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
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local activeESPs = {}
local flyConn, flyPart, flyGyro = nil, nil, nil
local spinConn, floatPart, clickTpConn, bhopConn, invisibleConn = nil, nil, nil, nil, nil
local followConn, followTarget, orbitConn, orbitTarget = nil, nil, nil, nil
local camlockConn, camlockTarget, shakeConn, discoConn = nil, nil, nil, nil
local playerEspConn, itemEspConn, spamSitConn, spamJumpConn = nil, nil, nil, nil
local xrayEnabled = false
local savedPosition = nil
local originalCamSubject = nil
local oldLighting = {}
local isFullbright = false

local originalLighting = nil
local originalCamera = nil
local originalCharProps = {}
local originalWorkspaceProps = nil

local function cacheLighting()
    if not originalLighting then
        originalLighting = {
            Ambient = Lighting.Ambient,
            Brightness = Lighting.Brightness,
            ClockTime = Lighting.ClockTime,
            FogEnd = Lighting.FogEnd,
            GlobalShadows = Lighting.GlobalShadows
        }
    end
end

local function cacheCamera()
    if not originalCamera and Workspace.CurrentCamera then
        originalCamera = {
            FieldOfView = Workspace.CurrentCamera.FieldOfView,
            CameraType = Workspace.CurrentCamera.CameraType,
            CameraSubject = Workspace.CurrentCamera.CameraSubject
        }
    end
end

local function cacheCharacter()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") and not originalCharProps[char] then
        local hum = char.Humanoid
        originalCharProps[char] = {
            WalkSpeed = hum.WalkSpeed,
            JumpPower = hum.JumpPower,
            UseJumpPower = hum.UseJumpPower,
            HipHeight = hum.HipHeight,
            MaxHealth = hum.MaxHealth,
            BodyWidthScale = hum:FindFirstChild("BodyWidthScale") and hum.BodyWidthScale.Value or 1,
            BodyHeightScale = hum:FindFirstChild("BodyHeightScale") and hum.BodyHeightScale.Value or 1,
            BodyDepthScale = hum:FindFirstChild("BodyDepthScale") and hum.BodyDepthScale.Value or 1,
            HeadScale = hum:FindFirstChild("HeadScale") and hum.HeadScale.Value or 1
        }
    end
end

local function cacheWorkspace()
    if not originalWorkspaceProps then
        originalWorkspaceProps = {
            Gravity = Workspace.Gravity
        }
    end
end

local fcEnabled = false
local fcBaseSpeed, fcSpeed = 50, 50
local fcSpeedStep, fcMinSpeed, fcMaxSpeed = 15, 5, 500
local fcVelocity, fcTargetVelocity = Vector3.new(), Vector3.new()
local fcMoveAcceleration = 10
local fcYaw, fcPitch, fcCurrentYaw, fcCurrentPitch = 0, 0, 0, 0
local fcLookSensitivity, fcRotSmoothness = 0.002, 15
local fovTweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
local hiddenGuis = {}

local chamFolder = Instance.new("Folder")
chamFolder.Name = "PaperChams"
pcall(function()
    chamFolder.Parent = CoreGui
end)

local itemChamFolder = Instance.new("Folder")
itemChamFolder.Name = "PaperItemChams"
pcall(function()
    itemChamFolder.Parent = CoreGui
end)

local function getRoot(char)
    if not char then
        return nil
    end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function setCharacterState(frozen)
    local char = LocalPlayer.Character
    if not char then
        return
    end
    local root = getRoot(char)
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
        fcPitch, fcYaw = rx, ry
        fcCurrentPitch, fcCurrentYaw = fcPitch, fcYaw
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
        Notify("Freecam", fcEnabled and "Freecam Enabled" or "Freecam Disabled")
    end
    if fcEnabled and shiftHeld and input.UserInputType == Enum.UserInputType.MouseButton3 then
        fcSpeed = fcBaseSpeed
    end
end)

UserInputService.InputChanged:Connect(function(input, processed)
    if not fcEnabled then
        return
    end
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Delta
        fcYaw = fcYaw - delta.X * fcLookSensitivity
        fcPitch = math.clamp(fcPitch - delta.Y * fcLookSensitivity, -math.pi / 2 + 0.01, math.pi / 2 - 0.01)
    elseif input.UserInputType == Enum.UserInputType.MouseWheel then
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
            fcSpeed = math.clamp(fcSpeed + (input.Position.Z * fcSpeedStep), fcMinSpeed, fcMaxSpeed)
        end
    end
end)

RunService.RenderStepped:Connect(function(dt)
    if not fcEnabled then
        return
    end
    local cam = Workspace.CurrentCamera
    if not cam then
        return
    end
    local rotAlpha = 1 - math.exp(-dt * fcRotSmoothness)
    fcCurrentYaw = fcCurrentYaw + (fcYaw - fcCurrentYaw) * rotAlpha
    fcCurrentPitch = fcCurrentPitch + (fcPitch - fcCurrentPitch) * rotAlpha
    local rotationCFrame = CFrame.Angles(0, fcCurrentYaw, 0) * CFrame.Angles(fcCurrentPitch, 0, 0)
    local moveDir = Vector3.new()
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        moveDir = moveDir + Vector3.new(0, 0, -1)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        moveDir = moveDir + Vector3.new(0, 0, 1)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        moveDir = moveDir + Vector3.new(-1, 0, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        moveDir = moveDir + Vector3.new(1, 0, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.E) then
        moveDir = moveDir + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
        moveDir = moveDir + Vector3.new(0, -1, 0)
    end
    if moveDir.Magnitude > 0 then
        moveDir = moveDir.Unit
    end
    fcTargetVelocity = rotationCFrame:VectorToWorldSpace(moveDir) * fcSpeed
    local moveAlpha = 1 - math.exp(-dt * fcMoveAcceleration)
    fcVelocity = fcVelocity:Lerp(fcTargetVelocity, moveAlpha)
    cam.CFrame = CFrame.new(cam.CFrame.Position + fcVelocity * dt) * rotationCFrame
end)

RegisterCommand("expand", {"open", "ui"}, "", "none", "Expands the UI", function()
    SetUIExpanded(true)
end)

RegisterCommand("minimize", {"close", "shrink"}, "", "none", "Minimizes the UI", function()
    SetUIExpanded(false)
end)

RegisterCommand("rejoin", {"rj"}, "", "none", "Rejoins current server", function()
    Notify("Server", "Rejoining...")
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

RegisterCommand("jobid", {"job"}, "", "none", "Copies JobId", function()
    if setclipboard then
        setclipboard(tostring(game.JobId))
        Notify("Server", "JobId copied")
    end
end)

RegisterCommand("joinlink", {"link"}, "", "none", "Copies join link", function()
    if setclipboard then
        setclipboard("roblox://experiences/start?placeId=" .. tostring(game.PlaceId) .. "&gameInstanceId=" .. tostring(game.JobId))
        Notify("Server", "Link copied")
    end
end)

RegisterCommand("fov", {"fieldofview"}, "[num]", "none", "Changes FOV", function(args)
    cacheCamera()
    local num = tonumber(args[2])
    if num then
        Workspace.CurrentCamera.FieldOfView = num
        Notify("Camera", "FOV: " .. num)
    end
end)

RegisterCommand("sit", {}, "", "none", "Sit down", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Sit = true
    end
end)

RegisterCommand("unlocate", {"unesp"}, "", "none", "Removes locates", function()
    local count = 0
    for _, esp in pairs(activeESPs) do
        esp.Cleanup()
        count = count + 1
    end
    Notify("Locate", "Removed " .. count .. " trackers")
end)

RegisterCommand("hidestats", {"hwm"}, "", "none", "Hides watermark", function()
    SetWatermarkVisible(false)
    Notify("Settings", "Watermark hidden")
end)

RegisterCommand("showstats", {"swm"}, "", "none", "Shows watermark", function()
    SetWatermarkVisible(true)
    Notify("Settings", "Watermark revealed")
end)

RegisterCommand("goto", {"tp", "to"}, "[player]", "player", "Teleports to target", function(args)
    local target = GetPlayer(args[2])
    if target and target.Character and getRoot(target.Character) and getRoot(LocalPlayer.Character) then
        getRoot(LocalPlayer.Character).CFrame = getRoot(target.Character).CFrame * CFrame.new(0, 0, 3)
        Notify("Teleport", "Goto " .. target.DisplayName)
    end
end)

RegisterCommand("reset", {"kill", "die"}, "", "none", "Kills your character", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = 0
    end
end)

RegisterCommand("speed", {"ws", "walkspeed"}, "[num]", "none", "Changes WalkSpeed", function(args)
    cacheCharacter()
    local amount = tonumber(args[2])
    if amount and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = amount
        Notify("Speed", "WalkSpeed: " .. amount)
    end
end)

RegisterCommand("jumppower", {"jp"}, "[num]", "none", "Changes JumpPower", function(args)
    cacheCharacter()
    local amount = tonumber(args[2])
    if amount and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = amount
        Notify("JumpPower", "JumpPower: " .. amount)
    end
end)

RegisterCommand("unfly", {"nofly"}, "", "none", "Disables flight", function()
    if flyConn then
        flyConn:Disconnect()
        flyConn = nil
    end
    if flyPart then
        flyPart:Destroy()
        flyPart = nil
    end
    if flyGyro then
        flyGyro:Destroy()
        flyGyro = nil
    end
    Notify("Flight", "Disabled")
end)

RegisterCommand("clip", {"c"}, "", "none", "Disables noclip", function()
    if _G.PaperNoclip then
        _G.PaperNoclip:Disconnect()
        _G.PaperNoclip = nil
    end
    Notify("Movement", "Noclip Disabled")
end)

RegisterCommand("freecam", {"fc"}, "", "none", "Toggles freecam", function()
    toggleFreecam()
end)

RegisterCommand("disablenotifs", {"nonotifs"}, "", "none", "Hides notifs", function()
    SetNotifsEnabled(false)
end)

RegisterCommand("enablenotifs", {}, "", "none", "Shows notifs", function()
    SetNotifsEnabled(true)
    Notify("Settings", "Notifs Enabled")
end)

RegisterCommand("spectate", {"view"}, "[player]", "player", "Spectates", function(args)
    local target = GetPlayer(args[2])
    if target and target.Character and target.Character:FindFirstChild("Humanoid") then
        originalCamSubject = Workspace.CurrentCamera.CameraSubject
        Workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
        Notify("Camera", "Spectating " .. target.DisplayName)
    end
end)

RegisterCommand("unspectate", {"unview"}, "", "none", "Stops spectating", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
        Notify("Camera", "Stopped spectating")
    end
end)

RegisterCommand("unfullbright", {"unfb"}, "", "none", "Restores lighting", function()
    if isFullbright then
        isFullbright = false
        if fbConn then
            fbConn:Disconnect()
            fbConn = nil
        end
        Lighting.Ambient = oldLighting.Ambient
        Lighting.Brightness = oldLighting.Brightness
        Lighting.ClockTime = oldLighting.ClockTime
        Lighting.FogEnd = oldLighting.FogEnd
        Lighting.GlobalShadows = oldLighting.GlobalShadows
        Notify("Graphics", "Fullbright Disabled")
    end
end)

RegisterCommand("gravity", {"grav"}, "[num]", "none", "Sets gravity", function(args)
    cacheWorkspace()
    local amount = tonumber(args[2])
    if amount then
        Workspace.Gravity = amount
    end
end)

RegisterCommand("resetgravity", {"rgrav"}, "", "none", "Resets gravity", function()
    Workspace.Gravity = 196.2
end)

RegisterCommand("noclicktp", {"unctp"}, "", "none", "Disables ClickTP", function()
    if clickTpConn then
        clickTpConn:Disconnect()
        clickTpConn = nil
    end
end)

RegisterCommand("copypos", {"cpos"}, "", "none", "Copies pos", function()
    if setclipboard and getRoot(LocalPlayer.Character) then
        local pos = getRoot(LocalPlayer.Character).Position
        setclipboard(pos.X .. ", " .. pos.Y .. ", " .. pos.Z)
    end
end)

RegisterCommand("coords", {"pos"}, "", "none", "Shows coords", function()
    if getRoot(LocalPlayer.Character) then
        local pos = getRoot(LocalPlayer.Character).Position
        Notify("Coords", math.floor(pos.X) .. ", " .. math.floor(pos.Y) .. ", " .. math.floor(pos.Z))
    end
end)

RegisterCommand("savepos", {"sp"}, "", "none", "Saves position", function()
    if getRoot(LocalPlayer.Character) then
        savedPosition = getRoot(LocalPlayer.Character).CFrame
        Notify("Teleport", "Pos Saved")
    end
end)

RegisterCommand("loadpos", {"lp"}, "", "none", "Loads position", function()
    if savedPosition and getRoot(LocalPlayer.Character) then
        getRoot(LocalPlayer.Character).CFrame = savedPosition
    end
end)

RegisterCommand("freeze", {"anchor"}, "", "none", "Anchors character", function()
    if getRoot(LocalPlayer.Character) then
        getRoot(LocalPlayer.Character).Anchored = true
    end
end)

RegisterCommand("unfreeze", {"unanchor"}, "", "none", "Unanchors character", function()
    if getRoot(LocalPlayer.Character) then
        getRoot(LocalPlayer.Character).Anchored = false
    end
end)

RegisterCommand("health", {"hp"}, "[num]", "none", "Sets local HP", function(args)
    cacheCharacter()
    local amount = tonumber(args[2])
    if amount and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = amount
    end
end)

RegisterCommand("maxhealth", {"maxhp"}, "[num]", "none", "Sets local MaxHP", function(args)
    cacheCharacter()
    local amount = tonumber(args[2])
    if amount and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.MaxHealth = amount
    end
end)

RegisterCommand("heal", {}, "", "none", "Heals locally", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
    end
end)

RegisterCommand("copyplaceid", {"cpid"}, "", "none", "Copies place ID", function()
    if setclipboard then
        setclipboard(tostring(game.PlaceId))
    end
end)

RegisterCommand("copyuserid", {"cuid"}, "", "none", "Copies user ID", function()
    if setclipboard then
        setclipboard(tostring(LocalPlayer.UserId))
    end
end)

RegisterCommand("serverinfo", {"sinfo"}, "", "none", "Shows server stats", function()
    Notify("Server", "Players: " .. #Players:GetPlayers() .. " | JobId: " .. string.sub(game.JobId, 1, 8) .. "...")
end)

RegisterCommand("hideui", {"hui"}, "", "none", "Hides CoreUI", function()
    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    end)
end)

RegisterCommand("showui", {"sui"}, "", "none", "Shows CoreUI", function()
    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
    end)
end)

RegisterCommand("hipheight", {"hh"}, "[num]", "none", "Adjusts hipheight", function(args)
    cacheCharacter()
    local amount = tonumber(args[2])
    if amount and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.HipHeight = amount
    end
end)

RegisterCommand("visible", {"vis"}, "", "none", "Makes visible", function()
    if invisibleConn then
        invisibleConn:Disconnect()
        invisibleConn = nil
    end
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.LocalTransparencyModifier = 0
            end
        end
    end
end)

RegisterCommand("unspin", {}, "", "none", "Stops spin", function()
    if spinConn then
        spinConn:Disconnect()
        spinConn = nil
    end
end)

RegisterCommand("unfloat", {}, "", "none", "Stops float", function()
    if floatPart then
        floatPart:Destroy()
        floatPart = nil
    end
end)

RegisterCommand("stun", {"ragdoll"}, "", "none", "Stuns character", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = true
    end
end)

RegisterCommand("unstun", {"unragdoll"}, "", "none", "Unstuns character", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end
end)

RegisterCommand("zoom", {}, "[num]", "none", "Sets MaxZoom", function(args)
    cacheCamera()
    local amount = tonumber(args[2])
    if amount then
        LocalPlayer.CameraMaxZoomDistance = amount
    end
end)

RegisterCommand("firstperson", {"fp"}, "", "none", "Forces FP", function()
    cacheCamera()
    LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
end)

RegisterCommand("thirdperson", {"tp"}, "", "none", "Unlocks TP", function()
    cacheCamera()
    LocalPlayer.CameraMode = Enum.CameraMode.Classic
    LocalPlayer.CameraMaxZoomDistance = 400
end)

RegisterCommand("bringcamera", {"bcam"}, "", "none", "TPs to camera", function()
    if getRoot(LocalPlayer.Character) then
        getRoot(LocalPlayer.Character).CFrame = Workspace.CurrentCamera.Focus
    end
end)

RegisterCommand("walkto", {}, "[x] [y] [z]", "none", "Walk to coords", function(args)
    local x = tonumber(args[2])
    local y = tonumber(args[3])
    local z = tonumber(args[4])
    if x and y and z and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(x, y, z))
    end
end)

RegisterCommand("brightness", {}, "[num]", "none", "Sets brightness", function(args)
    cacheLighting()
    local amount = tonumber(args[2])
    if amount then
        Lighting.Brightness = amount
    end
end)

RegisterCommand("clocktime", {"time"}, "[num]", "none", "Sets time", function(args)
    cacheLighting()
    local amount = tonumber(args[2])
    if amount then
        Lighting.ClockTime = amount
    end
end)

RegisterCommand("nofog", {}, "", "none", "Removes fog", function()
    cacheLighting()
    Lighting.FogEnd = 100000
end)

RegisterCommand("shadows", {}, "", "none", "Enables shadows", function()
    cacheLighting()
    Lighting.GlobalShadows = true
end)

RegisterCommand("noshadows", {}, "", "none", "Disables shadows", function()
    cacheLighting()
    Lighting.GlobalShadows = false
end)

RegisterCommand("ping", {}, "", "none", "Displays ping", function()
    local ping = tonumber(string.match(Stats.Network.ServerStatsItem["Data Ping"]:GetValueString(), "%d+"))
    if ping then
        Notify("Utility", "Ping: " .. ping .. "ms")
    end
end)

RegisterCommand("fps", {}, "", "none", "Displays FPS", function()
    Notify("Utility", "FPS: " .. math.floor(Workspace:GetRealPhysicsFPS()))
end)

RegisterCommand("velocity", {"vel"}, "[x] [y] [z]", "none", "Sets Velocity", function(args)
    local x = tonumber(args[2]) or 0
    local y = tonumber(args[3]) or 0
    local z = tonumber(args[4]) or 0
    if getRoot(LocalPlayer.Character) then
        getRoot(LocalPlayer.Character).AssemblyLinearVelocity = Vector3.new(x, y, z)
    end
end)

RegisterCommand("rocket", {}, "", "none", "Shoots you up", function()
    if getRoot(LocalPlayer.Character) then
        getRoot(LocalPlayer.Character).AssemblyLinearVelocity = Vector3.new(0, 1000, 0)
    end
end)

RegisterCommand("unbhop", {"nobhop"}, "", "none", "Disables bhop", function()
    if bhopConn then
        bhopConn:Disconnect()
        bhopConn = nil
    end
end)

RegisterCommand("dash", {}, "", "none", "Pushes you forward", function()
    if getRoot(LocalPlayer.Character) then
        local hrp = getRoot(LocalPlayer.Character)
        hrp.AssemblyLinearVelocity = hrp.CFrame.LookVector * 150
    end
end)

RegisterCommand("playercount", {"pc"}, "", "none", "Shows player count", function()
    Notify("Server", "Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers)
end)

RegisterCommand("fakekick", {}, "", "none", "Kicks yourself", function()
    LocalPlayer:Kick("You have been kicked from this game.")
end)

RegisterCommand("fakecrash", {}, "", "none", "Crashes client", function()
    while true do
    end
end)

RegisterCommand("locate", {"find", "esp"}, "[player] [tracer?]", "player", "Creates ESP", function(args)
    local target = GetPlayer(args[2])
    if not target or target == LocalPlayer then
        return
    end
    local wantsTracer = false
    if args[3] and string.lower(tostring(args[3])):match("t") then
        wantsTracer = true
    end
    if activeESPs[target] then
        activeESPs[target].Cleanup()
    end
    local espData = {}
    local billboard = Instance.new("BillboardGui", TargetGui)
    billboard.Name = "Paper_ESP_GUI"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 150, 0, 40)
    
    local textLabel = Instance.new("TextLabel", billboard)
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.TextSize = 12
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextStrokeTransparency = 0
    
    local tracerLine = Instance.new("Frame", TracerContainer)
    tracerLine.AnchorPoint = Vector2.new(0.5, 0.5)
    tracerLine.BackgroundColor3 = Color3.new(1, 1, 1)
    tracerLine.BorderSizePixel = 0
    tracerLine.Visible = false
    
    espData.Cleanup = function()
        billboard:Destroy()
        tracerLine:Destroy()
        if espData.Conn then
            espData.Conn:Disconnect()
        end
        activeESPs[target] = nil
    end
    
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
            textLabel.Text = target.Name .. "\n[" .. math.floor((lp.HumanoidRootPart.Position - targetHRP.Position).Magnitude) .. "s]"
        else
            textLabel.Text = target.Name
        end
        if wantsTracer and Workspace.CurrentCamera then
            local pos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(targetHRP.Position)
            if onScreen then
                tracerLine.Visible = true
                local from = Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, Workspace.CurrentCamera.ViewportSize.Y)
                local to = Vector2.new(pos.X, pos.Y)
                tracerLine.Size = UDim2.new(0, (to - from).Magnitude, 0, 1)
                tracerLine.Position = UDim2.new(0, (from.X + to.X) / 2, 0, (from.Y + to.Y) / 2)
                tracerLine.Rotation = math.deg(math.atan2(to.Y - from.Y, to.X - from.X))
            else
                tracerLine.Visible = false
            end
        else
            tracerLine.Visible = false
        end
    end)
    activeESPs[target] = espData
    Notify("Locate", "Tracking " .. target.Name)
end)

RegisterCommand("fly", {"flight"}, "", "none", "Enables flight", function()
    if flyConn then
        flyConn:Disconnect()
    end
    if flyPart then
        flyPart:Destroy()
    end
    if flyGyro then
        flyGyro:Destroy()
    end
    local char = LocalPlayer.Character
    if char and getRoot(char) and char:FindFirstChild("Humanoid") then
        for _, track in ipairs(char.Humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
        end
        flyPart = Instance.new("BodyVelocity", getRoot(char))
        flyPart.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyGyro = Instance.new("BodyGyro", getRoot(char))
        flyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyGyro.P = 9e4
        flyConn = RunService.RenderStepped:Connect(function()
            local cam = Workspace.CurrentCamera
            local moveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + cam.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - cam.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end
            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit
            end
            flyPart.Velocity = moveDir * 50
            flyGyro.CFrame = cam.CFrame
        end)
        Notify("Flight", "Fly enabled")
    end
end)

RegisterCommand("noclip", {"nc"}, "", "none", "Go through walls", function()
    if _G.PaperNoclip then
        _G.PaperNoclip:Disconnect()
    end
    _G.PaperNoclip = RunService.Stepped:Connect(function()
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
    Notify("Movement", "Noclip Enabled")
end)

RegisterCommand("fullbright", {"fb"}, "", "none", "Maxes lighting", function()
    if not isFullbright then
        oldLighting = {
            Ambient = Lighting.Ambient,
            Brightness = Lighting.Brightness,
            ClockTime = Lighting.ClockTime,
            FogEnd = Lighting.FogEnd,
            GlobalShadows = Lighting.GlobalShadows
        }
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

RegisterCommand("clicktp", {"ctp"}, "", "none", "TP where you click", function()
    if clickTpConn then
        clickTpConn:Disconnect()
    end
    clickTpConn = Mouse.Button1Down:Connect(function()
        if LocalPlayer.Character and getRoot(LocalPlayer.Character) and Mouse.Hit then
            getRoot(LocalPlayer.Character).CFrame = Mouse.Hit + Vector3.new(0, 3, 0)
        end
    end)
    Notify("Movement", "ClickTP Enabled")
end)

RegisterCommand("invisible", {"invis"}, "", "none", "Makes locally invisible", function()
    if invisibleConn then
        invisibleConn:Disconnect()
    end
    invisibleConn = RunService.RenderStepped:Connect(function()
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.LocalTransparencyModifier = 1
                end
            end
        end
    end)
    Notify("Player", "Locally Invisible")
end)

RegisterCommand("spin", {}, "[speed]", "none", "Spins you", function(args)
    local speed = tonumber(args[2]) or 50
    if spinConn then
        spinConn:Disconnect()
    end
    spinConn = RunService.RenderStepped:Connect(function()
        if getRoot(LocalPlayer.Character) then
            getRoot(LocalPlayer.Character).CFrame = getRoot(LocalPlayer.Character).CFrame * CFrame.Angles(0, math.rad(speed), 0)
        end
    end)
end)

RegisterCommand("float", {}, "", "none", "Floats in air", function()
    if getRoot(LocalPlayer.Character) then
        if floatPart then
            floatPart:Destroy()
        end
        floatPart = Instance.new("BodyPosition", getRoot(LocalPlayer.Character))
        floatPart.MaxForce = Vector3.new(0, 9e9, 0)
        floatPart.Position = getRoot(LocalPlayer.Character).Position
    end
end)

RegisterCommand("bhop", {"bunnyhop"}, "", "none", "Autojumps", function()
    if bhopConn then
        bhopConn:Disconnect()
    end
    bhopConn = RunService.RenderStepped:Connect(function()
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if LocalPlayer.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
                LocalPlayer.Character.Humanoid.Jump = true
            end
        end
    end)
end)

local function runGitScript(url, arg1, arg2)
    local success, err = pcall(function()
        local scriptFunc = loadstring(game:HttpGet(url))
        if scriptFunc then
            scriptFunc(arg1, arg2)
        end
    end)
    if not success then
        Notify("Error", err)
    end
end

RegisterCommand("notepad", {"notes"}, "", "none", "Notepad editor", function()
    Notify("Loading", "Notepad...")
    runGitScript("https://raw.githubusercontent.com/slavtherookie/Slav/refs/heads/main/main/Paper/loads/Utils/extras/Notepad.luau")
end)

RegisterCommand("cmds", {"help"}, "", "none", "Commands UI", function()
    Notify("Loading", "Commands...")
    runGitScript("https://raw.githubusercontent.com/slavtherookie/Slav/refs/heads/main/main/Paper/loads/Utils/extras/cmds.luau", LocalCmdRegistry)
end)

RegisterCommand("info", {"whois"}, "[player]", "player", "Player info", function(args)
    local target = GetPlayer(args[2])
    if target then
        Notify("Loading", "Info...")
        runGitScript("https://raw.githubusercontent.com/slavtherookie/Slav/refs/heads/main/main/Paper/loads/Utils/extras/PlayerInfo.luau", target)
    end
end)

RegisterCommand("bettersync", {"bsync"}, "[key]", "none", "Enables BetterSync", function(args)
    local key = args[2] or "G"
    runGitScript("https://raw.githubusercontent.com/slavtherookie/Slav/refs/heads/main/main/Paper/loads/Utils/extras/BetterSync.luau", "start", key)
end)

RegisterCommand("unbettersync", {"unbsync"}, "", "none", "Disables BetterSync", function()
    runGitScript("https://raw.githubusercontent.com/slavtherookie/Slav/refs/heads/main/main/Paper/loads/Utils/extras/BetterSync.luau", "cleanup")
end)

RegisterCommand("dex", {}, "", "none", "Loads Dex", function()
    runGitScript("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua")
end)

RegisterCommand("simplespy", {"rspy"}, "", "none", "Loads Spy", function()
    runGitScript("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua")
end)

RegisterCommand("follow", {}, "[player]", "player", "Follows player", function(args)
    local target = GetPlayer(args[2])
    if not target then
        return
    end
    followTarget = target
    if followConn then
        followConn:Disconnect()
    end
    followConn = RunService.RenderStepped:Connect(function()
        if followTarget and getRoot(followTarget.Character) and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:MoveTo(getRoot(followTarget.Character).Position)
        end
    end)
end)

RegisterCommand("unfollow", {}, "", "none", "Stops follow", function()
    if followConn then
        followConn:Disconnect()
        followConn = nil
    end
    followTarget = nil
end)

RegisterCommand("orbit", {}, "[player]", "player", "Orbits player", function(args)
    local target = GetPlayer(args[2])
    if not target then
        return
    end
    orbitTarget = target
    if orbitConn then
        orbitConn:Disconnect()
    end
    orbitConn = RunService.RenderStepped:Connect(function()
        if orbitTarget and getRoot(orbitTarget.Character) and getRoot(LocalPlayer.Character) then
            local timeCalc = tick() * 2
            local targetPos = getRoot(orbitTarget.Character).Position
            getRoot(LocalPlayer.Character).CFrame = CFrame.new(targetPos + Vector3.new(math.cos(timeCalc) * 10, 0, math.sin(timeCalc) * 10), targetPos)
        end
    end)
end)

RegisterCommand("unorbit", {}, "", "none", "Stops orbiting", function()
    if orbitConn then
        orbitConn:Disconnect()
        orbitConn = nil
    end
    orbitTarget = nil
end)

RegisterCommand("camlock", {"aimlock"}, "[player]", "player", "Locks cam", function(args)
    local target = GetPlayer(args[2])
    if not target then
        return
    end
    camlockTarget = target
    if camlockConn then
        camlockConn:Disconnect()
    end
    camlockConn = RunService.RenderStepped:Connect(function()
        if camlockTarget and getRoot(camlockTarget.Character) then
            Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, getRoot(camlockTarget.Character).Position)
        end
    end)
end)

RegisterCommand("uncamlock", {"unaimlock"}, "", "none", "Unlocks cam", function()
    if camlockConn then
        camlockConn:Disconnect()
        camlockConn = nil
    end
end)

RegisterCommand("lookat", {"face"}, "[player]", "player", "Faces player", function(args)
    local target = GetPlayer(args[2])
    if target and getRoot(target.Character) and getRoot(LocalPlayer.Character) then
        local rootPart = getRoot(LocalPlayer.Character)
        rootPart.CFrame = CFrame.new(rootPart.Position, Vector3.new(getRoot(target.Character).Position.X, rootPart.Position.Y, getRoot(target.Character).Position.Z))
    end
end)

RegisterCommand("playanim", {"anim"}, "[id]", "none", "Plays anim", function(args)
    local animId = tonumber(args[2])
    if animId and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://" .. animId
        LocalPlayer.Character.Humanoid:LoadAnimation(anim):Play()
    end
end)

RegisterCommand("stopanims", {"noanims"}, "", "none", "Stops anims", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        for _, track in ipairs(LocalPlayer.Character.Humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
        end
    end
end)

RegisterCommand("headless", {}, "", "none", "Removes head locally", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        LocalPlayer.Character.Head.Transparency = 1
        if LocalPlayer.Character.Head:FindFirstChild("face") then
            LocalPlayer.Character.Head.face.Transparency = 1
        end
    end
end)

RegisterCommand("xray", {}, "", "none", "Toggles xray", function()
    xrayEnabled = not xrayEnabled
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part.Parent:FindFirstChild("Humanoid") then
            part.LocalTransparencyModifier = xrayEnabled and 0.5 or 0
        end
    end
end)

RegisterCommand("playeresp", {"chams"}, "", "none", "Highlight ESP", function()
    if playerEspConn then
        playerEspConn:Disconnect()
        playerEspConn = nil
        chamFolder:ClearAllChildren()
        Notify("Visuals", "Player ESP Disabled")
    else
        playerEspConn = RunService.RenderStepped:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local highlight = chamFolder:FindFirstChild(player.Name)
                    if not highlight then
                        highlight = Instance.new("Highlight", chamFolder)
                        highlight.Name = player.Name
                        highlight.FillColor = Color3.new(1, 0, 0)
                    end
                    highlight.Adornee = player.Character
                end
            end
            for _, folderChild in pairs(chamFolder:GetChildren()) do
                if not Players:FindFirstChild(folderChild.Name) or not Players[folderChild.Name].Character then
                    folderChild:Destroy()
                end
            end
        end)
        Notify("Visuals", "Player ESP Enabled")
    end
end)

RegisterCommand("itemesp", {"toolesp"}, "", "none", "Item Highlight ESP", function()
    if itemEspConn then
        itemEspConn:Disconnect()
        itemEspConn = nil
        itemChamFolder:ClearAllChildren()
    else
        itemEspConn = RunService.RenderStepped:Connect(function()
            for _, tool in pairs(Workspace:GetDescendants()) do
                if tool:IsA("Tool") and tool:FindFirstChild("Handle") and not tool.Parent:FindFirstChild("Humanoid") then
                    local toolId = tool.Name .. tool:GetDebugId()
                    local highlight = itemChamFolder:FindFirstChild(toolId)
                    if not highlight then
                        highlight = Instance.new("Highlight", itemChamFolder)
                        highlight.Name = toolId
                        highlight.Adornee = tool
                        highlight.FillColor = Color3.new(0, 1, 0)
                    end
                end
            end
        end)
    end
end)

RegisterCommand("hidechat", {"hchat"}, "", "none", "Hides Chat", function()
    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
    end)
end)

RegisterCommand("showchat", {"schat"}, "", "none", "Shows Chat", function()
    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
    end)
end)

RegisterCommand("copygameid", {"cgid"}, "", "none", "Copies GameId", function()
    if setclipboard then
        setclipboard(tostring(game.GameId))
    end
end)

RegisterCommand("gameinfo", {}, "", "none", "Shows game info", function()
    pcall(function()
        local info = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
        Notify("Game Info", "Name: " .. info.Name)
    end)
end)

RegisterCommand("memory", {"mem"}, "", "none", "Shows memory", function()
    Notify("Utility", "Memory: " .. math.floor(gcinfo() / 1024) .. " MB")
end)

RegisterCommand("executor", {"exec"}, "", "none", "Shows executor", function()
    Notify("Utility", "Exec: " .. (identifyexecutor and identifyexecutor() or "Unknown"))
end)

RegisterCommand("network", {"net"}, "", "none", "Shows network", function()
    Notify("Utility", "Recv: " .. math.floor(Stats.DataReceiveKbps) .. " Kbps")
end)

RegisterCommand("screenshake", {"shake"}, "", "none", "Shakes screen", function()
    if shakeConn then
        shakeConn:Disconnect()
        shakeConn = nil
    else
        shakeConn = RunService.RenderStepped:Connect(function()
            Workspace.CurrentCamera.CFrame = Workspace.CurrentCamera.CFrame * CFrame.Angles(math.rad(math.random(-2, 2)), math.rad(math.random(-2, 2)), math.rad(math.random(-2, 2)))
        end)
    end
end)

RegisterCommand("disco", {"rainbow"}, "", "none", "Rainbow lighting", function()
    cacheLighting()
    if discoConn then
        discoConn:Disconnect()
        discoConn = nil
        Lighting.Ambient = Color3.new(1, 1, 1)
    else
        local hue = 0
        discoConn = RunService.RenderStepped:Connect(function()
            hue = hue + 0.005
            if hue > 1 then
                hue = 0
            end
            Lighting.Ambient = Color3.fromHSV(hue, 1, 1)
        end)
    end
end)

RegisterCommand("fire", {}, "", "none", "Locally set on fire", function()
    if getRoot(LocalPlayer.Character) then
        if getRoot(LocalPlayer.Character):FindFirstChild("PFire") then
            getRoot(LocalPlayer.Character).PFire:Destroy()
        else
            local fireObj = Instance.new("Fire", getRoot(LocalPlayer.Character))
            fireObj.Name = "PFire"
        end
    end
end)

RegisterCommand("smoke", {}, "", "none", "Locally smoke", function()
    if getRoot(LocalPlayer.Character) then
        if getRoot(LocalPlayer.Character):FindFirstChild("PSmoke") then
            getRoot(LocalPlayer.Character).PSmoke:Destroy()
        else
            local smokeObj = Instance.new("Smoke", getRoot(LocalPlayer.Character))
            smokeObj.Name = "PSmoke"
        end
    end
end)

RegisterCommand("sparkles", {"confetti"}, "", "none", "Locally sparkle", function()
    if getRoot(LocalPlayer.Character) then
        if getRoot(LocalPlayer.Character):FindFirstChild("PSp") then
            getRoot(LocalPlayer.Character).PSp:Destroy()
        else
            local sparklesObj = Instance.new("Sparkles", getRoot(LocalPlayer.Character))
            sparklesObj.Name = "PSp"
        end
    end
end)

RegisterCommand("saveinstance", {"savegame"}, "", "none", "Saves map", function()
    if saveinstance then
        saveinstance()
        Notify("System", "Saving...")
    else
        Notify("Error", "Not supported")
    end
end)

RegisterCommand("console", {}, "", "none", "Opens console", function()
    Notify("Console", "Coming soon")
end)

local function modScale(scaleValue)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        if humanoid:FindFirstChild("BodyWidthScale") then
            humanoid.BodyWidthScale.Value = scaleValue
            humanoid.BodyHeightScale.Value = scaleValue
            humanoid.BodyDepthScale.Value = scaleValue
            humanoid.HeadScale.Value = scaleValue
        end
    end
end

RegisterCommand("giant", {}, "", "none", "Makes you locally giant", function()
    cacheCharacter()
    modScale(3)
end)

RegisterCommand("tiny", {}, "", "none", "Makes you locally tiny", function()
    cacheCharacter()
    modScale(0.3)
end)

RegisterCommand("normalscale", {}, "", "none", "Resets scale", function()
    modScale(1)
end)

RegisterCommand("wide", {}, "", "none", "Makes you wide", function()
    cacheCharacter()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid:FindFirstChild("BodyWidthScale") then
        LocalPlayer.Character.Humanoid.BodyWidthScale.Value = 3
    end
end)

RegisterCommand("flat", {}, "", "none", "Makes you flat", function()
    cacheCharacter()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid:FindFirstChild("BodyDepthScale") then
        LocalPlayer.Character.Humanoid.BodyDepthScale.Value = 0.1
    end
end)

RegisterCommand("noarms", {}, "", "none", "Removes arms locally", function()
    cacheCharacter()
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part.Name:match("Arm") or part.Name:match("Hand") then
                part.Transparency = 1
            end
        end
    end
end)

RegisterCommand("nolegs", {}, "", "none", "Removes legs locally", function()
    cacheCharacter()
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part.Name:match("Leg") or part.Name:match("Foot") then
                part.Transparency = 1
            end
        end
    end
end)

RegisterCommand("torsoonly", {}, "", "none", "Leaves only torso", function()
    cacheCharacter()
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") and not part.Name:match("Torso") then
                part.Transparency = 1
            end
        end
    end
end)

RegisterCommand("fixchar", {"restorechar"}, "", "none", "Restores character parts", function()
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 0
            end
        end
    end
end)

RegisterCommand("spamsit", {}, "", "none", "Spams sit", function()
    if spamSitConn then
        spamSitConn:Disconnect()
        spamSitConn = nil
    else
        spamSitConn = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Sit = not LocalPlayer.Character.Humanoid.Sit
            end
        end)
    end
end)

RegisterCommand("spamjump", {}, "", "none", "Spams jump", function()
    if spamJumpConn then
        spamJumpConn:Disconnect()
        spamJumpConn = nil
    else
        spamJumpConn = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Jump = true
            end
        end)
    end
end)

RegisterCommand("walk", {}, "", "none", "Speed 16", function()
    cacheCharacter()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

RegisterCommand("run", {}, "", "none", "Speed 30", function()
    cacheCharacter()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 30
    end
end)

RegisterCommand("sprint", {}, "", "none", "Speed 50", function()
    cacheCharacter()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 50
    end
end)

RegisterCommand("flashspeed", {}, "", "none", "Speed 200", function()
    cacheCharacter()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 200
    end
end)

RegisterCommand("slowwalk", {}, "", "none", "Speed 8", function()
    cacheCharacter()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 8
    end
end)

RegisterCommand("crawl", {}, "", "none", "Speed 4", function()
    cacheCharacter()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 4
    end
end)

RegisterCommand("lowjump", {}, "", "none", "Jump 25", function()
    cacheCharacter()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = 25
    end
end)

RegisterCommand("highjump", {}, "", "none", "Jump 100", function()
    cacheCharacter()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = 100
    end
end)

RegisterCommand("superjump", {}, "", "none", "Jump 250", function()
    cacheCharacter()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = 250
    end
end)

RegisterCommand("megajump", {}, "", "none", "Jump 500", function()
    cacheCharacter()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = 500
    end
end)

local function doDash(vec, mult)
    if getRoot(LocalPlayer.Character) then
        getRoot(LocalPlayer.Character).AssemblyLinearVelocity = vec * mult
    end
end

RegisterCommand("dashforward", {"df"}, "", "none", "Dash fwd", function()
    if getRoot(LocalPlayer.Character) then
        doDash(getRoot(LocalPlayer.Character).CFrame.LookVector, 150)
    end
end)

RegisterCommand("dashback", {"db"}, "", "none", "Dash back", function()
    if getRoot(LocalPlayer.Character) then
        doDash(-getRoot(LocalPlayer.Character).CFrame.LookVector, 150)
    end
end)

RegisterCommand("dashleft", {"dl"}, "", "none", "Dash left", function()
    if getRoot(LocalPlayer.Character) then
        doDash(-getRoot(LocalPlayer.Character).CFrame.RightVector, 150)
    end
end)

RegisterCommand("dashright", {"dr"}, "", "none", "Dash right", function()
    if getRoot(LocalPlayer.Character) then
        doDash(getRoot(LocalPlayer.Character).CFrame.RightVector, 150)
    end
end)

RegisterCommand("dashup", {"du"}, "", "none", "Dash up", function()
    if getRoot(LocalPlayer.Character) then
        doDash(Vector3.new(0, 1, 0), 200)
    end
end)

RegisterCommand("dashdown", {"dd"}, "", "none", "Dash down", function()
    if getRoot(LocalPlayer.Character) then
        doDash(Vector3.new(0, -1, 0), 200)
    end
end)

local function doTP(vec)
    if getRoot(LocalPlayer.Character) then
        getRoot(LocalPlayer.Character).CFrame = getRoot(LocalPlayer.Character).CFrame + vec
    end
end

RegisterCommand("up", {}, "[num]", "none", "TP up studs", function(args)
    local studs = tonumber(args[2]) or 10
    doTP(Vector3.new(0, studs, 0))
end)

RegisterCommand("down", {}, "[num]", "none", "TP down studs", function(args)
    local studs = tonumber(args[2]) or 10
    doTP(Vector3.new(0, -studs, 0))
end)

RegisterCommand("forward", {"fwd"}, "[num]", "none", "TP fwd studs", function(args)
    local studs = tonumber(args[2]) or 10
    if getRoot(LocalPlayer.Character) then
        doTP(getRoot(LocalPlayer.Character).CFrame.LookVector * studs)
    end
end)

RegisterCommand("back", {}, "[num]", "none", "TP back studs", function(args)
    local studs = tonumber(args[2]) or 10
    if getRoot(LocalPlayer.Character) then
        doTP(-getRoot(LocalPlayer.Character).CFrame.LookVector * studs)
    end
end)

RegisterCommand("left", {}, "[num]", "none", "TP left studs", function(args)
    local studs = tonumber(args[2]) or 10
    if getRoot(LocalPlayer.Character) then
        doTP(-getRoot(LocalPlayer.Character).CFrame.RightVector * studs)
    end
end)

RegisterCommand("right", {}, "[num]", "none", "TP right studs", function(args)
    local studs = tonumber(args[2]) or 10
    if getRoot(LocalPlayer.Character) then
        doTP(getRoot(LocalPlayer.Character).CFrame.RightVector * studs)
    end
end)

RegisterCommand("day", {"morning"}, "", "none", "Time 14", function()
    cacheLighting()
    Lighting.ClockTime = 14
end)

RegisterCommand("night", {"midnight"}, "", "none", "Time 0", function()
    cacheLighting()
    Lighting.ClockTime = 0
end)

RegisterCommand("dawn", {"sunrise"}, "", "none", "Time 6", function()
    cacheLighting()
    Lighting.ClockTime = 6
end)

RegisterCommand("dusk", {"sunset"}, "", "none", "Time 18", function()
    cacheLighting()
    Lighting.ClockTime = 18
end)

RegisterCommand("redsky", {}, "", "none", "Red ambient", function()
    cacheLighting()
    Lighting.Ambient = Color3.new(1, 0, 0)
end)

RegisterCommand("bluesky", {}, "", "none", "Blue ambient", function()
    cacheLighting()
    Lighting.Ambient = Color3.new(0, 0, 1)
end)

RegisterCommand("greensky", {}, "", "none", "Green ambient", function()
    cacheLighting()
    Lighting.Ambient = Color3.new(0, 1, 0)
end)

RegisterCommand("blacksky", {}, "", "none", "Black ambient", function()
    cacheLighting()
    Lighting.Ambient = Color3.new(0, 0, 0)
end)

RegisterCommand("whitesky", {}, "", "none", "White ambient", function()
    cacheLighting()
    Lighting.Ambient = Color3.new(1, 1, 1)
end)

RegisterCommand("clearsky", {"nosky"}, "", "none", "Deletes Skybox", function()
    for _, obj in pairs(Lighting:GetChildren()) do
        if obj:IsA("Sky") then
            obj:Destroy()
        end
    end
end)

local originalPartProperties = {}

local function cachePartProperties()
    if not next(originalPartProperties) then
        for _, part in pairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                originalPartProperties[part] = {
                    Material = part.Material,
                    TopSurface = part.TopSurface,
                    BottomSurface = part.BottomSurface,
                    Transparency = part.Transparency
                }
            end
        end
    end
end

local function modMaterials(materialType)
    cachePartProperties()
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Material = materialType
        end
    end
end

RegisterCommand("plasticworld", {}, "", "none", "World to Plastic", function()
    modMaterials(Enum.Material.Plastic)
end)

RegisterCommand("neonworld", {}, "", "none", "World to Neon", function()
    modMaterials(Enum.Material.Neon)
end)

RegisterCommand("legoworld", {}, "", "none", "World to Studs", function()
    cachePartProperties()
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            part.TopSurface = Enum.SurfaceType.Studs
            part.BottomSurface = Enum.SurfaceType.Inlet
        end
    end
end)

RegisterCommand("smoothworld", {}, "", "none", "World to Smooth", function()
    cachePartProperties()
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            part.TopSurface = Enum.SurfaceType.Smooth
            part.BottomSurface = Enum.SurfaceType.Smooth
        end
    end
end)

RegisterCommand("iceage", {}, "", "none", "World to Ice", function()
    modMaterials(Enum.Material.Ice)
end)

RegisterCommand("glassworld", {}, "", "none", "World to Glass", function()
    modMaterials(Enum.Material.Glass)
end)

RegisterCommand("foilworld", {}, "", "none", "World to Foil", function()
    modMaterials(Enum.Material.Foil)
end)

RegisterCommand("woodworld", {}, "", "none", "World to Wood", function()
    modMaterials(Enum.Material.Wood)
end)

RegisterCommand("forcefieldworld", {}, "", "none", "World to ForceField", function()
    modMaterials(Enum.Material.ForceField)
end)

RegisterCommand("wireframe", {}, "", "none", "World to Wireframe", function()
    cachePartProperties()
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            local wire = Instance.new("SelectionBox", part)
            wire.Name = "PaperWireframe"
            wire.Adornee = part
            wire.LineThickness = 0.01
            part.Transparency = 1
        end
    end
end)

RegisterCommand("normalworld", {"unworld", "unwireframe"}, "", "none", "Restores the world", function()
    if not next(originalPartProperties) then return end
    for part, props in pairs(originalPartProperties) do
        if part and part.Parent then
            part.Material = props.Material
            part.TopSurface = props.TopSurface
            part.BottomSurface = props.BottomSurface
            part.Transparency = props.Transparency
            local wire = part:FindFirstChild("PaperWireframe")
            if wire then
                wire:Destroy()
            end
        end
    end
    originalPartProperties = {}
end)

RegisterCommand("delunanchored", {}, "", "none", "Deletes unanchored parts", function()
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part.Anchored and not part.Parent:FindFirstChild("Humanoid") then
            part:Destroy()
        end
    end
end)

RegisterCommand("cleartextures", {"cleardecals"}, "", "none", "Deletes decals", function()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Decal") or obj:IsA("Texture") then
            obj:Destroy()
        end
    end
end)

RegisterCommand("lowquality", {"lq"}, "", "none", "Low Graphics Mode", function()
    settings().Rendering.QualityLevel = 1
    sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility)
end)

RegisterCommand("highquality", {"hq"}, "", "none", "Max Graphics Mode", function()
    settings().Rendering.QualityLevel = 21
    sethiddenproperty(Lighting, "Technology", Enum.Technology.Future)
end)

RegisterCommand("invertcam", {}, "", "none", "Upside down cam", function()
    cacheCamera()
    Workspace.CurrentCamera.CFrame = Workspace.CurrentCamera.CFrame * CFrame.Angles(0, 0, math.rad(180))
end)

RegisterCommand("topdown", {}, "", "none", "Top down view", function()
    cacheCamera()
    Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    Workspace.CurrentCamera.CFrame = CFrame.new(getRoot(LocalPlayer.Character).Position + Vector3.new(0, 50, 0), getRoot(LocalPlayer.Character).Position)
end)

RegisterCommand("fixcam", {}, "", "none", "Resets Camera", function()
    Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
    Workspace.CurrentCamera.FieldOfView = 70
end)

RegisterCommand("unlockmouse", {}, "", "none", "Unlocks mouse", function()
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end)

RegisterCommand("lockmouse", {}, "", "none", "Locks mouse", function()
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
end)

RegisterCommand("hideplayerlist", {"hpl"}, "", "none", "Hides PlayerList", function()
    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
    end)
end)

RegisterCommand("showplayerlist", {"spl"}, "", "none", "Shows PlayerList", function()
    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
    end)
end)

RegisterCommand("hidebackpack", {"hbp"}, "", "none", "Hides Backpack", function()
    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
    end)
end)

RegisterCommand("showbackpack", {"sbp"}, "", "none", "Shows Backpack", function()
    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
    end)
end)

RegisterCommand("hideemotes", {}, "", "none", "Hides Emotes", function()
    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
    end)
end)

RegisterCommand("showemotes", {}, "", "none", "Shows Emotes", function()
    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, true)
    end)
end)

RegisterCommand("muteall", {"mute"}, "", "none", "Mutes game", function()
    game:GetService("SoundService").AmbientReverb = Enum.ReverbType.NoReverb
    for _, sound in pairs(Workspace:GetDescendants()) do
        if sound:IsA("Sound") then
            sound.Volume = 0
        end
    end
end)

RegisterCommand("unmuteall", {"unmute"}, "", "none", "Unmutes game", function()
    for _, sound in pairs(Workspace:GetDescendants()) do
        if sound:IsA("Sound") then
            sound.Volume = 1
        end
    end
end)

RegisterCommand("stopsounds", {}, "", "none", "Stops all playing sounds", function()
    for _, sound in pairs(Workspace:GetDescendants()) do
        if sound:IsA("Sound") then
            sound:Stop()
        end
    end
end)

RegisterCommand("earrape", {}, "", "none", "Maxes all volume", function()
    for _, sound in pairs(Workspace:GetDescendants()) do
        if sound:IsA("Sound") then
            sound.Volume = 10
        end
    end
end)

local function setColorChams(color)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = chamFolder:FindFirstChild(player.Name)
            if not highlight then
                highlight = Instance.new("Highlight", chamFolder)
                highlight.Name = player.Name
                highlight.Adornee = player.Character
            end
            highlight.FillColor = color
        end
    end
end

RegisterCommand("redchams", {}, "", "none", "Red Player ESP", function()
    setColorChams(Color3.new(1, 0, 0))
end)

RegisterCommand("bluechams", {}, "", "none", "Blue Player ESP", function()
    setColorChams(Color3.new(0, 0, 1))
end)

RegisterCommand("greenchams", {}, "", "none", "Green Player ESP", function()
    setColorChams(Color3.new(0, 1, 0))
end)

RegisterCommand("yellowchams", {}, "", "none", "Yellow Player ESP", function()
    setColorChams(Color3.new(1, 1, 0))
end)

RegisterCommand("whitechams", {}, "", "none", "White Player ESP", function()
    setColorChams(Color3.new(1, 1, 1))
end)

RegisterCommand("blackchams", {}, "", "none", "Black Player ESP", function()
    setColorChams(Color3.new(0, 0, 0))
end)

RegisterCommand("pinkchams", {}, "", "none", "Pink Player ESP", function()
    setColorChams(Color3.new(1, 0, 1))
end)

RegisterCommand("clearchams", {}, "", "none", "Removes Color ESP", function()
    chamFolder:ClearAllChildren()
end)

RegisterCommand("copylookvector", {"clv"}, "", "none", "Copies lookvector", function()
    if setclipboard and getRoot(LocalPlayer.Character) then
        setclipboard(tostring(getRoot(LocalPlayer.Character).CFrame.LookVector))
    end
end)

RegisterCommand("copydisplayname", {"cdn"}, "", "none", "Copies displayname", function()
    if setclipboard then
        setclipboard(LocalPlayer.DisplayName)
    end
end)

RegisterCommand("copyusername", {"cun"}, "", "none", "Copies username", function()
    if setclipboard then
        setclipboard(LocalPlayer.Name)
    end
end)

RegisterCommand("copycframe", {"ccf"}, "", "none", "Copies full CFrame", function()
    if setclipboard and getRoot(LocalPlayer.Character) then
        setclipboard(tostring(getRoot(LocalPlayer.Character).CFrame))
    end
end)

RegisterCommand("clearclipboard", {"ccb"}, "", "none", "Clears clipboard", function()
    if setclipboard then
        setclipboard("")
    end
end)

RegisterCommand("accountage", {"age"}, "", "none", "Shows Account Age", function()
    Notify("Account", "Age: " .. LocalPlayer.AccountAge .. " days")
end)

RegisterCommand("servertime", {"stime"}, "", "none", "Shows Server Time", function()
    Notify("Time", os.date("%X"))
end)

RegisterCommand("zerogravity", {"zerog"}, "", "none", "Gravity 0", function()
    Workspace.Gravity = 0
end)

RegisterCommand("lowgravity", {"lowg"}, "", "none", "Gravity 50", function()
    Workspace.Gravity = 50
end)

RegisterCommand("highgravity", {"highg"}, "", "none", "Gravity 400", function()
    Workspace.Gravity = 400
end)

RegisterCommand("supergravity", {"superg"}, "", "none", "Gravity 1000", function()
    Workspace.Gravity = 1000
end)

RegisterCommand("laydown", {"sleep"}, "", "none", "Lays character down", function()
    if getRoot(LocalPlayer.Character) then
        getRoot(LocalPlayer.Character).CFrame = getRoot(LocalPlayer.Character).CFrame * CFrame.Angles(math.rad(-90), 0, 0)
    end
end)

RegisterCommand("upsidedown", {}, "", "none", "Flips character", function()
    if getRoot(LocalPlayer.Character) then
        getRoot(LocalPlayer.Character).CFrame = getRoot(LocalPlayer.Character).CFrame * CFrame.Angles(math.rad(180), 0, 0)
    end
end)

RegisterCommand("sideways", {}, "", "none", "Turns character", function()
    if getRoot(LocalPlayer.Character) then
        getRoot(LocalPlayer.Character).CFrame = getRoot(LocalPlayer.Character).CFrame * CFrame.Angles(0, 0, math.rad(90))
    end
end)

RegisterCommand("sink", {}, "", "none", "Pushes into ground", function()
    if getRoot(LocalPlayer.Character) then
        getRoot(LocalPlayer.Character).CFrame = getRoot(LocalPlayer.Character).CFrame - Vector3.new(0, 3, 0)
    end
end)

RegisterCommand("rise", {}, "", "none", "Pulls from ground", function()
    if getRoot(LocalPlayer.Character) then
        getRoot(LocalPlayer.Character).CFrame = getRoot(LocalPlayer.Character).CFrame + Vector3.new(0, 3, 0)
    end
end)

RegisterCommand("massless", {}, "", "none", "Makes parts massless", function()
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Massless = true
            end
        end
    end
end)

RegisterCommand("unmassless", {}, "", "none", "Removes massless", function()
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Massless = false
            end
        end
    end
end)

RegisterCommand("cancollide", {}, "", "none", "Forces collide true", function()
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

RegisterCommand("blur", {}, "", "none", "Adds blur", function()
    local blurEffect = Lighting:FindFirstChild("PaperBlur")
    if not blurEffect then
        blurEffect = Instance.new("BlurEffect", Lighting)
        blurEffect.Name = "PaperBlur"
    end
    blurEffect.Size = 24
end)

RegisterCommand("unblur", {}, "", "none", "Removes blur", function()
    local blurEffect = Lighting:FindFirstChild("PaperBlur")
    if blurEffect then
        blurEffect:Destroy()
    end
end)

RegisterCommand("bloom", {}, "", "none", "Adds bloom", function()
    local bloomEffect = Lighting:FindFirstChild("PaperBloom")
    if not bloomEffect then
        bloomEffect = Instance.new("BloomEffect", Lighting)
        bloomEffect.Name = "PaperBloom"
    end
    bloomEffect.Intensity = 2
end)

RegisterCommand("unbloom", {}, "", "none", "Removes bloom", function()
    local bloomEffect = Lighting:FindFirstChild("PaperBloom")
    if bloomEffect then
        bloomEffect:Destroy()
    end
end)

RegisterCommand("sunrays", {}, "", "none", "Adds sunrays", function()
    local sunEffect = Lighting:FindFirstChild("PaperSunrays")
    if not sunEffect then
        sunEffect = Instance.new("SunRaysEffect", Lighting)
        sunEffect.Name = "PaperSunrays"
    end
    sunEffect.Intensity = 0.5
end)

RegisterCommand("unsunrays", {}, "", "none", "Removes sunrays", function()
    local sunEffect = Lighting:FindFirstChild("PaperSunrays")
    if sunEffect then
        sunEffect:Destroy()
    end
end)

RegisterCommand("matrix", {}, "", "none", "Matrix vision", function()
    cacheLighting()
    local cc = Lighting:FindFirstChild("PaperMatrix")
    if not cc then
        cc = Instance.new("ColorCorrectionEffect", Lighting)
        cc.Name = "PaperMatrix"
    end
    cc.TintColor = Color3.new(0.2, 1, 0.2)
    cc.Contrast = 0.5
end)

RegisterCommand("unmatrix", {}, "", "none", "Removes matrix", function()
    local cc = Lighting:FindFirstChild("PaperMatrix")
    if cc then
        cc:Destroy()
    end
end)

RegisterCommand("deepfry", {}, "", "none", "Deepfry screen", function()
    cacheLighting()
    local cc = Lighting:FindFirstChild("PaperDeepfry")
    if not cc then
        cc = Instance.new("ColorCorrectionEffect", Lighting)
        cc.Name = "PaperDeepfry"
    end
    cc.Saturation = 5
    cc.Contrast = 1.5
end)

RegisterCommand("undeepfry", {}, "", "none", "Removes deepfry", function()
    local cc = Lighting:FindFirstChild("PaperDeepfry")
    if cc then
        cc:Destroy()
    end
end)

RegisterCommand("tpsky", {}, "", "none", "Teleports extremely high", function()
    if getRoot(LocalPlayer.Character) then
        getRoot(LocalPlayer.Character).CFrame = getRoot(LocalPlayer.Character).CFrame + Vector3.new(0, 50000, 0)
    end
end)

RegisterCommand("tpvoid", {}, "", "none", "Teleports to the void", function()
    if getRoot(LocalPlayer.Character) then
        getRoot(LocalPlayer.Character).CFrame = getRoot(LocalPlayer.Character).CFrame - Vector3.new(0, 50000, 0)
    end
end)

RegisterCommand("tporigin", {"center"}, "", "none", "Teleports to center", function()
    if getRoot(LocalPlayer.Character) then
        getRoot(LocalPlayer.Character).CFrame = CFrame.new(0, 50, 0)
    end
end)

RegisterCommand("randomtp", {"rtp"}, "", "none", "Teleports randomly", function()
    if getRoot(LocalPlayer.Character) then
        local rx = math.random(-5000, 5000)
        local rz = math.random(-5000, 5000)
        getRoot(LocalPlayer.Character).CFrame = CFrame.new(rx, 500, rz)
    end
end)

RegisterCommand("drop", {}, "", "none", "Zeroes vertical velocity", function()
    if getRoot(LocalPlayer.Character) then
        local currentVel = getRoot(LocalPlayer.Character).AssemblyLinearVelocity
        getRoot(LocalPlayer.Character).AssemblyLinearVelocity = Vector3.new(currentVel.X, -500, currentVel.Z)
    end
end)

RegisterCommand("noface", {"removeface"}, "", "none", "Removes local face", function()
    cacheCharacter()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") and LocalPlayer.Character.Head:FindFirstChild("face") then
        LocalPlayer.Character.Head.face:Destroy()
    end
end)

RegisterCommand("deletehats", {"nohats"}, "", "none", "Removes hats locally", function()
    cacheCharacter()
    if LocalPlayer.Character then
        for _, obj in pairs(LocalPlayer.Character:GetChildren()) do
            if obj:IsA("Accessory") then
                obj:Destroy()
            end
        end
    end
end)

RegisterCommand("naked", {}, "", "none", "Removes clothing locally", function()
    cacheCharacter()
    if LocalPlayer.Character then
        for _, obj in pairs(LocalPlayer.Character:GetChildren()) do
            if obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") then
                obj:Destroy()
            end
        end
    end
end)

RegisterCommand("waterworld", {}, "", "none", "Materials to water", function()
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.Water
        end
    end
end)

RegisterCommand("lavaworld", {}, "", "none", "Materials to neon orange", function()
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.Neon
            part.Color = Color3.fromRGB(255, 100, 0)
        end
    end
end)

RegisterCommand("removeterrain", {"noterrain"}, "", "none", "Clears local terrain", function()
    Workspace.Terrain:Clear()
end)

RegisterCommand("nofoliage", {"nograss"}, "", "none", "Removes grass details", function()
    Workspace.Terrain.Decoration = false
end)

RegisterCommand("btools", {"f3x"}, "", "none", "Loads BTools locally", function()
    local btools = Instance.new("HopperBin", LocalPlayer.Backpack)
    btools.BinType = Enum.BinType.Clone
    local btools2 = Instance.new("HopperBin", LocalPlayer.Backpack)
    btools2.BinType = Enum.BinType.Hammer
    local btools3 = Instance.new("HopperBin", LocalPlayer.Backpack)
    btools3.BinType = Enum.BinType.Grab
    Notify("Tools", "Classic BTools Added")
end)

RegisterCommand("cyanchams", {}, "", "none", "Cyan Player ESP", function()
    setColorChams(Color3.new(0, 1, 1))
end)

RegisterCommand("magentachams", {}, "", "none", "Magenta Player ESP", function()
    setColorChams(Color3.new(1, 0, 1))
end)

RegisterCommand("orangechams", {}, "", "none", "Orange Player ESP", function()
    setColorChams(Color3.new(1, 0.5, 0))
end)

RegisterCommand("purplechams", {}, "", "none", "Purple Player ESP", function()
    setColorChams(Color3.new(0.5, 0, 1))
end)

RegisterCommand("ghostchams", {}, "", "none", "Ghostly Player ESP", function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = chamFolder:FindFirstChild(player.Name)
            if not highlight then
                highlight = Instance.new("Highlight", chamFolder)
                highlight.Name = player.Name
                highlight.Adornee = player.Character
            end
            highlight.FillColor = Color3.new(1, 1, 1)
            highlight.FillTransparency = 0.8
        end
    end
end)

RegisterCommand("solidchams", {}, "", "none", "Solid White ESP", function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = chamFolder:FindFirstChild(player.Name)
            if not highlight then
                highlight = Instance.new("Highlight", chamFolder)
                highlight.Name = player.Name
                highlight.Adornee = player.Character
            end
            highlight.FillColor = Color3.new(1, 1, 1)
            highlight.FillTransparency = 0
            highlight.OutlineTransparency = 1
        end
    end
end)

RegisterCommand("fixlighting", {"unlighting", "normallighting"}, "", "none", "Restores lighting", function()
    if originalLighting then
        Lighting.Ambient = originalLighting.Ambient
        Lighting.Brightness = originalLighting.Brightness
        Lighting.ClockTime = originalLighting.ClockTime
        Lighting.FogEnd = originalLighting.FogEnd
        Lighting.GlobalShadows = originalLighting.GlobalShadows
        if originalLighting.ColorShift_Bottom then
            pcall(function() Lighting.ColorShift_Bottom = originalLighting.ColorShift_Bottom end)
        end
        if originalLighting.ColorShift_Top then
            pcall(function() Lighting.ColorShift_Top = originalLighting.ColorShift_Top end)
        end
        if originalLighting.OutdoorAmbient then
            pcall(function() Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient end)
        end
    end
end)

RegisterCommand("fixchar", {"restorechar", "unchar"}, "", "none", "Restores character parts/stats", function()
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 0
            end
        end
        if originalCharProps[LocalPlayer.Character] and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local props = originalCharProps[LocalPlayer.Character]
            local hum = LocalPlayer.Character.Humanoid
            hum.WalkSpeed = props.WalkSpeed
            hum.JumpPower = props.JumpPower
            hum.UseJumpPower = props.UseJumpPower
            hum.HipHeight = props.HipHeight
            hum.MaxHealth = props.MaxHealth
            if hum:FindFirstChild("BodyWidthScale") then hum.BodyWidthScale.Value = props.BodyWidthScale end
            if hum:FindFirstChild("BodyHeightScale") then hum.BodyHeightScale.Value = props.BodyHeightScale end
            if hum:FindFirstChild("BodyDepthScale") then hum.BodyDepthScale.Value = props.BodyDepthScale end
            if hum:FindFirstChild("HeadScale") then hum.HeadScale.Value = props.HeadScale end
        end
    end
end)

RegisterCommand("fixcam", {"uncam", "normalcam"}, "", "none", "Resets Camera", function()
    Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
    end
    if originalCamera then
        Workspace.CurrentCamera.FieldOfView = originalCamera.FieldOfView
    else
        Workspace.CurrentCamera.FieldOfView = 70
    end
    LocalPlayer.CameraMode = Enum.CameraMode.Classic
    LocalPlayer.CameraMaxZoomDistance = 400
end)

RegisterCommand("revertall", {"unall", "resetall"}, "", "none", "Reverts all cacheable commands", function()
    pcall(function() LocalCmdRegistry[#LocalCmdRegistry].Callback() end) -- This is a bit hacky, let's call the functions directly.
    -- Wait, instead of calling the registry, I'll just run the logic of the normal commands.
    
    -- Fix Lighting
    if originalLighting then
        Lighting.Ambient = originalLighting.Ambient
        Lighting.Brightness = originalLighting.Brightness
        Lighting.ClockTime = originalLighting.ClockTime
        Lighting.FogEnd = originalLighting.FogEnd
        Lighting.GlobalShadows = originalLighting.GlobalShadows
    end
    
    -- Fix Char
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 0
            end
        end
        if originalCharProps[LocalPlayer.Character] and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local props = originalCharProps[LocalPlayer.Character]
            local hum = LocalPlayer.Character.Humanoid
            hum.WalkSpeed = props.WalkSpeed
            hum.JumpPower = props.JumpPower
            hum.UseJumpPower = props.UseJumpPower
            hum.HipHeight = props.HipHeight
            hum.MaxHealth = props.MaxHealth
            if hum:FindFirstChild("BodyWidthScale") then hum.BodyWidthScale.Value = props.BodyWidthScale end
            if hum:FindFirstChild("BodyHeightScale") then hum.BodyHeightScale.Value = props.BodyHeightScale end
            if hum:FindFirstChild("BodyDepthScale") then hum.BodyDepthScale.Value = props.BodyDepthScale end
            if hum:FindFirstChild("HeadScale") then hum.HeadScale.Value = props.HeadScale end
        end
    end
    
    -- Fix Cam
    Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
    end
    if originalCamera then
        Workspace.CurrentCamera.FieldOfView = originalCamera.FieldOfView
    else
        Workspace.CurrentCamera.FieldOfView = 70
    end
    LocalPlayer.CameraMode = Enum.CameraMode.Classic
    LocalPlayer.CameraMaxZoomDistance = 400
    
    -- Fix World
    if next(originalPartProperties) then
        for part, props in pairs(originalPartProperties) do
            if part and part.Parent then
                part.Material = props.Material
                part.TopSurface = props.TopSurface
                part.BottomSurface = props.BottomSurface
                part.Transparency = props.Transparency
                local wire = part:FindFirstChild("PaperWireframe")
                if wire then
                    wire:Destroy()
                end
            end
        end
        originalPartProperties = {}
    end
    
    -- Fix Workspace
    if originalWorkspaceProps then
        Workspace.Gravity = originalWorkspaceProps.Gravity
    end
end)

RegisterCommand("flipcam", {}, "", "none", "Rolls camera sideways", function()
    cacheCamera()
    Workspace.CurrentCamera.CFrame = Workspace.CurrentCamera.CFrame * CFrame.Angles(0, 0, math.rad(90))
end)

RegisterCommand("lagserver", {}, "", "none", "FPS drop loops", function()
    RunService.RenderStepped:Connect(function()
        for i = 1, 1000 do
            local mathWaste = math.sqrt(i * i)
        end
    end)
    Notify("Warning", "Client lag generated")
end)

RegisterCommand("printpos", {}, "", "none", "Prints position", function()
    if getRoot(LocalPlayer.Character) then
        print(getRoot(LocalPlayer.Character).Position)
    end
end)

RegisterCommand("spinspeed", {}, "[num]", "none", "Sets fly spin speed", function(args)
    local val = tonumber(args[2])
    if val then
        if spinConn then
            spinConn:Disconnect()
        end
        spinConn = RunService.RenderStepped:Connect(function()
            if getRoot(LocalPlayer.Character) then
                getRoot(LocalPlayer.Character).CFrame = getRoot(LocalPlayer.Character).CFrame * CFrame.Angles(0, math.rad(val), 0)
            end
        end)
    end
end)

for i = 0, 24 do
    RegisterCommand("time" .. i, {}, "", "none", "Set Time to " .. i, function()
        Lighting.ClockTime = i
    end)
end

for i = 0, 10 do
    RegisterCommand("brightness" .. i, {"b" .. i}, "", "none", "Set Brightness " .. i, function()
    cacheLighting()
        Lighting.Brightness = i
    end)
end

for i = 10, 150, 10 do
    RegisterCommand("fov" .. i, {}, "", "none", "FOV " .. i, function()
    cacheCamera()
        Workspace.CurrentCamera.FieldOfView = i
    end)
end
