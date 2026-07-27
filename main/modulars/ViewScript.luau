local sspdo = loadstring(game:HttpGet("https://raw.githubusercontent.com/slavtherookie/Slav/refs/heads/main/PublicModules/sspdo.luau"))()
sspdo.Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/slavtherookie/Slav/refs/heads/main/Public/Themes/PaperDark.luau"))()
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
	actionBar.Size = UDim2.new(1, 0, 0, 20)
	actionBar.BackgroundTransparency = 1
	actionBar.Parent = contentPane

	local function createButton(name, text, xPos)
		local btn = Instance.new("TextButton")
		btn.Name = name
		btn.Size = UDim2.new(0.25, 0, 1, 0)
		btn.Position = UDim2.new(xPos, 0, 0, 0)
		btn.BackgroundTransparency = 1
		btn.TextColor3 = sspdo.Theme.Text or Color3.new(1, 1, 1)
		btn.Text = text
		btn.Font = Enum.Font.SourceSans
		btn.TextSize = 14
		btn.Parent = actionBar
		return btn
	end

	local btnCopy = createButton("CopyBtn", "Copy to Clipboard", 0)
	local btnSave = createButton("SaveBtn", "Save to File", 0.25)
	local btnExec = createButton("ExecuteBtn", "Execute Code", 0.5)
	local btnClear = createButton("ClearBtn", "Clear", 0.75)

	local editorContainer = Instance.new("Frame")
	editorContainer.Name = "EditorContainer"
	editorContainer.Position = UDim2.new(0, 0, 0, 20)
	editorContainer.Size = UDim2.new(1, 0, 1, -20)
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
