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
	actionBar.Size = UDim2.new(1, 0, 0, 24)
	actionBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	actionBar.BorderSizePixel = 0
	actionBar.Parent = contentPane

	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Horizontal
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 0)
	listLayout.Parent = actionBar

	local function createButton(name, text, order)
		local btn = Instance.new("TextButton")
		btn.Name = name
		btn.LayoutOrder = order
		btn.Size = UDim2.new(0.25, 0, 1, 0)
		btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		btn.BorderSizePixel = 1
		btn.BorderColor3 = Color3.fromRGB(30, 30, 30)
		btn.TextColor3 = Color3.fromRGB(220, 220, 220)
		btn.Text = text
		btn.Font = Enum.Font.SourceSans
		btn.TextSize = 14
		btn.AutoButtonColor = false

		btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55) end)
		btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45) end)
		btn.MouseButton1Down:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35) end)
		btn.MouseButton1Up:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55) end)

		btn.Parent = actionBar
		return btn
	end

	local btnCopy = createButton("CopyBtn", "Copy to Clipboard", 1)
	local btnSave = createButton("SaveBtn", "Save to File", 2)
	local btnExec = createButton("ExecuteBtn", "Execute Code", 3)
	local btnClear = createButton("ClearBtn", "Clear", 4)

	local editorContainer = Instance.new("Frame")
	editorContainer.Name = "EditorContainer"
	editorContainer.Position = UDim2.new(0, 0, 0, 24)
	editorContainer.Size = UDim2.new(1, 0, 1, -24)
	editorContainer.BackgroundTransparency = 1 
	editorContainer.Parent = contentPane

	editor = LuaUEngine.new(editorContainer)
	editor:ImportTheme("https://raw.githubusercontent.com/slavtherookie/Slav/refs/heads/main/Public/Themes/PaperDark.luau")

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
		pcall(function()
			loadstring(editor.Text)()
		end)
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
				editor.Text = ""
			end
		else
			editor.Text = ""
		end
	end

	window:Show()
end

return ScriptViewer
