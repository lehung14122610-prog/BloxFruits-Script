-- [ MODULES: ESP_FRUITFINDER.LUA - DUAL ESP & AUTO FRUIT PICKER ]
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESPModule = {}
local ESPFolder = Instance.new("Folder", Workspace)
ESPFolder.Name = "BF_Hub_ESP_Titan"

local function CreateESPLabel(part, color, text)
    if not part then return end
    local bg = Instance.new("BillboardGui")
    bg.Adornee = part
    bg.Size = UDim2.new(0, 160, 0, 40)
    bg.StudsOffset = Vector3.new(0, 3.5, 0)
    bg.AlwaysOnTop = true
    bg.Parent = ESPFolder
    
    local lbl = Instance.new("TextLabel")
    lbl.Parent = bg
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    lbl.TextStrokeTransparency = 0
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = text or part.Name
end

function ESPModule.Init(UI, TabESP, TabFruit, Config, Network, Movement)
    -- ESP Controls
    UI.AddSection(TabESP, "ESP Định Vị & Nhìn Thấu")
    UI.AddToggle(TabESP, "👤 ESP Players (Người Chơi)", Config.ESP_Player, function(v) Config.ESP_Player = v end)
    UI.AddToggle(TabESP, "🧟 ESP Mobs (Quái Thường)", Config.ESP_Mobs, function(v) Config.ESP_Mobs = v end)
    UI.AddToggle(TabESP, "📦 ESP Rương (Chests)", Config.ESP_Chests, function(v) Config.ESP_Chests = v end)
    UI.AddToggle(TabESP, "🍎 ESP Trái Ác Quỷ (Fruits)", Config.ESP_Fruits, function(v) Config.ESP_Fruits = v end)
    UI.AddToggle(TabESP, "🌸 ESP Hoa Race V2 (Flowers)", Config.ESP_Flowers, function(v) Config.ESP_Flowers = v end)
    
    -- Fruits Controls
    UI.AddSection(TabFruit, "Tự Động Nâng Điểm (Stats)")
    UI.AddToggle(TabFruit, "📊 Auto Cộng Điểm Chỉ Số", Config.AutoStat, function(v) Config.AutoStat = v end)
    UI.AddDropdown(TabFruit, "Chỉ Số Nâng:", {"Melee", "Defense", "Sword", "Gun", "Blox Fruit"}, function(v) Config.StatTarget = v end)
    
    UI.AddSection(TabFruit, "Trái Ác Quỷ & Gacha")
    UI.AddToggle(TabFruit, "🍎 Auto Nhặt Trái Rơi Bản Đồ", Config.AutoCollectFruit, function(v) Config.AutoCollectFruit = v end)
    UI.AddToggle(TabFruit, "📥 Auto Cất Trái Vào Rương", Config.AutoStoreFruit, function(v) Config.AutoStoreFruit = v end)
    UI.AddToggle(TabFruit, "🎲 Auto Mua Trái Random (Gacha)", Config.AutoBuyGachaFruit, function(v) Config.AutoBuyGachaFruit = v end)
    UI.AddToggle(TabFruit, "🛡️ Auto Bật Buso Haki", Config.AutoHaki, function(v) Config.AutoHaki = v end)
    
    -- Auto Stat Loop
    task.spawn(function()
        while task.wait(0.5) do
            if Config.AutoStat then
                Network.InvokeCommF("AddPoint", Config.StatTarget, 3)
            end
        end
    end)
    
    -- Auto Haki Loop
    task.spawn(function()
        while task.wait(1) do
            if Config.AutoHaki then
                local char = Network.GetCharacter()
                if char and not char:FindFirstChild("HasBuso") then
                    Network.InvokeCommF("HasBuso")
                end
            end
        end
    end)
    
    -- Auto Fruit Picker & Store
    task.spawn(function()
        while task.wait(1) do
            if Config.AutoCollectFruit then
                for _, v in pairs(Workspace:GetChildren()) do
                    if v:IsA("Tool") or v.Name:find("Fruit") then
                        local handle = v:FindFirstChild("Handle") or v:FindFirstChildOfClass("Part")
                        if handle then
                            Movement.TweenTo(handle.CFrame, 350)
                            task.wait(0.5)
                            if Config.AutoStoreFruit and v:IsA("Tool") then
                                Network.InvokeCommF("StoreFruit", v.Name, v)
                            end
                        end
                    end
                end
            end
        end
    end)
    
    -- Auto Gacha Loop
    task.spawn(function()
        while task.wait(10) do
            if Config.AutoBuyGachaFruit then
                Network.InvokeCommF("Cousin", "Buy")
            end
        end
    end)
    
    -- ESP Render Loop
    RunService.RenderStepped:Connect(function()
        ESPFolder:ClearAllChildren()
        local root = Network.GetRoot()
        if not root then return end
        
        if Config.ESP_Player then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = math.floor((root.Position - p.Character.HumanoidRootPart.Position).Magnitude)
                    CreateESPLabel(p.Character.HumanoidRootPart, Color3.fromRGB(0, 255, 170), p.Name .. " | " .. dist .. "m")
                end
            end
        end
        
        if Config.ESP_Chests then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v.Name:find("Chest") and v:IsA("BasePart") then
                    local dist = math.floor((root.Position - v.Position).Magnitude)
                    CreateESPLabel(v, Color3.fromRGB(255, 215, 0), "📦 Rương | " .. dist .. "m")
                end
            end
        end
        
        if Config.ESP_Fruits then
            for _, v in pairs(Workspace:GetChildren()) do
                if v:IsA("Tool") or v.Name:find("Fruit") then
                    local handle = v:FindFirstChild("Handle") or v:FindFirstChildOfClass("Part")
                    if handle then
                        local dist = math.floor((root.Position - handle.Position).Magnitude)
                        CreateESPLabel(handle, Color3.fromRGB(255, 60, 60), "🍎 " .. v.Name .. " | " .. dist .. "m")
                    end
                end
            end
        end
    end)
end

return ESPModule
