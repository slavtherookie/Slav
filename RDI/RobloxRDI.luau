local RDI = {}
local Configuration = {
	Theme = {
		Background = Color3.fromRGB(15, 16, 22),
		Panel = Color3.fromRGB(24, 26, 36),
		Border = Color3.fromRGB(38, 41, 56),
		Text = Color3.fromRGB(240, 243, 255),
		Muted = Color3.fromRGB(140, 145, 175),
		Accent = Color3.fromRGB(0, 225, 175),
		AccentBlue = Color3.fromRGB(0, 160, 255),
		Alert = Color3.fromRGB(255, 75, 100)
	},
	RefreshRate = 1.0,
	MaxTimelineEvents = 1000,
	MaxInstances = 20000
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
	game:GetService("ReplicatedFirst"),
	game:GetService("StarterGui"),
	game:GetService("StarterPack"),
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
	for _, service in TargetServices do
		table.insert(list, service)
		for _, desc in service:GetDescendants() do
			table.insert(list, desc)
		end
	end

	local count = #list
	if count > Configuration.MaxInstances then
		count = Configuration.MaxInstances
	end

	local size = 4 + (count * 44)
	local buf = buffer.create(size)
	buffer.writeu32(buf, 0, count)

	for i = 1, count do
		local inst = list[i]
		local offset = 4 + (i - 1) * 44

		local instId = getInstanceId(inst)
		local classId = getClassId(inst.ClassName)

		local parentId = 0
		if inst.Parent then
			parentId = getInstanceId(inst.Parent)
		end

		local nameId = getStringId(inst.Name)

		local px, py, pz = 0, 0, 0
		local sx, sy, sz = 0, 0, 0
		local colorInt = 0
		local matVal = 0
		local flags = 0

		if inst:IsA("BasePart") then
			local pos = inst.Position
			px, py, pz = pos.X, pos.Y, pos.Z
			local s = inst.Size
			sx, sy, sz = s.X, s.Y, s.Z

			local color = inst.Color
			local r = math.clamp(math.round(color.R * 255), 0, 255)
			local g = math.clamp(math.round(color.G * 255), 0, 255)
			local b = math.clamp(math.round(color.B * 255), 0, 255)
			colorInt = bit32.bor(bit32.lshift(r, 16), bit32.lshift(g, 8), b)

			matVal = inst.Material.Value

			if inst.Anchored then flags = bit32.bor(flags, 1) end
			if inst.CanCollide then flags = bit32.bor(flags, 2) end
			if inst.CastShadow then flags = bit32.bor(flags, 4) end
		end

		buffer.writeu32(buf, offset, instId)
		buffer.writeu16(buf, offset + 4, classId)
		buffer.writeu32(buf, offset + 6, parentId)
		buffer.writeu32(buf, offset + 10, nameId)
		buffer.writef32(buf, offset + 14, px)
		buffer.writef32(buf, offset + 18, py)
		buffer.writef32(buf, offset + 22, pz)
		buffer.writef32(buf, offset + 26, sx)
		buffer.writef32(buf, offset + 30, sy)
		buffer.writef32(buf, offset + 34, sz)
		buffer.writeu32(buf, offset + 38, colorInt)
		buffer.writeu8(buf, offset + 42, matVal)
		buffer.writeu8(buf, offset + 43, flags)
	end

	return buf
end

local function parseSnapshot(buf: buffer)
	local count = buffer.readu32(buf, 0)
	local records = {}
	for i = 1, count do
		local offset = 4 + (i - 1) * 44
		local instId = buffer.readu32(buf, offset)
		records[instId] = {
			classId = buffer.readu16(buf, offset + 4),
			parentId = buffer.readu32(buf, offset + 6),
			nameId = buffer.readu32(buf, offset + 10),
			position = Vector3.new(
				buffer.readf32(buf, offset + 14),
				buffer.readf32(buf, offset + 18),
				buffer.readf32(buf, offset + 22)
			),
			size = Vector3.new(
				buffer.readf32(buf, offset + 26),
				buffer.readf32(buf, offset + 30),
				buffer.readf32(buf, offset + 34)
			),
			colorInt = buffer.readu32(buf, offset + 38),
			material = buffer.readu8(buf, offset + 42),
			flags = buffer.readu8(buf, offset + 43)
		end
	end
	return records
end

local function querySnapshot(buf: buffer, queryStr: string)
	local count = buffer.readu32(buf, 0)
	local matches = {}

	local prefix, pattern = queryStr:match("^([%a%d]+):(.*)$")
	if not prefix then
		pattern = queryStr
	end

	local lowerPattern = string.lower(pattern or "")

	for i = 1, count do
		local offset = 4 + (i - 1) * 44
		local instId = buffer.readu32(buf, offset)
		local classId = buffer.readu16(buf, offset + 4)
		local nameId = buffer.readu32(buf, offset + 10)

		local className = IdToClass[classId] or ""
		local name = IdToString[nameId] or ""
		local flags = buffer.readu8(buf, offset + 43)

		local isMatch = false

		if not prefix then
			if string.find(string.lower(name), lowerPattern) then
				isMatch = true
			end
		elseif prefix == "name" then
			if string.find(string.lower(name), lowerPattern) then
				isMatch = true
			end
		elseif prefix == "class" then
			if string.find(string.lower(className), lowerPattern) then
				isMatch = true
			end
		elseif prefix == "anchored" then
			local anchored = bit32.band(flags, 1) ~= 0
			local targetBool = lowerPattern == "true"
			if anchored == targetBool then
				isMatch = true
			end
		elseif prefix == "collide" then
			local collide = bit32.band(flags, 2) ~= 0
			local targetBool = lowerPattern == "true"
			if collide == targetBool then
				isMatch = true
			end
		end

		if isMatch then
			table.insert(matches, instId)
		end
	end

	return matches
end

local EVENT_LIMIT = Configuration.MaxTimelineEvents
local EVENT_SIZE = 17
local eventBuffer = buffer.create(EVENT_LIMIT * EVENT_SIZE)
local eventHead = 0
local eventCount = 0
local startTime = os.clock()

local function recordEvent(eventType: number, instId: number, infoId: number, valueId: number)
	local offset = eventHead * EVENT_SIZE
	local elapsed = os.clock() - startTime

	buffer.writeu8(eventBuffer, offset, eventType)
	buffer.writef32(eventBuffer, offset + 1, elapsed)
	buffer.writeu32(eventBuffer, offset + 5, instId)
	buffer.writeu32(eventBuffer, offset + 9, infoId)
	buffer.writeu32(eventBuffer, offset + 13, valueId)

	eventHead = (eventHead + 1) % EVENT_LIMIT
	if eventCount < EVENT_LIMIT then
		eventCount = eventCount + 1
	end
end

local function getEvents()
	local list = {}
	local startIdx = 0
	if eventCount == EVENT_LIMIT then
		startIdx = eventHead
	end

	for i = 0, eventCount - 1 do
		local idx = (startIdx + i) % EVENT_LIMIT
		local offset = idx * EVENT_SIZE

		local evType = buffer.readu8(eventBuffer, offset)
		local elapsed = buffer.readf32(eventBuffer, offset + 1)
		local instId = buffer.readu32(eventBuffer, offset + 5)
		local infoId = buffer.readu32(eventBuffer, offset + 9)
		local valId = buffer.readu32(eventBuffer, offset + 13)

		table.insert(list, {
			type = evType,
			elapsed = elapsed,
			instId = instId,
			infoId = infoId,
			valId = valId
		})
	end
	return list
end

for _, service in TargetServices do
	service.DescendantAdded:Connect(function(desc)
		local instId = getInstanceId(desc)
		local classId = getClassId(desc.ClassName)
		local nameId = getStringId(desc.Name)
		recordEvent(1, instId, classId, nameId)
	end)

	service.DescendantRemoving:Connect(function(desc)
		local id = InstanceToId[desc]
		if id then
			local classId = getClassId(desc.ClassName)
			local nameId = getStringId(desc.Name)
			recordEvent(2, id, classId, nameId)
		end
	end)
end

local function create(className, properties, children)
	local inst = Instance.new(className)
	for k, v in properties do
		inst[k] = v
	end
	if children then
		for _, child in children do
			child.Parent = inst
		end
	end
	return inst
end

local ScreenGui = create("ScreenGui", {
	Name = "RDI_Observatory",
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local parentSuccess, _ = pcall(function()
	ScreenGui.Parent = game:GetService("CoreGui")
end)
if not parentSuccess then
	local LocalPlayer = game:GetService("Players").LocalPlayer
	if LocalPlayer then
		ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end
end

local MainFrame = create("Frame", {
	Position = UDim2.new(0.5, -325, 0.5, -210),
	Size = UDim2.new(0, 650, 0, 420),
	BackgroundColor3 = Configuration.Theme.Background,
	BorderSizePixel = 0,
	Active = true,
	Draggable = false
}, {
	create("UICorner", { CornerRadius = UDim.new(0, 8) }),
	create("UIStroke", {
		Color = Configuration.Theme.Border,
		Thickness = 1
	})
})

local Header = create("Frame", {
	Size = UDim2.new(1, 0, 0, 35),
	BackgroundColor3 = Configuration.Theme.Panel,
	BorderSizePixel = 0
}, {
	create("UICorner", { CornerRadius = UDim.new(0, 8) }),
	create("TextLabel", {
		Text = "RDI // RUNTIME DATA INSPECTOR",
		Font = Enum.Font.Code,
		TextSize = 13,
		TextColor3 = Configuration.Theme.Accent,
		TextXAlignment = Enum.TextXAlignment.Left,
		Position = UDim2.new(0, 12, 0, 0),
		Size = UDim2.new(0.5, 0, 1, 0),
		BackgroundTransparency = 1
	})
})

local UserInputService = game:GetService("UserInputService")
local dragInput, dragStart, startPos
local dragging = false

Header.InputBegan:Connect(function(input)
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

Header.InputChanged:Connect(function(input)
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

local Sidebar = create("Frame", {
	Position = UDim2.new(0, 0, 0, 35),
	Size = UDim2.new(0, 120, 1, -35),
	BackgroundColor3 = Configuration.Theme.Panel,
	BorderSizePixel = 0
}, {
	create("UIListLayout", {
		Padding = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center
	})
})

local Container = create("Frame", {
	Position = UDim2.new(0, 120, 0, 35),
	Size = UDim2.new(1, -120, 1, -35),
	BackgroundTransparency = 1
})

local function buildPage()
	local frame = create("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1
	})
	return frame
end

local Pages = {
	Explorer = buildPage(),
	Timeline = buildPage(),
	Performance = buildPage(),
	Search = buildPage(),
	Graph = buildPage()
}

for _, page in Pages do
	page.Visible = false
	page.Parent = Container
end

local activeTab = nil
local function selectTab(tabName: string)
	if activeTab then
		Pages[activeTab].Visible = false
	end
	activeTab = tabName
	Pages[tabName].Visible = true
end

local function makeTabButton(name: string, label: string)
	local btn = create("TextButton", {
		Size = UDim2.new(0.9, 0, 0, 32),
		BackgroundColor3 = Configuration.Theme.Background,
		BorderSizePixel = 0,
		Text = label,
		Font = Enum.Font.Code,
		TextSize = 11,
		TextColor3 = Configuration.Theme.Muted,
		AutoButtonColor = true
	}, {
		create("UICorner", { CornerRadius = UDim.new(0, 4) }),
		create("UIStroke", {
			Color = Configuration.Theme.Border,
			Thickness = 1
		})
	})

	btn.MouseButton1Click:Connect(function()
		selectTab(name)
		for _, child in Sidebar:GetChildren() do
			if child:IsA("TextButton") then
				child.TextColor3 = Configuration.Theme.Muted
				child.UIStroke.Color = Configuration.Theme.Border
			end
		end
		btn.TextColor3 = Configuration.Theme.Accent
		btn.UIStroke.Color = Configuration.Theme.Accent
	end)

	btn.Parent = Sidebar
end

makeTabButton("Explorer", "EXPLORER")
makeTabButton("Search", "QUERY ENGINE")
makeTabButton("Timeline", "TIMELINE")
makeTabButton("Performance", "STATS")
makeTabButton("Graph", "RELATION GRAPH")

local MinimizeButton = create("TextButton", {
	Size = UDim2.new(0, 30, 0, 25),
	Position = UDim2.new(1, -35, 0, 5),
	BackgroundColor3 = Configuration.Theme.Background,
	BorderSizePixel = 0,
	Text = "-",
	TextColor3 = Configuration.Theme.Text,
	Font = Enum.Font.Code,
	TextSize = 14,
	Parent = Header
}, {
	create("UICorner", { CornerRadius = UDim.new(0, 4) })
})

local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		MainFrame.Size = UDim2.new(0, 650, 0, 35)
		Container.Visible = false
		Sidebar.Visible = false
		MinimizeButton.Text = "+"
	else
		MainFrame.Size = UDim2.new(0, 650, 0, 420)
		Container.Visible = true
		Sidebar.Visible = true
		MinimizeButton.Text = "-"
	end
end)

Header.Parent = MainFrame
Sidebar.Parent = MainFrame
Container.Parent = MainFrame
MainFrame.Parent = ScreenGui

local Exp_TreeFrame = create("ScrollingFrame", {
	Size = UDim2.new(0.6, -10, 1, -10),
	Position = UDim2.new(0, 5, 0, 5),
	BackgroundTransparency = 1,
	CanvasSize = UDim2.new(0, 0, 0, 0),
	ScrollBarThickness = 4,
	ScrollBarImageColor3 = Configuration.Theme.Border,
	Parent = Pages.Explorer
}, {
	create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 2)
	})
})

local Exp_PropsFrame = create("ScrollingFrame", {
	Size = UDim2.new(0.4, -5, 1, -10),
	Position = UDim2.new(0.6, 5, 0, 5),
	BackgroundColor3 = Configuration.Theme.Panel,
	BorderSizePixel = 0,
	CanvasSize = UDim2.new(0, 0, 0, 0),
	ScrollBarThickness = 4,
	ScrollBarImageColor3 = Configuration.Theme.Border,
	Parent = Pages.Explorer
}, {
	create("UICorner", { CornerRadius = UDim.new(0, 6) }),
	create("UIStroke", { Color = Configuration.Theme.Border, Thickness = 1 }),
	create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 4),
		HorizontalAlignment = Enum.HorizontalAlignment.Center
	})
})

local selectedInstanceId = nil
local collapsedStates = {}

local function createPropRow(label: string, val: string, isHeader: boolean)
	local row = create("Frame", {
		Size = UDim2.new(0.95, 0, 0, isHeader and 24 or 20),
		BackgroundTransparency = isHeader and 0 or 1,
		BackgroundColor3 = Configuration.Theme.Background,
		BorderSizePixel = 0
	}, {
		create("UICorner", { CornerRadius = UDim.new(0, 4) }),
		create("TextLabel", {
			Size = UDim2.new(0.4, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = label,
			TextColor3 = isHeader and Configuration.Theme.Accent or Configuration.Theme.Muted,
			Font = Enum.Font.Code,
			TextSize = 10,
			TextXAlignment = Enum.TextXAlignment.Left,
			Position = UDim2.new(0, 5, 0, 0)
		}),
		create("TextLabel", {
			Size = UDim2.new(0.6, -5, 1, 0),
			Position = UDim2.new(0.4, 5, 0, 0),
			BackgroundTransparency = 1,
			Text = val,
			TextColor3 = Configuration.Theme.Text,
			Font = Enum.Font.Code,
			TextSize = 10,
			TextXAlignment = Enum.TextXAlignment.Left,
			ClipsDescendants = true
		})
	})
	return row
end

local function showProperties(instId: number, records)
	for _, child in Exp_PropsFrame:GetChildren() do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	local data = records[instId]
	if not data then return end

	local className = IdToClass[data.classId] or "Unknown"
	local name = IdToString[data.nameId] or "Unknown"

	createPropRow("IDENTITY", "", true).Parent = Exp_PropsFrame
	createPropRow("Name", name, false).Parent = Exp_PropsFrame
	createPropRow("Class", className, false).Parent = Exp_PropsFrame
	createPropRow("ID", tostring(instId), false).Parent = Exp_PropsFrame

	if className == "Part" or className == "WedgePart" or className == "MeshPart" or className == "SpawnLocation" then
		createPropRow("TRANSFORM", "", true).Parent = Exp_PropsFrame
		createPropRow("Position", string.format("%.2f, %.2f, %.2f", data.position.X, data.position.Y, data.position.Z), false).Parent = Exp_PropsFrame
		createPropRow("Size", string.format("%.2f, %.2f, %.2f", data.size.X, data.size.Y, data.size.Z), false).Parent = Exp_PropsFrame

		createPropRow("RENDERING", "", true).Parent = Exp_PropsFrame
		local r = bit32.band(bit32.rshift(data.colorInt, 16), 0xFF)
		local g = bit32.band(bit32.rshift(data.colorInt, 8), 0xFF)
		local b = bit32.band(data.colorInt, 0xFF)
		createPropRow("Color RGB", string.format("%d, %d, %d", r, g, b), false).Parent = Exp_PropsFrame

		local foundMat = "Unknown"
		for _, enumMat in Materials do
			if enumMat.Value == data.material then
				foundMat = enumMat.Name
				break
			end
		end
		createPropRow("Material", foundMat, false).Parent = Exp_PropsFrame

		createPropRow("PHYSICS & FLAGS", "", true).Parent = Exp_PropsFrame
		createPropRow("Anchored", tostring(bit32.band(data.flags, 1) ~= 0), false).Parent = Exp_PropsFrame
		createPropRow("CanCollide", tostring(bit32.band(data.flags, 2) ~= 0), false).Parent = Exp_PropsFrame
		createPropRow("CastShadow", tostring(bit32.band(data.flags, 4) ~= 0), false).Parent = Exp_PropsFrame
	end

	Exp_PropsFrame.CanvasSize = UDim2.new(0, 0, 0, Exp_PropsFrame.UIListLayout.AbsoluteContentSize.Y + 10)
end

local function redrawTree()
	for _, child in Exp_TreeFrame:GetChildren() do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	local snap = createSnapshot()
	local records = parseSnapshot(snap)

	local childrenMap = {}
	local roots = {}

	for instId, data in records do
		local parentId = data.parentId
		if parentId == 0 or not records[parentId] then
			table.insert(roots, instId)
		else
			if not childrenMap[parentId] then
				childrenMap[parentId] = {}
			end
			table.insert(childrenMap[parentId], instId)
		end
	end

	local visibleList = {}
	local function traverse(instId, depth)
		table.insert(visibleList, { id = instId, depth = depth })
		if not collapsedStates[instId] then
			local children = childrenMap[instId]
			if children then
				table.sort(children, function(a, b)
					return (IdToString[records[a].nameId] or "") < (IdToString[records[b].nameId] or "")
				end)
				for _, childId in children do
					traverse(childId, depth + 1)
				end
			end
		end
	end

	table.sort(roots, function(a, b)
		return (IdToString[records[a].nameId] or "") < (IdToString[records[b].nameId] or "")
	end)
	for _, rootId in roots do
		traverse(rootId, 0)
	end

	for idx, item in visibleList do
		local instId = item.id
		local depth = item.depth
		local data = records[instId]
		local name = IdToString[data.nameId] or "Unknown"
		local class = IdToClass[data.classId] or "Unknown"

		local hasChildren = childrenMap[instId] ~= nil

		local row = create("Frame", {
			Size = UDim2.new(1, -10, 0, 20),
			BackgroundTransparency = 1,
			LayoutOrder = idx
		})

		local toggleText = ""
		if hasChildren then
			toggleText = collapsedStates[instId] and "[+]" or "[-]"
		end

		local toggleBtn = create("TextButton", {
			Size = UDim2.new(0, 18, 1, 0),
			Position = UDim2.new(0, depth * 12, 0, 0),
			BackgroundTransparency = 1,
			Text = toggleText,
			Font = Enum.Font.Code,
			TextColor3 = Configuration.Theme.AccentBlue,
			TextSize = 9,
			Parent = row
		})

		toggleBtn.MouseButton1Click:Connect(function()
			if hasChildren then
				collapsedStates[instId] = not collapsedStates[instId]
				redrawTree()
			end
		end)

		local nameBtn = create("TextButton", {
			Size = UDim2.new(1, - (depth * 12 + 20), 1, 0),
			Position = UDim2.new(0, depth * 12 + 20, 0, 0),
			BackgroundTransparency = 1,
			Text = string.format("%s (%s)", name, class),
			Font = Enum.Font.Code,
			TextColor3 = (selectedInstanceId == instId) and Configuration.Theme.Accent or Configuration.Theme.Text,
			TextSize = 10,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = row
		})

		nameBtn.MouseButton1Click:Connect(function()
			selectedInstanceId = instId
			redrawTree()
			showProperties(instId, records)
		end)

		row.Parent = Exp_TreeFrame
	end

	Exp_TreeFrame.CanvasSize = UDim2.new(0, 0, 0, Exp_TreeFrame.UIListLayout.AbsoluteContentSize.Y + 10)
end

local SearchInput = create("TextBox", {
	Size = UDim2.new(1, -10, 0, 26),
	Position = UDim2.new(0, 5, 0, 5),
	BackgroundColor3 = Configuration.Theme.Panel,
	BorderSizePixel = 0,
	PlaceholderText = "Search by query (e.g. class:Part, name:Door, anchored:true)",
	Text = "",
	TextColor3 = Configuration.Theme.Text,
	PlaceholderColor3 = Configuration.Theme.Muted,
	Font = Enum.Font.Code,
	TextSize = 10,
	Parent = Pages.Search
}, {
	create("UICorner", { CornerRadius = UDim.new(0, 4) }),
	create("UIStroke", { Color = Configuration.Theme.Border, Thickness = 1 })
})

local SearchResults = create("ScrollingFrame", {
	Size = UDim2.new(1, -10, 1, -40),
	Position = UDim2.new(0, 5, 0, 35),
	BackgroundTransparency = 1,
	CanvasSize = UDim2.new(0, 0, 0, 0),
	ScrollBarThickness = 4,
	ScrollBarImageColor3 = Configuration.Theme.Border,
	Parent = Pages.Search
}, {
	create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 2)
	})
})

SearchInput.FocusLost:Connect(function(enterPressed)
	if not enterPressed then return end
	for _, child in SearchResults:GetChildren() do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	local txt = SearchInput.Text
	if txt == "" then return end

	local snap = createSnapshot()
	local matches = querySnapshot(snap, txt)
	local records = parseSnapshot(snap)

	for idx, instId in matches do
		local data = records[instId]
		if not data then continue end

		local name = IdToString[data.nameId] or "Unknown"
		local class = IdToClass[data.classId] or "Unknown"

		local row = create("Frame", {
			Size = UDim2.new(1, -10, 0, 22),
			BackgroundColor3 = Configuration.Theme.Panel,
			BorderSizePixel = 0,
			LayoutOrder = idx
		}, {
			create("UICorner", { CornerRadius = UDim.new(0, 4) }),
			create("TextLabel", {
				Size = UDim2.new(0.8, -5, 1, 0),
				Position = UDim2.new(0, 10, 0, 0),
				BackgroundTransparency = 1,
				Text = string.format("%s [ID: %d] (%s)", name, instId, class),
				Font = Enum.Font.Code,
				TextColor3 = Configuration.Theme.Text,
				TextSize = 10,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			create("TextButton", {
				Size = UDim2.new(0.2, -10, 0.8, 0),
				Position = UDim2.new(0.8, 5, 0.1, 0),
				BackgroundColor3 = Configuration.Theme.Background,
				BorderSizePixel = 0,
				Text = "LOCATE",
				Font = Enum.Font.Code,
				TextColor3 = Configuration.Theme.Accent,
				TextSize = 9
			})
		})

		row.TextButton.MouseButton1Click:Connect(function()
			local actualInst = IdToInstance[instId]
			if actualInst and actualInst:IsA("BasePart") then
				local camera = workspace.CurrentCamera
				if camera then
					camera.CFrame = CFrame.new(actualInst.Position + Vector3.new(0, 10, 15), actualInst.Position)
				end
			end
		end)

		row.Parent = SearchResults
	end

	SearchResults.CanvasSize = UDim2.new(0, 0, 0, SearchResults.UIListLayout.AbsoluteContentSize.Y + 10)
end)

local TimelineScroll = create("ScrollingFrame", {
	Size = UDim2.new(1, -10, 1, -10),
	Position = UDim2.new(0, 5, 0, 5),
	BackgroundTransparency = 1,
	CanvasSize = UDim2.new(0, 0, 0, 0),
	ScrollBarThickness = 4,
	ScrollBarImageColor3 = Configuration.Theme.Border,
	Parent = Pages.Timeline
}, {
	create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 2)
	})
})

local function refreshTimeline()
	for _, child in TimelineScroll:GetChildren() do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	local events = getEvents()
	for idx, ev in events do
		local indicator = "+"
		local col = Configuration.Theme.Accent
		if ev.type == 2 then
			indicator = "-"
			col = Configuration.Theme.Alert
		elseif ev.type == 3 then
			indicator = "~"
			col = Configuration.Theme.AccentBlue
		end

		local class = IdToClass[ev.infoId] or "Unknown"
		local name = IdToString[ev.valId] or "Unknown"
		local timestampStr = string.format("[%02d:%02d]", math.floor(ev.elapsed / 60), math.floor(ev.elapsed % 60))

		local row = create("Frame", {
			Size = UDim2.new(1, -10, 0, 20),
			BackgroundTransparency = 1,
			LayoutOrder = -idx
		}, {
			create("TextLabel", {
				Size = UDim2.new(0, 15, 1, 0),
				BackgroundTransparency = 1,
				Text = indicator,
				Font = Enum.Font.Code,
				TextColor3 = col,
				TextSize = 11,
				TextXAlignment = Enum.TextXAlignment.Center
			}),
			create("TextLabel", {
				Size = UDim2.new(0, 50, 1, 0),
				Position = UDim2.new(0, 20, 0, 0),
				BackgroundTransparency = 1,
				Text = timestampStr,
				Font = Enum.Font.Code,
				TextColor3 = Configuration.Theme.Muted,
				TextSize = 10,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			create("TextLabel", {
				Size = UDim2.new(1, -75, 1, 0),
				Position = UDim2.new(0, 75, 0, 0),
				BackgroundTransparency = 1,
				Text = string.format("%s (Class: %s) [ID: %d]", name, class, ev.instId),
				Font = Enum.Font.Code,
				TextColor3 = Configuration.Theme.Text,
				TextSize = 10,
				TextXAlignment = Enum.TextXAlignment.Left
			})
		})

		row.Parent = TimelineScroll
	end

	TimelineScroll.CanvasSize = UDim2.new(0, 0, 0, TimelineScroll.UIListLayout.AbsoluteContentSize.Y + 10)
end

local StatsLabel = create("TextLabel", {
	Size = UDim2.new(0.5, -10, 1, -10),
	Position = UDim2.new(0, 5, 0, 5),
	BackgroundColor3 = Configuration.Theme.Panel,
	BorderSizePixel = 0,
	Text = "",
	TextColor3 = Configuration.Theme.Text,
	Font = Enum.Font.Code,
	TextSize = 10,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
	Parent = Pages.Performance
}, {
	create("UICorner", { CornerRadius = UDim.new(0, 6) }),
	create("UIPadding", {
		PaddingLeft = UDim.new(0, 10),
		PaddingTop = UDim.new(0, 10)
	}),
	create("UIStroke", { Color = Configuration.Theme.Border, Thickness = 1 })
})

local StatsGraph = create("Frame", {
	Size = UDim2.new(0.5, -5, 1, -10),
	Position = UDim2.new(0.5, 5, 0, 5),
	BackgroundColor3 = Configuration.Theme.Panel,
	BorderSizePixel = 0,
	Parent = Pages.Performance
}, {
	create("UICorner", { CornerRadius = UDim.new(0, 6) }),
	create("UIStroke", { Color = Configuration.Theme.Border, Thickness = 1 })
})

local history = table.create(30, 0)
local function refreshPerformance()
	local snap = createSnapshot()
	local count = buffer.readu32(snap, 0)

	local classCounts = {}
	local records = parseSnapshot(snap)
	for _, data in records do
		local class = IdToClass[data.classId] or "Unknown"
		classCounts[class] = (classCounts[class] or 0) + 1
	end

	local topClasses = {}
	for class, num in classCounts do
		table.insert(topClasses, { class = class, count = num })
	end
	table.sort(topClasses, function(a, b) return a.count > b.count end)

	local distributionStr = ""
	for i = 1, math.min(5, #topClasses) do
		local item = topClasses[i]
		distributionStr = distributionStr .. string.format("\n- %s: %d", item.class, item.count)
	end

	local memory = game:GetService("Stats"):GetTotalMemoryUsageMb()
	local heap = gcinfo()

	StatsLabel.Text = string.format(
		"RUNNING INSTANCES: %d\n" ..
		"LUA GC HEAP SIZE:  %.2f KB\n" ..
		"TOTAL MEMORY:      %.2f MB\n" ..
		"TRACKED STRINGS:   %d\n" ..
		"REGISTERED ID MAP: %d\n" ..
		"\nTOP DISTRIBUTION:%s",
		count,
		heap,
		memory,
		StringCounter,
		InstanceCounter,
		distributionStr
	)

	table.remove(history, 1)
	table.insert(history, count)

	for _, child in StatsGraph:GetChildren() do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	local maxCount = 0
	for _, v in history do
		if v > maxCount then maxCount = v end
	end
	if maxCount == 0 then maxCount = 1 end

	local w = StatsGraph.AbsoluteSize.X - 20
	local h = StatsGraph.AbsoluteSize.Y - 20
	local step = w / 30

	for i = 1, 30 do
		local val = history[i]
		local pct = val / maxCount
		local barH = math.clamp(pct * h, 2, h)

		local bar = create("Frame", {
			Size = UDim2.new(0, math.max(1, step - 2), 0, barH),
			Position = UDim2.new(0, 10 + (i - 1) * step, 0, 10 + (h - barH)),
			BackgroundColor3 = Configuration.Theme.Accent,
			BorderSizePixel = 0,
			Parent = StatsGraph
		})
	end
end

local function drawNode(text: string, pos: UDim2, parent: Instance, isMain: boolean)
	local node = create("Frame", {
		Size = UDim2.new(0, 100, 0, 30),
		Position = pos,
		BackgroundColor3 = isMain and Configuration.Theme.Accent or Configuration.Theme.Background,
		BorderSizePixel = 0,
		Parent = parent
	}, {
		create("UICorner", { CornerRadius = UDim.new(0, 4) }),
		create("UIStroke", {
			Color = isMain and Configuration.Theme.Accent or Configuration.Theme.Border,
			Thickness = 1
		}),
		create("TextLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = text,
			TextColor3 = isMain and Configuration.Theme.Background or Configuration.Theme.Text,
			Font = Enum.Font.Code,
			TextSize = 9,
			ClipsDescendants = true
		})
	})
	return node
end

local function drawLine(p1: Vector2, p2: Vector2, parent: Instance)
	local diff = p2 - p1
	local dist = diff.Magnitude
	local rad = math.atan2(diff.Y, diff.X)

	local line = create("Frame", {
		Size = UDim2.new(0, dist, 0, 1),
		Position = UDim2.new(0, p1.X, 0, p1.Y),
		Rotation = math.deg(rad),
		BackgroundColor3 = Configuration.Theme.Border,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 0.5),
		Parent = parent
	})
end

local function refreshGraph()
	for _, child in Pages.Graph:GetChildren() do
		child:Destroy()
	end

	local graphArea = create("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Parent = Pages.Graph
	})

	local inst = IdToInstance[selectedInstanceId]
	if not inst then
		create("TextLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = "SELECT AN INSTANCE IN THE EXPLORER TO VIEW ITS RELATIONSHIP GRAPH",
			Font = Enum.Font.Code,
			TextColor3 = Configuration.Theme.Muted,
			TextSize = 10,
			Parent = graphArea
		})
		return
	end

	local areaW = graphArea.AbsoluteSize.X
	local areaH = graphArea.AbsoluteSize.Y
	if areaW == 0 then areaW = 530 end
	if areaH == 0 then areaH = 385 end

	local midX = areaW / 2
	local midY = areaH / 2

	local mainNode = drawNode(inst.Name, UDim2.new(0, midX - 50, 0, midY - 15), graphArea, true)

	if inst.Parent then
		local parentNode = drawNode(inst.Parent.Name, UDim2.new(0, midX - 50, 0, midY - 120), graphArea, false)
		drawLine(Vector2.new(midX, midY - 15), Vector2.new(midX, midY - 90), graphArea)
	end

	local children = inst:GetChildren()
	if #children > 0 then
		local count = math.min(#children, 4)
		local stepX = areaW / (count + 1)
		for i = 1, count do
			local child = children[i]
			local xPos = stepX * i
			local childNode = drawNode(child.Name, UDim2.new(0, xPos - 50, 0, midY + 90), graphArea, false)
			drawLine(Vector2.new(midX, midY + 15), Vector2.new(xPos, midY + 90), graphArea)
		end
	end
end

task.spawn(function()
	while task.wait(Configuration.RefreshRate) do
		if Pages.Performance.Visible then
			refreshPerformance()
		end
		if Pages.Timeline.Visible then
			refreshTimeline()
		end
	end
end)

Pages.Explorer:GetPropertyChangedSignal("Visible"):Connect(function()
	if Pages.Explorer.Visible then
		redrawTree()
	end
end)

Pages.Graph:GetPropertyChangedSignal("Visible"):Connect(function()
	if Pages.Graph.Visible then
		refreshGraph()
	end
end)

selectTab("Explorer")
redrawTree()
