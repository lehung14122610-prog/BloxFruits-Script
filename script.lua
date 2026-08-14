--[[
    ===================================================================================
    ★ BLOX FRUITS ULTIMATE HUB V5.5 (SUPER MOBILE & DELTAX COMPATIBLE) ★
    Tương thích 100% với tất cả Trình thực thi PC & Mobile:
    - Mobile: Delta, DeltaX, Arceus X, Codex, Fluxus Mobile, Hydrogen, VegaX
    - PC: Solara, Wave, Xeno, Celery, Swift, Synapse Z
    ===================================================================================
--]]

-- ===================================================================================
-- [ 1. SAFE SERVICES & EXECUTOR ENVIRONMENT PROTECTION ]
-- ===================================================================================
local getgenv = getgenv or function() return _G end
local cloneref = cloneref or function(obj) return obj end

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

-- Safe GUI Container Resolver (Tương thích tuyệt đối DeltaX / gethui / CoreGui / PlayerGui)
local function GetUIContainer()
    local container = nil
    pcall(function()
        if gethui then
            container = gethui()
        elseif get_hidden_gui then
            container = get_hidden_gui()
        else
            container = game:GetService("CoreGui")
        end
    end)
    if container then return container end
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- Destroy Previous UI Instance (Khôi phục nếu chạy lại script)
local parentContainer = GetUIContainer()
if parentContainer:FindFirstChild("BF_Ultimate_Hub_Gui") then
    parentContainer.BF_Ultimate_Hub_Gui:Destroy()
end

-- ===================================================================================
-- [ 2. GLOBAL HUB CONFIGURATION & STATE MANAGER ]
-- ===================================================================================
getgenv().BF_Hub_Config = {
    -- Auto Farm Engine
    AutoFarmLevel = false,
    AutoFarmSelectedMob = false,
    AutoFarmBoss = false,
    AutoFarmChest = false,
    
    -- Farm Settings
    SelectedMob = "",
    SelectedBoss = "",
    SelectedWeapon = "Melee", -- Melee, Sword, Blox Fruit, Gun
    FarmHeight = 9,
    FarmDistance = 2,
    FastAttack = true,
    BringMobs = true,
    BringRadius = 350,
    
    -- Skill Auto Spammer
    AutoSkillZ = false,
    AutoSkillX = false,
    AutoSkillC = false,
    AutoSkillV = false,
    SkillDelay = 0.5,
    
    -- Flight & Movement
    Fly = false,
    FlySpeed = 70,
    WalkSpeedToggle = false,
    WalkSpeed = 60,
    JumpPowerToggle = false,
    JumpPower = 120,
    Noclip = false,
    WaterWalk = false,
    InfiniteJump = false,
    TweenSpeed = 260,
    SelectedIsland = "Starter Island (Sea 1)",
    
    -- ESP Visuals
    ESP_Player = false,
    ESP_Mobs = false,
    ESP_Chests = false,
    ESP_Fruits = false,
    ESP_Flowers = false,
    ESP_Color_Player = Color3.fromRGB(0, 255, 150),
    ESP_Color_Mob = Color3.fromRGB(255, 100, 100),
    ESP_Color_Chest = Color3.fromRGB(255, 215, 0),
    ESP_Color_Fruit = Color3.fromRGB(255, 50, 50),
    ESP_Color_Flower = Color3.fromRGB(255, 105, 180),
    
    -- Blox Fruits Services
    AutoStat = false,
    StatTarget = "Melee", -- Melee, Defense, Sword, Gun, Blox Fruit
    StatPointAmount = 3,
    AutoHaki = true,
    AutoCollectFruit = false,
    AutoStoreFruit = true,
    AutoCollectFlowers = false,
    
    -- Optimization & Fix Lag
    FixLag = false,
    BlackScreen = false,
    FullBright = false,
    ClearFog = false,
    
    -- System Controls
    AntiAFK = true
}

local Config = getgenv().BF_Hub_Config

-- Notification Engine
local function Notify(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title or "BF Ultimate Hub",
            Text = text or "",
            Duration = duration or 3
        })
    end)
end

-- ===================================================================================
-- [ 3. INSTANT UI ENGINE (HIỂN THỊ TỨC THÌ TRÊN DELTAX & MOBILE) ]
-- ===================================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BF_Ultimate_Hub_Gui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = parentContainer

-- Nút Icon Nổi Mobile Toggle (Đặc biệt cho DeltaX / Delta / Cảm ứng Điện thoại)
local MobileFloatingBtn = Instance.new("TextButton")
MobileFloatingBtn.Name = "MobileToggleIcon"
MobileFloatingBtn.Size = UDim2.new(0, 52, 0, 52)
MobileFloatingBtn.Position = UDim2.new(0, 15, 0.25, 0)
MobileFloatingBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 38)
MobileFloatingBtn.Text = "🔥"
MobileFloatingBtn.TextSize = 24
MobileFloatingBtn.Active = true
MobileFloatingBtn.Draggable = true
MobileFloatingBtn.Parent = ScreenGui

local MobileBtnCorner = Instance.new("UICorner")
MobileBtnCorner.CornerRadius = UDim.new(1, 0)
MobileBtnCorner.Parent = MobileFloatingBtn

local MobileBtnStroke = Instance.new("UIStroke")
MobileBtnStroke.Color = Color3.fromRGB(0, 210, 255)
MobileBtnStroke.Thickness = 2
MobileBtnStroke.Parent = MobileFloatingBtn

-- Main Frame UI Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 680, 0, 420)
MainFrame.Position = UDim2.new(0.5, -340, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true -- Tự động bật giao diện ngay khi chạy!
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(35, 40, 55)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

MobileFloatingBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.Size = UDim2.new(1, -70, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "⚡ BLOX FRUITS ULTIMATE HUB V5.5 (DELTAX FIXED)"
TitleText.TextColor3 = Color3.fromRGB(0, 220, 255)
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextSize = 17
TitleText.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -35, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(230, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 14

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Sidebar Tabs Container
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SideLayout = Instance.new("UIListLayout")
SideLayout.Parent = Sidebar
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Padding = UDim.new(0, 4)

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -165, 1, -45)
ContentArea.Position = UDim2.new(0, 165, 0, 45)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local Pages = {}

local function CreateTab(name)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -10, 0, 36)
    tabBtn.Position = UDim2.new(0, 5, 0, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 35)
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabBtn.Font = Enum.Font.SourceSansSemibold
    tabBtn.TextSize = 14
    tabBtn.Parent = Sidebar
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabBtn
    
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -10, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 4
    page.Visible = false
    page.Parent = ContentArea
    
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Parent = page
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 8)
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        page.Visible = true
    end)
    
    table.insert(Pages, page)
    if #Pages == 1 then page.Visible = true end
    return page
end

-- UI Component Helpers
local function AddToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(25, 28, 38)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -65, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 48, 0, 24)
    btn.Position = UDim2.new(1, -55, 0.5, -12)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 75)
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 75)
        btn.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

local function AddButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(0, 130, 230)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

local function AddSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 46)
    frame.BackgroundColor3 = Color3.fromRGB(25, 28, 38)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 0, 20)
    lbl.Position = UDim2.new(0, 10, 0, 2)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. tostring(default)
    lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame
    
    local sliderBg = Instance.new("TextButton")
    sliderBg.Size = UDim2.new(1, -20, 0, 10)
    sliderBg.Position = UDim2.new(0, 10, 0, 26)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 55, 75)
    sliderBg.Text = ""
    sliderBg.Parent = frame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 210, 255)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg
    
    local dragging = false
    local function UpdateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        lbl.Text = text .. ": " .. tostring(val)
        callback(val)
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
    frame.Size = UDim2.new(1, -10, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(25, 28, 38)
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.4, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.55, -10, 0, 26)
    btn.Position = UDim2.new(0.45, 0, 0.5, -13)
    btn.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
    btn.Text = options[1] or "Select"
    btn.TextColor3 = Color3.fromRGB(0, 210, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.Parent = frame
    
    local currentIndex = 1
    btn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex + 1
        if currentIndex > #options then currentIndex = 1 end
        btn.Text = options[currentIndex]
        callback(options[currentIndex])
    end)
end

-- Construct UI Tabs
local TabFarm = CreateTab("🌾 Auto Farm")
local TabCombat = CreateTab("⚔️ Combat")
local TabFly = CreateTab("✈️ Bay / Fly")
local TabESP = CreateTab("👁️ ESP Visuals")
local TabExtra = CreateTab("🍎 Stats & Fruit")
local TabLag = CreateTab("⚡ Fix Lag")
local TabSystem = CreateTab("⚙️ System")

-- ===================================================================================
-- [ 4. DATABASES (ISLANDS, QUESTS, MOBS) ]
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
    ["Skylands (Sea 1)"] = Vector3.new(-4832, 717, -2623),
    ["Prison (Sea 1)"] = Vector3.new(4854, 5, 739),
    ["Colosseum (Sea 1)"] = Vector3.new(-1440, 7, -3015),
    ["Magma Village (Sea 1)"] = Vector3.new(-5242, 8, 8527),
    ["Underwater City (Sea 1)"] = Vector3.new(3864, 5, -1926),
    ["Fountain City (Sea 1)"] = Vector3.new(5127, 59, 4105),

    -- SEA 2
    ["Cafe / Rose Town (Sea 2)"] = Vector3.new(-386, 73, 298),
    ["Green Zone (Sea 2)"] = Vector3.new(-2384, 72, -3154),
    ["Graveyard (Sea 2)"] = Vector3.new(-5445, 48, -748),
    ["Snow Mountain (Sea 2)"] = Vector3.new(623, 401, -5374),
    ["Hot and Cold (Sea 2)"] = Vector3.new(-502, 15, -5334),
    ["Cursed Ship (Sea 2)"] = Vector3.new(923, 125, 32852),
    ["Ice Castle (Sea 2)"] = Vector3.new(6148, 294, -6742),
    ["Forgotten Island (Sea 2)"] = Vector3.new(-3055, 239, -10145),

    -- SEA 3
    ["Port Town (Sea 3)"] = Vector3.new(-290, 6, 5343),
    ["Hydra Island (Sea 3)"] = Vector3.new(5750, 610, -282),
    ["Great Tree (Sea 3)"] = Vector3.new(2284, 25, -6755),
    ["Floating Turtle (Sea 3)"] = Vector3.new(-13274, 332, -7926),
    ["Castle on the Sea (Sea 3)"] = Vector3.new(-5056, 314, -3161),
    ["Haunted Castle (Sea 3)"] = Vector3.new(-9514, 142, 5535),
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

    -- SEA 2 & 3
    {MinLvl = 700, MaxLvl = 724, Mob = "Raider", QuestName = "Area1Quest", QuestLvl = 1, NpcCFrame = CFrame.new(-427, 73, 1836), MobCFrame = CFrame.new(-740, 73, 2400)},
    {MinLvl = 725, MaxLvl = 774, Mob = "Mercenary", QuestName = "Area1Quest", QuestLvl = 2, NpcCFrame = CFrame.new(-427, 73, 1836), MobCFrame = CFrame.new(-920, 73, 1600)},
    {MinLvl = 1500, MaxLvl = 1524, Mob = "Pirate Millionaire", QuestName = "PortTownQuest", QuestLvl = 1, NpcCFrame = CFrame.new(-290, 6, 5343), MobCFrame = CFrame.new(-380, 6, 5550)},
    {MinLvl = 2450, MaxLvl = 2550, Mob = "Isle Outlaw", QuestName = "TikiQuest1", QuestLvl = 1, NpcCFrame = CFrame.new(-16235, 9, 413), MobCFrame = CFrame.new(-16500, 9, 700)}
}

-- ===================================================================================
-- [ 5. HELPER FUNCTIONS & MOVEMENT ENGINES ]
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
    
    if distance < 4 then
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
    
    if dist > 750 then
        local highPos1 = Vector3.new(currentPos.X, 950, currentPos.Z)
        local highPos2 = Vector3.new(targetPos.X, 950, targetPos.Z)
        
        TweenTo(CFrame.new(highPos1)):Completed():Wait()
        TweenTo(CFrame.new(highPos2)):Completed():Wait()
        TweenTo(targetCFrame):Completed():Wait()
    else
        TweenTo(targetCFrame)
    end
end

-- Noclip Engine
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

-- Water Walk Engine
local WaterPlatform = Instance.new("Part")
WaterPlatform.Name = "BF_Hub_WaterPlatform"
WaterPlatform.Size = Vector3.new(600, 1, 600)
WaterPlatform.Anchored = true
WaterPlatform.Transparency = 1
WaterPlatform.Parent = Workspace

RunService.RenderStepped:Connect(function()
    if Config.WaterWalk then
        local root = GetRoot()
        if root then
            if root.Position.Y <= 25 then
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

-- Infinite Jump Engine
UserInputService.JumpRequest:Connect(function()
    if Config.InfiniteJump then
        local hum = GetHumanoid()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- WalkSpeed & JumpPower Enforcers
RunService.RenderStepped:Connect(function()
    local hum = GetHumanoid()
    if hum then
        if Config.WalkSpeedToggle then
            hum.WalkSpeed = Config.WalkSpeed
        end
        if Config.JumpPowerToggle then
            hum.UseJumpPower = true
            hum.JumpPower = Config.JumpPower
        end
    end
end)

-- Free Fly Engine V2 (BodyVelocity + WASD + Mobile Touch Joystick)
local flyBodyVel, flyBodyGyro = nil, nil
local flyKeys = {W = false, A = false, S = false, D = false, E = false, Q = false}

local function StartFly()
    local root = GetRoot()
    if not root then return end
    
    if flyBodyVel then flyBodyVel:Destroy() end
    if flyBodyGyro then flyBodyGyro:Destroy() end
    
    flyBodyVel = Instance.new("BodyVelocity")
    flyBodyVel.MaxForce = Vector3.new(1, 1, 1) * 10e6
    flyBodyVel.Velocity = Vector3.zero
    flyBodyVel.Parent = root
    
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 10e6
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

-- ===================================================================================
-- [ 6. AUTO FARM & QUEST ENGINE ]
-- ===================================================================================

local function GetPlayerLevel()
    pcall(function()
        return LocalPlayer.Data.Level.Value
    end)
    return 1
end

local function GetQuestForCurrentLevel()
    local level = GetPlayerLevel()
    for _, q in ipairs(QuestData) do
        if level >= q.MinLvl and level <= q.MaxLvl then
            return q
        end
    end
    return QuestData[1]
end

local function EquipSelectedWeapon()
    local char = GetCharacter()
    if not char then return end
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
                tool.Parent = char
                return tool
            end
        end
    end
end

local function FastAttackHit()
    if not Config.FastAttack then return end
    pcall(function()
        VirtualUser:Button1Down(Vector2.new(0, 0), Camera.CFrame)
        VirtualUser:Button1Up(Vector2.new(0, 0), Camera.CFrame)
    end)
end

local function BringMobsV2(targetCFrame)
    if not Config.BringMobs then return end
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return end
    
    for _, mob in pairs(enemies:GetChildren()) do
        if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            local dist = (targetCFrame.Position - mob.HumanoidRootPart.Position).Magnitude
            if dist <= Config.BringRadius then
                mob.HumanoidRootPart.CFrame = targetCFrame * CFrame.new(0, 0, -2)
                mob.HumanoidRootPart.CanCollide = false
                mob.HumanoidRootPart.Velocity = Vector3.zero
                mob.Humanoid.WalkSpeed = 0
            end
        end
    end
end

local function HasQuest()
    local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
    if questGui and questGui:FindFirstChild("Quest") and questGui.Quest.Visible then
        return true
    end
    return false
end

local function TakeQuest(questData)
    if not questData then return end
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questData.QuestName, questData.QuestLvl)
    end)
end

-- MAIN FARM LOOP
task.spawn(function()
    while task.wait(0.1) do
        local root = GetRoot()
        if root then
            if Config.AutoFarmLevel then
                local quest = GetQuestForCurrentLevel()
                if quest then
                    if not HasQuest() then
                        TweenTo(quest.NpcCFrame)
                        if (root.Position - quest.NpcCFrame.Position).Magnitude < 15 then
                            TakeQuest(quest)
                            task.wait(0.5)
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
                            local farmCF = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, Config.FarmHeight, Config.FarmDistance) * CFrame.Angles(math.rad(-90), 0, 0)
                            TweenTo(farmCF, 300)
                            BringMobsV2(targetMob.HumanoidRootPart.CFrame)
                            EquipSelectedWeapon()
                            FastAttackHit()
                        else
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
                    local farmCF = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, Config.FarmHeight, Config.FarmDistance) * CFrame.Angles(math.rad(-90), 0, 0)
                    TweenTo(farmCF, 300)
                    BringMobsV2(targetMob.HumanoidRootPart.CFrame)
                    EquipSelectedWeapon()
                    FastAttackHit()
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
                    local farmCF = targetBoss.HumanoidRootPart.CFrame * CFrame.new(0, Config.FarmHeight, Config.FarmDistance) * CFrame.Angles(math.rad(-90), 0, 0)
                    TweenTo(farmCF, 300)
                    BringMobsV2(targetBoss.HumanoidRootPart.CFrame)
                    EquipSelectedWeapon()
                    FastAttackHit()
                end
            elseif Config.AutoFarmChest then
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v.Name:find("Chest") and v:IsA("BasePart") then
                        TweenTo(v.CFrame * CFrame.new(0, 3, 0), 350)
                        task.wait(0.3)
                    end
                end
            end
        end
    end
end)

-- ===================================================================================
-- [ 7. ESP VISUAL ENGINE ]
-- ===================================================================================

local ESPFolder = Instance.new("Folder", Workspace)
ESPFolder.Name = "BF_Hub_ESP_Folder"

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
    lbl.Font = Enum.Font.SourceSansBold
    lbl.Text = text or part.Name
end

RunService.RenderStepped:Connect(function()
    ClearESP()
    local root = GetRoot()
    if not root then return end
    
    -- 1. Player ESP
    if Config.ESP_Player then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = math.floor((root.Position - p.Character.HumanoidRootPart.Position).Magnitude)
                local hp = p.Character:FindFirstChild("Humanoid") and math.floor(p.Character.Humanoid.Health) or 0
                CreateESPLabel(p.Character.HumanoidRootPart, Config.ESP_Color_Player, p.Name .. " | " .. dist .. "m | HP: " .. hp)
            end
        end
    end
    
    -- 2. Chest ESP
    if Config.ESP_Chests then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v.Name:find("Chest") and v:IsA("BasePart") then
                local dist = math.floor((root.Position - v.Position).Magnitude)
                CreateESPLabel(v, Config.ESP_Color_Chest, "📦 Rương (" .. v.Name .. ") | " .. dist .. "m")
            end
        end
    end
    
    -- 3. Fruit ESP
    if Config.ESP_Fruits then
        for _, v in pairs(Workspace:GetChildren()) do
            if v:IsA("Tool") or v.Name:find("Fruit") then
                local handle = v:FindFirstChild("Handle") or v:FindFirstChildOfClass("Part")
                if handle then
                    local dist = math.floor((root.Position - handle.Position).Magnitude)
                    CreateESPLabel(handle, Config.ESP_Color_Fruit, "🍎 Trái Ác Quỷ: " .. v.Name .. " | " .. dist .. "m")
                end
            end
        end
    end
    
    -- 4. Mobs ESP
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
end)

-- ===================================================================================
-- [ 8. STATS, HAKI, FRUIT STORE, ANTI-AFK & OPTIMIZATIONS ]
-- ===================================================================================

-- Auto Stat Point
task.spawn(function()
    while task.wait(0.5) do
        if Config.AutoStat then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", Config.StatTarget, Config.StatPointAmount)
            end)
        end
    end
end)

-- Auto Buso Haki
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

-- Auto Collect & Store Fruit
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

-- Anti-AFK Handler
LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        pcall(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
        end)
    end
end)

-- Ultra Fix Lag
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

-- Black Screen Mode
local BlackScreenFrame = nil

local function ToggleBlackScreen(state)
    if state then
        if not BlackScreenFrame then
            local sg = Instance.new("ScreenGui")
            sg.Name = "BF_Hub_BlackScreen"
            sg.ResetOnSpawn = false
            sg.Parent = parentContainer
            
            BlackScreenFrame = Instance.new("Frame")
            BlackScreenFrame.Size = UDim2.new(1, 0, 1, 0)
            BlackScreenFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            BlackScreenFrame.Parent = sg
            
            local txt = Instance.new("TextLabel")
            txt.Parent = BlackScreenFrame
            txt.Size = UDim2.new(1, 0, 1, 0)
            txt.Text = "🌙 ULTRA BLACK SCREEN MODE (TREO ĐÊM TIẾT KIỆM PIN & FPS)\n\nNhấp nút Icon Nổi Mobile hoặc Toggle để mở lại giao diện."
            txt.TextColor3 = Color3.fromRGB(0, 255, 150)
            txt.Font = Enum.Font.SourceSansBold
            txt.TextSize = 22
        end
        BlackScreenFrame.Visible = true
        RunService:Set3dRenderingEnabled(false)
    else
        if BlackScreenFrame then
            BlackScreenFrame.Visible = false
        end
        RunService:Set3dRenderingEnabled(true)
    end
end

-- Garbage Collection Loop
task.spawn(function()
    while task.wait(60) do
        collectgarbage("collect")
    end
end)

-- ===================================================================================
-- [ 9. CONSTRUCT TAB CONTROLS ]
-- ===================================================================================

-- TAB 1: AUTO FARM
AddDropdown(TabFarm, "Vũ Khí Farm:", {"Melee", "Sword", "Blox Fruit", "Gun"}, function(v) Config.SelectedWeapon = v end)
AddToggle(TabFarm, "🌾 Auto Farm Level (Lv 1 -> 2550)", Config.AutoFarmLevel, function(v) Config.AutoFarmLevel = v end)
AddToggle(TabFarm, "🎯 Auto Farm Quái Bãi Chọn", Config.AutoFarmSelectedMob, function(v) Config.AutoFarmSelectedMob = v end)
AddToggle(TabFarm, "👑 Auto Farm Boss Chọn", Config.AutoFarmBoss, function(v) Config.AutoFarmBoss = v end)
AddToggle(TabFarm, "📦 Auto Farm Rương (Chest Farm)", Config.AutoFarmChest, function(v) Config.AutoFarmChest = v end)
AddSlider(TabFarm, "Độ Cao Farm Đứng Trên Đầu", 5, 20, Config.FarmHeight, function(v) Config.FarmHeight = v end)

-- TAB 2: COMBAT
AddToggle(TabCombat, "⚡ Fast Attack V2", Config.FastAttack, function(v) Config.FastAttack = v end)
AddToggle(TabCombat, "🌀 Gom Quái V2 (Bring Mobs 3D)", Config.BringMobs, function(v) Config.BringMobs = v end)
AddSlider(TabCombat, "Bán Kính Gom Quái", 100, 500, Config.BringRadius, function(v) Config.BringRadius = v end)

-- TAB 3: BAY / FLY
local islandList = {}
for k, _ in pairs(Islands) do table.insert(islandList, k) end
AddDropdown(TabFly, "Chọn Đảo Bay:", islandList, function(v) Config.SelectedIsland = v end)
AddButton(TabFly, "🚀 Bay Đến Đảo Đã Chọn", function()
    local targetPos = Islands[Config.SelectedIsland]
    if targetPos then
        SafeWayPointTween(CFrame.new(targetPos + Vector3.new(0, 50, 0)))
    end
end)

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
AddToggle(TabFly, "🦘 Infinite Jump (Nhảy Không Giới Hạn)", Config.InfiniteJump, function(v) Config.InfiniteJump = v end)

-- TAB 4: ESP VISUALS
AddToggle(TabESP, "👤 ESP Players (Người Chơi)", Config.ESP_Player, function(v) Config.ESP_Player = v end)
AddToggle(TabESP, "🧟 ESP Mobs (Quái Thường)", Config.ESP_Mobs, function(v) Config.ESP_Mobs = v end)
AddToggle(TabESP, "📦 ESP Rương (Chests)", Config.ESP_Chests, function(v) Config.ESP_Chests = v end)
AddToggle(TabESP, "🍎 ESP Trái Ác Quỷ (Fruits)", Config.ESP_Fruits, function(v) Config.ESP_Fruits = v end)

-- TAB 5: STATS & FRUIT
AddToggle(TabExtra, "📊 Auto Stat Point", Config.AutoStat, function(v) Config.AutoStat = v end)
AddDropdown(TabExtra, "Chỉ Số Cộng Point:", {"Melee", "Defense", "Sword", "Gun", "Blox Fruit"}, function(v) Config.StatTarget = v end)
AddToggle(TabExtra, "🛡️ Auto Buso Haki", Config.AutoHaki, function(v) Config.AutoHaki = v end)
AddToggle(TabExtra, "🍎 Auto Collect Spawned Fruits", Config.AutoCollectFruit, function(v) Config.AutoCollectFruit = v end)
AddToggle(TabExtra, "📥 Auto Store Fruit to Inventory", Config.AutoStoreFruit, function(v) Config.AutoStoreFruit = v end)

-- TAB 6: FIX LAG
AddToggle(TabLag, "⚡ Ultra Fix Lag FPS Booster V2", Config.FixLag, function(v) 
    Config.FixLag = v 
    if v then ApplyUltraFixLag() end
end)
AddToggle(TabLag, "🌙 Black Screen Mode (Treo Đêm Tiết Kiệm FPS)", Config.BlackScreen, function(v) 
    Config.BlackScreen = v 
    ToggleBlackScreen(v)
end)

-- TAB 7: SYSTEM
AddToggle(TabSystem, "💤 Anti-AFK (Chống Văng Game)", Config.AntiAFK, function(v) Config.AntiAFK = v end)
AddButton(TabSystem, "🔄 Rejoin Current Server", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)
AddButton(TabSystem, "🌐 Server Hop (Đổi Server Khác)", function()
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

Notify("🔥 BLOX FRUITS ULTIMATE HUB V5.5", "Giao diện đã mở! Đã sửa lỗi hiển thị DeltaX thành công.", 5)
print("★ BLOX FRUITS ULTIMATE HUB V5.5 LOADED SUCCESSFULLY ON DELTAX ★")
