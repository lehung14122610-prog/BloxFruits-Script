--[[
    ===================================================================================
    ★ MODULES: ESP_FRUITFINDER.LUA - OBJECT POOLING ESP & FRUIT RADAR V9.0 ★
    ===================================================================================
--]]

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ESPModule = {}
local ESPFolder = Instance.new("Folder", Workspace)
ESPFolder.Name = "BF_Titan_ESPFolder_Pool_v9"

local ESPPool = {}

local function GetOrCreateESPLabel(adorneePart, color, defaultText)
    if not adorneePart then return nil end
    local id = adorneePart:GetDebugId()
    local item = ESPPool[id]
    
    if not item or not item.Billboard or item.Billboard.Parent ~= ESPFolder then
        local bg = Instance.new("BillboardGui")
        bg.Name = "ESP_" .. adorneePart.Name
        bg.Adornee = adorneePart
        bg.Size = UDim2.new(0, 160, 0, 36)
        bg.StudsOffset = Vector3.new(0, 3.2, 0)
        bg.AlwaysOnTop = true
        bg.Parent = ESPFolder
        
        local lbl = Instance.new("TextLabel")
        lbl.Parent = bg
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = color or Color3.fromRGB(255, 255, 255)
        lbl.TextStrokeTransparency = 0
        lbl.TextSize = 12
        lbl.Font = Enum.Font.GothamBold
        lbl.Text = defaultText or adorneePart.Name
        
        item = {Billboard = bg, Label = lbl, Part = adorneePart}
        ESPPool[id] = item
        
        adorneePart.AncestryChanged:Connect(function(_, parent)
            if not parent and ESPPool[id] then
                pcall(function() ESPPool[id].Billboard:Destroy() end)
                ESPPool[id] = nil
            end
        end)
    end
    
    item.Label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    item.Billboard.Enabled = true
    return item
end

function ESPModule.Init(Config, Network, Movement)
    task.spawn(function()
        while task.wait(0.3) do
            local root = Network.GetRoot()
            if root then
                -- ESP FRUITS
                if Config.ESP_Fruits then
                    for _, v in pairs(Workspace:GetChildren()) do
                        if v:IsA("Tool") or v.Name:find("Fruit") then
                            local handle = v:FindFirstChild("Handle") or v:FindFirstChildOfClass("Part")
                            if handle then
                                local dist = math.floor((root.Position - handle.Position).Magnitude)
                                local item = GetOrCreateESPLabel(handle, Color3.fromRGB(255, 60, 60), "🍎 " .. v.Name)
                                if item then item.Label.Text = "🍎 " .. v.Name .. " | " .. dist .. "m" end
                            end
                        end
                    end
                end
                
                -- ESP PLAYERS
                if Config.ESP_Player then
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = math.floor((root.Position - p.Character.HumanoidRootPart.Position).Magnitude)
                            local hp = p.Character:FindFirstChild("Humanoid") and math.floor(p.Character.Humanoid.Health) or 0
                            local item = GetOrCreateESPLabel(p.Character.HumanoidRootPart, Color3.fromRGB(0, 255, 170), p.Name)
                            if item then item.Label.Text = p.Name .. " | " .. dist .. "m | HP: " .. hp end
                        end
                    end
                end
                
                -- AUTO COLLECT FRUIT
                if Config.AutoCollectFruit then
                    for _, v in pairs(Workspace:GetChildren()) do
                        if v:IsA("Tool") or v.Name:find("Fruit") then
                            local handle = v:FindFirstChild("Handle") or v:FindFirstChildOfClass("Part")
                            if handle then
                                Movement.TravelTo(handle.CFrame, 320)
                                break
                            end
                        end
                    end
                end
                
                -- AUTO STORE FRUIT
                if Config.AutoStoreFruit then
                    local char = Network.GetCharacter()
                    local bp = LocalPlayer:FindFirstChild("Backpack")
                    if char then
                        for _, tool in pairs(char:GetChildren()) do
                            if tool:IsA("Tool") and tool.Name:find("Fruit") then
                                Network.InvokeCommF("StoreFruit", tool.Name, tool)
                            end
                        end
                    end
                    if bp then
                        for _, tool in pairs(bp:GetChildren()) do
                            if tool:IsA("Tool") and tool.Name:find("Fruit") then
                                Network.InvokeCommF("StoreFruit", tool.Name, tool)
                            end
                        end
                    end
                end
            end
        end
    end)
end

return ESPModule
