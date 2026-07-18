local Builder = {}
Builder.__index = Builder

local Classes = {
	"Part",
	"WedgePart",
	"CornerWedgePart",
	"MeshPart",
	"TrussPart",
	"SpawnLocation"
}

local Materials = {
	Enum.Material.Plastic,
	Enum.Material.Wood,
	Enum.Material.Slate,
	Enum.Material.Concrete,
	Enum.Material.Cobblestone,
	Enum.Material.Brick,
	Enum.Material.Sand,
	Enum.Material.Fabric,
	Enum.Material.Ice,
	Enum.Material.Glass,
	Enum.Material.SmoothPlastic,
	Enum.Material.Neon,
	Enum.Material.WoodPlanks,
	Enum.Material.Marble,
	Enum.Material.Granite,
	Enum.Material.Pebble,
	Enum.Material.CorrodedMetal,
	Enum.Material.DiamondPlate,
	Enum.Material.Foil,
	Enum.Material.Metal,
	Enum.Material.Grass,
	Enum.Material.LeafyGrass,
	Enum.Material.Sandstone,
	Enum.Material.Rock,
	Enum.Material.Basalt,
	Enum.Material.CrackedLava,
	Enum.Material.Glacier,
	Enum.Material.Snow,
	Enum.Material.Mud,
	Enum.Material.Ground,
	Enum.Material.Asphalt,
	Enum.Material.Salt,
	Enum.Material.Limestone,
	Enum.Material.Pavement,
	Enum.Material.ForceField,
	Enum.Material.Air,
	Enum.Material.Water
}

local ClassToId = {}
for i, name in Classes do
	ClassToId[name] = i
end

local MaterialToId = {}
for i, mat in Materials do
	MaterialToId[mat] = i
end

function Builder.new(className: string)
	local self = setmetatable({}, Builder)
	self.Instance = Instance.new(className)
	return self
end

function Builder:Set(prop: string, value: any)
	self.Instance[prop] = value
	return self
end

function Builder:SetProperties(properties: {[string]: any})
	for k, v in properties do
		self.Instance[k] = v
	end
	return self
end

function Builder:Children(children: {any})
	for _, child in children do
		if typeof(child) == "Instance" then
			child.Parent = self.Instance
		elseif type(child) == "table" and child.Instance then
			child.Instance.Parent = self.Instance
		end
	end
	return self
end

function Builder:Parent(parent: Instance)
	self.Instance.Parent = parent
	return self
end

function Builder:Build()
	return self.Instance
end

function Builder.serialize(instances: {Instance}): buffer
	local list = {}
	for _, inst in instances do
		if inst:IsA("BasePart") then
			table.insert(list, inst)
		end
	end

	local count = #list
	local size = 4 + (count * 96)
	local buf = buffer.create(size)

	buffer.writeu32(buf, 0, count)

	local offset = 4
	for _, inst in list do
		local classId = ClassToId[inst.ClassName] or 1
		local cf = inst.CFrame
		local sizeVec = inst.Size
		local qx, qy, qz, qw = cf:ToQuaternion()

		local r = math.clamp(math.round(inst.Color.R * 255), 0, 255)
		local g = math.clamp(math.round(inst.Color.G * 255), 0, 255)
		local b = math.clamp(math.round(inst.Color.B * 255), 0, 255)
		local colorInt = bit32.bor(bit32.lshift(r, 16), bit32.lshift(g, 8), b)

		local materialId = MaterialToId[inst.Material] or 1

		local flags = 0
		if inst.Anchored then flags = bit32.bor(flags, 1) end
		if inst.CanCollide then flags = bit32.bor(flags, 2) end
		if inst.CastShadow then flags = bit32.bor(flags, 4) end

		buffer.writeu32(buf, offset, classId)
		buffer.writef64(buf, offset + 4, cf.Position.X)
		buffer.writef64(buf, offset + 12, cf.Position.Y)
		buffer.writef64(buf, offset + 20, cf.Position.Z)
		buffer.writef64(buf, offset + 28, sizeVec.X)
		buffer.writef64(buf, offset + 36, sizeVec.Y)
		buffer.writef64(buf, offset + 44, sizeVec.Z)
		buffer.writef64(buf, offset + 52, qx)
		buffer.writef64(buf, offset + 60, qy)
		buffer.writef64(buf, offset + 68, qz)
		buffer.writef64(buf, offset + 76, qw)
		buffer.writeu32(buf, offset + 84, colorInt)
		buffer.writeu32(buf, offset + 88, materialId)
		buffer.writeu32(buf, offset + 92, flags)

		offset = offset + 96
	end

	return buf
end

function Builder.deserialize(buf: buffer): {Instance}
	local count = buffer.readu32(buf, 0)
	local instances = table.create(count)
	local offset = 4

	for i = 1, count do
		local classId = buffer.readu32(buf, offset)
		local className = Classes[classId] or "Part"

		local px = buffer.readf64(buf, offset + 4)
		local py = buffer.readf64(buf, offset + 12)
		local pz = buffer.readf64(buf, offset + 20)

		local sx = buffer.readf64(buf, offset + 28)
		local sy = buffer.readf64(buf, offset + 36)
		local sz = buffer.readf64(buf, offset + 44)

		local qx = buffer.readf64(buf, offset + 52)
		local qy = buffer.readf64(buf, offset + 60)
		local qz = buffer.readf64(buf, offset + 68)
		local qw = buffer.readf64(buf, offset + 76)

		local colorInt = buffer.readu32(buf, offset + 84)
		local materialId = buffer.readu32(buf, offset + 88)
		local flags = buffer.readu32(buf, offset + 92)

		local r = bit32.band(bit32.rshift(colorInt, 16), 0xFF) / 255
		local g = bit32.band(bit32.rshift(colorInt, 8), 0xFF) / 255
		local b = bit32.band(colorInt, 0xFF) / 255

		local inst = Instance.new(className)
		inst.CFrame = CFrame.new(px, py, pz, qx, qy, qz, qw)
		inst.Size = Vector3.new(sx, sy, sz)
		inst.Color = Color3.new(r, g, b)

		local mat = Materials[materialId]
		if mat then
			inst.Material = mat
		end

		inst.Anchored = bit32.band(flags, 1) ~= 0
		inst.CanCollide = bit32.band(flags, 2) ~= 0
		inst.CastShadow = bit32.band(flags, 4) ~= 0

		table.insert(instances, inst)
		offset = offset + 96
	end

	return instances
end

return Builder
