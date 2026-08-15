-- [ MODULES: SEA2.LUA - AUTO RAID DUNGEON & FACTORY ROUTINES ]
local Sea2Module = {}

function Sea2Module.Init(UI, Config, Network, Movement, IslandsData)
    local TabSea2 = UI.CreateTab("Sea 2 Raids", "⚔️")
    
    UI.AddSection(TabSea2, "Raid Dungeon & Thức Tỉnh Trái")
    local chipChoice = "Flame"
    UI.AddDropdown(TabSea2, "Chọn Chip Raid:", {"Flame", "Ice", "Quake", "Light", "Dark", "String", "Rumble", "Magma", "Buddha", "Dough"}, function(v) chipChoice = v end)
    UI.AddButton(TabSea2, "💳 Mua Chip Raid Tự Động", function()
        Network.InvokeCommF("RaidsNpc", "Select", chipChoice)
    end)
    UI.AddButton(TabSea2, "🚀 Bắt Đầu Raid (Start Raid)", function()
        Network.InvokeCommF("RaidsNpc", "Start")
    end)
    
    UI.AddSection(TabSea2, "Race V2 (Tìm Hoa Tự Động)")
    UI.AddButton(TabSea2, "🌸 Tự Động Nhặt Hoa Đỏ / Xanh", function()
        for _, v in pairs(game:GetService("Workspace"):GetChildren()) do
            if v.Name == "Flower1" or v.Name == "Flower2" then
                Movement.TweenTo(v.CFrame * CFrame.new(0, 3, 0), 300)
                task.wait(0.5)
            end
        end
    end)
end

return Sea2Module
