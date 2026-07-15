local PaperAPI = ...
local RegisterCommand = PaperAPI.RegisterCommand
local Notify = PaperAPI.Notify
local GetPlayer = PaperAPI.GetPlayer
local SetUIExpanded = PaperAPI.SetUIExpanded
local SetWatermarkVisible = PaperAPI.SetWatermarkVisible
local SetNotifsEnabled = PaperAPI.SetNotifsEnabled
local TracerContainer = PaperAPI.TracerContainer
local TargetGui = PaperAPI.TargetGui

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local activeESPs = {}
local flyConn = nil
local flyPart = nil
local flyGyro = nil

-- Freecam Variables
local fcEnabled = false
local fcBaseSpeed = 50
local fcSpeed = fcBaseSpeed
local fcSpeedStep = 15
local fcMinSpeed = 5
local fcMaxSpeed = 500

local fcVelocity = Vector3.new()
local fcTargetVelocity = Vector3.new()
local fcMoveAcceleration = 10

local fcYaw = 0
local fcPitch = 0
local fcCurrentYaw = 0
local fcCurrentPitch = 0
local fcLookSensitivity = 0.002
local fcRotSmoothness = 15

local fovTweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
local hiddenGuis = {}

local function setCharacterState(frozen)
	local char = LocalPlayer.Character
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
	
	local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	if playerGui then
		if not state then
			table.clear(hiddenGuis)
			for _, gui in ipairs(playerGui:GetChildren()) do
				if gui:IsA("ScreenGui") and gui.Enabled and gui.Name ~= "PaperAdmin" and gui.Name ~= "Paper_ESP_GUI" then
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
	fcEnabled = not fcEnabled
	local cam = Workspace.CurrentCamera

	if fcEnabled then
		setCharacterState(true)
		setGuisEnabled(false)

		local rx, ry, rz = cam.CFrame:ToEulerAnglesYXZ()
		fcPitch = rx
		fcYaw = ry
		fcCurrentPitch = fcPitch
		fcCurrentYaw = fcYaw
		fcVelocity = Vector3.new()
		fcSpeed = fcBaseSpeed

		cam.CameraType = Enum.CameraType.Scriptable
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter

		TweenService:Create(cam, fovTweenInfo, {FieldOfView = 90}):Play()
	else
		setCharacterState(false)
		setGuisEnabled(true)

		cam.CameraType = Enum.CameraType.Custom
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default

		TweenService:Create(cam, fovTweenInfo, {FieldOfView = 70}):Play()
	end
end

UserInputService.InputBegan:Connect(function(input, processed)
	local shiftHeld = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
	
	if input.KeyCode == Enum.KeyCode.P and shiftHeld and not processed then
		toggleFreecam()
		if fcEnabled then Notify("Freecam", "Freecam Enabled") else Notify("Freecam", "Freecam Disabled") end
	end

	if fcEnabled and shiftHeld and input.UserInputType == Enum.UserInputType.MouseButton3 then
		fcSpeed = fcBaseSpeed
	end
end)

UserInputService.InputChanged:Connect(function(input, processed)
	if not fcEnabled then return end

	if input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Delta
		fcYaw = fcYaw - delta.X * fcLookSensitivity
		fcPitch = math.clamp(fcPitch - delta.Y * fcLookSensitivity, -math.pi / 2 + 0.01, math.pi / 2 - 0.01)
	elseif input.UserInputType == Enum.UserInputType.MouseWheel then
		local shiftHeld = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
		if shiftHeld then
			fcSpeed = math.clamp(fcSpeed + (input.Position.Z * fcSpeedStep), fcMinSpeed, fcMaxSpeed)
		end
	end
end)

RunService.RenderStepped:Connect(function(dt)
	if not fcEnabled then return end
	local cam = Workspace.CurrentCamera
	if not cam then return end

	local rotAlpha = 1 - math.exp(-dt * fcRotSmoothness)
	fcCurrentYaw = fcCurrentYaw + (fcYaw - fcCurrentYaw) * rotAlpha
	fcCurrentPitch = fcCurrentPitch + (fcPitch - fcCurrentPitch) * rotAlpha

	local rotationCFrame = CFrame.Angles(0, fcCurrentYaw, 0) * CFrame.Angles(fcCurrentPitch, 0, 0)

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

	fcTargetVelocity = rotationCFrame:VectorToWorldSpace(moveDir) * fcSpeed
	
	local moveAlpha = 1 - math.exp(-dt * fcMoveAcceleration)
	fcVelocity = fcVelocity:Lerp(fcTargetVelocity, moveAlpha)

	cam.CFrame = CFrame.new(cam.CFrame.Position + fcVelocity * dt) * rotationCFrame
end)

-- Command Registry 

RegisterCommand("expand", {"open", "ui"}, "", "none", "Expands the UI to show all commands", function(args)
	SetUIExpanded(true)
end)

RegisterCommand("minimize", {"close", "shrink"}, "", "none", "Minimizes the UI back to normal", function(args)
	SetUIExpanded(false)
end)

RegisterCommand("rejoin", {"rj"}, "", "none", "Rejoins the current server", function(args)
	Notify("Server", "Rejoining...")
	TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

RegisterCommand("jobid", {"job"}, "", "none", "Copies server JobId to clipboard", function(args)
	if setclipboard then
		setclipboard(tostring(game.JobId))
		Notify("Server", "JobId copied to clipboard")
	else
		Notify("Error", "Your executor doesn't support setclipboard")
	end
end)

RegisterCommand("joinlink", {"link"}, "", "none", "Copies server join link to clipboard", function(args)
	if setclipboard then
		setclipboard("roblox://experiences/start?placeId=" .. tostring(game.PlaceId) .. "&gameInstanceId=" .. tostring(game.JobId))
		Notify("Server", "Join link copied to clipboard")
	else
		Notify("Error", "Your executor doesn't support setclipboard")
	end
end)

RegisterCommand("fov", {"fieldofview"}, "[num]", "none", "Changes Camera FOV", function(args)
	local num = tonumber(args[2])
	if num then
		Workspace.CurrentCamera.FieldOfView = num
		Notify("Camera", "FOV set to " .. tostring(num))
	end
end)

RegisterCommand("sit", {}, "", "none", "Makes your character sit", function(args)
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.Sit = true
	end
end)

RegisterCommand("locate", {"find", "esp"}, "[player] [tracer?]", "player", "Creates ESP and optional tracer", function(args)
	local target = GetPlayer(args[2])
	if not target then return Notify("Error", "Player not found") end
	if target == LocalPlayer then return Notify("Error", "Cannot locate yourself") end
	
	local wantsTracer = false
	if args[3] then
		local t = string.lower(tostring(args[3]))
		if t == "true" or t == "yes" or t == "tracer" or t == "t" then
			wantsTracer = true
		end
	end
	
	if activeESPs[target] then
		activeESPs[target].Cleanup()
	end
	
	local espData = {}
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "Paper_ESP_GUI"
	billboard.AlwaysOnTop = true
	billboard.Size = UDim2.new(0, 150, 0, 40)
	billboard.Parent = TargetGui
	
	local textLabel = Instance.new("TextLabel", billboard)
	textLabel.BackgroundTransparency = 1
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.Font = Enum.Font.GothamMedium
	textLabel.TextSize = 12
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	textLabel.TextStrokeTransparency = 0
	
	local tracerLine = Instance.new("Frame")
	tracerLine.AnchorPoint = Vector2.new(0.5, 0.5)
	tracerLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	tracerLine.BorderSizePixel = 0
	tracerLine.Visible = false
	tracerLine.Parent = TracerContainer
	
	local function Cleanup()
		billboard:Destroy()
		tracerLine:Destroy()
		if espData.Conn then espData.Conn:Disconnect() end
		activeESPs[target] = nil
	end
	espData.Cleanup = Cleanup
	
	espData.Conn = RunService.RenderStepped:Connect(function()
		if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
			textLabel.Text = target.Name .. "\n[Loading...]"
			tracerLine.Visible = false
			return
		end
		
		local targetHRP = target.Character.HumanoidRootPart
		billboard.Adornee = targetHRP
		
		local lp = LocalPlayer.Character
		if lp and lp:FindFirstChild("HumanoidRootPart") then
			local dist = math.floor((lp.HumanoidRootPart.Position - targetHRP.Position).Magnitude)
			textLabel.Text = target.Name .. "\n[" .. dist .. "s]"
		else
			textLabel.Text = target.Name
		end
		
		if wantsTracer then
			local cam = Workspace.CurrentCamera
			if cam then
				local pos, onScreen = cam:WorldToViewportPoint(targetHRP.Position)
				if onScreen then
					tracerLine.Visible = true
					local from = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
					local to = Vector2.new(pos.X, pos.Y)
					local dist = (to - from).Magnitude
					tracerLine.Size = UDim2.new(0, dist, 0, 1)
					tracerLine.Position = UDim2.new(0, (from.X + to.X) / 2, 0, (from.Y + to.Y) / 2)
					tracerLine.Rotation = math.deg(math.atan2(to.Y - from.Y, to.X - from.X))
				else
					tracerLine.Visible = false
				end
			end
		else
			tracerLine.Visible = false
		end
	end)
	activeESPs[target] = espData
	Notify("Locate", "Tracking " .. target.Name)
end)

RegisterCommand("unlocate", {"unesp"}, "", "none", "Removes all locates", function(args)
	local count = 0
	for _, esp in pairs(activeESPs) do
		esp.Cleanup()
		count = count + 1
	end
	Notify("Locate", "Removed " .. tostring(count) .. " tracker(s)")
end)

RegisterCommand("hidestats", {"hwm"}, "", "none", "Hides the Paper watermark", function(args)
	SetWatermarkVisible(false)
	Notify("Settings", "Watermark hidden.")
end)

RegisterCommand("showstats", {"swm"}, "", "none", "Shows the Paper watermark", function(args)
	SetWatermarkVisible(true)
	Notify("Settings", "Watermark revealed.")
end)

RegisterCommand("goto", {"tp", "to"}, "[player]", "player", "Teleports to target", function(args)
	local target = GetPlayer(args[2])
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3) 
			Notify("Teleport", "Teleported to " .. target.DisplayName)
		end
	end
end)

RegisterCommand("reset", {"kill", "die"}, "", "none", "Kills your character", function(args)
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.Health = 0
		Notify("Reset", "You reset your character.")
	end
end)

RegisterCommand("speed", {"ws", "walkspeed"}, "[num]", "none", "Changes WalkSpeed", function(args)
	local amt = tonumber(args[2])
	if amt and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = amt
		Notify("Speed", "WalkSpeed set to " .. tostring(amt))
	end
end)

RegisterCommand("jumppower", {"jp"}, "[num]", "none", "Changes JumpPower", function(args)
	local amt = tonumber(args[2])
	if amt and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.UseJumpPower = true
		LocalPlayer.Character.Humanoid.JumpPower = amt
		Notify("JumpPower", "JumpPower set to " .. tostring(amt))
	end
end)

RegisterCommand("fly", {"flight"}, "", "none", "Enables smooth flight mode", function(args)
	if flyConn then flyConn:Disconnect() end
	if flyPart then flyPart:Destroy() end
	if flyGyro then flyGyro:Destroy() end

	local char = LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
		for _, track in ipairs(char.Humanoid:GetPlayingAnimationTracks()) do
			track:Stop()
		end

		flyPart = Instance.new("BodyVelocity")
		flyPart.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		flyPart.Parent = char.HumanoidRootPart
		flyGyro = Instance.new("BodyGyro")
		flyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		flyGyro.P = 9e4
		flyGyro.Parent = char.HumanoidRootPart

		local speed = 50
		flyConn = RunService.RenderStepped:Connect(function()
			local cam = Workspace.CurrentCamera
			local moveDir = Vector3.new(0, 0, 0)
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
			if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
			flyPart.Velocity = moveDir * speed
			flyGyro.CFrame = cam.CFrame
		end)
		Notify("Flight", "Fly enabled. Use WASD + Space/Shift")
	end
end)

RegisterCommand("unfly", {"nofly"}, "", "none", "Disables flight mode", function(args)
	if flyConn then flyConn:Disconnect() flyConn = nil end
	if flyPart then flyPart:Destroy() flyPart = nil end
	if flyGyro then flyGyro:Destroy() flyGyro = nil end
	Notify("Flight", "Fly disabled.")
end)

RegisterCommand("noclip", {"nc"}, "", "none", "Go through walls", function(args)
	if _G.PaperNoclip then _G.PaperNoclip:Disconnect() end
	_G.PaperNoclip = RunService.Stepped:Connect(function()
		if LocalPlayer.Character then
			for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
				if v:IsA("BasePart") then v.CanCollide = false end
			end
		end
	end)
	Notify("Movement", "Noclip Enabled")
end)

RegisterCommand("clip", {"c"}, "", "none", "Disables noclip", function(args)
	if _G.PaperNoclip then 
		_G.PaperNoclip:Disconnect() 
		_G.PaperNoclip = nil
		Notify("Movement", "Noclip Disabled")
	end
end)

RegisterCommand("freecam", {"fc"}, "", "none", "Toggles freecam mode", function(args)
	toggleFreecam()
	if fcEnabled then 
		Notify("Freecam", "Freecam Enabled. You can also use Shift+P to toggle.")
	else
		Notify("Freecam", "Freecam Disabled.")
	end
end)

RegisterCommand("disablenotifs", {"nonotifs"}, "", "none", "Hides notifications", function(args)
	SetNotifsEnabled(false)
end)

RegisterCommand("enablenotifs", {}, "", "none", "Shows notifications", function(args)
	SetNotifsEnabled(true)
	Notify("Settings", "Notifications Enabled")
end)

RegisterCommand("notepad", {"notes", "editor"}, "", "none", "Opens the Paper Notepad script editor", function(args)
	Notify("Notepad", "Loading Notepad...")
	local success, err = pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/slavtherookie/Slav/refs/heads/main/main/Paper/loads/Utils/extras/Notepad.luau"))()
	end)
	
	if not success then
		Notify("Error", "Failed to load Notepad: " .. tostring(err))
	end
end)
