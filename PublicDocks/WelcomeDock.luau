local LocalPlayer = game:GetService("Players").LocalPlayer
local displayName = LocalPlayer and LocalPlayer.DisplayName or "Developer"

local win, content, toggle = _G.Onion["CreateDock"](
	"Welcome, " .. displayName,
	"rbxassetid://84021105793570",
	"None",
	{InitialSize = UDim2.new(0, 520, 0, 580), ShowInMenu = true}
)

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 0
scrollFrame.ScrollBarImageTransparency = 1
scrollFrame.Parent = content

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 14)
layout.Parent = scrollFrame

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 16)
padding.PaddingRight = UDim.new(0, 16)
padding.PaddingTop = UDim.new(0, 16)
padding.PaddingBottom = UDim.new(0, 16)
padding.Parent = scrollFrame

local layoutOrder = 0
local function getOrder()
	layoutOrder = layoutOrder + 1
	return layoutOrder
end

local function createSeparator()
	local sepContainer = Instance.new("Frame")
	sepContainer.Size = UDim2.new(1, 0, 0, 10)
	sepContainer.BackgroundTransparency = 1
	sepContainer.LayoutOrder = getOrder()
	sepContainer.Parent = scrollFrame
	
	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, 0, 0, 1)
	line.Position = UDim2.new(0, 0, 0.5, 0)
	line.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
	line.BorderSizePixel = 0
	line.Parent = sepContainer
end

local function createText(text, size, font, color)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 0)
	lbl.AutomaticSize = Enum.AutomaticSize.Y
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = color or Color3.fromRGB(220, 220, 225)
	lbl.Font = font or Enum.Font.Gotham
	lbl.TextSize = size or 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.TextWrapped = true
	lbl.RichText = true
	lbl.LayoutOrder = getOrder()
	lbl.Parent = scrollFrame
	return lbl
end

local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, 42)
headerFrame.BackgroundTransparency = 1
headerFrame.LayoutOrder = getOrder()
headerFrame.Parent = scrollFrame

local hLayout = Instance.new("UIListLayout")
hLayout.FillDirection = Enum.FillDirection.Horizontal
hLayout.SortOrder = Enum.SortOrder.LayoutOrder
hLayout.VerticalAlignment = Enum.VerticalAlignment.Center
hLayout.Padding = UDim.new(0, 10)
hLayout.Parent = headerFrame

local paperIcon = Instance.new("ImageLabel")
paperIcon.Size = UDim2.new(0, 42, 0, 42)
paperIcon.BackgroundTransparency = 1
paperIcon.Image = "rbxassetid://84021105793570" 
paperIcon.LayoutOrder = 1
paperIcon.Parent = headerFrame

local headerText = Instance.new("TextLabel")
headerText.AutomaticSize = Enum.AutomaticSize.X
headerText.Size = UDim2.new(0, 0, 1, 0)
headerText.BackgroundTransparency = 1
headerText.Text = "Introducing Onion"
headerText.TextColor3 = Color3.fromRGB(255, 255, 255)
headerText.Font = Enum.Font.GothamBold
headerText.TextSize = 24
headerText.LayoutOrder = 2
headerText.Parent = headerFrame

local customEmoji = Instance.new("ImageLabel")
customEmoji.Size = UDim2.new(0, 26, 0, 26)
customEmoji.BackgroundTransparency = 1
customEmoji.Image = "rbxassetid://140799579" 
customEmoji.LayoutOrder = 3
customEmoji.Parent = headerFrame

createText("A part of the Paper Engine\nDeveloped by <b>@slavtherookie</b> (GitHub) / <b>@PaperClockWork</b> (Roblox)", 13, Enum.Font.Gotham, Color3.fromRGB(150, 150, 155))

createSeparator()

local introText = [[
It was developed and inspired by Moon's Dex Explorer. Although this does not have as much legacy functionalities just yet, it will definitely have more OVERALL useful functionalities that actually help with development and debugging.

Also, it is fully powered by a new LuaU syntax engine that is currently the absolute best on Roblox.

<b>CONFIDENTIAL & PRIVATE BUILD</b>
This is a private build version not released for the public. It is strictly for developers and testers of this tool. Sharing this may lead to legal circumstances. Sharing is only permitted after key licensing by the developer of this tool.]]
createText(introText, 14, Enum.Font.Gotham, Color3.fromRGB(200, 200, 205))

createSeparator()

createText("<b>Feature Deep Dive</b>", 18, Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255))

local function addFeature(title, desc)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 0)
	frame.AutomaticSize = Enum.AutomaticSize.Y
	frame.BackgroundTransparency = 1
	frame.LayoutOrder = getOrder()
	frame.Parent = scrollFrame
	
	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size = UDim2.new(1, 0, 0, 18)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = "- " .. title
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextSize = 14
	titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.Parent = frame
	
	local descLbl = Instance.new("TextLabel")
	descLbl.Size = UDim2.new(1, -15, 0, 0)
	descLbl.Position = UDim2.new(0, 15, 0, 20)
	descLbl.AutomaticSize = Enum.AutomaticSize.Y
	descLbl.BackgroundTransparency = 1
	descLbl.Text = desc
	descLbl.Font = Enum.Font.Gotham
	descLbl.TextSize = 13
	descLbl.TextColor3 = Color3.fromRGB(175, 175, 180)
	descLbl.TextXAlignment = Enum.TextXAlignment.Left
	descLbl.TextWrapped = true
	descLbl.Parent = frame
end

addFeature("Modular Docking Engine", "This lets you snap any window to the left, right, or bottom of your screen. It keeps your workspace really organized so you aren't dragging menus everywhere while trying to work.")
addFeature("Explorer & Rename", "The explorer updates in real-time and uses custom icons. The rename feature is super useful because you can just right-click and rename an instance directly without having to dig through the properties panel to find the Name value.")
addFeature("Advanced Context Menu", "Just right-click an object and you get a menu to Cut, Copy, Paste, Duplicate, Delete, Group, or Ungroup. It even has a 'Teleport To' button which is really nice for finding parts quickly in a big map.")
addFeature("Properties Panel", "Lets you edit the deep values of any object. I added built-in Color and BrickColor pickers, so instead of manually typing numbers, a clean UI pops up to let you pick the exact color you want easily.")
addFeature("Script Viewer", "We have a multi-tabbed script viewer so you can look at multiple scripts at once. It hooks directly into the decompiler, and you can quickly copy the code to your clipboard or save it directly as a file.")
addFeature("LuaU Syntax Engine", "It is powered by a completely custom LuaU syntax engine we built specifically for this. It runs extremely fast and handles syntax rendering better than anything else currently available on the platform.")

createSeparator()

createText("<b>Coming Soon</b>", 18, Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255))

addFeature("Settings Panel", "Adding a dedicated settings panel soon so you can fully customize the look, colors, and behavior of Onion to how you like it.")
addFeature("3D Object Previewer", "Working on a standalone viewport window where you can inspect models and meshes in 3D without actually placing them in the workspace.")

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 40)
end)

toggle(true)
