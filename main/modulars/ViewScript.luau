local sspdo = loadstring(game:HttpGet("https://raw.githubusercontent.com/slavtherookie/Slav/refs/heads/main/PublicModules/sspdo.luau"))()
local LuaUEngine = loadstring(game:HttpGet("https://raw.githubusercontent.com/slavtherookie/Slav/refs/heads/main/main/modulars/LuaUEngine.luau"))()

local ScriptViewer = {}
local window
local editor
local currentScript

function ScriptViewer.Init()
	window = sspdo.new("Script Viewer", 650, 450)
	ScriptViewer.Window = window

	local contentPane = window.GuiElems.Content

	local actionBar = Instance.new("Frame")
	actionBar.Name = "ActionBar"
	actionBar.Size = UDim2.new(1, 0, 0, 34)
	actionBar.BackgroundTransparency = 1
	actionBar.Parent = contentPane

	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Horizontal
	listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 8)
	listLayout.Parent = actionBar

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 8)
	padding.PaddingRight = UDim.new(0, 8)
	padding.Parent = actionBar

	local function createButton(name, text, width)
		local btn = Instance.new("TextButton")
		btn.Name = name
		btn.Size = UDim2.new(0, width, 0, 22)
		btn.BackgroundColor3 = sspdo.Theme.Button
		btn.TextColor3 = sspdo.Theme.Text
		btn.Text = text
		btn.Font = Enum.Font.SourceSansSemibold
		btn.TextSize = 14
		btn.AutoButtonColor = false

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 4)
		corner.Parent = btn

		btn.MouseEnter:Connect(function() btn.BackgroundColor3 = sspdo.Theme.ButtonHover end)
		btn.MouseLeave:Connect(function() btn.BackgroundColor3 = sspdo.Theme.Button end)
		btn.MouseButton1Down:Connect(function() btn.BackgroundColor3 = sspdo.Theme.ButtonPress end)
		btn.MouseButton1Up:Connect(function() btn.BackgroundColor3 = sspdo.Theme.ButtonHover end)

		btn.Parent = actionBar
		return btn
	end

	local btnCopy = createButton("CopyBtn", "Copy to Clipboard", 125)
	local btnSave = createButton("SaveBtn", "Save to File", 100)
	local btnExec = createButton("ExecuteBtn", "Execute Code", 100)
	local btnClear = createButton("ClearBtn", "Clear", 60)

	local editorContainer = Instance.new("Frame")
	editorContainer.Name = "EditorContainer"
	editorContainer.Position = UDim2.new(0, 0, 0, 34)
	editorContainer.Size = UDim2.new(1, 0, 1, -34)
	
	editorContainer.BackgroundTransparency = 1 
	editorContainer.Parent = contentPane

	editor = LuaUEngine.new(editorContainer)
	editor.BackgroundTransparency = 1 
	editor.ReadOnly = false 

	btnCopy.MouseButton1Click:Connect(function()
		if setclipboard then
			setclipboard(editor.Text)
		end
	end)

	btnSave.MouseButton1Click:Connect(function()
		if writefile then
			local filename = "ScriptViewer_" .. os.time() .. ".txt"
			if currentScript and currentScript.Name then
				filename = currentScript.Name .. "_" .. os.time() .. ".txt"
			end
			writefile(filename, editor.Text)
		end
	end)

	btnExec.MouseButton1Click:Connect(function()
		local success, err = pcall(function()
			loadstring(editor.Text)()
		end)
		if not success then
			warn("[ScriptViewer] Execution Error:", err)
		end
	end)

	btnClear.MouseButton1Click:Connect(function()
		editor.Text = ""
	end)
end

function ScriptViewer.ViewScript(scriptInstance, customSource)
	if not window then
		ScriptViewer.Init()
	end

	currentScript = scriptInstance
	local name = scriptInstance and scriptInstance.Name or "Script"
	window:SetTitle("Script Viewer - " .. name)

	if customSource then
		editor.Text = customSource
	else
		if decompile and typeof(scriptInstance) == "Instance" and scriptInstance:IsA("LuaSourceContainer") then
			local success, result = pcall(decompile, scriptInstance)
			if success and result then
				editor.Text = result
			else
				editor.Text = "-- Failed to decompile " .. name .. "\n-- " .. tostring(result)
			end
		else
			editor.Text = "-- [No source provided, and decompile is unavailable or object is not a script]\n-- Start typing here..."
		end
	end

	window:Show()
end

return ScriptViewer
