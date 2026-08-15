-- [ CORE: UTILS.LUA - FIX LAG, BLACK SCREEN WITH VISIBLE BUTTON & SERVER HOP ]
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera or Workspace:FindFirstChildOfClass("Camera")

local Utils = {}
local BlackScreenGui = nil

function Utils.ApplyUltraFixLag()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.CastShadow = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end
    end)
end

-- SỬA LỖI ULTRA BLACK SCREEN (NÚT BẤM TO NỔI BẬT LỚP TỐI CAO)
function Utils.ToggleBlackScreen(state)
    if state then
        if not BlackScreenGui then
            local pgui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer.PlayerGui
            BlackScreenGui = Instance.new("ScreenGui")
            BlackScreenGui.Name = "BF_Titan_UltraBlackScreen_V8"
            BlackScreenGui.ResetOnSpawn = false
            BlackScreenGui.DisplayOrder = 10000000 -- Lớp tối cao
            BlackScreenGui.IgnoreGuiInset = true
            BlackScreenGui.Parent = pgui
            
            local bg = Instance.new("Frame")
            bg.Size = UDim2.new(1, 0, 1, 0)
            bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            bg.Parent = BlackScreenGui
            
            local btnExit = Instance.new("TextButton")
            btnExit.Size = UDim2.new(0, 320, 0, 65)
            btnExit.Position = UDim2.new(0.5, -160, 0.5, -32)
            btnExit.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
            btnExit.Text = "🌙 ULTRA BLACK SCREEN (TREO ĐÊM)
[CHẠM VÀO ĐÂY ĐỂ MỞ LẠI GIAO DIỆN]"
            btnExit.TextColor3 = Color3.fromRGB(0, 255, 180)
            btnExit.Font = Enum.Font.GothamBold
            btnExit.TextSize = 13
            btnExit.Parent = bg
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 10)
            btnCorner.Parent = btnExit
            
            local btnStroke = Instance.new("UIStroke")
            btnStroke.Color = Color3.fromRGB(0, 220, 255)
            btnStroke.Thickness = 2
            btnStroke.Parent = btnExit
            
            btnExit.MouseButton1Click:Connect(function()
                Utils.ToggleBlackScreen(false)
                if getgenv().BF_Hub_Config then
                    getgenv().BF_Hub_Config.BlackScreen = false
                end
            end)
        end
        BlackScreenGui.Enabled = true
        RunService:Set3dRenderingEnabled(false)
    else
        if BlackScreenGui then BlackScreenGui.Enabled = false end
        RunService:Set3dRenderingEnabled(true)
    end
end

function Utils.RejoinServer()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end

function Utils.ServerHop()
    pcall(function()
        local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local list = game:GetService("HttpService"):JSONDecode(game:HttpGet(Api))
        if list and list.data then
            for _, s in pairs(list.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                    break
                end
            end
        end
    end)
end

LocalPlayer.Idled:Connect(function()
    local cfg = getgenv().BF_Hub_Config
    if cfg and cfg.AntiAFK then
        pcall(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
        end)
    end
end)

return Utils
