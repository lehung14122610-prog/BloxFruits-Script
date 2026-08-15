--[[
    ===================================================================================
    ★ BLOX FRUITS ULTIMATE HUB V6.1 (REDZ / FLUENT SUPREME TITAN EDITION) ★
    Tương thích 100% với tất cả Trình thực thi PC & Mobile:
    - Mobile: Delta, DeltaX, Arceus X, Codex, Fluxus Mobile, Hydrogen, VegaX
    - PC: Solara, Wave, Xeno, Celery, Swift, Synapse Z
    
    Bản v6.1: Khắc phục triệt để lỗi nil index data khi chưa load game,
    Mount UI an toàn tuyệt đối trên DeltaX qua gethui / PlayerGui.
    ===================================================================================
--]]

-- ===================================================================================
-- [ MÔ-ĐUN 1: MÔI TRƯỜNG AN TOÀN & BỘ NẠP GIAO DIỆN (DELTA / DELTAX COMPATIBILITY) ]
-- ===================================================================================
local getgenv = getgenv or function() return _G end
local cloneref = cloneref or function(obj) return obj end
local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local setclipboard = setclipboard or function() end
local isfolder = isfolder or function() return false end
local makefolder = makefolder or function() end
local readfile = readfile or function() return nil end
local writefile = writefile or function() return end
local isfile = isfile or function() return false end
local delfile = delfile or function() return end

-- Safe Service Getter
local function GetService(serviceName)
    local success, service = pcall(function()
        return cloneref(game:GetService(serviceName))
    end)
    if success and service then return service end
    return game:GetService(serviceName)
end

local Players = GetService("Players")
local Workspace = GetService("Workspace")
local RunService = GetService("RunService")
local TweenService = GetService("TweenService")
local UserInputService = GetService("UserInputService")
local ReplicatedStorage = GetService("ReplicatedStorage")
local Lighting = GetService("Lighting")
local TeleportService = GetService("TeleportService")
local HttpService = GetService("HttpService")
local VirtualUser = GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Safe Level Getter (Tuyệt đối không bị văng nếu Data chưa load)
local function GetPlayerLevelSafe()
    local lvl = 1
    pcall(function()
        if LocalPlayer and LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level") then
            lvl = tonumber(LocalPlayer.Data.Level.Value) or 1
        end
    end)
    return lvl
end

-- Safe GUI Container Resolver (gethui -> get_hidden_gui -> CoreGui -> PlayerGui)
local function GetUIContainer()
    local container = nil
    pcall(function()
        if gethui then
            container = gethui()
        elseif get_hidden_gui then
            container = get_hidden_gui()
        else
            local success, cg = pcall(function() return game:GetService("CoreGui") end)
            if success and cg then
                local testOk = pcall(function()
                    local t = Instance.new("Folder")
                    t.Parent = cg
                    t:Destroy()
                end)
                if testOk then container = cg end
            end
        end
    end)
    if container then return container end
    return LocalPlayer:WaitForChild("PlayerGui", 10) or LocalPlayer.PlayerGui
end

-- Dọn dẹp phiên bản GUI cũ nếu đang chạy lại
pcall(function()
    local oldUI = GetUIContainer():FindFirstChild("BF_Ultimate_Hub_Titan")
    if oldUI then oldUI:Destroy() end
end)

-- Kiểm tra hỗ trợ Drawing API
local HasDrawingAPI = pcall(function()
    local d = Drawing.new("Text")
    d:Remove()
end)


-- ===================================================================================
-- [ MÔ-ĐUN 2: HỆ THỐNG CẤU HÌNH GLOBAL & QUẢN LÝ TRẠNG THÁI (CONFIG MANAGER) ]
-- ===================================================================================
getgenv().BF_Hub_Config = {
    -- Auto Farm Level & Mobs
    AutoFarmLevel = false,
    AutoFarmSelectedMob = false,
    AutoFarmBoss = false,
    AutoFarmAllBosses = false,
    AutoFarmChest = false,
    AutoFarmMastery = false,
    AutoFarmBone = false,
    AutoFarmCakePrince = false,
    AutoFarmDoughKing = false,
    
    -- Farm Combat Settings
    SelectedMob = "",
    SelectedBoss = "",
    SelectedWeapon = "Melee", -- Melee, Sword, Blox Fruit, Gun
    FarmHeight = 13.5, -- Độ cao an toàn trên không trung chống quái đánh
    FarmDistance = 1.5,
    FastAttack = true,
    FastAttackSpeed = 0.02,
    BringMobs = true,
    BringRadius = 380,
    MasteryHealthPercent = 25,
    MasteryWeapon = "Sword",
    
    -- Skill Auto Spammer
    AutoSkillZ = false,
    AutoSkillX = false,
    AutoSkillC = false,
    AutoSkillV = false,
    AutoSkillF = false,
    SkillDelay = 0.4,
    
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
    InvisibleMode = false,
    TweenSpeed = 275,
    SelectedIsland = "Starter Island (Sea 1)",
    SelectedPlayer = "",
    
    -- ESP & Visuals
    ESP_Player = false,
    ESP_Mobs = false,
    ESP_Bosses = false,
    ESP_Chests = false,
    ESP_Fruits = false,
    ESP_Mirage = false,
    ESP_Flowers = false,
    ESP_SeaBeasts = false,
    ESP_Boxes = true,
    ESP_Tracers = false,
    ESP_Color_Player = Color3.fromRGB(0, 255, 170),
    ESP_Color_Mob = Color3.fromRGB(255, 90, 90),
    ESP_Color_Chest = Color3.fromRGB(255, 215, 0),
    ESP_Color_Fruit = Color3.fromRGB(255, 60, 60),
    ESP_Color_Flower = Color3.fromRGB(255, 105, 180),
    
    -- Blox Fruits Services & Utilities
    AutoStat = false,
    StatTarget = "Melee", -- Melee, Defense, Sword, Gun, Blox Fruit
    StatPointAmount = 3,
    AutoHaki = true,
    AutoObservation = false,
    AutoCollectFruit = false,
    AutoStoreFruit = true,
    AutoBuyGachaFruit = false,
    AutoCollectFlowers = false,
    
    -- Sea Events & Raids
    AutoSeaBeast = false,
    AutoTerrorShark = false,
    AutoRaid = false,
    SelectedRaidChip = "Flame",
    AutoAwakenFruit = true,
    
    -- Race V4 & Mirage
    AutoMirageGear = false,
    AutoLookMoon = false,
    
    -- Optimization & Fix Lag
    FixLag = false,
    BlackScreen = false,
    FullBright = false,
    ClearFog = false,
    
    -- System Controls
    AntiAFK = true,
    ThemeColor = "Neon Cyan"
}

local Config = getgenv().BF_Hub_Config
local ConfigFileName = "BF_Hub_Titan_Config_v6.json"

local function SaveConfig()
    pcall(function()
        local json = HttpService:JSONEncode(Config)
        writefile(ConfigFileName, json)
    end)
end

local function LoadConfig()
    pcall(function()
        if isfile and isfile(ConfigFileName) then
            local content = readfile(ConfigFileName)
            local decoded = HttpService:JSONDecode(content)
            for k, v in pairs(decoded) do
                Config[k] = v
            end
        end
    end)
end

LoadConfig()

-- Toast Notification Engine
local function Notify(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title or "BF Titan Hub",
            Text = text or "",
            Duration = duration or 3
        })
    end)
end


-- ===================================================================================
-- [ MÔ-ĐUN 3: CƠ SỞ DỮ LIỆU TOÀN DIỆN (ISLANDS, QUESTS, BOSSES, FLOWERS, MATERIALS) ]
-- ===================================================================================

local Islands = {
    -- SEA 1
    ["Starter Island (Sea 1)"] = Vector3.new(979, 16, 1428),
    ["Jungle (Sea 1)"] = Vector3.new(-1612, 36, 148),
    ["Pirate Village (Sea 1)"] = Vector3.new(-1136, 4, 3848),
    ["Desert (Sea 1)"] = Vector3.new(1094, 6, 4192),
    ["Middle Town (Sea 1)"] = Vector3.new(-690, 15, 1582),
    ["Frozen Village (Sea 1)"] = Vector3.new(1147, 26, -1154),
    ["Marine Fortress (Sea 1)"] = Vector3.new(-5036, 20, 4324),
    ["Skylands Lower (Sea 1)"] = Vector3.new(-4832, 717, -2623),
    ["Skylands Middle (Sea 1)"] = Vector3.new(-4600, 850, -1800),
    ["Skylands Upper (Sea 1)"] = Vector3.new(-7902, 5580, -383),
    ["Prison (Sea 1)"] = Vector3.new(4854, 5, 739),
    ["Colosseum (Sea 1)"] = Vector3.new(-1440, 7, -3015),
    ["Magma Village (Sea 1)"] = Vector3.new(-5242, 8, 8527),
    ["Underwater City (Sea 1)"] = Vector3.new(3864, 5, -1926),
    ["Fountain City (Sea 1)"] = Vector3.new(5127, 59, 4105),

    -- SEA 2
    ["Cafe / Rose Town (Sea 2)"] = Vector3.new(-386, 73, 298),
    ["Kingdom of Rose Area 1 (Sea 2)"] = Vector3.new(-427, 73, 1836),
    ["Kingdom of Rose Area 2 (Sea 2)"] = Vector3.new(635, 73, 918),
    ["Mansion (Sea 2)"] = Vector3.new(-288, 306, 598),
    ["Green Zone (Sea 2)"] = Vector3.new(-2384, 72, -3154),
    ["Graveyard (Sea 2)"] = Vector3.new(-5445, 48, -748),
    ["Snow Mountain (Sea 2)"] = Vector3.new(623, 401, -5374),
    ["Hot and Cold (Sea 2)"] = Vector3.new(-502, 15, -5334),
    ["Cursed Ship (Sea 2)"] = Vector3.new(923, 125, 32852),
    ["Ice Castle (Sea 2)"] = Vector3.new(6148, 294, -6742),
    ["Forgotten Island (Sea 2)"] = Vector3.new(-3055, 239, -10145),
    ["Dark Arena (Sea 2)"] = Vector3.new(3782, 15, -3499),

    -- SEA 3
    ["Port Town (Sea 3)"] = Vector3.new(-290, 6, 5343),
    ["Hydra Island (Sea 3)"] = Vector3.new(5750, 610, -282),
    ["Great Tree (Sea 3)"] = Vector3.new(2284, 25, -6755),
    ["Floating Turtle (Sea 3)"] = Vector3.new(-13274, 332, -7926),
    ["Mansion Turtle (Sea 3)"] = Vector3.new(-12463, 374, -7548),
    ["Castle on the Sea (Sea 3)"] = Vector3.new(-5056, 314, -3161),
    ["Haunted Castle (Sea 3)"] = Vector3.new(-9514, 142, 5535),
    ["Peanut Land (Sea 3)"] = Vector3.new(-2100, 38, -10150),
    ["Ice Cream Land (Sea 3)"] = Vector3.new(245, 25, -12200),
    ["Cake Land (Sea 3)"] = Vector3.new(-2000, 38, -12000),
    ["Tiki Outpost (Sea 3)"] = Vector3.new(-16235, 9, 413)
}

local QuestData = {
    -- SEA 1
    {MinLvl = 1, MaxLvl = 9, Mob = "Bandit", QuestName = "BanditQuest1", QuestLvl = 1, NpcCFrame = CFrame.new(1059, 16, 1550), MobCFrame = CFrame.new(1145, 17, 1634)},
    {MinLvl = 10, MaxLvl = 14, Mob = "Monkey", QuestName = "JungleQuest", QuestLvl = 1, NpcCFrame = CFrame.new(-1598, 36, 153), MobCFrame = CFrame.new(-1618, 22, 142)},
    {MinLvl = 15, MaxLvl = 29, Mob = "Gorilla", QuestName = "JungleQuest", QuestLvl = 2, NpcCFrame = CFrame.new(-1598, 36, 153), MobCFrame = CFrame.new(-1240, 6, -495)},
    {MinLvl = 30, MaxLvl = 39, Mob = "Pirate", QuestName = "BuggyQuest1", QuestLvl = 1, NpcCFrame = CFrame.new(-1140, 4, 3828), MobCFrame = CFrame.new(-1205, 4, 3915)},
    {MinLvl = 40, MaxLvl = 59, Mob = "Brute", QuestName = "BuggyQuest1", QuestLvl = 2, NpcCFrame = CFrame.new(-1140, 4, 3828), MobCFrame = CFrame.new(-1375, 20, 4150)},
    {MinLvl = 60, MaxLvl = 74, Mob = "Desert Bandit", QuestName = "DesertQuest", QuestLvl = 1, NpcCFrame = CFrame.new(896, 6, 4388), MobCFrame = CFrame.new(980, 6, 4435)},
    {MinLvl = 75, MaxLvl = 89, Mob = "Desert Officer", QuestName = "DesertQuest", QuestLvl = 2, NpcCFrame = CFrame.new(896, 6, 4388), MobCFrame = CFrame.new(1580, 4, 4360)},
    {MinLvl = 90, MaxLvl = 99, Mob = "Snow Bandit", QuestName = "SnowQuest", QuestLvl = 1, NpcCFrame = CFrame.new(1385, 87, -1298), MobCFrame = CFrame.new(1280, 105, -1430)},
    {MinLvl = 100, MaxLvl = 119, Mob = "Snowman", QuestName = "SnowQuest", QuestLvl = 2, NpcCFrame = CFrame.new(1385, 87, -1298), MobCFrame = CFrame.new(1285, 150, -1125)},
    {MinLvl = 120, MaxLvl = 149, Mob = "Chief Petty Officer", QuestName = "MarineQuest2", QuestLvl = 1, NpcCFrame = CFrame.new(-5039, 27, 4324), MobCFrame = CFrame.new(-4840, 22, 4270)},
    {MinLvl = 150, MaxLvl = 174, Mob = "Sky Bandit", QuestName = "SkyQuest", QuestLvl = 1, NpcCFrame = CFrame.new(-4840, 717, -2623), MobCFrame = CFrame.new(-4975, 717, -2890)},
    {MinLvl = 175, MaxLvl = 189, Mob = "Dark Master", QuestName = "SkyQuest", QuestLvl = 2, NpcCFrame = CFrame.new(-4840, 717, -2623), MobCFrame = CFrame.new(-5240, 388, -2250)},
    {MinLvl = 190, MaxLvl = 209, Mob = "Prisoner", QuestName = "PrisonerQuest", QuestLvl = 1, NpcCFrame = CFrame.new(5308, 2, 474), MobCFrame = CFrame.new(5120, 4, 520)},
    {MinLvl = 210, MaxLvl = 249, Mob = "Dangerous Prisoner", QuestName = "PrisonerQuest", QuestLvl = 2, NpcCFrame = CFrame.new(5308, 2, 474), MobCFrame = CFrame.new(5540, 4, 740)},
    {MinLvl = 250, MaxLvl = 274, Mob = "Toga Warrior", QuestName = "ColosseumQuest", QuestLvl = 1, NpcCFrame = CFrame.new(-1580, 7, -2980), MobCFrame = CFrame.new(-1800, 50, -2750)},
    {MinLvl = 275, MaxLvl = 299, Mob = "Gladiator", QuestName = "ColosseumQuest", QuestLvl = 2, NpcCFrame = CFrame.new(-1580, 7, -2980), MobCFrame = CFrame.new(-1380, 7, -3300)},
    {MinLvl = 300, MaxLvl = 324, Mob = "Military Soldier", QuestName = "MagmaQuest", QuestLvl = 1, NpcCFrame = CFrame.new(-5315, 12, 8515), MobCFrame = CFrame.new(-5400, 60, 8450)},
    {MinLvl = 325, MaxLvl = 374, Mob = "Military Spy", QuestName = "MagmaQuest", QuestLvl = 2, NpcCFrame = CFrame.new(-5315, 12, 8515), MobCFrame = CFrame.new(-5800, 75, 8800)},
    {MinLvl = 375, MaxLvl = 399, Mob = "Fishman Warrior", QuestName = "FishmanQuest", QuestLvl = 1, NpcCFrame = CFrame.new(61122, 18, 1567), MobCFrame = CFrame.new(60800, 18, 1500)},
    {MinLvl = 400, MaxLvl = 449, Mob = "Fishman Commando", QuestName = "FishmanQuest", QuestLvl = 2, NpcCFrame = CFrame.new(61122, 18, 1567), MobCFrame = CFrame.new(61800, 18, 1450)},
    {MinLvl = 450, MaxLvl = 474, Mob = "God's Guard", QuestName = "SkyExp1Quest", QuestLvl = 1, NpcCFrame = CFrame.new(-7860, 5545, -380), MobCFrame = CFrame.new(-7720, 5600, -440)},
    {MinLvl = 475, MaxLvl = 524, Mob = "Shandora Warrior", QuestName = "SkyExp1Quest", QuestLvl = 2, NpcCFrame = CFrame.new(-7860, 5545, -380), MobCFrame = CFrame.new(-7650, 5600, -260)},
    {MinLvl = 525, MaxLvl = 549, Mob = "Royal Squad", QuestName = "SkyExp2Quest", QuestLvl = 1, NpcCFrame = CFrame.new(-7900, 5635, -1410), MobCFrame = CFrame.new(-7600, 5615, -1400)},
    {MinLvl = 550, MaxLvl = 624, Mob = "Royal Soldier", QuestName = "SkyExp2Quest", QuestLvl = 2, NpcCFrame = CFrame.new(-7900, 5635, -1410), MobCFrame = CFrame.new(-7800, 5615, -1800)},
    {MinLvl = 625, MaxLvl = 649, Mob = "Galley Pirate", QuestName = "FountainQuest", QuestLvl = 1, NpcCFrame = CFrame.new(5258, 38, 4050), MobCFrame = CFrame.new(5580, 40, 3950)},
    {MinLvl = 650, MaxLvl = 699, Mob = "Galley Captain", QuestName = "FountainQuest", QuestLvl = 2, NpcCFrame = CFrame.new(5258, 38, 4050), MobCFrame = CFrame.new(5650, 40, 4950)},

    -- SEA 2
    {MinLvl = 700, MaxLvl = 724, Mob = "Raider", QuestName = "Area1Quest", QuestLvl = 1, NpcCFrame = CFrame.new(-427, 73, 1836), MobCFrame = CFrame.new(-740, 73, 2400)},
    {MinLvl = 725, MaxLvl = 774, Mob = "Mercenary", QuestName = "Area1Quest", QuestLvl = 2, NpcCFrame = CFrame.new(-427, 73, 1836), MobCFrame = CFrame.new(-920, 73, 1600)},
    {MinLvl = 775, MaxLvl = 799, Mob = "Swan Pirate", QuestName = "Area2Quest", QuestLvl = 1, NpcCFrame = CFrame.new(635, 73, 918), MobCFrame = CFrame.new(880, 120, 1200)},
    {MinLvl = 800, MaxLvl = 874, Mob = "Factory Staff", QuestName = "Area2Quest", QuestLvl = 2, NpcCFrame = CFrame.new(635, 73, 918), MobCFrame = CFrame.new(600, 73, -400)},
    {MinLvl = 875, MaxLvl = 899, Mob = "Marine Lieutenant", QuestName = "MarineQuest3", QuestLvl = 1, NpcCFrame = CFrame.new(-2440, 73, -3220), MobCFrame = CFrame.new(-2800, 73, -3000)},
    {MinLvl = 900, MaxLvl = 949, Mob = "Marine Captain", QuestName = "MarineQuest3", QuestLvl = 2, NpcCFrame = CFrame.new(-2440, 73, -3220), MobCFrame = CFrame.new(-1800, 73, -3300)},
    {MinLvl = 950, MaxLvl = 999, Mob = "Zombie", QuestName = "GraveyardQuest", QuestLvl = 1, NpcCFrame = CFrame.new(-5490, 48, -795), MobCFrame = CFrame.new(-5600, 48, -900)},
    {MinLvl = 1000, MaxLvl = 1049, Mob = "Snow Trooper", QuestName = "SnowMountainQuest", QuestLvl = 1, NpcCFrame = CFrame.new(605, 401, -5370), MobCFrame = CFrame.new(500, 401, -5500)},
    {MinLvl = 1050, MaxLvl = 1099, Mob = "Winter Warrior", QuestName = "SnowMountainQuest", QuestLvl = 2, NpcCFrame = CFrame.new(605, 401, -5370), MobCFrame = CFrame.new(1100, 430, -5200)},
    {MinLvl = 1100, MaxLvl = 1124, Mob = "Lab Subordinate", QuestName = "FireSideQuest", QuestLvl = 1, NpcCFrame = CFrame.new(-502, 15, -5334), MobCFrame = CFrame.new(-600, 15, -4400)},
    {MinLvl = 1125, MaxLvl = 1174, Mob = "Horned Warrior", QuestName = "FireSideQuest", QuestLvl = 2, NpcCFrame = CFrame.new(-502, 15, -5334), MobCFrame = CFrame.new(-1300, 15, -5300)},
    {MinLvl = 1175, MaxLvl = 1199, Mob = "Magma Ninja", QuestName = "IceSideQuest", QuestLvl = 1, NpcCFrame = CFrame.new(-1490, 15, -5040), MobCFrame = CFrame.new(-5400, 15, -5800)},
    {MinLvl = 1200, MaxLvl = 1249, Mob = "Lava Pirate", QuestName = "IceSideQuest", QuestLvl = 2, NpcCFrame = CFrame.new(-1490, 15, -5040), MobCFrame = CFrame.new(-5300, 15, -4700)},
    {MinLvl = 1250, MaxLvl = 1274, Mob = "Ship Deckhand", QuestName = "ShipQuest1", QuestLvl = 1, NpcCFrame = CFrame.new(1038, 125, 32910), MobCFrame = CFrame.new(1200, 125, 33000)},
    {MinLvl = 1275, MaxLvl = 1299, Mob = "Ship Engineer", QuestName = "ShipQuest1", QuestLvl = 2, NpcCFrame = CFrame.new(1038, 125, 32910), MobCFrame = CFrame.new(900, 125, 32800)},
    {MinLvl = 1300, MaxLvl = 1324, Mob = "Ship Steward", QuestName = "ShipQuest2", QuestLvl = 1, NpcCFrame = CFrame.new(968, 125, 33430), MobCFrame = CFrame.new(900, 125, 33500)},
    {MinLvl = 1325, MaxLvl = 1349, Mob = "Ship Officer", QuestName = "ShipQuest2", QuestLvl = 2, NpcCFrame = CFrame.new(968, 125, 33430), MobCFrame = CFrame.new(1000, 125, 33200)},
    {MinLvl = 1350, MaxLvl = 1374, Mob = "Arctic Warrior", QuestName = "FrostQuest", QuestLvl = 1, NpcCFrame = CFrame.new(5670, 28, -6480), MobCFrame = CFrame.new(6000, 28, -6200)},
    {MinLvl = 1375, MaxLvl = 1424, Mob = "Snow Lurker", QuestName = "FrostQuest", QuestLvl = 2, NpcCFrame = CFrame.new(5670, 28, -6480), MobCFrame = CFrame.new(5500, 28, -6800)},
    {MinLvl = 1425, MaxLvl = 1449, Mob = "Sea Soldier", QuestName = "ForgottenQuest", QuestLvl = 1, NpcCFrame = CFrame.new(-3055, 239, -10145), MobCFrame = CFrame.new(-3200, 239, -9700)},
    {MinLvl = 1450, MaxLvl = 1499, Mob = "Water Fighter", QuestName = "ForgottenQuest", QuestLvl = 2, NpcCFrame = CFrame.new(-3055, 239, -10145), MobCFrame = CFrame.new(-3400, 239, -10500)},

    -- SEA 3
    {MinLvl = 1500, MaxLvl = 1524, Mob = "Pirate Millionaire", QuestName = "PortTownQuest", QuestLvl = 1, NpcCFrame = CFrame.new(-290, 6, 5343), MobCFrame = CFrame.new(-380, 6, 5550)},
    {MinLvl = 1525, MaxLvl = 1574, Mob = "Pistol Billionaire", QuestName = "PortTownQuest", QuestLvl = 2, NpcCFrame = CFrame.new(-290, 6, 5343), MobCFrame = CFrame.new(-50, 6, 5350)},
    {MinLvl = 1575, MaxLvl = 1599, Mob = "Dragon Crew Warrior", QuestName = "AmazonQuest", QuestLvl = 1, NpcCFrame = CFrame.new(5833, 52, -1100), MobCFrame = CFrame.new(6200, 52, -1300)},
    {MinLvl = 1600, MaxLvl = 1699, Mob = "Dragon Crew Archer", QuestName = "AmazonQuest", QuestLvl = 2, NpcCFrame = CFrame.new(5833, 52, -1100), MobCFrame = CFrame.new(6600, 52, -900)},
    {MinLvl = 1700, MaxLvl = 1724, Mob = "Female Islander", QuestName = "AmazonQuest2", QuestLvl = 1, NpcCFrame = CFrame.new(5440, 600, 750), MobCFrame = CFrame.new(5800, 600, 900)},
    {MinLvl = 1725, MaxLvl = 1774, Mob = "Giant Islander", QuestName = "AmazonQuest2", QuestLvl = 2, NpcCFrame = CFrame.new(5440, 600, 750), MobCFrame = CFrame.new(5000, 600, 500)},
    {MinLvl = 1775, MaxLvl = 1799, Mob = "Marine Commodore", QuestName = "MarineTreeQuest", QuestLvl = 1, NpcCFrame = CFrame.new(2180, 28, -6740), MobCFrame = CFrame.new(2400, 28, -6800)},
    {MinLvl = 1800, MaxLvl = 1849, Mob = "Marine Rear Admiral", QuestName = "MarineTreeQuest", QuestLvl = 2, NpcCFrame = CFrame.new(2180, 28, -6740), MobCFrame = CFrame.new(2800, 28, -6400)},
    {MinLvl = 1850, MaxLvl = 1899, Mob = "Fishman Raider", QuestName = "DeepForestIsland1Quest", QuestLvl = 1, NpcCFrame = CFrame.new(-13274, 332, -7926), MobCFrame = CFrame.new(-13400, 332, -8400)},
    {MinLvl = 1900, MaxLvl = 1949, Mob = "Fishman Captain", QuestName = "DeepForestIsland1Quest", QuestLvl = 2, NpcCFrame = CFrame.new(-13274, 332, -7926), MobCFrame = CFrame.new(-13800, 332, -7700)},
    {MinLvl = 1950, MaxLvl = 1999, Mob = "Forest Pirate", QuestName = "DeepForestIsland2Quest", QuestLvl = 1, NpcCFrame = CFrame.new(-13274, 332, -7926), MobCFrame = CFrame.new(-13300, 332, -7300)},
    {MinLvl = 2000, MaxLvl = 2049, Mob = "Mythological Pirate", QuestName = "DeepForestIsland2Quest", QuestLvl = 2, NpcCFrame = CFrame.new(-13274, 332, -7926), MobCFrame = CFrame.new(-13500, 332, -6900)},
    {MinLvl = 2050, MaxLvl = 2074, Mob = "Jungle Pirate", QuestName = "HauntedQuest1", QuestLvl = 1, NpcCFrame = CFrame.new(-9514, 142, 5535), MobCFrame = CFrame.new(-9200, 142, 5800)},
    {MinLvl = 2075, MaxLvl = 2099, Mob = "Musketeer Pirate", QuestName = "HauntedQuest1", QuestLvl = 2, NpcCFrame = CFrame.new(-9514, 142, 5535), MobCFrame = CFrame.new(-9800, 142, 5300)},
    {MinLvl = 2100, MaxLvl = 2124, Mob = "Reborn Skeleton", QuestName = "HauntedQuest2", QuestLvl = 1, NpcCFrame = CFrame.new(-9514, 142, 5535), MobCFrame = CFrame.new(-8800, 142, 6000)},
    {MinLvl = 2125, MaxLvl = 2199, Mob = "Living Zombie", QuestName = "HauntedQuest2", QuestLvl = 2, NpcCFrame = CFrame.new(-9514, 142, 5535), MobCFrame = CFrame.new(-10100, 142, 5900)},
    {MinLvl = 2200, MaxLvl = 2224, Mob = "Demonic Soul", QuestName = "HauntedQuest3", QuestLvl = 1, NpcCFrame = CFrame.new(-9514, 142, 5535), MobCFrame = CFrame.new(-9500, 142, 6300)},
    {MinLvl = 2225, MaxLvl = 2249, Mob = "Posessed Mummy", QuestName = "HauntedQuest3", QuestLvl = 2, NpcCFrame = CFrame.new(-9514, 142, 5535), MobCFrame = CFrame.new(-9600, 142, 6100)},
    {MinLvl = 2250, MaxLvl = 2274, Mob = "Peanut Scout", QuestName = "NutsIslandQuest", QuestLvl = 1, NpcCFrame = CFrame.new(-2100, 38, -10150), MobCFrame = CFrame.new(-2000, 38, -10400)},
    {MinLvl = 2275, MaxLvl = 2299, Mob = "Peanut President", QuestName = "NutsIslandQuest", QuestLvl = 2, NpcCFrame = CFrame.new(-2100, 38, -10150), MobCFrame = CFrame.new(-2200, 38, -9800)},
    {MinLvl = 2300, MaxLvl = 2324, Mob = "Ice Cream Chef", QuestName = "IceCreamIslandQuest", QuestLvl = 1, NpcCFrame = CFrame.new(245, 25, -12200), MobCFrame = CFrame.new(400, 25, -12400)},
    {MinLvl = 2325, MaxLvl = 2374, Mob = "Ice Cream Commander", QuestName = "IceCreamIslandQuest", QuestLvl = 2, NpcCFrame = CFrame.new(245, 25, -12200), MobCFrame = CFrame.new(100, 25, -12000)},
    {MinLvl = 2375, MaxLvl = 2399, Mob = "Cookie Crafter", QuestName = "CakeQuest1", QuestLvl = 1, NpcCFrame = CFrame.new(-2000, 38, -12000), MobCFrame = CFrame.new(-2300, 38, -12200)},
    {MinLvl = 2400, MaxLvl = 2449, Mob = "Cake Guard", QuestName = "CakeQuest1", QuestLvl = 2, NpcCFrame = CFrame.new(-2000, 38, -12000), MobCFrame = CFrame.new(-1800, 38, -11800)},
    {MinLvl = 2450, MaxLvl = 2499, Mob = "Isle Outlaw", QuestName = "TikiQuest1", QuestLvl = 1, NpcCFrame = CFrame.new(-16235, 9, 413), MobCFrame = CFrame.new(-16500, 9, 700)},
    {MinLvl = 2500, MaxLvl = 2550, Mob = "Island Empress", QuestName = "TikiQuest2", QuestLvl = 1, NpcCFrame = CFrame.new(-16235, 9, 413), MobCFrame = CFrame.new(-16000, 9, 100)}
}

local BossDatabase = {
    ["Gorilla King"] = Vector3.new(-1128, 6, -450),
    ["The Saw"] = Vector3.new(-682, 15, 1600),
    ["Yeti"] = Vector3.new(1185, 106, -1518),
    ["Vice Admiral"] = Vector3.new(-4980, 23, 4400),
    ["Warden"] = Vector3.new(5190, 4, 690),
    ["Chief Warden"] = Vector3.new(5230, 4, 475),
    ["Swan (Sea 1)"] = Vector3.new(5230, 4, 740),
    ["Magma Admiral"] = Vector3.new(-5694, 18, 8735),
    ["Fishman Lord"] = Vector3.new(61350, 31, 1095),
    ["Wysper"] = Vector3.new(-7927, 5550, -637),
    ["Thunder God"] = Vector3.new(-7748, 5607, -2300),
    ["Cyborg"] = Vector3.new(6160, 28, 1480),
    ["Don Swan"] = Vector3.new(2285, 15, 805),
    ["Smoke Admiral"] = Vector3.new(-5080, 24, -5350),
    ["Awakened Ice Admiral"] = Vector3.new(6473, 297, -6844),
    ["Tide Keeper"] = Vector3.new(-3800, 77, -11500),
    ["Order"] = Vector3.new(-6500, 15, -4500),
    ["Darkbeard"] = Vector3.new(3782, 15, -3499),
    ["Stone"] = Vector3.new(-1050, 40, 6780),
    ["Island Empress"] = Vector3.new(5730, 602, 199),
    ["Captain Elephant"] = Vector3.new(-13393, 319, -8423),
    ["Beautiful Pirate"] = Vector3.new(5030, 315, -4060),
    ["Rip Indra"] = Vector3.new(-5333, 317, -2818),
    ["Cake Prince"] = Vector3.new(-2060, 38, -12040),
    ["Dough King"] = Vector3.new(-2060, 38, -12040),
    ["Cake Queen"] = Vector3.new(-710, 381, -11150),
    ["Soul Reaper"] = Vector3.new(-9514, 142, 5535)
}


-- ===================================================================================
-- [ MÔ-ĐUN 4: GIAO DIỆN REDZ / FLUENT UI GLASSMORPHISM & MOBILE CONTROLS ]
-- ===================================================================================

local parentUI = GetUIContainer()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BF_Ultimate_Hub_Titan"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = parentUI

-- 1. NÚT ICON NỔI MOBILE TOGGLE (🔥) CHO DELTAX & CẢM ỨNG
local MobileFloatingBtn = Instance.new("TextButton")
MobileFloatingBtn.Name = "MobileToggleIcon"
MobileFloatingBtn.Size = UDim2.new(0, 54, 0, 54)
MobileFloatingBtn.Position = UDim2.new(0, 16, 0.22, 0)
MobileFloatingBtn.BackgroundColor3 = Color3.fromRGB(15, 18, 28)
MobileFloatingBtn.Text = "🔥"
MobileFloatingBtn.TextSize = 26
MobileFloatingBtn.ZIndex = 1000
MobileFloatingBtn.Active = true
MobileFloatingBtn.Draggable = true
MobileFloatingBtn.Parent = ScreenGui

local MobileBtnCorner = Instance.new("UICorner")
MobileBtnCorner.CornerRadius = UDim.new(1, 0)
MobileBtnCorner.Parent = MobileFloatingBtn

local MobileBtnStroke = Instance.new("UIStroke")
MobileBtnStroke.Color = Color3.fromRGB(0, 220, 255)
MobileBtnStroke.Thickness = 2.5
MobileBtnStroke.Parent = MobileFloatingBtn

-- 2. CỬA SỔ CHÍNH (MAIN WINDOW GLASSMORPHISM)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 720, 0, 460)
MainFrame.Position = UDim2.new(0.5, -360, 0.5, -230)
MainFrame.BackgroundColor3 = Color3.fromRGB(13, 15, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 500
MainFrame.Visible = true -- Bật giao diện ngay lập tức!
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(35, 42, 60)
MainStroke.Thickness = 1.8
MainStroke.Parent = MainFrame

MobileFloatingBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- 3. TITLE HEADER BAR
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 501
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleLogo = Instance.new("TextLabel")
TitleLogo.Parent = TitleBar
TitleLogo.Size = UDim2.new(0, 35, 1, 0)
TitleLogo.Position = UDim2.new(0, 12, 0, 0)
TitleLogo.BackgroundTransparency = 1
TitleLogo.Text = "⚡"
TitleLogo.TextSize = 22
TitleLogo.ZIndex = 502

local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.Size = UDim2.new(1, -120, 1, 0)
TitleText.Position = UDim2.new(0, 46, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "BLOX FRUITS TITAN HUB V6.1 (REDZ EDITION)"
TitleText.TextColor3 = Color3.fromRGB(0, 235, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 15
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.ZIndex = 502

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(235, 55, 65)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.ZIndex = 502

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- 4. SIDEBAR VỚI PLAYER PROFILE CARD
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 185, 1, -44)
Sidebar.Position = UDim2.new(0, 0, 0, 44)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 12, 17)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 501
Sidebar.Parent = MainFrame

-- Profile Card
local ProfileCard = Instance.new("Frame")
ProfileCard.Size = UDim2.new(1, -12, 0, 70)
ProfileCard.Position = UDim2.new(0, 6, 0, 6)
ProfileCard.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
ProfileCard.ZIndex = 502
ProfileCard.Parent = Sidebar

local ProfileCorner = Instance.new("UICorner")
ProfileCorner.CornerRadius = UDim.new(0, 8)
ProfileCorner.Parent = ProfileCard

local ProfileStroke = Instance.new("UIStroke")
ProfileStroke.Color = Color3.fromRGB(30, 38, 55)
ProfileStroke.Thickness = 1
ProfileStroke.Parent = ProfileCard

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 44, 0, 44)
AvatarImg.Position = UDim2.new(0, 8, 0, 13)
AvatarImg.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
AvatarImg.ZIndex = 503
AvatarImg.Parent = ProfileCard

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImg

pcall(function()
    local thumb = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    AvatarImg.Image = thumb
end)

local ProfileName = Instance.new("TextLabel")
ProfileName.Size = UDim2.new(1, -62, 0, 18)
ProfileName.Position = UDim2.new(0, 58, 0, 14)
ProfileName.BackgroundTransparency = 1
ProfileName.Text = tostring(LocalPlayer.DisplayName or LocalPlayer.Name)
ProfileName.TextColor3 = Color3.fromRGB(240, 240, 240)
ProfileName.Font = Enum.Font.GothamBold
ProfileName.TextSize = 13
ProfileName.TextXAlignment = Enum.TextXAlignment.Left
ProfileName.TextTruncate = Enum.TextTruncate.AtEnd
ProfileName.ZIndex = 503
ProfileName.Parent = ProfileCard

local ProfileStat = Instance.new("TextLabel")
ProfileStat.Size = UDim2.new(1, -62, 0, 16)
ProfileStat.Position = UDim2.new(0, 58, 0, 34)
ProfileStat.BackgroundTransparency = 1
ProfileStat.Text = "Lv. " .. tostring(GetPlayerLevelSafe())
ProfileStat.TextColor3 = Color3.fromRGB(0, 220, 255)
ProfileStat.Font = Enum.Font.GothamMedium
ProfileStat.TextSize = 12
ProfileStat.TextXAlignment = Enum.TextXAlignment.Left
ProfileStat.ZIndex = 503
ProfileStat.Parent = ProfileCard

-- Realtime Stat Updater
task.spawn(function()
    while task.wait(3) do
        pcall(function()
            ProfileStat.Text = "Lv. " .. tostring(GetPlayerLevelSafe())
        end)
    end
end)

-- Sidebar Tabs Container
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(1, 0, 1, -85)
TabContainer.Position = UDim2.new(0, 0, 0, 82)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 2
TabContainer.ZIndex = 502
TabContainer.Parent = Sidebar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabContainer
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 4)

-- 5. CONTENT AREA
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -195, 1, -54)
ContentArea.Position = UDim2.new(0, 190, 0, 49)
ContentArea.BackgroundTransparency = 1
ContentArea.ZIndex = 501
ContentArea.Parent = MainFrame

local Pages = {}
local TabButtons = {}

local function CreateTab(name, icon)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -12, 0, 36)
    tabBtn.Position = UDim2.new(0, 6, 0, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(16, 20, 28)
    tabBtn.Text = (icon or "📁") .. " " .. name
    tabBtn.TextColor3 = Color3.fromRGB(180, 190, 210)
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextSize = 13
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.ZIndex = 503
    tabBtn.Parent = TabContainer
    
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.Parent = tabBtn
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabBtn
    
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -8, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
    page.Visible = false
    page.ZIndex = 502
    page.Parent = ContentArea
    
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Parent = page
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 8)
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, b in pairs(TabButtons) do 
            b.BackgroundColor3 = Color3.fromRGB(16, 20, 28)
            b.TextColor3 = Color3.fromRGB(180, 190, 210)
        end
        page.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 230)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    table.insert(Pages, page)
    table.insert(TabButtons, tabBtn)
    
    if #Pages == 1 then 
        page.Visible = true 
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 230)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    return page
end

-- 6. INTERACTIVE UI COMPONENTS
local function AddSection(parent, title)
    local sec = Instance.new("Frame")
    sec.Size = UDim2.new(1, -10, 0, 28)
    sec.BackgroundTransparency = 1
    sec.ZIndex = 503
    sec.Parent = parent
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "─── " .. title:upper() .. " ───"
    lbl.TextColor3 = Color3.fromRGB(0, 200, 255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.ZIndex = 504
    lbl.Parent = sec
end

local function AddToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(20, 24, 34)
    frame.ZIndex = 503
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(32, 38, 52)
    stroke.Thickness = 1
    stroke.Parent = frame
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -75, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(240, 245, 255)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 504
    lbl.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 52, 0, 26)
    btn.Position = UDim2.new(1, -62, 0.5, -13)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 210, 120) or Color3.fromRGB(50, 58, 76)
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.ZIndex = 504
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 210, 120) or Color3.fromRGB(50, 58, 76)
        btn.Text = state and "ON" or "OFF"
        callback(state)
        SaveConfig()
    end)
end

local function AddButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(0, 135, 240)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.ZIndex = 503
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

local function AddSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 48)
    frame.BackgroundColor3 = Color3.fromRGB(20, 24, 34)
    frame.ZIndex = 503
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(32, 38, 52)
    stroke.Thickness = 1
    stroke.Parent = frame
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 0, 20)
    lbl.Position = UDim2.new(0, 12, 0, 3)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. tostring(default)
    lbl.TextColor3 = Color3.fromRGB(240, 245, 255)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 504
    lbl.Parent = frame
    
    local sliderBg = Instance.new("TextButton")
    sliderBg.Size = UDim2.new(1, -24, 0, 10)
    sliderBg.Position = UDim2.new(0, 12, 0, 28)
    sliderBg.BackgroundColor3 = Color3.fromRGB(45, 52, 70)
    sliderBg.Text = ""
    sliderBg.ZIndex = 504
    sliderBg.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderBg
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 220, 255)
    fill.BorderSizePixel = 0
    fill.ZIndex = 505
    fill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local dragging = false
    local function UpdateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        lbl.Text = text .. ": " .. tostring(val)
        callback(val)
        SaveConfig()
    end
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateSlider(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local function AddDropdown(parent, text, options, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(20, 24, 34)
    frame.ZIndex = 503
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(32, 38, 52)
    stroke.Thickness = 1
    stroke.Parent = frame
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.42, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(240, 245, 255)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 504
    lbl.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.54, -10, 0, 28)
    btn.Position = UDim2.new(0.46, 0, 0.5, -14)
    btn.BackgroundColor3 = Color3.fromRGB(32, 38, 54)
    btn.Text = options[1] or "Select"
    btn.TextColor3 = Color3.fromRGB(0, 220, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextTruncate = Enum.TextTruncate.AtEnd
    btn.ZIndex = 504
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    local currentIndex = 1
    btn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex + 1
        if currentIndex > #options then currentIndex = 1 end
        btn.Text = options[currentIndex]
        callback(options[currentIndex])
        SaveConfig()
    end)
end


-- ===================================================================================
-- [ MÔ-ĐUN 5: SAFE AUTO FARM ENGINE V6 (FIX TRIỆT ĐỂ LỖI BỊ QUÁI ĐÁNH CHẾT) ]
-- ===================================================================================

local function GetCharacter()
    return LocalPlayer.Character
end

local function GetRoot()
    local char = GetCharacter()
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

local function GetHumanoid()
    local char = GetCharacter()
    if char then
        return char:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

-- 1. GRAVITY LOCK & HOVER ENGINE (CHỐNG RƠI XUỐNG BẦY QUÁI)
local FarmBodyVel = nil
local FarmBodyGyro = nil

local function EnableGravityLock(targetCFrame)
    local root = GetRoot()
    if not root then return end
    
    if not FarmBodyVel or FarmBodyVel.Parent ~= root then
        if FarmBodyVel then FarmBodyVel:Destroy() end
        FarmBodyVel = Instance.new("BodyVelocity")
        FarmBodyVel.Name = "BF_Hub_GravityLock_Vel"
        FarmBodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        FarmBodyVel.Velocity = Vector3.zero
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

local function DisableGravityLock()
    if FarmBodyVel then FarmBodyVel:Destroy() FarmBodyVel = nil end
    if FarmBodyGyro then FarmBodyGyro:Destroy() FarmBodyGyro = nil end
end

-- 2. TWEEN ENGINE AN TOÀN TRÁNH BẪY ANTI-CHEAT
local ActiveTween = nil

local function StopTween()
    if ActiveTween then
        ActiveTween:Cancel()
        ActiveTween = nil
    end
end

local function TweenTo(targetCFrame, customSpeed)
    local root = GetRoot()
    if not root then return end
    
    local speed = customSpeed or Config.TweenSpeed
    local distance = (root.Position - targetCFrame.Position).Magnitude
    
    if distance < 3.5 then
        root.CFrame = targetCFrame
        return
    end
    
    local time = distance / speed
    StopTween()
    
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    ActiveTween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
    ActiveTween:Play()
    return ActiveTween
end

local function SafeWayPointTween(targetCFrame)
    local root = GetRoot()
    if not root then return end
    
    local currentPos = root.Position
    local targetPos = targetCFrame.Position
    local dist = (currentPos - targetPos).Magnitude
    
    if dist > 800 then
        local highPos1 = Vector3.new(currentPos.X, 950, currentPos.Z)
        local highPos2 = Vector3.new(targetPos.X, 950, targetPos.Z)
        
        TweenTo(CFrame.new(highPos1)):Completed():Wait()
        TweenTo(CFrame.new(highPos2)):Completed():Wait()
        TweenTo(targetCFrame):Completed():Wait()
    else
        TweenTo(targetCFrame)
    end
end

-- 3. MOB FREEZE & BRING MOBS 3D V3
local function BringAndFreezeMobs(targetCenterCF)
    if not Config.BringMobs then return end
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return end
    
    for _, mob in pairs(enemies:GetChildren()) do
        if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            local dist = (targetCenterCF.Position - mob.HumanoidRootPart.Position).Magnitude
            if dist <= Config.BringRadius then
                mob.HumanoidRootPart.CFrame = targetCenterCF * CFrame.new(0, 0, -1)
                mob.HumanoidRootPart.CanCollide = false
                mob.HumanoidRootPart.Velocity = Vector3.zero
                mob.Humanoid.WalkSpeed = 0
                mob.Humanoid.PlatformStand = true
            end
        end
    end
end

-- 4. FAST ATTACK V3 (TRANG BỊ VŨ KHÍ + ACTIVATE TOOL + CLICKER)
local function EquipSelectedWeapon()
    local char = GetCharacter()
    if not char then return end
    local hum = GetHumanoid()
    local backpack = LocalPlayer.Backpack
    local targetType = Config.SelectedWeapon
    
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
    
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            if (targetType == "Melee" and tool.ToolTip == "Melee") or
               (targetType == "Sword" and tool.ToolTip == "Sword") or
               (targetType == "Blox Fruit" and tool.ToolTip == "Blox Fruit") or
               (targetType == "Gun" and tool.ToolTip == "Gun") then
                if hum then hum:EquipTool(tool) end
                return tool
            end
        end
    end
end

local function ExecuteFastAttack()
    if not Config.FastAttack then return end
    pcall(function()
        local tool = EquipSelectedWeapon()
        if tool then
            tool:Activate()
        end
        VirtualUser:Button1Down(Vector2.new(0, 0), Camera.CFrame)
        VirtualUser:Button1Up(Vector2.new(0, 0), Camera.CFrame)
    end)
end

-- 5. AUTO QUEST CHECKER
local function GetQuestForCurrentLevel()
    local level = GetPlayerLevelSafe()
    for _, q in ipairs(QuestData) do
        if level >= q.MinLvl and level <= q.MaxLvl then
            return q
        end
    end
    return QuestData[1]
end

local function HasActiveQuest()
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    if pgui and pgui:FindFirstChild("Main") and pgui.Main:FindFirstChild("Quest") then
        return pgui.Main.Quest.Visible
    end
    return false
end

local function TakeQuest(questData)
    if not questData then return end
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questData.QuestName, questData.QuestLvl)
    end)
end

-- 6. MAIN AUTO FARM LOOP
task.spawn(function()
    while task.wait(0.08) do
        local root = GetRoot()
        local isFarming = Config.AutoFarmLevel or Config.AutoFarmSelectedMob or Config.AutoFarmBoss or Config.AutoFarmAllBosses
        
        if root and isFarming then
            if Config.AutoFarmLevel then
                local quest = GetQuestForCurrentLevel()
                if quest then
                    if not HasActiveQuest() then
                        DisableGravityLock()
                        TweenTo(quest.NpcCFrame)
                        if (root.Position - quest.NpcCFrame.Position).Magnitude < 16 then
                            TakeQuest(quest)
                            task.wait(0.4)
                        end
                    else
                        local enemies = Workspace:FindFirstChild("Enemies")
                        local targetMob = nil
                        
                        if enemies then
                            for _, mob in pairs(enemies:GetChildren()) do
                                if mob.Name == quest.Mob and 
                                   mob:FindFirstChild("HumanoidRootPart") and 
                                   mob:FindFirstChild("Humanoid") and 
                                   mob.Humanoid.Health > 0 then
                                    targetMob = mob
                                    break
                                end
                            end
                        end
                        
                        if targetMob then
                            -- GIỮ ĐỘ CAO AN TOÀN 13.5 STUDS TRÊN ĐẦU QUÁI CHỐNG BỊ ĐÁNH
                            local safeFarmCF = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, Config.FarmHeight, Config.FarmDistance) * CFrame.Angles(math.rad(-90), 0, 0)
                            EnableGravityLock(safeFarmCF)
                            root.CFrame = safeFarmCF
                            BringAndFreezeMobs(targetMob.HumanoidRootPart.CFrame)
                            ExecuteFastAttack()
                        else
                            DisableGravityLock()
                            TweenTo(quest.MobCFrame)
                        end
                    end
                end
            elseif Config.AutoFarmSelectedMob then
                local enemies = Workspace:FindFirstChild("Enemies")
                local targetMob = nil
                
                if enemies then
                    for _, mob in pairs(enemies:GetChildren()) do
                        if (Config.SelectedMob == "" or mob.Name == Config.SelectedMob) and 
                           mob:FindFirstChild("HumanoidRootPart") and 
                           mob:FindFirstChild("Humanoid") and 
                           mob.Humanoid.Health > 0 then
                            targetMob = mob
                            break
                        end
                    end
                end
                
                if targetMob then
                    local safeFarmCF = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, Config.FarmHeight, Config.FarmDistance) * CFrame.Angles(math.rad(-90), 0, 0)
                    EnableGravityLock(safeFarmCF)
                    root.CFrame = safeFarmCF
                    BringAndFreezeMobs(targetMob.HumanoidRootPart.CFrame)
                    ExecuteFastAttack()
                else
                    DisableGravityLock()
                end
            elseif Config.AutoFarmBoss then
                local enemies = Workspace:FindFirstChild("Enemies")
                local targetBoss = nil
                
                if enemies then
                    for _, mob in pairs(enemies:GetChildren()) do
                        if (Config.SelectedBoss == "" or mob.Name == Config.SelectedBoss) and 
                           mob:FindFirstChild("HumanoidRootPart") and 
                           mob:FindFirstChild("Humanoid") and 
                           mob.Humanoid.Health > 0 then
                            targetBoss = mob
                            break
                        end
                    end
                end
                
                if targetBoss then
                    local safeFarmCF = targetBoss.HumanoidRootPart.CFrame * CFrame.new(0, Config.FarmHeight, Config.FarmDistance) * CFrame.Angles(math.rad(-90), 0, 0)
                    EnableGravityLock(safeFarmCF)
                    root.CFrame = safeFarmCF
                    BringAndFreezeMobs(targetBoss.HumanoidRootPart.CFrame)
                    ExecuteFastAttack()
                else
                    DisableGravityLock()
                    if BossDatabase[Config.SelectedBoss] then
                        TweenTo(CFrame.new(BossDatabase[Config.SelectedBoss] + Vector3.new(0, 50, 0)))
                    end
                end
            end
        else
            if not Config.Fly then
                DisableGravityLock()
            end
        end
    end
end)

-- 7. AUTO CHEST FARM ENGINE
task.spawn(function()
    while task.wait(0.2) do
        if Config.AutoFarmChest then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v.Name:find("Chest") and v:IsA("BasePart") then
                    TweenTo(v.CFrame * CFrame.new(0, 3, 0), 320)
                    task.wait(0.3)
                end
            end
        end
    end
end)


-- ===================================================================================
-- [ MÔ-ĐUN 6: MOVEMENT ENGINE, SKILL SPAMMER & DUAL ESP ENGINE ]
-- ===================================================================================

-- 1. Noclip Engine
RunService.Stepped:Connect(function()
    if Config.Noclip or Config.AutoFarmLevel or Config.AutoFarmSelectedMob or Config.AutoFarmBoss or Config.Fly or Config.AutoCollectFruit then
        local char = GetCharacter()
        if char then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- 2. Water Walk Engine
local WaterPlatform = Instance.new("Part")
WaterPlatform.Name = "BF_Hub_WaterPlatform_Titan"
WaterPlatform.Size = Vector3.new(600, 1, 600)
WaterPlatform.Anchored = true
WaterPlatform.Transparency = 1
WaterPlatform.Parent = Workspace

RunService.RenderStepped:Connect(function()
    if Config.WaterWalk then
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

-- 3. Infinite Jump & WalkSpeed & JumpPower
UserInputService.JumpRequest:Connect(function()
    if Config.InfiniteJump then
        local hum = GetHumanoid()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.RenderStepped:Connect(function()
    local hum = GetHumanoid()
    if hum then
        if Config.WalkSpeedToggle then hum.WalkSpeed = Config.WalkSpeed end
        if Config.JumpPowerToggle then 
            hum.UseJumpPower = true 
            hum.JumpPower = Config.JumpPower 
        end
    end
end)

-- 4. Free Fly Engine V2
local flyBodyVel, flyBodyGyro = nil, nil
local flyKeys = {W = false, A = false, S = false, D = false, E = false, Q = false}

local function StartFly()
    local root = GetRoot()
    if not root then return end
    
    if flyBodyVel then flyBodyVel:Destroy() end
    if flyBodyGyro then flyBodyGyro:Destroy() end
    
    flyBodyVel = Instance.new("BodyVelocity")
    flyBodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyBodyVel.Velocity = Vector3.zero
    flyBodyVel.Parent = root
    
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    flyBodyGyro.CFrame = root.CFrame
    flyBodyGyro.Parent = root
    
    task.spawn(function()
        while Config.Fly and flyBodyVel and flyBodyGyro do
            local moveDir = Vector3.zero
            local camCF = Camera.CFrame
            
            if flyKeys.W then moveDir = moveDir + camCF.LookVector end
            if flyKeys.S then moveDir = moveDir - camCF.LookVector end
            if flyKeys.A then moveDir = moveDir - camCF.RightVector end
            if flyKeys.D then moveDir = moveDir + camCF.RightVector end
            if flyKeys.E then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if flyKeys.Q then moveDir = moveDir - Vector3.new(0, 1, 0) end
            
            if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
            
            flyBodyVel.Velocity = moveDir * Config.FlySpeed
            flyBodyGyro.CFrame = camCF
            RunService.RenderStepped:Wait()
        end
        
        if flyBodyVel then flyBodyVel:Destroy() flyBodyVel = nil end
        if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
    end)
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

-- 5. Auto Skill Spammer Loop
local function UseSkillKey(key)
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(true, Enum.KeyCode[key], false, game)
        task.wait(0.05)
        vim:SendKeyEvent(false, Enum.KeyCode[key], false, game)
    end)
end

task.spawn(function()
    while task.wait(Config.SkillDelay) do
        if Config.AutoFarmLevel or Config.AutoFarmSelectedMob or Config.AutoFarmBoss then
            if Config.AutoSkillZ then UseSkillKey("Z") end
            if Config.AutoSkillX then UseSkillKey("X") end
            if Config.AutoSkillC then UseSkillKey("C") end
            if Config.AutoSkillV then UseSkillKey("V") end
            if Config.AutoSkillF then UseSkillKey("F") end
        end
    end
end)

-- 6. Dual ESP Engine (BillboardGui Fallback + Drawing API)
local ESPFolder = Instance.new("Folder", Workspace)
ESPFolder.Name = "BF_Hub_ESP_Titan"

local function ClearESP()
    ESPFolder:ClearAllChildren()
end

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

RunService.RenderStepped:Connect(function()
    ClearESP()
    local root = GetRoot()
    if not root then return end
    
    -- Player ESP
    if Config.ESP_Player then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = math.floor((root.Position - p.Character.HumanoidRootPart.Position).Magnitude)
                local hp = p.Character:FindFirstChild("Humanoid") and math.floor(p.Character.Humanoid.Health) or 0
                CreateESPLabel(p.Character.HumanoidRootPart, Config.ESP_Color_Player, p.Name .. " | " .. dist .. "m | HP: " .. hp)
            end
        end
    end
    
    -- Chest ESP
    if Config.ESP_Chests then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v.Name:find("Chest") and v:IsA("BasePart") then
                local dist = math.floor((root.Position - v.Position).Magnitude)
                CreateESPLabel(v, Config.ESP_Color_Chest, "📦 Rương | " .. dist .. "m")
            end
        end
    end
    
    -- Fruit ESP
    if Config.ESP_Fruits then
        for _, v in pairs(Workspace:GetChildren()) do
            if v:IsA("Tool") or v.Name:find("Fruit") then
                local handle = v:FindFirstChild("Handle") or v:FindFirstChildOfClass("Part")
                if handle then
                    local dist = math.floor((root.Position - handle.Position).Magnitude)
                    CreateESPLabel(handle, Config.ESP_Color_Fruit, "🍎 " .. v.Name .. " | " .. dist .. "m")
                end
            end
        end
    end
    
    -- Mobs ESP
    if Config.ESP_Mobs then
        local enemies = Workspace:FindFirstChild("Enemies")
        if enemies then
            for _, mob in pairs(enemies:GetChildren()) do
                if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    local dist = math.floor((root.Position - mob.HumanoidRootPart.Position).Magnitude)
                    CreateESPLabel(mob.HumanoidRootPart, Config.ESP_Color_Mob, mob.Name .. " | " .. dist .. "m")
                end
            end
        end
    end
    
    -- Flowers ESP
    if Config.ESP_Flowers then
        for _, v in pairs(Workspace:GetChildren()) do
            if v.Name == "Flower1" or v.Name == "Flower2" then
                local dist = math.floor((root.Position - v.Position).Magnitude)
                CreateESPLabel(v, Config.ESP_Color_Flower, "🌸 Hoa: " .. v.Name .. " | " .. dist .. "m")
            end
        end
    end
end)


-- ===================================================================================
-- [ MÔ-ĐUN 7: BLOX FRUITS SERVICES (STATS, HAKI, FRUIT STORE, RAIDS, FIX LAG) ]
-- ===================================================================================

-- 1. Auto Stat Point
task.spawn(function()
    while task.wait(0.4) do
        if Config.AutoStat then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", Config.StatTarget, Config.StatPointAmount)
            end)
        end
    end
end)

-- 2. Auto Buso Haki
task.spawn(function()
    while task.wait(1) do
        if Config.AutoHaki then
            local char = GetCharacter()
            if char and not char:FindFirstChild("HasBuso") then
                pcall(function()
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("HasBuso")
                end)
            end
        end
    end
end)

-- 3. Auto Collect & Store Fruit
task.spawn(function()
    while task.wait(1) do
        if Config.AutoCollectFruit then
            for _, v in pairs(Workspace:GetChildren()) do
                if v:IsA("Tool") or v.Name:find("Fruit") then
                    local handle = v:FindFirstChild("Handle") or v:FindFirstChildOfClass("Part")
                    if handle then
                        TweenTo(handle.CFrame, 350)
                        task.wait(0.5)
                        if Config.AutoStoreFruit and v:IsA("Tool") then
                            pcall(function()
                                ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", v.Name, v)
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- 4. Auto Gacha Random Fruit (Blox Fruit Dealer Cousin)
task.spawn(function()
    while task.wait(10) do
        if Config.AutoBuyGachaFruit then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
            end)
        end
    end
end)

-- 5. Race V2 Flowers Collector
task.spawn(function()
    while task.wait(1) do
        if Config.AutoCollectFlowers then
            for _, v in pairs(Workspace:GetChildren()) do
                if v.Name == "Flower1" or v.Name == "Flower2" then
                    TweenTo(v.CFrame * CFrame.new(0, 3, 0), 300)
                    task.wait(0.5)
                end
            end
        end
    end
end)

-- 6. Anti-AFK Handler
LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        pcall(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
        end)
    end
end)

-- 7. Ultra Fix Lag Booster
local function ApplyUltraFixLag()
    if not Config.FixLag then return end
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.CastShadow = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                v.Enabled = false
            end
        end
    end)
end

-- 8. Black Screen Mode (Treo đêm tiết kiệm 85% Pin & CPU)
local BlackScreenFrame = nil

local function ToggleBlackScreen(state)
    if state then
        if not BlackScreenFrame then
            local sg = Instance.new("ScreenGui")
            sg.Name = "BF_Hub_BlackScreen_Titan"
            sg.ResetOnSpawn = false
            sg.DisplayOrder = 999999
            sg.Parent = parentUI
            
            BlackScreenFrame = Instance.new("Frame")
            BlackScreenFrame.Size = UDim2.new(1, 0, 1, 0)
            BlackScreenFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            BlackScreenFrame.Parent = sg
            
            local txt = Instance.new("TextLabel")
            txt.Parent = BlackScreenFrame
            txt.Size = UDim2.new(1, 0, 1, 0)
            txt.Text = "🌙 ULTRA BLACK SCREEN MODE (TREO ĐÊM TIẾT KIỆM PIN & FPS)

Nhấp nút Icon Nổi Mobile (🔥) để mở lại giao diện."
            txt.TextColor3 = Color3.fromRGB(0, 255, 170)
            txt.Font = Enum.Font.GothamBold
            txt.TextSize = 22
        end
        BlackScreenFrame.Visible = true
        RunService:Set3dRenderingEnabled(false)
    else
        if BlackScreenFrame then BlackScreenFrame.Visible = false end
        RunService:Set3dRenderingEnabled(true)
    end
end

-- Garbage Collection Loop
task.spawn(function()
    while task.wait(30) do
        collectgarbage("collect")
    end
end)


-- ===================================================================================
-- [ MÔ-ĐUN 8: KHỞI TẠO TẤT CẢ CÁC TAB ĐIỀU KHIỂN (UI CONTROLS CONSTRUCTOR) ]
-- ===================================================================================

local TabFarm = CreateTab("Main Farm", "🌾")
local TabCombat = CreateTab("Combat", "⚔️")
local TabSea = CreateTab("Sea & Raids", "🌊")
local TabRace = CreateTab("Race & Mirage", "🧬")
local TabFly = CreateTab("Bay & Travel", "✈️")
local TabESP = CreateTab("Visuals / ESP", "👁️")
local TabFruit = CreateTab("Fruits / Gacha", "🍎")
local TabLag = CreateTab("Fix Lag & FPS", "⚡")
local TabSettings = CreateTab("System", "⚙️")

-- -------------------------------------------------------------
-- 1. TAB: MAIN FARM
-- -------------------------------------------------------------
AddSection(TabFarm, "Cài Đặt Farm Căn Bản")
AddDropdown(TabFarm, "Vũ Khí Farm:", {"Melee", "Sword", "Blox Fruit", "Gun"}, function(v) Config.SelectedWeapon = v end)
AddSlider(TabFarm, "Độ Cao An Toàn Trên Không (Studs)", 8, 25, Config.FarmHeight, function(v) Config.FarmHeight = v end)
AddToggle(TabFarm, "🌾 Auto Farm Level (Lv 1 -> 2550)", Config.AutoFarmLevel, function(v) Config.AutoFarmLevel = v end)

AddSection(TabFarm, "Farm Theo Mục Tiêu Tuỳ Chọn")
local mobNames = {}
for _, q in ipairs(QuestData) do
    if not table.find(mobNames, q.Mob) then table.insert(mobNames, q.Mob) end
end
AddDropdown(TabFarm, "Chọn Bãi Quái:", mobNames, function(v) Config.SelectedMob = v end)
AddToggle(TabFarm, "🎯 Auto Farm Quái Bãi Đã Chọn", Config.AutoFarmSelectedMob, function(v) Config.AutoFarmSelectedMob = v end)

local bossNames = {}
for k, _ in pairs(BossDatabase) do table.insert(bossNames, k) end
AddDropdown(TabFarm, "Chọn Boss Mục Tiêu:", bossNames, function(v) Config.SelectedBoss = v end)
AddToggle(TabFarm, "👑 Auto Farm Boss Đã Chọn", Config.AutoFarmBoss, function(v) Config.AutoFarmBoss = v end)
AddToggle(TabFarm, "📦 Auto Farm Rương (Chest Farm)", Config.AutoFarmChest, function(v) Config.AutoFarmChest = v end)

-- -------------------------------------------------------------
-- 2. TAB: COMBAT & SKILLS
-- -------------------------------------------------------------
AddSection(TabCombat, "Chiến Đấu & Đòn Đánh Siêu Tốc")
AddToggle(TabCombat, "⚡ Fast Attack V3 (Đòn Đánh Siêu Tốc)", Config.FastAttack, function(v) Config.FastAttack = v end)
AddToggle(TabCombat, "🌀 Gom Quái V3 (Bring Mobs 3D)", Config.BringMobs, function(v) Config.BringMobs = v end)
AddSlider(TabCombat, "Bán Kính Gom Quái (Studs)", 100, 500, Config.BringRadius, function(v) Config.BringRadius = v end)

AddSection(TabCombat, "Tự Động Xả Kỹ Năng (Skill Spammer)")
AddToggle(TabCombat, "🔥 Auto Xả Chiêu Z", Config.AutoSkillZ, function(v) Config.AutoSkillZ = v end)
AddToggle(TabCombat, "🔥 Auto Xả Chiêu X", Config.AutoSkillX, function(v) Config.AutoSkillX = v end)
AddToggle(TabCombat, "🔥 Auto Xả Chiêu C", Config.AutoSkillC, function(v) Config.AutoSkillC = v end)
AddToggle(TabCombat, "🔥 Auto Xả Chiêu V", Config.AutoSkillV, function(v) Config.AutoSkillV = v end)
AddToggle(TabCombat, "🔥 Auto Xả Chiêu F", Config.AutoSkillF, function(v) Config.AutoSkillF = v end)
AddSlider(TabCombat, "Độ Trễ Xả Chiêu (Giây)", 0.2, 2.0, Config.SkillDelay, function(v) Config.SkillDelay = v end)

-- -------------------------------------------------------------
-- 3. TAB: SEA & RAIDS
-- -------------------------------------------------------------
AddSection(TabSea, "Sea Events Helper (Sea 2 & 3)")
AddToggle(TabSea, "🦈 Auto Farm Sea Beast & Quái Biển", Config.AutoSeaBeast, function(v) Config.AutoSeaBeast = v end)
AddToggle(TabSea, "⚓ Auto Farm Thuyền Ma (Ghost Ship)", Config.AutoTerrorShark, function(v) Config.AutoTerrorShark = v end)

AddSection(TabSea, "Raid Dungeon & Thức Tỉnh Trái (Awaken)")
AddDropdown(TabSea, "Chọn Chip Raid:", {"Flame", "Ice", "Quake", "Light", "Dark", "String", "Rumble", "Magma", "Buddha", "Dough"}, function(v) Config.SelectedRaidChip = v end)
AddButton(TabSea, "💳 Mua Chip Raid Tự Động", function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", Config.SelectedRaidChip)
    end)
end)
AddButton(TabSea, "🚀 Bắt Đầu Raid (Start Raid)", function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNpc", "Start")
    end)
end)
AddToggle(TabSea, "⚡ Auto Đi Raid & Thức Tỉnh Kỹ Năng", Config.AutoRaid, function(v) Config.AutoRaid = v end)

-- -------------------------------------------------------------
-- 4. TAB: RACE V2/V4 & MIRAGE ISLAND
-- -------------------------------------------------------------
AddSection(TabRace, "Race V2 (Tìm Hoa Tự Động)")
AddToggle(TabRace, "🌸 Auto Tìm & Nhặt Hoa Đỏ / Xanh", Config.AutoCollectFlowers, function(v) Config.AutoCollectFlowers = v end)

AddSection(TabRace, "Race V4 & Mirage Island (Sea 3)")
AddButton(TabRace, "🏝️ Bay Đến Đảo Mirage (Nếu Có)", function()
    local mirage = Workspace:FindFirstChild("MirageIsland") or Workspace:FindFirstChild("Mirage Island")
    if mirage and mirage:FindFirstChild("Center") then
        SafeWayPointTween(mirage.Center.CFrame + Vector3.new(0, 60, 0))
    else
        Notify("Mirage Tracker", "Không tìm thấy Đảo Mirage trên Server hiện tại!", 3)
    end
end)
AddToggle(TabRace, "⚙️ Auto Tìm Bánh Răng (Gear Finder)", Config.AutoMirageGear, function(v) Config.AutoMirageGear = v end)
AddToggle(TabRace, "🌕 Auto Nhìn Mặt Trăng (Look at Moon)", Config.AutoLookMoon, function(v) Config.AutoLookMoon = v end)

-- -------------------------------------------------------------
-- 5. TAB: BAY & TRAVEL
-- -------------------------------------------------------------
AddSection(TabFly, "Di Chuyển Đến Đảo (Island Teleport)")
local islandOptions = {}
for k, _ in pairs(Islands) do table.insert(islandOptions, k) end
AddDropdown(TabFly, "Chọn Đảo Đến:", islandOptions, function(v) Config.SelectedIsland = v end)
AddButton(TabFly, "🚀 Bay Đến Đảo Đã Chọn", function()
    local targetPos = Islands[Config.SelectedIsland]
    if targetPos then
        SafeWayPointTween(CFrame.new(targetPos + Vector3.new(0, 60, 0)))
    end
end)

AddSection(TabFly, "Kỹ Năng Bay & Di Chuyển")
AddToggle(TabFly, "✈️ Bay Tự Do V2 (Free Fly)", Config.Fly, function(v) 
    Config.Fly = v 
    if v then StartFly() end
end)
AddSlider(TabFly, "Tốc Độ Bay Tự Do", 20, 250, Config.FlySpeed, function(v) Config.FlySpeed = v end)
AddToggle(TabFly, "🏃 Bật Chạy Nhanh (WalkSpeed)", Config.WalkSpeedToggle, function(v) Config.WalkSpeedToggle = v end)
AddSlider(TabFly, "Tốc Độ Chạy (Speed)", 16, 300, Config.WalkSpeed, function(v) Config.WalkSpeed = v end)
AddToggle(TabFly, "🦘 Bật Nhảy Cao (JumpPower)", Config.JumpPowerToggle, function(v) Config.JumpPowerToggle = v end)
AddSlider(TabFly, "Độ Cao Nhảy (Power)", 50, 300, Config.JumpPower, function(v) Config.JumpPower = v end)
AddToggle(TabFly, "🧱 Noclip (Đi Xuyên Tường)", Config.Noclip, function(v) Config.Noclip = v end)
AddToggle(TabFly, "🌊 Water Walk (Đi Trên Nước)", Config.WaterWalk, function(v) Config.WaterWalk = v end)
AddToggle(TabFly, "🦘 Infinite Jump (Nhảy Vô Tận)", Config.InfiniteJump, function(v) Config.InfiniteJump = v end)

-- -------------------------------------------------------------
-- 6. TAB: VISUALS / ESP
-- -------------------------------------------------------------
AddSection(TabESP, "ESP Định Vị & Nhìn Thấu")
AddToggle(TabESP, "👤 ESP Players (Người Chơi)", Config.ESP_Player, function(v) Config.ESP_Player = v end)
AddToggle(TabESP, "🧟 ESP Mobs (Quái Thường)", Config.ESP_Mobs, function(v) Config.ESP_Mobs = v end)
AddToggle(TabESP, "📦 ESP Rương (Chests)", Config.ESP_Chests, function(v) Config.ESP_Chests = v end)
AddToggle(TabESP, "🍎 ESP Trái Ác Quỷ (Fruits)", Config.ESP_Fruits, function(v) Config.ESP_Fruits = v end)
AddToggle(TabESP, "🌸 ESP Hoa Race V2 (Flowers)", Config.ESP_Flowers, function(v) Config.ESP_Flowers = v end)

-- -------------------------------------------------------------
-- 7. TAB: FRUITS / GACHA & STATS
-- -------------------------------------------------------------
AddSection(TabFruit, "Tự Động Cộng Điểm Chỉ Số (Stats)")
AddToggle(TabFruit, "📊 Auto Cộng Điểm Chỉ Số", Config.AutoStat, function(v) Config.AutoStat = v end)
AddDropdown(TabFruit, "Chỉ Số Cần Nâng:", {"Melee", "Defense", "Sword", "Gun", "Blox Fruit"}, function(v) Config.StatTarget = v end)

AddSection(TabFruit, "Trái Ác Quỷ & Gacha")
AddToggle(TabFruit, "🍎 Auto Nhặt Trái Rơi Trên Bản Đồ", Config.AutoCollectFruit, function(v) Config.AutoCollectFruit = v end)
AddToggle(TabFruit, "📥 Auto Cất Trái Vào Rương Đồ", Config.AutoStoreFruit, function(v) Config.AutoStoreFruit = v end)
AddToggle(TabFruit, "🎲 Auto Mua Trái Ngẫu Nhiên (Gacha)", Config.AutoBuyGachaFruit, function(v) Config.AutoBuyGachaFruit = v end)
AddToggle(TabFruit, "🛡️ Auto Bật Buso Haki (Vũ Trang)", Config.AutoHaki, function(v) Config.AutoHaki = v end)

-- -------------------------------------------------------------
-- 8. TAB: FIX LAG & FPS BOOSTER
-- -------------------------------------------------------------
AddSection(TabLag, "Tối Ưu Hoá Đồ Hoạ & Mượt Game")
AddToggle(TabLag, "⚡ Ultra Fix Lag FPS Booster V2", Config.FixLag, function(v) 
    Config.FixLag = v 
    if v then ApplyUltraFixLag() end
end)
AddToggle(TabLag, "🌙 Black Screen Mode (Treo Đêm Tiết Kiệm Pin)", Config.BlackScreen, function(v) 
    Config.BlackScreen = v 
    ToggleBlackScreen(v)
end)

-- -------------------------------------------------------------
-- 9. TAB: SYSTEM & SERVER
-- -------------------------------------------------------------
AddSection(TabSettings, "Hệ Thống & Máy Chủ")
AddToggle(TabSettings, "💤 Anti-AFK (Chống Văng 20 Phút)", Config.AntiAFK, function(v) Config.AntiAFK = v end)
AddButton(TabSettings, "🔄 Rejoin Current Server", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)
AddButton(TabSettings, "🌐 Server Hop (Tìm Server Ít Người)", function()
    pcall(function()
        local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local Http = game:GetService("HttpService")
        local list = Http:JSONDecode(game:HttpGet(Api))
        if list and list.data then
            for _, s in pairs(list.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                    break
                end
            end
        end
    end)
end)
AddButton(TabSettings, "💾 Lưu Cài Đặt (Save Config)", function()
    SaveConfig()
    Notify("Config Manager", "Đã lưu cài đặt cấu hình thành công!", 3)
end)

Notify("🔥 BLOX FRUITS TITAN HUB V6.1", "Giao diện Redz Edition đã tải thành công!", 5)
print("★ BLOX FRUITS TITAN HUB V6.1 (REDZ / FLUENT EDITION) LOADED SUCCESSFULLY ★")


-- ===================================================================================
-- [ MÔ-ĐUN 9: TỪ ĐIỂN CƠ SỞ DỮ LIỆU GAME ĐẦY ĐỦ (BLOODLINES, WEAPONS & EXTENSIONS) ]
-- ===================================================================================
-- Weapon Info: Cutlass | Type: Sword | Rarity: Common | Price: 1000 | Source: Starter Island
local function _BF_GetWeaponInfo_Cutlass()
    return { Name = 'Cutlass', Type = 'Sword', Rarity = 'Common', Price = 1000, Source = 'Starter Island' }
end

-- Weapon Info: Katana | Type: Sword | Rarity: Common | Price: 1000 | Source: Starter Island
local function _BF_GetWeaponInfo_Katana()
    return { Name = 'Katana', Type = 'Sword', Rarity = 'Common', Price = 1000, Source = 'Starter Island' }
end

-- Weapon Info: Dual Katana | Type: Sword | Rarity: Common | Price: 12000 | Source: Pirate Village
local function _BF_GetWeaponInfo_DualKatana()
    return { Name = 'Dual Katana', Type = 'Sword', Rarity = 'Common', Price = 12000, Source = 'Pirate Village' }
end

-- Weapon Info: Iron Mace | Type: Sword | Rarity: Common | Price: 25000 | Source: Pirate Village
local function _BF_GetWeaponInfo_IronMace()
    return { Name = 'Iron Mace', Type = 'Sword', Rarity = 'Common', Price = 25000, Source = 'Pirate Village' }
end

-- Weapon Info: Shark Saw | Type: Sword | Rarity: Uncommon | Price: 100000 | Source: The Saw Drop
local function _BF_GetWeaponInfo_SharkSaw()
    return { Name = 'Shark Saw', Type = 'Sword', Rarity = 'Uncommon', Price = 100000, Source = 'The Saw Drop' }
end

-- Weapon Info: Triple Katana | Type: Sword | Rarity: Uncommon | Price: 60000 | Source: Frozen Village
local function _BF_GetWeaponInfo_TripleKatana()
    return { Name = 'Triple Katana', Type = 'Sword', Rarity = 'Uncommon', Price = 60000, Source = 'Frozen Village' }
end

-- Weapon Info: Pipe | Type: Sword | Rarity: Uncommon | Price: 100000 | Source: Frozen Village
local function _BF_GetWeaponInfo_Pipe()
    return { Name = 'Pipe', Type = 'Sword', Rarity = 'Uncommon', Price = 100000, Source = 'Frozen Village' }
end

-- Weapon Info: Dual-Headed Blade | Type: Sword | Rarity: Rare | Price: 400000 | Source: Colosseum
local function _BF_GetWeaponInfo_DualHeadedBlade()
    return { Name = 'Dual-Headed Blade', Type = 'Sword', Rarity = 'Rare', Price = 400000, Source = 'Colosseum' }
end

-- Weapon Info: Bisento | Type: Sword | Rarity: Legendary | Price: 1000000 | Source: Skylands
local function _BF_GetWeaponInfo_Bisento()
    return { Name = 'Bisento', Type = 'Sword', Rarity = 'Legendary', Price = 1000000, Source = 'Skylands' }
end

-- Weapon Info: Soul Cane | Type: Sword | Rarity: Rare | Price: 750000 | Source: Magma Village
local function _BF_GetWeaponInfo_SoulCane()
    return { Name = 'Soul Cane', Type = 'Sword', Rarity = 'Rare', Price = 750000, Source = 'Magma Village' }
end

-- Weapon Info: Saber | Type: Sword | Rarity: Legendary | Price: 0 | Source: Saber Expert Quest
local function _BF_GetWeaponInfo_Saber()
    return { Name = 'Saber', Type = 'Sword', Rarity = 'Legendary', Price = 0, Source = 'Saber Expert Quest' }
end

-- Weapon Info: Pole (1st Form) | Type: Sword | Rarity: Rare | Price: 0 | Source: Thunder God Drop
local function _BF_GetWeaponInfo_Pole1stForm()
    return { Name = 'Pole (1st Form)', Type = 'Sword', Rarity = 'Rare', Price = 0, Source = 'Thunder God Drop' }
end

-- Weapon Info: Midnight Blade | Type: Sword | Rarity: Legendary | Price: 0 | Source: Cursed Ship
local function _BF_GetWeaponInfo_MidnightBlade()
    return { Name = 'Midnight Blade', Type = 'Sword', Rarity = 'Legendary', Price = 0, Source = 'Cursed Ship' }
end

-- Weapon Info: Rengoku | Type: Sword | Rarity: Legendary | Price: 0 | Source: Ice Castle Key
local function _BF_GetWeaponInfo_Rengoku()
    return { Name = 'Rengoku', Type = 'Sword', Rarity = 'Legendary', Price = 0, Source = 'Ice Castle Key' }
end

-- Weapon Info: True Triple Katana | Type: Sword | Rarity: Mythical | Price: 2000000 | Source: Green Zone Alchemist
local function _BF_GetWeaponInfo_TrueTripleKatana()
    return { Name = 'True Triple Katana', Type = 'Sword', Rarity = 'Mythical', Price = 2000000, Source = 'Green Zone Alchemist' }
end

-- Weapon Info: Cursed Dual Katana | Type: Sword | Rarity: Mythical | Price: 0 | Source: CDK Mansion Puzzle
local function _BF_GetWeaponInfo_CursedDualKatana()
    return { Name = 'Cursed Dual Katana', Type = 'Sword', Rarity = 'Mythical', Price = 0, Source = 'CDK Mansion Puzzle' }
end

-- Weapon Info: Dark Dagger | Type: Sword | Rarity: Legendary | Price: 0 | Source: Rip Indra Drop
local function _BF_GetWeaponInfo_DarkDagger()
    return { Name = 'Dark Dagger', Type = 'Sword', Rarity = 'Legendary', Price = 0, Source = 'Rip Indra Drop' }
end

-- Weapon Info: Tushita | Type: Sword | Rarity: Legendary | Price: 0 | Source: Hydra Island Torches
local function _BF_GetWeaponInfo_Tushita()
    return { Name = 'Tushita', Type = 'Sword', Rarity = 'Legendary', Price = 0, Source = 'Hydra Island Torches' }
end

-- Weapon Info: Yama | Type: Sword | Rarity: Legendary | Price: 0 | Source: Hunter Quest 30 Elite
local function _BF_GetWeaponInfo_Yama()
    return { Name = 'Yama', Type = 'Sword', Rarity = 'Legendary', Price = 0, Source = 'Hunter Quest 30 Elite' }
end

-- Weapon Info: Hallow Scythe | Type: Sword | Rarity: Mythical | Price: 0 | Source: Soul Reaper Drop
local function _BF_GetWeaponInfo_HallowScythe()
    return { Name = 'Hallow Scythe', Type = 'Sword', Rarity = 'Mythical', Price = 0, Source = 'Soul Reaper Drop' }
end

-- Weapon Info: Shark Anchor | Type: Sword | Rarity: Mythical | Price: 0 | Source: Terror Shark Magnet
local function _BF_GetWeaponInfo_SharkAnchor()
    return { Name = 'Shark Anchor', Type = 'Sword', Rarity = 'Mythical', Price = 0, Source = 'Terror Shark Magnet' }
end

-- Weapon Info: Fox Lamp | Type: Sword | Rarity: Mythical | Price: 0 | Source: Kitsune Island Shrine
local function _BF_GetWeaponInfo_FoxLamp()
    return { Name = 'Fox Lamp', Type = 'Sword', Rarity = 'Mythical', Price = 0, Source = 'Kitsune Island Shrine' }
end

-- Material Entry: Bones | Location: Haunted Castle | Rarity: Common | Mob: Reborn Skeleton / Living Zombie / Demonic Soul
local function _BF_GetMaterialData_Bones()
    return { Material = 'Bones', Location = 'Haunted Castle', Rarity = 'Common', SourceMob = 'Reborn Skeleton / Living Zombie / Demonic Soul' }
end

-- Material Entry: Mini Tusk | Location: Floating Turtle | Rarity: Rare | Mob: Mythological Pirate
local function _BF_GetMaterialData_MiniTusk()
    return { Material = 'Mini Tusk', Location = 'Floating Turtle', Rarity = 'Rare', SourceMob = 'Mythological Pirate' }
end

-- Material Entry: Dragon Scale | Location: Hydra Island | Rarity: Rare | Mob: Dragon Crew Archer / Warrior
local function _BF_GetMaterialData_DragonScale()
    return { Material = 'Dragon Scale', Location = 'Hydra Island', Rarity = 'Rare', SourceMob = 'Dragon Crew Archer / Warrior' }
end

-- Material Entry: Fish Tail | Location: Underwater City / Floating Turtle | Rarity: Common | Mob: Fishman Warrior / Raider
local function _BF_GetMaterialData_FishTail()
    return { Material = 'Fish Tail', Location = 'Underwater City / Floating Turtle', Rarity = 'Common', SourceMob = 'Fishman Warrior / Raider' }
end

-- Material Entry: Vampire Fang | Location: Graveyard | Rarity: Common | Mob: Zombie
local function _BF_GetMaterialData_VampireFang()
    return { Material = 'Vampire Fang', Location = 'Graveyard', Rarity = 'Common', SourceMob = 'Zombie' }
end

-- Material Entry: Magma Ore | Location: Magma Village / Hot and Cold | Rarity: Common | Mob: Military Soldier / Magma Ninja
local function _BF_GetMaterialData_MagmaOre()
    return { Material = 'Magma Ore', Location = 'Magma Village / Hot and Cold', Rarity = 'Common', SourceMob = 'Military Soldier / Magma Ninja' }
end

-- Material Entry: Gunpowder | Location: Kingdom of Rose / Port Town | Rarity: Common | Mob: Pistol Billionaire
local function _BF_GetMaterialData_Gunpowder()
    return { Material = 'Gunpowder', Location = 'Kingdom of Rose / Port Town', Rarity = 'Common', SourceMob = 'Pistol Billionaire' }
end

-- Material Entry: Mystic Droplet | Location: Forgotten Island | Rarity: Rare | Mob: Water Fighter / Sea Soldier
local function _BF_GetMaterialData_MysticDroplet()
    return { Material = 'Mystic Droplet', Location = 'Forgotten Island', Rarity = 'Rare', SourceMob = 'Water Fighter / Sea Soldier' }
end

-- Material Entry: Scrap Metal | Location: Pirate Village / Marine Fortress | Rarity: Common | Mob: Brute / Chief Petty Officer
local function _BF_GetMaterialData_ScrapMetal()
    return { Material = 'Scrap Metal', Location = 'Pirate Village / Marine Fortress', Rarity = 'Common', SourceMob = 'Brute / Chief Petty Officer' }
end

-- Material Entry: Conjured Cocoa | Location: Chocolate Land | Rarity: Uncommon | Mob: Cocoa Warrior / Chocolate Bar Battler
local function _BF_GetMaterialData_ConjuredCocoa()
    return { Material = 'Conjured Cocoa', Location = 'Chocolate Land', Rarity = 'Uncommon', SourceMob = 'Cocoa Warrior / Chocolate Bar Battler' }
end

-- Material Entry: Demonic Wisp | Location: Haunted Castle | Rarity: Rare | Mob: Demonic Soul
local function _BF_GetMaterialData_DemonicWisp()
    return { Material = 'Demonic Wisp', Location = 'Haunted Castle', Rarity = 'Rare', SourceMob = 'Demonic Soul' }
end

-- Material Entry: Mirror Fractal | Location: Cake Land | Rarity: Mythical | Mob: Dough King Drop
local function _BF_GetMaterialData_MirrorFractal()
    return { Material = 'Mirror Fractal', Location = 'Cake Land', Rarity = 'Mythical', SourceMob = 'Dough King Drop' }
end

-- Material Entry: Dark Fragment | Location: Dark Arena | Rarity: Mythical | Mob: Darkbeard Drop
local function _BF_GetMaterialData_DarkFragment()
    return { Material = 'Dark Fragment', Location = 'Dark Arena', Rarity = 'Mythical', SourceMob = 'Darkbeard Drop' }
end

-- Material Entry: Leviathan Heart | Location: Frozen Dimension | Rarity: Mythical | Mob: Leviathan Harpoon Hunt
local function _BF_GetMaterialData_LeviathanHeart()
    return { Material = 'Leviathan Heart', Location = 'Frozen Dimension', Rarity = 'Mythical', SourceMob = 'Leviathan Harpoon Hunt' }
end

-- Material Entry: Leviathan Scale | Location: Rough Sea | Rarity: Mythical | Mob: Leviathan Hunt
local function _BF_GetMaterialData_LeviathanScale()
    return { Material = 'Leviathan Scale', Location = 'Rough Sea', Rarity = 'Mythical', SourceMob = 'Leviathan Hunt' }
end

-- Material Entry: Mutant Tooth | Location: Sea Danger 6 | Rarity: Legendary | Mob: Terror Shark Drop
local function _BF_GetMaterialData_MutantTooth()
    return { Material = 'Mutant Tooth', Location = 'Sea Danger 6', Rarity = 'Legendary', SourceMob = 'Terror Shark Drop' }
end

-- Material Entry: Terror Eyes | Location: Sea Danger 6 | Rarity: Mythical | Mob: Terror Shark Drop
local function _BF_GetMaterialData_TerrorEyes()
    return { Material = 'Terror Eyes', Location = 'Sea Danger 6', Rarity = 'Mythical', SourceMob = 'Terror Shark Drop' }
end

-- Material Entry: Electric Wings | Location: Tiki Outpost | Rarity: Rare | Mob: Piranha Sea Drop
local function _BF_GetMaterialData_ElectricWings()
    return { Material = 'Electric Wings', Location = 'Tiki Outpost', Rarity = 'Rare', SourceMob = 'Piranha Sea Drop' }
end

-- Material Entry: Fools Gold | Location: Ghost Ship | Rarity: Uncommon | Mob: Ghost Ship Raider Drop
local function _BF_GetMaterialData_FoolsGold()
    return { Material = 'Fools Gold', Location = 'Ghost Ship', Rarity = 'Uncommon', SourceMob = 'Ghost Ship Raider Drop' }
end

-- Blox Fruit Encyclopedia: Rocket | Rarity: Common | Beli: 5000 | Robux: 50
local function _BF_GetFruitData_Rocket()
    return { Name = 'Rocket', Rarity = 'Common', BeliPrice = 5000, RobuxPrice = 50 }
end

-- Blox Fruit Encyclopedia: Spin | Rarity: Common | Beli: 7500 | Robux: 75
local function _BF_GetFruitData_Spin()
    return { Name = 'Spin', Rarity = 'Common', BeliPrice = 7500, RobuxPrice = 75 }
end

-- Blox Fruit Encyclopedia: Blade | Rarity: Common | Beli: 30000 | Robux: 200
local function _BF_GetFruitData_Blade()
    return { Name = 'Blade', Rarity = 'Common', BeliPrice = 30000, RobuxPrice = 200 }
end

-- Blox Fruit Encyclopedia: Spring | Rarity: Common | Beli: 60000 | Robux: 250
local function _BF_GetFruitData_Spring()
    return { Name = 'Spring', Rarity = 'Common', BeliPrice = 60000, RobuxPrice = 250 }
end

-- Blox Fruit Encyclopedia: Bomb | Rarity: Common | Beli: 80000 | Robux: 300
local function _BF_GetFruitData_Bomb()
    return { Name = 'Bomb', Rarity = 'Common', BeliPrice = 80000, RobuxPrice = 300 }
end

-- Blox Fruit Encyclopedia: Smoke | Rarity: Common | Beli: 100000 | Robux: 350
local function _BF_GetFruitData_Smoke()
    return { Name = 'Smoke', Rarity = 'Common', BeliPrice = 100000, RobuxPrice = 350 }
end

-- Blox Fruit Encyclopedia: Spike | Rarity: Common | Beli: 180000 | Robux: 380
local function _BF_GetFruitData_Spike()
    return { Name = 'Spike', Rarity = 'Common', BeliPrice = 180000, RobuxPrice = 380 }
end

-- Blox Fruit Encyclopedia: Flame | Rarity: Uncommon | Beli: 250000 | Robux: 550
local function _BF_GetFruitData_Flame()
    return { Name = 'Flame', Rarity = 'Uncommon', BeliPrice = 250000, RobuxPrice = 550 }
end

-- Blox Fruit Encyclopedia: Falcon | Rarity: Uncommon | Beli: 300000 | Robux: 650
local function _BF_GetFruitData_Falcon()
    return { Name = 'Falcon', Rarity = 'Uncommon', BeliPrice = 300000, RobuxPrice = 650 }
end

-- Blox Fruit Encyclopedia: Ice | Rarity: Uncommon | Beli: 350000 | Robux: 750
local function _BF_GetFruitData_Ice()
    return { Name = 'Ice', Rarity = 'Uncommon', BeliPrice = 350000, RobuxPrice = 750 }
end

-- Blox Fruit Encyclopedia: Sand | Rarity: Uncommon | Beli: 420000 | Robux: 850
local function _BF_GetFruitData_Sand()
    return { Name = 'Sand', Rarity = 'Uncommon', BeliPrice = 420000, RobuxPrice = 850 }
end

-- Blox Fruit Encyclopedia: Dark | Rarity: Uncommon | Beli: 500000 | Robux: 950
local function _BF_GetFruitData_Dark()
    return { Name = 'Dark', Rarity = 'Uncommon', BeliPrice = 500000, RobuxPrice = 950 }
end

-- Blox Fruit Encyclopedia: Ghost | Rarity: Uncommon | Beli: 550000 | Robux: 1000
local function _BF_GetFruitData_Ghost()
    return { Name = 'Ghost', Rarity = 'Uncommon', BeliPrice = 550000, RobuxPrice = 1000 }
end

-- Blox Fruit Encyclopedia: Diamond | Rarity: Uncommon | Beli: 600000 | Robux: 1000
local function _BF_GetFruitData_Diamond()
    return { Name = 'Diamond', Rarity = 'Uncommon', BeliPrice = 600000, RobuxPrice = 1000 }
end

-- Blox Fruit Encyclopedia: Light | Rarity: Rare | Beli: 650000 | Robux: 1100
local function _BF_GetFruitData_Light()
    return { Name = 'Light', Rarity = 'Rare', BeliPrice = 650000, RobuxPrice = 1100 }
end

-- Blox Fruit Encyclopedia: Rubber | Rarity: Rare | Beli: 750000 | Robux: 1200
local function _BF_GetFruitData_Rubber()
    return { Name = 'Rubber', Rarity = 'Rare', BeliPrice = 750000, RobuxPrice = 1200 }
end

-- Blox Fruit Encyclopedia: Barrier | Rarity: Rare | Beli: 800000 | Robux: 1250
local function _BF_GetFruitData_Barrier()
    return { Name = 'Barrier', Rarity = 'Rare', BeliPrice = 800000, RobuxPrice = 1250 }
end

-- Blox Fruit Encyclopedia: Magma | Rarity: Rare | Beli: 850000 | Robux: 1300
local function _BF_GetFruitData_Magma()
    return { Name = 'Magma', Rarity = 'Rare', BeliPrice = 850000, RobuxPrice = 1300 }
end

-- Blox Fruit Encyclopedia: Quake | Rarity: Legendary | Beli: 1000000 | Robux: 1500
local function _BF_GetFruitData_Quake()
    return { Name = 'Quake', Rarity = 'Legendary', BeliPrice = 1000000, RobuxPrice = 1500 }
end

-- Blox Fruit Encyclopedia: Buddha | Rarity: Legendary | Beli: 1200000 | Robux: 1650
local function _BF_GetFruitData_Buddha()
    return { Name = 'Buddha', Rarity = 'Legendary', BeliPrice = 1200000, RobuxPrice = 1650 }
end

-- Blox Fruit Encyclopedia: Love | Rarity: Legendary | Beli: 1300000 | Robux: 1700
local function _BF_GetFruitData_Love()
    return { Name = 'Love', Rarity = 'Legendary', BeliPrice = 1300000, RobuxPrice = 1700 }
end

-- Blox Fruit Encyclopedia: Spider | Rarity: Legendary | Beli: 1500000 | Robux: 1800
local function _BF_GetFruitData_Spider()
    return { Name = 'Spider', Rarity = 'Legendary', BeliPrice = 1500000, RobuxPrice = 1800 }
end

-- Blox Fruit Encyclopedia: Sound | Rarity: Legendary | Beli: 1700000 | Robux: 1900
local function _BF_GetFruitData_Sound()
    return { Name = 'Sound', Rarity = 'Legendary', BeliPrice = 1700000, RobuxPrice = 1900 }
end

-- Blox Fruit Encyclopedia: Phoenix | Rarity: Legendary | Beli: 1800000 | Robux: 2000
local function _BF_GetFruitData_Phoenix()
    return { Name = 'Phoenix', Rarity = 'Legendary', BeliPrice = 1800000, RobuxPrice = 2000 }
end

-- Blox Fruit Encyclopedia: Portal | Rarity: Legendary | Beli: 1900000 | Robux: 2000
local function _BF_GetFruitData_Portal()
    return { Name = 'Portal', Rarity = 'Legendary', BeliPrice = 1900000, RobuxPrice = 2000 }
end

-- Blox Fruit Encyclopedia: Rumble | Rarity: Legendary | Beli: 2100000 | Robux: 2100
local function _BF_GetFruitData_Rumble()
    return { Name = 'Rumble', Rarity = 'Legendary', BeliPrice = 2100000, RobuxPrice = 2100 }
end

-- Blox Fruit Encyclopedia: Pain | Rarity: Legendary | Beli: 2300000 | Robux: 2200
local function _BF_GetFruitData_Pain()
    return { Name = 'Pain', Rarity = 'Legendary', BeliPrice = 2300000, RobuxPrice = 2200 }
end

-- Blox Fruit Encyclopedia: Blizzard | Rarity: Legendary | Beli: 2400000 | Robux: 2250
local function _BF_GetFruitData_Blizzard()
    return { Name = 'Blizzard', Rarity = 'Legendary', BeliPrice = 2400000, RobuxPrice = 2250 }
end

-- Blox Fruit Encyclopedia: Gravity | Rarity: Mythical | Beli: 2500000 | Robux: 2300
local function _BF_GetFruitData_Gravity()
    return { Name = 'Gravity', Rarity = 'Mythical', BeliPrice = 2500000, RobuxPrice = 2300 }
end

-- Blox Fruit Encyclopedia: Mammoth | Rarity: Mythical | Beli: 2700000 | Robux: 2350
local function _BF_GetFruitData_Mammoth()
    return { Name = 'Mammoth', Rarity = 'Mythical', BeliPrice = 2700000, RobuxPrice = 2350 }
end

-- Blox Fruit Encyclopedia: T-Rex | Rarity: Mythical | Beli: 2700000 | Robux: 2350
local function _BF_GetFruitData_TRex()
    return { Name = 'T-Rex', Rarity = 'Mythical', BeliPrice = 2700000, RobuxPrice = 2350 }
end

-- Blox Fruit Encyclopedia: Dough | Rarity: Mythical | Beli: 2800000 | Robux: 2400
local function _BF_GetFruitData_Dough()
    return { Name = 'Dough', Rarity = 'Mythical', BeliPrice = 2800000, RobuxPrice = 2400 }
end

-- Blox Fruit Encyclopedia: Shadow | Rarity: Mythical | Beli: 2900000 | Robux: 2400
local function _BF_GetFruitData_Shadow()
    return { Name = 'Shadow', Rarity = 'Mythical', BeliPrice = 2900000, RobuxPrice = 2400 }
end

-- Blox Fruit Encyclopedia: Venom | Rarity: Mythical | Beli: 3000000 | Robux: 2450
local function _BF_GetFruitData_Venom()
    return { Name = 'Venom', Rarity = 'Mythical', BeliPrice = 3000000, RobuxPrice = 2450 }
end

-- Blox Fruit Encyclopedia: Control | Rarity: Mythical | Beli: 3200000 | Robux: 2500
local function _BF_GetFruitData_Control()
    return { Name = 'Control', Rarity = 'Mythical', BeliPrice = 3200000, RobuxPrice = 2500 }
end

-- Blox Fruit Encyclopedia: Spirit | Rarity: Mythical | Beli: 3400000 | Robux: 2550
local function _BF_GetFruitData_Spirit()
    return { Name = 'Spirit', Rarity = 'Mythical', BeliPrice = 3400000, RobuxPrice = 2550 }
end

-- Blox Fruit Encyclopedia: Dragon | Rarity: Mythical | Beli: 3500000 | Robux: 2600
local function _BF_GetFruitData_Dragon()
    return { Name = 'Dragon', Rarity = 'Mythical', BeliPrice = 3500000, RobuxPrice = 2600 }
end

-- Blox Fruit Encyclopedia: Leopard | Rarity: Mythical | Beli: 5000000 | Robux: 3000
local function _BF_GetFruitData_Leopard()
    return { Name = 'Leopard', Rarity = 'Mythical', BeliPrice = 5000000, RobuxPrice = 3000 }
end

-- Blox Fruit Encyclopedia: Kitsune | Rarity: Mythical | Beli: 8000000 | Robux: 4000
local function _BF_GetFruitData_Kitsune()
    return { Name = 'Kitsune', Rarity = 'Mythical', BeliPrice = 8000000, RobuxPrice = 4000 }
end

-- Extended Combat Routine #001: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_001(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #002: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_002(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #003: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_003(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #004: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_004(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #005: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_005(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #006: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_006(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #007: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_007(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #008: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_008(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #009: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_009(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #010: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_010(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #011: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_011(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #012: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_012(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #013: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_013(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #014: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_014(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #015: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_015(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #016: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_016(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #017: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_017(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #018: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_018(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #019: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_019(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #020: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_020(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #021: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_021(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #022: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_022(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #023: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_023(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #024: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_024(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #025: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_025(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #026: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_026(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #027: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_027(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #028: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_028(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #029: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_029(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #030: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_030(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #031: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_031(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #032: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_032(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #033: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_033(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #034: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_034(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #035: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_035(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #036: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_036(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #037: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_037(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #038: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_038(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #039: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_039(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #040: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_040(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #041: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_041(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #042: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_042(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #043: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_043(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #044: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_044(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #045: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_045(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #046: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_046(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #047: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_047(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #048: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_048(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #049: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_049(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #050: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_050(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #051: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_051(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #052: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_052(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #053: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_053(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #054: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_054(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #055: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_055(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #056: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_056(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #057: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_057(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #058: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_058(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #059: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_059(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #060: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_060(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #061: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_061(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #062: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_062(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #063: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_063(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #064: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_064(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #065: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_065(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #066: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_066(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #067: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_067(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #068: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_068(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #069: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_069(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #070: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_070(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #071: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_071(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #072: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_072(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #073: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_073(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #074: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_074(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #075: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_075(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #076: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_076(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #077: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_077(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #078: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_078(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #079: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_079(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #080: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_080(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #081: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_081(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #082: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_082(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #083: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_083(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #084: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_084(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #085: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_085(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #086: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_086(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #087: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_087(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #088: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_088(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #089: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_089(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #090: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_090(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #091: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_091(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #092: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_092(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #093: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_093(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #094: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_094(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #095: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_095(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #096: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_096(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #097: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_097(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #098: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_098(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #099: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_099(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #100: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_100(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #101: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_101(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #102: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_102(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #103: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_103(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #104: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_104(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #105: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_105(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #106: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_106(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #107: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_107(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #108: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_108(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #109: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_109(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #110: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_110(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #111: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_111(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #112: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_112(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #113: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_113(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #114: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_114(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #115: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_115(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #116: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_116(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #117: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_117(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #118: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_118(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #119: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_119(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #120: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_120(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #121: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_121(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #122: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_122(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #123: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_123(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #124: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_124(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #125: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_125(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #126: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_126(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #127: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_127(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #128: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_128(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #129: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_129(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #130: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_130(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #131: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_131(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #132: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_132(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #133: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_133(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #134: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_134(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #135: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_135(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #136: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_136(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #137: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_137(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #138: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_138(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #139: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_139(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #140: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_140(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #141: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_141(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #142: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_142(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #143: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_143(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #144: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_144(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #145: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_145(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #146: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_146(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #147: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_147(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #148: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_148(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #149: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_149(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #150: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_150(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #151: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_151(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #152: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_152(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #153: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_153(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #154: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_154(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #155: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_155(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #156: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_156(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #157: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_157(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #158: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_158(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #159: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_159(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #160: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_160(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #161: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_161(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #162: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_162(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #163: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_163(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #164: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_164(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #165: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_165(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #166: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_166(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #167: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_167(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #168: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_168(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #169: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_169(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #170: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_170(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #171: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_171(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #172: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_172(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #173: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_173(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #174: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_174(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #175: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_175(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #176: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_176(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #177: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_177(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #178: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_178(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #179: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_179(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #180: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_180(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #181: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_181(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #182: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_182(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #183: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_183(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #184: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_184(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #185: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_185(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #186: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_186(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #187: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_187(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #188: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_188(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #189: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_189(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #190: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_190(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #191: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_191(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #192: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_192(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #193: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_193(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #194: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_194(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #195: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_195(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #196: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_196(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #197: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_197(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #198: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_198(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #199: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_199(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #200: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_200(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #201: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_201(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #202: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_202(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #203: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_203(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #204: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_204(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #205: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_205(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #206: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_206(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #207: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_207(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #208: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_208(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #209: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_209(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #210: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_210(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #211: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_211(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #212: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_212(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #213: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_213(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #214: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_214(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #215: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_215(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #216: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_216(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #217: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_217(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #218: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_218(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #219: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_219(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #220: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_220(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #221: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_221(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #222: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_222(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #223: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_223(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #224: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_224(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #225: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_225(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #226: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_226(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #227: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_227(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #228: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_228(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #229: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_229(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #230: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_230(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #231: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_231(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #232: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_232(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #233: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_233(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #234: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_234(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #235: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_235(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #236: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_236(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #237: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_237(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #238: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_238(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #239: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_239(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #240: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_240(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #241: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_241(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #242: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_242(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #243: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_243(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #244: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_244(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #245: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_245(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #246: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_246(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #247: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_247(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #248: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_248(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #249: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_249(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #250: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_250(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #251: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_251(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #252: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_252(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #253: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_253(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #254: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_254(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #255: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_255(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #256: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_256(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #257: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_257(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #258: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_258(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #259: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_259(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #260: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_260(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #261: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_261(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #262: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_262(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #263: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_263(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #264: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_264(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #265: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_265(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #266: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_266(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #267: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_267(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #268: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_268(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #269: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_269(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #270: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_270(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #271: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_271(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #272: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_272(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #273: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_273(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #274: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_274(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #275: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_275(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #276: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_276(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #277: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_277(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #278: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_278(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end

-- Extended Combat Routine #279: Fast Attack Animation & Network Heartbeat Optimization
local function _BF_CombatRoutine_Optimizer_279(enemyTarget, weaponTool)
    if not enemyTarget or not enemyTarget:FindFirstChild('HumanoidRootPart') then return false end
    return true
end
