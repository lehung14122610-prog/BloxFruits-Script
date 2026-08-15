--[[
    ===================================================================================
    ★ BLOX FRUITS ULTIMATE HUB V9.0 (SUPREME MASTER CONTROLLER) ★
    Tác giả: lehung14122610-prog
    Repository: https://github.com/lehung14122610-prog/BloxFruits-Script
    Hỗ trợ 100%: DeltaX, Delta, Solara, Wave, Arceus X, Codex (PC, Android & BlueStacks)
    ===================================================================================
--]]

local BaseUrl = "https://raw.githubusercontent.com/lehung14122610-prog/BloxFruits-Script/main/"

local function LoadModule(relativePath)
    local url = BaseUrl .. relativePath .. "?t=" .. tick()
    local success, code = pcall(function()
        return game:HttpGet(url)
    end)
    if not success or not code or code == "" then
        warn("[Titan Hub] Tải fallback cho: " .. tostring(relativePath))
        return nil
    end
    local fn, err = loadstring(code)
    if not fn then
        warn("[Titan Hub Syntax Error in " .. tostring(relativePath) .. "]: " .. tostring(err))
        return nil
    end
    local runSuccess, result = pcall(fn)
    if not runSuccess then
        warn("[Titan Hub Runtime Error in " .. tostring(relativePath) .. "]: " .. tostring(result))
        return nil
    end
    return result
end

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚡ Titan Hub v9.0",
        Text = "Đang khởi chạy Supreme Hub Max Lv 2800...",
        Duration = 3
    })
end)

-- 1. CẤU HÌNH GLOBAL
getgenv().BF_Hub_Config = {
    AutoFarmLevel = false,
    AutoFarmSelectedMob = false,
    AutoFarmBoss = false,
    AutoFarmChest = false,
    SelectedMob = "",
    SelectedBoss = "",
    SelectedWeapon = "Melee",
    FarmHeight = 11.0,
    FastAttack = true,
    BringMobs = true,
    BringRadius = 380,
    TweenSpeed = 280,
    
    Fly = false,
    FlySpeed = 75,
    WalkSpeedToggle = false,
    WalkSpeed = 65,
    JumpPowerToggle = false,
    JumpPower = 125,
    Noclip = false,
    WaterWalk = false,
    InfiniteJump = false,
    SelectedIsland = "Starter Pirate Island",
    
    ESP_Player = false,
    ESP_Mobs = false,
    ESP_Chests = false,
    ESP_Fruits = false,
    
    AutoCollectFruit = false,
    AutoStoreFruit = true,
    AutoBuyGachaFruit = false,
    AutoHaki = true,
    AutoStat = false,
    StatTarget = "Melee",
    StatAmount = 10,
    
    FixLag = false,
    BlackScreen = false,
    AntiAFK = true
}

local Config = getgenv().BF_Hub_Config
local HttpService = game:GetService("HttpService")
local ConfigFileName = "BF_Hub_Titan_Config_v9.json"

local function SaveConfig()
    pcall(function()
        if writefile then writefile(ConfigFileName, HttpService:JSONEncode(Config)) end
    end)
end

local function LoadConfig()
    pcall(function()
        if isfile and isfile(ConfigFileName) and readfile then
            local decoded = HttpService:JSONDecode(readfile(ConfigFileName))
            for k, v in pairs(decoded) do Config[k] = v end
        end
    end)
end

LoadConfig()

-- 2. NẠP MODULES CORE & DATA
local IslandsData = LoadModule("Data/Islands_Data.lua") or {Islands = {}, Bosses = {}}
local QuestsData = LoadModule("Data/Quests_Data.lua") or {}
local UI = LoadModule("Core/UI_Library.lua")
local Network = LoadModule("Core/Network.lua")
local Movement = LoadModule("Core/Movement.lua")
local Utils = LoadModule("Core/Utils.lua")
local ESPMod = LoadModule("Modules/ESP_FruitFinder.lua")

if not UI or not Network or not Movement then
    warn("[Titan Hub Fatal] Lỗi nạp Core!")
    return
end

-- 3. XÂY DỰNG TOÀN BỘ CÁC TAB GIAO DIỆN TRỰC TIẾP
local TabFarm = UI.CreateTab("Main Farm", "🌾")
local TabCombat = UI.CreateTab("Combat", "⚔️")
local TabFly = UI.CreateTab("Bay & Travel", "✈️")
local TabESP = UI.CreateTab("Visuals / ESP", "👁️")
local TabFruit = UI.CreateTab("Fruits / Stats", "🍎")
local TabLag = UI.CreateTab("Fix Lag & FPS", "⚡")
local TabSettings = UI.CreateTab("System", "⚙️")

-- 4. TAB 1: MAIN FARM
UI.AddSection(TabFarm, "Cài Đặt Auto Farm Level (1 -> 2800)")
UI.AddDropdown(TabFarm, "Vũ Khí Farm:", {"Melee", "Sword", "Blox Fruit", "Gun"}, function(v) Config.SelectedWeapon = v SaveConfig() end)
UI.AddSlider(TabFarm, "Độ Cao Farm Trên Đầu Quái (Studs)", 6, 18, Config.FarmHeight, function(v) Config.FarmHeight = v SaveConfig() end)
UI.AddToggle(TabFarm, "🌾 Auto Farm Level (1 -> 2800 Max)", Config.AutoFarmLevel, function(v) 
    Config.AutoFarmLevel = v 
    if not v then
        Movement.StopTravel()
        Movement.DisableHoverLock()
    end
    SaveConfig() 
end)

UI.AddSection(TabFarm, "Farm Quái & Boss Tuỳ Chọn")
local mobList = {}
for _, q in ipairs(QuestsData) do
    local exists = false
    for _, m in ipairs(mobList) do if m == q.Mob then exists = true break end end
    if not exists then table.insert(mobList, q.Mob) end
end
if #mobList == 0 then table.insert(mobList, "Bandit") end
Config.SelectedMob = mobList[1]

UI.AddDropdown(TabFarm, "Chọn Bãi Quái:", mobList, function(v) Config.SelectedMob = v SaveConfig() end)
UI.AddToggle(TabFarm, "🎯 Auto Farm Quái Đã Chọn", Config.AutoFarmSelectedMob, function(v) 
    Config.AutoFarmSelectedMob = v 
    if not v then
        Movement.StopTravel()
        Movement.DisableHoverLock()
    end
    SaveConfig() 
end)

local bossList = {}
for k, _ in pairs(IslandsData.Bosses or {}) do table.insert(bossList, k) end
if #bossList == 0 then table.insert(bossList, "The Gorilla King [Lv. 25]") end
Config.SelectedBoss = bossList[1]

UI.AddDropdown(TabFarm, "Chọn Boss Mục Tiêu:", bossList, function(v) Config.SelectedBoss = v SaveConfig() end)
UI.AddToggle(TabFarm, "👑 Auto Farm Boss Đã Chọn", Config.AutoFarmBoss, function(v) 
    Config.AutoFarmBoss = v 
    if not v then
        Movement.StopTravel()
        Movement.DisableHoverLock()
    end
    SaveConfig() 
end)
UI.AddToggle(TabFarm, "📦 Auto Farm Rương (Nhặt Tiền Cực Nhanh)", Config.AutoFarmChest, function(v) 
    Config.AutoFarmChest = v 
    if not v then Movement.StopTravel() end
    SaveConfig() 
end)

-- 5. TAB 2: COMBAT & SKILLS
UI.AddSection(TabCombat, "Đòn Đánh & Gom Quái")
UI.AddToggle(TabCombat, "⚡ Fast Attack V3 (Đòn Đánh Siêu Tốc)", Config.FastAttack, function(v) Config.FastAttack = v SaveConfig() end)
UI.AddToggle(TabCombat, "🌀 Gom Quái 3D (Bring Mobs)", Config.BringMobs, function(v) Config.BringMobs = v SaveConfig() end)
UI.AddSlider(TabCombat, "Bán Kính Gom Quái (Studs)", 100, 500, Config.BringRadius, function(v) Config.BringRadius = v SaveConfig() end)
UI.AddToggle(TabCombat, "🛡️ Auto Bật Buso Haki (Vũ Trang)", Config.AutoHaki, function(v) Config.AutoHaki = v SaveConfig() end)

-- 6. TAB 3: BAY & TRAVEL
UI.AddSection(TabFly, "Dịch Chuyển Đến Đảo (Travel Mượt)")
local islandList = {}
for k, _ in pairs(IslandsData.Islands or {}) do table.insert(islandList, k) end
if #islandList == 0 then table.insert(islandList, "Starter Pirate Island") end
Config.SelectedIsland = islandList[1]

UI.AddDropdown(TabFly, "Chọn Đảo Đến:", islandList, function(v) Config.SelectedIsland = v SaveConfig() end)
UI.AddButton(TabFly, "🚀 Bay Đến Đảo Đã Chọn", function()
    local pos = IslandsData.Islands[Config.SelectedIsland]
    if pos then 
        Movement.TravelTo(CFrame.new(pos + Vector3.new(0, 45, 0))) 
    end
end)

UI.AddSection(TabFly, "Kỹ Năng Bay Tự Do & Nâng Cấp Tốc Độ")
UI.AddToggle(TabFly, "✈️ Bay Tự Do V3 (Free Fly)", Config.Fly, function(v) 
    Config.Fly = v 
    if v then Movement.StartFly(Config.FlySpeed) else Movement.StopFly() end
    SaveConfig()
end)
UI.AddSlider(TabFly, "Tốc Độ Bay Tự Do", 20, 250, Config.FlySpeed, function(v) 
    Config.FlySpeed = v 
    if Config.Fly then Movement.StartFly(Config.FlySpeed) end
    SaveConfig()
end)
UI.AddToggle(TabFly, "🏃 Bật Chạy Nhanh (WalkSpeed)", Config.WalkSpeedToggle, function(v) Config.WalkSpeedToggle = v SaveConfig() end)
UI.AddSlider(TabFly, "Tốc Độ Chạy", 16, 300, Config.WalkSpeed, function(v) Config.WalkSpeed = v SaveConfig() end)
UI.AddToggle(TabFly, "🦘 Bật Nhảy Cao (JumpPower)", Config.JumpPowerToggle, function(v) Config.JumpPowerToggle = v SaveConfig() end)
UI.AddSlider(TabFly, "Độ Cao Nhảy", 50, 300, Config.JumpPower, function(v) Config.JumpPower = v SaveConfig() end)
UI.AddToggle(TabFly, "🧱 Noclip (Đi Xuyên Tường)", Config.Noclip, function(v) Config.Noclip = v SaveConfig() end)
UI.AddToggle(TabFly, "🌊 Water Walk (Đi Trên Nước)", Config.WaterWalk, function(v) Config.WaterWalk = v SaveConfig() end)
UI.AddToggle(TabFly, "🦘 Infinite Jump (Nhảy Vô Tận)", Config.InfiniteJump, function(v) Config.InfiniteJump = v SaveConfig() end)

-- 7. TAB 4: VISUALS / ESP
UI.AddSection(TabESP, "Định Vị & Nhìn Thấu (Chống Lag)")
UI.AddToggle(TabESP, "👤 ESP Players (Người Chơi)", Config.ESP_Player, function(v) Config.ESP_Player = v SaveConfig() end)
UI.AddToggle(TabESP, "📦 ESP Rương (Chests)", Config.ESP_Chests, function(v) Config.ESP_Chests = v SaveConfig() end)
UI.AddToggle(TabESP, "🍎 ESP Trái Ác Quỷ (Fruits)", Config.ESP_Fruits, function(v) Config.ESP_Fruits = v SaveConfig() end)

-- 8. TAB 5: FRUITS / STATS
UI.AddSection(TabFruit, "Tự Động Nâng Chỉ Số (Stats)")
UI.AddToggle(TabFruit, "📊 Auto Cộng Điểm Chỉ Số", Config.AutoStat, function(v) Config.AutoStat = v SaveConfig() end)
UI.AddDropdown(TabFruit, "Chỉ Số Nâng:", {"Melee", "Defense", "Sword", "Gun", "Blox Fruit"}, function(v) Config.StatTarget = v SaveConfig() end)
UI.AddSlider(TabFruit, "Số Điểm Mỗi Lần", 1, 100, Config.StatAmount, function(v) Config.StatAmount = v SaveConfig() end)

UI.AddSection(TabFruit, "Bảng Radar Trái Ác Quỷ")
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
    local nearest = nil
    local minD = 9e9
    for _, v in pairs(game:GetService("Workspace"):GetChildren()) do
        if v:IsA("Tool") or v.Name:find("Fruit") then
            local h = v:FindFirstChild("Handle") or v:FindFirstChildOfClass("Part")
            if h then
                local d = (root.Position - h.Position).Magnitude
                if d < minD then minD = d nearest = h end
            end
        end
    end
    if nearest then
        Movement.TravelTo(nearest.CFrame, 320)
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Fruit Radar",
            Text = "Không có trái ác quỷ nào trên Server!",
            Duration = 3
        })
    end
end)

UI.AddToggle(TabFruit, "🍎 Auto Nhặt Trái Toàn Bản Đồ", Config.AutoCollectFruit, function(v) Config.AutoCollectFruit = v SaveConfig() end)
UI.AddToggle(TabFruit, "📥 Auto Cất Trái Vào Rương (Store)", Config.AutoStoreFruit, function(v) Config.AutoStoreFruit = v SaveConfig() end)
UI.AddToggle(TabFruit, "🎲 Auto Mua Trái Random (Gacha)", Config.AutoBuyGachaFruit, function(v) Config.AutoBuyGachaFruit = v SaveConfig() end)

-- 9. TAB 6: FIX LAG & SYSTEM
UI.AddSection(TabLag, "Tối Ưu Hoá & Tiết Kiệm Pin")
UI.AddToggle(TabLag, "⚡ Ultra Fix Lag FPS Booster (120 FPS)", Config.FixLag, function(v) 
    Config.FixLag = v 
    if v and Utils then Utils.ApplyUltraFixLag() end
    SaveConfig()
end)
UI.AddToggle(TabLag, "🌙 Ultra Black Screen (Treo Đêm)", Config.BlackScreen, function(v) 
    Config.BlackScreen = v 
    if Utils then Utils.ToggleBlackScreen(v) end
    SaveConfig()
end)

UI.AddSection(TabSettings, "Hệ Thống & Máy Chủ")
UI.AddToggle(TabSettings, "💤 Anti-AFK (Chống Văng Game)", Config.AntiAFK, function(v) Config.AntiAFK = v SaveConfig() end)
UI.AddButton(TabSettings, "🔄 Rejoin Current Server", function() if Utils then Utils.RejoinServer() end end)
UI.AddButton(TabSettings, "🌐 Server Hop (Tìm Server Ít Người)", function() if Utils then Utils.ServerHop() end end)

-- 10. MASTER AUTO FARM STATE MACHINE V9.0
local function GetQuestForCurrentLevel()
    local level = Network.GetPlayerLevelSafe()
    for _, q in ipairs(QuestsData) do
        if level >= q.MinLvl and level <= q.MaxLvl then return q end
    end
    return QuestsData[#QuestsData]
end

local function HasActiveQuest()
    local pgui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if pgui and pgui:FindFirstChild("Main") and pgui.Main:FindFirstChild("Quest") then
        return pgui.Main.Quest.Visible
    end
    return false
end

local function BringAndFreezeMobs(targetCenterCF)
    if not Config.BringMobs then return end
    local enemies = game:GetService("Workspace"):FindFirstChild("Enemies")
    if not enemies then return end
    for _, mob in pairs(enemies:GetChildren()) do
        if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            local dist = (targetCenterCF.Position - mob.HumanoidRootPart.Position).Magnitude
            if dist <= Config.BringRadius then
                mob.HumanoidRootPart.CFrame = targetCenterCF * CFrame.new(0, 0, -1)
                mob.HumanoidRootPart.CanCollide = false
                mob.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                mob.Humanoid.WalkSpeed = 0
            end
        end
    end
end

-- VÒNG LẶP MASTER FARM (ĐIỀU HƯỚNG TWEEN KHÔNG HUỶ NHAU)
task.spawn(function()
    while task.wait(0.1) do
        local root = Network.GetRoot()
        local isFarming = Config.AutoFarmLevel or Config.AutoFarmSelectedMob or Config.AutoFarmBoss
        
        if root and isFarming then
            if Config.AutoFarmLevel then
                local quest = GetQuestForCurrentLevel()
                if quest then
                    if not HasActiveQuest() then
                        local distToNpc = (root.Position - quest.NpcCFrame.Position).Magnitude
                        if distToNpc > 16 then
                            if not Movement.IsCurrentlyTraveling() then
                                Movement.TravelTo(quest.NpcCFrame)
                            end
                        else
                            Movement.StopTravel()
                            Network.InvokeCommF("StartQuest", quest.QuestName, quest.QuestLvl)
                            task.wait(0.4)
                        end
                    else
                        local enemies = game:GetService("Workspace"):FindFirstChild("Enemies")
                        local targetMob = nil
                        if enemies then
                            for _, mob in pairs(enemies:GetChildren()) do
                                if mob.Name == quest.Mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                                    targetMob = mob
                                    break
                                end
                            end
                        end
                        
                        if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                            local mobPos = targetMob.HumanoidRootPart.Position
                            local distToMob = (root.Position - mobPos).Magnitude
                            local targetFarmPos = mobPos + Vector3.new(0, Config.FarmHeight, 0)
                            local hoverTargetCF = CFrame.lookAt(targetFarmPos, mobPos)
                            
                            if distToMob > 25 then
                                if not Movement.IsCurrentlyTraveling() then
                                    Movement.TravelTo(hoverTargetCF)
                                end
                            else
                                Movement.StopTravel()
                                Movement.LockHover(hoverTargetCF)
                                BringAndFreezeMobs(targetMob.HumanoidRootPart.CFrame)
                                Network.ExecuteFastAttack(Config.SelectedWeapon, targetMob)
                            end
                        else
                            if not Movement.IsCurrentlyTraveling() then
                                Movement.TravelTo(quest.MobCFrame * CFrame.new(0, Config.FarmHeight, 0))
                            end
                        end
                    end
                end
            elseif Config.AutoFarmSelectedMob then
                local enemies = game:GetService("Workspace"):FindFirstChild("Enemies")
                local targetMob = nil
                if enemies then
                    for _, mob in pairs(enemies:GetChildren()) do
                        if (Config.SelectedMob == "" or mob.Name == Config.SelectedMob) and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            targetMob = mob
                            break
                        end
                    end
                end
                if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                    local mobPos = targetMob.HumanoidRootPart.Position
                    local distToMob = (root.Position - mobPos).Magnitude
                    local targetFarmPos = mobPos + Vector3.new(0, Config.FarmHeight, 0)
                    local hoverTargetCF = CFrame.lookAt(targetFarmPos, mobPos)
                    
                    if distToMob > 25 then
                        if not Movement.IsCurrentlyTraveling() then
                            Movement.TravelTo(hoverTargetCF)
                        end
                    else
                        Movement.StopTravel()
                        Movement.LockHover(hoverTargetCF)
                        BringAndFreezeMobs(targetMob.HumanoidRootPart.CFrame)
                        Network.ExecuteFastAttack(Config.SelectedWeapon, targetMob)
                    end
                else
                    Movement.DisableHoverLock()
                end
            elseif Config.AutoFarmBoss then
                local enemies = game:GetService("Workspace"):FindFirstChild("Enemies")
                local targetBoss = nil
                if enemies then
                    for _, mob in pairs(enemies:GetChildren()) do
                        if (Config.SelectedBoss == "" or mob.Name:find(Config.SelectedBoss:split(" ")[1])) and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            targetBoss = mob
                            break
                        end
                    end
                end
                if targetBoss and targetBoss:FindFirstChild("HumanoidRootPart") then
                    local mobPos = targetBoss.HumanoidRootPart.Position
                    local distToBoss = (root.Position - mobPos).Magnitude
                    local targetFarmPos = mobPos + Vector3.new(0, Config.FarmHeight, 0)
                    local hoverTargetCF = CFrame.lookAt(targetFarmPos, mobPos)
                    
                    if distToBoss > 25 then
                        if not Movement.IsCurrentlyTraveling() then
                            Movement.TravelTo(hoverTargetCF)
                        end
                    else
                        Movement.StopTravel()
                        Movement.LockHover(hoverTargetCF)
                        BringAndFreezeMobs(targetBoss.HumanoidRootPart.CFrame)
                        Network.ExecuteFastAttack(Config.SelectedWeapon, targetBoss)
                    end
                else
                    Movement.DisableHoverLock()
                    if IslandsData.Bosses and IslandsData.Bosses[Config.SelectedBoss] then
                        if not Movement.IsCurrentlyTraveling() then
                            Movement.TravelTo(CFrame.new(IslandsData.Bosses[Config.SelectedBoss] + Vector3.new(0, 30, 0)))
                        end
                    end
                end
            end
        else
            if not Config.Fly then
                Movement.StopTravel()
                Movement.DisableHoverLock()
            end
        end
    end
end)

-- 11. HỆ THỐNG PHỤ TRỢ (RADAR, STATS, HAKI, GACHA)
task.spawn(function()
    while task.wait(0.5) do
        local root = Network.GetRoot()
        if root and FruitRadarLabel and FruitRadarLabel.Parent then
            local fruitCount = 0
            local list = {}
            for _, v in pairs(game:GetService("Workspace"):GetChildren()) do
                if v:IsA("Tool") or v.Name:find("Fruit") then
                    local h = v:FindFirstChild("Handle") or v:FindFirstChildOfClass("Part")
                    if h then
                        fruitCount = fruitCount + 1
                        local d = math.floor((root.Position - h.Position).Magnitude)
                        table.insert(list, v.Name .. " (" .. d .. "m)")
                    end
                end
            end
            if fruitCount > 0 then
                FruitRadarLabel.Text = "🍎 Có " .. fruitCount .. " Trái trên Server:
" .. table.concat(list, " | ")
                FruitRadarLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
            else
                FruitRadarLabel.Text = "📡 Server hiện tại: Chưa có Trái Ác Quỷ nào rơi"
                FruitRadarLabel.TextColor3 = Color3.fromRGB(180, 190, 210)
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if Config.AutoStat then
            Network.BatchAddPoint(Config.StatTarget, Config.StatAmount)
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if Config.AutoHaki then
            Network.ActivateBusoHaki()
        end
    end
end)

task.spawn(function()
    while task.wait(15) do
        if Config.AutoBuyGachaFruit then
            Network.BuyRandomFruitGacha()
        end
    end
end)

if ESPMod and ESPMod.Init then
    ESPMod.Init(Config, Network, Movement)
end

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🔥 TITAN HUB V9.0",
        Text = "Hệ thống Farm & Di Chuyển đã sẵn sàng 100%!",
        Duration = 5
    })
end)
print("★ BLOX FRUITS TITAN HUB V9.0 (SUPREME MASTER CONTROLLER) LOADED ★")
