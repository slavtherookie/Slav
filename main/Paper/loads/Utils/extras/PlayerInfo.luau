local targetPlayer = ...
if type(targetPlayer) ~= "userdata" or not targetPlayer:IsA("Player") then return end

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local guiName = "PaperInfoGui_" .. targetPlayer.Name
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
MainPanel.Size = UDim2.new(0, 500, 0, 0)
MainPanel.Position = UDim2.new(0.5, -250, 0.5, -175)
MainPanel.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
MainPanel.ClipsDescendants = true
MainPanel.Active = true
MainPanel.BorderSizePixel = 0

local PanelCorner = Instance.new("UICorner", MainPanel)
PanelCorner.CornerRadius = UDim.new(0, 4)

local PanelStroke = Instance.new("UIStroke", MainPanel)
PanelStroke.Color = Color3.fromRGB(45, 45, 45)
PanelStroke.Thickness = 1
PanelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

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

local TitleLabel = Instance.new("TextLabel", MainPanel)
TitleLabel.Size = UDim2.new(0, 300, 0, 35)
TitleLabel.Position = UDim2.new(0, 14, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Player Info - " .. targetPlayer.DisplayName
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
TitleLabel.Font = Enum.Font.GothamMedium
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 2

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

local ContentGroup = Instance.new("Frame", MainPanel)
ContentGroup.Size = UDim2.new(1, 0, 1, -35)
ContentGroup.Position = UDim2.new(0, 0, 0, 35)
ContentGroup.BackgroundTransparency = 1
ContentGroup.BorderSizePixel = 0
ContentGroup.Visible = false

local LoadingFrame = Instance.new("Frame", MainPanel)
LoadingFrame.Size = UDim2.new(1, 0, 1, -35)
LoadingFrame.Position = UDim2.new(0, 0, 0, 35)
LoadingFrame.BackgroundTransparency = 1

local Spinner = Instance.new("ImageLabel", LoadingFrame)
Spinner.Size = UDim2.new(0, 32, 0, 32)
Spinner.Position = UDim2.new(0.5, -16, 0.5, -16)
Spinner.BackgroundTransparency = 1
Spinner.Image = "rbxassetid://17687447043"
Spinner.ImageColor3 = Color3.fromRGB(200, 200, 200)

local spinConn = RunService.RenderStepped:Connect(function()
	if Spinner and Spinner.Parent then
		Spinner.Rotation = Spinner.Rotation + 3
	else
		if spinConn then spinConn:Disconnect() end
	end
end)

local LeftPanel = Instance.new("Frame", ContentGroup)
LeftPanel.Size = UDim2.new(0, 190, 1, 0)
LeftPanel.Position = UDim2.new(0, 0, 0, 0)
LeftPanel.BackgroundTransparency = 1

local SearchBar = Instance.new("TextBox", LeftPanel)
SearchBar.Size = UDim2.new(1, -24, 0, 28)
SearchBar.Position = UDim2.new(0, 12, 0, 4)
SearchBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
SearchBar.TextColor3 = Color3.fromRGB(220, 220, 220)
SearchBar.PlaceholderText = "Search Groups..."
SearchBar.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
SearchBar.Font = Enum.Font.Gotham
SearchBar.TextSize = 12
SearchBar.Text = ""
SearchBar.TextXAlignment = Enum.TextXAlignment.Left
SearchBar.ClearTextOnFocus = false

local SearchCorner = Instance.new("UICorner", SearchBar)
SearchCorner.CornerRadius = UDim.new(0, 3)
local SearchStroke = Instance.new("UIStroke", SearchBar)
SearchStroke.Color = Color3.fromRGB(40, 40, 40)
SearchStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
local SearchPad = Instance.new("UIPadding", SearchBar)
SearchPad.PaddingLeft = UDim.new(0, 10)
SearchPad.PaddingRight = UDim.new(0, 10)

SearchBar.Focused:Connect(function() TweenService:Create(SearchStroke, fastTween, {Color = Color3.fromRGB(70, 70, 70)}):Play() end)
SearchBar.FocusLost:Connect(function() TweenService:Create(SearchStroke, fastTween, {Color = Color3.fromRGB(40, 40, 40)}):Play() end)

local ListScroll = Instance.new("ScrollingFrame", LeftPanel)
ListScroll.Size = UDim2.new(1, -24, 1, -44)
ListScroll.Position = UDim2.new(0, 12, 0, 40)
ListScroll.BackgroundTransparency = 1
ListScroll.BorderSizePixel = 0
ListScroll.ScrollBarThickness = 0

local ListLayout = Instance.new("UIListLayout", ListScroll)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 2)

ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	ListScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end)

local Separator = Instance.new("Frame", ContentGroup)
Separator.Size = UDim2.new(0, 1, 1, -24)
Separator.Position = UDim2.new(0, 190, 0, 12)
Separator.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Separator.BorderSizePixel = 0

local RightPanel = Instance.new("Frame", ContentGroup)
RightPanel.Size = UDim2.new(1, -191, 1, 0)
RightPanel.Position = UDim2.new(0, 191, 0, 0)
RightPanel.BackgroundTransparency = 1

local ProfileContainer = Instance.new("Frame", RightPanel)
ProfileContainer.Size = UDim2.new(1, 0, 1, 0)
ProfileContainer.BackgroundTransparency = 1

local ProfAvatar = Instance.new("ImageLabel", ProfileContainer)
ProfAvatar.Size = UDim2.new(0, 60, 0, 60)
ProfAvatar.Position = UDim2.new(0, 20, 0, 16)
ProfAvatar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ProfAvatar.Image = Players:GetUserThumbnailAsync(targetPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
Instance.new("UICorner", ProfAvatar).CornerRadius = UDim.new(1, 0)

local ProfName = Instance.new("TextLabel", ProfileContainer)
ProfName.Size = UDim2.new(1, -110, 0, 20)
ProfName.Position = UDim2.new(0, 95, 0, 22)
ProfName.BackgroundTransparency = 1
ProfName.Text = targetPlayer.DisplayName
ProfName.TextColor3 = Color3.fromRGB(255, 255, 255)
ProfName.Font = Enum.Font.GothamBold
ProfName.TextSize = 16
ProfName.TextXAlignment = Enum.TextXAlignment.Left

local ProfUser = Instance.new("TextLabel", ProfileContainer)
ProfUser.Size = UDim2.new(1, -110, 0, 16)
ProfUser.Position = UDim2.new(0, 95, 0, 44)
ProfUser.BackgroundTransparency = 1
ProfUser.Text = "@" .. targetPlayer.Name
ProfUser.TextColor3 = Color3.fromRGB(160, 160, 160)
ProfUser.Font = Enum.Font.Gotham
ProfUser.TextSize = 12
ProfUser.TextXAlignment = Enum.TextXAlignment.Left

local ProfStats = Instance.new("TextLabel", ProfileContainer)
ProfStats.Size = UDim2.new(1, -40, 0, 20)
ProfStats.Position = UDim2.new(0, 20, 0, 90)
ProfStats.BackgroundTransparency = 1
ProfStats.Text = "Followers: 0 | Following: 0"
ProfStats.TextColor3 = Color3.fromRGB(255, 75, 75)
ProfStats.Font = Enum.Font.GothamMedium
ProfStats.TextSize = 12
ProfStats.TextXAlignment = Enum.TextXAlignment.Left

local ProfAboutTitle = Instance.new("TextLabel", ProfileContainer)
ProfAboutTitle.Size = UDim2.new(1, -40, 0, 20)
ProfAboutTitle.Position = UDim2.new(0, 20, 0, 120)
ProfAboutTitle.BackgroundTransparency = 1
ProfAboutTitle.Text = "About Me"
ProfAboutTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
ProfAboutTitle.Font = Enum.Font.GothamBold
ProfAboutTitle.TextSize = 13
ProfAboutTitle.TextXAlignment = Enum.TextXAlignment.Left

local ProfAbout = Instance.new("TextLabel", ProfileContainer)
ProfAbout.Size = UDim2.new(1, -40, 1, -150)
ProfAbout.Position = UDim2.new(0, 20, 0, 145)
ProfAbout.BackgroundTransparency = 1
ProfAbout.Text = "Loading..."
ProfAbout.TextColor3 = Color3.fromRGB(160, 160, 160)
ProfAbout.Font = Enum.Font.Gotham
ProfAbout.TextSize = 12
ProfAbout.TextWrapped = true
ProfAbout.TextXAlignment = Enum.TextXAlignment.Left
ProfAbout.TextYAlignment = Enum.TextYAlignment.Top

local GroupContainer = Instance.new("Frame", RightPanel)
GroupContainer.Size = UDim2.new(1, 0, 1, 0)
GroupContainer.BackgroundTransparency = 1
GroupContainer.Visible = false

local GrpIcon = Instance.new("ImageLabel", GroupContainer)
GrpIcon.Size = UDim2.new(0, 60, 0, 60)
GrpIcon.Position = UDim2.new(0, 20, 0, 16)
GrpIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", GrpIcon).CornerRadius = UDim.new(0, 6)
local GrpIconStroke = Instance.new("UIStroke", GrpIcon)
GrpIconStroke.Color = Color3.fromRGB(45, 45, 45)
GrpIconStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local GrpName = Instance.new("TextLabel", GroupContainer)
GrpName.Size = UDim2.new(1, -110, 0, 20)
GrpName.Position = UDim2.new(0, 95, 0, 22)
GrpName.BackgroundTransparency = 1
GrpName.TextColor3 = Color3.fromRGB(255, 255, 255)
GrpName.Font = Enum.Font.GothamBold
GrpName.TextSize = 15
GrpName.TextXAlignment = Enum.TextXAlignment.Left

local GrpMembers = Instance.new("TextLabel", GroupContainer)
GrpMembers.Size = UDim2.new(1, -110, 0, 16)
GrpMembers.Position = UDim2.new(0, 95, 0, 44)
GrpMembers.BackgroundTransparency = 1
GrpMembers.TextColor3 = Color3.fromRGB(160, 160, 160)
GrpMembers.Font = Enum.Font.Gotham
GrpMembers.TextSize = 12
GrpMembers.TextXAlignment = Enum.TextXAlignment.Left

local GrpRank = Instance.new("TextLabel", GroupContainer)
GrpRank.Size = UDim2.new(1, -40, 0, 20)
GrpRank.Position = UDim2.new(0, 20, 0, 90)
GrpRank.BackgroundTransparency = 1
GrpRank.TextColor3 = Color3.fromRGB(255, 75, 75)
GrpRank.Font = Enum.Font.GothamMedium
GrpRank.TextSize = 12
GrpRank.TextXAlignment = Enum.TextXAlignment.Left

local GrpDescTitle = Instance.new("TextLabel", GroupContainer)
GrpDescTitle.Size = UDim2.new(1, -40, 0, 20)
GrpDescTitle.Position = UDim2.new(0, 20, 0, 120)
GrpDescTitle.BackgroundTransparency = 1
GrpDescTitle.Text = "Description"
GrpDescTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
GrpDescTitle.Font = Enum.Font.GothamBold
GrpDescTitle.TextSize = 13
GrpDescTitle.TextXAlignment = Enum.TextXAlignment.Left

local GrpDescScroll = Instance.new("ScrollingFrame", GroupContainer)
GrpDescScroll.Size = UDim2.new(1, -40, 1, -150)
GrpDescScroll.Position = UDim2.new(0, 20, 0, 145)
GrpDescScroll.BackgroundTransparency = 1
GrpDescScroll.BorderSizePixel = 0
GrpDescScroll.ScrollBarThickness = 2
GrpDescScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)

local GrpDesc = Instance.new("TextLabel", GrpDescScroll)
GrpDesc.Size = UDim2.new(1, -8, 0, 0)
GrpDesc.BackgroundTransparency = 1
GrpDesc.TextColor3 = Color3.fromRGB(160, 160, 160)
GrpDesc.Font = Enum.Font.Gotham
GrpDesc.TextSize = 12
GrpDesc.TextWrapped = true
GrpDesc.TextXAlignment = Enum.TextXAlignment.Left
GrpDesc.TextYAlignment = Enum.TextYAlignment.Top
GrpDesc:GetPropertyChangedSignal("TextBounds"):Connect(function()
	GrpDesc.Size = UDim2.new(1, -8, 0, GrpDesc.TextBounds.Y)
	GrpDescScroll.CanvasSize = UDim2.new(0, 0, 0, GrpDesc.TextBounds.Y)
end)

local currentSelectedBtn = nil

local function createListBtn(name, isProfile, data)
	local btn = Instance.new("TextButton", ListScroll)
	btn.Name = name
	btn.Size = UDim2.new(1, 0, 0, 26)
	btn.BackgroundTransparency = 1
	btn.BorderSizePixel = 0
	btn.Text = "  " .. name
	btn.TextColor3 = Color3.fromRGB(160, 160, 160)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 12
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.AutoButtonColor = false
	
	local Indicator = Instance.new("Frame", btn)
	Indicator.Size = UDim2.new(0, 2, 0, 0)
	Indicator.Position = UDim2.new(0, 0, 0.5, 0)
	Indicator.AnchorPoint = Vector2.new(0, 0.5)
	Indicator.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
	Indicator.BorderSizePixel = 0
	
	btn.MouseEnter:Connect(function()
		if currentSelectedBtn ~= btn then TweenService:Create(btn, fastTween, {TextColor3 = Color3.fromRGB(220, 220, 220)}):Play() end
	end)
	
	btn.MouseLeave:Connect(function()
		if currentSelectedBtn ~= btn then TweenService:Create(btn, fastTween, {TextColor3 = Color3.fromRGB(160, 160, 160)}):Play() end
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
		
		if isProfile then
			GroupContainer.Visible = false
			ProfileContainer.Visible = true
		else
			ProfileContainer.Visible = false
			GroupContainer.Visible = true
			GrpName.Text = data.group.name
			GrpMembers.Text = "Members: " .. tostring(data.group.memberCount)
			GrpRank.Text = "Role: " .. tostring(data.role.name)
			GrpIcon.Image = "rbxthumb://type=GroupIcon&id=" .. data.group.id .. "&w=150&h=150"
			
			GrpDesc.Text = "Loading description..."
			task.spawn(function()
				local s, r = pcall(game.HttpGet, game, "https://groups.roproxy.com/v1/groups/" .. data.group.id)
				if s and r then
					local ds, dt = pcall(HttpService.JSONDecode, HttpService, r)
					if ds and dt and dt.description then
						GrpDesc.Text = dt.description ~= "" and dt.description or "No description provided."
					else
						GrpDesc.Text = "Failed to parse description."
					end
				else
					GrpDesc.Text = "Failed to load description."
				end
			end)
		end
	end)
	
	return btn
end

SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
	local query = string.lower(SearchBar.Text)
	for _, btn in ipairs(ListScroll:GetChildren()) do
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

task.spawn(function()
	local uid = targetPlayer.UserId
	
	local function fetch(url)
		local s, r = pcall(game.HttpGet, game, url)
		if s and r then
			local ds, dt = pcall(HttpService.JSONDecode, HttpService, r)
			if ds then return dt end
		end
		return nil
	end

	local fers = fetch("https://friends.roproxy.com/v1/users/" .. uid .. "/followers/count")
	local fing = fetch("https://friends.roproxy.com/v1/users/" .. uid .. "/followings/count")
	local uInfo = fetch("https://users.roproxy.com/v1/users/" .. uid)
	local gInfo = fetch("https://groups.roproxy.com/v1/users/" .. uid .. "/groups/roles")

	if fers and fing then
		ProfStats.Text = "Followers: " .. tostring(fers.count) .. " | Following: " .. tostring(fing.count)
	end

	if uInfo and uInfo.description then
		ProfAbout.Text = uInfo.description ~= "" and uInfo.description or "No description provided."
	else
		ProfAbout.Text = "Failed to load description."
	end
	
	local profBtn = createListBtn("Profile", true, nil)
	currentSelectedBtn = profBtn
	profBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	profBtn:FindFirstChild("Frame").Size = UDim2.new(0, 2, 0, 14)

	if gInfo and gInfo.data then
		for _, g in ipairs(gInfo.data) do
			if g.group and g.group.name then
				createListBtn(g.group.name, false, g)
			end
		end
	end

	TweenService:Create(Spinner, fastTween, {ImageTransparency = 1}):Play()
	task.wait(0.2)
	if spinConn then spinConn:Disconnect() end
	LoadingFrame.Visible = false
	ContentGroup.Visible = true
	
	for _, v in ipairs(ContentGroup:GetDescendants()) do
		if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
			v.TextTransparency = 1
			TweenService:Create(v, smoothTween, {TextTransparency = 0}):Play()
		elseif v:IsA("ImageLabel") then
			v.ImageTransparency = 1
			TweenService:Create(v, smoothTween, {ImageTransparency = 0}):Play()
		end
	end
end)
