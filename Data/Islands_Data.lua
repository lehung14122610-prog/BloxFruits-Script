--[[
    ===================================================================================
    ★ DATA: ISLANDS_DATA.LUA - TOẠ ĐỘ ĐẢO & BOSS ĐẦY ĐỦ 3 SEA ★
    ===================================================================================
--]]

local Data = {}

Data.Islands = {
    -- SEA 1
    ["Starter Pirate Island"] = Vector3.new(1059, 16, 1550),
    ["Starter Marine Island"] = Vector3.new(-2568, 7, 2045),
    ["Jungle Island"] = Vector3.new(-1598, 36, 153),
    ["Pirate Village"] = Vector3.new(-1140, 4, 3828),
    ["Desert Island"] = Vector3.new(896, 6, 4388),
    ["Frozen Village"] = Vector3.new(1385, 87, -1298),
    ["Marine Fortress"] = Vector3.new(-5039, 27, 4324),
    ["Skylands (Lower)"] = Vector3.new(-4840, 717, -2623),
    ["Skylands (Upper)"] = Vector3.new(-7860, 5545, -380),
    ["Prison"] = Vector3.new(5308, 2, 474),
    ["Colosseum"] = Vector3.new(-1580, 7, -2980),
    ["Magma Village"] = Vector3.new(-5315, 12, 8515),
    ["Underwater City"] = Vector3.new(61122, 18, 1567),
    ["Fountain City"] = Vector3.new(5258, 38, 4050),
    ["Mob Island"] = Vector3.new(-2850, 7, 5300),

    -- SEA 2
    ["Kingdom of Rose"] = Vector3.new(-427, 73, 1836),
    ["Kingdom of Rose (Mansion)"] = Vector3.new(-290, 306, -200),
    ["Green Zone"] = Vector3.new(-2440, 73, -3220),
    ["Graveyard Island"] = Vector3.new(-5490, 48, -795),
    ["Snow Mountain"] = Vector3.new(605, 401, -5370),
    ["Hot and Cold (Hot)"] = Vector3.new(-502, 15, -5334),
    ["Hot and Cold (Cold)"] = Vector3.new(-1490, 15, -5040),
    ["Cursed Ship"] = Vector3.new(1038, 125, 32910),
    ["Ice Castle"] = Vector3.new(5670, 28, -6480),
    ["Forgotten Island"] = Vector3.new(-3055, 239, -10145),
    ["Dark Arena"] = Vector3.new(3800, 15, -3500),
    ["Usopp's Island"] = Vector3.new(4800, 8, 2800),

    -- SEA 3
    ["Port Town"] = Vector3.new(-290, 6, 5343),
    ["Hydra Island"] = Vector3.new(5833, 52, -1100),
    ["Great Tree"] = Vector3.new(2180, 28, -6740),
    ["Floating Turtle (Mansion)"] = Vector3.new(-12463, 375, -7551),
    ["Floating Turtle (Forest)"] = Vector3.new(-13274, 332, -7926),
    ["Haunted Castle"] = Vector3.new(-9514, 142, 5535),
    ["Sea of Treats (Peanut)"] = Vector3.new(-2100, 38, -10150),
    ["Sea of Treats (Ice Cream)"] = Vector3.new(245, 25, -12200),
    ["Sea of Treats (Cake)"] = Vector3.new(-2000, 38, -12000),
    ["Tiki Outpost"] = Vector3.new(-16235, 9, 413),
    ["Tiki Outpost Heights"] = Vector3.new(-16600, 25, 1200),
    ["Dragon Sanctuary"] = Vector3.new(-18200, 45, -2500),
    ["Celestial Peak"] = Vector3.new(-19200, 80, -3200),
    ["Kitsune Island"] = Vector3.new(-22000, 10, -5000),
    ["Mirage Island"] = Vector3.new(-15000, 10, -15000)
}

Data.Bosses = {
    -- SEA 1 BOSSES
    ["The Gorilla King [Lv. 25]"] = Vector3.new(-1128, 6, -451),
    ["Bobby The Clown [Lv. 55]"] = Vector3.new(-1141, 14, 4134),
    ["The Saw [Lv. 100]"] = Vector3.new(-682, 15, 1582),
    ["Yeti [Lv. 110]"] = Vector3.new(1185, 106, -1518),
    ["Mob Leader [Lv. 120]"] = Vector3.new(-2850, 7, 5300),
    ["Vice Admiral [Lv. 130]"] = Vector3.new(-4807, 21, 4360),
    ["Saber Expert [Lv. 200]"] = Vector3.new(-1461, 30, -51),
    ["Warden [Lv. 220]"] = Vector3.new(5230, 2, 475),
    ["Chief Warden [Lv. 230]"] = Vector3.new(5230, 2, 475),
    ["Swan [Lv. 240]"] = Vector3.new(5230, 2, 475),
    ["Magma Admiral [Lv. 350]"] = Vector3.new(-5694, 18, 8735),
    ["Fishman Lord [Lv. 425]"] = Vector3.new(61350, 18, 1465),
    ["Wysper [Lv. 500]"] = Vector3.new(-7927, 5550, -637),
    ["Thunder God [Lv. 575]"] = Vector3.new(-7748, 5607, -2306),
    ["Cyborg [Lv. 675]"] = Vector3.new(61163, 18, 802),

    -- SEA 2 BOSSES
    ["Diamond [Lv. 750]"] = Vector3.new(-1583, 198, -31),
    ["Jeremy [Lv. 850]"] = Vector3.new(2316, 449, 787),
    ["Fajita [Lv. 925]"] = Vector3.new(-2086, 73, -2678),
    ["Don Swan [Lv. 1000]"] = Vector3.new(2288, 15, 808),
    ["Smoke Admiral [Lv. 1150]"] = Vector3.new(-5078, 24, -5352),
    ["Awakened Ice Admiral [Lv. 1400]"] = Vector3.new(6474, 297, -6854),
    ["Tide Keeper [Lv. 1475]"] = Vector3.new(-3711, 77, -11468),
    ["Order / Law [Raid Boss]"] = Vector3.new(-6500, 250, -150),
    ["Darkbeard [Lv. 1000]"] = Vector3.new(3800, 15, -3500),

    -- SEA 3 BOSSES
    ["Stone [Lv. 1550]"] = Vector3.new(-1049, 40, 6791),
    ["Island Empress [Lv. 1675]"] = Vector3.new(5730, 602, 199),
    ["Kilo Admiral [Lv. 1750]"] = Vector3.new(2889, 424, -7233),
    ["Captain Elephant [Lv. 1875]"] = Vector3.new(-13393, 319, -8423),
    ["Beautiful Pirate [Lv. 1950]"] = Vector3.new(5132, 59, 396),
    ["Soul Reaper [Lv. 2100]"] = Vector3.new(-9514, 142, 5535),
    ["Cake Queen [Lv. 2175]"] = Vector3.new(-710, 382, -11150),
    ["Dough King [Lv. 2300]"] = Vector3.new(-2100, 38, -12000),
    ["Cake Prince [Lv. 2300]"] = Vector3.new(-2100, 38, -12000),
    ["Rip Indra [Lv. 5000]"] = Vector3.new(-5400, 313, -2800),
    ["Leviathan [Sea Event]"] = Vector3.new(-25000, 20, -10000)
}

return Data
