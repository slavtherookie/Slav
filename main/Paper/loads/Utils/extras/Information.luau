local targetPlayer = ...
if not targetPlayer then return end

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Paper_Information_GUI_" .. targetPlayer.Name
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local s, e = pcall(function() screenGui.Parent = CoreGui end)
if not s then screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(40, 40, 40)
stroke.Thickness = 1
stroke.Parent = mainFrame

local topbar = Instance.new("Frame")
topbar.Name = "Topbar"
topbar.Size = UDim2.new(1, 0, 0, 35)
topbar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
topbar.BorderSizePixel = 0
topbar.Parent = mainFrame

local topbarCorner = Instance.new("UICorner")
topbarCorner.CornerRadius = UDim.new(0, 8)
topbarCorner.Parent = topbar

local topbarSquare = Instance.new("Frame")
topbarSquare.Size = UDim2.new(1, 0, 0, 8)
topbarSquare.Position = UDim2.new(0, 0, 1, -8)
topbarSquare.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
topbarSquare.BorderSizePixel = 0
topbarSquare.Parent = topbar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Player Info - " .. targetPlayer.DisplayName
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topbar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = topbar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 35, 0, 35)
minBtn.Position = UDim2.new(1, -70, 0, 0)
minBtn.BackgroundTransparency = 1
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.Parent = topbar

local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, 0, 1, -35)
contentContainer.Position = UDim2.new(0, 0, 0, 35)
contentContainer.BackgroundTransparency = 1
contentContainer.ClipsDescendants = true
contentContainer.Parent = mainFrame

local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.BackgroundTransparency = 1
loadingFrame.Parent = contentContainer

local spinner = Instance.new("ImageLabel")
spinner.Size = UDim2.new(0, 40, 0, 40)
spinner.Position = UDim2.new(0.5, -20, 0.5, -20)
spinner.BackgroundTransparency = 1
spinner.Image = "rbxassetid://17687447043"
spinner.Parent = loadingFrame

local viewContainer = Instance.new("Frame")
viewContainer.Size = UDim2.new(2, 0, 1, 0)
viewContainer.Position = UDim2.new(0, 0, 0, 0)
viewContainer.BackgroundTransparency = 1
viewContainer.Visible = false
viewContainer.Parent = contentContainer

local profileView = Instance.new("Frame")
profileView.Size = UDim2.new(0.5, 0, 1, 0)
profileView.Position = UDim2.new(0, 0, 0, 0)
profileView.BackgroundTransparency = 1
profileView.Parent = viewContainer

local groupView = Instance.new("Frame")
groupView.Size = UDim2.new(0.5, 0, 1, 0)
groupView.Position = UDim2.new(0.5, 0, 0, 0)
groupView.BackgroundTransparency = 1
groupView.Parent = viewContainer

local avatarImg = Instance.new("ImageLabel")
avatarImg.Size = UDim2.new(0, 80, 0, 80)
avatarImg.Position = UDim2.new(0, 15, 0, 15)
avatarImg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
avatarImg.Image = Players:GetUserThumbnailAsync(targetPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
avatarImg.Parent = profileView
local avCorner = Instance.new("UICorner")
avCorner.CornerRadius = UDim.new(1, 0)
avCorner.Parent = avatarImg

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1, -120, 0, 25)
nameLabel.Position = UDim2.new(0, 110, 0, 20)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = targetPlayer.DisplayName
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 20
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Parent = profileView

local userLabel = Instance.new("TextLabel")
userLabel.Size = UDim2.new(1, -120, 0, 15)
userLabel.Position = UDim2.new(0, 110, 0, 45)
userLabel.BackgroundTransparency = 1
userLabel.Text = "@" .. targetPlayer.Name
userLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
userLabel.Font = Enum.Font.Gotham
userLabel.TextSize = 14
userLabel.TextXAlignment = Enum.TextXAlignment.Left
userLabel.Parent = profileView

local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.new(1, -120, 0, 15)
statsLabel.Position = UDim2.new(0, 110, 0, 70)
statsLabel.BackgroundTransparency = 1
statsLabel.Text = "Followers: ... | Following: ..."
statsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statsLabel.Font = Enum.Font.GothamMedium
statsLabel.TextSize = 12
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.Parent = profileView

local aboutTitle = Instance.new("TextLabel")
aboutTitle.Size = UDim2.new(1, -30, 0, 20)
aboutTitle.Position = UDim2.new(0, 15, 0, 110)
aboutTitle.BackgroundTransparency = 1
aboutTitle.Text = "About Me"
aboutTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
aboutTitle.Font = Enum.Font.GothamBold
aboutTitle.TextSize = 14
aboutTitle.TextXAlignment = Enum.TextXAlignment.Left
aboutTitle.Parent = profileView

local aboutText = Instance.new("TextLabel")
aboutText.Size = UDim2.new(1, -30, 0, 60)
aboutText.Position = UDim2.new(0, 15, 0, 135)
aboutText.BackgroundTransparency = 1
aboutText.Text = "Loading..."
aboutText.TextColor3 = Color3.fromRGB(180, 180, 180)
aboutText.Font = Enum.Font.Gotham
aboutText.TextSize = 12
aboutText.TextXAlignment = Enum.TextXAlignment.Left
aboutText.TextYAlignment = Enum.TextYAlignment.Top
aboutText.TextWrapped = true
aboutText.Parent = profileView

local groupsTitle = Instance.new("TextLabel")
groupsTitle.Size = UDim2.new(1, -30, 0, 20)
groupsTitle.Position = UDim2.new(0, 15, 0, 205)
groupsTitle.BackgroundTransparency = 1
groupsTitle.Text = "Groups"
groupsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
groupsTitle.Font = Enum.Font.GothamBold
groupsTitle.TextSize = 14
groupsTitle.TextXAlignment = Enum.TextXAlignment.Left
groupsTitle.Parent = profileView

local groupsScroll = Instance.new("ScrollingFrame")
groupsScroll.Size = UDim2.new(1, -20, 1, -235)
groupsScroll.Position = UDim2.new(0, 10, 0, 230)
groupsScroll.BackgroundTransparency = 1
groupsScroll.BorderSizePixel = 0
groupsScroll.ScrollBarThickness = 4
groupsScroll.Parent = profileView

local groupsList = Instance.new("UIListLayout")
groupsList.SortOrder = Enum.SortOrder.LayoutOrder
groupsList.Padding = UDim.new(0, 5)
groupsList.Parent = groupsScroll

local gvBack = Instance.new("TextButton")
gvBack.Size = UDim2.new(0, 30, 0, 30)
gvBack.Position = UDim2.new(0, 15, 0, 15)
gvBack.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
gvBack.Text = "<"
gvBack.TextColor3 = Color3.fromRGB(255, 255, 255)
gvBack.Font = Enum.Font.GothamBold
gvBack.TextSize = 16
gvBack.Parent = groupView
Instance.new("UICorner", gvBack).CornerRadius = UDim.new(0, 6)

local gvIcon = Instance.new("ImageLabel")
gvIcon.Size = UDim2.new(0, 80, 0, 80)
gvIcon.Position = UDim2.new(0.5, -40, 0, 20)
gvIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
gvIcon.Parent = groupView
Instance.new("UICorner", gvIcon).CornerRadius = UDim.new(0, 8)

local gvName = Instance.new("TextLabel")
gvName.Size = UDim2.new(1, -30, 0, 25)
gvName.Position = UDim2.new(0, 15, 0, 110)
gvName.BackgroundTransparency = 1
gvName.TextColor3 = Color3.fromRGB(255, 255, 255)
gvName.Font = Enum.Font.GothamBold
gvName.TextSize = 18
gvName.Parent = groupView

local gvMembers = Instance.new("TextLabel")
gvMembers.Size = UDim2.new(1, -30, 0, 15)
gvMembers.Position = UDim2.new(0, 15, 0, 140)
gvMembers.BackgroundTransparency = 1
gvMembers.TextColor3 = Color3.fromRGB(200, 200, 200)
gvMembers.Font = Enum.Font.GothamMedium
gvMembers.TextSize = 13
gvMembers.Parent = groupView

local gvDescScroll = Instance.new("ScrollingFrame")
gvDescScroll.Size = UDim2.new(1, -30, 1, -175)
gvDescScroll.Position = UDim2.new(0, 15, 0, 165)
gvDescScroll.BackgroundTransparency = 1
gvDescScroll.BorderSizePixel = 0
gvDescScroll.ScrollBarThickness = 4
gvDescScroll.Parent = groupView

local gvDesc = Instance.new("TextLabel")
gvDesc.Size = UDim2.new(1, -10, 0, 0)
gvDesc.BackgroundTransparency = 1
gvDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
gvDesc.Font = Enum.Font.Gotham
gvDesc.TextSize = 12
gvDesc.TextWrapped = true
gvDesc.TextXAlignment = Enum.TextXAlignment.Left
gvDesc.TextYAlignment = Enum.TextYAlignment.Top
gvDesc.Parent = gvDescScroll
gvDesc:GetPropertyChangedSignal("TextBounds"):Connect(function()
	gvDesc.Size = UDim2.new(1, -10, 0, gvDesc.TextBounds.Y)
	gvDescScroll.CanvasSize = UDim2.new(0, 0, 0, gvDesc.TextBounds.Y)
end)

local isMinimized = false
local isClosed = false
local dragging = false
local dragStart = nil
local startPos = nil

topbar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)

topbar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	if isClosed then return end
	isClosed = true
	TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
	task.wait(0.3)
	screenGui:Destroy()
end)

minBtn.MouseButton1Click:Connect(function()
	if isClosed then return end
	isMinimized = not isMinimized
	if isMinimized then
		TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 35)}):Play()
		minBtn.Text = "+"
	else
		TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 450)}):Play()
		minBtn.Text = "-"
	end
end)

gvBack.MouseButton1Click:Connect(function()
	TweenService:Create(viewContainer, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
end)

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
	if spinner and spinner.Parent then
		spinner.Rotation = spinner.Rotation + 4
	else
		spinConn:Disconnect()
	end
end)

TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 450)}):Play()

task.spawn(function()
	local uid = targetPlayer.UserId
	local userInfo = getWebData("https://users.roproxy.com/v1/users/" .. uid)
	local followers = getWebData("https://friends.roproxy.com/v1/users/" .. uid .. "/followers/count")
	local following = getWebData("https://friends.roproxy.com/v1/users/" .. uid .. "/followings/count")
	local groups = getWebData("https://groups.roproxy.com/v1/users/" .. uid .. "/groups/roles")

	if followers and following then
		statsLabel.Text = "Followers: " .. tostring(followers.count) .. " | Following: " .. tostring(following.count)
	else
		statsLabel.Text = "Followers: N/A | Following: N/A"
	end

	if userInfo and userInfo.description and userInfo.description ~= "" then
		aboutText.Text = userInfo.description
	else
		aboutText.Text = "This user has no description."
	end

	if groups and groups.data then
		for _, g in ipairs(groups.data) do
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -10, 0, 35)
			btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			btn.BorderSizePixel = 0
			btn.Text = "  " .. g.group.name
			btn.TextColor3 = Color3.fromRGB(220, 220, 220)
			btn.Font = Enum.Font.GothamMedium
			btn.TextSize = 13
			btn.TextXAlignment = Enum.TextXAlignment.Left
			btn.Parent = groupsScroll

			local btnCorner = Instance.new("UICorner")
			btnCorner.CornerRadius = UDim.new(0, 6)
			btnCorner.Parent = btn

			btn.MouseButton1Click:Connect(function()
				gvName.Text = g.group.name
				gvMembers.Text = "Members: " .. tostring(g.group.memberCount)
				gvDesc.Text = "Loading description..."
				gvIcon.Image = ""
				TweenService:Create(viewContainer, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Position = UDim2.new(-1, 0, 0, 0)}):Play()

				task.spawn(function()
					local gInfo = getWebData("https://groups.roproxy.com/v1/groups/" .. g.group.id)
					if gInfo then
						gvDesc.Text = gInfo.description or "No description provided."
					else
						gvDesc.Text = "Failed to load description."
					end
					local gIconInfo = getWebData("https://thumbnails.roproxy.com/v1/groups/icons?groupIds=" .. g.group.id .. "&size=150x150&format=Png&isCircular=false")
					if gIconInfo and gIconInfo.data and gIconInfo.data[1] then
						gvIcon.Image = gIconInfo.data[1].imageUrl
					end
				end)
			end)
		end
		groupsScroll.CanvasSize = UDim2.new(0, 0, 0, groupsList.AbsoluteContentSize.Y + 10)
	end

	TweenService:Create(loadingFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
	TweenService:Create(spinner, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
	task.wait(0.3)
	loadingFrame.Visible = false
	viewContainer.Visible = true
end)
