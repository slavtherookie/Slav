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
local LocalPlayer = Players.LocalPlayer

local activeESPs = {}
local flyConn = nil
local flyPart = nil
local flyGyro = nil

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

RegisterCommand("disablenotifs", {"nonotifs"}, "", "none", "Hides notifications", function(args)
	SetNotifsEnabled(false)
end)

RegisterCommand("enablenotifs", {}, "", "none", "Shows notifications", function(args)
	SetNotifsEnabled(true)
	Notify("Settings", "Notifications Enabled")
end)
