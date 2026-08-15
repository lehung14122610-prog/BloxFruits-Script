--[[
    ===================================================================================
    ★ BLOX FRUITS ULTIMATE HUB V8.1 (TRUE FLIGHT & COMBAT ENGINE) ★
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
        warn("[Titan Hub Loader Error] Không thể tải module: " .. tostring(relativePath))
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

-- Thông báo nạp
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚡ Titan Hub v8.1",
        Text = "Đang nạp hệ thống Auto Farm...",
        Duration = 3
    })
end)

-- 1. CẤU HÌNH GLOBAL (BF_Hub_Config)
getgenv().BF_Hub_Config = {
    -- Auto Farm
    AutoFarmLevel = false,
    AutoFarmSelectedMob = false,
    AutoFarmBoss = false,
    AutoFarmChest = false,
    SelectedMob = "",
    SelectedBoss = "",
    SelectedWeapon = "Melee",
    FarmHeight = 12.0,
    FarmDistance = 0.0,
    FastAttack = true,
    BringMobs = true,
    BringRadius = 380,
    TweenSpeed = 275,
    
    -- Movement & Flight
    Fly = false,
    FlySpeed = 75,
    WalkSpeedToggle = false,
    WalkSpeed = 65,
    JumpPowerToggle = false,
    JumpPower = 125,
    Noclip = false,
    WaterWalk = false,
    InfiniteJump = false,
    SelectedIsland = "Starter Island (Sea 1)",
    
    -- Visuals / ESP
    ESP_Player = false,
    ESP_Mobs = false,
    ESP_Chests = false,
    ESP_Fruits = false,
    ESP_Flowers = false,
    
    -- Fruits & Gacha
    AutoCollectFruit = false,
    AutoStoreFruit = true,
    AutoBuyGachaFruit = false,
    AutoHaki = true,
    AutoStat = false,
    StatTarget = "Melee",
    
    -- Fix Lag & System
    FixLag = false,
    BlackScreen = false,
    AntiAFK = true
}

local Config = getgenv().BF_Hub_Config
local HttpService = game:GetService("HttpService")
local ConfigFileName = "BF_Hub_Titan_Config_v8.json"

local function SaveConfig()
    pcall(function()
        if writefile then
            writefile(ConfigFileName, HttpService:JSONEncode(Config))
        end
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

-- 2. NẠP DỮ LIỆU & LỚP CORE
local IslandsData = LoadModule("Data/Islands_Data.lua") or {Islands = {}, Bosses = {}}
local QuestsData = LoadModule("Data/Quests_Data.lua") or {}
local UI = LoadModule("Core/UI_Library.lua")
local Network = LoadModule("Core/Network.lua")
local Movement = LoadModule("Core/Movement.lua")
local Utils = LoadModule("Core/Utils.lua")

if not UI or not Network or not Movement then
    warn("[Titan Hub Fatal] Không thể khởi chạy do thiếu Core module!")
    return
end

-- 3. TẠO CÁC TAB GIAO DIỆN CHÍNH
local TabFarm = UI.CreateTab("Main Farm", "🌾")
local TabCombat = UI.CreateTab("Combat", "⚔️")
local TabFly = UI.CreateTab("Bay & Travel", "✈️")
local TabESP = UI.CreateTab("Visuals / ESP", "👁️")
local TabFruit = UI.CreateTab("Fruits / Stats", "🍎")
local TabLag = UI.CreateTab("Fix Lag & FPS", "⚡")
local TabSettings = UI.CreateTab("System", "⚙️")

-- 4. TAB: MAIN FARM
UI.AddSection(TabFarm, "Cài Đặt Auto Farm Level (1 -> 2800)")
UI.AddDropdown(TabFarm, "Vũ Khí Farm:", {"Melee", "Sword", "Blox Fruit", "Gun"}, function(v) Config.SelectedWeapon = v SaveConfig() end)
UI.AddSlider(TabFarm, "Độ Cao Farm Trên Đầu Quái (Studs)", 6, 20, Config.FarmHeight, function(v) Config.FarmHeight = v SaveConfig() end)
UI.AddToggle(TabFarm, "🌾 Auto Farm Level (1 -> 2800 Max)", Config.AutoFarmLevel, function(v) Config.AutoFarmLevel = v SaveConfig() end)

UI.AddSection(TabFarm, "Farm Quái & Boss Tuỳ Chọn")
local mobList = {}
for _, q in ipairs(QuestsData) do
    local exists = false
    for _, m in ipairs(mobList) do if m == q.Mob then exists = true break end end
    if not exists then table.insert(mobList, q.Mob) end
end
UI.AddDropdown(TabFarm, "Chọn Bãi Quái:", mobList, function(v) Config.SelectedMob = v SaveConfig() end)
UI.AddToggle(TabFarm, "🎯 Auto Farm Quái Đã Chọn", Config.AutoFarmSelectedMob, function(v) Config.AutoFarmSelectedMob = v SaveConfig() end)

local bossList = {}
for k, _ in pairs(IslandsData.Bosses or {}) do table.insert(bossList, k) end
UI.AddDropdown(TabFarm, "Chọn Boss Mục Tiêu:", bossList, function(v) Config.SelectedBoss = v SaveConfig() end)
UI.AddToggle(TabFarm, "👑 Auto Farm Boss Đã Chọn", Config.AutoFarmBoss, function(v) Config.AutoFarmBoss = v SaveConfig() end)
UI.AddToggle(TabFarm, "📦 Auto Farm Rương (Nhặt Tiền Cực Nhanh)", Config.AutoFarmChest, function(v) Config.AutoFarmChest = v SaveConfig() end)

-- 5. TAB: COMBAT & SKILLS
UI.AddSection(TabCombat, "Đòn Đánh & Gom Quái")
UI.AddToggle(TabCombat, "⚡ Fast Attack V3 (Đòn Đánh Siêu Tốc)", Config.FastAttack, function(v) Config.FastAttack = v SaveConfig() end)
UI.AddToggle(TabCombat, "🌀 Gom Quái 3D (Bring Mobs)", Config.BringMobs, function(v) Config.BringMobs = v SaveConfig() end)
UI.AddSlider(TabCombat, "Bán Kính Gom Quái (Studs)", 100, 500, Config.BringRadius, function(v) Config.BringRadius = v SaveConfig() end)

-- 6. TAB: BAY & TRAVEL
UI.AddSection(TabFly, "Dịch Chuyển Đến Đảo (Tween Mượt)")
local islandList = {}
for k, _ in pairs(IslandsData.Islands or {}) do table.insert(islandList, k) end
UI.AddDropdown(TabFly, "Chọn Đảo Đến:", islandList, function(v) Config.SelectedIsland = v SaveConfig() end)
UI.AddButton(TabFly, "🚀 Bay Đến Đảo Đã Chọn", function()
    local pos = IslandsData.Islands[Config.SelectedIsland]
    if pos then Movement.SafeWayPointTween(CFrame.new(pos + Vector3.new(0, 45, 0))) end
end)

UI.AddSection(TabFly, "Kỹ Năng Bay Tự Do (Điều Khiển Bằng Phím/Cảm Ứng)")
UI.AddToggle(TabFly, "✈️ Bay Tự Do V2 (Free Fly)", Config.Fly, function(v) 
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

-- 7. TAB: FIX LAG & SYSTEM
UI.AddSection(TabLag, "Tối Ưu Hoá & Tiết Kiệm Pin")
UI.AddToggle(TabLag, "⚡ Ultra Fix Lag FPS Booster V2", Config.FixLag, function(v) 
    Config.FixLag = v 
    if v and Utils then Utils.ApplyUltraFixLag() end
    SaveConfig()
end)
UI.AddToggle(TabLag, "🌙 Black Screen Mode (Treo Đêm)", Config.BlackScreen, function(v) 
    Config.BlackScreen = v 
    if Utils then Utils.ToggleBlackScreen(v) end
    SaveConfig()
end)

UI.AddSection(TabSettings, "Hệ Thống & Máy Chủ")
UI.AddToggle(TabSettings, "💤 Anti-AFK (Chống Văng Game)", Config.AntiAFK, function(v) Config.AntiAFK = v SaveConfig() end)
UI.AddButton(TabSettings, "🔄 Rejoin Current Server", function() if Utils then Utils.RejoinServer() end end)
UI.AddButton(TabSettings, "🌐 Server Hop (Tìm Server Ít Người)", function() if Utils then Utils.ServerHop() end end)

-- 8. TIẾN TRÌNH AUTO FARM STATE MACHINE CHUẨN V8.1
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

-- MASTER AUTO FARM LOOP (SMOOTH HORIZONTAL TWEEN + LOCAL HOVER ATTACK)
task.spawn(function()
    while task.wait(0.08) do
        local root = Network.GetRoot()
        local isFarming = Config.AutoFarmLevel or Config.AutoFarmSelectedMob or Config.AutoFarmBoss
        
        if root and isFarming then
            if Config.AutoFarmLevel then
                local quest = GetQuestForCurrentLevel()
                if quest then
                    if not HasActiveQuest() then
                        Movement.DisableHoverLock()
                        Movement.TweenTo(quest.NpcCFrame)
                        if (root.Position - quest.NpcCFrame.Position).Magnitude < 16 then
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
                        
                        if targetMob then
                            local mobPos = targetMob.HumanoidRootPart.Position
                            local distToMob = (root.Position - mobPos).Magnitude
                            local hoverTargetCF = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, Config.FarmHeight, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                            
                            -- Nếu đang ở xa quái (> 20 studs): TWEEN NGANG TRỰC TIẾP ĐẾN QUÁI
                            if distToMob > 20 then
                                Movement.DisableHoverLock()
                                Movement.TweenTo(hoverTargetCF)
                            else
                                -- Đã đến ngay trên đầu quái (<= 20 studs): KHOÁ VỊ TRÍ TRÊN KHÔNG VÀ TẤN CÔNG
                                Movement.StopTween()
                                Movement.EnableHoverLock(hoverTargetCF)
                                BringAndFreezeMobs(targetMob.HumanoidRootPart.CFrame)
                                Network.ExecuteFastAttack(Config.SelectedWeapon, targetMob)
                            end
                        else
                            -- Nếu chưa spawn quái, bay ngang đến toạ độ bãi quái
                            Movement.DisableHoverLock()
                            Movement.TweenTo(quest.MobCFrame * CFrame.new(0, Config.FarmHeight, 0))
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
                if targetMob then
                    local mobPos = targetMob.HumanoidRootPart.Position
                    local distToMob = (root.Position - mobPos).Magnitude
                    local hoverTargetCF = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, Config.FarmHeight, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    
                    if distToMob > 20 then
                        Movement.DisableHoverLock()
                        Movement.TweenTo(hoverTargetCF)
                    else
                        Movement.StopTween()
                        Movement.EnableHoverLock(hoverTargetCF)
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
                        if (Config.SelectedBoss == "" or mob.Name == Config.SelectedBoss) and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            targetBoss = mob
                            break
                        end
                    end
                end
                if targetBoss then
                    local mobPos = targetBoss.HumanoidRootPart.Position
                    local distToBoss = (root.Position - mobPos).Magnitude
                    local hoverTargetCF = targetBoss.HumanoidRootPart.CFrame * CFrame.new(0, Config.FarmHeight, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    
                    if distToBoss > 20 then
                        Movement.DisableHoverLock()
                        Movement.TweenTo(hoverTargetCF)
                    else
                        Movement.StopTween()
                        Movement.EnableHoverLock(hoverTargetCF)
                        BringAndFreezeMobs(targetBoss.HumanoidRootPart.CFrame)
                        Network.ExecuteFastAttack(Config.SelectedWeapon, targetBoss)
                    end
                else
                    Movement.DisableHoverLock()
                    if IslandsData.Bosses and IslandsData.Bosses[Config.SelectedBoss] then
                        Movement.TweenTo(CFrame.new(IslandsData.Bosses[Config.SelectedBoss] + Vector3.new(0, 30, 0)))
                    end
                end
            end
        else
            if not Config.Fly then Movement.DisableHoverLock() end
        end
    end
end)

-- 9. SỬA LỖI AUTO FARM RƯƠNG (CHEST FARM)
task.spawn(function()
    while task.wait(0.2) do
        if Config.AutoFarmChest then
            local root = Network.GetRoot()
            if root then
                local foundChest = nil
                local minDist = 9e9
                local ws = game:GetService("Workspace")
                local chestFolder = ws:FindFirstChild("ChestModels") or ws:FindFirstChild("Chests") or ws
                
                for _, obj in pairs(chestFolder:GetChildren()) do
                    if obj.Name:find("Chest") or obj.Name:find("ChestModels") then
                        local part = obj:IsA("BasePart") and obj or obj:FindFirstChildOfClass("BasePart")
                        if part and (not obj:FindFirstChild("Collected") or obj.Collected.Value ~= true) then
                            local d = (root.Position - part.Position).Magnitude
                            if d < minDist then
                                minDist = d
                                foundChest = part
                            end
                        end
                    end
                end
                
                if foundChest then
                    Movement.TweenTo(foundChest.CFrame * CFrame.new(0, 2.5, 0), 320)
                    if (root.Position - foundChest.Position).Magnitude < 8 then
                        pcall(function()
                            if firetouchinterest then
                                firetouchinterest(root, foundChest, 0)
                                task.wait(0.05)
                                firetouchinterest(root, foundChest, 1)
                            end
                        end)
                        task.wait(0.25)
                    end
                end
            end
        end
    end
end)

-- 10. NẠP CÁC MODULE THEO SEA & ESP
local PlaceId = game.PlaceId
if PlaceId == 2753915549 then
    local Sea1 = LoadModule("Modules/Sea1.lua")
    if Sea1 and Sea1.Init then Sea1.Init(UI, Config, Network, Movement, IslandsData) end
elseif PlaceId == 4442272183 then
    local Sea2 = LoadModule("Modules/Sea2.lua")
    if Sea2 and Sea2.Init then Sea2.Init(UI, Config, Network, Movement, IslandsData) end
elseif PlaceId == 7449423635 then
    local Sea3 = LoadModule("Modules/Sea3.lua")
    if Sea3 and Sea3.Init then Sea3.Init(UI, Config, Network, Movement, IslandsData) end
else
    local Sea1 = LoadModule("Modules/Sea1.lua")
    if Sea1 and Sea1.Init then Sea1.Init(UI, Config, Network, Movement, IslandsData) end
end

local ESPMod = LoadModule("Modules/ESP_FruitFinder.lua")
if ESPMod and ESPMod.Init then ESPMod.Init(UI, TabESP, TabFruit, Config, Network, Movement) end

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🔥 TITAN HUB V8.1",
        Text = "Auto Farm & Combat Engine sẵn sàng!",
        Duration = 5
    })
end)
print("★ BLOX FRUITS TITAN HUB V8.1 (TRUE FLIGHT & COMBAT ENGINE) LOADED ★")
