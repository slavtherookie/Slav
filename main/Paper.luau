local creator = "slavtherookie"
local githubrepo = "Slav"
local branch = "main"
local pathBase = "main/Paper/loads/"

local function GetGithubFile(path)
	return string.format("https://raw.githubusercontent.com/%s/%s/%s/%s%s", creator, githubrepo, branch, pathBase, path)
end

local teleportFunc = queue_on_teleport
	or (syn and syn.queue_on_teleport)
	or (fluxus and fluxus.queue_on_teleport)
	or (getgenv and getgenv().queue_on_teleport)

if teleportFunc then
	local execStr = string.format([[
		task.wait(2.5)

		local success, result = pcall(game.HttpGet, game,
			"https://raw.githubusercontent.com/%s/%s/%s/main/Paper.luau"
		)

		if success and result then
			local fn = loadstring(result)
			if type(fn) == "function" then
				fn()
			end
		end
	]], creator, githubrepo, branch)

	pcall(function()
		teleportFunc(execStr)
	end)
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local ContentProvider = game:GetService("ContentProvider")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local guiName = "PaperAdmin"
local targetGui = pcall(function() return CoreGui.Name end) and CoreGui or LocalPlayer:WaitForChild("PlayerGui")

if targetGui:FindFirstChild(guiName) then
	targetGui[guiName]:Destroy()
end
for _, v in ipairs(targetGui:GetChildren()) do
	if v.Name == "Paper_ESP_GUI" then
		v:Destroy()
	end
end

local smoothTween = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local fastTween = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local loaded = false
local notifsEnabled = true
local isFocused = false
local isHovered = false
local isExpanded = false
local isDragged = false
local settingsOpen = false
local activeSuggestions = {}
local CommandRegistry = {}

local tooltipConn, suggConn, dragConn, keybindConn

local MAIN_ICON = "rbxassetid://84021105793570"
local NOTIF_ICON = "rbxassetid://91047500682054"
local GITHUB_ICON = "rbxassetid://102816031861909"
local CLOSE_ICON = "rbxassetid://4458805208"
local SETTINGS_ICON = "rbxassetid://9405931578"
local BACK_ICON = "rbxassetid://9405925508"
local LOADER_ICON = "rbxassetid://135205586099792"

task.spawn(function()
	local iconsToCheck = {MAIN_ICON, NOTIF_ICON, GITHUB_ICON, CLOSE_ICON, SETTINGS_ICON, BACK_ICON, LOADER_ICON}
	for _, id in ipairs(iconsToCheck) do
		pcall(function()
			local temp = Instance.new("ImageLabel")
			temp.Image = id
			ContentProvider:PreloadAsync({temp})
			temp:Destroy()
		end)
	end
end)

local function RegisterCommand(name, aliases, argHint, argType, description, callback)
	table.insert(CommandRegistry, {
		Name = string.lower(name),
		Aliases = aliases,
		ArgHint = argHint,
		ArgType = argType,
		Description = description,
		Callback = callback
	})
end

local function GetPlayerFromQuery(query)
	query = string.lower(query or "")
	if query == "" then return nil end
	for _, p in ipairs(Players:GetPlayers()) do
		if string.lower(p.Name) == query or string.lower(p.DisplayName) == query or tostring(p.UserId) == query then
			return p
		end
	end
	for _, p in ipairs(Players:GetPlayers()) do
		if string.sub(string.lower(p.Name), 1, #query) == query or string.sub(string.lower(p.DisplayName), 1, #query) == query then
			return p
		end
	end
	for _, p in ipairs(Players:GetPlayers()) do
		if string.find(string.lower(p.Name), query) or string.find(string.lower(p.DisplayName), query) then
			return p
		end
	end
	return nil
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = targetGui

local function CreateLargeNotification(titleText, descText, iconId)
	local bg = Instance.new("Frame", ScreenGui)
	bg.AnchorPoint = Vector2.new(0.5, 0.5)
	bg.Position = UDim2.new(0.5, 0, 0.5, 0)
	bg.Size = UDim2.new(0, 400, 0, 250)
	bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	bg.Active = true
	bg.ZIndex = 150

	local uic = Instance.new("UICorner", bg)
	uic.CornerRadius = UDim.new(0, 4)
	local uis = Instance.new("UIStroke", bg)
	uis.Color = Color3.fromRGB(60, 60, 60)

	local top = Instance.new("Frame", bg)
	top.Size = UDim2.new(1, 0, 0, 30)
	top.BackgroundTransparency = 1

	local icon = Instance.new("ImageLabel", top)
	icon.Size = UDim2.new(0, 16, 0, 16)
	icon.Position = UDim2.new(0, 10, 0.5, -8)
	icon.BackgroundTransparency = 1
	icon.Image = iconId

	local lbl = Instance.new("TextLabel", top)
	lbl.Size = UDim2.new(1, -60, 1, 0)
	lbl.Position = UDim2.new(0, 36, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = titleText
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	lbl.Font = Enum.Font.GothamMedium
	lbl.TextSize = 14
	lbl.TextXAlignment = Enum.TextXAlignment.Left

	local cbtn = Instance.new("ImageButton", top)
	cbtn.Size = UDim2.new(0, 16, 0, 16)
	cbtn.Position = UDim2.new(1, -26, 0.5, -8)
	cbtn.BackgroundTransparency = 1
	cbtn.Image = CLOSE_ICON
	cbtn.ImageColor3 = Color3.fromRGB(180, 180, 180)
	cbtn.MouseButton1Click:Connect(function() bg:Destroy() end)

	local scroll = Instance.new("ScrollingFrame", bg)
	scroll.Size = UDim2.new(1, -20, 1, -40)
	scroll.Position = UDim2.new(0, 10, 0, 35)
	scroll.BackgroundTransparency = 1
	scroll.ScrollBarThickness = 4
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

	local tbox = Instance.new("TextLabel", scroll)
	tbox.Size = UDim2.new(1, -10, 0, 0)
	tbox.BackgroundTransparency = 1
	tbox.Text = descText
	tbox.TextColor3 = Color3.fromRGB(200, 200, 200)
	tbox.Font = Enum.Font.Gotham
	tbox.TextSize = 13
	tbox.TextWrapped = true
	tbox.TextXAlignment = Enum.TextXAlignment.Left
	tbox.TextYAlignment = Enum.TextYAlignment.Top
	tbox.AutomaticSize = Enum.AutomaticSize.Y

	local drag, dInput, dStart, sPos
	top.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			drag = true
			dStart = input.Position
			sPos = bg.Position
		end
	end)
	top.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			drag = false
		end
	end)
	top.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dInput = input
		end
	end)
	local dConn = UserInputService.InputChanged:Connect(function(input)
		if input == dInput and drag then
			local delta = input.Position - dStart
			bg.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
		end
	end)
	bg.Destroying:Connect(function()
		if dConn then dConn:Disconnect() end
	end)
end

local TracerContainer = Instance.new("Frame")
TracerContainer.Name = "TracerContainer"
TracerContainer.Size = UDim2.new(1, 0, 1, 0)
TracerContainer.BackgroundTransparency = 1
TracerContainer.Parent = ScreenGui
TracerContainer.ZIndex = 0

local Tooltip = Instance.new("TextLabel")
Tooltip.Parent = ScreenGui
Tooltip.Size = UDim2.new(0, 0, 0, 22)
Tooltip.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Tooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
Tooltip.Font = Enum.Font.GothamMedium
Tooltip.TextSize = 11
Tooltip.TextTransparency = 1
Tooltip.BackgroundTransparency = 1
Tooltip.ZIndex = 100
Tooltip.AnchorPoint = Vector2.new(0, 1)

local TooltipCorner = Instance.new("UICorner", Tooltip)
TooltipCorner.CornerRadius = UDim.new(0, 2)
local TooltipStroke = Instance.new("UIStroke", Tooltip)
TooltipStroke.Color = Color3.fromRGB(50, 50, 50)
TooltipStroke.Transparency = 1

local currentTooltip = nil
local function AddTooltip(element, text)
	element.MouseEnter:Connect(function()
		currentTooltip = text
		Tooltip.Text = text
		Tooltip.Size = UDim2.new(0, Tooltip.TextBounds.X + 16, 0, 22)
		TweenService:Create(Tooltip, fastTween, {TextTransparency = 0, BackgroundTransparency = 0}):Play()
		TweenService:Create(TooltipStroke, fastTween, {Transparency = 0}):Play()
	end)
	element.MouseLeave:Connect(function()
		if currentTooltip == text then
			currentTooltip = nil
			TweenService:Create(Tooltip, fastTween, {TextTransparency = 1, BackgroundTransparency = 1}):Play()
			TweenService:Create(TooltipStroke, fastTween, {Transparency = 1}):Play()
		end
	end)
end

tooltipConn = RunService.RenderStepped:Connect(function()
	if currentTooltip then
		local pos = UserInputService:GetMouseLocation()
		Tooltip.Position = UDim2.new(0, pos.X + 16, 0, pos.Y - 26)
	end
end)

local Watermark = Instance.new("TextLabel")
Watermark.Parent = ScreenGui
Watermark.AnchorPoint = Vector2.new(0, 1)
Watermark.Position = UDim2.new(0, 20, 1, -20)
Watermark.Size = UDim2.new(0, 0, 0, 20)
Watermark.BackgroundTransparency = 1
Watermark.Text = "Paper | Slavtherookie"
Watermark.TextColor3 = Color3.fromRGB(255, 255, 255)
Watermark.Font = Enum.Font.GothamMedium
Watermark.TextSize = 13
Watermark.TextXAlignment = Enum.TextXAlignment.Left
Watermark.Visible = false

local WatermarkStroke = Instance.new("UIStroke", Watermark)
WatermarkStroke.Color = Color3.fromRGB(40, 40, 40)
WatermarkStroke.Thickness = 1
WatermarkStroke.Transparency = 0.2

local NotifContainer = Instance.new("Frame")
NotifContainer.Parent = ScreenGui
NotifContainer.AnchorPoint = Vector2.new(1, 1)
NotifContainer.Position = UDim2.new(1, -20, 1, -20)
NotifContainer.Size = UDim2.new(0, 240, 0.8, 0)
NotifContainer.BackgroundTransparency = 1

local NotifLayout = Instance.new("UIListLayout", NotifContainer)
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 8)

local SuggestionsContainer = Instance.new("Frame")
SuggestionsContainer.Parent = ScreenGui
SuggestionsContainer.AnchorPoint = Vector2.new(0, 1)
SuggestionsContainer.BackgroundTransparency = 1
SuggestionsContainer.ClipsDescendants = true
SuggestionsContainer.AutomaticSize = Enum.AutomaticSize.Y

local SuggestionsLayout = Instance.new("UIListLayout", SuggestionsContainer)
SuggestionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
SuggestionsLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
SuggestionsLayout.Padding = UDim.new(0, 4)

local MainPanel
local function UpdateNotifPosition()
	local targetY = -20
	if not isDragged then
		if isExpanded then
			targetY = -350
		else
			local baseHeight = settingsOpen and 100 or 42
			if (isFocused or isHovered or settingsOpen) then
				targetY = -(baseHeight + 26)
				if SuggestionsContainer.AbsoluteSize.Y > 0 then
					targetY = targetY - SuggestionsContainer.AbsoluteSize.Y
				end
			end
		end
	end
	pcall(function() TweenService:Create(NotifContainer, smoothTween, {Position = UDim2.new(1, -20, 1, targetY)}):Play() end)
end

SuggestionsContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateNotifPosition)

suggConn = RunService.RenderStepped:Connect(function()
	if MainPanel then
		SuggestionsContainer.Position = UDim2.new(0, MainPanel.AbsolutePosition.X, 0, MainPanel.AbsolutePosition.Y - 6)
		SuggestionsContainer.Size = UDim2.new(0, MainPanel.AbsoluteSize.X, 0, 0)
	end
end)

local function Notify(title, text, iconId)
	if not notifsEnabled then return end
	iconId = iconId or NOTIF_ICON
	local Frame = Instance.new("Frame", NotifContainer)
	Frame.Size = UDim2.new(1, 0, 0, 0)
	Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	Frame.ClipsDescendants = true
	
	local Corner = Instance.new("UICorner", Frame)
	Corner.CornerRadius = UDim.new(0, 2)
	local Stroke = Instance.new("UIStroke", Frame)
	Stroke.Color = Color3.fromRGB(45, 45, 45)
	
	local Icon = Instance.new("ImageLabel", Frame)
	Icon.AnchorPoint = Vector2.new(0, 0.5)
	Icon.Position = UDim2.new(0, 12, 0.5, 0)
	Icon.Size = UDim2.new(0, 24, 0, 24)
	Icon.BackgroundTransparency = 1
	Icon.Image = iconId
	
	local Title = Instance.new("TextLabel", Frame)
	Title.Position = UDim2.new(0, 46, 0, 10)
	Title.Size = UDim2.new(1, -76, 0, 16)
	Title.BackgroundTransparency = 1
	Title.Text = title
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.Font = Enum.Font.GothamMedium
	Title.TextSize = 13
	Title.TextXAlignment = Enum.TextXAlignment.Left
	
	local Desc = Instance.new("TextLabel", Frame)
	Desc.Position = UDim2.new(0, 46, 0, 28)
	Desc.Size = UDim2.new(1, -76, 0, 14)
	Desc.BackgroundTransparency = 1
	Desc.Text = text
	Desc.TextColor3 = Color3.fromRGB(160, 160, 160)
	Desc.Font = Enum.Font.Gotham
	Desc.TextSize = 11
	Desc.TextWrapped = true
	Desc.TextXAlignment = Enum.TextXAlignment.Left

	local ClickArea = Instance.new("TextButton", Frame)
	ClickArea.Size = UDim2.new(1, -30, 1, 0)
	ClickArea.Position = UDim2.new(0, 0, 0, 0)
	ClickArea.BackgroundTransparency = 1
	ClickArea.Text = ""
	ClickArea.ZIndex = 5
	ClickArea.MouseButton1Click:Connect(function()
		if string.lower(title) == "error" then
			CreateLargeNotification(title, text, iconId)
		end
	end)
	
	local CloseBtn = Instance.new("ImageButton", Frame)
	CloseBtn.AnchorPoint = Vector2.new(1, 0.5)
	CloseBtn.Position = UDim2.new(1, -10, 0.5, 0)
	CloseBtn.Size = UDim2.new(0, 16, 0, 16)
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.Image = CLOSE_ICON
	CloseBtn.ImageColor3 = Color3.fromRGB(180, 180, 180)
	CloseBtn.ZIndex = 6
	
	local closed = false
	local function closeNotif()
		if closed then return end
		closed = true
		pcall(function() TweenService:Create(Frame, smoothTween, {Size = UDim2.new(1, 0, 0, 0)}):Play() end)
		task.delay(0.4, function() pcall(function() Frame:Destroy() end) end)
	end
	
	CloseBtn.MouseButton1Click:Connect(closeNotif)
	CloseBtn.MouseEnter:Connect(function() pcall(function() TweenService:Create(CloseBtn, fastTween, {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play() end) end)
	CloseBtn.MouseLeave:Connect(function() pcall(function() TweenService:Create(CloseBtn, fastTween, {ImageColor3 = Color3.fromRGB(180, 180, 180)}):Play() end) end)
	AddTooltip(CloseBtn, "Dismiss")
	
	pcall(function() TweenService:Create(Frame, smoothTween, {Size = UDim2.new(1, 0, 0, 56)}):Play() end)
	task.delay(6, closeNotif)
end

local HoverZone = Instance.new("Frame", ScreenGui)
HoverZone.AnchorPoint = Vector2.new(1, 1)
HoverZone.Position = UDim2.new(1, 0, 1, 0)
HoverZone.Size = UDim2.new(0, 320, 0, 100)
HoverZone.BackgroundTransparency = 1
HoverZone.Active = true
HoverZone.Visible = false

MainPanel = Instance.new("Frame", ScreenGui)
MainPanel.AnchorPoint = Vector2.new(1, 1)
MainPanel.Position = UDim2.new(1, -20, 1, 60)
MainPanel.Size = UDim2.new(0, 280, 0, 42)
MainPanel.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
MainPanel.ClipsDescendants = true
MainPanel.Active = true

local PanelCorner = Instance.new("UICorner", MainPanel)
PanelCorner.CornerRadius = UDim.new(0, 2)
local PanelStroke = Instance.new("UIStroke", MainPanel)
PanelStroke.Color = Color3.fromRGB(45, 45, 45)

local ExpandedContent = Instance.new("CanvasGroup", MainPanel)
ExpandedContent.Size = UDim2.new(1, 0, 1, -42)
ExpandedContent.Position = UDim2.new(0, 0, 0, 0)
ExpandedContent.BackgroundTransparency = 1
ExpandedContent.GroupTransparency = 1

local CommandScroll = Instance.new("ScrollingFrame", ExpandedContent)
CommandScroll.Size = UDim2.new(1, -12, 1, -12)
CommandScroll.Position = UDim2.new(0, 6, 0, 6)
CommandScroll.BackgroundTransparency = 1
CommandScroll.ScrollBarThickness = 0
local CommandScrollLayout = Instance.new("UIListLayout", CommandScroll)
CommandScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
CommandScrollLayout.Padding = UDim.new(0, 6)
CommandScrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local BottomBar = Instance.new("Frame", MainPanel)
BottomBar.AnchorPoint = Vector2.new(0, 1)
BottomBar.Position = UDim2.new(0, 0, 1, 0)
BottomBar.Size = UDim2.new(1, 0, 0, 42)
BottomBar.BackgroundTransparency = 1

local MainIcon = Instance.new("ImageLabel", BottomBar)
MainIcon.AnchorPoint = Vector2.new(0, 0.5)
MainIcon.Position = UDim2.new(0, 12, 0.5, 0)
MainIcon.Size = UDim2.new(0, 18, 0, 18)
MainIcon.BackgroundTransparency = 1
MainIcon.Image = MAIN_ICON
MainIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
AddTooltip(MainIcon, "Paper Client")

local TextBox = Instance.new("TextBox", BottomBar)
TextBox.AnchorPoint = Vector2.new(0, 0.5)
TextBox.Position = UDim2.new(0, 40, 0.5, 0)
TextBox.Size = UDim2.new(1, -80, 0, 30)
TextBox.BackgroundTransparency = 1
TextBox.Text = ""
TextBox.PlaceholderText = "Type command..."
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
TextBox.Font = Enum.Font.Gotham
TextBox.TextSize = 13
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.ClearTextOnFocus = false
AddTooltip(TextBox, "Type a command or press ; to auto-focus")

local SettingsBtn = Instance.new("ImageButton", BottomBar)
SettingsBtn.AnchorPoint = Vector2.new(1, 0.5)
SettingsBtn.Position = UDim2.new(1, -12, 0.5, 0)
SettingsBtn.Size = UDim2.new(0, 18, 0, 18)
SettingsBtn.BackgroundTransparency = 1
SettingsBtn.Image = SETTINGS_ICON
SettingsBtn.ImageColor3 = Color3.fromRGB(180, 180, 180)
AddTooltip(SettingsBtn, "Client Settings")

local SettingsPanel = Instance.new("Frame", MainPanel)
SettingsPanel.Position = UDim2.new(1, 0, 0, 0)
SettingsPanel.Size = UDim2.new(1, 0, 1, 0)
SettingsPanel.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
SettingsPanel.ZIndex = 5

local SettingsBackBtn = Instance.new("ImageButton", SettingsPanel)
SettingsBackBtn.AnchorPoint = Vector2.new(0, 0.5)
SettingsBackBtn.Position = UDim2.new(0, 12, 1, -21)
SettingsBackBtn.Size = UDim2.new(0, 18, 0, 18)
SettingsBackBtn.BackgroundTransparency = 1
SettingsBackBtn.Image = BACK_ICON
SettingsBackBtn.Rotation = 180
SettingsBackBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
SettingsBackBtn.ZIndex = 6

local SettingsTitle = Instance.new("TextLabel", SettingsPanel)
SettingsTitle.AnchorPoint = Vector2.new(0, 0.5)
SettingsTitle.Position = UDim2.new(0, 40, 1, -21)
SettingsTitle.Size = UDim2.new(1, -52, 0, 30)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Text = "Settings"
SettingsTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
SettingsTitle.Font = Enum.Font.GothamMedium
SettingsTitle.TextSize = 13
SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
SettingsTitle.ZIndex = 6

local ProfilePic = Instance.new("ImageLabel", SettingsPanel)
ProfilePic.Size = UDim2.new(0, 36, 0, 36)
ProfilePic.Position = UDim2.new(0, 12, 0, 12)
ProfilePic.BackgroundTransparency = 1
pcall(function() ProfilePic.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48) end)
local PPCorner = Instance.new("UICorner", ProfilePic)
PPCorner.CornerRadius = UDim.new(1, 0)

local ProfileName = Instance.new("TextLabel", SettingsPanel)
ProfileName.Position = UDim2.new(0, 58, 0, 14)
ProfileName.Size = UDim2.new(1, -70, 0, 16)
ProfileName.BackgroundTransparency = 1
ProfileName.Text = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")"
ProfileName.TextColor3 = Color3.fromRGB(255, 255, 255)
ProfileName.Font = Enum.Font.GothamMedium
ProfileName.TextSize = 13
ProfileName.TextXAlignment = Enum.TextXAlignment.Left

local LicenseText = Instance.new("TextLabel", SettingsPanel)
LicenseText.Position = UDim2.new(0, 58, 0, 32)
LicenseText.Size = UDim2.new(1, -70, 0, 14)
LicenseText.BackgroundTransparency = 1
LicenseText.RichText = true
LicenseText.Text = "License: Valid -- paper user"
LicenseText.Font = Enum.Font.Gotham
LicenseText.TextSize = 11
LicenseText.TextXAlignment = Enum.TextXAlignment.Left

local dragging, dragInput, dragStart, startPos
MainPanel.InputBegan:Connect(function(input)
	if not isExpanded then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		isDragged = true
		dragStart = input.Position
		startPos = MainPanel.Position
		UpdateNotifPosition()
	end
end)

MainPanel.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

MainPanel.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

dragConn = UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging and isExpanded then
		local delta = input.Position - dragStart
		MainPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local function UpdateUIState()
	pcall(function()
		if isExpanded then
			local targetPos = isDragged and MainPanel.Position or UDim2.new(1, -20, 1, -20)
			TweenService:Create(MainPanel, smoothTween, {Size = UDim2.new(0, 380, 0, 320), Position = targetPos}):Play()
			TweenService:Create(ExpandedContent, smoothTween, {GroupTransparency = 0}):Play()
		elseif isFocused or isHovered or settingsOpen then
			isDragged = false
			local targetHeight = settingsOpen and 100 or 42
			TweenService:Create(MainPanel, smoothTween, {Size = UDim2.new(0, 280, 0, targetHeight), Position = UDim2.new(1, -20, 1, -20)}):Play()
			TweenService:Create(ExpandedContent, smoothTween, {GroupTransparency = 1}):Play()
		else
			isDragged = false
			TweenService:Create(MainPanel, smoothTween, {Size = UDim2.new(0, 280, 0, 42), Position = UDim2.new(1, -20, 1, 60)}):Play()
			TweenService:Create(ExpandedContent, smoothTween, {GroupTransparency = 1}):Play()
			if settingsOpen then
				settingsOpen = false
				TweenService:Create(SettingsPanel, smoothTween, {Position = UDim2.new(1, 0, 0, 0)}):Play()
			end
		end
		UpdateNotifPosition()
	end)
end

local PaperAPI = {
	RegisterCommand = RegisterCommand,
	Notify = Notify,
	GetPlayer = GetPlayerFromQuery,
	SetUIExpanded = function(state)
		isExpanded = state
		UpdateUIState()
	end,
	SetWatermarkVisible = function(state) Watermark.Visible = state end,
	SetNotifsEnabled = function(state) notifsEnabled = state end,
	TargetGui = targetGui,
	TracerContainer = TracerContainer
}

local success, result = pcall(function()
	local src = game:HttpGet(GetGithubFile("Utils/commands.luau"))
	local fn = loadstring(src)
	if type(fn) == "function" then 
		return fn 
	else
		error("Failed to compile commands.luau: " .. tostring(fn))
	end
end)

if success and type(result) == "function" then
	local apiSuccess, apiErr = pcall(result, PaperAPI)
	if not apiSuccess then
		Notify("Error", "Execution error in commands: " .. tostring(apiErr))
	end
else
	Notify("Error", "Failed to load commands script: " .. tostring(result))
end

local function PopulateCommandList()
	for _, child in ipairs(CommandScroll:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end
	for _, cmd in ipairs(CommandRegistry) do
		local F = Instance.new("Frame", CommandScroll)
		F.Size = UDim2.new(1, -8, 0, 44)
		F.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		local C = Instance.new("UICorner", F)
		C.CornerRadius = UDim.new(0, 2)
		local S = Instance.new("UIStroke", F)
		S.Color = Color3.fromRGB(45, 45, 45)
		
		local T = Instance.new("TextLabel", F)
		T.Position = UDim2.new(0, 12, 0, 6)
		T.Size = UDim2.new(1, -24, 0, 16)
		T.BackgroundTransparency = 1
		
		local aliasText = ""
		if cmd.Aliases and #cmd.Aliases > 0 then
			aliasText = " [" .. table.concat(cmd.Aliases, ", ") .. "]"
		end
		
		T.Text = cmd.Name .. aliasText .. " " .. cmd.ArgHint
		T.TextColor3 = Color3.fromRGB(255, 255, 255)
		T.Font = Enum.Font.GothamMedium
		T.TextSize = 13
		T.TextXAlignment = Enum.TextXAlignment.Left
		T.TextTruncate = Enum.TextTruncate.AtEnd
		
		local D = Instance.new("TextLabel", F)
		D.Position = UDim2.new(0, 12, 0, 22)
		D.Size = UDim2.new(1, -24, 0, 16)
		D.BackgroundTransparency = 1
		D.Text = cmd.Description
		D.TextColor3 = Color3.fromRGB(150, 150, 150)
		D.Font = Enum.Font.Gotham
		D.TextSize = 11
		D.TextXAlignment = Enum.TextXAlignment.Left
	end
	CommandScroll.CanvasSize = UDim2.new(0, 0, 0, #CommandRegistry * 50)
end

HoverZone.MouseEnter:Connect(function()
	if not loaded then return end
	isHovered = true
	UpdateUIState()
end)
HoverZone.MouseLeave:Connect(function()
	if not loaded then return end
	isHovered = false
	UpdateUIState()
end)

SettingsBtn.MouseEnter:Connect(function() pcall(function() TweenService:Create(SettingsBtn, fastTween, {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play() end) end)
SettingsBtn.MouseLeave:Connect(function() pcall(function() TweenService:Create(SettingsBtn, fastTween, {ImageColor3 = Color3.fromRGB(180, 180, 180)}):Play() end) end)

SettingsBtn.MouseButton1Click:Connect(function()
	settingsOpen = true
	UpdateUIState()
	pcall(function() TweenService:Create(SettingsPanel, smoothTween, {Position = UDim2.new(0, 0, 0, 0)}):Play() end)
end)

SettingsBackBtn.MouseButton1Click:Connect(function()
	settingsOpen = false
	UpdateUIState()
	pcall(function() TweenService:Create(SettingsPanel, smoothTween, {Position = UDim2.new(1, 0, 0, 0)}):Play() end)
end)

local function ClearSuggestions()
	for _, child in ipairs(activeSuggestions) do
		pcall(function() TweenService:Create(child, fastTween, {Size = UDim2.new(1, 0, 0, 0)}):Play() end)
		task.delay(0.2, function() pcall(function() child:Destroy() end) end)
	end
	activeSuggestions = {}
end

local function CreateSuggestion(iconId, titleText, subText, autoFillText)
	local Frame = Instance.new("Frame", SuggestionsContainer)
	Frame.Size = UDim2.new(1, 0, 0, 0)
	Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	Frame.ClipsDescendants = true
	
	local Corner = Instance.new("UICorner", Frame)
	Corner.CornerRadius = UDim.new(0, 2)
	local Stroke = Instance.new("UIStroke", Frame)
	Stroke.Color = Color3.fromRGB(45, 45, 45)
	
	local Icon = Instance.new("ImageLabel", Frame)
	Icon.AnchorPoint = Vector2.new(0, 0.5)
	Icon.Position = UDim2.new(0, 10, 0.5, 0)
	Icon.Size = UDim2.new(0, 20, 0, 20)
	Icon.BackgroundTransparency = 1
	Icon.Image = iconId
	if string.find(iconId, "headshot") then
		local IconCorner = Instance.new("UICorner", Icon)
		IconCorner.CornerRadius = UDim.new(1, 0)
	end
	
	local Title = Instance.new("TextLabel", Frame)
	Title.Position = UDim2.new(0, 38, 0, 6)
	Title.Size = UDim2.new(1, -44, 0, 16)
	Title.BackgroundTransparency = 1
	Title.Text = titleText
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.Font = Enum.Font.GothamMedium
	Title.TextSize = 12
	Title.TextXAlignment = Enum.TextXAlignment.Left
	
	local SubTitle = Instance.new("TextLabel", Frame)
	SubTitle.Position = UDim2.new(0, 38, 0, 22)
	SubTitle.Size = UDim2.new(1, -44, 0, 14)
	SubTitle.BackgroundTransparency = 1
	SubTitle.Text = subText
	SubTitle.TextColor3 = Color3.fromRGB(140, 140, 140)
	SubTitle.Font = Enum.Font.Gotham
	SubTitle.TextSize = 11
	SubTitle.TextXAlignment = Enum.TextXAlignment.Left
	SubTitle.TextTruncate = Enum.TextTruncate.AtEnd
	
	local ClickBtn = Instance.new("TextButton", Frame)
	ClickBtn.Size = UDim2.new(1, 0, 1, 0)
	ClickBtn.BackgroundTransparency = 1
	ClickBtn.Text = ""
	ClickBtn.MouseButton1Click:Connect(function()
		TextBox.Text = autoFillText
		TextBox:CaptureFocus()
		TextBox.CursorPosition = #TextBox.Text + 1
	end)
	AddTooltip(ClickBtn, "Click to auto-fill")
	
	table.insert(activeSuggestions, Frame)
	pcall(function() TweenService:Create(Frame, smoothTween, {Size = UDim2.new(1, 0, 0, 44)}):Play() end)
end

local function IsCommandMatch(cmd, query)
	if string.sub(cmd.Name, 1, #query) == query then 
		return true, cmd.Name 
	end
	if cmd.Aliases then
		for _, alias in ipairs(cmd.Aliases) do
			if string.sub(alias, 1, #query) == query then 
				return true, alias 
			end
		end
	end
	return false, nil
end

TextBox:GetPropertyChangedSignal("Text"):Connect(function()
	if TextBox.Text == ";" and not isFocused then
		TextBox.Text = ""
	end
	ClearSuggestions()
	if not isFocused then return end
	
	local text = TextBox.Text
	if text == "" then return end
	
	local args = string.split(text, " ")
	local cmdQuery = string.lower(args[1])
	
	if #args == 1 then
		local count = 0
		for _, cmd in ipairs(CommandRegistry) do
			local match, matchStr = IsCommandMatch(cmd, cmdQuery)
			if match then
				if count >= 4 then break end
				CreateSuggestion(MAIN_ICON, matchStr .. " " .. cmd.ArgHint, cmd.Description, matchStr .. " ")
				count += 1
			end
		end
	elseif #args >= 2 then
		local selectedCmd = nil
		for _, cmd in ipairs(CommandRegistry) do
			local match, matchStr = IsCommandMatch(cmd, cmdQuery)
			if match then
				selectedCmd = cmd
				break
			end
		end
		
		if selectedCmd and selectedCmd.ArgType == "player" then
			if #args == 2 then
				local count = 0
				local playerQuery = string.lower(args[2])
				for _, p in ipairs(Players:GetPlayers()) do
					if string.find(string.lower(p.Name), playerQuery) or string.find(string.lower(p.DisplayName), playerQuery) then
						if count >= 4 then break end
						pcall(function()
							local thumb = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
							CreateSuggestion(thumb, p.DisplayName, "@" .. p.Name, args[1] .. " " .. p.Name .. " ")
						end)
						count += 1
					end
				end
			elseif selectedCmd.Name == "locate" and #args == 3 then
				local tQuery = string.lower(args[3])
				if string.sub("true", 1, #tQuery) == tQuery or string.sub("tracer", 1, #tQuery) == tQuery then
					CreateSuggestion(MAIN_ICON, "true", "Enable Tracer", args[1] .. " " .. args[2] .. " true")
				end
			end
		end
	end
end)

TextBox.Focused:Connect(function()
	if not loaded then return end
	isFocused = true
	UpdateUIState()
end)

TextBox.FocusLost:Connect(function(enterPressed)
	isFocused = false
	ClearSuggestions()
	UpdateUIState()
	
	if enterPressed then
		local input = TextBox.Text
		TextBox.Text = ""
		local args = {}
		for arg in string.gmatch(input, "[^%s]+") do
			table.insert(args, arg)
		end
		local cmdQuery = string.lower(args[1] or "")
		if cmdQuery ~= "" then
			local selectedCmd = nil
			for _, cmd in ipairs(CommandRegistry) do
				if cmd.Name == cmdQuery or (cmd.Aliases and table.find(cmd.Aliases, cmdQuery)) then
					selectedCmd = cmd
					break
				end
			end
			if not selectedCmd then
				for _, cmd in ipairs(CommandRegistry) do
					if string.sub(cmd.Name, 1, #cmdQuery) == cmdQuery then
						selectedCmd = cmd
						break
					end
					if cmd.Aliases then
						local foundAlias = false
						for _, alias in ipairs(cmd.Aliases) do
							if string.sub(alias, 1, #cmdQuery) == cmdQuery then
								foundAlias = true
								break
							end
						end
						if foundAlias then
							selectedCmd = cmd
							break
						end
					end
				end
			end
			if selectedCmd then
				pcall(function() selectedCmd.Callback(args) end)
			else
				Notify("Error", "Unknown command: " .. cmdQuery)
			end
		end
	end
end)

keybindConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed or not loaded then return end
	if input.KeyCode == Enum.KeyCode.Semicolon then
		isFocused = true
		if settingsOpen then
			settingsOpen = false
			pcall(function() TweenService:Create(SettingsPanel, smoothTween, {Position = UDim2.new(1, 0, 0, 0)}):Play() end)
		end
		UpdateUIState()
		task.delay(0.01, function()
			TextBox:CaptureFocus()
			if TextBox.Text == ";" then TextBox.Text = "" end
		end)
	end
end)

PopulateCommandList()

local function fetchSources()
	local urlMain = GetGithubFile("main.luau")
	local urlCmds = GetGithubFile("Utils/commands.luau")
	local s1, r1 = pcall(function() return game:HttpGet(urlMain) end)
	local s2, r2 = pcall(function() return game:HttpGet(urlCmds) end)
	return s1 and r1 or "", s2 and r2 or ""
end

local initialMain, initialCmds = fetchSources()

task.spawn(function()
	while task.wait(15) do
		local curMain, curCmds = fetchSources()
		if (curMain ~= "" and curMain ~= initialMain) or (curCmds ~= "" and curCmds ~= initialCmds) then
			local successFn, loadFn = pcall(function() return loadstring(curMain) end)
			if successFn and type(loadFn) == "function" then
				Notify("Update", "Changes have been pulled, now updating...", MAIN_ICON)
				task.wait(2.5)
				
				if tooltipConn then tooltipConn:Disconnect() end
				if suggConn then suggConn:Disconnect() end
				if dragConn then dragConn:Disconnect() end
				if keybindConn then keybindConn:Disconnect() end
				
				if ScreenGui then ScreenGui:Destroy() end
				
				pcall(loadFn)
				break
			else
				initialMain = curMain
				initialCmds = curCmds
			end
		end
	end
end)

task.spawn(function()
	local LoaderPanel = Instance.new("Frame", ScreenGui)
	LoaderPanel.AnchorPoint = Vector2.new(1, 1)
	LoaderPanel.Position = UDim2.new(1, -20, 1, -20)
	LoaderPanel.Size = UDim2.new(0, 280, 0, 80)
	LoaderPanel.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
	LoaderPanel.ClipsDescendants = true
	
	local LCorner = Instance.new("UICorner", LoaderPanel)
	LCorner.CornerRadius = UDim.new(0, 2)
	local LStroke = Instance.new("UIStroke", LoaderPanel)
	LStroke.Color = Color3.fromRGB(45, 45, 45)
	
	local LIcon = Instance.new("ImageLabel", LoaderPanel)
	LIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	LIcon.Position = UDim2.new(0.5, 0, 0.5, -12)
	LIcon.Size = UDim2.new(0, 24, 0, 24)
	LIcon.BackgroundTransparency = 1
	LIcon.Image = MAIN_ICON
	LIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
	LIcon.ImageTransparency = 1
	
	local LCredit1 = Instance.new("TextLabel", LoaderPanel)
	LCredit1.AnchorPoint = Vector2.new(0.5, 0.5)
	LCredit1.Position = UDim2.new(0.5, 0, 0.5, 10)
	LCredit1.Size = UDim2.new(0, 200, 0, 14)
	LCredit1.BackgroundTransparency = 1
	LCredit1.Text = "created by"
	LCredit1.TextColor3 = Color3.fromRGB(150, 150, 150)
	LCredit1.Font = Enum.Font.Gotham
	LCredit1.TextSize = 10
	LCredit1.TextTransparency = 1
	
	local LCredit2 = Instance.new("TextLabel", LoaderPanel)
	LCredit2.AnchorPoint = Vector2.new(0.5, 0.5)
	LCredit2.Position = UDim2.new(0.5, 0, 0.5, 24)
	LCredit2.Size = UDim2.new(0, 200, 0, 14)
	LCredit2.BackgroundTransparency = 1
	LCredit2.Text = "slav / siv / rune"
	LCredit2.TextColor3 = Color3.fromRGB(220, 220, 220)
	LCredit2.Font = Enum.Font.GothamMedium
	LCredit2.TextSize = 12
	LCredit2.TextTransparency = 1

	pcall(function()
		TweenService:Create(LIcon, smoothTween, {ImageTransparency = 0}):Play()
		task.wait(0.4)
		TweenService:Create(LCredit1, smoothTween, {TextTransparency = 0}):Play()
		TweenService:Create(LCredit2, smoothTween, {TextTransparency = 0}):Play()
		task.wait(1.5)
		TweenService:Create(LIcon, smoothTween, {ImageTransparency = 1}):Play()
		TweenService:Create(LCredit1, smoothTween, {TextTransparency = 1}):Play()
		TweenService:Create(LCredit2, smoothTween, {TextTransparency = 1}):Play()
		task.wait(0.3)
		TweenService:Create(LoaderPanel, smoothTween, {Size = UDim2.new(0, 280, 0, 0)}):Play()
		task.wait(0.4)
		LoaderPanel:Destroy()
	end)
	
	loaded = true
	HoverZone.Visible = true
	Watermark.Visible = true
	UpdateUIState()
	Notify("Paper", "Loaded Successfully! Auto-execute enabled.", MAIN_ICON)
end)
