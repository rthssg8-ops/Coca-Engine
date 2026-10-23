--[[═══════════════════════════════════════════════════════════════════════════════
  🔴 COCO POWDER — V21 COMPLETE UNCUT BULLETPROOF & LOW-END OPTIMIZED EDITION
  ═══════════════════════════════════════════════════════════════════════════════]]

print("[COCO POWDER] Initializing Complete Uncut Engine...")

if not game:IsLoaded() then
    local loadedSuccess = pcall(function() game.Loaded:Wait() end)
    if not loadedSuccess then
        task.wait(1)
    end
end

local RunService        = game:GetService("RunService")
local Players           = game:GetService("Players")
local UIS               = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local Debris            = game:GetService("Debris")
local SoundService      = game:GetService("SoundService")
local StarterGui        = game:GetService("StarterGui")
local VoiceChatService  = nil
pcall(function() VoiceChatService = game:GetService("VoiceChatService") end)

local CoreGui = nil
pcall(function() CoreGui = game:GetService("CoreGui") end)

local LP = Players.LocalPlayer
while not LP do
    task.wait(0.1)
    LP = Players.LocalPlayer
end

-- Fast Math Cache
local v3_zero   = Vector3.zero
local cf_new    = CFrame.new
local cf_angles = CFrame.Angles
local m_rad     = math.rad
local m_sin     = math.sin
local m_cos     = math.cos
local m_pi      = math.pi
local m_clamp   = math.clamp
local m_floor   = math.floor

local function getGuiContainer()
    local success, hui = pcall(function()
        if typeof(gethui) == "function" then
            return gethui()
        end
    end)
    if success and hui then return hui end

    if CoreGui and pcall(function() return CoreGui:GetChildren() end) then
        return CoreGui
    end

    local pgui = LP:FindFirstChild("PlayerGui")
    if not pgui then
        pgui = LP:WaitForChild("PlayerGui", 10)
    end
    return pgui
end

local GuiParent = getGuiContainer()
if not GuiParent then return end

pcall(function()
    for _, child in ipairs(GuiParent:GetChildren()) do
        if child.Name:match("^CocoPowder") or child.Name:match("^RedHub") or child.Name:match("^COCA_") or child.Name:match("^AntiVoidProGui") then
            child:Destroy()
        end
    end
    local pgui = LP:FindFirstChild("PlayerGui")
    if pgui and pgui ~= GuiParent then
        for _, child in ipairs(pgui:GetChildren()) do
            if child.Name:match("^CocoPowder") or child.Name:match("^RedHub") or child.Name:match("^COCA_") or child.Name:match("^AntiVoidProGui") then
                child:Destroy()
            end
        end
    end
end)

local sethiddenproperty = sethiddenproperty or set_hidden_property or set_hidden_prop
local InstanceHandleNew = nil
pcall(function()
    if InstanceHandle and typeof(InstanceHandle.new) == "function" then
        InstanceHandleNew = InstanceHandle.new
    end
end)

local cam = workspace.CurrentCamera or workspace:FindFirstChildOfClass("Camera")

local T = {
    BG       = Color3.fromRGB(15, 16, 19),
    BG2      = Color3.fromRGB(22, 24, 28),
    Panel    = Color3.fromRGB(28, 30, 36),
    PanelLt  = Color3.fromRGB(38, 41, 49),
    Border   = Color3.fromRGB(52, 56, 68),
    Accent   = Color3.fromRGB(75, 85, 99),
    Accent2  = Color3.fromRGB(55, 65, 81),
    Neon     = Color3.fromRGB(156, 163, 175),
    Success  = Color3.fromRGB(52, 199, 89),
    Danger   = Color3.fromRGB(220, 38, 38),
    Warning  = Color3.fromRGB(234, 179, 8),
    Pink     = Color3.fromRGB(107, 114, 128),
    Purple   = Color3.fromRGB(99, 102, 241),
    Text     = Color3.fromRGB(243, 244, 246),
    Muted    = Color3.fromRGB(148, 163, 184),
    Dark     = Color3.fromRGB(11, 12, 14),
}

-- Forward declaration
local promptNebulaFling = nil

local function sfx(id, vol, pitch)
    task.spawn(function()
        pcall(function()
            local s = Instance.new("Sound")
            s.SoundId = "rbxassetid://" .. tostring(id)
            s.Volume = vol or 0.35
            s.PlaybackSpeed = pitch or 1
            s.Parent = SoundService
            s:Play()
            Debris:AddItem(s, 3)
        end)
    end)
end

local sClick     = function() sfx(12221967, 0.35, 1.8) end
local sHover     = function() sfx(12221967, 0.12, 2.5) end
local sSuccess   = function() sfx(5696552322, 0.45, 1.2) end
local sError     = function() sfx(5766952670, 0.45, 0.9) end
local sToggleOn  = function() sfx(5696552322, 0.35, 1.6) end
local sToggleOff = function() sfx(5696552322, 0.35, 0.7) end
local sWhoosh    = function() sfx(6895079853, 0.45, 1.4) end
local sSlap      = function() sfx(9114223179, 0.65, 1.1) end
local sFling     = function() sfx(9069609267, 0.55, 1.2) end

local function notify(title, text)
    task.spawn(function()
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = title or "COCO POWDER",
                Text = text or "",
                Duration = 2.5,
                Icon = "rbxassetid://10850257404"
            })
        end)
    end)
end

local ANIM_DB = {
    Sit         = { R6 = 178130996, R15 = 2506281703 },
    ShoulderSit = { R6 = 178130996, R15 = 2506281703 },
    HeadSit     = { R6 = 178130996, R15 = 2506281703 },
    Backpack    = { R6 = 178130996, R15 = 2506281703 },
    Kick        = { R6 = 184570534, R15 = 507770677 },
    Slap        = { R6 = 204062532, R15 = 4555808220 },
    Carry       = { R6 = 178130996, R15 = 507770677 },
    Hug         = { R6 = 178130996, R15 = 507770677 },
    Kiss        = { R6 = 3576686446, R15 = 3576686446 },
    RomanceClasp= { R6 = 10281064499, R15 = 10281064499 },
    PassionGrip = { R6 = 82810853201599, R15 = 82810853201599 },
    Jerk        = { R6 = 148840371, R15 = 507770677 },
    Pos69       = { R6 = 282574440, R15 = 282574440 },
    BangAggressive = { R6 = 148840371, R15 = 507770677 },
    Dances      = {
        Floss     = 507771019,
        Default   = 507766666,
        OrangeJ   = 507777826,
        Gangnam   = 182435998,
        Hype      = 507770677,
        Party     = 4555808220,
        DontStart = 507772104,
        ChaCha    = 3696763549,
        Dance     = 5918726674,
    },
    Prone       = { R6 = 282574440, R15 = 282574440 },
    Bow         = { R6 = 282574440, R15 = 282574440 },
    Point       = { R6 = 204062532, R15 = 507770677 },
    Flex        = { R6 = 313762630, R15 = 96658788627102 },
    Uppercut    = { R6 = 204062532, R15 = 4555808220 },
    Handshake   = { R6 = 178130996, R15 = 507770677 },
    Pat         = { R6 = 204062532, R15 = 507770677 },
    Twerk       = { R6 = 182435998, R15 = 507771019 }
}

local V = {
    X = 0, Y = 0, Z = 1.3,
    RX = 0, RY = 0, RZ = 0,
    Speed = 1.0,
}

local CurrentWeld         = nil
local CurrentTarget       = nil
local selectedPlayer      = nil
local AnimCopyEnabled     = false
local PlayedAnims         = {}
local CopiedTracks        = {}
local AnimCopyConn        = nil

local OriginalFPDH        = workspace.FallenPartsDestroyHeight
if OriginalFPDH ~= OriginalFPDH then OriginalFPDH = -500 end

local ThrustActive        = false
local ThrustConn          = nil
local ThrustTouchZ        = 1.0
local ThrustDirection     = 1
local ThrustRange         = 0.7
local ThrustSpeed         = 2.2
local ThrustZMin          = -4.0
local ThrustZMax          = -0.4
local IsCustomZThrust     = false

local MotionMode          = "none"
local MotionConn          = nil
local OrbitRadius         = 3.0
local OrbitSpeed          = 1.2
local BounceHeight        = 3.0
local BounceSpeed         = 1.5

-- Fast part caching
local MyCharacterParts    = {}
local CachedMyRoot        = nil
local CachedMyHum         = nil

local function updateCachedCharacter(char)
    table.clear(MyCharacterParts)
    CachedMyRoot = nil
    CachedMyHum = nil
    if not char then return end
    
    CachedMyRoot = char:WaitForChild("HumanoidRootPart", 5)
    CachedMyHum  = char:WaitForChild("Humanoid", 5)

    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            table.insert(MyCharacterParts, p)
        end
    end
end

if LP.Character then updateCachedCharacter(LP.Character) end
LP.CharacterAdded:Connect(updateCachedCharacter)

-- Defense variables
local AntiSitEnabled      = false
local AntiSitConn         = nil
local AntiSitCount        = 0
local AntiSitCountLabel   = nil

local AntiFlingEnabled    = false
local AntiFlingConn       = nil

local AntiVoidEnabled     = false
local AntiVoidSafeCFrame  = nil
local AntiVoidRecoveries  = 0
local AntiVoidStatusLabel = nil

local OriginalCameraSubject = nil
local AutoReweldEnabled   = true
local LastWeldTargetUserId = nil
local LastWeldAnimId      = nil
local LastWeldWasThrust   = false
local LastWeldType        = nil
local LastCustomData      = {}

local FlingActive         = false
local FlingConn           = nil
local FlingSidePanel      = nil
local FlingCountdownLabel = nil

local UIRefs              = {}
local ProceduralArmConn   = nil
local ProceduralActive    = false
local ActiveMotorsBackup  = {}

local function getRig(player)
    if not player or not player.Character then return nil end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    return hum and hum.RigType or nil
end

local function isR15(player)
    return getRig(player) == Enum.HumanoidRigType.R15
end

local function getTargetTorso(char)
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.RigType == Enum.HumanoidRigType.R15 then
        return char:FindFirstChild("UpperTorso") or char:FindFirstChild("LowerTorso") or char:FindFirstChild("HumanoidRootPart")
    else
        return char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    end
end

local function getTorsoDepth(char)
    if not char then return 1.0 end
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    return torso and torso.Size.Z or 1.0
end

local function getAnimIdForRig(category, isUserR15)
    local entry = ANIM_DB[category]
    if not entry then return nil end
    if typeof(entry) == "number" then return entry end
    return isUserR15 and (entry.R15 or entry.R6) or (entry.R6 or entry.R15)
end

local function resetProceduralMotors()
    if ProceduralArmConn then
        ProceduralArmConn:Disconnect()
        ProceduralArmConn = nil
    end
    ProceduralActive = false

    local char = LP.Character
    if not char then return end

    for motor, originalData in pairs(ActiveMotorsBackup) do
        if motor and motor.Parent then
            pcall(function()
                motor.Transform = originalData.Transform or CFrame.identity
                motor.C0 = originalData.C0 or motor.C0
            end)
        end
    end
    table.clear(ActiveMotorsBackup)
end

local function enableProceduralArmRaise(mode)
    resetProceduralMotors()
    local char = LP.Character
    if not char then return end

    local userIsR15 = isR15(LP)
    ProceduralActive = true

    local leftShoulder, rightShoulder = nil, nil
    if userIsR15 then
        local upperTorso = char:FindFirstChild("UpperTorso")
        local leftArm    = char:FindFirstChild("LeftUpperArm")
        local rightArm   = char:FindFirstChild("RightUpperArm")
        if upperTorso then
            leftShoulder  = upperTorso:FindFirstChild("LeftShoulder")
            rightShoulder = upperTorso:FindFirstChild("RightShoulder")
        end
        if not leftShoulder and leftArm then leftShoulder = leftArm:FindFirstChild("LeftShoulder") end
        if not rightShoulder and rightArm then rightShoulder = rightArm:FindFirstChild("RightShoulder") end
    else
        local torso = char:FindFirstChild("Torso")
        if torso then
            leftShoulder  = torso:FindFirstChild("Left Shoulder")
            rightShoulder = torso:FindFirstChild("Right Shoulder")
        end
    end

    if leftShoulder then ActiveMotorsBackup[leftShoulder] = { C0 = leftShoulder.C0, Transform = leftShoulder.Transform } end
    if rightShoulder then ActiveMotorsBackup[rightShoulder] = { C0 = rightShoulder.C0, Transform = rightShoulder.Transform } end

    local startTime = tick()
    ProceduralArmConn = RunService.Stepped:Connect(function()
        if not ProceduralActive or not LP.Character then
            resetProceduralMotors()
            return
        end
        local elapsed = tick() - startTime
        local sway = m_sin(elapsed * 3) * 0.05

        if mode == "jerk" then
            if not userIsR15 and rightShoulder then
                local jerkOsc = m_sin(elapsed * 24)
                pcall(function()
                    rightShoulder.Transform = cf_new(0, -0.15 + jerkOsc * 0.08, -0.22) * cf_angles(m_rad(65 + jerkOsc * 30), m_rad(-22), m_rad(-14))
                end)
                if leftShoulder then
                    pcall(function() leftShoulder.Transform = cf_angles(m_rad(18), m_rad(5), m_rad(-10)) end)
                end
            elseif userIsR15 and rightShoulder then
                local jerkOsc = m_sin(elapsed * 22)
                pcall(function()
                    rightShoulder.Transform = cf_new(0, -0.12, -0.2) * cf_angles(m_rad(70 + jerkOsc * 26), m_rad(-20), m_rad(10))
                end)
            end
        elseif mode == "handshake" and rightShoulder then
            pcall(function() rightShoulder.Transform = cf_angles(m_rad(85), m_rad(10), 0) end)
        elseif mode == "pat" and rightShoulder then
            local patSwing = m_sin(elapsed * 6) * m_rad(15)
            pcall(function() rightShoulder.Transform = cf_angles(m_rad(105) + patSwing, m_rad(-15), 0) end)
        elseif userIsR15 then
            local liftAngle = m_rad(80 + sway * 10)
            local inwardAngle = (mode == "hug") and m_rad(28) or m_rad(18)
            if rightShoulder then pcall(function() rightShoulder.Transform = cf_angles(liftAngle, -inwardAngle, m_rad(10)) end) end
            if leftShoulder then pcall(function() leftShoulder.Transform = cf_angles(liftAngle, inwardAngle, -m_rad(10)) end) end
        else
            local liftAngle = m_rad(85 + sway * 10)
            local inwardAngle = (mode == "hug") and m_rad(25) or m_rad(15)
            if rightShoulder then pcall(function() rightShoulder.Transform = cf_angles(liftAngle, 0, -inwardAngle) end) end
            if leftShoulder then pcall(function() leftShoulder.Transform = cf_angles(liftAngle, 0, inwardAngle) end) end
        end
    end)
end

-- State Manager
local StateManager = {}
StateManager.sPunch = function() sfx(131237241, 0.65, 1.1) end
StateManager.sLaugh = function() sfx(5235775702, 0.5, 1.3) end

StateManager.AutoLookAtActive     = false
StateManager.AutoLookAtConn       = nil
StateManager.TargetCamLockActive  = false
StateManager.TargetCamLockConn    = nil
StateManager.ReversePOVActive     = false
StateManager.ReversePOVConn       = nil
StateManager.GhostModeActive      = false
StateManager.GhostModeConn        = nil
StateManager.NoclipActive         = false
StateManager.JerkActive           = false
StateManager.JerkConn             = nil
StateManager.NoclipConn           = nil
StateManager.DistanceKeeperActive = false
StateManager.DistanceKeeperConn   = nil
StateManager.DistanceKeeperRadius = 5.0
StateManager.CopyVelocityActive   = false
StateManager.CopyVelocityConn     = nil
StateManager.SpinAttackActive     = false
StateManager.SpinAttackConn       = nil
StateManager.FakeFlingArcActive   = false
StateManager.FakeFlingArcConn     = nil
StateManager.AnchorLockActive     = false
StateManager.ActiveParticles      = {}

function StateManager:StopAllAnimations()
    for _, track in ipairs(PlayedAnims) do
        pcall(function() track:Stop(0); track:Destroy() end)
    end
    table.clear(PlayedAnims)
    if AnimCopyConn then AnimCopyConn:Disconnect(); AnimCopyConn = nil end
    for _, track in ipairs(CopiedTracks) do
        pcall(function() track:Stop(0); track:Destroy() end)
    end
    table.clear(CopiedTracks)
end

function StateManager:StopThrust()
    ThrustActive = false
    IsCustomZThrust = false
    if ThrustConn then ThrustConn:Disconnect(); ThrustConn = nil end
end

function StateManager:StopMotion()
    MotionMode = "none"
    if MotionConn then MotionConn:Disconnect(); MotionConn = nil end
end

function StateManager:StopPOV()
    if OriginalCameraSubject and cam then
        pcall(function() cam.CameraSubject = OriginalCameraSubject end)
        OriginalCameraSubject = nil
    end
    if StateManager.ReversePOVConn then
        StateManager.ReversePOVConn:Disconnect()
        StateManager.ReversePOVConn = nil
    end
    StateManager.ReversePOVActive = false
    if cam then
        cam.CameraType = Enum.CameraType.Custom
        if CachedMyHum then cam.CameraSubject = CachedMyHum end
    end
end

function StateManager:StopUtilities()
    if StateManager.AutoLookAtConn then StateManager.AutoLookAtConn:Disconnect(); StateManager.AutoLookAtConn = nil end
    StateManager.AutoLookAtActive = false
    if CachedMyHum then pcall(function() CachedMyHum.AutoRotate = true end) end

    if StateManager.TargetCamLockConn then StateManager.TargetCamLockConn:Disconnect(); StateManager.TargetCamLockConn = nil end
    pcall(function() RunService:UnbindFromRenderStep("CocoPowderTargetCamLock") end)
    StateManager.TargetCamLockActive = false

    if StateManager.GhostModeConn then StateManager.GhostModeConn:Disconnect(); StateManager.GhostModeConn = nil end
    for i = 1, #MyCharacterParts do
        local p = MyCharacterParts[i]
        if p.Parent then pcall(function() p.LocalTransparencyModifier = 0 end) end
    end
    StateManager.GhostModeActive = false

    if StateManager.SpinAttackConn then StateManager.SpinAttackConn:Disconnect(); StateManager.SpinAttackConn = nil end
    StateManager.SpinAttackActive = false
    if CachedMyRoot then CachedMyRoot.AssemblyAngularVelocity = v3_zero end

    if StateManager.FakeFlingArcConn then StateManager.FakeFlingArcConn:Disconnect(); StateManager.FakeFlingArcConn = nil end
    StateManager.FakeFlingArcActive = false

    if StateManager.CopyVelocityConn then StateManager.CopyVelocityConn:Disconnect(); StateManager.CopyVelocityConn = nil end
    StateManager.CopyVelocityActive = false

    if CachedMyRoot then pcall(function() CachedMyRoot.Anchored = false end) end
    if CachedMyHum and StateManager.OriginalWalkSpeed then pcall(function() CachedMyHum.WalkSpeed = StateManager.OriginalWalkSpeed end) end
    StateManager.AnchorLockActive = false

    if StateManager.NoclipConn then StateManager.NoclipConn:Disconnect(); StateManager.NoclipConn = nil end
    StateManager.NoclipActive = false

    if StateManager.DistanceKeeperConn then StateManager.DistanceKeeperConn:Disconnect(); StateManager.DistanceKeeperConn = nil end
    StateManager.DistanceKeeperActive = false

    if StateManager.JerkConn then StateManager.JerkConn:Disconnect(); StateManager.JerkConn = nil end
    StateManager.JerkActive = false

    for _, emitter in ipairs(StateManager.ActiveParticles) do pcall(function() emitter:Destroy() end) end
    table.clear(StateManager.ActiveParticles)
end

function StateManager:StopFling()
    if FlingConn then FlingConn:Disconnect(); FlingConn = nil end
    FlingActive = false
    if FlingSidePanel then FlingSidePanel.Visible = false end
end

function StateManager:Cleanup(keepTarget)
    if CurrentWeld then
        pcall(function() CurrentWeld:Destroy() end)
        CurrentWeld = nil
    end

    self:StopAllAnimations()
    self:StopThrust()
    self:StopMotion()
    self:StopPOV()
    self:StopFling()
    self:StopUtilities()
    resetProceduralMotors()

    if CachedMyRoot then
        CachedMyRoot.AssemblyLinearVelocity = v3_zero
        CachedMyRoot.AssemblyAngularVelocity = v3_zero
    end
    if not keepTarget then CurrentTarget = nil end
end

-- Core Weld Engine
local function WeldTo(TPart, AnimId, UseCopy)
    local char = LP.Character
    if not char or not CachedMyRoot or not CachedMyHum then return nil end

    StateManager:StopAllAnimations()

    if UseCopy and CurrentTarget and AnimCopyEnabled then
        local myRig = getRig(LP)
        local tRig  = getRig(CurrentTarget)
        if myRig and tRig and myRig == tRig then
            local tc = CurrentTarget.Character
            local tHum = tc and tc:FindFirstChildOfClass("Humanoid")
            local tAnim = tHum and tHum:FindFirstChildOfClass("Animator")
            local mAnim = CachedMyHum:FindFirstChildOfClass("Animator")
            if tAnim and mAnim then
                for _, trk in ipairs(tAnim:GetPlayingAnimationTracks()) do
                    pcall(function()
                        local a = Instance.new("Animation")
                        a.AnimationId = trk.Animation.AnimationId
                        local nt = mAnim:LoadAnimation(a)
                        nt:AdjustSpeed(V.Speed)
                        nt:Play(trk.TimePosition or 0)
                        table.insert(CopiedTracks, nt)
                    end)
                end
            end
        end
    elseif AnimId and AnimId ~= 0 then
        local animator = CachedMyHum:FindFirstChildOfClass("Animator") or char:FindFirstChildWhichIsA("Animator", true)
        if animator then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://" .. tostring(AnimId)
            local ok, track = pcall(function() return animator:LoadAnimation(anim) end)
            if ok and track then
                pcall(function()
                    track:AdjustSpeed(V.Speed)
                    track:Play()
                end)
                table.insert(PlayedAnims, track)
            end
        end
    end

    for i = 1, #MyCharacterParts do
        local p = MyCharacterParts[i]
        if p.Parent then
            p.CanCollide = false
            p.Massless = true
        end
    end

    local initialOffset = cf_new(V.X, V.Y, V.Z) * cf_angles(m_rad(V.RX), m_rad(V.RY), m_rad(V.RZ))
    CachedMyRoot.CFrame = TPart.CFrame * initialOffset
    CachedMyRoot.AssemblyLinearVelocity = v3_zero
    CachedMyRoot.AssemblyAngularVelocity = v3_zero

    local WeldObj = {}
    local conn = nil

    conn = RunService.Heartbeat:Connect(function()
        if not char.Parent or not TPart.Parent or not CachedMyRoot then
            if WeldObj.Destroy then WeldObj:Destroy() end
            return
        end
        local currentOffset = cf_new(V.X, V.Y, V.Z) * cf_angles(m_rad(V.RX), m_rad(V.RY), m_rad(V.RZ))
        CachedMyRoot.CFrame = TPart.CFrame * currentOffset
        CachedMyRoot.AssemblyLinearVelocity = v3_zero
        CachedMyRoot.AssemblyAngularVelocity = v3_zero

        if sethiddenproperty then
            pcall(function()
                sethiddenproperty(CachedMyRoot, "PhysicsRepRootPart", TPart)
                if InstanceHandleNew then
                    sethiddenproperty(CachedMyRoot, "PhysicsRepRootRef", InstanceHandleNew(TPart))
                end
            end)
        end
    end)

    function WeldObj:Destroy()
        if conn then conn:Disconnect(); conn = nil end
        StateManager:StopAllAnimations()
        StateManager:StopThrust()
        StateManager:StopMotion()
        resetProceduralMotors()
        if CachedMyRoot then
            CachedMyRoot.AssemblyLinearVelocity = v3_zero
            CachedMyRoot.AssemblyAngularVelocity = v3_zero
        end
    end

    return WeldObj
end

local function startThrust(customMin, customMax)
    StateManager:StopThrust()
    ThrustActive = true
    if customMin and customMax then
        IsCustomZThrust = true
        ThrustZMin = customMin
        ThrustZMax = customMax
    end
    local t0 = tick()
    ThrustConn = RunService.Heartbeat:Connect(function()
        if not ThrustActive then return end
        local elapsed = tick() - t0
        local phase = (m_sin(elapsed * ThrustSpeed * m_pi * 2) + 1) / 2
        if IsCustomZThrust then
            V.Z = ThrustZMin + phase * (ThrustZMax - ThrustZMin)
        else
            V.Z = ThrustTouchZ + ThrustDirection * phase * ThrustRange
        end
    end)
end

local function startMotion(mode)
    StateManager:StopMotion()
    MotionMode = mode
    local t0 = tick()
    MotionConn = RunService.Heartbeat:Connect(function()
        if MotionMode == "none" then return end
        local t = tick() - t0
        if MotionMode == "orbit" then
            local angle = t * OrbitSpeed * m_pi * 2
            V.X = m_cos(angle) * OrbitRadius
            V.Z = m_sin(angle) * OrbitRadius
            V.Y = 0
        elseif MotionMode == "bounce" then
            V.Y = math.abs(m_sin(t * BounceSpeed * m_pi)) * BounceHeight
        end
    end)
end

local function storeWeldInfo(targetPlr, animId, wasThrust, wType, customData)
    if not targetPlr then return end
    LastWeldTargetUserId = targetPlr.UserId
    LastWeldAnimId       = animId or 0
    LastWeldWasThrust    = wasThrust or false
    LastWeldType         = wType or "weld"
    LastCustomData       = customData or {}
end

local performAutoReweld = nil

local function hookTargetRespawn(targetPlr)
    if not targetPlr then return end
    if targetPlr:FindFirstChild("__CocoPowderHookV21") then return end
    local marker = Instance.new("BoolValue")
    marker.Name = "__CocoPowderHookV21"
    marker.Parent = targetPlr

    targetPlr.CharacterAdded:Connect(function()
        if not AutoReweldEnabled then return end
        if targetPlr ~= selectedPlayer then return end
        if LastWeldTargetUserId ~= targetPlr.UserId then return end
        task.wait(1.2)
        if not targetPlr.Character or CurrentWeld then return end
        if performAutoReweld then performAutoReweld(targetPlr, "Respawn re-weld") end
    end)
end

LP.CharacterAdded:Connect(function()
    task.wait(1.0)
    if AutoReweldEnabled and selectedPlayer and selectedPlayer.Character and LastWeldTargetUserId == selectedPlayer.UserId then
        if performAutoReweld then performAutoReweld(selectedPlayer, "Player reset re-weld") end
    end
end)

-- Nebula Fling Core
launchNebulaFling = function(durationSeconds, modeTitle)
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select a target player first!")
        sError()
        return
    end

    local targetRoot = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not CachedMyRoot or not targetRoot then
        notify("COCO POWDER", "Target RootPart not found!")
        sError()
        return
    end

    local origCF = CachedMyRoot.CFrame
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    FlingActive = true

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    pcall(function() targetRoot:SetNetworkOwner(LP) end)
    storeWeldInfo(selectedPlayer, 0, false, "fling", {duration = durationSeconds})
    hookTargetRespawn(selectedPlayer)

    if FlingSidePanel then
        FlingSidePanel.Visible = true
        if FlingCountdownLabel then
            FlingCountdownLabel.Text = (durationSeconds > 0) and ("⏳ " .. tostring(m_floor(durationSeconds)) .. "s remaining") or "♾️ UNLIMITED"
        end
    end

    sFling()
    notify("COCO POWDER", "✨ Nebula Fling (" .. modeTitle .. ") → " .. selectedPlayer.Name)

    local startTime = tick()
    FlingConn = RunService.Heartbeat:Connect(function()
        if not FlingActive or not LP.Character or not targetRoot.Parent or not CachedMyRoot then
            StateManager:StopFling()
            return
        end

        local elapsed = tick() - startTime
        if durationSeconds > 0 then
            local remaining = math.max(0, durationSeconds - elapsed)
            if FlingCountdownLabel then
                FlingCountdownLabel.Text = "⏳ " .. string.format("%.1f", remaining) .. "s left"
            end
            if remaining <= 0 then
                StateManager:StopFling()
                if CachedMyRoot then
                    CachedMyRoot.AssemblyLinearVelocity = v3_zero
                    CachedMyRoot.AssemblyAngularVelocity = v3_zero
                    CachedMyRoot.CFrame = origCF
                end
                StateManager:Cleanup(true)
                notify("COCO POWDER", "✨ Nebula Fling Finished Safely!")
                sSuccess()
                return
            end
        end

        local t = tick() * 24
        local offsetX = m_cos(t) * 3.5
        local offsetZ = m_sin(t) * 3.5

        CachedMyRoot.CFrame = targetRoot.CFrame 
            * cf_new(offsetX, 1.8, offsetZ) 
            * cf_angles(math.random(-15, 15), t, math.random(-15, 15))

        CachedMyRoot.AssemblyLinearVelocity = Vector3.new(math.random(-5000, 5000), math.random(4000, 8000), math.random(-5000, 5000))
        CachedMyRoot.AssemblyAngularVelocity = Vector3.new(math.random(-800, 800), math.random(-800, 800), math.random(-800, 800))
    end)
end

-- Defensive Throttled Subsystems
local function enableAntiSit()
    AntiSitEnabled = true
    if AntiSitConn then AntiSitConn:Disconnect() end
    local lastCheck = 0
    AntiSitConn = RunService.Heartbeat:Connect(function()
        if not AntiSitEnabled or not CachedMyHum then return end
        local now = os.clock()
        if now - lastCheck < 0.1 then return end
        lastCheck = now
        
        if CachedMyHum.Sit then
            CachedMyHum.Sit = false
            CachedMyHum.Jump = true
            AntiSitCount = AntiSitCount + 1
            if AntiSitCountLabel then AntiSitCountLabel.Text = "🛡 Seats Blocked: " .. AntiSitCount end
            if LP.Character then
                for _, obj in ipairs(LP.Character:GetChildren()) do
                    if obj:IsA("Weld") and obj.Name == "SeatWeld" then
                        pcall(function() obj:Destroy() end)
                    end
                end
            end
        end
    end)
end

local function disableAntiSit()
    AntiSitEnabled = false
    if AntiSitConn then AntiSitConn:Disconnect(); AntiSitConn = nil end
end

local function enableAntiFling()
    AntiFlingEnabled = true
    if AntiFlingConn then AntiFlingConn:Disconnect() end
    local lastCheck = 0

    if CachedMyHum then
        CachedMyHum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        CachedMyHum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    end

    AntiFlingConn = RunService.Stepped:Connect(function()
        if not AntiFlingEnabled then return end
        local now = os.clock()
        if now - lastCheck < 0.066 then return end
        lastCheck = now

        if CachedMyRoot then
            local lv = CachedMyRoot.AssemblyLinearVelocity
            local av = CachedMyRoot.AssemblyAngularVelocity
            if lv.Magnitude > 100 then CachedMyRoot.AssemblyLinearVelocity = v3_zero end
            if av.Magnitude > 50 then CachedMyRoot.AssemblyAngularVelocity = v3_zero end
        end

        for _, other in ipairs(Players:GetPlayers()) do
            if other ~= LP and other.Character then
                local oRoot = other.Character:FindFirstChild("HumanoidRootPart")
                if oRoot and oRoot.CanCollide then oRoot.CanCollide = false end
            end
        end
    end)
end

local function disableAntiFling()
    AntiFlingEnabled = false
    if AntiFlingConn then AntiFlingConn:Disconnect(); AntiFlingConn = nil end
end

-- Throttled Anti-Void Thread
task.spawn(function()
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.IgnoreWater = true

    while true do
        task.wait(0.125)
        if AntiVoidEnabled and CachedMyRoot and CachedMyHum then
            local pos = CachedMyRoot.Position
            local vel = CachedMyRoot.AssemblyLinearVelocity

            if pos.Y <= -60 then
                if AntiVoidSafeCFrame then
                    CachedMyRoot.CFrame = AntiVoidSafeCFrame + Vector3.new(0, 4, 0)
                    CachedMyRoot.AssemblyLinearVelocity = v3_zero
                    CachedMyRoot.AssemblyAngularVelocity = v3_zero
                    AntiVoidRecoveries = AntiVoidRecoveries + 1
                    if AntiVoidStatusLabel then AntiVoidStatusLabel.Text = "🛡 Recovers: " .. AntiVoidRecoveries end
                    notify("ANTI-VOID", "Recovered from void drop!")
                end
            elseif vel.Y >= -3 and LP.Character then
                rayParams.FilterDescendantsInstances = { LP.Character }
                local hit = workspace:Raycast(pos, Vector3.new(0, -6, 0), rayParams)
                if hit then AntiVoidSafeCFrame = CachedMyRoot.CFrame end
            end
        end
    end
end)

local function checkVoiceEligibility()
    if not VoiceChatService then return "VoiceChat Unavailable", T.Danger end
    local ok, enabled = pcall(function() return VoiceChatService:IsVoiceEnabledForUserIdAsync(LP.UserId) end)
    if not ok then return "API Blocked / Offline", T.Warning end
    if enabled == true then return "Status: ELIGIBLE", T.Success
    elseif enabled == false then return "Status: NOT ENABLED", T.Danger end
    return "Status: UNKNOWN", T.Muted
end

-- Implementation of all Zero-Delay Actions
local function executeZeroDelayKiss()
    if not selectedPlayer or not selectedPlayer.Character then notify("COCO POWDER", "Select target player first!"); sError(); return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then notify("COCO POWDER", "Target Torso not found"); sError(); return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, 0, -1.5, 0, 180, 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    storeWeldInfo(selectedPlayer, ANIM_DB.Kiss.R15, true, "kiss")
    hookTargetRespawn(selectedPlayer)
    enableProceduralArmRaise("kiss")

    ThrustActive = true
    local t0 = tick()
    ThrustConn = RunService.Heartbeat:Connect(function()
        if not ThrustActive then return end
        V.Z = -1.6 + m_sin((tick() - t0) * 3.0) * 1.4
    end)

    local animId = getAnimIdForRig("Kiss", isR15(LP))
    CurrentWeld = WeldTo(targetTorso, animId, false)
    if CurrentWeld then sSuccess(); notify("COCO POWDER", "💋 Zero-Delay Kiss") else sError() end
end

local function executeZeroDelayHug()
    if not selectedPlayer or not selectedPlayer.Character then notify("COCO POWDER", "Select target player first!"); sError(); return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then notify("COCO POWDER", "Target Torso not found"); sError(); return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, 0, -0.8, 0, 180, 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    storeWeldInfo(selectedPlayer, ANIM_DB.Hug.R15, false, "hug")
    hookTargetRespawn(selectedPlayer)
    enableProceduralArmRaise("hug")

    local animId = getAnimIdForRig("Hug", isR15(LP))
    CurrentWeld = WeldTo(targetTorso, animId, false)
    if CurrentWeld then sSuccess(); notify("COCO POWDER", "🤗 Zero-Delay Hug") else sError() end
end

local function executeZeroDelay69()
    if not selectedPlayer or not selectedPlayer.Character then notify("COCO POWDER", "Select target player first!"); sError(); return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then notify("COCO POWDER", "Target Torso not found"); sError(); return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, 0, -1.5, 0, 180, 180

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    storeWeldInfo(selectedPlayer, ANIM_DB.Pos69.R15, true, "pos69")
    hookTargetRespawn(selectedPlayer)

    ThrustActive = true
    local t0 = tick()
    ThrustConn = RunService.Heartbeat:Connect(function()
        if not ThrustActive then return end
        V.Z = -1.5 + m_sin((tick() - t0) * 3.2) * 0.5
    end)

    local animId = getAnimIdForRig("Pos69", isR15(LP))
    CurrentWeld = WeldTo(targetTorso, animId, false)
    if CurrentWeld then sSuccess(); notify("COCO POWDER", "🔄 69 Position") else sError() end
end

local function executeZeroDelaySlap()
    if not selectedPlayer or not selectedPlayer.Character then notify("COCO POWDER", "Select target player first!"); sError(); return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then notify("COCO POWDER", "Target Torso not found"); sError(); return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, 0, -1.5, 0, 180, 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    storeWeldInfo(selectedPlayer, 0, false, "slap")
    hookTargetRespawn(selectedPlayer)

    local animId = getAnimIdForRig("Slap", isR15(LP))
    CurrentWeld = WeldTo(targetTorso, animId, false)
    if CurrentWeld then sSlap(); notify("COCO POWDER", "👋 Slap Executed") else sError() end
end

local function executeZeroDelayKick()
    if not CachedMyHum then return end
    StateManager:Cleanup(true)
    local animId = getAnimIdForRig("Kick", isR15(LP))
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. tostring(animId)
    local ok, track = pcall(function() return CachedMyHum:LoadAnimation(anim) end)
    if ok and track then
        track:AdjustSpeed(1.6)
        track:Play()
        table.insert(PlayedAnims, track)
        sSuccess()
        notify("COCO POWDER", "🦵 Kick Executed!")
    else
        sError()
    end
end

local function executeShoulderSit()
    if not selectedPlayer or not selectedPlayer.Character then notify("COCO POWDER", "Select target player first!"); sError(); return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    local userR15 = isR15(LP)
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 1.5, (userR15 and 2.2 or 1.8), 0, 0, 0, 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local animId = getAnimIdForRig("ShoulderSit", userR15)
    storeWeldInfo(selectedPlayer, animId, false, "shoulder")
    hookTargetRespawn(selectedPlayer)

    CurrentWeld = WeldTo(targetTorso, animId, false)
    if CurrentWeld then sSuccess(); notify("COCO POWDER", "🪑 Shoulder Sit") end
end

local function executeHeadSit()
    if not selectedPlayer or not selectedPlayer.Character then notify("COCO POWDER", "Select target player first!"); sError(); return end
    local head = selectedPlayer.Character:FindFirstChild("Head") or getTargetTorso(selectedPlayer.Character)
    if not head then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    local userR15 = isR15(LP)
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, (userR15 and 3.0 or 2.5), 0, 0, 0, 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local animId = getAnimIdForRig("HeadSit", userR15)
    storeWeldInfo(selectedPlayer, animId, false, "headsit")
    hookTargetRespawn(selectedPlayer)

    CurrentWeld = WeldTo(head, animId, false)
    if CurrentWeld then sSuccess(); notify("COCO POWDER", "🪑 Head Sit") end
end

local function executeBackpack()
    if not selectedPlayer or not selectedPlayer.Character then notify("COCO POWDER", "Select target player first!"); sError(); return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, 0.2, 1.15, 0, 180, 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local animId = getAnimIdForRig("Backpack", isR15(LP))
    storeWeldInfo(selectedPlayer, animId, false, "backpack")
    hookTargetRespawn(selectedPlayer)

    CurrentWeld = WeldTo(targetTorso, animId, false)
    if CurrentWeld then sSuccess(); notify("COCO POWDER", "🎒 Backpack Seated") end
end

local function executeCarry()
    if not selectedPlayer or not selectedPlayer.Character then notify("COCO POWDER", "Select target player first!"); sError(); return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    local userR15 = isR15(LP)
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, 1.0, (userR15 and 2.0 or 1.5), 0, 0, 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local animId = getAnimIdForRig("Carry", userR15)
    storeWeldInfo(selectedPlayer, animId, false, "carry")
    hookTargetRespawn(selectedPlayer)

    CurrentWeld = WeldTo(targetTorso, animId, false)
    if CurrentWeld then sSuccess(); notify("COCO POWDER", "🎪 Carry Active") end
end

local function executeZeroDelayStare()
    if not selectedPlayer or not selectedPlayer.Character then notify("COCO POWDER", "Select target player first!"); sError(); return end
    local targetRoot = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot or not CachedMyRoot then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    storeWeldInfo(selectedPlayer, 0, false, "stare")
    hookTargetRespawn(selectedPlayer)

    CachedMyRoot.CFrame = cf_new(targetRoot.Position + targetRoot.CFrame.LookVector * 2.5, targetRoot.Position)
    local conn = RunService.Heartbeat:Connect(function()
        if not LP.Character or not selectedPlayer.Character or not CachedMyRoot then return end
        CachedMyRoot.CFrame = cf_new(targetRoot.Position + targetRoot.CFrame.LookVector * 2.5, targetRoot.Position)
        CachedMyRoot.AssemblyLinearVelocity = v3_zero
        CachedMyRoot.AssemblyAngularVelocity = v3_zero
    end)

    local StareWeld = {}
    function StareWeld:Destroy() if conn then conn:Disconnect(); conn = nil end end
    CurrentWeld = StareWeld
    sSuccess()
    notify("COCO POWDER", "👁️ Staring at " .. selectedPlayer.Name)
end

local function runPreset(x, y, z, rx, ry, rz, animId, presetName)
    if not selectedPlayer or not selectedPlayer.Character then notify("COCO POWDER", "Select target player first!"); sError(); return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = x, y, z, rx, ry, rz
    pcall(function()
        if UIRefs.SlX then UIRefs.SlX.set(x, false) end
        if UIRefs.SlY then UIRefs.SlY.set(y, false) end
        if UIRefs.SlZ then UIRefs.SlZ.set(z, false) end
        if UIRefs.SlRX then UIRefs.SlRX.set(rx, false) end
        if UIRefs.SlRY then UIRefs.SlRY.set(ry, false) end
        if UIRefs.SlRZ then UIRefs.SlRZ.set(rz, false) end
    end)
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end
    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    storeWeldInfo(selectedPlayer, animId, false, "preset")
    hookTargetRespawn(selectedPlayer)
    CurrentWeld = WeldTo(targetTorso, animId, false)
    if CurrentWeld then sSuccess(); notify("COCO POWDER", (presetName or "Preset") .. " Active") end
end

local function runBang(animId, speed, rangeOverride)
    if not selectedPlayer or not selectedPlayer.Character then notify("COCO POWDER", "Select player first!"); sError(); return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end

    local touchZ = (getTorsoDepth(LP.Character) + getTorsoDepth(selectedPlayer.Character)) / 2 + 0.15
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, 0, touchZ, 0, 0, 0
    ThrustTouchZ = touchZ
    ThrustDirection = 1

    if rangeOverride then ThrustRange = rangeOverride end
    if speed then ThrustSpeed = speed end

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    storeWeldInfo(selectedPlayer, animId, true, "bang")
    hookTargetRespawn(selectedPlayer)

    CurrentWeld = WeldTo(targetTorso, animId, false)
    if CurrentWeld then startThrust(); sSuccess() end
end

local function runFBang(animId, speed, isAggressive)
    if not selectedPlayer or not selectedPlayer.Character then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    local head = selectedPlayer.Character:FindFirstChild("Head") or getTargetTorso(selectedPlayer.Character)
    if not head then return end

    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, 2.5, -1.5, 0, 180, 0
    startThrust(-4.0, -0.4)
    if speed then ThrustSpeed = speed end

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    storeWeldInfo(selectedPlayer, animId, true, isAggressive and "fbangagg" or "fbang")
    hookTargetRespawn(selectedPlayer)

    CurrentWeld = WeldTo(head, animId, false)
    if CurrentWeld then sSuccess() end
end

performAutoReweld = function(targetPlr, reasonText)
    if not AutoReweldEnabled or not targetPlr or not targetPlr.Character then return end
    if LastWeldType == "kiss" then executeZeroDelayKiss() return
    elseif LastWeldType == "hug" then executeZeroDelayHug() return
    elseif LastWeldType == "pos69" then executeZeroDelay69() return
    elseif LastWeldType == "shoulder" then executeShoulderSit() return
    elseif LastWeldType == "headsit" then executeHeadSit() return
    elseif LastWeldType == "backpack" then executeBackpack() return
    elseif LastWeldType == "carry" then executeCarry() return
    elseif LastWeldType == "slap" then executeZeroDelaySlap() return
    elseif LastWeldType == "stare" then executeZeroDelayStare() return
    elseif LastWeldType == "bang" then runBang(LastWeldAnimId or 148840371, 2.2) return
    end

    local targetTorso = getTargetTorso(targetPlr.Character)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = targetPlr
    selectedPlayer = targetPlr

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    CurrentWeld = WeldTo(targetTorso, LastWeldAnimId, AnimCopyEnabled)
    if CurrentWeld then
        if LastWeldWasThrust then startThrust() end
        sSuccess()
    end
end

-- 35 Feature Functions Attached to StateManager
function StateManager.executeBackOrbit()
    if not selectedPlayer or not selectedPlayer.Character then return end
    local targetRoot = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot or not CachedMyRoot then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    storeWeldInfo(selectedPlayer, 0, false, "back_orbit")
    hookTargetRespawn(selectedPlayer)
    local t0 = tick()
    local conn = RunService.RenderStepped:Connect(function()
        if not CachedMyRoot or not targetRoot.Parent then return end
        local angle = (tick() - t0) * OrbitSpeed * m_pi * 2
        CachedMyRoot.CFrame = cf_new(targetRoot.Position + Vector3.new(m_cos(angle) * OrbitRadius, 0, m_sin(angle) * OrbitRadius), targetRoot.Position)
    end)
    local OrbitWeld = {}
    function OrbitWeld:Destroy() if conn then conn:Disconnect(); conn = nil end end
    CurrentWeld = OrbitWeld
    sSuccess()
end

function StateManager.executeBackpackRide()
    if not selectedPlayer or not selectedPlayer.Character then return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, 0.5, 0.8, 0, 180, 0
    CurrentWeld = WeldTo(targetTorso, getAnimIdForRig("Backpack", isR15(LP)), false)
    sSuccess()
end

function StateManager.executeFootSit()
    if not selectedPlayer or not selectedPlayer.Character then return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, -2.0, 0.2, 0, 0, 0
    CurrentWeld = WeldTo(targetTorso, getAnimIdForRig("Sit", isR15(LP)), false)
    sSuccess()
end

function StateManager.executeSideGlanceLock()
    if not selectedPlayer or not selectedPlayer.Character then return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 1.5, 0, 0, 0, -90, 0
    CurrentWeld = WeldTo(targetTorso, 0, false)
    sSuccess()
end

function StateManager.executePhaseShift()
    if not selectedPlayer or not selectedPlayer.Character or not CachedMyRoot then return end
    local targetRoot = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    StateManager:Cleanup(true)
    CachedMyRoot.CFrame = targetRoot.CFrame * cf_new(0, 0, 3)
    sWhoosh()
end

function StateManager.executeShadowGlitch()
    if not selectedPlayer or not selectedPlayer.Character then return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, 0, 0, 0, 0, 0
    CurrentWeld = WeldTo(targetTorso, 0, false)
    sSuccess()
end

function StateManager.executeCrawlerPosition()
    if not selectedPlayer or not selectedPlayer.Character then return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, -2.2, 1.5, 90, 0, 0
    CurrentWeld = WeldTo(targetTorso, getAnimIdForRig("Prone", isR15(LP)), false)
    sSuccess()
end

function StateManager.executeHoverCrown()
    if not selectedPlayer or not selectedPlayer.Character then return end
    local head = selectedPlayer.Character:FindFirstChild("Head") or getTargetTorso(selectedPlayer.Character)
    if not head or not CachedMyRoot then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    local t0 = tick()
    local conn = RunService.RenderStepped:Connect(function()
        if not CachedMyRoot or not head.Parent then return end
        local elapsed = tick() - t0
        CachedMyRoot.CFrame = head.CFrame * cf_new(0, 3.0, 0) * cf_angles(0, elapsed * 2.0, 0)
    end)
    local CrownWeld = {}
    function CrownWeld:Destroy() if conn then conn:Disconnect(); conn = nil end end
    CurrentWeld = CrownWeld
    sSuccess()
end

function StateManager.executeLegDragFollow()
    if not selectedPlayer or not selectedPlayer.Character then return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, -2.2, -1.6, 80, 0, 0
    CurrentWeld = WeldTo(targetTorso, getAnimIdForRig("Prone", isR15(LP)), false)
    sSuccess()
end

function StateManager.executeReversePOV()
    if not selectedPlayer or not selectedPlayer.Character then return end
    local targetHead = selectedPlayer.Character:FindFirstChild("Head")
    if not targetHead or not CachedMyRoot or not cam then return end
    if StateManager.ReversePOVConn then StateManager.ReversePOVConn:Disconnect(); StateManager.ReversePOVConn = nil end
    StateManager.ReversePOVActive = true
    OriginalCameraSubject = cam.CameraSubject
    cam.CameraType = Enum.CameraType.Scriptable
    StateManager.ReversePOVConn = RunService.RenderStepped:Connect(function()
        if not StateManager.ReversePOVActive or not targetHead.Parent or not CachedMyRoot then return end
        cam.CFrame = cf_new(targetHead.Position, CachedMyRoot.Position)
    end)
    sSuccess()
end

function StateManager.executeBowDown()
    if not selectedPlayer or not selectedPlayer.Character then return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, -1.8, -2.0, 60, 180, 0
    CurrentWeld = WeldTo(targetTorso, getAnimIdForRig("Bow", isR15(LP)), false)
    sSuccess()
end

function StateManager.executePointMock()
    if not selectedPlayer or not selectedPlayer.Character then return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, 0, -2.5, 0, 180, 0
    CurrentWeld = WeldTo(targetTorso, getAnimIdForRig("Point", isR15(LP)), false)
    StateManager.sLaugh()
end

function StateManager.executeBlowKiss()
    if not selectedPlayer or not selectedPlayer.Character then return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, 0, -2.0, 0, 180, 0
    CurrentWeld = WeldTo(targetTorso, getAnimIdForRig("Slap", isR15(LP)), false)
    sSuccess()
end

function StateManager.executeFlexPose()
    if not selectedPlayer or not selectedPlayer.Character then return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, 0, -2.5, 0, 180, 0
    CurrentWeld = WeldTo(targetTorso, getAnimIdForRig("Flex", isR15(LP)), false)
    sSuccess()
end

function StateManager.executeFakeUppercut()
    if not selectedPlayer or not selectedPlayer.Character or not CachedMyRoot then return end
    local targetRoot = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    CachedMyRoot.CFrame = targetRoot.CFrame * cf_new(0, 0, -1.8) * cf_angles(0, m_rad(180), 0)
    sWhoosh()
    task.wait(0.08)
    StateManager.sPunch()
    CachedMyRoot.CFrame = CachedMyRoot.CFrame * cf_new(0, 2.5, 0)
    CachedMyRoot.AssemblyLinearVelocity = Vector3.new(0, 35, 0)
    task.delay(0.2, function()
        if CachedMyRoot then CachedMyRoot.AssemblyLinearVelocity = v3_zero end
    end)
end

function StateManager.executeSlapBack()
    if not selectedPlayer or not selectedPlayer.Character then return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, 0, -1.5, 0, 0, 0
    CurrentWeld = WeldTo(targetTorso, getAnimIdForRig("Slap", isR15(LP)), false)
    startThrust(-1.8, -1.0)
    sSlap()
end

function StateManager.executeHandshakePose()
    if not selectedPlayer or not selectedPlayer.Character then return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, 0, -2.2, 0, 180, 0
    CurrentWeld = WeldTo(targetTorso, getAnimIdForRig("Handshake", isR15(LP)), false)
    enableProceduralArmRaise("handshake")
    sSuccess()
end

function StateManager.executePatHead()
    if not selectedPlayer or not selectedPlayer.Character then return end
    local head = selectedPlayer.Character:FindFirstChild("Head") or getTargetTorso(selectedPlayer.Character)
    if not head then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, 0.4, -1.6, 0, 180, 0
    CurrentWeld = WeldTo(head, getAnimIdForRig("Pat", isR15(LP)), false)
    enableProceduralArmRaise("pat")
    sSuccess()
end

function StateManager.executeBellyDance()
    if not selectedPlayer or not selectedPlayer.Character then return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, 0, -2.0, 0, 0, 0
    CurrentWeld = WeldTo(targetTorso, getAnimIdForRig("Twerk", isR15(LP)), false)
    sSuccess()
end

function StateManager.executeSpankOffset()
    if not selectedPlayer or not selectedPlayer.Character then return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, -0.2, -1.2, 0, 0, 0
    CurrentWeld = WeldTo(targetTorso, getAnimIdForRig("Slap", isR15(LP)), false)
    startThrust(-1.8, -0.8)
    sSlap()
end

function StateManager.toggleAutoLookAt()
    if StateManager.AutoLookAtActive then
        if StateManager.AutoLookAtConn then StateManager.AutoLookAtConn:Disconnect(); StateManager.AutoLookAtConn = nil end
        StateManager.AutoLookAtActive = false
        if CachedMyHum then pcall(function() CachedMyHum.AutoRotate = true end) end
        sToggleOff()
    else
        if not selectedPlayer or not selectedPlayer.Character then notify("COCO POWDER", "Select target player first!"); sError(); return end
        StateManager.AutoLookAtActive = true
        sToggleOn()
        StateManager.AutoLookAtConn = RunService.RenderStepped:Connect(function()
            if not StateManager.AutoLookAtActive or not CachedMyRoot then return end
            local tc = selectedPlayer and selectedPlayer.Character
            local targetRoot = tc and tc:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                if CachedMyHum and CachedMyHum.AutoRotate then CachedMyHum.AutoRotate = false end
                local flatDir = Vector3.new(targetRoot.Position.X - CachedMyRoot.Position.X, 0, targetRoot.Position.Z - CachedMyRoot.Position.Z)
                if flatDir.Magnitude > 0.05 then CachedMyRoot.CFrame = cf_new(CachedMyRoot.Position, CachedMyRoot.Position + flatDir) end
            end
        end)
    end
end

function StateManager.toggleTargetCamLock()
    if StateManager.TargetCamLockActive then
        pcall(function() RunService:UnbindFromRenderStep("CocoPowderTargetCamLock") end)
        StateManager.TargetCamLockActive = false
        sToggleOff()
    else
        if not selectedPlayer or not selectedPlayer.Character then notify("COCO POWDER", "Select target player first!"); sError(); return end
        StateManager.TargetCamLockActive = true
        sToggleOn()
        RunService:BindToRenderStep("CocoPowderTargetCamLock", Enum.RenderPriority.Camera.Value + 1, function()
            if not StateManager.TargetCamLockActive then return end
            local tc = selectedPlayer and selectedPlayer.Character
            local targetHead = tc and (tc:FindFirstChild("Head") or tc:FindFirstChild("HumanoidRootPart"))
            if targetHead and cam then
                local desiredCF = cf_new(cam.CFrame.Position, targetHead.Position)
                cam.CFrame = cam.CFrame:Lerp(desiredCF, 0.25)
            end
        end)
    end
end

function StateManager.executeInvisibilityTeleport()
    if not selectedPlayer or not selectedPlayer.Character or not CachedMyRoot then return end
    local targetRoot = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    sWhoosh()
    for i = 1, #MyCharacterParts do
        local p = MyCharacterParts[i]
        if p.Parent then p.LocalTransparencyModifier = 1 end
    end
    task.spawn(function()
        task.wait(0.08)
        local behindCF = targetRoot.CFrame * cf_new(0, 0, 2.8)
        CachedMyRoot.CFrame = cf_new(behindCF.Position, targetRoot.Position)
        task.wait(0.12)
        for i = 1, #MyCharacterParts do
            local p = MyCharacterParts[i]
            if p.Parent then p.LocalTransparencyModifier = 0 end
        end
        sSuccess()
    end)
end

function StateManager.toggleSpinAttack()
    if StateManager.SpinAttackActive then
        if StateManager.SpinAttackConn then StateManager.SpinAttackConn:Disconnect(); StateManager.SpinAttackConn = nil end
        StateManager.SpinAttackActive = false
        if CachedMyHum then pcall(function() CachedMyHum.AutoRotate = true end) end
        if CachedMyRoot then CachedMyRoot.AssemblyAngularVelocity = v3_zero end
        sToggleOff()
    else
        if not CachedMyRoot then return end
        StateManager.SpinAttackActive = true
        if CachedMyHum then pcall(function() CachedMyHum.AutoRotate = false end) end
        sToggleOn()
        StateManager.SpinAttackConn = RunService.Heartbeat:Connect(function()
            if not StateManager.SpinAttackActive or not CachedMyRoot then return end
            CachedMyRoot.CFrame = CachedMyRoot.CFrame * cf_angles(0, m_rad(36), 0)
            CachedMyRoot.AssemblyAngularVelocity = Vector3.new(0, 80, 0)
        end)
    end
end

function StateManager.executeFakeFlingArc()
    if StateManager.FakeFlingArcActive then
        if StateManager.FakeFlingArcConn then StateManager.FakeFlingArcConn:Disconnect(); StateManager.FakeFlingArcConn = nil end
        StateManager.FakeFlingArcActive = false
        sToggleOff()
        return
    end
    if not selectedPlayer or not selectedPlayer.Character or not CachedMyRoot then return end
    local targetRoot = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    StateManager.FakeFlingArcActive = true
    sToggleOn()
    local t0 = tick()
    StateManager.FakeFlingArcConn = RunService.Heartbeat:Connect(function()
        if not StateManager.FakeFlingArcActive or not CachedMyRoot or not targetRoot.Parent then return end
        local t = (tick() - t0) * 3
        CachedMyRoot.CFrame = targetRoot.CFrame * cf_new(m_cos(t) * 3.8, math.abs(m_sin(t * 1.5)) * 4.5, m_sin(t) * 3.8) * cf_angles(m_sin(t) * 0.5, t * 2, 0)
    end)
    local ArcWeld = {}
    function ArcWeld:Destroy()
        if StateManager.FakeFlingArcConn then StateManager.FakeFlingArcConn:Disconnect(); StateManager.FakeFlingArcConn = nil end
        StateManager.FakeFlingArcActive = false
    end
    CurrentWeld = ArcWeld
    sFling()
end

function StateManager.toggleCopyVelocity()
    if StateManager.CopyVelocityActive then
        if StateManager.CopyVelocityConn then StateManager.CopyVelocityConn:Disconnect(); StateManager.CopyVelocityConn = nil end
        StateManager.CopyVelocityActive = false
        sToggleOff()
    else
        if not selectedPlayer or not selectedPlayer.Character then notify("COCO POWDER", "Select target player first!"); sError(); return end
        StateManager.CopyVelocityActive = true
        sToggleOn()
        StateManager.CopyVelocityConn = RunService.Heartbeat:Connect(function()
            if not StateManager.CopyVelocityActive or not CachedMyRoot then return end
            local tc = selectedPlayer and selectedPlayer.Character
            local targetRoot = tc and tc:FindFirstChild("HumanoidRootPart")
            local targetHum = tc and tc:FindFirstChildOfClass("Humanoid")
            if targetRoot and CachedMyHum and targetHum then
                CachedMyRoot.AssemblyLinearVelocity = targetRoot.AssemblyLinearVelocity
                CachedMyRoot.AssemblyAngularVelocity = targetRoot.AssemblyAngularVelocity
                CachedMyHum:Move(targetHum.MoveDirection, false)
                if targetHum.Jump then CachedMyHum.Jump = true end
            end
        end)
    end
end

function StateManager.toggleNoclipWalk()
    if StateManager.NoclipActive then
        if StateManager.NoclipConn then StateManager.NoclipConn:Disconnect(); StateManager.NoclipConn = nil end
        StateManager.NoclipActive = false
        sToggleOff()
    else
        StateManager.NoclipActive = true
        sToggleOn()
        local lastRefresh = 0
        StateManager.NoclipConn = RunService.Stepped:Connect(function()
            local now = os.clock()
            if now - lastRefresh < 0.1 then return end
            lastRefresh = now
            for i = 1, #MyCharacterParts do
                local p = MyCharacterParts[i]
                if p.Parent and p.CanCollide then p.CanCollide = false end
            end
        end)
    end
end

function StateManager.executeHeightMatch()
    if not selectedPlayer or not selectedPlayer.Character or not CachedMyRoot then return end
    local tc = selectedPlayer.Character
    local targetHead = tc:FindFirstChild("Head") or tc:FindFirstChild("HumanoidRootPart")
    if not targetHead then return end
    local deltaY = targetHead.Position.Y - CachedMyRoot.Position.Y
    V.Y = m_clamp(V.Y + deltaY, -10, 10)
    if UIRefs.SlY and UIRefs.SlY.set then UIRefs.SlY.set(V.Y, true) end
    sSuccess()
end

function StateManager.toggleDistanceKeeper()
    if StateManager.DistanceKeeperActive then
        if StateManager.DistanceKeeperConn then StateManager.DistanceKeeperConn:Disconnect(); StateManager.DistanceKeeperConn = nil end
        StateManager.DistanceKeeperActive = false
        sToggleOff()
    else
        if not selectedPlayer or not selectedPlayer.Character then return end
        StateManager.DistanceKeeperActive = true
        sToggleOn()
        StateManager.DistanceKeeperConn = RunService.Heartbeat:Connect(function()
            if not StateManager.DistanceKeeperActive or not CachedMyRoot then return end
            local tc = selectedPlayer and selectedPlayer.Character
            local targetRoot = tc and tc:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local diff = CachedMyRoot.Position - targetRoot.Position
                local flatDiff = Vector3.new(diff.X, 0, diff.Z)
                if flatDiff.Magnitude > 0.05 then
                    local desiredPos = targetRoot.Position + flatDiff.Unit * StateManager.DistanceKeeperRadius
                    CachedMyRoot.CFrame = cf_new(Vector3.new(desiredPos.X, CachedMyRoot.Position.Y, desiredPos.Z), targetRoot.Position)
                end
            end
        end)
    end
end

function StateManager.executeTrueKiss()
    if not selectedPlayer or not selectedPlayer.Character then return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, 0, -1.4, 0, 180, 0
    enableProceduralArmRaise("kiss")
    ThrustActive = true
    local t0 = tick()
    ThrustConn = RunService.Heartbeat:Connect(function()
        if not ThrustActive then return end
        V.Z = -1.4 + m_sin((tick() - t0) * 3.2) * 1.1
    end)
    CurrentWeld = WeldTo(targetTorso, 3576686446, false)
    if CurrentWeld then sSuccess() else sError() end
end

function StateManager.executeRomanceClasp()
    if not selectedPlayer or not selectedPlayer.Character then return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, 0, -1.2, 0, 180, 0
    enableProceduralArmRaise("hug")
    CurrentWeld = WeldTo(targetTorso, 10281064499, false)
    if CurrentWeld then sSuccess() end
end

function StateManager.executePassionGrip()
    if not selectedPlayer or not selectedPlayer.Character then return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, 0, 1.3, 0, 0, 0
    CurrentWeld = WeldTo(targetTorso, 82810853201599, false)
    if CurrentWeld then startThrust(-1.8, -0.6); sSuccess() end
end

function StateManager.executeR6Jerk(isSolo)
    StateManager:Cleanup(not isSolo)
    StateManager.JerkActive = true
    enableProceduralArmRaise("jerk")
    if not isSolo and selectedPlayer and selectedPlayer.Character then
        CurrentTarget = selectedPlayer
        hookTargetRespawn(selectedPlayer)
        local targetTorso = getTargetTorso(selectedPlayer.Character)
        if targetTorso then
            V.X, V.Y, V.Z, V.RX, V.RY, V.RZ = 0, 0, -1.8, 0, 180, 0
            CurrentWeld = WeldTo(targetTorso, 148840371, false)
        end
    end
    sClick()
end

-- Nebula prompt
promptNebulaFling = function()
    if not selectedPlayer then notify("COCO POWDER", "Select target player first!"); sError(); return end
    launchNebulaFling(3.0, "3 Seconds")
end

-- GUI Elements
local vp = cam.ViewportSize
local screenW = (vp and vp.X > 400) and vp.X or 1280
local screenH = (vp and vp.Y > 400) and vp.Y or 720
local W = m_clamp(screenW - 40, 420, 480)
local H = 370

local gui = Instance.new("ScreenGui")
gui.Name = "CocoPowderV21"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.Parent = GuiParent

local mobToggle = Instance.new("TextButton")
mobToggle.Name = "CocoPowderMobileToggle"
mobToggle.Size = UDim2.new(0, 42, 0, 42)
mobToggle.Position = UDim2.new(0, 16, 0.5, -21)
mobToggle.BackgroundColor3 = T.Accent
mobToggle.Text = "⚡"
mobToggle.TextSize = 20
mobToggle.Font = Enum.Font.GothamBold
mobToggle.TextColor3 = Color3.new(1, 1, 1)
mobToggle.ZIndex = 999
mobToggle.Parent = gui
Instance.new("UICorner", mobToggle).CornerRadius = UDim.new(1, 0)

local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Size = UDim2.new(0, W, 0, H)
main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
main.BackgroundColor3 = T.BG
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Active = true
main.ZIndex = 5
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

main.Visible = false
mobToggle.Visible = false

mobToggle.MouseButton1Click:Connect(function()
    sClick()
    main.Visible = not main.Visible
end)

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 44)
header.BackgroundColor3 = T.Panel
header.BorderSizePixel = 0
header.ZIndex = 6
header.Parent = main
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -150, 1, 0)
title.Position = UDim2.new(0, 14, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ COCO POWDER"
title.TextColor3 = T.Accent
title.Font = Enum.Font.GothamBlack
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 8
title.Parent = header

local btnMin = Instance.new("TextButton")
btnMin.Size = UDim2.new(0, 28, 0, 28)
btnMin.Position = UDim2.new(1, -66, 0, 8)
btnMin.BackgroundColor3 = T.PanelLt
btnMin.Text = "—"
btnMin.TextColor3 = T.Text
btnMin.Font = Enum.Font.GothamBold
btnMin.TextSize = 12
btnMin.ZIndex = 8
btnMin.Parent = header
Instance.new("UICorner", btnMin).CornerRadius = UDim.new(0, 6)

local btnClose = Instance.new("TextButton")
btnClose.Size = UDim2.new(0, 28, 0, 28)
btnClose.Position = UDim2.new(1, -34, 0, 8)
btnClose.BackgroundColor3 = T.Danger
btnClose.Text = "✕"
btnClose.TextColor3 = Color3.new(1, 1, 1)
btnClose.Font = Enum.Font.GothamBold
btnClose.TextSize = 12
btnClose.ZIndex = 8
btnClose.Parent = header
Instance.new("UICorner", btnClose).CornerRadius = UDim.new(0, 6)

btnMin.MouseButton1Click:Connect(function()
    sClick()
    main.Visible = false
end)

btnClose.MouseButton1Click:Connect(function()
    sClick()
    StateManager:Cleanup(false)
    disableAntiSit()
    disableAntiFling()
    AntiVoidEnabled = false
    gui:Destroy()
end)

local dragging, dragStart, startPos
header.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = inp.Position; startPos = main.Position
    end
end)
UIS.InputChanged:Connect(function(inp)
    if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        local d = inp.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

local tabsBar = Instance.new("ScrollingFrame")
tabsBar.Name = "TabsBar"
tabsBar.Size = UDim2.new(1, 0, 0, 40)
tabsBar.Position = UDim2.new(0, 0, 0, 44)
tabsBar.BackgroundColor3 = T.BG2
tabsBar.BorderSizePixel = 0
tabsBar.ScrollBarThickness = 0
tabsBar.ScrollingDirection = Enum.ScrollingDirection.X
tabsBar.AutomaticCanvasSize = Enum.AutomaticSize.X
tabsBar.ZIndex = 6
tabsBar.Parent = main

local tabsLayout = Instance.new("UIListLayout")
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
tabsLayout.Padding = UDim.new(0, 4)
tabsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabsLayout.Parent = tabsBar

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, 0, 1, -140)
content.Position = UDim2.new(0, 0, 0, 84)
content.BackgroundTransparency = 1
content.ZIndex = 6
content.Parent = main

local footer = Instance.new("Frame")
footer.Name = "Footer"
footer.Size = UDim2.new(1, 0, 0, 56)
footer.Position = UDim2.new(0, 0, 1, -56)
footer.BackgroundColor3 = T.Panel
footer.BorderSizePixel = 0
footer.ZIndex = 6
footer.Parent = main

local footerLabel = Instance.new("TextLabel")
footerLabel.Size = UDim2.new(1, -220, 0, 20)
footerLabel.Position = UDim2.new(0, 14, 0, 8)
footerLabel.BackgroundTransparency = 1
footerLabel.Text = "👤 No player selected"
footerLabel.TextColor3 = T.Muted
footerLabel.Font = Enum.Font.GothamBold
footerLabel.TextSize = 11
footerLabel.TextXAlignment = Enum.TextXAlignment.Left
footerLabel.ZIndex = 8
footerLabel.Parent = footer

local footerSub = Instance.new("TextLabel")
footerSub.Size = UDim2.new(1, -220, 0, 16)
footerSub.Position = UDim2.new(0, 14, 0, 28)
footerSub.BackgroundTransparency = 1
footerSub.Text = "Select a player to begin"
footerSub.TextColor3 = T.Muted
footerSub.Font = Enum.Font.Gotham
footerSub.TextSize = 9
footerSub.TextXAlignment = Enum.TextXAlignment.Left
footerSub.ZIndex = 8
footerSub.Parent = footer

local btnWeld = Instance.new("TextButton")
btnWeld.Size = UDim2.new(0, 95, 0, 38)
btnWeld.Position = UDim2.new(1, -207, 0, 9)
btnWeld.Text = "🔗 WELD"
btnWeld.TextColor3 = Color3.new(1, 1, 1)
btnWeld.Font = Enum.Font.GothamBlack
btnWeld.TextSize = 12
btnWeld.BackgroundColor3 = T.Accent
btnWeld.ZIndex = 8
btnWeld.Parent = footer
Instance.new("UICorner", btnWeld).CornerRadius = UDim.new(0, 8)

local btnUnweld = Instance.new("TextButton")
btnUnweld.Size = UDim2.new(0, 95, 0, 38)
btnUnweld.Position = UDim2.new(1, -105, 0, 9)
btnUnweld.Text = "🔓 UNWELD"
btnUnweld.TextColor3 = Color3.new(1, 1, 1)
btnUnweld.Font = Enum.Font.GothamBlack
btnUnweld.TextSize = 12
btnUnweld.BackgroundColor3 = T.Danger
btnUnweld.ZIndex = 8
btnUnweld.Parent = footer
Instance.new("UICorner", btnUnweld).CornerRadius = UDim.new(0, 8)

local TabPages, TabButtons = {}, {}

local function showTab(name)
    for n, p in pairs(TabPages) do p.Visible = (n == name) end
    for n, b in pairs(TabButtons) do
        local act = (n == name)
        b.BackgroundColor3 = act and T.Accent or T.Panel
        b.TextColor3 = act and Color3.new(1, 1, 1) or T.Muted
    end
end

local function createTab(name, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 84, 0, 26)
    btn.BackgroundColor3 = T.Panel
    btn.Text = icon .. " " .. name
    btn.TextColor3 = T.Muted
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.ZIndex = 7
    btn.Parent = tabsBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function() sClick(); showTab(name) end)
    TabButtons[name] = btn

    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = T.Accent
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.ZIndex = 6
    page.Parent = content

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 6); pad.PaddingBottom = UDim.new(0, 6)
    pad.PaddingLeft = UDim.new(0, 8); pad.PaddingRight = UDim.new(0, 8)
    pad.Parent = page

    local lst = Instance.new("UIListLayout")
    lst.Padding = UDim.new(0, 5)
    lst.SortOrder = Enum.SortOrder.LayoutOrder
    lst.Parent = page

    TabPages[name] = page
    return page
end

local function sectionLbl(parent, order, txt, color)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 16)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = color or T.Accent
    l.Font = Enum.Font.GothamBlack
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.LayoutOrder = order
    l.ZIndex = 7
    l.Parent = parent
    return l
end

local function makeGridRow(parent, order, btns)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 36)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order
    row.ZIndex = 7
    row.Parent = parent
    for i, cfg in ipairs(btns) do
        local bw = 1 / #btns
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(bw, -2, 1, 0)
        b.Position = UDim2.new((i - 1) * bw, 2, 0, 0)
        b.Text = cfg.text
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 10
        b.TextWrapped = true
        b.BackgroundColor3 = cfg.color or T.PanelLt
        b.ZIndex = 8
        b.Parent = row
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
        b.MouseButton1Click:Connect(function()
            sClick()
            if cfg.cb then pcall(cfg.cb)
            elseif cfg.isNebula and promptNebulaFling then pcall(promptNebulaFling) end
        end)
    end
end

local function makeSlider(parent, order, label, minV, maxV, defV, onChange)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = T.Panel
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.ClipsDescendants = true
    row.ZIndex = 7
    row.Parent = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 32, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = T.Text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.ZIndex = 8
    lbl.Parent = row

    local bg = Instance.new("TextButton")
    bg.Size = UDim2.new(1, -100, 0, 8)
    bg.Position = UDim2.new(0, 44, 0.5, -4)
    bg.BackgroundColor3 = T.PanelLt
    bg.Text = ""
    bg.AutoButtonColor = false
    bg.ZIndex = 8
    bg.Parent = row
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = T.Accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 9
    fill.Parent = bg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, -9, 0.5, -9)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.ZIndex = 10
    knob.Parent = bg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local vb = Instance.new("TextBox")
    vb.Size = UDim2.new(0, 50, 0, 24)
    vb.Position = UDim2.new(1, -54, 0.5, -12)
    vb.BackgroundColor3 = T.PanelLt
    vb.Text = tostring(defV)
    vb.TextColor3 = T.Text
    vb.Font = Enum.Font.Gotham
    vb.TextSize = 11
    vb.ClearTextOnFocus = false
    vb.ZIndex = 8
    vb.Parent = row
    Instance.new("UICorner", vb).CornerRadius = UDim.new(0, 4)

    local cur = defV
    local function setVal(v, fire)
        v = m_clamp(v, minV, maxV)
        cur = v
        vb.Text = tostring(m_floor(v * 100 + 0.5) / 100)
        local pct = (v - minV) / (maxV - minV)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, -9, 0.5, -9)
        if fire and onChange then onChange(v) end
    end

    local drag = false
    bg.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            drag = true
            local rX = inp.Position.X - bg.AbsolutePosition.X
            setVal(minV + m_clamp(rX / bg.AbsoluteSize.X, 0, 1) * (maxV - minV), true)
        end
    end)
    bg.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then drag = false end
    end)
    UIS.InputChanged:Connect(function(inp)
        if drag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local rX = inp.Position.X - bg.AbsolutePosition.X
            setVal(minV + m_clamp(rX / bg.AbsoluteSize.X, 0, 1) * (maxV - minV), true)
        end
    end)
    vb.FocusLost:Connect(function()
        local n = tonumber(vb.Text)
        if n then setVal(n, true) else setVal(cur, false) end
    end)

    setVal(defV, false)
    return { set = setVal, get = function() return cur end }
end

-- Tab 1: Players
local playersTab = createTab("Players", "👥")
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, 0, 0, 32)
searchBox.BackgroundColor3 = T.Panel
searchBox.PlaceholderText = "🔍 Search player..."
searchBox.Text = ""
searchBox.TextColor3 = T.Text
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 12
searchBox.LayoutOrder = 1
searchBox.ClearTextOnFocus = false
searchBox.ZIndex = 7
searchBox.Parent = playersTab
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 7)

local listFrame = Instance.new("Frame")
listFrame.Size = UDim2.new(1, 0, 0, 152)
listFrame.BackgroundColor3 = T.Panel
listFrame.BorderSizePixel = 0
listFrame.LayoutOrder = 2
listFrame.ZIndex = 7
listFrame.Parent = playersTab
Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 7)

local listScroll = Instance.new("ScrollingFrame")
listScroll.Size = UDim2.new(1, -6, 1, -6)
listScroll.Position = UDim2.new(0, 3, 0, 3)
listScroll.BackgroundTransparency = 1
listScroll.ScrollBarThickness = 2
listScroll.ScrollBarImageColor3 = T.Accent
listScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
listScroll.ZIndex = 8
listScroll.Parent = listFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = listScroll

local function refreshList()
    for _, c in ipairs(listScroll:GetChildren()) do
        if c:IsA("TextButton") or c:IsA("TextLabel") then c:Destroy() end
    end
    local query = (searchBox.Text or ""):lower()
    for i, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and (query == "" or p.Name:lower():find(query, 1, true) or p.DisplayName:lower():find(query, 1, true)) then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -6, 0, 32)
            btn.BackgroundColor3 = (selectedPlayer == p) and T.Accent or T.PanelLt
            btn.Text = ""
            btn.LayoutOrder = i
            btn.ZIndex = 9
            btn.Parent = listScroll
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

            local nm = Instance.new("TextLabel")
            nm.Size = UDim2.new(1, -12, 1, 0)
            nm.Position = UDim2.new(0, 10, 0, 0)
            nm.BackgroundTransparency = 1
            nm.Text = p.DisplayName .. " (@" .. p.Name .. ")"
            nm.TextColor3 = Color3.new(1, 1, 1)
            nm.Font = Enum.Font.GothamBold
            nm.TextSize = 11
            nm.TextXAlignment = Enum.TextXAlignment.Left
            nm.ZIndex = 10
            nm.Parent = btn

            btn.MouseButton1Click:Connect(function()
                selectedPlayer = p
                footerLabel.Text = "👤 " .. p.Name
                footerSub.Text = "Ready — Select an Action"
                sClick()
                refreshList()
            end)
        end
    end
end
searchBox:GetPropertyChangedSignal("Text"):Connect(refreshList)
refreshList()

-- Tab 2: Attach
local attachTab = createTab("Attach", "🔗")
sectionLbl(attachTab, 1, "📍 POSITION & LOCK FEATURES", T.Accent)
makeGridRow(attachTab, 2, {
    { text = "🌀 Back Orbit", cb = StateManager.executeBackOrbit },
    { text = "🎒 Backpack Ride", cb = StateManager.executeBackpackRide },
    { text = "👣 Foot Sit", cb = StateManager.executeFootSit },
})
makeGridRow(attachTab, 3, {
    { text = "👁 Side Glance Lock", cb = StateManager.executeSideGlanceLock },
    { text = "⚡ Phase Shift", cb = StateManager.executePhaseShift },
    { text = "👤 Shadow Glitch", cb = StateManager.executeShadowGlitch },
})
makeGridRow(attachTab, 4, {
    { text = "🐛 Crawler Position", cb = StateManager.executeCrawlerPosition },
    { text = "👑 Hover Crown", cb = StateManager.executeHoverCrown },
    { text = "🦵 Leg Drag Follow", cb = StateManager.executeLegDragFollow },
})
makeGridRow(attachTab, 5, {
    { text = "🎥 Reverse POV", cb = StateManager.executeReversePOV },
    { text = "🪑 Shoulder Sit", cb = executeShoulderSit },
    { text = "🪑 Head Sit", cb = executeHeadSit },
})

-- Tab 3: Actions
local actionsTab = createTab("Actions", "⚡")
sectionLbl(actionsTab, 1, "🎭 ANIMATIONS & INTERACTIONS", T.Neon)
makeGridRow(actionsTab, 2, {
    { text = "🙇 Bow Down", color = Color3.fromRGB(160, 40, 70), cb = StateManager.executeBowDown },
    { text = "👉 Point & Mock", color = Color3.fromRGB(52, 57, 67), cb = StateManager.executePointMock },
    { text = "💋 Blow Kiss", color = Color3.fromRGB(64, 70, 82), cb = StateManager.executeBlowKiss },
})
makeGridRow(actionsTab, 3, {
    { text = "💪 Flex Pose", color = Color3.fromRGB(54, 59, 70), cb = StateManager.executeFlexPose },
    { text = "🥊 Fake Uppercut", color = Color3.fromRGB(239, 68, 68), cb = StateManager.executeFakeUppercut },
    { text = "👋 Slap Back", color = Color3.fromRGB(60, 65, 76), cb = StateManager.executeSlapBack },
})
makeGridRow(actionsTab, 4, {
    { text = "🤝 Handshake Pose", color = Color3.fromRGB(16, 185, 129), cb = StateManager.executeHandshakePose },
    { text = "👋 Pat Head", color = Color3.fromRGB(245, 158, 11), cb = StateManager.executePatHead },
    { text = "💃 Belly Dance", color = Color3.fromRGB(46, 50, 60), cb = StateManager.executeBellyDance },
})
makeGridRow(actionsTab, 5, {
    { text = "🍑 Spank", color = Color3.fromRGB(60, 65, 76), cb = StateManager.executeSpankOffset },
    { text = "🤗 Zero-Delay Hug", color = Color3.fromRGB(64, 70, 82), cb = executeZeroDelayHug },
    { text = "💋 True Kiss", color = Color3.fromRGB(60, 65, 76), cb = StateManager.executeTrueKiss },
})
makeGridRow(actionsTab, 6, {
    { text = "✊ R6 Jerk", color = Color3.fromRGB(245, 158, 11), cb = function() StateManager.executeR6Jerk(not selectedPlayer) end },
    { text = "💞 Romance Clasp", color = Color3.fromRGB(55, 60, 72), cb = StateManager.executeRomanceClasp },
    { text = "🔥 Passion Grip", color = Color3.fromRGB(239, 68, 68), cb = StateManager.executePassionGrip },
})

-- Tab 4: Utility
local utilityTab = createTab("Utility", "🛠")
sectionLbl(utilityTab, 1, "🛠 UTILITY & CAMERA SUITE", T.Accent)
makeGridRow(utilityTab, 2, {
    { text = "🧭 Auto Look-At", color = Color3.fromRGB(6, 182, 212), cb = StateManager.toggleAutoLookAt },
    { text = "🎯 Target Cam Lock", color = Color3.fromRGB(59, 130, 246), cb = StateManager.toggleTargetCamLock },
    { text = "👻 Ghost Mode", color = Color3.fromRGB(168, 85, 247), cb = function()
        StateManager.GhostModeActive = not StateManager.GhostModeActive
        for i = 1, #MyCharacterParts do
            local p = MyCharacterParts[i]
            if p.Parent then p.LocalTransparencyModifier = StateManager.GhostModeActive and 0.5 or 0 end
        end
        notify("COCO POWDER", "Ghost Mode: " .. (StateManager.GhostModeActive and "ON" or "OFF"))
    end },
})
makeGridRow(utilityTab, 3, {
    { text = "⚡ Invisibility TP", color = Color3.fromRGB(60, 65, 76), cb = StateManager.executeInvisibilityTeleport },
    { text = "🌪️ Spin Tornado", color = Color3.fromRGB(245, 158, 11), cb = StateManager.toggleSpinAttack },
    { text = "🚀 Fake Fling Arc", color = Color3.fromRGB(55, 60, 72), cb = StateManager.executeFakeFlingArc },
})
makeGridRow(utilityTab, 4, {
    { text = "🏎️ Copy Velocity", color = Color3.fromRGB(16, 185, 129), cb = StateManager.toggleCopyVelocity },
    { text = "⚓ Anchor Lock", color = Color3.fromRGB(239, 68, 68), cb = function()
        if not CachedMyRoot then return end
        StateManager.AnchorLockActive = not StateManager.AnchorLockActive
        CachedMyRoot.Anchored = StateManager.AnchorLockActive
        notify("COCO POWDER", "Anchor: " .. (StateManager.AnchorLockActive and "LOCKED" or "UNLOCKED"))
    end },
    { text = "🚶 Noclip Walk", color = Color3.fromRGB(147, 51, 234), cb = StateManager.toggleNoclipWalk },
})
makeGridRow(utilityTab, 5, {
    { text = "📏 Height Match", color = Color3.fromRGB(245, 158, 11), cb = StateManager.executeHeightMatch },
    { text = "🛡️ Distance Keeper", color = Color3.fromRGB(6, 182, 212), cb = StateManager.toggleDistanceKeeper },
    { text = "✨ Nebula Fling", color = Color3.fromRGB(168, 85, 247), isNebula = true },
})

-- Tab 5: Adjust
local adjustTab = createTab("Adjust", "📐")
sectionLbl(adjustTab, 1, "📐 POSITION OFFSET (STUDS)", T.Accent)
UIRefs.SlX = makeSlider(adjustTab, 2, "X", -10, 10, 0, function(v) V.X = v end)
UIRefs.SlY = makeSlider(adjustTab, 3, "Y", -10, 10, 0, function(v) V.Y = v end)
UIRefs.SlZ = makeSlider(adjustTab, 4, "Z", -10, 10, 1.3, function(v) V.Z = v end)

sectionLbl(adjustTab, 5, "🔄 ROTATION (DEGREES)", T.Warning)
UIRefs.SlRX = makeSlider(adjustTab, 6, "RX", -180, 180, 0, function(v) V.RX = v end)
UIRefs.SlRY = makeSlider(adjustTab, 7, "RY", -180, 180, 0, function(v) V.RY = v end)
UIRefs.SlRZ = makeSlider(adjustTab, 8, "RZ", -180, 180, 0, function(v) V.RZ = v end)

-- Tab 6: Presets
local presetsTab = createTab("Presets", "⚡")
makeGridRow(presetsTab, 1, {
    { text = "🎭 Stand", cb = function() runPreset(1.5, 1.25, 2.0, 0, 0, 0, 313762630, "Stand") end },
    { text = "⚔ Attack", cb = function() runPreset(0, 0, -1.25, 0, 180, 0, 259438880, "Attack") end },
    { text = "🪑 HeadSit", cb = executeHeadSit },
})
makeGridRow(presetsTab, 2, {
    { text = "💥 Bang", cb = function() runBang(148840371, 2.2) end },
    { text = "🎒 Backpack", cb = executeBackpack },
    { text = "🛏 Carpet", cb = function() runPreset(0, -1.0, 0, 0, 0, 0, 282574440, "Carpet") end },
})
makeGridRow(presetsTab, 3, {
    { text = "🔥 BANG AGGRESSIVE", color = Color3.fromRGB(65, 70, 82), cb = function() runBang(148840371, 4.8, 1.2) end },
    { text = "💦 FACE BANG", color = Color3.fromRGB(48, 52, 62), cb = function() runFBang(148840371, 2.2, false) end },
})

-- Tab 7: Anims
local animsTab = createTab("Anims", "🎬")
sectionLbl(animsTab, 1, "🎬 CUSTOM ANIMATION TRACK PLAYER", T.Accent)
local animInput = Instance.new("TextBox")
animInput.Size = UDim2.new(1, 0, 0, 32)
animInput.BackgroundColor3 = T.Panel
animInput.PlaceholderText = "Enter Roblox Animation Asset ID..."
animInput.Text = ""
animInput.TextColor3 = T.Text
animInput.Font = Enum.Font.Gotham
animInput.TextSize = 11
animInput.Parent = animsTab
Instance.new("UICorner", animInput).CornerRadius = UDim.new(0, 6)

makeGridRow(animsTab, 2, {
    { text = "▶ PLAY TRACK", color = T.Success, cb = function()
        local id = tonumber(animInput.Text)
        if not id or not CachedMyHum then return end
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://" .. id
        local ok, track = pcall(function() return CachedMyHum:LoadAnimation(anim) end)
        if ok and track then
            track:Play()
            table.insert(PlayedAnims, track)
            notify("COCO POWDER", "Playing: " .. id)
        end
    end },
    { text = "⏹ STOP ALL", color = T.Danger, cb = function() StateManager:StopAllAnimations() end },
})

sectionLbl(animsTab, 3, "💃 DANCE COLLECTION", T.Accent2)
makeGridRow(animsTab, 4, {
    { text = "Floss", cb = function() runBang(ANIM_DB.Dances.Floss, 2.2) end },
    { text = "Default", cb = function() runBang(ANIM_DB.Dances.Default, 2.2) end },
    { text = "Orange J", cb = function() runBang(ANIM_DB.Dances.OrangeJ, 2.2) end },
})
makeGridRow(animsTab, 5, {
    { text = "Gangnam", cb = function() runBang(ANIM_DB.Dances.Gangnam, 2.2) end },
    { text = "Hype", cb = function() runBang(ANIM_DB.Dances.Hype, 2.2) end },
    { text = "Party", cb = function() runBang(ANIM_DB.Dances.Party, 2.2) end },
})
makeGridRow(animsTab, 6, {
    { text = "DontStart", cb = function() runBang(ANIM_DB.Dances.DontStart, 2.2) end },
    { text = "Cha Cha", cb = function() runBang(ANIM_DB.Dances.ChaCha, 2.2) end },
    { text = "Dance", cb = function() runBang(ANIM_DB.Dances.Dance, 2.2) end },
})

-- Tab 8: Extra
local extraTab = createTab("Extra", "🎯")
sectionLbl(extraTab, 1, "🎯 SPECIAL ACTIONS & COMBAT", T.Accent)
makeGridRow(extraTab, 2, {
    { text = "✨ Nebula Fling", color = Color3.fromRGB(168, 85, 247), cb = promptNebulaFling },
    { text = "🤗 Hug", color = Color3.fromRGB(64, 70, 82), cb = executeZeroDelayHug },
    { text = "💋 Kiss", color = Color3.fromRGB(60, 65, 76), cb = executeZeroDelayKiss },
})
makeGridRow(extraTab, 3, {
    { text = "🔄 69 Position", color = Color3.fromRGB(55, 60, 72), cb = executeZeroDelay69 },
    { text = "👋 Slap", color = Color3.fromRGB(220, 60, 100), cb = executeZeroDelaySlap },
    { text = "🦵 Kick", color = Color3.fromRGB(239, 68, 68), cb = executeZeroDelayKick },
})
makeGridRow(extraTab, 4, {
    { text = "🪑 Shoulder Sit", cb = executeShoulderSit },
    { text = "👁️ Stare Face-to-Face", cb = executeZeroDelayStare },
    { text = "🎒 Backpack", cb = executeBackpack },
})

-- Tab 9: Motion
local motionTab = createTab("Motion", "🌀")
sectionLbl(motionTab, 1, "🌀 DYNAMIC ORBIT & BOUNCE", T.Accent)
makeSlider(motionTab, 2, "Radius", 1.0, 10.0, 3.0, function(v) OrbitRadius = v end)
makeSlider(motionTab, 3, "Speed", 0.2, 4.0, 1.2, function(v) OrbitSpeed = v end)
makeGridRow(motionTab, 4, {
    { text = "🌀 START ORBIT", color = T.Accent, cb = function()
        if not selectedPlayer or not selectedPlayer.Character then return end
        local tTorso = getTargetTorso(selectedPlayer.Character)
        if not tTorso then return end
        StateManager:Cleanup(true)
        CurrentTarget = selectedPlayer
        V.X, V.Y, V.Z = 0, 0, OrbitRadius
        CurrentWeld = WeldTo(tTorso, 148840371, false)
        startMotion("orbit")
    end },
    { text = "🏀 START BOUNCE", color = T.Warning, cb = function()
        if not selectedPlayer or not selectedPlayer.Character then return end
        local tTorso = getTargetTorso(selectedPlayer.Character)
        if not tTorso then return end
        StateManager:Cleanup(true)
        CurrentTarget = selectedPlayer
        V.X, V.Y, V.Z = 0, 0, 1.5
        CurrentWeld = WeldTo(tTorso, 148840371, false)
        startMotion("bounce")
    end }
})

-- Tab 10: Defense
local defenseTab = createTab("Defense", "🛡")
sectionLbl(defenseTab, 1, "🛡 MULTI-DEFENSE & SECURITY SUITE", T.Neon)

local function makeDefButton(titleTxt, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = T.PanelLt
    btn.Text = titleTxt .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.LayoutOrder = order
    btn.Parent = defenseTab
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local active = false
    btn.MouseButton1Click:Connect(function()
        sClick()
        active = not active
        btn.BackgroundColor3 = active and T.Success or T.PanelLt
        btn.Text = titleTxt .. (active and ": ACTIVE" or ": OFF")
        callback(active)
    end)
    return btn
end

makeDefButton("🛡 ANTI-SIT PROTECTION", 2, function(on) if on then enableAntiSit() else disableAntiSit() end end)
makeDefButton("🌪️ ANTI-FLING VELOCITY SHIELD", 3, function(on) if on then enableAntiFling() else disableAntiFling() end end)
makeDefButton("🌌 ANTI-VOID RESCUE", 4, function(on) AntiVoidEnabled = on end)

local vcCheckBtn = Instance.new("TextButton")
vcCheckBtn.Size = UDim2.new(1, 0, 0, 32)
vcCheckBtn.BackgroundColor3 = T.Panel
vcCheckBtn.Text = "🎙️ CHECK VC ELIGIBILITY"
vcCheckBtn.TextColor3 = T.Text
vcCheckBtn.Font = Enum.Font.GothamBold
vcCheckBtn.TextSize = 11
vcCheckBtn.LayoutOrder = 5
vcCheckBtn.Parent = defenseTab
Instance.new("UICorner", vcCheckBtn).CornerRadius = UDim.new(0, 6)

vcCheckBtn.MouseButton1Click:Connect(function()
    sClick()
    local msg, col = checkVoiceEligibility()
    notify("ANTI-VC", msg)
end)

-- Nebula floating side HUD
FlingSidePanel = Instance.new("Frame")
FlingSidePanel.Size = UDim2.new(0, 190, 0, 100)
FlingSidePanel.Position = UDim2.new(1, -206, 0.5, -50)
FlingSidePanel.BackgroundColor3 = T.Panel
FlingSidePanel.BorderSizePixel = 0
FlingSidePanel.Visible = false
FlingSidePanel.ZIndex = 80
FlingSidePanel.Parent = gui
Instance.new("UICorner", FlingSidePanel).CornerRadius = UDim.new(0, 10)

FlingCountdownLabel = Instance.new("TextLabel")
FlingCountdownLabel.Size = UDim2.new(1, -12, 0, 24)
FlingCountdownLabel.Position = UDim2.new(0, 8, 0, 8)
FlingCountdownLabel.BackgroundTransparency = 1
FlingCountdownLabel.Text = "⏳ Fling Active"
FlingCountdownLabel.TextColor3 = Color3.new(1, 1, 1)
FlingCountdownLabel.Font = Enum.Font.GothamBold
FlingCountdownLabel.TextSize = 11
FlingCountdownLabel.Parent = FlingSidePanel

local stopFlingBtn = Instance.new("TextButton")
stopFlingBtn.Size = UDim2.new(1, -16, 0, 32)
stopFlingBtn.Position = UDim2.new(0, 8, 0, 52)
stopFlingBtn.BackgroundColor3 = T.Danger
stopFlingBtn.Text = "🛑 STOP FLING & RETURN"
stopFlingBtn.TextColor3 = Color3.new(1, 1, 1)
stopFlingBtn.Font = Enum.Font.GothamBlack
stopFlingBtn.TextSize = 11
stopFlingBtn.Parent = FlingSidePanel
Instance.new("UICorner", stopFlingBtn).CornerRadius = UDim.new(0, 6)

stopFlingBtn.MouseButton1Click:Connect(function()
    sClick()
    StateManager:StopFling()
    StateManager:Cleanup(true)
    notify("COCO POWDER", "Nebula Fling Stopped")
end)

-- Weld & Unweld
btnWeld.MouseButton1Click:Connect(function()
    sClick()
    if not selectedPlayer or not selectedPlayer.Character then notify("COCO POWDER", "Select a target player first!"); return end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    CurrentWeld = WeldTo(targetTorso, 0, AnimCopyEnabled)
    if CurrentWeld then sSuccess(); notify("COCO POWDER", "Welded → " .. selectedPlayer.Name) end
end)

btnUnweld.MouseButton1Click:Connect(function()
    sClick()
    StateManager:Cleanup(false)
    CurrentTarget = nil
    notify("COCO POWDER", "Unwelded & Cleared")
    sSuccess()
end)

--[[═══════════════════════════════════════════════════════════════════════════════
  🔐 FULL COCA-STYLE VERIFICATION GATE
═══════════════════════════════════════════════════════════════════════════════]]
local COCA_ACCESS_KEY = "KINGCOCA"
local COCA_DISCORD_LINK = "https://discord.com/users/1543328830746403017"
local COCA_ACCESS_USERS = {
    ["shivyy73"] = "SUPREME OWNER",
    ["armaan_lulla"] = "PREMIUM GUEST",
    ["shivyy7711"] = "PREMIUM GUEST",
    ["mannat_8490"] = "PREMIUM GUEST",
    ["attitudehizru"] = "PREMIUM GUEST",
    ["retreee_yawrrr"] = "PREMIUM GUEST",
    ["kaun_bhai"] = "PREMIUM GUEST",
}

local verifyGate = Instance.new("Frame")
verifyGate.Name = "COCAVerificationGate"
verifyGate.AnchorPoint = Vector2.new(0.5, 0.5)
verifyGate.Size = UDim2.new(0, 350, 0, 410)
verifyGate.Position = UDim2.new(0.5, 0, 0.5, 0)
verifyGate.BackgroundColor3 = T.BG
verifyGate.BorderSizePixel = 0
verifyGate.ZIndex = 200
verifyGate.Parent = gui
Instance.new("UICorner", verifyGate).CornerRadius = UDim.new(0, 18)

local verifyAvatar = Instance.new("ImageLabel")
verifyAvatar.Size = UDim2.new(0, 82, 0, 82)
verifyAvatar.Position = UDim2.new(0.5, -41, 0, 24)
verifyAvatar.BackgroundColor3 = T.Panel
verifyAvatar.ZIndex = 202
verifyAvatar.Parent = verifyGate
Instance.new("UICorner", verifyAvatar).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    pcall(function()
        local ok, imageUrl = Players:GetUserThumbnailAsync(
            LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150
        )
        if ok and verifyAvatar.Parent then verifyAvatar.Image = imageUrl end
    end)
end)

local verifyTitle = Instance.new("TextLabel")
verifyTitle.BackgroundTransparency = 1
verifyTitle.Size = UDim2.new(1, -24, 0, 26)
verifyTitle.Position = UDim2.new(0, 12, 0, 118)
verifyTitle.Text = "COCO POWDER • SECURE ACCESS"
verifyTitle.TextColor3 = T.Text
verifyTitle.Font = Enum.Font.GothamBlack
verifyTitle.TextSize = 16
verifyTitle.ZIndex = 202
verifyTitle.Parent = verifyGate

local verifyIdentity = Instance.new("TextLabel")
verifyIdentity.BackgroundTransparency = 1
verifyIdentity.Size = UDim2.new(1, -24, 0, 24)
verifyIdentity.Position = UDim2.new(0, 12, 0, 147)
verifyIdentity.Text = LP.DisplayName .. " (@" .. LP.Name .. ")"
verifyIdentity.TextColor3 = T.Muted
verifyIdentity.Font = Enum.Font.GothamMedium
verifyIdentity.TextSize = 12
verifyIdentity.ZIndex = 202
verifyIdentity.Parent = verifyGate

local userLower = string.lower(LP.Name)
local userRole = COCA_ACCESS_USERS[userLower] or "PUBLIC ACCESS"

local verifyRole = Instance.new("TextLabel")
verifyRole.BackgroundTransparency = 1
verifyRole.Size = UDim2.new(1, -24, 0, 20)
verifyRole.Position = UDim2.new(0, 12, 0, 174)
verifyRole.Text = userRole
verifyRole.TextColor3 = T.Success
verifyRole.Font = Enum.Font.GothamBold
verifyRole.TextSize = 11
verifyRole.ZIndex = 202
verifyRole.Parent = verifyGate

local verifyKeyBox = Instance.new("TextBox")
verifyKeyBox.Size = UDim2.new(1, -40, 0, 44)
verifyKeyBox.Position = UDim2.new(0, 20, 0, 210)
verifyKeyBox.BackgroundColor3 = T.Panel
verifyKeyBox.PlaceholderText = "Enter Access Key (KINGCOCA)..."
verifyKeyBox.Text = ""
verifyKeyBox.TextColor3 = T.Text
verifyKeyBox.Font = Enum.Font.GothamBold
verifyKeyBox.TextSize = 13
verifyKeyBox.ZIndex = 202
verifyKeyBox.Parent = verifyGate
Instance.new("UICorner", verifyKeyBox).CornerRadius = UDim.new(0, 10)

local verifyUnlock = Instance.new("TextButton")
verifyUnlock.Size = UDim2.new(0.5, -25, 0, 40)
verifyUnlock.Position = UDim2.new(0.5, 5, 0, 268)
verifyUnlock.BackgroundColor3 = T.Accent
verifyUnlock.Text = "UNLOCK"
verifyUnlock.TextColor3 = Color3.new(1, 1, 1)
verifyUnlock.Font = Enum.Font.GothamBlack
verifyUnlock.TextSize = 12
verifyUnlock.ZIndex = 202
verifyUnlock.Parent = verifyGate
Instance.new("UICorner", verifyUnlock).CornerRadius = UDim.new(0, 9)

local verifyDiscord = Instance.new("TextButton")
verifyDiscord.Size = UDim2.new(0.5, -25, 0, 40)
verifyDiscord.Position = UDim2.new(0, 20, 0, 268)
verifyDiscord.BackgroundColor3 = T.PanelLt
verifyDiscord.Text = "GET KEY"
verifyDiscord.TextColor3 = T.Text
verifyDiscord.Font = Enum.Font.GothamBlack
verifyDiscord.TextSize = 12
verifyDiscord.ZIndex = 202
verifyDiscord.Parent = verifyGate
Instance.new("UICorner", verifyDiscord).CornerRadius = UDim.new(0, 9)

local verifyStatus = Instance.new("TextLabel")
verifyStatus.BackgroundTransparency = 1
verifyStatus.Size = UDim2.new(1, -24, 0, 38)
verifyStatus.Position = UDim2.new(0, 12, 0, 318)
verifyStatus.Text = "Enter access key to continue."
verifyStatus.TextColor3 = T.Muted
verifyStatus.Font = Enum.Font.GothamMedium
verifyStatus.TextSize = 11
verifyStatus.ZIndex = 202
verifyStatus.Parent = verifyGate

verifyDiscord.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then setclipboard(COCA_DISCORD_LINK) end
    end)
    verifyStatus.Text = "Discord copied to clipboard!"
    verifyStatus.TextColor3 = T.Success
end)

local function completeVerification()
    local enteredKey = verifyKeyBox.Text:match("^%s*(.-)%s*$")
    if enteredKey ~= COCA_ACCESS_KEY then
        verifyStatus.Text = "Incorrect access key!"
        verifyStatus.TextColor3 = T.Danger
        sError()
        return
    end

    verifyStatus.Text = "Access granted! Loading..."
    verifyStatus.TextColor3 = T.Success
    sSuccess()
    task.delay(0.3, function()
        verifyGate:Destroy()
        main.Visible = true
        mobToggle.Visible = true
        showTab("Players")
        notify("COCO POWDER", "Welcome • " .. userRole)
    end)
end

verifyUnlock.MouseButton1Click:Connect(completeVerification)
verifyKeyBox.FocusLost:Connect(function(enter)
    if enter then completeVerification() end
end)

UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)
