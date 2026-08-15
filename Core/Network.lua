-- [ CORE: NETWORK.LUA - REMOTE EVENT & CHARACTER SERVICES V8.0 ]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera or Workspace:FindFirstChildOfClass("Camera")
local LocalPlayer = Players.LocalPlayer

local Network = {}

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

function Network.EquipWeapon(targetType)
    local char = Network.GetCharacter()
    local hum = Network.GetHumanoid()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not char or not hum then return nil end
    
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            if (targetType == "Melee" and tool.ToolTip == "Melee") or
               (targetType == "Sword" and tool.ToolTip == "Sword") or
               (targetType == "Blox Fruit" and tool.ToolTip == "Blox Fruit") or
               (targetType == "Gun" and tool.ToolTip == "Gun") then
                return tool
            end
        end
    end
    
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                if (targetType == "Melee" and tool.ToolTip == "Melee") or
                   (targetType == "Sword" and tool.ToolTip == "Sword") or
                   (targetType == "Blox Fruit" and tool.ToolTip == "Blox Fruit") or
                   (targetType == "Gun" and tool.ToolTip == "Gun") then
                    hum:EquipTool(tool)
                    return tool
                end
            end
        end
    end
    return nil
end

function Network.ExecuteFastAttack(targetWeaponType)
    pcall(function()
        local tool = Network.EquipWeapon(targetWeaponType or "Melee")
        if tool then tool:Activate() end
        VirtualUser:Button1Down(Vector2.new(0, 0), Camera.CFrame)
        VirtualUser:Button1Up(Vector2.new(0, 0), Camera.CFrame)
    end)
end

-- Sửa lỗi Auto Buso Haki 100%
function Network.ActivateBusoHaki()
    pcall(function()
        local char = Network.GetCharacter()
        if char and not char:FindFirstChild("HasBuso") then
            Network.InvokeCommF("Buso")
        end
    end)
end

-- Sửa lỗi Auto Gacha Cousin
function Network.BuyRandomFruitGacha()
    local success, res = pcall(function()
        return Network.InvokeCommF("Cousin", "Buy")
    end)
    return success and res
end

-- Tăng tốc độ cộng điểm chỉ số
function Network.BatchAddPoint(statName, points)
    pcall(function()
        Network.InvokeCommF("AddPoint", statName, tonumber(points) or 10)
    end)
end

return Network
