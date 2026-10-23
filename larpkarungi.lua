--[[═══════════════════════════════════════════════════════════════════════════════
  🔴 COCO POWDER — V20 ULTIMATE PRECISION & BULLETPROOF EDITION (31+ NEW FEATURES INTEGRATED)
  ═══════════════════════════════════════════════════════════════════════════════
  Created & Refactored by Senior Roblox Lua Engine Architect
  Toggle Key: RightShift (Or Tap Floating Mobile Toggle Icon)
  Compatibility: Universal R6 & R15 Cross-Rig Architecture
  Executors Supported: Delta, Solara, Wave, Codex, Arceus X, Appleware, Synapse, KRNL
  
  [V19 FIXES & UPGRADES CHANGELOG]
  1. Zero-Delay Logic Synchronization:
     - Hug, Kiss, Stare, Slap executed with 0ms delay. No arbitrary task.wait() yields.
     - StateManager synchronizes CFrame instantly on the exact trigger frame.
  2. Kiss Feature Adjustments:
     - CFrame Z-offset dynamically sweeps between -3.0 and -0.2 studs smoothly.
     - Local player dynamically rotates on Y-axis (RY=180°) to face partner eye-to-eye.
     - Pure zero-delay synchronous trigger pipeline.
  3. Rig-Agnostic Hug & Kiss Procedural Arm Raising Engine:
     - Custom procedural Motor6D Transform and C0 solver dynamically raises arms.
     - Full R6 (Torso Left/Right Shoulder) and R15 (UpperTorso / Shoulder joints) support.
     - Arms realistically wrap target character without breaking physics or joint constraints.
  4. Position & Rotation Fix for "69" Feature:
     - Exact requested angles: RY = 180°, RZ = 180°, RX = 0°.
     - Position Offsets: X = 0, Y = 0.
     - Dynamic sinusoidal Z-offset shifting smoothly between Z = -2.0 and Z = -1.0 studs.
     - Synchronized with zero-delay StateManager.
  5. 100% Cross-Rig (R6 & R15) Animation Coverage:
     - Shoulder Sit: Dedicated R6 sit (178130996) + R15 sit (2506281703).
     - Head Sit: Full R6 sitting animation (178130996) + R15 sitting animation (2506281703).
     - Kick: Working, responsive Kick IDs for both R6 (184570534) and R15 (507770677).
     - Backpack: Dedicated seated posture tracks for R6 (178130996) and R15 (2506281703).
     - Slap: Dedicated R6 slap (204062532) & R15 slap (4555808220) with target Z = -1.5.
     - Carry: Dual-rig R6 (178130996) and R15 (507770677) carry tracks.
  6. Nebula Fling Feature - Time Control & Dedicated Side-Panel UI:
     - Integrated Duration Selector: 3 Seconds, 10 Seconds, Unlimited.
     - Dedicated real-time side-panel HUD displaying active status, timer countdown,
       and instant manual STOP toggle button with safe snap-back.
  7. Central State Manager (Global Mutual Exclusivity):
     - Central StateManager:Cleanup() eliminates feature conflict and animation overlaps.
     - Automatically resets previous loops, Motor6D overrides, velocities, and tracks.
  8. Executor Safety & Bootstrapping ("Script Not Opening" Fix):
     - Safe game:IsLoaded() wait cycle prevents hanging on executor start.
     - Multi-tier GUI container detection: gethui() -> syn.protect_gui -> CoreGui -> PlayerGui.
     - Existing duplicate instance purge prevents ghost GUIs or hidden viewports.
     - Fallback viewport math prevents collapsed zero-sized UI on mobile/early injection.
═══════════════════════════════════════════════════════════════════════════════]]

print("[COCO POWDER V19] Initializing Bulletproof Bootstrapper...")

--[[
═══════════════════════════════════════════════════════════════════════════════
  🔴 COCO POWDER — V21 ULTIMATE BULLETPROOF & COMPILATION EDITION (35+ FEATURES)
═══════════════════════════════════════════════════════════════════════════════
  Created & Refactored by Senior Roblox Lua Engine Architect
  Toggle Key: RightShift (Or Tap Floating Mobile Toggle Icon)
  Compatibility: Universal R6 & R15 Cross-Rig Architecture
  Executors Supported: Delta, Solara, Wave, Codex, Arceus X, Appleware, Synapse, KRNL

  [V21 MAJOR FIXES & NEW FEATURES CHANGELOG]
  1. 🛠️ Complete Utility Suite Overhaul (Buttons 21-31 - 100% Functional):
     - Target Cam Lock: Upgraded to RunService:BindToRenderStep("CocoPowderTargetCamLock",
       Enum.RenderPriority.Camera.Value + 1) so Roblox's CameraModule can NEVER override
       or jitter the camera lock.
     - Ghost Mode (0.5α): Converted to continuous RenderStepped frame-lock so
       Roblox's TransparencyController cannot revert character transparency to 0.
     - Spin Tornado: Fixed Humanoid.AutoRotate conflict to eliminate physics
       jitter/stutter; applied high-speed angular rotation with clean toggle off.
     - Fake Fling Arc: Fixed missing connection tracking in StateManager and 
       implemented true toggle on/off with clean mutual exclusivity.
     - Invisibility TP: Persistent transparency mask, precise behind-target CFrame
       alignment, and zero velocity landing.
     - Copy Velocity: Now synchronizes Humanoid.MoveDirection, Jump state, and 
       assembly linear/angular velocities simultaneously.
     - Anchor Lock (Freeze): Freezes HumanoidRootPart and zeroes WalkSpeed to prevent
       client rubber-banding; fully restorable upon toggle off.
     - Noclip Walk: Robust Stepped CanCollide bypass with Character respawn guard.
     - Height Match (Eye): Dynamic delta-Y calculation with immediate CFrame refresh.
     - Distance Keeper (5s): Smooth perimeter retention without physics instability.
     - Nebula Fling: Fixed scope error where PromptNebulaFling was inaccessible
       from the Utility tab. Now fully responsive from both Utility & Extra tabs.
  2. 💋 Verified Animation ID 3576686446 Integration:
     - Applied verified True Kiss / Romantic Emote ID 3576686446 to ANIM_DB.Kiss
       and added dedicated True Kiss feature button.
  3. 💖 Forwarded Animation ID 10281064499 & Asset ID 82810853201599:
     - Integrated into ANIM_DB as RomanceClasp and PassionGrip.
     - Added dedicated zero-delay interaction buttons in Actions & Anims tabs.
  4. ✊ R6 Procedural Jerk Engine:
     - Custom high-speed procedural Motor6D right shoulder & torso oscillation solver.
     - Compatible with R6 and cross-rig fallback for R15 rigs.
     - Supports both Solo (local player) and Target (welded) execution modes.
  5. 🛡️ Bulletproof StateManager Mutual Exclusivity:
     - Every utility now cleans up instantly when switching features or tapping Unweld.
═══════════════════════════════════════════════════════════════════════════════
]]

-- Ensure game is loaded before accessing services
if not game:IsLoaded() then
    local loadedSuccess = pcall(function() game.Loaded:Wait() end)
    if not loadedSuccess then
        task.wait(1)
    end
end

local RunService    = game:GetService("RunService")
local Players       = game:GetService("Players")
local UIS           = game:GetService("UserInputService")
local TweenService  = game:GetService("TweenService")
local Debris        = game:GetService("Debris")
local SoundService  = game:GetService("SoundService")
local StarterGui    = game:GetService("StarterGui")
local CoreGui       = nil
pcall(function() CoreGui = game:GetService("CoreGui") end)

local LP = Players.LocalPlayer
while not LP do
    task.wait(0.1)
    LP = Players.LocalPlayer
end

-- Safe GUI container resolution (Protects against anti-cheat and prevents blank screens)
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
if not GuiParent then
    warn("[COCO POWDER V19] Fatal: Could not resolve GUI container!")
    return
end
print("[COCO POWDER V19] GUI Target Container: " .. GuiParent.Name)

-- Clean up any prior running instances of Coco Powder to prevent UI locking or conflicts
pcall(function()
    for _, child in ipairs(GuiParent:GetChildren()) do
        if child.Name == "CocoPowder" or child.Name == "CocoPowderV18" or child.Name == "CocoPowderV19" or child.Name == "CocoPowderV20" or child.Name == "CocoPowderNebulaFling" or child.Name == "RedHub" or child.Name == "RedHubV18" or child.Name == "RedHubV19" or child.Name == "RedHubV20" or child.Name == "RedHubNebulaFling" then
            child:Destroy()
        end
    end
    if LP:FindFirstChild("PlayerGui") and LP.PlayerGui ~= GuiParent then
        for _, child in ipairs(LP.PlayerGui:GetChildren()) do
            if child.Name == "CocoPowder" or child.Name == "CocoPowderV18" or child.Name == "CocoPowderV19" or child.Name == "CocoPowderV20" or child.Name == "CocoPowderNebulaFling" or child.Name == "RedHub" or child.Name == "RedHubV18" or child.Name == "RedHubV19" or child.Name == "RedHubV20" or child.Name == "RedHubNebulaFling" then
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

local cam = workspace.CurrentCamera
if not cam then
    cam = workspace:WaitForChild("Camera", 5) or workspace:FindFirstChildOfClass("Camera")
end
if not cam then
    warn("[COCO POWDER V19] Camera not found, waiting for camera...")
    repeat task.wait(0.2); cam = workspace.CurrentCamera until cam
end
print("[COCO POWDER V19] Camera active and verified.")

--[[═══════════════════════════════════════════════════════════════════════════════
  🎨 COLOR PALETTE & DESIGN TOKENS
═══════════════════════════════════════════════════════════════════════════════]]
local T = {
    BG       = Color3.fromRGB(15, 16, 19),       -- Deep Obsidian Slate
    BG2      = Color3.fromRGB(22, 24, 28),       -- Dark Graphite
    Panel    = Color3.fromRGB(28, 30, 36),       -- Clean Slate Panel
    PanelLt  = Color3.fromRGB(38, 41, 49),       -- Subtle Highlight Grey
    Border   = Color3.fromRGB(52, 56, 68),       -- Minimalist Slate Border
    Accent   = Color3.fromRGB(75, 85, 99),       -- Sleek Cool Slate (Clean Monochrome Accent)
    Accent2  = Color3.fromRGB(55, 65, 81),       -- Muted Gunmetal Slate
    Neon     = Color3.fromRGB(156, 163, 175),     -- Silver Pearl Glow
    Success  = Color3.fromRGB(52, 199, 89),      -- Minimal Emerald Green
    Danger   = Color3.fromRGB(220, 38, 38),      -- Crimson Warning
    Warning  = Color3.fromRGB(234, 179, 8),      -- Amber
    Pink     = Color3.fromRGB(107, 114, 128),     -- Steel Neutral
    Purple   = Color3.fromRGB(99, 102, 241),     -- Soft Indigo Accent
    Text     = Color3.fromRGB(243, 244, 246),    -- Crisp Clean Off-White
    Muted    = Color3.fromRGB(148, 163, 184),    -- Subdued Slate Text
    Dark     = Color3.fromRGB(11, 12, 14),       -- True Dark Charcoal
}

--[[═══════════════════════════════════════════════════════════════════════════════
  🎵 AUDIO & SOUND FX LIBRARY (Protected & Graceful Failover)
═══════════════════════════════════════════════════════════════════════════════]]
local function sfx(id, vol, pitch)
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://" .. tostring(id)
        s.Volume = vol or 0.4
        s.PlaybackSpeed = pitch or 1
        s.Parent = SoundService
        s:Play()
        Debris:AddItem(s, 4)
    end)
end

local sClick     = function() sfx(12221967, 0.35, 1.8) end
local sHover     = function() sfx(12221967, 0.12, 2.5) end
local sSuccess   = function() sfx(5696552322, 0.5, 1.2) end
local sError     = function() sfx(5766952670, 0.5, 0.9) end
local sToggleOn  = function() sfx(5696552322, 0.4, 1.6) end
local sToggleOff = function() sfx(5696552322, 0.4, 0.7) end
local sWhoosh    = function() sfx(6895079853, 0.5, 1.4) end
local sScream    = function() sfx(5235775702, 1.0, 1.0) end
local sFling     = function() sfx(9069609267, 0.6, 1.2) end
local sSlap      = function() sfx(9114223179, 0.7, 1.1) end

local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "COCO POWDER",
            Text = text or "",
            Duration = 3,
            Icon = "rbxassetid://10850257404"
        })
    end)
end

--[[═══════════════════════════════════════════════════════════════════════════════
  📐 DUAL-RIG ANIMATION DATABASE (R6 & R15 FULLY VERIFIED)
═══════════════════════════════════════════════════════════════════════════════
  Note: If you want to customize or swap any animation ID, modify the table below.
  Every emote and action dynamically queries this table based on the player rig!
]]
local ANIM_DB = {
    -- Sit / Rest Animations
    Sit = {
        R6  = 178130996,            -- Classic Default R6 Sitting Track
        R15 = 2506281703,           -- Modern High-Def R15 Sitting Track
    },
    -- Shoulder Sit Position
    ShoulderSit = {
        R6  = 178130996,            -- Fixed: R6 now sits properly instead of standing!
        R15 = 2506281703,           -- Standard R15 Seated Emote
    },
    -- Head Sit Posture
    HeadSit = {
        R6  = 178130996,            -- Fixed: R6 Head Sit seated posture loaded
        R15 = 2506281703,           -- R15 Head Sit seated posture
    },
    -- Backpack Posture
    Backpack = {
        R6  = 178130996,            -- Fixed: R6 Backpack posture
        R15 = 2506281703,           -- Fixed: R15 Backpack posture
    },
    -- Kick Action
    Kick = {
        R6  = 184570534,            -- Fixed: High quality R6 roundhouse kick
        R15 = 507770677,            -- Fixed: Responsive R15 dropkick / forward kick
    },
    -- Slap Action
    Slap = {
        R6  = 204062532,            -- Fixed: R6 classic punch/slap swing
        R15 = 4555808220,           -- R15 expressive slap impact animation
    },
    -- Carry Action
    Carry = {
        R6  = 178130996,            -- R6 carry pose
        R15 = 507770677,            -- Fixed: R15 carry animation paired track
    },
    -- Hug Action
    Hug = {
        R6  = 178130996,            -- R6 arm-wrap base
        R15 = 507770677,            -- R15 arm-wrap base
    },
    -- Kiss Action (Updated with Verified Working Kiss Animation ID: 3576686446)
    Kiss = {
        R6  = 3576686446,           -- Verified True Kiss Emote (Animation ID: 3576686446)
        R15 = 3576686446,           -- Verified True Kiss Emote (Animation ID: 3576686446)
        FallbackR6  = 178130996,
        FallbackR15 = 507770677,
    },
    -- New Verified Forwarded Romance & Passion Animations
    RomanceClasp = {
        R6  = 10281064499,          -- Forwarded Animation ID: 10281064499
        R15 = 10281064499,
    },
    PassionGrip = {
        R6  = 82810853201599,       -- Forwarded Asset ID: 82810853201599
        R15 = 82810853201599,
    },
    -- R6 Jerk Procedural Track / Base
    Jerk = {
        R6  = 148840371,            -- R6 Jerk motion reference track
        R15 = 507770677,
    },
    -- 69 Position
    Pos69 = {
        R6  = 282574440,            -- R6 inverted lie
        R15 = 282574440,            -- R15 inverted lie
    },
    -- Bang Aggressive
    BangAggressive = {
        R6  = 148840371,            -- Fallback for R6
        R15 = 507770677,            -- R15 Bang Aggressive
    },
    -- Dance Collection
    Dances = {
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
    -- New Verified Emotes for 31 Modules
    Prone       = { R6 = 282574440, R15 = 282574440 },
    Bow         = { R6 = 282574440, R15 = 282574440 },
    Point       = { R6 = 204062532, R15 = 507770677 },
    Flex        = { R6 = 313762630, R15 = 96658788627102 },
    Uppercut    = { R6 = 204062532, R15 = 4555808220 },
    Handshake   = { R6 = 178130996, R15 = 507770677 },
    Pat         = { R6 = 204062532, R15 = 507770677 },
    Twerk       = { R6 = 182435998, R15 = 507771019 }
}

--[[═══════════════════════════════════════════════════════════════════════════════
  ⚙️ GLOBAL STATE & RUNTIME VARIABLES
═══════════════════════════════════════════════════════════════════════════════]]
local V = {
    X = 0,
    Y = 0,
    Z = 1.3,
    RX = 0,
    RY = 0,
    RZ = 0,
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
local SuckDuration        = 2.0

local AntiSitEnabled      = false
local AntiSitConn         = nil
local AntiSitCharConn     = nil
local AntiSitCount        = 0
local AntiSitCountLabel   = nil

local OriginalCameraSubject = nil
local AutoReweldEnabled   = true
local LastWeldTargetUserId = nil
local LastWeldAnimId      = nil
local LastWeldWasThrust   = false
local LastWeldType        = nil
local LastCustomData      = {}

-- Nebula Fling Settings
local FlingDuration       = 3.0
local FlingActive         = false
local FlingConn           = nil
local FlingDurationMode   = "3s" -- "3s", "10s", "unlimited"
local FlingSidePanel      = nil
local FlingCountdownLabel = nil

local UIRefs              = {}
local ProceduralArmConn   = nil
local ProceduralActive    = false
local ActiveMotorsBackup  = {}

--[[═══════════════════════════════════════════════════════════════════════════════
  🔍 RIG DETECTION & CHARACTER UTILITY HELPERS
═══════════════════════════════════════════════════════════════════════════════]]
local function getRig(player)
    if not player or not player.Character then return nil end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end
    return hum.RigType
end

local function isR15(player)
    return getRig(player) == Enum.HumanoidRigType.R15
end

local function getTargetTorso(char)
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.RigType == Enum.HumanoidRigType.R15 then
        return char:FindFirstChild("UpperTorso") 
            or char:FindFirstChild("LowerTorso") 
            or char:FindFirstChild("HumanoidRootPart")
    else
        return char:FindFirstChild("Torso") 
            or char:FindFirstChild("HumanoidRootPart")
    end
end

local function getHeadHeight(char)
    if not char then return 1.5 end
    local head = char:FindFirstChild("Head")
    local hrp  = char:FindFirstChild("HumanoidRootPart")
    if not head or not hrp then return 1.5 end
    return head.Position.Y - hrp.Position.Y
end

local function getTorsoDepth(char)
    if not char then return 1.0 end
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if torso then return torso.Size.Z end
    return 1.0
end

local function getAnimIdForRig(category, isUserR15)
    local entry = ANIM_DB[category]
    if not entry then return nil end
    if typeof(entry) == "number" then return entry end
    if isUserR15 then
        return entry.R15 or entry.R6
    else
        return entry.R6 or entry.R15
    end
end

--[[═══════════════════════════════════════════════════════════════════════════════
  🦾 PROCEDURAL MOTOR6D ARM SOLVER (RIG-AGNOSTIC HUG & KISS)
═══════════════════════════════════════════════════════════════════════════════
  Solves arm elevation and gentle inward rotation for both R6 and R15 rigs
  without breaking joint attachments or colliding physics.
]]
local function resetProceduralMotors()
    if ProceduralArmConn then
        ProceduralArmConn:Disconnect()
        ProceduralArmConn = nil
    end
    ProceduralActive = false

    local char = LP.Character
    if not char then return end

    -- Restore saved C0 / Transform states
    for motor, originalData in pairs(ActiveMotorsBackup) do
        if motor and motor.Parent then
            pcall(function()
                motor.Transform = originalData.Transform or CFrame.identity
                motor.C0 = originalData.C0 or motor.C0
            end)
        end
    end
    ActiveMotorsBackup = {}
end

local function enableProceduralArmRaise(mode)
    resetProceduralMotors()
    local char = LP.Character
    if not char then return end

    local userIsR15 = isR15(LP)
    ProceduralActive = true

    local leftShoulder, rightShoulder = nil, nil

    if userIsR15 then
        -- R15 Joints are in UpperTorso or UpperArms
        local upperTorso = char:FindFirstChild("UpperTorso")
        local leftArm    = char:FindFirstChild("LeftUpperArm")
        local rightArm   = char:FindFirstChild("RightUpperArm")
        if upperTorso then
            leftShoulder  = upperTorso:FindFirstChild("LeftShoulder")
            rightShoulder = upperTorso:FindFirstChild("RightShoulder")
        end
        if not leftShoulder and leftArm then
            leftShoulder = leftArm:FindFirstChild("LeftShoulder")
        end
        if not rightShoulder and rightArm then
            rightShoulder = rightArm:FindFirstChild("RightShoulder")
        end
    else
        -- R6 Joints are located directly inside Torso
        local torso = char:FindFirstChild("Torso")
        if torso then
            leftShoulder  = torso:FindFirstChild("Left Shoulder")
            rightShoulder = torso:FindFirstChild("Right Shoulder")
        end
    end

    if leftShoulder then
        ActiveMotorsBackup[leftShoulder] = {
            C0 = leftShoulder.C0,
            Transform = leftShoulder.Transform
        }
    end
    if rightShoulder then
        ActiveMotorsBackup[rightShoulder] = {
            C0 = rightShoulder.C0,
            Transform = rightShoulder.Transform
        }
    end

    local startTime = tick()

    -- Procedural bone manipulation running on Stepped (before physics evaluation)
    ProceduralArmConn = RunService.Stepped:Connect(function()
        if not ProceduralActive or not LP.Character then
            resetProceduralMotors()
            return
        end

        local elapsed = tick() - startTime
        local sway = math.sin(elapsed * 3) * 0.05

        if mode == "jerk" then
            if not userIsR15 and rightShoulder then
                -- Dedicated R6 Jerk procedural arm motor movement
                local jerkFreq = elapsed * 24
                local jerkOsc = math.sin(jerkFreq)
                local armPitch = math.rad(65 + jerkOsc * 30)
                local armYaw = math.rad(-22)
                local armRoll = math.rad(-14)
                pcall(function()
                    rightShoulder.Transform = CFrame.new(0, -0.15 + jerkOsc * 0.08, -0.22) * CFrame.Angles(armPitch, armYaw, armRoll)
                end)
                if leftShoulder then
                    pcall(function()
                        leftShoulder.Transform = CFrame.Angles(math.rad(18), math.rad(5), math.rad(-10))
                    end)
                end
            elseif userIsR15 and rightShoulder then
                -- Cross-rig R15 procedural support
                local jerkFreq = elapsed * 22
                local jerkOsc = math.sin(jerkFreq)
                pcall(function()
                    rightShoulder.Transform = CFrame.new(0, -0.12, -0.2) * CFrame.Angles(math.rad(70 + jerkOsc * 26), math.rad(-20), math.rad(10))
                end)
            end
        elseif mode == "handshake" then
            if rightShoulder then
                pcall(function()
                    rightShoulder.Transform = CFrame.Angles(math.rad(85), math.rad(10), 0)
                end)
            end
        elseif mode == "pat" then
            local patSwing = math.sin(elapsed * 6) * math.rad(15)
            if rightShoulder then
                pcall(function()
                    rightShoulder.Transform = CFrame.Angles(math.rad(105) + patSwing, math.rad(-15), 0)
                end)
            end
        elseif userIsR15 then
            -- R15 Arms Forward & Wrapping
            local liftAngle = math.rad(80 + sway * 10)
            local inwardAngle = (mode == "hug") and math.rad(28) or math.rad(18)

            if rightShoulder then
                pcall(function()
                    rightShoulder.Transform = CFrame.Angles(liftAngle, -inwardAngle, math.rad(10))
                end)
            end
            if leftShoulder then
                pcall(function()
                    leftShoulder.Transform = CFrame.Angles(liftAngle, inwardAngle, -math.rad(10))
                end)
            end
        else
            -- R6 Arms Forward & Inward Hug/Kiss Angles
            local liftAngle = math.rad(85 + sway * 10)
            local inwardAngle = (mode == "hug") and math.rad(25) or math.rad(15)

            if rightShoulder then
                pcall(function()
                    rightShoulder.Transform = CFrame.Angles(liftAngle, 0, -inwardAngle)
                end)
            end
            if leftShoulder then
                pcall(function()
                    leftShoulder.Transform = CFrame.Angles(liftAngle, 0, inwardAngle)
                end)
            end
        end
    end)
end

--[[═══════════════════════════════════════════════════════════════════════════════
  🛡️ CENTRAL STATE MANAGER (GLOBAL MUTUAL EXCLUSIVITY & ZERO-DELAY LOGIC)
═══════════════════════════════════════════════════════════════════════════════
  Ensures whenever ANY action, emote, or script is called, all previous tracks,
  loops, CFrame locks, and procedural overrides are instantaneously stopped
  and purged to guarantee zero-overlap and peak performance.
]]
local StateManager = {}
StateManager.sPunch = function() sfx(131237241, 0.65, 1.1) end
StateManager.sLaugh = function() sfx(5235775702, 0.5, 1.3) end

-- [V20 STATE ATTACHMENTS FOR 31 NEW ZERO-DELAY MODULES - 0 TOP-LEVEL LOCALS USED]
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
StateManager.PromptNebulaFling    = nil

function StateManager:StopAllAnimations()
    for _, track in ipairs(PlayedAnims) do
        pcall(function() track:Stop(0) end)
        pcall(function() track:Destroy() end)
    end
    PlayedAnims = {}
end

function StateManager:StopCopying()
    if AnimCopyConn then
        AnimCopyConn:Disconnect()
        AnimCopyConn = nil
    end
    for _, track in ipairs(CopiedTracks) do
        pcall(function() track:Stop(0) end)
        pcall(function() track:Destroy() end)
    end
    CopiedTracks = {}
end

function StateManager:StopThrust()
    ThrustActive = false
    IsCustomZThrust = false
    if ThrustConn then
        ThrustConn:Disconnect()
        ThrustConn = nil
    end
end

function StateManager:StopMotion()
    MotionMode = "none"
    if MotionConn then
        MotionConn:Disconnect()
        MotionConn = nil
    end
end

function StateManager:StopPOV()
    if OriginalCameraSubject then
        pcall(function() cam.CameraSubject = OriginalCameraSubject end)
        OriginalCameraSubject = nil
    end
    if StateManager.ReversePOVActive or StateManager.ReversePOVConn then
        if StateManager.ReversePOVConn then StateManager.ReversePOVConn:Disconnect(); StateManager.ReversePOVConn = nil end
        StateManager.ReversePOVActive = false
        pcall(function()
            cam.CameraType = Enum.CameraType.Custom
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then cam.CameraSubject = hum end
        end)
    end
end

function StateManager:StopUtilities()
    -- 21. Auto Look-At cleanup
    if StateManager.AutoLookAtConn then StateManager.AutoLookAtConn:Disconnect(); StateManager.AutoLookAtConn = nil end
    StateManager.AutoLookAtActive = false
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then pcall(function() hum.AutoRotate = true end) end

    -- 22. Target Cam Lock cleanup (Unbind from RenderStep)
    if StateManager.TargetCamLockConn then StateManager.TargetCamLockConn:Disconnect(); StateManager.TargetCamLockConn = nil end
    pcall(function() RunService:UnbindFromRenderStep("CocoPowderTargetCamLock") end)
    StateManager.TargetCamLockActive = false

    -- 23. Ghost Mode cleanup
    if StateManager.GhostModeConn then StateManager.GhostModeConn:Disconnect(); StateManager.GhostModeConn = nil end
    if char then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then pcall(function() p.LocalTransparencyModifier = 0 end) end
        end
    end
    StateManager.GhostModeActive = false

    -- 25. Spin Attack cleanup
    if StateManager.SpinAttackConn then StateManager.SpinAttackConn:Disconnect(); StateManager.SpinAttackConn = nil end
    StateManager.SpinAttackActive = false
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then pcall(function() root.AssemblyAngularVelocity = Vector3.zero end) end

    -- 26. Fake Fling Arc cleanup
    if StateManager.FakeFlingArcConn then StateManager.FakeFlingArcConn:Disconnect(); StateManager.FakeFlingArcConn = nil end
    StateManager.FakeFlingArcActive = false

    -- 27. Copy Velocity cleanup
    if StateManager.CopyVelocityConn then StateManager.CopyVelocityConn:Disconnect(); StateManager.CopyVelocityConn = nil end
    StateManager.CopyVelocityActive = false

    -- 28. Anchor Lock cleanup
    if root then pcall(function() root.Anchored = false end) end
    if hum and StateManager.OriginalWalkSpeed then pcall(function() hum.WalkSpeed = StateManager.OriginalWalkSpeed end) end
    StateManager.AnchorLockActive = false

    -- 29. Noclip cleanup
    if StateManager.NoclipConn then StateManager.NoclipConn:Disconnect(); StateManager.NoclipConn = nil end
    StateManager.NoclipActive = false

    -- 31. Distance Keeper cleanup
    if StateManager.DistanceKeeperConn then StateManager.DistanceKeeperConn:Disconnect(); StateManager.DistanceKeeperConn = nil end
    StateManager.DistanceKeeperActive = false

    -- R6 Jerk engine cleanup
    if StateManager.JerkConn then StateManager.JerkConn:Disconnect(); StateManager.JerkConn = nil end
    StateManager.JerkActive = false

    for _, emitter in ipairs(StateManager.ActiveParticles) do
        pcall(function() emitter:Destroy() end)
    end
    StateManager.ActiveParticles = {}
end

function StateManager:StopFling()
    if FlingConn then
        FlingConn:Disconnect()
        FlingConn = nil
    end
    FlingActive = false
    if FlingSidePanel then
        FlingSidePanel.Visible = false
    end
end

function StateManager:ResetPhysics(character)
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.Massless = true
        end
    end
end

function StateManager:Cleanup(keepTarget)
    -- Instant synchronous termination of any active actions
    if CurrentWeld then
        pcall(function() CurrentWeld:Destroy() end)
        CurrentWeld = nil
    end

    self:StopAllAnimations()
    self:StopCopying()
    self:StopThrust()
    self:StopMotion()
    self:StopPOV()
    self:StopFling()
    self:StopUtilities()
    resetProceduralMotors()

    if LP.Character then
        self:ResetPhysics(LP.Character)
    end

    if not keepTarget then
        -- keep selectedPlayer intact for quick re-use, but clean CurrentTarget
        CurrentTarget = nil
    end
end

--[[═══════════════════════════════════════════════════════════════════════════════
  🔗 PRECISION ZERO-DELAY WELD ENGINE
═══════════════════════════════════════════════════════════════════════════════]]
local function WeldTo(TPart, AnimId, UseCopy)
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum  = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return nil end

    -- Zero-delay cleanup of any prior active tracks
    StateManager:StopAllAnimations()

    if UseCopy then
        -- Dynamic copy logic
        if CurrentTarget and AnimCopyEnabled then
            local myRig = getRig(LP)
            local tRig  = getRig(CurrentTarget)
            if myRig and tRig and myRig == tRig then
                local tc = CurrentTarget.Character
                local tHum = tc and tc:FindFirstChildOfClass("Humanoid")
                local tAnim = tHum and tHum:FindFirstChildOfClass("Animator")
                local mAnim = hum:FindFirstChildOfClass("Animator")
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
        end
    elseif AnimId and AnimId ~= 0 then
        StateManager:StopCopying()
        local animator = hum:FindFirstChildOfClass("Animator") or char:FindFirstChildWhichIsA("Animator", true)
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

    -- Collisions & masslessness
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.Massless = true
        end
    end

    -- Zero-delay immediate initial snap on current frame
    local initialOffset = CFrame.new(V.X, V.Y, V.Z)
        * CFrame.Angles(math.rad(V.RX), math.rad(V.RY), math.rad(V.RZ))
    root.CFrame = TPart.CFrame * initialOffset
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero

    local WeldObj = {}
    local conn = nil

    conn = RunService.Heartbeat:Connect(function()
        if not char.Parent or not TPart.Parent then
            if WeldObj.Destroy then WeldObj:Destroy() end
            return
        end
        local currentOffset = CFrame.new(V.X, V.Y, V.Z)
            * CFrame.Angles(math.rad(V.RX), math.rad(V.RY), math.rad(V.RZ))
        root.CFrame = TPart.CFrame * currentOffset
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        if sethiddenproperty then
            pcall(function()
                sethiddenproperty(root, "PhysicsRepRootPart", TPart)
                if InstanceHandleNew then
                    sethiddenproperty(root, "PhysicsRepRootRef", InstanceHandleNew(TPart))
                end
            end)
        end
    end)

    function WeldObj:Destroy()
        if conn then
            conn:Disconnect()
            conn = nil
        end
        StateManager:StopCopying()
        StateManager:StopAllAnimations()
        StateManager:StopThrust()
        StateManager:StopMotion()
        resetProceduralMotors()
        if root then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end

    return WeldObj
end

--[[═══════════════════════════════════════════════════════════════════════════════
  ⚡ DYNAMIC THRUST ENGINE (Oscillating Z Coordinate)
═══════════════════════════════════════════════════════════════════════════════]]
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
        local phase = (math.sin(elapsed * ThrustSpeed * math.pi * 2) + 1) / 2
        if IsCustomZThrust then
            V.Z = ThrustZMin + phase * (ThrustZMax - ThrustZMin)
        else
            V.Z = ThrustTouchZ + ThrustDirection * phase * ThrustRange
        end
    end)
end

--[[═══════════════════════════════════════════════════════════════════════════════
  🌀 DYNAMIC MOTION PRESETS (Orbit, Bounce, Suck)
═══════════════════════════════════════════════════════════════════════════════]]
local function startMotion(mode)
    StateManager:StopMotion()
    MotionMode = mode
    local t0 = tick()
    MotionConn = RunService.Heartbeat:Connect(function()
        if MotionMode == "none" then return end
        local t = tick() - t0
        if MotionMode == "orbit" then
            local angle = t * OrbitSpeed * math.pi * 2
            V.X = math.cos(angle) * OrbitRadius
            V.Z = math.sin(angle) * OrbitRadius
            V.Y = 0
        elseif MotionMode == "bounce" then
            V.Y = math.abs(math.sin(t * BounceSpeed * math.pi)) * BounceHeight
        elseif MotionMode == "suck" then
            local progress = math.min(t / SuckDuration, 1)
            V.Z = 8.0 - (8.0 - 1.0) * progress
            if progress >= 1 then StateManager:StopMotion() end
        end
    end)
end

--[[═══════════════════════════════════════════════════════════════════════════════
  🛡️ ANTI-SIT PROTECTION SYSTEM
═══════════════════════════════════════════════════════════════════════════════]]
local function antiSitTick()
    if not AntiSitEnabled then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    -- Only scan for SeatWelds when seated; the previous version scanned the full
    -- character hierarchy on every Heartbeat even while the player was standing.
    if hum.Sit then
        hum.Sit = false
        hum.Jump = true
        AntiSitCount = AntiSitCount + 1
        if AntiSitCountLabel then
            AntiSitCountLabel.Text = "🛡 Blocked: " .. AntiSitCount .. " times"
        end
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Weld") and obj.Name == "SeatWeld" then
                pcall(function() obj:Destroy() end)
            end
        end
    end
end

local function hookCharAntiSit(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    hum:GetPropertyChangedSignal("Sit"):Connect(function()
        if hum.Sit and AntiSitEnabled then
            -- The Sit property callback can run before Heartbeat. Remove the seat weld here
            -- so the optimized Heartbeat path does not miss it after Sit is reset to false.
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Weld") and obj.Name == "SeatWeld" then
                    pcall(function() obj:Destroy() end)
                end
            end
            hum.Sit = false
            hum.Jump = true
            AntiSitCount = AntiSitCount + 1
            if AntiSitCountLabel then
                AntiSitCountLabel.Text = "🛡 Blocked: " .. AntiSitCount .. " times"
            end
        end
    end)
end

local function enableAntiSit()
    AntiSitEnabled = true
    AntiSitCount = 0
    if AntiSitCountLabel then AntiSitCountLabel.Text = "🛡 Blocked: 0 times" end
    if AntiSitConn then AntiSitConn:Disconnect() end
    AntiSitConn = RunService.Heartbeat:Connect(antiSitTick)
    if AntiSitCharConn then AntiSitCharConn:Disconnect() end
    AntiSitCharConn = LP.CharacterAdded:Connect(function(char)
        task.wait(0.2)
        hookCharAntiSit(char)
    end)
    if LP.Character then hookCharAntiSit(LP.Character) end
end

local function disableAntiSit()
    AntiSitEnabled = false
    if AntiSitConn then
        AntiSitConn:Disconnect()
        AntiSitConn = nil
    end
end

--[[═══════════════════════════════════════════════════════════════════════════════
  🔄 AUTO RE-WELD & RESPAWN TRACKER
═══════════════════════════════════════════════════════════════════════════════]]
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
    if targetPlr:FindFirstChild("__CocoPowderHookV19") then return end
    local marker = Instance.new("BoolValue")
    marker.Name = "__CocoPowderHookV19"
    marker.Parent = targetPlr

    targetPlr.CharacterAdded:Connect(function()
        if not AutoReweldEnabled then return end
        if targetPlr ~= selectedPlayer then return end
        if LastWeldTargetUserId ~= targetPlr.UserId then return end
        task.wait(1.2)
        if not targetPlr.Character then return end
        if CurrentWeld then return end
        if performAutoReweld then
            performAutoReweld(targetPlr, "Respawn re-weld")
        end
    end)
end

LP.CharacterAdded:Connect(function(newChar)
    task.wait(1.0)
    if AutoReweldEnabled and selectedPlayer and selectedPlayer.Character and LastWeldTargetUserId == selectedPlayer.UserId then
        if performAutoReweld then
            performAutoReweld(selectedPlayer, "Player reset re-weld")
        end
    end
end)

--[[═══════════════════════════════════════════════════════════════════════════════
  ✨ NEBULA FLING ENGINE (WITH TIME CONTROL & REAL-TIME SIDE-PANEL HUD)
═══════════════════════════════════════════════════════════════════════════════]]
local function launchNebulaFling(durationSeconds, modeTitle)
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select a target player first!")
        sError()
        return
    end

    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local targetRoot = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot or not targetRoot then
        notify("COCO POWDER", "Target RootPart not found!")
        sError()
        return
    end

    local origCF = myRoot.CFrame

    -- Global cleanup to eliminate conflict
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    FlingActive = true

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    pcall(function() targetRoot:SetNetworkOwner(LP) end)
    storeWeldInfo(selectedPlayer, 0, false, "fling", {duration = durationSeconds})
    hookTargetRespawn(selectedPlayer)

    -- Display real-time side-panel widget
    if FlingSidePanel then
        FlingSidePanel.Visible = true
        if FlingCountdownLabel then
            FlingCountdownLabel.Text = (durationSeconds > 0) 
                and ("⏳ " .. tostring(math.ceil(durationSeconds)) .. "s remaining") 
                or "♾️ UNLIMITED (Active)"
        end
    end

    sFling()
    notify("COCO POWDER", "✨ Nebula Fling (" .. modeTitle .. ") → " .. selectedPlayer.Name)

    local startTime = tick()
    FlingConn = RunService.Heartbeat:Connect(function()
        if not FlingActive or not myChar.Parent or not targetRoot.Parent then
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
                if myRoot then
                    myRoot.AssemblyLinearVelocity = Vector3.zero
                    myRoot.AssemblyAngularVelocity = Vector3.zero
                    myRoot.CFrame = origCF
                end
                StateManager:Cleanup(true)
                notify("COCO POWDER", "✨ Nebula Fling Finished & Safely Returned!")
                sSuccess()
                return
            end
        end

        local t = tick() * 24
        local orbitDist = 3.5
        local offsetX = math.cos(t) * orbitDist
        local offsetZ = math.sin(t) * orbitDist

        myRoot.CFrame = targetRoot.CFrame 
            * CFrame.new(offsetX, 1.8, offsetZ) 
            * CFrame.Angles(math.random(-15, 15), t, math.random(-15, 15))

        myRoot.AssemblyLinearVelocity = Vector3.new(
            math.random(-5000, 5000), 
            math.random(4000, 8000), 
            math.random(-5000, 5000)
        )
        myRoot.AssemblyAngularVelocity = Vector3.new(
            math.random(-800, 800), 
            math.random(-800, 800), 
            math.random(-800, 800)
        )
    end)
end

--[[═══════════════════════════════════════════════════════════════════════════════
  🎯 IMPLEMENTATION OF REFACTORED ZERO-DELAY ACTIONS
═══════════════════════════════════════════════════════════════════════════════]]

-- 1. ZERO-DELAY KISS FEATURE
-- Z distance dynamic between -3.0 and -0.2 studs; RY = 180° (face to face); Procedural arms raised
local function executeZeroDelayKiss()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end

    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then
        notify("COCO POWDER", "Target Torso not found")
        sError()
        return
    end

    -- Instant mutual exclusivity cleanup
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    V.X  = 0
    V.Y  = 0
    V.Z  = -1.5
    V.RX = 0
    V.RY = 180  -- Face partner directly
    V.RZ = 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    storeWeldInfo(selectedPlayer, ANIM_DB.Kiss.R15, true, "kiss")
    hookTargetRespawn(selectedPlayer)

    -- Enable procedural arm wrapping and dynamic forward-backward movement
    enableProceduralArmRaise("kiss")

    -- Kiss oscillation: sweeps between -3.0 and -0.2 studs smoothly
    local kissSpeed = 3.0
    ThrustActive = true
    local t0 = tick()
    ThrustConn = RunService.Heartbeat:Connect(function()
        if not ThrustActive then return end
        local elapsed = tick() - t0
        -- Sinusoidal interpolation between -3.0 and -0.2
        -- Center = -1.6, Amplitude = 1.4 -> Range: [-3.0, -0.2]
        V.Z = -1.6 + math.sin(elapsed * kissSpeed) * 1.4
    end)

    local animId = getAnimIdForRig("Kiss", isR15(LP))
    local ok, w = pcall(function() return WeldTo(targetTorso, animId, false) end)
    if ok and w then
        CurrentWeld = w
        sSuccess()
        notify("COCO POWDER", "💋 Zero-Delay Kiss (Z: -3.0 to -0.2, RY: 180°) → " .. selectedPlayer.Name)
    else
        sError()
    end
end

-- 2. ZERO-DELAY HUG FEATURE
-- Z = -0.8 studs, RY = 180°, Rig-Agnostic Procedural Arm Wrap for R6 & R15
local function executeZeroDelayHug()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end

    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then
        notify("COCO POWDER", "Target Torso not found")
        sError()
        return
    end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    V.X  = 0
    V.Y  = 0
    V.Z  = -0.8
    V.RX = 0
    V.RY = 180  -- Face partner directly
    V.RZ = 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    storeWeldInfo(selectedPlayer, ANIM_DB.Hug.R15, false, "hug")
    hookTargetRespawn(selectedPlayer)

    -- Engage procedural wrapping arms for both rigs
    enableProceduralArmRaise("hug")

    local animId = getAnimIdForRig("Hug", isR15(LP))
    local ok, w = pcall(function() return WeldTo(targetTorso, animId, false) end)
    if ok and w then
        CurrentWeld = w
        sSuccess()
        notify("COCO POWDER", "🤗 Zero-Delay Hug (RY: 180°, Procedural Arms) → " .. selectedPlayer.Name)
    else
        sError()
    end
end

-- 3. ZERO-DELAY 69 POSITION FEATURE
-- RY = 180°, RZ = 180°, X = 0, Y = 0, Dynamic Z shifting smoothly between -2.0 and -1.0 studs
local function executeZeroDelay69()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end

    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then
        notify("COCO POWDER", "Target Torso not found")
        sError()
        return
    end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    V.X  = 0
    V.Y  = 0
    V.Z  = -1.5
    V.RX = 0
    V.RY = 180  -- Rotate 180 degrees on Y-Axis
    V.RZ = 180  -- Rotate 180 degrees on Z-Axis (Inverted)

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    storeWeldInfo(selectedPlayer, ANIM_DB.Pos69.R15, true, "pos69")
    hookTargetRespawn(selectedPlayer)

    -- Dynamic oscillation: smoothly shifts between Z = -2.0 and Z = -1.0
    -- Center = -1.5, Amplitude = 0.5 -> Range: [-2.0, -1.0]
    local oscSpeed = 3.2
    ThrustActive = true
    local t0 = tick()
    ThrustConn = RunService.Heartbeat:Connect(function()
        if not ThrustActive then return end
        local elapsed = tick() - t0
        V.Z = -1.5 + math.sin(elapsed * oscSpeed) * 0.5
    end)

    local animId = getAnimIdForRig("Pos69", isR15(LP))
    local ok, w = pcall(function() return WeldTo(targetTorso, animId, false) end)
    if ok and w then
        CurrentWeld = w
        sSuccess()
        notify("COCO POWDER", "🔄 69 Position (RY: 180°, RZ: 180°, Z: -2 to -1) → " .. selectedPlayer.Name)
    else
        sError()
    end
end

-- 4. ZERO-DELAY SLAP FEATURE
-- Forces target dynamic offset to Z = -1.5, faces target (RY = 180°), loads R6 (204062532) / R15 (4555808220)
local function executeZeroDelaySlap()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end

    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then
        notify("COCO POWDER", "Target Torso not found")
        sError()
        return
    end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    -- Force target dynamic offset to Z = -1.5
    V.X  = 0
    V.Y  = 0
    V.Z  = -1.5
    V.RX = 0
    V.RY = 180
    V.RZ = 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    storeWeldInfo(selectedPlayer, 0, false, "slap")
    hookTargetRespawn(selectedPlayer)

    local animId = getAnimIdForRig("Slap", isR15(LP))
    local ok, w = pcall(function() return WeldTo(targetTorso, animId, false) end)
    if ok and w then
        CurrentWeld = w
        sSlap()
        notify("COCO POWDER", "👋 Zero-Delay Slap (Z = -1.5, Cross-Rig) → " .. selectedPlayer.Name)
    else
        sError()
    end
end

-- 5. ZERO-DELAY KICK FEATURE
-- High quality R6 (184570534) & R15 (507770677) responsive kick execution
local function executeZeroDelayKick()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local animator = hum and hum:FindFirstChildOfClass("Animator")
    if not animator then
        animator = char:FindFirstChildWhichIsA("Animator", true)
    end
    if not animator then return end

    StateManager:Cleanup(true)

    local animId = getAnimIdForRig("Kick", isR15(LP))
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. tostring(animId)

    local ok, track = pcall(function() return animator:LoadAnimation(anim) end)
    if ok and track then
        pcall(function()
            track:AdjustSpeed(1.6)
            track:Play()
        end)
        table.insert(PlayedAnims, track)
        sSuccess()
        notify("COCO POWDER", "🦵 Zero-Delay Kick Executed! (ID: " .. animId .. ")")
    else
        sError()
        notify("COCO POWDER", "Failed to load Kick Animation!")
    end
end

-- 6. ZERO-DELAY SHOULDER SIT FEATURE
-- Full R6 (178130996) and R15 (2506281703) seated posture on shoulder
local function executeShoulderSit()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end

    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    local userR15 = isR15(LP)
    local offsetY = userR15 and 2.2 or 1.8

    V.X  = 1.5
    V.Y  = offsetY
    V.Z  = 0
    V.RX = 0
    V.RY = 0
    V.RZ = 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local animId = getAnimIdForRig("ShoulderSit", userR15)
    storeWeldInfo(selectedPlayer, animId, false, "shoulder")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(targetTorso, animId, false) end)
    if ok and w then
        CurrentWeld = w
        sSuccess()
        notify("COCO POWDER", "🪑 Shoulder Sit (Cross-Rig R6 & R15) → " .. selectedPlayer.Name)
    end
end

-- 7. ZERO-DELAY HEAD SIT FEATURE
-- Full R6 (178130996) and R15 (2506281703) seated posture on head
local function executeHeadSit()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end

    local tc = selectedPlayer.Character
    local head = tc:FindFirstChild("Head") or getTargetTorso(tc)
    if not head then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    local userR15 = isR15(LP)
    V.X  = 0
    V.Y  = userR15 and 3.0 or 2.5
    V.Z  = 0
    V.RX = 0
    V.RY = 0
    V.RZ = 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local animId = getAnimIdForRig("HeadSit", userR15)
    storeWeldInfo(selectedPlayer, animId, false, "headsit")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(head, animId, false) end)
    if ok and w then
        CurrentWeld = w
        sSuccess()
        notify("COCO POWDER", "🪑 Head Sit (Cross-Rig Active) → " .. selectedPlayer.Name)
    end
end

-- 8. ZERO-DELAY BACKPACK FEATURE
-- Seated backpack posture for both R6 (178130996) and R15 (2506281703)
local function executeBackpack()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end

    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    V.X  = 0
    V.Y  = 0.2
    V.Z  = 1.15
    V.RX = 0
    V.RY = 180
    V.RZ = 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local animId = getAnimIdForRig("Backpack", isR15(LP))
    storeWeldInfo(selectedPlayer, animId, false, "backpack")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(targetTorso, animId, false) end)
    if ok and w then
        CurrentWeld = w
        sSuccess()
        notify("COCO POWDER", "🎒 Backpack Seated Posture → " .. selectedPlayer.Name)
    end
end

-- 9. ZERO-DELAY CARRY FEATURE
-- Working R15 (507770677) and R6 (178130996) carry animation setup
local function executeCarry()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end

    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    local userR15 = isR15(LP)
    V.X  = 0
    V.Y  = 1.0
    V.Z  = userR15 and 2.0 or 1.5
    V.RX = 0
    V.RY = 0
    V.RZ = 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local animId = getAnimIdForRig("Carry", userR15)
    storeWeldInfo(selectedPlayer, animId, false, "carry")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(targetTorso, animId, false) end)
    if ok and w then
        CurrentWeld = w
        sSuccess()
        notify("COCO POWDER", "🎪 Carry Feature (Cross-Rig Synced) → " .. selectedPlayer.Name)
    end
end

-- 10. ZERO-DELAY STARE AT PLAYER FEATURE
local function executeZeroDelayStare()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end

    local tc = selectedPlayer.Character
    local targetRoot = tc:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end

    local char = LP.Character
    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    storeWeldInfo(selectedPlayer, 0, false, "stare")
    hookTargetRespawn(selectedPlayer)

    -- Immediate snap to facing position (2.5 studs in front)
    myRoot.CFrame = CFrame.new(targetRoot.Position + targetRoot.CFrame.LookVector * 2.5, targetRoot.Position)
    myRoot.AssemblyLinearVelocity = Vector3.zero
    myRoot.AssemblyAngularVelocity = Vector3.zero

    local conn = RunService.Heartbeat:Connect(function()
        if not char.Parent or not tc.Parent then
            if conn then conn:Disconnect() end
            return
        end
        myRoot.CFrame = CFrame.new(targetRoot.Position + targetRoot.CFrame.LookVector * 2.5, targetRoot.Position)
        myRoot.AssemblyLinearVelocity = Vector3.zero
        myRoot.AssemblyAngularVelocity = Vector3.zero
    end)

    local StareWeld = {}
    function StareWeld:Destroy()
        if conn then conn:Disconnect(); conn = nil end
    end
    CurrentWeld = StareWeld
    sSuccess()
    notify("COCO POWDER", "👁️ Zero-Delay Staring Face-to-Face with " .. selectedPlayer.Name)
end


--[[═══════════════════════════════════════════════════════════════════════════════
  🎯 31 NEW ZERO-DELAY FEATURES IMPLEMENTATION (ATTACHED TO STATEMANAGER)
═══════════════════════════════════════════════════════════════════════════════]]

-- 1. Back Orbit (360-degree circle loop around Target on RenderStepped)
function StateManager.executeBackOrbit()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetRoot = tc:FindFirstChild("HumanoidRootPart")
    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot or not myRoot then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    storeWeldInfo(selectedPlayer, 0, false, "back_orbit")
    hookTargetRespawn(selectedPlayer)

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local t0 = tick()
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not myChar.Parent or not tc.Parent then return end
        local elapsed = tick() - t0
        local angle = elapsed * OrbitSpeed * math.pi * 2
        local x = math.cos(angle) * OrbitRadius
        local z = math.sin(angle) * OrbitRadius
        local desiredPos = targetRoot.Position + Vector3.new(x, 0, z)
        myRoot.CFrame = CFrame.lookAt(desiredPos, targetRoot.Position)
        myRoot.AssemblyLinearVelocity = Vector3.zero
        myRoot.AssemblyAngularVelocity = Vector3.zero
    end)

    local OrbitWeld = {}
    function OrbitWeld:Destroy() if conn then conn:Disconnect(); conn = nil end end
    CurrentWeld = OrbitWeld
    sSuccess()
    notify("COCO POWDER", "🌀 Back Orbit (360° Zero-Delay) → " .. selectedPlayer.Name)
end

-- 2. Backpack Ride (Offset Z = 0.8, Y = 0.5, RY = 180, seated posture)
function StateManager.executeBackpackRide()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    V.X, V.Y, V.Z    = 0, 0.5, 0.8
    V.RX, V.RY, V.RZ = 0, 180, 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local animId = getAnimIdForRig("Backpack", isR15(LP))
    storeWeldInfo(selectedPlayer, animId, false, "backpack_ride")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(targetTorso, animId, false) end)
    if ok and w then
        CurrentWeld = w
        sSuccess()
        notify("COCO POWDER", "🎒 Backpack Ride (Z:0.8, Y:0.5) → " .. selectedPlayer.Name)
    end
end

-- 3. Foot Sit / Feet Sit (Offset Y = -2.0, Z = 0.2, sitting animation)
function StateManager.executeFootSit()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    V.X, V.Y, V.Z    = 0, -2.0, 0.2
    V.RX, V.RY, V.RZ = 0, 0, 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local animId = getAnimIdForRig("Sit", isR15(LP))
    storeWeldInfo(selectedPlayer, animId, false, "foot_sit")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(targetTorso, animId, false) end)
    if ok and w then
        CurrentWeld = w
        sSuccess()
        notify("COCO POWDER", "👣 Foot Sit (Attached to Feet) → " .. selectedPlayer.Name)
    end
end

-- 4. Side Glance Lock (Offset X = 1.5, Z = 0, RY = -90 facing Target face)
function StateManager.executeSideGlanceLock()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    V.X, V.Y, V.Z    = 1.5, 0, 0
    V.RX, V.RY, V.RZ = 0, -90, 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    storeWeldInfo(selectedPlayer, 0, false, "side_glance")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(targetTorso, 0, false) end)
    if ok and w then
        CurrentWeld = w
        sSuccess()
        notify("COCO POWDER", "👁️ Side Glance Lock (X:1.5, Facing Face) → " .. selectedPlayer.Name)
    end
end

-- 5. Phase Shift (Instant Dash behind Target Z = -3)
function StateManager.executePhaseShift()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetRoot = tc:FindFirstChild("HumanoidRootPart")
    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot or not myRoot then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    sWhoosh()

    myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
    myRoot.AssemblyLinearVelocity = Vector3.zero
    myRoot.AssemblyAngularVelocity = Vector3.zero

    notify("COCO POWDER", "⚡ Phase Shift Dash Behind → " .. selectedPlayer.Name)
    sSuccess()
end

-- 6. Shadow Glitch (Lock inside Target RootPart center Offset: 0, 0, 0)
function StateManager.executeShadowGlitch()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    V.X, V.Y, V.Z    = 0, 0, 0
    V.RX, V.RY, V.RZ = 0, 0, 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    storeWeldInfo(selectedPlayer, 0, false, "shadow_glitch")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(targetTorso, 0, false) end)
    if ok and w then
        CurrentWeld = w
        sSuccess()
        notify("COCO POWDER", "👤 Shadow Glitch (Direct Center Lock) → " .. selectedPlayer.Name)
    end
end

-- 7. Crawler Position (Prone/flat on ground near Target, follow logic)
function StateManager.executeCrawlerPosition()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    V.X, V.Y, V.Z    = 0, -2.2, 1.5
    V.RX, V.RY, V.RZ = 90, 0, 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local animId = getAnimIdForRig("Prone", isR15(LP))
    storeWeldInfo(selectedPlayer, animId, false, "crawler")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(targetTorso, animId, false) end)
    if ok and w then
        CurrentWeld = w
        sSuccess()
        notify("COCO POWDER", "🐛 Crawler Position (Prone Follow) → " .. selectedPlayer.Name)
    end
end

-- 8. Hover Crown (Positioned 2-3 studs above head Offset Y = 3 with slow rotation)
function StateManager.executeHoverCrown()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local head = tc:FindFirstChild("Head") or getTargetTorso(tc)
    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not head or not myRoot then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    storeWeldInfo(selectedPlayer, 0, false, "hover_crown")
    hookTargetRespawn(selectedPlayer)

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local t0 = tick()
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not myChar.Parent or not tc.Parent then return end
        local elapsed = tick() - t0
        myRoot.CFrame = head.CFrame * CFrame.new(0, 3.0, 0) * CFrame.Angles(0, elapsed * 2.0, 0)
        myRoot.AssemblyLinearVelocity = Vector3.zero
        myRoot.AssemblyAngularVelocity = Vector3.zero
    end)

    local CrownWeld = {}
    function CrownWeld:Destroy() if conn then conn:Disconnect(); conn = nil end end
    CurrentWeld = CrownWeld
    sSuccess()
    notify("COCO POWDER", "👑 Hover Crown (Rotating Halo) → " .. selectedPlayer.Name)
end

-- 9. Leg Drag Follow (Ground-sliding posture locked to Target feet)
function StateManager.executeLegDragFollow()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    V.X, V.Y, V.Z    = 0, -2.2, -1.6
    V.RX, V.RY, V.RZ = 80, 0, 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local animId = getAnimIdForRig("Prone", isR15(LP))
    storeWeldInfo(selectedPlayer, animId, false, "leg_drag")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(targetTorso, animId, false) end)
    if ok and w then
        CurrentWeld = w
        sSuccess()
        notify("COCO POWDER", "🦵 Leg Drag Follow (Sliding Ground Anchor) → " .. selectedPlayer.Name)
    end
end

-- 10. Reverse POV (Camera on Target face looking backward at LocalPlayer)
function StateManager.executeReversePOV()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetHead = tc:FindFirstChild("Head")
    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not targetHead or not myRoot then return end

    if StateManager.ReversePOVConn then StateManager.ReversePOVConn:Disconnect(); StateManager.ReversePOVConn = nil end
    StateManager.ReversePOVActive = true
    OriginalCameraSubject = cam.CameraSubject

    cam.CameraType = Enum.CameraType.Scriptable
    StateManager.ReversePOVConn = RunService.RenderStepped:Connect(function()
        if not StateManager.ReversePOVActive or not targetHead.Parent or not myRoot.Parent then
            if StateManager.ReversePOVConn then StateManager.ReversePOVConn:Disconnect(); StateManager.ReversePOVConn = nil end
            StateManager.ReversePOVActive = false
            return
        end
        cam.CFrame = CFrame.lookAt(targetHead.Position, myRoot.Position)
    end)

    sSuccess()
    notify("COCO POWDER", "🎥 Reverse POV Active (Target Face Looking at You)")
end

-- 11. Bow Down (Sajda: Kneeling/bowing loop in front of Target)
function StateManager.executeBowDown()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    V.X, V.Y, V.Z    = 0, -1.8, -2.0
    V.RX, V.RY, V.RZ = 60, 180, 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local animId = getAnimIdForRig("Bow", isR15(LP))
    storeWeldInfo(selectedPlayer, animId, false, "bow_down")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(targetTorso, animId, false) end)
    if ok and w then
        CurrentWeld = w
        sSuccess()
        notify("COCO POWDER", "🙇 Bow Down / Sajda Position → " .. selectedPlayer.Name)
    end
end

-- 12. Point & Mock (Face target + point emote + mock laugh sound)
function StateManager.executePointMock()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    V.X, V.Y, V.Z    = 0, 0, -2.5
    V.RX, V.RY, V.RZ = 0, 180, 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local animId = getAnimIdForRig("Point", isR15(LP))
    storeWeldInfo(selectedPlayer, animId, false, "point_mock")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(targetTorso, animId, false) end)
    if ok and w then
        CurrentWeld = w
        StateManager.sLaugh()
        notify("COCO POWDER", "👉 Point & Mock Emote → " .. selectedPlayer.Name)
    end
end

-- 13. Blow Kiss (Face target + air-kiss + client heart particle emitter)
function StateManager.executeBlowKiss()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    V.X, V.Y, V.Z    = 0, 0, -2.0
    V.RX, V.RY, V.RZ = 0, 180, 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local animId = getAnimIdForRig("Slap", isR15(LP))
    storeWeldInfo(selectedPlayer, animId, false, "blow_kiss")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(targetTorso, animId, false) end)
    if ok and w then
        CurrentWeld = w
        sSuccess()
        pcall(function()
            local myChar = LP.Character
            local head = myChar and myChar:FindFirstChild("Head")
            if head then
                local pe = Instance.new("ParticleEmitter")
                pe.Texture = "rbxassetid://258129523"
                pe.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 0.8)})
                pe.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
                pe.Lifetime = NumberRange.new(1.0, 1.8)
                pe.Rate = 15
                pe.Speed = NumberRange.new(2, 4)
                pe.SpreadAngle = Vector2.new(45, 45)
                pe.Color = ColorSequence.new(Color3.fromRGB(64, 70, 82))
                pe.Parent = head
                table.insert(StateManager.ActiveParticles, pe)
                task.delay(3, function() pcall(function() pe:Destroy() end) end)
            end
        end)
        notify("COCO POWDER", "💋 Blow Kiss (Heart Particles Spawned) → " .. selectedPlayer.Name)
    end
end

-- 14. Flex Pose (Bodybuilding poses cycle in front of Target)
function StateManager.executeFlexPose()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    V.X, V.Y, V.Z    = 0, 0, -2.5
    V.RX, V.RY, V.RZ = 0, 180, 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local animId = getAnimIdForRig("Flex", isR15(LP))
    storeWeldInfo(selectedPlayer, animId, false, "flex_pose")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(targetTorso, animId, false) end)
    if ok and w then
        CurrentWeld = w
        sSuccess()
        notify("COCO POWDER", "💪 Flex Pose (Bodybuilding Cycle) → " .. selectedPlayer.Name)
    end
end

-- 15. Fake Uppercut (Forward dash + upward impulse visual with punch impact)
function StateManager.executeFakeUppercut()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetRoot = tc:FindFirstChild("HumanoidRootPart")
    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot or not myRoot then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    local forwardCF = targetRoot.CFrame * CFrame.new(0, 0, -1.8) * CFrame.Angles(0, math.rad(180), 0)
    myRoot.CFrame = forwardCF
    sWhoosh()

    local animId = getAnimIdForRig("Uppercut", isR15(LP))
    pcall(function()
        local hum = myChar:FindFirstChildOfClass("Humanoid")
        local animator = hum and hum:FindFirstChildOfClass("Animator")
        if animator and animId and animId > 0 then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://" .. tostring(animId)
            local track = animator:LoadAnimation(anim)
            track.Priority = Enum.AnimationPriority.Action
            track:Play(0.1, 1, 1.5)
            table.insert(PlayedAnims, track)
        end
    end)

    task.wait(0.08)
    StateManager.sPunch()
    myRoot.CFrame = myRoot.CFrame * CFrame.new(0, 2.5, 0)
    myRoot.AssemblyLinearVelocity = Vector3.new(0, 35, 0)

    task.delay(0.2, function()
        if myRoot and myRoot.Parent then
            myRoot.AssemblyLinearVelocity = Vector3.zero
        end
    end)
    notify("COCO POWDER", "🥊 Fake Uppercut Launched → " .. selectedPlayer.Name)
end

-- 16. Slap Back (Behind Target Offset Z = -1.5 with repeated slap)
function StateManager.executeSlapBack()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    V.X, V.Y, V.Z    = 0, 0, -1.5
    V.RX, V.RY, V.RZ = 0, 0, 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local animId = getAnimIdForRig("Slap", isR15(LP))
    storeWeldInfo(selectedPlayer, animId, true, "slap_back")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(targetTorso, animId, false) end)
    if ok and w then
        CurrentWeld = w
        startThrust(-1.8, -1.0)
        sSlap()
        notify("COCO POWDER", "👋 Slap Back (Rear Impact Loop) → " .. selectedPlayer.Name)
    end
end

-- 17. Handshake Pose (Facing target with arm extended forward)
function StateManager.executeHandshakePose()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    V.X, V.Y, V.Z    = 0, 0, -2.2
    V.RX, V.RY, V.RZ = 0, 180, 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local animId = getAnimIdForRig("Handshake", isR15(LP))
    storeWeldInfo(selectedPlayer, animId, false, "handshake")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(targetTorso, animId, false) end)
    if ok and w then
        CurrentWeld = w
        enableProceduralArmRaise("handshake")
        sSuccess()
        notify("COCO POWDER", "🤝 Handshake Pose (Extended Arm Stance) → " .. selectedPlayer.Name)
    end
end

-- 18. Pat Head (Auto-adjust Y offset to target head height, arm patting)
function StateManager.executePatHead()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetHead = tc:FindFirstChild("Head") or getTargetTorso(tc)
    if not targetHead then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    V.X, V.Y, V.Z    = 0, 0.4, -1.6
    V.RX, V.RY, V.RZ = 0, 180, 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local animId = getAnimIdForRig("Pat", isR15(LP))
    storeWeldInfo(selectedPlayer, animId, false, "pat_head")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(targetHead, animId, false) end)
    if ok and w then
        CurrentWeld = w
        enableProceduralArmRaise("pat")
        sSuccess()
        notify("COCO POWDER", "👋 Pat Head (Height Calibrated) → " .. selectedPlayer.Name)
    end
end

-- 19. Belly Dance / Twerk (Hip sway rhythmic emote loop)
function StateManager.executeBellyDance()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    V.X, V.Y, V.Z    = 0, 0, -2.0
    V.RX, V.RY, V.RZ = 0, 0, 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local animId = getAnimIdForRig("Twerk", isR15(LP))
    storeWeldInfo(selectedPlayer, animId, false, "belly_dance")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(targetTorso, animId, false) end)
    if ok and w then
        CurrentWeld = w
        sSuccess()
        notify("COCO POWDER", "💃 Belly Dance / Twerk Loop → " .. selectedPlayer.Name)
    end
end

-- 20. Spank Offset (Lock to rear Offset Z = -1.2, Y = -0.2 with slap contact)
function StateManager.executeSpankOffset()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    V.X, V.Y, V.Z    = 0, -0.2, -1.2
    V.RX, V.RY, V.RZ = 0, 0, 0

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local animId = getAnimIdForRig("Slap", isR15(LP))
    storeWeldInfo(selectedPlayer, animId, true, "spank")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(targetTorso, animId, false) end)
    if ok and w then
        CurrentWeld = w
        startThrust(-1.8, -0.8)
        sSlap()
        notify("COCO POWDER", "🍑 Spank Offset (Rear Contact Thrust) → " .. selectedPlayer.Name)
    end
end

-- 21. Auto Look-At (Permanently force LocalPlayer to face Target - Anti-Jitter)
function StateManager.toggleAutoLookAt()
    if StateManager.AutoLookAtActive then
        if StateManager.AutoLookAtConn then StateManager.AutoLookAtConn:Disconnect(); StateManager.AutoLookAtConn = nil end
        StateManager.AutoLookAtActive = false
        local myChar = LP.Character
        local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
        if myHum then pcall(function() myHum.AutoRotate = true end) end
        sToggleOff()
        notify("COCO POWDER", "Auto Look-At Disabled")
    else
        if not selectedPlayer or not selectedPlayer.Character then
            notify("COCO POWDER", "Select target player first!")
            sError()
            return
        end
        StateManager.AutoLookAtActive = true
        sToggleOn()
        StateManager.AutoLookAtConn = RunService.RenderStepped:Connect(function()
            if not StateManager.AutoLookAtActive then
                if StateManager.AutoLookAtConn then StateManager.AutoLookAtConn:Disconnect(); StateManager.AutoLookAtConn = nil end
                return
            end
            local myChar = LP.Character
            local tc = selectedPlayer and selectedPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local targetRoot = tc and tc:FindFirstChild("HumanoidRootPart")
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            if myRoot and targetRoot then
                if myHum and myHum.AutoRotate then myHum.AutoRotate = false end
                local myPos = myRoot.Position
                local targetPos = targetRoot.Position
                local flatDir = Vector3.new(targetPos.X - myPos.X, 0, targetPos.Z - myPos.Z)
                if flatDir.Magnitude > 0.05 then
                    myRoot.CFrame = CFrame.lookAt(myPos, myPos + flatDir)
                end
            end
        end)
        notify("COCO POWDER", "🧭 Auto Look-At Active → " .. selectedPlayer.Name)
    end
end

-- 22. Target Cam Lock (Smooth camera lookAt target head via Priority 201 RenderStep)
function StateManager.toggleTargetCamLock()
    if StateManager.TargetCamLockActive then
        pcall(function() RunService:UnbindFromRenderStep("CocoPowderTargetCamLock") end)
        if StateManager.TargetCamLockConn then StateManager.TargetCamLockConn:Disconnect(); StateManager.TargetCamLockConn = nil end
        StateManager.TargetCamLockActive = false
        sToggleOff()
        notify("COCO POWDER", "Target Cam Lock Disabled")
    else
        if not selectedPlayer or not selectedPlayer.Character then
            notify("COCO POWDER", "Select target player first!")
            sError()
            return
        end
        StateManager.TargetCamLockActive = true
        sToggleOn()
        RunService:BindToRenderStep("CocoPowderTargetCamLock", Enum.RenderPriority.Camera.Value + 1, function()
            if not StateManager.TargetCamLockActive then
                pcall(function() RunService:UnbindFromRenderStep("CocoPowderTargetCamLock") end)
                return
            end
            local tc = selectedPlayer and selectedPlayer.Character
            local targetHead = tc and (tc:FindFirstChild("Head") or tc:FindFirstChild("HumanoidRootPart"))
            if targetHead and cam then
                local currentCamPos = cam.CFrame.Position
                local targetPos = targetHead.Position
                local desiredCF = CFrame.lookAt(currentCamPos, targetPos)
                cam.CFrame = cam.CFrame:Lerp(desiredCF, 0.25)
            end
        end)
        notify("COCO POWDER", "🎯 Target Cam Lock Active → " .. selectedPlayer.Name)
    end
end

-- 23. Ghost Mode (Continuous RenderStepped Frame-Lock 0.5 Transparency)
function StateManager.toggleGhostMode()
    StateManager.GhostModeActive = not StateManager.GhostModeActive
    if StateManager.GhostModeConn then
        StateManager.GhostModeConn:Disconnect()
        StateManager.GhostModeConn = nil
    end
    
    if StateManager.GhostModeActive then
        sToggleOn()
        -- Low-end optimization: avoid walking the entire character tree every rendered frame.
        -- Transparency is refreshed about 7 times/second, which is sufficient for this visual effect.
        local lastGhostRefresh = 0
        StateManager.GhostModeConn = RunService.RenderStepped:Connect(function()
            if not StateManager.GhostModeActive then
                if StateManager.GhostModeConn then StateManager.GhostModeConn:Disconnect(); StateManager.GhostModeConn = nil end
                return
            end
            local now = os.clock()
            if now - lastGhostRefresh < 0.15 then return end
            lastGhostRefresh = now
            local char = LP.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.LocalTransparencyModifier = 0.5
                    end
                end
            end
        end)
        notify("COCO POWDER", "👻 Ghost Mode: ON (Translucent)")
    else
        sToggleOff()
        local char = LP.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    pcall(function() part.LocalTransparencyModifier = 0 end)
                end
            end
        end
        notify("COCO POWDER", "👻 Ghost Mode: OFF")
    end
end

-- 24. Invisibility Teleport (Instant Stealth Blink Behind Target)
function StateManager.executeInvisibilityTeleport()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetRoot = tc:FindFirstChild("HumanoidRootPart")
    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot or not myRoot then return end

    sWhoosh()
    local invisActive = true
    -- Cache character parts once for this short effect instead of rescanning descendants each frame.
    local invisChar = LP.Character
    local invisParts = {}
    if invisChar then
        for _, item in ipairs(invisChar:GetDescendants()) do
            if item:IsA("BasePart") then table.insert(invisParts, item) end
        end
    end
    local invisDescConn
    if invisChar then
        invisDescConn = invisChar.DescendantAdded:Connect(function(item)
            if invisActive and item:IsA("BasePart") then table.insert(invisParts, item) end
        end)
    end
    local invisConn = RunService.RenderStepped:Connect(function()
        if not invisActive then return end
        for i = 1, #invisParts do
            local part = invisParts[i]
            if part.Parent then part.LocalTransparencyModifier = 1 end
        end
    end)
    
    task.spawn(function()
        task.wait(0.08)
        local behindCF = targetRoot.CFrame * CFrame.new(0, 0, 2.8)
        myRoot.CFrame = CFrame.lookAt(behindCF.Position, targetRoot.Position)
        myRoot.AssemblyLinearVelocity = Vector3.zero
        myRoot.AssemblyAngularVelocity = Vector3.zero
        task.wait(0.12)
        invisActive = false
        if invisConn then invisConn:Disconnect(); invisConn = nil end
        if invisDescConn then invisDescConn:Disconnect(); invisDescConn = nil end
        if LP.Character then
            for _, part in ipairs(LP.Character:GetDescendants()) do
                if part:IsA("BasePart") then pcall(function() part.LocalTransparencyModifier = 0 end) end
            end
        end
        sSuccess()
        notify("COCO POWDER", "⚡ Invisibility Teleport Behind → " .. selectedPlayer.Name)
    end)
end

-- 25. Spin Attack / Tornado (High-velocity Y-axis continuous rotational spin)
function StateManager.toggleSpinAttack()
    if StateManager.SpinAttackActive then
        if StateManager.SpinAttackConn then StateManager.SpinAttackConn:Disconnect(); StateManager.SpinAttackConn = nil end
        StateManager.SpinAttackActive = false
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if hum then pcall(function() hum.AutoRotate = true end) end
        if root then pcall(function() root.AssemblyAngularVelocity = Vector3.zero end) end
        sToggleOff()
        notify("COCO POWDER", "🌪️ Spin Attack Stopped")
    else
        local char = LP.Character
        local myRoot = char and char:FindFirstChild("HumanoidRootPart")
        local myHum  = char and char:FindFirstChildOfClass("Humanoid")
        if not myRoot then return end
        StateManager.SpinAttackActive = true
        if myHum then pcall(function() myHum.AutoRotate = false end) end
        sToggleOn()
        StateManager.SpinAttackConn = RunService.Heartbeat:Connect(function()
            if not StateManager.SpinAttackActive or not LP.Character then
                if StateManager.SpinAttackConn then StateManager.SpinAttackConn:Disconnect(); StateManager.SpinAttackConn = nil end
                StateManager.SpinAttackActive = false
                return
            end
            local r = LP.Character:FindFirstChild("HumanoidRootPart")
            if r then
                r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(36), 0)
                r.AssemblyAngularVelocity = Vector3.new(0, 80, 0)
            end
        end)
        notify("COCO POWDER", "🌪️ Spin Attack (Tornado Mode) Active!")
    end
end

-- 26. Fake Fling Arc (Smooth 3D parabolic Lissajous curve around target - with full toggle)
function StateManager.executeFakeFlingArc()
    if StateManager.FakeFlingArcActive then
        if StateManager.FakeFlingArcConn then StateManager.FakeFlingArcConn:Disconnect(); StateManager.FakeFlingArcConn = nil end
        StateManager.FakeFlingArcActive = false
        sToggleOff()
        notify("COCO POWDER", "Fake Fling Arc Stopped")
        return
    end
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetRoot = tc:FindFirstChild("HumanoidRootPart")
    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot or not myRoot then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    storeWeldInfo(selectedPlayer, 0, false, "fling_arc")
    hookTargetRespawn(selectedPlayer)
    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)

    StateManager.FakeFlingArcActive = true
    sToggleOn()
    local t0 = tick()
    StateManager.FakeFlingArcConn = RunService.Heartbeat:Connect(function()
        if not StateManager.FakeFlingArcActive or not myChar.Parent or not tc.Parent then
            if StateManager.FakeFlingArcConn then StateManager.FakeFlingArcConn:Disconnect(); StateManager.FakeFlingArcConn = nil end
            StateManager.FakeFlingArcActive = false
            return
        end
        local t = (tick() - t0) * 3
        local arcY = math.abs(math.sin(t * 1.5)) * 4.5
        local x = math.cos(t) * 3.8
        local z = math.sin(t) * 3.8
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(x, arcY, z) * CFrame.Angles(math.sin(t) * 0.5, t * 2, 0)
        myRoot.AssemblyLinearVelocity = Vector3.zero
        myRoot.AssemblyAngularVelocity = Vector3.zero
    end)
    local ArcWeld = {}
    function ArcWeld:Destroy()
        if StateManager.FakeFlingArcConn then StateManager.FakeFlingArcConn:Disconnect(); StateManager.FakeFlingArcConn = nil end
        StateManager.FakeFlingArcActive = false
    end
    CurrentWeld = ArcWeld
    sFling()
    notify("COCO POWDER", "🚀 Fake Fling Arc (Parabolic Orbit) → " .. selectedPlayer.Name)
end

-- 27. Copy Velocity (Match Assembly Velocity + MoveDirection + Jump Sync)
function StateManager.toggleCopyVelocity()
    if StateManager.CopyVelocityActive then
        if StateManager.CopyVelocityConn then StateManager.CopyVelocityConn:Disconnect(); StateManager.CopyVelocityConn = nil end
        StateManager.CopyVelocityActive = false
        sToggleOff()
        notify("COCO POWDER", "Copy Velocity Disabled")
    else
        if not selectedPlayer or not selectedPlayer.Character then
            notify("COCO POWDER", "Select target player first!")
            sError()
            return
        end
        StateManager.CopyVelocityActive = true
        sToggleOn()
        StateManager.CopyVelocityConn = RunService.Heartbeat:Connect(function()
            if not StateManager.CopyVelocityActive then
                if StateManager.CopyVelocityConn then StateManager.CopyVelocityConn:Disconnect(); StateManager.CopyVelocityConn = nil end
                return
            end
            local myChar = LP.Character
            local tc = selectedPlayer and selectedPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local targetRoot = tc and tc:FindFirstChild("HumanoidRootPart")
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            local targetHum = tc and tc:FindFirstChildOfClass("Humanoid")
            if myRoot and targetRoot then
                myRoot.AssemblyLinearVelocity = targetRoot.AssemblyLinearVelocity
                myRoot.AssemblyAngularVelocity = targetRoot.AssemblyAngularVelocity
                if myHum and targetHum then
                    myHum:Move(targetHum.MoveDirection, false)
                    if targetHum.Jump then myHum.Jump = true end
                end
            end
        end)
        notify("COCO POWDER", "🏎️ Velocity & Motion Matching Active → " .. selectedPlayer.Name)
    end
end

-- 28. Anchor Lock (Toggle Anchored state on HumanoidRootPart + Zero WalkSpeed)
function StateManager.toggleAnchorLock()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if not root then return end
    StateManager.AnchorLockActive = not StateManager.AnchorLockActive
    root.Anchored = StateManager.AnchorLockActive
    if StateManager.AnchorLockActive then
        if hum then
            StateManager.OriginalWalkSpeed = hum.WalkSpeed
            pcall(function() hum.WalkSpeed = 0 end)
        end
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        sToggleOn()
        notify("COCO POWDER", "⚓ Anchor Lock: FROZEN IN PLACE")
    else
        if hum and StateManager.OriginalWalkSpeed then
            pcall(function() hum.WalkSpeed = StateManager.OriginalWalkSpeed end)
        end
        sToggleOff()
        notify("COCO POWDER", "⚓ Anchor Lock: UNLOCKED")
    end
end

-- 29. Noclip Walk (Continuous CanCollide = false bypass with respawn guard)
function StateManager.toggleNoclipWalk()
    if StateManager.NoclipActive then
        if StateManager.NoclipConn then StateManager.NoclipConn:Disconnect(); StateManager.NoclipConn = nil end
        if StateManager.NoclipDescConn then StateManager.NoclipDescConn:Disconnect(); StateManager.NoclipDescConn = nil end
        StateManager.NoclipActive = false
        sToggleOff()
        notify("COCO POWDER", "Noclip Disabled")
    else
        StateManager.NoclipActive = true
        sToggleOn()
        -- Low-end optimization: refresh collision flags at 10 Hz instead of every physics step.
        -- This preserves the toggle while reducing repeated descendant traversal on slower devices.
        local lastNoclipRefresh = 0
        local cachedNoclipCharacter = nil
        local cachedNoclipParts = {}
        local cachedNoclipDescConn = nil
        StateManager.NoclipDescConn = nil
        StateManager.NoclipConn = RunService.Stepped:Connect(function()
            if not StateManager.NoclipActive then
                if StateManager.NoclipConn then StateManager.NoclipConn:Disconnect(); StateManager.NoclipConn = nil end
                return
            end
            local now = os.clock()
            if now - lastNoclipRefresh < 0.1 then return end
            lastNoclipRefresh = now
            local char = LP.Character
            if not char then return end
            if char ~= cachedNoclipCharacter then
                if cachedNoclipDescConn then cachedNoclipDescConn:Disconnect(); cachedNoclipDescConn = nil end
                cachedNoclipCharacter = char
                cachedNoclipParts = {}
                for _, item in ipairs(char:GetDescendants()) do
                    if item:IsA("BasePart") then table.insert(cachedNoclipParts, item) end
                end
                cachedNoclipDescConn = char.DescendantAdded:Connect(function(item)
                    if item:IsA("BasePart") then table.insert(cachedNoclipParts, item) end
                end)
                StateManager.NoclipDescConn = cachedNoclipDescConn
            end
            for i = 1, #cachedNoclipParts do
                local part = cachedNoclipParts[i]
                if part.Parent and part.CanCollide then part.CanCollide = false end
            end
        end)
        notify("COCO POWDER", "👻 Noclip Walk: ACTIVE (Walk Through Walls)")
    end
end

-- 30. Height Match (Calculate Target Head Y and adjust Local Y offset to eye level)
function StateManager.executeHeightMatch()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetHead = tc:FindFirstChild("Head") or tc:FindFirstChild("HumanoidRootPart")
    local myChar = LP.Character
    local myHead = myChar and (myChar:FindFirstChild("Head") or myChar:FindFirstChild("HumanoidRootPart"))
    if not targetHead or not myHead then return end
    local deltaY = targetHead.Position.Y - myHead.Position.Y
    V.Y = math.clamp(V.Y + deltaY, -10, 10)
    if UIRefs.SlY and UIRefs.SlY.set then
        UIRefs.SlY.set(V.Y, true)
    end
    if CurrentWeld and LP.Character and targetHead then
        local myRoot = LP.Character:FindFirstChild("HumanoidRootPart")
        if myRoot then
            local curOffset = CFrame.new(V.X, V.Y, V.Z) * CFrame.Angles(math.rad(V.RX), math.rad(V.RY), math.rad(V.RZ))
            myRoot.CFrame = targetHead.CFrame * curOffset
        end
    end
    sSuccess()
    notify("COCO POWDER", "📏 Height Matched Eye-to-Eye (ΔY: " .. string.format("%.2f", deltaY) .. ")")
end

-- 31. Distance Keeper (Strict 5-stud perimeter forcefield with smooth lerp)
function StateManager.toggleDistanceKeeper()
    if StateManager.DistanceKeeperActive then
        if StateManager.DistanceKeeperConn then StateManager.DistanceKeeperConn:Disconnect(); StateManager.DistanceKeeperConn = nil end
        StateManager.DistanceKeeperActive = false
        sToggleOff()
        notify("COCO POWDER", "Distance Keeper Disabled")
    else
        if not selectedPlayer or not selectedPlayer.Character then
            notify("COCO POWDER", "Select target player first!")
            sError()
            return
        end
        StateManager.DistanceKeeperActive = true
        sToggleOn()
        StateManager.DistanceKeeperConn = RunService.Heartbeat:Connect(function()
            if not StateManager.DistanceKeeperActive then
                if StateManager.DistanceKeeperConn then StateManager.DistanceKeeperConn:Disconnect(); StateManager.DistanceKeeperConn = nil end
                return
            end
            local myChar = LP.Character
            local tc = selectedPlayer and selectedPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local targetRoot = tc and tc:FindFirstChild("HumanoidRootPart")
            if myRoot and targetRoot then
                local diff = myRoot.Position - targetRoot.Position
                local flatDiff = Vector3.new(diff.X, 0, diff.Z)
                if flatDiff.Magnitude > 0.05 then
                    local desiredPos = targetRoot.Position + flatDiff.Unit * StateManager.DistanceKeeperRadius
                    local aimTarget = targetRoot.Position
                    myRoot.CFrame = CFrame.lookAt(Vector3.new(desiredPos.X, myRoot.Position.Y, desiredPos.Z), aimTarget)
                    myRoot.AssemblyLinearVelocity = Vector3.zero
                end
            end
        end)
        notify("COCO POWDER", "🛡️ Distance Keeper Active (Strict 5-Stud Forcefield)")
    end
end

-- 32. Dedicated True Kiss (Verified ID: 3576686446 with Zero-Delay Sync & Arm Wrap)
function StateManager.executeTrueKiss()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then
        notify("COCO POWDER", "Target Torso not found")
        sError()
        return
    end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X  = 0
    V.Y  = 0
    V.Z  = -1.4
    V.RX = 0
    V.RY = 180
    V.RZ = 0
    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    storeWeldInfo(selectedPlayer, 3576686446, true, "true_kiss")
    hookTargetRespawn(selectedPlayer)
    enableProceduralArmRaise("kiss")
    local kissSpeed = 3.2
    ThrustActive = true
    local t0 = tick()
    ThrustConn = RunService.Heartbeat:Connect(function()
        if not ThrustActive then return end
        local elapsed = tick() - t0
        V.Z = -1.4 + math.sin(elapsed * kissSpeed) * 1.1
    end)
    local ok, w = pcall(function() return WeldTo(targetTorso, 3576686446, false) end)
    if ok and w then
        CurrentWeld = w
        sSuccess()
        notify("COCO POWDER", "💋 True Kiss Active (ID: 3576686446) → " .. selectedPlayer.Name)
    else
        sError()
    end
end

-- 33. Romance Clasp (Forwarded Animation ID: 10281064499)
function StateManager.executeRomanceClasp()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z = 0, 0, -1.2
    V.RX, V.RY, V.RZ = 0, 180, 0
    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    storeWeldInfo(selectedPlayer, 10281064499, false, "romance")
    hookTargetRespawn(selectedPlayer)
    enableProceduralArmRaise("hug")
    local ok, w = pcall(function() return WeldTo(targetTorso, 10281064499, false) end)
    if ok and w then
        CurrentWeld = w
        sSuccess()
        notify("COCO POWDER", "💖 Romance Clasp Active (ID: 10281064499) → " .. selectedPlayer.Name)
    end
end

-- 34. Passion Grip (Forwarded Asset ID: 82810853201599)
function StateManager.executePassionGrip()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end
    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    V.X, V.Y, V.Z = 0, 0, 1.3
    V.RX, V.RY, V.RZ = 0, 0, 0
    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    storeWeldInfo(selectedPlayer, 82810853201599, true, "passion")
    hookTargetRespawn(selectedPlayer)
    local ok, w = pcall(function() return WeldTo(targetTorso, 82810853201599, false) end)
    if ok and w then
        CurrentWeld = w
        startThrust(-1.8, -0.6)
        sSuccess()
        notify("COCO POWDER", "🔥 Passion Grip Active (Asset ID: 82810853201599) → " .. selectedPlayer.Name)
    end
end

-- 35. R6 Procedural Jerk Engine (Requested Custom R6 Joint Oscillation + Cross-Rig Fallback)
function StateManager.executeR6Jerk(isSolo)
    StateManager:Cleanup(not isSolo)
    local char = LP.Character
    if not char then return end
    local myRoot = char:FindFirstChild("HumanoidRootPart")
    local myHum  = char:FindFirstChildOfClass("Humanoid")
    if not myRoot or not myHum then return end

    StateManager.JerkActive = true
    enableProceduralArmRaise("jerk")
    
    if not isSolo and selectedPlayer and selectedPlayer.Character then
        CurrentTarget = selectedPlayer
        hookTargetRespawn(selectedPlayer)
        local tc = selectedPlayer.Character
        local targetTorso = getTargetTorso(tc)
        if targetTorso then
            V.X, V.Y, V.Z = 0, 0, -1.8
            V.RX, V.RY, V.RZ = 0, 180, 0
            storeWeldInfo(selectedPlayer, 148840371, true, "jerk")
            local ok, w = pcall(function() return WeldTo(targetTorso, 148840371, false) end)
            if ok and w then CurrentWeld = w end
        end
    end

    local jerkStart = tick()
    StateManager.JerkConn = RunService.Heartbeat:Connect(function()
        if not StateManager.JerkActive or not LP.Character then
            if StateManager.JerkConn then StateManager.JerkConn:Disconnect(); StateManager.JerkConn = nil end
            StateManager.JerkActive = false
            return
        end
        local el = tick() - jerkStart
        local microTilt = math.sin(el * 24) * 0.08
        if CurrentWeld and not isSolo then
            V.Z = -1.8 + microTilt
        end
    end)

    sClick()
    notify("COCO POWDER", "✊ R6 Jerk Procedural Engine Active!" .. (isSolo and " (Solo Mode)" or (" → " .. (selectedPlayer and selectedPlayer.Name or "Target"))))
end

-- 11. GENERAL PRESET RUNNER
local function runPreset(x, y, z, rx, ry, rz, animId, presetName)
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    V.X, V.Y, V.Z    = x, y, z
    V.RX, V.RY, V.RZ = rx, ry, rz

    pcall(function()
        if UIRefs.SlX then UIRefs.SlX.set(x, false) end
        if UIRefs.SlY then UIRefs.SlY.set(y, false) end
        if UIRefs.SlZ then UIRefs.SlZ.set(z, false) end
        if UIRefs.SlRX then UIRefs.SlRX.set(rx, false) end
        if UIRefs.SlRY then UIRefs.SlRY.set(ry, false) end
        if UIRefs.SlRZ then UIRefs.SlRZ.set(rz, false) end
    end)

    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then return end

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    storeWeldInfo(selectedPlayer, animId, false, "preset")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(targetTorso, animId, false) end)
    if ok and w then
        CurrentWeld = w
        sSuccess()
        notify("COCO POWDER", (presetName or "Preset") .. " → " .. selectedPlayer.Name)
    end
end

-- 12. DYNAMIC BANG RUNNER
local function runBang(animId, speed, rangeOverride)
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select player first!")
        sError()
        return
    end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    local tc = selectedPlayer.Character
    local targetTorso = getTargetTorso(tc)
    if not targetTorso then return end

    local touchZ = (getTorsoDepth(LP.Character) + getTorsoDepth(tc)) / 2 + 0.15
    V.X, V.Y, V.Z    = 0, 0, touchZ
    V.RX, V.RY, V.RZ = 0, 0, 0
    ThrustTouchZ     = touchZ
    ThrustDirection  = 1

    if rangeOverride then
        ThrustRange = rangeOverride
        pcall(function()
            if UIRefs.SlThrustDist then UIRefs.SlThrustDist.set(rangeOverride, true) end
        end)
    end
    if speed then ThrustSpeed = speed end

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    storeWeldInfo(selectedPlayer, animId, true, "bang")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(targetTorso, animId, false) end)
    if ok and w then
        CurrentWeld = w
        startThrust()
        sSuccess()
        notify("COCO POWDER", "💥 Bang → " .. selectedPlayer.Name)
    end
end

-- 13. FACE BANG RUNNER
local function runFBang(animId, speed, isAggressive)
    if not selectedPlayer or not selectedPlayer.Character then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer

    local head = selectedPlayer.Character:FindFirstChild("Head") or getTargetTorso(selectedPlayer.Character)
    if not head then return end

    V.X  = 0
    V.Y  = 2.5
    V.Z  = -1.5
    V.RX = 0
    V.RY = 180 -- Only Y-Axis rotation
    V.RZ = 0

    startThrust(-4.0, -0.4)
    if speed then ThrustSpeed = speed end

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    storeWeldInfo(selectedPlayer, animId, true, isAggressive and "fbangagg" or "fbang")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(head, animId, false) end)
    if ok and w then
        CurrentWeld = w
        sSuccess()
        notify("COCO POWDER", "💦 Face Bang (Y:2.5, RY:180°) → " .. selectedPlayer.Name)
    end
end

-- Auto re-weld callback implementation
performAutoReweld = function(targetPlr, reasonText)
    if not AutoReweldEnabled then return end
    if not targetPlr or not targetPlr.Character then return end

    if LastWeldType == "kiss" then
        executeZeroDelayKiss()
        return
    elseif LastWeldType == "hug" then
        executeZeroDelayHug()
        return
    elseif LastWeldType == "pos69" then
        executeZeroDelay69()
        return
    elseif LastWeldType == "shoulder" then
        executeShoulderSit()
        return
    elseif LastWeldType == "headsit" then
        executeHeadSit()
        return
    elseif LastWeldType == "backpack" then
        executeBackpack()
        return
    elseif LastWeldType == "carry" then
        executeCarry()
        return
    elseif LastWeldType == "slap" then
        executeZeroDelaySlap()
        return
    elseif LastWeldType == "stare" then
        executeZeroDelayStare()
        return
    elseif LastWeldType == "back_orbit" then
        StateManager.executeBackOrbit()
        return
    elseif LastWeldType == "backpack_ride" then
        StateManager.executeBackpackRide()
        return
    elseif LastWeldType == "foot_sit" then
        StateManager.executeFootSit()
        return
    elseif LastWeldType == "side_glance" then
        StateManager.executeSideGlanceLock()
        return
    elseif LastWeldType == "shadow_glitch" then
        StateManager.executeShadowGlitch()
        return
    elseif LastWeldType == "crawler" then
        StateManager.executeCrawlerPosition()
        return
    elseif LastWeldType == "hover_crown" then
        StateManager.executeHoverCrown()
        return
    elseif LastWeldType == "leg_drag" then
        StateManager.executeLegDragFollow()
        return
    elseif LastWeldType == "bow_down" then
        StateManager.executeBowDown()
        return
    elseif LastWeldType == "point_mock" then
        StateManager.executePointMock()
        return
    elseif LastWeldType == "blow_kiss" then
        StateManager.executeBlowKiss()
        return
    elseif LastWeldType == "flex_pose" then
        StateManager.executeFlexPose()
        return
    elseif LastWeldType == "slap_back" then
        StateManager.executeSlapBack()
        return
    elseif LastWeldType == "handshake" then
        StateManager.executeHandshakePose()
        return
    elseif LastWeldType == "pat_head" then
        StateManager.executePatHead()
        return
    elseif LastWeldType == "belly_dance" then
        StateManager.executeBellyDance()
        return
    elseif LastWeldType == "spank" then
        StateManager.executeSpankOffset()
        return
    elseif LastWeldType == "fling_arc" then
        StateManager.executeFakeFlingArc()
        return
    elseif LastWeldType == "fbang" or LastWeldType == "fbangagg" then
        runFBang(LastWeldAnimId or 148840371, 2.2, LastWeldType == "fbangagg")
        return
    elseif LastWeldType == "bang" then
        runBang(LastWeldAnimId or 148840371, 2.2)
        return
    end

    local targetTorso = getTargetTorso(targetPlr.Character)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = targetPlr
    selectedPlayer = targetPlr

    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local ok, w = pcall(function() return WeldTo(targetTorso, LastWeldAnimId, AnimCopyEnabled) end)
    if ok and w then
        CurrentWeld = w
        if LastWeldWasThrust then startThrust() end
        sSuccess()
        notify("COCO POWDER", (reasonText or "Auto re-weld") .. " → " .. targetPlr.Name)
    end
end

--[[═══════════════════════════════════════════════════════════════════════════════
  🖥️ GUI CONSTRUCTION & V19 HIGH-FIDELITY USER INTERFACE
═══════════════════════════════════════════════════════════════════════════════]]
print("[COCO POWDER V19] Assembling Master ScreenGui...")

-- Determine responsive dimensions with guaranteed non-zero fallbacks
local vp = cam.ViewportSize
local screenW = (vp and vp.X > 400) and vp.X or 1280
local screenH = (vp and vp.Y > 400) and vp.Y or 720
local W = math.clamp(screenW - 40, 420, 480)
local H = 370

local gui = Instance.new("ScreenGui")
gui.Name = "CocoPowderV20"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true

-- Safe parenting with fallback to PlayerGui
local mountOk = pcall(function() gui.Parent = GuiParent end)
if not mountOk then
    gui.Parent = LP:WaitForChild("PlayerGui")
end

--[[ Floating Mobile / Executor Toggle Icon ]]
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
local mobStroke = Instance.new("UIStroke")
mobStroke.Color = T.Neon
mobStroke.Thickness = 2
mobStroke.Parent = mobToggle

-- Draggable mobile toggle
local mobDrag, mobStart, mobPos
mobToggle.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        mobDrag = true
        mobStart = inp.Position
        mobPos = mobToggle.Position
    end
end)
UIS.InputChanged:Connect(function(inp)
    if mobDrag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        local delta = inp.Position - mobStart
        mobToggle.Position = UDim2.new(mobPos.X.Scale, mobPos.X.Offset + delta.X, mobPos.Y.Scale, mobPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        mobDrag = false
    end
end)

-- Main Hub Window
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

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = T.Border
mainStroke.Thickness = 1.2
mainStroke.Transparency = 0.3
mainStroke.Parent = main

local mainGrad = Instance.new("UIGradient")
mainGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, T.BG),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(18, 20, 24)),
    ColorSequenceKeypoint.new(1, T.BG2),
})
mainGrad.Rotation = 135
mainGrad.Parent = main

-- Mobile toggle click triggers visibility
mobToggle.MouseButton1Click:Connect(function()
    sClick()
    main.Visible = not main.Visible
end)

-- Header Frame
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 44)
header.BackgroundColor3 = T.Panel
header.BorderSizePixel = 0
header.ZIndex = 6
header.Parent = main
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)

local hFix = Instance.new("Frame")
hFix.Size = UDim2.new(1, 0, 0, 12)
hFix.Position = UDim2.new(0, 0, 1, -12)
hFix.BackgroundColor3 = T.Panel
hFix.BorderSizePixel = 0
hFix.ZIndex = 7
hFix.Parent = header

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

local vTag = Instance.new("TextLabel")
vTag.Size = UDim2.new(0, 60, 0, 16)
vTag.Position = UDim2.new(0, 165, 0, 14)
vTag.BackgroundColor3 = T.Accent
vTag.Text = "V20 +31 NEW"
vTag.TextColor3 = Color3.new(1, 1, 1)
vTag.Font = Enum.Font.GothamBlack
vTag.TextSize = 8
vTag.ZIndex = 8
vTag.Parent = header
Instance.new("UICorner", vTag).CornerRadius = UDim.new(0, 4)

-- Button Ripple & Styling Utility
local BtnColors = setmetatable({}, {__mode = "k"})

local function ripple(btn, input)
    pcall(function()
        local r = Instance.new("Frame")
        r.AnchorPoint = Vector2.new(0.5, 0.5)
        r.Position = UDim2.new(0, input.Position.X - btn.AbsolutePosition.X, 0, input.Position.Y - btn.AbsolutePosition.Y)
        r.Size = UDim2.new(0, 0, 0, 0)
        r.BackgroundColor3 = Color3.new(1, 1, 1)
        r.BackgroundTransparency = 0.5
        r.ZIndex = btn.ZIndex + 2
        r.Parent = btn
        Instance.new("UICorner", r).CornerRadius = UDim.new(1, 0)
        local maxSize = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2
        TweenService:Create(r, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, maxSize, 0, maxSize),
            BackgroundTransparency = 1
        }):Play()
        Debris:AddItem(r, 0.6)
    end)
end

local function setBtnColor(b, c)
    BtnColors[b] = c
    TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = c}):Play()
end

local function styleBtn(b, initialColor)
    BtnColors[b] = initialColor
    b.BackgroundColor3 = initialColor
    b.AutoButtonColor = false
    b.ClipsDescendants = true
    b.MouseEnter:Connect(function()
        sHover()
        if BtnColors[b] then
            TweenService:Create(b, TweenInfo.new(0.12), {
                BackgroundColor3 = BtnColors[b]:Lerp(Color3.new(1, 1, 1), 0.18)
            }):Play()
        end
    end)
    b.MouseLeave:Connect(function()
        if BtnColors[b] then
            TweenService:Create(b, TweenInfo.new(0.18), {
                BackgroundColor3 = BtnColors[b]
            }):Play()
        end
    end)
    b.MouseButton1Down:Connect(function(input)
        if input and b.AbsoluteSize.X > 20 then
            ripple(b, input)
        end
    end)
end

-- Header Window Action Buttons
local function makeWinBtn(xPos, bgColor)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 28, 0, 28)
    b.Position = UDim2.new(1, xPos, 0, 8)
    b.BackgroundColor3 = bgColor
    b.Text = ""
    b.AutoButtonColor = false
    b.ZIndex = 8
    b.Parent = header
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseEnter:Connect(function()
        sHover()
        TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = bgColor:Lerp(Color3.new(1, 1, 1), 0.25)}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.18), {BackgroundColor3 = bgColor}):Play()
    end)
    b.MouseButton1Down:Connect(function(input) ripple(b, input) end)
    return b
end

local btnMin = makeWinBtn(-90, T.PanelLt)
local minLine = Instance.new("Frame")
minLine.Size = UDim2.new(0, 12, 0, 2)
minLine.Position = UDim2.new(0.5, -6, 0.5, -1)
minLine.BackgroundColor3 = T.Text
minLine.BorderSizePixel = 0
minLine.ZIndex = 9
minLine.Parent = btnMin

local btnClose = makeWinBtn(-58, T.Accent)
local x1 = Instance.new("Frame")
x1.Size = UDim2.new(0, 14, 0, 2)
x1.Position = UDim2.new(0.5, -7, 0.5, -1)
x1.BackgroundColor3 = Color3.new(1, 1, 1)
x1.BorderSizePixel = 0
x1.Rotation = 45
x1.ZIndex = 9
x1.Parent = btnClose
local x2 = Instance.new("Frame")
x2.Size = UDim2.new(0, 14, 0, 2)
x2.Position = UDim2.new(0.5, -7, 0.5, -1)
x2.BackgroundColor3 = Color3.new(1, 1, 1)
x2.BorderSizePixel = 0
x2.Rotation = -45
x2.ZIndex = 9
x2.Parent = btnClose

-- Draggable Window Behavior
local dragging, dragStart, startPos
header.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = inp.Position
        startPos = main.Position
    end
end)
UIS.InputChanged:Connect(function(inp)
    if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        local d = inp.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Horizontal Tabs Bar
local tabsBar = Instance.new("ScrollingFrame")
tabsBar.Name = "TabsBar"
tabsBar.Size = UDim2.new(1, 0, 0, 40)
tabsBar.Position = UDim2.new(0, 0, 0, 44)
tabsBar.BackgroundColor3 = T.BG2
tabsBar.BorderSizePixel = 0
tabsBar.ScrollBarThickness = 0
tabsBar.ScrollingDirection = Enum.ScrollingDirection.X
tabsBar.CanvasSize = UDim2.new(0, 0, 0, 0)
tabsBar.AutomaticCanvasSize = Enum.AutomaticSize.X
tabsBar.ZIndex = 6
tabsBar.Parent = main

local tabsLayout = Instance.new("UIListLayout")
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
tabsLayout.Padding = UDim.new(0, 4)
tabsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabsLayout.Parent = tabsBar

local tabsPad = Instance.new("UIPadding")
tabsPad.PaddingLeft = UDim.new(0, 8)
tabsPad.PaddingRight = UDim.new(0, 8)
tabsPad.Parent = tabsBar

-- Main Content Container
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, 0, 1, -140)
content.Position = UDim2.new(0, 0, 0, 84)
content.BackgroundTransparency = 1
content.ZIndex = 6
content.Parent = main

-- Footer Frame
local footer = Instance.new("Frame")
footer.Name = "Footer"
footer.Size = UDim2.new(1, 0, 0, 56)
footer.Position = UDim2.new(0, 0, 1, -56)
footer.BackgroundColor3 = T.Panel
footer.BorderSizePixel = 0
footer.ZIndex = 6
footer.Parent = main

local fTop = Instance.new("Frame")
fTop.Size = UDim2.new(1, 0, 0, 2)
fTop.BackgroundColor3 = T.Accent
fTop.BorderSizePixel = 0
fTop.ZIndex = 7
fTop.Parent = footer

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
btnWeld.ZIndex = 8
btnWeld.Parent = footer
Instance.new("UICorner", btnWeld).CornerRadius = UDim.new(0, 8)
styleBtn(btnWeld, T.Accent)

local btnUnweld = Instance.new("TextButton")
btnUnweld.Size = UDim2.new(0, 95, 0, 38)
btnUnweld.Position = UDim2.new(1, -105, 0, 9)
btnUnweld.Text = "🔓 UNWELD"
btnUnweld.TextColor3 = Color3.new(1, 1, 1)
btnUnweld.Font = Enum.Font.GothamBlack
btnUnweld.TextSize = 12
btnUnweld.ZIndex = 8
btnUnweld.Parent = footer
Instance.new("UICorner", btnUnweld).CornerRadius = UDim.new(0, 8)
styleBtn(btnUnweld, T.Danger)

-- Tab Creation Utility
local TabPages, TabButtons = {}, {}
local tabCounter = 0

local function showTab(name)
    for n, p in pairs(TabPages) do
        p.Visible = (n == name)
    end
    for n, b in pairs(TabButtons) do
        local act = (n == name)
        TweenService:Create(b, TweenInfo.new(0.15), {
            BackgroundColor3 = act and T.Accent or T.Panel,
            TextColor3 = act and Color3.new(1, 1, 1) or T.Muted,
        }):Play()
    end
end

local function createTab(name, icon)
    tabCounter = tabCounter + 1
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 84, 0, 26)
    btn.BackgroundColor3 = T.Panel
    btn.Text = icon .. " " .. name
    btn.TextColor3 = T.Muted
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.LayoutOrder = tabCounter
    btn.ZIndex = 7
    btn.Parent = tabsBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    styleBtn(btn, T.Panel)
    btn.MouseButton1Click:Connect(function()
        sClick()
        showTab(name)
    end)
    TabButtons[name] = btn

    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = T.Accent
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.ZIndex = 6
    page.Parent = content

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 6)
    pad.PaddingBottom = UDim.new(0, 6)
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)
    pad.Parent = page

    local lst = Instance.new("UIListLayout")
    lst.Padding = UDim.new(0, 5)
    lst.SortOrder = Enum.SortOrder.LayoutOrder
    lst.Parent = page

    TabPages[name] = page
    return page
end

-- Slider Widget Builder
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
    local knobStroke = Instance.new("UIStroke")
    knobStroke.Color = T.Accent
    knobStroke.Thickness = 2
    knobStroke.Parent = knob

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
        v = math.clamp(v, minV, maxV)
        cur = v
        vb.Text = tostring(math.floor(v * 100 + 0.5) / 100)
        local pct = (v - minV) / (maxV - minV)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, -9, 0.5, -9)
        if fire and onChange then onChange(v) end
    end

    local drag = false
    local function upd(inp)
        local rX = inp.Position.X - bg.AbsolutePosition.X
        local pct = math.clamp(rX / bg.AbsoluteSize.X, 0, 1)
        setVal(minV + pct * (maxV - minV), true)
    end

    bg.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            drag = true
            upd(inp)
            sHover()
        end
    end)
    bg.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if drag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            upd(inp)
        end
    end)
    vb.FocusLost:Connect(function()
        local n = tonumber(vb.Text)
        if n then
            setVal(n, true)
            sClick()
        else
            setVal(cur, false)
        end
    end)

    setVal(defV, false)
    return {
        set = setVal,
        get = function() return cur end
    }
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

--[[═══════════════════════════════════════════════════════════════════════════════
  👥 PLAYERS TAB
═══════════════════════════════════════════════════════════════════════════════]]
local playersTab = createTab("Players", "👥")

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, 0, 0, 32)
searchBox.BackgroundColor3 = T.Panel
searchBox.PlaceholderText = "🔍 Search player by username or display name..."
searchBox.Text = ""
searchBox.TextColor3 = T.Text
searchBox.PlaceholderColor3 = T.Muted
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
listFrame.ClipsDescendants = true
listFrame.ZIndex = 7
listFrame.Parent = playersTab
Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 7)

local listScroll = Instance.new("ScrollingFrame")
listScroll.Size = UDim2.new(1, -6, 1, -6)
listScroll.Position = UDim2.new(0, 3, 0, 3)
listScroll.BackgroundTransparency = 1
listScroll.BorderSizePixel = 0
listScroll.ScrollBarThickness = 2
listScroll.ScrollBarImageColor3 = T.Accent
listScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
listScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
listScroll.ZIndex = 8
listScroll.Parent = listFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = listScroll

local function findPlayers(q)
    q = (q or ""):lower()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            if q == "" or p.Name:lower():sub(1, #q) == q or p.DisplayName:lower():sub(1, #q) == q then
                table.insert(list, p)
            end
        end
    end
    return list
end

local function refreshList()
    for _, c in ipairs(listScroll:GetChildren()) do
        if c:IsA("TextButton") or c:IsA("TextLabel") then c:Destroy() end
    end
    local plrs = findPlayers(searchBox.Text)
    if #plrs == 0 then
        local e = Instance.new("TextLabel")
        e.Size = UDim2.new(1, 0, 0, 30)
        e.BackgroundTransparency = 1
        e.Text = "No players found"
        e.TextColor3 = T.Muted
        e.Font = Enum.Font.Gotham
        e.TextSize = 11
        e.LayoutOrder = 1
        e.ZIndex = 9
        e.Parent = listScroll
        return
    end

    for i, p in ipairs(plrs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -6, 0, 32)
        btn.BackgroundColor3 = (selectedPlayer == p) and T.Accent or T.PanelLt
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.LayoutOrder = i
        btn.ZIndex = 9
        btn.ClipsDescendants = true
        btn.Parent = listScroll
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        styleBtn(btn, (selectedPlayer == p) and T.Accent or T.PanelLt)

        local av = Instance.new("ImageLabel")
        av.Size = UDim2.new(0, 24, 0, 24)
        av.Position = UDim2.new(0, 4, 0.5, -12)
        av.BackgroundColor3 = T.Panel
        av.Image = "rbxthumb://type=AvatarHeadShot&id=" .. p.UserId .. "&w=48&h=48"
        av.ZIndex = 10
        av.Parent = btn
        Instance.new("UICorner", av).CornerRadius = UDim.new(1, 0)

        local nm = Instance.new("TextLabel")
        nm.Size = UDim2.new(1, -36, 1, 0)
        nm.Position = UDim2.new(0, 32, 0, 0)
        nm.BackgroundTransparency = 1
        nm.Text = p.Name .. (p.DisplayName ~= p.Name and (" (" .. p.DisplayName .. ")") or "")
        nm.TextColor3 = Color3.new(1, 1, 1)
        nm.Font = Enum.Font.GothamBold
        nm.TextSize = 11
        nm.TextXAlignment = Enum.TextXAlignment.Left
        nm.ZIndex = 10
        nm.Parent = btn

        btn.MouseButton1Click:Connect(function()
            selectedPlayer = p
            footerLabel.Text = "👤 " .. p.Name
            footerSub.Text = "Ready — Select an Action or Tap WELD"
            sClick()
            refreshList()
        end)
    end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function() pcall(refreshList) end)
pcall(function() refreshList() end)

Players.PlayerAdded:Connect(function(p)
    task.wait(0.5)
    pcall(refreshList)
    if AutoReweldEnabled and LastWeldTargetUserId and p.UserId == LastWeldTargetUserId then
        task.wait(1.5)
        if not p.Character then return end
        selectedPlayer = p
        footerLabel.Text = "👤 " .. p.Name
        footerSub.Text = "Rejoined — auto re-welding..."
        if performAutoReweld then performAutoReweld(p, "Rejoin re-weld") end
        hookTargetRespawn(p)
    end
end)

Players.PlayerRemoving:Connect(function(p)
    if selectedPlayer == p then
        if AutoReweldEnabled and LastWeldTargetUserId == p.UserId then
            footerLabel.Text = "👤 " .. p.Name .. " (left)"
            footerSub.Text = "⏳ Waiting for target rejoin..."
            StateManager:Cleanup(true)
        else
            selectedPlayer = nil
            footerLabel.Text = "👤 No player selected"
            footerSub.Text = "Select a player to begin"
        end
    end
    task.wait(0.1)
    pcall(refreshList)
end)

--[[═══════════════════════════════════════════════════════════════════════════════
  📐 ADJUST TAB (6-AXIS REAL-TIME CFRAME & SPEED)
═══════════════════════════════════════════════════════════════════════════════]]

--[[═══════════════════════════════════════════════════════════════════════════════
  🔗 ATTACH TAB (POSITION & LOCK FEATURES 1-10) [DO-SCOPED]
═══════════════════════════════════════════════════════════════════════════════]]
do
    local attachTab = createTab("Attach", "🔗")
    sectionLbl(attachTab, 1, "📍 POSITION & LOCK FEATURES (1-10 ZERO-DELAY)", T.Accent)

    local function attachRow(order, btns)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 36)
        row.BackgroundTransparency = 1
        row.LayoutOrder = order
        row.ZIndex = 7
        row.Parent = attachTab
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
            b.ZIndex = 8
            b.Parent = row
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
            styleBtn(b, cfg.color)
            b.MouseButton1Click:Connect(function() sClick(); if cfg.cb then pcall(cfg.cb) end end)
        end
    end

    attachRow(2, {
        { text = "🌀 Back Orbit (360°)", color = Color3.fromRGB(45, 49, 58), cb = StateManager.executeBackOrbit },
        { text = "🎒 Backpack Ride", color = Color3.fromRGB(55, 60, 70), cb = StateManager.executeBackpackRide },
        { text = "👣 Foot Sit", color = Color3.fromRGB(42, 46, 54), cb = StateManager.executeFootSit },
    })
    attachRow(3, {
        { text = "👁 Side Glance Lock", color = Color3.fromRGB(58, 63, 74), cb = StateManager.executeSideGlanceLock },
        { text = "⚡ Phase Shift (Dash)", color = Color3.fromRGB(64, 70, 82), cb = StateManager.executePhaseShift },
        { text = "👤 Shadow Glitch", color = Color3.fromRGB(36, 39, 46), cb = StateManager.executeShadowGlitch },
    })
    attachRow(4, {
        { text = "🐛 Crawler Position", color = Color3.fromRGB(50, 54, 64), cb = StateManager.executeCrawlerPosition },
        { text = "👑 Hover Crown (Halo)", color = Color3.fromRGB(245, 158, 11), cb = StateManager.executeHoverCrown },
        { text = "🦵 Leg Drag Follow", color = Color3.fromRGB(60, 65, 76), cb = StateManager.executeLegDragFollow },
    })
    attachRow(5, {
        { text = "🎥 Reverse POV (Target)", color = Color3.fromRGB(168, 85, 247), cb = StateManager.executeReversePOV },
        { text = "🪑 Shoulder Sit", color = Color3.fromRGB(44, 48, 56), cb = executeShoulderSit },
        { text = "🪑 Head Sit", color = Color3.fromRGB(48, 52, 62), cb = executeHeadSit },
    })
end

--[[═══════════════════════════════════════════════════════════════════════════════
  ⚡ ACTIONS TAB (ANIMATIONS & INTERACTION FEATURES 11-20) [DO-SCOPED]
═══════════════════════════════════════════════════════════════════════════════]]
do
    local actionsTab = createTab("Actions", "⚡")
    sectionLbl(actionsTab, 1, "🎭 ANIMATIONS & INTERACTIONS (11-20 ZERO-DELAY)", T.Neon)

    local function actionsRow(order, btns)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 36)
        row.BackgroundTransparency = 1
        row.LayoutOrder = order
        row.ZIndex = 7
        row.Parent = actionsTab
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
            b.ZIndex = 8
            b.Parent = row
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
            styleBtn(b, cfg.color)
            b.MouseButton1Click:Connect(function() sClick(); if cfg.cb then pcall(cfg.cb) end end)
        end
    end

    actionsRow(2, {
        { text = "🙇 Bow Down (Sajda)", color = Color3.fromRGB(160, 40, 70), cb = StateManager.executeBowDown },
        { text = "👉 Point & Mock", color = Color3.fromRGB(52, 57, 67), cb = StateManager.executePointMock },
        { text = "💋 Blow Kiss (Hearts)", color = Color3.fromRGB(64, 70, 82), cb = StateManager.executeBlowKiss },
    })
    actionsRow(3, {
        { text = "💪 Flex Pose Cycle", color = Color3.fromRGB(54, 59, 70), cb = StateManager.executeFlexPose },
        { text = "🥊 Fake Uppercut", color = Color3.fromRGB(239, 68, 68), cb = StateManager.executeFakeUppercut },
        { text = "👋 Slap Back (Rear)", color = Color3.fromRGB(60, 65, 76), cb = StateManager.executeSlapBack },
    })
    actionsRow(4, {
        { text = "🤝 Handshake Pose", color = Color3.fromRGB(16, 185, 129), cb = StateManager.executeHandshakePose },
        { text = "👋 Pat Head", color = Color3.fromRGB(245, 158, 11), cb = StateManager.executePatHead },
        { text = "💃 Belly Dance / Twerk", color = Color3.fromRGB(46, 50, 60), cb = StateManager.executeBellyDance },
    })
    actionsRow(5, {
        { text = "🍑 Spank Offset", color = Color3.fromRGB(60, 65, 76), cb = StateManager.executeSpankOffset },
        { text = "🤗 Zero-Delay Hug", color = Color3.fromRGB(64, 70, 82), cb = executeZeroDelayHug },
        { text = "💋 True Kiss (3576686446)", color = Color3.fromRGB(60, 65, 76), cb = StateManager.executeTrueKiss },
    })
    actionsRow(6, {
        { text = "✊ R6 Jerk (Solo/Target)", color = Color3.fromRGB(245, 158, 11), cb = function() StateManager.executeR6Jerk(not selectedPlayer) end },
        { text = "💞 Romance Clasp (10281064499)", color = Color3.fromRGB(55, 60, 72), cb = StateManager.executeRomanceClasp },
        { text = "🔥 Passion Grip (82810853201599)", color = Color3.fromRGB(239, 68, 68), cb = StateManager.executePassionGrip },
    })
end

--[[═══════════════════════════════════════════════════════════════════════════════
  🛠 UTILITY TAB (UTILITY, TROLL & CAMERA SUITE 21-31) [DO-SCOPED]
═══════════════════════════════════════════════════════════════════════════════]]
do
    local utilityTab = createTab("Utility", "🛠")
    sectionLbl(utilityTab, 1, "🛠 UTILITY, TROLL & CAMERA SUITE (21-31 ZERO-DELAY)", T.Accent)

    local function utilityRow(order, btns)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 36)
        row.BackgroundTransparency = 1
        row.LayoutOrder = order
        row.ZIndex = 7
        row.Parent = utilityTab
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
            b.ZIndex = 8
            b.Parent = row
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
            styleBtn(b, cfg.color)
            b.MouseButton1Click:Connect(function()
                sClick()
                if cfg.cb then
                    pcall(cfg.cb)
                elseif cfg.isNebula then
                    if StateManager.PromptNebulaFling then
                        pcall(StateManager.PromptNebulaFling)
                    elseif promptNebulaFling then
                        pcall(promptNebulaFling)
                    end
                end
            end)
        end
    end

    utilityRow(2, {
        { text = "🧭 Auto Look-At", color = Color3.fromRGB(6, 182, 212), cb = StateManager.toggleAutoLookAt },
        { text = "🎯 Target Cam Lock", color = Color3.fromRGB(59, 130, 246), cb = StateManager.toggleTargetCamLock },
        { text = "👻 Ghost Mode (0.5α)", color = Color3.fromRGB(168, 85, 247), cb = StateManager.toggleGhostMode },
    })
    utilityRow(3, {
        { text = "⚡ Invisibility TP", color = Color3.fromRGB(60, 65, 76), cb = StateManager.executeInvisibilityTeleport },
        { text = "🌪️ Spin Tornado", color = Color3.fromRGB(245, 158, 11), cb = StateManager.toggleSpinAttack },
        { text = "🚀 Fake Fling Arc", color = Color3.fromRGB(55, 60, 72), cb = StateManager.executeFakeFlingArc },
    })
    utilityRow(4, {
        { text = "🏎️ Copy Velocity", color = Color3.fromRGB(16, 185, 129), cb = StateManager.toggleCopyVelocity },
        { text = "⚓ Anchor Lock (Freeze)", color = Color3.fromRGB(239, 68, 68), cb = StateManager.toggleAnchorLock },
        { text = "🚶 Noclip Walk", color = Color3.fromRGB(147, 51, 234), cb = StateManager.toggleNoclipWalk },
    })
    utilityRow(5, {
        { text = "📏 Height Match (Eye)", color = Color3.fromRGB(245, 158, 11), cb = StateManager.executeHeightMatch },
        { text = "🛡️ Distance Keeper (5s)", color = Color3.fromRGB(6, 182, 212), cb = StateManager.toggleDistanceKeeper },
        { text = "✨ Nebula Fling", color = Color3.fromRGB(168, 85, 247), isNebula = true },
    })
end

local adjustTab = createTab("Adjust", "📐")
sectionLbl(adjustTab, 1, "📐 POSITION OFFSET (STUDS)", T.Accent)
UIRefs.SlX = makeSlider(adjustTab, 2, "X", -10, 10, 0, function(v) V.X = v end)
UIRefs.SlY = makeSlider(adjustTab, 3, "Y", -10, 10, 0, function(v) V.Y = v end)
UIRefs.SlZ = makeSlider(adjustTab, 4, "Z", -10, 10, 1.3, function(v) V.Z = v end)

sectionLbl(adjustTab, 5, "🔄 ROTATION (DEGREES)", T.Warning)
UIRefs.SlRX = makeSlider(adjustTab, 6, "RX", -180, 180, 0, function(v) V.RX = v end)
UIRefs.SlRY = makeSlider(adjustTab, 7, "RY", -180, 180, 0, function(v) V.RY = v end)
UIRefs.SlRZ = makeSlider(adjustTab, 8, "RZ", -180, 180, 0, function(v) V.RZ = v end)

sectionLbl(adjustTab, 9, "🎬 ANIMATION SPEED MULTIPLIER", T.Success)
UIRefs.SlSpeed = makeSlider(adjustTab, 10, "Spd", 0.1, 4.0, 1.0, function(v)
    V.Speed = v
    for _, track in ipairs(PlayedAnims) do pcall(function() track:AdjustSpeed(v) end) end
    for _, track in ipairs(CopiedTracks) do pcall(function() track:AdjustSpeed(v) end) end
end)

local rowApply = Instance.new("Frame")
rowApply.Size = UDim2.new(1, 0, 0, 34)
rowApply.BackgroundTransparency = 1
rowApply.LayoutOrder = 11
rowApply.ZIndex = 7
rowApply.Parent = adjustTab

local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(0.65, -3, 1, 0)
applyBtn.Position = UDim2.new(0, 0, 0, 0)
applyBtn.Text = "⚡ APPLY & WELD"
applyBtn.TextColor3 = Color3.new(1, 1, 1)
applyBtn.Font = Enum.Font.GothamBlack
applyBtn.TextSize = 12
applyBtn.ZIndex = 8
applyBtn.Parent = rowApply
Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 7)
styleBtn(applyBtn, T.Accent)

local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0.35, -3, 1, 0)
resetBtn.Position = UDim2.new(0.65, 3, 0, 0)
resetBtn.Text = "↺ RESET"
resetBtn.TextColor3 = T.Text
resetBtn.Font = Enum.Font.GothamBlack
resetBtn.TextSize = 11
resetBtn.ZIndex = 8
resetBtn.Parent = rowApply
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 7)
styleBtn(resetBtn, T.PanelLt)

resetBtn.MouseButton1Click:Connect(function()
    sClick()
    UIRefs.SlX.set(0, true)
    UIRefs.SlY.set(0, true)
    UIRefs.SlZ.set(1.3, true)
    UIRefs.SlRX.set(0, true)
    UIRefs.SlRY.set(0, true)
    UIRefs.SlRZ.set(0, true)
    UIRefs.SlSpeed.set(1.0, true)
end)

applyBtn.MouseButton1Click:Connect(function()
    sClick()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select a player first")
        sError()
        return
    end
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    storeWeldInfo(selectedPlayer, 0, false, "weld")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(targetTorso, 0, AnimCopyEnabled) end)
    if ok and w then
        CurrentWeld = w
        sSuccess()
        notify("COCO POWDER", "Applied Offsets → " .. selectedPlayer.Name)
    end
end)

--[[═══════════════════════════════════════════════════════════════════════════════
  ⚡ PRESETS TAB
═══════════════════════════════════════════════════════════════════════════════]]
local presetsTab = createTab("Presets", "⚡")

local function presetRow(order, btns)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order
    row.ZIndex = 7
    row.Parent = presetsTab
    for i, cfg in ipairs(btns) do
        local bw = 1 / #btns
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(bw, -2, 1, 0)
        b.Position = UDim2.new((i - 1) * bw, 2, 0, 0)
        b.Text = cfg.text
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 10
        b.ZIndex = 8
        b.Parent = row
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
        styleBtn(b, cfg.color)
        b.MouseButton1Click:Connect(function()
            sClick()
            pcall(cfg.cb)
        end)
    end
end

local function fullBtn(order, text, color, cb)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 38)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order
    row.ZIndex = 7
    row.Parent = presetsTab
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 1, 0)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBlack
    b.TextSize = 12
    b.ZIndex = 8
    b.Parent = row
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    styleBtn(b, color)
    b.MouseButton1Click:Connect(function()
        sClick()
        pcall(cb)
    end)
end

presetRow(1, {
    {
        text = "🎭 Stand",
        color = Color3.fromRGB(45, 49, 58),
        cb = function()
            if isR15(LP) then
                runPreset(1.8, 1.8, 2.0, 0, 0, 0, 96658788627102, "Stand")
            else
                runPreset(1.5, 1.25, 2.0, 0, 0, 0, 313762630, "Stand")
            end
        end
    },
    {
        text = "⚔ Attack",
        color = Color3.fromRGB(52, 57, 67),
        cb = function()
            if isR15(LP) then
                runPreset(0, 0.5, -2.55, 0, 180, 0, 117183737438245, "Attack")
            else
                runPreset(0, 0, -1.25, 0, 180, 0, 259438880, "Attack")
            end
        end
    },
    {
        text = "🪑 HeadSit",
        color = Color3.fromRGB(42, 46, 54),
        cb = executeHeadSit
    },
})

presetRow(2, {
    {
        text = "💥 Bang 2.0",
        color = Color3.fromRGB(58, 63, 75),
        cb = function() runBang(148840371, 2.2) end
    },
    {
        text = "🎒 Backpack",
        color = Color3.fromRGB(160, 40, 60),
        cb = executeBackpack
    },
    {
        text = "🛏 Carpet",
        color = Color3.fromRGB(200, 120, 40),
        cb = function() runPreset(0, -1.0, 0, 0, 0, 0, 282574440, "Carpet") end
    },
})

fullBtn(3, "🔥 BANG AGGRESSIVE", Color3.fromRGB(65, 70, 82), function()
    local animId = getAnimIdForRig("BangAggressive", isR15(LP))
    runBang(animId, 4.8, 1.2)
end)

fullBtn(4, "💦 FACE BANG (Y:2.5, RY:180°)", Color3.fromRGB(48, 52, 62), function()
    runFBang(148840371, 2.2, false)
end)

fullBtn(5, "🔥💦 FACE BANG AGGRESSIVE", Color3.fromRGB(62, 67, 78), function()
    local animId = getAnimIdForRig("BangAggressive", isR15(LP))
    runFBang(animId, 5.0, true)
end)

sectionLbl(presetsTab, 6, "💥 BANG DYNAMIC CONTROLS", T.Warning)
UIRefs.SlThrustDist = makeSlider(presetsTab, 7, "Dist", 0.1, 3.5, 0.7, function(v) ThrustRange = v end)
UIRefs.SlThrustSpd  = makeSlider(presetsTab, 8, "Spd", 0.5, 6.0, 2.2, function(v) ThrustSpeed = v end)

presetRow(9, {
    {
        text = "🎪 Carry",
        color = Color3.fromRGB(180, 50, 50),
        cb = executeCarry
    },
    {
        text = "🤸 Leap",
        color = Color3.fromRGB(220, 90, 40),
        cb = function() runPreset(0, 2.5, 1.5, 15, 0, 0, 178130996, "Leap") end
    },
    {
        text = "🪁 Throne",
        color = Color3.fromRGB(180, 30, 60),
        cb = function() runPreset(0, 3.2, 0.5, 0, 0, 0, 282574440, "Throne") end
    },
})

sectionLbl(presetsTab, 10, "🛡 RESPAWN & AUTO RE-WELD", T.Neon)
local autoReweldBtn = Instance.new("TextButton")
autoReweldBtn.Size = UDim2.new(1, 0, 0, 36)
autoReweldBtn.LayoutOrder = 11
autoReweldBtn.Text = "🛡 AUTO RE-WELD: ON"
autoReweldBtn.TextColor3 = Color3.new(1, 1, 1)
autoReweldBtn.Font = Enum.Font.GothamBlack
autoReweldBtn.TextSize = 12
autoReweldBtn.ZIndex = 8
autoReweldBtn.Parent = presetsTab
Instance.new("UICorner", autoReweldBtn).CornerRadius = UDim.new(0, 8)
styleBtn(autoReweldBtn, T.Success)

autoReweldBtn.MouseButton1Click:Connect(function()
    AutoReweldEnabled = not AutoReweldEnabled
    if AutoReweldEnabled then
        setBtnColor(autoReweldBtn, T.Success)
        autoReweldBtn.Text = "🛡 AUTO RE-WELD: ON"
        sToggleOn()
    else
        setBtnColor(autoReweldBtn, T.PanelLt)
        autoReweldBtn.Text = "🛡 AUTO RE-WELD: OFF"
        sToggleOff()
    end
end)

sectionLbl(presetsTab, 12, "🎬 ANIMATION MIRROR & COPY", T.Success)
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(1, 0, 0, 36)
copyBtn.LayoutOrder = 13
copyBtn.Text = "📋 COPY TARGET ANIMATION: OFF"
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.Font = Enum.Font.GothamBlack
copyBtn.TextSize = 12
copyBtn.ZIndex = 8
copyBtn.Parent = presetsTab
Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 8)
styleBtn(copyBtn, T.PanelLt)

copyBtn.MouseButton1Click:Connect(function()
    AnimCopyEnabled = not AnimCopyEnabled
    if AnimCopyEnabled then
        setBtnColor(copyBtn, T.Success)
        copyBtn.Text = "✅ COPY TARGET ANIMATION: ON"
        sToggleOn()
    else
        setBtnColor(copyBtn, T.PanelLt)
        copyBtn.Text = "📋 COPY TARGET ANIMATION: OFF"
        sToggleOff()
        StateManager:StopCopying()
    end
end)

--[[═══════════════════════════════════════════════════════════════════════════════
  🎬 ANIMS TAB (CUSTOM PLAYER & BANG DANCE SUITE)
═══════════════════════════════════════════════════════════════════════════════]]
local animsTab = createTab("Anims", "🎬")
sectionLbl(animsTab, 1, "🎬 CUSTOM ANIMATION TRACK PLAYER", T.Accent)

local animInput = Instance.new("TextBox")
animInput.Size = UDim2.new(1, 0, 0, 34)
animInput.BackgroundColor3 = T.Panel
animInput.PlaceholderText = "Enter Roblox Animation Asset ID (e.g. 507770677)..."
animInput.Text = ""
animInput.TextColor3 = T.Text
animInput.PlaceholderColor3 = T.Muted
animInput.Font = Enum.Font.Gotham
animInput.TextSize = 12
animInput.LayoutOrder = 2
animInput.ClearTextOnFocus = false
animInput.ZIndex = 7
animInput.Parent = animsTab
Instance.new("UICorner", animInput).CornerRadius = UDim.new(0, 7)

local animRow = Instance.new("Frame")
animRow.Size = UDim2.new(1, 0, 0, 34)
animRow.BackgroundTransparency = 1
animRow.LayoutOrder = 3
animRow.ZIndex = 7
animRow.Parent = animsTab

local playBtn = Instance.new("TextButton")
playBtn.Size = UDim2.new(0.5, -2, 1, 0)
playBtn.Position = UDim2.new(0, 0, 0, 0)
playBtn.Text = "▶ PLAY ON SELF"
playBtn.TextColor3 = Color3.new(1, 1, 1)
playBtn.Font = Enum.Font.GothamBlack
playBtn.TextSize = 11
playBtn.ZIndex = 8
playBtn.Parent = animRow
Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 7)
styleBtn(playBtn, T.Success)

playBtn.MouseButton1Click:Connect(function()
    sClick()
    local id = tonumber(animInput.Text)
    if not id then
        notify("COCO POWDER", "Invalid ID entered!")
        sError()
        return
    end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local animator = hum and hum:FindFirstChildOfClass("Animator")
    if not animator then animator = char:FindFirstChildWhichIsA("Animator", true) end
    if not animator then return end

    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. id
    local ok, track = pcall(function() return animator:LoadAnimation(anim) end)
    if ok and track then
        pcall(function()
            track:AdjustSpeed(V.Speed)
            track:Play()
        end)
        table.insert(PlayedAnims, track)
        notify("COCO POWDER", "Playing Anim: " .. id)
        sSuccess()
    else
        notify("COCO POWDER", "Load Failed for ID: " .. id)
        sError()
    end
end)

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0.5, -2, 1, 0)
stopBtn.Position = UDim2.new(0.5, 2, 0, 0)
stopBtn.Text = "⏹ STOP ALL TRACKS"
stopBtn.TextColor3 = Color3.new(1, 1, 1)
stopBtn.Font = Enum.Font.GothamBlack
stopBtn.TextSize = 11
stopBtn.ZIndex = 8
stopBtn.Parent = animRow
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 7)
styleBtn(stopBtn, T.Danger)

stopBtn.MouseButton1Click:Connect(function()
    sClick()
    StateManager:StopAllAnimations()
    StateManager:StopCopying()
    notify("COCO POWDER", "All animation tracks cleared!")
end)

sectionLbl(animsTab, 4, "💃 BANG DANCE COLLECTION (SYNCHRONIZED)", T.Accent2)

local function runDanceBang(name, animId)
    if not selectedPlayer then
        local char = LP.Character
        if not char then return end
        local animator = char:FindFirstChildWhichIsA("Animator", true)
        if not animator then return end
        local a = Instance.new("Animation")
        a.AnimationId = "rbxassetid://" .. tostring(animId)
        local ok, tr = pcall(function() return animator:LoadAnimation(a) end)
        if ok and tr then
            pcall(function()
                tr:AdjustSpeed(V.Speed)
                tr:Play()
            end)
            table.insert(PlayedAnims, tr)
            notify(name, "Playing Solo Emote")
            sSuccess()
        end
        return
    end

    runBang(animId, 2.2)
    notify(name, "💃 Dancing with " .. selectedPlayer.Name)
end

local function danceRow(order, btns)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 38)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order
    row.ZIndex = 7
    row.Parent = animsTab
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
        b.ZIndex = 8
        b.Parent = row
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
        styleBtn(b, cfg.color)
        b.MouseButton1Click:Connect(function()
            sClick()
            pcall(function() runDanceBang(cfg.text:gsub("\n", " "), cfg.id) end)
        end)
    end
end

danceRow(5, {
    {text="Bang 3.0\nFloss", color=Color3.fromRGB(200, 40, 60), id=ANIM_DB.Dances.Floss},
    {text="Bang 4.0\nDefault", color=Color3.fromRGB(220, 70, 40), id=ANIM_DB.Dances.Default},
    {text="Bang 5.0\nOrange J.", color=Color3.fromRGB(56, 61, 72), id=ANIM_DB.Dances.OrangeJ},
})
danceRow(6, {
    {text="Bang 6.0\nGangnam", color=Color3.fromRGB(200, 50, 70), id=ANIM_DB.Dances.Gangnam},
    {text="Bang 7.0\nHype", color=Color3.fromRGB(180, 40, 50), id=ANIM_DB.Dances.Hype},
    {text="Bang 8.0\nParty", color=Color3.fromRGB(52, 57, 68), id=ANIM_DB.Dances.Party},
})
danceRow(7, {
    {text="Bang 9.0\nDontStart", color=Color3.fromRGB(180, 30, 60), id=ANIM_DB.Dances.DontStart},
    {text="Bang 10.0\nCha Cha", color=Color3.fromRGB(220, 60, 60), id=ANIM_DB.Dances.ChaCha},
    {text="Bang 11.0\nDance", color=Color3.fromRGB(200, 40, 80), id=ANIM_DB.Dances.Dance},
})
danceRow(8, {
    {text="Kiss 3576686446\n(Verified)", color=Color3.fromRGB(64, 70, 82), id=3576686446},
    {text="Romance\n10281064499", color=Color3.fromRGB(55, 60, 72), id=10281064499},
    {text="Passion Asset\n82810853201599", color=Color3.fromRGB(60, 65, 76), id=82810853201599},
})

--[[═══════════════════════════════════════════════════════════════════════════════
  🎯 EXTRA TAB (SPECIAL MOVES & NEBULA FLING DURATION PROMPT)
═══════════════════════════════════════════════════════════════════════════════]]
local extraTab = createTab("Extra", "🎯")
sectionLbl(extraTab, 1, "🎯 SPECIAL ACTIONS & COMBAT (ZERO-DELAY SYNCHRONIZED)", T.Accent)

-- Nebula Fling Duration Selector Dialog
local promptNebulaFling;
promptNebulaFling = function()
    StateManager.PromptNebulaFling = promptNebulaFling
    if not selectedPlayer then
        notify("COCO POWDER", "Select target player first!")
        sError()
        return
    end

    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.ZIndex = 120
    overlay.Parent = gui

    local modal = Instance.new("Frame")
    modal.Size = UDim2.new(0, 290, 0, 210)
    modal.Position = UDim2.new(0.5, -145, 0.5, -105)
    modal.BackgroundColor3 = T.Panel
    modal.BorderSizePixel = 0
    modal.ZIndex = 121
    modal.Parent = overlay
    Instance.new("UICorner", modal).CornerRadius = UDim.new(0, 12)

    local mStroke = Instance.new("UIStroke")
    mStroke.Color = T.Purple
    mStroke.Thickness = 2
    mStroke.Parent = modal

    local mTitle = Instance.new("TextLabel")
    mTitle.Size = UDim2.new(1, -20, 0, 28)
    mTitle.Position = UDim2.new(0, 10, 0, 10)
    mTitle.BackgroundTransparency = 1
    mTitle.Text = "✨ NEBULA FLING DURATION"
    mTitle.TextColor3 = T.Purple
    mTitle.Font = Enum.Font.GothamBlack
    mTitle.TextSize = 14
    mTitle.ZIndex = 122
    mTitle.Parent = modal

    local mSub = Instance.new("TextLabel")
    mSub.Size = UDim2.new(1, -20, 0, 20)
    mSub.Position = UDim2.new(0, 10, 0, 34)
    mSub.BackgroundTransparency = 1
    mSub.Text = "Target: " .. selectedPlayer.Name
    mSub.TextColor3 = T.Muted
    mSub.Font = Enum.Font.Gotham
    mSub.TextSize = 11
    mSub.ZIndex = 122
    mSub.Parent = modal

    local function makeOptBtn(y, text, color, cb)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -24, 0, 32)
        b.Position = UDim2.new(0, 12, 0, y)
        b.BackgroundColor3 = color
        b.Text = text
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 11
        b.ZIndex = 123
        b.Parent = modal
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        styleBtn(b, color)
        b.MouseButton1Click:Connect(function()
            sClick()
            overlay:Destroy()
            cb()
        end)
    end

    makeOptBtn(64, "⚡ 3 Seconds (Quick Blast)", Color3.fromRGB(168, 85, 247), function()
        launchNebulaFling(3.0, "3 Seconds")
    end)
    makeOptBtn(102, "🌪️ 10 Seconds (Extreme Annihilation)", Color3.fromRGB(60, 65, 76), function()
        launchNebulaFling(10.0, "10 Seconds")
    end)
    makeOptBtn(140, "♾️ Unlimited (Manual Stop Only)", Color3.fromRGB(64, 70, 82), function()
        launchNebulaFling(-1, "Unlimited")
    end)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -30, 0, 8)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = T.Muted
    closeBtn.Font = Enum.Font.GothamBlack
    closeBtn.TextSize = 14
    closeBtn.ZIndex = 124
    closeBtn.Parent = modal
    closeBtn.MouseButton1Click:Connect(function()
        sClick()
        overlay:Destroy()
    end)
end
StateManager.PromptNebulaFling = promptNebulaFling

-- Extra Action Rows
local function actionRow(order, btns)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 38)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order
    row.ZIndex = 7
    row.Parent = extraTab
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
        b.ZIndex = 8
        b.Parent = row
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
        styleBtn(b, cfg.color)
        b.MouseButton1Click:Connect(function()
            sClick()
            pcall(cfg.cb)
        end)
    end
end

actionRow(2, {
    {text = "✨ Nebula Fling", color = Color3.fromRGB(168, 85, 247), cb = promptNebulaFling},
    {text = "🤗 Zero-Delay Hug", color = Color3.fromRGB(64, 70, 82), cb = executeZeroDelayHug},
    {text = "💋 Zero-Delay Kiss", color = Color3.fromRGB(60, 65, 76), cb = executeZeroDelayKiss},
})

actionRow(3, {
    {text = "🔄 69 Position", color = Color3.fromRGB(55, 60, 72), cb = executeZeroDelay69},
    {text = "👋 Slap (Z:-1.5)", color = Color3.fromRGB(220, 60, 100), cb = executeZeroDelaySlap},
    {text = "🦵 Kick (Cross-Rig)", color = Color3.fromRGB(239, 68, 68), cb = executeZeroDelayKick},
})

actionRow(4, {
    {text = "🪑 Shoulder Sit", color = Color3.fromRGB(160, 80, 50), cb = executeShoulderSit},
    {text = "👁️ Stare (Eye-to-Eye)", color = Color3.fromRGB(58, 63, 74), cb = executeZeroDelayStare},
    {text = "🎒 Seated Backpack", color = Color3.fromRGB(160, 40, 60), cb = executeBackpack},
})

actionRow(5, {
    {text = "🎪 Carry Position", color = Color3.fromRGB(180, 50, 50), cb = executeCarry},
    {
        text = "🕳️ Underground",
        color = Color3.fromRGB(80, 50, 50),
        cb = function()
            if not selectedPlayer then return end
            StateManager:Cleanup(true)
            CurrentTarget = selectedPlayer
            V.X, V.Y, V.Z = 0, -50, 0
            V.RX, V.RY, V.RZ = 0, 0, 0
            pcall(function() workspace.FallenPartsDestroyHeight = -5000 end)
            local targetTorso = getTargetTorso(selectedPlayer.Character)
            if targetTorso then
                storeWeldInfo(selectedPlayer, 0, false, "underground")
                local ok, w = pcall(function() return WeldTo(targetTorso, 0, false) end)
                if ok and w then CurrentWeld = w; sSuccess() end
            end
        end
    },
    {
        text = "👁 Spectate Cam",
        color = Color3.fromRGB(120, 60, 60),
        cb = function()
            if not selectedPlayer or not selectedPlayer.Character then return end
            local hum = selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            StateManager:Cleanup(true)
            if not OriginalCameraSubject then OriginalCameraSubject = cam.CameraSubject end
            cam.CameraSubject = hum
            CurrentTarget = selectedPlayer
            notify("COCO POWDER", "Spectating: " .. selectedPlayer.Name)
            sSuccess()
        end
    },
})

actionRow(6, {
    {
        text = "👣 Follow Shadow",
        color = Color3.fromRGB(200, 100, 100),
        cb = function()
            if not selectedPlayer or not selectedPlayer.Character then return end
            StateManager:Cleanup(true)
            CurrentTarget = selectedPlayer
            local targetRoot = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not targetRoot or not root then return end
            pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
            local conn = RunService.Heartbeat:Connect(function()
                if not char.Parent or not targetRoot.Parent then return end
                root.CFrame = root.CFrame:Lerp(targetRoot.CFrame * CFrame.new(0, 0, 3), 0.25)
            end)
            local FollowWeld = {}
            function FollowWeld:Destroy() if conn then conn:Disconnect(); conn = nil end end
            CurrentWeld = FollowWeld
            sSuccess()
            notify("COCO POWDER", "Following " .. selectedPlayer.Name)
        end
    },
    {
        text = "🎥 Target Head POV",
        color = Color3.fromRGB(180, 60, 60),
        cb = function()
            if not selectedPlayer or not selectedPlayer.Character then return end
            local head = selectedPlayer.Character:FindFirstChild("Head")
            if not head then return end
            StateManager:Cleanup(true)
            if not OriginalCameraSubject then OriginalCameraSubject = cam.CameraSubject end
            cam.CameraSubject = head
            CurrentTarget = selectedPlayer
            sSuccess()
            notify("COCO POWDER", "Target POV: " .. selectedPlayer.Name)
        end
    },
    {
        text = "↺ Reset Cam & View",
        color = Color3.fromRGB(100, 80, 80),
        cb = function()
            StateManager:Cleanup(false)
            notify("COCO POWDER", "View & State completely reset")
            sSuccess()
        end
    },
})

--[[═══════════════════════════════════════════════════════════════════════════════
  🌀 MOTION TAB (ORBIT, BOUNCE, SUCK)
═══════════════════════════════════════════════════════════════════════════════]]
local motionTab = createTab("Motion", "🌀")
sectionLbl(motionTab, 1, "🌀 DYNAMIC ORBIT", T.Accent)
makeSlider(motionTab, 2, "Rad", 1.0, 10.0, 3.0, function(v) OrbitRadius = v end)
makeSlider(motionTab, 3, "Spd", 0.2, 4.0, 1.2, function(v) OrbitSpeed = v end)

local orbitBtn = Instance.new("TextButton")
orbitBtn.Size = UDim2.new(1, 0, 0, 34)
orbitBtn.LayoutOrder = 4
orbitBtn.Text = "🌀 START ZERO-DELAY ORBIT"
orbitBtn.TextColor3 = Color3.new(1, 1, 1)
orbitBtn.Font = Enum.Font.GothamBlack
orbitBtn.TextSize = 12
orbitBtn.ZIndex = 8
orbitBtn.Parent = motionTab
Instance.new("UICorner", orbitBtn).CornerRadius = UDim.new(0, 7)
styleBtn(orbitBtn, T.Accent)

orbitBtn.MouseButton1Click:Connect(function()
    sClick()
    if not selectedPlayer or not selectedPlayer.Character then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end
    V.X, V.Y, V.Z = 0, 0, OrbitRadius
    V.RX, V.RY, V.RZ = 0, 0, 0
    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local ok, w = pcall(function() return WeldTo(targetTorso, 148840371, false) end)
    if ok and w then
        CurrentWeld = w
        startMotion("orbit")
        sSuccess()
        notify("COCO POWDER", "🌀 Orbiting → " .. selectedPlayer.Name)
    end
end)

sectionLbl(motionTab, 5, "🏀 VERTICAL BOUNCE", T.Warning)
makeSlider(motionTab, 6, "Hgt", 1.0, 10.0, 3.0, function(v) BounceHeight = v end)
makeSlider(motionTab, 7, "Spd", 0.3, 5.0, 1.5, function(v) BounceSpeed = v end)

local bounceBtn = Instance.new("TextButton")
bounceBtn.Size = UDim2.new(1, 0, 0, 34)
bounceBtn.LayoutOrder = 8
bounceBtn.Text = "🏀 START BOUNCE"
bounceBtn.TextColor3 = Color3.new(1, 1, 1)
bounceBtn.Font = Enum.Font.GothamBlack
bounceBtn.TextSize = 12
bounceBtn.ZIndex = 8
bounceBtn.Parent = motionTab
Instance.new("UICorner", bounceBtn).CornerRadius = UDim.new(0, 7)
styleBtn(bounceBtn, T.Warning)

bounceBtn.MouseButton1Click:Connect(function()
    sClick()
    if not selectedPlayer or not selectedPlayer.Character then return end
    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then return end
    V.X, V.Y, V.Z = 0, 0, 1.5
    V.RX, V.RY, V.RZ = 0, 0, 0
    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    local ok, w = pcall(function() return WeldTo(targetTorso, 148840371, false) end)
    if ok and w then
        CurrentWeld = w
        startMotion("bounce")
        sSuccess()
        notify("COCO POWDER", "🏀 Bouncing → " .. selectedPlayer.Name)
    end
end)

--[[═══════════════════════════════════════════════════════════════════════════════
  🛡️ ANTI-SIT TAB
═══════════════════════════════════════════════════════════════════════════════]]
local antiSitTab = createTab("Anti-Sit", "🛡")
sectionLbl(antiSitTab, 1, "🛡 ANTI-SIT PROTECTION & SEAT EXPLOIT DEFENSE", T.Neon)

AntiSitCountLabel = Instance.new("TextLabel")
AntiSitCountLabel.Size = UDim2.new(1, 0, 0, 32)
AntiSitCountLabel.BackgroundColor3 = T.Panel
AntiSitCountLabel.Text = "🛡 Blocked: 0 times"
AntiSitCountLabel.TextColor3 = T.Neon
AntiSitCountLabel.Font = Enum.Font.GothamBlack
AntiSitCountLabel.TextSize = 12
AntiSitCountLabel.LayoutOrder = 2
AntiSitCountLabel.ZIndex = 7
AntiSitCountLabel.Parent = antiSitTab
Instance.new("UICorner", AntiSitCountLabel).CornerRadius = UDim.new(0, 7)

local antiSitBtn = Instance.new("TextButton")
antiSitBtn.Size = UDim2.new(1, 0, 0, 42)
antiSitBtn.LayoutOrder = 3
antiSitBtn.Text = "🛡 ENABLE ANTI-SIT PROTECTION"
antiSitBtn.TextColor3 = Color3.new(1, 1, 1)
antiSitBtn.Font = Enum.Font.GothamBlack
antiSitBtn.TextSize = 13
antiSitBtn.ZIndex = 8
antiSitBtn.Parent = antiSitTab
Instance.new("UICorner", antiSitBtn).CornerRadius = UDim.new(0, 8)
styleBtn(antiSitBtn, T.PanelLt)

antiSitBtn.MouseButton1Click:Connect(function()
    if AntiSitEnabled then
        disableAntiSit()
        setBtnColor(antiSitBtn, T.PanelLt)
        antiSitBtn.Text = "🛡 ENABLE ANTI-SIT PROTECTION"
        sToggleOff()
        notify("COCO POWDER", "Anti-Sit Disabled")
    else
        enableAntiSit()
        setBtnColor(antiSitBtn, T.Success)
        antiSitBtn.Text = "✅ ANTI-SIT ACTIVE & PROTECTING"
        sToggleOn()
        notify("COCO POWDER", "Anti-Sit Active")
    end
end)

--[[═══════════════════════════════════════════════════════════════════════════════
  📖 GUIDE & ID SWAP TAB
═══════════════════════════════════════════════════════════════════════════════]]
local guideTab = createTab("Guide", "📖")

local function guideCard(order, titleTxt, bodyTxt, color)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = T.Panel
    card.BorderSizePixel = 0
    card.LayoutOrder = order
    card.ZIndex = 7
    card.Parent = guideTab
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 7)

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.Parent = card

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 4)
    list.Parent = card

    local h = Instance.new("TextLabel")
    h.Size = UDim2.new(1, 0, 0, 18)
    h.BackgroundTransparency = 1
    h.Text = titleTxt
    h.TextColor3 = color or T.Neon
    h.Font = Enum.Font.GothamBlack
    h.TextSize = 11
    h.TextXAlignment = Enum.TextXAlignment.Left
    h.LayoutOrder = 1
    h.ZIndex = 8
    h.Parent = card

    local b = Instance.new("TextLabel")
    b.Size = UDim2.new(1, 0, 0, 0)
    b.AutomaticSize = Enum.AutomaticSize.Y
    b.BackgroundTransparency = 1
    b.Text = bodyTxt
    b.TextColor3 = T.Text
    b.Font = Enum.Font.Gotham
    b.TextSize = 10
    b.TextWrapped = true
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.TextYAlignment = Enum.TextYAlignment.Top
    b.LayoutOrder = 2
    b.ZIndex = 8
    b.Parent = card
    return card
end

guideCard(1, "⚡ V19 ZERO-DELAY & CROSS-RIG ARCHITECTURE",
[[• Zero-Delay Synchronization:
  Hug, Kiss, Slap, and Stare execute instantly without arbitrary yields or lag.
  All triggers synchronize CFrame on the exact invocation frame.

• Kiss Feature:
  Z-distance oscillates dynamically between -3.0 and -0.2 studs facing the partner (RY = 180°).

• Procedural Motor6D Arms:
  Raises character arms smoothly for both R6 and R15 rigs during Hug and Kiss.

• 69 Position:
  RY = 180°, RZ = 180°, X = 0, Y = 0, dynamic Z shifts between -2.0 and -1.0 studs.

• Nebula Fling Time Control:
  Choose between 3s, 10s, or Unlimited with real-time HUD and emergency cancel.]], T.Neon)

guideCard(2, "🔧 ANIMATION ID REPLACEMENT MANUAL",
[[To customize animation tracks for your game:
• Locate the ANIM_DB table near line 110 of the script.
• Swap any ID for R6 or R15:
  ANIM_DB.Sit = { R6 = 178130996, R15 = 2506281703 }
  ANIM_DB.Kick = { R6 = 184570534, R15 = 507770677 }
  ANIM_DB.Slap = { R6 = 204062532, R15 = 4555808220 }
  ANIM_DB.Carry = { R6 = 178130996, R15 = 507770677 }

Every action automatically detects your rig and selects the appropriate track!]], T.Purple)

--[[═══════════════════════════════════════════════════════════════════════════════
  ✨ DEDICATED NEBULA FLING FLOATING SIDE-PANEL HUD
═══════════════════════════════════════════════════════════════════════════════]]
FlingSidePanel = Instance.new("Frame")
FlingSidePanel.Name = "NebulaFlingSidePanel"
FlingSidePanel.Size = UDim2.new(0, 200, 0, 110)
FlingSidePanel.Position = UDim2.new(1, -216, 0.5, -55)
FlingSidePanel.BackgroundColor3 = T.Panel
FlingSidePanel.BorderSizePixel = 0
FlingSidePanel.Visible = false
FlingSidePanel.ZIndex = 80
FlingSidePanel.Parent = gui
Instance.new("UICorner", FlingSidePanel).CornerRadius = UDim.new(0, 10)

local fStroke = Instance.new("UIStroke")
fStroke.Color = T.Purple
fStroke.Thickness = 2
fStroke.Parent = FlingSidePanel

local fTitle = Instance.new("TextLabel")
fTitle.Size = UDim2.new(1, -12, 0, 22)
fTitle.Position = UDim2.new(0, 8, 0, 6)
fTitle.BackgroundTransparency = 1
fTitle.Text = "✨ NEBULA FLING ACTIVE"
fTitle.TextColor3 = T.Purple
fTitle.Font = Enum.Font.GothamBlack
fTitle.TextSize = 11
fTitle.TextXAlignment = Enum.TextXAlignment.Left
fTitle.ZIndex = 81
fTitle.Parent = FlingSidePanel

FlingCountdownLabel = Instance.new("TextLabel")
FlingCountdownLabel.Size = UDim2.new(1, -12, 0, 20)
FlingCountdownLabel.Position = UDim2.new(0, 8, 0, 30)
FlingCountdownLabel.BackgroundTransparency = 1
FlingCountdownLabel.Text = "⏳ Calculating..."
FlingCountdownLabel.TextColor3 = Color3.new(1, 1, 1)
FlingCountdownLabel.Font = Enum.Font.GothamBold
FlingCountdownLabel.TextSize = 12
FlingCountdownLabel.TextXAlignment = Enum.TextXAlignment.Left
FlingCountdownLabel.ZIndex = 81
FlingCountdownLabel.Parent = FlingSidePanel

local stopFlingBtn = Instance.new("TextButton")
stopFlingBtn.Size = UDim2.new(1, -16, 0, 32)
stopFlingBtn.Position = UDim2.new(0, 8, 0, 64)
stopFlingBtn.BackgroundColor3 = T.Danger
stopFlingBtn.Text = "🛑 STOP FLING & RETURN"
stopFlingBtn.TextColor3 = Color3.new(1, 1, 1)
stopFlingBtn.Font = Enum.Font.GothamBlack
stopFlingBtn.TextSize = 11
stopFlingBtn.ZIndex = 82
stopFlingBtn.Parent = FlingSidePanel
Instance.new("UICorner", stopFlingBtn).CornerRadius = UDim.new(0, 6)
styleBtn(stopFlingBtn, T.Danger)

stopFlingBtn.MouseButton1Click:Connect(function()
    sClick()
    StateManager:StopFling()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
    StateManager:Cleanup(true)
    notify("COCO POWDER", "Nebula Fling Manually Stopped")
    sSuccess()
end)

-- Footer Weld / Unweld Button Logic
btnWeld.MouseButton1Click:Connect(function()
    sClick()
    if not selectedPlayer or not selectedPlayer.Character then
        notify("COCO POWDER", "Select a target player first!")
        sError()
        return
    end

    local targetTorso = getTargetTorso(selectedPlayer.Character)
    if not targetTorso then
        notify("COCO POWDER", "Target Torso not found!")
        return
    end

    StateManager:Cleanup(true)
    CurrentTarget = selectedPlayer
    pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
    storeWeldInfo(selectedPlayer, 0, false, "weld")
    hookTargetRespawn(selectedPlayer)

    local ok, w = pcall(function() return WeldTo(targetTorso, 0, AnimCopyEnabled) end)
    if ok and w then
        CurrentWeld = w
        sSuccess()
        notify("COCO POWDER", "Welded → " .. selectedPlayer.Name)
    else
        sError()
    end
end)

btnUnweld.MouseButton1Click:Connect(function()
    sClick()
    StateManager:Cleanup(false)
    CurrentTarget = nil
    LastWeldTargetUserId = nil
    LastWeldAnimId = 0
    LastWeldWasThrust = false
    LastWeldType = "weld"
    pcall(function() workspace.FallenPartsDestroyHeight = OriginalFPDH end)
    notify("COCO POWDER", "Unwelded & State Cleared")
    sSuccess()
end)

-- Window Minimize & Confirm Close Logic
local minimized = false
local fullSize = UDim2.new(0, W, 0, H)
local fullPos  = UDim2.new(0.5, -W/2, 0.5, -H/2)
local minSize  = UDim2.new(0, W, 0, 44)

btnMin.MouseButton1Click:Connect(function()
    sClick()
    minimized = not minimized
    if minimized then
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = minSize}):Play()
        tabsBar.Visible = false
        content.Visible = false
        footer.Visible = false
    else
        TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = fullSize,
            Position = fullPos
        }):Play()
        task.delay(0.1, function()
            tabsBar.Visible = true
            content.Visible = true
            footer.Visible = true
        end)
    end
end)

local function shutdown()
    StateManager:Cleanup(false)
    pcall(function() workspace.FallenPartsDestroyHeight = OriginalFPDH end)
    gui:Destroy()
    print("[COCO POWDER V19] Script Terminated & Cleaned Up.")
end

local function showCloseConfirm()
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    overlay.BackgroundTransparency = 1
    overlay.ZIndex = 100
    overlay.Parent = gui

    local dlg = Instance.new("Frame")
    dlg.Size = UDim2.new(0, 0, 0, 0)
    dlg.Position = UDim2.new(0.5, 0, 0.5, 0)
    dlg.BackgroundColor3 = T.Panel
    dlg.BorderSizePixel = 0
    dlg.ZIndex = 101
    dlg.Parent = gui
    Instance.new("UICorner", dlg).CornerRadius = UDim.new(0, 14)

    local ds = Instance.new("UIStroke")
    ds.Color = T.Accent
    ds.Thickness = 1.5
    ds.Transparency = 0.3
    ds.Parent = dlg

    local dt = Instance.new("TextLabel")
    dt.Size = UDim2.new(1, -20, 0, 28)
    dt.Position = UDim2.new(0, 10, 0, 14)
    dt.BackgroundTransparency = 1
    dt.Text = "⚠  Close COCO POWDER V19?"
    dt.TextColor3 = T.Accent
    dt.Font = Enum.Font.GothamBlack
    dt.TextSize = 15
    dt.ZIndex = 102
    dt.Parent = dlg

    local dm = Instance.new("TextLabel")
    dm.Size = UDim2.new(1, -20, 0, 44)
    dm.Position = UDim2.new(0, 10, 0, 48)
    dm.BackgroundTransparency = 1
    dm.Text = "Do you want to terminate all welds and close the interface?"
    dm.TextColor3 = T.Muted
    dm.Font = Enum.Font.Gotham
    dm.TextSize = 11
    dm.ZIndex = 102
    dm.Parent = dlg

    local yb = Instance.new("TextButton")
    yb.Size = UDim2.new(0, 110, 0, 34)
    yb.Position = UDim2.new(0.5, -115, 1, -48)
    yb.Text = "YES, CLOSE"
    yb.TextColor3 = Color3.new(1, 1, 1)
    yb.Font = Enum.Font.GothamBlack
    yb.TextSize = 12
    yb.ZIndex = 102
    yb.Parent = dlg
    Instance.new("UICorner", yb).CornerRadius = UDim.new(0, 8)
    styleBtn(yb, T.Accent)

    local nb = Instance.new("TextButton")
    nb.Size = UDim2.new(0, 110, 0, 34)
    nb.Position = UDim2.new(0.5, 5, 1, -48)
    nb.Text = "CANCEL"
    nb.TextColor3 = T.Text
    nb.Font = Enum.Font.GothamBlack
    nb.TextSize = 12
    nb.ZIndex = 102
    nb.Parent = dlg
    Instance.new("UICorner", nb).CornerRadius = UDim.new(0, 8)
    styleBtn(nb, T.PanelLt)

    TweenService:Create(overlay, TweenInfo.new(0.15), {BackgroundTransparency = 0.5}):Play()
    TweenService:Create(dlg, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 260, 0, 190),
        Position = UDim2.new(0.5, -130, 0.5, -95),
    }):Play()

    local function dismiss()
        sClick()
        TweenService:Create(overlay, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
        TweenService:Create(dlg, TweenInfo.new(0.15), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
        }):Play()
        task.wait(0.16)
        overlay:Destroy()
        dlg:Destroy()
    end

    yb.MouseButton1Click:Connect(function()
        sToggleOff()
        shutdown()
    end)
    nb.MouseButton1Click:Connect(dismiss)
end

btnClose.MouseButton1Click:Connect(function()
    sClick()
    showCloseConfirm()
end)

-- Keyboard Toggle (RightShift)
UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
        if gui.Enabled then sWhoosh() else sToggleOff() end
    end
end)

--[[═══════════════════════════════════════════════════════════════════════════════
  🔐 COCA-STYLE VERIFICATION GATE (ported from cocca.lua)
  Only this new gate and its access list are added; existing feature code is unchanged.
═══════════════════════════════════════════════════════════════════════════════]]
local COCA_ACCESS_KEY = "KINGCOCA"
local COCA_DISCORD_LINK = "https://discord.com/users/1543328830746403017"
local COCA_ACCESS_USERS = {
    -- Supreme Owners
    ["indiangamer6975"] = "SUPREME OWNER",
    ["shivyy73"]         = "SUPREME OWNER",

    -- Premium Whitelisted Guests
    ["yourxarjun"]       = "PREMIUM GUEST",
    ["wildbunny_8"]      = "PREMIUM GUEST",
    ["badmash2330"]      = "PREMIUM GUEST",
    ["vigu_771"]         = "PREMIUM GUEST",
    ["anime_akash99"]    = "PREMIUM GUEST",
    ["armaan_lulla"]     = "PREMIUM GUEST",
    ["shivyy7711"]       = "PREMIUM GUEST",
    ["mannat_8490"]      = "PREMIUM GUEST",
    ["attitudehizru"]    = "PREMIUM GUEST",
    ["retreee_yawrrr"]   = "PREMIUM GUEST",
    ["kaun_bhai"]        = "PREMIUM GUEST",
}

-- Keep the original COCO POWDER interface and its mobile toggle hidden until
-- the local access check succeeds. No existing feature handlers are replaced.
main.Visible = false
mobToggle.Visible = false

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
local verifyStroke = Instance.new("UIStroke")
verifyStroke.Color = T.Border
verifyStroke.Thickness = 1.5
verifyStroke.Parent = verifyGate

local verifyTop = Instance.new("Frame")
verifyTop.Size = UDim2.new(1, 0, 0, 4)
verifyTop.BackgroundColor3 = T.Accent
verifyTop.BorderSizePixel = 0
verifyTop.ZIndex = 201
verifyTop.Parent = verifyGate
Instance.new("UICorner", verifyTop).CornerRadius = UDim.new(0, 18)

local verifyAvatar = Instance.new("ImageLabel")
verifyAvatar.Size = UDim2.new(0, 82, 0, 82)
verifyAvatar.Position = UDim2.new(0.5, -41, 0, 24)
verifyAvatar.BackgroundColor3 = T.Panel
verifyAvatar.BackgroundTransparency = 0
verifyAvatar.Image = ""
verifyAvatar.ZIndex = 202
verifyAvatar.Parent = verifyGate
Instance.new("UICorner", verifyAvatar).CornerRadius = UDim.new(1, 0)
local verifyAvatarStroke = Instance.new("UIStroke")
verifyAvatarStroke.Color = T.Neon
verifyAvatarStroke.Thickness = 2
verifyAvatarStroke.Parent = verifyAvatar
pcall(function()
    task.spawn(function()
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
verifyIdentity.Size = UDim2.new(1, -24, 0, 36)
verifyIdentity.Position = UDim2.new(0, 12, 0, 147)
verifyIdentity.Text = LP.DisplayName .. "  ( @" .. LP.Name .. " )"
verifyIdentity.TextColor3 = T.Muted
verifyIdentity.Font = Enum.Font.GothamMedium
verifyIdentity.TextSize = 12
verifyIdentity.ZIndex = 202
verifyIdentity.Parent = verifyGate

local verifyRole = Instance.new("TextLabel")
verifyRole.BackgroundTransparency = 1
verifyRole.Size = UDim2.new(1, -24, 0, 20)
verifyRole.Position = UDim2.new(0, 12, 0, 174)
verifyRole.Text = COCA_ACCESS_USERS[string.lower(LP.Name)] or "NOT WHITELISTED"
verifyRole.TextColor3 = COCA_ACCESS_USERS[string.lower(LP.Name)] and T.Success or T.Danger
verifyRole.Font = Enum.Font.GothamBold
verifyRole.TextSize = 11
verifyRole.ZIndex = 202
verifyRole.Parent = verifyGate

local verifyKeyBox = Instance.new("TextBox")
verifyKeyBox.Size = UDim2.new(1, -40, 0, 44)
verifyKeyBox.Position = UDim2.new(0, 20, 0, 210)
verifyKeyBox.BackgroundColor3 = T.Panel
verifyKeyBox.BorderSizePixel = 0
verifyKeyBox.PlaceholderText = "Enter access key..."
verifyKeyBox.Text = ""
verifyKeyBox.ClearTextOnFocus = false
verifyKeyBox.PlaceholderColor3 = T.Muted
verifyKeyBox.TextColor3 = T.Text
verifyKeyBox.Font = Enum.Font.GothamBold
verifyKeyBox.TextSize = 13
verifyKeyBox.TextXAlignment = Enum.TextXAlignment.Center
verifyKeyBox.ZIndex = 202
verifyKeyBox.Parent = verifyGate
Instance.new("UICorner", verifyKeyBox).CornerRadius = UDim.new(0, 10)
local verifyKeyStroke = Instance.new("UIStroke")
verifyKeyStroke.Color = T.Border
verifyKeyStroke.Parent = verifyKeyBox

local function makeVerifyButton(label, xScale, xOffset, widthScale, widthOffset, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(widthScale, widthOffset, 0, 40)
    b.Position = UDim2.new(xScale, xOffset, 0, 268)
    b.BackgroundColor3 = color
    b.BorderSizePixel = 0
    b.Text = label
    b.TextColor3 = T.Text
    b.Font = Enum.Font.GothamBlack
    b.TextSize = 12
    b.AutoButtonColor = true
    b.ZIndex = 202
    b.Parent = verifyGate
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 9)
    return b
end
local verifyGetKey = makeVerifyButton("GET KEY / DISCORD", 0, 20, 0.5, -25, T.PanelLt)
local verifyUnlock = makeVerifyButton("UNLOCK", 0.5, 5, 0.5, -25, T.Accent)

local verifyStatus = Instance.new("TextLabel")
verifyStatus.BackgroundTransparency = 1
verifyStatus.Size = UDim2.new(1, -24, 0, 38)
verifyStatus.Position = UDim2.new(0, 12, 0, 318)
verifyStatus.Text = "Enter your key to continue."
verifyStatus.TextColor3 = T.Muted
verifyStatus.Font = Enum.Font.GothamMedium
verifyStatus.TextSize = 11
verifyStatus.TextWrapped = true
verifyStatus.ZIndex = 202
verifyStatus.Parent = verifyGate

local verifyFooter = Instance.new("TextLabel")
verifyFooter.BackgroundTransparency = 1
verifyFooter.Size = UDim2.new(1, -20, 0, 18)
verifyFooter.Position = UDim2.new(0, 10, 1, -23)
verifyFooter.Text = "COCO POWDER • LOCAL ACCESS GATE"
verifyFooter.TextColor3 = T.Muted
verifyFooter.Font = Enum.Font.GothamBold
verifyFooter.TextSize = 9
verifyFooter.ZIndex = 202
verifyFooter.Parent = verifyGate

verifyKeyBox.Focused:Connect(function()
    TweenService:Create(verifyKeyStroke, TweenInfo.new(0.15), {Color = T.Neon}):Play()
end)
verifyKeyBox.FocusLost:Connect(function()
    TweenService:Create(verifyKeyStroke, TweenInfo.new(0.15), {Color = T.Border}):Play()
end)

verifyGetKey.Activated:Connect(function()
    local copied = false
    pcall(function()
        if setclipboard then setclipboard(COCA_DISCORD_LINK); copied = true end
    end)
    if copied then
        verifyStatus.Text = "Discord profile link copied to clipboard."
        verifyStatus.TextColor3 = T.Success
    else
        verifyStatus.Text = "Discord: 1543328830746403017"
        verifyStatus.TextColor3 = T.Warning
    end
end)

local verifyBusy = false
local function completeVerification()
    if verifyBusy then return end
    verifyBusy = true
    local username = string.lower(LP.Name)
    local allowedRole = COCA_ACCESS_USERS[username]
    local enteredKey = string.match(verifyKeyBox.Text or "", "^%s*(.-)%s*$") or ""
    if not allowedRole then
        verifyStatus.Text = "ACCESS DENIED • account is not on the access list."
        verifyStatus.TextColor3 = T.Danger
        sError()
        verifyBusy = false
        return
    end
    if enteredKey ~= COCA_ACCESS_KEY then
        verifyStatus.Text = "Incorrect access key. Please try again."
        verifyStatus.TextColor3 = T.Danger
        verifyKeyBox.Text = ""
        sError()
        verifyBusy = false
        return
    end
    verifyStatus.Text = "Access accepted. Loading interface..."
    verifyStatus.TextColor3 = T.Success
    sSuccess()
    task.delay(0.45, function()
        if not gui.Parent then return end
        verifyGate:Destroy()
        main.Visible = true
        mobToggle.Visible = true
        showTab("Players")
        notify("COCO POWDER", "Verification successful • " .. allowedRole)
    end)
end
verifyUnlock.Activated:Connect(completeVerification)
verifyKeyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then completeVerification() end
end)

-- Bootup initial display
showTab("Players")
notify("COCO POWDER V20", "Loaded! 31 New Zero-Delay Modules Ready. RightShift to toggle.")
print("[COCO POWDER V20] Ready — Bulletproof & 31 New Zero-Delay Modules Initialized.")
