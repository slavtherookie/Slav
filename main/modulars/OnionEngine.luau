local CustomDocks = {
	"https://raw.githubusercontent.com/slavtherookie/Slav/refs/heads/main/PublicDocks/WelcomeDock.luau"
}

local CONFIG = {
	["Urls"] = {
		["ApiDump"] = "https://raw.githubusercontent.com/MaximumADHD/Roblox-Client-Tracker/roblox/API-Dump.json",
		["Baseline"] = "https://raw.githubusercontent.com/slavtherookie/Slav/refs/heads/main/main/modulars/LuaUEngine.luau",
		["PaperDark"] = "https://raw.githubusercontent.com/slavtherookie/Slav/refs/heads/main/Public/Themes/PaperDark.luau",
		["VanillaIcons"] = "https://raw.githubusercontent.com/yerastu/dexya/refs/heads/main/VanillaIcons.luau",
		["ReflectionMetadata"] = "https://raw.githubusercontent.com/CloneTrooper1019/Roblox-Client-Tracker/roblox/ReflectionMetadata.xml",
		["Website"] = "https://www.onion.2bd.net/"
	},
	["AssetIds"] = {
		["Outline"] = "rbxassetid://1427967925",
		["Logo"] = "rbxassetid://77687418593481",
		["PbGlow"] = "rbxassetid://18245826428",
		["Checkmark"] = "rbxassetid://6401617475",
		["Middle"] = "rbxassetid://6425281788",
		["ColorSpace"] = "rbxassetid://1072518406",
		["ColorStrip"] = "rbxassetid://1072518502",
		["Hex"] = "rbxassetid://1281023007",
		["PropIcon"] = "rbxassetid://14227443834",
		["ExpandIcon"] = "rbxassetid://5642383285",
		["CloseBtn"] = "rbxassetid://5054663650",
		["MaxBtn"] = "rbxassetid://5448127505",
		["MinBtn"] = "rbxassetid://5034768003",
		["MinBtnActive"] = "rbxassetid://5060023708",
		["ExplorerArrow"] = "rbxassetid://6511490623",
		["ExplorerIconDefault"] = "rbxassetid://124679872867639",
		["ExplorerIconFallback"] = "rbxassetid://483448923",
		["LockIcon"] = "rbxassetid://7733671754",
		["ScriptViewer"] = "rbxassetid://101746547091937",
		["ExplorerDock"] = "rbxassetid://99875150701464",
		["PropertiesDock"] = "rbxassetid://90101573500817"
	},
	["Theme"] = {
		["Main1"] = Color3.fromRGB(3, 3, 3),
		["Main2"] = Color3.fromRGB(3, 3, 3),
		["Outline1"] = Color3.fromRGB(5, 5, 5),
		["Outline2"] = Color3.fromRGB(4, 4, 4),
		["Outline3"] = Color3.fromRGB(3, 3, 3),
		["TextBox"] = Color3.fromRGB(4, 4, 4),
		["Menu"] = Color3.fromRGB(3, 3, 3),
		["ListSelection"] = Color3.fromRGB(0, 90, 156),
		["Button"] = Color3.fromRGB(4, 4, 4),
		["ButtonHover"] = Color3.fromRGB(5, 5, 5),
		["ButtonPress"] = Color3.fromRGB(3, 3, 3),
		["Highlight"] = Color3.fromRGB(5, 5, 5),
		["Text"] = Color3.fromRGB(230, 230, 235),
		["PlaceholderText"] = Color3.fromRGB(100, 108, 130),
		["Important"] = Color3.fromRGB(255, 69, 58),
		["LockedIcon"] = Color3.fromRGB(120, 126, 145),
		["MenuBackground"] = Color3.fromRGB(3, 3, 3),
		["AppListCard"] = Color3.fromRGB(3, 3, 3),
		["AppListCardHover"] = Color3.fromRGB(4, 4, 4),
		["IntroBg"] = Color3.fromRGB(0, 0, 0),
		["DockPreviewBg"] = Color3.fromRGB(0, 90, 156)
	},
	["ThemeDefault2"] = {
		["Main1"] = Color3.fromRGB(52, 52, 52),
		["Main2"] = Color3.fromRGB(45, 45, 45),
		["Outline1"] = Color3.fromRGB(33, 33, 33),
		["Outline2"] = Color3.fromRGB(55, 55, 55),
		["Outline3"] = Color3.fromRGB(30, 30, 30),
		["TextBox"] = Color3.fromRGB(38, 38, 38),
		["Menu"] = Color3.fromRGB(32, 32, 32),
		["ListSelection"] = Color3.fromRGB(11, 90, 175),
		["Button"] = Color3.fromRGB(60, 60, 60),
		["ButtonHover"] = Color3.fromRGB(68, 68, 68),
		["ButtonPress"] = Color3.fromRGB(40, 40, 40),
		["Highlight"] = Color3.fromRGB(75, 75, 75),
		["Text"] = Color3.fromRGB(255, 255, 255),
		["PlaceholderText"] = Color3.fromRGB(100, 100, 100),
		["Important"] = Color3.fromRGB(255, 0, 0),
		["LockedIcon"] = Color3.fromRGB(120, 126, 145),
		["MenuBackground"] = Color3.fromRGB(32, 32, 32),
		["AppListCard"] = Color3.fromRGB(52, 52, 52),
		["AppListCardHover"] = Color3.fromRGB(60, 60, 60),
		["IntroBg"] = Color3.fromRGB(32, 32, 32),
		["DockPreviewBg"] = Color3.fromRGB(11, 90, 175)
	},
	["Settings"] = {
		["IconTheme"] = "Default2",
		["MaxVisibleFrames"] = 150,
		["RowHeight"] = 20,
		["EdgeThreshold"] = 40,
		["ExplorerUpdateDelay"] = 0.1,
		["WheelIncrement"] = 3,
		["FastWaitBackup"] = 0.01,
		["DockSizes"] = { ["Left"] = 350, ["Right"] = 370, ["Bottom"] = 250 },
		["MenuWidth"] = 320,
		["MenuMaxHeight"] = 400,
		["IntroSize"] = UDim2.new(0, 450, 0, 250),
		["MinWindowSize"] = Vector2.new(200, 100),
		["Properties"] = {
			["MaxConflictCheck"] = 50,
			["ShowDeprecated"] = false,
			["ShowHidden"] = false,
			["ClearOnFocus"] = false,
			["LoadstringInput"] = true,
			["NumberRounding"] = 3,
			["ShowAttributes"] = true,
			["MaxAttributes"] = 50,
			["ScaleType"] = 1
		}
	},
	["Strings"] = {
		["Title"] = "Onion",
		["Desc"] = "Ultimate Debugging Utility",
		["Creator"] = "Developed by Yera",
		["StatusStart"] = "Starting Environment...",
		["StatusApi"] = "Fetching Onion API & Assets...",
		["StatusMods"] = "Loading Modules...",
		["StatusData"] = "Loading Player Data...",
		["StatusKicks"] = "Disabling Client Kicks...",
		["StatusFinish"] = "Finishing Setup...",
		["StatusComplete"] = "Complete",
		["YourDocks"] = "Your Docks",
		["AddMore"] = "Add more Docks",
		["LockedSpace"] = "Add more\nto add space!",
		["Decompiling"] = "-- Decompiling...",
		["FailedDecompile"] = "-- Failed to decompile\n",
		["NoDecompiler"] = "-- Decompiler not available",
		["CopyClipboard"] = "Copy to Clipboard",
		["SaveFile"] = "Save to File",
		["DumpFuncs"] = "Dump Functions",
		["Enable"] = "Enable",
		["Disable"] = "Disable"
	},
	["Animation"] = {
		["IntroFade"] = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		["IntroProgress"] = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		["IntroOut"] = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In),
		["MenuToggle"] = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		["MenuClose"] = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
		["DockUpdate"] = TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		["WindowResize"] = TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
		["WindowClose"] = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		["AppHover"] = TweenInfo.new(0.2)
	}
}

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
	end
end)

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local LocalPlayer = Players.LocalPlayer
local GuiParent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

local OnionGlobals = {}
OnionGlobals["Instances"] = {}
OnionGlobals["Connections"] = {}

local function TrackInstance(inst)
	table.insert(OnionGlobals["Instances"], inst)
	return inst
end

local function TrackConnection(conn)
	table.insert(OnionGlobals["Connections"], conn)
	return conn
end

if _G.OnionCleanup then pcall(_G.OnionCleanup) end

_G.OnionIsActive = true
_G.OnionCleanup = function()
	_G.OnionIsActive = false
	for _, c in ipairs(OnionGlobals["Connections"]) do
		if c and c.Connected then c:Disconnect() end
	end
	table.clear(OnionGlobals["Connections"])
	for _, i in ipairs(OnionGlobals["Instances"]) do
		if i and i.Parent then i:Destroy() end
	end
	table.clear(OnionGlobals["Instances"])
end

if GuiParent:FindFirstChild("OnionIntro") then GuiParent.OnionIntro:Destroy() end
if GuiParent:FindFirstChild("OnionDock") then GuiParent.OnionDock:Destroy() end

local VanillaIcons = {}
local VanillaIconsLoaded = false
local DefaultIcons = {}
local DefaultIconsLoaded = false
local CustomIconCache = {}
local CurrentlyFetching = {}

local function GetCustomIconAsset(className, folderTheme)
	if CustomIconCache[className] then return CustomIconCache[className] end
	local url = "https://www.onion.2bd.net/raw/" .. className .. ".png"
	local folderPath = "OnionIcons/" .. folderTheme
	local fileName = folderPath .. "/" .. className .. ".png"
	local canUseFs = false
	pcall(function()
		if makefolder and isfolder and isfile and writefile and getcustomasset then
			if not isfolder("OnionIcons") then makefolder("OnionIcons") end
			if not isfolder(folderPath) then makefolder(folderPath) end
			canUseFs = true
		end
	end)
	local resultAsset = "NONE"
	if canUseFs and isfile(fileName) then
		resultAsset = getcustomasset(fileName)
	else
		local success, data = pcall(function() return game:HttpGet(url) end)
		if success and data and not data:find("404: Not Found") and not data:find("404 Not Found") and not data:find("Site not found") and #data > 0 then
			if canUseFs then
				local writeSuccess = pcall(function() writefile(fileName, data) end)
				if writeSuccess then resultAsset = getcustomasset(fileName) end
			end
		end
	end
	if resultAsset == "NONE" and className ~= "Instance" then
		resultAsset = GetCustomIconAsset("Instance", folderTheme)
	end
	CustomIconCache[className] = resultAsset
	return resultAsset
end

_G.Onion = { ["Theme"] = CONFIG["Theme"], ["CreateDock"] = nil }

local DexIcons = {
	["Accessory"] = 32, ["Accoutrement"] = 32, ["AdService"] = 73, ["Animation"] = 60,
	["AnimationController"] = 60, ["AnimationTrack"] = 60, ["Animator"] = 60, ["ArcHandles"] = 56,
	["AssetService"] = 72, ["Attachment"] = 34, ["Backpack"] = 20, ["BadgeService"] = 75,
	["BallSocketConstraint"] = 89, ["BillboardGui"] = 64, ["BinaryStringValue"] = 4,
	["BindableEvent"] = 67, ["BindableFunction"] = 66, ["BlockMesh"] = 8, ["BloomEffect"] = 90,
	["BlurEffect"] = 90, ["BodyAngularVelocity"] = 14, ["BodyForce"] = 14, ["BodyGyro"] = 14,
	["BodyPosition"] = 14, ["BodyThrust"] = 14, ["BodyVelocity"] = 14, ["BoolValue"] = 4,
	["BoxHandleAdornment"] = 54, ["BrickColorValue"] = 4, ["Camera"] = 5, ["CFrameValue"] = 4,
	["CharacterMesh"] = 60, ["Chat"] = 33, ["ClickDetector"] = 41, ["CollectionService"] = 30,
	["Color3Value"] = 4, ["ColorCorrectionEffect"] = 90, ["ConeHandleAdornment"] = 54,
	["Configuration"] = 58, ["ContentProvider"] = 72, ["ContextActionService"] = 41, ["CoreGui"] = 46,
	["CoreScript"] = 18, ["CornerWedgePart"] = 1, ["CustomEvent"] = 4, ["CustomEventReceiver"] = 4,
	["CylinderHandleAdornment"] = 54, ["CylinderMesh"] = 8, ["CylindricalConstraint"] = 89,
	["Debris"] = 30, ["Decal"] = 7, ["Dialog"] = 62, ["DialogChoice"] = 63, ["DoubleConstrainedValue"] = 4,
	["Explosion"] = 36, ["FileMesh"] = 8, ["Fire"] = 61, ["Flag"] = 38, ["FlagStand"] = 39,
	["FloorWire"] = 4, ["Folder"] = 70, ["ForceField"] = 37, ["Frame"] = 48, ["GamePassService"] = 19,
	["Glue"] = 34, ["GuiButton"] = 52, ["GuiMain"] = 47, ["GuiService"] = 47, ["Handles"] = 53,
	["HapticService"] = 84, ["Hat"] = 45, ["HingeConstraint"] = 89, ["Hint"] = 33, ["HopperBin"] = 22,
	["HttpService"] = 76, ["Humanoid"] = 9, ["ImageButton"] = 52, ["ImageLabel"] = 49,
	["InsertService"] = 72, ["IntConstrainedValue"] = 4, ["IntValue"] = 4, ["JointInstance"] = 34,
	["JointsService"] = 34, ["Keyframe"] = 60, ["KeyframeSequence"] = 60, ["KeyframeSequenceProvider"] = 60,
	["Lighting"] = 13, ["LineHandleAdornment"] = 54, ["LocalScript"] = 18, ["LogService"] = 87,
	["MarketplaceService"] = 46, ["Message"] = 33, ["Model"] = 2, ["ModuleScript"] = 71, ["Motor"] = 34,
	["Motor6D"] = 34, ["MoveToConstraint"] = 89, ["NegateOperation"] = 78, ["NetworkClient"] = 16,
	["NetworkReplicator"] = 29, ["NetworkServer"] = 15, ["NumberValue"] = 4, ["ObjectValue"] = 4,
	["Pants"] = 44, ["ParallelRampPart"] = 1, ["Part"] = 1, ["ParticleEmitter"] = 69, ["PartPairLasso"] = 57,
	["PathfindingService"] = 37, ["Platform"] = 35, ["Player"] = 12, ["PlayerGui"] = 46, ["Players"] = 21,
	["PlayerScripts"] = 82, ["PointLight"] = 13, ["PointsService"] = 83, ["Pose"] = 60,
	["PrismaticConstraint"] = 89, ["PrismPart"] = 1, ["PyramidPart"] = 1, ["RayValue"] = 4,
	["ReflectionMetadata"] = 86, ["ReflectionMetadataCallbacks"] = 86, ["ReflectionMetadataClass"] = 86,
	["ReflectionMetadataClasses"] = 86, ["ReflectionMetadataEnum"] = 86, ["ReflectionMetadataEnumItem"] = 86,
	["ReflectionMetadataEnums"] = 86, ["ReflectionMetadataEvents"] = 86, ["ReflectionMetadataFunctions"] = 86,
	["ReflectionMetadataMember"] = 86, ["ReflectionMetadataProperties"] = 86,
	["ReflectionMetadataYieldFunctions"] = 86, ["RemoteEvent"] = 80, ["RemoteFunction"] = 79,
	["ReplicatedFirst"] = 72, ["ReplicatedStorage"] = 72, ["RightAngleRampPart"] = 1,
	["RocketPropulsion"] = 14, ["RodConstraint"] = 89, ["RopeConstraint"] = 89, ["Rotate"] = 34,
	["RotateP"] = 34, ["RotateV"] = 34, ["RunService"] = 66, ["ScreenGui"] = 47, ["Script"] = 6,
	["ScrollingFrame"] = 48, ["Seat"] = 35, ["Selection"] = 55, ["SelectionBox"] = 54,
	["SelectionPartLasso"] = 57, ["SelectionPointLasso"] = 57, ["SelectionSphere"] = 54,
	["ServerScriptService"] = 0, ["ServerStorage"] = 74, ["Shirt"] = 43, ["ShirtGraphic"] = 40,
	["SkateboardPlatform"] = 35, ["Sky"] = 28, ["SlidingBallConstraint"] = 89, ["Smoke"] = 59,
	["Snap"] = 34, ["Sound"] = 11, ["SoundService"] = 31, ["Sparkles"] = 42, ["SpawnLocation"] = 25,
	["SpecialMesh"] = 8, ["SphereHandleAdornment"] = 54, ["SpotLight"] = 13, ["SpringConstraint"] = 89,
	["StarterCharacterScripts"] = 82, ["StarterGear"] = 20, ["StarterGui"] = 46, ["StarterPack"] = 20,
	["StarterPlayer"] = 88, ["StarterPlayerScripts"] = 82, ["Status"] = 2, ["StringValue"] = 4,
	["SunRaysEffect"] = 90, ["SurfaceGui"] = 64, ["SurfaceLight"] = 13, ["SurfaceSelection"] = 55,
	["Team"] = 24, ["Teams"] = 23, ["TeleportService"] = 81, ["Terrain"] = 65, ["TerrainRegion"] = 65,
	["TestService"] = 68, ["TextBox"] = 51, ["TextButton"] = 51, ["TextLabel"] = 50, ["Texture"] = 10,
	["TextureTrail"] = 4, ["Tool"] = 17, ["TouchTransmitter"] = 37, ["TrussPart"] = 1,
	["UnionOperation"] = 77, ["UserInputService"] = 84, ["Vector3Value"] = 4, ["VehicleSeat"] = 35,
	["VelocityMotor"] = 34, ["WedgePart"] = 1, ["Weld"] = 34, ["Workspace"] = 19
}

local function GetIconRect(className)
	local id = DexIcons[className] or 0
	local row = math.floor(id / 14)
	local col = id % 14
	return Vector2.new(col * 16, row * 16), Vector2.new(16, 16)
end

local DexAPI = {
	["Classes"] = {},
	["CategoryOrder"] = { ["Appearance"] = 1, ["Data"] = 2, ["Behavior"] = 3, ["Part"] = 4, ["State"] = 5, ["Collision"] = 6 }
}

local function FetchAPIDump()
	task.spawn(function()
		pcall(function()
			local dumpJSON = game:HttpGet(CONFIG["Urls"]["ApiDump"])
			local dump = HttpService:JSONDecode(dumpJSON)
			for _, class in ipairs(dump["Classes"]) do
				local cls = { ["Name"] = class["Name"], ["Superclass"] = class["Superclass"], ["Properties"] = {} }
				for _, member in ipairs(class["Members"]) do
					if member["MemberType"] == "Property" then
						local tags = {}
						if member["Tags"] then
							for _, t in ipairs(member["Tags"]) do tags[t] = true end
						end
						table.insert(cls["Properties"], { ["Class"] = class["Name"], ["Name"] = member["Name"], ["Category"] = member["Category"] or "Data", ["ValueType"] = member["ValueType"] or {["Name"] = "string"}, ["Tags"] = tags })
					end
				end
				DexAPI["Classes"][class["Name"]] = cls
			end
		end)
	end)
end

local function createSimpleGUI(data)
	local insts = {}
	for i,v in pairs(data) do
		insts[v[1]] = Instance.new(v[2])
	end
	for _,v in pairs(data) do
		for prop,val in pairs(v[3]) do
			if type(val) == "table" then
				insts[v[1]][prop] = insts[val[1]]
			else
				insts[v[1]][prop] = val
			end
		end
	end
	return insts[1]
end

local IntroLib = {}
function IntroLib.Play(onComplete)
	local gui = createSimpleGUI({
		{1,"ScreenGui",{Name="OnionIntro",DisplayOrder=99999,IgnoreGuiInset=true}},
		{2,"Frame",{Active=true,BackgroundColor3=Color3.fromRGB(0,0,0),BorderSizePixel=0,Name="Main",Parent={1},Position=UDim2.new(0.5,-175,0.5,-100),Size=UDim2.new(0,350,0,200)}},
		{3,"Frame",{BackgroundColor3=Color3.fromRGB(3,3,3),BorderSizePixel=0,ClipsDescendants=true,Name="Holder",Parent={2},Size=UDim2.new(1,0,1,0)}},
		{4,"UIGradient",{Parent={3},Rotation=30,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(1,1,0)})}},
		{5,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=Enum.Font.GothamBlack,Name="Title",Parent={3},Position=UDim2.new(0,-190,0,15),Size=UDim2.new(0,100,0,50),Text="ONION",TextColor3=Color3.fromRGB(230,230,235),TextSize=46,TextTransparency=1}},
		{6,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=Enum.Font.GothamSemibold,Name="Desc",Parent={3},Position=UDim2.new(0,-230,0,60),Size=UDim2.new(0,180,0,25),Text="Ultimate Debugging Suite",TextColor3=Color3.fromRGB(100,108,130),TextSize=15,TextTransparency=1}},
		{7,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=Enum.Font.GothamMedium,Name="StatusText",Parent={3},Position=UDim2.new(0,20,0,110),Size=UDim2.new(0,180,0,25),Text="Initializing Library",TextColor3=Color3.fromRGB(120,126,145),TextSize=13,TextTransparency=1}},
		{8,"Frame",{BackgroundColor3=Color3.fromRGB(3,3,3),BorderSizePixel=0,Name="ProgressBar",Parent={3},Position=UDim2.new(0,110,0,145),Size=UDim2.new(0,0,0,4)}},
		{9,"Frame",{BackgroundColor3=Color3.fromRGB(0,90,156),BorderSizePixel=0,Name="Bar",Parent={8},Size=UDim2.new(0,0,1,0)}},
		{10,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image="rbxassetid://2764171053",ImageColor3=Color3.fromRGB(4,4,4),Parent={8},ScaleType=Enum.ScaleType.Slice,Size=UDim2.new(1,0,1,0),SliceCenter=Rect.new(2,2,254,254)}},
		{11,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=Enum.Font.GothamMedium,Name="Creator",Parent={2},Position=UDim2.new(1,-130,1,-25),Size=UDim2.new(0,120,0,20),Text="Developed by Runnore",TextColor3=Color3.fromRGB(230,230,235),TextSize=12,TextXAlignment=Enum.TextXAlignment.Right}},
		{12,"UIGradient",{Parent={11},Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(1,1,0)})}},
		{13,"TextLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Font=Enum.Font.GothamMedium,Name="Version",Parent={2},Position=UDim2.new(1,-130,1,-40),Size=UDim2.new(0,120,0,20),Text="Version 0.05",TextColor3=Color3.fromRGB(120,126,145),TextSize=12,TextXAlignment=Enum.TextXAlignment.Right}},
		{14,"UIGradient",{Parent={13},Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(1,1,0)})}},
		{15,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Image="rbxassetid://1427967925",ImageColor3=Color3.fromRGB(5,5,5),Name="Outlines",Parent={2},Position=UDim2.new(0,-5,0,-5),ScaleType=Enum.ScaleType.Slice,Size=UDim2.new(1,10,1,10),SliceCenter=Rect.new(6,6,25,25),TileSize=UDim2.new(0,20,0,20)}},
		{16,"UIGradient",{Parent={15},Rotation=-30,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(1,1,0)})}},
		{17,"UIGradient",{Parent={2},Rotation=-30,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(1,1,0)})}},
		{20,"UICorner",{CornerRadius=UDim.new(1,0),Parent={8}}},
		{21,"UICorner",{CornerRadius=UDim.new(1,0),Parent={9}}}
	})

	TrackInstance(gui)
	gui.Parent = GuiParent

	local main = gui.Main
	local holder = main.Holder
	local backGradient = main.UIGradient
	local outlinesGradient = main.Outlines.UIGradient
	local holderGradient = holder.UIGradient
	local titleText = holder.Title
	local descText = holder.Desc
	local versionText = main.Version
	local versionGradient = versionText.UIGradient
	local creatorText = main.Creator
	local creatorGradient = creatorText.UIGradient
	local statusText = holder.StatusText
	local progressBar = holder.ProgressBar

	local function tweenNumber(n,ti,func)
		local tweenVal = Instance.new("NumberValue")
		tweenVal.Value = 0
		local con; con = tweenVal.Changed:Connect(func)
		local tween = TweenService:Create(tweenVal,ti,{Value = n})
		tween:Play()
		tween.Completed:Connect(function()
			if con then con:Disconnect() end
			tweenVal:Destroy()
		end)
	end

	local ti = TweenInfo.new(0.4,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
	tweenNumber(100,ti,function(val)
		val = val/200
		local start = NumberSequenceKeypoint.new(0,0)
		local a1 = NumberSequenceKeypoint.new(val,0)
		local a2 = NumberSequenceKeypoint.new(math.min(0.5,val+math.min(0.05,val)),1)
		if a1.Time == a2.Time then a2 = a1 end
		local b1 = NumberSequenceKeypoint.new(1-val,0)
		local b2 = NumberSequenceKeypoint.new(math.max(0.5,1-val-math.min(0.05,val)),1)
		if b1.Time == b2.Time then b2 = b1 end
		local goal = NumberSequenceKeypoint.new(1,0)
		backGradient.Transparency = NumberSequence.new({start,a1,a2,b2,b1,goal})
		outlinesGradient.Transparency = NumberSequence.new({start,a1,a2,b2,b1,goal})
	end)

	task.wait(0.4)

	tweenNumber(100,ti,function(val)
		val = val/166.66
		local start = NumberSequenceKeypoint.new(0,0)
		local a1 = NumberSequenceKeypoint.new(val,0)
		local a2 = NumberSequenceKeypoint.new(val+0.01,1)
		local goal = NumberSequenceKeypoint.new(1,1)
		holderGradient.Transparency = NumberSequence.new({start,a1,a2,goal})
	end)

	TweenService:Create(titleText,ti,{Position = UDim2.new(0,60,0,15), TextTransparency = 0}):Play()
	TweenService:Create(descText,ti,{Position = UDim2.new(0,20,0,60), TextTransparency = 0}):Play()

	local function rightTextTransparency(obj)
		tweenNumber(100,ti,function(val)
			val = val/100
			local a1 = NumberSequenceKeypoint.new(1-val,0)
			local a2 = NumberSequenceKeypoint.new(math.max(0,1-val-0.01),1)
			if a1.Time == a2.Time then a2 = a1 end
			local start = NumberSequenceKeypoint.new(0,a1 == a2 and 0 or 1)
			local goal = NumberSequenceKeypoint.new(1,0)
			obj.Transparency = NumberSequence.new({start,a2,a1,goal})
		end)
	end

	rightTextTransparency(versionGradient)
	rightTextTransparency(creatorGradient)

	task.wait(0.9)

	local progressTI = TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
	TweenService:Create(statusText,progressTI,{Position = UDim2.new(0,20,0,120), TextTransparency = 0}):Play()
	TweenService:Create(progressBar,progressTI,{Position = UDim2.new(0,60,0,145), Size = UDim2.new(0,100,0,4)}):Play()

	task.wait(0.25)

	local function setProgress(text,n)
		statusText.Text = text
		TweenService:Create(progressBar.Bar,progressTI,{Size = UDim2.new(n,0,1,0)}):Play()
	end

	task.spawn(function()
		task.wait(0.2)
		setProgress("Fetching Roblox Version", 0.2)
		
		task.wait(0.4)
		setProgress("Fetching API", 0.4)
		
		task.spawn(function()
			pcall(function()
				local rawIcons = game:HttpGet("https://raw.githubusercontent.com/sp0zx/Modules/refs/heads/main/Icon_Map.lua")
				local loadFunc = loadstring(rawIcons)
				if loadFunc then
					local result = loadFunc()
					if type(result) == "table" then
						DefaultIcons = result
						DefaultIconsLoaded = true
					end
				end
			end)
		end)

		task.spawn(function()
			pcall(function()
				local rawIcons = game:HttpGet(CONFIG["Urls"]["VanillaIcons"])
				local loadFunc = loadstring(rawIcons)
				if loadFunc then
					local result = loadFunc()
					if type(result) == "table" then
						VanillaIcons = result
						VanillaIconsLoaded = true
					end
				end
			end)
		end)
		FetchAPIDump()
		
		task.wait(0.6)
		setProgress("Fetching RMD", 0.6)
		
		task.wait(0.5)
		setProgress("Loading Modules", 0.8)
		
		task.wait(0.5)
		setProgress("Initializing Modules", 0.9)
		
		task.wait(0.5)
		setProgress("Complete", 1)
		
		task.wait(0.5)
		TweenService:Create(titleText,progressTI,{TextTransparency = 1}):Play()
		TweenService:Create(descText,progressTI,{TextTransparency = 1}):Play()
		TweenService:Create(versionText,progressTI,{TextTransparency = 1}):Play()
		TweenService:Create(creatorText,progressTI,{TextTransparency = 1}):Play()
		TweenService:Create(statusText,progressTI,{TextTransparency = 1}):Play()
		TweenService:Create(progressBar,progressTI,{BackgroundTransparency = 1}):Play()
		TweenService:Create(progressBar.Bar,progressTI,{BackgroundTransparency = 1}):Play()
		TweenService:Create(progressBar.ImageLabel,progressTI,{ImageTransparency = 1}):Play()
		
		tweenNumber(100,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.In),function(val)
			val = val/250
			local start = NumberSequenceKeypoint.new(0,0)
			local a1 = NumberSequenceKeypoint.new(0.6+val,0)
			local a2 = NumberSequenceKeypoint.new(math.min(1,0.601+val),1)
			if a1.Time == a2.Time then a2 = a1 end
			local goal = NumberSequenceKeypoint.new(1,a1 == a2 and 0 or 1)
			holderGradient.Transparency = NumberSequence.new({start,a1,a2,goal})
		end)
		
		task.wait(0.5)
		main.BackgroundTransparency = 1
		outlinesGradient.Rotation = 30
		
		tweenNumber(100,ti,function(val)
			val = val/100
			local start = NumberSequenceKeypoint.new(0,1)
			local a1 = NumberSequenceKeypoint.new(val,1)
			local a2 = NumberSequenceKeypoint.new(math.min(1,val+math.min(0.05,val)),0)
			if a1.Time == a2.Time then a2 = a1 end
			local goal = NumberSequenceKeypoint.new(1,a1 == a2 and 1 or 0)
			outlinesGradient.Transparency = NumberSequence.new({start,a1,a2,goal})
			holderGradient.Transparency = NumberSequence.new({start,a1,a2,goal})
		end)
		
		task.wait(0.45)
		gui:Destroy()
		if onComplete then onComplete() end
	end)
end

local function GetPropertiesModule()
	local PropertiesModule = {}
	local function create(data)
		local insts = {}
		for i,v in pairs(data) do
			insts[v[1]] = Instance.new(v[2])
		end
		for _,v in pairs(data) do
			for prop,val in pairs(v[3]) do
				if type(val) == "table" then
					insts[v[1]][prop] = insts[val[1]]
				else
					insts[v[1]][prop] = val
				end
			end
		end
		if insts[1] then return insts[1] end
		local folder = Instance.new("Folder")
		for _,v in pairs(data) do
			if not v[3].Parent then insts[v[1]].Parent = folder end
		end
		return folder
	end
	local function createSimple(class,props)
		local inst = Instance.new(class)
		for i,v in next,props do inst[i] = v end
		return inst
	end
	local Lib = {}
	Lib["Signal"] = (function()
		local funcs = {}
		funcs.Connect = function(self,func)
			local con = {["Signal"] = self, ["Func"] = func, ["Disconnect"] = function(c)
				local pos = table.find(c["Signal"]["Connections"], c)
				if pos then table.remove(c["Signal"]["Connections"], pos) end
			end}
			self["Connections"][#self["Connections"]+1] = con
			return con
		end
		funcs.Fire = function(self,...)
			for i,v in next,self["Connections"] do
				task.spawn(v["Func"], ...)
			end
		end
		return {["new"] = function() return setmetatable({["Connections"] = {}}, {["__index"] = funcs}) end}
	end)()
	Lib["Checkbox"] = (function()
		local funcs = {}
		funcs.SetState = function(self, val)
			self["Toggled"] = val
			if self["Toggled"] then
				self["GuiElems"]["Checkmark2"].Visible = true
				self["GuiElems"]["Middle"].Visible = false
			else
				self["GuiElems"]["Checkmark2"].Visible = false
				self["GuiElems"]["Middle"].Visible = self["Toggled"] == nil
			end
		end
		return {
			["new"] = function(style)
				local obj = setmetatable({ ["Toggled"] = false, ["Disabled"] = false, ["OnInput"] = Lib["Signal"].new(), ["Style"] = style or 1 }, {["__index"] = funcs})
				local checkbox = create({
					{1,"ImageButton",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Name="Checkbox",Position=UDim2.new(0,3,0,3),Size=UDim2.new(0,16,0,16)}},
					{3,"Frame",{BackgroundColor3=CONFIG["Theme"]["Outline1"],BorderSizePixel=0,Name="outline",Parent={1},Size=UDim2.new(0,16,0,16)}},
					{4,"Frame",{BackgroundColor3=CONFIG["Theme"]["Main1"],BorderSizePixel=0,Name="filler",Parent={3},Position=UDim2.new(0,1,0,1),Size=UDim2.new(0,14,0,14)}},
					{11,"ImageLabel",{AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image=CONFIG["AssetIds"]["Checkmark"],ImageColor3=CONFIG["Theme"]["Text"],Name="checkmark2",Parent={4},Position=UDim2.new(0.5,0,0.5,0),Size=UDim2.new(0,12,0,12),Visible=false}},
					{12,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,Image=CONFIG["AssetIds"]["Middle"],ImageTransparency=0.2,Name="middle",Parent={4},ScaleType=Enum.ScaleType.Slice,Size=UDim2.new(1,0,1,0),TileSize=UDim2.new(0,2,0,2),Visible=false}},
					{13,"UICorner",{CornerRadius=UDim.new(0,2),Parent={3}}}
				})
				obj["Gui"] = checkbox
				obj["GuiElems"] = {
					["Outline"] = checkbox["outline"],
					["Filler"] = checkbox["outline"]["filler"],
					["Checkmark2"] = checkbox["outline"]["filler"]["checkmark2"],
					["Middle"] = checkbox["outline"]["filler"]["middle"]
				}
				TrackConnection(checkbox.Activated:Connect(function()
					if not obj["Disabled"] then obj:SetState(not obj["Toggled"]) end
					obj["OnInput"]:Fire()
				end))
				return obj
			end
		}
	end)()
	Lib["ScrollBar"] = (function()
		local funcs = {}
		funcs.Update = function(self)
			local total, visible, index = self["TotalSpace"], self["VisibleSpace"], self["Index"]
			self["Index"] = math.clamp(self["Index"], 0, math.max(0, total - visible))
			local scrollThumb = self["GuiElems"]["ScrollThumb"]
			if not (self["Index"] > 0 or self["Index"] + visible < total) then
				scrollThumb.Visible = false
			else
				scrollThumb.Visible = true
				if self["Horizontal"] then
					scrollThumb.Size = UDim2.new(visible/total,0,1,0)
					if scrollThumb.AbsoluteSize.X < 16 then scrollThumb.Size = UDim2.new(0,16,1,0) end
					local fs, bs = self["GuiElems"]["ScrollThumbFrame"].AbsoluteSize.X, scrollThumb.AbsoluteSize.X
					scrollThumb.Position = UDim2.new((self["Index"]/(total-visible))*(fs-bs)/fs,0,0,0)
				else
					scrollThumb.Size = UDim2.new(1,0,visible/total,0)
					if scrollThumb.AbsoluteSize.Y < 16 then scrollThumb.Size = UDim2.new(1,0,0,16) end
					local fs, bs = self["GuiElems"]["ScrollThumbFrame"].AbsoluteSize.Y, scrollThumb.AbsoluteSize.Y
					scrollThumb.Position = UDim2.new(0,0,(self["Index"]/(total-visible))*(fs-bs)/fs,0)
				end
			end
		end
		funcs.ScrollTo = function(self, ind)
			self["Index"] = ind
			self:Update()
			self["Scrolled"]:Fire()
		end
		funcs.SetScrollFrame = function(self, frame)
			self["ScrollFrame"] = frame
			TrackConnection(frame.MouseWheelForward:Connect(function()
				self:ScrollTo(self["Index"] - (self["WheelIncrement"] or CONFIG["Settings"]["WheelIncrement"]))
			end))
			TrackConnection(frame.MouseWheelBackward:Connect(function()
				self:ScrollTo(self["Index"] + (self["WheelIncrement"] or CONFIG["Settings"]["WheelIncrement"]))
			end))
		end
		return {
			["new"] = function(hor)
				local obj = setmetatable({ ["Index"] = 0, ["VisibleSpace"] = 0, ["TotalSpace"] = 0, ["Horizontal"] = hor, ["Scrolled"] = Lib["Signal"].new(), ["GuiElems"] = {} }, {["__index"] = funcs})
				local newFrame = createSimple("Frame",{BackgroundColor3=CONFIG["Theme"]["Main1"], BorderColor3=CONFIG["Theme"]["Outline1"], BorderSizePixel=1, Position=UDim2.new(1,-18,0,0), Size=UDim2.new(0,18,1,0), ZIndex=1})
				if hor then newFrame.Size = UDim2.new(1,0,0,18) end
				local scrollThumbFrame = createSimple("TextButton", {Text="", AutoButtonColor=false, BackgroundTransparency = 1, Parent = newFrame})
				if hor then
					scrollThumbFrame.Position = UDim2.new(0,18,0,0)
					scrollThumbFrame.Size = UDim2.new(1,-36,1,0)
				else
					scrollThumbFrame.Position = UDim2.new(0,0,0,18)
					scrollThumbFrame.Size = UDim2.new(1,0,1,-36)
				end
				local scrollThumb = createSimple("Frame", {BackgroundColor3 = CONFIG["Theme"]["Button"], BorderSizePixel = 0, Parent = scrollThumbFrame})

				TrackConnection(scrollThumbFrame.MouseEnter:Connect(function() scrollThumb.BackgroundColor3 = CONFIG["Theme"]["ButtonHover"] end))
				TrackConnection(scrollThumbFrame.MouseLeave:Connect(function() scrollThumb.BackgroundColor3 = CONFIG["Theme"]["Button"] end))
				TrackConnection(scrollThumbFrame.MouseButton1Down:Connect(function() scrollThumb.BackgroundColor3 = CONFIG["Theme"]["ButtonPress"] end))
				TrackConnection(scrollThumbFrame.MouseButton1Up:Connect(function() scrollThumb.BackgroundColor3 = CONFIG["Theme"]["ButtonHover"] end))

				obj["GuiElems"]["ScrollThumb"] = scrollThumb
				obj["GuiElems"]["ScrollThumbFrame"] = scrollThumbFrame
				obj["Gui"] = newFrame
				TrackConnection(newFrame.MouseWheelForward:Connect(function() obj:ScrollTo(obj["Index"] - 3) end))
				TrackConnection(newFrame.MouseWheelBackward:Connect(function() obj:ScrollTo(obj["Index"] + 3) end))
				return obj
			end
		}
	end)()
	Lib["ViewportTextBox"] = (function()
		return {
			["convert"] = function(textbox)
				local view = Instance.new("Frame")
				view.BackgroundTransparency = textbox.BackgroundTransparency
				view.BackgroundColor3 = textbox.BackgroundColor3
				view.BorderSizePixel = textbox.BorderSizePixel
				view.BorderColor3 = textbox.BorderColor3
				view.Position = textbox.Position
				view.Size = textbox.Size
				view.ClipsDescendants = true
				textbox.BackgroundTransparency = 1
				textbox.Position = UDim2.new(0,0,0,0)
				textbox.Size = UDim2.new(1,0,1,0)
				textbox.TextXAlignment = Enum.TextXAlignment.Left
				view.Parent = textbox.Parent
				textbox.Parent = view
				TrackConnection(textbox:GetPropertyChangedSignal("CursorPosition"):Connect(function()
					local text = textbox.Text
					local cursorPos = textbox.CursorPosition
					if text == "" or cursorPos == -1 then textbox.Position = UDim2.new(0,0,0,0) return end
					local cursorText = text:sub(1,cursorPos-1)
					local leftEnd = -textbox.Position.X.Offset
					local rightEnd = leftEnd + view.AbsoluteSize.X
					local totalTextSize = TextService:GetTextSize(text,textbox.TextSize,textbox.Font,Vector2.new(99999,100)).X
					local cursorTextSize = TextService:GetTextSize(cursorText,textbox.TextSize,textbox.Font,Vector2.new(99999,100)).X
					local pos
					if cursorTextSize > rightEnd then pos = math.max(-1,cursorTextSize - view.AbsoluteSize.X + 2)
					elseif cursorTextSize < leftEnd then pos = math.max(-1,cursorTextSize-2)
					elseif totalTextSize < rightEnd then pos = math.max(-1,totalTextSize - view.AbsoluteSize.X + 2) end
					if pos then textbox.Position = UDim2.new(0,-pos,0,0) textbox.Size = UDim2.new(1,pos,1,0) end
				end))
				return textbox
			end
		}
	end)()
	Lib["ColorToBytes"] = function(c)
		return math.floor(c.R*255)..", "..math.floor(c.G*255)..", "..math.floor(c.B*255)
	end
	Lib["Window"] = {}
	Lib["Window"]["new"] = function()
		local obj = {}
		local gui = TrackInstance(Instance.new("ScreenGui"))
		gui.Name = "OnionDialog"
		gui.DisplayOrder = 99999
		local main = Instance.new("Frame", gui)
		main.BackgroundColor3 = CONFIG["Theme"]["Main2"]
		main.BorderColor3 = CONFIG["Theme"]["Outline1"]
		main.BorderSizePixel = 1
		main.Active = true
		main.ClipsDescendants = true
		local topBar = Instance.new("TextButton", main)
		topBar.BackgroundColor3 = CONFIG["Theme"]["Main1"]
		topBar.BorderSizePixel = 0
		topBar.Size = UDim2.new(1, 0, 0, 20)
		topBar.Text = ""
		topBar.AutoButtonColor = false
		local titleLbl = Instance.new("TextLabel", topBar)
		titleLbl.BackgroundTransparency = 1
		titleLbl.Size = UDim2.new(1, -20, 1, 0)
		titleLbl.Position = UDim2.new(0, 5, 0, 0)
		titleLbl.TextColor3 = CONFIG["Theme"]["Text"]
		titleLbl.Font = Enum.Font.SourceSans
		titleLbl.TextSize = 14
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left
		local closeBtn = Instance.new("ImageButton", topBar)
		closeBtn.Size = UDim2.new(0, 20, 0, 20)
		closeBtn.Position = UDim2.new(1, -20, 0, 0)
		closeBtn.Image = ""
		closeBtn.BackgroundTransparency = 1
		local closeIcon = Instance.new("ImageLabel", closeBtn)
		closeIcon.BackgroundTransparency = 1
		closeIcon.Size = UDim2.new(0, 12, 0, 12)
		closeIcon.Position = UDim2.new(0.5, -6, 0.5, -6)
		closeIcon.Image = CONFIG["AssetIds"]["CloseBtn"]
		closeIcon.ImageColor3 = CONFIG["Theme"]["Text"]
		local content = Instance.new("Frame", main)
		content.Name = "Content"
		content.Position = UDim2.new(0, 0, 0, 20)
		content.Size = UDim2.new(1, 0, 1, -20)
		content.BackgroundTransparency = 1
		obj["Gui"] = gui
		obj["GuiElems"] = {["Main"] = main, ["Content"] = content, ["Title"] = titleLbl, ["Close"] = closeBtn, ["TopBar"] = topBar}
		obj["SetTitle"] = function(self, t) titleLbl.Text = t end
		obj["Resize"] = function(self, w, h) main.Size = UDim2.new(0, w, 0, h + 20) end
		obj["Show"] = function(self)
			gui.Parent = GuiParent
			main.Position = UDim2.new(0.5, -main.Size.X.Offset/2, 0.5, -main.Size.Y.Offset/2)
		end
		obj["ShowAndFocus"] = obj["Show"]
		obj["Close"] = function(self) gui.Parent = nil end
		TrackConnection(closeBtn.MouseButton1Click:Connect(function() obj:Close() end))
		local dragging = false
		local dragStart, startPos
		TrackConnection(topBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = main.Position
			end
		end))
		TrackConnection(UIS.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				if dragging then
					local delta = input.Position - dragStart
					main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
				end
			end
		end))
		TrackConnection(UIS.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end))
		return obj
	end
	Lib["ContextMenu"] = {}
	Lib["ContextMenu"]["new"] = function()
		local obj = {["Items"] = {}}
		local gui = TrackInstance(Instance.new("ScreenGui"))
		gui.Name = "ContextMenu"
		gui.DisplayOrder = 100000
		local main = Instance.new("Frame", gui)
		main.BackgroundColor3 = CONFIG["Theme"]["Outline1"]
		main.BorderSizePixel = 0
		main.ClipsDescendants = true
		local container = Instance.new("Frame", main)
		container.Position = UDim2.new(0, 1, 0, 1)
		container.Size = UDim2.new(1, -2, 1, -2)
		container.BackgroundColor3 = CONFIG["Theme"]["Main2"]
		container.BorderSizePixel = 0
		local list = Instance.new("ScrollingFrame", container)
		list.Size = UDim2.new(1, 0, 1, 0)
		list.BackgroundTransparency = 1
		list.ScrollBarThickness = 4
		list.BorderSizePixel = 0
		list.ScrollBarImageColor3 = CONFIG["Theme"]["Button"]
		list.ScrollBarImageTransparency = 0.5
		local layout = Instance.new("UIListLayout", list)
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		obj["Gui"] = gui
		obj["GuiElems"] = {["Main"] = main, ["List"] = list}
		obj["Clear"] = function(self)
			self["Items"] = {}
			for _, child in ipairs(list:GetChildren()) do
				if child ~= layout then child:Destroy() end
			end
		end
		obj["Add"] = function(self, item)
			table.insert(self["Items"], item)
			local btn = Instance.new("TextButton", list)
			btn.Size = UDim2.new(1, 0, 0, 22)
			btn.BackgroundColor3 = CONFIG["Theme"]["Highlight"]
			btn.BackgroundTransparency = 1
			btn.BorderSizePixel = 0
			btn.Text = "  " .. item["Name"]
			btn.TextColor3 = CONFIG["Theme"]["Text"]
			btn.Font = Enum.Font.SourceSans
			btn.TextSize = 14
			btn.TextXAlignment = Enum.TextXAlignment.Left
			TrackConnection(btn.MouseEnter:Connect(function() btn.BackgroundTransparency = 0 end))
			TrackConnection(btn.MouseLeave:Connect(function() btn.BackgroundTransparency = 1 end))
			TrackConnection(btn.MouseButton1Click:Connect(function()
				if item["OnClick"] then item["OnClick"](item["Name"]) end
				self:Hide()
			end))
		end
		obj["Show"] = function(self, x, y)
			gui.Parent = GuiParent
			local targetHeight = math.min(self["MaxHeight"] or 150, #self["Items"] * 22 + 2)
			list.CanvasSize = UDim2.new(0, 0, 0, #self["Items"] * 22)
			main.Position = UDim2.new(0, x, 0, y)
			main.Size = UDim2.new(0, self["Width"] or 150, 0, 0)
			TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {["Size"] = UDim2.new(0, self["Width"] or 150, 0, targetHeight)}):Play()
			local closable = false
			if self["CloseEvent"] then self["CloseEvent"]:Disconnect() end
			self["CloseEvent"] = TrackConnection(UIS.InputBegan:Connect(function(input)
				if not closable then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					local mx, my = input.Position.X, input.Position.Y
					local ax, ay = main.AbsolutePosition.X, main.AbsolutePosition.Y
					local aw, ah = main.AbsoluteSize.X, targetHeight
					if mx < ax or mx > ax + aw or my < ay or my > ay + ah then
						self["CloseEvent"]:Disconnect()
						self:Hide()
					end
				end
			end))
			task.wait(0.1)
			closable = true
		end
		obj["Hide"] = function(self)
			if self["CloseEvent"] then self["CloseEvent"]:Disconnect() end
			TweenService:Create(main, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {["Size"] = UDim2.new(0, self["Width"] or 150, 0, 0)}):Play()
			task.delay(0.15, function() gui.Parent = nil end)
		end
		return obj
	end
	Lib["ColorPicker"] = {}
	Lib["ColorPicker"]["new"] = function()
		local newMt = {["OnSelect"] = Lib["Signal"].new(), ["OnCancel"] = Lib["Signal"].new(), ["OnPreview"] = Lib["Signal"].new()}
		local cpWin, cpContent, toggleFunc = nil, nil, nil
		local colorSpace, colorStrip, previewFrame
		local colorScope, sliderBtn_ref, sliderGrad_ref
		local redTB_r, grnTB_r, bluTB_r, hueTB_r, satTB_r, hexTB_r
		local mouse = Players.LocalPlayer:GetMouse()
		local hue,sat,val = 0,0,1
		local red,green,blue = 1,1,1
		local chosenColor = Color3.new(1,1,1)
		local updateColorVisuals
		local function buildUI(contentFrame)
			local cpFrame = Instance.new("Frame")
			cpFrame.Name = "ColorPickerFrame"
			cpFrame.BackgroundColor3 = CONFIG["Theme"]["Main2"]
			cpFrame.BorderSizePixel = 0
			cpFrame.Size = UDim2.new(1,0,1,0)
			cpFrame.ClipsDescendants = true
			cpFrame.Parent = contentFrame
			cpFrame.Active = true

			local cb = Instance.new("Frame")
			cb.Name = "ColorBox"; cb.BackgroundColor3 = Color3.fromRGB(3,3,3)
			cb.BorderSizePixel = 0; cb.Position = UDim2.new(0,10,0,10)
			cb.Size = UDim2.new(0,215,0,200); cb.Parent = cpFrame
			local imgLbl = Instance.new("ImageLabel")
			imgLbl.Name = "ImageLabel"; imgLbl.BackgroundTransparency = 1
			imgLbl.BorderSizePixel = 0; imgLbl.Size = UDim2.new(1,0,1,0)
			imgLbl.Image = "rbxassetid://80712561731148"; imgLbl.Parent = cb
			imgLbl.Active = true
			local ch = Instance.new("ImageLabel")
			ch.Name = "Crosshair"; ch.BackgroundTransparency = 1
			ch.BorderSizePixel = 0; ch.Size = UDim2.new(0,28,0,28)
			ch.AnchorPoint = Vector2.new(0.5,0.5)
			ch.Image = "rbxassetid://7028065119"; ch.ZIndex = 2; ch.Parent = cb

			local vs = Instance.new("Frame")
			vs.Name = "ValueSlider"; vs.BackgroundColor3 = Color3.fromRGB(3,3,3)
			vs.BorderSizePixel = 0; vs.Position = UDim2.new(0,235,0,10)
			vs.Size = UDim2.new(0,18,0,200); vs.Parent = cpFrame
			vs.Active = true
			local sGrad = Instance.new("UIGradient")
			sGrad.Name = "UIGradient"; sGrad.Rotation = 90; sGrad.Parent = vs
			local sBtn = Instance.new("ImageButton")
			sBtn.Name = "ImageButton"; sBtn.BackgroundTransparency = 1
			sBtn.BorderSizePixel = 0; sBtn.Size = UDim2.new(0,18,0,18)
			sBtn.AnchorPoint = Vector2.new(0.5,0.5)
			sBtn.Position = UDim2.new(1,0,0,0)
			sBtn.Image = "rbxassetid://4841250241"
			sBtn.ImageColor3 = Color3.fromRGB(5,5,5); sBtn.ZIndex = 2; sBtn.Parent = vs

			local mc = Instance.new("Frame")
			mc.Name = "MainColor"; mc.BackgroundColor3 = Color3.fromRGB(3,3,3)
			mc.BorderSizePixel = 0; mc.Position = UDim2.new(0,270,0,220)
			mc.Size = UDim2.new(0,70,0,120); mc.Parent = cpFrame

			local function mkInput(parent, name, xPos, yPos, w, labelText, ph)
				local f = Instance.new("Frame")
				f.Name = name; f.BackgroundColor3 = CONFIG["Theme"]["Main1"]
				f.BorderSizePixel = 0; f.Position = UDim2.new(0,xPos,0,yPos)
				f.Size = UDim2.new(0,w,0,24); f.Parent = parent

				local lbl = Instance.new("TextLabel",f)
				lbl.BackgroundTransparency = 1; lbl.BorderSizePixel = 0
				lbl.Position = UDim2.new(0,-42,0,0); lbl.Size = UDim2.new(0,38,1,0)
				lbl.Font = Enum.Font.SourceSans; lbl.Text = labelText
				lbl.TextColor3 = Color3.fromRGB(230,230,235); lbl.TextSize = 13
				lbl.TextXAlignment = Enum.TextXAlignment.Right
				local tb = Instance.new("TextBox",f)
				tb.Name = "TextBox"; tb.BackgroundTransparency = 1; tb.BorderSizePixel = 0
				tb.Size = UDim2.new(1,0,1,0); tb.Font = Enum.Font.SourceSans
				tb.PlaceholderText = ph or "0"
				tb.PlaceholderColor3 = Color3.fromRGB(100,108,130)
				tb.Text = ""; tb.TextColor3 = Color3.fromRGB(230,230,235); tb.TextSize = 13
				tb.TextXAlignment = Enum.TextXAlignment.Left
				local pad = Instance.new("UIPadding",tb); pad.PaddingLeft = UDim.new(0,5)
				return tb
			end

			local colRX, colRY = 390, 220
			local colHX = 485
			local hueTB  = mkInput(cpFrame,"Hue",   colHX, colRY,     52, "Hue:",   "0")
			local satTB  = mkInput(cpFrame,"Sat",   colHX, colRY+30,  52, "Sat:",   "0")
			local valTB  = mkInput(cpFrame,"Val",   colHX, colRY+60,  52, "Val:",   "0")
			local redTB  = mkInput(cpFrame,"Red",   colRX, colRY,     52, "Red:",   "0")
			local grnTB  = mkInput(cpFrame,"Green", colRX, colRY+30,  52, "Green:", "0")
			local bluTB  = mkInput(cpFrame,"Blue",  colRX, colRY+60,  52, "Blue:",  "0")
			local hexTB  = mkInput(cpFrame,"Hex",   colRX+30, colRY+96, 122, "Hex:",   "#ffffff")

			local bct = Instance.new("Frame")
			bct.Name = "BasicColorsTable"; bct.BackgroundTransparency = 1
			bct.BorderSizePixel = 0; bct.Position = UDim2.new(0,270,0,10)
			bct.Size = UDim2.new(0,265,0,200); bct.ClipsDescendants = true; bct.Parent = cpFrame
			local bctGrid = Instance.new("UIGridLayout",bct)
			bctGrid.CellPadding = UDim2.new(0,2,0,2); bctGrid.CellSize = UDim2.new(0,20,0,20)
			bctGrid.FillDirectionMaxCells = 12
			bctGrid.SortOrder = Enum.SortOrder.LayoutOrder
			local basicColors = {
				Color3.fromRGB(0,0,0),Color3.fromRGB(127,127,127),Color3.fromRGB(170,0,0),Color3.fromRGB(0,85,0),Color3.fromRGB(170,85,0),
				Color3.fromRGB(0,170,0),Color3.fromRGB(170,170,0),Color3.fromRGB(0,255,0),Color3.fromRGB(170,255,0),
				Color3.fromRGB(0,0,127),Color3.fromRGB(170,0,127),Color3.fromRGB(0,85,127),
				Color3.fromRGB(170,85,127),Color3.fromRGB(0,170,127),Color3.fromRGB(170,170,127),Color3.fromRGB(0,255,127),Color3.fromRGB(170,255,127),
				Color3.fromRGB(85,0,0),Color3.fromRGB(255,0,0),Color3.fromRGB(85,85,0),Color3.fromRGB(255,85,0),
				Color3.fromRGB(85,170,0),Color3.fromRGB(255,170,0),Color3.fromRGB(85,255,0),Color3.fromRGB(255,255,0),
				Color3.fromRGB(85,0,127),Color3.fromRGB(255,0,127),Color3.fromRGB(85,85,127),Color3.fromRGB(255,85,127),
				Color3.fromRGB(85,170,127),Color3.fromRGB(255,170,127),Color3.fromRGB(85,255,127),Color3.fromRGB(255,255,127),
				Color3.fromRGB(85,0,255),Color3.fromRGB(255,0,255),Color3.fromRGB(85,85,255),Color3.fromRGB(255,85,255),
				Color3.fromRGB(85,170,255),Color3.fromRGB(255,170,255),Color3.fromRGB(85,255,255),Color3.fromRGB(255,255,255),
				Color3.fromRGB(4,4,4),Color3.fromRGB(3,3,3),Color3.fromRGB(3,3,3),
				Color3.fromRGB(255,128,0),Color3.fromRGB(128,0,255),Color3.fromRGB(0,128,255),
				Color3.fromRGB(255,0,128),Color3.fromRGB(0,255,128),Color3.fromRGB(128,255,0),
				Color3.fromRGB(255,200,200),Color3.fromRGB(200,255,200),Color3.fromRGB(200,200,255),
				Color3.fromRGB(255,128,128),Color3.fromRGB(128,255,128),Color3.fromRGB(128,128,255),
				Color3.fromRGB(64,0,0),Color3.fromRGB(0,64,0),Color3.fromRGB(0,0,64),
				Color3.fromRGB(128,64,0),Color3.fromRGB(64,128,0),Color3.fromRGB(0,128,64),
				Color3.fromRGB(0,64,128),Color3.fromRGB(64,0,128),Color3.fromRGB(128,0,64),
				Color3.fromRGB(255,200,100),Color3.fromRGB(100,200,255),Color3.fromRGB(200,100,255),
			}
			for i, bc in ipairs(basicColors) do
				local sw = Instance.new("TextButton",bct)
				sw.LayoutOrder = i; sw.BackgroundColor3 = bc
				sw.BorderSizePixel = 1; sw.BorderColor3 = Color3.fromRGB(5,5,5)
				sw.Text = ""; sw.AutoButtonColor = false
				local bcRef = bc
				TrackConnection(sw.MouseButton1Click:Connect(function()
					red,green,blue = bcRef.R,bcRef.G,bcRef.B
					hue,sat,val = Color3.toHSV(bcRef)
					chosenColor = bcRef
					if updateColorVisuals then updateColorVisuals() end
				end))
			end

			local extraLabel = Instance.new("TextLabel")
			extraLabel.Name = "ExtraColorsLabel"; extraLabel.BackgroundTransparency = 1
			extraLabel.BorderSizePixel = 0; extraLabel.Position = UDim2.new(0,10,0,218)
			extraLabel.Size = UDim2.new(0,240,0,16); extraLabel.Parent = cpFrame
			extraLabel.Font = Enum.Font.SourceSansSemibold; extraLabel.Text = "EXTRA COLORS"
			extraLabel.TextColor3 = Color3.fromRGB(120,126,145); extraLabel.TextSize = 11
			extraLabel.TextXAlignment = Enum.TextXAlignment.Left

			local ect = Instance.new("Frame")
			ect.Name = "ExtraColorsTable"; ect.BackgroundTransparency = 1
			ect.BorderSizePixel = 0; ect.Position = UDim2.new(0,10,0,236)
			ect.Size = UDim2.new(0,245,0,140); ect.ClipsDescendants = true; ect.Parent = cpFrame
			local ectGrid = Instance.new("UIGridLayout",ect)
			ectGrid.CellPadding = UDim2.new(0,2,0,2); ectGrid.CellSize = UDim2.new(0,14,0,14)
			ectGrid.FillDirectionMaxCells = 16
			ectGrid.SortOrder = Enum.SortOrder.LayoutOrder
			local extraColors = {
				Color3.fromRGB(255,204,204),Color3.fromRGB(255,153,153),Color3.fromRGB(255,102,102),Color3.fromRGB(255,51,51),
				Color3.fromRGB(204,0,0),Color3.fromRGB(153,0,0),Color3.fromRGB(102,0,0),Color3.fromRGB(51,0,0),
				Color3.fromRGB(204,255,204),Color3.fromRGB(153,255,153),Color3.fromRGB(102,255,102),Color3.fromRGB(51,255,51),
				Color3.fromRGB(0,204,0),Color3.fromRGB(0,153,0),Color3.fromRGB(0,102,0),Color3.fromRGB(0,51,0),
				Color3.fromRGB(204,204,255),Color3.fromRGB(153,153,255),Color3.fromRGB(102,102,255),Color3.fromRGB(51,51,255),
				Color3.fromRGB(0,0,204),Color3.fromRGB(0,0,153),Color3.fromRGB(0,0,102),Color3.fromRGB(0,0,51),
				Color3.fromRGB(255,255,204),Color3.fromRGB(255,255,153),Color3.fromRGB(255,255,102),Color3.fromRGB(255,255,51),
				Color3.fromRGB(204,204,0),Color3.fromRGB(153,153,0),Color3.fromRGB(102,102,0),Color3.fromRGB(51,51,0),
				Color3.fromRGB(255,204,255),Color3.fromRGB(255,153,255),Color3.fromRGB(255,102,255),Color3.fromRGB(255,51,255),
				Color3.fromRGB(204,0,204),Color3.fromRGB(153,0,153),Color3.fromRGB(102,0,102),Color3.fromRGB(51,0,51),
				Color3.fromRGB(204,255,255),Color3.fromRGB(153,255,255),Color3.fromRGB(102,255,255),Color3.fromRGB(51,255,255),
				Color3.fromRGB(0,204,204),Color3.fromRGB(0,153,153),Color3.fromRGB(0,102,102),Color3.fromRGB(0,51,51),
				Color3.fromRGB(255,228,196),Color3.fromRGB(255,183,128),Color3.fromRGB(255,140,64),Color3.fromRGB(230,115,0),
				Color3.fromRGB(179,89,0),Color3.fromRGB(128,64,0),Color3.fromRGB(77,38,0),Color3.fromRGB(38,19,0),
				Color3.fromRGB(210,180,222),Color3.fromRGB(180,130,200),Color3.fromRGB(150,80,180),Color3.fromRGB(120,40,160),
				Color3.fromRGB(90,0,140),Color3.fromRGB(70,0,110),Color3.fromRGB(50,0,80),Color3.fromRGB(30,0,50),
			}
			for i, ec in ipairs(extraColors) do
				local sw = Instance.new("TextButton",ect)
				sw.LayoutOrder = i; sw.BackgroundColor3 = ec
				sw.BorderSizePixel = 1; sw.BorderColor3 = Color3.fromRGB(5,5,5)
				sw.Text = ""; sw.AutoButtonColor = false
				local ecRef = ec
				TrackConnection(sw.MouseButton1Click:Connect(function()
					red,green,blue = ecRef.R,ecRef.G,ecRef.B
					hue,sat,val = Color3.toHSV(ecRef)
					chosenColor = ecRef
					if updateColorVisuals then updateColorVisuals() end
				end))
			end

			local okF = Instance.new("Frame")
			okF.Name = "Ok"; okF.BackgroundColor3 = CONFIG["Theme"]["Main1"]
			okF.BorderSizePixel = 0; okF.Position = UDim2.new(1,-160,1,-35)
			okF.Size = UDim2.new(0,73,0,25); okF.Parent = cpFrame
			local okBtn = Instance.new("TextButton",okF)
			okBtn.BackgroundTransparency = 1; okBtn.BorderSizePixel = 0
			okBtn.Size = UDim2.new(1,0,1,0); okBtn.Font = Enum.Font.SourceSans
			okBtn.Text = "Ok"; okBtn.TextColor3 = Color3.fromRGB(230,230,235); okBtn.TextSize = 14

			local cancelF = Instance.new("Frame")
			cancelF.Name = "Cancel"; cancelF.BackgroundColor3 = CONFIG["Theme"]["Main1"]
			cancelF.BorderSizePixel = 0; cancelF.Position = UDim2.new(1,-80,1,-35)
			cancelF.Size = UDim2.new(0,73,0,25); cancelF.Parent = cpFrame
			local cancelBtn = Instance.new("TextButton",cancelF)
			cancelBtn.BackgroundTransparency = 1; cancelBtn.BorderSizePixel = 0
			cancelBtn.Size = UDim2.new(1,0,1,0); cancelBtn.Font = Enum.Font.SourceSans
			cancelBtn.Text = "Cancel"; cancelBtn.TextColor3 = Color3.fromRGB(230,230,235); cancelBtn.TextSize = 14

			colorSpace = imgLbl; colorScope = ch
			colorStrip = vs; sliderBtn_ref = sBtn; sliderGrad_ref = sGrad
			previewFrame = mc
			redTB_r = redTB; grnTB_r = grnTB; bluTB_r = bluTB
			hueTB_r = hueTB; satTB_r = satTB; valTB_r = valTB; hexTB_r = hexTB

			updateColorVisuals = function()
				local as = colorSpace.AbsoluteSize
				colorScope.Position = UDim2.new(0, hue*as.X, 0, (1-sat)*as.Y)
				sliderGrad_ref.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromHSV(hue,sat,1)),
					ColorSequenceKeypoint.new(1, Color3.new(0,0,0))
				})
				sliderBtn_ref.Position = UDim2.new(1,0,0,(1-val)*colorStrip.AbsoluteSize.Y)
				previewFrame.BackgroundColor3 = chosenColor
				redTB_r.Text  = tostring(math.floor(red*255+0.5))
				grnTB_r.Text  = tostring(math.floor(green*255+0.5))
				bluTB_r.Text  = tostring(math.floor(blue*255+0.5))
				hueTB_r.Text  = tostring(math.floor(hue*360))
				satTB_r.Text  = tostring(math.floor(sat*100))
				valTB_r.Text  = tostring(math.floor(val*100))
				hexTB_r.Text  = string.format("#%02X%02X%02X",math.floor(red*255+0.5),math.floor(green*255+0.5),math.floor(blue*255+0.5))
				newMt["Color"] = chosenColor
				newMt["OnPreview"]:Fire(chosenColor)
			end

			local function getMouseLocation()
				local pos = UIS:GetMouseLocation()
				local inset = game:GetService("GuiService"):GetGuiInset()
				return Vector2.new(pos.X - inset.X, pos.Y - inset.Y)
			end

			TrackConnection(imgLbl.InputBegan:Connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseButton1 then
					task.spawn(function()
						while UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
							local ap = imgLbl.AbsolutePosition; local as = imgLbl.AbsoluteSize
							local mLoc = getMouseLocation()
							hue = math.clamp(mLoc.X-ap.X,0,as.X)/as.X
							sat = 1 - math.clamp(mLoc.Y-ap.Y,0,as.Y)/as.Y
							local c = Color3.fromHSV(hue,sat,val)
							red,green,blue = c.R,c.G,c.B; chosenColor = c
							updateColorVisuals(); task.wait()
						end
					end)
				end
			end))

			local function startSlider(inp)
				if inp.UserInputType == Enum.UserInputType.MouseButton1 then
					task.spawn(function()
						while UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
							local ap = vs.AbsolutePosition; local as = vs.AbsoluteSize
							local mLoc = getMouseLocation()
							val = 1 - math.clamp(mLoc.Y-ap.Y,0,as.Y)/as.Y
							local c = Color3.fromHSV(hue,sat,val)
							red,green,blue = c.R,c.G,c.B; chosenColor = c; updateColorVisuals()
							task.wait()
						end
					end)
				end
			end
			TrackConnection(vs.InputBegan:Connect(startSlider))
			TrackConnection(sBtn.InputBegan:Connect(startSlider))

			local function applyRGB()
				red = math.clamp(tonumber(redTB.Text) or 0,0,255)/255
				green = math.clamp(tonumber(grnTB.Text) or 0,0,255)/255
				blue = math.clamp(tonumber(bluTB.Text) or 0,0,255)/255
				hue,sat,val = Color3.toHSV(Color3.new(red,green,blue))
				chosenColor = Color3.new(red,green,blue); updateColorVisuals()
			end
			local function applyHSV()
				hue = math.clamp(tonumber(hueTB.Text) or 0,0,360)/360
				sat = math.clamp(tonumber(satTB.Text) or 0,0,100)/100
				val = math.clamp(tonumber(valTB.Text) or 0,0,100)/100
				local c = Color3.fromHSV(hue,sat,val)
				red,green,blue = c.R,c.G,c.B; chosenColor = c; updateColorVisuals()
			end
			local function applyHex()
				pcall(function()
					local c = Color3.fromHex(hexTB.Text:gsub("#",""))
					red,green,blue = c.R,c.G,c.B; hue,sat,val = Color3.toHSV(c)
					chosenColor = c; updateColorVisuals()
				end)
			end
			TrackConnection(redTB.FocusLost:Connect(applyRGB))
			TrackConnection(grnTB.FocusLost:Connect(applyRGB))
			TrackConnection(bluTB.FocusLost:Connect(applyRGB))
			TrackConnection(hueTB.FocusLost:Connect(applyHSV))
			TrackConnection(satTB.FocusLost:Connect(applyHSV))
			TrackConnection(valTB.FocusLost:Connect(applyHSV))
			TrackConnection(hexTB.FocusLost:Connect(applyHex))

			TrackConnection(okBtn.MouseButton1Click:Connect(function() newMt["OnSelect"]:Fire(chosenColor) if toggleFunc then toggleFunc(false) end end))
			TrackConnection(cancelBtn.MouseButton1Click:Connect(function() newMt["OnCancel"]:Fire() if toggleFunc then toggleFunc(false) end end))

			updateColorVisuals()
		end

		newMt["SetColor"] = function(self, color)
			red,green,blue = color.R,color.G,color.B
			hue,sat,val = Color3.toHSV(color)
			chosenColor = color
			if updateColorVisuals then updateColorVisuals() end
		end

		newMt["Show"] = function(self)
			if not cpWin then
				if _G.Onion["CreateDock"] then
					cpWin, cpContent, toggleFunc = _G.Onion["CreateDock"]("Color Picker", CONFIG["AssetIds"]["PropertiesDock"], nil, {Resizable=false, ShowInMenu=false, InitialSize=UDim2.fromOffset(550, 413)})
					buildUI(cpContent)
				end
			end
			if cpWin then
				if toggleFunc then toggleFunc(true) end
				if updateColorVisuals then updateColorVisuals() end
			end
		end

		return newMt
	end

	Lib["BrickColorPicker"] = {}
	Lib["BrickColorPicker"]["new"] = function()
		local newMt = {["OnSelect"] = Lib["Signal"].new(), ["OnCancel"] = Lib["Signal"].new(), ["OnPreview"] = Lib["Signal"].new(), ["OnMoreColors"] = Lib["Signal"].new()}
		local bcpWin, bcpContent, toggleFunc = nil, nil, nil

		local function buildUI(contentFrame)
			local cpFrame = Instance.new("Frame")
			cpFrame.Name = "BrickColorPickerFrame"
			cpFrame.BackgroundColor3 = CONFIG["Theme"]["Main2"]
			cpFrame.BorderSizePixel = 0
			cpFrame.Size = UDim2.new(1,0,1,0)
			cpFrame.ClipsDescendants = true
			cpFrame.Parent = contentFrame
			cpFrame.Active = true

			local hex = Instance.new("ImageLabel")
			hex.BackgroundTransparency = 1
			hex.Image = CONFIG["AssetIds"]["Hex"]
			hex.ImageColor3 = Color3.new(0.33,0.33,0.49)
			hex.Size = UDim2.new(0,35,0,35)
			hex.Visible = false

			local paletteCount = 0
			local function getMouseLocation()
				local pos = UIS:GetMouseLocation()
				local inset = game:GetService("GuiService"):GetGuiInset()
				return Vector2.new(pos.X - inset.X, pos.Y - inset.Y)
			end

			local function isMouseInHexagon(hexObj, touchPos)
				local relativeX = touchPos.X - hexObj.AbsolutePosition.X
				local relativeY = touchPos.Y - hexObj.AbsolutePosition.Y
				if relativeX >= 4 and relativeX < 4 + 27 then
					relativeX = relativeX - 4
					local relativeWidth = (13 - math.min(relativeX, 26 - relativeX)) / 13
					if relativeY >= 1 + 8 * relativeWidth and relativeY < hexObj.AbsoluteSize.Y - 1 - 8 * relativeWidth then return true end
				end
				return false
			end

			local function hexInput(hexObj, color)
				TrackConnection(hexObj.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if isMouseInHexagon(hexObj, getMouseLocation()) then
							newMt["OnSelect"]:Fire(color)
							if toggleFunc then toggleFunc(false) end
						end
					end
				end))
				TrackConnection(hexObj.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						if isMouseInHexagon(hexObj, getMouseLocation()) then
							newMt["OnPreview"]:Fire(color)
						end
					end
				end))
			end

			for row = 1,13 do
				local columns = math.min(row,14-row)+6
				for column = 1,columns do
					local nextColor = BrickColor.palette(paletteCount).Color
					local newHex = hex:Clone()
					newHex.Position = UDim2.new(0, (column-1)*25-(columns-7)*13+3*26 + 1, 0, (row-1)*23 + 4)
					newHex.ImageColor3 = nextColor
					newHex.Visible = true
					hexInput(newHex,nextColor)
					newHex.Parent = cpFrame
					paletteCount = paletteCount + 1
				end
			end

			local moreBtn = Instance.new("TextButton")
			moreBtn.Name = "MoreColors"
			moreBtn.BackgroundColor3 = CONFIG["Theme"]["Button"]
			moreBtn.BorderColor3 = CONFIG["Theme"]["Outline1"]
			moreBtn.BorderSizePixel = 0
			moreBtn.Position = UDim2.new(0,5,1,-30)
			moreBtn.Size = UDim2.new(1,-10,0,25)
			moreBtn.Font = Enum.Font.SourceSans
			moreBtn.Text = "More Colors"
			moreBtn.TextColor3 = CONFIG["Theme"]["Text"]
			moreBtn.TextSize = 14
			moreBtn.Parent = cpFrame
			Instance.new("UICorner", moreBtn).CornerRadius = UDim.new(0,4)

			TrackConnection(moreBtn.MouseButton1Click:Connect(function()
				newMt["OnMoreColors"]:Fire()
				if toggleFunc then toggleFunc(false) end
			end))

			newMt["SetMoreColorsVisible"] = function(self,vis) moreBtn.Visible = vis end
		end

		newMt["SetMoreColorsVisible"] = function(self,vis) end

		newMt["Show"] = function(self,x,y,prevColor)
			if not bcpWin then
				if _G.Onion["CreateDock"] then
					bcpWin, bcpContent, toggleFunc = _G.Onion["CreateDock"]("BrickColor Picker", CONFIG["AssetIds"]["PropertiesDock"], nil, {Resizable=false, ShowInMenu=false, InitialSize=UDim2.fromOffset(340, 405)})
					buildUI(bcpContent)
				end
			end
			if bcpWin then
				if toggleFunc then toggleFunc(true) end
			end
		end

		return newMt
	end

	local Properties = {}
	local API, RMD
	local scrollV, scrollH
	local categoryOrder
	local props, viewList, expanded, indexableProps, propEntries, autoUpdateObjs = {},{},{},{},{},{}
	local inputBox, inputTextBox, inputProp
	local checkboxes, propCons = {},{}

	Properties["GuiElems"] = {}
	Properties["Index"] = 0
	Properties["ViewWidth"] = 0
	Properties["MinInputWidth"] = 100
	Properties["EntryIndent"] = 16
	Properties["EntryOffset"] = 4
	Properties["SearchText"] = ""
	Properties["SelectionList"] = {}

	Properties["IgnoreProps"] = {
		["DataModel"] = {
			["PrivateServerId"] = true,
			["PrivateServerOwnerId"] = true,
			["VIPServerId"] = true,
			["VIPServerOwnerId"] = true
		}
	}

	Properties["ExpandableTypes"] = {
		["Vector2"]=true, ["Vector3"]=true, ["UDim"]=true, ["UDim2"]=true, ["CFrame"]=true,
		["Rect"]=true, ["PhysicalProperties"]=true, ["Ray"]=true, ["NumberRange"]=true,
		["Faces"]=true, ["Axes"]=true
	}

	Properties["ConflictSubProps"] = {
		["Vector2"] = {"X","Y"},
		["Vector3"] = {"X","Y","Z"},
		["UDim"] = {"Scale","Offset"},
		["UDim2"] = {"X","X.Scale","X.Offset","Y","Y.Scale","Y.Offset"},
		["CFrame"] = {"Position","Position.X","Position.Y","Position.Z","RightVector","RightVector.X","RightVector.Y","RightVector.Z","UpVector","UpVector.X","UpVector.Y","UpVector.Z","LookVector","LookVector.X","LookVector.Y","LookVector.Z"},
		["Rect"] = {"Min.X","Min.Y","Max.X","Max.Y"},
		["PhysicalProperties"] = {"Density","Elasticity","ElasticityWeight","Friction","FrictionWeight"},
		["Ray"] = {"Origin","Origin.X","Origin.Y","Origin.Z","Direction","Direction.X","Direction.Y","Direction.Z"},
		["NumberRange"] = {"Min","Max"},
		["Faces"] = {"Back","Bottom","Front","Left","Right","Top"},
		["Axes"] = {"X","Y","Z"}
	}

	Properties["ToNumberTypes"] = {
		["int"]=true, ["int64"]=true, ["float"]=true, ["double"]=true
	}

	Properties["StringToValue"] = function(prop,str)
		local typeName = prop["ValueType"]["Name"]
		if typeName == "string" or typeName == "Content" then return str
		elseif Properties["ToNumberTypes"][typeName] then return tonumber(str)
		elseif typeName == "Vector2" then local v=str:split(",") return #v>=2 and Vector2.new(tonumber(v[1]),tonumber(v[2]))
		elseif typeName == "Vector3" then local v=str:split(",") return #v>=3 and Vector3.new(tonumber(v[1]),tonumber(v[2]),tonumber(v[3]))
		elseif typeName == "UDim" then local v=str:split(",") return #v>=2 and UDim.new(tonumber(v[1]),tonumber(v[2]))
		elseif typeName == "UDim2" then local v=str:gsub("[{}]",""):split(",") return #v>=4 and UDim2.new(tonumber(v[1]),tonumber(v[2]),tonumber(v[3]),tonumber(v[4]))
		elseif typeName == "Color3" then local v=str:gsub("[{}]",""):split(",") local s,r = pcall(Color3.fromRGB,unpack(v)) if s and #v>=3 then return r end
		end return nil
	end

	Properties["ValueToString"] = function(prop,val)
		local typeName = prop["ValueType"]["Name"]
		if typeName == "Color3" then
			return string.format("%d, %d, %d", math.round(val.R*255), math.round(val.G*255), math.round(val.B*255))
		elseif typeName == "NumberRange" then
			return val.Min..", "..val.Max
		end
		return tostring(val)
	end

	Properties["GetIndexableProps"] = function(obj,classData)
		local ignoreProps = Properties["IgnoreProps"][classData["Name"]] or {}
		local result, count = {}, 1
		for i = 1,#classData["Properties"] do
			local prop = classData["Properties"][i]
			if not ignoreProps[prop["Name"]] then
				if pcall(function() return obj[prop["Name"]] end) then
					result[count] = prop count = count + 1
				end
			end
		end
		return result
	end

	Properties["NewPropEntry"] = function(index)
		local newEntry = Properties["EntryTemplate"]:Clone()
		local nameFrame = newEntry["NameFrame"]
		local valueFrame = newEntry["ValueFrame"]
		local newCheckbox = Lib["Checkbox"]["new"](1)
		newCheckbox["Gui"].Position = UDim2.new(0,3,0,3)
		newCheckbox["Gui"].Parent = valueFrame
		TrackConnection(newCheckbox["OnInput"]:Connect(function()
			local prop = viewList[index + Properties["Index"]]
			if prop then Properties["SetProp"](prop, newCheckbox["Toggled"]) end
		end))
		checkboxes[index] = newCheckbox
		newEntry.Position = UDim2.new(0,0,0,23*(index-1))

		TrackConnection(nameFrame["Expand"].MouseButton1Down:Connect(function()
			local prop = viewList[index + Properties["Index"]]
			if not prop then return end
			local fullName = (prop["CategoryName"] and "CAT_"..prop["CategoryName"]) or prop["Class"].."."..prop["Name"]..(prop["SubName"] or "")
			expanded[fullName] = not expanded[fullName]
			newEntry["NameFrame"]["Expand"]["Icon"].ImageRectOffset = expanded[fullName] and Vector2.new(144, 16) or Vector2.new(144, 0)
			newEntry["NameFrame"]["Expand"]["Icon"].Rotation = 0
			Properties["Update"]()
			Properties["Refresh"]()
		end))

		TrackConnection(valueFrame["ValueBox"].MouseButton1Down:Connect(function()
			local prop = viewList[index + Properties["Index"]]
			if prop then
				if prop["ValueType"]["Category"] == "Enum" and inputProp == prop and Properties["EnumDropdown"] and Properties["EnumDropdown"]["Gui"].Parent == GuiParent then
					Properties["EnumDropdown"]:Hide()
					inputProp = nil
					Properties["Refresh"]()
				else
					Properties["SetInputProp"](prop, index)
				end
			end
		end))
		TrackConnection(valueFrame["ColorButton"].MouseButton1Down:Connect(function()
			local prop = viewList[index + Properties["Index"]]
			if prop then Properties["SetInputProp"](prop, index, "color") end
		end))
		newEntry.Parent = Properties["GuiElems"]["PropsFrame"]
		local iconFrame = Instance.new("ImageLabel")
		iconFrame.BackgroundTransparency = 1
		iconFrame.Image = CONFIG["AssetIds"]["PropIcon"]
		iconFrame.Size = UDim2.new(0, 16, 0, 16)
		iconFrame.Position = UDim2.new(0, 2, 0, 3)
		iconFrame.Parent = valueFrame["RightButton"]
		TrackConnection(valueFrame["RightButton"].MouseButton1Click:Connect(function()
			local prop = viewList[index + Properties["Index"]]
			if not prop then return end
			local fullName = prop["Class"].."."..prop["Name"]..(prop["SubName"] or "")
			local inputFullName = inputProp and (inputProp["Class"].."."..inputProp["Name"]..(inputProp["SubName"] or ""))
			if fullName == inputFullName and inputProp["ValueType"]["Category"] == "Class" then
				inputProp = nil
				Properties["SetProp"](prop, nil)
			else
				Properties["SetInputProp"](prop, index, "right")
			end
		end))
		return {
			["Gui"] = newEntry,
			["GuiElems"] = {
				["NameFrame"] = nameFrame, ["ValueFrame"] = valueFrame,
				["PropName"] = nameFrame["PropName"], ["ValueBox"] = valueFrame["ValueBox"],
				["Expand"] = nameFrame["Expand"], ["Checkbox"] = valueFrame["Checkbox"],
				["RowButton"] = newEntry["RowButton"], ["EditAttributeButton"] = newEntry["EditAttributeButton"],
				["ToggleAttributes"] = nameFrame["ToggleAttributes"],
				["ColorButton"] = valueFrame["ColorButton"], ["ColorPreview"] = valueFrame["ColorButton"]["ColorPreview"],
				["Gradient"] = valueFrame["ColorButton"]["ColorPreview"]["UIGradient"], ["EnumArrow"] = valueFrame["EnumArrow"],
				["RightButton"] = valueFrame["RightButton"], ["RightButtonIcon"] = iconFrame
			}
		}
	end

	Properties["MakeSubProp"] = function(prop,subName,valueType,displayName)
		local subProp = {}
		for i,v in pairs(prop) do subProp[i] = v end
		subProp["RootType"] = subProp["RootType"] or subProp["ValueType"]
		subProp["ValueType"] = valueType
		subProp["SubName"] = subProp["SubName"] and (subProp["SubName"]..subName) or subName
		subProp["DisplayName"] = displayName
		return subProp
	end

	Properties["GetExpandedProps"] = function(prop)
		local result = {}
		local typeName = prop["ValueType"]["Name"]
		local msp = Properties["MakeSubProp"]
		if typeName == "Vector2" then
			result[1]=msp(prop,".X",{["Name"]="float"}) result[2]=msp(prop,".Y",{["Name"]="float"})
		elseif typeName == "Vector3" then
			result[1]=msp(prop,".X",{["Name"]="float"}) result[2]=msp(prop,".Y",{["Name"]="float"}) result[3]=msp(prop,".Z",{["Name"]="float"})
		elseif typeName == "UDim2" then
			result[1]=msp(prop,".X",{["Name"]="UDim"}) result[2]=msp(prop,".Y",{["Name"]="UDim"})
		elseif typeName == "CFrame" then
			result[1]=msp(prop,".Position",{["Name"]="Vector3"})
		end
		return result
	end

	Properties["UpdateView"] = function()
		local maxEntries = math.ceil(Properties["GuiElems"]["PropsFrame"].AbsoluteSize.Y / 23)
		local maxX = Properties["GuiElems"]["PropsFrame"].AbsoluteSize.X
		local totalWidth = Properties["ViewWidth"] + Properties["MinInputWidth"]
		scrollV["VisibleSpace"] = maxEntries
		scrollV["TotalSpace"] = #viewList + 1
		scrollH["VisibleSpace"] = maxX
		scrollH["TotalSpace"] = totalWidth
		scrollV["Gui"].Visible = #viewList + 1 > maxEntries
		scrollH["Gui"].Visible = CONFIG["Settings"]["Properties"]["ScaleType"] == 0 and totalWidth > maxX
		local oldSize = Properties["GuiElems"]["PropsFrame"].Size
		Properties["GuiElems"]["PropsFrame"].Size = UDim2.new(1,(scrollV["Gui"].Visible and -18 or 0),1,(scrollH["Gui"].Visible and -18 or 0))
		if oldSize ~= Properties["GuiElems"]["PropsFrame"].Size then
			Properties["UpdateView"]()
		else
			scrollV:Update()
			scrollH:Update()
			Properties["Index"] = scrollV["Index"]
		end
	end

	Properties["Update"] = function()
		table.clear(viewList)
		local lastCategory, count, maxWidth, maxDepth = nil, 1, 0, 1
		local stringSplit, lower, find = string.split, string.lower, string.find
		local searchText = (#Properties["SearchText"] > 0 and lower(Properties["SearchText"]))
		local function recur(propList, depth)
			for i = 1,#propList do
				local prop = propList[i]
				local visible = true
				if searchText and depth == 1 then
					visible = find(lower(prop["Name"]),searchText,1,true) ~= nil
				end
				if visible and lastCategory ~= prop["Category"] then
					viewList[count] = {["CategoryName"] = prop["Category"]}
					count = count + 1
					lastCategory = prop["Category"]
				end
				if expanded["CAT_"..prop["Category"]] == nil then expanded["CAT_"..prop["Category"]] = true end
				if (expanded["CAT_"..prop["Category"]] and visible) or prop["SpecialRow"] then
					if depth > 1 then prop["Depth"] = depth if depth > maxDepth then maxDepth = depth end end
					viewList[count] = prop
					count = count + 1
					local fullName = prop["Class"].."."..prop["Name"]..(prop["SubName"] or "")
					if expanded[fullName] then
						local expandedProps = Properties["GetExpandedProps"](prop)
						if #expandedProps > 0 then recur(expandedProps, depth+1) end
					end
				end
			end
		end
		recur(props, 1)
		Properties["ViewWidth"] = maxWidth + 9 + Properties["EntryOffset"]
		Properties["UpdateView"]()
	end

	Properties["DisplayProp"] = function(prop, entryIndex)
		local typeData = prop["ValueType"]
		local typeName = typeData["Name"]
		local gName = prop["Class"].."."..prop["Name"]..(prop["SubName"] or "")
		local propObj = autoUpdateObjs[gName]
		local entryData = propEntries[entryIndex]
		local valueBox = entryData["GuiElems"]["ValueBox"]
		local checkbox = entryData["GuiElems"]["Checkbox"]
		local colorButton = entryData["GuiElems"]["ColorButton"]
		local enumArrow = entryData["GuiElems"]["EnumArrow"]
		local gradient = entryData["GuiElems"]["Gradient"]
		local colorPreview = entryData["GuiElems"]["ColorPreview"]
		local rightButton = entryData["GuiElems"]["RightButton"]
		local rightButtonIcon = entryData["GuiElems"]["RightButtonIcon"]
		local propVal = Properties["GetPropVal"](prop, propObj)
		local inputFullName = inputProp and (inputProp["Class"].."."..inputProp["Name"]..(inputProp["SubName"] or ""))
		local offset = 4
		local endOffset = 6

		if (typeName == "Color3" or typeName == "BrickColor") then
			colorButton.Visible = true
			enumArrow.Visible = false
			if propVal then
				gradient.Color = (typeName == "Color3" and ColorSequence.new(propVal)) or (typeName == "BrickColor" and ColorSequence.new(propVal.Color)) or ColorSequence.new(Color3.new(1,1,1))
			else
				gradient.Color = ColorSequence.new(Color3.new(1,1,1))
			end
			offset = 22
			endOffset = 24
		elseif typeData["Category"] == "Enum" then
			colorButton.Visible = false
			enumArrow.Visible = not prop["Tags"]["ReadOnly"]
			endOffset = 22
		elseif gName == inputFullName and typeData["Category"] == "Class" then
			colorButton.Visible = false
			enumArrow.Visible = false
			endOffset = 26
		else
			colorButton.Visible = false
			enumArrow.Visible = false
		end

		valueBox.Position = UDim2.new(0, offset, 0, 0)
		valueBox.Size = UDim2.new(1, -endOffset, 1, 0)

		if inputFullName == gName and typeData["Category"] == "Class" then
			rightButtonIcon.Visible = true
			rightButton.Text = ""
			rightButton.Visible = true
		else
			rightButton.Visible = false
		end

		if typeName == "bool" or typeName == "PhysicalProperties" then
			valueBox.Visible = false
			checkbox.Visible = true
			checkboxes[entryIndex]:SetState(propVal)
		else
			valueBox.Visible = true
			checkbox.Visible = false
			if propVal ~= nil then
				if typeName == "Color3" then
					valueBox.Text = "["..Lib["ColorToBytes"](propVal).."]"
				elseif typeData["Category"] == "Enum" then
					valueBox.Text = propVal.Name
				elseif typeof(propVal) == "Instance" then
					valueBox.Text = propVal.Name
				else
					valueBox.Text = Properties["ValueToString"](prop, propVal)
				end
			else
				valueBox.Text = ""
			end
			valueBox.TextColor3 = prop["Tags"]["ReadOnly"] and CONFIG["Theme"]["PlaceholderText"] or CONFIG["Theme"]["Text"]
		end
	end

	Properties["Refresh"] = function()
		local maxEntries = math.max(math.ceil((Properties["GuiElems"]["PropsFrame"].AbsoluteSize.Y) / 23),0)
		local maxX = Properties["GuiElems"]["PropsFrame"].AbsoluteSize.X
		local valueWidth = math.max(Properties["MinInputWidth"], maxX - Properties["ViewWidth"])
		local inputPropVisible = false
		local scaleType = CONFIG["Settings"]["Properties"]["ScaleType"]
		for i = 1,#propCons do propCons[i]:Disconnect() end
		table.clear(propCons)
		for i = 1,maxEntries do
			local entryData = propEntries[i]
			if not entryData then entryData = Properties["NewPropEntry"](i) propEntries[i] = entryData end
			local prop = viewList[i + Properties["Index"]]
			local entry = entryData["Gui"]
			if prop then
				entry.Visible = true
				local entryXOffset = (scaleType == 0 and scrollH["Index"] or 0)
				entry.Position = UDim2.new(0,-entryXOffset,0,entry.Position.Y.Offset)
				entry.Size = UDim2.new(scaleType == 0 and 0 or 1, scaleType == 0 and Properties["ViewWidth"] + valueWidth or 0,0,22)
				local nameFrame = entryData["GuiElems"]["NameFrame"]
				local valueFrame = entryData["GuiElems"]["ValueFrame"]
				if prop["SpecialRow"] then
					if prop["SpecialRow"] == "AddAttribute" then
						nameFrame.Visible = false valueFrame.Visible = false entryData["GuiElems"]["RowButton"].Visible = true
					end
				else
					nameFrame.Visible = true entryData["GuiElems"]["RowButton"].Visible = false
					local leftOffset = Properties["EntryIndent"]*(prop["Depth"] or 1) + Properties["EntryOffset"]
					nameFrame.Position = UDim2.new(0, leftOffset, 0, 0)
					local gName = (prop["CategoryName"] and "CAT_"..prop["CategoryName"]) or prop["Class"].."."..prop["Name"]..(prop["SubName"] or "")
					if prop["CategoryName"] then
						entry.BackgroundColor3 = CONFIG["Theme"]["Main1"]
						valueFrame.Visible = false
						entryData["GuiElems"]["PropName"].Text = prop["CategoryName"]
						entryData["GuiElems"]["PropName"].Font = Enum.Font.SourceSansBold
						nameFrame.Size = UDim2.new(1,0,1,0)
					else
						entry.BackgroundColor3 = CONFIG["Theme"]["Main2"]
						valueFrame.Visible = true
						entryData["GuiElems"]["PropName"].Text = prop["DisplayName"] or string.split(gName,".")[#string.split(gName,".")]
						entryData["GuiElems"]["PropName"].Font = Enum.Font.SourceSans
						if scaleType == 0 then
							nameFrame.Size = UDim2.new(0,Properties["ViewWidth"] - leftOffset - 1,1,0)
							valueFrame.Position = UDim2.new(0,Properties["ViewWidth"],0,0)
							valueFrame.Size = UDim2.new(0,valueWidth,1,0)
						else
							nameFrame.Size = UDim2.new(0.5,-leftOffset - 1,1,0)
							valueFrame.Position = UDim2.new(0.5,0,0,0)
							valueFrame.Size = UDim2.new(0.5,0,1,0)
						end
						Properties["DisplayProp"](prop, i)
						local propObj = autoUpdateObjs[gName]
						if propObj and not prop["IsAttribute"] then
							propCons[#propCons+1] = propObj:GetPropertyChangedSignal(prop["Name"]):Connect(function() Properties["DisplayProp"](prop, i) end)
						end
						local inputFullName = inputProp and (inputProp["Class"].."."..inputProp["Name"]..(inputProp["SubName"] or ""))
						if gName == inputFullName then
							nameFrame.BackgroundColor3 = CONFIG["Theme"]["ListSelection"]
							nameFrame.BackgroundTransparency = 0
							if prop["ValueType"]["Category"] == "Class" or prop["ValueType"]["Category"] == "Enum" or prop["ValueType"]["Name"] == "BrickColor" or prop["ValueType"]["Name"] == "Color3" then
								valueFrame.BackgroundColor3 = CONFIG["Theme"]["TextBox"]
								valueFrame.BackgroundTransparency = 0
								entryData["GuiElems"]["ValueBox"].Visible = true
								if prop["ValueType"]["Category"] == "Class" then
									entryData["GuiElems"]["ValueBox"].Text = "Click an object in Explorer..."
								end
							else
								inputPropVisible = true
								inputBox.Position = UDim2.new(scaleType==0 and 0 or 0.5, scaleType==0 and Properties["ViewWidth"]-scrollH["Index"] or 0, 0, entry.Position.Y.Offset)
								inputBox.Size = UDim2.new(scaleType==0 and 1 or 0.5, scaleType==0 and -Properties["ViewWidth"]+scrollH["Index"] or 0, 0, 22)
								inputBox.Visible = true
								entryData["GuiElems"]["ValueBox"].Visible = false
							end
						else
							nameFrame.BackgroundColor3 = CONFIG["Theme"]["Main1"]
							nameFrame.BackgroundTransparency = 1
							valueFrame.BackgroundColor3 = CONFIG["Theme"]["Main1"]
							valueFrame.BackgroundTransparency = 1
						end
					end
					entryData["GuiElems"]["Expand"].Visible = prop["CategoryName"] or Properties["ExpandableTypes"][prop["ValueType"] and prop["ValueType"]["Name"]]
					if entryData["GuiElems"]["Expand"].Visible then
						entryData["GuiElems"]["Expand"]["Icon"].ImageRectOffset = Vector2.new(144, 16)
						entryData["GuiElems"]["Expand"]["Icon"].Rotation = expanded[gName] and 90 or 0
					end
				end
			else
				entry.Visible = false
			end
		end
		if not inputPropVisible then inputBox.Visible = false end
		for i = maxEntries+1,#propEntries do propEntries[i]["Gui"]:Destroy() propEntries[i] = nil checkboxes[i] = nil end
	end

	Properties["SetProp"] = function(prop, val)
		if prop["Tags"]["ReadOnly"] then return end
		for i = 1, #Properties["SelectionList"] do
			local obj = Properties["SelectionList"][i]
			if obj:IsA(prop["Class"]) then
				pcall(function()
					if prop["RootType"] then
						local root = obj[prop["Name"]]
						if prop["RootType"]["Name"] == "Vector3" then
							obj[prop["Name"]] = Vector3.new((prop["SubName"]==".X" and val) or root.X, (prop["SubName"]==".Y" and val) or root.Y, (prop["SubName"]==".Z" and val) or root.Z)
						elseif prop["RootType"]["Name"] == "UDim2" then
							obj[prop["Name"]] = UDim2.new(UDim.new(root.X.Scale, root.X.Offset), UDim.new(root.Y.Scale, root.Y.Offset))
						end
					else
						obj[prop["Name"]] = val
					end
				end)
			end
		end
		Properties["ComputeConflicts"](prop)
	end

	Properties["GetPropVal"] = function(prop, obj)
		if prop["MultiType"] then return "<Multiple Types>" end
		if not obj then return nil end
		local propVal = obj[prop["Name"]]
		if prop["SubName"] then
			for _, indexName in ipairs(string.split(prop["SubName"],".")) do
				if #indexName > 0 and propVal then propVal = propVal[indexName] end
			end
		end
		return propVal
	end

	Properties["DisplayColorEditor"] = function(prop, col)
		local editor = Properties["ColorEditor"]
		if not editor then
			editor = Lib["ColorPicker"]["new"]()
			TrackConnection(editor["OnSelect"]:Connect(function(c)
				if not editor["CurrentProp"] then return end
				if editor["CurrentProp"] == inputProp then inputProp = nil end
				Properties["SetProp"](editor["CurrentProp"], c)
			end))
			Properties["ColorEditor"] = editor
		end
		editor["CurrentProp"] = prop
		if col then editor:SetColor(col) end
		editor:Show()
	end

	Properties["DisplayBrickColorEditor"] = function(prop, entryIndex, col)
		local editor = Properties["BrickColorEditor"]
		if not editor then
			editor = Lib["BrickColorPicker"]["new"]()
			TrackConnection(editor["OnSelect"]:Connect(function(c)
				if not editor["CurrentProp"] then return end
				if editor["CurrentProp"] == inputProp then inputProp = nil end
				Properties["SetProp"](editor["CurrentProp"], BrickColor.new(c))
			end))
			Properties["BrickColorEditor"] = editor
		end
		editor["CurrentProp"] = prop
		editor:Show()
	end

	Properties["DisplayEnumDropdown"] = function(entryIndex)
		local context = Properties["EnumContext"]
		if not context then
			context = Lib["ContextMenu"]["new"]()
			context["MaxHeight"] = 200
			Properties["EnumContext"] = context
		end
		if not inputProp or inputProp["ValueType"]["Category"] ~= "Enum" then return end
		local prop = inputProp
		local entry = propEntries[entryIndex]
		local valueFrame = entry["GuiElems"]["ValueFrame"]
		local enum = Enum[prop["ValueType"]["Name"]]
		if not enum then return end
		local sorted = {}
		for name, e in next, enum:GetEnumItems() do sorted[#sorted+1] = e end
		table.sort(sorted, function(a,b) return a.Name < b.Name end)
		context:Clear()
		local function onClick(name)
			if prop ~= inputProp then return end
			local enumItem = enum[name]
			inputProp = nil
			Properties["SetProp"](prop, enumItem)
		end
		for i = 1, #sorted do context:Add({["Name"] = sorted[i].Name, ["OnClick"] = onClick}) end
		context["Width"] = valueFrame.AbsoluteSize.X
		context:Show(valueFrame.AbsolutePosition.X, valueFrame.AbsolutePosition.Y + 22)
		Properties["EnumDropdown"] = context
	end

	Properties["SetInputProp"] = function(prop, entryIndex, special)
		if prop["Tags"]["ReadOnly"] then return end
		inputProp = prop
		local fullName = prop["Class"].."."..prop["Name"]..(prop["SubName"] or "")
		local propVal = Properties["GetPropVal"](prop, autoUpdateObjs[fullName])
		local typeName = prop["ValueType"]["Name"]
		if special == "color" then
			if typeName == "Color3" then
				Properties["DisplayColorEditor"](prop, propVal)
			elseif typeName == "BrickColor" then
				Properties["DisplayBrickColorEditor"](prop, entryIndex, propVal)
			end
		elseif typeName ~= "bool" and prop["ValueType"]["Category"] ~= "Enum" and prop["ValueType"]["Category"] ~= "Class" then
			inputTextBox.Text = propVal and Properties["ValueToString"](prop, propVal) or ""
			inputTextBox:CaptureFocus()
		elseif prop["ValueType"]["Category"] == "Enum" then
			Properties["DisplayEnumDropdown"](entryIndex)
		end
		Properties["Refresh"]()
	end

	Properties["ComputeConflicts"] = function(p)
		local t_clear = table.clear
		local propList = p and {p} or props
		if not p then table.clear(autoUpdateObjs) end
		if #Properties["SelectionList"] > 0 then
			for i = 1,#propList do
				local prop = propList[i]
				local gName = prop["Class"].."."..prop["Name"]
				autoUpdateObjs[gName] = Properties["SelectionList"][1]
				local subProps = Properties["ConflictSubProps"][prop["ValueType"]["Name"]] or {}
				for j=1,#subProps do autoUpdateObjs[gName.."."..subProps[j]] = Properties["SelectionList"][1] end
			end
		end
		if p then Properties["Refresh"]() end
	end

	Properties["ShowProps"] = function()
		table.clear(props)
		local foundClasses = {}
		local propCount = 1
		for i = 1, #Properties["SelectionList"] do
			local obj = Properties["SelectionList"][i]
			local class = obj.ClassName
			local apiClass = API["Classes"][class]
			while apiClass do
				local APIClassName = apiClass["Name"]
				if not foundClasses[APIClassName] then
					local apiProps = indexableProps[APIClassName]
					if not apiProps then apiProps = Properties["GetIndexableProps"](obj, apiClass) indexableProps[APIClassName] = apiProps end
					for _, prop in ipairs(apiProps) do
						if (not prop["Tags"]["Deprecated"] or CONFIG["Settings"]["Properties"]["ShowDeprecated"]) and (not prop["Tags"]["Hidden"] or CONFIG["Settings"]["Properties"]["ShowHidden"]) then
							props[propCount] = prop
							propCount = propCount + 1
						end
					end
					foundClasses[APIClassName] = true
				end
				apiClass = API["Classes"][apiClass["Superclass"]]
			end
		end
		table.sort(props,function(a,b)
			if a["Category"] ~= b["Category"] then
				local orderA = API["CategoryOrder"][a["Category"]] or 9999
				local orderB = API["CategoryOrder"][b["Category"]] or 9999
				if orderA == orderB then
					return a["Category"] < b["Category"]
				end
				return orderA < orderB
			else
				return string.lower(a["Name"]) < string.lower(b["Name"])
			end
		end)
		Properties["ComputeConflicts"]()
		Properties["Update"]()
		Properties["Refresh"]()
	end

	function PropertiesModule.SetSelection(objectsArray)
		Properties["SelectionList"] = objectsArray
		Properties["ShowProps"]()
	end

	function PropertiesModule.SelectObject(obj)
		if inputProp and inputProp["ValueType"]["Category"] == "Class" then
			local prop = inputProp
			inputProp = nil
			if typeof(obj) == "Instance" then
				Properties["SetProp"](prop, obj)
			end
			Properties["Refresh"]()
			return true
		end
		return false
	end

	Properties["InitInputBox"] = function()
		inputBox = create({
			{1,"Frame",{BackgroundColor3=CONFIG["Theme"]["TextBox"],BorderSizePixel=0,Name="InputBox",Size=UDim2.new(0,200,0,22),Visible=false,ZIndex=2}},
			{2,"TextBox",{BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,ClearTextOnFocus=false,Font=Enum.Font.SourceSans,Parent={1},Position=UDim2.new(0,3,0,0),Size=UDim2.new(1,-6,1,0),Text="",TextColor3=CONFIG["Theme"]["Text"],TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=2}}
		})
		inputTextBox = inputBox["TextBox"]
		inputBox.Parent = Properties["GuiElems"]["PropsFrame"]
		TrackConnection(inputTextBox.FocusLost:Connect(function()
			if not inputProp then return end
			local prop = inputProp inputProp = nil
			local val = Properties["StringToValue"](prop, inputTextBox.Text)
			if val ~= nil then Properties["SetProp"](prop, val) else Properties["Refresh"]() end
		end))
		Lib["ViewportTextBox"]["convert"](inputTextBox)
	end

	Properties["InitSearch"] = function()
		local searchBox = Properties["GuiElems"]["ToolBar"]["SearchFrame"]["SearchBox"]
		Lib["ViewportTextBox"]["convert"](searchBox)
		TrackConnection(searchBox:GetPropertyChangedSignal("Text"):Connect(function()
			Properties["SearchText"] = searchBox.Text
			Properties["Update"]()
			Properties["Refresh"]()
		end))
	end

	Properties["InitEntryStuff"] = function()
		Properties["EntryTemplate"] = create({
			{1,"TextButton",{AutoButtonColor=false,BackgroundColor3=CONFIG["Theme"]["Main2"],BorderColor3=CONFIG["Theme"]["Outline1"],Font=Enum.Font.SourceSans,Name="Entry",Position=UDim2.new(0,1,0,1),Size=UDim2.new(0,250,0,22),Text="",TextSize=14}},
			{2,"Frame",{BackgroundTransparency=1,BorderSizePixel=0,Name="NameFrame",Parent={1},Position=UDim2.new(0,20,0,0),Size=UDim2.new(1,-40,1,0)}},
			{3,"TextLabel",{BackgroundTransparency=1,Font=Enum.Font.SourceSans,Name="PropName",Parent={2},Position=UDim2.new(0,2,0,0),Size=UDim2.new(1,-2,1,0),Text="Anchored",TextColor3=CONFIG["Theme"]["Text"],TextSize=14,TextTruncate=Enum.TextTruncate.AtEnd,TextXAlignment=Enum.TextXAlignment.Left}},
			{4,"TextButton",{BackgroundTransparency=1,ClipsDescendants=true,Font=Enum.Font.SourceSans,Name="Expand",Parent={2},Position=UDim2.new(0,-20,0,1),Size=UDim2.new(0,20,0,20),Text="",Visible=false}},
			{5,"ImageLabel",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,ImageColor3=Color3.fromRGB(120,126,145),Image=CONFIG["AssetIds"]["ExpandIcon"],ImageRectOffset=Vector2.new(144,16),ImageRectSize=Vector2.new(16,16),Name="Icon",Parent={4},Position=UDim2.new(0,2,0,2),ScaleType=Enum.ScaleType.Fit,Size=UDim2.new(0,16,0,16),}},
			{6,"TextButton",{BackgroundTransparency=1,BorderSizePixel=0,Font=Enum.Font.SourceSansBold,Name="ToggleAttributes",Parent={2},Position=UDim2.new(1,-85,0,0),Size=UDim2.new(0,85,0,22),Text="[SETTING: OFF]",TextColor3=CONFIG["Theme"]["Text"],TextSize=14,Visible=false}},
			{7,"Frame",{BackgroundTransparency=1,BorderSizePixel=0,Name="ValueFrame",Parent={1},Position=UDim2.new(1,-100,0,0),Size=UDim2.new(0,80,1,0)}},
			{8,"Frame",{BackgroundColor3=CONFIG["Theme"]["Outline1"],BorderSizePixel=0,Name="Line",Parent={7},Position=UDim2.new(0,-1,0,0),Size=UDim2.new(0,1,1,0)}},
			{9,"TextButton",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Font=Enum.Font.SourceSans,Name="ColorButton",Parent={7},Size=UDim2.new(0,20,0,22),Text="",TextColor3=CONFIG["Theme"]["Text"],TextSize=14,Visible=false,}},
			{10,"Frame",{BackgroundColor3=Color3.new(1,1,1),BorderColor3=CONFIG["Theme"]["Outline1"],Name="ColorPreview",Parent={9},Position=UDim2.new(0,5,0,6),Size=UDim2.new(0,10,0,10),}},
			{11,"UIGradient",{Parent={10},}},
			{12,"Frame",{BackgroundTransparency=1,Name="EnumArrow",Parent={7},Position=UDim2.new(1,-16,0,3),Size=UDim2.new(0,16,0,16),Visible=false,}},
			{13,"Frame",{BackgroundColor3=CONFIG["Theme"]["Text"],BorderSizePixel=0,Parent={12},Position=UDim2.new(0,8,0,9),Size=UDim2.new(0,1,0,1),}},
			{14,"Frame",{BackgroundColor3=CONFIG["Theme"]["Text"],BorderSizePixel=0,Parent={12},Position=UDim2.new(0,7,0,8),Size=UDim2.new(0,3,0,1),}},
			{15,"Frame",{BackgroundColor3=CONFIG["Theme"]["Text"],BorderSizePixel=0,Parent={12},Position=UDim2.new(0,6,0,7),Size=UDim2.new(0,5,0,1),}},
			{16,"TextButton",{BackgroundTransparency=1,Font=Enum.Font.SourceSans,Name="ValueBox",Parent={7},Position=UDim2.new(0,4,0,0),Size=UDim2.new(1,-8,1,0),Text="",TextColor3=CONFIG["Theme"]["Text"],TextSize=14,TextTruncate=Enum.TextTruncate.AtEnd,TextXAlignment=Enum.TextXAlignment.Left}},
			{17,"TextButton",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Font=Enum.Font.SourceSans,Name="RightButton",Parent={7},Position=UDim2.new(1,-20,0,0),Size=UDim2.new(0,20,0,22),Text="...",TextColor3=CONFIG["Theme"]["Text"],TextSize=14,Visible=false,}},
			{24,"TextButton",{BackgroundTransparency=1,BorderSizePixel=0,Font=Enum.Font.SourceSans,Name="EditAttributeButton",Parent={1},Position=UDim2.new(1,-20,0,0),Size=UDim2.new(0,20,0,22),Text="",TextColor3=CONFIG["Theme"]["Text"],TextSize=14}},
			{26,"TextButton",{AutoButtonColor=false,BackgroundColor3=CONFIG["Theme"]["Button"],BorderSizePixel=0,Font=Enum.Font.SourceSans,Name="RowButton",Parent={1},Size=UDim2.new(1,0,1,0),Text="Add Attribute",TextColor3=CONFIG["Theme"]["Text"],TextSize=14,Visible=false}}
		})
	end

	function PropertiesModule.Init(ParentContainer, APIDump, RMDDump)
		API = APIDump
		RMD = RMDDump
		categoryOrder = API["CategoryOrder"]
		for category, _ in next, categoryOrder do
			expanded["CAT_"..category] = true
		end
		local guiItems = create({
			{1,"Folder",{Name="Items"}},
			{2,"Frame",{BackgroundColor3=CONFIG["Theme"]["Main1"],BorderSizePixel=0,Name="ToolBar",Parent={1},Size=UDim2.new(1,0,0,22)}},
			{3,"Frame",{BackgroundColor3=CONFIG["Theme"]["Main2"],BorderColor3=CONFIG["Theme"]["Outline1"],BorderSizePixel=0,Name="SearchFrame",Parent={2},Position=UDim2.new(0,3,0,1),Size=UDim2.new(1,-6,0,18)}},
			{4,"TextBox",{BackgroundTransparency=1,ClearTextOnFocus=false,Font=Enum.Font.SourceSans,Name="SearchBox",Parent={3},PlaceholderColor3=CONFIG["Theme"]["PlaceholderText"],PlaceholderText="Search properties",Position=UDim2.new(0,4,0,0),Size=UDim2.new(1,-24,0,18),Text="",TextColor3=CONFIG["Theme"]["Text"],TextSize=14,TextXAlignment=Enum.TextXAlignment.Left}},
			{12,"Frame",{BackgroundTransparency=1,ClipsDescendants=true,Name="List",Parent={1},Position=UDim2.new(0,0,0,23),Size=UDim2.new(1,0,1,-23)}}
		})
		local toolBar = guiItems["ToolBar"]
		local propsFrame = guiItems["List"]
		Properties["GuiElems"]["ToolBar"] = toolBar
		Properties["GuiElems"]["PropsFrame"] = propsFrame
		Properties["InitEntryStuff"]()
		toolBar.Parent = ParentContainer
		propsFrame.Parent = ParentContainer
		TrackConnection(ParentContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			Properties["UpdateView"]()
			Properties["Refresh"]()
		end))
		scrollV = Lib["ScrollBar"]["new"](false)
		scrollV["WheelIncrement"] = 3
		scrollV["Gui"].Position = UDim2.new(1,-18,0,23)
		scrollV:SetScrollFrame(propsFrame)
		TrackConnection(scrollV["Scrolled"]:Connect(function() Properties["Index"] = scrollV["Index"] Properties["Refresh"]() end))
		scrollV["Gui"].Parent = ParentContainer
		scrollH = Lib["ScrollBar"]["new"](true)
		scrollH["Increment"] = 5
		scrollH["WheelIncrement"] = 20
		scrollH["Gui"].Position = UDim2.new(0,0,1,-18)
		TrackConnection(scrollH["Scrolled"]:Connect(function() Properties["Refresh"]() end))
		scrollH["Gui"].Parent = ParentContainer
		Properties["InitInputBox"]()
		Properties["InitSearch"]()
		TrackConnection(UIS.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				if inputProp then
					local mPos = input.Position
					local isInsideProps = false
					local pFrame = Properties["GuiElems"]["PropsFrame"]
					if pFrame then
						local ap, as = pFrame.AbsolutePosition, pFrame.AbsoluteSize
						if mPos.X >= ap.X and mPos.X <= ap.X + as.X and mPos.Y >= ap.Y and mPos.Y <= ap.Y + as.Y then
							isInsideProps = true
						end
					end
					local isInsideEnum = false
					local eCtx = Properties["EnumDropdown"]
					if eCtx and eCtx["Gui"] and eCtx["Gui"].Parent then
						local main = eCtx["GuiElems"]["Main"]
						local ap, as = main.AbsolutePosition, main.AbsoluteSize
						if mPos.X >= ap.X and mPos.X <= ap.X + as.X and mPos.Y >= ap.Y and mPos.Y <= ap.Y + as.Y then
							isInsideEnum = true
						end
					end
					local isInsideColor = false
					local cp = Properties["ColorEditor"]
					if cp and cp["Window"] and cp["Window"]["Gui"] and cp["Window"]["Gui"].Parent then
						local main = cp["Window"]["GuiElems"]["Main"]
						local ap, as = main.AbsolutePosition, main.AbsoluteSize
						if mPos.X >= ap.X and mPos.X <= ap.X + as.X and mPos.Y >= ap.Y and mPos.Y <= ap.Y + as.Y then
							isInsideColor = true
						end
					end
					local isInsideBColor = false
					local bcp = Properties["BrickColorEditor"]
					if bcp and bcp["Window"] and bcp["Window"]["Gui"] and bcp["Window"]["Gui"].Parent then
						local main = bcp["Window"]["GuiElems"]["Main"]
						local ap, as = main.AbsolutePosition, main.AbsoluteSize
						if mPos.X >= ap.X and mPos.X <= ap.X + as.X and mPos.Y >= ap.Y and mPos.Y <= ap.Y + as.Y then
							isInsideBColor = true
						end
					end
					if not isInsideProps and not isInsideEnum and not isInsideColor and not isInsideBColor then
						inputProp = nil
						Properties["Refresh"]()
					end
				end
			end
		end))
		
		_G.OnionPropertiesRefresh = function()
			Properties["Refresh"]()
		end
	end

	PropertiesModule.Lib = Lib
	return PropertiesModule

end

local PropertiesModule = GetPropertiesModule()

local function InitDexStyleDockEngine()
	local dockGui = TrackInstance(Instance.new("ScreenGui"))
	dockGui.Name = "OnionDock"
	dockGui.IgnoreGuiInset = true
	dockGui.DisplayOrder = 10
	dockGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	dockGui.Parent = GuiParent

	local dockPreview = Instance.new("Frame")
	dockPreview.Name = "DockPreview"
	dockPreview.BackgroundColor3 = CONFIG["Theme"]["DockPreviewBg"]
	dockPreview.BackgroundTransparency = 0.8
	dockPreview.BorderSizePixel = 0
	dockPreview.ZIndex = 100
	dockPreview.Visible = false
	dockPreview.Parent = dockGui
	local dockPreviewCorner = Instance.new("UICorner", dockPreview)
	dockPreviewCorner.CornerRadius = UDim.new(0, 6)

	local OnionMenuBtn = Instance.new("TextButton")
	OnionMenuBtn.Name = "OnionMenuBtn"
	OnionMenuBtn.BackgroundColor3 = CONFIG["Theme"]["AppListCard"]
	OnionMenuBtn.BorderSizePixel = 0
	OnionMenuBtn.Size = UDim2.new(0, 80, 0, 36)
	OnionMenuBtn.Position = UDim2.new(0.5, -40, 0, 10)
	OnionMenuBtn.AutoButtonColor = false
	OnionMenuBtn.Text = ""
	OnionMenuBtn.Parent = dockGui
	Instance.new("UICorner", OnionMenuBtn).CornerRadius = UDim.new(0, 8)
	local menuBtnStroke = Instance.new("UIStroke", OnionMenuBtn)
	menuBtnStroke.Color = CONFIG["Theme"]["Button"]
	menuBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local menuBtnIcon = Instance.new("ImageLabel", OnionMenuBtn)
	menuBtnIcon.BackgroundTransparency = 1
	menuBtnIcon.Image = CONFIG["AssetIds"]["Logo"]
	menuBtnIcon.Size = UDim2.new(0, 20, 0, 20)
	menuBtnIcon.Position = UDim2.new(0, 15, 0.5, -10)

	local menuBtnCount = Instance.new("TextLabel", OnionMenuBtn)
	menuBtnCount.BackgroundTransparency = 1
	menuBtnCount.Size = UDim2.new(0, 30, 1, 0)
	menuBtnCount.Position = UDim2.new(0, 45, 0, 0)
	menuBtnCount.Text = "0"
	menuBtnCount.TextColor3 = CONFIG["Theme"]["Text"]
	menuBtnCount.Font = Enum.Font.GothamMedium
	menuBtnCount.TextSize = 16
	menuBtnCount.TextXAlignment = Enum.TextXAlignment.Left

	local AppMenu = Instance.new("Frame")
	AppMenu.Name = "AppMenu"
	AppMenu.BackgroundColor3 = CONFIG["Theme"]["MenuBackground"]
	AppMenu.BorderSizePixel = 0
	AppMenu.Position = UDim2.new(0.5, -(CONFIG["Settings"]["MenuWidth"]/2), 0, 56)
	AppMenu.Size = UDim2.new(0, CONFIG["Settings"]["MenuWidth"], 0, 0)
	AppMenu.ClipsDescendants = true
	AppMenu.Visible = false
	AppMenu.Parent = dockGui
	Instance.new("UICorner", AppMenu).CornerRadius = UDim.new(0, 10)
	local appMenuStroke = Instance.new("UIStroke", AppMenu)
	appMenuStroke.Color = Color3.fromRGB(5, 5, 5)

	local menuHeader = Instance.new("Frame", AppMenu)
	menuHeader.BackgroundTransparency = 1
	menuHeader.Size = UDim2.new(1, 0, 0, 50)

	local headerCountBox = Instance.new("Frame", menuHeader)
	headerCountBox.BackgroundColor3 = Color3.fromRGB(4, 4, 4)
	headerCountBox.Size = UDim2.new(0, 60, 0, 26)
	headerCountBox.Position = UDim2.new(0, 15, 0.5, -13)
	Instance.new("UICorner", headerCountBox).CornerRadius = UDim.new(1, 0)
	local headerCountIcon = Instance.new("ImageLabel", headerCountBox)
	headerCountIcon.BackgroundTransparency = 1
	headerCountIcon.Image = CONFIG["AssetIds"]["Logo"]
	headerCountIcon.Size = UDim2.new(0, 14, 0, 14)
	headerCountIcon.Position = UDim2.new(0, 8, 0.5, -7)
	local headerCountText = Instance.new("TextLabel", headerCountBox)
	headerCountText.BackgroundTransparency = 1
	headerCountText.Size = UDim2.new(1, -28, 1, 0)
	headerCountText.Position = UDim2.new(0, 26, 0, 0)
	headerCountText.Text = "0 / 4"
	headerCountText.TextColor3 = Color3.fromRGB(200, 200, 200)
	headerCountText.Font = Enum.Font.Gotham
	headerCountText.TextSize = 12
	headerCountText.TextXAlignment = Enum.TextXAlignment.Left

	local headerTitle = Instance.new("TextLabel", menuHeader)
	headerTitle.BackgroundTransparency = 1
	headerTitle.Size = UDim2.new(1, 0, 1, 0)
	headerTitle.Text = CONFIG["Strings"]["YourDocks"]
	headerTitle.TextColor3 = CONFIG["Theme"]["Text"]
	headerTitle.Font = Enum.Font.GothamMedium
	headerTitle.TextSize = 14

	local closeMenuBtn = Instance.new("ImageButton", menuHeader)
	closeMenuBtn.BackgroundColor3 = Color3.fromRGB(4, 4, 4)
	closeMenuBtn.Size = UDim2.new(0, 26, 0, 26)
	closeMenuBtn.Position = UDim2.new(1, -41, 0.5, -13)
	closeMenuBtn.Image = ""
	closeMenuBtn.AutoButtonColor = false
	Instance.new("UICorner", closeMenuBtn).CornerRadius = UDim.new(1, 0)
	local closeMenuIcon = Instance.new("ImageLabel", closeMenuBtn)
	closeMenuIcon.BackgroundTransparency = 1
	closeMenuIcon.Size = UDim2.new(0, 10, 0, 10)
	closeMenuIcon.Position = UDim2.new(0.5, -5, 0.5, -5)
	closeMenuIcon.Image = CONFIG["AssetIds"]["CloseBtn"]
	closeMenuIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)

	local settingsMenuBtn = Instance.new("ImageButton", menuHeader)
	settingsMenuBtn.Name = "SettingsMenuBtn"
	settingsMenuBtn.BackgroundColor3 = Color3.fromRGB(4, 4, 4)
	settingsMenuBtn.Size = UDim2.new(0, 26, 0, 26)
	settingsMenuBtn.Position = UDim2.new(1, -72, 0.5, -13)
	settingsMenuBtn.Image = ""
	settingsMenuBtn.AutoButtonColor = false
	Instance.new("UICorner", settingsMenuBtn).CornerRadius = UDim.new(1, 0)
	local settingsMenuIcon = Instance.new("ImageLabel", settingsMenuBtn)
	settingsMenuIcon.BackgroundTransparency = 1
	settingsMenuIcon.Size = UDim2.new(0, 14, 0, 14)
	settingsMenuIcon.Position = UDim2.new(0.5, -7, 0.5, -7)
	settingsMenuIcon.Image = "rbxassetid://9405931578"
	settingsMenuIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)

	local AppListFrame = Instance.new("ScrollingFrame", AppMenu)
	AppListFrame.Name = "AppList"
	AppListFrame.BackgroundTransparency = 1
	AppListFrame.Position = UDim2.new(0, 0, 0, 50)
	AppListFrame.Size = UDim2.new(1, 0, 1, -110)
	AppListFrame.ScrollBarThickness = 0
	local listPadding = Instance.new("UIPadding", AppListFrame)
	listPadding.PaddingTop = UDim.new(0, 5)
	listPadding.PaddingBottom = UDim.new(0, 5)
	listPadding.PaddingLeft = UDim.new(0, 15)
	listPadding.PaddingRight = UDim.new(0, 15)
	local listLayout = Instance.new("UIGridLayout", AppListFrame)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.CellSize = UDim2.new(0, 140, 0, 110)
	listLayout.CellPadding = UDim2.new(0, 10, 0, 10)

	local menuFooter = Instance.new("Frame", AppMenu)
	menuFooter.BackgroundColor3 = CONFIG["Theme"]["AppListCard"]
	menuFooter.Size = UDim2.new(1, -30, 0, 44)
	menuFooter.Position = UDim2.new(0, 15, 1, -54)
	Instance.new("UICorner", menuFooter).CornerRadius = UDim.new(0, 8)

	local footerIcon = Instance.new("ImageLabel", menuFooter)
	footerIcon.BackgroundTransparency = 1
	footerIcon.Image = CONFIG["AssetIds"]["Logo"]
	footerIcon.Size = UDim2.new(0, 20, 0, 20)
	footerIcon.Position = UDim2.new(0, 12, 0.5, -10)
	local footerTitle = Instance.new("TextLabel", menuFooter)
	footerTitle.BackgroundTransparency = 1
	footerTitle.Position = UDim2.new(0, 42, 0, 7)
	footerTitle.Size = UDim2.new(1, -50, 0, 14)
	footerTitle.Text = CONFIG["Strings"]["AddMore"]
	footerTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
	footerTitle.Font = Enum.Font.GothamMedium
	footerTitle.TextSize = 13
	footerTitle.TextXAlignment = Enum.TextXAlignment.Left
	local footerDesc = Instance.new("TextLabel", menuFooter)
	footerDesc.BackgroundTransparency = 1
	footerDesc.Position = UDim2.new(0, 42, 0, 23)
	footerDesc.Size = UDim2.new(1, -50, 0, 12)
	footerDesc.Text = CONFIG["Urls"]["Website"]
	footerDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
	footerDesc.Font = Enum.Font.Gotham
	footerDesc.TextSize = 11
	footerDesc.TextXAlignment = Enum.TextXAlignment.Left
	local footerArrow = Instance.new("TextLabel", menuFooter)
	footerArrow.BackgroundTransparency = 1
	footerArrow.Size = UDim2.new(0, 20, 1, 0)
	footerArrow.Position = UDim2.new(1, -25, 0, 0)
	footerArrow.Text = "→"
	footerArrow.TextColor3 = Color3.fromRGB(150, 150, 150)
	footerArrow.Font = Enum.Font.Gotham
	footerArrow.TextSize = 16

	local Apps = {}
	local menuOpen = false

	_G.UpdateMenuCounts = function()
		local activeCount = 0
		for _, app in ipairs(Apps) do
			if app:GetAttribute("isOpen") then activeCount = activeCount + 1 end
		end
		menuBtnCount.Text = tostring(activeCount)
		headerCountText.Text = tostring(activeCount) .. " / 4"
	end

	local function toggleMenu()
		menuOpen = not menuOpen
		if menuOpen then
			AppMenu.Visible = true
			if _G.UpdateMenuCounts then _G.UpdateMenuCounts() end
			local rows = math.ceil((#Apps + 1) / 2)
			local targetHeight = math.min(104 + (rows * 120), CONFIG["Settings"]["MenuMaxHeight"])
			AppListFrame.CanvasSize = UDim2.new(0, 0, 0, rows * 120)
			TweenService:Create(AppMenu, CONFIG["Animation"]["MenuToggle"], {["Size"] = UDim2.new(0, CONFIG["Settings"]["MenuWidth"], 0, targetHeight)}):Play()
		else
			local tw = TweenService:Create(AppMenu, CONFIG["Animation"]["MenuClose"], {["Size"] = UDim2.new(0, CONFIG["Settings"]["MenuWidth"], 0, 0)})
			tw:Play()
			task.delay(CONFIG["Animation"]["MenuClose"].Time, function()
				if not menuOpen then AppMenu.Visible = false end
			end)
		end
	end

	TrackConnection(OnionMenuBtn.MouseButton1Click:Connect(toggleMenu))
	TrackConnection(closeMenuBtn.MouseButton1Click:Connect(toggleMenu))

	local GlobalZIndex = 100
	local function BringToFront(win)
		GlobalZIndex = GlobalZIndex + 1
		win.ZIndex = GlobalZIndex
		dockPreview.ZIndex = GlobalZIndex + 1
	end

	local DockSizes = CONFIG["Settings"]["DockSizes"]
	local DockedWindows = {["Left"] = {}, ["Right"] = {}, ["Bottom"] = {}}
	local DockCollapsed = {["Left"] = false, ["Right"] = false}
	local dockToggles = {}
	local UpdateDockedWindows

	local function createDockToggle(side)
		local container = Instance.new("Frame")
		container.Name = side .. "DockToggle"
		container.Size = UDim2.new(0, 15, 0, 70)
		container.BackgroundTransparency = 1
		container.Visible = false
		container.Parent = dockGui

		local btn = Instance.new("Frame", container)
		btn.Name = "Button"
		btn.Size = UDim2.new(1, 0, 1, -15)
		btn.BackgroundColor3 = CONFIG["Theme"]["MenuBackground"] or Color3.fromRGB(3, 3, 3)
		btn.BorderSizePixel = 0

		local wedge = Instance.new("Frame", container)
		wedge.Name = "Wedge"
		wedge.Size = UDim2.new(1, 0, 0, 15)
		wedge.Position = UDim2.new(0, 0, 1, -15)
		wedge.BackgroundColor3 = btn.BackgroundColor3
		wedge.BorderSizePixel = 0

		local grad = Instance.new("UIGradient", wedge)
		grad.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.5, 1),
			NumberSequenceKeypoint.new(0.501, 0),
			NumberSequenceKeypoint.new(1, 0)
		})
		if side == "Right" then
			grad.Rotation = -45
		else
			grad.Rotation = -135
		end

		local txt = Instance.new("TextLabel", container)
		txt.BackgroundTransparency = 1
		txt.AnchorPoint = Vector2.new(0.5, 0.5)
		txt.Size = UDim2.new(0, 60, 0, 15)
		txt.Position = UDim2.new(0.5, 0, 0.5, -6)
		txt.Rotation = side == "Right" and -90 or 90
		txt.Text = "CLOSE"
		txt.TextColor3 = Color3.fromRGB(200, 200, 200)
		txt.Font = Enum.Font.GothamMedium
		txt.TextSize = 10
		txt.ZIndex = 2

		local clicker = Instance.new("TextButton", container)
		clicker.Size = UDim2.new(1, 0, 1, 0)
		clicker.BackgroundTransparency = 1
		clicker.Text = ""
		clicker.ZIndex = 5
		TrackConnection(clicker.MouseButton1Click:Connect(function()
			DockCollapsed[side] = not DockCollapsed[side]
			txt.Text = DockCollapsed[side] and "OPEN" or "CLOSE"
			UpdateDockedWindows(side, false)
		end))
		
		return container
	end
	dockToggles["Left"] = createDockToggle("Left")
	dockToggles["Right"] = createDockToggle("Right")

	UpdateDockedWindows = function(side, isDragging)
		local wins = DockedWindows[side]
		local count = #wins
		
		if side == "Left" or side == "Right" then
			local btn = dockToggles[side]
			if btn then
				if count == 0 then
					btn.Visible = false
				else
					btn.Visible = true
					local width = DockSizes[side]
					local bPos = side == "Left" 
						and UDim2.new(0, DockCollapsed[side] and 0 or width, 0, 0) 
						or UDim2.new(1, DockCollapsed[side] and -15 or (-width - 15), 0, 0)
					if isDragging then
						btn.Position = bPos
					else
						TweenService:Create(btn, CONFIG["Animation"]["DockUpdate"], {["Position"] = bPos}):Play()
					end
				end
			end
		end

		if count == 0 then return end

		local totalWeight = 0
		for _, w in ipairs(wins) do
			totalWeight = totalWeight + (w:GetAttribute("DockWeight") or 1)
		end
		local currentPos = 0

		if side == "Left" or side == "Right" then
			local width = DockSizes[side]
			for i, w in ipairs(wins) do
				local weight = w:GetAttribute("DockWeight") or 1
				local hRatio = weight / totalWeight
				local posX = (side == "Left") 
					and UDim2.new(0, DockCollapsed[side] and -width or 0, currentPos, 0) 
					or UDim2.new(1, DockCollapsed[side] and 0 or -width, currentPos, 0)
				local size = UDim2.new(0, width, hRatio, 0)

				if isDragging then
					w.Size = size
					w.Position = posX
				else
					TweenService:Create(w, CONFIG["Animation"]["DockUpdate"], {["Size"] = size, ["Position"] = posX}):Play()
				end
				currentPos = currentPos + hRatio

				local outl = w:FindFirstChild("Outlines")
				if outl then outl.Visible = false end

				local rc = w:FindFirstChild("ResizeControls")
				if rc then
					for _, h in ipairs(rc:GetChildren()) do 
						h:SetAttribute("DockActive", false) 
						local l = h:FindFirstChild("Line")
						if l then l.Visible = false end 
					end
					local sideHandle = side == "Left" and rc:FindFirstChild("E") or rc:FindFirstChild("W")
					if sideHandle then
						sideHandle:SetAttribute("DockActive", true)
						local l = sideHandle:FindFirstChild("Line")
						if l then l.Visible = true end
					end
					if i < count then
						local sHandle = rc:FindFirstChild("S")
						if sHandle then
							sHandle:SetAttribute("DockActive", true)
							local l = sHandle:FindFirstChild("Line")
							if l then l.Visible = true end
						end
					end
				end
			end
		elseif side == "Bottom" then
			local height = DockSizes["Bottom"]
			for i, w in ipairs(wins) do
				local weight = w:GetAttribute("DockWeight") or 1
				local wRatio = weight / totalWeight
				local posX = UDim2.new(currentPos, 0, 1, -height)
				local size = UDim2.new(wRatio, 0, 0, height)

				if isDragging then
					w.Size = size
					w.Position = posX
				else
					TweenService:Create(w, CONFIG["Animation"]["DockUpdate"], {["Size"] = size, ["Position"] = posX}):Play()
				end
				currentPos = currentPos + wRatio

				local outl = w:FindFirstChild("Outlines")
				if outl then outl.Visible = false end

				local rc = w:FindFirstChild("ResizeControls")
				if rc then
					for _, h in ipairs(rc:GetChildren()) do 
						h:SetAttribute("DockActive", false) 
						local l = h:FindFirstChild("Line")
						if l then l.Visible = false end 
					end
					local nHandle = rc:FindFirstChild("N")
					if nHandle then
						nHandle:SetAttribute("DockActive", true)
						local l = nHandle:FindFirstChild("Line")
						if l then l.Visible = true end
					end
					if i < count then
						local eHandle = rc:FindFirstChild("E")
						if eHandle then
							eHandle:SetAttribute("DockActive", true)
							local l = eHandle:FindFirstChild("Line")
							if l then l.Visible = true end
						end
					end
				end
			end
		end
	end

	local function getInsertIndex(side, mPos, count)
		local vpSize = workspace.CurrentCamera.ViewportSize
		if side == "Left" or side == "Right" then
			return math.clamp(math.floor(mPos.Y / (vpSize.Y / (count + 1))) + 1, 1, count + 1)
		elseif side == "Bottom" then
			return math.clamp(math.floor(mPos.X / (vpSize.X / (count + 1))) + 1, 1, count + 1)
		end
		return 1
	end

	local function AddDock(win, side, mPos)
		if not win:GetAttribute("DockWeight") then win:SetAttribute("DockWeight", 1) end
		local wins = DockedWindows[side]
		if mPos then
			local insertIndex = getInsertIndex(side, mPos, #wins)
			table.insert(wins, insertIndex, win)
		else
			table.insert(wins, win)
		end
		UpdateDockedWindows(side, false)
	end

	local function RemoveDock(win, side)
		if side == "None" then return end
		for i, w in ipairs(DockedWindows[side]) do
			if w == win then
				table.remove(DockedWindows[side], i)
				break
			end
		end
		UpdateDockedWindows(side, false)
	end

	local SelectionEvent = TrackInstance(Instance.new("BindableEvent"))
	local function CreateDexWindow(titleText, iconId, initialDock, options)
		options = options or {}
		local window = Instance.new("Frame")
		window.Name = "DexWindow"
		window.BackgroundTransparency = 1
		window.Active = true
		window.Size = options.InitialSize or UDim2.new(0, 300, 0, 400)
		window.Position = UDim2.new(0.5, -150, 0.5, -200)
		GlobalZIndex = GlobalZIndex + 1
		window.ZIndex = GlobalZIndex
		window.Parent = dockGui
		local outlines = Instance.new("ImageLabel")
		outlines.Name = "Outlines"
		outlines.BackgroundTransparency = 1
		outlines.Image = CONFIG["AssetIds"]["Outline"]
		outlines.ScaleType = Enum.ScaleType.Slice
		outlines.SliceCenter = Rect.new(6, 6, 25, 25)
		outlines.TileSize = UDim2.new(0, 20, 0, 20)
		outlines.Position = UDim2.new(0, -5, 0, -5)
		outlines.Size = UDim2.new(1, 10, 1, 10)
		outlines.Parent = window
		local content = Instance.new("Frame")
		content.Name = "Content"
		content.BackgroundColor3 = CONFIG["Theme"]["Main2"]
		content.BorderSizePixel = 0
		content.Active = true
		content.Position = UDim2.new(0, 0, 0, 20)
		content.Size = UDim2.new(1, 0, 1, -20)
		content.ClipsDescendants = true
		content.Parent = window

		local contentPadding = Instance.new("UIPadding", content)
		contentPadding.PaddingLeft = UDim.new(0, 0.9)
		contentPadding.PaddingRight = UDim.new(0, 0.9)
		local line = Instance.new("Frame")
		line.Name = "Line"
		line.BackgroundColor3 = CONFIG["Theme"]["Outline1"]
		line.BorderSizePixel = 0
		line.Size = UDim2.new(1, 0, 0, 1)
		line.Parent = content
		local topBar = Instance.new("TextButton")
		topBar.Name = "TopBar"
		topBar.Text = ""
		topBar.AutoButtonColor = false
		topBar.BackgroundColor3 = CONFIG["Theme"]["Main1"]
		topBar.BorderSizePixel = 0
		topBar.Size = UDim2.new(1, 0, 0, 20)
		topBar.Parent = window
		local windowTitle = Instance.new("TextLabel")
		windowTitle.Name = "Title"
		windowTitle.BackgroundTransparency = 1
		windowTitle.Position = UDim2.new(0, 5, 0, 0)
		windowTitle.Size = UDim2.new(1, -10, 1, 0)
		windowTitle.Font = Enum.Font.SourceSans
		windowTitle.Text = titleText
		windowTitle.TextColor3 = CONFIG["Theme"]["Text"]
		windowTitle.TextSize = 14
		windowTitle.TextXAlignment = Enum.TextXAlignment.Left
		windowTitle.Parent = topBar
		local function createTopBtn(name, ico, xOffset)
			local btn = Instance.new("TextButton")
			btn.Name = name
			btn.AutoButtonColor = false
			btn.BackgroundColor3 = CONFIG["Theme"]["Menu"]
			btn.BackgroundTransparency = 1
			btn.BorderSizePixel = 0
			btn.Position = UDim2.new(1, xOffset, 0, 2)
			btn.Size = UDim2.new(0, 16, 0, 16)
			btn.Text = ""
			btn.Parent = topBar
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 4)
			corner.Parent = btn
			local icon = Instance.new("ImageLabel")
			icon.Name = "Icon"
			icon.BackgroundTransparency = 1
			icon.Image = ico
			icon.Position = UDim2.new(0, 3, 0, 3)
			icon.Size = UDim2.new(0, 10, 0, 10)
			icon.Parent = btn
			local holding = false
			TrackConnection(btn.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					if not holding then btn.BackgroundTransparency = 0.4 end
				elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
					holding = true
					btn.BackgroundTransparency = 0
				end
			end))
			TrackConnection(btn.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					if not holding then btn.BackgroundTransparency = 1 end
				elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
					holding = false
					btn.BackgroundTransparency = 1
				end
			end))
			TrackConnection(btn.MouseLeave:Connect(function()
				if not holding then btn.BackgroundTransparency = 1 end
			end))
			return btn, icon
		end
		local closeBtn, closeIcon = createTopBtn("Close", CONFIG["AssetIds"]["CloseBtn"], -18)
		local maxBtn, maxIcon = createTopBtn("Maximize", CONFIG["AssetIds"]["MaxBtn"], -36)
		local minBtn, minIcon = createTopBtn("Minimize", CONFIG["AssetIds"]["MinBtn"], -54)
		local isDragging = false
		local dragStartPos = nil
		local dragStartWinPos = nil
		local isDocked = initialDock or "None"
		local isMaximized = false
		local isMinimized = false
		local preDockSize = window.Size
		local preDockPos = window.Position
		local currentPreviewTween = nil

		local function getInsertPreview(side, mPos)
			local count = #DockedWindows[side]
			if count == 0 then
				if side == "Left" then return UDim2.new(0, DockSizes["Left"], 1, 0), UDim2.new(0, 0, 0, 0) end
				if side == "Right" then return UDim2.new(0, DockSizes["Right"], 1, 0), UDim2.new(1, -DockSizes["Right"], 0, 0) end
				if side == "Bottom" then return UDim2.new(1, 0, 0, DockSizes["Bottom"]), UDim2.new(0, 0, 1, -DockSizes["Bottom"]) end
			end

			local insertIndex = getInsertIndex(side, mPos, count)
			if side == "Left" or side == "Right" then
				local hRatio = 1 / (count + 1)
				local yPos = (insertIndex - 1) * hRatio
				if side == "Left" then return UDim2.new(0, DockSizes["Left"], hRatio, 0), UDim2.new(0, 0, yPos, 0) end
				if side == "Right" then return UDim2.new(0, DockSizes["Right"], hRatio, 0), UDim2.new(1, -DockSizes["Right"], yPos, 0) end
			elseif side == "Bottom" then
				local wRatio = 1 / (count + 1)
				local xPos = (insertIndex - 1) * wRatio
				return UDim2.new(wRatio, 0, 0, DockSizes["Bottom"]), UDim2.new(xPos, 0, 1, -DockSizes["Bottom"])
			end
		end

		local function triggerPreview(size, pos)
			dockPreview.Visible = true
			if currentPreviewTween then currentPreviewTween:Cancel() end
			currentPreviewTween = TweenService:Create(dockPreview, CONFIG["Animation"]["DockUpdate"], {["Size"] = size, ["Position"] = pos})
			currentPreviewTween:Play()
		end

		local resizeControls = Instance.new("Frame")
		resizeControls.Name = "ResizeControls"
		resizeControls.BackgroundTransparency = 1
		resizeControls.Position = UDim2.new(0, 0, 0, 0)
		resizeControls.Size = UDim2.new(1, 0, 1, 0)
		resizeControls.Parent = window

		TrackConnection(window.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				BringToFront(window)
			end
		end))

		TrackConnection(topBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				BringToFront(window)
				isDragging = true
				dragStartPos = input.Position

				if isDocked ~= "None" or isMaximized then
					local oldSide = isDocked
					isDocked = "None"
					isMaximized = false
					outlines.Visible = true
					for _, h in ipairs(resizeControls:GetChildren()) do
						h:SetAttribute("DockActive", false)
						if h:FindFirstChild("Line") then h.Line.Visible = false end
					end
					if oldSide ~= "None" then RemoveDock(window, oldSide) end

					local offsetX = input.Position.X - window.AbsolutePosition.X
					local offsetY = input.Position.Y - window.AbsolutePosition.Y
					offsetX = math.clamp(offsetX, 5, preDockSize.X.Offset - 5)
					offsetY = math.clamp(offsetY, 5, 20)

					dragStartWinPos = UDim2.new(0, input.Position.X - offsetX, 0, input.Position.Y - offsetY)

					if isMinimized then
						window.Size = UDim2.new(0, preDockSize.X.Offset, 0, 20)
						window.Position = dragStartWinPos
					else
						TweenService:Create(window, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {["Size"] = preDockSize, ["Position"] = dragStartWinPos}):Play()
					end
				else
					dragStartWinPos = window.Position
				end
			end
		end))

		TrackConnection(UIS.InputChanged:Connect(function(input)
			if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				local delta = input.Position - dragStartPos
				window.Position = UDim2.new(dragStartWinPos.X.Scale, dragStartWinPos.X.Offset + delta.X, dragStartWinPos.Y.Scale, dragStartWinPos.Y.Offset + delta.Y)
				local vpSize = workspace.CurrentCamera.ViewportSize
				local mPos = input.Position
				local edgeThreshold = CONFIG["Settings"]["EdgeThreshold"]
				if mPos.X < edgeThreshold then
					local pSize, pPos = getInsertPreview("Left", mPos)
					triggerPreview(pSize, pPos)
				elseif mPos.X > vpSize.X - edgeThreshold then
					local pSize, pPos = getInsertPreview("Right", mPos)
					triggerPreview(pSize, pPos)
				elseif mPos.Y > vpSize.Y - edgeThreshold then
					local pSize, pPos = getInsertPreview("Bottom", mPos)
					triggerPreview(pSize, pPos)
				elseif mPos.Y < edgeThreshold then
					triggerPreview(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0))
				else
					if currentPreviewTween then currentPreviewTween:Cancel() end
					dockPreview.Visible = false
					dockPreview.Size = UDim2.new(0, 0, 0, 0)
				end
			end
		end))

		TrackConnection(UIS.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if isDragging then
					isDragging = false
					if dockPreview.Visible then
						dockPreview.Visible = false
						local vpSize = workspace.CurrentCamera.ViewportSize
						local mPos = input.Position
						local edgeThreshold = CONFIG["Settings"]["EdgeThreshold"]
						preDockSize = window.Size
						preDockPos = window.Position
						local twInfo = CONFIG["Animation"]["DockUpdate"]
						if mPos.X < edgeThreshold then
							isDocked = "Left"
							AddDock(window, "Left", mPos)
						elseif mPos.X > vpSize.X - edgeThreshold then
							isDocked = "Right"
							AddDock(window, "Right", mPos)
						elseif mPos.Y > vpSize.Y - edgeThreshold then
							isDocked = "Bottom"
							AddDock(window, "Bottom", mPos)
						elseif mPos.Y < edgeThreshold then
							isMaximized = true
							outlines.Visible = false
							TweenService:Create(window, twInfo, {["Size"] = UDim2.new(1, 0, 1, 0), ["Position"] = UDim2.new(0, 0, 0, 0)}):Play()
						end
					end
				end
			end
		end))

		TrackConnection(minBtn.MouseButton1Click:Connect(function()
			isMinimized = not isMinimized
			local twInfo = CONFIG["Animation"]["WindowResize"]
			if isMinimized then
				if isDocked ~= "None" then
					local oldSide = isDocked
					isDocked = "None"
					outlines.Visible = true
					for _, h in ipairs(resizeControls:GetChildren()) do
						h:SetAttribute("DockActive", false)
						if h:FindFirstChild("Line") then h.Line.Visible = false end
					end
					RemoveDock(window, oldSide)
					window.Position = preDockPos
				end
				if isMaximized then
					isMaximized = false
					outlines.Visible = true
					window.Position = preDockPos
				end
				if isDocked == "None" and not isMaximized then preDockSize = window.Size end
				TweenService:Create(window, twInfo, {["Size"] = UDim2.new(0, preDockSize.X.Offset, 0, 20)}):Play()
				minIcon.Image = CONFIG["AssetIds"]["MinBtnActive"]
			else
				TweenService:Create(window, twInfo, {["Size"] = preDockSize}):Play()
				minIcon.Image = CONFIG["AssetIds"]["MinBtn"]
			end
		end))

		TrackConnection(maxBtn.MouseButton1Click:Connect(function()
			if isMinimized then return end
			local twInfo = CONFIG["Animation"]["WindowResize"]
			if isMaximized then
				isMaximized = false
				outlines.Visible = true
				TweenService:Create(window, twInfo, {["Size"] = preDockSize, ["Position"] = preDockPos}):Play()
			else
				if isDocked ~= "None" then
					local oldSide = isDocked
					isDocked = "None"
					outlines.Visible = true
					for _, h in ipairs(resizeControls:GetChildren()) do
						h:SetAttribute("DockActive", false)
						if h:FindFirstChild("Line") then h.Line.Visible = false end
					end
					RemoveDock(window, oldSide)
				end
				if isDocked == "None" then
					preDockSize = window.Size
					preDockPos = window.Position
				end
				isDocked = "None"
				isMaximized = true
				outlines.Visible = false
				TweenService:Create(window, twInfo, {["Size"] = UDim2.new(1, 0, 1, 0), ["Position"] = UDim2.new(0, 0, 0, 0)}):Play()
			end
		end))

		local function createResizeHandle(name, pos, size, edgeX, edgeY)
			if options.Resizable == false then return end
			local handle = Instance.new("TextButton")
			handle.Name = name
			handle.BackgroundTransparency = 1
			handle.Position = pos
			handle.Size = size
			handle.Text = ""
			handle.AutoButtonColor = false
			handle.Parent = resizeControls

			local hoverVis = Instance.new("Frame")
			hoverVis.Name = "HoverVis"
			hoverVis.BackgroundColor3 = CONFIG["Theme"]["ButtonHover"]
			hoverVis.BackgroundTransparency = 1
			hoverVis.BorderSizePixel = 0
			hoverVis.Parent = handle

			local line = Instance.new("Frame")
			line.Name = "Line"
			line.BackgroundColor3 = CONFIG["Theme"]["Outline1"]
			line.BorderSizePixel = 0
			line.ZIndex = 50
			line.Visible = false
			line.Parent = handle

			if name == "E" or name == "W" then
				hoverVis.Size = UDim2.new(0, 4, 1, 28)
				hoverVis.Position = UDim2.new(0.5, -2, 0, -14)
				line.Size = UDim2.new(0, 5.5, 1, 28)
				line.Position = UDim2.new(0.5, -1, 0, -14)
			elseif name == "S" or name == "N" then
				hoverVis.Size = UDim2.new(1, 28, 0, 4)
				hoverVis.Position = UDim2.new(0, -14, 0.5, -2)
				line.Size = UDim2.new(1, 28, 0, 2)
				line.Position = UDim2.new(0, -14, 0.5, -1)
			else
				hoverVis.Size = UDim2.new(1, 0, 1, 0)
				hoverVis.Position = UDim2.new(0, 0, 0, 0)
			end

			local isResizing = false
			local resizeStartPos = nil
			local resizeStartSize = nil
			local resizeStartWinPos = nil

			TrackConnection(handle.MouseEnter:Connect(function()
				if handle:GetAttribute("DockActive") or isDocked == "None" then
					hoverVis.BackgroundTransparency = 0.5
				end
			end))

			TrackConnection(handle.MouseLeave:Connect(function()
				if not isResizing then
					hoverVis.BackgroundTransparency = 1
				end
			end))

			TrackConnection(handle.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not isMinimized and not isMaximized then
						local canResize = false
						if isDocked == "None" then canResize = true
						elseif isDocked == "Left" and (name == "E" or name == "S") and handle:GetAttribute("DockActive") then canResize = true
						elseif isDocked == "Right" and (name == "W" or name == "S") and handle:GetAttribute("DockActive") then canResize = true
						elseif isDocked == "Bottom" and (name == "N" or name == "E") and handle:GetAttribute("DockActive") then canResize = true
						end
						if canResize then
							isResizing = true
							resizeStartPos = input.Position
							resizeStartSize = window.AbsoluteSize
							resizeStartWinPos = window.Position
							hoverVis.BackgroundTransparency = 0.5
						end
					end
				end
			end))

			TrackConnection(UIS.InputChanged:Connect(function(input)
				if isResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
					local delta = input.Position - resizeStartPos
					if isDocked == "Left" or isDocked == "Right" then
						if name == "E" and isDocked == "Left" then
							DockSizes["Left"] = math.max(150, resizeStartSize.X + delta.X)
							UpdateDockedWindows("Left", true)
						elseif name == "W" and isDocked == "Right" then
							DockSizes["Right"] = math.max(150, resizeStartSize.X - delta.X)
							UpdateDockedWindows("Right", true)
						elseif name == "S" then
							local wins = DockedWindows[isDocked]
							local myIndex = table.find(wins, window)
							if myIndex and myIndex < #wins then
								local nextWin = wins[myIndex + 1]
								local myWeight = window:GetAttribute("DockWeight")
								local nextWeight = nextWin:GetAttribute("DockWeight")
								local totalWeight = myWeight + nextWeight
								local viewportHeight = workspace.CurrentCamera.ViewportSize.Y
								local deltaScale = delta.Y / viewportHeight
								local allWeights = 0
								for _, w in ipairs(wins) do allWeights = allWeights + w:GetAttribute("DockWeight") end
								local deltaWeight = deltaScale * allWeights
								local newMyWeight = math.max(0.1, myWeight + deltaWeight)
								local newNextWeight = math.max(0.1, totalWeight - (newMyWeight - myWeight))
								if newNextWeight == 0.1 then
									newMyWeight = totalWeight - 0.1
								end
								window:SetAttribute("DockWeight", newMyWeight)
								nextWin:SetAttribute("DockWeight", newNextWeight)
								resizeStartPos = input.Position
								UpdateDockedWindows(isDocked, true)
							end
						end
					elseif isDocked == "Bottom" then
						if name == "N" then
							DockSizes["Bottom"] = math.max(100, resizeStartSize.Y - delta.Y)
							UpdateDockedWindows("Bottom", true)
						elseif name == "E" then
							local wins = DockedWindows[isDocked]
							local myIndex = table.find(wins, window)
							if myIndex and myIndex < #wins then
								local nextWin = wins[myIndex + 1]
								local myWeight = window:GetAttribute("DockWeight")
								local nextWeight = nextWin:GetAttribute("DockWeight")
								local totalWeight = myWeight + nextWeight
								local viewportWidth = workspace.CurrentCamera.ViewportSize.X
								local deltaScale = delta.X / viewportWidth
								local allWeights = 0
								for _, w in ipairs(wins) do allWeights = allWeights + w:GetAttribute("DockWeight") end
								local deltaWeight = deltaScale * allWeights
								local newMyWeight = math.max(0.1, myWeight + deltaWeight)
								local newNextWeight = math.max(0.1, totalWeight - (newMyWeight - myWeight))
								if newNextWeight == 0.1 then
									newMyWeight = totalWeight - 0.1
								end
								window:SetAttribute("DockWeight", newMyWeight)
								nextWin:SetAttribute("DockWeight", newNextWeight)
								resizeStartPos = input.Position
								UpdateDockedWindows("Bottom", true)
							end
						end
					else
						local newSizeX = resizeStartSize.X
						local newSizeY = resizeStartSize.Y
						local newPosX = resizeStartWinPos.X.Offset
						local newPosY = resizeStartWinPos.Y.Offset
						if edgeX == 1 then
							newSizeX = math.max(CONFIG["Settings"]["MinWindowSize"].X, resizeStartSize.X + delta.X)
						elseif edgeX == -1 then
							newSizeX = math.max(CONFIG["Settings"]["MinWindowSize"].X, resizeStartSize.X - delta.X)
							newPosX = resizeStartWinPos.X.Offset + (resizeStartSize.X - newSizeX)
						end
						if edgeY == 1 then
							newSizeY = math.max(CONFIG["Settings"]["MinWindowSize"].Y, resizeStartSize.Y + delta.Y)
						elseif edgeY == -1 then
							newSizeY = math.max(CONFIG["Settings"]["MinWindowSize"].Y, resizeStartSize.Y - delta.Y)
							newPosY = resizeStartWinPos.Y.Offset + (resizeStartSize.Y - newSizeY)
						end
						window.Size = UDim2.new(0, newSizeX, 0, newSizeY)
						window.Position = UDim2.new(resizeStartWinPos.X.Scale, newPosX, resizeStartWinPos.Y.Scale, newPosY)
						preDockSize = window.Size
						preDockPos = window.Position
					end
				end
			end))

			TrackConnection(UIS.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if isResizing then
						isResizing = false
						hoverVis.BackgroundTransparency = 1
					end
				end
			end))
		end

		createResizeHandle("N", UDim2.new(0, 14, 0, -7), UDim2.new(1, -28, 0, 14), 0, -1)
		createResizeHandle("S", UDim2.new(0, 14, 1, -7), UDim2.new(1, -28, 0, 14), 0, 1)
		createResizeHandle("E", UDim2.new(1, -7, 0, 14), UDim2.new(0, 14, 1, -28), 1, 0)
		createResizeHandle("W", UDim2.new(0, -7, 0, 14), UDim2.new(0, 14, 1, -28), -1, 0)
		createResizeHandle("NW", UDim2.new(0, -7, 0, -7), UDim2.new(0, 14, 0, 14), -1, -1)
		createResizeHandle("NE", UDim2.new(1, -7, 0, -7), UDim2.new(0, 14, 0, 14), 1, -1)
		createResizeHandle("SW", UDim2.new(0, -7, 1, -7), UDim2.new(0, 14, 0, 14), -1, 1)
		createResizeHandle("SE", UDim2.new(1, -7, 1, -7), UDim2.new(0, 14, 0, 14), 1, 1)

		local isOpen = true
		local appBtn = nil
		local highlight, enableText

		if options.ShowInMenu ~= false then
			appBtn = Instance.new("TextButton")
			appBtn.Size = UDim2.new(0, 140, 0, 110)
			appBtn.BackgroundColor3 = CONFIG["Theme"]["AppListCard"]
			appBtn.AutoButtonColor = false
			appBtn.Text = ""
			appBtn.Parent = AppListFrame
			Instance.new("UICorner", appBtn).CornerRadius = UDim.new(0, 8)

			local btnStroke = Instance.new("UIStroke", appBtn)
			btnStroke.Color = CONFIG["Theme"]["Button"]
			btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

			highlight = Instance.new("Frame")
			highlight.Size = UDim2.new(0, 4, 0, 24)
			highlight.Position = UDim2.new(0, 8, 0, 20)
			highlight.BackgroundColor3 = CONFIG["Theme"]["Text"]
			highlight.BorderSizePixel = 0
			highlight.Visible = true
			highlight.Parent = appBtn
			Instance.new("UICorner", highlight).CornerRadius = UDim.new(1, 0)

			local appIcon = Instance.new("ImageLabel")
			appIcon.Size = UDim2.new(0, 28, 0, 28)
			appIcon.Position = UDim2.new(0.5, -14, 0, 15)
			appIcon.BackgroundTransparency = 1
			if type(iconId) == "string" then appIcon.Image = iconId
			elseif type(iconId) == "number" then appIcon.Image = "rbxassetid://" .. iconId
			elseif type(iconId) == "table" then
				appIcon.Image = iconId["Image"]
				appIcon.ImageRectOffset = iconId["ImageRectOffset"] or Vector2.new(0,0)
				appIcon.ImageRectSize = iconId["ImageRectSize"] or Vector2.new(0,0)
			end
			appIcon.Parent = appBtn

			local appName = Instance.new("TextLabel")
			appName.Size = UDim2.new(1, 0, 0, 16)
			appName.Position = UDim2.new(0, 0, 0, 50)
			appName.BackgroundTransparency = 1
			appName.Text = titleText
			appName.TextColor3 = Color3.fromRGB(240, 240, 240)
			appName.Font = Enum.Font.GothamMedium
			appName.TextSize = 13
			appName.TextXAlignment = Enum.TextXAlignment.Center
			appName.Parent = appBtn

			local destroyBtn = Instance.new("ImageButton")
			destroyBtn.Size = UDim2.new(0, 20, 0, 20)
			destroyBtn.Position = UDim2.new(1, -25, 0, 5)
			destroyBtn.BackgroundTransparency = 1
			destroyBtn.Image = ""
			destroyBtn.Parent = appBtn
			local destroyBtnIcon = Instance.new("ImageLabel", destroyBtn)
			destroyBtnIcon.BackgroundTransparency = 1
			destroyBtnIcon.Size = UDim2.new(0, 12, 0, 12)
			destroyBtnIcon.Position = UDim2.new(0.5, -6, 0.5, -6)
			destroyBtnIcon.Image = CONFIG["AssetIds"]["CloseBtn"]
			destroyBtnIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)

			local enableBtnBox = Instance.new("Frame", appBtn)
			enableBtnBox.BackgroundColor3 = CONFIG["Theme"]["AppListCardHover"]
			enableBtnBox.Size = UDim2.new(0, 110, 0, 26)
			enableBtnBox.Position = UDim2.new(0.5, -55, 1, -34)
			Instance.new("UICorner", enableBtnBox).CornerRadius = UDim.new(0, 6)
			local enableBtnStroke = Instance.new("UIStroke", enableBtnBox)
			enableBtnStroke.Color = CONFIG["Theme"]["Button"]

			local enableIcon = Instance.new("ImageLabel", enableBtnBox)
			enableIcon.BackgroundTransparency = 1
			enableIcon.Image = CONFIG["AssetIds"]["Logo"]
			enableIcon.Size = UDim2.new(0, 14, 0, 14)
			enableIcon.Position = UDim2.new(0, 10, 0.5, -7)

			local enableCost = Instance.new("TextLabel", enableBtnBox)
			enableCost.BackgroundTransparency = 1
			enableCost.Size = UDim2.new(0, 15, 1, 0)
			enableCost.Position = UDim2.new(0, 28, 0, 0)
			enableCost.Text = "1"
			enableCost.TextColor3 = Color3.fromRGB(200, 200, 200)
			enableCost.Font = Enum.Font.Gotham
			enableCost.TextSize = 12

			local enableLine = Instance.new("Frame", enableBtnBox)
			enableLine.BackgroundColor3 = CONFIG["Theme"]["Button"]
			enableLine.BorderSizePixel = 0
			enableLine.Size = UDim2.new(0, 1, 0, 16)
			enableLine.Position = UDim2.new(0, 45, 0.5, -8)

			enableText = Instance.new("TextLabel", enableBtnBox)
			enableText.BackgroundTransparency = 1
			enableText.Size = UDim2.new(1, -50, 1, 0)
			enableText.Position = UDim2.new(0, 50, 0, 0)
			enableText.Text = CONFIG["Strings"]["Disable"]
			enableText.TextColor3 = Color3.fromRGB(220, 220, 220)
			enableText.Font = Enum.Font.Gotham
			enableText.TextSize = 12

			appBtn:SetAttribute("isOpen", isOpen)

			TrackConnection(appBtn.MouseEnter:Connect(function()
				TweenService:Create(appBtn, CONFIG["Animation"]["AppHover"], {["BackgroundColor3"] = CONFIG["Theme"]["AppListCardHover"]}):Play()
			end))
			TrackConnection(appBtn.MouseLeave:Connect(function()
				TweenService:Create(appBtn, CONFIG["Animation"]["AppHover"], {["BackgroundColor3"] = CONFIG["Theme"]["AppListCard"]}):Play()
			end))

			table.insert(Apps, appBtn)

			TrackConnection(destroyBtn.MouseButton1Click:Connect(function()
				if isDocked ~= "None" then RemoveDock(window, isDocked) end
				window:Destroy()
				if appBtn then appBtn:Destroy() end
				for i, app in ipairs(Apps) do
					if app == appBtn then
						table.remove(Apps, i)
						break
					end
				end
				if _G.UpdateMenuCounts then _G.UpdateMenuCounts() end
			end))
		end

		local function ToggleWindow(forceState)
			if forceState ~= nil then
				if isOpen == forceState then return end
				isOpen = forceState
			else
				isOpen = not isOpen
			end
			if appBtn then
				appBtn:SetAttribute("isOpen", isOpen)
				highlight.Visible = isOpen
				enableText.Text = isOpen and CONFIG["Strings"]["Disable"] or CONFIG["Strings"]["Enable"]
			end
			if _G.UpdateMenuCounts then _G.UpdateMenuCounts() end

			if isOpen then
				window.Visible = true
				window.Size = UDim2.new(0, window.Size.X.Offset, 0, 20)
				topBar.BackgroundTransparency = 1
				windowTitle.TextTransparency = 1
				if isDocked == "None" then outlines.ImageTransparency = 1 end
				closeIcon.ImageTransparency = 1
				maxIcon.ImageTransparency = 1
				minIcon.ImageTransparency = 1
				
				local twInfoOpen = CONFIG["Animation"]["WindowClose"]
				TweenService:Create(topBar, twInfoOpen, {BackgroundTransparency = 0}):Play()
				TweenService:Create(windowTitle, twInfoOpen, {TextTransparency = 0}):Play()
				if isDocked == "None" then TweenService:Create(outlines, twInfoOpen, {ImageTransparency = 0}):Play() end
				TweenService:Create(closeIcon, twInfoOpen, {ImageTransparency = 0}):Play()
				TweenService:Create(maxIcon, twInfoOpen, {ImageTransparency = 0}):Play()
				TweenService:Create(minIcon, twInfoOpen, {ImageTransparency = 0}):Play()
				
				if isDocked ~= "None" then
					if isDocked == "Left" then window.Position = UDim2.new(0, -DockSizes["Left"], 0.5, 0)
					elseif isDocked == "Right" then window.Position = UDim2.new(1, DockSizes["Right"], 0.5, 0)
					elseif isDocked == "Bottom" then window.Position = UDim2.new(0.5, 0, 1, DockSizes["Bottom"]) end
					AddDock(window, isDocked)
				else
					TweenService:Create(window, CONFIG["Animation"]["WindowResize"], {["Size"] = preDockSize}):Play()
				end
				BringToFront(window)
			else
				if isDocked ~= "None" then
					RemoveDock(window, isDocked)
				end
				local twInfo = CONFIG["Animation"]["WindowClose"]
				local t1 = TweenService:Create(window, twInfo, {["Size"] = UDim2.new(0, window.Size.X.Offset, 0, 20)})
				t1:Play()
				TrackConnection(t1.Completed:Connect(function()
					if isOpen then return end
					TweenService:Create(topBar, twInfo, {["BackgroundTransparency"] = 1}):Play()
					TweenService:Create(windowTitle, twInfo, {["TextTransparency"] = 1}):Play()
					TweenService:Create(outlines, twInfo, {["ImageTransparency"] = 1}):Play()
					closeIcon.ImageTransparency = 1
					maxIcon.ImageTransparency = 1
					minIcon.ImageTransparency = 1
					task.delay(0.2, function()
						if not isOpen then window.Visible = false end
					end)
				end))
			end
		end

		if appBtn then
			TrackConnection(appBtn.MouseButton1Click:Connect(function() ToggleWindow() end))
		end
		closeBtn.MouseButton1Click:Connect(function() ToggleWindow(false) end)

		if options.ShowInMenu == false then
			isOpen = false
			window.Visible = false
		end
		if isDocked ~= "None" then
			outlines.Visible = false
			window:SetAttribute("DockWeight", 1)
			if not DockedWindows[isDocked] then DockedWindows[isDocked] = {} end
			table.insert(DockedWindows[isDocked], window)
			if isDocked == "Left" then window.Position = UDim2.new(0, -DockSizes["Left"], 0.5, 0)
			elseif isDocked == "Right" then window.Position = UDim2.new(1, DockSizes["Right"], 0.5, 0)
			elseif isDocked == "Bottom" then window.Position = UDim2.new(0.5, 0, 1, DockSizes["Bottom"]) end
			UpdateDockedWindows(isDocked, false)
		else
			if options.ShowInMenu ~= false then
				window.Size = UDim2.new(0, preDockSize.X.Offset, 0, 20)
				TweenService:Create(window, CONFIG["Animation"]["WindowResize"], {["Size"] = preDockSize}):Play()
			end
		end

		return window, content, ToggleWindow
	end

	_G.Onion["CreateDock"] = CreateDexWindow

	local ScriptViewerData = {
		Win = nil,
		Content = nil,
		ToggleFunc = nil,
		TabsContainer = nil,
		CodeArea = nil,
		Toolbar = nil,
		OpenedScripts = {},
		ActiveIndex = 0
	}

	local function OpenScriptViewer(inst)
		if not ScriptViewerData.Win then
			ScriptViewerData.Win, ScriptViewerData.Content, ScriptViewerData.ToggleFunc = _G.Onion["CreateDock"]("Script Viewer", CONFIG["AssetIds"]["ScriptViewer"])
			TweenService:Create(ScriptViewerData.Win, CONFIG["Animation"]["WindowResize"], {["Size"] = UDim2.new(0, 1000, 0, 550)}):Play()
			
			local tabsScroll = Instance.new("ScrollingFrame")
			tabsScroll.Name = "TabsScroll"
			tabsScroll.Size = UDim2.new(1, 0, 0, 30)
			tabsScroll.Position = UDim2.new(0, 0, 0, 0)
			tabsScroll.BackgroundColor3 = CONFIG["Theme"]["Main1"]
			tabsScroll.BorderSizePixel = 0
			tabsScroll.ScrollBarThickness = 2
			tabsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
			tabsScroll.Parent = ScriptViewerData.Content
			ScriptViewerData.TabsContainer = tabsScroll

			local tabLayout = Instance.new("UIListLayout", tabsScroll)
			tabLayout.FillDirection = Enum.FillDirection.Horizontal
			tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
			tabLayout.Padding = UDim.new(0, 2)
			
			local codeArea = Instance.new("Frame")
			codeArea.Name = "CodeArea"
			codeArea.Size = UDim2.new(1, 0, 1, -60)
			codeArea.Position = UDim2.new(0, 0, 0, 30)
			codeArea.BackgroundTransparency = 1
			codeArea.Parent = ScriptViewerData.Content
			ScriptViewerData.CodeArea = codeArea
			
			local toolbar = Instance.new("Frame")
			toolbar.Size = UDim2.new(1, 0, 0, 24)
			toolbar.Position = UDim2.new(0, 0, 1, -30)
			toolbar.BackgroundColor3 = CONFIG["Theme"]["Main2"]
			toolbar.BorderSizePixel = 0
			toolbar.Parent = ScriptViewerData.Content
			ScriptViewerData.Toolbar = toolbar
			
			local btnCopy = Instance.new("TextButton")
			btnCopy.Size = UDim2.new(0.33, 0, 1, 0)
			btnCopy.Position = UDim2.new(0, 0, 0, 0)
			btnCopy.BackgroundTransparency = 1
			btnCopy.Text = CONFIG["Strings"]["CopyClipboard"]
			btnCopy.TextColor3 = CONFIG["Theme"]["Text"]
			btnCopy.Font = Enum.Font.Gotham
			btnCopy.TextSize = 12
			btnCopy.Parent = toolbar
			
			local btnSave = Instance.new("TextButton")
			btnSave.Size = UDim2.new(0.33, 0, 1, 0)
			btnSave.Position = UDim2.new(0.33, 0, 0, 0)
			btnSave.BackgroundTransparency = 1
			btnSave.Text = CONFIG["Strings"]["SaveFile"]
			btnSave.TextColor3 = CONFIG["Theme"]["Text"]
			btnSave.Font = Enum.Font.Gotham
			btnSave.TextSize = 12
			btnSave.Parent = toolbar
			
			local btnDump = Instance.new("TextButton")
			btnDump.Size = UDim2.new(0.34, 0, 1, 0)
			btnDump.Position = UDim2.new(0.66, 0, 0, 0)
			btnDump.BackgroundTransparency = 1
			btnDump.Text = CONFIG["Strings"]["DumpFuncs"]
			btnDump.TextColor3 = CONFIG["Theme"]["Text"]
			btnDump.Font = Enum.Font.Gotham
			btnDump.TextSize = 12
			btnDump.Parent = toolbar
			
			TrackConnection(btnCopy.MouseButton1Click:Connect(function()
				local activeScript = ScriptViewerData.OpenedScripts[ScriptViewerData.ActiveIndex]
				if not activeScript then return end
				local setclip = setclipboard or toclipboard or set_clipboard
				if setclip then pcall(function() setclip(activeScript.CurrentCode) end) end
			end))
			
			TrackConnection(btnSave.MouseButton1Click:Connect(function()
				local activeScript = ScriptViewerData.OpenedScripts[ScriptViewerData.ActiveIndex]
				if not activeScript then return end
				if writefile then pcall(function() writefile(activeScript.Inst.Name .. ".lua", activeScript.CurrentCode) end) end
			end))
		else
			if ScriptViewerData.ToggleFunc then
				ScriptViewerData.ToggleFunc(true)
			end
			local foundIndex = nil
			for i, data in ipairs(ScriptViewerData.OpenedScripts) do
				if data.Inst == inst then
					foundIndex = i
					break
				end
			end
			if foundIndex then
				SwitchToScriptTab(foundIndex)
				return
			end
		end

		local scriptData = {
			Inst = inst,
			CurrentCode = "",
			TabBtn = nil,
			EditorGroup = nil,
			BaseLineEditor = nil,
			FallbackBox = nil,
			Separator = nil
		}
		table.insert(ScriptViewerData.OpenedScripts, scriptData)
		local newIndex = #ScriptViewerData.OpenedScripts

		local tabBtn = Instance.new("TextButton")
		tabBtn.Name = "Tab_" .. inst.Name
		tabBtn.Size = UDim2.new(0, 150, 1, 0)
		tabBtn.BackgroundColor3 = CONFIG["Theme"]["Main2"]
		tabBtn.BackgroundTransparency = 0.5
		tabBtn.BorderSizePixel = 0
		tabBtn.Text = ""
		tabBtn.AutoButtonColor = false
		tabBtn.LayoutOrder = newIndex
		tabBtn.Parent = ScriptViewerData.TabsContainer
		scriptData.TabBtn = tabBtn
		
		local tabSeparator = Instance.new("Frame")
		tabSeparator.Name = "Separator"
		tabSeparator.Size = UDim2.new(1, 0, 0, 2)
		tabSeparator.Position = UDim2.new(0, 0, 1, -2)
		tabSeparator.BackgroundColor3 = CONFIG["Theme"]["ListSelection"]
		tabSeparator.BorderSizePixel = 0
		tabSeparator.BackgroundTransparency = 1
		tabSeparator.Parent = tabBtn
		scriptData.Separator = tabSeparator

		local tabIcon = Instance.new("ImageLabel")
		tabIcon.Size = UDim2.new(0, 16, 0, 16)
		tabIcon.Position = UDim2.new(0, 5, 0.5, -8)
		tabIcon.BackgroundTransparency = 1
		tabIcon:SetAttribute("CurrentClass", inst.ClassName)
		
		local theme = CONFIG["Settings"]["IconTheme"]

		if theme == "CustomDark" or theme == "CustomLight" then
			local folderTheme = theme == "CustomDark" and "dark" or "light"
			local cached = CustomIconCache[inst.ClassName]

			if cached then
				if cached == "NONE" then
					tabIcon.Image = ""
					tabIcon.ImageTransparency = 1
				else
					tabIcon.Image = cached
					tabIcon.ImageRectOffset = Vector2.new(0, 0)
					tabIcon.ImageRectSize = Vector2.new(0, 0)
					tabIcon.ImageTransparency = 0
				end
			else
				tabIcon.Image = ""
				tabIcon.ImageTransparency = 1
				if not CurrentlyFetching[inst.ClassName] then
					CurrentlyFetching[inst.ClassName] = true
					task.spawn(function()
						local asset = GetCustomIconAsset(inst.ClassName, folderTheme)
						CurrentlyFetching[inst.ClassName] = nil

						if tabIcon:GetAttribute("CurrentClass") == inst.ClassName then
							if asset == "NONE" then
								tabIcon.Image = ""
								tabIcon.ImageTransparency = 1
							else
								tabIcon.Image = asset
								tabIcon.ImageRectOffset = Vector2.new(0, 0)
								tabIcon.ImageRectSize = Vector2.new(0, 0)
								tabIcon.ImageTransparency = 0
							end
						end
					end)
				end
			end
		elseif (theme == "Default" or theme == "Default2") and DefaultIconsLoaded then
			local info = DefaultIcons[inst.ClassName] or DefaultIcons["File"] or {x = 0, y = 0}
			tabIcon.Image = "rbxassetid://15288945291"
			tabIcon.ImageRectOffset = Vector2.new(info.x, info.y)
			tabIcon.ImageRectSize = Vector2.new(16, 16)
			tabIcon.ImageTransparency = 0
		elseif theme == "Vanilla" and VanillaIconsLoaded then
			local iconId = VanillaIcons[inst.ClassName] or VanillaIcons["Instance"] or CONFIG["AssetIds"]["ExplorerIconDefault"]
			tabIcon.Image = iconId
			tabIcon.ImageRectOffset = Vector2.new(0, 0)
			tabIcon.ImageRectSize = Vector2.new(0, 0)
			tabIcon.ImageTransparency = 0
		else
			local offset, size = GetIconRect(inst.ClassName)
			tabIcon.Image = CONFIG["AssetIds"]["ExplorerIconFallback"]
			tabIcon.ImageRectOffset = offset
			tabIcon.ImageRectSize = size
			tabIcon.ImageTransparency = 0
		end
		
		tabIcon.Parent = tabBtn

		local tabName = Instance.new("TextLabel")
		tabName.Size = UDim2.new(1, -45, 1, 0)
		tabName.Position = UDim2.new(0, 25, 0, 0)
		tabName.BackgroundTransparency = 1
		tabName.Text = inst.Name
		tabName.TextColor3 = CONFIG["Theme"]["Text"]
		tabName.TextXAlignment = Enum.TextXAlignment.Left
		tabName.Font = Enum.Font.Gotham
		tabName.TextSize = 13
		tabName.TextTruncate = Enum.TextTruncate.AtEnd
		tabName.Parent = tabBtn

		local tabClose = Instance.new("ImageButton")
		tabClose.Size = UDim2.new(0, 10, 0, 10)
		tabClose.Position = UDim2.new(1, -16, 0.5, -5)
		tabClose.BackgroundTransparency = 1
		tabClose.Image = CONFIG["AssetIds"]["CloseBtn"]
		tabClose.ImageColor3 = Color3.fromRGB(180, 180, 180)
		tabClose.Parent = tabBtn

		local codeCanvas = Instance.new("Frame")
		codeCanvas.Size = UDim2.new(1, 0, 1, 0)
		codeCanvas.Position = UDim2.new(0, 0, 0, 0)
		codeCanvas.BackgroundColor3 = CONFIG["Theme"]["Main2"]
		codeCanvas.BorderSizePixel = 0
		codeCanvas.Visible = false
		codeCanvas.ClipsDescendants = true
		codeCanvas.BackgroundColor3 = Color3.fromRGB(3, 3, 3)
		codeCanvas.Parent = ScriptViewerData.CodeArea
		scriptData.EditorGroup = codeCanvas

		pcall(function()
			local raw = game:HttpGet(CONFIG["Urls"]["Baseline"])
			local Baseline = loadstring(raw)()
			if Baseline then
				local editor = Baseline.new(codeCanvas)
				editor:ImportTheme(CONFIG["Urls"]["PaperDark"])
				editor.ReadOnly = true
				if not CONFIG["Settings"]["Baseline"] then
					CONFIG["Settings"]["Baseline"] = {
						SmoothBlinker = true,
						TextSize = 16,
						Font = "RobotoMono",
						Minimap = true,
						Lines = true,
						Wrapped = false
					}
				end
				for k, v in pairs(CONFIG["Settings"]["Baseline"]) do
					if k == "Font" then
						pcall(function() editor.Font = Enum.Font[v] end)
					else
						pcall(function() editor[k] = v end)
					end
				end
				editor.Text = CONFIG["Strings"]["Decompiling"]
				scriptData.BaseLineEditor = editor
				
				task.spawn(function()
					task.wait(0.5)
					codeCanvas.BackgroundColor3 = Color3.fromRGB(3, 3, 3)
					for _, v in ipairs(codeCanvas:GetDescendants()) do
						if v:IsA("Frame") or v:IsA("ScrollingFrame") or v:IsA("TextBox") then
							if v.BackgroundColor3 == Color3.fromRGB(3, 3, 3) then
								v.BackgroundColor3 = Color3.fromRGB(3, 3, 3)
							end
							if v.ClassName == "ScrollingFrame" then
								v.ScrollBarImageColor3 = Color3.fromRGB(3, 3, 3)
								v.ScrollBarImageTransparency = 0.5
							end
							if v.Name == "VScrollBar" or v.Name == "HScrollBar" then
								v.BackgroundTransparency = 1
								for _, child in ipairs(v:GetDescendants()) do
									if child:IsA("Frame") and child.Name == "Track" then
										child.BackgroundTransparency = 1
									end
									if child:IsA("Frame") and child.Name == "Thumb" then
										child.BackgroundTransparency = 0.3
										child.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
									end
								end
							end
						end
					end
				end)
			end
		end)

		if not scriptData.BaseLineEditor then
			local fallbackTextBox = Instance.new("TextBox")
			fallbackTextBox.Size = UDim2.new(1, -10, 1, -10)
			fallbackTextBox.Position = UDim2.new(0, 5, 0, 5)
			fallbackTextBox.BackgroundTransparency = 0
			fallbackTextBox.BackgroundColor3 = CONFIG["Theme"]["Main2"]
			fallbackTextBox.BorderSizePixel = 0
			fallbackTextBox.TextEditable = false
			fallbackTextBox.ClearTextOnFocus = false
			fallbackTextBox.TextXAlignment = Enum.TextXAlignment.Left
			fallbackTextBox.TextYAlignment = Enum.TextYAlignment.Top
			fallbackTextBox.TextColor3 = CONFIG["Theme"]["Text"]
			fallbackTextBox.Font = Enum.Font.Code
			fallbackTextBox.TextSize = 16
			fallbackTextBox.MultiLine = true
			fallbackTextBox.Text = CONFIG["Strings"]["Decompiling"]
			fallbackTextBox.Parent = codeCanvas
			scriptData.FallbackBox = fallbackTextBox
		end

		task.spawn(function()
			local code = ""
			if decompile then
				local success, result = pcall(function() return decompile(inst) end)
				if success and result then
					code = result
				else
					code = CONFIG["Strings"]["FailedDecompile"] .. tostring(result)
				end
			else
				code = CONFIG["Strings"]["NoDecompiler"]
			end
			scriptData.CurrentCode = code
			if scriptData.BaseLineEditor then
				scriptData.BaseLineEditor.Text = code
			elseif scriptData.FallbackBox then
				scriptData.FallbackBox.Text = code
			end
		end)

		local uiListLayout = ScriptViewerData.TabsContainer:FindFirstChildOfClass("UIListLayout")
		if uiListLayout then
			ScriptViewerData.TabsContainer.CanvasSize = UDim2.new(0, uiListLayout.AbsoluteContentSize.X + (#ScriptViewerData.OpenedScripts * 2), 0, 0)
		end

		TrackConnection(tabBtn.MouseButton1Click:Connect(function()
			for i, data in ipairs(ScriptViewerData.OpenedScripts) do
				if data.Inst == inst then
					SwitchToScriptTab(i)
					break
				end
			end
		end))

		TrackConnection(tabClose.MouseButton1Click:Connect(function()
			local closeIndex = nil
			for i, data in ipairs(ScriptViewerData.OpenedScripts) do
				if data.Inst == inst then
					closeIndex = i
					break
				end
			end
			if closeIndex then
				CloseScriptTab(closeIndex)
			end
		end))

		SwitchToScriptTab(newIndex)
	end

	function SwitchToScriptTab(index)
		local data = ScriptViewerData.OpenedScripts[index]
		if not data then return end
		
		ScriptViewerData.ActiveIndex = index
		for i, sData in ipairs(ScriptViewerData.OpenedScripts) do
			if sData.EditorGroup then
				sData.EditorGroup.Visible = (i == index)
			end
			if sData.TabBtn then
				local isAct = (i == index)
				local targetBg = isAct and CONFIG["Theme"]["Main1"] or CONFIG["Theme"]["Main2"]
				local targetTrans = isAct and 0 or 0.5
				local sepTrans = isAct and 0 or 1

				TweenService:Create(sData.TabBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = targetBg,
					BackgroundTransparency = targetTrans
				}):Play()

				if sData.Separator then
					TweenService:Create(sData.Separator, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundTransparency = sepTrans
					}):Play()
				end
			end
		end
	end

	function CloseScriptTab(index)
		local data = table.remove(ScriptViewerData.OpenedScripts, index)
		if data then
			if data.TabBtn then data.TabBtn:Destroy() end
			if data.EditorGroup then data.EditorGroup:Destroy() end
		end
		
		if ScriptViewerData.TabsContainer then
			local uiListLayout = ScriptViewerData.TabsContainer:FindFirstChildOfClass("UIListLayout")
			if uiListLayout then
				ScriptViewerData.TabsContainer.CanvasSize = UDim2.new(0, uiListLayout.AbsoluteContentSize.X + (#ScriptViewerData.OpenedScripts * 2), 0, 0)
			end
		end

		if #ScriptViewerData.OpenedScripts > 0 then
			local nextIndex = index
			if nextIndex > #ScriptViewerData.OpenedScripts then
				nextIndex = #ScriptViewerData.OpenedScripts
			end
			for i, sData in ipairs(ScriptViewerData.OpenedScripts) do
				if sData.TabBtn then
					sData.TabBtn.LayoutOrder = i
				end
			end
			SwitchToScriptTab(nextIndex)
		else
			ScriptViewerData.ActiveIndex = 0
			if ScriptViewerData.ToggleFunc then
				ScriptViewerData.ToggleFunc(false)
			end
		end
	end

	local ExplorerOrders = {}
	local function InitExplorer(parentContent)
		local scrollFrame = Instance.new("ScrollingFrame")
		scrollFrame.Name = "TreeScroll"
		scrollFrame.BackgroundColor3 = CONFIG["Theme"]["Main2"]
		scrollFrame.BackgroundTransparency = 1
		scrollFrame.BorderSizePixel = 0
		scrollFrame.Position = UDim2.new(0, 0, 0, 24)
		scrollFrame.Size = UDim2.new(1, 0, 1, -24)
		scrollFrame.ScrollBarThickness = 6
		scrollFrame.ScrollBarImageColor3 = CONFIG["Theme"]["Button"]
		scrollFrame.VerticalScrollBarInset = Enum.ScrollBarInset.None
		scrollFrame.Parent = parentContent
		
		local toolBar = Instance.new("Frame")
		toolBar.Name = "ToolBar"
		toolBar.BackgroundColor3 = CONFIG["Theme"]["Main1"]
		toolBar.BorderSizePixel = 0
		toolBar.Size = UDim2.new(1, 0, 0, 22)
		toolBar.Parent = parentContent

		local searchFrame = Instance.new("Frame")
		searchFrame.Name = "SearchFrame"
		searchFrame.BackgroundColor3 = CONFIG["Theme"]["Main2"]
		searchFrame.BorderColor3 = CONFIG["Theme"]["Outline1"]
		searchFrame.BorderSizePixel = 0
		searchFrame.Position = UDim2.new(0, 3, 0, 1)
		searchFrame.Size = UDim2.new(1, -6, 0, 18)
		searchFrame.Parent = toolBar
		Instance.new("UICorner", searchFrame).CornerRadius = UDim.new(0, 2)

		local searchBox = Instance.new("TextBox")
		searchBox.Name = "SearchBox"
		searchBox.BackgroundTransparency = 1
		searchBox.Position = UDim2.new(0, 4, 0, 0)
		searchBox.Size = UDim2.new(1, -24, 0, 18)
		searchBox.Font = Enum.Font.SourceSans
		searchBox.PlaceholderText = "Search workspace"
		searchBox.PlaceholderColor3 = CONFIG["Theme"]["PlaceholderText"] or Color3.fromRGB(100, 100, 100)
		searchBox.Text = ""
		searchBox.TextColor3 = CONFIG["Theme"]["Text"]
		searchBox.TextSize = 14
		searchBox.TextXAlignment = Enum.TextXAlignment.Left
		searchBox.ClearTextOnFocus = false
		searchBox.Parent = searchFrame
		if Lib and Lib["ViewportTextBox"] then Lib["ViewportTextBox"]["convert"](searchBox) end

		local SearchText = ""
		local SearchResults = {}

		local FlattenedTree = {}
		local Expanded = {[game] = true, [workspace] = true}
		local Selected = nil
		local RowHeight = CONFIG["Settings"]["RowHeight"]
		local LastClickedInstance = nil
		local LastClickTime = 0
		
		local InternalLib = PropertiesModule.Lib
		
		local ICON_SPRITESHEET = "rbxassetid://6511490623"
		local function iconOffset(index)
			local col = index % 16
			local row = math.floor(index / 16)
			return Vector2.new(col * 16, row * 16)
		end
		local CTX_ICONS = {
			["Cut"]         = iconOffset(1),
			["Copy"]        = iconOffset(3),
			["Paste Into"]  = iconOffset(5),
			["Duplicate"]   = iconOffset(3),
			["Rename"]      = iconOffset(14),
			["Delete"]      = iconOffset(7),
			["Group"]       = iconOffset(9),
			["Ungroup"]     = iconOffset(11),
			["Copy Path"]   = iconOffset(0),
			["Teleport To"] = iconOffset(13),
		}

		local clipboard = {}
		
		local renamingInst = nil
		local renameBox = nil
		local renameBoxFrame = nil

		local draggingInst = nil
		local dragLabel = nil
		local dragGui = nil
		
		local function getPath(obj)
			local path = obj.Name
			local current = obj.Parent
			while current and current ~= game do
				path = current.Name .. "." .. path
				current = current.Parent
			end
			return "game." .. path
		end
		
		local ContextMenuGui = nil
		local ContextMenuClose = nil

		local function HideContextMenu(instant)
			if ContextMenuClose then
				ContextMenuClose:Disconnect()
				ContextMenuClose = nil
			end
			local guiToHide = ContextMenuGui
			ContextMenuGui = nil
			
			if guiToHide then
				if instant then
					guiToHide:Destroy()
				else
					local main = guiToHide:FindFirstChild("Main")
					if main then
						TweenService:Create(main, TweenInfo.new(0.12, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, main.AbsoluteSize.X, 0, 0)}):Play()
					end
					task.delay(0.12, function()
						guiToHide:Destroy()
					end)
				end
			end
		end

		local function ShowContextMenu(items, mouseX, mouseY)
			HideContextMenu(true)
			
			local sg = TrackInstance(Instance.new("ScreenGui"))
			sg.Name = "OnionContextMenu"
			sg.DisplayOrder = 100001
			sg.ResetOnSpawn = false
			ContextMenuGui = sg

			local ITEM_H = 22
			local DIVIDER_H = 7
			local MENU_W = 170
			local PAD = 2

			local totalH = PAD * 2
			for _, item in ipairs(items) do
				if item.Divider then totalH = totalH + DIVIDER_H
				else totalH = totalH + ITEM_H end
			end

			local plr = game:GetService("Players").LocalPlayer
			local mouse = plr:GetMouse()
			local vpX = mouse.ViewSizeX
			local vpY = mouse.ViewSizeY
			local posX = math.min(mouseX, vpX - MENU_W - 4)
			local posY = math.min(mouseY, vpY - totalH - 4)

			local outline = Instance.new("Frame", sg)
			outline.Name = "Main"
			outline.Position = UDim2.new(0, posX, 0, posY)
			outline.Size = UDim2.new(0, MENU_W, 0, 0)
			outline.BackgroundColor3 = CONFIG["Theme"]["Outline1"]
			outline.BorderSizePixel = 0
			outline.ClipsDescendants = true
			Instance.new("UICorner", outline).CornerRadius = UDim.new(0, 4)

			local inner = Instance.new("Frame", outline)
			inner.Position = UDim2.new(0, 1, 0, 1)
			inner.Size = UDim2.new(1, -2, 1, -2)
			inner.BackgroundColor3 = CONFIG["Theme"]["Menu"]
			inner.BorderSizePixel = 0
			Instance.new("UICorner", inner).CornerRadius = UDim.new(0, 4)

			local layout = Instance.new("UIListLayout", inner)
			layout.Padding = UDim.new(0, 0)
			layout.SortOrder = Enum.SortOrder.LayoutOrder
			
			local pad = Instance.new("UIPadding", inner)
			pad.PaddingTop = UDim.new(0, PAD)
			pad.PaddingBottom = UDim.new(0, PAD)

			for idx, item in ipairs(items) do
				if item.Divider then
					local div = Instance.new("Frame", inner)
					div.Size = UDim2.new(1, 0, 0, DIVIDER_H)
					div.BackgroundTransparency = 1
					div.BorderSizePixel = 0
					div.LayoutOrder = idx
					local line = Instance.new("Frame", div)
					line.AnchorPoint = Vector2.new(0, 0.5)
					line.Position = UDim2.new(0, 4, 0.5, 0)
					line.Size = UDim2.new(1, -8, 0, 1)
					line.BackgroundColor3 = CONFIG["Theme"]["Outline2"]
					line.BorderSizePixel = 0
				else
					local btn = Instance.new("TextButton", inner)
					btn.Size = UDim2.new(1, 0, 0, ITEM_H)
					btn.BackgroundColor3 = CONFIG["Theme"]["Highlight"]
					btn.BackgroundTransparency = 1
					btn.BorderSizePixel = 0
					btn.Text = ""
					btn.LayoutOrder = idx
					Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3)

					local iconLbl = Instance.new("ImageLabel", btn)
					iconLbl.Size = UDim2.new(0, 16, 0, 16)
					iconLbl.Position = UDim2.new(0, 2, 0, 3)
					iconLbl.ScaleType = Enum.ScaleType.Crop
					iconLbl.BackgroundTransparency = 1
					iconLbl.BorderSizePixel = 0
					iconLbl.Image = ICON_SPRITESHEET
					iconLbl.ImageRectSize = Vector2.new(16, 16)
					local iconOff = CTX_ICONS[item.Name]
					if iconOff then
						iconLbl.ImageRectOffset = iconOff
						iconLbl.ImageTransparency = item.Disabled and 0.6 or 0
					else
						iconLbl.ImageTransparency = 1
					end

					local lbl = Instance.new("TextLabel", btn)
					lbl.Size = UDim2.new(1, -24, 1, 0)
					lbl.Position = UDim2.new(0, 24, 0, 0)
					lbl.BackgroundTransparency = 1
					lbl.Text = item.Name
					lbl.TextColor3 = item.Disabled and CONFIG["Theme"]["PlaceholderText"] or CONFIG["Theme"]["Text"]
					lbl.Font = Enum.Font.SourceSans
					lbl.TextSize = 14
					lbl.TextXAlignment = Enum.TextXAlignment.Left
					lbl.BorderSizePixel = 0

					if not item.Disabled then
						TrackConnection(btn.MouseEnter:Connect(function()
							btn.BackgroundTransparency = 0
						end))
						TrackConnection(btn.MouseLeave:Connect(function()
							btn.BackgroundTransparency = 1
						end))
						if item.OnClick then
							TrackConnection(btn.MouseButton1Click:Connect(function()
								HideContextMenu()
								item.OnClick()
							end))
						end
					end
				end
			end

			sg.Parent = GuiParent
			TweenService:Create(outline, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, MENU_W, 0, totalH)}):Play()

			local closable = false
			ContextMenuClose = TrackConnection(UIS.InputBegan:Connect(function(input)
				if not closable then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local mx, my = input.Position.X, input.Position.Y
					local ap = outline.AbsolutePosition
					local as = outline.AbsoluteSize
					if mx < ap.X or mx > ap.X + as.X or my < ap.Y or my > ap.Y + totalH then
						HideContextMenu()
					end
				end
			end))
			
			task.spawn(function()
				task.wait()
				closable = true
			end)
		end

		local function ShowRightClickMenu()
			if not Selected then return end
			local items = {}

			table.insert(items, {Name = "Cut", OnClick = function()
				local s, cloned = pcall(game.Clone, Selected)
				if s and cloned then clipboard = {cloned} end
				pcall(game.Destroy, Selected)
				Selected = nil; SelResult = nil
				SelectionEvent:Fire(nil)
				RefreshTree(); UpdateScrollSize(); Render()
			end})
			table.insert(items, {Name = "Copy", OnClick = function()
				local s, cloned = pcall(game.Clone, Selected)
				if s and cloned then clipboard = {cloned} end
			end})

			local hasClip = clipboard and clipboard[1] ~= nil
			table.insert(items, {Name = "Paste Into", Disabled = not hasClip, OnClick = not hasClip and nil or function()
				if Selected and clipboard[1] then
					for _, inst in ipairs(clipboard) do
						local s, cloned = pcall(game.Clone, inst)
						if s and cloned then cloned.Parent = Selected end
					end
					Expanded[Selected] = true
					RefreshTree(); UpdateScrollSize(); Render()
				end
			end})

			table.insert(items, {Name = "Duplicate", OnClick = function()
				local s, cloned = pcall(game.Clone, Selected)
				if s and cloned then
					cloned.Parent = Selected.Parent
					RefreshTree(); UpdateScrollSize(); Render()
				end
			end})

			table.insert(items, {Name = "Rename", OnClick = function()
				if renameBox then
					renamingInst = Selected
					renameBox.Text = tostring(Selected)
					renameBox:CaptureFocus()
					Render()
				end
			end})

			table.insert(items, {Name = "Delete", OnClick = function()
				pcall(game.Destroy, Selected)
				Selected = nil
				SelectionEvent:Fire(nil)
				RefreshTree(); UpdateScrollSize(); Render()
			end})

			table.insert(items, {Divider = true})

			table.insert(items, {Name = "Group", OnClick = function()
				if Selected and Selected.Parent then
					local model = Instance.new("Model", Selected.Parent)
					pcall(function() Selected.Parent = model end)
					Selected = model; SelectionEvent:Fire(model)
					RefreshTree(); UpdateScrollSize(); Render()
				end
			end})

			if Selected:IsA("Model") then
				table.insert(items, {Name = "Ungroup", OnClick = function()
					local par = Selected.Parent
					for _, ch in ipairs(Selected:GetChildren()) do
						pcall(function() ch.Parent = par end)
					end
					pcall(game.Destroy, Selected)
					Selected = nil; SelectionEvent:Fire(nil)
					RefreshTree(); UpdateScrollSize(); Render()
				end})
			end

			table.insert(items, {Divider = true})

			if Selected:IsA("LuaSourceContainer") then
				table.insert(items, {Name = "View Script", OnClick = function()
					if OpenScriptViewer then OpenScriptViewer(Selected) end
				end})
			end
			if setclipboard then
				table.insert(items, {Name = "Copy Path", OnClick = function()
					setclipboard(getPath(Selected))
				end})
			end

			if Selected:IsA("BasePart") or Selected:IsA("Model") then
				table.insert(items, {Name = "Teleport To", OnClick = function()
					local plr2 = game:GetService("Players").LocalPlayer
					local hrp = plr2 and plr2.Character and plr2.Character:FindFirstChild("HumanoidRootPart")
					if hrp then
						if Selected:IsA("BasePart") then
							hrp.CFrame = Selected.CFrame
						else
							local pp = Selected.PrimaryPart or Selected:FindFirstChildWhichIsA("BasePart", true)
							if pp then hrp.CFrame = pp.CFrame end
						end
					end
				end})
			end

			local mouse = game:GetService("Players").LocalPlayer:GetMouse()
			ShowContextMenu(items, mouse.X, mouse.Y)
		end

		local function SortNodes(a, b)
			local pA = ExplorerOrders[a.ClassName] or 9999
			local pB = ExplorerOrders[b.ClassName] or 9999
			if pA == pB then
				return a.Name:lower() < b.Name:lower()
			end
			return pA < pB
		end
		
		local function BuildTree(node, depth)
			if SearchText ~= "" and not SearchResults[node] then return end
			table.insert(FlattenedTree, {["Instance"] = node, ["Depth"] = depth})
			
			local shouldExpand = Expanded[node]
			if SearchText ~= "" and SearchResults[node] then shouldExpand = true end

			if shouldExpand then
				local children = {}
				pcall(function() children = node:GetChildren() end)
				table.sort(children, SortNodes)
				for _, child in ipairs(children) do
					BuildTree(child, depth + 1)
				end
			end
		end
		
		local function UpdateSearch()
			SearchResults = {}
			if SearchText == "" then return end
			local q = SearchText:lower()
			local children = {}
			pcall(function() children = game:GetChildren() end)
			local count = 0
			local bufferWrite = 32
			for _, child in ipairs(children) do
				pcall(function()
					if string.find(child.Name:lower(), q, 1, true) then
						SearchResults[child] = true
					end
					local descendants = child:GetDescendants()
					for i = 1, #descendants do
						local desc = descendants[i]
						if string.find(desc.Name:lower(), q, 1, true) then
							SearchResults[desc] = true
							local p = desc.Parent
							while p and p ~= game and not SearchResults[p] do
								SearchResults[p] = true
								p = p.Parent
							end
						end
						count = count + 1
						if count > (bufferWrite * 100) then
							count = 0
							task.wait()
							if SearchText:lower() ~= q then return end
						end
					end
				end)
			end
		end

		local function RefreshTree()
			FlattenedTree = {}
			UpdateSearch()
			local children = {}
			pcall(function() children = game:GetChildren() end)
			table.sort(children, SortNodes)
			for _, child in ipairs(children) do
				BuildTree(child, 0)
			end
		end
		
		local function UpdateScrollSize()
			scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #FlattenedTree * RowHeight)
		end
		
		local Frames = {}
		local FrameLinks = {}
		local MaxVisibleFrames = CONFIG["Settings"]["MaxVisibleFrames"]
		local HoveredFrame = nil
		local ArrowHoverStates = {}
		local Render
		
		for i = 1, MaxVisibleFrames do
			local frame = Instance.new("TextButton")
			frame.Name = "Row" .. i
			frame.Size = UDim2.new(1, 0, 0, RowHeight)
			frame.AutoButtonColor = false
			frame.BackgroundTransparency = 1
			frame.BackgroundColor3 = CONFIG["Theme"]["Button"]
			frame.BorderSizePixel = 0
			frame.Text = ""
			frame.Visible = false
			frame.Parent = scrollFrame
			local indent = Instance.new("Frame")
			indent.Name = "Indent"
			indent.BackgroundTransparency = 1
			indent.Size = UDim2.new(1, 0, 1, 0)
			indent.Parent = frame
			local arrow = Instance.new("ImageButton")
			arrow.Name = "Arrow"
			arrow.Size = UDim2.new(0, 16, 0, 16)
			arrow.Position = UDim2.new(0, -18, 0, 2)
			arrow.BackgroundTransparency = 1
			arrow.Image = CONFIG["AssetIds"]["ExplorerArrow"]
			arrow.ImageRectOffset = Vector2.new(144, 16)
			arrow.ImageRectSize = Vector2.new(16, 16)
			arrow.Parent = indent
			TrackConnection(arrow.MouseEnter:Connect(function() 
				ArrowHoverStates[frame] = true 
				Render() 
			end))
			TrackConnection(arrow.MouseLeave:Connect(function() 
				ArrowHoverStates[frame] = false 
				Render() 
			end))
			local icon = Instance.new("ImageLabel")
			icon.Name = "Icon"
			icon.Size = UDim2.new(0, 16, 0, 16)
			icon.Position = UDim2.new(0, 4, 0, 2)
			icon.BackgroundTransparency = 1
			icon.Image = CONFIG["AssetIds"]["ExplorerIconDefault"]
			icon.Parent = indent
			local nameLabel = Instance.new("TextLabel")
			nameLabel.Name = "NameLabel"
			nameLabel.Size = UDim2.new(1, -26, 1, 0)
			nameLabel.Position = UDim2.new(0, 26, 0, 0)
			nameLabel.BackgroundTransparency = 1
			nameLabel.TextXAlignment = Enum.TextXAlignment.Left
			nameLabel.TextColor3 = CONFIG["Theme"]["Text"]
			nameLabel.Font = Enum.Font.SourceSans
			nameLabel.TextSize = 14
			nameLabel.Parent = indent
			TrackConnection(frame.MouseEnter:Connect(function()
				HoveredFrame = frame
				Render()
			end))
			TrackConnection(frame.MouseLeave:Connect(function()
				if HoveredFrame == frame then
					HoveredFrame = nil
					Render()
				end
			end))
			TrackConnection(frame.MouseButton1Click:Connect(function()
				local linked = FrameLinks[frame]
				if linked then
					if PropertiesModule and PropertiesModule.SelectObject and PropertiesModule.SelectObject(linked) then
						return
					end
					if LastClickedInstance == linked and (tick() - LastClickTime) < 0.3 then
						if linked.ClassName == "LocalScript" or linked.ClassName == "ModuleScript" then
							OpenScriptViewer(linked)
						else
							if renameBox then
								renamingInst = linked
								renameBox.Text = tostring(linked)
								renameBox:CaptureFocus()
								Render()
							end
						end
					end
					LastClickedInstance = linked
					LastClickTime = tick()
					Selected = linked
					SelectionEvent:Fire(linked)
					Render()
				end
			end))
			local dragDownTime = 0
			local dragStarted = false
			TrackConnection(frame.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragDownTime = tick()
					dragStarted = false
					local linkedInst = FrameLinks[frame]
					if not linkedInst then return end
					task.spawn(function()
						task.wait(0.25)
						if not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then return end
						if FrameLinks[frame] ~= linkedInst then return end
						dragStarted = true
						draggingInst = linkedInst
						dragLabel.Text = "  " .. tostring(linkedInst)
						dragLabel.Visible = true
						dragGui.Parent = GuiParent
						
						local dragConnection
						local RunService = game:GetService("RunService")
						
						dragConnection = RunService.RenderStepped:Connect(function()
							if not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
								dragConnection:Disconnect()
								dragLabel.Visible = false
								dragGui.Parent = nil
								local mouse = game:GetService("Players").LocalPlayer:GetMouse()
								local dropTarget = nil
								for _, rowData in ipairs(Frames) do
									local f = rowData["Frame"]
									if f.Visible then
										local ap = f.AbsolutePosition
										local as = f.AbsoluteSize
										if mouse.Y >= ap.Y and mouse.Y < ap.Y + as.Y then
											dropTarget = FrameLinks[f]
											break
										end
									end
								end
								if dropTarget and dropTarget ~= draggingInst and dropTarget ~= draggingInst.Parent then
									pcall(function() draggingInst.Parent = dropTarget end)
									Expanded[dropTarget] = true
								end
								draggingInst = nil
								RefreshTree(); UpdateScrollSize()
								Render()
								return
							end
							
							local mouse = game:GetService("Players").LocalPlayer:GetMouse()
							dragLabel.Position = UDim2.new(0, mouse.X + 12, 0, mouse.Y - 10)
							
							for _, rowData in ipairs(Frames) do
								local f = rowData["Frame"]
								if f.Visible then
									local ap = f.AbsolutePosition
									local as = f.AbsoluteSize
									if mouse.Y >= ap.Y and mouse.Y < ap.Y + as.Y then
										f.BackgroundColor3 = CONFIG["Theme"]["Highlight"]
										f.BackgroundTransparency = 0.5
									else
										f.BackgroundColor3 = CONFIG["Theme"]["ListSelection"]
										f.BackgroundTransparency = (FrameLinks[f] == Selected) and 0.5 or 1
									end
								end
							end
						end)
					end)
				end
			end))
			TrackConnection(frame.MouseButton2Click:Connect(function()
				local linked = FrameLinks[frame]
				if linked then
					Selected = linked
					SelectionEvent:Fire(linked)
					Render()
					ShowRightClickMenu()
				end
			end))
			TrackConnection(arrow.MouseButton1Click:Connect(function()
				local linked = FrameLinks[frame]
				if linked then
					Expanded[linked] = not Expanded[linked]
					RefreshTree()
					scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #FlattenedTree * RowHeight)
					Render()
				end
			end))
			table.insert(Frames, {
				["Frame"] = frame,
				["Indent"] = indent,
				["Arrow"] = arrow,
				["Icon"] = icon,
				["NameLabel"] = nameLabel
			})
		end
		
		do
			renameBox = Instance.new("TextBox")
			renameBox.Name = "RenameBox"
			renameBox.Size = UDim2.new(0, 160, 0, 16)
			renameBox.BackgroundColor3 = CONFIG["Theme"]["TextBox"]
			renameBox.BorderColor3 = Color3.fromRGB(10, 130, 255)
			renameBox.BorderMode = Enum.BorderMode.Inset
			renameBox.BorderSizePixel = 1
			renameBox.ClearTextOnFocus = false
			renameBox.Font = Enum.Font.SourceSans
			renameBox.TextSize = 14
			renameBox.TextColor3 = CONFIG["Theme"]["Text"]
			renameBox.TextXAlignment = Enum.TextXAlignment.Left
			renameBox.Visible = false
			renameBox.ZIndex = 5
			renameBox.Parent = scrollFrame
			TrackConnection(renameBox.FocusLost:Connect(function()
				if not renamingInst then return end
				pcall(function() renamingInst.Name = renameBox.Text end)
				renamingInst = nil
				renameBox.Visible = false
				RefreshTree()
				Render()
			end))
			TrackConnection(renameBox.Focused:Connect(function()
				renameBox.SelectionStart = 1
				renameBox.CursorPosition = #renameBox.Text + 1
			end))
		end

		do
			local dsg = TrackInstance(Instance.new("ScreenGui"))
			dsg.Name = "OnionDragGhost"
			dsg.DisplayOrder = 99999
			dsg.ResetOnSpawn = false
			dragGui = dsg
			dragLabel = Instance.new("TextLabel", dsg)
			dragLabel.Size = UDim2.new(0, 180, 0, 20)
			dragLabel.BackgroundColor3 = CONFIG["Theme"]["ListSelection"]
			dragLabel.BackgroundTransparency = 0.4
			dragLabel.BorderSizePixel = 0
			dragLabel.TextColor3 = CONFIG["Theme"]["Text"]
			dragLabel.Font = Enum.Font.SourceSans
			dragLabel.TextSize = 13
			dragLabel.TextXAlignment = Enum.TextXAlignment.Left
			dragLabel.Text = ""
			dragLabel.Visible = false
			Instance.new("UIPadding", dragLabel).PaddingLeft = UDim.new(0, 6)
			dragGui.Parent = nil
		end

		Render = function()
			local scrollY = scrollFrame.CanvasPosition.Y
			local startIndex = math.max(1, math.floor(scrollY / RowHeight) + 1)
			for i, rowData in ipairs(Frames) do
				local frame = rowData["Frame"]
				local indent = rowData["Indent"]
				local arrow = rowData["Arrow"]
				local icon = rowData["Icon"]
				local nameLabel = rowData["NameLabel"]
				local dataIndex = startIndex + i - 1
				local data = FlattenedTree[dataIndex]
				
				if data then
					local inst = data["Instance"]
					local depth = data["Depth"]
					FrameLinks[frame] = inst
					frame.Visible = true
					frame.Position = UDim2.new(0, 0, 0, (dataIndex - 1) * RowHeight)
					local indentOffX = 20 * depth + 28
					indent.Position = UDim2.new(0, indentOffX, 0, 0)
					indent.Size = UDim2.new(1, -indentOffX, 1, 0)
					nameLabel.Text = tostring(inst)
					
					if renamingInst == inst and renameBox then
						renameBox.Position = UDim2.new(0, indentOffX + 24, 0, (dataIndex - 1) * RowHeight + 2)
						renameBox.Visible = true
						renameBox.Size = UDim2.new(1, -(indentOffX + 26), 0, RowHeight - 4)
					end

					icon:SetAttribute("CurrentClass", inst.ClassName)
					local theme = CONFIG["Settings"]["IconTheme"]

					if theme == "CustomDark" or theme == "CustomLight" then
						local folderTheme = theme == "CustomDark" and "dark" or "light"
						local cached = CustomIconCache[inst.ClassName]

						if cached then
							if cached == "NONE" then
								icon.Image = ""
								icon.ImageTransparency = 1
							else
								icon.Image = cached
								icon.ImageRectOffset = Vector2.new(0, 0)
								icon.ImageRectSize = Vector2.new(0, 0)
								icon.ImageTransparency = 0
							end
						else
							icon.Image = ""
							icon.ImageTransparency = 1
							if not CurrentlyFetching[inst.ClassName] then
								CurrentlyFetching[inst.ClassName] = true
								task.spawn(function()
									local asset = GetCustomIconAsset(inst.ClassName, folderTheme)
									CurrentlyFetching[inst.ClassName] = nil

									if icon:GetAttribute("CurrentClass") == inst.ClassName then
										if asset == "NONE" then
											icon.Image = ""
											icon.ImageTransparency = 1
										else
											icon.Image = asset
											icon.ImageRectOffset = Vector2.new(0, 0)
											icon.ImageRectSize = Vector2.new(0, 0)
											icon.ImageTransparency = 0
										end
									end
								end)
							end
						end
					elseif (theme == "Default" or theme == "Default2") and DefaultIconsLoaded then
						local info = DefaultIcons[inst.ClassName] or DefaultIcons["File"] or {x = 0, y = 0}
						icon.Image = "rbxassetid://15288945291"
						icon.ImageRectOffset = Vector2.new(info.x, info.y)
						icon.ImageRectSize = Vector2.new(16, 16)
						icon.ImageTransparency = 0
					elseif theme == "Vanilla" and VanillaIconsLoaded then
						local iconId = VanillaIcons[inst.ClassName] or VanillaIcons["Instance"] or CONFIG["AssetIds"]["ExplorerIconDefault"]
						icon.Image = iconId
						icon.ImageRectOffset = Vector2.new(0, 0)
						icon.ImageRectSize = Vector2.new(0, 0)
						icon.ImageTransparency = 0
					else
						local offset, size = GetIconRect(inst.ClassName)
						icon.Image = CONFIG["AssetIds"]["ExplorerIconFallback"]
						icon.ImageRectOffset = offset
						icon.ImageRectSize = size
						icon.ImageTransparency = 0
					end

					local hasChildren = false
					pcall(function() hasChildren = #inst:GetChildren() > 0 end)
					if hasChildren then
						arrow.Visible = true
						local isExpanded = Expanded[inst]
						local isHovering = ArrowHoverStates[frame]
						if isExpanded then
							arrow.ImageRectOffset = isHovering and Vector2.new(160, 16) or Vector2.new(176, 16)
						else
							arrow.ImageRectOffset = isHovering and Vector2.new(128, 16) or Vector2.new(144, 16)
						end
					else
						arrow.Visible = false
					end
					
					if Selected == inst then
						frame.BackgroundColor3 = CONFIG["Theme"]["ListSelection"]
						frame.BackgroundTransparency = 0.5
					else
						if HoveredFrame == frame then
							frame.BackgroundColor3 = CONFIG["Theme"]["ButtonHover"]
							frame.BackgroundTransparency = 0
						else
							frame.BackgroundTransparency = 1
						end
					end
				else
					frame.Visible = false
				end
			end
		end
		
		RefreshTree()
		UpdateScrollSize()
		Render()
		
		TrackConnection(scrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(Render))
		
		local updatePending = false
		local function QueueUpdate()
			if updatePending then return end
			updatePending = true
			task.delay(CONFIG["Settings"]["ExplorerUpdateDelay"], function()
				updatePending = false
				RefreshTree()
				UpdateScrollSize()
				Render()
			end)
		end
		
		TrackConnection(game.DescendantAdded:Connect(function(descendant)
			QueueUpdate()
		end))
		TrackConnection(game.DescendantRemoving:Connect(function(descendant)
			if Selected == descendant then
				Selected = nil
				SelectionEvent:Fire(nil)
			end
			QueueUpdate()
		end))
		TrackConnection(Players.PlayerAdded:Connect(function()
			QueueUpdate()
		end))
		TrackConnection(Players.PlayerRemoving:Connect(function(player)
			if Selected == player then
				Selected = nil
				SelectionEvent:Fire(nil)
			end
			QueueUpdate()
		end))
		
		if searchBox then
			local searchDebounce = 0
			TrackConnection(searchBox:GetPropertyChangedSignal("Text"):Connect(function()
				SearchText = searchBox.Text
				searchDebounce = searchDebounce + 1
				local currentDebounce = searchDebounce
				task.delay(0.15, function()
					if currentDebounce == searchDebounce then
						RefreshTree()
						UpdateScrollSize()
						Render()
					end
				end)
			end))
		end

		_G.OnionExplorerRefresh = function()
			RefreshTree()
			UpdateScrollSize()
			Render()
		end
	end

	local AppMenuRef = dockGui:FindFirstChild("AppMenu")
	if AppMenuRef then
		local lockedBtn = Instance.new("Frame")
		lockedBtn.Size = UDim2.new(0, 140, 0, 110)
		lockedBtn.BackgroundColor3 = CONFIG["Theme"]["AppListCard"]
		lockedBtn.BackgroundTransparency = 0.5
		lockedBtn.Parent = AppMenuRef:FindFirstChild("AppList")
		lockedBtn.LayoutOrder = 999
		Instance.new("UICorner", lockedBtn).CornerRadius = UDim.new(0, 8)

		local btnStroke = Instance.new("UIStroke", lockedBtn)
		btnStroke.Color = CONFIG["Theme"]["Button"]
		btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		btnStroke.Transparency = 0.2

		local lockIcon = Instance.new("ImageLabel", lockedBtn)
		lockIcon.BackgroundTransparency = 1
		lockIcon.Image = CONFIG["AssetIds"]["LockIcon"]
		lockIcon.Size = UDim2.new(0, 20, 0, 20)
		lockIcon.Position = UDim2.new(0.5, -10, 0.5, -25)
		lockIcon.ImageColor3 = CONFIG["Theme"]["LockedIcon"]

		local lockText = Instance.new("TextLabel", lockedBtn)
		lockText.BackgroundTransparency = 1
		lockText.Size = UDim2.new(1, -20, 0, 30)
		lockText.Position = UDim2.new(0, 10, 0.5, 5)
		lockText.Text = CONFIG["Strings"]["LockedSpace"]
		lockText.TextColor3 = CONFIG["Theme"]["LockedIcon"]
		lockText.Font = Enum.Font.Gotham
		lockText.TextSize = 12
		lockText.TextWrapped = true
	end
	
	if _G.UpdateMenuCounts then _G.UpdateMenuCounts() end

	task.spawn(function()
		pcall(function()
			local xml = game:HttpGet(CONFIG["Urls"]["ReflectionMetadata"])
			for propsBlock in xml:gmatch("<Item class=\"ReflectionMetadataClass\">%s*<Properties>(.-)</Properties>") do
				local name = propsBlock:match("<string name=\"Name\">(.-)</string>")
				local order = propsBlock:match("<string name=\"ExplorerOrder\">(.-)</string>")
				if name and order then
					ExplorerOrders[name] = tonumber(order)
				end
			end
		end)
		if _G.OnionExplorerRefresh then _G.OnionExplorerRefresh() end
	end)

	if not CONFIG["Settings"]["Baseline"] then
		CONFIG["Settings"]["Baseline"] = {
			SmoothBlinker = true,
			TextSize = 16,
			Font = "RobotoMono",
			Minimap = true,
			Lines = true,
			Wrapped = false
		}
	end

	local function updateAllBaselines(key, value)
		CONFIG["Settings"]["Baseline"][key] = value
		if ScriptViewerData and ScriptViewerData.OpenedScripts then
			for _, scriptData in ipairs(ScriptViewerData.OpenedScripts) do
				if scriptData.BaseLineEditor then
					if key == "Font" then
						pcall(function() scriptData.BaseLineEditor.Font = Enum.Font[value] end)
					else
						pcall(function() scriptData.BaseLineEditor[key] = value end)
					end
				end
			end
		end
	end

	if not CONFIG["Settings"]["Baseline"] then
		CONFIG["Settings"]["Baseline"] = {
			SmoothBlinker = true,
			TextSize = 16,
			Font = "RobotoMono",
			Minimap = true,
			Lines = true,
			Wrapped = false
		}
	end

	local function updateAllBaselines(key, value)
		CONFIG["Settings"]["Baseline"][key] = value
		if ScriptViewerData and ScriptViewerData.OpenedScripts then
			for _, scriptData in ipairs(ScriptViewerData.OpenedScripts) do
				if scriptData.BaseLineEditor then
					if key == "Font" then
						pcall(function() scriptData.BaseLineEditor.Font = Enum.Font[value] end)
					else
						pcall(function() scriptData.BaseLineEditor[key] = value end)
					end
				end
			end
		end
	end

	if not CONFIG["Settings"]["Baseline"] then
		CONFIG["Settings"]["Baseline"] = {
			SmoothBlinker = true,
			TextSize = 16,
			Font = "rbxasset://fonts/families/RobotoMono.json",
			Minimap = true,
			Lines = true,
			Wrapped = false
		}
	end

	local function updateAllBaselines(key, value)
		CONFIG["Settings"]["Baseline"][key] = value
		if ScriptViewerData and ScriptViewerData.OpenedScripts then
			for _, scriptData in ipairs(ScriptViewerData.OpenedScripts) do
				if scriptData.BaseLineEditor then
					if key == "Font" then
						pcall(function() scriptData.BaseLineEditor.Font = Font.new(value) end)
					else
						pcall(function() scriptData.BaseLineEditor[key] = value end)
					end
				end
			end
		end
	end

	if not CONFIG["Settings"]["Baseline"] then
		CONFIG["Settings"]["Baseline"] = {
			SmoothBlinker = true,
			TextSize = 16,
			Font = "rbxasset://fonts/families/RobotoMono.json",
			Minimap = true,
			Lines = true,
			Wrapped = false
		}
	end

	local function updateAllBaselines(key, value)
		CONFIG["Settings"]["Baseline"][key] = value
		if ScriptViewerData and ScriptViewerData.OpenedScripts then
			for _, scriptData in ipairs(ScriptViewerData.OpenedScripts) do
				if scriptData.BaseLineEditor then
					if key == "Font" then
						pcall(function() scriptData.BaseLineEditor.Font = Font.new(value) end)
					else
						pcall(function() scriptData.BaseLineEditor[key] = value end)
					end
				end
			end
		end
	end

	local InitialTheme = {}
	for k, v in pairs(CONFIG["Theme"]) do
		InitialTheme[k] = v
	end

	local UpdateSettingsVisuals = {}

	if not CONFIG["Settings"]["Baseline"] then
		CONFIG["Settings"]["Baseline"] = {
			SmoothBlinker = true,
			TextSize = 16,
			Font = "rbxasset://fonts/families/RobotoMono.json",
			Minimap = true,
			Lines = true,
			Wrapped = false
		}
	end

	local function updateAllBaselines(key, value)
		CONFIG["Settings"]["Baseline"][key] = value
		if ScriptViewerData and ScriptViewerData.OpenedScripts then
			for _, scriptData in ipairs(ScriptViewerData.OpenedScripts) do
				if scriptData.BaseLineEditor then
					if key == "Font" then
						pcall(function() scriptData.BaseLineEditor.Font = Font.new(value) end)
					else
						pcall(function() scriptData.BaseLineEditor[key] = value end)
					end
				end
			end
		end
	end

	local InitialTheme = {}
	for k, v in pairs(CONFIG["Theme"]) do
		InitialTheme[k] = v
	end

	local UpdateSettingsVisuals = {}

	local settingsWin, settingsContent, settingsToggle = CreateDexWindow("Settings", "rbxassetid://9405931596", "None", {ShowInMenu = true, InitialSize = UDim2.new(0, 300, 0, 400)})
	settingsMenuBtn.MouseButton1Click:Connect(function()
		settingsToggle(true)
	end)

	local settingsScroll = Instance.new("ScrollingFrame", settingsContent)
	settingsScroll.Size = UDim2.new(1, 0, 1, 0)
	settingsScroll.BackgroundTransparency = 1
	settingsScroll.ScrollBarThickness = 0
	settingsScroll.ScrollBarImageTransparency = 1
	settingsScroll.BorderSizePixel = 0
	settingsScroll.Active = true
	local settingsLayout = Instance.new("UIListLayout", settingsScroll)
	settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local currentDropdownCtx = nil
	settingsScroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
		if currentDropdownCtx then
			currentDropdownCtx:Hide()
			currentDropdownCtx = nil
		end
	end)

	local function applyThemeUpdate(oldT)
		local function cMatch(c1, c2)
			if type(c1) ~= "userdata" or type(c2) ~= "userdata" then return false end
			return math.abs(c1.R - c2.R) < 0.01 and math.abs(c1.G - c2.G) < 0.01 and math.abs(c1.B - c2.B) < 0.01
		end
		local guiParent = game:GetService("CoreGui")
		if not guiParent:FindFirstChild("OnionDock") then
			guiParent = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
		end
		if guiParent then
			for _, g in ipairs(guiParent:GetChildren()) do
				if string.sub(g.Name, 1, 5) == "Onion" then
					for _, obj in ipairs(g:GetDescendants()) do
						pcall(function()
							if obj:IsA("GuiObject") then
								for k, oldCol in pairs(oldT) do
									if cMatch(obj.BackgroundColor3, oldCol) then
										obj.BackgroundColor3 = CONFIG["Theme"][k]
										break
									end
								end
								for k, oldCol in pairs(oldT) do
									if cMatch(obj.BorderColor3, oldCol) then
										obj.BorderColor3 = CONFIG["Theme"][k]
										break
									end
								end
							end
							if obj:IsA("UIStroke") then
								for k, oldCol in pairs(oldT) do
									if cMatch(obj.Color, oldCol) then
										obj.Color = CONFIG["Theme"][k]
										break
									end
								end
							end
							if obj:IsA("TextLabel") or obj:IsA("TextBox") or obj:IsA("TextButton") then
								for k, oldCol in pairs(oldT) do
									if cMatch(obj.TextColor3, oldCol) then
										obj.TextColor3 = CONFIG["Theme"][k]
										break
									end
								end
							end
							if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
								if cMatch(obj.ImageColor3, oldT["Text"]) then
									obj.ImageColor3 = CONFIG["Theme"]["Text"]
								elseif cMatch(obj.ImageColor3, oldT["PlaceholderText"]) then
									obj.ImageColor3 = CONFIG["Theme"]["PlaceholderText"]
								end
							end
						end)
					end
				end
			end
		end

		if ScriptViewerData and ScriptViewerData.OpenedScripts then
			for _, scriptData in ipairs(ScriptViewerData.OpenedScripts) do
				if scriptData.EditorGroup then
					pcall(function() scriptData.EditorGroup.BackgroundColor3 = CONFIG["Theme"]["Main1"] end)
				end
				if scriptData.BaseLineEditor then
					pcall(function() scriptData.BaseLineEditor.BackgroundColor3 = CONFIG["Theme"]["Main1"] end)
				end
			end
		end

		if _G.OnionPropertiesRefresh then _G.OnionPropertiesRefresh() end
		if _G.OnionExplorerRefresh then _G.OnionExplorerRefresh() end
	end

	local function createCategory(name, order)
		local cat = Instance.new("TextLabel", settingsScroll)
		cat.Size = UDim2.new(1, 0, 0, 22)
		cat.BackgroundColor3 = CONFIG["Theme"]["Main1"]
		cat.TextColor3 = CONFIG["Theme"]["Text"]
		cat.Text = "  " .. name
		cat.Font = Enum.Font.SourceSansBold
		cat.TextSize = 14
		cat.TextXAlignment = Enum.TextXAlignment.Left
		cat.BorderSizePixel = 0
		cat.LayoutOrder = order
		return cat
	end

	local function createColorSetting(name, order, defaultColor, callback)
		local row = Instance.new("Frame", settingsScroll)
		row.Size = UDim2.new(1, 0, 0, 24)
		row.BackgroundColor3 = CONFIG["Theme"]["Main2"]
		row.BorderSizePixel = 0
		row.LayoutOrder = order
		
		local lbl = Instance.new("TextLabel", row)
		lbl.Size = UDim2.new(0.5, -10, 1, 0)
		lbl.Position = UDim2.new(0, 16, 0, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text = name
		lbl.TextColor3 = CONFIG["Theme"]["Text"]
		lbl.Font = Enum.Font.SourceSans
		lbl.TextSize = 14
		lbl.TextXAlignment = Enum.TextXAlignment.Left

		local colorBtn = Instance.new("TextButton", row)
		colorBtn.Size = UDim2.new(0.5, -8, 1, -4)
		colorBtn.Position = UDim2.new(0.5, 4, 0, 2)
		colorBtn.BackgroundColor3 = CONFIG["Theme"]["TextBox"]
		colorBtn.BorderSizePixel = 0
		colorBtn.Text = ""
		Instance.new("UICorner", colorBtn).CornerRadius = UDim.new(0, 4)

		local preview = Instance.new("Frame", colorBtn)
		preview.Size = UDim2.new(0, 12, 0, 12)
		preview.Position = UDim2.new(0, 4, 0.5, -6)
		preview.BackgroundColor3 = defaultColor
		preview.BorderSizePixel = 0
		Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 2)
		
		local previewStroke = Instance.new("UIStroke", preview)
		previewStroke.Color = Color3.fromRGB(150, 150, 150)
		previewStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		previewStroke.Thickness = 1

		local valLbl = Instance.new("TextLabel", colorBtn)
		valLbl.Size = UDim2.new(1, -24, 1, 0)
		valLbl.Position = UDim2.new(0, 20, 0, 0)
		valLbl.BackgroundTransparency = 1
		valLbl.Text = math.floor(defaultColor.R*255)..", "..math.floor(defaultColor.G*255)..", "..math.floor(defaultColor.B*255)
		valLbl.TextColor3 = CONFIG["Theme"]["Text"]
		valLbl.Font = Enum.Font.SourceSans
		valLbl.TextSize = 13
		valLbl.TextXAlignment = Enum.TextXAlignment.Left

		table.insert(UpdateSettingsVisuals, function()
			preview.BackgroundColor3 = CONFIG["Theme"]["Main1"]
			valLbl.Text = math.floor(CONFIG["Theme"]["Main1"].R*255)..", "..math.floor(CONFIG["Theme"]["Main1"].G*255)..", "..math.floor(CONFIG["Theme"]["Main1"].B*255)
		end)

		colorBtn.MouseButton1Click:Connect(function()
			local cp = PropertiesModule.Lib.ColorPicker.new()
			cp:SetColor(preview.BackgroundColor3)
			local conn
			conn = cp.OnSelect:Connect(function(col)
				preview.BackgroundColor3 = col
				valLbl.Text = math.floor(col.R*255)..", "..math.floor(col.G*255)..", "..math.floor(col.B*255)
				callback(col)
				if conn then conn:Disconnect() end
			end)
			cp:Show()
		end)
	end

	local function createButtonSetting(name, order, btnText, callback)
		local row = Instance.new("Frame", settingsScroll)
		row.Size = UDim2.new(1, 0, 0, 24)
		row.BackgroundColor3 = CONFIG["Theme"]["Main2"]
		row.BorderSizePixel = 0
		row.LayoutOrder = order
		
		local lbl = Instance.new("TextLabel", row)
		lbl.Size = UDim2.new(0.5, -10, 1, 0)
		lbl.Position = UDim2.new(0, 16, 0, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text = name
		lbl.TextColor3 = CONFIG["Theme"]["Text"]
		lbl.Font = Enum.Font.SourceSans
		lbl.TextSize = 14
		lbl.TextXAlignment = Enum.TextXAlignment.Left

		local btn = Instance.new("TextButton", row)
		btn.Size = UDim2.new(0.5, -8, 1, -4)
		btn.Position = UDim2.new(0.5, 4, 0, 2)
		btn.BackgroundColor3 = CONFIG["Theme"]["Button"]
		btn.BorderSizePixel = 0
		btn.Text = btnText
		btn.TextColor3 = CONFIG["Theme"]["Text"]
		btn.Font = Enum.Font.SourceSans
		btn.TextSize = 13
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
		
		btn.MouseButton1Click:Connect(callback)
	end

	local function createTextSetting(name, order, defaultText, callback)
		local row = Instance.new("Frame", settingsScroll)
		row.Size = UDim2.new(1, 0, 0, 24)
		row.BackgroundColor3 = CONFIG["Theme"]["Main2"]
		row.BorderSizePixel = 0
		row.LayoutOrder = order
		
		local lbl = Instance.new("TextLabel", row)
		lbl.Size = UDim2.new(0.5, -10, 1, 0)
		lbl.Position = UDim2.new(0, 16, 0, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text = name
		lbl.TextColor3 = CONFIG["Theme"]["Text"]
		lbl.Font = Enum.Font.SourceSans
		lbl.TextSize = 14
		lbl.TextXAlignment = Enum.TextXAlignment.Left

		local boxFrame = Instance.new("Frame", row)
		boxFrame.Size = UDim2.new(0.5, -8, 1, -4)
		boxFrame.Position = UDim2.new(0.5, 4, 0, 2)
		boxFrame.BackgroundColor3 = CONFIG["Theme"]["TextBox"]
		boxFrame.BorderSizePixel = 0
		Instance.new("UICorner", boxFrame).CornerRadius = UDim.new(0, 4)

		local pad = Instance.new("UIPadding", boxFrame)
		pad.PaddingLeft = UDim.new(0, 6)
		pad.PaddingRight = UDim.new(0, 6)

		local tb = Instance.new("TextBox", boxFrame)
		tb.Size = UDim2.new(1, 0, 1, 0)
		tb.Position = UDim2.new(0, 0, 0, 0)
		tb.BackgroundTransparency = 1
		tb.Text = defaultText
		tb.TextColor3 = CONFIG["Theme"]["Text"]
		tb.Font = Enum.Font.SourceSans
		tb.TextSize = 13
		tb.TextXAlignment = Enum.TextXAlignment.Left
		tb.ClearTextOnFocus = false
		
		PropertiesModule.Lib.ViewportTextBox.convert(tb)

		tb.FocusLost:Connect(function()
			callback(tb.Text)
		end)
	end

	local function createBooleanSetting(name, order, defaultVal, callback)
		local row = Instance.new("Frame", settingsScroll)
		row.Size = UDim2.new(1, 0, 0, 24)
		row.BackgroundColor3 = CONFIG["Theme"]["Main2"]
		row.BorderSizePixel = 0
		row.LayoutOrder = order

		local lbl = Instance.new("TextLabel", row)
		lbl.Size = UDim2.new(0.5, -10, 1, 0)
		lbl.Position = UDim2.new(0, 16, 0, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text = name
		lbl.TextColor3 = CONFIG["Theme"]["Text"]
		lbl.Font = Enum.Font.SourceSans
		lbl.TextSize = 14
		lbl.TextXAlignment = Enum.TextXAlignment.Left

		local cb = PropertiesModule.Lib.Checkbox.new(1)
		cb.Gui.Parent = row
		cb.Gui.Position = UDim2.new(0.5, 4, 0.5, -8)
		cb:SetState(defaultVal)
		cb.OnInput:Connect(function()
			callback(cb.Toggled)
		end)
	end

	local function createDropdownSetting(name, order, options, defaultVal, callback)
		local row = Instance.new("Frame", settingsScroll)
		row.Size = UDim2.new(1, 0, 0, 24)
		row.BackgroundColor3 = CONFIG["Theme"]["Main2"]
		row.BorderSizePixel = 0
		row.LayoutOrder = order

		local lbl = Instance.new("TextLabel", row)
		lbl.Size = UDim2.new(0.5, -10, 1, 0)
		lbl.Position = UDim2.new(0, 16, 0, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text = name
		lbl.TextColor3 = CONFIG["Theme"]["Text"]
		lbl.Font = Enum.Font.SourceSans
		lbl.TextSize = 14
		lbl.TextXAlignment = Enum.TextXAlignment.Left

		local btn = Instance.new("TextButton", row)
		btn.Size = UDim2.new(0.5, -8, 1, -4)
		btn.Position = UDim2.new(0.5, 4, 0, 2)
		btn.BackgroundColor3 = CONFIG["Theme"]["TextBox"]
		btn.BorderSizePixel = 0
		
		local defaultName = "Unknown"
		for _, opt in ipairs(options) do
			if opt.Value == defaultVal then defaultName = opt.Name break end
		end

		btn.Text = "  " .. tostring(defaultName)
		btn.TextColor3 = CONFIG["Theme"]["Text"]
		btn.Font = Enum.Font.SourceSans
		btn.TextSize = 13
		btn.TextXAlignment = Enum.TextXAlignment.Left
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

		local arrow = Instance.new("ImageLabel", btn)
		arrow.Size = UDim2.new(0, 16, 0, 16)
		arrow.Position = UDim2.new(1, -20, 0.5, -8)
		arrow.BackgroundTransparency = 1
		arrow.Image = CONFIG["AssetIds"]["ExplorerArrow"]
		arrow.ImageRectOffset = Vector2.new(144, 16)
		arrow.ImageRectSize = Vector2.new(16, 16)
		arrow.Rotation = 90

		local dropdownOpen = false

		btn.MouseButton1Click:Connect(function()
			if dropdownOpen and currentDropdownCtx then
				currentDropdownCtx:Hide()
				return
			end
			if currentDropdownCtx then currentDropdownCtx:Hide() end

			local ctx = PropertiesModule.Lib.ContextMenu.new()
			currentDropdownCtx = ctx
			dropdownOpen = true
			arrow.Rotation = -90
			ctx.MaxHeight = 150
			ctx.Width = btn.AbsoluteSize.X
			
			local originalHide = ctx.Hide
			ctx.Hide = function(self_ctx)
				if currentDropdownCtx == self_ctx then
					dropdownOpen = false
					currentDropdownCtx = nil
					arrow.Rotation = 90
				end
				originalHide(self_ctx)
			end

			for _, opt in ipairs(options) do
				ctx:Add({
					Name = tostring(opt.Name),
					OnClick = function()
						btn.Text = "  " .. tostring(opt.Name)
						callback(opt.Value)
					end
				})
			end
			ctx:Show(btn.AbsolutePosition.X, btn.AbsolutePosition.Y + btn.AbsoluteSize.Y + 2)
		end)
	end

	createCategory("Main", 1)
	createColorSetting("Background Color", 2, CONFIG["Theme"]["Main1"], function(col)
		local oldT = {}
		for k, v in pairs(CONFIG["Theme"]) do oldT[k] = v end
		
		local h, s, v = Color3.toHSV(col)
		local isLight = v > 0.5
		
		local main2V = math.clamp(v + (isLight and -0.05 or 0.05), 0, 1)
		local outline1V = math.clamp(v + (isLight and -0.15 or 0.15), 0, 1)
		local outline2V = math.clamp(v + (isLight and -0.25 or 0.25), 0, 1)
		local hoverV = math.clamp(v + (isLight and -0.10 or 0.10), 0, 1)

		local main2Col = Color3.fromHSV(h, s, main2V)
		local outlineCol = Color3.fromHSV(h, s, outline1V)
		local outline2Col = Color3.fromHSV(h, s, outline2V)
		local hoverCol = Color3.fromHSV(h, s, hoverV)

		local textV = v > 0.5 and 0.1 or 0.9
		local textColor = Color3.fromHSV(h, s, textV)
		local placeholderColor = Color3.fromHSV(h, s, v > 0.5 and 0.3 or 0.7)

		CONFIG["Theme"]["Main1"] = col
		CONFIG["Theme"]["Main2"] = main2Col
		CONFIG["Theme"]["Menu"] = main2Col
		CONFIG["Theme"]["MenuBackground"] = main2Col
		CONFIG["Theme"]["AppListCard"] = main2Col
		CONFIG["Theme"]["TextBox"] = main2Col
		
		CONFIG["Theme"]["Outline1"] = outlineCol
		CONFIG["Theme"]["Outline2"] = outline2Col
		CONFIG["Theme"]["Outline3"] = outline2Col
		CONFIG["Theme"]["Button"] = outlineCol
		CONFIG["Theme"]["ButtonHover"] = hoverCol
		CONFIG["Theme"]["ButtonPress"] = col
		CONFIG["Theme"]["AppListCardHover"] = hoverCol
		CONFIG["Theme"]["Highlight"] = hoverCol

		CONFIG["Theme"]["Text"] = textColor
		CONFIG["Theme"]["PlaceholderText"] = placeholderColor
		
		applyThemeUpdate(oldT)
	end)

	createButtonSetting("Reset to Default", 3, "Reset Theme", function()
		local oldT = {}
		for k, v in pairs(CONFIG["Theme"]) do oldT[k] = v end
		for k, v in pairs(InitialTheme) do CONFIG["Theme"][k] = v end
		applyThemeUpdate(oldT)
		for _, fn in ipairs(UpdateSettingsVisuals) do pcall(fn) end
	end)

	createCategory("Extras", 4)
	createTextSetting("Syntax Color URL", 5, CONFIG["Urls"]["PaperDark"], function(t)
		if t:match("^https?://") then
			CONFIG["Urls"]["PaperDark"] = t
		end
	end)

	createCategory("Script Editor (Baseline)", 6)
	
	createBooleanSetting("Smooth Blinker", 7, CONFIG["Settings"]["Baseline"].SmoothBlinker, function(val)
		updateAllBaselines("SmoothBlinker", val)
	end)
	
	createTextSetting("Text Size", 8, tostring(CONFIG["Settings"]["Baseline"].TextSize), function(val)
		local num = tonumber(val)
		if num then updateAllBaselines("TextSize", num) end
	end)
	
	createBooleanSetting("Minimap", 9, CONFIG["Settings"]["Baseline"].Minimap, function(val)
		updateAllBaselines("Minimap", val)
	end)

	createBooleanSetting("Line Numbers", 10, CONFIG["Settings"]["Baseline"].Lines, function(val)
		updateAllBaselines("Lines", val)
	end)

	createBooleanSetting("Word Wrap", 11, CONFIG["Settings"]["Baseline"].Wrapped, function(val)
		updateAllBaselines("Wrapped", val)
	end)
	
	local fontOptions = {
		{Name = "Roboto Mono", Value = "rbxasset://fonts/families/RobotoMono.json"},
		{Name = "Fira Mono", Value = "rbxasset://fonts/families/FiraMono.json"},
		{Name = "Inconsolata", Value = "rbxasset://fonts/families/Inconsolata.json"},
		{Name = "Ubuntu", Value = "rbxasset://fonts/families/Ubuntu.json"},
		{Name = "Gotham", Value = "rbxasset://fonts/families/GothamSSm.json"},
		{Name = "Source Sans Pro", Value = "rbxasset://fonts/families/SourceSansPro.json"},
		{Name = "Comic Sans", Value = "rbxasset://fonts/families/ComicNeueAngular.json"},
		{Name = "Jura", Value = "rbxasset://fonts/families/Jura.json"},
		{Name = "Oswald", Value = "rbxasset://fonts/families/Oswald.json"},
		{Name = "Amatic SC", Value = "rbxasset://fonts/families/AmaticSC.json"},
		{Name = "Bangers", Value = "rbxasset://fonts/families/Bangers.json"},
		{Name = "Creepster", Value = "rbxasset://fonts/families/Creepster.json"},
		{Name = "Denk One", Value = "rbxasset://fonts/families/DenkOne.json"},
		{Name = "Fredoka One", Value = "rbxasset://fonts/families/FredokaOne.json"},
		{Name = "Kalam", Value = "rbxasset://fonts/families/Kalam.json"},
		{Name = "Michroma", Value = "rbxasset://fonts/families/Michroma.json"},
		{Name = "Nunito", Value = "rbxasset://fonts/families/Nunito.json"},
		{Name = "Patrick Hand", Value = "rbxasset://fonts/families/PatrickHand.json"},
		{Name = "Permanent Marker", Value = "rbxasset://fonts/families/PermanentMarker.json"},
		{Name = "Special Elite", Value = "rbxasset://fonts/families/SpecialElite.json"},
		{Name = "Titillium Web", Value = "rbxasset://fonts/families/TitilliumWeb.json"},
		{Name = "Arial", Value = "rbxasset://fonts/families/Arial.json"}
	}
	createDropdownSetting("Font", 12, fontOptions, CONFIG["Settings"]["Baseline"].Font, function(val)
		updateAllBaselines("Font", val)
	end)

	local explorerWin, explorerContent = CreateDexWindow("Explorer", CONFIG["AssetIds"]["ExplorerDock"], "Right")
	InitExplorer(explorerContent)

	local propsWin, propsContent = CreateDexWindow("Properties", CONFIG["AssetIds"]["PropertiesDock"], "Right")
	PropertiesModule.Init(propsContent, DexAPI, {})

	local UserInputService = game:GetService("UserInputService")
	TrackConnection(UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseWheel then
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
				local mouse = UserInputService:GetMouseLocation()
				local viewportSize = workspace.CurrentCamera.ViewportSize

				local dockSide = nil
				local dockThreshold = 40
				
				if mouse.X < dockThreshold then
					dockSide = "Left"
				elseif mouse.X > viewportSize.X - dockThreshold then
					dockSide = "Right"
				elseif mouse.Y > viewportSize.Y - dockThreshold then
					dockSide = "Bottom"
				end
				
				if dockSide and DockedWindows[dockSide] and #DockedWindows[dockSide] > 0 then
					 
					local direction = input.Position.Z > 0 and -1 or 1
					local currentSize = CONFIG["Settings"]["DockSizes"][dockSide]
					local newSize = math.clamp(currentSize + (direction * 10), 200, 800)
					if newSize ~= currentSize then
						CONFIG["Settings"]["DockSizes"][dockSide] = newSize
						UpdateDockedWindows(dockSide, false)
					end
				else
					 
					local direction = input.Position.Z > 0 and -1 or 1
					local currentHeight = CONFIG["Settings"]["RowHeight"]
					local newHeight = math.clamp(currentHeight + (direction * 2), 12, 40)
					if newHeight ~= currentHeight then
						CONFIG["Settings"]["RowHeight"] = newHeight
						if _G.OnionExplorerRefresh then _G.OnionExplorerRefresh() end
						if _G.OnionPropertiesRefresh then _G.OnionPropertiesRefresh() end
					end
				end
			end
		end
	end))
	
	TrackConnection(SelectionEvent.Event:Connect(function(inst)
		if inst then
			PropertiesModule.SetSelection({inst})
		else
			PropertiesModule.SetSelection({})
		end
	end))

	if CustomDocks and #CustomDocks > 0 then
		for _, url in ipairs(CustomDocks) do
			task.spawn(function()
				pcall(function()
					local dockCode = game:HttpGet(url)
					if dockCode then
						local loadedFunc = loadstring(dockCode)
						if loadedFunc then loadedFunc() end
					end
				end)
			end)
		end
	end
end

IntroLib.Play(function() InitDexStyleDockEngine() end)
