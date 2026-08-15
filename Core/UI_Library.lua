-- [ CORE: UI_LIBRARY.LUA - FLUENT REDZ SUPREME GLASSMORPHISM V8.0 ]
local Players = game:GetService("Players")
local StatsService = game:GetService("Stats")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()

local function GetUIContainer()
    local pgui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:FindFirstChild("PlayerGui")
    if pgui then return pgui end
    local container = nil
    pcall(function()
        if gethui then container = gethui() end
    end)
    return container or LocalPlayer:WaitForChild("PlayerGui", 10) or LocalPlayer.PlayerGui
end

local parentUI = GetUIContainer()

pcall(function()
    if parentUI:FindFirstChild("BF_Ultimate_Hub_Titan") then
        parentUI.BF_Ultimate_Hub_Titan:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BF_Ultimate_Hub_Titan"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = parentUI

-- 1. NÚT ICON NỔI MOBILE TOGGLE (🔥) DRAGGABLE VỚI HIỆU ỨNG GLOW
local MobileFloatingBtn = Instance.new("TextButton")
MobileFloatingBtn.Name = "MobileToggleIcon"
MobileFloatingBtn.Size = UDim2.new(0, 50, 0, 50)
MobileFloatingBtn.Position = UDim2.new(0, 15, 0.20, 0)
MobileFloatingBtn.BackgroundColor3 = Color3.fromRGB(12, 16, 24)
MobileFloatingBtn.Text = "⚡"
MobileFloatingBtn.TextColor3 = Color3.fromRGB(0, 235, 255)
MobileFloatingBtn.TextSize = 22
MobileFloatingBtn.ZIndex = 10000000
MobileFloatingBtn.Active = true
MobileFloatingBtn.Draggable = true
MobileFloatingBtn.Parent = ScreenGui

local MobileBtnCorner = Instance.new("UICorner")
MobileBtnCorner.CornerRadius = UDim.new(1, 0)
MobileBtnCorner.Parent = MobileFloatingBtn

local MobileBtnStroke = Instance.new("UIStroke")
MobileBtnStroke.Color = Color3.fromRGB(0, 220, 255)
MobileBtnStroke.Thickness = 2.2
MobileBtnStroke.Parent = MobileFloatingBtn

-- 2. KHUNG CHÍNH FLUENT GLASSMORPHISM (MAIN FRAME)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 390)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -195)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 13, 19)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 500
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(30, 38, 56)
MainStroke.Thickness = 1.6
MainStroke.Parent = MainFrame

MobileFloatingBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- 3. THANH TIÊU ĐỀ & HUD DASHBOARD REAL-TIME (HEADER HUD)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundColor3 = Color3.fromRGB(16, 20, 30)
TitleBar.ZIndex = 501
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.Size = UDim2.new(0, 230, 1, 0)
TitleText.Position = UDim2.new(0, 14, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "⚡ BLOX FRUITS TITAN V8.0"
TitleText.TextColor3 = Color3.fromRGB(0, 235, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 14
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.ZIndex = 502

-- HUD FPS & Ping & Sea
local HudContainer = Instance.new("Frame")
HudContainer.Size = UDim2.new(0, 240, 1, -12)
HudContainer.Position = UDim2.new(1, -290, 0, 6)
HudContainer.BackgroundColor3 = Color3.fromRGB(22, 28, 42)
HudContainer.ZIndex = 502
HudContainer.Parent = TitleBar

local HudCorner = Instance.new("UICorner")
HudCorner.CornerRadius = UDim.new(0, 6)
HudCorner.Parent = HudContainer

local HudLabel = Instance.new("TextLabel")
HudLabel.Size = UDim2.new(1, 0, 1, 0)
HudLabel.BackgroundTransparency = 1
HudLabel.Text = "FPS: 60 | PING: 45ms | SEA " .. (game.PlaceId == 2753915549 and "1" or game.PlaceId == 4442272183 and "2" or "3")
HudLabel.TextColor3 = Color3.fromRGB(0, 255, 180)
HudLabel.Font = Enum.Font.GothamMedium
HudLabel.TextSize = 11
HudLabel.ZIndex = 503
HudLabel.Parent = HudContainer

-- Live FPS Counter Loop
task.spawn(function()
    local lastUpdate = tick()
    local frameCount = 0
    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        if tick() - lastUpdate >= 1 then
            local fps = frameCount
            frameCount = 0
            lastUpdate = tick()
            local ping = 45
            pcall(function()
                ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            local seaNum = game.PlaceId == 2753915549 and "1" or game.PlaceId == 4442272183 and "2" or "3"
            HudLabel.Text = "FPS: " .. fps .. " | PING: " .. ping .. "ms | SEA " .. seaNum
        end
    end)
end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(235, 55, 65)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.ZIndex = 502

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- 4. SIDEBAR VỚI AVATAR PROFILE CARD
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 170, 1, -44)
Sidebar.Position = UDim2.new(0, 0, 0, 44)
Sidebar.BackgroundColor3 = Color3.fromRGB(9, 11, 16)
Sidebar.ZIndex = 501
Sidebar.Parent = MainFrame

local ProfileCard = Instance.new("Frame")
ProfileCard.Size = UDim2.new(1, -12, 0, 58)
ProfileCard.Position = UDim2.new(0, 6, 0, 6)
ProfileCard.BackgroundColor3 = Color3.fromRGB(16, 20, 30)
ProfileCard.ZIndex = 502
ProfileCard.Parent = Sidebar

local ProfileCorner = Instance.new("UICorner")
ProfileCorner.CornerRadius = UDim.new(0, 8)
ProfileCorner.Parent = ProfileCard

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 38, 0, 38)
AvatarImg.Position = UDim2.new(0, 6, 0, 10)
AvatarImg.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
AvatarImg.ZIndex = 503
AvatarImg.Parent = ProfileCard

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImg

pcall(function()
    AvatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.AvatarHeadShot, Enum.ThumbnailSize.Size100x100)
end)

local ProfileName = Instance.new("TextLabel")
ProfileName.Size = UDim2.new(1, -52, 0, 16)
ProfileName.Position = UDim2.new(0, 48, 0, 10)
ProfileName.BackgroundTransparency = 1
ProfileName.Text = tostring(LocalPlayer.DisplayName or LocalPlayer.Name)
ProfileName.TextColor3 = Color3.fromRGB(240, 240, 240)
ProfileName.Font = Enum.Font.GothamBold
ProfileName.TextSize = 12
ProfileName.TextXAlignment = Enum.TextXAlignment.Left
ProfileName.TextTruncate = Enum.TextTruncate.AtEnd
ProfileName.ZIndex = 503
ProfileName.Parent = ProfileCard

local ProfileStat = Instance.new("TextLabel")
ProfileStat.Size = UDim2.new(1, -52, 0, 14)
ProfileStat.Position = UDim2.new(0, 48, 0, 28)
ProfileStat.BackgroundTransparency = 1
local curLvl = (LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level")) and LocalPlayer.Data.Level.Value or 1
ProfileStat.Text = "Lv. " .. tostring(curLvl) .. " / 2800"
ProfileStat.TextColor3 = Color3.fromRGB(0, 220, 255)
ProfileStat.Font = Enum.Font.GothamMedium
ProfileStat.TextSize = 11
ProfileStat.TextXAlignment = Enum.TextXAlignment.Left
ProfileStat.ZIndex = 503
ProfileStat.Parent = ProfileCard

task.spawn(function()
    while task.wait(3) do
        pcall(function()
            local l = (LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level")) and LocalPlayer.Data.Level.Value or 1
            ProfileStat.Text = "Lv. " .. tostring(l) .. " / 2800"
        end)
    end
end)

-- Sidebar Tabs Container
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(1, 0, 1, -74)
TabContainer.Position = UDim2.new(0, 0, 0, 70)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 2
TabContainer.ZIndex = 502
TabContainer.Parent = Sidebar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabContainer
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 4)

-- 5. VÙNG NỘI DUNG CHÍNH (CONTENT AREA)
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -180, 1, -52)
ContentArea.Position = UDim2.new(0, 175, 0, 48)
ContentArea.BackgroundTransparency = 1
ContentArea.ZIndex = 501
ContentArea.Parent = MainFrame

local Pages = {}
local TabButtons = {}

local UILibrary = {}

function UILibrary.CreateTab(name, icon)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -10, 0, 34)
    tabBtn.Position = UDim2.new(0, 5, 0, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
    tabBtn.Text = (icon or "📁") .. " " .. name
    tabBtn.TextColor3 = Color3.fromRGB(180, 190, 210)
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextSize = 12
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.ZIndex = 503
    tabBtn.Parent = TabContainer
    
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 8)
    pad.Parent = tabBtn
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabBtn
    
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -6, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
    page.Visible = false
    page.ZIndex = 502
    page.Parent = ContentArea
    
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Parent = page
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 6)
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, b in pairs(TabButtons) do 
            b.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
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

function UILibrary.AddSection(parent, title)
    local sec = Instance.new("Frame")
    sec.Size = UDim2.new(1, -8, 0, 24)
    sec.BackgroundTransparency = 1
    sec.ZIndex = 503
    sec.Parent = parent
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "─── " .. title:upper() .. " ───"
    lbl.TextColor3 = Color3.fromRGB(0, 200, 255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.ZIndex = 504
    lbl.Parent = sec
end

function UILibrary.AddToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -8, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
    frame.ZIndex = 503
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(30, 36, 50)
    stroke.Thickness = 1
    stroke.Parent = frame
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -65, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(240, 245, 255)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 504
    lbl.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 46, 0, 22)
    btn.Position = UDim2.new(1, -54, 0.5, -11)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 210, 120) or Color3.fromRGB(48, 54, 70)
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.ZIndex = 504
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 210, 120) or Color3.fromRGB(48, 54, 70)
        btn.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

function UILibrary.AddButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(0, 135, 240)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.ZIndex = 503
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

function UILibrary.AddSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -8, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
    frame.ZIndex = 503
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(30, 36, 50)
    stroke.Thickness = 1
    stroke.Parent = frame
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 0, 18)
    lbl.Position = UDim2.new(0, 10, 0, 2)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. tostring(default)
    lbl.TextColor3 = Color3.fromRGB(240, 245, 255)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 504
    lbl.Parent = frame
    
    local sliderBg = Instance.new("TextButton")
    sliderBg.Size = UDim2.new(1, -20, 0, 8)
    sliderBg.Position = UDim2.new(0, 10, 0, 26)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 46, 62)
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

function UILibrary.AddDropdown(parent, text, options, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -8, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
    frame.ZIndex = 503
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(30, 36, 50)
    stroke.Thickness = 1
    stroke.Parent = frame
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.42, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(240, 245, 255)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 504
    lbl.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.54, -8, 0, 24)
    btn.Position = UDim2.new(0.46, 0, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(28, 34, 48)
    btn.Text = options[1] or "Select"
    btn.TextColor3 = Color3.fromRGB(0, 220, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.ZIndex = 504
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    local currentIndex = 1
    btn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex + 1
        if currentIndex > #options then currentIndex = 1 end
        btn.Text = options[currentIndex]
        callback(options[currentIndex])
    end)
end

return UILibrary
