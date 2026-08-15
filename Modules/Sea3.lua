-- [ MODULES: SEA3.LUA - KITSUNE, LEVIATHAN, MIRAGE & RACE V4 ]
local Sea3Module = {}

function Sea3Module.Init(UI, Config, Network, Movement, IslandsData)
    local TabSea3 = UI.CreateTab("Sea 3 Events", "🦊")
    
    UI.AddSection(TabSea3, "Mirage Island & Race V4")
    UI.AddButton(TabSea3, "🏝️ Bay Đến Đảo Mirage (Nếu Có)", function()
        local ws = game:GetService("Workspace")
        local mirage = ws:FindFirstChild("MirageIsland") or ws:FindFirstChild("Mirage Island")
        if mirage and mirage:FindFirstChild("Center") then
            Movement.SafeWayPointTween(mirage.Center.CFrame + Vector3.new(0, 60, 0))
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Mirage Tracker",
                Text = "Không tìm thấy Đảo Mirage trên Server!",
                Duration = 3
            })
        end
    end)
    
    UI.AddButton(TabSea3, "⚙️ Tìm Bánh Răng Mirage (Gear)", function()
        local ws = game:GetService("Workspace")
        local mirage = ws:FindFirstChild("MirageIsland") or ws:FindFirstChild("Mirage Island")
        if mirage and mirage:FindFirstChild("Gear") then
            Movement.SafeWayPointTween(mirage.Gear.CFrame)
        end
    end)
    
    UI.AddSection(TabSea3, "Kitsune & Leviathan")
    UI.AddButton(TabSea3, "🦊 Tìm Đảo Kitsune", function()
        local ws = game:GetService("Workspace")
        local kitsune = ws:FindFirstChild("KitsuneIsland") or ws:FindFirstChild("Kitsune Island")
        if kitsune then
            Movement.SafeWayPointTween(kitsune:GetModelCFrame() + Vector3.new(0, 60, 0))
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Kitsune Tracker",
                Text = "Chưa xuất hiện Đảo Kitsune!",
                Duration = 3
            })
        end
    end)
end

return Sea3Module
