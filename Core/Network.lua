--[[
    ===================================================================================
    ★ CORE: NETWORK.LUA - WEAPON & ATTACK ENGINE V9.0 ★
    Khắc phục triệt để lỗi swap vũ khí liên tục, click ảo chính xác, đăng ký sát thương.
    ===================================================================================
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera or Workspace:FindFirstChildOfClass("Camera")
local LocalPlayer = Players.LocalPlayer

local Network = {}

local MeleeNames = {
    "Combat", "Dark Step", "Electric", "Water Kung Fu", "Dragon Breath",
    "Superhuman", "Death Step", "Sharkman Karate", "Electric Claw",
    "Dragon Talon", "Godhuman", "Sanguine Art"
}

function Network.GetCharacter()
    return LocalPlayer.Character
end

function Network.GetRoot()
    local char = Network.GetCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

function Network.GetHumanoid()
    local char = Network.GetCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

function Network.GetPlayerLevelSafe()
    local lvl = 1
    pcall(function()
        if LocalPlayer and LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level") then
            lvl = tonumber(LocalPlayer.Data.Level.Value) or 1
        end
    end)
    return lvl
end

function Network.GetPlayerBeli()
    local beli = 0
    pcall(function()
        if LocalPlayer and LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Beli") then
            beli = tonumber(LocalPlayer.Data.Beli.Value) or 0
        end
    end)
    return beli
end

function Network.GetPlayerFragments()
    local frags = 0
    pcall(function()
        if LocalPlayer and LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Fragments") then
            frags = tonumber(LocalPlayer.Data.Fragments.Value) or 0
        end
    end)
    return frags
end

function Network.InvokeCommF(arg1, arg2, arg3, arg4)
    local res = nil
    pcall(function()
        if ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_") then
            res = ReplicatedStorage.Remotes.CommF_:InvokeServer(arg1, arg2, arg3, arg4)
        end
    end)
    return res
end

local function IsToolMatch(tool, targetType)
    if not tool or not tool:IsA("Tool") then return false end
    local tip = tool.ToolTip or ""
    local name = tool.Name
    
    if targetType == "Melee" then
        if tip == "Melee" then return true end
        for _, mName in ipairs(MeleeNames) do
            if name:find(mName) then return true end
        end
        if tip ~= "Sword" and tip ~= "Gun" and tip ~= "Blox Fruit" and not name:find("Fruit") then
            return true
        end
    elseif targetType == "Sword" then
        if tip == "Sword" then return true end
    elseif targetType == "Blox Fruit" then
        if tip == "Blox Fruit" or name:find("Fruit") then return true end
    elseif targetType == "Gun" then
        if tip == "Gun" then return true end
    end
    return false
end

-- TRANG BỊ VŨ KHÍ ỔN ĐỊNH: Chỉ rút vũ khí khi chưa cầm đúng loại
function Network.EnsureWeaponEquipped(targetType)
    local char = Network.GetCharacter()
    local hum = Network.GetHumanoid()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not char or not hum then return nil end
    
    local currentTool = char:FindFirstChildOfClass("Tool")
    if currentTool and IsToolMatch(currentTool, targetType) then
        return currentTool
    end
    
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and IsToolMatch(tool, targetType) then
                hum:EquipTool(tool)
                return tool
            end
        end
        if not currentTool then
            local firstTool = backpack:FindFirstChildOfClass("Tool")
            if firstTool then
                hum:EquipTool(firstTool)
                return firstTool
            end
        end
    end
    return currentTool
end

-- XẢ ĐÒN TẤN CÔNG LIÊN HOÀN
function Network.ExecuteFastAttack(targetWeaponType, targetMob)
    pcall(function()
        local tool = Network.EnsureWeaponEquipped(targetWeaponType or "Melee")
        if tool then
            tool:Activate()
        end
        
        VirtualUser:Button1Down(Vector2.new(0.5, 0.5))
        VirtualUser:Button1Up(Vector2.new(0.5, 0.5))
        
        local net = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")
        if net then
            if net:FindFirstChild("RegisterAttack") then
                net.RegisterAttack:FireServer(0)
            end
            if targetMob and targetMob:FindFirstChild("HumanoidRootPart") and net:FindFirstChild("RegisterHit") then
                net.RegisterHit:FireServer(targetMob.HumanoidRootPart, { {targetMob, targetMob.HumanoidRootPart} })
            end
        end
    end)
end

function Network.ActivateBusoHaki()
    pcall(function()
        local char = Network.GetCharacter()
        if char and not char:FindFirstChild("HasBuso") then
            Network.InvokeCommF("Buso")
        end
    end)
end

function Network.ActivateKenHaki()
    pcall(function()
        local char = Network.GetCharacter()
        if char and not char:FindFirstChild("KenHaki") then
            Network.InvokeCommF("Ken")
        end
    end)
end

function Network.BuyRandomFruitGacha()
    local success, res = pcall(function()
        return Network.InvokeCommF("Cousin", "Buy")
    end)
    return success and res
end

function Network.BatchAddPoint(statName, points)
    pcall(function()
        Network.InvokeCommF("AddPoint", statName, tonumber(points) or 10)
    end)
end

return Network
