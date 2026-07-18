local RDI = {}
local Configuration = {
	Theme = {
		Background = Color3.fromRGB(20, 20, 20),
		Panel = Color3.fromRGB(30, 30, 30),
		Border = Color3.fromRGB(45, 45, 45),
		Text = Color3.fromRGB(255, 255, 255),
		Muted = Color3.fromRGB(150, 150, 150),
		Accent = Color3.fromRGB(0, 170, 255)
	},
	RefreshRate = 1.0,
	MaxInstances = 5000
}

local StringToId = {}
local IdToString = {}
local StringCounter = 0
local ClassToId = {}
local IdToClass = {}
local ClassCounter = 0
local InstanceToId = {}
local IdToInstance = {}
local InstanceCounter = 0

local function getStringId(str: string): number
	local id = StringToId[str]
	if not id then
		StringCounter = StringCounter + 1
		id = StringCounter
		StringToId[str] = id
		IdToString[id] = str
	end
	return id
end

local function getClassId(className: string): number
	local id = ClassToId[className]
	if not id then
		ClassCounter = ClassCounter + 1
		id = ClassCounter
		ClassToId[className] = id
		IdToClass[id] = className
	end
	return id
end

local function getInstanceId(inst: Instance): number
	local id = InstanceToId[inst]
	if not id then
		InstanceCounter = InstanceCounter + 1
		id = InstanceCounter
		InstanceToId[inst] = id
		IdToInstance[id] = inst
	end
	return id
end

local TargetServices = {
	workspace,
	game:GetService("ReplicatedStorage"),
	game:GetService("Players"),
	game:GetService("Lighting")
}

game.DescendantRemoving:Connect(function(desc)
	local id = InstanceToId[desc]
	if id then
		InstanceToId[desc] = nil
		IdToInstance[id] = nil
	end
end)

local function createSnapshot(): buffer
	local list = {}
	for _, service in ipairs(TargetServices) do
		table.insert(list, service)
		for _, desc in ipairs(service:GetDescendants()) do
			table.insert(list, desc)
		end
	end

	local count = #list
	if count > Configuration.MaxInstances then
		count = Configuration.MaxInstances
	end

	local size = 4 + (count * 18)
	local buf = buffer.create(size)
	buffer.writeu32(buf, 0, count)

	for i = 1, count do
		local inst = list[i]
		local offset = 4 + (i - 1) * 18

		local instId = getInstanceId(inst)
		local classId = getClassId(inst.ClassName)
		local parentId = 0
		if inst.Parent then
			parentId = getInstanceId(inst.Parent)
		end
		local nameId = getStringId(inst.Name)

		buffer.writeu32(buf, offset, instId)
		buffer.writeu16(buf, offset + 4, classId)
		buffer.writeu32(buf, offset + 6, parentId)
		buffer.writeu32(buf, offset + 10, nameId)
	end

	return buf
end

local function parseSnapshot(buf: buffer)
	local count = buffer.readu32(buf, 0)
	local records = {}
	for i = 1, count do
		local offset = 4 + (i - 1) * 18
		local instId = buffer.readu32(buf, offset)
		records[instId] = {
			classId = buffer.readu16(buf, offset + 4),
			parentId = buffer.readu32(buf, offset + 6),
			nameId = buffer.readu32(buf, offset + 10)
		}
	end
	return records
end

local function querySnapshot(buf: buffer, queryStr: string)
	local count = buffer.readu32(buf, 0)
	local matches = {}
	local lowerQuery = string.lower(queryStr)

	for i = 1, count do
		local offset = 4 + (i - 1) * 18
		local instId = buffer.readu32(buf, offset)
		local classId = buffer.readu16(buf, offset + 4)
		local nameId = buffer.readu32(buf, offset + 10)

		local name = IdToString[nameId] or ""
		local class = IdToClass[classId] or ""

		if string.find(string.lower(name), lowerQuery) or string.find(string.lower(class), lowerQuery) then
			table.insert(matches, instId)
		end
	end
	return matches
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RDI"
ScreenGui.ResetOnSpawn = false

local parentSuccess, _ = pcall(function()
	ScreenGui.Parent = game:GetService("CoreGui")
end)
if not parentSuccess then
	local LocalPlayer = game:GetService("Players").LocalPlayer
	if LocalPlayer then
		ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end
end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 320)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -160)
MainFrame.BackgroundColor3 = Configuration.Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Configuration.Theme.Border
UIStroke.Thickness = 1
UIStroke.Parent = MainFrame

local UserInputService = game:GetService("UserInputService")
local dragInput, dragStart, startPos
local dragging = false

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Configuration.Theme.Panel
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 6)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 10)
HeaderFix.Position = UDim2.new(0, 0, 1, -10)
HeaderFix.BackgroundColor3 = Configuration.Theme.Panel
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "RDI"
Title.TextColor3 = Configuration.Theme.Text
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Nav = Instance.new("Frame")
Nav.Size = UDim2.new(1, 0, 0, 30)
Nav.Position = UDim2.new(0, 0, 0, 30)
Nav.BackgroundColor3 = Configuration.Theme.Panel
Nav.BorderSizePixel = 0
Nav.Parent = MainFrame

local NavLayout = Instance.new("UIListLayout")
NavLayout.FillDirection = Enum.FillDirection.Horizontal
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
NavLayout.Padding = UDim.new(0, 5)
NavLayout.Parent = Nav

local NavPadding = Instance.new("UIPadding")
NavPadding.PaddingLeft = UDim.new(0, 10)
NavPadding.PaddingTop = UDim.new(0, 2)
NavPadding.Parent = Nav

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -20, 1, -70)
Container.Position = UDim2.new(0, 10, 0, 65)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local Pages = {}
local function createPage(name: string)
	local p = Instance.new("Frame")
	p.Size = UDim2.new(1, 0, 1, 0)
	p.BackgroundTransparency = 1
	p.Visible = false
	p.Parent = Container
	Pages[name] = p
	return p
end

local ExplorerPage = createPage("Explorer")
local SearchPage = createPage("Search")
local StatsPage = createPage("Stats")

local currentTab = nil
local tabButtons = {}

local function selectTab(name: string)
	if currentTab then
		Pages[currentTab].Visible = false
	end
	currentTab = name
	Pages[name].Visible = true

	for tabName, btn in pairs(tabButtons) do
		if tabName == name then
			btn.TextColor3 = Configuration.Theme.Accent
		else
			btn.TextColor3 = Configuration.Theme.Muted
		end
	end
end

local function createTabButton(name: string)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 80, 0, 26)
	btn.BackgroundTransparency = 1
	btn.Text = string.upper(name)
	btn.TextColor3 = Configuration.Theme.Muted
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 12
	btn.Parent = Nav

	btn.MouseButton1Click:Connect(function()
		selectTab(name)
	end)

	tabButtons[name] = btn
end

createTabButton("Explorer")
createTabButton("Search")
createTabButton("Stats")

local ExpList = Instance.new("ScrollingFrame")
ExpList.Size = UDim2.new(0.6, -5, 1, 0)
ExpList.BackgroundTransparency = 1
ExpList.ScrollBarThickness = 4
ExpList.CanvasSize = UDim2.new(0, 0, 0, 0)
ExpList.Parent = ExplorerPage

local ExpListLayout = Instance.new("UIListLayout")
ExpListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ExpListLayout.Padding = UDim.new(0, 2)
ExpListLayout.Parent = ExpList

local ExpDetail = Instance.new("Frame")
ExpDetail.Size = UDim2.new(0.4, -5, 1, 0)
ExpDetail.Position = UDim2.new(0.6, 5, 0, 0)
ExpDetail.BackgroundColor3 = Configuration.Theme.Panel
ExpDetail.BorderSizePixel = 0
ExpDetail.Parent = ExplorerPage

local ExpDetailCorner = Instance.new("UICorner")
ExpDetailCorner.CornerRadius = UDim.new(0, 4)
ExpDetailCorner.Parent = ExpDetail

local ExpDetailLabel = Instance.new("TextLabel")
ExpDetailLabel.Size = UDim2.new(1, -10, 1, -10)
ExpDetailLabel.Position = UDim2.new(0, 5, 0, 5)
ExpDetailLabel.BackgroundTransparency = 1
ExpDetailLabel.TextColor3 = Configuration.Theme.Text
ExpDetailLabel.Font = Enum.Font.SourceSans
ExpDetailLabel.TextSize = 12
ExpDetailLabel.TextXAlignment = Enum.TextXAlignment.Left
ExpDetailLabel.TextYAlignment = Enum.TextYAlignment.Top
ExpDetailLabel.Text = "Select an item to view properties"
ExpDetailLabel.Parent = ExpDetail

local function updateExplorer()
	for _, child in ipairs(ExpList:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	local snap = createSnapshot()
	local records = parseSnapshot(snap)

	local sortedIds = {}
	for instId, _ in pairs(records) do
		table.insert(sortedIds, instId)
	end
	table.sort(sortedIds, function(a, b)
		return (IdToString[records[a].nameId] or "") < (IdToString[records[b].nameId] or "")
	end)

	for _, instId in ipairs(sortedIds) do
		local data = records[instId]
		local name = IdToString[data.nameId] or "Unknown"
		local class = IdToClass[data.classId] or "Unknown"

		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -10, 0, 22)
		btn.BackgroundColor3 = Configuration.Theme.Panel
		btn.BorderSizePixel = 0
		btn.Text = string.format("  %s (%s)", name, class)
		btn.TextColor3 = Configuration.Theme.Text
		btn.Font = Enum.Font.SourceSans
		btn.TextSize = 12
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.Parent = ExpList

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 3)
		corner.Parent = btn

		btn.MouseButton1Click:Connect(function()
			local actual = IdToInstance[instId]
			if actual then
				local details = string.format(
					"Name: %s\nClass: %s\nParent: %s\n",
					actual.Name,
					actual.ClassName,
					actual.Parent and actual.Parent.Name or "nil"
				)
				if actual:IsA("BasePart") then
					details = details .. string.format(
						"\nPosition:\n%.2f, %.2f, %.2f\n\nSize:\n%.2f, %.2f, %.2f\n\nColor:\n%s\n\nMaterial: %s",
						actual.Position.X, actual.Position.Y, actual.Position.Z,
						actual.Size.X, actual.Size.Y, actual.Size.Z,
						tostring(actual.Color),
						actual.Material.Name
					)
				end
				ExpDetailLabel.Text = details
			else
				ExpDetailLabel.Text = "Instance is no longer available."
			end
		end)
	end

	ExpList.CanvasSize = UDim2.new(0, 0, 0, ExpListLayout.AbsoluteContentSize.Y + 10)
end

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, 0, 0, 26)
SearchBox.BackgroundColor3 = Configuration.Theme.Panel
SearchBox.BorderSizePixel = 0
SearchBox.PlaceholderText = "Type class name or item name to search..."
SearchBox.Text = ""
SearchBox.TextColor3 = Configuration.Theme.Text
SearchBox.PlaceholderColor3 = Configuration.Theme.Muted
SearchBox.Font = Enum.Font.SourceSans
SearchBox.TextSize = 12
SearchBox.Parent = SearchPage

local SearchBoxCorner = Instance.new("UICorner")
SearchBoxCorner.CornerRadius = UDim.new(0, 4)
SearchBoxCorner.Parent = SearchBox

local SearchScroll = Instance.new("ScrollingFrame")
SearchScroll.Size = UDim2.new(1, 0, 1, -32)
SearchScroll.Position = UDim2.new(0, 0, 0, 32)
SearchScroll.BackgroundTransparency = 1
SearchScroll.ScrollBarThickness = 4
SearchScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
SearchScroll.Parent = SearchPage

local SearchScrollLayout = Instance.new("UIListLayout")
SearchScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
SearchScrollLayout.Padding = UDim.new(0, 2)
SearchScrollLayout.Parent = SearchScroll

SearchBox.FocusLost:Connect(function(enterPressed)
	if not enterPressed then return end
	for _, child in ipairs(SearchScroll:GetChildren()) do
		if child:IsA("TextLabel") then
			child:Destroy()
		end
	end

	local txt = SearchBox.Text
	if txt == "" then return end

	local snap = createSnapshot()
	local matches = querySnapshot(snap, txt)
	local records = parseSnapshot(snap)

	for _, instId in ipairs(matches) do
		local data = records[instId]
		if data then
			local name = IdToString[data.nameId] or "Unknown"
			local class = IdToClass[data.classId] or "Unknown"

			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, 0, 0, 20)
			lbl.BackgroundColor3 = Configuration.Theme.Panel
			lbl.BorderSizePixel = 0
			lbl.Text = string.format("  %s (%s)", name, class)
			lbl.TextColor3 = Configuration.Theme.Text
			lbl.Font = Enum.Font.SourceSans
			lbl.TextSize = 12
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = SearchScroll

			local c = Instance.new("UICorner")
			c.CornerRadius = UDim.new(0, 3)
			c.Parent = lbl
		end
	end

	SearchScroll.CanvasSize = UDim2.new(0, 0, 0, SearchScrollLayout.AbsoluteContentSize.Y + 10)
end)

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(1, 0, 1, 0)
StatsLabel.BackgroundTransparency = 1
StatsLabel.TextColor3 = Configuration.Theme.Text
StatsLabel.Font = Enum.Font.SourceSans
StatsLabel.TextSize = 13
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.TextYAlignment = Enum.TextYAlignment.Top
StatsLabel.Text = "Loading stats..."
StatsLabel.Parent = StatsPage

local function updateStats()
	local snap = createSnapshot()
	local count = buffer.readu32(snap, 0)
	local memory = game:GetService("Stats"):GetTotalMemoryUsageMb()
	local heap = gcinfo()

	StatsLabel.Text = string.format(
		"Tracking Stats:\n\n" ..
		"Tracked Instances: %d\n" ..
		"Lua GC Heap: %.2f KB\n" ..
		"Memory Consumption: %.2f MB\n" ..
		"Tracked Strings: %d\n" ..
		"Indexed IDs: %d",
		count,
		heap,
		memory,
		StringCounter,
		InstanceCounter
	)
end

selectTab("Explorer")
updateExplorer()

task.spawn(function()
	while task.wait(Configuration.RefreshRate) do
		if Pages.Stats.Visible then
			updateStats()
		end
	end
end)
