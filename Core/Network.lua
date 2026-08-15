-- [ CORE: NETWORK.LUA - BULLETPROOF WEAPON & ATTACK ENGINE V8.1 ]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera or Workspace:FindFirstChildOfClass("Camera")
local LocalPlayer = Players.LocalPlayer

local Network = {}

-- Danh sách tên Fighting Styles (Melee) trong Blox Fruits
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
        -- Nếu không phải Sword, Gun hay Fruit thì mặc định là Melee
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

function Network.EquipWeapon(targetType)
    local char = Network.GetCharacter()
    local hum = Network.GetHumanoid()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not char or not hum then return nil end
    
    -- 1. Kiểm tra tool đang cầm trên tay
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") and IsToolMatch(tool, targetType) then
            return tool
        end
    end
    
    -- 2. Kiểm tra trong Backpack
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and IsToolMatch(tool, targetType) then
                hum:EquipTool(tool)
                return tool
            end
        end
        -- Fallback: Nếu không tìm thấy loại khớp, trang bị tool đầu tiên trong túi
        local firstTool = backpack:FindFirstChildOfClass("Tool")
        if firstTool then
            hum:EquipTool(firstTool)
            return firstTool
        end
    end
    
    return char:FindFirstChildOfClass("Tool")
end

-- THI HÀNH ĐÒN ĐÁNH SIÊU TỐC VỚI ĐẦY ĐỦ 4 LỚP SÁT THƯƠNG
function Network.ExecuteFastAttack(targetWeaponType, targetMob)
    pcall(function()
        local tool = Network.EquipWeapon(targetWeaponType or "Melee")
        if tool then
            tool:Activate()
        end
        
        -- Lớp 1: VirtualUser Click trực tiếp
        VirtualUser:CaptureController()
        VirtualUser:Button1Down(Vector2.new(0, 0), Camera.CFrame)
        VirtualUser:Button1Up(Vector2.new(0, 0), Camera.CFrame)
        
        -- Lớp 2: Kích hoạt Remote Blox Fruits Net
        local net = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")
        if net then
            if net:FindFirstChild("RegisterAttack") then
                net.RegisterAttack:FireServer(0)
            end
            if targetMob and targetMob:FindFirstChild("HumanoidRootPart") and net:FindFirstChild("RegisterHit") then
                net.RegisterHit:FireServer(targetMob.HumanoidRootPart, {})
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
