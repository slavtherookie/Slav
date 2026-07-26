local sspdockcontainer = {}
if getgenv()._sspdockcontainer then
	pcall(function() getgenv()._sspdockcontainer:Cleanup() end)
end
getgenv()._sspdockcontainer = sspdockcontainer
sspdockcontainer.AllDocks = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local guiHolder = pcall(function() return CoreGui.Name end) and CoreGui or LocalPlayer:WaitForChild("PlayerGui")

sspdockcontainer.Theme = {
	Background = Color3.fromRGB(45, 45, 45),
	TopBar = Color3.fromRGB(52, 52, 52),
	Outline = Color3.fromRGB(33, 33, 33),
	Button = Color3.fromRGB(60, 60, 60),
	ButtonHover = Color3.fromRGB(68, 68, 68),
	ButtonPress = Color3.fromRGB(40, 40, 40),
	Text = Color3.fromRGB(255, 255, 255),
	ResizeHandle = Color3.fromRGB(65, 65, 65)
}

local static = {MinWidth = 200, FreeWidth = 200}
local visibleWindows = {}
local leftSide = {Width = 300, Windows = {}, ResizeCons = {}, Hidden = true}
local rightSide = {Width = 300, Windows = {}, ResizeCons = {}, Hidden = true}

local displayOrderStart = 10
local sideDisplayOrder = 8
local sideTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweens = {}
local isA = game.IsA
local sidesGui, alignIndicator
local isInitialized = false
local updateWindows

function sspdockcontainer:Cleanup()
	for _, dock in ipairs(self.AllDocks) do
		if dock.Gui then dock.Gui:Destroy() end
	end
	if sidesGui then sidesGui:Destroy() end
	if alignIndicator then alignIndicator:Destroy() end
	for _, tween in ipairs(tweens) do
		tween:Cancel()
	end
	table.clear(tweens)
	table.clear(self.AllDocks)
	table.clear(visibleWindows)
	table.clear(leftSide.Windows)
	table.clear(rightSide.Windows)
end

function sspdockcontainer.SetTheme(baseColor)
	local h, s, v = baseColor:ToHSV()
	local function shift(dv) return Color3.fromHSV(h, s, math.clamp(v + dv, 0, 1)) end
	
	local t = sspdockcontainer.Theme
	t.Background = baseColor
	t.TopBar = shift(0.03)
	t.Outline = shift(-0.05)
	t.Button = shift(0.06)
	t.ButtonHover = shift(0.09)
	t.ButtonPress = shift(-0.02)
	t.ResizeHandle = shift(0.08)
	
	local function updateSideTheme(frame)
		if not frame then return end
		frame.BackgroundColor3 = t.Background
		frame.Resizer.BackgroundColor3 = t.ResizeHandle
		frame.Resizer.Line.BackgroundColor3 = t.Outline
		for _, child in ipairs(frame:GetChildren()) do
			if child.Name == "WindowResizer" then
				child.BackgroundColor3 = t.ResizeHandle
				if child:FindFirstChild("Line") then
					child.Line.BackgroundColor3 = t.Outline
				end
			end
		end
	end

	local function updateTemplate(template)
		if not template then return end
		template.BackgroundColor3 = t.ResizeHandle
		if template:FindFirstChild("Line") then
			template.Line.BackgroundColor3 = t.Outline
		end
	end

	if sidesGui then
		updateSideTheme(leftSide.Frame)
		updateSideTheme(rightSide.Frame)
		sidesGui.LeftToggle.BackgroundColor3 = t.TopBar
		sidesGui.LeftToggle.BorderColor3 = t.Outline
		sidesGui.RightToggle.BackgroundColor3 = t.TopBar
		sidesGui.RightToggle.BorderColor3 = t.Outline
		
		updateTemplate(leftSide.WindowResizer)
		updateTemplate(rightSide.WindowResizer)
	end

	for _, dock in ipairs(sspdockcontainer.AllDocks) do
		dock.GuiElems.Content.BackgroundColor3 = t.Background
		dock.GuiElems.Line.BackgroundColor3 = t.Outline
		dock.GuiElems.TopBar.BackgroundColor3 = t.TopBar
		dock.GuiElems.Title.TextColor3 = t.Text
		dock.GuiElems.Close.TextColor3 = t.Text
		dock.GuiElems.Minimize.TextColor3 = t.Text
		
		for _, ctrl in ipairs(dock.GuiElems.ResizeControls:GetChildren()) do
			if ctrl:IsA("GuiObject") then
				ctrl.BackgroundColor3 = t.ResizeHandle
			end
		end
	end
end

local function create(data)
	local insts = {}
	for _, v in pairs(data) do insts[v[1]] = Instance.new(v[2]) end
	for _, v in pairs(data) do
		for prop, val in pairs(v[3]) do
			if type(val) == "table" then
				insts[v[1]][prop] = insts[val[1]]
			else
				insts[v[1]][prop] = val
			end
		end
	end
	return insts[1]
end

local Signal = {}
Signal.__index = Signal

function Signal.new()
	local self = setmetatable({}, Signal)
	self.Connections = {}
	return self
end

function Signal:Connect(func)
	local con = {
		Signal = self,
		Func = func,
		Disconnect = function(c)
			local pos = table.find(c.Signal.Connections, c)
			if pos then table.remove(c.Signal.Connections, pos) end
		end
	}
	self.Connections[#self.Connections + 1] = con
	return con
end

function Signal:Fire(...)
	for _, v in next, self.Connections do
		xpcall(coroutine.wrap(v.Func), function(e) warn(e .. "\n" .. debug.traceback()) end, ...)
	end
end

local function checkMouseInGui(gui)
	if gui == nil then return false end
	local guiPosition = gui.AbsolutePosition
	local guiSize = gui.AbsoluteSize	
	return Mouse.X >= guiPosition.X and Mouse.X < guiPosition.X + guiSize.X and Mouse.Y >= guiPosition.Y and Mouse.Y < guiPosition.Y + guiSize.Y
end

local function buttonAnim(button, data)
	local holding = false
	local disabled = false
	local mode = data and data.Mode or 1
	local control = {}

	button.InputBegan:Connect(function(input)
		if disabled then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement and not holding then
			if mode == 1 then
				button.BackgroundTransparency = 0.5
			elseif mode == 2 then
				button.BackgroundColor3 = sspdockcontainer.Theme.ButtonHover
			end
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			holding = true
			if mode == 1 then
				button.BackgroundTransparency = 0
			elseif mode == 2 then
				button.BackgroundColor3 = sspdockcontainer.Theme.ButtonPress
				button.BorderColor3 = sspdockcontainer.Theme.ButtonPress
			end
		end
	end)

	button.InputEnded:Connect(function(input)
		if disabled then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement and not holding then
			if mode == 1 then
				button.BackgroundTransparency = 1
			elseif mode == 2 then
				button.BackgroundColor3 = sspdockcontainer.Theme.TopBar
			end
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			holding = false
			if mode == 1 then
				button.BackgroundTransparency = checkMouseInGui(button) and 0.5 or 1
			elseif mode == 2 then
				button.BackgroundColor3 = checkMouseInGui(button) and sspdockcontainer.Theme.ButtonHover or sspdockcontainer.Theme.TopBar
				button.BorderColor3 = sspdockcontainer.Theme.Outline
			end
		end
	end)

	control.Disable = function()
		disabled = true
		holding = false
		if mode == 1 then
			button.BackgroundTransparency = 1
		elseif mode == 2 then
			button.BackgroundColor3 = sspdockcontainer.Theme.TopBar
		end
	end

	control.Enable = function()
		disabled = false
	end

	return control
end

local function stopTweens()
	for i = 1, #tweens do
		tweens[i]:Cancel()
	end
	tweens = {}
end

local function moveToTop(window)
	local found = table.find(visibleWindows, window)
	if found then
		table.remove(visibleWindows, found)
		table.insert(visibleWindows, 1, window)
		updateWindows()
	end
end

local function sideHasRoom(side, neededSize)
	local maxY = sidesGui.AbsoluteSize.Y - (math.max(0, #side.Windows - 1) * 4)
	local inc = 0
	for i, v in pairs(side.Windows) do
		inc = inc + (v.MinY or 100)
		if inc > maxY - neededSize then return false end
	end
	return true
end

local function getSideInsertPos(side, curY)
	local pos = #side.Windows + 1
	local range = {0, sidesGui.AbsoluteSize.Y}

	for i, v in ipairs(side.Windows) do
		local midPos = v.PosY + (v.SizeY / 2)
		if curY <= midPos then
			pos = i
			range[2] = midPos
			break
		else
			range[1] = midPos
		end
	end
	return pos, range
end

local function focusInput(self, obj)
	if isA(obj, "GuiButton") then
		obj.MouseButton1Down:Connect(function()
			moveToTop(self)
		end)
	elseif isA(obj, "TextBox") then
		obj.Focused:Connect(function()
			moveToTop(self)
		end)
	end
end

local function resizeHook(self, resizer, dir)
	local guiMain = self.GuiElems.Main
	resizer.InputBegan:Connect(function(input)
		if not self.Dragging and not self.Resizing and self.Resizable and self.ResizableInternal then
			local isH = dir:find("[WE]") and true
			local isV = dir:find("[NS]") and true
			local signX = dir:find("W", 1, true) and -1 or 1
			local signY = dir:find("N", 1, true) and -1 or 1

			if self.Minimized and isV then return end

			if input.UserInputType == Enum.UserInputType.MouseMovement then
				resizer.BackgroundTransparency = 0.5
			elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
				moveToTop(self)
				local releaseEvent, mouseEvent
				self.Resizing = resizer
				resizer.BackgroundTransparency = 1

				local startMouseX, startMouseY = Mouse.X, Mouse.Y
				local startSizeX, startSizeY = self.SizeX, self.SizeY
				local startPosX, startPosY = guiMain.AbsolutePosition.X, guiMain.AbsolutePosition.Y

				releaseEvent = UserInputService.InputEnded:Connect(function(inp)
					if inp.UserInputType == Enum.UserInputType.MouseButton1 then
						releaseEvent:Disconnect()
						mouseEvent:Disconnect()
						self.Resizing = false
						resizer.BackgroundTransparency = 1
					end
				end)

				mouseEvent = UserInputService.InputChanged:Connect(function(inp)
					if self.Resizable and self.ResizableInternal and inp.UserInputType == Enum.UserInputType.MouseMovement then
						self:StopTweens()

						local deltaX = inp.Position.X - startMouseX
						local deltaY = inp.Position.Y - startMouseY

						local newSizeX = startSizeX + (deltaX * signX)
						local newSizeY = startSizeY + (deltaY * signY)
						local newPosX = startPosX
						local newPosY = startPosY

						if newSizeX < self.MinX then 
							newSizeX = self.MinX 
							deltaX = (newSizeX - startSizeX) * signX 
						end
						if newSizeY < self.MinY then 
							newSizeY = self.MinY 
							deltaY = (newSizeY - startSizeY) * signY 
						end

						if signX < 0 then newPosX = startPosX + deltaX end
						if signY < 0 then newPosY = startPosY + deltaY end

						self.SizeX = newSizeX
						self.SizeY = newSizeY

						guiMain.Position = UDim2.new(0, newPosX, 0, newPosY)
						guiMain.Size = UDim2.new(0, newSizeX, 0, self.Minimized and 20 or newSizeY)
					end
				end)
			end
		end
	end)

	resizer.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and self.Resizing ~= resizer then
			resizer.BackgroundTransparency = 1
		end
	end)
end

local function updateSideFrames(noTween)
	stopTweens()
	leftSide.Frame.Size = UDim2.new(0, leftSide.Width, 1, 0)
	rightSide.Frame.Size = UDim2.new(0, rightSide.Width, 1, 0)
	leftSide.Frame.Resizer.Position = UDim2.new(0, leftSide.Width, 0, 0)
	rightSide.Frame.Resizer.Position = UDim2.new(0, -5, 0, 0)

	local leftHidden = #leftSide.Windows == 0 or leftSide.Hidden
	local rightHidden = #rightSide.Windows == 0 or rightSide.Hidden
	local leftPos = (leftHidden and UDim2.new(0, -leftSide.Width - 10, 0, 0) or UDim2.new(0, 0, 0, 0))
	local rightPos = (rightHidden and UDim2.new(1, 10, 0, 0) or UDim2.new(1, -rightSide.Width, 0, 0))

	sidesGui.LeftToggle.Text = leftHidden and ">" or "<"
	sidesGui.RightToggle.Text = rightHidden and "<" or ">"

	if not noTween then
		local function insertTween(...)
			local tween = TweenService:Create(...)
			tweens[#tweens + 1] = tween
			tween:Play()
		end
		insertTween(leftSide.Frame, sideTweenInfo, {Position = leftPos})
		insertTween(rightSide.Frame, sideTweenInfo, {Position = rightPos})
		insertTween(sidesGui.LeftToggle, sideTweenInfo, {Position = UDim2.new(0, #leftSide.Windows == 0 and -16 or 0, 0, -36)})
		insertTween(sidesGui.RightToggle, sideTweenInfo, {Position = UDim2.new(1, #rightSide.Windows == 0 and 0 or -16, 0, -36)})
	else
		leftSide.Frame.Position = leftPos
		rightSide.Frame.Position = rightPos
		sidesGui.LeftToggle.Position = UDim2.new(0, #leftSide.Windows == 0 and -16 or 0, 0, -36)
		sidesGui.RightToggle.Position = UDim2.new(1, #rightSide.Windows == 0 and 0 or -16, 0, -36)
	end
end

local function getSideFramePos(side)
	local leftHidden = #leftSide.Windows == 0 or leftSide.Hidden
	local rightHidden = #rightSide.Windows == 0 or rightSide.Hidden
	if side == leftSide then
		return (leftHidden and UDim2.new(0, -leftSide.Width - 10, 0, 0) or UDim2.new(0, 0, 0, 0))
	else
		return (rightHidden and UDim2.new(1, 10, 0, 0) or UDim2.new(1, -rightSide.Width, 0, 0))
	end
end

local function sideResized(side)
	local currentPos = 0
	local sideFramePos = getSideFramePos(side)
	for i, v in pairs(side.Windows) do
		v.SizeX = side.Width
		v.GuiElems.Main.Size = UDim2.new(0, side.Width, 0, v.SizeY)
		v.GuiElems.Main.Position = UDim2.new(sideFramePos.X.Scale, sideFramePos.X.Offset, 0, currentPos)
		currentPos = currentPos + v.SizeY + 4
	end
end

local function sideResizerHook(resizer, dir, side, pos)
	local windows = side.Windows
	resizer.InputBegan:Connect(function(input)
		if not side.Resizing then
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				resizer.BackgroundColor3 = sspdockcontainer.Theme.ButtonHover
			elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
				local releaseEvent, mouseEvent
				side.Resizing = resizer
				resizer.BackgroundColor3 = sspdockcontainer.Theme.ButtonPress

				local startMouse = Mouse[dir == "V" and "Y" or "X"]
				local startSizes = {}
				for i, w in pairs(windows) do startSizes[i] = w.SizeY end
				local startWidth = side.Width

				releaseEvent = UserInputService.InputEnded:Connect(function(inp)
					if inp.UserInputType == Enum.UserInputType.MouseButton1 then
						releaseEvent:Disconnect()
						mouseEvent:Disconnect()
						side.Resizing = false
						resizer.BackgroundColor3 = sspdockcontainer.Theme.ResizeHandle
					end
				end)

				mouseEvent = UserInputService.InputChanged:Connect(function(inp)
					if not resizer.Parent then
						releaseEvent:Disconnect()
						mouseEvent:Disconnect()
						side.Resizing = false
						return
					end
					if inp.UserInputType == Enum.UserInputType.MouseMovement then
						if dir == "V" then
							local delta = inp.Position.Y - startMouse
							if delta > 0 then
								local neededSize = delta
								for i = pos + 1, #windows do
									local window = windows[i]
									local startS = startSizes[i]
									local newSize = math.max(startS - neededSize, (window.MinY or 100))
									neededSize = neededSize - (startS - newSize)
									window.SizeY = newSize
								end
								windows[pos].SizeY = startSizes[pos] + math.max(0, delta - neededSize)
							else
								local neededSize = -delta
								for i = pos, 1, -1 do
									local window = windows[i]
									local startS = startSizes[i]
									local newSize = math.max(startS - neededSize, (window.MinY or 100))
									neededSize = neededSize - (startS - newSize)
									window.SizeY = newSize
								end
								windows[pos + 1].SizeY = startSizes[pos + 1] + math.max(0, -delta - neededSize)
							end
							updateSideFrames()
							sideResized(side)
						elseif dir == "H" then
							local maxWidth = math.max(300, sidesGui.AbsoluteSize.X - static.FreeWidth)
							local otherSide = (side == leftSide and rightSide or leftSide)
							local delta = inp.Position.X - startMouse
							delta = (side == leftSide and delta or -delta)

							local proposedSize = math.max(static.MinWidth, startWidth + delta)
							if proposedSize + otherSide.Width <= maxWidth then
								side.Width = proposedSize
							else
								local newOtherSize = maxWidth - proposedSize
								if newOtherSize >= static.MinWidth then
									side.Width = proposedSize
									otherSide.Width = newOtherSize
								else
									side.Width = maxWidth - static.MinWidth
									otherSide.Width = static.MinWidth
								end
							end
							updateSideFrames(true)
							sideResized(side)
							sideResized(otherSide)
						end
					end
				end)
			end
		end
	end)

	resizer.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and side.Resizing ~= resizer then
			resizer.BackgroundColor3 = sspdockcontainer.Theme.ResizeHandle
		end
	end)
end

local function renderSide(side, noTween)
	local currentPos = 0
	local sideFramePos = getSideFramePos(side)
	local template = side.WindowResizer:Clone()
	for i, v in pairs(side.ResizeCons) do v:Disconnect() end
	for i, v in pairs(side.Frame:GetChildren()) do if v.Name == "WindowResizer" then v:Destroy() end end
	side.ResizeCons = {}
	side.Resizing = nil

	for i, v in pairs(side.Windows) do
		v.SidePos = i
		local isEnd = i == #side.Windows
		local size = UDim2.new(0, side.Width, 0, v.SizeY)
		local pos = UDim2.new(sideFramePos.X.Scale, sideFramePos.X.Offset, 0, currentPos)
		v.Gui.Parent = guiHolder
		if noTween then
			v.GuiElems.Main.Size = size
			v.GuiElems.Main.Position = pos
		else
			local tween = TweenService:Create(v.GuiElems.Main, sideTweenInfo, {Size = size, Position = pos})
			tweens[#tweens + 1] = tween
			tween:Play()
		end
		currentPos = currentPos + v.SizeY + 4

		if not isEnd then
			local newTemplate = template:Clone()
			newTemplate.Position = UDim2.new(0, 0, 0, currentPos - 4)
			newTemplate.Size = UDim2.new(1, 0, 0, 4)
			side.ResizeCons[#side.ResizeCons + 1] = v.Gui.Main:GetPropertyChangedSignal("Size"):Connect(function()
				newTemplate.Position = UDim2.new(0, 0, 0, v.GuiElems.Main.Position.Y.Offset + v.GuiElems.Main.Size.Y.Offset)
			end)
			side.ResizeCons[#side.ResizeCons + 1] = v.Gui.Main:GetPropertyChangedSignal("Position"):Connect(function()
				newTemplate.Position = UDim2.new(0, 0, 0, v.GuiElems.Main.Position.Y.Offset + v.GuiElems.Main.Size.Y.Offset)
			end)
			sideResizerHook(newTemplate, "V", side, i)
			newTemplate.Parent = side.Frame
		end
	end
end

local function updateSide(side, noTween)
	local oldHeight = 0
	local currentPos = 0
	local neededSize = 0
	local windows = side.Windows
	local height = sidesGui.AbsoluteSize.Y - (math.max(0, #windows - 1) * 4)

	for i, v in pairs(windows) do oldHeight = oldHeight + v.SizeY end
	for i, v in pairs(windows) do
		if i == #windows then
			v.SizeY = height - currentPos
			neededSize = math.max(0, (v.MinY or 100) - v.SizeY)
		else
			v.SizeY = math.max(math.floor(v.SizeY / oldHeight * height), v.MinY or 100)
		end
		currentPos = currentPos + v.SizeY
	end

	if neededSize > 0 then
		for i = #windows - 1, 1, -1 do
			local window = windows[i]
			local newSize = math.max(window.SizeY - neededSize, (window.MinY or 100))
			neededSize = neededSize - (window.SizeY - newSize)
			window.SizeY = newSize
		end
		local lastWindow = windows[#windows]
		lastWindow.SizeY = (lastWindow.MinY or 100) - neededSize
	end
	renderSide(side, noTween)
end

updateWindows = function(noTween)
	updateSideFrames(noTween)
	updateSide(leftSide, noTween)
	updateSide(rightSide, noTween)
	local count = 0
	for i = #visibleWindows, 1, -1 do
		visibleWindows[i].Gui.DisplayOrder = displayOrderStart + count
		visibleWindows[i].Gui.Parent = guiHolder
		count = count + 1
	end
end

local funcs = {}
local windowMt = {__index = funcs}

local function createGui(self)
	local theme = sspdockcontainer.Theme
	local gui = create({
		{1, "ScreenGui", {Name="Window", IgnoreGuiInset=true}},
		{2, "Frame", {Active=true, BackgroundTransparency=1, BorderSizePixel=0, Name="Main", Parent={1}, Position=UDim2.new(0.4, 0, 0.4, 0), Size=UDim2.new(0, 300, 0, 300), ClipsDescendants=true}},
		{3, "Frame", {BackgroundColor3=theme.Background, BorderSizePixel=0, Name="Content", Parent={2}, Position=UDim2.new(0, 0, 0, 20), Size=UDim2.new(1, 0, 1, -20), ClipsDescendants=true}},
		{4, "Frame", {BackgroundColor3=theme.Outline, BorderSizePixel=0, Name="Line", Parent={3}, Size=UDim2.new(1, 0, 0, 1)}},
		{5, "Frame", {BackgroundColor3=theme.TopBar, BorderSizePixel=0, Name="TopBar", Parent={2}, Size=UDim2.new(1, 0, 0, 20)}},
		{6, "TextLabel", {BackgroundTransparency=1, Font=3, Name="Title", Parent={5}, Position=UDim2.new(0, 5, 0, 0), Size=UDim2.new(1, -10, 0, 20), Text="Window", TextColor3=theme.Text, TextSize=14, TextXAlignment=0}},
		{7, "TextButton", {AutoButtonColor=false, BackgroundColor3=Color3.fromRGB(0,0,0), BackgroundTransparency=1, BorderSizePixel=0, Font=3, Name="Close", Parent={5}, Position=UDim2.new(1, -18, 0, 2), Size=UDim2.new(0, 16, 0, 16), Text="", TextColor3=theme.Text, TextSize=14}},
		{8, "ImageLabel", {BackgroundTransparency=1, Image="rbxassetid://5054663650", Parent={7}, Position=UDim2.new(0, 3, 0, 3), Size=UDim2.new(0, 10, 0, 10)}},
		{9, "UICorner", {CornerRadius=UDim.new(0, 4), Parent={7}}},
		{10, "TextButton", {AutoButtonColor=false, BackgroundColor3=Color3.fromRGB(0,0,0), BackgroundTransparency=1, BorderSizePixel=0, Font=3, Name="Minimize", Parent={5}, Position=UDim2.new(1, -36, 0, 2), Size=UDim2.new(0, 16, 0, 16), Text="", TextColor3=theme.Text, TextSize=14}},
		{11, "ImageLabel", {BackgroundTransparency=1, Image="rbxassetid://5034768003", Parent={10}, Position=UDim2.new(0, 3, 0, 3), Size=UDim2.new(0, 10, 0, 10)}},
		{12, "UICorner", {CornerRadius=UDim.new(0, 4), Parent={10}}},
		{13, "ImageLabel", {BackgroundTransparency=1, BorderSizePixel=0, Image="rbxassetid://1427967925", Name="Outlines", Parent={2}, Position=UDim2.new(0, -5, 0, -5), ScaleType=1, Size=UDim2.new(1, 10, 1, 10), SliceCenter=Rect.new(6, 6, 25, 25), TileSize=UDim2.new(0, 20, 0, 20)}},
		{14, "Frame", {BackgroundTransparency=1, Name="ResizeControls", Parent={2}, Position=UDim2.new(0, -5, 0, -5), Size=UDim2.new(1, 10, 1, 10)}},
		{15, "TextButton", {AutoButtonColor=false, BackgroundTransparency=1, BorderSizePixel=0, Font=3, Name="North", Parent={14}, Position=UDim2.new(0, 5, 0, 0), Size=UDim2.new(1, -10, 0, 5), Text="", TextSize=14}},
		{16, "TextButton", {AutoButtonColor=false, BackgroundTransparency=1, BorderSizePixel=0, Font=3, Name="South", Parent={14}, Position=UDim2.new(0, 5, 1, -5), Size=UDim2.new(1, -10, 0, 5), Text="", TextSize=14}},
		{17, "TextButton", {AutoButtonColor=false, BackgroundTransparency=1, BorderSizePixel=0, Font=3, Name="NorthEast", Parent={14}, Position=UDim2.new(1, -5, 0, 0), Size=UDim2.new(0, 5, 0, 5), Text="", TextSize=14}},
		{18, "TextButton", {AutoButtonColor=false, BackgroundTransparency=1, BorderSizePixel=0, Font=3, Name="East", Parent={14}, Position=UDim2.new(1, -5, 0, 5), Size=UDim2.new(0, 5, 1, -10), Text="", TextSize=14}},
		{19, "TextButton", {AutoButtonColor=false, BackgroundTransparency=1, BorderSizePixel=0, Font=3, Name="West", Parent={14}, Position=UDim2.new(0, 0, 0, 5), Size=UDim2.new(0, 5, 1, -10), Text="", TextSize=14}},
		{20, "TextButton", {AutoButtonColor=false, BackgroundTransparency=1, BorderSizePixel=0, Font=3, Name="SouthEast", Parent={14}, Position=UDim2.new(1, -5, 1, -5), Size=UDim2.new(0, 5, 0, 5), Text="", TextSize=14}},
		{21, "TextButton", {AutoButtonColor=false, BackgroundTransparency=1, BorderSizePixel=0, Font=3, Name="NorthWest", Parent={14}, Size=UDim2.new(0, 5, 0, 5), Text="", TextSize=14}},
		{22, "TextButton", {AutoButtonColor=false, BackgroundTransparency=1, BorderSizePixel=0, Font=3, Name="SouthWest", Parent={14}, Position=UDim2.new(0, 0, 1, -5), Size=UDim2.new(0, 5, 0, 5), Text="", TextSize=14}}
	})

	local guiMain = gui.Main
	local guiTopBar = guiMain.TopBar
	local guiResizeControls = guiMain.ResizeControls
	local guiDragging = false

	self.GuiElems.Main = guiMain
	self.GuiElems.TopBar = guiMain.TopBar
	self.GuiElems.Content = guiMain.Content
	self.GuiElems.Line = guiMain.Content.Line
	self.GuiElems.Outlines = guiMain.Outlines
	self.GuiElems.Title = guiTopBar.Title
	self.GuiElems.Close = guiTopBar.Close
	self.GuiElems.Minimize = guiTopBar.Minimize
	self.GuiElems.ResizeControls = guiResizeControls
	self.ContentPane = guiMain.Content

	guiTopBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and self.Draggable then
			moveToTop(self)
			local releaseEvent, mouseEvent
			local initX = guiMain.AbsolutePosition.X
			local initY = guiMain.AbsolutePosition.Y
			local offX = Mouse.X - initX
			local offY = Mouse.Y - initY
			local alignInsertPos, alignInsertSide
			
			if not self.Aligned then
				self.UndockedSizeX = self.SizeX
				self.UndockedSizeY = self.SizeY
			end

			guiDragging = true

			releaseEvent = UserInputService.InputEnded:Connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseButton1 then
					releaseEvent:Disconnect()
					mouseEvent:Disconnect()
					guiDragging = false
					alignIndicator.Parent = nil
					if alignInsertSide then
						local targetSide = (alignInsertSide == "left" and leftSide) or (alignInsertSide == "right" and rightSide)
						self:AlignTo(targetSide, alignInsertPos)
					end
				end
			end)

			mouseEvent = UserInputService.InputChanged:Connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseMovement and self.Draggable and not self.Closed then
					if self.Aligned then
						if leftSide.Resizing or rightSide.Resizing then return end
						local posX, posY = inp.Position.X - offX, inp.Position.Y - offY
						local delta = math.sqrt((posX - initX)^2 + (posY - initY)^2)
						if delta >= 5 then
							self:SetAligned(false)
						end
					else
						local inputX, inputY = inp.Position.X, inp.Position.Y
						local posX, posY = inputX - offX, inputY - offY
						if posY < 0 then posY = 0 end
						guiMain.Position = UDim2.new(0, posX, 0, posY)

						if self.Resizable and self.Alignable then
							local maxX = sidesGui.AbsoluteSize.X
							if inputX < 25 then
								if sideHasRoom(leftSide, self.MinY or 100) then
									local insertPos, range = getSideInsertPos(leftSide, inputY)
									alignIndicator.Indicator.Position = UDim2.new(0, 0, 0, range[1])
									alignIndicator.Indicator.Size = UDim2.new(0, leftSide.Width, 0, range[2] - range[1])
									alignIndicator.Parent = guiHolder
									alignInsertPos = insertPos
									alignInsertSide = "left"
									return
								end
							elseif inputX >= maxX - 25 then
								if sideHasRoom(rightSide, self.MinY or 100) then
									local insertPos, range = getSideInsertPos(rightSide, inputY)
									alignIndicator.Indicator.Position = UDim2.new(0, maxX - rightSide.Width, 0, range[1])
									alignIndicator.Indicator.Size = UDim2.new(0, rightSide.Width, 0, range[2] - range[1])
									alignIndicator.Parent = guiHolder
									alignInsertPos = insertPos
									alignInsertSide = "right"
									return
								end
							end
						end
						alignIndicator.Parent = nil
						alignInsertPos = nil
						alignInsertSide = nil
					end
				end
			end)
		end
	end)

	guiTopBar.Close.MouseButton1Click:Connect(function()
		if self.Closed then return end
		self:Close()
	end)

	guiTopBar.Minimize.MouseButton1Click:Connect(function()
		if self.Closed then return end
		if self.Aligned then
			self:SetAligned(false)
		else
			self:SetMinimized()
		end
	end)

	guiTopBar.Minimize.MouseButton2Click:Connect(function()
		if self.Closed then return end
		if not self.Aligned then
			self:SetMinimized(nil, 2)
			guiTopBar.Minimize.BackgroundTransparency = 1
		end
	end)

	guiMain.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and not self.Aligned and not self.Closed then
			moveToTop(self)
		end
	end)

	guiMain:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
		local absPos = guiMain.AbsolutePosition
		self.PosX = absPos.X
		self.PosY = absPos.Y
	end)

	resizeHook(self, guiResizeControls.North, "N")
	resizeHook(self, guiResizeControls.NorthEast, "NE")
	resizeHook(self, guiResizeControls.East, "E")
	resizeHook(self, guiResizeControls.SouthEast, "SE")
	resizeHook(self, guiResizeControls.South, "S")
	resizeHook(self, guiResizeControls.SouthWest, "SW")
	resizeHook(self, guiResizeControls.West, "W")
	resizeHook(self, guiResizeControls.NorthWest, "NW")

	guiMain.Size = UDim2.new(0, self.SizeX, 0, self.SizeY)

	gui.DescendantAdded:Connect(function(obj) focusInput(self, obj) end)
	local descs = gui:GetDescendants()
	for i = 1, #descs do
		focusInput(self, descs[i])
	end

	self.MinimizeAnim = buttonAnim(guiTopBar.Minimize)
	self.CloseAnim = buttonAnim(guiTopBar.Close)

	return gui
end

function funcs:SetMinimized(set, mode)
	local oldVal = self.Minimized
	local newVal
	if set == nil then newVal = not self.Minimized else newVal = set end
	self.Minimized = newVal
	if not mode then mode = 1 end

	local resizeControls = self.GuiElems.ResizeControls
	local minimizeControls = {"North", "NorthEast", "NorthWest", "South", "SouthEast", "SouthWest"}
	for i = 1, #minimizeControls do
		local control = resizeControls:FindFirstChild(minimizeControls[i])
		if control then control.Visible = not newVal end
	end

	if mode == 1 or mode == 2 then
		self:StopTweens()
		if mode == 1 then
			self.GuiElems.Main:TweenSize(UDim2.new(0, self.SizeX, 0, newVal and 20 or self.SizeY), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
		else
			local maxY = sidesGui.AbsoluteSize.Y
			local newPos = UDim2.new(0, self.PosX, 0, newVal and math.min(maxY - 20, self.PosY + self.SizeY - 20) or math.max(0, self.PosY - self.SizeY + 20))

			self.GuiElems.Main:TweenPosition(newPos, Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
			self.GuiElems.Main:TweenSize(UDim2.new(0, self.SizeX, 0, newVal and 20 or self.SizeY), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
		end
		self.GuiElems.Minimize.ImageLabel.Image = newVal and "rbxassetid://5060023708" or "rbxassetid://5034768003"
	end

	if oldVal ~= newVal then
		if newVal then
			self.OnMinimize:Fire()
		else
			self.OnRestore:Fire()
		end
	end
end

function funcs:Resize(sizeX, sizeY)
	self.SizeX = sizeX or self.SizeX
	self.SizeY = sizeY or self.SizeY
	self.GuiElems.Main.Size = UDim2.new(0, self.SizeX, 0, self.SizeY)
end

funcs.SetSize = funcs.Resize

function funcs:SetTitle(title)
	self.GuiElems.Title.Text = title
end

function funcs:SetResizable(val)
	self.Resizable = val
	self.GuiElems.ResizeControls.Visible = self.Resizable and self.ResizableInternal
end

function funcs:SetResizableInternal(val)
	self.ResizableInternal = val
	self.GuiElems.ResizeControls.Visible = self.Resizable and self.ResizableInternal
end

function funcs:SetAligned(val)
	self.Aligned = val
	self:SetResizableInternal(not val)
	self.GuiElems.Main.Active = not val
	self.GuiElems.Main.Outlines.Visible = not val
	
	if not val then
		for i, v in pairs(leftSide.Windows) do if v == self then table.remove(leftSide.Windows, i) break end end
		for i, v in pairs(rightSide.Windows) do if v == self then table.remove(rightSide.Windows, i) break end end
		
		if self.UndockedSizeX and self.UndockedSizeY then
			self.SizeX = self.UndockedSizeX
			self.SizeY = self.UndockedSizeY
			self.GuiElems.Main.Size = UDim2.new(0, self.SizeX, 0, self.SizeY)
		end
		
		if not table.find(visibleWindows, self) then table.insert(visibleWindows, 1, self) end
		self.GuiElems.Minimize.ImageLabel.Image = "rbxassetid://5034768003"
		self.Side = nil
		updateWindows()
	else
		if not self.UndockedSizeX then
			self.UndockedSizeX = self.SizeX
			self.UndockedSizeY = self.SizeY
		end
		self:SetMinimized(false, 3)
		for i, v in pairs(visibleWindows) do if v == self then table.remove(visibleWindows, i) break end end
		self.GuiElems.Minimize.ImageLabel.Image = "rbxassetid://5448127505"
	end
end

function funcs:Add(obj, name)
	if type(obj) == "table" and obj.Gui and obj.Gui:IsA("GuiObject") then
		obj.Gui.Parent = self.ContentPane
	else
		obj.Parent = self.ContentPane
	end
	if name then self.Elements[name] = obj end
end

function funcs:GetElement(name)
	return self.Elements[name]
end

function funcs:AlignTo(side, pos, size, silent)
	if table.find(side.Windows, self) or self.Closed then return end

	if not self.Aligned then
		self.UndockedSizeX = self.SizeX
		self.UndockedSizeY = self.SizeY
	end

	self:SetAligned(true)
	self.Side = side
	self.SizeX = side.Width
	self.Gui.DisplayOrder = sideDisplayOrder + 1
	for i, v in pairs(side.Windows) do v.Gui.DisplayOrder = sideDisplayOrder end
	pos = math.min(#side.Windows + 1, pos or 1)
	self.SidePos = pos
	table.insert(side.Windows, pos, self)

	local totalWindows = #side.Windows
	local equalHeight = math.max(100, sidesGui.AbsoluteSize.Y / totalWindows)
	for _, v in ipairs(side.Windows) do
		v.SizeY = equalHeight
	end

	if not silent then
		side.Hidden = false
	end
	updateWindows(silent)
end

function funcs:Close()
	self.Closed = true
	self:SetResizableInternal(false)

	local pos
	pos = table.find(leftSide.Windows, self)
	if pos then table.remove(leftSide.Windows, pos) end
	pos = table.find(rightSide.Windows, self)
	if pos then table.remove(rightSide.Windows, pos) end
	pos = table.find(visibleWindows, self)
	if pos then table.remove(visibleWindows, pos) end

	self.MinimizeAnim.Disable()
	self.CloseAnim.Disable()
	self.ClosedSide = self.Side
	self.Side = nil
	self.OnDeactivate:Fire()

	if not self.Aligned then
		self:StopTweens()
		local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local closeTime = tick()
		self.LastClose = closeTime

		self:DoTween(self.GuiElems.Main, ti, {Size = UDim2.new(0, self.SizeX, 0, 20)})
		self:DoTween(self.GuiElems.Title, ti, {TextTransparency = 1})
		self:DoTween(self.GuiElems.Minimize.ImageLabel, ti, {ImageTransparency = 1})
		self:DoTween(self.GuiElems.Close.ImageLabel, ti, {ImageTransparency = 1})
		self:DoTween(self.GuiElems.TopBar, ti, {BackgroundTransparency = 1})
		self:DoTween(self.GuiElems.Outlines, ti, {ImageTransparency = 1})
		
		task.spawn(function()
			task.wait(0.2)
			if closeTime == self.LastClose then
				self.Gui.Parent = nil
				updateWindows(true)
			end
		end)
	else
		self.Gui.Parent = nil
		updateWindows(true)
	end
end

funcs.Hide = funcs.Close

function funcs:IsVisible()
	return not self.Closed and ((self.Side and not self.Side.Hidden) or not self.Side)
end

function funcs:IsContentVisible()
	return self:IsVisible() and not self.Minimized
end

function funcs:Focus()
	moveToTop(self)
end

function funcs:MoveInBoundary()
	local posX, posY = self.PosX, self.PosY
	local maxX, maxY = sidesGui.AbsoluteSize.X, sidesGui.AbsoluteSize.Y
	posX = math.min(posX, maxX - self.SizeX)
	posY = math.min(posY, maxY - 20)
	self.GuiElems.Main.Position = UDim2.new(0, posX, 0, posY)
end

function funcs:DoTween(...)
	local tween = TweenService:Create(...)
	self.Tweens[#self.Tweens + 1] = tween
	tween:Play()
end

function funcs:StopTweens()
	for i, v in pairs(self.Tweens) do
		v:Cancel()
	end
	self.Tweens = {}
end

function funcs:Show(data)
	data = data or {}
	local align = data.Align
	local position = data.Pos
	local size = data.Size
	local targetSide = (align == "left" and leftSide) or (align == "right" and rightSide)

	if not self.Closed then
		if not self.Aligned then
			self:SetMinimized(false)
		elseif self.Side and not data.Silent then
			sspdockcontainer.SetSideVisible(self.Side, true)
		end
		return
	end

	self.Closed = false
	self.LastClose = tick()
	self.GuiElems.Title.TextTransparency = 0
	self.GuiElems.Minimize.ImageLabel.ImageTransparency = 0
	self.GuiElems.Close.ImageLabel.ImageTransparency = 0
	self.GuiElems.TopBar.BackgroundTransparency = 0
	self.GuiElems.Outlines.ImageTransparency = 0
	self.GuiElems.Minimize.ImageLabel.Image = "rbxassetid://5034768003"
	self.GuiElems.Main.Active = true
	self.GuiElems.Main.Outlines.Visible = true
	self:SetMinimized(false, 3)
	self:SetResizableInternal(true)
	self.MinimizeAnim.Enable()
	self.CloseAnim.Enable()

	if align then
		self:AlignTo(targetSide, position, size, data.Silent)
	else
		if align == nil and self.ClosedSide then
			self:AlignTo(self.ClosedSide, self.SidePos, size, true)
			sspdockcontainer.SetSideVisible(self.ClosedSide, true)
		else
			if table.find(visibleWindows, self) then return end

			self.GuiElems.Main.Size = UDim2.new(0, self.SizeX, 0, 20)
			local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			self:StopTweens()
			self:DoTween(self.GuiElems.Main, ti, {Size = UDim2.new(0, self.SizeX, 0, self.SizeY)})

			self.SizeY = size or self.SizeY
			table.insert(visibleWindows, 1, self)
			updateWindows()
		end
	end

	self.ClosedSide = nil
	self.OnActivate:Fire()
end

function funcs:ShowAndFocus(data)
	self:Show(data)
	RunService.RenderStepped:Wait()
	self:Focus()
end

function sspdockcontainer.ToggleSide(name)
	local side = (name == "left" and leftSide or rightSide)
	side.Hidden = not side.Hidden
	for i, v in pairs(side.Windows) do
		if side.Hidden then
			v.OnDeactivate:Fire()
		else
			v.OnActivate:Fire()
		end
	end
	updateWindows()
end

function sspdockcontainer.SetSideVisible(s, vis)
	local side = (type(s) == "table" and s) or (s == "left" and leftSide or rightSide)
	side.Hidden = not vis
	for i, v in pairs(side.Windows) do
		if side.Hidden then
			v.OnDeactivate:Fire()
		else
			v.OnActivate:Fire()
		end
	end
	updateWindows()
end

function sspdockcontainer.Init()
	if isInitialized then return end
	isInitialized = true

	sidesGui = Instance.new("ScreenGui")
	sidesGui.Name = "sspdockcontainer_Sides"
	sidesGui.IgnoreGuiInset = true
	
	local theme = sspdockcontainer.Theme

	local leftFrame = create({
		{1, "Frame", {Active=true, Name="LeftSide", BackgroundColor3=theme.Background, BorderSizePixel=0}},
		{2, "TextButton", {AutoButtonColor=false, BackgroundColor3=theme.ResizeHandle, BorderSizePixel=0, Font=3, Name="Resizer", Parent={1}, Size=UDim2.new(0, 5, 1, 0), Text="", TextSize=14}},
		{3, "Frame", {BackgroundColor3=theme.Outline, BorderSizePixel=0, Name="Line", Parent={2}, Position=UDim2.new(0, 0, 0, 0), Size=UDim2.new(0, 1, 1, 0)}},
		{4, "TextButton", {AutoButtonColor=false, BackgroundColor3=theme.ResizeHandle, BorderSizePixel=0, Font=3, Name="WindowResizer", Parent={1}, Position=UDim2.new(0, 0, 0, 0), Size=UDim2.new(1, 0, 0, 4), Text="", TextSize=14}},
		{5, "Frame", {BackgroundColor3=theme.Outline, BorderSizePixel=0, Name="Line", Parent={4}, Size=UDim2.new(1, 0, 0, 1)}}
	})
	leftSide.Frame = leftFrame
	leftFrame.Position = UDim2.new(0, -leftSide.Width - 10, 0, 0)
	leftSide.WindowResizer = leftFrame.WindowResizer
	leftFrame.WindowResizer.Parent = nil
	leftFrame.Parent = sidesGui

	local rightFrame = create({
		{1, "Frame", {Active=true, Name="RightSide", BackgroundColor3=theme.Background, BorderSizePixel=0}},
		{2, "TextButton", {AutoButtonColor=false, BackgroundColor3=theme.ResizeHandle, BorderSizePixel=0, Font=3, Name="Resizer", Parent={1}, Size=UDim2.new(0, 5, 1, 0), Text="", TextSize=14}},
		{3, "Frame", {BackgroundColor3=theme.Outline, BorderSizePixel=0, Name="Line", Parent={2}, Position=UDim2.new(0, 4, 0, 0), Size=UDim2.new(0, 1, 1, 0)}},
		{4, "TextButton", {AutoButtonColor=false, BackgroundColor3=theme.ResizeHandle, BorderSizePixel=0, Font=3, Name="WindowResizer", Parent={1}, Position=UDim2.new(0, 0, 0, 0), Size=UDim2.new(1, 0, 0, 4), Text="", TextSize=14}},
		{5, "Frame", {BackgroundColor3=theme.Outline, BorderSizePixel=0, Name="Line", Parent={4}, Size=UDim2.new(1, 0, 0, 1)}}
	})
	rightSide.Frame = rightFrame
	rightFrame.Position = UDim2.new(1, 10, 0, 0)
	rightSide.WindowResizer = rightFrame.WindowResizer
	rightFrame.WindowResizer.Parent = nil
	rightFrame.Parent = sidesGui

	sideResizerHook(leftFrame.Resizer, "H", leftSide)
	sideResizerHook(rightFrame.Resizer, "H", rightSide)

	alignIndicator = Instance.new("ScreenGui")
	alignIndicator.Name = "sspdockcontainer_Indicator"
	alignIndicator.DisplayOrder = 101000
	alignIndicator.IgnoreGuiInset = true
	
	local indicator = Instance.new("Frame", alignIndicator)
	indicator.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	indicator.BorderSizePixel = 0
	indicator.BackgroundTransparency = 0.5
	indicator.Name = "Indicator"
	local corner = Instance.new("UICorner", indicator)
	corner.CornerRadius = UDim.new(0, 10)

	local leftToggle = create({{1, "TextButton", {AutoButtonColor=false, BackgroundColor3=theme.TopBar, BorderColor3=theme.Outline, BorderMode=2, Font=10, Name="LeftToggle", Position=UDim2.new(0, 0, 0, -36), Size=UDim2.new(0, 16, 0, 36), Text="<", TextColor3=theme.Text, TextSize=14}}})
	local rightToggle = leftToggle:Clone()
	rightToggle.Name = "RightToggle"
	rightToggle.Position = UDim2.new(1, -16, 0, -36)
	
	buttonAnim(leftToggle, {Mode = 2, StartColor = theme.TopBar, HoverColor = theme.ButtonHover, PressColor = theme.ButtonPress, OutlineColor = theme.TopBar})
	buttonAnim(rightToggle, {Mode = 2, StartColor = theme.TopBar, HoverColor = theme.ButtonHover, PressColor = theme.ButtonPress, OutlineColor = theme.TopBar})

	leftToggle.MouseButton1Click:Connect(function()
		sspdockcontainer.ToggleSide("left")
	end)

	rightToggle.MouseButton1Click:Connect(function()
		sspdockcontainer.ToggleSide("right")
	end)

	leftToggle.Parent = sidesGui
	rightToggle.Parent = sidesGui

	sidesGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		local maxWidth = math.max(300, sidesGui.AbsoluteSize.X - static.FreeWidth)
		leftSide.Width = math.max(static.MinWidth, math.min(leftSide.Width, maxWidth - rightSide.Width))
		rightSide.Width = math.max(static.MinWidth, math.min(rightSide.Width, maxWidth - leftSide.Width))
		for i = 1, #visibleWindows do
			visibleWindows[i]:MoveInBoundary()
		end
		updateWindows(true)
	end)

	sidesGui.DisplayOrder = sideDisplayOrder - 1
	sidesGui.Parent = guiHolder
	updateSideFrames()
end

function sspdockcontainer.new(title, sizeX, sizeY)
	sspdockcontainer.Init()
	
	local obj = setmetatable({
		Minimized = false,
		Dragging = false,
		Resizing = false,
		Aligned = false,
		Draggable = true,
		Resizable = true,
		ResizableInternal = true,
		Alignable = true,
		Closed = true,
		SizeX = sizeX or 300,
		SizeY = sizeY or 300,
		MinX = 200,
		MinY = 200,
		PosX = 0,
		PosY = 0,
		GuiElems = {},
		Tweens = {},
		Elements = {},
		OnActivate = Signal.new(),
		OnDeactivate = Signal.new(),
		OnMinimize = Signal.new(),
		OnRestore = Signal.new()
	}, windowMt)
	
	obj.Gui = createGui(obj)
	table.insert(sspdockcontainer.AllDocks, obj)
	if title then obj:SetTitle(title) end
	return obj
end

return sspdockcontainer
