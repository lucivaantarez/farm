-- ==========================================
-- 0. PERFORMANCE & FPS CAP
-- ==========================================
pcall(function() setfpscap(10) end)

if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(3) 

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local mainFont = Enum.Font.SourceSansBold 
local uiDark = Color3.fromRGB(30, 30, 30)
local SmoothPlastic = Enum.Material.SmoothPlastic
local flatColor = Color3.fromRGB(150, 150, 150)

-- ==========================================
-- 1. THE RONIX BULLY & PROMPT KILLER
-- ==========================================
local afkGui = Instance.new("ScreenGui")
afkGui.Name = "FinalCompactAFK"
afkGui.IgnoreGuiInset = true
afkGui.DisplayOrder = 2147483647 
afkGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local function setParent()
    pcall(function() afkGui.Parent = CoreGui:FindFirstChild("RobloxGui") or CoreGui end)
end
setParent()

-- Safe Roblox menus we DO NOT want to hide
local coreWhitelist = {"RobloxGui", "RobloxNetworkPauseNotification", "ThemeProvider", "TeleportGui"}

task.spawn(function()
    while task.wait(1) do
        setParent()
        pcall(function()
            -- 1. Kill the Headset/Error Prompts completely
            local promptGui = CoreGui:FindFirstChild("RobloxPromptGui")
            if promptGui then promptGui.Enabled = false end

            -- 2. Hide Ronix/Delta UIs but protect Roblox's core engine
            for _, gui in pairs(CoreGui:GetChildren()) do
                if gui:IsA("ScreenGui") and gui ~= afkGui and not table.find(coreWhitelist, gui.Name) then
                    -- If the black screen is on, hide executor UIs
                    gui.Enabled = not afkGui:FindFirstChild("BlackScreen").Visible
                end
            end
        end)
    end
end)

-- ==========================================
-- 2. CLICK-PROOF DASHBOARD
-- ==========================================
local blackScreen = Instance.new("Frame")
blackScreen.Name = "BlackScreen"
blackScreen.Size = UDim2.new(1, 0, 1, 0)
blackScreen.BackgroundColor3 = Color3.new(0, 0, 0)
blackScreen.Active = true -- BLOCKS CLICKS FROM PASSING THROUGH
blackScreen.Parent = afkGui

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(1, 0, 1, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = ""
closeBtn.Active = true -- ABSORBS YOUR TAP
closeBtn.Parent = blackScreen

local container = Instance.new("Frame")
container.Size = UDim2.new(1, 0, 0.4, 0) 
container.Position = UDim2.new(0, 0, 0.6, 0)
container.BackgroundTransparency = 1
container.Parent = blackScreen

local listLayout = Instance.new("UIListLayout")
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
listLayout.Padding = UDim.new(0, 0) 
listLayout.Parent = container

local userLabel = Instance.new("TextLabel")
userLabel.Size = UDim2.new(1, 0, 0, 30)
userLabel.BackgroundTransparency = 1
userLabel.TextColor3 = Color3.new(0.7, 0.7, 0.7)
userLabel.TextSize = 25
userLabel.Font = mainFont
userLabel.Text = LocalPlayer.Name
userLabel.Parent = container

local mainInfoLabel = Instance.new("TextLabel")
mainInfoLabel.Size = UDim2.new(1, 0, 0, 60)
mainInfoLabel.BackgroundTransparency = 1
mainInfoLabel.TextColor3 = Color3.new(1, 1, 1)
mainInfoLabel.TextSize = 55 
mainInfoLabel.Font = mainFont
mainInfoLabel.Text = "0 | 00:00:00"
mainInfoLabel.Parent = container

local statLabel1 = Instance.new("TextLabel")
statLabel1.Size = UDim2.new(1, 0, 0, 35)
statLabel1.BackgroundTransparency = 1
statLabel1.TextColor3 = Color3.fromRGB(0, 255, 150)
statLabel1.TextSize = 30
statLabel1.Font = mainFont
statLabel1.Text = "A:0 | C:0"
statLabel1.Parent = container

local statLabel2 = Instance.new("TextLabel")
statLabel2.Size = UDim2.new(1, 0, 0, 35)
statLabel2.BackgroundTransparency = 1
statLabel2.TextColor3 = Color3.fromRGB(0, 255, 150)
statLabel2.TextSize = 30
statLabel2.Font = mainFont
statLabel2.Text = "M:0 | R:0"
statLabel2.Parent = container

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 100, 0, 50)
toggleBtn.Position = UDim2.new(1, -110, 0, 10)
toggleBtn.BackgroundColor3 = uiDark
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.TextSize = 20
toggleBtn.Font = mainFont
toggleBtn.Text = "AFK"
toggleBtn.Active = true
toggleBtn.Visible = false
toggleBtn.Parent = afkGui

closeBtn.MouseButton1Click:Connect(function()
    blackScreen.Visible = false
    toggleBtn.Visible = true
end)

toggleBtn.MouseButton1Click:Connect(function()
    blackScreen.Visible = true
    toggleBtn.Visible = false
end)

-- ==========================================
-- 3. GMT+7 TIME & NO-FREEZE INVENTORY TRACKER
-- ==========================================
local startOsTime = os.time()
local frameCounter = 0

RunService.Heartbeat:Connect(function() frameCounter = frameCounter + 1 end)

local function getQuantity(name, base)
    if string.find(string.lower(name), "untradable") then return 0 end
    local num = string.match(name, base .. " (%d+)")
    if num then return tonumber(num) end
    if string.find(name, base) then return 1 end
    return 0
end

local function updateEverything()
    local diff = os.time() - startOsTime
    local h = math.floor(diff / 3600)
    local m = math.floor((diff % 3600) / 60)
    local s = diff % 60
    mainInfoLabel.Text = string.format("%d | %02d:%02d:%02d", frameCounter, h, m, s)
    frameCounter = 0
    
    local c = {A=0, C=0, M=0, R=0}
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local char = LocalPlayer.Character
    
    local function check(folder)
        if not folder then return end
        for _, item in pairs(folder:GetChildren()) do
            local n = item.Name
            c.A = c.A + getQuantity(n, "Aura Crate")
            c.C = c.C + getQuantity(n, "Cosmetic Crate")
            c.M = c.M + getQuantity(n, "Mythical Chest")
            c.R = c.R + getQuantity(n, "Clan Reroll")
        end
    end
    
    check(backpack)
    check(char)
    
    statLabel1.Text = string.format("A:%d | C:%d", c.A, c.C)
    statLabel2.Text = string.format("M:%d | R:%d", c.M, c.R)
end

task.spawn(function()
    while true do
        if blackScreen.Visible then pcall(updateEverything) end
        task.wait(1)
    end
end)

-- ==========================================
-- 4. CLEANUP
-- ==========================================
local function optimize(obj)
    if obj:FindFirstAncestor(afkGui.Name) then return end
    pcall(function()
        if obj:IsA("BasePart") then
            obj.Material = SmoothPlastic; obj.Color = flatColor; obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("Sky") then
            obj:Destroy()
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            obj.Enabled = false
        end
    end)
end
for _, v in pairs(Workspace:GetDescendants()) do optimize(v) end
Workspace.DescendantAdded:Connect(optimize)
pcall(function() Lighting.FogEnd = 60 end)

print("Click-Proof Split-Screen Dashboard Active.")
