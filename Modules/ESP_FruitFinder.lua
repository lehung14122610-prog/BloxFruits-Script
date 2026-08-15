-- [ MODULES: ESP_FRUITFINDER.LUA - OBJECT POOLING ESP & FRUIT RADAR V8.0 ]
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESPModule = {}
local ESPFolder = Instance.new("Folder", Workspace)
ESPFolder.Name = "BF_Titan_ESPFolder_Pool"

-- OBJECT POOLING CHỐNG LAG 100% (KHÔNG TẠO MỚI/XOÁ TRONG RENDERSTEPPED)
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

function ESPModule.Init(UI, TabESP, TabFruit, Config, Network, Movement)
    -- 1. CÀI ĐẶT ESP
    UI.AddSection(TabESP, "ESP Định Vị & Nhìn Thấu (Chống Lag)")
    UI.AddToggle(TabESP, "👤 ESP Players (Người Chơi)", Config.ESP_Player, function(v) 
        Config.ESP_Player = v 
        if not v then
            for _, item in pairs(ESPPool) do if item.Billboard and item.Billboard.Name:find("ESP_HumanoidRootPart") then item.Billboard.Enabled = false end end
        end
    end)
    UI.AddToggle(TabESP, "🧟 ESP Mobs (Quái Thường)", Config.ESP_Mobs, function(v) Config.ESP_Mobs = v end)
    UI.AddToggle(TabESP, "📦 ESP Rương (Chests)", Config.ESP_Chests, function(v) Config.ESP_Chests = v end)
    UI.AddToggle(TabESP, "🍎 ESP Trái Ác Quỷ (Fruits)", Config.ESP_Fruits, function(v) Config.ESP_Fruits = v end)
    UI.AddToggle(TabESP, "🌸 ESP Hoa Race V2 (Flowers)", Config.ESP_Flowers, function(v) Config.ESP_Flowers = v end)
    
    -- 2. CÀI ĐẶT STATS
    UI.AddSection(TabFruit, "Tự Động Nâng Chỉ Số (Stats)")
    UI.AddToggle(TabFruit, "📊 Auto Cộng Điểm Chỉ Số", Config.AutoStat, function(v) Config.AutoStat = v end)
    UI.AddDropdown(TabFruit, "Chỉ Số Nâng:", {"Melee", "Defense", "Sword", "Gun", "Blox Fruit"}, function(v) Config.StatTarget = v end)
    local statAmount = 10
    UI.AddSlider(TabFruit, "Số Điểm Nâng Mỗi Đợt", 1, 100, 10, function(v) statAmount = v end)
    
    -- 3. CÀI ĐẶT TRÁI ÁC QUỶ & FRUIT RADAR
    UI.AddSection(TabFruit, "Bảng Radar Trái Ác Quỷ Trên Server")
    local FruitRadarLabel = Instance.new("TextLabel")
    FruitRadarLabel.Size = UDim2.new(1, -8, 0, 48)
    FruitRadarLabel.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
    FruitRadarLabel.Text = "📡 Đang quét tìm Trái Ác Quỷ..."
    FruitRadarLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
    FruitRadarLabel.Font = Enum.Font.GothamMedium
    FruitRadarLabel.TextSize = 12
    FruitRadarLabel.Parent = TabFruit
    
    local radarCorner = Instance.new("UICorner")
    radarCorner.CornerRadius = UDim.new(0, 6)
    radarCorner.Parent = FruitRadarLabel
    
    UI.AddButton(TabFruit, "🚀 Bay Đến Nhặt Trái Gần Nhất", function()
        local root = Network.GetRoot()
        if not root then return end
        local nearestFruit = nil
        local minDist = 9e9
        for _, v in pairs(Workspace:GetChildren()) do
            if v:IsA("Tool") or v.Name:find("Fruit") then
                local handle = v:FindFirstChild("Handle") or v:FindFirstChildOfClass("Part")
                if handle then
                    local d = (root.Position - handle.Position).Magnitude
                    if d < minDist then
                        minDist = d
                        nearestFruit = handle
                    end
                end
            end
        end
        if nearestFruit then
            Movement.TweenTo(nearestFruit.CFrame, 320)
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Fruit Radar",
                Text = "Không có Trái Ác Quỷ nào đang rơi trên Server!",
                Duration = 3
            })
        end
    end)
    
    UI.AddSection(TabFruit, "Tự Động Nhặt & Gacha Trái")
    UI.AddToggle(TabFruit, "🍎 Auto Nhặt Trái Rơi Toàn Map", Config.AutoCollectFruit, function(v) Config.AutoCollectFruit = v end)
    UI.AddToggle(TabFruit, "📥 Auto Cất Trái Vào Rương (Store)", Config.AutoStoreFruit, function(v) Config.AutoStoreFruit = v end)
    UI.AddToggle(TabFruit, "🎲 Auto Mua Trái Random (Gacha)", Config.AutoBuyGachaFruit, function(v) Config.AutoBuyGachaFruit = v end)
    UI.AddToggle(TabFruit, "🛡️ Auto Bật Buso Haki (Vũ Trang)", Config.AutoHaki, function(v) Config.AutoHaki = v end)
    
    -- Throttled Fruit Radar & ESP Loop (Chạy mỗi 0.25 giây chống giật lag)
    task.spawn(function()
        while task.wait(0.25) do
            local root = Network.GetRoot()
            if root then
                -- Quét Fruit Radar
                local fruitCount = 0
                local fruitInfoList = {}
                for _, v in pairs(Workspace:GetChildren()) do
                    if v:IsA("Tool") or v.Name:find("Fruit") then
                        local handle = v:FindFirstChild("Handle") or v:FindFirstChildOfClass("Part")
                        if handle then
                            fruitCount = fruitCount + 1
                            local dist = math.floor((root.Position - handle.Position).Magnitude)
                            table.insert(fruitInfoList, v.Name .. " (" .. dist .. "m)")
                            if Config.ESP_Fruits then
                                local item = GetOrCreateESPLabel(handle, Color3.fromRGB(255, 60, 60), "🍎 " .. v.Name)
                                if item then item.Label.Text = "🍎 " .. v.Name .. " | " .. dist .. "m" end
                            end
                        end
                    end
                end
                if fruitCount > 0 then
                    FruitRadarLabel.Text = "🍎 Có " .. fruitCount .. " Trái trên Server:
" .. table.concat(fruitInfoList, " | ")
                    FruitRadarLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
                else
                    FruitRadarLabel.Text = "📡 Server hiện tại: Chưa có Trái Ác Quỷ nào rơi"
                    FruitRadarLabel.TextColor3 = Color3.fromRGB(180, 190, 210)
                end
                
                -- Player ESP
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
            end
        end
    end)
    
    -- Auto Stat Loop
    task.spawn(function()
        while task.wait(0.4) do
            if Config.AutoStat then
                Network.BatchAddPoint(Config.StatTarget, statAmount)
            end
        end
    end)
    
    -- Auto Buso Haki Loop
    task.spawn(function()
        while task.wait(1) do
            if Config.AutoHaki then
                Network.ActivateBusoHaki()
            end
        end
    end)
    
    -- Auto Gacha Loop
    task.spawn(function()
        while task.wait(15) do
            if Config.AutoBuyGachaFruit then
                Network.BuyRandomFruitGacha()
            end
        end
    end)
end

return ESPModule
