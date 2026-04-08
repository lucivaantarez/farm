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
local GuiService = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer

local mainFont = Enum.Font.SourceSansBold 
local uiDark = Color3.fromRGB(30, 30, 30)
local SmoothPlastic = Enum.Material.SmoothPlastic
local flatColor = Color3.fromRGB(150, 150, 150) -- The flat gray color

-- ==========================================
-- 1. THE RONIX BULLY & FATAL ERROR KILLER
-- ==========================================
local afkGui = Instance.new("ScreenGui")
afkGui.Name = "FinalCompactAFK_Center"
afkGui.IgnoreGuiInset = true
afkGui.DisplayOrder = 2147483647 
afkGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local function setParent()
    pcall(function() afkGui.Parent = CoreGui:FindFirstChild("RobloxGui") or CoreGui end)
end
setParent()

local coreWhitelist = {"RobloxGui", "RobloxNetworkPauseNotification", "ThemeProvider", "TeleportGui"}

task.spawn(function()
    while task.wait(0.5) do
        setParent()
        pcall(function()
            -- Instantly kill Headset Disconnected Errors
            GuiService:ClearError()
            
            local promptGui = CoreGui:FindFirstChild("RobloxPromptGui")
            if promptGui then 
                promptGui.Enabled = false 
                for _, child in pairs(promptGui:GetDescendants()) do
                    if child:IsA("GuiObject") then child.Visible = false end
                end
            end

            -- Hide Ronix/Delta UIs (Leaves Game UI Alone)
            for _, gui in pairs(CoreGui:GetChildren()) do
                if gui:IsA("ScreenGui") and gui ~= afkGui and not table.find(coreWhitelist, gui.Name) then
                    if afkGui:FindFirstChild("BlackScreen") and afkGui.BlackScreen.Visible then
                        gui.Enabled = false
                    end
                end
            end
        end)
    end
end)

-- ==========================================
-- 2. CENTERED DASHBOARD (1-Line Stats)
-- ==========================================
local blackScreen = Instance.new("Frame")
blackScreen.Name = "BlackScreen"
blackScreen.Size = UDim2.new(1, 0, 1, 0)
blackScreen.BackgroundColor3 = Color3.new(0, 0, 0)
blackScreen.Active = true 
blackScreen.Parent = afkGui

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(1, 0, 1, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = ""
closeBtn.Active = true 
closeBtn.Parent = blackScreen

local container = Instance.new("Frame")
container.Size = UDim2.new(1, 0, 1, 0) 
container.Position = UDim2.new(0, 0, 0, 0)
container.BackgroundTransparency = 1
container.Parent = blackScreen

local listLayout = Instance.new("UIListLayout")
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.VerticalAlignment = Enum.VerticalAlignment.Center 
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

local statLabel = Instance.new("TextLabel")
statLabel.Size = UDim2.new(1, 0, 0, 35)
statLabel.BackgroundTransparency = 1
statLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
statLabel.TextSize = 30
statLabel.Font = mainFont
statLabel.Text = "A:0 | C:0 | R:0 | M:0"
statLabel.Parent = container

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
-- 3. GMT+7 TIME & INVENTORY TRACKER
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
    
    statLabel.Text = string.format("A:%d | C:%d | R:%d | M:%d", c.A, c.C, c.R, c.M)
end

task.spawn(function()
    while true do
        if blackScreen.Visible then pcall(updateEverything) end
        task.wait(1)
    end
end)

-- ==========================================
-- 4. ULTRA POTATO ENFORCER (UI, Sky, Colors)
-- ==========================================
task.spawn(function()
    while task.wait(1) do -- Sweeps the game every second to force potato mode
        pcall(function()
            -- A. LOW TEXTURE UI (Leaves it functional for Auto-Farm, just flat/ugly)
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                for _, uiElement in pairs(playerGui:GetDescendants()) do
                    if not uiElement:FindFirstAncestor(afkGui.Name) then
                        if uiElement:IsA("UICorner") or uiElement:IsA("UIStroke") or 
                           uiElement:IsA("UIGradient") or uiElement:IsA("UIShadow") then
                            uiElement:Destroy()
                        elseif uiElement:IsA("GuiObject") then
                            uiElement.BorderSizePixel = 0
                            if uiElement:IsA("TextLabel") or uiElement:IsA("TextButton") then
                                uiElement.RichText = false
                            end
                        end
                    end
                end
            end

            -- B. NUKE THE SKY & LIGHTING
            Lighting.GlobalShadows = false
            Lighting.Brightness = 0
            Lighting.ClockTime = 14
            Lighting.FogEnd = 9e9
            Lighting.Ambient = flatColor
            Lighting.OutdoorAmbient = flatColor
            
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("PostEffect") or v:IsA("Clouds") then
                    v:Destroy()
                end
            end
            for _, v in pairs(Workspace.Terrain:GetChildren()) do
                if v:IsA("Clouds") then v:Destroy() end
            end

            -- C. FORCE GREY CHARACTERS & REMOVE CLOTHES
            -- This targets YOUR character and ALL NPCs/Players currently spawned
            for _, model in pairs(Workspace:GetDescendants()) do
                if model:IsA("Model") and model:FindFirstChild("Humanoid") then
                    for _, part in pairs(model:GetDescendants()) do
                        if part:IsA("BodyColors") or part:IsA("Shirt") or part:IsA("Pants") or 
                           part:IsA("ShirtGraphic") or part:IsA("Accessory") or 
                           (part:IsA("Decal") and (part.Name:lower() == "face")) then
                            part:Destroy()
                        elseif part:IsA("BasePart") then
                            -- Overwrite the color aggressively every second
                            part.Material = SmoothPlastic
                            part.Color = flatColor
                            part.CastShadow = false
                            if part:IsA("MeshPart") then
                                part.TextureID = ""
                            end
                        end
                    end
                end
            end
            
            -- D. CLEAN UP WORLD TEXTURES & PARTICLES
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Texture") or v:IsA("Decal") or v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v:Destroy()
                end
            end

        end)
    end
end)

print("ULTRA Potato Dashboard Active (Low UI, Grey Avatars, No Sky).")
