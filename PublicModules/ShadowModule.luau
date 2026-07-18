local TweenService = game:GetService("TweenService")

local ShadowModule = {}
ShadowModule.__index = ShadowModule

local DEFAULT_IMAGE = "rbxassetid://125999138090687"
local DEFAULT_SLICE_CENTER = Rect.new(160, 160, 352, 352)

local Defaults = {
	Image = DEFAULT_IMAGE,
	ImageColor3 = Color3.new(0, 0, 0),
	ImageTransparency = 0.5,
	ScaleType = Enum.ScaleType.Slice,
	SliceCenter = DEFAULT_SLICE_CENTER,
	Offset = Vector2.new(10, 10),
	PositionOffset = Vector2.new(0, 4),
	ZIndexOffset = -1,
}

function ShadowModule.new(target: GuiObject, properties: {[string]: any}?)
	assert(target and target:IsA("GuiObject"), "ShadowModule.new requires a GuiObject")

	local self = setmetatable({}, ShadowModule)

	self.Target = target
	self.Settings = table.clone(Defaults)

	if properties then
		for key, value in properties do
			self.Settings[key] = value
		end
	end

	self.Shadow = Instance.new("ImageLabel")
	self.Shadow.Name = "Shadow"
	self.Shadow.BackgroundTransparency = 1
	self.Shadow.BorderSizePixel = 0
	self.Shadow.Parent = target.Parent

	self._connections = {}

	self:Apply()

	table.insert(self._connections, target:GetPropertyChangedSignal("Position"):Connect(function()
		self:Sync()
	end))

	table.insert(self._connections, target:GetPropertyChangedSignal("Size"):Connect(function()
		self:Sync()
	end))

	table.insert(self._connections, target:GetPropertyChangedSignal("AnchorPoint"):Connect(function()
		self:Sync()
	end))

	table.insert(self._connections, target:GetPropertyChangedSignal("Rotation"):Connect(function()
		self:Sync()
	end))

	table.insert(self._connections, target:GetPropertyChangedSignal("ZIndex"):Connect(function()
		self:Sync()
	end))

	table.insert(self._connections, target:GetPropertyChangedSignal("Parent"):Connect(function()
		self.Shadow.Parent = target.Parent
	end))

	table.insert(self._connections, target.AncestryChanged:Connect(function(_, parent)
		if not parent then
			self:Destroy()
		end
	end))

	table.insert(self._connections, target.Destroying:Connect(function()
		self:Destroy()
	end))

	return self
end

function ShadowModule:Set(prop: string, value: any)
	self.Settings[prop] = value
	self:Apply()
	return self
end

function ShadowModule:SetProperties(properties: {[string]: any})
	for key, value in properties do
		self.Settings[key] = value
	end
	self:Apply()
	return self
end

function ShadowModule:Apply()
	self.Shadow.Image = self.Settings.Image
	self.Shadow.ImageColor3 = self.Settings.ImageColor3
	self.Shadow.ImageTransparency = self.Settings.ImageTransparency
	self.Shadow.ScaleType = self.Settings.ScaleType
	self.Shadow.SliceCenter = self.Settings.SliceCenter
	self:Sync()
	return self
end

function ShadowModule:Sync()
	local target = self.Target
	local offset = self.Settings.Offset
	local posOffset = self.Settings.PositionOffset

	self.Shadow.AnchorPoint = target.AnchorPoint
	self.Shadow.Rotation = target.Rotation
	self.Shadow.ZIndex = target.ZIndex + self.Settings.ZIndexOffset

	self.Shadow.Size = UDim2.new(
		target.Size.X.Scale,
		target.Size.X.Offset + offset.X * 2,
		target.Size.Y.Scale,
		target.Size.Y.Offset + offset.Y * 2
	)

	self.Shadow.Position = UDim2.new(
		target.Position.X.Scale,
		target.Position.X.Offset - offset.X + posOffset.X,
		target.Position.Y.Scale,
		target.Position.Y.Offset - offset.Y + posOffset.Y
	)

	return self
end

function ShadowModule:Animate(tweenInfo: TweenInfo, goal: {[string]: any})
	local tween = TweenService:Create(self.Shadow, tweenInfo, goal)
	tween:Play()
	return tween
end

function ShadowModule:Instance()
	return self.Shadow
end

function ShadowModule:Destroy()
	for _, connection in self._connections do
		connection:Disconnect()
	end
	table.clear(self._connections)

	if self.Shadow then
		self.Shadow:Destroy()
	end
end

return ShadowModule
