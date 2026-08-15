-- [ CORE: MOVEMENT.LUA - TWEEN BYPASS, GRAVITY LOCK & FLY V2 ]
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera or Workspace:FindFirstChildOfClass("Camera")

local Movement = {}
local FarmBodyVel, FarmBodyGyro = nil, nil
local ActiveTween = nil
local flyBodyVel, flyBodyGyro = nil, nil
local flyKeys = {W = false, A = false, S = false, D = false, E = false, Q = false}

local function GetRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

function Movement.EnableGravityLock(targetCFrame)
    local root = GetRoot()
    if not root then return end
    
    if not FarmBodyVel or FarmBodyVel.Parent ~= root then
        if FarmBodyVel then FarmBodyVel:Destroy() end
        FarmBodyVel = Instance.new("BodyVelocity")
        FarmBodyVel.Name = "BF_Hub_GravityLock_Vel"
        FarmBodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        FarmBodyVel.Velocity = Vector3.new(0, 0, 0)
        FarmBodyVel.Parent = root
    end
    
    if not FarmBodyGyro or FarmBodyGyro.Parent ~= root then
        if FarmBodyGyro then FarmBodyGyro:Destroy() end
        FarmBodyGyro = Instance.new("BodyGyro")
        FarmBodyGyro.Name = "BF_Hub_GravityLock_Gyro"
        FarmBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        FarmBodyGyro.CFrame = targetCFrame or root.CFrame
        FarmBodyGyro.Parent = root
    end
    
    if targetCFrame and FarmBodyGyro then
        FarmBodyGyro.CFrame = targetCFrame
    end
end

function Movement.DisableGravityLock()
    if FarmBodyVel then FarmBodyVel:Destroy() FarmBodyVel = nil end
    if FarmBodyGyro then FarmBodyGyro:Destroy() FarmBodyGyro = nil end
end

function Movement.StopTween()
    if ActiveTween then
        ActiveTween:Cancel()
        ActiveTween = nil
    end
end

function Movement.TweenTo(targetCFrame, customSpeed)
    local root = GetRoot()
    if not root then return end
    
    local speed = customSpeed or (getgenv().BF_Hub_Config and getgenv().BF_Hub_Config.TweenSpeed or 275)
    local distance = (root.Position - targetCFrame.Position).Magnitude
    
    if distance < 3.5 then
        root.CFrame = targetCFrame
        return nil
    end
    
    local time = distance / speed
    Movement.StopTween()
    
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    ActiveTween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
    ActiveTween:Play()
    return ActiveTween
end

function Movement.SafeWayPointTween(targetCFrame)
    local root = GetRoot()
    if not root then return end
    
    local currentPos = root.Position
    local targetPos = targetCFrame.Position
    local dist = (currentPos - targetPos).Magnitude
    
    if dist > 800 then
        local highPos1 = Vector3.new(currentPos.X, 950, currentPos.Z)
        local highPos2 = Vector3.new(targetPos.X, 950, targetPos.Z)
        
        local tw1 = Movement.TweenTo(CFrame.new(highPos1))
        if tw1 then tw1.Completed:Wait() end
        
        local tw2 = Movement.TweenTo(CFrame.new(highPos2))
        if tw2 then tw2.Completed:Wait() end
        
        local tw3 = Movement.TweenTo(targetCFrame)
        if tw3 then tw3.Completed:Wait() end
    else
        Movement.TweenTo(targetCFrame)
    end
end

function Movement.StartFly(speed)
    local root = GetRoot()
    if not root then return end
    
    if flyBodyVel then flyBodyVel:Destroy() end
    if flyBodyGyro then flyBodyGyro:Destroy() end
    
    flyBodyVel = Instance.new("BodyVelocity")
    flyBodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyBodyVel.Velocity = Vector3.new(0, 0, 0)
    flyBodyVel.Parent = root
    
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    flyBodyGyro.CFrame = root.CFrame
    flyBodyGyro.Parent = root
    
    task.spawn(function()
        local cfg = getgenv().BF_Hub_Config
        while cfg and cfg.Fly and flyBodyVel and flyBodyGyro do
            local moveDir = Vector3.new(0, 0, 0)
            local camCF = Camera.CFrame
            
            if flyKeys.W then moveDir = moveDir + camCF.LookVector end
            if flyKeys.S then moveDir = moveDir - camCF.LookVector end
            if flyKeys.A then moveDir = moveDir - camCF.RightVector end
            if flyKeys.D then moveDir = moveDir + camCF.RightVector end
            if flyKeys.E then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if flyKeys.Q then moveDir = moveDir - Vector3.new(0, 1, 0) end
            
            if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
            flyBodyVel.Velocity = moveDir * (speed or 75)
            flyBodyGyro.CFrame = camCF
            RunService.RenderStepped:Wait()
        end
        Movement.StopFly()
    end)
end

function Movement.StopFly()
    if flyBodyVel then flyBodyVel:Destroy() flyBodyVel = nil end
    if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local k = input.KeyCode.Name
    if flyKeys[k] ~= nil then flyKeys[k] = true end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    local k = input.KeyCode.Name
    if flyKeys[k] ~= nil then flyKeys[k] = false end
end)

-- Noclip Thread
RunService.Stepped:Connect(function()
    local cfg = getgenv().BF_Hub_Config
    if cfg and (cfg.Noclip or cfg.AutoFarmLevel or cfg.AutoFarmSelectedMob or cfg.AutoFarmBoss or cfg.Fly) then
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

-- Water Walk Platform
local WaterPlatform = Instance.new("Part")
WaterPlatform.Name = "BF_Hub_WaterPlatform_Titan"
WaterPlatform.Size = Vector3.new(600, 1, 600)
WaterPlatform.Anchored = true
WaterPlatform.Transparency = 1
WaterPlatform.Parent = Workspace

RunService.RenderStepped:Connect(function()
    local cfg = getgenv().BF_Hub_Config
    if cfg and cfg.WaterWalk then
        local root = GetRoot()
        if root then
            if root.Position.Y <= 26 then
                WaterPlatform.CFrame = CFrame.new(root.Position.X, 10, root.Position.Z)
                WaterPlatform.CanCollide = true
            else
                WaterPlatform.CanCollide = false
            end
        end
    else
        WaterPlatform.CanCollide = false
    end
end)

-- WalkSpeed & JumpPower
RunService.RenderStepped:Connect(function()
    local cfg = getgenv().BF_Hub_Config
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if cfg and hum then
        if cfg.WalkSpeedToggle then hum.WalkSpeed = cfg.WalkSpeed end
        if cfg.JumpPowerToggle then hum.UseJumpPower = true hum.JumpPower = cfg.JumpPower end
    end
end)

UserInputService.JumpRequest:Connect(function()
    local cfg = getgenv().BF_Hub_Config
    if cfg and cfg.InfiniteJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

return Movement
