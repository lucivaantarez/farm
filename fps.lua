-- ==========================================
-- 0. EXECUTOR-LEVEL FPS CAP
-- ==========================================
pcall(function() 
    setfpscap(10) -- Limits the game engine to 10 FPS to save Redfinger resources
end)

if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(2)
print("Starting Ultimate Codex AFK Script (10 FPS Cap Active)...")

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Terrain = Workspace.Terrain
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local SmoothPlastic = Enum.Material.SmoothPlastic
local flatColor = Color3.fromRGB(150, 150, 150)
local uiDark = Color3.fromRGB(30, 30, 30)
local mainFont = Enum.Font.SourceSansBold 
local os_clock = os.clock
local task_wait = task.wait
local pcall_func = pcall

-- ==========================================
-- 1. GRAPHICS, AUDIO & PHYSICS THROTTLE
-- ==========================================
pcall_func(function() 
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 
    UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1 
    UserSettings():GetService("UserGameSettings").MasterVolume = 0 
    SoundService.AmbientReverb = Enum.ReverbType.NoReverb 
    settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Skip3
    settings().Physics.AllowSleep = true
end)

-- ==========================================
-- 2. TOP-LAYER DPI CUSTOM DASHBOARD
-- ==========================================
local startOsTime = os.time()
-- Hardcoded GMT+7 calculation for Indonesian Time (dd/mm/hh:mm)
local lastExecutedStr = os.date("!%d/%m/%H:%M", os.time() + (7 * 3600)) 
local cleanUsername = LocalPlayer and LocalPlayer.Name or "Unknown"

local afkGui = Instance.new("ScreenGui")
afkGui.Name = "CodexAFK"
afkGui.IgnoreGuiInset = true
afkGui.DisplayOrder = 2147483647 -- Absolute Max (Above Ronix UI)
afkGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

if not pcall_func(function() afkGui.Parent = CoreGui end) then
    afkGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local blackScreen = Instance.new("TextButton")
blackScreen.Size = UDim2.new(1, 0, 1, 0)
blackScreen.BackgroundColor3 = Color3.new(0, 0, 0)
blackScreen.Text = ""
blackScreen.ZIndex = 10
blackScreen.AutoButtonColor = false
blackScreen.Parent = afkGui

local container = Instance.new("Frame")
container.Size = UDim2.new(1, 0, 1, 0)
container.BackgroundTransparency = 1
container.ZIndex = 11
container.Parent = blackScreen

local listLayout = Instance.new("UIListLayout")
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
listLayout.Padding = UDim.new(0, 0) 
listLayout.Parent = container

-- LINE 1: USERNAME (Size 35)
local userLabel = Instance.new("TextLabel")
userLabel.Size = UDim2.new(1, 0, 0, 40)
userLabel.BackgroundTransparency = 1
userLabel.TextColor3 = Color3.new(1, 1, 1)
userLabel.TextSize = 35
userLabel.Font = mainFont
userLabel.ZIndex = 12
userLabel.Text = cleanUsername
userLabel.Parent = container

-- LINE 2: FPS | UPTIME (Size 70)
local mainInfoLabel = Instance.new("TextLabel")
mainInfoLabel.Size = UDim2.new(1, 0, 0, 80) 
mainInfoLabel.BackgroundTransparency = 1
mainInfoLabel.TextColor3 = Color3.new(1, 1, 1)
mainInfoLabel.TextSize = 70 
mainInfoLabel.Font = mainFont
mainInfoLabel.ZIndex = 12
mainInfoLabel.Text = "0 | 00:00:00"
mainInfoLabel.Parent = container

-- LINE 3: DATE (GMT+7 Style)
local dateLabel = Instance.new("TextLabel")
dateLabel.Size = UDim2.new(1, 0, 0, 40)
dateLabel.BackgroundTransparency = 1
dateLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
dateLabel.TextSize = 35
dateLabel.Font = mainFont
dateLabel.ZIndex = 12
dateLabel.Text = lastExecutedStr
dateLabel.Parent = container

-- AFK TOGGLE BUTTON
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 160, 0, 80)
toggleBtn.AnchorPoint = Vector2.new(1, 0)
toggleBtn.Position = UDim2.new(1, -30, 0, 30)
toggleBtn.BackgroundColor3 = uiDark
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.TextSize = 35
toggleBtn.Font = mainFont
toggleBtn.ZIndex = 2147483647
toggleBtn.Text = "AFK"
toggleBtn.BorderSizePixel = 0
toggleBtn.Visible = false
toggleBtn.Parent = afkGui

local function setBlackScreen(state)
    blackScreen.Visible = state
    toggleBtn.Visible = not state
    pcall_func(function() RunService:Set3dRenderingEnabled(not state) end)
end

blackScreen.MouseButton1Click:Connect(function() setBlackScreen(false) end)
toggleBtn.MouseButton1Click:Connect(function() setBlackScreen(true) end)

setBlackScreen(true)

-- Live Logic Loop
local frames = 0
RunService.Heartbeat:Connect(function() frames = frames + 1 end)

task.spawn(function()
    while task_wait(1) do
        if blackScreen.Visible then
            local diff = os.time() - startOsTime
            local h = math.floor(diff / 3600)
            local m = math.floor((diff % 3600) / 60)
            local s = diff % 60
            mainInfoLabel.Text = string.format("%d | %02d:%02d:%02d", frames, h, m, s)
        end
        frames = 0 
    end
end)

-- ==========================================
-- 3. WORLD OPTIMIZATION & CLEANUP
-- ==========================================
local ClassActions = {
    ["Sound"] = function(o) o.Playing = false; o.Volume = 0 end,
    ["Shirt"] = function(o) o:Destroy() end,
    ["Pants"] = function(o) o:Destroy() end,
    ["ShirtGraphic"] = function(o) o:Destroy() end,
    ["BodyColors"] = function(o) o:Destroy() end,
    ["CharacterMesh"] = function(o) o:Destroy() end,
    ["SurfaceAppearance"] = function(o) o:Destroy() end, 
    ["UICorner"] = function(o) o:Destroy() end,
    ["UIStroke"] = function(o) o:Destroy() end,
    ["UIGradient"] = function(o) o:Destroy() end,
    ["UIShadow"] = function(o) o:Destroy() end,
    ["Clouds"] = function(o) o:Destroy() end,
    ["Atmosphere"] = function(o) o:Destroy() end,
    ["Sky"] = function(o) if o.Name ~= "VoidSky" then o:Destroy() end end,
    ["PostEffect"] = function(o) o.Enabled = false end,
    ["ParticleEmitter"] = function(o) 
        o.Enabled = false; o.Texture = "" 
        pcall_func(function() o.Size = NumberSequence.new(0) end)
        pcall_func(function() o:Clear() end) 
    end,
    ["Trail"] = function(o) o.Enabled = false; o.Texture = "" end,
    ["Beam"] = function(o) o.Enabled = false; o.Texture = "" end,
    ["Fire"] = function(o) o.Enabled = false; o.Size = 0 end,
    ["Smoke"] = function(o) o.Enabled = false; o.Size = 0 end,
    ["Highlight"] = function(o) o.Enabled = false end,
    ["PointLight"] = function(o) o.Enabled = false end,
    ["Texture"] = function(o) o.Texture = ""; o.Transparency = 1 end,
    ["Decal"] = function(o) o.Texture = ""; o.Transparency = 1 end,
    ["SpecialMesh"] = function(o) pcall_func(function() o.TextureId = "" end) end,
}

local function optimizeObject(obj)
    if obj:FindFirstAncestor("CodexAFK") or obj.Name == "CodexAFK" then return end
    pcall_func(function()
        local action = ClassActions[obj.ClassName]
        if action then
            action(obj)
        elseif obj:IsA("BasePart") then
            if obj.Transparency < 1 then
                obj.Material = SmoothPlastic
                obj.Color = flatColor
                obj.CastShadow = false
            end
        end
    end)
end

pcall_func(function()
    Lighting.ClockTime = 0
    Lighting.Brightness = 0
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 60 
    Lighting.Ambient = flatColor
    Lighting.OutdoorAmbient = flatColor
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterColor = flatColor
    local blankSky = Instance.new("Sky")
    blankSky.Name = "VoidSky"
    blankSky.CelestialBodiesShown = false
    blankSky.Parent = Lighting
end)

local startTimeExec = os_clock()
for _, obj in ipairs(Workspace:GetDescendants()) do
    optimizeObject(obj)
    if os_clock() - startTimeExec > 0.015 then
        task_wait()
        startTimeExec = os_clock()
    end
end

Workspace.DescendantAdded:Connect(optimizeObject)
Lighting.DescendantAdded:Connect(optimizeObject)

task.spawn(function()
    if LocalPlayer then
        local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
        if playerGui then
            for _, uiObj in ipairs(playerGui:GetDescendants()) do optimizeObject(uiObj) end
            playerGui.DescendantAdded:Connect(optimizeObject)
        end
    end
end)

task.spawn(function()
    while task_wait(3) do
        pcall_func(function()
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    for _, obj in ipairs(player.Character:GetDescendants()) do optimizeObject(obj) end
                end
            end
            if Workspace.CurrentCamera then
                for _, obj in ipairs(Workspace.CurrentCamera:GetDescendants()) do optimizeObject(obj) end
            end
            for _, obj in ipairs(Terrain:GetChildren()) do optimizeObject(obj) end
            for _, obj in ipairs(Lighting:GetChildren()) do optimizeObject(obj) end
        end)
    end
end)

print("10 FPS Limit Dashboard Running.")
