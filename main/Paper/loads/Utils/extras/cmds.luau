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

-- Updated Animations: Smoother, more dynamic easing styles
local fastTween = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local slickTween = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local bounceTween = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

-- Main Container (Deep black theme)
local MainPanel = Instance.new("Frame")
MainPanel.Parent = ScreenGui
MainPanel.Size = UDim2.new(0, 540, 0, 360)
MainPanel.Position = UDim2.new(0.5, -270, 0.5, -180)
MainPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainPanel.ClipsDescendants = true
MainPanel.Active = true
MainPanel.BorderSizePixel = 0

local PanelCorner = Instance.new("UICorner", MainPanel)
PanelCorner.CornerRadius = UDim.new(0, 8)

local PanelStroke = Instance.new("UIStroke", MainPanel)
PanelStroke.Color = Color3.fromRGB(35, 35, 35)
PanelStroke.Thickness = 1
PanelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Dragging logic
local TopBarDrag = Instance.new("TextButton", MainPanel)
TopBarDrag.Size = UDim2.new(1, -70, 0, 40) 
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
TitleLabel.Size = UDim2.new(0, 200, 0, 40)
TitleLabel.Position = UDim2.new(0, 16, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "PAPER // COMMANDS"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 12
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 2

-- Controls (Top Right)
local ControlsFrame = Instance.new("Frame", MainPanel)
ControlsFrame.Size = UDim2.new(0, 70, 0, 40)
ControlsFrame.Position = UDim2.new(1, -70, 0, 0)
ControlsFrame.BackgroundTransparency = 1
ControlsFrame.ZIndex = 10

local MinBtn = Instance.new("ImageButton", ControlsFrame)
MinBtn.Size = UDim2.new(0, 14, 0, 14)
MinBtn.Position = UDim2.new(0, 15, 0.5, 0)
MinBtn.AnchorPoint = Vector2.new(0, 0.5)
MinBtn.BackgroundTransparency = 1
MinBtn.Image = "rbxassetid://82235228007110"
MinBtn.ImageColor3 = Color3.fromRGB(120, 120, 120)

local CloseBtn = Instance.new("ImageButton", ControlsFrame)
CloseBtn.Size = UDim2.new(0, 14, 0, 14)
CloseBtn.Position = UDim2.new(0, 40, 0.5, 0)
CloseBtn.AnchorPoint = Vector2.new(0, 0.5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Image = "rbxassetid://10152135063"
CloseBtn.ImageColor3 = Color3.fromRGB(120, 120, 120)

MinBtn.MouseEnter:Connect(function() TweenService:Create(MinBtn, fastTween, {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play() end)
MinBtn.MouseLeave:Connect(function() TweenService:Create(MinBtn, fastTween, {ImageColor3 = Color3.fromRGB(120, 120, 120)}):Play() end)

CloseBtn.MouseEnter:Connect(function() TweenService:Create(CloseBtn, fastTween, {ImageColor3 = Color3.fromRGB(255, 75, 75)}):Play() end)
CloseBtn.MouseLeave:Connect(function() TweenService:Create(CloseBtn, fastTween, {ImageColor3 = Color3.fromRGB(120, 120, 120)}):Play() end)

-- Content Area
local ContentGroup = Instance.new("Frame", MainPanel)
ContentGroup.Size = UDim2.new(1, 0, 1, -40)
ContentGroup.Position = UDim2.new(0, 0, 0, 40)
ContentGroup.BackgroundTransparency = 1
ContentGroup.BorderSizePixel = 0

-- Left Panel (Card layout for unique style)
local LeftCard = Instance.new("Frame", ContentGroup)
LeftCard.Size = UDim2.new(0, 200, 1, -16)
LeftCard.Position = UDim2.new(0, 16, 0, 0)
LeftCard.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
local LeftCorner = Instance.new("UICorner", LeftCard)
LeftCorner.CornerRadius = UDim.new(0, 6)
local LeftStroke = Instance.new("UIStroke", LeftCard)
LeftStroke.Color = Color3.fromRGB(30, 30, 30)
LeftStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Search Bar
local SearchBar = Instance.new("TextBox", LeftCard)
SearchBar.Size = UDim2.new(1, -16, 0, 32)
SearchBar.Position = UDim2.new(0, 8, 0, 8)
SearchBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
SearchBar.TextColor3 = Color3.fromRGB(220, 220, 220)
SearchBar.PlaceholderText = "Search commands..."
SearchBar.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
SearchBar.Font = Enum.Font.Gotham
SearchBar.TextSize = 12
SearchBar.TextXAlignment = Enum.TextXAlignment.Left
SearchBar.ClearTextOnFocus = false

local SearchCorner = Instance.new("UICorner", SearchBar)
SearchCorner.CornerRadius = UDim.new(0, 4)
local SearchStroke = Instance.new("UIStroke", SearchBar)
SearchStroke.Color = Color3.fromRGB(40, 40, 40)
SearchStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border -- CRITICAL FIX: Outer stroke
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
local CmdListScroll = Instance.new("ScrollingFrame", LeftCard)
CmdListScroll.Size = UDim2.new(1, -16, 1, -56)
CmdListScroll.Position = UDim2.new(0, 8, 0, 48)
CmdListScroll.BackgroundTransparency = 1
CmdListScroll.BorderSizePixel = 0
CmdListScroll.ScrollBarThickness = 0 -- CRITICAL FIX: Transparent Scrollbar

local ListLayout = Instance.new("UIListLayout", CmdListScroll)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 4)

ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	CmdListScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end)

-- Right Panel (Card layout)
local RightCard = Instance.new("Frame", ContentGroup)
RightCard.Size = UDim2.new(1, -240, 1, -16)
RightCard.Position = UDim2.new(0, 224, 0, 0)
RightCard.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
local RightCorner = Instance.new("UICorner", RightCard)
RightCorner.CornerRadius = UDim.new(0, 6)
local RightStroke = Instance.new("UIStroke", RightCard)
RightStroke.Color = Color3.fromRGB(30, 30, 30)
RightStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- CanvasGroup for fading transition effect
local RightFader = Instance.new("CanvasGroup", RightCard)
RightFader.Size = UDim2.new(1, 0, 1, 0)
RightFader.BackgroundTransparency = 1

local InfoTitle = Instance.new("TextLabel", RightFader)
InfoTitle.Size = UDim2.new(1, -40, 0, 30)
InfoTitle.Position = UDim2.new(0, 20, 0, 20)
InfoTitle.BackgroundTransparency = 1
InfoTitle.Text = "SELECT COMMAND"
InfoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoTitle.Font = Enum.Font.GothamBold
InfoTitle.TextSize = 18
InfoTitle.TextXAlignment = Enum.TextXAlignment.Left

local TitleUnderline = Instance.new("Frame", InfoTitle)
TitleUnderline.Size = UDim2.new(0, 30, 0, 2)
TitleUnderline.Position = UDim2.new(0, 0, 1, 0)
TitleUnderline.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
TitleUnderline.BorderSizePixel = 0

local InfoDesc = Instance.new("TextLabel", RightFader)
InfoDesc.Size = UDim2.new(1, -40, 0, 60)
InfoDesc.Position = UDim2.new(0, 20, 0, 65)
InfoDesc.BackgroundTransparency = 1
InfoDesc.Text = "Browse the list on the left to view command details, arguments, and usage."
InfoDesc.TextColor3 = Color3.fromRGB(160, 160, 160)
InfoDesc.Font = Enum.Font.Gotham
InfoDesc.TextSize = 13
InfoDesc.TextWrapped = true
InfoDesc.TextYAlignment = Enum.TextYAlignment.Top
InfoDesc.TextXAlignment = Enum.TextXAlignment.Left

local InfoAliases = Instance.new("TextLabel", RightFader)
InfoAliases.Size = UDim2.new(1, -40, 0, 20)
InfoAliases.Position = UDim2.new(0, 20, 0, 135)
InfoAliases.BackgroundTransparency = 1
InfoAliases.Text = ""
InfoAliases.TextColor3 = Color3.fromRGB(130, 130, 130)
InfoAliases.Font = Enum.Font.Gotham
InfoAliases.TextSize = 12
InfoAliases.TextXAlignment = Enum.TextXAlignment.Left

local InfoUsage = Instance.new("TextLabel", RightFader)
InfoUsage.Size = UDim2.new(1, -40, 0, 20)
InfoUsage.Position = UDim2.new(0, 20, 0, 160)
InfoUsage.BackgroundTransparency = 1
InfoUsage.Text = ""
InfoUsage.TextColor3 = Color3.fromRGB(255, 75, 75) -- CRITICAL FIX: Red instead of green
InfoUsage.Font = Enum.Font.GothamMedium
InfoUsage.TextSize = 13
InfoUsage.TextXAlignment = Enum.TextXAlignment.Left

local currentSelectedBtn = nil

local function UpdateRightPanel(cmd)
	if not cmd then return end
	
	-- Transition Out
	TweenService:Create(RightFader, fastTween, {GroupTransparency = 1}):Play()
	TweenService:Create(TitleUnderline, fastTween, {Size = UDim2.new(0, 0, 0, 2)}):Play()
	task.wait(0.15)
	
	-- Update Content
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
	
	-- Transition In
	TweenService:Create(RightFader, slickTween, {GroupTransparency = 0}):Play()
	TweenService:Create(TitleUnderline, bounceTween, {Size = UDim2.new(0, 30, 0, 2)}):Play()
end

table.sort(inputRegistry, function(a, b) return a.Name < b.Name end)

for _, cmd in ipairs(inputRegistry) do
	local btn = Instance.new("TextButton", CmdListScroll)
	btn.Name = cmd.Name
	btn.Size = UDim2.new(1, 0, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
	btn.BackgroundTransparency = 1
	btn.BorderSizePixel = 0
	btn.Text = "  " .. cmd.Name
	btn.TextColor3 = Color3.fromRGB(180, 180, 180)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 12
	btn.TextXAlignment = Enum.TextXAlignment.Left
	
	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0, 4)
	
	-- Animated Selection Indicator
	local Indicator = Instance.new("Frame", btn)
	Indicator.Size = UDim2.new(0, 3, 0, 0)
	Indicator.Position = UDim2.new(0, 0, 0.5, 0)
	Indicator.AnchorPoint = Vector2.new(0, 0.5)
	Indicator.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
	Indicator.BorderSizePixel = 0
	local IndCorner = Instance.new("UICorner", Indicator)
	IndCorner.CornerRadius = UDim.new(1, 0)
	
	btn.MouseEnter:Connect(function()
		if currentSelectedBtn ~= btn then
			TweenService:Create(btn, fastTween, {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(22, 22, 22), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		end
	end)
	
	btn.MouseLeave:Connect(function()
		if currentSelectedBtn ~= btn then
			TweenService:Create(btn, fastTween, {BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(16, 16, 16), TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
		end
	end)
	
	btn.MouseButton1Click:Connect(function()
		if currentSelectedBtn == btn then return end
		
		if currentSelectedBtn then
			TweenService:Create(currentSelectedBtn, fastTween, {BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(16, 16, 16), TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
			TweenService:Create(currentSelectedBtn:FindFirstChild("Frame"), fastTween, {Size = UDim2.new(0, 3, 0, 0)}):Play()
		end
		
		currentSelectedBtn = btn
		TweenService:Create(btn, fastTween, {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(26, 26, 26), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		TweenService:Create(Indicator, bounceTween, {Size = UDim2.new(0, 3, 0, 16)}):Play()
		
		UpdateRightPanel(cmd)
	end)
end

if #inputRegistry > 0 then
	-- Trigger first selection without user input visually
	local firstBtn = CmdListScroll:GetChildren()[2] -- index 1 is UIListLayout
	if firstBtn and firstBtn:IsA("TextButton") then
		currentSelectedBtn = firstBtn
		firstBtn.BackgroundTransparency = 0
		firstBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
		firstBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		firstBtn:FindFirstChild("Frame").Size = UDim2.new(0, 3, 0, 16)
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
local preMinSize = MainPanel.Size

MinBtn.MouseButton1Click:Connect(function()
	if isMinimized then
		isMinimized = false
		MinBtn.Image = "rbxassetid://82235228007110"
		ContentGroup.Visible = true
		TweenService:Create(MainPanel, slickTween, {Size = preMinSize}):Play()
	else
		isMinimized = true
		preMinSize = MainPanel.Size
		MinBtn.Image = "rbxassetid://102684448472066"
		ContentGroup.Visible = false
		TweenService:Create(MainPanel, slickTween, {Size = UDim2.new(0, preMinSize.X.Offset, 0, 40)}):Play()
	end
end)

local function PlayCloseAnimation()
	isMinimized = true
	
	-- Smooth collapse and fade out
	local collapseTween = TweenService:Create(MainPanel, slickTween, {
		Size = UDim2.new(0, 160, 0, 40),
		BackgroundTransparency = 1
	})
	TweenService:Create(PanelStroke, fastTween, {Transparency = 1}):Play()
	
	for _, v in ipairs(MainPanel:GetDescendants()) do
		if v:IsA("TextLabel") or v:IsA("TextBox") or v:IsA("TextButton") then
			TweenService:Create(v, fastTween, {TextTransparency = 1}):Play()
		elseif v:IsA("UIStroke") then
			TweenService:Create(v, fastTween, {Transparency = 1}):Play()
		elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
			TweenService:Create(v, fastTween, {ImageTransparency = 1}):Play()
		elseif v:IsA("Frame") and v ~= MainPanel then
			TweenService:Create(v, fastTween, {BackgroundTransparency = 1}):Play()
		end
	end
	
	collapseTween:Play()
	task.delay(0.5, function() ScreenGui:Destroy() end)
end

CloseBtn.MouseButton1Click:Connect(PlayCloseAnimation)
