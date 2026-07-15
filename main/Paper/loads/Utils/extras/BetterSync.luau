local Users = game:GetService("Players") 
local Inputs = game:GetService("UserInputService") 
local Runtime = game:GetService("RunService")

local Client = Users.LocalPlayer

local Handler = {} 
Handler.__index = Handler

function Handler.new() 
    local self = setmetatable({}, Handler)

    self.Active = false
    self.Memory = buffer.create(24)

    self.FixedRot = CFrame.identity
    self.TrueRot = CFrame.identity
    self.TrueVel = Vector3.zero
    self.TrueAng = Vector3.zero

    self.TickTask = nil
    self.TaskName = "DesyncTask"

    return self
end

function Handler:Store(index, pos)
    buffer.writef32(self.Memory, index, pos.X)
    buffer.writef32(self.Memory, index + 4, pos.Y)
    buffer.writef32(self.Memory, index + 8, pos.Z) 
end

function Handler:Fetch(index) 
    local x = buffer.readf32(self.Memory, index) 
    local y = buffer.readf32(self.Memory, index + 4) 
    local z = buffer.readf32(self.Memory, index + 8) 
    return Vector3.new(x, y, z)
end

function Handler:Toggle() 
    self.Active = not self.Active

    local model = Client.Character
    if not model then
        self.Active = false
        return
    end

    local root = model:FindFirstChild("HumanoidRootPart")
    if not root then
        self.Active = false
        return
    end

    if self.Active then
        self.FixedRot = root.CFrame.Rotation
        self:Store(0, root.CFrame.Position)
        
        self.TrueRot = root.CFrame.Rotation
        self:Store(12, root.CFrame.Position)
        
        self.TrueVel = root.AssemblyLinearVelocity
        self.TrueAng = root.AssemblyAngularVelocity

        self.TickTask = Runtime.Heartbeat:Connect(function()
            local curModel = Client.Character
            if not curModel then return end
            
            local curRoot = curModel:FindFirstChild("HumanoidRootPart")
            if not curRoot then return end

            self.TrueRot = curRoot.CFrame.Rotation
            self:Store(12, curRoot.CFrame.Position)
            self.TrueVel = curRoot.AssemblyLinearVelocity
            self.TrueAng = curRoot.AssemblyAngularVelocity

            local fixedPos = self:Fetch(0)
            curRoot.CFrame = CFrame.new(fixedPos) * self.FixedRot
            curRoot.AssemblyLinearVelocity = Vector3.zero
            curRoot.AssemblyAngularVelocity = Vector3.zero
        end)

        Runtime:BindToRenderStep(self.TaskName, Enum.RenderPriority.Camera.Value - 1, function()
            local curModel = Client.Character
            if not curModel then return end
            
            local curRoot = curModel:FindFirstChild("HumanoidRootPart")
            if not curRoot then return end

            local truePos = self:Fetch(12)
            curRoot.CFrame = CFrame.new(truePos) * self.TrueRot
            curRoot.AssemblyLinearVelocity = self.TrueVel
            curRoot.AssemblyAngularVelocity = self.TrueAng
        end)

    else
        if self.TickTask then
            self.TickTask:Disconnect()
            self.TickTask = nil
        end
        
        pcall(function()
            Runtime:UnbindFromRenderStep(self.TaskName)
        end)

        local truePos = self:Fetch(12)
        root.CFrame = CFrame.new(truePos) * self.TrueRot
        root.AssemblyLinearVelocity = self.TrueVel
        root.AssemblyAngularVelocity = self.TrueAng
    end
end

local Session = Handler.new()

Inputs.InputBegan:Connect(function(input, handled)
    if Session.Active then
        local model = Client.Character
        if model then
            local root = model:FindFirstChild("HumanoidRootPart")
            if root then
                local truePos = Session:Fetch(12)
                root.CFrame = CFrame.new(truePos) * Session.TrueRot
            end
        end
    end

    if handled then return end

    if input.KeyCode == Enum.KeyCode.G then
        Session:Toggle()
    end
end)

Client.CharacterAdded:Connect(function() 
    if Session.Active then 
        Session:Toggle() 
    end 
end)
