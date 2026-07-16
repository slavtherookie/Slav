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

local fastTween = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local slideTween = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local MainPanel = Instance.new("CanvasGroup")
MainPanel.Parent = ScreenGui
MainPanel.Size = UDim2.new(0, 500, 0, 350)
MainPanel.Position = UDim2.new(0.5, -250, 0.5, -175)
MainPanel.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
MainPanel.ClipsDescendants = true
MainPanel.Active = true
MainPanel.BorderSizePixel = 0
MainPanel.GroupTransparency = 1

local PanelScale = Instance.new("UIScale", MainPanel)
PanelScale.Scale = 0.9

local PanelCorner = Instance.new("UICorner", MainPanel)
PanelCorner.CornerRadius = UDim.new(0, 3)

local PanelStroke = Instance.new("UIStroke", MainPanel)
PanelStroke.Color = Color3.fromRGB(45, 45, 45)
PanelStroke.Thickness = 1

local TopBarDrag = Instance.new("TextButton", MainPanel)
TopBarDrag.Size = UDim2.new(1, -60, 0, 35) 
TopBarDrag.Position = UDim2.new(0, 0, 0, 0)
TopBarDrag.BackgroundTransparency = 1
TopBarDrag.Text = ""
TopBarDrag.ZIndex = 1

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

local ContentGroup = Instance.new("Frame", MainPanel)
ContentGroup.Size = UDim2.new(1, 0, 1, -35)
ContentGroup.Position = UDim2.new(0, 0, 0, 35)
ContentGroup.BackgroundTransparency = 1
ContentGroup.BorderSizePixel = 0

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
MinBtn.ZIndex = 10

local CloseBtn = Instance.new("ImageButton", ControlsFrame)
CloseBtn.Size = UDim2.new(0, 16, 0, 16)
CloseBtn.Position = UDim2.new(0, 36, 0.5, 0)
CloseBtn.AnchorPoint = Vector2.new(0, 0.5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Image = "rbxassetid://10152135063"
CloseBtn.ImageColor3 = Color3.fromRGB(150, 150, 150)
CloseBtn.ZIndex = 10

MinBtn.MouseEnter:Connect(function() TweenService:Create(MinBtn, fastTween, {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play() end)
MinBtn.MouseLeave:Connect(function() TweenService:Create(MinBtn, fastTween, {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play() end)
CloseBtn.MouseEnter:Connect(function() TweenService:Create(CloseBtn, fastTween, {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play() end)
CloseBtn.MouseLeave:Connect(function() TweenService:Create(CloseBtn, fastTween, {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play() end)

local isMinimized = false
local preMinSize = MainPanel.Size

MinBtn.MouseButton1Click:Connect(function()
    if isMinimized then
        isMinimized = false
        MinBtn.Image = "rbxassetid://82235228007110"
        ContentGroup.Visible = true
        TweenService:Create(MainPanel, slideTween, {Size = preMinSize}):Play()
    else
        isMinimized = true
        preMinSize = MainPanel.Size
        MinBtn.Image = "rbxassetid://102684448472066"
        ContentGroup.Visible = false
        TweenService:Create(MainPanel, slideTween, {Size = UDim2.new(0, preMinSize.X.Offset, 0, 35)}):Play()
    end
end)

local function PlayCloseAnimation()
    local fadeTween = TweenService:Create(MainPanel, slideTween, {GroupTransparency = 1})
    local scaleTween = TweenService:Create(PanelScale, slideTween, {Scale = 0.9})
    fadeTween:Play()
    scaleTween:Play()
    task.delay(0.4, function() ScreenGui:Destroy() end)
end

CloseBtn.MouseButton1Click:Connect(PlayCloseAnimation)

local TitleLabel = Instance.new("TextLabel", MainPanel)
TitleLabel.Size = UDim2.new(1, -84, 0, 35)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Commands"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
TitleLabel.Font = Enum.Font.GothamMedium
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 2

local LeftPanel = Instance.new("Frame", ContentGroup)
LeftPanel.Size = UDim2.new(0, 180, 1, 0)
LeftPanel.Position = UDim2.new(0, 0, 0, 0)
LeftPanel.BackgroundTransparency = 1

local SearchBar = Instance.new("TextBox", LeftPanel)
SearchBar.Size = UDim2.new(1, -20, 0, 30)
SearchBar.Position = UDim2.new(0, 10, 0, 10)
SearchBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SearchBar.TextColor3 = Color3.fromRGB(220, 220, 220)
SearchBar.Text = ""
SearchBar.PlaceholderText = "Search..."
SearchBar.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
SearchBar.Font = Enum.Font.Gotham
SearchBar.TextSize = 12
SearchBar.TextXAlignment = Enum.TextXAlignment.Left
SearchBar.ClearTextOnFocus = false

local SearchCorner = Instance.new("UICorner", SearchBar)
SearchCorner.CornerRadius = UDim.new(0, 3)
local SearchStroke = Instance.new("UIStroke", SearchBar)
SearchStroke.Color = Color3.fromRGB(45, 45, 45)
local SearchPad = Instance.new("UIPadding", SearchBar)
SearchPad.PaddingLeft = UDim.new(0, 8)
SearchPad.PaddingRight = UDim.new(0, 8)

local CmdListScroll = Instance.new("ScrollingFrame", LeftPanel)
CmdListScroll.Size = UDim2.new(1, -20, 1, -55)
CmdListScroll.Position = UDim2.new(0, 10, 0, 45)
CmdListScroll.BackgroundTransparency = 1
CmdListScroll.BorderSizePixel = 0
CmdListScroll.ScrollBarThickness = 2
CmdListScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)

local ListLayout = Instance.new("UIListLayout", CmdListScroll)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 4)

ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    CmdListScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end)

local Separator = Instance.new("Frame", ContentGroup)
Separator.Size = UDim2.new(0, 1, 1, -20)
Separator.Position = UDim2.new(0, 185, 0, 10)
Separator.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Separator.BorderSizePixel = 0

local RightPanel = Instance.new("Frame", ContentGroup)
RightPanel.Size = UDim2.new(1, -195, 1, 0)
RightPanel.Position = UDim2.new(0, 195, 0, 0)
RightPanel.BackgroundTransparency = 1

local InfoTitle = Instance.new("TextLabel", RightPanel)
InfoTitle.Size = UDim2.new(1, -30, 0, 30)
InfoTitle.Position = UDim2.new(0, 15, 0, 10)
InfoTitle.BackgroundTransparency = 1
InfoTitle.Text = "SELECT A COMMAND"
InfoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoTitle.Font = Enum.Font.GothamBold
InfoTitle.TextSize = 16
InfoTitle.TextXAlignment = Enum.TextXAlignment.Left

local InfoDesc = Instance.new("TextLabel", RightPanel)
InfoDesc.Size = UDim2.new(1, -30, 0, 40)
InfoDesc.Position = UDim2.new(0, 15, 0, 40)
InfoDesc.BackgroundTransparency = 1
InfoDesc.Text = "Hover or click a command from the list on the left to see its details."
InfoDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
InfoDesc.Font = Enum.Font.Gotham
InfoDesc.TextSize = 13
InfoDesc.TextWrapped = true
InfoDesc.TextYAlignment = Enum.TextYAlignment.Top
InfoDesc.TextXAlignment = Enum.TextXAlignment.Left

local InfoAliases = Instance.new("TextLabel", RightPanel)
InfoAliases.Size = UDim2.new(1, -30, 0, 20)
InfoAliases.Position = UDim2.new(0, 15, 0, 85)
InfoAliases.BackgroundTransparency = 1
InfoAliases.Text = ""
InfoAliases.TextColor3 = Color3.fromRGB(140, 140, 140)
InfoAliases.Font = Enum.Font.Gotham
InfoAliases.TextSize = 12
InfoAliases.TextXAlignment = Enum.TextXAlignment.Left

local InfoUsage = Instance.new("TextLabel", RightPanel)
InfoUsage.Size = UDim2.new(1, -30, 0, 20)
InfoUsage.Position = UDim2.new(0, 15, 0, 110)
InfoUsage.BackgroundTransparency = 1
InfoUsage.Text = ""
InfoUsage.TextColor3 = Color3.fromRGB(150, 200, 150)
InfoUsage.Font = Enum.Font.GothamMedium
InfoUsage.TextSize = 12
InfoUsage.TextXAlignment = Enum.TextXAlignment.Left

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
    btn.Size = UDim2.new(1, -6, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.BorderSizePixel = 0
    btn.Text = "  " .. cmd.Name
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 3)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, fastTween, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, fastTween, {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        UpdateRightPanel(cmd)
    end)
end

if #inputRegistry > 0 then
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

TweenService:Create(MainPanel, slideTween, {GroupTransparency = 0}):Play()
TweenService:Create(PanelScale, slideTween, {Scale = 1}):Play()
