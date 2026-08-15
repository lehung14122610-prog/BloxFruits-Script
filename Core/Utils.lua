-- [ CORE: UTILS.LUA - FIX LAG, BLACK SCREEN & SERVER HOP ]
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera or Workspace:FindFirstChildOfClass("Camera")

local Utils = {}
local BlackScreenFrame = nil

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

function Utils.ToggleBlackScreen(state)
    if state then
        if not BlackScreenFrame then
            local pgui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer.PlayerGui
            local sg = Instance.new("ScreenGui")
            sg.Name = "BF_Hub_BlackScreen_Titan"
            sg.ResetOnSpawn = false
            sg.DisplayOrder = 999999
            sg.Parent = pgui
            
            BlackScreenFrame = Instance.new("Frame")
            BlackScreenFrame.Size = UDim2.new(1, 0, 1, 0)
            BlackScreenFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            BlackScreenFrame.Parent = sg
            
            local txt = Instance.new("TextLabel")
            txt.Parent = BlackScreenFrame
            txt.Size = UDim2.new(1, 0, 1, 0)
            txt.Text = "ULTRA BLACK SCREEN MODE - Nhap Icon Noi (🔥) de mo lai"
            txt.TextColor3 = Color3.fromRGB(0, 255, 170)
            txt.Font = Enum.Font.GothamBold
            txt.TextSize = 22
        end
        BlackScreenFrame.Visible = true
        game:GetService("RunService"):Set3dRenderingEnabled(false)
    else
        if BlackScreenFrame then BlackScreenFrame.Visible = false end
        game:GetService("RunService"):Set3dRenderingEnabled(true)
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
