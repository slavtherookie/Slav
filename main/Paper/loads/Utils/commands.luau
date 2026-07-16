local PaperAPI = ...
local OriginalRegisterCommand = PaperAPI.RegisterCommand
local Notify = PaperAPI.Notify
local GetPlayer = PaperAPI.GetPlayer
local SetUIExpanded = PaperAPI.SetUIExpanded
local SetWatermarkVisible = PaperAPI.SetWatermarkVisible
local SetNotifsEnabled = PaperAPI.SetNotifsEnabled
local TracerContainer = PaperAPI.TracerContainer
local TargetGui = PaperAPI.TargetGui

local LocalCmdRegistry = {}

local function RegisterCommand(name, aliases, argHint, argType, description, callback)
	table.insert(LocalCmdRegistry, {
		Name = name,
		Aliases = aliases,
		ArgHint = argHint,
		ArgType = argType,
		Description = description
	})
	OriginalRegisterCommand(name, aliases, argHint, argType, description, callback)
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local activeESPs = {}
local flyConn = nil
local flyPart = nil
local flyGyro = nil
local spinConn = nil
local floatPart = nil
local clickTpConn = nil
local bhopConn = nil
local fbConn = nil
local invisibleConn = nil

local savedPosition = nil
local originalCamSubject = nil
local oldLighting = {}
local isFullbright = false

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

local function getRoot(char)
	if not char then return nil end
	return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function setCharacterState(frozen)
	local char = LocalPlayer.Character
	if not char then return end
	local root = getRoot(char)
	local hum = char:FindFirstChildOfClass("Humanoid")
	if root then root.Anchored = frozen end
	if hum then hum.AutoRotate = not frozen end
end

local function setGuisEnabled(state)
	pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, state) end)
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
				if gui.Parent then gui.Enabled = true end
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
	if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
	fcTargetVelocity = rotationCFrame:VectorToWorldSpace(moveDir) * fcSpeed
	local moveAlpha = 1 - math.exp(-dt * fcMoveAcceleration)
	fcVelocity = fcVelocity:Lerp(fcTargetVelocity, moveAlpha)
	cam.CFrame = CFrame.new(cam.CFrame.Position + fcVelocity * dt) * rotationCFrame
end)

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
		if t == "true" or t == "yes" or t == "tracer" or t == "t" then wantsTracer = true end
	end
	if activeESPs[target] then activeESPs[target].Cleanup() end
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
	if target and target.Character and getRoot(target.Character) then
		if LocalPlayer.Character and getRoot(LocalPlayer.Character) then
			getRoot(LocalPlayer.Character).CFrame = getRoot(target.Character).CFrame * CFrame.new(0, 0, 3)
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
	if char and getRoot(char) and char:FindFirstChild("Humanoid") then
		for _, track in ipairs(char.Humanoid:GetPlayingAnimationTracks()) do track:Stop() end
		flyPart = Instance.new("BodyVelocity")
		flyPart.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		flyPart.Parent = getRoot(char)
		flyGyro = Instance.new("BodyGyro")
		flyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		flyGyro.P = 9e4
		flyGyro.Parent = getRoot(char)
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
	if _G.PaperNoclip then _G.PaperNoclip:Disconnect() _G.PaperNoclip = nil end
	Notify("Movement", "Noclip Disabled")
end)

RegisterCommand("freecam", {"fc"}, "", "none", "Toggles freecam mode", function(args)
	toggleFreecam()
	if fcEnabled then
		Notify("Freecam", "Freecam Enabled.")
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
		local src = game:HttpGet("https://raw.githubusercontent.com/slavtherookie/Slav/refs/heads/main/main/Paper/loads/Utils/extras/Notepad.luau")
		local fn = loadstring(src)
		if fn then fn() else Notify("Error", "Failed to compile Notepad") end
	end)
	if not success then Notify("Error", "Failed to load Notepad: " .. tostring(err)) end
end)

RegisterCommand("cmds", {"commands", "help"}, "", "none", "Opens the Commands UI", function(args)
	Notify("Commands", "Loading Commands UI...")
	local success, err = pcall(function()
		local src = game:HttpGet("https://raw.githubusercontent.com/slavtherookie/Slav/refs/heads/main/main/Paper/loads/Utils/extras/cmds.luau")
		local fn = loadstring(src)
		if fn then fn(LocalCmdRegistry) else Notify("Error", "Failed to compile Commands UI") end
	end)
	if not success then Notify("Error", "Failed to load Commands UI: " .. tostring(err)) end
end)

RegisterCommand("info", {"whois", "playerinfo"}, "[player]", "player", "Displays detailed player information", function(args)
	local target = GetPlayer(args[2])
	if not target then return Notify("Error", "Player not found") end
	Notify("Info", "Loading profile for " .. target.DisplayName .. "...")
	local success, err = pcall(function()
		local src = game:HttpGet("https://raw.githubusercontent.com/slavtherookie/Slav/refs/heads/main/main/Paper/loads/Utils/extras/PlayerInfo.luau")
		local fn = loadstring(src)
		if fn then fn()(target) else Notify("Error", "Failed to compile PlayerInfo source") end
	end)
	if not success then Notify("Error", "Information UI: " .. tostring(err)) end
end)

RegisterCommand("bettersync", {"bsync"}, "[key]", "none", "Enables BetterSync with optional key", function(args)
	local key = args[2] or "G"
	local success, err = pcall(function()
		local src = game:HttpGet("https://raw.githubusercontent.com/slavtherookie/Slav/refs/heads/main/main/Paper/loads/Utils/extras/BetterSync.luau")
		local fn = loadstring(src)
		if fn then fn("start", key) else Notify("Error", "Failed to compile BetterSync") end
	end)
	if success then Notify("BetterSync", "Executed BetterSync (Key: " .. string.upper(key) .. ")") else Notify("Error", "Failed to load BetterSync: " .. tostring(err)) end
end)

RegisterCommand("unbettersync", {"unbsync"}, "", "none", "Disables BetterSync", function(args)
	local success, err = pcall(function()
		local src = game:HttpGet("https://raw.githubusercontent.com/slavtherookie/Slav/refs/heads/main/main/Paper/loads/Utils/extras/BetterSync.luau")
		local fn = loadstring(src)
		if fn then fn("cleanup") else Notify("Error", "Failed to compile BetterSync") end
	end)
	if success then Notify("BetterSync", "Disabled BetterSync") else Notify("Error", "Failed to disable BetterSync") end
end)

RegisterCommand("spectate", {"view"}, "[player]", "player", "Spectates a player", function(args)
	local target = GetPlayer(args[2])
	if target and target.Character and target.Character:FindFirstChild("Humanoid") then
		originalCamSubject = Workspace.CurrentCamera.CameraSubject
		Workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
		Notify("Camera", "Spectating " .. target.DisplayName)
	end
end)

RegisterCommand("unspectate", {"unview"}, "", "none", "Stops spectating", function(args)
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
		Notify("Camera", "Stopped spectating")
	end
end)

RegisterCommand("fullbright", {"fb"}, "", "none", "Maxes out lighting", function(args)
	if not isFullbright then
		oldLighting.Ambient = Lighting.Ambient
		oldLighting.Brightness = Lighting.Brightness
		oldLighting.ClockTime = Lighting.ClockTime
		oldLighting.FogEnd = Lighting.FogEnd
		oldLighting.GlobalShadows = Lighting.GlobalShadows
		isFullbright = true
		fbConn = RunService.RenderStepped:Connect(function()
			Lighting.Ambient = Color3.new(1, 1, 1)
			Lighting.Brightness = 2
			Lighting.ClockTime = 14
			Lighting.FogEnd = 100000
			Lighting.GlobalShadows = false
		end)
		Notify("Graphics", "Fullbright Enabled")
	end
end)

RegisterCommand("unfullbright", {"unfb"}, "", "none", "Restores original lighting", function(args)
	if isFullbright then
		isFullbright = false
		if fbConn then fbConn:Disconnect() end
		Lighting.Ambient = oldLighting.Ambient
		Lighting.Brightness = oldLighting.Brightness
		Lighting.ClockTime = oldLighting.ClockTime
		Lighting.FogEnd = oldLighting.FogEnd
		Lighting.GlobalShadows = oldLighting.GlobalShadows
		Notify("Graphics", "Fullbright Disabled")
	end
end)

RegisterCommand("gravity", {"grav"}, "[num]", "none", "Sets Workspace gravity", function(args)
	local amt = tonumber(args[2])
	if amt then
		Workspace.Gravity = amt
		Notify("Physics", "Gravity set to " .. tostring(amt))
	end
end)

RegisterCommand("resetgravity", {"rgrav"}, "", "none", "Resets gravity to default", function(args)
	Workspace.Gravity = 196.2
	Notify("Physics", "Gravity reset")
end)

RegisterCommand("clicktp", {"ctp"}, "", "none", "Teleports you to where you click", function(args)
	if clickTpConn then clickTpConn:Disconnect() end
	clickTpConn = Mouse.Button1Down:Connect(function()
		if LocalPlayer.Character and getRoot(LocalPlayer.Character) and Mouse.Hit then
			getRoot(LocalPlayer.Character).CFrame = Mouse.Hit + Vector3.new(0, 3, 0)
		end
	end)
	Notify("Movement", "ClickTP Enabled")
end)

RegisterCommand("noclicktp", {"unctp"}, "", "none", "Disables ClickTP", function(args)
	if clickTpConn then clickTpConn:Disconnect() clickTpConn = nil end
	Notify("Movement", "ClickTP Disabled")
end)

RegisterCommand("copypos", {"cpos"}, "", "none", "Copies your exact position", function(args)
	if setclipboard and LocalPlayer.Character and getRoot(LocalPlayer.Character) then
		local pos = getRoot(LocalPlayer.Character).Position
		setclipboard(tostring(pos.X) .. ", " .. tostring(pos.Y) .. ", " .. tostring(pos.Z))
		Notify("Utility", "Position copied")
	end
end)

RegisterCommand("coords", {"pos"}, "", "none", "Shows your current coordinates", function(args)
	if LocalPlayer.Character and getRoot(LocalPlayer.Character) then
		local pos = getRoot(LocalPlayer.Character).Position
		Notify("Utility", "Coords: " .. tostring(math.floor(pos.X)) .. ", " .. tostring(math.floor(pos.Y)) .. ", " .. tostring(math.floor(pos.Z)))
	end
end)

RegisterCommand("savepos", {"sp"}, "", "none", "Saves your current position", function(args)
	if LocalPlayer.Character and getRoot(LocalPlayer.Character) then
		savedPosition = getRoot(LocalPlayer.Character).CFrame
		Notify("Teleport", "Position saved")
	end
end)

RegisterCommand("loadpos", {"lp"}, "", "none", "Teleports to saved position", function(args)
	if savedPosition and LocalPlayer.Character and getRoot(LocalPlayer.Character) then
		getRoot(LocalPlayer.Character).CFrame = savedPosition
		Notify("Teleport", "Loaded position")
	else
		Notify("Error", "No position saved")
	end
end)

RegisterCommand("freeze", {"anchor"}, "", "none", "Anchors your character", function(args)
	if LocalPlayer.Character and getRoot(LocalPlayer.Character) then
		getRoot(LocalPlayer.Character).Anchored = true
		Notify("Physics", "Character Frozen")
	end
end)

RegisterCommand("unfreeze", {"unanchor"}, "", "none", "Unanchors your character", function(args)
	if LocalPlayer.Character and getRoot(LocalPlayer.Character) then
		getRoot(LocalPlayer.Character).Anchored = false
		Notify("Physics", "Character Unfrozen")
	end
end)

RegisterCommand("health", {"hp"}, "[num]", "none", "Sets local health", function(args)
	local amt = tonumber(args[2])
	if amt and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.Health = amt
		Notify("Character", "Health locally set to " .. tostring(amt))
	end
end)

RegisterCommand("maxhealth", {"maxhp"}, "[num]", "none", "Sets max health", function(args)
	local amt = tonumber(args[2])
	if amt and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.MaxHealth = amt
		Notify("Character", "MaxHealth locally set to " .. tostring(amt))
	end
end)

RegisterCommand("heal", {}, "", "none", "Heals character locally", function(args)
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
		Notify("Character", "Healed locally")
	end
end)

RegisterCommand("copyplaceid", {"cpid"}, "", "none", "Copies place ID", function(args)
	if setclipboard then
		setclipboard(tostring(game.PlaceId))
		Notify("Utility", "PlaceId copied")
	end
end)

RegisterCommand("copyuserid", {"cuid"}, "", "none", "Copies your User ID", function(args)
	if setclipboard then
		setclipboard(tostring(LocalPlayer.UserId))
		Notify("Utility", "UserId copied")
	end
end)

RegisterCommand("serverinfo", {"sinfo"}, "", "none", "Shows basic server stats", function(args)
	local pc = #Players:GetPlayers()
	Notify("Server", "Players: " .. tostring(pc) .. " | JobId: " .. string.sub(game.JobId, 1, 8) .. "...")
end)

RegisterCommand("hideui", {"hui"}, "", "none", "Hides Roblox CoreUI", function(args)
	pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false) end)
	Notify("UI", "Core UI Hidden")
end)

RegisterCommand("showui", {"sui"}, "", "none", "Shows Roblox CoreUI", function(args)
	pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true) end)
	Notify("UI", "Core UI Restored")
end)

RegisterCommand("hipheight", {"hh"}, "[num]", "none", "Adjusts hip height", function(args)
	local amt = tonumber(args[2])
	if amt and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.HipHeight = amt
		Notify("Character", "HipHeight set to " .. tostring(amt))
	end
end)

RegisterCommand("invisible", {"invis"}, "", "none", "Makes you locally invisible", function(args)
	if invisibleConn then invisibleConn:Disconnect() end
	invisibleConn = RunService.RenderStepped:Connect(function()
		if LocalPlayer.Character then
			for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
				if v:IsA("BasePart") or v:IsA("Decal") then
					v.LocalTransparencyModifier = 1
				end
			end
		end
	end)
	Notify("Player", "Locally Invisible")
end)

RegisterCommand("visible", {"vis"}, "", "none", "Makes you visible again", function(args)
	if invisibleConn then invisibleConn:Disconnect() invisibleConn = nil end
	if LocalPlayer.Character then
		for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
			if v:IsA("BasePart") or v:IsA("Decal") then
				v.LocalTransparencyModifier = 0
			end
		end
	end
	Notify("Player", "Visible")
end)

RegisterCommand("spin", {}, "[speed]", "none", "Spins your character", function(args)
	local speed = tonumber(args[2]) or 50
	if spinConn then spinConn:Disconnect() end
	spinConn = RunService.RenderStepped:Connect(function()
		if LocalPlayer.Character and getRoot(LocalPlayer.Character) then
			getRoot(LocalPlayer.Character).CFrame = getRoot(LocalPlayer.Character).CFrame * CFrame.Angles(0, math.rad(speed), 0)
		end
	end)
	Notify("Player", "Spinning")
end)

RegisterCommand("unspin", {}, "", "none", "Stops spinning", function(args)
	if spinConn then spinConn:Disconnect() spinConn = nil end
	Notify("Player", "Stopped spinning")
end)

RegisterCommand("float", {}, "", "none", "Floats in the air", function(args)
	if LocalPlayer.Character and getRoot(LocalPlayer.Character) then
		if floatPart then floatPart:Destroy() end
		floatPart = Instance.new("BodyPosition")
		floatPart.MaxForce = Vector3.new(0, 9e9, 0)
		floatPart.Position = getRoot(LocalPlayer.Character).Position
		floatPart.Parent = getRoot(LocalPlayer.Character)
		Notify("Player", "Floating")
	end
end)

RegisterCommand("unfloat", {}, "", "none", "Stops floating", function(args)
	if floatPart then floatPart:Destroy() floatPart = nil end
	Notify("Player", "Stopped floating")
end)

RegisterCommand("stun", {"ragdoll"}, "", "none", "PlatformStands your character", function(args)
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.PlatformStand = true
		Notify("Player", "Stunned")
	end
end)

RegisterCommand("unstun", {"unragdoll"}, "", "none", "Un-PlatformStands character", function(args)
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.PlatformStand = false
		Notify("Player", "Unstunned")
	end
end)

RegisterCommand("zoom", {}, "[num]", "none", "Sets MaxZoomDistance", function(args)
	local amt = tonumber(args[2])
	if amt then
		LocalPlayer.CameraMaxZoomDistance = amt
		Notify("Camera", "MaxZoomDistance set to " .. tostring(amt))
	end
end)

RegisterCommand("firstperson", {"fp"}, "", "none", "Forces first person", function(args)
	LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
	Notify("Camera", "Locked to First Person")
end)

RegisterCommand("thirdperson", {"tp"}, "", "none", "Unlocks third person", function(args)
	LocalPlayer.CameraMode = Enum.CameraMode.Classic
	LocalPlayer.CameraMaxZoomDistance = 400
	Notify("Camera", "Unlocked Third Person")
end)

RegisterCommand("bringcamera", {"bcam"}, "", "none", "Teleports to camera focus", function(args)
	if LocalPlayer.Character and getRoot(LocalPlayer.Character) then
		getRoot(LocalPlayer.Character).CFrame = Workspace.CurrentCamera.Focus
		Notify("Teleport", "Teleported to Camera Focus")
	end
end)

RegisterCommand("walkto", {}, "[x] [y] [z]", "none", "Makes character walk to coords", function(args)
	local x = tonumber(args[2])
	local y = tonumber(args[3])
	local z = tonumber(args[4])
	if x and y and z and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(x, y, z))
		Notify("Teleport", "Walking to coordinates")
	end
end)

RegisterCommand("brightness", {}, "[num]", "none", "Sets lighting brightness", function(args)
	local amt = tonumber(args[2])
	if amt then
		Lighting.Brightness = amt
		Notify("Graphics", "Brightness set to " .. tostring(amt))
	end
end)

RegisterCommand("clocktime", {"time"}, "[num]", "none", "Sets time of day", function(args)
	local amt = tonumber(args[2])
	if amt then
		Lighting.ClockTime = amt
		Notify("Graphics", "Time set to " .. tostring(amt))
	end
end)

RegisterCommand("nofog", {}, "", "none", "Removes fog", function(args)
	Lighting.FogEnd = 100000
	Notify("Graphics", "Fog removed")
end)

RegisterCommand("shadows", {}, "", "none", "Enables global shadows", function(args)
	Lighting.GlobalShadows = true
	Notify("Graphics", "Shadows enabled")
end)

RegisterCommand("noshadows", {}, "", "none", "Disables global shadows", function(args)
	Lighting.GlobalShadows = false
	Notify("Graphics", "Shadows disabled")
end)

RegisterCommand("ping", {}, "", "none", "Displays your ping", function(args)
	local ping = tonumber(string.match(Stats.Network.ServerStatsItem["Data Ping"]:GetValueString(), "%d+"))
	if ping then Notify("Utility", "Ping: " .. tostring(ping) .. "ms") end
end)

RegisterCommand("fps", {}, "", "none", "Displays your FPS", function(args)
	local fps = Workspace:GetRealPhysicsFPS()
	Notify("Utility", "FPS: " .. tostring(math.floor(fps)))
end)

RegisterCommand("velocity", {"vel"}, "[x] [y] [z]", "none", "Sets HRP Velocity", function(args)
	local x = tonumber(args[2]) or 0
	local y = tonumber(args[3]) or 0
	local z = tonumber(args[4]) or 0
	if LocalPlayer.Character and getRoot(LocalPlayer.Character) then
		getRoot(LocalPlayer.Character).AssemblyLinearVelocity = Vector3.new(x, y, z)
		Notify("Physics", "Velocity updated")
	end
end)

RegisterCommand("rocket", {}, "", "none", "Shoots you upwards", function(args)
	if LocalPlayer.Character and getRoot(LocalPlayer.Character) then
		getRoot(LocalPlayer.Character).AssemblyLinearVelocity = Vector3.new(0, 1000, 0)
		Notify("Physics", "Blast off!")
	end
end)

RegisterCommand("bhop", {"bunnyhop"}, "", "none", "Autojumps when holding space", function(args)
	if bhopConn then bhopConn:Disconnect() end
	bhopConn = RunService.RenderStepped:Connect(function()
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
			if LocalPlayer.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
				LocalPlayer.Character.Humanoid.Jump = true
			end
		end
	end)
	Notify("Movement", "Bhop Enabled")
end)

RegisterCommand("unbhop", {"nobhop"}, "", "none", "Disables bunnyhop", function(args)
	if bhopConn then bhopConn:Disconnect() bhopConn = nil end
	Notify("Movement", "Bhop Disabled")
end)

RegisterCommand("dash", {}, "", "none", "Pushes you forward", function(args)
	if LocalPlayer.Character and getRoot(LocalPlayer.Character) then
		local hrp = getRoot(LocalPlayer.Character)
		hrp.AssemblyLinearVelocity = hrp.CFrame.LookVector * 150
		Notify("Movement", "Dashed")
	end
end)

RegisterCommand("playercount", {"pc"}, "", "none", "Shows amount of players", function(args)
	Notify("Server", "Player Count: " .. tostring(#Players:GetPlayers()) .. "/" .. tostring(Players.MaxPlayers))
end)

RegisterCommand("fakekick", {}, "", "none", "Kicks you from the game", function(args)
	LocalPlayer:Kick("You have been kicked from this game.")
end)

RegisterCommand("fakecrash", {}, "", "none", "Crashes your client", function(args)
	while true do end
end)

RegisterCommand("dex", {}, "", "none", "Loads Dex Explorer", function(args)
	local success, err = pcall(function()
		local src = game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua")
		local fn = loadstring(src)
		if fn then fn() else Notify("Error", "Failed to compile Dex") end
	end)
	if success then Notify("Developer", "Loaded Dex Explorer") else Notify("Error", "Failed to load Dex") end
end)

RegisterCommand("simplespy", {"rspy"}, "", "none", "Loads SimpleSpy", function(args)
	local success, err = pcall(function()
		local src = game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua")
		local fn = loadstring(src)
		if fn then fn() else Notify("Error", "Failed to compile SimpleSpy") end
	end)
	if success then Notify("Developer", "Loaded SimpleSpy") else Notify("Error", "Failed to load SimpleSpy") end
end)
