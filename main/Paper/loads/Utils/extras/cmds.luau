local inputRegistry = ... or {}

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local guiName = "PaperCmdsGui"
local targetGui = pcall(function() return CoreGui.Name end) and CoreGui or Players.LocalPlayer:WaitForChild("PlayerGui")

if targetGui:FindFirstChild(guiName) then
	targetGui[guiName]:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = targetGui

local smoothTween = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local fastTween = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local MainPanel = Instance.new("Frame")
MainPanel.Parent = ScreenGui
MainPanel.Size = UDim2.new(0, 500, 0, 0) -- Starts at 0 height for entrance animation
MainPanel.Position = UDim2.new(0.5, -250, 0.5, -175)
MainPanel.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
MainPanel.ClipsDescendants = true
MainPanel.Active = true
MainPanel.BorderSizePixel = 0

local PanelCorner = Instance.new("UICorner", MainPanel)
PanelCorner.CornerRadius = UDim.new(0, 4) -- Sharper edges

local PanelStroke = Instance.new("UIStroke", MainPanel)
PanelStroke.Color = Color3.fromRGB(45, 45, 45)
PanelStroke.Thickness = 1
PanelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Top Bar / Dragging
local TopBarDrag = Instance.new("TextButton", MainPanel)
TopBarDrag.Size = UDim2.new(1, -60, 0, 35) 
TopBarDrag.Position = UDim2.new(0, 0, 0, 0)
TopBarDrag.BackgroundTransparency = 1
TopBarDrag.Text = ""
TopBarDrag.ZIndex = 10

local dragging, dragInput, dragStart, startPos
TopBarDrag.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainPanel.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

TopBarDrag.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		MainPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Title
local TitleLabel = Instance.new("TextLabel", MainPanel)
TitleLabel.Size = UDim2.new(0, 200, 0, 35)
TitleLabel.Position = UDim2.new(0, 14, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Paper Client"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
TitleLabel.Font = Enum.Font.GothamMedium
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 2

-- Controls (Top Right)
local ControlsFrame = Instance.new("Frame", MainPanel)
ControlsFrame.Size = UDim2.new(0, 60, 0, 35)
ControlsFrame.Position = UDim2.new(1, -60, 0, 0)
ControlsFrame.BackgroundTransparency = 1
ControlsFrame.ZIndex = 10

local MinBtn = Instance.new("ImageButton", ControlsFrame)
MinBtn.Size = UDim2.new(0, 16, 0, 16)
MinBtn.Position = UDim2.new(0, 12, 0.5, 0)
MinBtn.AnchorPoint = Vector2.new(0, 0.5)
MinBtn.BackgroundTransparency = 1
MinBtn.Image = "rbxassetid://82235228007110"
MinBtn.ImageColor3 = Color3.fromRGB(150, 150, 150)

local CloseBtn = Instance.new("ImageButton", ControlsFrame)
CloseBtn.Size = UDim2.new(0, 16, 0, 16)
CloseBtn.Position = UDim2.new(0, 36, 0.5, 0)
CloseBtn.AnchorPoint = Vector2.new(0, 0.5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Image = "rbxassetid://10152135063"
CloseBtn.ImageColor3 = Color3.fromRGB(150, 150, 150)

MinBtn.MouseEnter:Connect(function() TweenService:Create(MinBtn, fastTween, {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play() end)
MinBtn.MouseLeave:Connect(function() TweenService:Create(MinBtn, fastTween, {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play() end)

CloseBtn.MouseEnter:Connect(function() TweenService:Create(CloseBtn, fastTween, {ImageColor3 = Color3.fromRGB(255, 75, 75)}):Play() end)
CloseBtn.MouseLeave:Connect(function() TweenService:Create(CloseBtn, fastTween, {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play() end)

-- Content Area
local ContentGroup = Instance.new("Frame", MainPanel)
ContentGroup.Size = UDim2.new(1, 0, 1, -35)
ContentGroup.Position = UDim2.new(0, 0, 0, 35)
ContentGroup.BackgroundTransparency = 1
ContentGroup.BorderSizePixel = 0

-- Left Panel
local LeftPanel = Instance.new("Frame", ContentGroup)
LeftPanel.Size = UDim2.new(0, 190, 1, 0)
LeftPanel.Position = UDim2.new(0, 0, 0, 0)
LeftPanel.BackgroundTransparency = 1

local SearchBar = Instance.new("TextBox", LeftPanel)
SearchBar.Size = UDim2.new(1, -24, 0, 28)
SearchBar.Position = UDim2.new(0, 12, 0, 4)
SearchBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
SearchBar.TextColor3 = Color3.fromRGB(220, 220, 220)
SearchBar.PlaceholderText = "Search..."
SearchBar.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
SearchBar.Font = Enum.Font.Gotham
SearchBar.TextSize = 12
SearchBar.Text = "" -- Ensuring it is cleared
SearchBar.TextXAlignment = Enum.TextXAlignment.Left
SearchBar.ClearTextOnFocus = false

local SearchCorner = Instance.new("UICorner", SearchBar)
SearchCorner.CornerRadius = UDim.new(0, 3)
local SearchStroke = Instance.new("UIStroke", SearchBar)
SearchStroke.Color = Color3.fromRGB(40, 40, 40)
SearchStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border -- Outer stroke
local SearchPad = Instance.new("UIPadding", SearchBar)
SearchPad.PaddingLeft = UDim.new(0, 10)
SearchPad.PaddingRight = UDim.new(0, 10)

SearchBar.Focused:Connect(function()
	TweenService:Create(SearchStroke, fastTween, {Color = Color3.fromRGB(70, 70, 70)}):Play()
end)
SearchBar.FocusLost:Connect(function()
	TweenService:Create(SearchStroke, fastTween, {Color = Color3.fromRGB(40, 40, 40)}):Play()
end)

-- Scroll List
local CmdListScroll = Instance.new("ScrollingFrame", LeftPanel)
CmdListScroll.Size = UDim2.new(1, -24, 1, -44)
CmdListScroll.Position = UDim2.new(0, 12, 0, 40)
CmdListScroll.BackgroundTransparency = 1
CmdListScroll.BorderSizePixel = 0
CmdListScroll.ScrollBarThickness = 0 -- Transparent scrollbar

local ListLayout = Instance.new("UIListLayout", CmdListScroll)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 2)

ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	CmdListScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end)

-- Separator Line
local Separator = Instance.new("Frame", ContentGroup)
Separator.Size = UDim2.new(0, 1, 1, -24)
Separator.Position = UDim2.new(0, 190, 0, 12)
Separator.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Separator.BorderSizePixel = 0

-- Right Panel
local RightPanel = Instance.new("Frame", ContentGroup)
RightPanel.Size = UDim2.new(1, -191, 1, 0)
RightPanel.Position = UDim2.new(0, 191, 0, 0)
RightPanel.BackgroundTransparency = 1

local InfoTitle = Instance.new("TextLabel", RightPanel)
InfoTitle.Size = UDim2.new(1, -40, 0, 30)
InfoTitle.Position = UDim2.new(0, 20, 0, 16)
InfoTitle.BackgroundTransparency = 1
InfoTitle.Text = "Select a Command"
InfoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoTitle.Font = Enum.Font.GothamBold
InfoTitle.TextSize = 16
InfoTitle.TextXAlignment = Enum.TextXAlignment.Left

local InfoDesc = Instance.new("TextLabel", RightPanel)
InfoDesc.Size = UDim2.new(1, -40, 0, 60)
InfoDesc.Position = UDim2.new(0, 20, 0, 50)
InfoDesc.BackgroundTransparency = 1
InfoDesc.Text = ""
InfoDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
InfoDesc.Font = Enum.Font.Gotham
InfoDesc.TextSize = 12
InfoDesc.TextWrapped = true
InfoDesc.TextYAlignment = Enum.TextYAlignment.Top
InfoDesc.TextXAlignment = Enum.TextXAlignment.Left

local InfoAliases = Instance.new("TextLabel", RightPanel)
InfoAliases.Size = UDim2.new(1, -40, 0, 20)
InfoAliases.Position = UDim2.new(0, 20, 0, 120)
InfoAliases.BackgroundTransparency = 1
InfoAliases.Text = ""
InfoAliases.TextColor3 = Color3.fromRGB(110, 110, 110)
InfoAliases.Font = Enum.Font.Gotham
InfoAliases.TextSize = 12
InfoAliases.TextXAlignment = Enum.TextXAlignment.Left

local InfoUsage = Instance.new("TextLabel", RightPanel)
InfoUsage.Size = UDim2.new(1, -40, 0, 20)
InfoUsage.Position = UDim2.new(0, 20, 0, 145)
InfoUsage.BackgroundTransparency = 1
InfoUsage.Text = ""
InfoUsage.TextColor3 = Color3.fromRGB(255, 75, 75) -- Red usage text
InfoUsage.Font = Enum.Font.GothamMedium
InfoUsage.TextSize = 12
InfoUsage.TextXAlignment = Enum.TextXAlignment.Left

local currentSelectedBtn = nil

local function UpdateRightPanel(cmd)
	if not cmd then return end
	
	InfoTitle.Text = string.upper(cmd.Name)
	InfoDesc.Text = cmd.Description or "No description provided."
	
	local aliases = "None"
	if cmd.Aliases and #cmd.Aliases > 0 then
		aliases = table.concat(cmd.Aliases, ", ")
	end
	InfoAliases.Text = "Aliases: " .. aliases
	
	local usage = cmd.Name
	if cmd.ArgHint and cmd.ArgHint ~= "" then
		usage = usage .. " " .. cmd.ArgHint
	end
	InfoUsage.Text = "Usage: " .. usage
end

table.sort(inputRegistry, function(a, b) return a.Name < b.Name end)

for _, cmd in ipairs(inputRegistry) do
	local btn = Instance.new("TextButton", CmdListScroll)
	btn.Name = cmd.Name
	btn.Size = UDim2.new(1, 0, 0, 26)
	btn.BackgroundTransparency = 1
	btn.BorderSizePixel = 0
	btn.Text = "  " .. cmd.Name
	btn.TextColor3 = Color3.fromRGB(160, 160, 160)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 12
	btn.TextXAlignment = Enum.TextXAlignment.Left
	
	local Indicator = Instance.new("Frame", btn)
	Indicator.Size = UDim2.new(0, 2, 0, 0)
	Indicator.Position = UDim2.new(0, 0, 0.5, 0)
	Indicator.AnchorPoint = Vector2.new(0, 0.5)
	Indicator.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
	Indicator.BorderSizePixel = 0
	
	btn.MouseEnter:Connect(function()
		if currentSelectedBtn ~= btn then
			TweenService:Create(btn, fastTween, {TextColor3 = Color3.fromRGB(220, 220, 220)}):Play()
		end
	end)
	
	btn.MouseLeave:Connect(function()
		if currentSelectedBtn ~= btn then
			TweenService:Create(btn, fastTween, {TextColor3 = Color3.fromRGB(160, 160, 160)}):Play()
		end
	end)
	
	btn.MouseButton1Click:Connect(function()
		if currentSelectedBtn == btn then return end
		
		if currentSelectedBtn then
			TweenService:Create(currentSelectedBtn, fastTween, {TextColor3 = Color3.fromRGB(160, 160, 160)}):Play()
			TweenService:Create(currentSelectedBtn:FindFirstChild("Frame"), fastTween, {Size = UDim2.new(0, 2, 0, 0)}):Play()
		end
		
		currentSelectedBtn = btn
		TweenService:Create(btn, fastTween, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		TweenService:Create(Indicator, fastTween, {Size = UDim2.new(0, 2, 0, 14)}):Play()
		
		UpdateRightPanel(cmd)
	end)
end

if #inputRegistry > 0 then
	local firstBtn = CmdListScroll:GetChildren()[2]
	if firstBtn and firstBtn:IsA("TextButton") then
		currentSelectedBtn = firstBtn
		firstBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		firstBtn:FindFirstChild("Frame").Size = UDim2.new(0, 2, 0, 14)
	end
	UpdateRightPanel(inputRegistry[1])
end

SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
	local query = string.lower(SearchBar.Text)
	for _, btn in ipairs(CmdListScroll:GetChildren()) do
		if btn:IsA("TextButton") then
			if query == "" or string.find(string.lower(btn.Name), query) then
				btn.Visible = true
			else
				btn.Visible = false
			end
		end
	end
end)

local isMinimized = false
local isMinimizingAnim = false
local preMinSize = UDim2.new(0, 500, 0, 350)

MinBtn.MouseButton1Click:Connect(function()
	if isMinimizingAnim then return end
	isMinimizingAnim = true
	
	if isMinimized then
		isMinimized = false
		MinBtn.Image = "rbxassetid://82235228007110"
		local t = TweenService:Create(MainPanel, smoothTween, {Size = preMinSize})
		t:Play()
		t.Completed:Connect(function() isMinimizingAnim = false end)
	else
		isMinimized = true
		MinBtn.Image = "rbxassetid://102684448472066"
		local t = TweenService:Create(MainPanel, smoothTween, {Size = UDim2.new(0, preMinSize.X.Offset, 0, 35)})
		t:Play()
		t.Completed:Connect(function() isMinimizingAnim = false end)
	end
end)

local isClosing = false
local function PlayCloseAnimation()
	if isClosing then return end
	isClosing = true
	
	-- Matches the original paper notification close logic (collapsing size to 0 smoothly)
	local closeTween = TweenService:Create(MainPanel, smoothTween, {Size = UDim2.new(0, 500, 0, 0)})
	TweenService:Create(PanelStroke, fastTween, {Transparency = 1}):Play()
	
	for _, v in ipairs(MainPanel:GetDescendants()) do
		if v:IsA("TextLabel") or v:IsA("TextBox") or v:IsA("TextButton") then
			TweenService:Create(v, fastTween, {TextTransparency = 1}):Play()
		elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
			TweenService:Create(v, fastTween, {ImageTransparency = 1}):Play()
		elseif v:IsA("Frame") and v ~= MainPanel then
			TweenService:Create(v, fastTween, {BackgroundTransparency = 1}):Play()
		elseif v:IsA("UIStroke") then
			TweenService:Create(v, fastTween, {Transparency = 1}):Play()
		end
	end
	
	closeTween:Play()
	task.delay(0.4, function() ScreenGui:Destroy() end)
end

CloseBtn.MouseButton1Click:Connect(PlayCloseAnimation)
TweenService:Create(MainPanel, smoothTween, {Size = preMinSize}):Play()
