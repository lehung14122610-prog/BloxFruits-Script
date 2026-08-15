--[[
    ===================================================================================
    ★ CORE: MOVEMENT.LUA - ADVANCED TRAVEL & HOVER ENGINE V9.0 ★
    Giải quyết triệt để lỗi bay quá cao, lỗi huỷ Tween liên tục và lỗi văng nhân vật.
    ===================================================================================
--]]

local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera or Workspace:FindFirstChildOfClass("Camera")

local Movement = {}
local HoverBodyPos, HoverBodyGyro = nil, nil
local ActiveTween = nil
local CurrentTravelThread = nil
local IsTraveling = false

local flyBodyVel, flyBodyGyro = nil, nil
local flyKeys = {W = false, A = false, S = false, D = false, E = false, Q = false}

local function GetRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
end

-- 1. HOVER LOCK AN TOÀN (KHOÁ CỐ ĐỊNH TRÊN ĐẦU QUÁI KHI FARM)
function Movement.LockHover(targetCFrame)
    local root = GetRoot()
    local hum = GetHumanoid()
    if not root or not hum then return end
    
    root.Velocity = Vector3.new(0, 0, 0)
    root.RotVelocity = Vector3.new(0, 0, 0)
    hum.PlatformStand = true
    
    if not HoverBodyPos or HoverBodyPos.Parent ~= root then
        if HoverBodyPos then HoverBodyPos:Destroy() end
        HoverBodyPos = Instance.new("BodyPosition")
        HoverBodyPos.Name = "BF_Titan_HoverPos"
        HoverBodyPos.P = 35000
        HoverBodyPos.D = 750
        HoverBodyPos.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        HoverBodyPos.Position = targetCFrame.Position
        HoverBodyPos.Parent = root
    else
        HoverBodyPos.Position = targetCFrame.Position
    end
    
    if not HoverBodyGyro or HoverBodyGyro.Parent ~= root then
        if HoverBodyGyro then HoverBodyGyro:Destroy() end
        HoverBodyGyro = Instance.new("BodyGyro")
        HoverBodyGyro.Name = "BF_Titan_HoverGyro"
        HoverBodyGyro.P = 35000
        HoverBodyGyro.D = 750
        HoverBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        HoverBodyGyro.CFrame = targetCFrame
        HoverBodyGyro.Parent = root
    else
        HoverBodyGyro.CFrame = targetCFrame
    end
end

function Movement.DisableHoverLock()
    local hum = GetHumanoid()
    local root = GetRoot()
    if HoverBodyPos then HoverBodyPos:Destroy() HoverBodyPos = nil end
    if HoverBodyGyro then HoverBodyGyro:Destroy() HoverBodyGyro = nil end
    if root then
        root.Velocity = Vector3.new(0, 0, 0)
        root.RotVelocity = Vector3.new(0, 0, 0)
    end
    if hum and not (getgenv().BF_Hub_Config and getgenv().BF_Hub_Config.Fly) then
        hum.PlatformStand = false
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
end

-- 2. TWEEN ENGINE KHÔNG BỊ HUỶ TRONG VÒNG LẶP (NON-CANCELLING TRAVEL)
function Movement.StopTravel()
    IsTraveling = false
    if ActiveTween then
        ActiveTween:Cancel()
        ActiveTween = nil
    end
    Movement.DisableHoverLock()
end

function Movement.IsCurrentlyTraveling()
    return IsTraveling
end

function Movement.TravelTo(targetCFrame, customSpeed, onComplete)
    local root = GetRoot()
    local hum = GetHumanoid()
    if not root or not hum then return end
    
    Movement.DisableHoverLock()
    hum.PlatformStand = true
    root.Velocity = Vector3.new(0, 0, 0)
    
    local speed = customSpeed or (getgenv().BF_Hub_Config and getgenv().BF_Hub_Config.TweenSpeed or 280)
    local currentPos = root.Position
    local targetPos = targetCFrame.Position
    local distance = (currentPos - targetPos).Magnitude
    
    if distance < 6.0 then
        root.CFrame = targetCFrame
        IsTraveling = false
        if onComplete then onComplete() end
        return
    end
    
    IsTraveling = true
    
    -- Nếu khoảng cách xa (> 600 studs), bay qua biển ở độ cao êm ái (+45 studs)
    if distance > 600 then
        local safeY = math.max(currentPos.Y, targetPos.Y, 45) + 35
        local midPos = Vector3.new((currentPos.X + targetPos.X) / 2, safeY, (currentPos.Z + targetPos.Z) / 2)
        
        local twInfo1 = TweenInfo.new((currentPos - midPos).Magnitude / speed, Enum.EasingStyle.Linear)
        ActiveTween = TweenService:Create(root, twInfo1, {CFrame = CFrame.new(midPos)})
        ActiveTween:Play()
        
        ActiveTween.Completed:Connect(function(status)
            if status == Enum.PlaybackState.Completed and IsTraveling then
                local twInfo2 = TweenInfo.new((midPos - targetPos).Magnitude / speed, Enum.EasingStyle.Linear)
                ActiveTween = TweenService:Create(root, twInfo2, {CFrame = targetCFrame})
                ActiveTween:Play()
                ActiveTween.Completed:Connect(function(s2)
                    if s2 == Enum.PlaybackState.Completed then
                        IsTraveling = false
                        if onComplete then onComplete() end
                    end
                end)
            end
        end)
    else
        local twInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
        ActiveTween = TweenService:Create(root, twInfo, {CFrame = targetCFrame})
        ActiveTween:Play()
        ActiveTween.Completed:Connect(function(status)
            if status == Enum.PlaybackState.Completed then
                IsTraveling = false
                if onComplete then onComplete() end
            end
        end)
    end
end

-- 3. FLY V3 ENGINE - ĐIỀU KHIỂN SIÊU MƯỢT TRÊN PC & BLUESTACKS
function Movement.StartFly(speed)
    local root = GetRoot()
    local hum = GetHumanoid()
    if not root or not hum then return end
    
    Movement.StopTravel()
    hum.PlatformStand = true
    root.Velocity = Vector3.new(0, 0, 0)
    
    if flyBodyVel then flyBodyVel:Destroy() end
    if flyBodyGyro then flyBodyGyro:Destroy() end
    
    flyBodyVel = Instance.new("BodyVelocity")
    flyBodyVel.Name = "BF_Titan_FlyVel"
    flyBodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyBodyVel.Velocity = Vector3.new(0, 0, 0)
    flyBodyVel.Parent = root
    
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.Name = "BF_Titan_FlyGyro"
    flyBodyGyro.P = 40000
    flyBodyGyro.D = 800
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
            flyBodyVel.Velocity = moveDir * (speed or (cfg and cfg.FlySpeed) or 75)
            flyBodyGyro.CFrame = camCF
            RunService.RenderStepped:Wait()
        end
        Movement.StopFly()
    end)
end

function Movement.StopFly()
    local root = GetRoot()
    local hum = GetHumanoid()
    if flyBodyVel then flyBodyVel:Destroy() flyBodyVel = nil end
    if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
    if root then
        root.Velocity = Vector3.new(0, 0, 0)
        root.RotVelocity = Vector3.new(0, 0, 0)
    end
    if hum then
        hum.PlatformStand = false
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
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

-- 4. NOCLIP THREAD CHỐNG KẸT ĐỊA HÌNH
RunService.Stepped:Connect(function()
    local cfg = getgenv().BF_Hub_Config
    if cfg and (cfg.Noclip or cfg.AutoFarmLevel or cfg.AutoFarmSelectedMob or cfg.AutoFarmBoss or cfg.Fly or cfg.AutoFarmChest or IsTraveling) then
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

-- 5. WATER WALK THREAD
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

-- 6. WALKSPEED & JUMPPOWER & INFINITE JUMP
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
