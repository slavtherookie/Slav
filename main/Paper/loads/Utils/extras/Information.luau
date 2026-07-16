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
local slideTween = TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

local MainPanel = Instance.new("Frame")
MainPanel.Parent = ScreenGui
MainPanel.Size = UDim2.new(0, 500, 0, 0)
MainPanel.Position = UDim2.new(0.5, -250, 0.5, -200)
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
TitleLabel.Size = UDim2.new(0, 250, 0, 35)
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
ContentGroup.ClipsDescendants = true

local LoadingFrame = Instance.new("Frame", ContentGroup)
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundTransparency = 1

local Spinner = Instance.new("ImageLabel", LoadingFrame)
Spinner.Size = UDim2.new(0, 30, 0, 30)
Spinner.Position = UDim2.new(0.5, -15, 0.5, -15)
Spinner.BackgroundTransparency = 1
Spinner.Image = "rbxassetid://17687447043"
Spinner.ImageColor3 = Color3.fromRGB(200, 200, 200)

local ViewContainer = Instance.new("Frame", ContentGroup)
ViewContainer.Size = UDim2.new(2, 0, 1, 0)
ViewContainer.Position = UDim2.new(0, 0, 0, 0)
ViewContainer.BackgroundTransparency = 1
ViewContainer.Visible = false

local ProfileView = Instance.new("Frame", ViewContainer)
ProfileView.Size = UDim2.new(0.5, 0, 1, 0)
ProfileView.Position = UDim2.new(0, 0, 0, 0)
ProfileView.BackgroundTransparency = 1

local GroupView = Instance.new("Frame", ViewContainer)
GroupView.Size = UDim2.new(0.5, 0, 1, 0)
GroupView.Position = UDim2.new(0.5, 0, 0, 0)
GroupView.BackgroundTransparency = 1

local AvatarImg = Instance.new("ImageLabel", ProfileView)
AvatarImg.Size = UDim2.new(0, 64, 0, 64)
AvatarImg.Position = UDim2.new(0, 14, 0, 10)
AvatarImg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
AvatarImg.Image = Players:GetUserThumbnailAsync(targetPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)
local AvStroke = Instance.new("UIStroke", AvatarImg)
AvStroke.Color = Color3.fromRGB(45, 45, 45)
AvStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local NameLabel = Instance.new("TextLabel", ProfileView)
NameLabel.Size = UDim2.new(1, -100, 0, 20)
NameLabel.Position = UDim2.new(0, 90, 0, 12)
NameLabel.BackgroundTransparency = 1
NameLabel.Text = targetPlayer.DisplayName
NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NameLabel.Font = Enum.Font.GothamBold
NameLabel.TextSize = 18
NameLabel.TextXAlignment = Enum.TextXAlignment.Left

local UserLabel = Instance.new("TextLabel", ProfileView)
UserLabel.Size = UDim2.new(1, -100, 0, 15)
UserLabel.Position = UDim2.new(0, 90, 0, 36)
UserLabel.BackgroundTransparency = 1
UserLabel.Text = "@" .. targetPlayer.Name
UserLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
UserLabel.Font = Enum.Font.Gotham
UserLabel.TextSize = 12
UserLabel.TextXAlignment = Enum.TextXAlignment.Left

local StatsLabel = Instance.new("TextLabel", ProfileView)
StatsLabel.Size = UDim2.new(1, -100, 0, 15)
StatsLabel.Position = UDim2.new(0, 90, 0, 56)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "Followers: ... | Following: ..."
StatsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatsLabel.Font = Enum.Font.GothamMedium
StatsLabel.TextSize = 11
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left

local AboutTitle = Instance.new("TextLabel", ProfileView)
AboutTitle.Size = UDim2.new(1, -28, 0, 15)
AboutTitle.Position = UDim2.new(0, 14, 0, 90)
AboutTitle.BackgroundTransparency = 1
AboutTitle.Text = "About"
AboutTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
AboutTitle.Font = Enum.Font.GothamBold
AboutTitle.TextSize = 13
AboutTitle.TextXAlignment = Enum.TextXAlignment.Left

local AboutText = Instance.new("TextLabel", ProfileView)
AboutText.Size = UDim2.new(1, -28, 0, 45)
AboutText.Position = UDim2.new(0, 14, 0, 110)
AboutText.BackgroundTransparency = 1
AboutText.Text = "Loading..."
AboutText.TextColor3 = Color3.fromRGB(180, 180, 180)
AboutText.Font = Enum.Font.Gotham
AboutText.TextSize = 11
AboutText.TextXAlignment = Enum.TextXAlignment.Left
AboutText.TextYAlignment = Enum.TextYAlignment.Top
AboutText.TextWrapped = true

local GroupsTitle = Instance.new("TextLabel", ProfileView)
GroupsTitle.Size = UDim2.new(1, -28, 0, 15)
GroupsTitle.Position = UDim2.new(0, 14, 0, 160)
GroupsTitle.BackgroundTransparency = 1
GroupsTitle.Text = "Groups"
GroupsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
GroupsTitle.Font = Enum.Font.GothamBold
GroupsTitle.TextSize = 13
GroupsTitle.TextXAlignment = Enum.TextXAlignment.Left

local GroupsScroll = Instance.new("ScrollingFrame", ProfileView)
GroupsScroll.Size = UDim2.new(1, -16, 1, -185)
GroupsScroll.Position = UDim2.new(0, 8, 0, 180)
GroupsScroll.BackgroundTransparency = 1
GroupsScroll.BorderSizePixel = 0
GroupsScroll.ScrollBarThickness = 2
GroupsScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)

local GroupsListLayout = Instance.new("UIListLayout", GroupsScroll)
GroupsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
GroupsListLayout.Padding = UDim.new(0, 4)
GroupsListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local GvBack = Instance.new("TextButton", GroupView)
GvBack.Size = UDim2.new(0, 60, 0, 24)
GvBack.Position = UDim2.new(0, 14, 0, 10)
GvBack.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
GvBack.Text = "Back"
GvBack.TextColor3 = Color3.fromRGB(200, 200, 200)
GvBack.Font = Enum.Font.GothamMedium
GvBack.TextSize = 12
Instance.new("UICorner", GvBack).CornerRadius = UDim.new(0, 4)
local GvBackStroke = Instance.new("UIStroke", GvBack)
GvBackStroke.Color = Color3.fromRGB(45, 45, 45)
GvBackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local GvIcon = Instance.new("ImageLabel", GroupView)
GvIcon.Size = UDim2.new(0, 64, 0, 64)
GvIcon.Position = UDim2.new(0.5, -32, 0, 45)
GvIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", GvIcon).CornerRadius = UDim.new(0, 6)
local GvIconStroke = Instance.new("UIStroke", GvIcon)
GvIconStroke.Color = Color3.fromRGB(45, 45, 45)
GvIconStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local GvName = Instance.new("TextLabel", GroupView)
GvName.Size = UDim2.new(1, -40, 0, 20)
GvName.Position = UDim2.new(0, 20, 0, 120)
GvName.BackgroundTransparency = 1
GvName.TextColor3 = Color3.fromRGB(255, 255, 255)
GvName.Font = Enum.Font.GothamBold
GvName.TextSize = 16

local GvMembers = Instance.new("TextLabel", GroupView)
GvMembers.Size = UDim2.new(1, -40, 0, 15)
GvMembers.Position = UDim2.new(0, 20, 0, 142)
GvMembers.BackgroundTransparency = 1
GvMembers.TextColor3 = Color3.fromRGB(160, 160, 160)
GvMembers.Font = Enum.Font.GothamMedium
GvMembers.TextSize = 12

local GvDescScroll = Instance.new("ScrollingFrame", GroupView)
GvDescScroll.Size = UDim2.new(1, -28, 1, -175)
GvDescScroll.Position = UDim2.new(0, 14, 0, 165)
GvDescScroll.BackgroundTransparency = 1
GvDescScroll.BorderSizePixel = 0
GvDescScroll.ScrollBarThickness = 2
GvDescScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)

local GvDesc = Instance.new("TextLabel", GvDescScroll)
GvDesc.Size = UDim2.new(1, -10, 0, 0)
GvDesc.BackgroundTransparency = 1
GvDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
GvDesc.Font = Enum.Font.Gotham
GvDesc.TextSize = 11
GvDesc.TextWrapped = true
GvDesc.TextXAlignment = Enum.TextXAlignment.Left
GvDesc.TextYAlignment = Enum.TextYAlignment.Top
GvDesc:GetPropertyChangedSignal("TextBounds"):Connect(function()
	GvDesc.Size = UDim2.new(1, -10, 0, GvDesc.TextBounds.Y)
	GvDescScroll.CanvasSize = UDim2.new(0, 0, 0, GvDesc.TextBounds.Y)
end)

GvBack.MouseEnter:Connect(function() TweenService:Create(GvBack, fastTween, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play() end)
GvBack.MouseLeave:Connect(function() TweenService:Create(GvBack, fastTween, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play() end)

GvBack.MouseButton1Click:Connect(function()
	TweenService:Create(ViewContainer, slideTween, {Position = UDim2.new(0, 0, 0, 0)}):Play()
end)

local isMinimized = false
local isMinimizingAnim = false
local preMinSize = UDim2.new(0, 500, 0, 400)

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
		if v:IsA("TextLabel") or v:IsA("TextButton") then
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

local function getWebData(url)
	local s, r = pcall(function() return game:HttpGet(url) end)
	if s and r then
		local ds, dr = pcall(function() return HttpService:JSONDecode(r) end)
		if ds then return dr end
	end
	return nil
end

local spinConn
spinConn = RunService.RenderStepped:Connect(function()
	if Spinner and Spinner.Parent then
		Spinner.Rotation = Spinner.Rotation + 3
	else
		spinConn:Disconnect()
	end
end)

TweenService:Create(MainPanel, smoothTween, {Size = preMinSize}):Play()

task.spawn(function()
	local uid = targetPlayer.UserId
	local userInfo = getWebData("https://users.roproxy.com/v1/users/" .. uid)
	local followers = getWebData("https://friends.roproxy.com/v1/users/" .. uid .. "/followers/count")
	local following = getWebData("https://friends.roproxy.com/v1/users/" .. uid .. "/followings/count")
	local groups = getWebData("https://groups.roproxy.com/v1/users/" .. uid .. "/groups/roles")

	if followers and following then
		StatsLabel.Text = "Followers: " .. tostring(followers.count) .. " | Following: " .. tostring(following.count)
	else
		StatsLabel.Text = "Followers: N/A | Following: N/A"
	end

	if userInfo and userInfo.description and userInfo.description ~= "" then
		AboutText.Text = userInfo.description
	else
		AboutText.Text = "This user has no description."
	end

	if groups and groups.data then
		for _, g in ipairs(groups.data) do
			local btn = Instance.new("TextButton", GroupsScroll)
			btn.Size = UDim2.new(1, -12, 0, 32)
			btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
			btn.BorderSizePixel = 0
			btn.Text = "  " .. g.group.name
			btn.TextColor3 = Color3.fromRGB(200, 200, 200)
			btn.Font = Enum.Font.GothamMedium
			btn.TextSize = 12
			btn.TextXAlignment = Enum.TextXAlignment.Left

			local btnCorner = Instance.new("UICorner", btn)
			btnCorner.CornerRadius = UDim.new(0, 4)
			
			local btnStroke = Instance.new("UIStroke", btn)
			btnStroke.Color = Color3.fromRGB(40, 40, 40)
			btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

			btn.MouseEnter:Connect(function()
				TweenService:Create(btn, fastTween, {BackgroundColor3 = Color3.fromRGB(25, 25, 25), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
				TweenService:Create(btnStroke, fastTween, {Color = Color3.fromRGB(60, 60, 60)}):Play()
			end)
			
			btn.MouseLeave:Connect(function()
				TweenService:Create(btn, fastTween, {BackgroundColor3 = Color3.fromRGB(18, 18, 18), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
				TweenService:Create(btnStroke, fastTween, {Color = Color3.fromRGB(40, 40, 40)}):Play()
			end)

			btn.MouseButton1Click:Connect(function()
				GvName.Text = g.group.name
				GvMembers.Text = "Members: " .. tostring(g.group.memberCount)
				GvDesc.Text = "Loading description..."
				GvIcon.Image = ""
				TweenService:Create(ViewContainer, slideTween, {Position = UDim2.new(-1, 0, 0, 0)}):Play()

				task.spawn(function()
					local gInfo = getWebData("https://groups.roproxy.com/v1/groups/" .. g.group.id)
					if gInfo then
						GvDesc.Text = gInfo.description or "No description provided."
					else
						GvDesc.Text = "Failed to load description."
					end
					local gIconInfo = getWebData("https://thumbnails.roproxy.com/v1/groups/icons?groupIds=" .. g.group.id .. "&size=150x150&format=Png&isCircular=false")
					if gIconInfo and gIconInfo.data and gIconInfo.data[1] then
						GvIcon.Image = gIconInfo.data[1].imageUrl
					end
				end)
			end)
		end
		GroupsListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			GroupsScroll.CanvasSize = UDim2.new(0, 0, 0, GroupsListLayout.AbsoluteContentSize.Y + 8)
		end)
		GroupsScroll.CanvasSize = UDim2.new(0, 0, 0, GroupsListLayout.AbsoluteContentSize.Y + 8)
	end

	TweenService:Create(Spinner, fastTween, {ImageTransparency = 1}):Play()
	task.wait(0.2)
	LoadingFrame.Visible = false
	ViewContainer.Visible = true
	
	for _, v in ipairs(ProfileView:GetDescendants()) do
		if v:IsA("TextLabel") then
			v.TextTransparency = 1
			TweenService:Create(v, smoothTween, {TextTransparency = 0}):Play()
		elseif v:IsA("ImageLabel") then
			v.ImageTransparency = 1
			TweenService:Create(v, smoothTween, {ImageTransparency = 0}):Play()
		elseif v:IsA("TextButton") then
			v.TextTransparency = 1
			TweenService:Create(v, smoothTween, {TextTransparency = 0}):Play()
		end
	end
end)
