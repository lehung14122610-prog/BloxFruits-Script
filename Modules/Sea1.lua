-- [ MODULES: SEA1.LUA - SEA 1 LOGIC & QUEST SOLVER ]
local Sea1Module = {}

function Sea1Module.Init(UI, Config, Network, Movement, IslandsData)
    local TabSea1 = UI.CreateTab("Sea 1 Quests", "🌴")
    
    UI.AddSection(TabSea1, "Saber Expert Secret Quest")
    UI.AddButton(TabSea1, "🗡️ Tự Động Giải Đố Mở Cửa Saber", function()
        pcall(function()
            local buttons = {
                CFrame.new(-1598, 37, 153),
                CFrame.new(-1450, 37, 200),
                CFrame.new(-1300, 37, 300),
                CFrame.new(-1200, 37, 400),
                CFrame.new(-1100, 37, 500)
            }
            for _, btnCF in ipairs(buttons) do
                Movement.TweenTo(btnCF)
                task.wait(0.5)
            end
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Saber Quest",
                Text = "Đã nhấn 5 nút bí mật mở cửa Saber!",
                Duration = 4
            })
        end)
    end)
    
    UI.AddSection(TabSea1, "Dịch Chuyển Khu Vực Đặc Biệt")
    UI.AddButton(TabSea1, "☁️ Lên Đảo Trên Trời (Skylands)", function()
        Movement.SafeWayPointTween(CFrame.new(-7902, 5580, -383))
    end)
    UI.AddButton(TabSea1, "🌊 Xuống Thành Phố Dưới Nước (Underwater)", function()
        Movement.SafeWayPointTween(CFrame.new(3864, 5, -1926))
    end)
end

return Sea1Module
