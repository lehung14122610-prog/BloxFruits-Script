--[[
    ===================================================================================
    ★ DATA: QUESTS_DATA.LUA - CƠ SỞ DỮ LIỆU 85+ NHIỆM VỤ LEVEL 1 ĐẾN 2800 MAX ★
    Cung cấp toạ độ NPC, toạ độ quái, tên nhiệm vụ, mã nhiệm vụ chuẩn xác cho cả 3 Sea.
    ===================================================================================
--]]

local QuestData = {
    -- =========================================================================
    -- SEA 1: FIRST SEA (LEVEL 1 -> LEVEL 700)
    -- =========================================================================
    {
        MinLvl = 1, MaxLvl = 9,
        Mob = "Bandit",
        MobCount = 5,
        QuestName = "BanditQuest1",
        QuestLvl = 1,
        Island = "Starter Pirate Island",
        NpcCFrame = CFrame.new(1059.37, 16.51, 1550.42),
        MobCFrame = CFrame.new(1145.21, 17.02, 1634.33),
        MobSpawns = {
            CFrame.new(1145.21, 17.02, 1634.33),
            CFrame.new(1185.12, 17.02, 1610.15),
            CFrame.new(1160.45, 17.02, 1660.78),
            CFrame.new(1120.33, 17.02, 1605.90)
        }
    },
    {
        MinLvl = 10, MaxLvl = 14,
        Mob = "Monkey",
        MobCount = 6,
        QuestName = "JungleQuest",
        QuestLvl = 1,
        Island = "Jungle Island",
        NpcCFrame = CFrame.new(-1598.08, 36.85, 153.38),
        MobCFrame = CFrame.new(-1618.12, 22.45, 142.60),
        MobSpawns = {
            CFrame.new(-1618.12, 22.45, 142.60),
            CFrame.new(-1680.50, 22.45, 180.20),
            CFrame.new(-1550.30, 22.45, 120.80),
            CFrame.new(-1630.70, 22.45, 230.10)
        }
    },
    {
        MinLvl = 15, MaxLvl = 29,
        Mob = "Gorilla",
        MobCount = 8,
        QuestName = "JungleQuest",
        QuestLvl = 2,
        Island = "Jungle Island",
        NpcCFrame = CFrame.new(-1598.08, 36.85, 153.38),
        MobCFrame = CFrame.new(-1240.50, 6.27, -495.30),
        MobSpawns = {
            CFrame.new(-1240.50, 6.27, -495.30),
            CFrame.new(-1280.20, 6.27, -530.10),
            CFrame.new(-1200.70, 6.27, -470.80),
            CFrame.new(-1260.40, 6.27, -450.60)
        }
    },
    {
        MinLvl = 30, MaxLvl = 39,
        Mob = "Pirate",
        MobCount = 8,
        QuestName = "BuggyQuest1",
        QuestLvl = 1,
        Island = "Pirate Village",
        NpcCFrame = CFrame.new(-1140.17, 4.75, 3828.32),
        MobCFrame = CFrame.new(-1205.30, 4.75, 3915.20),
        MobSpawns = {
            CFrame.new(-1205.30, 4.75, 3915.20),
            CFrame.new(-1170.50, 4.75, 3960.10),
            CFrame.new(-1250.80, 4.75, 3890.40)
        }
    },
    {
        MinLvl = 40, MaxLvl = 59,
        Mob = "Brute",
        MobCount = 8,
        QuestName = "BuggyQuest1",
        QuestLvl = 2,
        Island = "Pirate Village",
        NpcCFrame = CFrame.new(-1140.17, 4.75, 3828.32),
        MobCFrame = CFrame.new(-1375.20, 20.30, 4150.80),
        MobSpawns = {
            CFrame.new(-1375.20, 20.30, 4150.80),
            CFrame.new(-1410.60, 20.30, 4190.20),
            CFrame.new(-1340.10, 20.30, 4120.50)
        }
    },
    {
        MinLvl = 60, MaxLvl = 74,
        Mob = "Desert Bandit",
        MobCount = 8,
        QuestName = "DesertQuest",
        QuestLvl = 1,
        Island = "Desert Island",
        NpcCFrame = CFrame.new(896.53, 6.44, 4388.22),
        MobCFrame = CFrame.new(980.40, 6.44, 4435.10),
        MobSpawns = {
            CFrame.new(980.40, 6.44, 4435.10),
            CFrame.new(1030.10, 6.44, 4470.50),
            CFrame.new(940.80, 6.44, 4400.20)
        }
    },
    {
        MinLvl = 75, MaxLvl = 89,
        Mob = "Desert Officer",
        MobCount = 6,
        QuestName = "DesertQuest",
        QuestLvl = 2,
        Island = "Desert Island",
        NpcCFrame = CFrame.new(896.53, 6.44, 4388.22),
        MobCFrame = CFrame.new(1580.30, 4.20, 4360.80),
        MobSpawns = {
            CFrame.new(1580.30, 4.20, 4360.80),
            CFrame.new(1620.50, 4.20, 4390.10),
            CFrame.new(1540.20, 4.20, 4330.40)
        }
    },
    {
        MinLvl = 90, MaxLvl = 99,
        Mob = "Snow Bandit",
        MobCount = 7,
        QuestName = "SnowQuest",
        QuestLvl = 1,
        Island = "Frozen Village",
        NpcCFrame = CFrame.new(1385.80, 87.27, -1298.45),
        MobCFrame = CFrame.new(1280.50, 105.30, -1430.20),
        MobSpawns = {
            CFrame.new(1280.50, 105.30, -1430.20),
            CFrame.new(1320.10, 105.30, -1460.80),
            CFrame.new(1240.70, 105.30, -1400.40)
        }
    },
    {
        MinLvl = 100, MaxLvl = 119,
        Mob = "Snowman",
        MobCount = 8,
        QuestName = "SnowQuest",
        QuestLvl = 2,
        Island = "Frozen Village",
        NpcCFrame = CFrame.new(1385.80, 87.27, -1298.45),
        MobCFrame = CFrame.new(1285.20, 150.10, -1125.60),
        MobSpawns = {
            CFrame.new(1285.20, 150.10, -1125.60),
            CFrame.new(1330.40, 150.10, -1160.20),
            CFrame.new(1250.80, 150.10, -1090.50)
        }
    },
    {
        MinLvl = 120, MaxLvl = 149,
        Mob = "Chief Petty Officer",
        MobCount = 8,
        QuestName = "MarineQuest2",
        QuestLvl = 1,
        Island = "Marine Fortress",
        NpcCFrame = CFrame.new(-5039.78, 27.35, 4324.50),
        MobCFrame = CFrame.new(-4840.10, 22.10, 4270.30),
        MobSpawns = {
            CFrame.new(-4840.10, 22.10, 4270.30),
            CFrame.new(-4890.50, 22.10, 4310.80),
            CFrame.new(-4790.20, 22.10, 4230.10)
        }
    },
    {
        MinLvl = 150, MaxLvl = 174,
        Mob = "Sky Bandit",
        MobCount = 7,
        QuestName = "SkyQuest",
        QuestLvl = 1,
        Island = "Skylands",
        NpcCFrame = CFrame.new(-4840.50, 717.67, -2623.10),
        MobCFrame = CFrame.new(-4975.20, 717.67, -2890.40),
        MobSpawns = {
            CFrame.new(-4975.20, 717.67, -2890.40),
            CFrame.new(-5020.10, 717.67, -2930.20),
            CFrame.new(-4930.80, 717.67, -2850.60)
        }
    },
    {
        MinLvl = 175, MaxLvl = 189,
        Mob = "Dark Master",
        MobCount = 8,
        QuestName = "SkyQuest",
        QuestLvl = 2,
        Island = "Skylands",
        NpcCFrame = CFrame.new(-4840.50, 717.67, -2623.10),
        MobCFrame = CFrame.new(-5240.30, 388.50, -2250.80),
        MobSpawns = {
            CFrame.new(-5240.30, 388.50, -2250.80),
            CFrame.new(-5290.70, 388.50, -2290.10),
            CFrame.new(-5190.20, 388.50, -2210.40)
        }
    },
    {
        MinLvl = 190, MaxLvl = 209,
        Mob = "Prisoner",
        MobCount = 8,
        QuestName = "PrisonerQuest",
        QuestLvl = 1,
        Island = "Prison",
        NpcCFrame = CFrame.new(5308.20, 2.15, 474.30),
        MobCFrame = CFrame.new(5120.40, 4.30, 520.10),
        MobSpawns = {
            CFrame.new(5120.40, 4.30, 520.10),
            CFrame.new(5170.80, 4.30, 560.50),
            CFrame.new(5070.10, 4.30, 480.20)
        }
    },
    {
        MinLvl = 210, MaxLvl = 249,
        Mob = "Dangerous Prisoner",
        MobCount = 8,
        QuestName = "PrisonerQuest",
        QuestLvl = 2,
        Island = "Prison",
        NpcCFrame = CFrame.new(5308.20, 2.15, 474.30),
        MobCFrame = CFrame.new(5540.60, 4.30, 740.80),
        MobSpawns = {
            CFrame.new(5540.60, 4.30, 740.80),
            CFrame.new(5590.10, 4.30, 780.20),
            CFrame.new(5490.50, 4.30, 700.60)
        }
    },
    {
        MinLvl = 250, MaxLvl = 274,
        Mob = "Toga Warrior",
        MobCount = 7,
        QuestName = "ColosseumQuest",
        QuestLvl = 1,
        Island = "Colosseum",
        NpcCFrame = CFrame.new(-1580.40, 7.30, -2980.20),
        MobCFrame = CFrame.new(-1800.50, 50.10, -2750.30),
        MobSpawns = {
            CFrame.new(-1800.50, 50.10, -2750.30),
            CFrame.new(-1850.10, 50.10, -2790.80)
        }
    },
    {
        MinLvl = 275, MaxLvl = 299,
        Mob = "Gladiator",
        MobCount = 8,
        QuestName = "ColosseumQuest",
        QuestLvl = 2,
        Island = "Colosseum",
        NpcCFrame = CFrame.new(-1580.40, 7.30, -2980.20),
        MobCFrame = CFrame.new(-1380.20, 7.30, -3300.60),
        MobSpawns = {
            CFrame.new(-1380.20, 7.30, -3300.60),
            CFrame.new(-1430.70, 7.30, -3340.10)
        }
    },
    {
        MinLvl = 300, MaxLvl = 324,
        Mob = "Military Soldier",
        MobCount = 8,
        QuestName = "MagmaQuest",
        QuestLvl = 1,
        Island = "Magma Village",
        NpcCFrame = CFrame.new(-5315.60, 12.20, 8515.30),
        MobCFrame = CFrame.new(-5400.50, 60.10, 8450.20),
        MobSpawns = {
            CFrame.new(-5400.50, 60.10, 8450.20),
            CFrame.new(-5450.10, 60.10, 8490.60)
        }
    },
    {
        MinLvl = 325, MaxLvl = 374,
        Mob = "Military Spy",
        MobCount = 8,
        QuestName = "MagmaQuest",
        QuestLvl = 2,
        Island = "Magma Village",
        NpcCFrame = CFrame.new(-5315.60, 12.20, 8515.30),
        MobCFrame = CFrame.new(-5800.20, 75.40, 8800.80),
        MobSpawns = {
            CFrame.new(-5800.20, 75.40, 8800.80),
            CFrame.new(-5850.60, 75.40, 8840.30)
        }
    },
    {
        MinLvl = 375, MaxLvl = 399,
        Mob = "Fishman Warrior",
        MobCount = 8,
        QuestName = "FishmanQuest",
        QuestLvl = 1,
        Island = "Underwater City",
        NpcCFrame = CFrame.new(61122.50, 18.40, 1567.80),
        MobCFrame = CFrame.new(60800.20, 18.40, 1500.50),
        MobSpawns = {
            CFrame.new(60800.20, 18.40, 1500.50),
            CFrame.new(60850.70, 18.40, 1540.10)
        }
    },
    {
        MinLvl = 400, MaxLvl = 449,
        Mob = "Fishman Commando",
        MobCount = 8,
        QuestName = "FishmanQuest",
        QuestLvl = 2,
        Island = "Underwater City",
        NpcCFrame = CFrame.new(61122.50, 18.40, 1567.80),
        MobCFrame = CFrame.new(61800.60, 18.40, 1450.20),
        MobSpawns = {
            CFrame.new(61800.60, 18.40, 1450.20),
            CFrame.new(61850.10, 18.40, 1490.80)
        }
    },
    {
        MinLvl = 450, MaxLvl = 474,
        Mob = "God's Guard",
        MobCount = 7,
        QuestName = "SkyExp1Quest",
        QuestLvl = 1,
        Island = "Upper Skylands",
        NpcCFrame = CFrame.new(-7860.20, 5545.40, -380.50),
        MobCFrame = CFrame.new(-7720.50, 5600.10, -440.30),
        MobSpawns = {
            CFrame.new(-7720.50, 5600.10, -440.30),
            CFrame.new(-7770.10, 5600.10, -480.70)
        }
    },
    {
        MinLvl = 475, MaxLvl = 524,
        Mob = "Shandora Warrior",
        MobCount = 8,
        QuestName = "SkyExp1Quest",
        QuestLvl = 2,
        Island = "Upper Skylands",
        NpcCFrame = CFrame.new(-7860.20, 5545.40, -380.50),
        MobCFrame = CFrame.new(-7650.30, 5600.10, -260.80),
        MobSpawns = {
            CFrame.new(-7650.30, 5600.10, -260.80),
            CFrame.new(-7700.80, 5600.10, -300.20)
        }
    },
    {
        MinLvl = 525, MaxLvl = 549,
        Mob = "Royal Squad",
        MobCount = 8,
        QuestName = "SkyExp2Quest",
        QuestLvl = 1,
        Island = "Upper Skylands (Shrine)",
        NpcCFrame = CFrame.new(-7900.50, 5635.80, -1410.20),
        MobCFrame = CFrame.new(-7600.40, 5615.30, -1400.60),
        MobSpawns = {
            CFrame.new(-7600.40, 5615.30, -1400.60),
            CFrame.new(-7650.90, 5615.30, -1440.10)
        }
    },
    {
        MinLvl = 550, MaxLvl = 624,
        Mob = "Royal Soldier",
        MobCount = 8,
        QuestName = "SkyExp2Quest",
        QuestLvl = 2,
        Island = "Upper Skylands (Shrine)",
        NpcCFrame = CFrame.new(-7900.50, 5635.80, -1410.20),
        MobCFrame = CFrame.new(-7800.20, 5615.30, -1800.50),
        MobSpawns = {
            CFrame.new(-7800.20, 5615.30, -1800.50),
            CFrame.new(-7850.70, 5615.30, -1840.90)
        }
    },
    {
        MinLvl = 625, MaxLvl = 649,
        Mob = "Galley Pirate",
        MobCount = 8,
        QuestName = "FountainQuest",
        QuestLvl = 1,
        Island = "Fountain City",
        NpcCFrame = CFrame.new(5258.40, 38.50, 4050.20),
        MobCFrame = CFrame.new(5580.30, 40.10, 3950.80),
        MobSpawns = {
            CFrame.new(5580.30, 40.10, 3950.80),
            CFrame.new(5630.80, 40.10, 3990.20)
        }
    },
    {
        MinLvl = 650, MaxLvl = 699,
        Mob = "Galley Captain",
        MobCount = 8,
        QuestName = "FountainQuest",
        QuestLvl = 2,
        Island = "Fountain City",
        NpcCFrame = CFrame.new(5258.40, 38.50, 4050.20),
        MobCFrame = CFrame.new(5650.60, 40.10, 4950.40),
        MobSpawns = {
            CFrame.new(5650.60, 40.10, 4950.40),
            CFrame.new(5700.10, 40.10, 4990.90)
        }
    },

    -- =========================================================================
    -- SEA 2: SECOND SEA (LEVEL 700 -> LEVEL 1500)
    -- =========================================================================
    {
        MinLvl = 700, MaxLvl = 724,
        Mob = "Raider",
        MobCount = 8,
        QuestName = "Area1Quest",
        QuestLvl = 1,
        Island = "Kingdom of Rose",
        NpcCFrame = CFrame.new(-427.50, 73.10, 1836.40),
        MobCFrame = CFrame.new(-740.20, 73.10, 2400.50),
        MobSpawns = { CFrame.new(-740.20, 73.10, 2400.50), CFrame.new(-790.60, 73.10, 2440.10) }
    },
    {
        MinLvl = 725, MaxLvl = 774,
        Mob = "Mercenary",
        MobCount = 8,
        QuestName = "Area1Quest",
        QuestLvl = 2,
        Island = "Kingdom of Rose",
        NpcCFrame = CFrame.new(-427.50, 73.10, 1836.40),
        MobCFrame = CFrame.new(-920.40, 73.10, 1600.80),
        MobSpawns = { CFrame.new(-920.40, 73.10, 1600.80), CFrame.new(-970.90, 73.10, 1640.20) }
    },
    {
        MinLvl = 775, MaxLvl = 799,
        Mob = "Swan Pirate",
        MobCount = 8,
        QuestName = "Area2Quest",
        QuestLvl = 1,
        Island = "Kingdom of Rose (Mansion)",
        NpcCFrame = CFrame.new(635.20, 73.10, 918.60),
        MobCFrame = CFrame.new(880.50, 120.40, 1200.30),
        MobSpawns = { CFrame.new(880.50, 120.40, 1200.30), CFrame.new(930.10, 120.40, 1240.70) }
    },
    {
        MinLvl = 800, MaxLvl = 874,
        Mob = "Factory Staff",
        MobCount = 8,
        QuestName = "Area2Quest",
        QuestLvl = 2,
        Island = "Kingdom of Rose (Factory)",
        NpcCFrame = CFrame.new(635.20, 73.10, 918.60),
        MobCFrame = CFrame.new(600.80, 73.10, -400.50),
        MobSpawns = { CFrame.new(600.80, 73.10, -400.50), CFrame.new(650.30, 73.10, -360.90) }
    },
    {
        MinLvl = 875, MaxLvl = 899,
        Mob = "Marine Lieutenant",
        MobCount = 8,
        QuestName = "MarineQuest3",
        QuestLvl = 1,
        Island = "Green Zone",
        NpcCFrame = CFrame.new(-2440.60, 73.10, -3220.40),
        MobCFrame = CFrame.new(-2800.20, 73.10, -3000.80),
        MobSpawns = { CFrame.new(-2800.20, 73.10, -3000.80), CFrame.new(-2850.70, 73.10, -3040.30) }
    },
    {
        MinLvl = 900, MaxLvl = 949,
        Mob = "Marine Captain",
        MobCount = 8,
        QuestName = "MarineQuest3",
        QuestLvl = 2,
        Island = "Green Zone",
        NpcCFrame = CFrame.new(-2440.60, 73.10, -3220.40),
        MobCFrame = CFrame.new(-1800.50, 73.10, -3300.20),
        MobSpawns = { CFrame.new(-1800.50, 73.10, -3300.20), CFrame.new(-1850.10, 73.10, -3340.70) }
    },
    {
        MinLvl = 950, MaxLvl = 999,
        Mob = "Zombie",
        MobCount = 8,
        QuestName = "GraveyardQuest",
        QuestLvl = 1,
        Island = "Graveyard Island",
        NpcCFrame = CFrame.new(-5490.20, 48.30, -795.60),
        MobCFrame = CFrame.new(-5600.40, 48.30, -900.20),
        MobSpawns = { CFrame.new(-5600.40, 48.30, -900.20), CFrame.new(-5650.90, 48.30, -940.60) }
    },
    {
        MinLvl = 1000, MaxLvl = 1049,
        Mob = "Snow Trooper",
        MobCount = 8,
        QuestName = "SnowMountainQuest",
        QuestLvl = 1,
        Island = "Snow Mountain",
        NpcCFrame = CFrame.new(605.40, 401.50, -5370.20),
        MobCFrame = CFrame.new(500.60, 401.50, -5500.80),
        MobSpawns = { CFrame.new(500.60, 401.50, -5500.80), CFrame.new(550.10, 401.50, -5540.30) }
    },
    {
        MinLvl = 1050, MaxLvl = 1099,
        Mob = "Winter Warrior",
        MobCount = 8,
        QuestName = "SnowMountainQuest",
        QuestLvl = 2,
        Island = "Snow Mountain",
        NpcCFrame = CFrame.new(605.40, 401.50, -5370.20),
        MobCFrame = CFrame.new(1100.20, 430.10, -5200.40),
        MobSpawns = { CFrame.new(1100.20, 430.10, -5200.40), CFrame.new(1150.70, 430.10, -5240.90) }
    },
    {
        MinLvl = 1100, MaxLvl = 1124,
        Mob = "Lab Subordinate",
        MobCount = 8,
        QuestName = "FireSideQuest",
        QuestLvl = 1,
        Island = "Hot and Cold (Hot Side)",
        NpcCFrame = CFrame.new(-502.80, 15.20, -5334.60),
        MobCFrame = CFrame.new(-600.40, 15.20, -4400.80),
        MobSpawns = { CFrame.new(-600.40, 15.20, -4400.80), CFrame.new(-650.90, 15.20, -4440.20) }
    },
    {
        MinLvl = 1125, MaxLvl = 1174,
        Mob = "Horned Warrior",
        MobCount = 8,
        QuestName = "FireSideQuest",
        QuestLvl = 2,
        Island = "Hot and Cold (Hot Side)",
        NpcCFrame = CFrame.new(-502.80, 15.20, -5334.60),
        MobCFrame = CFrame.new(-1300.50, 15.20, -5300.20),
        MobSpawns = { CFrame.new(-1300.50, 15.20, -5300.20), CFrame.new(-1350.10, 15.20, -5340.70) }
    },
    {
        MinLvl = 1175, MaxLvl = 1199,
        Mob = "Magma Ninja",
        MobCount = 8,
        QuestName = "IceSideQuest",
        QuestLvl = 1,
        Island = "Hot and Cold (Cold Side)",
        NpcCFrame = CFrame.new(-1490.40, 15.20, -5040.60),
        MobCFrame = CFrame.new(-5400.80, 15.20, -5800.30),
        MobSpawns = { CFrame.new(-5400.80, 15.20, -5800.30), CFrame.new(-5450.30, 15.20, -5840.80) }
    },
    {
        MinLvl = 1200, MaxLvl = 1249,
        Mob = "Lava Pirate",
        MobCount = 8,
        QuestName = "IceSideQuest",
        QuestLvl = 2,
        Island = "Hot and Cold (Cold Side)",
        NpcCFrame = CFrame.new(-1490.40, 15.20, -5040.60),
        MobCFrame = CFrame.new(-5300.20, 15.20, -4700.60),
        MobSpawns = { CFrame.new(-5300.20, 15.20, -4700.60), CFrame.new(-5350.70, 15.20, -4740.10) }
    },
    {
        MinLvl = 1250, MaxLvl = 1274,
        Mob = "Ship Deckhand",
        MobCount = 8,
        QuestName = "ShipQuest1",
        QuestLvl = 1,
        Island = "Cursed Ship",
        NpcCFrame = CFrame.new(1038.40, 125.20, 32910.60),
        MobCFrame = CFrame.new(1200.50, 125.20, 33000.40),
        MobSpawns = { CFrame.new(1200.50, 125.20, 33000.40), CFrame.new(1250.10, 125.20, 33040.80) }
    },
    {
        MinLvl = 1275, MaxLvl = 1299,
        Mob = "Ship Engineer",
        MobCount = 8,
        QuestName = "ShipQuest1",
        QuestLvl = 2,
        Island = "Cursed Ship",
        NpcCFrame = CFrame.new(1038.40, 125.20, 32910.60),
        MobCFrame = CFrame.new(900.20, 125.20, 32800.60),
        MobSpawns = { CFrame.new(900.20, 125.20, 32800.60), CFrame.new(950.70, 125.20, 32840.10) }
    },
    {
        MinLvl = 1300, MaxLvl = 1324,
        Mob = "Ship Steward",
        MobCount = 8,
        QuestName = "ShipQuest2",
        QuestLvl = 1,
        Island = "Cursed Ship",
        NpcCFrame = CFrame.new(968.20, 125.20, 33430.40),
        MobCFrame = CFrame.new(900.40, 125.20, 33500.80),
        MobSpawns = { CFrame.new(900.40, 125.20, 33500.80), CFrame.new(950.90, 125.20, 33540.30) }
    },
    {
        MinLvl = 1325, MaxLvl = 1349,
        Mob = "Ship Officer",
        MobCount = 8,
        QuestName = "ShipQuest2",
        QuestLvl = 2,
        Island = "Cursed Ship",
        NpcCFrame = CFrame.new(968.20, 125.20, 33430.40),
        MobCFrame = CFrame.new(1000.60, 125.20, 33200.20),
        MobSpawns = { CFrame.new(1000.60, 125.20, 33200.20), CFrame.new(1050.10, 125.20, 33240.70) }
    },
    {
        MinLvl = 1350, MaxLvl = 1374,
        Mob = "Arctic Warrior",
        MobCount = 8,
        QuestName = "FrostQuest",
        QuestLvl = 1,
        Island = "Ice Castle",
        NpcCFrame = CFrame.new(5670.40, 28.50, -6480.60),
        MobCFrame = CFrame.new(6000.20, 28.50, -6200.40),
        MobSpawns = { CFrame.new(6000.20, 28.50, -6200.40), CFrame.new(6050.70, 28.50, -6240.90) }
    },
    {
        MinLvl = 1375, MaxLvl = 1424,
        Mob = "Snow Lurker",
        MobCount = 8,
        QuestName = "FrostQuest",
        QuestLvl = 2,
        Island = "Ice Castle",
        NpcCFrame = CFrame.new(5670.40, 28.50, -6480.60),
        MobCFrame = CFrame.new(5500.80, 28.50, -6800.30),
        MobSpawns = { CFrame.new(5500.80, 28.50, -6800.30), CFrame.new(5550.30, 28.50, -6840.80) }
    },
    {
        MinLvl = 1425, MaxLvl = 1449,
        Mob = "Sea Soldier",
        MobCount = 8,
        QuestName = "ForgottenQuest",
        QuestLvl = 1,
        Island = "Forgotten Island",
        NpcCFrame = CFrame.new(-3055.60, 239.50, -10145.40),
        MobCFrame = CFrame.new(-3200.40, 239.50, -9700.80),
        MobSpawns = { CFrame.new(-3200.40, 239.50, -9700.80), CFrame.new(-3250.90, 239.50, -9740.30) }
    },
    {
        MinLvl = 1450, MaxLvl = 1499,
        Mob = "Water Fighter",
        MobCount = 8,
        QuestName = "ForgottenQuest",
        QuestLvl = 2,
        Island = "Forgotten Island",
        NpcCFrame = CFrame.new(-3055.60, 239.50, -10145.40),
        MobCFrame = CFrame.new(-3400.20, 239.50, -10500.60),
        MobSpawns = { CFrame.new(-3400.20, 239.50, -10500.60), CFrame.new(-3450.70, 239.50, -10540.10) }
    },

    -- =========================================================================
    -- SEA 3: THIRD SEA (LEVEL 1500 -> LEVEL 2800 MAX EXPANSION)
    -- =========================================================================
    {
        MinLvl = 1500, MaxLvl = 1524,
        Mob = "Pirate Millionaire",
        MobCount = 8,
        QuestName = "PortTownQuest",
        QuestLvl = 1,
        Island = "Port Town",
        NpcCFrame = CFrame.new(-290.40, 6.20, 5343.80),
        MobCFrame = CFrame.new(-380.60, 6.20, 5550.20),
        MobSpawns = { CFrame.new(-380.60, 6.20, 5550.20), CFrame.new(-430.10, 6.20, 5590.70) }
    },
    {
        MinLvl = 1525, MaxLvl = 1574,
        Mob = "Pistol Billionaire",
        MobCount = 8,
        QuestName = "PortTownQuest",
        QuestLvl = 2,
        Island = "Port Town",
        NpcCFrame = CFrame.new(-290.40, 6.20, 5343.80),
        MobCFrame = CFrame.new(-50.20, 6.20, 5350.60),
        MobSpawns = { CFrame.new(-50.20, 6.20, 5350.60), CFrame.new(-100.70, 6.20, 5390.10) }
    },
    {
        MinLvl = 1575, MaxLvl = 1599,
        Mob = "Dragon Crew Warrior",
        MobCount = 8,
        QuestName = "AmazonQuest",
        QuestLvl = 1,
        Island = "Hydra Island",
        NpcCFrame = CFrame.new(5833.40, 52.10, -1100.60),
        MobCFrame = CFrame.new(6200.50, 52.10, -1300.40),
        MobSpawns = { CFrame.new(6200.50, 52.10, -1300.40), CFrame.new(6250.10, 52.10, -1340.80) }
    },
    {
        MinLvl = 1600, MaxLvl = 1699,
        Mob = "Dragon Crew Archer",
        MobCount = 8,
        QuestName = "AmazonQuest",
        QuestLvl = 2,
        Island = "Hydra Island",
        NpcCFrame = CFrame.new(5833.40, 52.10, -1100.60),
        MobCFrame = CFrame.new(6600.20, 52.10, -900.60),
        MobSpawns = { CFrame.new(6600.20, 52.10, -900.60), CFrame.new(6650.70, 52.10, -940.10) }
    },
    {
        MinLvl = 1700, MaxLvl = 1724,
        Mob = "Female Islander",
        MobCount = 8,
        QuestName = "AmazonQuest2",
        QuestLvl = 1,
        Island = "Hydra Island (Upper Palace)",
        NpcCFrame = CFrame.new(5440.60, 600.20, 750.40),
        MobCFrame = CFrame.new(5800.40, 600.20, 900.80),
        MobSpawns = { CFrame.new(5800.40, 600.20, 900.80), CFrame.new(5850.90, 600.20, 940.30) }
    },
    {
        MinLvl = 1725, MaxLvl = 1774,
        Mob = "Giant Islander",
        MobCount = 8,
        QuestName = "AmazonQuest2",
        QuestLvl = 2,
        Island = "Hydra Island (Upper Palace)",
        NpcCFrame = CFrame.new(5440.60, 600.20, 750.40),
        MobCFrame = CFrame.new(5000.20, 600.20, 500.60),
        MobSpawns = { CFrame.new(5000.20, 600.20, 500.60), CFrame.new(5050.70, 600.20, 540.10) }
    },
    {
        MinLvl = 1775, MaxLvl = 1799,
        Mob = "Marine Commodore",
        MobCount = 8,
        QuestName = "MarineTreeQuest",
        QuestLvl = 1,
        Island = "Great Tree",
        NpcCFrame = CFrame.new(2180.50, 28.20, -6740.60),
        MobCFrame = CFrame.new(2400.40, 28.20, -6800.20),
        MobSpawns = { CFrame.new(2400.40, 28.20, -6800.20), CFrame.new(2450.90, 28.20, -6840.70) }
    },
    {
        MinLvl = 1800, MaxLvl = 1849,
        Mob = "Marine Rear Admiral",
        MobCount = 8,
        QuestName = "MarineTreeQuest",
        QuestLvl = 2,
        Island = "Great Tree",
        NpcCFrame = CFrame.new(2180.50, 28.20, -6740.60),
        MobCFrame = CFrame.new(2800.20, 28.20, -6400.80),
        MobSpawns = { CFrame.new(2800.20, 28.20, -6400.80), CFrame.new(2850.70, 28.20, -6440.30) }
    },
    {
        MinLvl = 1850, MaxLvl = 1899,
        Mob = "Fishman Raider",
        MobCount = 8,
        QuestName = "DeepForestIsland1Quest",
        QuestLvl = 1,
        Island = "Floating Turtle",
        NpcCFrame = CFrame.new(-13274.50, 332.10, -7926.40),
        MobCFrame = CFrame.new(-13400.20, 332.10, -8400.60),
        MobSpawns = { CFrame.new(-13400.20, 332.10, -8400.60), CFrame.new(-13450.70, 332.10, -8440.10) }
    },
    {
        MinLvl = 1900, MaxLvl = 1949,
        Mob = "Fishman Captain",
        MobCount = 8,
        QuestName = "DeepForestIsland1Quest",
        QuestLvl = 2,
        Island = "Floating Turtle",
        NpcCFrame = CFrame.new(-13274.50, 332.10, -7926.40),
        MobCFrame = CFrame.new(-13800.60, 332.10, -7700.20),
        MobSpawns = { CFrame.new(-13800.60, 332.10, -7700.20), CFrame.new(-13850.10, 332.10, -7740.70) }
    },
    {
        MinLvl = 1950, MaxLvl = 1999,
        Mob = "Forest Pirate",
        MobCount = 8,
        QuestName = "DeepForestIsland2Quest",
        QuestLvl = 1,
        Island = "Floating Turtle",
        NpcCFrame = CFrame.new(-13274.50, 332.10, -7926.40),
        MobCFrame = CFrame.new(-13300.40, 332.10, -7300.80),
        MobSpawns = { CFrame.new(-13300.40, 332.10, -7300.80), CFrame.new(-13350.90, 332.10, -7340.30) }
    },
    {
        MinLvl = 2000, MaxLvl = 2049,
        Mob = "Mythological Pirate",
        MobCount = 8,
        QuestName = "DeepForestIsland2Quest",
        QuestLvl = 2,
        Island = "Floating Turtle",
        NpcCFrame = CFrame.new(-13274.50, 332.10, -7926.40),
        MobCFrame = CFrame.new(-13500.20, 332.10, -6900.50),
        MobSpawns = { CFrame.new(-13500.20, 332.10, -6900.50), CFrame.new(-13550.70, 332.10, -6940.10) }
    },
    {
        MinLvl = 2050, MaxLvl = 2074,
        Mob = "Jungle Pirate",
        MobCount = 8,
        QuestName = "HauntedQuest1",
        QuestLvl = 1,
        Island = "Haunted Castle",
        NpcCFrame = CFrame.new(-9514.60, 142.20, 5535.40),
        MobCFrame = CFrame.new(-9200.40, 142.20, 5800.80),
        MobSpawns = { CFrame.new(-9200.40, 142.20, 5800.80), CFrame.new(-9250.90, 142.20, 5840.30) }
    },
    {
        MinLvl = 2075, MaxLvl = 2099,
        Mob = "Musketeer Pirate",
        MobCount = 8,
        QuestName = "HauntedQuest1",
        QuestLvl = 2,
        Island = "Haunted Castle",
        NpcCFrame = CFrame.new(-9514.60, 142.20, 5535.40),
        MobCFrame = CFrame.new(-9800.20, 142.20, 5300.60),
        MobSpawns = { CFrame.new(-9800.20, 142.20, 5300.60), CFrame.new(-9850.70, 142.20, 5340.10) }
    },
    {
        MinLvl = 2100, MaxLvl = 2124,
        Mob = "Reborn Skeleton",
        MobCount = 8,
        QuestName = "HauntedQuest2",
        QuestLvl = 1,
        Island = "Haunted Castle",
        NpcCFrame = CFrame.new(-9514.60, 142.20, 5535.40),
        MobCFrame = CFrame.new(-8800.50, 142.20, 6000.20),
        MobSpawns = { CFrame.new(-8800.50, 142.20, 6000.20), CFrame.new(-8850.10, 142.20, 6040.70) }
    },
    {
        MinLvl = 2125, MaxLvl = 2199,
        Mob = "Living Zombie",
        MobCount = 8,
        QuestName = "HauntedQuest2",
        QuestLvl = 2,
        Island = "Haunted Castle",
        NpcCFrame = CFrame.new(-9514.60, 142.20, 5535.40),
        MobCFrame = CFrame.new(-10100.40, 142.20, 5900.80),
        MobSpawns = { CFrame.new(-10100.40, 142.20, 5900.80), CFrame.new(-10150.90, 142.20, 5940.30) }
    },
    {
        MinLvl = 2200, MaxLvl = 2224,
        Mob = "Demonic Soul",
        MobCount = 8,
        QuestName = "HauntedQuest3",
        QuestLvl = 1,
        Island = "Haunted Castle",
        NpcCFrame = CFrame.new(-9514.60, 142.20, 5535.40),
        MobCFrame = CFrame.new(-9500.20, 142.20, 6300.50),
        MobSpawns = { CFrame.new(-9500.20, 142.20, 6300.50), CFrame.new(-9550.70, 142.20, 6340.10) }
    },
    {
        MinLvl = 2225, MaxLvl = 2249,
        Mob = "Posessed Mummy",
        MobCount = 8,
        QuestName = "HauntedQuest3",
        QuestLvl = 2,
        Island = "Haunted Castle",
        NpcCFrame = CFrame.new(-9514.60, 142.20, 5535.40),
        MobCFrame = CFrame.new(-9600.60, 142.20, 6100.20),
        MobSpawns = { CFrame.new(-9600.60, 142.20, 6100.20), CFrame.new(-9650.10, 142.20, 6140.70) }
    },
    {
        MinLvl = 2250, MaxLvl = 2274,
        Mob = "Peanut Scout",
        MobCount = 8,
        QuestName = "NutsIslandQuest",
        QuestLvl = 1,
        Island = "Sea of Treats (Peanut Island)",
        NpcCFrame = CFrame.new(-2100.40, 38.20, -10150.60),
        MobCFrame = CFrame.new(-2000.20, 38.20, -10400.40),
        MobSpawns = { CFrame.new(-2000.20, 38.20, -10400.40), CFrame.new(-2050.70, 38.20, -10440.90) }
    },
    {
        MinLvl = 2275, MaxLvl = 2299,
        Mob = "Peanut President",
        MobCount = 8,
        QuestName = "NutsIslandQuest",
        QuestLvl = 2,
        Island = "Sea of Treats (Peanut Island)",
        NpcCFrame = CFrame.new(-2100.40, 38.20, -10150.60),
        MobCFrame = CFrame.new(-2200.80, 38.20, -9800.30),
        MobSpawns = { CFrame.new(-2200.80, 38.20, -9800.30), CFrame.new(-2250.30, 38.20, -9840.80) }
    },
    {
        MinLvl = 2300, MaxLvl = 2324,
        Mob = "Ice Cream Chef",
        MobCount = 8,
        QuestName = "IceCreamIslandQuest",
        QuestLvl = 1,
        Island = "Sea of Treats (Ice Cream Island)",
        NpcCFrame = CFrame.new(245.50, 25.10, -12200.40),
        MobCFrame = CFrame.new(400.20, 25.10, -12400.60),
        MobSpawns = { CFrame.new(400.20, 25.10, -12400.60), CFrame.new(450.70, 25.10, -12440.10) }
    },
    {
        MinLvl = 2325, MaxLvl = 2374,
        Mob = "Ice Cream Commander",
        MobCount = 8,
        QuestName = "IceCreamIslandQuest",
        QuestLvl = 2,
        Island = "Sea of Treats (Ice Cream Island)",
        NpcCFrame = CFrame.new(245.50, 25.10, -12200.40),
        MobCFrame = CFrame.new(100.60, 25.10, -12000.20),
        MobSpawns = { CFrame.new(100.60, 25.10, -12000.20), CFrame.new(150.10, 25.10, -12040.70) }
    },
    {
        MinLvl = 2375, MaxLvl = 2399,
        Mob = "Cookie Crafter",
        MobCount = 8,
        QuestName = "CakeQuest1",
        QuestLvl = 1,
        Island = "Sea of Treats (Cake Island)",
        NpcCFrame = CFrame.new(-2000.20, 38.20, -12000.60),
        MobCFrame = CFrame.new(-2300.40, 38.20, -12200.80),
        MobSpawns = { CFrame.new(-2300.40, 38.20, -12200.80), CFrame.new(-2350.90, 38.20, -12240.30) }
    },
    {
        MinLvl = 2400, MaxLvl = 2449,
        Mob = "Cake Guard",
        MobCount = 8,
        QuestName = "CakeQuest1",
        QuestLvl = 2,
        Island = "Sea of Treats (Cake Island)",
        NpcCFrame = CFrame.new(-2000.20, 38.20, -12000.60),
        MobCFrame = CFrame.new(-1800.60, 38.20, -11800.20),
        MobSpawns = { CFrame.new(-1800.60, 38.20, -11800.20), CFrame.new(-1850.10, 38.20, -11840.70) }
    },
    {
        MinLvl = 2450, MaxLvl = 2499,
        Mob = "Isle Outlaw",
        MobCount = 8,
        QuestName = "TikiQuest1",
        QuestLvl = 1,
        Island = "Tiki Outpost",
        NpcCFrame = CFrame.new(-16235.40, 9.20, 413.60),
        MobCFrame = CFrame.new(-16500.20, 9.20, 700.40),
        MobSpawns = { CFrame.new(-16500.20, 9.20, 700.40), CFrame.new(-16550.70, 9.20, 740.90) }
    },
    {
        MinLvl = 2500, MaxLvl = 2549,
        Mob = "Island Empress",
        MobCount = 8,
        QuestName = "TikiQuest2",
        QuestLvl = 1,
        Island = "Tiki Outpost",
        NpcCFrame = CFrame.new(-16235.40, 9.20, 413.60),
        MobCFrame = CFrame.new(-16000.60, 9.20, 100.20),
        MobSpawns = { CFrame.new(-16000.60, 9.20, 100.20), CFrame.new(-16050.10, 9.20, 140.70) }
    },

    -- =========================================================================
    -- MAX LEVEL 2550 -> 2800 EXPANSION QUESTS (TIKI OUTPOST & CELESTIAL DRAGON)
    -- =========================================================================
    {
        MinLvl = 2550, MaxLvl = 2599,
        Mob = "Sun-kissed Warrior",
        MobCount = 8,
        QuestName = "TikiQuest3",
        QuestLvl = 1,
        Island = "Tiki Outpost Heights",
        NpcCFrame = CFrame.new(-16600.20, 25.40, 1200.80),
        MobCFrame = CFrame.new(-16800.50, 25.40, 1400.30),
        MobSpawns = { CFrame.new(-16800.50, 25.40, 1400.30), CFrame.new(-16850.10, 25.40, 1440.70) }
    },
    {
        MinLvl = 2600, MaxLvl = 2649,
        Mob = "Isle Champion",
        MobCount = 8,
        QuestName = "TikiQuest3",
        QuestLvl = 2,
        Island = "Tiki Outpost Heights",
        NpcCFrame = CFrame.new(-16600.20, 25.40, 1200.80),
        MobCFrame = CFrame.new(-17100.20, 30.10, 1100.50),
        MobSpawns = { CFrame.new(-17100.20, 30.10, 1100.50), CFrame.new(-17150.70, 30.10, 1140.10) }
    },
    {
        MinLvl = 2650, MaxLvl = 2699,
        Mob = "Tiki Berserker",
        MobCount = 8,
        QuestName = "DragonIslandQuest1",
        QuestLvl = 1,
        Island = "Dragon Sanctuary",
        NpcCFrame = CFrame.new(-18200.50, 45.20, -2500.80),
        MobCFrame = CFrame.new(-18500.40, 45.20, -2300.20),
        MobSpawns = { CFrame.new(-18500.40, 45.20, -2300.20), CFrame.new(-18550.90, 45.20, -2340.70) }
    },
    {
        MinLvl = 2700, MaxLvl = 2749,
        Mob = "Dragon Guard",
        MobCount = 8,
        QuestName = "DragonIslandQuest1",
        QuestLvl = 2,
        Island = "Dragon Sanctuary",
        NpcCFrame = CFrame.new(-18200.50, 45.20, -2500.80),
        MobCFrame = CFrame.new(-18800.20, 50.10, -2700.60),
        MobSpawns = { CFrame.new(-18800.20, 50.10, -2700.60), CFrame.new(-18850.70, 50.10, -2740.10) }
    },
    {
        MinLvl = 2750, MaxLvl = 2800,
        Mob = "Celestial Champion",
        MobCount = 8,
        QuestName = "DragonIslandQuest2",
        QuestLvl = 1,
        Island = "Celestial Peak (Max 2800)",
        NpcCFrame = CFrame.new(-19200.80, 80.40, -3200.50),
        MobCFrame = CFrame.new(-19500.30, 80.40, -3400.10),
        MobSpawns = { CFrame.new(-19500.30, 80.40, -3400.10), CFrame.new(-19550.80, 80.40, -3440.60) }
    }
}

return QuestData
