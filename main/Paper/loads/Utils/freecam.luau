local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local enabled = false
local baseSpeed = 50
local speed = baseSpeed
local speedStep = 15
local minSpeed = 5
local maxSpeed = 500

local velocity = Vector3.new()
local targetVelocity = Vector3.new()
local moveAcceleration = 10

local yaw = 0
local pitch = 0
local currentYaw = 0
local currentPitch = 0
local lookSensitivity = 0.002
local rotSmoothness = 15

local fovTweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
local hiddenGuis = {}

local function setCharacterState(frozen)
	local char = player.Character
	if not char then return end
	
	local root = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	
	if root then
		root.Anchored = frozen
	end
	if hum then
		hum.AutoRotate = not frozen
	end
end

local function setGuisEnabled(state)
	pcall(function()
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, state)
	end)
	
	local playerGui = player:FindFirstChildOfClass("PlayerGui")
	if playerGui then
		if not state then
			table.clear(hiddenGuis)
			for _, gui in ipairs(playerGui:GetChildren()) do
				if gui:IsA("ScreenGui") and gui.Enabled then
					hiddenGuis[gui] = true
					gui.Enabled = false
				end
			end
		else
			for gui in pairs(hiddenGuis) do
				if gui.Parent then
					gui.Enabled = true
				end
			end
			table.clear(hiddenGuis)
		end
	end
end

local function toggleFreecam()
	enabled = not enabled

	if enabled then
		setCharacterState(true)
		setGuisEnabled(false)

		local rx, ry, rz = camera.CFrame:ToEulerAnglesYXZ()
		pitch = rx
		yaw = ry
		currentPitch = pitch
		currentYaw = yaw
		velocity = Vector3.new()
		speed = baseSpeed

		camera.CameraType = Enum.CameraType.Scriptable
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter

		TweenService:Create(camera, fovTweenInfo, {FieldOfView = 90}):Play()
	else
		setCharacterState(false)
		setGuisEnabled(true)

		camera.CameraType = Enum.CameraType.Custom
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default

		TweenService:Create(camera, fovTweenInfo, {FieldOfView = 70}):Play()
	end
end

UserInputService.InputBegan:Connect(function(input, processed)
	local shiftHeld = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
	
	if input.KeyCode == Enum.KeyCode.P and shiftHeld then
		toggleFreecam()
	end

	if enabled and shiftHeld and input.UserInputType == Enum.UserInputType.MouseButton3 then
		speed = baseSpeed
	end
end)

UserInputService.InputChanged:Connect(function(input, processed)
	if not enabled then return end

	if input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Delta
		yaw = yaw - delta.X * lookSensitivity
		pitch = math.clamp(pitch - delta.Y * lookSensitivity, -math.pi / 2 + 0.01, math.pi / 2 - 0.01)
	elseif input.UserInputType == Enum.UserInputType.MouseWheel then
		local shiftHeld = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
		if shiftHeld then
			speed = math.clamp(speed + (input.Position.Z * speedStep), minSpeed, maxSpeed)
		end
	end
end)

RunService.RenderStepped:Connect(function(dt)
	if not enabled then return end

	local rotAlpha = 1 - math.exp(-dt * rotSmoothness)
	currentYaw = currentYaw + (yaw - currentYaw) * rotAlpha
	currentPitch = currentPitch + (pitch - currentPitch) * rotAlpha

	local rotationCFrame = CFrame.Angles(0, currentYaw, 0) * CFrame.Angles(currentPitch, 0, 0)

	local moveDir = Vector3.new()
	if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Vector3.new(0, 0, -1) end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir + Vector3.new(0, 0, 1) end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir + Vector3.new(-1, 0, 0) end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Vector3.new(1, 0, 0) end
	if UserInputService:IsKeyDown(Enum.KeyCode.E) then moveDir = moveDir + Vector3.new(0, 1, 0) end
	if UserInputService:IsKeyDown(Enum.KeyCode.Q) then moveDir = moveDir + Vector3.new(0, -1, 0) end

	if moveDir.Magnitude > 0 then
		moveDir = moveDir.Unit
	end

	targetVelocity = rotationCFrame:VectorToWorldSpace(moveDir) * speed
	
	local moveAlpha = 1 - math.exp(-dt * moveAcceleration)
	velocity = velocity:Lerp(targetVelocity, moveAlpha)

	camera.CFrame = CFrame.new(camera.CFrame.Position + velocity * dt) * rotationCFrame
end)
