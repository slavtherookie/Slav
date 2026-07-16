local ICONS = {
	Min = "rbxassetid://82235228007110", 
	Expand = "rbxassetid://10684070966", 
	Close = "rbxassetid://10152135063",
	Outgoing = "rbxassetid://87024842547700", 
	Incoming = "rbxassetid://128209045083147",
	Bindable = "rbxassetid://133895839007258",
	Settings = "rbxassetid://113800750269765",
	Clear = "rbxassetid://107722760573482",
	Copy = "rbxassetid://108510339109290",
	Execute = "rbxassetid://75930817388973",
	Search = "rbxassetid://98343851403074",
	Args = "rbxassetid://131328270097325",
	Code = "rbxassetid://120361285964665",
	Info = "rbxassetid://82235228007110",
	Chevron = "rbxassetid://10709790948",
	Menu = "rbxassetid://10620959458",
	Check = "rbxassetid://108792501004149",
	Trash = "rbxassetid://10152135063", 
	Export = "rbxassetid://107722760573482", 
	Decompile = "rbxassetid://120361285964665", 
	Mock = "rbxassetid://75930817388973" 
}

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local teleportFunc = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport) or (getgenv and getgenv().queue_on_teleport)
if teleportFunc then pcall(function() teleportFunc([[task.wait(1)]]) end) end

local guiName = "PaperSpyGui"
local targetGui = pcall(function() return CoreGui.Name end) and CoreGui or LocalPlayer:WaitForChild("PlayerGui")
if targetGui:FindFirstChild(guiName) then targetGui[guiName]:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = targetGui

local smoothTween = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local fastTween = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local Logs = {}
local PendingLogs = {}
local activeTab = "Outgoing"
local searchFilter = ""
local currentHistoryPage = 1
local currentDetailLog = nil

local Settings = {
	CaptureOutgoing = true, CaptureIncoming = true, CaptureBindables = true,
	AutoScroll = true, MaxLogs = 200, VirtualScroll = true, IgnoredRemotes = {}, BlockedRemotes = {}, MockedBindables = {}
}

local NotifContainer = Instance.new("Frame", ScreenGui)
NotifContainer.Size = UDim2.new(0, 240, 1, -40)
NotifContainer.Position = UDim2.new(1, -260, 0, 20)
NotifContainer.BackgroundTransparency = 1
NotifContainer.BorderSizePixel = 0
NotifContainer.ZIndex = 100
local NotifLayout = Instance.new("UIListLayout", NotifContainer)
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 8)

local function SpyNotify(title, text)
	local f = Instance.new("Frame", NotifContainer)
	f.Size = UDim2.new(1, 0, 0, 0)
	f.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	f.BorderSizePixel = 0
	f.ClipsDescendants = true
	Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)
	local s = Instance.new("UIStroke", f)
	s.Color = Color3.fromRGB(50, 50, 50)
	local ic = Instance.new("ImageLabel", f)
	ic.Size = UDim2.new(0, 16, 0, 16)
	ic.Position = UDim2.new(0, 12, 0, 14)
	ic.BackgroundTransparency = 1
	ic.BorderSizePixel = 0
	ic.Image = ICONS.Check
	ic.ImageColor3 = Color3.fromRGB(80, 200, 80)
	local tl = Instance.new("TextLabel", f)
	tl.Size = UDim2.new(1, -40, 0, 16)
	tl.Position = UDim2.new(0, 36, 0, 8)
	tl.BackgroundTransparency = 1
	tl.BorderSizePixel = 0
	tl.Text = title
	tl.TextColor3 = Color3.fromRGB(255, 255, 255)
	tl.Font = Enum.Font.GothamMedium
	tl.TextSize = 13
	tl.TextXAlignment = Enum.TextXAlignment.Left
	local dl = Instance.new("TextLabel", f)
	dl.Size = UDim2.new(1, -40, 0, 14)
	dl.Position = UDim2.new(0, 36, 0, 24)
	dl.BackgroundTransparency = 1
	dl.BorderSizePixel = 0
	dl.Text = text
	dl.TextColor3 = Color3.fromRGB(160, 160, 160)
	dl.Font = Enum.Font.Gotham
	dl.TextSize = 11
	dl.TextXAlignment = Enum.TextXAlignment.Left
	TweenService:Create(f, smoothTween, {Size = UDim2.new(1, 0, 0, 48)}):Play()
	task.delay(2.5, function()
		local t = TweenService:Create(f, smoothTween, {Size = UDim2.new(1, 0, 0, 0)})
		t:Play()
		t.Completed:Connect(function() f:Destroy() end)
	end)
end

local function safeGetName(obj)
	if typeof(obj) ~= "Instance" then return tostring(obj) end
	local success, name = pcall(function() return obj.Name end)
	return success and name or "<Restricted>"
end

local function getInstancePath(obj)
	if typeof(obj) ~= "Instance" then return "nil" end
	if obj == game then return "game" end
	local path = {}
	local current = obj
	while current and current ~= game do
		local success, name = pcall(function() return current.Name end)
		if not success then return "game.<RestrictedPath>" end
		if name:match("^[A-Za-z_][A-Za-z0-9_]*$") then
			table.insert(path, 1, "." .. name)
		else
			table.insert(path, 1, '["' .. name:gsub('"', '\\"') .. '"]')
		end
		local pSuccess, parent = pcall(function() return current.Parent end)
		if pSuccess and parent then current = parent else break end
	end
	local fullPath = "game"
	local pSuccess, pObj = pcall(function() return obj.Parent end)
	local cSuccess, cName = pcall(function() return obj.ClassName end)
	if pSuccess and pObj == game and cSuccess then return 'game:GetService("' .. cName .. '")' end
	if path[1] and path[1]:sub(1, 1) == "." then
		local serviceName = path[1]:sub(2)
		if pcall(function() return game.GetService(game, serviceName) end) then
			path[1] = ':GetService("' .. serviceName .. '")'
		end
	end
	return fullPath .. table.concat(path)
end

function serializeTable(val, depth, maxDepth, visited)
	depth = depth or 0
	maxDepth = maxDepth or 3
	visited = visited or {}

	if type(val) == "string" then 
		return '"' .. val:gsub('"', '\\"') .. '"'
	elseif type(val) == "number" or type(val) == "boolean" then 
		return tostring(val)
	elseif typeof(val) == "Instance" then 
		return getInstancePath(val)
	elseif type(val) == "table" then
		if visited[val] then return "{ [Circular Reference] }" end
		if depth >= maxDepth then return "{...}" end
		visited[val] = true
		local str = "{\n"
		local indent = string.rep("    ", depth + 1)
		for k, v in pairs(val) do
			local keyStr = type(k) == "string" and '["' .. k .. '"]' or "[" .. tostring(k) .. "]"
			str = str .. indent .. keyStr .. " = " .. serializeTable(v, depth + 1, maxDepth, visited) .. ",\n"
		end
		visited[val] = nil
		return str .. string.rep("    ", depth) .. "}"
	elseif typeof(val) == "Vector3" then return string.format("Vector3.new(%s, %s, %s)", tostring(val.X), tostring(val.Y), tostring(val.Z))
	elseif typeof(val) == "Vector2" then return string.format("Vector2.new(%s, %s)", tostring(val.X), tostring(val.Y))
	elseif typeof(val) == "Color3" then return string.format("Color3.new(%s, %s, %s)", tostring(val.R), tostring(val.G), tostring(val.B))
	elseif typeof(val) == "CFrame" then return string.format("CFrame.new(%s)", tostring(val))
	elseif typeof(val) == "EnumItem" then return "Enum." .. tostring(val.EnumType) .. "." .. val.Name
	elseif typeof(val) == "UDim2" then return string.format("UDim2.new(%s, %s, %s, %s)", val.X.Scale, val.X.Offset, val.Y.Scale, val.Y.Offset)
	elseif typeof(val) == "UDim" then return string.format("UDim.new(%s, %s)", val.Scale, val.Offset)
	elseif typeof(val) == "BrickColor" then return string.format("BrickColor.new(\"%s\")", val.Name)
	else return tostring(val) end
end

local MainPanel = Instance.new("Frame")
MainPanel.Parent = ScreenGui
MainPanel.Size = UDim2.new(0, 780, 0, 520)
MainPanel.Position = UDim2.new(0.5, -390, 0.5, -260)
MainPanel.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
MainPanel.ClipsDescendants = true
MainPanel.Active = true
MainPanel.BorderSizePixel = 0
Instance.new("UICorner", MainPanel).CornerRadius = UDim.new(0, 4)

local MainInputBlocker = Instance.new("TextButton", MainPanel)
MainInputBlocker.Size = UDim2.new(1, 0, 1, 0)
MainInputBlocker.BackgroundTransparency = 1
MainInputBlocker.Text = ""
MainInputBlocker.ZIndex = 0
MainInputBlocker.AutoButtonColor = false

local PanelStroke = Instance.new("UIStroke", MainPanel)
PanelStroke.Color = Color3.fromRGB(45, 45, 45)
PanelStroke.Thickness = 1

local TopBarDrag = Instance.new("TextButton", MainPanel)
TopBarDrag.Size = UDim2.new(1, -60, 0, 40)
TopBarDrag.Position = UDim2.new(0, 0, 0, 0)
TopBarDrag.BackgroundTransparency = 1
TopBarDrag.BorderSizePixel = 0
TopBarDrag.Text = ""
TopBarDrag.ZIndex = 10

local dragging, dragInput, dragStart, startPos
TopBarDrag.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true; dragStart = input.Position; startPos = MainPanel.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
TopBarDrag.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		MainPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local ControlsFrame = Instance.new("Frame", MainPanel)
ControlsFrame.Size = UDim2.new(0, 84, 0, 40)
ControlsFrame.Position = UDim2.new(1, -84, 0, 0)
ControlsFrame.BackgroundTransparency = 1
ControlsFrame.BorderSizePixel = 0
ControlsFrame.ZIndex = 11

local function createWinBtn(icon, pos)
	local btn = Instance.new("ImageButton", ControlsFrame)
	btn.Size = UDim2.new(0, 16, 0, 16)
	btn.Position = pos
	btn.AnchorPoint = Vector2.new(0, 0.5)
	btn.BackgroundTransparency = 1
	btn.BorderSizePixel = 0
	btn.Image = icon
	btn.ImageColor3 = Color3.fromRGB(150, 150, 150)
	btn.MouseEnter:Connect(function() TweenService:Create(btn, fastTween, {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play() end)
	btn.MouseLeave:Connect(function() TweenService:Create(btn, fastTween, {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play() end)
	return btn
end

local AdvSearchBtn = createWinBtn(ICONS.Search, UDim2.new(0, 12, 0.5, 0))
local MinBtn = createWinBtn(ICONS.Min, UDim2.new(0, 36, 0.5, 0))
local CloseBtn = createWinBtn(ICONS.Close, UDim2.new(0, 60, 0.5, 0))
CloseBtn.MouseEnter:Connect(function() TweenService:Create(CloseBtn, fastTween, {ImageColor3 = Color3.fromRGB(255, 75, 75)}):Play() end)

-- Unseen logs badge next to search icon
local UnseenBadge = Instance.new("Frame", ControlsFrame)
UnseenBadge.Size = UDim2.new(0, 14, 0, 14)
UnseenBadge.Position = UDim2.new(0, 20, 0, 6)
UnseenBadge.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
UnseenBadge.BorderSizePixel = 0
UnseenBadge.ZIndex = 15
UnseenBadge.Visible = false
Instance.new("UICorner", UnseenBadge).CornerRadius = UDim.new(1, 0)
local UnseenCount = Instance.new("TextLabel", UnseenBadge)
UnseenCount.Size = UDim2.new(1, 0, 1, 0)
UnseenCount.BackgroundTransparency = 1
UnseenCount.Text = "0"
UnseenCount.TextColor3 = Color3.fromRGB(255, 255, 255)
UnseenCount.Font = Enum.Font.GothamBold
UnseenCount.TextSize = 8
UnseenCount.ZIndex = 16

local unseenCount = 0
local function AddUnseen()
	unseenCount = unseenCount + 1
	UnseenCount.Text = unseenCount > 99 and "99+" or tostring(unseenCount)
	UnseenBadge.Visible = true
end
local function ClearUnseen()
	unseenCount = 0
	UnseenBadge.Visible = false
end

local ContentGroup = Instance.new("Frame", MainPanel)
ContentGroup.Size = UDim2.new(1, 0, 1, -85)
ContentGroup.Position = UDim2.new(0, 0, 0, 40)
ContentGroup.BackgroundTransparency = 1
ContentGroup.BorderSizePixel = 0

local BottomNav = Instance.new("Frame", MainPanel)
BottomNav.Size = UDim2.new(1, 0, 0, 45)
BottomNav.Position = UDim2.new(0, 0, 1, -45)
BottomNav.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
BottomNav.BorderSizePixel = 0
BottomNav.ZIndex = 5

local isMinimized = false
local isMinimizingAnim = false
local preMinSize = MainPanel.Size

MinBtn.MouseButton1Click:Connect(function()
	if isMinimizingAnim then return end
	isMinimizingAnim = true
	if isMinimized then
		isMinimized = false
		MinBtn.Image = ICONS.Min
		ContentGroup.Visible = true
		BottomNav.Visible = true
		local t = TweenService:Create(MainPanel, smoothTween, {Size = preMinSize})
		t:Play()
		t.Completed:Connect(function() isMinimizingAnim = false end)
	else
		isMinimized = true
		MinBtn.Image = ICONS.Expand
		preMinSize = MainPanel.Size
		ContentGroup.Visible = false
		BottomNav.Visible = false
		local t = TweenService:Create(MainPanel, smoothTween, {Size = UDim2.new(0, preMinSize.X.Offset, 0, 40)})
		t:Play()
		t.Completed:Connect(function() isMinimizingAnim = false end)
	end
end)

local isClosing = false
CloseBtn.MouseButton1Click:Connect(function()
	if isClosing then return end
	isClosing = true
	local t = TweenService:Create(MainPanel, smoothTween, {Size = UDim2.new(0, preMinSize.X.Offset, 0, 0)})
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
	t:Play()
	task.delay(0.4, function()
		for _, logData in ipairs(Logs) do
			if logData.ui then logData.ui:Destroy(); logData.ui = nil end
		end
		Logs = {}
		PendingLogs = {}
		_G.HookedConns = {}
		ScreenGui:Destroy()
	end)
end)

local TitleIcon = Instance.new("ImageLabel", MainPanel)
TitleIcon.Size = UDim2.new(0, 20, 0, 20)
TitleIcon.Position = UDim2.new(0, 16, 0, 10)
TitleIcon.BackgroundTransparency = 1
TitleIcon.BorderSizePixel = 0
TitleIcon.Image = "rbxassetid://84021105793570"

local TitleLabel = Instance.new("TextLabel", MainPanel)
TitleLabel.Size = UDim2.new(0, 200, 0, 40)
TitleLabel.Position = UDim2.new(0, 44, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.BorderSizePixel = 0
TitleLabel.Text = "PaperSpy"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
TitleLabel.Font = Enum.Font.GothamMedium
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local ActiveNavHighlight = Instance.new("Frame", BottomNav)
ActiveNavHighlight.Size = UDim2.new(0, 40, 0, 2)
ActiveNavHighlight.Position = UDim2.new(0, 0, 0, 0)
ActiveNavHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ActiveNavHighlight.BorderSizePixel = 0

local NavContainer = Instance.new("Frame", BottomNav)
NavContainer.Size = UDim2.new(1, 0, 1, 0)
NavContainer.BackgroundTransparency = 1
NavContainer.BorderSizePixel = 0
local NavLayout = Instance.new("UIListLayout", NavContainer)
NavLayout.FillDirection = Enum.FillDirection.Horizontal
NavLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NavLayout.VerticalAlignment = Enum.VerticalAlignment.Center
NavLayout.Padding = UDim.new(0, 20)
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder

local SearchContainer = Instance.new("Frame", ContentGroup)
SearchContainer.Size = UDim2.new(1, -32, 0, 36)
SearchContainer.Position = UDim2.new(0, 16, 0, 0)
SearchContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
SearchContainer.BorderSizePixel = 0
Instance.new("UICorner", SearchContainer).CornerRadius = UDim.new(0, 4)
local SearchStroke = Instance.new("UIStroke", SearchContainer)
SearchStroke.Color = Color3.fromRGB(40, 40, 40)

local SearchIcon = Instance.new("ImageLabel", SearchContainer)
SearchIcon.Size = UDim2.new(0, 16, 0, 16)
SearchIcon.Position = UDim2.new(0, 12, 0.5, -8)
SearchIcon.BackgroundTransparency = 1
SearchIcon.BorderSizePixel = 0
SearchIcon.Image = ICONS.Search
SearchIcon.ImageColor3 = Color3.fromRGB(120, 120, 120)

local SearchInput = Instance.new("TextBox", SearchContainer)
SearchInput.Size = UDim2.new(1, -40, 1, 0)
SearchInput.Position = UDim2.new(0, 36, 0, 0)
SearchInput.BackgroundTransparency = 1
SearchInput.BorderSizePixel = 0
SearchInput.Text = ""
SearchInput.PlaceholderText = "Filter remotes..."
SearchInput.TextColor3 = Color3.fromRGB(220, 220, 220)
SearchInput.Font = Enum.Font.Gotham
SearchInput.TextSize = 13
SearchInput.TextXAlignment = Enum.TextXAlignment.Left
SearchInput.ClearTextOnFocus = false
SearchInput.Focused:Connect(function() TweenService:Create(SearchStroke, fastTween, {Color = Color3.fromRGB(70, 70, 70)}):Play() end)
SearchInput.FocusLost:Connect(function() TweenService:Create(SearchStroke, fastTween, {Color = Color3.fromRGB(40, 40, 40)}):Play() end)

SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
	searchFilter = SearchInput.Text:lower()
	RefreshLogList()
end)

local LogsArea = Instance.new("Frame", ContentGroup)
LogsArea.Size = UDim2.new(1, 0, 1, -44)
LogsArea.Position = UDim2.new(0, 0, 0, 44)
LogsArea.BackgroundTransparency = 1
LogsArea.BorderSizePixel = 0

local LogsScroll = Instance.new("ScrollingFrame", LogsArea)
LogsScroll.Size = UDim2.new(1, -16, 1, -10)
LogsScroll.Position = UDim2.new(0, 8, 0, 0)
LogsScroll.BackgroundTransparency = 1
LogsScroll.BorderSizePixel = 0
LogsScroll.ScrollBarThickness = 2
LogsScroll.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 70)
local LogsScrollPad = Instance.new("UIPadding", LogsScroll)
LogsScrollPad.PaddingLeft = UDim.new(0, 8)
LogsScrollPad.PaddingRight = UDim.new(0, 8)
LogsScrollPad.PaddingTop = UDim.new(0, 4)
LogsScrollPad.PaddingBottom = UDim.new(0, 4)

local LogsLayout = Instance.new("UIListLayout", LogsScroll)
LogsLayout.SortOrder = Enum.SortOrder.LayoutOrder
LogsLayout.Padding = UDim.new(0, 8)
LogsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	LogsScroll.CanvasSize = UDim2.new(0, 0, 0, LogsLayout.AbsoluteContentSize.Y + 8)
	if Settings.AutoScroll then LogsScroll.CanvasPosition = Vector2.new(0, LogsLayout.AbsoluteContentSize.Y) end
end)

local EmptyState = Instance.new("Frame", LogsArea)
EmptyState.Size = UDim2.new(1, 0, 1, 0)
EmptyState.BackgroundTransparency = 1
EmptyState.BorderSizePixel = 0

local EmptyIcon = Instance.new("ImageLabel", EmptyState)
EmptyIcon.Size = UDim2.new(0, 48, 0, 48)
EmptyIcon.Position = UDim2.new(0.5, -24, 0.5, -40)
EmptyIcon.BackgroundTransparency = 1
EmptyIcon.BorderSizePixel = 0
EmptyIcon.Image = ICONS.Search
EmptyIcon.ImageColor3 = Color3.fromRGB(60, 60, 60)

local EmptyText = Instance.new("TextLabel", EmptyState)
EmptyText.Size = UDim2.new(1, 0, 0, 20)
EmptyText.Position = UDim2.new(0, 0, 0.5, 15)
EmptyText.BackgroundTransparency = 1
EmptyText.BorderSizePixel = 0
EmptyText.Text = "No remotes logged yet"
EmptyText.TextColor3 = Color3.fromRGB(110, 110, 110)
EmptyText.Font = Enum.Font.GothamMedium
EmptyText.TextSize = 13

local ContextMenuBg = Instance.new("TextButton", ScreenGui)
ContextMenuBg.Size = UDim2.new(1, 0, 1, 0)
ContextMenuBg.BackgroundTransparency = 1
ContextMenuBg.BorderSizePixel = 0
ContextMenuBg.Text = ""
ContextMenuBg.ZIndex = 50
ContextMenuBg.Visible = false

local ContextMenu = Instance.new("Frame", ContextMenuBg)
ContextMenu.Size = UDim2.new(0, 180, 0, 0)
ContextMenu.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ContextMenu.BorderSizePixel = 0
ContextMenu.ClipsDescendants = true
ContextMenu.ZIndex = 51
Instance.new("UICorner", ContextMenu).CornerRadius = UDim.new(0, 4)
local ctxStroke = Instance.new("UIStroke", ContextMenu)
ctxStroke.Color = Color3.fromRGB(50, 50, 50)

local ContextLayout = Instance.new("UIListLayout", ContextMenu)
ContextLayout.SortOrder = Enum.SortOrder.LayoutOrder
local ContextPad = Instance.new("UIPadding", ContextMenu)
ContextPad.PaddingTop = UDim.new(0, 4); ContextPad.PaddingBottom = UDim.new(0, 4)

local currentContextLog = nil

local function RefreshFilterLists()
	if not _G.FilterListsUpdated then return end
	_G.FilterListsUpdated()
end

local function CreateContextBtn(text, color, onClick)
	local btn = Instance.new("TextButton", ContextMenu)
	btn.Size = UDim2.new(1, 0, 0, 30)
	btn.BackgroundTransparency = 1
	btn.BorderSizePixel = 0
	btn.Text = ""
	local lbl = Instance.new("TextLabel", btn)
	lbl.Size = UDim2.new(1, -24, 1, 0)
	lbl.Position = UDim2.new(0, 12, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.BorderSizePixel = 0
	lbl.Text = text
	lbl.TextColor3 = color or Color3.fromRGB(220, 220, 220)
	lbl.Font = Enum.Font.GothamMedium
	lbl.TextSize = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	local bg = Instance.new("Frame", btn)
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	bg.BackgroundTransparency = 1
	bg.BorderSizePixel = 0
	bg.ZIndex = 0
	lbl.ZIndex = 2
	btn.MouseEnter:Connect(function() TweenService:Create(bg, fastTween, {BackgroundTransparency = 0}):Play() end)
	btn.MouseLeave:Connect(function() TweenService:Create(bg, fastTween, {BackgroundTransparency = 1}):Play() end)
	btn.MouseButton1Click:Connect(function()
		local t = TweenService:Create(ContextMenu, fastTween, {Size = UDim2.new(0, 180, 0, 0)})
		t:Play()
		t.Completed:Connect(function() ContextMenuBg.Visible = false end)
		if onClick and currentContextLog then onClick(currentContextLog) end
	end)
	return btn
end

CreateContextBtn("Copy Remote Path", nil, function(log) setclipboard(log.path); SpyNotify("Copied", "Remote path copied to clipboard") end)
CreateContextBtn("Copy Caller Script", nil, function(log) setclipboard(log.callerPath); SpyNotify("Copied", "Caller path copied to clipboard") end)
CreateContextBtn("Ignore Remote", nil, function(log) Settings.IgnoredRemotes[log.remote] = true; RefreshFilterLists(); SpyNotify("Ignored", "Remote added to ignore list") end)
CreateContextBtn("Block Remote", nil, function(log) Settings.BlockedRemotes[log.remote] = true; RefreshFilterLists(); SpyNotify("Blocked", "Remote added to block list") end)

ContextMenuBg.MouseButton1Click:Connect(function()
	local t = TweenService:Create(ContextMenu, fastTween, {Size = UDim2.new(0, 180, 0, 0)})
	t:Play()
	t.Completed:Connect(function() ContextMenuBg.Visible = false end)
end)

local function OpenContextMenu(logData)
	currentContextLog = logData
	local mousePos = UserInputService:GetMouseLocation()
	ContextMenuBg.Visible = true
	ContextMenu.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y - 36)
	ContextMenu.Size = UDim2.new(0, 180, 0, 0)
	TweenService:Create(ContextMenu, fastTween, {Size = UDim2.new(0, 180, 0, 128)}):Play()
end

local SettingsArea = Instance.new("ScrollingFrame", ContentGroup)
SettingsArea.Size = UDim2.new(1, -16, 1, -40)
SettingsArea.Position = UDim2.new(0, 8, 0, 40)
SettingsArea.BackgroundTransparency = 1
SettingsArea.BorderSizePixel = 0
SettingsArea.ScrollBarThickness = 2
SettingsArea.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 70)
SettingsArea.Visible = false

local SettingsLayout = Instance.new("UIListLayout", SettingsArea)
SettingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
SettingsLayout.Padding = UDim.new(0, 6)
local SettingsPad = Instance.new("UIPadding", SettingsArea)
SettingsPad.PaddingLeft = UDim.new(0, 8); SettingsPad.PaddingRight = UDim.new(0, 8)
SettingsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	SettingsArea.CanvasSize = UDim2.new(0, 0, 0, SettingsLayout.AbsoluteContentSize.Y + 10)
end)

local function CreateSettingHeader(title)
	local Lbl = Instance.new("TextLabel", SettingsArea)
	Lbl.Size = UDim2.new(1, 0, 0, 30)
	Lbl.BackgroundTransparency = 1
	Lbl.BorderSizePixel = 0
	Lbl.Text = title
	Lbl.TextColor3 = Color3.fromRGB(150, 150, 150)
	Lbl.Font = Enum.Font.GothamMedium
	Lbl.TextSize = 12
	Lbl.TextXAlignment = Enum.TextXAlignment.Left
end

local function CreateSettingToggle(title, settingKey)
	local Card = Instance.new("Frame", SettingsArea)
	Card.Size = UDim2.new(1, 0, 0, 44)
	Card.BackgroundTransparency = 1
	Card.BorderSizePixel = 0
	local Lbl = Instance.new("TextLabel", Card)
	Lbl.Size = UDim2.new(1, -60, 1, 0)
	Lbl.Position = UDim2.new(0, 8, 0, 0)
	Lbl.BackgroundTransparency = 1
	Lbl.BorderSizePixel = 0
	Lbl.Text = title
	Lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
	Lbl.Font = Enum.Font.GothamMedium; Lbl.TextSize = 13
	Lbl.TextXAlignment = Enum.TextXAlignment.Left
	local Toggle = Instance.new("TextButton", Card)
	Toggle.Size = UDim2.new(0, 34, 0, 18)
	Toggle.Position = UDim2.new(1, -42, 0.5, -9)
	Toggle.BackgroundColor3 = Settings[settingKey] and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(200, 80, 80)
	Toggle.BorderSizePixel = 0
	Toggle.Text = ""
	Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)
	local Knob = Instance.new("Frame", Toggle)
	Knob.Size = UDim2.new(0, 14, 0, 14)
	Knob.Position = Settings[settingKey] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
	Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Knob.BorderSizePixel = 0
	Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
	Toggle.MouseButton1Click:Connect(function()
		Settings[settingKey] = not Settings[settingKey]
		TweenService:Create(Toggle, fastTween, {BackgroundColor3 = Settings[settingKey] and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(200, 80, 80)}):Play()
		TweenService:Create(Knob, fastTween, {Position = Settings[settingKey] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
	end)
end

CreateSettingHeader("Capture Options")
CreateSettingToggle("Capture Outgoing (FireServer, InvokeServer)", "CaptureOutgoing")
CreateSettingToggle("Capture Incoming (OnClientEvent)", "CaptureIncoming")
CreateSettingToggle("Capture Bindables (Fire, Invoke)", "CaptureBindables")
CreateSettingHeader("Preferences")
CreateSettingToggle("Auto-Scroll to Bottom", "AutoScroll")
CreateSettingToggle("Virtual Chunk Scroll (clears old frames on scroll for perf)", "VirtualScroll")

CreateSettingHeader("Ignored & Blocked Remotes")

local FilterListContainer = Instance.new("Frame", SettingsArea)
FilterListContainer.Size = UDim2.new(1, 0, 0, 0)
FilterListContainer.AutomaticSize = Enum.AutomaticSize.Y
FilterListContainer.BackgroundTransparency = 1
FilterListContainer.BorderSizePixel = 0
local FilterListLayout = Instance.new("UIListLayout", FilterListContainer)
FilterListLayout.SortOrder = Enum.SortOrder.LayoutOrder
FilterListLayout.Padding = UDim.new(0, 4)

_G.FilterListsUpdated = function()
	for _, child in ipairs(FilterListContainer:GetChildren()) do
		if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end
	end
	local hasAny = false
	local function addFilterRow(remote, listType, dict)
		hasAny = true
		local rPath = getInstancePath(remote)
		local row = Instance.new("Frame", FilterListContainer)
		row.Size = UDim2.new(1, 0, 0, 36)
		row.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		row.BorderSizePixel = 0
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)
		local strk = Instance.new("UIStroke", row)
		strk.Color = Color3.fromRGB(45, 45, 45)
		local lbl = Instance.new("TextLabel", row)
		lbl.Size = UDim2.new(1, -120, 1, 0)
		lbl.Position = UDim2.new(0, 12, 0, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text = rPath
		lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
		lbl.Font = Enum.Font.RobotoMono
		lbl.TextSize = 12
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.TextTruncate = Enum.TextTruncate.AtEnd
		local typeLbl = Instance.new("TextLabel", row)
		typeLbl.Size = UDim2.new(0, 60, 1, 0)
		typeLbl.Position = UDim2.new(1, -100, 0, 0)
		typeLbl.BackgroundTransparency = 1
		typeLbl.Text = listType
		typeLbl.TextColor3 = listType == "Ignored" and Color3.fromRGB(150, 150, 150) or Color3.fromRGB(255, 100, 100)
		typeLbl.Font = Enum.Font.GothamMedium
		typeLbl.TextSize = 11
		local rmBtn = Instance.new("ImageButton", row)
		rmBtn.Size = UDim2.new(0, 20, 0, 20)
		rmBtn.Position = UDim2.new(1, -30, 0.5, -10)
		rmBtn.BackgroundTransparency = 1
		rmBtn.Image = ICONS.Trash
		rmBtn.ImageColor3 = Color3.fromRGB(180, 180, 180)
		rmBtn.MouseButton1Click:Connect(function()
			dict[remote] = nil
			_G.FilterListsUpdated()
		end)
	end
	for remote, _ in pairs(Settings.IgnoredRemotes) do addFilterRow(remote, "Ignored", Settings.IgnoredRemotes) end
	for remote, _ in pairs(Settings.BlockedRemotes) do addFilterRow(remote, "Blocked", Settings.BlockedRemotes) end
	if not hasAny then
		local lbl = Instance.new("TextLabel", FilterListContainer)
		lbl.Size = UDim2.new(1, 0, 0, 30)
		lbl.BackgroundTransparency = 1
		lbl.Text = "No remotes currently filtered."
		lbl.TextColor3 = Color3.fromRGB(100, 100, 100)
		lbl.Font = Enum.Font.Gotham
		lbl.TextSize = 12
		lbl.TextXAlignment = Enum.TextXAlignment.Left
	end
end
_G.FilterListsUpdated()

local navButtons = {}
local function UpdateNavHighlight(btn)
	TweenService:Create(ActiveNavHighlight, fastTween, {
		Size = UDim2.new(0, btn.AbsoluteSize.X, 0, 2),
		Position = UDim2.new(0, btn.AbsolutePosition.X - BottomNav.AbsolutePosition.X, 0, 0)
	}):Play()
end

local CHUNK_SIZE = 30
local visibleChunkEnd = CHUNK_SIZE

local function RebuildLogList()
	for _, child in ipairs(LogsScroll:GetChildren()) do
		if child:IsA("Frame") or child:IsA("TextButton") then child:Destroy() end
	end
	for _, logData in ipairs(Logs) do
		if logData.ui then logData.ui = nil end
	end
end

local function RefreshLogList(resetChunk)
	if resetChunk then visibleChunkEnd = CHUNK_SIZE end
	local logsExist = false
	local filtered = {}
	for _, logData in ipairs(Logs) do
		if logData.type == activeTab then
			if searchFilter == "" or logData.name:lower():find(searchFilter) then
				table.insert(filtered, logData)
			end
		end
	end

	if Settings.VirtualScroll then
		-- Chunk-framer mode: only show up to visibleChunkEnd frames, destroy the rest
		for _, child in ipairs(LogsScroll:GetChildren()) do
			if child:IsA("Frame") or (child:IsA("TextButton") and child.Name == "ShowMoreBtn") then child:Destroy() end
		end
		for _, logData in ipairs(filtered) do logData.ui = nil end

		local endIdx = math.min(#filtered, visibleChunkEnd)
		for i = #filtered, #filtered - endIdx + 1, -1 do
			local logData = filtered[i]
			if not logData.ui then CreateLogUI(logData) end
			logData.ui.Visible = true
			logsExist = true
		end

		-- Show More button if there are more logs above
		if #filtered > visibleChunkEnd then
			local moreBtn = Instance.new("TextButton", LogsScroll)
			moreBtn.Name = "ShowMoreBtn"
			moreBtn.Size = UDim2.new(1, -8, 0, 32); moreBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
			moreBtn.BorderSizePixel = 0; moreBtn.Text = "Show More ("..(#filtered - endIdx).." hidden)"
			moreBtn.TextColor3 = Color3.fromRGB(170, 170, 170); moreBtn.Font = Enum.Font.GothamMedium; moreBtn.TextSize = 12
			moreBtn.AutoButtonColor = false
			Instance.new("UICorner", moreBtn).CornerRadius = UDim.new(0, 4)
			Instance.new("UIStroke", moreBtn).Color = Color3.fromRGB(50, 50, 50)
			moreBtn.LayoutOrder = 0
			moreBtn.MouseEnter:Connect(function() TweenService:Create(moreBtn, fastTween, {BackgroundColor3 = Color3.fromRGB(38, 38, 38)}):Play() end)
			moreBtn.MouseLeave:Connect(function() TweenService:Create(moreBtn, fastTween, {BackgroundColor3 = Color3.fromRGB(28, 28, 28)}):Play() end)
			moreBtn.MouseButton1Click:Connect(function()
				visibleChunkEnd = visibleChunkEnd + CHUNK_SIZE
				RefreshLogList(false)
			end)
		end
	else
		-- Show-More button mode: all frames stay, just hide/show
		for _, child in ipairs(LogsScroll:GetChildren()) do
			if child:IsA("Frame") then child.Visible = false end
		end
		for _, logData in ipairs(filtered) do
			if logData.ui then
				logData.ui.Visible = true
				logsExist = true
			end
		end
	end
	EmptyState.Visible = not logsExist
end

local function SwitchTab(tabName)
	activeTab = tabName
	for name, btnData in pairs(navButtons) do
		local isActive = (name == tabName)
		TweenService:Create(btnData.Icon, fastTween, {ImageColor3 = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 120, 120)}):Play()
		TweenService:Create(btnData.Label, fastTween, {TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 120, 120)}):Play()
		if isActive then UpdateNavHighlight(btnData.Btn) end
	end
	if tabName == "Settings" or tabName == "Export" or tabName == "Clear" then
		SettingsArea.Visible = (tabName == "Settings")
		SearchContainer.Visible = false; LogsArea.Visible = false; EmptyState.Visible = false
	else
		SettingsArea.Visible = false
		SearchContainer.Visible = true; LogsArea.Visible = true
		RefreshLogList(true)
	end
end

local function generateCode(logData, argsData)
	local code = "local Remote = " .. logData.path .. "\n\n"
	code = code .. "local args = " .. serializeTable(argsData or logData.args, 0, 4) .. "\n\n"
	code = code .. "Remote:" .. logData.method .. "(unpack(args))"
	return code
end

local function CreateNavBtn(name, icon, isAction)
	local btn = Instance.new("TextButton", NavContainer)
	btn.Size = UDim2.new(0, 0, 1, 0); btn.AutomaticSize = Enum.AutomaticSize.X
	btn.BackgroundTransparency = 1; btn.BorderSizePixel = 0; btn.Text = ""
	local list = Instance.new("UIListLayout", btn)
	list.FillDirection = Enum.FillDirection.Horizontal; list.VerticalAlignment = Enum.VerticalAlignment.Center; list.Padding = UDim.new(0, 6)
	local icnObj = Instance.new("ImageLabel", btn)
	icnObj.Size = UDim2.new(0, 16, 0, 16); icnObj.BackgroundTransparency = 1; icnObj.BorderSizePixel = 0
	icnObj.Image = icon; icnObj.ImageColor3 = Color3.fromRGB(120, 120, 120)
	local lblObj = Instance.new("TextLabel", btn)
	lblObj.Size = UDim2.new(0, 0, 1, 0); lblObj.AutomaticSize = Enum.AutomaticSize.X
	lblObj.BackgroundTransparency = 1; lblObj.BorderSizePixel = 0; lblObj.Text = name
	lblObj.TextColor3 = Color3.fromRGB(120, 120, 120); lblObj.Font = Enum.Font.GothamMedium; lblObj.TextSize = 13
	btn.MouseButton1Click:Connect(function()
		if isAction then
			if name == "Clear" then
				for _, log in ipairs(Logs) do if log.ui then log.ui:Destroy() end end
				Logs = {}; RefreshLogList()
				SpyNotify("Cleared", "All logs have been cleared")
			elseif name == "Export" then
				if writefile then
					local fileContent = "-- Generated by PaperSpy\n\n"
					for _, log in ipairs(Logs) do
						fileContent = fileContent .. string.format("-- Remote: %s | Call Count: %d\n", log.path, log.count)
						fileContent = fileContent .. generateCode(log, log.args) .. "\n\n"
					end
					local fileName = string.format("PaperSpy_Export_%d.lua", os.time())
					local success, err = pcall(writefile, fileName, fileContent)
					if success then SpyNotify("Exported", "Saved to workspace/" .. fileName) else SpyNotify("Error", "Failed to save file") end
				else
					SpyNotify("Error", "Executor does not support writefile")
				end
			end
		else SwitchTab(name) end
	end)
	if not isAction then navButtons[name] = {Btn = btn, Icon = icnObj, Label = lblObj} end
end

CreateNavBtn("Outgoing", ICONS.Outgoing, false)
CreateNavBtn("Incoming", ICONS.Incoming, false)
CreateNavBtn("Bindables", ICONS.Bindable, false)
CreateNavBtn("Settings", ICONS.Settings, false)
local exportPad = Instance.new("Frame", NavContainer)
exportPad.Size = UDim2.new(0, 10, 1, 0); exportPad.BackgroundTransparency = 1; exportPad.BorderSizePixel = 0
CreateNavBtn("Export", ICONS.Export, true)
CreateNavBtn("Clear", ICONS.Clear, true)

local DetailModal = Instance.new("CanvasGroup", MainPanel)
DetailModal.Size = UDim2.new(1, 0, 1, -40)
DetailModal.Position = UDim2.new(0, 0, 1, 0)
DetailModal.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
DetailModal.BorderSizePixel = 0
DetailModal.ZIndex = 20
DetailModal.Visible = false
DetailModal.ClipsDescendants = true
Instance.new("UIStroke", DetailModal).Color = Color3.fromRGB(45, 45, 45)

local DetailInputBlocker = Instance.new("TextButton", DetailModal)
DetailInputBlocker.Size = UDim2.new(1, 0, 1, 0)
DetailInputBlocker.BackgroundTransparency = 1
DetailInputBlocker.Text = ""
DetailInputBlocker.ZIndex = 0
DetailInputBlocker.AutoButtonColor = false

local DetailHeader = Instance.new("Frame", DetailModal)
DetailHeader.Size = UDim2.new(1, 0, 0, 45)
DetailHeader.BackgroundTransparency = 1
DetailHeader.BorderSizePixel = 0

local DetailIcon = Instance.new("ImageLabel", DetailHeader)
DetailIcon.Size = UDim2.new(0, 16, 0, 16)
DetailIcon.AnchorPoint = Vector2.new(0, 0.5)
DetailIcon.Position = UDim2.new(0, 16, 0.5, 0)
DetailIcon.BackgroundTransparency = 1
DetailIcon.BorderSizePixel = 0

local DetailTitle = Instance.new("TextLabel", DetailHeader)
DetailTitle.Size = UDim2.new(1, -80, 1, 0)
DetailTitle.AnchorPoint = Vector2.new(0, 0.5)
DetailTitle.Position = UDim2.new(0, 40, 0.5, 0)
DetailTitle.BackgroundTransparency = 1
DetailTitle.BorderSizePixel = 0
DetailTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
DetailTitle.Font = Enum.Font.GothamMedium
DetailTitle.TextSize = 14
DetailTitle.TextXAlignment = Enum.TextXAlignment.Left

local isDetailOpen = false
local DetailCloseBtn = Instance.new("ImageButton", DetailHeader)
DetailCloseBtn.Size = UDim2.new(0, 24, 0, 24)
DetailCloseBtn.AnchorPoint = Vector2.new(1, 0.5)
DetailCloseBtn.Position = UDim2.new(1, -12, 0.5, 0)
DetailCloseBtn.BackgroundTransparency = 1
DetailCloseBtn.BorderSizePixel = 0
DetailCloseBtn.Image = ICONS.Close
DetailCloseBtn.ImageColor3 = Color3.fromRGB(140, 140, 140)
DetailCloseBtn.ZIndex = 25
DetailCloseBtn.MouseButton1Click:Connect(function() 
	isDetailOpen = false
	local t = TweenService:Create(DetailModal, smoothTween, {Position = UDim2.new(0, 0, 1, 0)})
	t:Play()
	t.Completed:Connect(function() if not isDetailOpen then DetailModal.Visible = false end end)
end)

local DetailTabs = Instance.new("Frame", DetailModal)
DetailTabs.Size = UDim2.new(1, 0, 0, 36)
DetailTabs.Position = UDim2.new(0, 0, 0, 45)
DetailTabs.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
DetailTabs.BorderSizePixel = 0

local ActiveDetailHighlight = Instance.new("Frame", DetailTabs)
ActiveDetailHighlight.Size = UDim2.new(0, 40, 0, 2)
ActiveDetailHighlight.Position = UDim2.new(0, 0, 1, -2)
ActiveDetailHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ActiveDetailHighlight.BorderSizePixel = 0
ActiveDetailHighlight.ZIndex = 5

local DetailTabsContainer = Instance.new("Frame", DetailTabs)
DetailTabsContainer.Size = UDim2.new(1, 0, 1, 0)
DetailTabsContainer.BackgroundTransparency = 1
DetailTabsContainer.BorderSizePixel = 0
local DetailTabsLayout = Instance.new("UIListLayout", DetailTabsContainer)
DetailTabsLayout.FillDirection = Enum.FillDirection.Horizontal
DetailTabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
DetailTabsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
DetailTabsLayout.Padding = UDim.new(0, 24)
local DetailTabsPad = Instance.new("UIPadding", DetailTabsContainer)
DetailTabsPad.PaddingLeft = UDim.new(0, 16)

local DetailContent = Instance.new("Frame", DetailModal)
DetailContent.Size = UDim2.new(1, 0, 1, -125)
DetailContent.Position = UDim2.new(0, 0, 0, 81)
DetailContent.BackgroundTransparency = 1
DetailContent.BorderSizePixel = 0
DetailContent.ClipsDescendants = true

local ArgsContainer = Instance.new("Frame", DetailContent)
ArgsContainer.Size = UDim2.new(1, 0, 1, 0)
ArgsContainer.BackgroundTransparency = 1
ArgsContainer.BorderSizePixel = 0

local ArgsScroll = Instance.new("ScrollingFrame", ArgsContainer)
ArgsScroll.Size = UDim2.new(1, -16, 1, -44)
ArgsScroll.Position = UDim2.new(0, 8, 0, 8)
ArgsScroll.BackgroundTransparency = 1
ArgsScroll.BorderSizePixel = 0
ArgsScroll.ScrollBarThickness = 2
ArgsScroll.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 70)
local ArgsLayout = Instance.new("UIListLayout", ArgsScroll)
ArgsLayout.SortOrder = Enum.SortOrder.LayoutOrder; ArgsLayout.Padding = UDim.new(0, 6)
local ArgsScrollPad = Instance.new("UIPadding", ArgsScroll)
ArgsScrollPad.PaddingRight = UDim.new(0, 8); ArgsScrollPad.PaddingLeft = UDim.new(0, 2)
ArgsScrollPad.PaddingTop = UDim.new(0, 4); ArgsScrollPad.PaddingBottom = UDim.new(0, 4)

local ArgsPagination = Instance.new("Frame", ArgsContainer)
ArgsPagination.Size = UDim2.new(1, 0, 0, 36)
ArgsPagination.Position = UDim2.new(0, 0, 1, -36)
ArgsPagination.BackgroundTransparency = 1
ArgsPagination.BorderSizePixel = 0

local PaginationLayout = Instance.new("UIListLayout", ArgsPagination)
PaginationLayout.FillDirection = Enum.FillDirection.Horizontal
PaginationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
PaginationLayout.VerticalAlignment = Enum.VerticalAlignment.Center
PaginationLayout.Padding = UDim.new(0, 20)

local function createPageBtn(text)
	local btn = Instance.new("TextButton", ArgsPagination)
	btn.Size = UDim2.new(0, 50, 0, 28)
	btn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = Color3.fromRGB(45, 45, 45)
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(200, 200, 200)
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 13
	return btn
end

local PrevPageBtn = createPageBtn("Prev")
local PageLabel = Instance.new("TextLabel", ArgsPagination)
PageLabel.Size = UDim2.new(0, 60, 1, 0)
PageLabel.BackgroundTransparency = 1
PageLabel.BorderSizePixel = 0
PageLabel.Text = "1 / 1"
PageLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
PageLabel.Font = Enum.Font.GothamMedium
PageLabel.TextSize = 13
local NextPageBtn = createPageBtn("Next")

local CodeContainer = Instance.new("Frame", DetailContent)
CodeContainer.Size = UDim2.new(1, -16, 1, -16)
CodeContainer.Position = UDim2.new(0, 8, 0, 8)
CodeContainer.BackgroundTransparency = 1
CodeContainer.BorderSizePixel = 0
CodeContainer.Visible = false

local InfoScroll = Instance.new("ScrollingFrame", DetailContent)
InfoScroll.Size = UDim2.new(1, -16, 1, -16)
InfoScroll.Position = UDim2.new(0, 8, 0, 8)
InfoScroll.BackgroundTransparency = 1
InfoScroll.BorderSizePixel = 0
InfoScroll.ScrollBarThickness = 2
InfoScroll.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 70)
InfoScroll.Visible = false
local InfoLayout = Instance.new("UIListLayout", InfoScroll)
InfoLayout.SortOrder = Enum.SortOrder.LayoutOrder; InfoLayout.Padding = UDim.new(0, 6)
local InfoPad = Instance.new("UIPadding", InfoScroll)
InfoPad.PaddingLeft = UDim.new(0, 4); InfoPad.PaddingRight = UDim.new(0, 8)
InfoPad.PaddingTop = UDim.new(0, 4); InfoPad.PaddingBottom = UDim.new(0, 4)

local MockOverlay = Instance.new("Frame", DetailModal)
MockOverlay.Size = UDim2.new(1, 0, 1, 0)
MockOverlay.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MockOverlay.BorderSizePixel = 0
MockOverlay.ZIndex = 50
MockOverlay.Visible = false
Instance.new("UICorner", MockOverlay).CornerRadius = UDim.new(0, 6)

local MockTitle = Instance.new("TextLabel", MockOverlay)
MockTitle.Size = UDim2.new(1, -20, 0, 30); MockTitle.Position = UDim2.new(0, 10, 0, 10)
MockTitle.BackgroundTransparency = 1; MockTitle.Text = "Mock Bindable Return Data"
MockTitle.TextColor3 = Color3.fromRGB(240, 240, 240); MockTitle.Font = Enum.Font.GothamBold
MockTitle.TextSize = 14; MockTitle.TextXAlignment = Enum.TextXAlignment.Left; MockTitle.ZIndex = 51

local MockCloseBtn = Instance.new("ImageButton", MockOverlay)
MockCloseBtn.Size = UDim2.new(0, 20, 0, 20); MockCloseBtn.Position = UDim2.new(1, -30, 0, 15)
MockCloseBtn.BackgroundTransparency = 1; MockCloseBtn.Image = ICONS.Close
MockCloseBtn.ImageColor3 = Color3.fromRGB(150, 150, 150); MockCloseBtn.ZIndex = 51

local MockTextBox = Instance.new("TextBox", MockOverlay)
MockTextBox.Size = UDim2.new(1, -20, 1, -100); MockTextBox.Position = UDim2.new(0, 10, 0, 45)
MockTextBox.BackgroundColor3 = Color3.fromRGB(22, 22, 22); MockTextBox.BorderSizePixel = 0
MockTextBox.TextColor3 = Color3.fromRGB(200, 240, 150); MockTextBox.Font = Enum.Font.RobotoMono
MockTextBox.TextSize = 13; MockTextBox.TextXAlignment = Enum.TextXAlignment.Left; MockTextBox.TextYAlignment = Enum.TextYAlignment.Top
MockTextBox.ClearTextOnFocus = false; MockTextBox.MultiLine = true
MockTextBox.ZIndex = 51
Instance.new("UICorner", MockTextBox).CornerRadius = UDim.new(0, 4)
local MockTextPad = Instance.new("UIPadding", MockTextBox)
MockTextPad.PaddingTop = UDim.new(0, 8); MockTextPad.PaddingLeft = UDim.new(0, 8)
MockTextPad.PaddingRight = UDim.new(0, 8); MockTextPad.PaddingBottom = UDim.new(0, 8)

local MockSaveBtn = Instance.new("TextButton", MockOverlay)
MockSaveBtn.Size = UDim2.new(0.5, -15, 0, 32); MockSaveBtn.Position = UDim2.new(0, 10, 1, -42)
MockSaveBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 200); MockSaveBtn.BorderSizePixel = 0
MockSaveBtn.Text = "Save Mock"; MockSaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MockSaveBtn.Font = Enum.Font.GothamMedium; MockSaveBtn.TextSize = 13; MockSaveBtn.ZIndex = 51
Instance.new("UICorner", MockSaveBtn).CornerRadius = UDim.new(0, 4)

local MockClearBtn = Instance.new("TextButton", MockOverlay)
MockClearBtn.Size = UDim2.new(0.5, -15, 0, 32); MockClearBtn.Position = UDim2.new(0.5, 5, 1, -42)
MockClearBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50); MockClearBtn.BorderSizePixel = 0
MockClearBtn.Text = "Clear Mock"; MockClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MockClearBtn.Font = Enum.Font.GothamMedium; MockClearBtn.TextSize = 13; MockClearBtn.ZIndex = 51
Instance.new("UICorner", MockClearBtn).CornerRadius = UDim.new(0, 4)

MockCloseBtn.MouseButton1Click:Connect(function() MockOverlay.Visible = false end)

MockSaveBtn.MouseButton1Click:Connect(function()
	if currentDetailLog and currentDetailLog.remote then
		Settings.MockedBindables[currentDetailLog.remote] = MockTextBox.Text
		MockOverlay.Visible = false
		SpyNotify("Saved", "Mock data saved for this bindable")
	end
end)

MockClearBtn.MouseButton1Click:Connect(function()
	if currentDetailLog and currentDetailLog.remote then
		Settings.MockedBindables[currentDetailLog.remote] = nil
		MockOverlay.Visible = false
		SpyNotify("Cleared", "Mock data cleared for this bindable")
	end
end)

-- Advanced Search Modal --
local isAdvSearchOpen = false
local AdvSearchModal = Instance.new("CanvasGroup", MainPanel)
AdvSearchModal.Size = UDim2.new(1, 0, 1, -40)
AdvSearchModal.Position = UDim2.new(0, 0, 1, 0)
AdvSearchModal.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
AdvSearchModal.BorderSizePixel = 0
AdvSearchModal.ZIndex = 30
AdvSearchModal.Visible = false
Instance.new("UIStroke", AdvSearchModal).Color = Color3.fromRGB(45, 45, 45)

local AdvInputBlocker = Instance.new("TextButton", AdvSearchModal)
AdvInputBlocker.Size = UDim2.new(1, 0, 1, 0)
AdvInputBlocker.BackgroundTransparency = 1
AdvInputBlocker.Text = ""
AdvInputBlocker.ZIndex = 0
AdvInputBlocker.AutoButtonColor = false

local AdvHeader = Instance.new("Frame", AdvSearchModal)
AdvHeader.Size = UDim2.new(1, 0, 0, 45)
AdvHeader.BackgroundTransparency = 1
AdvHeader.BorderSizePixel = 0

local AdvTitle = Instance.new("TextLabel", AdvHeader)
AdvTitle.Size = UDim2.new(1, -60, 1, 0)
AdvTitle.Position = UDim2.new(0, 16, 0, 0)
AdvTitle.BackgroundTransparency = 1
AdvTitle.Text = "Advanced Search"
AdvTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
AdvTitle.Font = Enum.Font.GothamMedium
AdvTitle.TextSize = 14
AdvTitle.TextXAlignment = Enum.TextXAlignment.Left

local AdvCloseBtn = Instance.new("ImageButton", AdvHeader)
AdvCloseBtn.Size = UDim2.new(0, 24, 0, 24)
AdvCloseBtn.AnchorPoint = Vector2.new(1, 0.5)
AdvCloseBtn.Position = UDim2.new(1, -12, 0.5, 0)
AdvCloseBtn.BackgroundTransparency = 1
AdvCloseBtn.Image = ICONS.Close
AdvCloseBtn.ImageColor3 = Color3.fromRGB(140, 140, 140)
AdvCloseBtn.ZIndex = 35

local AdvSearchBoxFrame = Instance.new("Frame", AdvSearchModal)
AdvSearchBoxFrame.Size = UDim2.new(1, -32, 0, 32)
AdvSearchBoxFrame.Position = UDim2.new(0, 16, 0, 45)
AdvSearchBoxFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
AdvSearchBoxFrame.BorderSizePixel = 0
Instance.new("UICorner", AdvSearchBoxFrame).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", AdvSearchBoxFrame).Color = Color3.fromRGB(45, 45, 45)

local AdvSearchIcon = Instance.new("ImageLabel", AdvSearchBoxFrame)
AdvSearchIcon.Size = UDim2.new(0, 14, 0, 14); AdvSearchIcon.Position = UDim2.new(0, 10, 0.5, -7)
AdvSearchIcon.BackgroundTransparency = 1; AdvSearchIcon.Image = ICONS.Search
AdvSearchIcon.ImageColor3 = Color3.fromRGB(120, 120, 120)

local AdvSearchInput = Instance.new("TextBox", AdvSearchBoxFrame)
AdvSearchInput.Size = UDim2.new(1, -40, 1, 0); AdvSearchInput.Position = UDim2.new(0, 32, 0, 0)
AdvSearchInput.BackgroundTransparency = 1; AdvSearchInput.Text = ""
AdvSearchInput.PlaceholderText = "Filter by remote name or caller path..."
AdvSearchInput.TextColor3 = Color3.fromRGB(220, 220, 220); AdvSearchInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
AdvSearchInput.Font = Enum.Font.GothamMedium; AdvSearchInput.TextSize = 12
AdvSearchInput.TextXAlignment = Enum.TextXAlignment.Left; AdvSearchInput.ClearTextOnFocus = false

local AdvTabs = Instance.new("Frame", AdvSearchModal)
AdvTabs.Size = UDim2.new(1, 0, 0, 36)
AdvTabs.Position = UDim2.new(0, 0, 0, 85)
AdvTabs.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
AdvTabs.BorderSizePixel = 0

local AdvHighlight = Instance.new("Frame", AdvTabs)
AdvHighlight.Size = UDim2.new(0, 40, 0, 2)
AdvHighlight.Position = UDim2.new(0, 0, 1, -2)
AdvHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AdvHighlight.BorderSizePixel = 0
AdvHighlight.ZIndex = 5

local AdvTabsContainer = Instance.new("Frame", AdvTabs)
AdvTabsContainer.Size = UDim2.new(1, 0, 1, 0); AdvTabsContainer.BackgroundTransparency = 1
local AdvTabsLayout = Instance.new("UIListLayout", AdvTabsContainer)
AdvTabsLayout.FillDirection = Enum.FillDirection.Horizontal; AdvTabsLayout.VerticalAlignment = Enum.VerticalAlignment.Center; AdvTabsLayout.Padding = UDim.new(0, 24)
local AdvTabsPad = Instance.new("UIPadding", AdvTabsContainer)
AdvTabsPad.PaddingLeft = UDim.new(0, 16)

local AdvScroll = Instance.new("ScrollingFrame", AdvSearchModal)
AdvScroll.Size = UDim2.new(1, -16, 1, -135)
AdvScroll.Position = UDim2.new(0, 8, 0, 125)
AdvScroll.BackgroundTransparency = 1
AdvScroll.BorderSizePixel = 0
AdvScroll.ScrollBarThickness = 2
AdvScroll.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 70)

local AdvScrollLayout = Instance.new("UIListLayout", AdvScroll)
AdvScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder; AdvScrollLayout.Padding = UDim.new(0, 4)
local AdvScrollPad = Instance.new("UIPadding", AdvScroll)
AdvScrollPad.PaddingRight = UDim.new(0, 8); AdvScrollPad.PaddingLeft = UDim.new(0, 2); AdvScrollPad.PaddingTop = UDim.new(0, 2)

local AdvEmptyState = Instance.new("TextLabel", AdvScroll)
AdvEmptyState.Size = UDim2.new(1, 0, 1, 0); AdvEmptyState.BackgroundTransparency = 1
AdvEmptyState.Text = "No remotes match this filter"
AdvEmptyState.TextColor3 = Color3.fromRGB(120, 120, 120); AdvEmptyState.Font = Enum.Font.GothamMedium
AdvEmptyState.TextSize = 14; AdvEmptyState.Visible = false

local advTabButtons = {}
local activeAdvTab = "All"
local advSearchText = ""

local function UpdateAdvHighlight(btn)
	TweenService:Create(AdvHighlight, fastTween, {
		Size = UDim2.new(0, btn.AbsoluteSize.X, 0, 2),
		Position = UDim2.new(0, btn.AbsolutePosition.X - AdvTabs.AbsolutePosition.X, 1, -2)
	}):Play()
end

local function CreateAdvTab(name)
	local btn = Instance.new("TextButton", AdvTabsContainer)
	btn.Size = UDim2.new(0, 0, 1, -2); btn.AutomaticSize = Enum.AutomaticSize.X; btn.BackgroundTransparency = 1; btn.Text = ""
	local lbl = Instance.new("TextLabel", btn)
	lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1
	lbl.Text = name; lbl.TextColor3 = Color3.fromRGB(120, 120, 120); lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 13
	advTabButtons[name] = {Btn = btn, Label = lbl}
end

CreateAdvTab("All")
CreateAdvTab("Outgoing")
CreateAdvTab("Incoming")
CreateAdvTab("Bindables")
CreateAdvTab("Kicks")

local function RefreshAdvancedSearch()
	for _, child in ipairs(AdvScroll:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end
	local count = 0
	for _, logData in ipairs(Logs) do
		local matchTab = (activeAdvTab == "All" or logData.type == activeAdvTab)
		local matchText = true
		if advSearchText ~= "" then
			local t = advSearchText:lower()
			if not (logData.name:lower():find(t) or (logData.callerPath and logData.callerPath:lower():find(t))) then
				matchText = false
			end
		end
		
		if matchTab and matchText then
			count = count + 1
			local row = Instance.new("TextButton", AdvScroll)
			row.Size = UDim2.new(1, 0, 0, 46); row.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
			row.BorderSizePixel = 0; row.AutoButtonColor = false; row.Text = ""
			Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)
			local rowStroke = Instance.new("UIStroke", row)
			rowStroke.Color = Color3.fromRGB(45, 45, 45)
			rowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			
			local titleLbl = Instance.new("TextLabel", row)
			titleLbl.Size = UDim2.new(1, -120, 0, 20); titleLbl.Position = UDim2.new(0, 12, 0, 6)
			titleLbl.BackgroundTransparency = 1; titleLbl.Text = logData.name
			titleLbl.TextColor3 = Color3.fromRGB(220, 220, 220); titleLbl.Font = Enum.Font.GothamMedium
			titleLbl.TextSize = 13; titleLbl.TextXAlignment = Enum.TextXAlignment.Left; titleLbl.TextTruncate = Enum.TextTruncate.AtEnd
			
			local pathLbl = Instance.new("TextLabel", row)
			pathLbl.Size = UDim2.new(1, -120, 0, 14); pathLbl.Position = UDim2.new(0, 12, 0, 26)
			pathLbl.BackgroundTransparency = 1; pathLbl.Text = logData.callerPath or "Unknown Caller"
			pathLbl.TextColor3 = Color3.fromRGB(120, 120, 120); pathLbl.Font = Enum.Font.RobotoMono
			pathLbl.TextSize = 11; pathLbl.TextXAlignment = Enum.TextXAlignment.Left; pathLbl.TextTruncate = Enum.TextTruncate.AtEnd
			
			local typeLbl = Instance.new("TextLabel", row)
			typeLbl.Size = UDim2.new(0, 80, 1, 0); typeLbl.Position = UDim2.new(1, -92, 0, 0)
			typeLbl.BackgroundTransparency = 1; typeLbl.Text = logData.method
			typeLbl.TextColor3 = Color3.fromRGB(150, 150, 150); typeLbl.Font = Enum.Font.GothamMedium
			typeLbl.TextSize = 11; typeLbl.TextXAlignment = Enum.TextXAlignment.Right
			
			row.MouseEnter:Connect(function() TweenService:Create(row, fastTween, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play() end)
			row.MouseLeave:Connect(function() TweenService:Create(row, fastTween, {BackgroundColor3 = Color3.fromRGB(22, 22, 22)}):Play() end)
			
			row.MouseButton1Click:Connect(function()
				AdvSearchModal.Visible = false
				isAdvSearchOpen = false
				ShowLogDetails(logData, false)
			end)
		end
	end
	AdvEmptyState.Visible = (count == 0)
	AdvScroll.CanvasSize = UDim2.new(0, 0, 0, count * 50)
end

for name, data in pairs(advTabButtons) do
	data.Btn.MouseButton1Click:Connect(function()
		activeAdvTab = name
		for n, d in pairs(advTabButtons) do
			local isActive = (n == name)
			TweenService:Create(d.Label, fastTween, {TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 120, 120)}):Play()
			if isActive then UpdateAdvHighlight(d.Btn) end
		end
		RefreshAdvancedSearch()
	end)
end

AdvSearchInput:GetPropertyChangedSignal("Text"):Connect(function()
	advSearchText = AdvSearchInput.Text
	RefreshAdvancedSearch()
end)

AdvCloseBtn.MouseButton1Click:Connect(function()
	isAdvSearchOpen = false
	local t = TweenService:Create(AdvSearchModal, smoothTween, {Position = UDim2.new(0, 0, 1, 0)})
	t:Play()
	t.Completed:Connect(function() if not isAdvSearchOpen then AdvSearchModal.Visible = false end end)
end)

AdvSearchBtn.MouseButton1Click:Connect(function()
	if not isAdvSearchOpen then
		isAdvSearchOpen = true
		AdvSearchModal.Visible = true
		RefreshAdvancedSearch()
		ClearUnseen()
		TweenService:Create(AdvSearchModal, smoothTween, {Position = UDim2.new(0, 0, 0, 40)}):Play()
		task.delay(0.05, function() UpdateAdvHighlight(advTabButtons[activeAdvTab].Btn) end)
	end
end)

LogsScroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
	local scrollMax = LogsScroll.AbsoluteCanvasSize.Y - LogsScroll.AbsoluteSize.Y
	if scrollMax > 0 and LogsScroll.CanvasPosition.Y >= scrollMax - 4 then
		ClearUnseen()
	end
end)


local engineUrl = "https://raw.githubusercontent.com/slavtherookie/Slav/refs/heads/main/main/modulars/LuaUEngine.luau"
local Baseline = loadstring(game:HttpGet(engineUrl))()
local codeEditor = Baseline.new(CodeContainer)
codeEditor.Text = ""; codeEditor.ReadOnly = true; codeEditor.HideScrollbars = false; codeEditor.Minimap = false; codeEditor.Lines = true
codeEditor.Font = Enum.Font.RobotoMono; codeEditor.TextSize = 16 
codeEditor.BackgroundTransparency = 1

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseWheel then
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
			if isDetailOpen and CodeContainer.Visible then
				local newSize = codeEditor.TextSize + (input.Position.Z > 0 and 2 or -2)
				codeEditor.TextSize = math.clamp(newSize, 8, 48)
			end
		end
	end
end)

local function GetDefaultTheme()
	local ThemeKeys = {}
	local textColor = Color3.fromRGB(230, 230, 235)
	local backgroundColor = Color3.fromRGB(0, 0, 0)
	local selectionColor = Color3.fromRGB(255, 255, 255)
	local selectionBackgroundColor = Color3.fromRGB(0, 90, 156)
	local operatorColor = Color3.fromRGB(230, 230, 235)
	local numberColor = Color3.fromRGB(255, 191, 71)
	local stringColor = Color3.fromRGB(120, 245, 175)
	local commentColor = Color3.fromRGB(120, 126, 145)
	local keywordColor = Color3.fromRGB(255, 110, 110)
	local errorColor = Color3.fromRGB(255, 69, 58)
	local warningColor = Color3.fromRGB(255, 149, 0)
	local informationColor = Color3.fromRGB(100, 108, 130)
	local hintColor = Color3.fromRGB(90, 150, 255)
	local findSelectionBackgroundColor = Color3.fromRGB(178, 128, 0)
	local matchingWordBackgroundColor = Color3.fromRGB(35, 35, 35)
	local builtinFunctionColor = Color3.fromRGB(120, 195, 255)
	local whitespaceColor = Color3.fromRGB(70, 74, 90)
	local currentLineHighlightColor = Color3.fromRGB(18, 18, 18)
	local debuggerCurrentLineColor = Color3.fromRGB(20, 20, 20)
	local debuggerErrorLineColor = Color3.fromRGB(45, 15, 15)
	local localMethodColor = Color3.fromRGB(255, 224, 150)
	local localPropertyColor = Color3.fromRGB(130, 175, 255)
	local nilColor = Color3.fromRGB(255, 191, 71)
	local boolColor = Color3.fromRGB(255, 191, 71)
	local functionWordColor = Color3.fromRGB(255, 110, 110)
	local localWordColor = Color3.fromRGB(255, 110, 110)
	local selfColor = Color3.fromRGB(255, 140, 140)
	local luauKeywordColor = Color3.fromRGB(255, 110, 110)
	local functionNameColor = Color3.fromRGB(255, 224, 150)
	local todoColor = Color3.fromRGB(120, 126, 145)
	local scriptRulerColor = Color3.fromRGB(60, 60, 60)
	local scriptBracketColor = Color3.fromRGB(230, 230, 235)
	local typeColor = Color3.fromRGB(110, 165, 255)
	local documentationCodeBlockBackgroundColor = Color3.fromRGB(15, 15, 15)
	local menuPrimaryTextColor = Color3.fromRGB(240, 240, 240)
	local menuSecondaryTextColor = Color3.fromRGB(130, 130, 130)
	local menuSelectedTextColor = Color3.fromRGB(255, 255, 255)
	local menuItemBackgroundColor = Color3.fromRGB(12, 12, 12)
	local selectedMenuItemBackgroundColor = Color3.fromRGB(0, 90, 156)
	local scriptEditorScrollbarBackgroundColor = Color3.fromRGB(14, 14, 14)
	local scriptEditorScrollbarHandleColor = Color3.fromRGB(55, 55, 55)
	local indentationRulerColor = Color3.fromRGB(28, 28, 28)

	ThemeKeys["TextColor"] = { type = "editor", color = textColor }
	ThemeKeys["BackgroundColor"] = { type = "editor", color = backgroundColor }
	ThemeKeys["SelectionColor"] = { type = "editor", color = selectionColor }
	ThemeKeys["SelectionBackgroundColor"] = { type = "editor", color = selectionBackgroundColor }
	ThemeKeys["ErrorColor"] = { type = "editor", color = errorColor }
	ThemeKeys["WarningColor"] = { type = "editor", color = warningColor }
	ThemeKeys["InformationColor"] = { type = "editor", color = informationColor }
	ThemeKeys["HintColor"] = { type = "editor", color = hintColor }
	ThemeKeys["FindSelectionBackgroundColor"] = { type = "editor", color = findSelectionBackgroundColor }
	ThemeKeys["MatchingWordBackgroundColor"] = { type = "editor", color = matchingWordBackgroundColor }
	ThemeKeys["WhitespaceColor"] = { type = "editor", color = whitespaceColor }
	ThemeKeys["CurrentLineHighlightColor"] = { type = "editor", color = currentLineHighlightColor }
	ThemeKeys["DebuggerCurrentLineColor"] = { type = "editor", color = debuggerCurrentLineColor }
	ThemeKeys["DebuggerErrorLineColor"] = { type = "editor", color = debuggerErrorLineColor }
	ThemeKeys["TODOColor"] = { type = "comment", color = todoColor }
	ThemeKeys["ScriptRulerColor"] = { type = "editor", color = scriptRulerColor }
	ThemeKeys["ScriptBracketColor"] = { type = "operator", color = scriptBracketColor }
	ThemeKeys["DocumentationCodeBlockBackgroundColor"] = { type = "editor", color = documentationCodeBlockBackgroundColor }
	ThemeKeys["MenuPrimaryTextColor"] = { type = "editor", color = menuPrimaryTextColor }
	ThemeKeys["MenuSecondaryTextColor"] = { type = "editor", color = menuSecondaryTextColor }
	ThemeKeys["MenuSelectedTextColor"] = { type = "editor", color = menuSelectedTextColor }
	ThemeKeys["MenuItemBackground"] = { type = "editor", color = menuItemBackgroundColor }
	ThemeKeys["SelectedMenuItemBackground"] = { type = "editor", color = selectedMenuItemBackgroundColor }
	ThemeKeys["ScriptEditorScrollbarBackground"] = { type = "editor", color = scriptEditorScrollbarBackgroundColor }
	ThemeKeys["ScriptEditorScrollbarHandle"] = { type = "editor", color = scriptEditorScrollbarHandleColor }
	ThemeKeys["IndentationRulerColor"] = { type = "editor", color = indentationRulerColor }

	ThemeKeys["and"] = { type = "keyword", color = keywordColor }
	ThemeKeys["do"] = { type = "keyword", color = keywordColor }
	ThemeKeys["end"] = { type = "keyword", color = keywordColor }
	ThemeKeys["export"] = { type = "keyword", color = luauKeywordColor }
	ThemeKeys["function"] = { type = "keyword", color = functionWordColor }
	ThemeKeys["in"] = { type = "keyword", color = keywordColor }
	ThemeKeys["inf"] = { type = "keyword", color = keywordColor }
	ThemeKeys["local"] = { type = "keyword", color = localWordColor }
	ThemeKeys["not"] = { type = "keyword", color = keywordColor }
	ThemeKeys["or"] = { type = "keyword", color = keywordColor }
	ThemeKeys["then"] = { type = "keyword", color = keywordColor }
	ThemeKeys["type"] = { type = "keyword", color = luauKeywordColor }
	ThemeKeys["self"] = { type = "keyword", color = selfColor }

	ThemeKeys["break"] = { type = "flow", color = keywordColor }
	ThemeKeys["continue"] = { type = "flow", color = luauKeywordColor }
	ThemeKeys["else"] = { type = "flow", color = keywordColor }
	ThemeKeys["elseif"] = { type = "flow", color = keywordColor }
	ThemeKeys["for"] = { type = "flow", color = keywordColor }
	ThemeKeys["if"] = { type = "flow", color = keywordColor }
	ThemeKeys["repeat"] = { type = "flow", color = keywordColor }
	ThemeKeys["return"] = { type = "flow", color = keywordColor }
	ThemeKeys["until"] = { type = "flow", color = keywordColor }
	ThemeKeys["while"] = { type = "flow", color = keywordColor }

	ThemeKeys["false"] = { type = "literal", color = boolColor }
	ThemeKeys["nil"] = { type = "literal", color = nilColor }
	ThemeKeys["true"] = { type = "literal", color = boolColor }

	ThemeKeys["string_literal"] = { type = "string", color = stringColor }
	ThemeKeys["function_name"] = { type = "identifier", color = functionNameColor }
	ThemeKeys["local_method"] = { type = "identifier", color = localMethodColor }
	ThemeKeys["local_property"] = { type = "identifier", color = localPropertyColor }

	ThemeKeys["op_add"] = { type = "operator", color = operatorColor }
	ThemeKeys["op_assign"] = { type = "operator", color = operatorColor }
	ThemeKeys["op_concat"] = { type = "operator", color = operatorColor }
	ThemeKeys["op_div"] = { type = "operator", color = operatorColor }
	ThemeKeys["op_eq"] = { type = "operator", color = operatorColor }
	ThemeKeys["op_floordiv"] = { type = "operator", color = operatorColor }
	ThemeKeys["op_ge"] = { type = "operator", color = operatorColor }
	ThemeKeys["op_gt"] = { type = "operator", color = operatorColor }
	ThemeKeys["op_le"] = { type = "operator", color = operatorColor }
	ThemeKeys["op_len"] = { type = "operator", color = operatorColor }
	ThemeKeys["op_lt"] = { type = "operator", color = operatorColor }
	ThemeKeys["op_mod"] = { type = "operator", color = operatorColor }
	ThemeKeys["op_mul"] = { type = "operator", color = operatorColor }
	ThemeKeys["op_neq"] = { type = "operator", color = operatorColor }
	ThemeKeys["op_pow"] = { type = "operator", color = operatorColor }
	ThemeKeys["op_sub"] = { type = "operator", color = operatorColor }
	ThemeKeys["op_unm"] = { type = "operator", color = operatorColor }

	ThemeKeys["op_ampersand"] = { type = "type_annotation", color = operatorColor }
	ThemeKeys["op_arrow"] = { type = "type_annotation", color = operatorColor }
	ThemeKeys["op_colon"] = { type = "type_annotation", color = operatorColor }
	ThemeKeys["op_pipe"] = { type = "type_annotation", color = operatorColor }
	ThemeKeys["op_question"] = { type = "type_annotation", color = operatorColor }
	ThemeKeys["op_typecast"] = { type = "type_annotation", color = operatorColor }

	ThemeKeys["typeof"] = { type = "type_annotation", color = builtinFunctionColor }
	ThemeKeys["assert"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["collectgarbage"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["error"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["gcinfo"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["getfenv"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["getmetatable"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["ipairs"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["loadstring"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["newproxy"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["next"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["pairs"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["pcall"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["print"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["rawequal"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["rawget"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["rawlen"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["rawset"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["require"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["select"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["setfenv"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["setmetatable"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["tonumber"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["tostring"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["unpack"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["warn"] = { type = "builtin", color = builtinFunctionColor }
	ThemeKeys["xpcall"] = { type = "builtin", color = builtinFunctionColor }

	ThemeKeys["_G"] = { type = "global", color = builtinFunctionColor }
	ThemeKeys["_VERSION"] = { type = "global", color = builtinFunctionColor }
	ThemeKeys["bit32"] = { type = "global", color = builtinFunctionColor }
	ThemeKeys["buffer"] = { type = "global", color = builtinFunctionColor }
	ThemeKeys["coroutine"] = { type = "global", color = builtinFunctionColor }
	ThemeKeys["debug"] = { type = "global", color = builtinFunctionColor }
	ThemeKeys["game"] = { type = "global", color = builtinFunctionColor }
	ThemeKeys["math"] = { type = "global", color = builtinFunctionColor }
	ThemeKeys["os"] = { type = "global", color = builtinFunctionColor }
	ThemeKeys["plugin"] = { type = "global", color = builtinFunctionColor }
	ThemeKeys["script"] = { type = "global", color = builtinFunctionColor }
	ThemeKeys["shared"] = { type = "global", color = builtinFunctionColor }
	ThemeKeys["string"] = { type = "global", color = builtinFunctionColor }
	ThemeKeys["table"] = { type = "global", color = builtinFunctionColor }
	ThemeKeys["task"] = { type = "global", color = builtinFunctionColor }
	ThemeKeys["utf8"] = { type = "global", color = builtinFunctionColor }
	ThemeKeys["vector"] = { type = "global", color = builtinFunctionColor }
	ThemeKeys["workspace"] = { type = "global", color = builtinFunctionColor }

	ThemeKeys["Axes"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["BrickColor"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["CFrame"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["CatalogSearchParams"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["Color3"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["ColorSequence"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["ColorSequenceKeypoint"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["DateTime"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["DockWidgetPluginGuiInfo"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["Enum"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["EnumItem"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["Faces"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["FloatCurveKey"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["Font"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["Instance"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["NumberRange"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["NumberSequence"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["NumberSequenceKeypoint"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["OverlapParams"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["PathWaypoint"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["PhysicalProperties"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["Ray"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["RaycastParams"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["RaycastResult"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["Rect"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["Region3"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["Region3int16"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["RotationCurveKey"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["SharedTable"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["TweenInfo"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["UDim"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["UDim2"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["Vector2"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["Vector2int16"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["Vector3"] = { type = "type", color = builtinFunctionColor }
	ThemeKeys["Vector3int16"] = { type = "type", color = builtinFunctionColor }

	ThemeKeys["any"] = { type = "type", color = typeColor }
	ThemeKeys["boolean"] = { type = "type", color = typeColor }
	ThemeKeys["never"] = { type = "type", color = typeColor }
	ThemeKeys["number"] = { type = "type", color = typeColor }
	ThemeKeys["thread"] = { type = "type", color = typeColor }
	ThemeKeys["unknown"] = { type = "type", color = typeColor }
	ThemeKeys["userdata"] = { type = "type", color = typeColor }
	ThemeKeys["void"] = { type = "type", color = typeColor }

	ThemeKeys["__add"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__band"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__bnot"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__bor"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__bxor"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__call"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__concat"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__div"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__eq"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__idiv"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__index"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__iter"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__le"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__len"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__lt"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__mod"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__mul"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__newindex"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__pow"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__shl"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__shr"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__sub"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__tostring"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__type"] = { type = "metamethod", color = builtinFunctionColor }
	ThemeKeys["__unm"] = { type = "metamethod", color = builtinFunctionColor }

	ThemeKeys["comment_multi_close"] = { type = "comment", color = commentColor }
	ThemeKeys["comment_multi_open"] = { type = "comment", color = commentColor }
	ThemeKeys["comment_single"] = { type = "comment", color = commentColor }

	ThemeKeys["num_binary"] = { type = "number", color = numberColor }
	ThemeKeys["num_exp"] = { type = "number", color = numberColor }
	ThemeKeys["num_float"] = { type = "number", color = numberColor }
	ThemeKeys["num_hex"] = { type = "number", color = numberColor }
	ThemeKeys["num_inf"] = { type = "number", color = numberColor }
	ThemeKeys["num_integer"] = { type = "number", color = numberColor }
	ThemeKeys["num_nan"] = { type = "number", color = numberColor }
	ThemeKeys["num_separator"] = { type = "number", color = numberColor }
	return ThemeKeys
end

task.spawn(function()
	local fn = GetDefaultTheme()
	if not fn["BackgroundColor"] then fn["BackgroundColor"] = {} end
	fn["BackgroundColor"].color = Color3.fromRGB(14, 14, 14)
	codeEditor:ApplyThemeRules(fn)
	codeEditor.BackgroundColor3 = Color3.fromRGB(14, 14, 14) 
	codeEditor.BackgroundTransparency = 1
end)

local DetailBottomBar = Instance.new("Frame", DetailModal)
DetailBottomBar.Size = UDim2.new(1, 0, 0, 44)
DetailBottomBar.Position = UDim2.new(0, 0, 1, -44)
DetailBottomBar.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
DetailBottomBar.BorderSizePixel = 0

local DetailBottomContainer = Instance.new("Frame", DetailBottomBar)
DetailBottomContainer.Size = UDim2.new(1, 0, 1, 0)
DetailBottomContainer.BackgroundTransparency = 1
DetailBottomContainer.BorderSizePixel = 0
local BBLayout = Instance.new("UIListLayout", DetailBottomContainer)
BBLayout.FillDirection = Enum.FillDirection.Horizontal; BBLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right; BBLayout.VerticalAlignment = Enum.VerticalAlignment.Center; BBLayout.Padding = UDim.new(0, 8)
local BBPad = Instance.new("UIPadding", DetailBottomContainer)
BBPad.PaddingRight = UDim.new(0, 12)

local dNavButtons = {}
local function UpdateDetailNavHighlight(btn)
	TweenService:Create(ActiveDetailHighlight, fastTween, {
		Size = UDim2.new(0, btn.AbsoluteSize.X, 0, 2),
		Position = UDim2.new(0, btn.AbsolutePosition.X - DetailTabs.AbsolutePosition.X, 1, -2)
	}):Play()
end

local function CreateDetailTab(name, icon, container)
	local btn = Instance.new("TextButton", DetailTabsContainer)
	btn.Size = UDim2.new(0, 0, 1, -2); btn.AutomaticSize = Enum.AutomaticSize.X; btn.BackgroundTransparency = 1; btn.Text = ""
	btn.BorderSizePixel = 0
	local list = Instance.new("UIListLayout", btn)
	list.FillDirection = Enum.FillDirection.Horizontal; list.VerticalAlignment = Enum.VerticalAlignment.Center; list.Padding = UDim.new(0, 8)
	local icn = Instance.new("ImageLabel", btn)
	icn.Size = UDim2.new(0, 14, 0, 14); icn.BackgroundTransparency = 1
	icn.BorderSizePixel = 0
	icn.Image = icon; icn.ImageColor3 = Color3.fromRGB(120, 120, 120)
	local lbl = Instance.new("TextLabel", btn)
	lbl.Size = UDim2.new(0, 0, 1, 0); lbl.AutomaticSize = Enum.AutomaticSize.X; lbl.BackgroundTransparency = 1
	lbl.BorderSizePixel = 0
	lbl.Text = name; lbl.TextColor3 = Color3.fromRGB(120, 120, 120); lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 13
	dNavButtons[name] = {Btn = btn, Icon = icn, Label = lbl, Container = container}
	btn.MouseButton1Click:Connect(function()
		for n, d in pairs(dNavButtons) do
			local isA = (n == name)
			TweenService:Create(d.Icon, fastTween, {ImageColor3 = isA and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 120, 120)}):Play()
			TweenService:Create(d.Label, fastTween, {TextColor3 = isA and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 120, 120)}):Play()
			if isA then UpdateDetailNavHighlight(d.Btn) end
			d.Container.Visible = isA
		end
	end)
end

CreateDetailTab("Arguments", ICONS.Args, ArgsContainer)
CreateDetailTab("Code", ICONS.Code, CodeContainer)
CreateDetailTab("Function Info", ICONS.Info, InfoScroll)

local function CreateActionBtn(name, icon)
	local btn = Instance.new("TextButton", DetailBottomContainer)
	btn.Size = UDim2.new(0, 0, 0, 28); btn.AutomaticSize = Enum.AutomaticSize.X; btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); btn.Text = ""
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
	local btnStroke = Instance.new("UIStroke", btn)
	btnStroke.Color = Color3.fromRGB(50, 50, 50)
	btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local list = Instance.new("UIListLayout", btn)
	list.FillDirection = Enum.FillDirection.Horizontal; list.HorizontalAlignment = Enum.HorizontalAlignment.Center; list.VerticalAlignment = Enum.VerticalAlignment.Center; list.Padding = UDim.new(0, 6)
	local pad = Instance.new("UIPadding", btn); pad.PaddingLeft = UDim.new(0, 10); pad.PaddingRight = UDim.new(0, 12)
	local icn = Instance.new("ImageLabel", btn)
	icn.Size = UDim2.new(0, 14, 0, 14); icn.BackgroundTransparency = 1; icn.Image = icon; icn.ImageColor3 = Color3.fromRGB(200, 200, 200)
	icn.BorderSizePixel = 0
	local lbl = Instance.new("TextLabel", btn)
	lbl.Size = UDim2.new(0, 0, 1, 0); lbl.AutomaticSize = Enum.AutomaticSize.X; lbl.BackgroundTransparency = 1
	lbl.BorderSizePixel = 0
	lbl.Text = name; lbl.TextColor3 = Color3.fromRGB(220, 220, 220); lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 13
	btn.MouseEnter:Connect(function() TweenService:Create(btn, fastTween, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play() end)
	btn.MouseLeave:Connect(function() TweenService:Create(btn, fastTween, {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play() end)
	return btn, lbl
end

local CopyArgsBtn, CopyArgsLbl = CreateActionBtn("Copy Args", ICONS.Copy)
local CopyPathBtn, CopyPathLbl = CreateActionBtn("Copy Path", ICONS.Copy)
local IgnoreBtn, IgnoreLbl = CreateActionBtn("Ignore", ICONS.Close)
local CopyCodeBtn, CopyLbl = CreateActionBtn("Copy Code", ICONS.Copy)
local RunCodeBtn, RunLbl = CreateActionBtn("Run Code", ICONS.Execute)
local FireEventBtn, FireEventLbl = CreateActionBtn("Fire Event", ICONS.Execute)
local MockEventBtn, MockEventLbl = CreateActionBtn("Mock", ICONS.Settings)
local DecompileBtn, DecompileLbl = CreateActionBtn("Decompile", ICONS.Decompile)

CopyArgsBtn.MouseButton1Click:Connect(function()
	if setclipboard and currentDetailLog and currentDetailLog.args then
		setclipboard(serializeTable(currentDetailLog.history[currentHistoryPage].args, 0, 10))
		SpyNotify("Copied", "Arguments copied to clipboard")
	end
end)

CopyPathBtn.MouseButton1Click:Connect(function()
	if setclipboard and currentDetailLog then
		setclipboard(currentDetailLog.path)
		SpyNotify("Copied", "Remote path copied to clipboard")
	end
end)

IgnoreBtn.MouseButton1Click:Connect(function()
	if currentDetailLog then
		Settings.IgnoredRemotes[currentDetailLog.remote] = true
		RefreshFilterLists()
		SpyNotify("Ignored", "Remote ignored successfully")
	end
end)

CopyCodeBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(codeEditor.Text)
		SpyNotify("Copied", "Code copied to clipboard")
	end
end)

RunCodeBtn.MouseButton1Click:Connect(function()
	local src = codeEditor.Text
	if src and src ~= "" then pcall(function() loadstring(src)() end); SpyNotify("Executed", "Code executed successfully") end
end)

FireEventBtn.MouseButton1Click:Connect(function()
	if currentDetailLog and currentDetailLog.remote then
		local r = currentDetailLog.remote
		local m = currentDetailLog.method
		local args = currentDetailLog.history[currentHistoryPage].args
		pcall(function()
			if m == "FireServer" then r:FireServer(unpack(args))
			elseif m == "InvokeServer" then r:InvokeServer(unpack(args))
			elseif m == "Fire" then r:Fire(unpack(args))
			elseif m == "Invoke" then r:Invoke(unpack(args))
			end
		end)
		SpyNotify("Fired", "Fired " .. currentDetailLog.name .. " successfully")
	end
end)

MockEventBtn.MouseButton1Click:Connect(function()
	if currentDetailLog and currentDetailLog.remote then
		MockTextBox.Text = Settings.MockedBindables[currentDetailLog.remote] or "return {\n\t\n}"
		MockOverlay.Visible = true
	end
end)

local decompileFunc = decompile or (syn and syn.decompile)
DecompileBtn.MouseButton1Click:Connect(function()
	if decompileFunc and currentDetailLog and typeof(currentDetailLog.remote) == "Instance" then
		local caller = currentDetailLog.caller
		if caller then
			codeEditor.Text = "\n\n"
			task.spawn(function()
				local sTime = os.clock()
				local success, source = pcall(decompileFunc, caller)
				if success then
					local elapsed = math.floor(os.clock() - sTime)
					source = source:gsub("%-%-%s*https?://[%w%.%/%?%=&_%-]+%s*\n*", "")
					source = source:gsub("%-%-%[%[ Line: %d+ | Upvalues: [^%]%-]* %]%]%s*", "")
					source = source:gsub("^%s+", "")
					
					local timeStr = string.format("%02d:%02d:%02d", math.floor(elapsed/3600), math.floor(elapsed/60) % 60, elapsed % 60)
					local header = "-- Generated by paperspy\n-- Time Taken " .. timeStr .. "\n-- discord.gg/paper\n\n"
					
					codeEditor.Text = header .. source
					SpyNotify("Decompiled", "Script source loaded")
				else
					codeEditor.Text = " " .. tostring(source)
					SpyNotify("Error", "Decompile failed")
				end
			end)
		else
			SpyNotify("Error", "No calling script found")
		end
	else
		SpyNotify("Error", "Decompiler not supported")
	end
end)

local function formatType(val)
	if type(val) == "string" then return "string"
	elseif type(val) == "number" then return "number"
	elseif type(val) == "boolean" then return "boolean"
	elseif type(val) == "table" then return "table"
	end
	return typeof(val)
end

local function renderArgsPage(logData, pageIndex)
	for _, child in ipairs(ArgsScroll:GetChildren()) do 
		if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end 
	end
	local historyList = logData.history or { {args = logData.args} }
	currentHistoryPage = math.clamp(pageIndex, 1, #historyList)
	local callArgs = historyList[currentHistoryPage].args
	local totalHeight = 0
	PageLabel.Text = currentHistoryPage .. " / " .. #historyList
	codeEditor.Text = generateCode(logData, callArgs)
	if not callArgs or #callArgs == 0 then
		local lbl = Instance.new("TextLabel", ArgsScroll)
		lbl.Size = UDim2.new(1, 0, 0, 30); lbl.BackgroundTransparency = 1
		lbl.BorderSizePixel = 0
		lbl.Text = "No arguments passed."; lbl.TextColor3 = Color3.fromRGB(130, 130, 130)
		lbl.Font = Enum.Font.Gotham; lbl.TextSize = 13
		totalHeight = 36
	else
		for i, v in pairs(callArgs) do
			local frame = Instance.new("Frame", ArgsScroll)
			frame.Size = UDim2.new(1, 0, 0, 36); frame.BackgroundTransparency = 1
			frame.BorderSizePixel = 0
			local strk = Instance.new("UIStroke", frame); strk.Color = Color3.fromRGB(45, 45, 45)
			Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
			local idxLbl = Instance.new("TextLabel", frame)
			idxLbl.Size = UDim2.new(0, 24, 1, 0); idxLbl.Position = UDim2.new(0, 12, 0, 0); idxLbl.BackgroundTransparency = 1
			idxLbl.BorderSizePixel = 0
			idxLbl.Text = tostring(i); idxLbl.TextColor3 = Color3.fromRGB(140, 140, 140); idxLbl.Font = Enum.Font.RobotoMono; idxLbl.TextSize = 13
			local valLbl = Instance.new("TextLabel", frame)
			valLbl.Size = UDim2.new(1, -150, 1, 0); valLbl.Position = UDim2.new(0, 44, 0, 0); valLbl.BackgroundTransparency = 1
			valLbl.BorderSizePixel = 0
			valLbl.Text = serializeTable(v, 0, 0); valLbl.TextColor3 = Color3.fromRGB(180, 240, 140)
			valLbl.Font = Enum.Font.RobotoMono; valLbl.TextSize = 13; valLbl.TextXAlignment = Enum.TextXAlignment.Left; valLbl.TextTruncate = Enum.TextTruncate.AtEnd
			local typLbl = Instance.new("TextLabel", frame)
			typLbl.Size = UDim2.new(0, 70, 1, 0); typLbl.Position = UDim2.new(1, -100, 0, 0); typLbl.BackgroundTransparency = 1
			typLbl.BorderSizePixel = 0
			typLbl.Text = formatType(v); typLbl.TextColor3 = Color3.fromRGB(120, 120, 120)
			typLbl.Font = Enum.Font.RobotoMono; typLbl.TextSize = 12; typLbl.TextXAlignment = Enum.TextXAlignment.Right
			local copySingle = Instance.new("ImageButton", frame)
			copySingle.Size = UDim2.new(0, 16, 0, 16); copySingle.Position = UDim2.new(1, -22, 0.5, -8)
			copySingle.BackgroundTransparency = 1; copySingle.Image = ICONS.Copy; copySingle.ImageColor3 = Color3.fromRGB(120, 120, 120)
			copySingle.BorderSizePixel = 0
			copySingle.Visible = false
			local bg = Instance.new("Frame", frame); bg.Size = UDim2.new(1,0,1,0); bg.BackgroundColor3 = Color3.fromRGB(24, 24, 24); bg.BackgroundTransparency=1; bg.ZIndex=0; bg.BorderSizePixel = 0; Instance.new("UICorner",bg).CornerRadius=UDim.new(0,4)
			idxLbl.ZIndex=2; valLbl.ZIndex=2; typLbl.ZIndex=2; copySingle.ZIndex=2
			frame.MouseEnter:Connect(function() copySingle.Visible = true; TweenService:Create(bg, fastTween, {BackgroundTransparency=0}):Play() end)
			frame.MouseLeave:Connect(function() copySingle.Visible = false; TweenService:Create(bg, fastTween, {BackgroundTransparency=1}):Play() end)
			copySingle.MouseButton1Click:Connect(function()
				if setclipboard then setclipboard(serializeTable(v, 0, 10)); SpyNotify("Copied", "Value copied to clipboard") end
			end)
			totalHeight = totalHeight + 42
		end
	end
	
	local callReturns = historyList[currentHistoryPage].returns
	if callReturns and #callReturns > 0 then
		local div = Instance.new("Frame", ArgsScroll)
		div.Size = UDim2.new(1, 0, 0, 1); div.BackgroundColor3 = Color3.fromRGB(45, 45, 45); div.BorderSizePixel = 0
		local retLbl = Instance.new("TextLabel", ArgsScroll)
		retLbl.Size = UDim2.new(1, 0, 0, 30); retLbl.BackgroundTransparency = 1; retLbl.BorderSizePixel = 0
		retLbl.Text = "Returns"; retLbl.TextColor3 = Color3.fromRGB(200, 200, 200); retLbl.Font = Enum.Font.GothamMedium; retLbl.TextSize = 13; retLbl.TextXAlignment = Enum.TextXAlignment.Left
		totalHeight = totalHeight + 40
		
		for i, v in pairs(callReturns) do
			local frame = Instance.new("Frame", ArgsScroll)
			frame.Size = UDim2.new(1, 0, 0, 36); frame.BackgroundTransparency = 1; frame.BorderSizePixel = 0
			local strk = Instance.new("UIStroke", frame); strk.Color = Color3.fromRGB(45, 45, 45)
			Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
			local idxLbl = Instance.new("TextLabel", frame)
			idxLbl.Size = UDim2.new(0, 24, 1, 0); idxLbl.Position = UDim2.new(0, 12, 0, 0); idxLbl.BackgroundTransparency = 1; idxLbl.BorderSizePixel = 0
			idxLbl.Text = tostring(i); idxLbl.TextColor3 = Color3.fromRGB(140, 140, 140); idxLbl.Font = Enum.Font.RobotoMono; idxLbl.TextSize = 13
			local valLbl = Instance.new("TextLabel", frame)
			valLbl.Size = UDim2.new(1, -150, 1, 0); valLbl.Position = UDim2.new(0, 44, 0, 0); valLbl.BackgroundTransparency = 1; valLbl.BorderSizePixel = 0
			valLbl.Text = serializeTable(v, 0, 0); valLbl.TextColor3 = Color3.fromRGB(255, 190, 100)
			valLbl.Font = Enum.Font.RobotoMono; valLbl.TextSize = 13; valLbl.TextXAlignment = Enum.TextXAlignment.Left; valLbl.TextTruncate = Enum.TextTruncate.AtEnd
			local typLbl = Instance.new("TextLabel", frame)
			typLbl.Size = UDim2.new(0, 70, 1, 0); typLbl.Position = UDim2.new(1, -100, 0, 0); typLbl.BackgroundTransparency = 1; typLbl.BorderSizePixel = 0
			typLbl.Text = formatType(v); typLbl.TextColor3 = Color3.fromRGB(120, 120, 120); typLbl.Font = Enum.Font.RobotoMono; typLbl.TextSize = 12; typLbl.TextXAlignment = Enum.TextXAlignment.Right
			local copySingle = Instance.new("ImageButton", frame)
			copySingle.Size = UDim2.new(0, 16, 0, 16); copySingle.Position = UDim2.new(1, -22, 0.5, -8); copySingle.BackgroundTransparency = 1; copySingle.Image = ICONS.Copy; copySingle.ImageColor3 = Color3.fromRGB(120, 120, 120)
			copySingle.BorderSizePixel = 0; copySingle.Visible = false
			local bg = Instance.new("Frame", frame); bg.Size = UDim2.new(1,0,1,0); bg.BackgroundColor3 = Color3.fromRGB(24, 24, 24); bg.BackgroundTransparency=1; bg.ZIndex=0; bg.BorderSizePixel = 0; Instance.new("UICorner",bg).CornerRadius=UDim.new(0,4)
			idxLbl.ZIndex=2; valLbl.ZIndex=2; typLbl.ZIndex=2; copySingle.ZIndex=2
			frame.MouseEnter:Connect(function() copySingle.Visible = true; TweenService:Create(bg, fastTween, {BackgroundTransparency=0}):Play() end)
			frame.MouseLeave:Connect(function() copySingle.Visible = false; TweenService:Create(bg, fastTween, {BackgroundTransparency=1}):Play() end)
			copySingle.MouseButton1Click:Connect(function()
				if setclipboard then setclipboard(serializeTable(v, 0, 10)); SpyNotify("Copied", "Value copied to clipboard") end
			end)
			totalHeight = totalHeight + 42
		end
	end
	ArgsScroll.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

PrevPageBtn.MouseButton1Click:Connect(function()
	if currentDetailLog and currentHistoryPage > 1 then renderArgsPage(currentDetailLog, currentHistoryPage - 1) end
end)
NextPageBtn.MouseButton1Click:Connect(function()
	if currentDetailLog and currentHistoryPage < #currentDetailLog.history then renderArgsPage(currentDetailLog, currentHistoryPage + 1) end
end)

local function populateInfoList(parent, logData)
	for _, child in ipairs(parent:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
	local rows = 0
	local function addRow(k, v)
		rows = rows + 1
		local frame = Instance.new("Frame", parent)
		frame.Size = UDim2.new(1, 0, 0, 36); frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		local strk = Instance.new("UIStroke", frame); strk.Color = Color3.fromRGB(45, 45, 45)
		Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
		local klbl = Instance.new("TextLabel", frame)
		klbl.Size = UDim2.new(0, 120, 1, 0); klbl.Position = UDim2.new(0, 12, 0, 0); klbl.BackgroundTransparency = 1
		klbl.BorderSizePixel = 0
		klbl.Text = k; klbl.TextColor3 = Color3.fromRGB(150, 150, 150); klbl.Font = Enum.Font.GothamMedium; klbl.TextSize = 13; klbl.TextXAlignment = Enum.TextXAlignment.Left
		local vlbl = Instance.new("TextLabel", frame)
		vlbl.Size = UDim2.new(1, -144, 1, 0); vlbl.Position = UDim2.new(0, 132, 0, 0); vlbl.BackgroundTransparency = 1
		vlbl.BorderSizePixel = 0
		vlbl.Text = tostring(v); vlbl.TextColor3 = Color3.fromRGB(220, 220, 220); vlbl.Font = Enum.Font.RobotoMono; vlbl.TextSize = 12
		vlbl.TextXAlignment = Enum.TextXAlignment.Left; vlbl.TextTruncate = Enum.TextTruncate.AtEnd
	end
	addRow("Remote Name", logData.name)
	addRow("Method", logData.method)
	addRow("Type", logData.type)
	addRow("Path", logData.path)
	addRow("Calling Script", logData.callerName)
	addRow("Caller Path", logData.callerPath)
	addRow("Total Calls", tostring(logData.count))
	addRow("Arguments Count", logData.args and tostring(#logData.args) or "0")
	addRow("Last Call Time", logData.timestamp or "N/A")
	if logData.trace then addRow("Traceback", logData.trace:gsub("\n", "  |  ")) end
	parent.CanvasSize = UDim2.new(0, 0, 0, rows * 42)
end

local function ShowLogDetails(logData, skipAnim)
	currentDetailLog = logData
	DetailTitle.Text = logData.name
	if logData.type == "Outgoing" then DetailIcon.Image = ICONS.Outgoing
	elseif logData.type == "Incoming" then DetailIcon.Image = ICONS.Incoming
	else DetailIcon.Image = ICONS.Bindable end
	
	FireEventBtn.Visible = (logData.type ~= "Incoming")
	MockEventBtn.Visible = (logData.type == "Bindables" and logData.method == "Invoke")
	
	renderArgsPage(logData, 1)
	populateInfoList(InfoScroll, logData)
	
	for n, d in pairs(dNavButtons) do
		local isA = (n == "Arguments")
		TweenService:Create(d.Icon, fastTween, {ImageColor3 = isA and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 120, 120)}):Play()
		TweenService:Create(d.Label, fastTween, {TextColor3 = isA and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 120, 120)}):Play()
		d.Container.Visible = isA
	end
	task.delay(0.05, function() UpdateDetailNavHighlight(dNavButtons["Arguments"].Btn) end)
	
	if not isDetailOpen then
		isDetailOpen = true; DetailModal.Visible = true
		if not skipAnim then TweenService:Create(DetailModal, smoothTween, {Position = UDim2.new(0, 0, 0, 40)}):Play() end
	end
end

function CreateLogUI(logData)
	local frame = Instance.new("Frame", LogsScroll)
	frame.Size = UDim2.new(1, -8, 0, 46); frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
	local strk = Instance.new("UIStroke", frame); strk.Color = Color3.fromRGB(45, 45, 45)
	local icon = Instance.new("ImageLabel", frame)
	icon.Size = UDim2.new(0, 16, 0, 16); icon.Position = UDim2.new(0, 14, 0.5, -8); icon.BackgroundTransparency = 1
	icon.BorderSizePixel = 0
	if logData.type == "Outgoing" then icon.Image = ICONS.Outgoing
	elseif logData.type == "Incoming" then icon.Image = ICONS.Incoming
	else icon.Image = ICONS.Bindable end
	icon.ImageColor3 = Color3.fromRGB(180, 180, 180)
	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1, -90, 0, 16); title.Position = UDim2.new(0, 42, 0, 6); title.BackgroundTransparency = 1
	title.BorderSizePixel = 0
	title.Text = logData.name; title.TextColor3 = Color3.fromRGB(240, 240, 240)
	title.Font = Enum.Font.GothamMedium; title.TextSize = 13; title.TextXAlignment = Enum.TextXAlignment.Left
	local sub = Instance.new("TextLabel", frame)
	sub.Size = UDim2.new(1, -90, 0, 14); sub.Position = UDim2.new(0, 42, 0, 24); sub.BackgroundTransparency = 1
	sub.BorderSizePixel = 0
	sub.Text = logData.method; sub.TextColor3 = Color3.fromRGB(130, 130, 130)
	sub.Font = Enum.Font.Gotham; sub.TextSize = 11; sub.TextXAlignment = Enum.TextXAlignment.Left
	local countLbl = Instance.new("TextLabel", frame)
	countLbl.Size = UDim2.new(0, 40, 1, 0); countLbl.Position = UDim2.new(1, -48, 0, 0); countLbl.BackgroundTransparency = 1
	countLbl.BorderSizePixel = 0
	countLbl.Text = "x" .. logData.count; countLbl.TextColor3 = Color3.fromRGB(180, 180, 180) 
	countLbl.Font = Enum.Font.GothamMedium; countLbl.TextSize = 12; countLbl.TextXAlignment = Enum.TextXAlignment.Right
	countLbl.Visible = (logData.count > 1)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = ""
	btn.BorderSizePixel = 0
	btn.MouseButton1Click:Connect(function() ShowLogDetails(logData, false) end)
	btn.MouseButton2Click:Connect(function() OpenContextMenu(logData) end)
	local bg = Instance.new("Frame", frame); bg.Size = UDim2.new(1,0,1,0); bg.BackgroundColor3 = Color3.fromRGB(25, 25, 25); bg.BackgroundTransparency=1; bg.ZIndex=0; bg.BorderSizePixel=0; Instance.new("UICorner",bg).CornerRadius=UDim.new(0,4)
	icon.ZIndex=2; title.ZIndex=2; sub.ZIndex=2; countLbl.ZIndex=2; btn.ZIndex=3
	btn.MouseEnter:Connect(function() TweenService:Create(bg, fastTween, {BackgroundTransparency=0}):Play() end)
	btn.MouseLeave:Connect(function() TweenService:Create(bg, fastTween, {BackgroundTransparency=1}):Play() end)
	logData.ui = frame; logData.countLbl = countLbl
end

local lastLog = nil
local function RecordLog(logData)
	table.insert(PendingLogs, logData)
end

task.spawn(function()
	while task.wait(0.01) do
		if #PendingLogs > 0 then
			local toProcess = PendingLogs
			PendingLogs = {}
			local needsAdvRefresh = false
			for _, logData in ipairs(toProcess) do
				if Settings.IgnoredRemotes[logData.remote] or Settings.BlockedRemotes[logData.remote] then continue end
				needsAdvRefresh = true
				logData.count = 1
				logData.history = { {args = logData.args, returns = logData.returns} } 
				logData.timestamp = os.date("%X")
				if lastLog and lastLog.remote == logData.remote and lastLog.method == logData.method and lastLog.type == logData.type then
					lastLog.count = lastLog.count + 1
					lastLog.timestamp = logData.timestamp
					table.insert(lastLog.history, 1, {args = logData.args, returns = logData.returns})
					if #lastLog.history > 30 then table.remove(lastLog.history, 31) end
					lastLog.args = logData.args
					if lastLog.countLbl then lastLog.countLbl.Text = "x" .. lastLog.count; lastLog.countLbl.Visible = true end
					if isDetailOpen and currentDetailLog == lastLog and currentHistoryPage == 1 then
						renderArgsPage(lastLog, 1)
					elseif isDetailOpen and currentDetailLog == lastLog then
						PageLabel.Text = currentHistoryPage .. " / " .. #lastLog.history
					end
				else
					if #Logs >= Settings.MaxLogs then
						local removed = table.remove(Logs, 1)
						if removed.ui then removed.ui:Destroy() end
					end
					table.insert(Logs, logData)
					lastLog = logData
					if logData.type == activeTab and not SettingsArea.Visible then
						if searchFilter == "" or logData.name:lower():find(searchFilter) then
							if not Settings.VirtualScroll then
								CreateLogUI(logData)
								EmptyState.Visible = false
							else
								EmptyState.Visible = false
							end
						end
					end
				end
			end
			if isAdvSearchOpen and needsAdvRefresh then
				RefreshAdvancedSearch()
			end
			if Settings.VirtualScroll and needsAdvRefresh and not SettingsArea.Visible then
				RefreshLogList(false)
				local scrollMax = LogsScroll.AbsoluteCanvasSize.Y - LogsScroll.AbsoluteSize.Y
				if scrollMax <= 0 or LogsScroll.CanvasPosition.Y < scrollMax - 4 then
					AddUnseen()
				end
			end
		end
	end
end)

local getCall = getcallingscript or function() return nil end

_G.HookedConns = _G.HookedConns or {}
local function hookRemoteConnections(remote)
	if not getconnections or not hookfunction then return end
	pcall(function()
		for _, conn in ipairs(getconnections(remote.OnClientEvent)) do
			local oldFunc = conn.Function
			if type(oldFunc) == "function" and not _G.HookedConns[oldFunc] then
				_G.HookedConns[oldFunc] = true
				local original
				original = hookfunction(oldFunc, function(...)
					if Settings.CaptureIncoming and not Settings.BlockedRemotes[remote] then
						local args = {...}
						local caller = getCall()
						task.defer(function()
							RecordLog({
								type = "Incoming",
								remote = remote,
								name = safeGetName(remote),
								path = getInstancePath(remote),
								method = "OnClientEvent",
								args = args,
								caller = caller,
								callerName = caller and safeGetName(caller) or "Unknown",
								callerPath = caller and getInstancePath(caller) or "Unknown",
								trace = debug.traceback()
							})
						end)
					end
					return original(...)
				end)
			end
		end
	end)
end

task.spawn(function()
	if Settings.CaptureIncoming then
		for _, obj in ipairs(game:GetDescendants()) do
			if obj:IsA("RemoteEvent") then
				hookRemoteConnections(obj)
			end
		end
	end
end)

local isBindableHooked = false
if hookmetamethod then
	local oldNamecall
	oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
		local method = getnamecallmethod()
		
		if method == "Kick" or method == "kick" then
			if not checkcaller() then
				local args = {...}
				local caller = getCall()
				task.defer(function()
					RecordLog({
						type = "Kicks",
						remote = self,
						name = "Kick",
						path = getInstancePath(self),
						method = method,
						args = args,
						caller = caller,
						callerName = caller and safeGetName(caller) or "Unknown",
						callerPath = caller and getInstancePath(caller) or "Unknown",
						trace = debug.traceback()
					})
					SpyNotify("Anti-Kick", "Blocked a kick attempt! See Advanced Search.")
				end)
				return
			end
		end

		if not checkcaller() then
			if Settings.BlockedRemotes[self] then return oldNamecall(self, ...) end

			if method == "Invoke" and typeof(self) == "Instance" and self:IsA("BindableFunction") and Settings.MockedBindables[self] then
				local success, result = pcall(function() return loadstring(Settings.MockedBindables[self])() end)
				if success then return result end
			end

			if (method == "FireServer" or method == "InvokeServer") and Settings.CaptureOutgoing then
				local args = {...}
				local caller = getCall()
				if method == "InvokeServer" then
					local returns = {oldNamecall(self, ...)}
					task.defer(function() RecordLog({type = "Outgoing", remote = self, name = safeGetName(self), path = getInstancePath(self), method = method, args = args, returns = returns, caller = caller, callerName = caller and safeGetName(caller) or "Unknown", callerPath = caller and getInstancePath(caller) or "Unknown", trace = debug.traceback()}) end)
					return unpack(returns)
				else
					task.defer(function() RecordLog({type = "Outgoing", remote = self, name = safeGetName(self), path = getInstancePath(self), method = method, args = args, caller = caller, callerName = caller and safeGetName(caller) or "Unknown", callerPath = caller and getInstancePath(caller) or "Unknown", trace = debug.traceback()}) end)
				end
			elseif (method == "Fire" or method == "Invoke") and Settings.CaptureBindables and typeof(self) == "Instance" and (self:IsA("BindableEvent") or self:IsA("BindableFunction")) then
				local args = {...}
				local caller = getCall()
				if method == "Invoke" then
					local returns = {oldNamecall(self, ...)}
					task.defer(function() RecordLog({type = "Bindables", remote = self, name = safeGetName(self), path = getInstancePath(self), method = method, args = args, returns = returns, caller = caller, callerName = caller and safeGetName(caller) or "Unknown", callerPath = caller and getInstancePath(caller) or "Unknown", trace = debug.traceback()}) end)
					return unpack(returns)
				else
					task.defer(function() RecordLog({type = "Bindables", remote = self, name = safeGetName(self), path = getInstancePath(self), method = method, args = args, caller = caller, callerName = caller and safeGetName(caller) or "Unknown", callerPath = caller and getInstancePath(caller) or "Unknown", trace = debug.traceback()}) end)
				end
			end
		end
		if setnamecallmethod then setnamecallmethod(method) end
		return oldNamecall(self, ...)
	end)

	local oldIndex
	oldIndex = hookmetamethod(game, "__index", function(self, key)
		local ret = oldIndex(self, key)
		if not checkcaller() and key == "OnClientEvent" and typeof(self) == "Instance" and self:IsA("RemoteEvent") and Settings.CaptureIncoming then
			task.delay(0.05, function() hookRemoteConnections(self) end)
		end
		return ret
	end)

	local oldNewIndex
	oldNewIndex = hookmetamethod(game, "__newindex", function(self, key, value)
		if not checkcaller() and key == "OnClientInvoke" and typeof(self) == "Instance" and self:IsA("RemoteFunction") and Settings.CaptureIncoming then
			if type(value) == "function" then
				local oldFunc = value
				value = function(...)
					if Settings.CaptureIncoming and not Settings.BlockedRemotes[self] then
						local args = {...}
						local caller = getCall()
						task.defer(function()
							RecordLog({
								type = "Incoming",
								remote = self,
								name = safeGetName(self),
								path = getInstancePath(self),
								method = "OnClientInvoke",
								args = args,
								caller = caller,
								callerName = caller and safeGetName(caller) or "Unknown",
								callerPath = caller and getInstancePath(caller) or "Unknown",
								trace = debug.traceback()
							})
						end)
					end
					return oldFunc(...)
				end
			end
		end
		return oldNewIndex(self, key, value)
	end)
end

task.spawn(function()
	pcall(function()
		local a
		for _, c in pairs(getgc(true)) do
			if typeof(c) ~= "table" then continue end
			local d = rawget(c, "indexInstance")
			if d and typeof(d) == "table" and (d[1] or "") == "kick" then
				a = c
				break
			end
		end
		if a then
			for _, g in pairs(a) do
				if type(g[2]) == "function" then
					hookfunction(g[2], function() return false end)
				end
			end
			SpyNotify("Anti-Kick", "successful.")
		end
	end)
end)

task.delay(0.1, function() SwitchTab("Outgoing") end)
