-- ==========================================
-- 0. PERFORMANCE & LAYER ENFORCEMENT
-- ==========================================
pcall(function() setfpscap(10) end)

if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(2)

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local SmoothPlastic = Enum.Material.SmoothPlastic
local flatColor = Color3.fromRGB(150, 150, 150)
local mainFont = Enum.Font.SourceSansBold 
local uiDark = Color3.fromRGB(30, 30, 30)

-- THE RONIX BULLY (Forces UI to stay on top of Ronix/Delta)
local afkGui = Instance.new("ScreenGui")
afkGui.Name = "SystemAFK_Bottom"
afkGui.IgnoreGuiInset = true
afkGui.DisplayOrder = 2147483647 
afkGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

task.spawn(function()
    while task.wait(0.5) do
        afkGui.DisplayOrder = 2147483647
        pcall(function()
            if afkGui.Parent ~= CoreGui then afkGui.Parent = CoreGui end
            for _, gui in pairs(CoreGui:GetChildren()) do
                if gui:IsA("ScreenGui") and gui.Name ~= afkGui.Name then
                    if gui.DisplayOrder >= 1 then
                        gui.DisplayOrder = 0
                        gui.Enabled = false 
                    end
                end
            end
        end)
    end
end)

-- ==========================================
-- 2. BOTTOM-ANCHORED COMPACT DASHBOARD
-- ==========================================
local blackScreen = Instance.new("TextButton")
blackScreen.Size = UDim2.new(1, 0, 1, 0)
blackScreen.BackgroundColor3 = Color3.new(0, 0, 0)
blackScreen.Text = ""
blackScreen.AutoButtonColor = false
blackScreen.Parent = afkGui

local container = Instance.new("Frame")
container.Size = UDim2.new(1, 0, 0.4, 0) 
container.Position = UDim2.new(0, 0, 0.6, 0) -- ANCHORED TO BOTTOM
container.BackgroundTransparency = 1
container.Parent = blackScreen

local listLayout = Instance.new("UIListLayout")
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom -- PUSHES TO BOTTOM
listLayout.Padding = UDim.new(0, -2) 
listLayout.Parent = container

-- LINE 1: USERNAME (Size 30)
local userLabel = Instance.new("TextLabel")
userLabel.Size = UDim2.new(1, 0, 0, 35)
userLabel.BackgroundTransparency = 1
userLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
userLabel.TextSize = 30
userLabel.Font = mainFont
userLabel.Text = LocalPlayer.Name
userLabel.Parent = container

-- LINE 2: FPS | UPTIME (Size 60)
local mainInfoLabel = Instance.new("TextLabel")
mainInfoLabel.Size = UDim2.new(1, 0, 0, 65)
mainInfoLabel.BackgroundTransparency = 1
mainInfoLabel.TextColor3 = Color3.new(1, 1, 1)
mainInfoLabel.TextSize = 60 
mainInfoLabel.Font = mainFont
mainInfoLabel.Text = "0 | 00:00:00"
mainInfoLabel.Parent = container

-- LINE 3: STATS PART 1 (Aura & Cosmetic)
local statLabel1 = Instance.new("TextLabel")
statLabel1.Size = UDim2.new(1, 0, 0, 35)
statLabel1.BackgroundTransparency = 1
statLabel1.TextColor3 = Color3.fromRGB(0, 255, 150)
statLabel1.TextSize = 30
statLabel1.Font = mainFont
statLabel1.Text = "A: 0 | C: 0"
statLabel1.Parent = container

-- LINE 4: STATS PART 2 (Mythical & Reroll)
local statLabel2 = Instance.new("TextLabel")
statLabel2.Size = UDim2.new(1, 0, 0, 35)
statLabel2.BackgroundTransparency = 1
statLabel2.TextColor3 = Color3.fromRGB(0, 255, 150)
statLabel2.TextSize = 30
statLabel2.Font = mainFont
statLabel2.Text = "M: 0 | R: 0"
statLabel2.Parent = container

-- TOGGLE BUTTON
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 120, 0, 60)
toggleBtn.Position = UDim2.new(1, -130, 0, 20)
toggleBtn.BackgroundColor3 = uiDark
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.TextSize = 25
toggleBtn.Font = mainFont
toggleBtn.Text = "AFK"
toggleBtn.Visible = false
toggleBtn.Parent = afkGui

local function setAFK(state)
    blackScreen.Visible = state
    toggleBtn.Visible = not state
    pcall(function() RunService:Set3dRenderingEnabled(not state) end)
end

blackScreen.MouseButton1Click:Connect(function() setAFK(false) end)
toggleBtn.MouseButton1Click:Connect(function() setAFK(true) end)
setAFK(true)

-- ==========================================
-- 3. LOGIC & TRACKING (Sailor Piece Stacks)
-- ==========================================
local startOsTime = os.time()
local frames = 0
RunService.Heartbeat:Connect(function() frames = frames + 1 end)

local function getQuantity(name, base)
    if string.find(string.lower(name), "untradable") then return 0 end
    if name == base then return 1 end
    local num = string.match(name, base .. "%s+(%d+)")
    return num and tonumber(num) or (string.find(name, base) and 1 or 0)
end

local function updateStats()
    local c = {A=0, C=0, M=0, R=0}
    local function scan(f)
        if not f then return end
        for _, i in pairs(f:GetChildren()) do
            local n = i.Name
            c.A = c.A + getQuantity(n, "Aura Crate")
            c.C = c.C + getQuantity(n, "Cosmetic Crate")
            c.M = c.M + getQuantity(n, "Mythical Chest")
            c.R = c.R + getQuantity(n, "Clan Reroll")
        end
    end
    scan(LocalPlayer:FindFirstChild("Backpack"))
    if LocalPlayer.Character then scan(LocalPlayer.Character) end
    
    statLabel1.Text = string.format("A: %d | C: %d", c.A, c.C)
    statLabel2.Text = string.format("M: %d | R: %d", c.M, c.R)
end

task.spawn(function()
    while task_wait(1) do
        if blackScreen.Visible then
            local diff = os.time() - startOsTime
            local h, m, s = math.floor(diff/3600), math.floor((diff%3600)/60), diff%60
            mainInfoLabel.Text = string.format("%d | %02d:%02d:%02d", frames, h, m, s)
            pcall(updateStats)
        end
        frames = 0
    end
end)

-- ==========================================
-- 4. FINAL OPTIMIZATION
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

print("Split-Screen Bottom Dashboard Active.")
