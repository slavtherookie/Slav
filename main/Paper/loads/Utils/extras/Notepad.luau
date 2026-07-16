local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local guiName = "PaperNotepadGui"
local targetGui = pcall(function() return CoreGui.Name end) and CoreGui or Players.LocalPlayer:WaitForChild("PlayerGui")

if targetGui:FindFirstChild(guiName) then
	targetGui[guiName]:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = targetGui

local fastTween = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local slideTween = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local Tooltip = Instance.new("TextLabel")
Tooltip.Parent = ScreenGui
Tooltip.Size = UDim2.new(0, 0, 0, 22)
Tooltip.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Tooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
Tooltip.Font = Enum.Font.GothamMedium
Tooltip.TextSize = 11
Tooltip.TextXAlignment = Enum.TextXAlignment.Left
Tooltip.TextTransparency = 1
Tooltip.BackgroundTransparency = 1
Tooltip.ZIndex = 100
Tooltip.AnchorPoint = Vector2.new(0, 1)
Tooltip.BorderSizePixel = 0

local TooltipPadding = Instance.new("UIPadding")
TooltipPadding.PaddingLeft = UDim.new(0, 8)
TooltipPadding.PaddingRight = UDim.new(0, 8)
TooltipPadding.PaddingTop = UDim.new(0, 5)
TooltipPadding.PaddingBottom = UDim.new(0, 5)
TooltipPadding.Parent = Tooltip

local TooltipCorner = Instance.new("UICorner")
TooltipCorner.CornerRadius = UDim.new(0, 4)
TooltipCorner.Parent = Tooltip

local TooltipStroke = Instance.new("UIStroke")
TooltipStroke.Color = Color3.fromRGB(45, 45, 45)
TooltipStroke.Transparency = 1
TooltipStroke.Parent = Tooltip

local currentElement = nil
local function AddTooltip(element, textOrFunc)
	element.MouseEnter:Connect(function()
		currentElement = element
		local text = type(textOrFunc) == "function" and textOrFunc() or textOrFunc
		Tooltip.Text = text
		Tooltip.Size = UDim2.new(0, Tooltip.TextBounds.X + 16, 0, math.max(22, Tooltip.TextBounds.Y + 10))
		TweenService:Create(Tooltip, fastTween, {TextTransparency = 0, BackgroundTransparency = 0}):Play()
		TweenService:Create(TooltipStroke, fastTween, {Transparency = 0}):Play()
	end)
	element.MouseLeave:Connect(function()
		if currentElement == element then
			currentElement = nil
			TweenService:Create(Tooltip, fastTween, {TextTransparency = 1, BackgroundTransparency = 1}):Play()
			TweenService:Create(TooltipStroke, fastTween, {Transparency = 1}):Play()
		end
	end)
end

RunService.RenderStepped:Connect(function()
	if currentElement then
		local pos = UserInputService:GetMouseLocation()
		Tooltip.Position = UDim2.new(0, pos.X + 16, 0, pos.Y - 16) 
	end
end)

local MainPanel = Instance.new("Frame")
MainPanel.Parent = ScreenGui
MainPanel.Size = UDim2.new(0, 650, 0, 420)
MainPanel.Position = UDim2.new(0.5, -325, 0.5, -210)
MainPanel.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
MainPanel.ClipsDescendants = true
MainPanel.Active = true
MainPanel.BorderSizePixel = 0

local PanelCorner = Instance.new("UICorner", MainPanel)
PanelCorner.CornerRadius = UDim.new(0, 6)

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

local handles = {
	Top = {UDim2.new(1, -24, 0, 6), UDim2.new(0, 12, 0, 0)},
	Bottom = {UDim2.new(1, -24, 0, 6), UDim2.new(0, 12, 1, -6)},
	Left = {UDim2.new(0, 6, 1, -24), UDim2.new(0, 0, 0, 12)},
	Right = {UDim2.new(0, 6, 1, -24), UDim2.new(1, -6, 0, 12)},
	TopLeft = {UDim2.new(0, 12, 0, 12), UDim2.new(0, 0, 0, 0)},
	TopRight = {UDim2.new(0, 12, 0, 12), UDim2.new(1, -12, 0, 0)},
	BottomLeft = {UDim2.new(0, 12, 0, 12), UDim2.new(0, 0, 1, -12)},
	BottomRight = {UDim2.new(0, 12, 0, 12), UDim2.new(1, -12, 1, -12)}
}

local resizeHandlesList = {}
local resizing, resizeDir, rStartMouse, rStartPos, rStartSize
local isMinimized = false
local preMinSize = MainPanel.Size

for name, data in pairs(handles) do
	local btn = Instance.new("TextButton", MainPanel)
	btn.Name = name .. "Resizer"
	btn.Size = data[1]
	btn.Position = data[2]
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.ZIndex = 50
	table.insert(resizeHandlesList, btn)

	btn.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not isMinimized then
			resizing = true
			resizeDir = name
			rStartMouse = input.Position
			rStartPos = MainPanel.Position
			rStartSize = MainPanel.Size
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					resizing = false
				end
			end)
		end
	end)
end

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		MainPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	elseif resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - rStartMouse
		local minX, minY = 400, 250
		local newSizeX = rStartSize.X.Offset
		local newSizeY = rStartSize.Y.Offset
		local newPosX = rStartPos.X.Offset
		local newPosY = rStartPos.Y.Offset

		if resizeDir:match("Right") then
			newSizeX = math.max(minX, rStartSize.X.Offset + delta.X)
		elseif resizeDir:match("Left") then
			local proposedSize = rStartSize.X.Offset - delta.X
			if proposedSize >= minX then
				newSizeX = proposedSize
				newPosX = rStartPos.X.Offset + delta.X
			else
				newSizeX = minX
				newPosX = rStartPos.X.Offset + (rStartSize.X.Offset - minX)
			end
		end

		if resizeDir:match("Bottom") then
			newSizeY = math.max(minY, rStartSize.Y.Offset + delta.Y)
		elseif resizeDir:match("Top") then
			local proposedSize = rStartSize.Y.Offset - delta.Y
			if proposedSize >= minY then
				newSizeY = proposedSize
				newPosY = rStartPos.Y.Offset + delta.Y
			else
				newSizeY = minY
				newPosY = rStartPos.Y.Offset + (rStartSize.Y.Offset - minY)
			end
		end

		MainPanel.Size = UDim2.new(0, newSizeX, 0, newSizeY)
		MainPanel.Position = UDim2.new(rStartPos.X.Scale, newPosX, rStartPos.Y.Scale, newPosY)
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

MinBtn.MouseButton1Click:Connect(function()
	if isMinimized then
		isMinimized = false
		MinBtn.Image = "rbxassetid://82235228007110"
		ContentGroup.Visible = true
		TweenService:Create(MainPanel, slideTween, {Size = preMinSize}):Play()
		for _, handle in ipairs(resizeHandlesList) do handle.Visible = true end
	else
		isMinimized = true
		preMinSize = MainPanel.Size
		MinBtn.Image = "rbxassetid://102684448472066"
		ContentGroup.Visible = false
		for _, handle in ipairs(resizeHandlesList) do handle.Visible = false end
		TweenService:Create(MainPanel, slideTween, {Size = UDim2.new(0, preMinSize.X.Offset, 0, 35)}):Play()
	end
end)

local function PlayCloseAnimation()
	isMinimized = true
	ContentGroup.Visible = false
	for _, handle in ipairs(resizeHandlesList) do handle.Visible = false end

	local fadeOut = function()
		local fadeTween = TweenService:Create(MainPanel, slideTween, {
			Size = UDim2.new(0, 140, 0, 35),
			BackgroundTransparency = 1
		})
		TweenService:Create(MinBtn, fastTween, {ImageTransparency = 1}):Play()
		TweenService:Create(CloseBtn, fastTween, {ImageTransparency = 1}):Play()
		TweenService:Create(PanelStroke, fastTween, {Transparency = 1}):Play()
		
		for _, v in ipairs(MainPanel:GetDescendants()) do
			if v:IsA("TextLabel") or v:IsA("TextBox") or v:IsA("TextButton") then
				TweenService:Create(v, fastTween, {TextTransparency = 1}):Play()
			elseif v:IsA("UIStroke") then
				TweenService:Create(v, fastTween, {Transparency = 1}):Play()
			elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
				TweenService:Create(v, fastTween, {ImageTransparency = 1}):Play()
			end
		end
		
		fadeTween:Play()
		task.delay(0.45, function() ScreenGui:Destroy() end)
	end

	if MainPanel.Size.Y.Offset > 35 then
		local collapse = TweenService:Create(MainPanel, slideTween, {Size = UDim2.new(0, MainPanel.Size.X.Offset, 0, 35)})
		collapse:Play()
		collapse.Completed:Connect(fadeOut)
	else
		fadeOut()
	end
end

CloseBtn.MouseButton1Click:Connect(PlayCloseAnimation)

local TitleLabel = Instance.new("TextLabel", MainPanel)
TitleLabel.Size = UDim2.new(1, -84, 0, 35)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Notepad"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
TitleLabel.Font = Enum.Font.GothamMedium
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 2

local EditorWrapper = Instance.new("Frame", ContentGroup)
EditorWrapper.Size = UDim2.new(1, -16, 1, -40)
EditorWrapper.Position = UDim2.new(0, 8, 0, 0)
EditorWrapper.BackgroundTransparency = 1
EditorWrapper.ClipsDescendants = true

local EditorContainer = Instance.new("Frame", EditorWrapper)
EditorContainer.Size = UDim2.new(1, 0, 1, 0)
EditorContainer.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
EditorContainer.BorderSizePixel = 0
EditorContainer.ClipsDescendants = true

EditorContainer:SetAttribute("StrokeTransparency", 1)
EditorContainer:SetAttribute("ScrollBarStrokeTransparency", 1)
EditorContainer:SetAttribute("BackgroundColor3", Color3.fromRGB(14, 14, 14))
EditorContainer:SetAttribute("ScrollBarTrackColor3", Color3.fromRGB(14, 14, 14))
EditorContainer:SetAttribute("ScrollBarThumbColor3", Color3.fromRGB(50, 50, 50))
EditorContainer:SetAttribute("ScrollBarHoverColor3", Color3.fromRGB(70, 70, 70))
EditorContainer:SetAttribute("ScrollBarPressColor3", Color3.fromRGB(35, 35, 35))
EditorContainer:SetAttribute("ScrollBarTrackTransparency", 0)

local EditorCorner = Instance.new("UICorner", EditorContainer)
EditorCorner.CornerRadius = UDim.new(0, 4)

local SettingsPanel = Instance.new("ScrollingFrame", ContentGroup)
SettingsPanel.Size = UDim2.new(1, -16, 1, -40)
SettingsPanel.Position = UDim2.new(1, 8, 0, 0) 
SettingsPanel.BackgroundTransparency = 1
SettingsPanel.BorderSizePixel = 0
SettingsPanel.ScrollBarThickness = 2
SettingsPanel.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 50)
SettingsPanel.CanvasSize = UDim2.new(0, 0, 0, 0)

local SettingsPadding = Instance.new("UIPadding", SettingsPanel)
SettingsPadding.PaddingTop = UDim.new(0, 4)
SettingsPadding.PaddingBottom = UDim.new(0, 4)
SettingsPadding.PaddingLeft = UDim.new(0, 4)
SettingsPadding.PaddingRight = UDim.new(0, 4)

local SettingsLayout = Instance.new("UIListLayout", SettingsPanel)
SettingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
SettingsLayout.Padding = UDim.new(0, 12)
SettingsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

SettingsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	SettingsPanel.CanvasSize = UDim2.new(0, 0, 0, SettingsLayout.AbsoluteContentSize.Y + 20)
end)

local function CreateSettingCard(title, description, customHeight)
	local Card = Instance.new("Frame")
	Card.Size = UDim2.new(1, -8, 0, customHeight or 75)
	Card.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	Card.BorderSizePixel = 0
	Card.ClipsDescendants = true
	
	Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 6)
	local stroke = Instance.new("UIStroke", Card)
	stroke.Color = Color3.fromRGB(35, 35, 35)
	
	local Header = Instance.new("TextLabel", Card)
	Header.Size = UDim2.new(1, -20, 0, 16)
	Header.Position = UDim2.new(0, 12, 0, 12)
	Header.BackgroundTransparency = 1
	Header.Text = title
	Header.TextColor3 = Color3.fromRGB(240, 240, 240)
	Header.Font = Enum.Font.GothamMedium
	Header.TextSize = 13
	Header.TextXAlignment = Enum.TextXAlignment.Left
	
	local Desc = Instance.new("TextLabel", Card)
	Desc.Size = UDim2.new(1, -20, 0, 14)
	Desc.Position = UDim2.new(0, 12, 0, 30)
	Desc.BackgroundTransparency = 1
	Desc.Text = description
	Desc.TextColor3 = Color3.fromRGB(140, 140, 140)
	Desc.Font = Enum.Font.Gotham
	Desc.TextSize = 11
	Desc.TextXAlignment = Enum.TextXAlignment.Left
	
	return Card
end

local ThemeCard = CreateSettingCard("Syntax Theme", "Enter a URL to load a custom syntax highlighting theme.", 100)
ThemeCard.LayoutOrder = 1
ThemeCard.Parent = SettingsPanel

local ThemeInput = Instance.new("TextBox", ThemeCard)
ThemeInput.Size = UDim2.new(1, -110, 0, 32)
ThemeInput.Position = UDim2.new(0, 12, 0, 52)
ThemeInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ThemeInput.TextColor3 = Color3.fromRGB(220, 220, 220)
ThemeInput.Font = Enum.Font.Gotham
ThemeInput.TextSize = 11
ThemeInput.Text = "https://raw.githubusercontent.com/slavtherookie/Slav/refs/heads/main/Public/Themes/PaperDark.luau"
ThemeInput.TextXAlignment = Enum.TextXAlignment.Left
ThemeInput.ClearTextOnFocus = false
ThemeInput.ClipsDescendants = true
ThemeInput.TextTruncate = Enum.TextTruncate.AtEnd
Instance.new("UICorner", ThemeInput).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", ThemeInput).Color = Color3.fromRGB(45, 45, 45)

local ThemeInputPadding = Instance.new("UIPadding", ThemeInput)
ThemeInputPadding.PaddingLeft = UDim.new(0, 8)
ThemeInputPadding.PaddingRight = UDim.new(0, 8)

local UpdateThemeBtn = Instance.new("TextButton", ThemeCard)
UpdateThemeBtn.Size = UDim2.new(0, 74, 0, 32)
UpdateThemeBtn.Position = UDim2.new(1, -86, 0, 52)
UpdateThemeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
UpdateThemeBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
UpdateThemeBtn.Font = Enum.Font.GothamMedium
UpdateThemeBtn.TextSize = 12
UpdateThemeBtn.Text = "Apply"
Instance.new("UICorner", UpdateThemeBtn).CornerRadius = UDim.new(0, 4)

local FontCard = CreateSettingCard("Editor Font", "Select the font family used for the code editor.", 100)
FontCard.LayoutOrder = 2
FontCard.Parent = SettingsPanel
FontCard.ClipsDescendants = true

local DropdownBtn = Instance.new("TextButton", FontCard)
DropdownBtn.Size = UDim2.new(1, -24, 0, 32)
DropdownBtn.Position = UDim2.new(0, 12, 0, 52)
DropdownBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
DropdownBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
DropdownBtn.Font = Enum.Font.Gotham
DropdownBtn.TextSize = 12
DropdownBtn.Text = "Roboto Mono"
DropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", DropdownBtn).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", DropdownBtn).Color = Color3.fromRGB(45, 45, 45)
local DPad = Instance.new("UIPadding", DropdownBtn)
DPad.PaddingLeft = UDim.new(0, 8)

local Chevron = Instance.new("ImageLabel", DropdownBtn)
Chevron.Size = UDim2.new(0, 16, 0, 16)
Chevron.AnchorPoint = Vector2.new(1, 0.5)
Chevron.Position = UDim2.new(1, -8, 0.5, 0)
Chevron.BackgroundTransparency = 1
Chevron.Image = "rbxassetid://10729792694"
Chevron.ImageColor3 = Color3.fromRGB(150, 150, 150)
Chevron.Rotation = -90

local FontListScroll = Instance.new("ScrollingFrame", FontCard)
FontListScroll.Size = UDim2.new(1, -24, 0, 0)
FontListScroll.Position = UDim2.new(0, 12, 0, 92)
FontListScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FontListScroll.BorderSizePixel = 0
FontListScroll.ScrollBarThickness = 2
FontListScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
FontListScroll.Visible = false
FontListScroll.ClipsDescendants = true
Instance.new("UICorner", FontListScroll).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", FontListScroll).Color = Color3.fromRGB(45, 45, 45)

local FontListPadding = Instance.new("UIPadding", FontListScroll)
FontListPadding.PaddingTop = UDim.new(0, 4)
FontListPadding.PaddingBottom = UDim.new(0, 4)
FontListPadding.PaddingLeft = UDim.new(0, 4)
FontListPadding.PaddingRight = UDim.new(0, 8)

local FontListLayout = Instance.new("UIListLayout", FontListScroll)
FontListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local SizeCard = CreateSettingCard("Font Size", "Adjust the size of the text in the editor.", 100)
SizeCard.LayoutOrder = 3
SizeCard.Parent = SettingsPanel

local FontSizeInput = Instance.new("TextBox", SizeCard)
FontSizeInput.Size = UDim2.new(1, -24, 0, 32)
FontSizeInput.Position = UDim2.new(0, 12, 0, 52)
FontSizeInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
FontSizeInput.TextColor3 = Color3.fromRGB(220, 220, 220)
FontSizeInput.Font = Enum.Font.Gotham
FontSizeInput.TextSize = 12
FontSizeInput.Text = "15"
FontSizeInput.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", FontSizeInput).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", FontSizeInput).Color = Color3.fromRGB(45, 45, 45)
local SPad = Instance.new("UIPadding", FontSizeInput)
SPad.PaddingLeft = UDim.new(0, 8)

local BlinkerCard = CreateSettingCard("Smooth Blinker", "Enable smooth cursor animation.", 75)
BlinkerCard.LayoutOrder = 4
BlinkerCard.Parent = SettingsPanel

local BlinkerToggle = Instance.new("ImageButton", BlinkerCard)
BlinkerToggle.Size = UDim2.new(0, 28, 0, 28)
BlinkerToggle.Position = UDim2.new(1, -40, 0.5, 0)
BlinkerToggle.AnchorPoint = Vector2.new(0, 0.5)
BlinkerToggle.BackgroundTransparency = 1
BlinkerToggle.ImageColor3 = Color3.fromRGB(220, 220, 220)

local BottomBar = Instance.new("Frame", ContentGroup)
BottomBar.Size = UDim2.new(1, -16, 0, 30)
BottomBar.Position = UDim2.new(0, 8, 1, -35)
BottomBar.BackgroundTransparency = 1

local BarLayout = Instance.new("UIListLayout", BottomBar)
BarLayout.FillDirection = Enum.FillDirection.Horizontal
BarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
BarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
BarLayout.Padding = UDim.new(0, 8)
BarLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function CreateActionButton(iconId, tooltipTextOrFunc, actionText, layoutOrder)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(0, 26, 0, 26)
	Btn.BackgroundTransparency = 1
	Btn.Text = ""
	Btn.ClipsDescendants = true
	Btn.LayoutOrder = layoutOrder
	
	local Icon = Instance.new("ImageLabel", Btn)
	Icon.Size = UDim2.new(0, 16, 0, 16)
	Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
	Icon.AnchorPoint = Vector2.new(0.5, 0.5)
	Icon.BackgroundTransparency = 1
	Icon.Image = iconId
	Icon.ImageColor3 = Color3.fromRGB(150, 150, 150)
	
	local Label = Instance.new("TextLabel", Btn)
	Label.Size = UDim2.new(1, 0, 1, 0)
	Label.BackgroundTransparency = 1
	Label.Text = actionText or ""
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.Font = Enum.Font.GothamMedium
	Label.TextSize = 11
	Label.TextTransparency = 1
	
	Btn.MouseEnter:Connect(function()
		TweenService:Create(Icon, fastTween, {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end)
	Btn.MouseLeave:Connect(function()
		TweenService:Create(Icon, fastTween, {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play()
	end)
	
	AddTooltip(Btn, tooltipTextOrFunc)
	
	local isAnimating = false
	local function triggerAction()
		if not actionText or isAnimating then return end
		isAnimating = true
		
		TweenService:Create(Btn, fastTween, {Size = UDim2.new(0, 75, 0, 26)}):Play()
		TweenService:Create(Icon, fastTween, {ImageTransparency = 1}):Play()
		TweenService:Create(Label, fastTween, {TextTransparency = 0}):Play()
		
		task.delay(1.2, function()
			TweenService:Create(Btn, fastTween, {Size = UDim2.new(0, 26, 0, 26)}):Play()
			TweenService:Create(Icon, fastTween, {ImageTransparency = 0}):Play()
			TweenService:Create(Label, fastTween, {TextTransparency = 1}):Play()
			task.wait(0.3)
			isAnimating = false
		end)
	end
	
	return Btn, Icon, triggerAction
end

local engineUrl = "https://raw.githubusercontent.com/slavtherookie/Slav/refs/heads/main/main/modulars/LuaUEngine.luau"
local engineSource = game:HttpGet(engineUrl)

local engineFunc, compileError = loadstring(engineSource)
if not engineFunc then
	error("Failed to load LuaUEngine.luau from GitHub. The file might be incomplete or broken: " .. tostring(compileError))
end

local Baseline = engineFunc()
local editor = Baseline.new(EditorContainer)

editor.Text = " "
editor.Minimap = true
editor.SmoothBlinker = true
editor.Lines = true
editor.TextSize = 15
editor.AutoHeight = false
editor.Wrapped = false
editor.HideScrollbars = true 
editor.Font = Enum.Font.RobotoMono

BlinkerToggle.Image = editor.SmoothBlinker and "rbxassetid://4458804262" or "rbxassetid://4458801905"

BlinkerToggle.MouseButton1Click:Connect(function()
	editor.SmoothBlinker = not editor.SmoothBlinker
	BlinkerToggle.Image = editor.SmoothBlinker and "rbxassetid://4458804262" or "rbxassetid://4458801905"
end)

local function applyFetchedTheme(url)
	local success, result = pcall(function()
		return game:HttpGet(url)
	end)
	if success and result then
		local fnSuccess, fnResult = pcall(function()
			return loadstring(result)()
		end)
		if fnSuccess then
			local themeRules = type(fnResult) == "function" and fnResult() or fnResult
			if type(themeRules) == "table" then
				if not themeRules["BackgroundColor"] then themeRules["BackgroundColor"] = {} end
				themeRules["BackgroundColor"].color = Color3.fromRGB(14, 14, 14)
				editor:ApplyThemeRules(themeRules)
				editor.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
				editor.StrokeTransparency = 1
				return true
			end
		end
	end
	return false
end
applyFetchedTheme(ThemeInput.Text)

local function GetEditorStats()
	local text = editor.Text or ""
	if text == " " then text = "" end
	
	local lines = text == "" and 0 or 1
	for _ in string.gmatch(text, "\n") do lines = lines + 1 end
	
	local functions = 0
	for _ in string.gmatch(text, "%f[%w]function%f[%W]") do functions = functions + 1 end
	
	local variables = 0
	for _ in string.gmatch(text, "%f[%w]local%f[%W]") do variables = variables + 1 end
	
	local comments = 0
	for _ in string.gmatch(text, "%-%-") do comments = comments + 1 end
	
	local stringsCount = 0
	for _ in string.gmatch(text, '".-"') do stringsCount = stringsCount + 1 end
	for _ in string.gmatch(text, "'.-'") do stringsCount = stringsCount + 1 end
	
	return string.format("Lines: %d\nFunctions: %d\nVariables: %d\nComments: %d\nStrings: %d", lines, functions, variables, comments, stringsCount)
end

local InfoBtn, _, _ = CreateActionButton("rbxassetid://103939313065245", GetEditorStats, nil, 1)
InfoBtn.Parent = BottomBar

local ClearBtn, _, TriggerClear = CreateActionButton("rbxassetid://91610802455390", "Clear", "CLEARED!", 2)
ClearBtn.Parent = BottomBar

local CopyBtn, _, TriggerCopy = CreateActionButton("rbxassetid://91403080584860", "Copy", "COPIED!", 3)
CopyBtn.Parent = BottomBar

local PasteBtn, _, TriggerPaste = CreateActionButton("rbxassetid://13436029894", "Paste", "PASTED!", 4)
PasteBtn.Parent = BottomBar

local ExecuteBtn, _, TriggerExecute = CreateActionButton("rbxassetid://8517323790", "Execute", "EXECUTED!", 5)
ExecuteBtn.Parent = BottomBar

local settingsOpen = false
local function getSettingsTooltip()
	return settingsOpen and "Back to Editor" or "Settings"
end

local SettingsBtn, SettingsIcon, _ = CreateActionButton("rbxassetid://9405931578", getSettingsTooltip, nil, 6)
SettingsBtn.Parent = BottomBar

ClearBtn.MouseButton1Click:Connect(function()
	editor.Text = " "
	TriggerClear()
end)

CopyBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		local textToCopy = editor.Text
		if textToCopy == " " then textToCopy = "" end
		setclipboard(textToCopy)
		TriggerCopy()
	end
end)

PasteBtn.MouseButton1Click:Connect(function()
	if getclipboard then
		editor.Text = getclipboard()
		TriggerPaste()
	end
end)

ExecuteBtn.MouseButton1Click:Connect(function()
	local source = editor.Text
	if source and source ~= " " and source ~= "" then
		local success, err = pcall(function() loadstring(source)() end)
		if not success then warn("[PaperNotepad] Execution Error:\n" .. tostring(err)) end
		TriggerExecute()
	end
end)

SettingsBtn.MouseButton1Click:Connect(function()
	settingsOpen = not settingsOpen
	if settingsOpen then
		TitleLabel.Text = "Settings"
		TweenService:Create(SettingsIcon, fastTween, {Rotation = 180}):Play()
		task.delay(0.15, function() SettingsIcon.Image = "rbxassetid://111290129018455" end)
		
		TweenService:Create(EditorWrapper, slideTween, {Position = UDim2.new(-1, 0, 0, 0)}):Play()
		TweenService:Create(SettingsPanel, slideTween, {Position = UDim2.new(0, 0, 0, 0)}):Play()
		
		TweenService:Create(InfoBtn, fastTween, {Size = UDim2.new(0, 0, 0, 26)}):Play()
		TweenService:Create(ClearBtn, fastTween, {Size = UDim2.new(0, 0, 0, 26)}):Play()
		TweenService:Create(CopyBtn, fastTween, {Size = UDim2.new(0, 0, 0, 26)}):Play()
		TweenService:Create(PasteBtn, fastTween, {Size = UDim2.new(0, 0, 0, 26)}):Play()
		TweenService:Create(ExecuteBtn, fastTween, {Size = UDim2.new(0, 0, 0, 26)}):Play()
	else
		TitleLabel.Text = "Notepad"
		TweenService:Create(SettingsIcon, fastTween, {Rotation = 0}):Play()
		task.delay(0.15, function() SettingsIcon.Image = "rbxassetid://9405931578" end)
		
		TweenService:Create(SettingsPanel, slideTween, {Position = UDim2.new(1, 8, 0, 0)}):Play()
		TweenService:Create(EditorWrapper, slideTween, {Position = UDim2.new(0, 8, 0, 0)}):Play()
		
		TweenService:Create(InfoBtn, fastTween, {Size = UDim2.new(0, 26, 0, 26)}):Play()
		TweenService:Create(ClearBtn, fastTween, {Size = UDim2.new(0, 26, 0, 26)}):Play()
		TweenService:Create(CopyBtn, fastTween, {Size = UDim2.new(0, 26, 0, 26)}):Play()
		TweenService:Create(PasteBtn, fastTween, {Size = UDim2.new(0, 26, 0, 26)}):Play()
		TweenService:Create(ExecuteBtn, fastTween, {Size = UDim2.new(0, 26, 0, 26)}):Play()
	end
end)

UpdateThemeBtn.MouseButton1Click:Connect(function()
	local url = ThemeInput.Text
	if url ~= "" then
		UpdateThemeBtn.Text = "..."
		task.spawn(function()
			local success = applyFetchedTheme(url)
			if success then
				UpdateThemeBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
				UpdateThemeBtn.Text = "Applied"
			else
				UpdateThemeBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
				UpdateThemeBtn.Text = "Error"
			end
			task.wait(1.5)
			UpdateThemeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
			UpdateThemeBtn.Text = "Apply"
		end)
	end
end)

FontSizeInput.FocusLost:Connect(function()
	local newSize = tonumber(FontSizeInput.Text)
	if newSize and newSize > 0 then
		editor.TextSize = newSize
	else
		FontSizeInput.Text = tostring(editor.TextSize)
	end
end)

local dropdownOpen = false
DropdownBtn.MouseButton1Click:Connect(function()
	dropdownOpen = not dropdownOpen
	if dropdownOpen then
		FontListScroll.Visible = true
		TweenService:Create(FontCard, fastTween, {Size = UDim2.new(1, -8, 0, 244)}):Play()
		TweenService:Create(FontListScroll, fastTween, {Size = UDim2.new(1, -24, 0, 140)}):Play()
		TweenService:Create(Chevron, fastTween, {Rotation = 90}):Play()
	else
		TweenService:Create(FontCard, fastTween, {Size = UDim2.new(1, -8, 0, 100)}):Play()
		local t = TweenService:Create(FontListScroll, fastTween, {Size = UDim2.new(1, -24, 0, 0)})
		t:Play()
		TweenService:Create(Chevron, fastTween, {Rotation = -90}):Play()
		t.Completed:Wait()
		if not dropdownOpen then
			FontListScroll.Visible = false
		end
	end
end)

local validEnumFonts = {
	{"Roboto Mono", Enum.Font.RobotoMono},
	{"Inconsolata", Enum.Font.Code},
	{"Source Sans", Enum.Font.SourceSans},
	{"Ubuntu", Enum.Font.Ubuntu},
	{"Gotham", Enum.Font.Gotham},
	{"Arial", Enum.Font.Arial},
	{"Sci-Fi", Enum.Font.SciFi},
	{"Fantasy", Enum.Font.Fantasy},
	{"Arcade", Enum.Font.Arcade},
	{"Cartoon", Enum.Font.Cartoon}
}

for _, fontData in ipairs(validEnumFonts) do
	local fBtn = Instance.new("TextButton", FontListScroll)
	fBtn.Size = UDim2.new(1, 0, 0, 28)
	fBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	fBtn.BorderSizePixel = 0
	fBtn.Text = "  " .. fontData[1]
	fBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
	fBtn.TextSize = 12
	fBtn.TextXAlignment = Enum.TextXAlignment.Left
	fBtn.Font = fontData[2]
	Instance.new("UICorner", fBtn).CornerRadius = UDim.new(0, 4)
	
	fBtn.MouseEnter:Connect(function() fBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35) end)
	fBtn.MouseLeave:Connect(function() fBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20) end)
	
	fBtn.MouseButton1Click:Connect(function()
		editor.Font = fontData[2]
		DropdownBtn.Text = fontData[1]
		dropdownOpen = false
		TweenService:Create(FontCard, fastTween, {Size = UDim2.new(1, -8, 0, 100)}):Play()
		local t = TweenService:Create(FontListScroll, fastTween, {Size = UDim2.new(1, -24, 0, 0)})
		t:Play()
		TweenService:Create(Chevron, fastTween, {Rotation = -90}):Play()
		t.Completed:Wait()
		if not dropdownOpen then
			FontListScroll.Visible = false
		end
	end)
end

FontListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	FontListScroll.CanvasSize = UDim2.new(0, 0, 0, FontListLayout.AbsoluteContentSize.Y)
end)
