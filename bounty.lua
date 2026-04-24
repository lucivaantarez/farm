-- // lanavienrose architecture: control interface
-- // profile: luxury_minimalist / gui_enabled
-- // build: v1.1.0-stable.raw_transit_logic

if not game:IsLoaded() then game.Loaded:Wait() end

local Players             = game:GetService("Players")
local CoreGui             = game:GetService("CoreGui")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local VirtualUser         = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UIS                 = game:GetService("UserInputService")
local RunService          = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- // spatial dataset
local SEA_1_ID         = 77747658251236
local SEA_2_ID         = 130167267952199
local DOOR_POS         = Vector3.new(-275.591, 324.905, -3060.462)
local CRYSTAL_POS      = Vector3.new(-438.665, -3.789,  374.054)
local STARTER_POS      = Vector3.new(-64.282,  -3.463, -294.211)

local BOUNTY_CAP_MIN  = 48000000
local BOUNTY_CAP_MAX  = 50000000

-- // remotes
local teleportRemote = ReplicatedStorage:FindFirstChild("TeleportToPortal",     true)
local checkRemote    = ReplicatedStorage:FindFirstChild("CheckPortalUnlock",    true)
local settingsRemote = ReplicatedStorage:FindFirstChild("SettingsToggle",       true)

-- // state
local autoSkillActive = false
local bountyCapHit    = false

-- // weapons
local targetWeapons = {
    ["Strongest In History"] = true,
    ["Ichigo"]               = true,
    ["Gryphon"]              = true,
}

-- // interface
local guiParent = gethui and gethui() or CoreGui
local UI_NAME   = "LanavienrosePanel"
if guiParent:FindFirstChild(UI_NAME) then guiParent[UI_NAME]:Destroy() end

local ScreenGui        = Instance.new("ScreenGui", guiParent)
ScreenGui.Name         = UI_NAME
ScreenGui.ResetOnSpawn = false

local Main                    = Instance.new("Frame", ScreenGui)
Main.Size                     = UDim2.new(0, 220, 0, 290)
Main.Position                 = UDim2.new(0.5, -110, 0.5, -145) 
Main.BackgroundColor3         = Color3.fromRGB(10, 10, 12)
Main.BackgroundTransparency   = 0.3
Main.BorderSizePixel          = 0
Main.Active                   = true
Main.Draggable                = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

-- // resize handle
local ResizeHandle                  = Instance.new("Frame", Main)
ResizeHandle.Size                   = UDim2.new(0, 18, 0, 18)
ResizeHandle.Position               = UDim2.new(1, -18, 1, -18)
ResizeHandle.BackgroundColor3       = Color3.fromRGB(55, 55, 70)
ResizeHandle.BackgroundTransparency = 0.3
ResizeHandle.BorderSizePixel        = 0
Instance.new("UICorner", ResizeHandle).CornerRadius = UDim.new(0, 3)

for i = 0, 1 do
    for j = 0, 1 do
        local dot                  = Instance.new("Frame", ResizeHandle)
        dot.Size                   = UDim2.new(0, 2, 0, 2)
        dot.Position               = UDim2.new(0, 4 + i * 6, 0, 4 + j * 6)
        dot.BackgroundColor3       = Color3.fromRGB(100, 100, 120)
        dot.BackgroundTransparency = 0.2
        dot.BorderSizePixel        = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    end
end

local resizing      = false
local resizeOrigin  = nil
local sizeOrigin    = nil

local ResizeBtn                  = Instance.new("TextButton", ResizeHandle)
ResizeBtn.Size                   = UDim2.new(1, 0, 1, 0)
ResizeBtn.BackgroundTransparency = 1
ResizeBtn.Text                   = ""
ResizeBtn.BorderSizePixel        = 0

ResizeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        if resizing then return end
        resizing = true
        resizeOrigin = Vector2.new(input.Position.X, input.Position.Y)
        sizeOrigin = Main.AbsoluteSize
    end
end)

UIS.InputChanged:Connect(function(input)
    if not resizing then return end
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - resizeOrigin
        local newW  = math.max(180, sizeOrigin.X + delta.X)
        local newH  = math.max(240, sizeOrigin.Y + delta.Y)
        Main.Size   = UDim2.new(0, newW, 0, newH)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = false
    end
end)

-- // close
local Close                   = Instance.new("TextButton", Main)
Close.Size                    = UDim2.new(0, 28, 0, 28)
Close.Position                = UDim2.new(1, -28, 0, 0)
Close.BackgroundTransparency  = 1
Close.Text                    = "×"
Close.TextColor3              = Color3.fromRGB(70, 70, 85)
Close.Font                    = Enum.Font.GothamBold
Close.TextSize                = 15
Close.BorderSizePixel         = 0
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- // label factory
local function makeLabel(text, yPos, size, color)
    local lbl                  = Instance.new("TextLabel", Main)
    lbl.Size                   = UDim2.new(1, -20, 0, 16)
    lbl.Position               = UDim2.new(0, 10, 0, yPos)
    lbl.BackgroundTransparency = 1
    lbl.Text                   = text
    lbl.TextColor3             = color or Color3.fromRGB(150, 150, 165)
    lbl.Font                   = Enum.Font.GothamMedium
    lbl.TextSize               = size or 9
    lbl.TextXAlignment         = Enum.TextXAlignment.Left
    lbl.TextScaled             = false
    return lbl
end

local function makeCategory(text, yPos)
    local lbl                  = Instance.new("TextLabel", Main)
    lbl.Size                   = UDim2.new(1, -20, 0, 12)
    lbl.Position               = UDim2.new(0, 10, 0, yPos)
    lbl.BackgroundTransparency = 1
    lbl.Text                   = text:upper()
    lbl.TextColor3             = Color3.fromRGB(55, 55, 72)
    lbl.Font                   = Enum.Font.GothamBold
    lbl.TextSize               = 7
    lbl.TextXAlignment         = Enum.TextXAlignment.Left

    local line                  = Instance.new("Frame", Main)
    line.Size                   = UDim2.new(1, -20, 0, 1)
    line.Position               = UDim2.new(0, 10, 0, yPos + 13)
    line.BackgroundColor3       = Color3.fromRGB(35, 35, 45)
    line.BackgroundTransparency = 0
    line.BorderSizePixel        = 0
end

local function makeBtn(text, yPos, color)
    local btn                   = Instance.new("TextButton", Main)
    btn.Size                    = UDim2.new(1, -20, 0, 28)
    btn.Position                = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3        = color or Color3.fromRGB(20, 20, 26)
    btn.BackgroundTransparency  = 0.15
    btn.Text                    = text
    btn.TextColor3              = Color3.fromRGB(205, 205, 215)
    btn.Font                    = Enum.Font.GothamBold
    btn.TextSize                = 9
    btn.BorderSizePixel         = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.MouseEnter:Connect(function() btn.BackgroundTransparency = 0    end)
    btn.MouseLeave:Connect(function() btn.BackgroundTransparency = 0.15 end)
    return btn
end

local function makeHalfBtn(text, yPos, side, color)
    local btn                   = Instance.new("TextButton", Main)
    btn.Size                    = UDim2.new(0.5, -14, 0, 28)
    btn.Position                = side == "left"
        and UDim2.new(0, 10, 0, yPos)
        or  UDim2.new(0.5, 4,  0, yPos)
    btn.BackgroundColor3        = color or Color3.fromRGB(20, 20, 26)
    btn.BackgroundTransparency  = 0.15
    btn.Text                    = text
    btn.TextColor3              = Color3.fromRGB(205, 205, 215)
    btn.Font                    = Enum.Font.GothamBold
    btn.TextSize                = 9
    btn.BorderSizePixel         = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.MouseEnter:Connect(function() btn.BackgroundTransparency = 0    end)
    btn.MouseLeave:Connect(function() btn.BackgroundTransparency = 0.15 end)
    return btn
end

-- // header
local Title     = makeLabel("LANAVIENROSE · AUTO BOUNTY", 10, 10, Color3.fromRGB(240, 240, 250))
Title.Font      = Enum.Font.GothamBold
local UserLabel = makeLabel(LocalPlayer.Name:upper(), 24, 8, Color3.fromRGB(65, 65, 80))
local StatusLabel = makeLabel("— · — · — · —", 36, 8, Color3.fromRGB(120, 120, 138))

makeCategory("hop",        56)
local BtnTransit  = makeBtn("TRANSIT TO SEA 1", 70)

makeCategory("teleport",  106)
local BtnSafeZone = makeHalfBtn("SAFE ZONE", 120, "left")
local BtnJungle   = makeHalfBtn("JUNGLE",    120, "right", Color3.fromRGB(38, 18, 18))

makeCategory("auto skill", 156)
local BtnKillHaki = makeHalfBtn("KILL HAKI",  170, "left",  Color3.fromRGB(38, 14, 14))
local BtnSkill    = makeHalfBtn("SKILL: OFF", 170, "right", Color3.fromRGB(18, 22, 32))

local LogLine               = Instance.new("TextLabel", Main)
LogLine.Size                = UDim2.new(1, 0, 0, 12)
LogLine.Position            = UDim2.new(0, 0, 1, -16)
LogLine.BackgroundTransparency = 1
LogLine.Text                = "READY"
LogLine.TextColor3          = Color3.fromRGB(45, 45, 60)
LogLine.Font                = Enum.Font.GothamMedium
LogLine.TextSize            = 7
LogLine.TextXAlignment      = Enum.TextXAlignment.Center

-- // anti-afk
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- // utilities
local function log(msg)
    LogLine.Text = msg
    print(string.format("[lanavienrose] %s", msg:lower()))
end

local function formatBounty(n)
    return tostring(math.floor(n)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

local function getHRP()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function isHakiActive()
    local char = LocalPlayer.Character
    if not char then return false end
    for _, v in ipairs(char:GetDescendants()) do
        if v.Name == "Buso" or v.Name == "Haki" or v:IsA("Highlight") then return true end
    end
    return false
end

local function purgeHaki()
    if not settingsRemote then return end
    settingsRemote:FireServer("AutoArmHaki",  false)
    settingsRemote:FireServer("AutoObsHaki",  false)
    settingsRemote:FireServer("AutoConqHaki", false)
    log("HAKI OFF")
end

local function stopSkill()
    autoSkillActive           = false
    BtnSkill.Text             = "SKILL: OFF"
    BtnSkill.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid:UnequipTools()
    end
end

-- // TRANSIT LOGIC (RAW CFRAME IMPORTED FROM PROVIDED SCRIPT)
local function executeTransit(mapArg, targetPos, promptName)
    if not teleportRemote or not checkRemote then
        log("ERROR: MISSING REMOTES")
        return
    end

    log("SYNCING SERVER DATA...")
    pcall(function() 
        checkRemote:InvokeServer("SoulDominion")
        checkRemote:InvokeServer(mapArg) 
    end)
    task.wait(0.2)

    log("REQUESTING TELEPORT...")
    teleportRemote:FireServer(mapArg)
    
    -- Wait for map load
    task.wait(3.5)

    local hrp = getHRP()
    if not hrp then return end
    
    hrp.Anchored = false

    -- Move to specific interactable coordinate
    log("MOVING TO OBJECT...")
    hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))
    task.wait(0.5)

    -- Force interact with prompt
    local fired = false
    for i = 1, 10 do
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.Name == promptName then
                local dist = (obj.Parent.Position - hrp.Position).Magnitude
                if dist <= 30 then
                    fireproximityprompt(obj)
                    fired = true
                    break
                end
            end
        end
        if fired then break end
        task.wait(0.5)
    end
    
    log(fired and "OPERATION SUCCESSFUL" or "INTERACTION FAILED")
end

-- // auto skill loop
task.spawn(function()
    while task.wait(0.1) do
        if autoSkillActive then
            local char = LocalPlayer.Character
            if char then
                local equipped = char:FindFirstChildOfClass("Tool")
                if not equipped or not targetWeapons[equipped.Name] then
                    local bp = LocalPlayer:FindFirstChild("Backpack")
                    if bp then
                        for _, tool in ipairs(bp:GetChildren()) do
                            if tool:IsA("Tool") and targetWeapons[tool.Name] then
                                local hum = char:FindFirstChild("Humanoid")
                                if hum then hum:EquipTool(tool) equipped = tool break end
                            end
                        end
                    end
                end
                if equipped and targetWeapons[equipped.Name] then
                    equipped:Activate()
                    VirtualInputManager:SendKeyEvent(true,  Enum.KeyCode.X, false, game)
                    task.wait(0.05)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.X, false, game)
                end
            end
        end
    end
end)

-- // status + bounty cap monitor
task.spawn(function()
    while ScreenGui.Parent do
        pcall(function()
            local region = game.PlaceId == SEA_1_ID and "SEA 1" or "SEA 2"
            local bountyVal = 0
            local bountyStr = "—"
            local stats = LocalPlayer:FindFirstChild("leaderstats")
            if stats and stats:FindFirstChild("Bounty") then
                bountyVal  = stats.Bounty.Value
                bountyStr  = formatBounty(bountyVal)
            end

            local hakiOn  = isHakiActive()
            local skillOn = autoSkillActive

            StatusLabel.Text = region
                .. "  ·  " .. bountyStr
                .. "  ·  " .. (hakiOn  and "HAKI ON"  or "HAKI OFF")
                .. "  ·  " .. (skillOn and "SKILL ON" or "SKILL OFF")

            StatusLabel.TextColor3 = hakiOn
                and Color3.fromRGB(200, 80, 80)
                or  Color3.fromRGB(110, 110, 128)

            if not bountyCapHit
                and bountyVal >= BOUNTY_CAP_MIN
                and bountyVal <= BOUNTY_CAP_MAX
            then
                bountyCapHit = true
                stopSkill()
                log("CAP REACHED — GOING SAFE")
                executeTransit("Starter", STARTER_POS, nil)
            end
        end)
        task.wait(1)
    end
end)

-- // bindings
BtnTransit.MouseButton1Click:Connect(function() 
    if game.PlaceId == SEA_1_ID then log("ALREADY IN SEA 1") return end
    task.spawn(function() executeTransit("World", DOOR_POS, "Sea2DoorPrompt") end)
end)

BtnSafeZone.MouseButton1Click:Connect(function() 
    task.spawn(function()
        log("TRANSITING TO SAFE ZONE...")
        pcall(function()
            checkRemote:InvokeServer("SoulDominion")
            task.wait(0.1)
            checkRemote:InvokeServer("Starter")
            task.wait(0.2)
            teleportRemote:FireServer("Starter")
        end)
        log("SAFE ZONE REACHED")
    end)
end)

BtnJungle.MouseButton1Click:Connect(function()   
    if game.PlaceId ~= SEA_1_ID then log("ERROR: TARGET SEA 1") return end
    task.spawn(function() executeTransit("Jungle", CRYSTAL_POS, "CheckpointPrompt") end)
end)

BtnKillHaki.MouseButton1Click:Connect(function() task.spawn(purgeHaki) end)

BtnSkill.MouseButton1Click:Connect(function()
    if bountyCapHit then
        log("CAP HIT — RESET BOUNTY FIRST")
        return
    end
    autoSkillActive = not autoSkillActive
    if autoSkillActive then
        BtnSkill.Text             = "SKILL: ON"
        BtnSkill.BackgroundColor3 = Color3.fromRGB(18, 38, 18)
        log("AUTO SKILL ON")
    else
        stopSkill()
        log("AUTO SKILL OFF")
    end
end)
