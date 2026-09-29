--============================================================
-- COCA SCRIPT : V52 UNIVERSAL LUAU / EXECUTOR-STABLE / FULL FEATURES / DEEPHAT
-- Key: KINGCOCA | Roblox Luau | adaptive executor compatibility
--
-- This build uses Roblox APIs first and only uses optional executor
-- adapters when the host provides them. Unsupported adapters simply
-- fall back instead of crashing the whole script.
--============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local Stats = game:GetService("Stats")
local SoundService = game:GetService("SoundService")

--============================================================
-- UNIVERSAL HOST COMPATIBILITY LAYER
--============================================================
-- Different Roblox executors expose different optional helpers.  The core
-- script never depends on one specific executor.  These adapters probe for
-- commonly exposed helpers and fall back to normal Roblox APIs when absent.
local function optionalGlobal(name)
    local ok, value = pcall(function() return _G[name] end)
    if ok and value ~= nil then return value end

    local ok2, value2 = pcall(function()
        if type(getgenv) == "function" then
            local env = getgenv()
            return env and env[name]
        end
    end)
    if ok2 and value2 ~= nil then return value2 end
    return nil
end

local function getPreferredGuiParent(player)
    local gethuiFn = optionalGlobal("gethui")
    if type(gethuiFn) == "function" then
        local ok, hui = pcall(gethuiFn)
        if ok and hui and typeof(hui) == "Instance" then
            return hui
        end
    end

    local clonerefFn = optionalGlobal("cloneref")
    local coreGui
    pcall(function() coreGui = game:GetService("CoreGui") end)
    if coreGui and type(clonerefFn) == "function" then
        local ok, clone = pcall(clonerefFn, coreGui)
        if ok and clone then coreGui = clone end
    end

    if coreGui then
        local ok, usable = pcall(function()
            local probe = Instance.new("Folder")
            probe.Name = "__COCA_GUI_PROBE"
            probe.Parent = coreGui
            local parentWorked = probe.Parent ~= nil
            probe:Destroy()
            return parentWorked
        end)
        if ok and usable then return coreGui end
    end

    local pg = player and player:FindFirstChildOfClass("PlayerGui")
    if pg then return pg end
    return player:WaitForChild("PlayerGui")
end

local function universalRequest(options)
    local candidates = {
        optionalGlobal("request"),
        optionalGlobal("http_request"),
        optionalGlobal("httprequest"),
    }

    local synTable = optionalGlobal("syn")
    if type(synTable) == "table" and type(synTable.request) == "function" then
        candidates[#candidates + 1] = synTable.request
    end

    for _, fn in ipairs(candidates) do
        if type(fn) == "function" then
            local ok, result = pcall(fn, options)
            if ok and result then return true, result end
        end
    end

    return false, nil
end

local LP = Players.LocalPlayer

local EXECUTOR = {
    Name = "Roblox",
    HasGUI = false,
    HasHTTP = false,
    HasGetConnections = false,
    HasClipboard = false,
    HasQueueTeleport = false,
}

local function detectExecutor()
    local identify = optionalGlobal("identifyexecutor")
    if type(identify) == "function" then
        pcall(function()
            local a, b = identify()
            EXECUTOR.Name = tostring(a or b or "Executor")
        end)
    end
    if EXECUTOR.Name == "Roblox" then
        local getName = optionalGlobal("getexecutorname")
        if type(getName) == "function" then
            pcall(function() EXECUTOR.Name = tostring(getName()) end)
        end
    end
    EXECUTOR.HasHTTP = type(optionalGlobal("request")) == "function"
        or type(optionalGlobal("http_request")) == "function"
        or type(optionalGlobal("httprequest")) == "function"
    EXECUTOR.HasGetConnections = type(optionalGlobal("getconnections")) == "function"
    EXECUTOR.HasClipboard = type(optionalGlobal("setclipboard")) == "function"
        or type(optionalGlobal("toclipboard")) == "function"
    EXECUTOR.HasQueueTeleport = type(optionalGlobal("queue_on_teleport")) == "function"
        or type(optionalGlobal("queueonteleport")) == "function"
end

detectExecutor()

--============================================================
-- 🔒 SUPREME ACCESS WHITELIST
--============================================================
local VIP_USERNAMES = {
	["shivyy73"] = { role = "SUPREME OWNER", icon = "♛", tier = 3 },
	["armaan_lulla"] = { role = "PREMIUM GUEST", icon = "✦", tier = 2 },
	["shivyy7711"] = { role = "PREMIUM GUEST", icon = "✦", tier = 2 },
	["mannat_8490"] = { role = "PREMIUM GUEST", icon = "✦", tier = 2 },
	["attitudehizru"] = { role = "PREMIUM GUEST", icon = "✦", tier = 2 },
}

--============================================================
-- GLOBAL STATE
--============================================================

local ACCESS_KEY = "KINGCOCA"
local DISCORD_WEB_LINK = "https://discord.com/users/1543328830746403017"

local State = {
	Unlocked = false,
	Target = nil, 
	TargetESP = true,
	PingComp = 35,
	WhitelistedPlayers = {}, 
	Moves = {
        Running = false, Mode = "Facebang", Distance = 1.2, Speed = 40,
        AutoAcquire = true, TargetLostAt = nil, LastAutoAcquire = 0
    },
	Chat = { Running = false, Count = 0, Delay = 1.5, Message = "" },
	Anim = { TrackSync = false, Follow = false, Distance = 3.0, Side = "Right" },
	Movement = { SpeedEnabled = false, WalkSpeed = 50, FlyEnabled = false, FlySpeed = 100, Noclip = false, InfJump = false },
	Safety = { AntiVoid = false, AntiAFK = false, SafeCFrame = nil },
	Emotes = { Track = nil, Pack = nil, OriginalAnimate = nil },
	Filling = { Running = false, AutoRejoin = false, RejoinUserId = nil },
	Performance = { Visible = true, Hud = true },
	Badges = { ShowRoleBadges = true },
	Reverse = { Recording = false, Playing = false, Loop = false, MaxSeconds = 30, SampleRate = 0.05, Buffer = {}, LastSample = 0 },
	QuickBar = {
        Enabled = true,
        Modes = {
            Pat = true,
            Headsit = true,
            Facebang = true,
            Hipbang = false,
            ["Close Contact"] = false,
            Orbit = false,
            Mount = false,
            Tornado = false,
            Fling = false,
            ["Void Send"] = false,
            Stomp = false,
            Spin = false,
            Attach = false,
            Glitch = false,
        }
    },
	Pat = {
        Speed = 12,
        TorsoBob = 0.3,
        HipSway = 0.4,
        HeadJitter = 0.2,
        Smoothness = 0.15,
        SwaySpeed = 1.0,
        HeadBobSpeed = 2.0,
        HeadBobAngle = 0.2,
        Intensity = 1.0,
        EngineState = "PatTroll"
    }
}

local Internal = { ApplyTarget = nil, StopMoves = nil, RefreshTargets = nil, RefreshImmunityList = nil, TargetUserId = nil }
local flyVelocity = Vector3.zero 
local selectedEmoteBtn = nil

-- Forward declarations: the reverse recorder is connected before the core
-- helpers are assigned later in the file. Without these locals, some Luau
-- hosts resolve hum/root as globals and the Heartbeat recorder errors.
local hum, root, getCharacter

--============================================================
-- 30-SECOND AUTOMATIC REVERSE MEMORY
-- Continuously keeps the most recent 30 seconds of local movement.
-- The user does not need to start/stop recording manually.
--============================================================
local reversePlaybackConn = nil

local function reverseStopPlayback()
    State.Reverse.Playing = false
    if reversePlaybackConn then reversePlaybackConn:Disconnect(); reversePlaybackConn = nil end
    local char = LP.Character
    local h = char and hum(char)
    if h then h.AutoRotate = true end
end

local function reverseClear()
    reverseStopPlayback()
    State.Reverse.Buffer = {}
    State.Reverse.LastSample = 0
end

local function reverseRecordStep()
    if State.Reverse.Playing then return end
    local now = os.clock()
    if now - State.Reverse.LastSample < State.Reverse.SampleRate then return end
    State.Reverse.LastSample = now
    local char = LP.Character
    local rp = char and root(char)
    if not rp then return end

    local buffer = State.Reverse.Buffer
    buffer[#buffer + 1] = {
        t = now,
        cf = rp.CFrame,
        lv = rp.AssemblyLinearVelocity,
        av = rp.AssemblyAngularVelocity
    }

    local maxSamples = math.floor(State.Reverse.MaxSeconds / State.Reverse.SampleRate) + 1
    while #buffer > maxSamples do
        table.remove(buffer, 1)
    end
end

local function reversePlayOnce()
    local buffer = State.Reverse.Buffer
    if #buffer < 2 then
        Notify("REVERSE", "Not enough movement history yet.", DANGER)
        return
    end

    if State.Reverse.Playing then
        reverseStopPlayback()
        return
    end

    State.Reverse.Playing = true
    local index = #buffer
    local accumulator = 0
    local char = LP.Character
    local h = char and hum(char)
    if h then h.AutoRotate = false end

    reversePlaybackConn = RunService.RenderStepped:Connect(function(dt)
        if not State.Reverse.Playing then return end
        local current = LP.Character
        local rp = current and root(current)
        if not rp then
            reverseStopPlayback()
            return
        end

        accumulator += dt
        local step = math.max(State.Reverse.SampleRate, 0.01)
        while accumulator >= step do
            accumulator -= step
            index -= 1
        end

        if index < 1 then
            if State.Reverse.Loop and #buffer >= 2 then
                index = #buffer
                accumulator = 0
            else
                reverseStopPlayback()
                Notify("REVERSE", "Movement history replay finished.", SUCCESS)
                return
            end
        end

        local sample = buffer[index]
        if sample then
            rp.CFrame = sample.cf
            rp.AssemblyLinearVelocity = sample.lv
            rp.AssemblyAngularVelocity = sample.av
        end
    end)
end

-- Always-on rolling recorder: the latest 30 seconds are available automatically.
local reverseConn = RunService.Heartbeat:Connect(reverseRecordStep)

LP.CharacterAdded:Connect(function()
    reverseStopPlayback()
    State.Reverse.Buffer = {}
    State.Reverse.LastSample = 0
end)

--============================================================
-- ANTI-TRIP / ANTI-RAGDOLL ENGINE
--============================================================
local function killFall(c)
	local h = c:WaitForChild("Humanoid", 5)
	if h then 
		pcall(function() 
			h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false) 
		end) 
	end
end
killFall(LP.Character or LP.CharacterAdded:Wait())
LP.CharacterAdded:Connect(killFall)

--============================================================
-- AUDIO ENGINE
--============================================================

local SOUNDS = { Hover = "6895086153", Click = "6042053626", Success = "2865228021", Error = "6895049798", Notif = "4522604085" }

local function playSound(id, vol, pitch)
	task.spawn(function()
		local s = Instance.new("Sound")
		s.SoundId = "rbxassetid://" .. id
		s.Volume = vol or 0.5
		s.Pitch = pitch or 1.0
		s.Parent = SoundService
		s:Play()
		s.Ended:Wait()
		s:Destroy()
	end)
end

--============================================================
-- UI STYLING & THEMING
--============================================================

local BG_MAIN = Color3.fromRGB(12, 12, 16)      
local BG_FLYOUT = Color3.fromRGB(18, 18, 22)    
local BG_ELEMENT = Color3.fromRGB(28, 28, 34)   
local BG_HOVER = Color3.fromRGB(40, 40, 48)     

local TEXT_MAIN = Color3.fromRGB(250, 250, 250)
local TEXT_SUB = Color3.fromRGB(140, 140, 150)
local ACCENT = Color3.fromRGB(255, 255, 255)
local RADIO_OFF = Color3.fromRGB(50, 50, 60)

local GRAD_1 = Color3.fromRGB(255, 42, 85)
local GRAD_2 = Color3.fromRGB(140, 20, 252)
local SUCCESS = Color3.fromRGB(10, 230, 120)
local DANGER = Color3.fromRGB(255, 55, 75)
local YELLOW = Color3.fromRGB(255, 195, 40)

local function tween(obj, props, duration, style)
	local t = TweenService:Create(obj, TweenInfo.new(duration or 0.25, style or Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), props)
	t:Play()
	return t
end

local function createShadow(parent, radius, opacity, yOffset)
	local shadow = Instance.new("ImageLabel")
	shadow.Name = "DropShadow"
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.Position = UDim2.new(0.5, 0, 0.5, yOffset or 4)
	shadow.Size = UDim2.new(1, radius or 30, 1, radius or 30)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://6015897843"
	shadow.ImageColor3 = Color3.new(0, 0, 0)
	shadow.ImageTransparency = opacity or 0.4
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(49, 49, 450, 450)
	shadow.ZIndex = parent.ZIndex - 1
	shadow.Parent = parent
	return shadow
end

local function applyGradient(obj) 
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, GRAD_1), ColorSequenceKeypoint.new(1, GRAD_2)})
	g.Rotation = 45
	g.Parent = obj
	return g 
end

--============================================================
-- UNIVERSAL GUI PARENTING & HIGHLIGHTS
--============================================================

-- Prefer an executor's protected GUI container when available, then CoreGui,
-- then PlayerGui. This lets the same source run in different Luau hosts.
local targetGuiParent = getPreferredGuiParent(LP)

local oldGui = targetGuiParent:FindFirstChild("COCA_Capsule_V50") or targetGuiParent:FindFirstChild("COCA_Capsule_V49") or targetGuiParent:FindFirstChild("COCA_Capsule_V48") or targetGuiParent:FindFirstChild("COCA_Capsule_V47") or targetGuiParent:FindFirstChild("COCA_Capsule_V44") or targetGuiParent:FindFirstChild("COCA_Capsule_V42")
if oldGui then oldGui:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "COCA_Capsule_V50"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999999
gui.Enabled = true
gui.Parent = targetGuiParent

local targetESP = Instance.new("Highlight")
targetESP.Name = "COCA_ESP"
targetESP.FillColor = GRAD_1
targetESP.OutlineColor = GRAD_2
targetESP.FillTransparency = 0.75
targetESP.OutlineTransparency = 0.1
targetESP.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
targetESP.Parent = targetGuiParent

local function updateESP(targetInstance)
	if targetInstance and State.TargetESP then 
		targetESP.Adornee = targetInstance
		targetESP.Enabled = true 
	else 
		targetESP.Adornee = nil
		targetESP.Enabled = false 
	end
end

--============================================================
-- NOTIFICATION ENGINE
--============================================================

local notifContainer = Instance.new("Frame")
notifContainer.Name = "NotifContainer"
notifContainer.Size = UDim2.new(0, 240, 1, -20)
notifContainer.Position = UDim2.new(1, -260, 0, 10)
notifContainer.BackgroundTransparency = 1
notifContainer.ZIndex = 100
notifContainer.Parent = gui

local notifLayout = Instance.new("UIListLayout")
notifLayout.Padding = UDim.new(0, 10)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.Parent = notifContainer

local function Notify(title, message, color)
	playSound(SOUNDS.Notif, 0.4, 1.2)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 40, 0, 50)
	card.BackgroundColor3 = BG_ELEMENT
	card.BackgroundTransparency = 1
	card.Parent = notifContainer
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
	local stroke = Instance.new("UIStroke", card)
	stroke.Color = Color3.fromRGB(45, 45, 55)
	stroke.Transparency = 1
	
	local ind = Instance.new("Frame")
	ind.Size = UDim2.new(0, 4, 1, -16)
	ind.Position = UDim2.new(0, 8, 0, 8)
	ind.BackgroundColor3 = color or ACCENT
	ind.BackgroundTransparency = 1
	ind.Parent = card
	Instance.new("UICorner", ind).CornerRadius = UDim.new(1, 0)
	
	local lblTitle = Instance.new("TextLabel")
	lblTitle.BackgroundTransparency = 1
	lblTitle.Text = title
	lblTitle.TextSize = 12
	lblTitle.TextColor3 = TEXT_MAIN
	lblTitle.TextTransparency = 1
	lblTitle.Font = Enum.Font.GothamBold
	lblTitle.Size = UDim2.new(1, -25, 0, 16)
	lblTitle.Position = UDim2.new(0, 20, 0, 8)
	lblTitle.TextXAlignment = Enum.TextXAlignment.Left
	lblTitle.Parent = card
	
	local lblMsg = Instance.new("TextLabel")
	lblMsg.BackgroundTransparency = 1
	lblMsg.Text = message
	lblMsg.TextSize = 11
	lblMsg.TextColor3 = TEXT_SUB
	lblMsg.TextTransparency = 1
	lblMsg.Font = Enum.Font.Gotham
	lblMsg.Size = UDim2.new(1, -25, 0, 16)
	lblMsg.Position = UDim2.new(0, 20, 0, 24)
	lblMsg.TextXAlignment = Enum.TextXAlignment.Left
	lblMsg.Parent = card
	
	tween(card, {Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 0}, 0.3)
	tween(stroke, {Transparency = 0}, 0.3)
	tween(ind, {BackgroundTransparency = 0}, 0.3)
	tween(lblTitle, {TextTransparency = 0}, 0.3)
	tween(lblMsg, {TextTransparency = 0}, 0.3)
	
	task.delay(2.5, function()
		tween(card, {Size = UDim2.new(1, 40, 0, 50), BackgroundTransparency = 1}, 0.3)
		tween(stroke, {Transparency = 1}, 0.3)
		tween(ind, {BackgroundTransparency = 1}, 0.3)
		tween(lblTitle, {TextTransparency = 1}, 0.3)
		tween(lblMsg, {TextTransparency = 1}, 0.3)
		task.wait(0.3)
		card:Destroy()
	end)
end

--============================================================
-- CORE MATHEMATICAL & ENGINE UTILITIES
--============================================================

hum = function(model) return model and model:FindFirstChildOfClass("Humanoid") end
root = function(model)
    if not model then return nil end
    return model:FindFirstChild("HumanoidRootPart")
        or model.PrimaryPart
        or model:FindFirstChild("UpperTorso")
        or model:FindFirstChild("Torso")
end
getCharacter = function() return LP.Character or LP.CharacterAdded:Wait() end

local function flatCF(cf) 
	local _, y, _ = cf:ToOrientation()
	return CFrame.new(cf.Position) * CFrame.Angles(0, y, 0) 
end

local function resolveCharacterRoot(model)
    if not model or not model.Parent then return nil end
    local h = hum(model)
    if not h or h.Health <= 0 then return nil end
    local r = model:FindFirstChild("HumanoidRootPart")
        or model.PrimaryPart
        or model:FindFirstChild("UpperTorso")
        or model:FindFirstChild("Torso")
    if r and r:IsA("BasePart") then return r end
    return nil
end

local function getTargetChar()
    local target = State.Target
    if not target then return nil end

    if target.kind == "PLAYER" then
        local p = target.player
        if not p or not p.Parent then return nil end

        local char = p.Character
        if not char then return nil end

        local r = resolveCharacterRoot(char)
        if r then
            target.instance = char
            return char
        end
        return nil
    end

    if target.kind == "NPC" then
        local m = target.instance
        if m and m.Parent and resolveCharacterRoot(m) then
            return m
        end
    end

    return nil
end

local function getTargetRoot()
    local tc = getTargetChar()
    return tc and resolveCharacterRoot(tc)
end

-- IMPORTANT: declare this before getTargets. The previous build referenced
-- isProtectedPlayer before its local declaration, which made Lua resolve it
-- as a nil global and stopped the entire server roster from being created.
local function isSupremeOwner(player)
	if not player then return false end
	local role = VIP_USERNAMES[string.lower(player.Name)]
	return role and role.tier == 3 or false
end

local function isProtectedPlayer(player)
	if not player then return false end
	local name = string.lower(player.Name)
	-- Premium Guests keep their role badge but remain valid troll targets.
	-- Only the Supreme Owner and manually added whitelist entries are immune.
	return isSupremeOwner(player) or State.WhitelistedPlayers[name] == true
end

local function getTargets()
	local result = {}
	local seenPlayers = {}
	local seenNPCs = {}

	-- Server player roster is collected first and independently.
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LP then
			local key = tostring(player.UserId)
			if not seenPlayers[key] then
				table.insert(result, {
					kind = "PLAYER",
					player = player,
					instance = player.Character,
					name = player.DisplayName ~= "" and player.DisplayName or player.Name,
					username = player.Name,
					protected = isProtectedPlayer(player)
				})
				seenPlayers[key] = true
			end
		end
	end

	-- Preserve NPC support, but an NPC scan failure must never hide players.
	pcall(function()
		for _, object in ipairs(workspace:GetDescendants()) do
			if object:IsA("Model")
				and object ~= LP.Character
				and not Players:GetPlayerFromCharacter(object)
				and hum(object)
				and root(object) then
				local key = object:GetDebugId()
				if not seenNPCs[key] then
					table.insert(result, {
						kind = "NPC",
						instance = object,
						player = nil,
						name = object.Name,
						username = "NPC"
					})
					seenNPCs[key] = true
				end
			end
		end
	end)

	table.sort(result, function(a, b)
		if a.kind ~= b.kind then return a.kind == "PLAYER" end
		return string.lower(a.name) < string.lower(b.name)
	end)
	return result
end

--============================================================
-- AUTOMATIC NEAREST-TARGET ACQUISITION
--============================================================
local nearestNpcCache = { stamp = 0, list = {} }

local function getAutoTargetCandidates()
    local list = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and not isProtectedPlayer(player) then
            local char = player.Character
            if resolveCharacterRoot(char) then
                list[#list + 1] = {
                    kind = "PLAYER",
                    player = player,
                    instance = char,
                    name = player.DisplayName ~= "" and player.DisplayName or player.Name,
                    username = player.Name,
                    protected = false
                }
            end
        end
    end

    -- NPC discovery is deliberately cached because Workspace:GetDescendants()
    -- every frame would reintroduce the delay this build is designed to remove.
    local now = os.clock()
    if now - nearestNpcCache.stamp > 1.0 then
        nearestNpcCache.stamp = now
        nearestNpcCache.list = {}
        pcall(function()
            for _, object in ipairs(workspace:GetDescendants()) do
                if object:IsA("Model")
                    and object ~= LP.Character
                    and not Players:GetPlayerFromCharacter(object)
                    and hum(object)
                    and resolveCharacterRoot(object) then
                    nearestNpcCache.list[#nearestNpcCache.list + 1] = {
                        kind = "NPC",
                        instance = object,
                        name = object.Name,
                        username = "NPC"
                    }
                end
            end
        end)
    end

    for _, npc in ipairs(nearestNpcCache.list) do
        local live = npc.instance
        if live and live.Parent and resolveCharacterRoot(live) then
            list[#list + 1] = npc
        end
    end
    return list
end

local function findNearestValidTarget()
    local myChar = LP.Character
    local myRoot = resolveCharacterRoot(myChar)
    if not myRoot then return nil, math.huge end

    local nearest, nearestDistance = nil, math.huge
    for _, candidate in ipairs(getAutoTargetCandidates()) do
        local char = candidate.kind == "PLAYER" and candidate.player and candidate.player.Character or candidate.instance
        local targetRoot = resolveCharacterRoot(char)
        if targetRoot then
            local distance = (myRoot.Position - targetRoot.Position).Magnitude
            if distance < nearestDistance then
                nearest = candidate
                nearestDistance = distance
            end
        end
    end
    return nearest, nearestDistance
end

local function shouldAutoAcquire()
    return State.Moves.Running and State.Moves.AutoAcquire == true
end

local function targetNeedsAutoAcquire()
    if not State.Target then return true end
    return getTargetChar() == nil
end

local function targetAcquireCooldownReady()
    local now = os.clock()
    if now - (State.Moves.LastAutoAcquire or 0) < 0.35 then return false end
    State.Moves.LastAutoAcquire = now
    return true
end

local function autoAcquireNearestTarget(notifyUser)
    if not shouldAutoAcquire() or not targetAcquireCooldownReady() then return false end
    local candidate, distance = findNearestValidTarget()
    if not candidate then return false end

    if Internal.ApplyTarget then
        Internal.ApplyTarget(candidate)
        if notifyUser then
            Notify("AUTO TARGET", "Nearest target: " .. candidate.name .. " (" .. math.floor(distance + 0.5) .. " studs)", SUCCESS)
        end
        return true
    end
    return false
end

local function targetMatches(target, query)
	query = string.lower(query or "")
	if query == "" then return true end
	return string.find(string.lower(target.name), query, 1, true) ~= nil or string.find(string.lower(target.username), query, 1, true) ~= nil
end

local function getVIPRole(username)
	local data = VIP_USERNAMES[string.lower(username or "")]
	return data and data.role or nil
end

local function getExecutorName()
    -- Optional executor identification. Never required by the core script.
    local probes = {
        optionalGlobal("identifyexecutor"),
        optionalGlobal("getexecutorname"),
    }
    local synTable = optionalGlobal("syn")
    if type(synTable) == "table" and type(synTable.get_executor_name) == "function" then
        probes[#probes + 1] = synTable.get_executor_name
    end
    for _, probe in ipairs(probes) do
        if type(probe) == "function" then
            local ok, value = pcall(probe)
            if ok and value and tostring(value) ~= "" then
                return tostring(value)
            end
        end
    end
    return "Roblox / LocalScript"
end

local function getPingMs()
	local ok, value = pcall(function()
		local network = Stats:FindFirstChild("Network")
		local serverStats = network and network:FindFirstChild("ServerStatsItem")
		local item = serverStats and (serverStats:FindFirstChild("Data Ping") or serverStats:FindFirstChild("Ping"))
		if item and item.GetValue then return tonumber(item:GetValue()) end
		return nil
	end)
	if ok and value then return math.max(0, math.floor(value + 0.5)) end
	return nil
end

--============================================================
-- PROCEDURAL PAT CONTROLLER
-- Based on the supplied DeepHat Pat references.
-- One managed controller is used so multiple Heartbeat loops never fight
-- over the same R15 Motor6Ds.
--============================================================

local PatMotion = {
    Character = nil,
    Waist = nil,
    Neck = nil,
    OriginalWaistC0 = nil,
    OriginalNeckC0 = nil,
    Time = 0,
    State = "Idle"
}

-- Unified procedural animation state manager.
-- This incorporates the useful part of the supplied Animation Manager:
-- one connection/state owner, stable original C0 baselines, and explicit
-- state switching. It deliberately avoids the source's cumulative-C0 drift.
function PatMotion:Stop()
    if self.Waist and self.OriginalWaistC0 then
        pcall(function() self.Waist.C0 = self.OriginalWaistC0 end)
    end
    if self.Neck and self.OriginalNeckC0 then
        pcall(function() self.Neck.C0 = self.OriginalNeckC0 end)
    end
    self.Character = nil
    self.Waist = nil
    self.Neck = nil
    self.OriginalWaistC0 = nil
    self.OriginalNeckC0 = nil
    self.Time = 0
    self.State = "Idle"
end

function PatMotion:Begin(character)
    if self.Character == character and self.Waist and self.Neck
        and self.Waist.Parent and self.Neck.Parent then
        return true
    end

    self:Stop()
    if not character then return false end

    local humanoid = hum(character)
    local waist = character:FindFirstChild("Waist", true)
    local neck = character:FindFirstChild("Neck", true)

    if not humanoid or humanoid.Health <= 0 or not waist or not neck then
        return false
    end
    if not waist:IsA("Motor6D") or not neck:IsA("Motor6D") then
        return false
    end

    self.Character = character
    self.Waist = waist
    self.Neck = neck
    self.OriginalWaistC0 = waist.C0
    self.OriginalNeckC0 = neck.C0
    self.Time = 0
    return true
end

function PatMotion:SetState(character, stateName)
    stateName = stateName or "Idle"
    if stateName == "Idle" then
        self:Stop()
        return true
    end

    if not self:Begin(character) then
        return false
    end

    if self.State ~= stateName then
        -- Preserve the original C0 baseline when switching states.
        if self.OriginalWaistC0 then self.Waist.C0 = self.OriginalWaistC0 end
        if self.OriginalNeckC0 then self.Neck.C0 = self.OriginalNeckC0 end
        self.Time = 0
        self.State = stateName
    end
    return true
end

function PatMotion:IsActive()
    return self.Character ~= nil
        and self.Waist ~= nil and self.Neck ~= nil
        and self.Waist.Parent ~= nil and self.Neck.Parent ~= nil
end

function PatMotion:Update(character, dt, stateName)
    if stateName then
        if not self:SetState(character, stateName) then return false end
    elseif not self:Begin(character) then
        return false
    end

    local humanoid = hum(character)
    if not humanoid or humanoid.Health <= 0 then
        self:Stop()
        return false
    end

    local settings = State.Pat
    local intensity = math.clamp(tonumber(settings.Intensity) or 1, 0, 3)
    local swaySpeed = math.max(tonumber(settings.SwaySpeed) or 1, 0.05)
    local headBobSpeed = math.max(tonumber(settings.HeadBobSpeed) or 2, 0.05)
    local headBobAngle = tonumber(settings.HeadBobAngle) or 0.2
    self.Time += math.max(dt or 0, 0) * math.max(settings.Speed, 0.1) * swaySpeed

    if self.State == "PatTroll" then
        local pulse = math.sin(self.Time)
        local jitter = math.cos(self.Time * 1.5)
        local targetWaistCFrame = self.OriginalWaistC0
            * CFrame.Angles(
                pulse * settings.TorsoBob * intensity,
                jitter * headBobAngle * intensity,
                -pulse * settings.HipSway * intensity
            )
            * CFrame.new(0, math.sin(self.Time * 0.5) * 0.1 * intensity, 0)
        local targetNeckCFrame = self.OriginalNeckC0
            * CFrame.Angles(
                math.sin(self.Time * headBobSpeed) * settings.HeadJitter * intensity,
                math.cos(self.Time * headBobSpeed * 0.6) * settings.HeadJitter * intensity,
                math.sin(self.Time * headBobSpeed * 0.75) * settings.HeadJitter * 0.5 * intensity
            )
        local alpha = math.clamp(settings.Smoothness, 0.01, 1)
        self.Waist.C0 = self.Waist.C0:Lerp(targetWaistCFrame, alpha)
        self.Neck.C0 = self.Neck.C0:Lerp(targetNeckCFrame, alpha)
        return true
    elseif self.State == "EmoteTroll" then
        -- Optional chaotic non-explicit procedural state from the supplied
        -- manager. It uses the saved C0 baseline, so it cannot accumulate drift.
        local chaos = math.clamp(settings.TorsoBob, 0, 1) * 0.5 * intensity
        local targetWaistCFrame = self.OriginalWaistC0
            * CFrame.Angles(
                math.noise(self.Time, 0, 0) * chaos,
                math.noise(0, self.Time, 0) * chaos,
                math.noise(0, 0, self.Time) * chaos
            )
        local targetNeckCFrame = self.OriginalNeckC0
            * CFrame.Angles(
                math.sin(self.Time * 10) * settings.HeadJitter * 0.2 * intensity + math.sin(self.Time * headBobSpeed) * headBobAngle * 0.25 * intensity,
                math.cos(self.Time * 10) * settings.HeadJitter * 0.2 * intensity,
                0
            )
        local alpha = math.clamp(settings.Smoothness * 0.7, 0.01, 1)
        self.Waist.C0 = self.Waist.C0:Lerp(targetWaistCFrame, alpha)
        self.Neck.C0 = self.Neck.C0:Lerp(targetNeckCFrame, alpha)
        return true
    end

    return false
end

LP.CharacterAdded:Connect(function()
    PatMotion:Stop()
    State.Moves.TargetLostAt = nil
    State.Moves.LastAutoAcquire = 0
end)

--============================================================
-- ANIMATION RUNTIME CONTROLLER
--============================================================

local function getAnimator(char)
	local h = hum(char)
	if not h then return nil end
	local anim = h:FindFirstChildOfClass("Animator")
	if not anim then
		anim = Instance.new("Animator")
		anim.Parent = h
	end
	return anim
end

local function clearAllEmoteTracks()
	local char = LP.Character
	if not char then return end
	local animator = getAnimator(char)
	if animator then
		for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
			if track.Priority == Enum.AnimationPriority.Action or track.Priority == Enum.AnimationPriority.Action4 then
				pcall(function() track:Stop(0.05); track:Destroy() end)
			end
		end
	end
	if State.Emotes.Track then
		pcall(function() State.Emotes.Track:Stop(0.05); State.Emotes.Track:Destroy() end)
		State.Emotes.Track = nil
	end
end

--============================================================
-- GUI ARCHITECTURE
--============================================================

local wrapper = Instance.new("Frame")
wrapper.Name = "Wrapper"
wrapper.Size = UDim2.new(0, 260, 0, 520)
wrapper.Position = UDim2.new(1, -300, 0.5, -260)
wrapper.BackgroundTransparency = 1
wrapper.Visible = true
wrapper.Parent = gui

local capsule = Instance.new("Frame")
capsule.Name = "Capsule"
capsule.Size = UDim2.new(0, 60, 1, 0)
capsule.Position = UDim2.new(1, -60, 0, 0)
capsule.BackgroundColor3 = BG_MAIN
capsule.BorderSizePixel = 0
capsule.ZIndex = 10
capsule.Parent = wrapper
Instance.new("UICorner", capsule).CornerRadius = UDim.new(0, 30)
local cStroke = Instance.new("UIStroke", capsule)
cStroke.Color = Color3.fromRGB(45, 45, 55)
cStroke.Thickness = 1.5

local navContainer = Instance.new("Frame")
navContainer.Size = UDim2.new(1, 0, 1, -70)
navContainer.BackgroundTransparency = 1
navContainer.Parent = capsule

local minContainer = Instance.new("Frame")
minContainer.Size = UDim2.new(1, 0, 0, 60)
minContainer.Position = UDim2.new(0, 0, 1, -60)
minContainer.BackgroundTransparency = 1
minContainer.Parent = capsule

local flyout = Instance.new("Frame")
flyout.Name = "Flyout"
flyout.Size = UDim2.new(0, 0, 1, -40)
flyout.Position = UDim2.new(1, -60, 0, 20)
flyout.BackgroundColor3 = BG_FLYOUT
flyout.BorderSizePixel = 0
flyout.ClipsDescendants = true
flyout.ZIndex = 1
flyout.Parent = wrapper
Instance.new("UICorner", flyout).CornerRadius = UDim.new(0, 20)
local fStroke = Instance.new("UIStroke", flyout)
fStroke.Color = Color3.fromRGB(45, 45, 55)
fStroke.Thickness = 1.5

local fadeOverlay = Instance.new("Frame")
fadeOverlay.Size = UDim2.new(1, 0, 1, 0)
fadeOverlay.BackgroundColor3 = BG_FLYOUT
fadeOverlay.BackgroundTransparency = 1
fadeOverlay.ZIndex = 9
fadeOverlay.Parent = flyout
Instance.new("UICorner", fadeOverlay).CornerRadius = UDim.new(0, 20)

local tabs = {}
local activeTab = nil

local function createTab()
	local frame = Instance.new("ScrollingFrame")
	frame.Size = UDim2.new(1, -20, 1, -20)
	frame.Position = UDim2.new(0, 10, 0, 10)
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.ScrollBarThickness = 2
	frame.ScrollBarImageColor3 = GRAD_2
	frame.ScrollingDirection = Enum.ScrollingDirection.Y
	frame.Visible = false
	frame.ZIndex = 2
	frame.Parent = flyout
	
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 10)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = frame
	
	local pad = Instance.new("UIPadding", frame)
	pad.PaddingBottom = UDim.new(0, 20)
	
	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() 
		frame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20) 
	end)
	return frame
end

tabs.Target = createTab()
tabs.Moves = createTab()
tabs.Chat = createTab()
tabs.Anim = createTab()
tabs.Emotes = createTab()
tabs.Filling = createTab()
tabs.Whitelist = createTab()
tabs.Movement = createTab()
tabs.Safety = createTab()
tabs.Performance = createTab()

local function showTab(tab)
	playSound(SOUNDS.Click, 0.3, 1.1)
	if activeTab == tab and flyout.Size.X.Offset > 0 then
		tab.Visible = false
		activeTab = nil
		tween(flyout, { Position = UDim2.new(1, -60, 0, 20), Size = UDim2.new(0, 0, 1, -40) }, 0.35, Enum.EasingStyle.Quint)
		return
	end
	fadeOverlay.BackgroundTransparency = 0
	for _, other in pairs(tabs) do other.Visible = false end
	tab.Visible = true
	activeTab = tab
	tween(flyout, { Position = UDim2.new(0, 0, 0, 20), Size = UDim2.new(1, -60, 1, -40) }, 0.35, Enum.EasingStyle.Quint)
	tween(fadeOverlay, {BackgroundTransparency = 1}, 0.25)
end

--============================================================
-- SMART UI ELEMENT BUILDERS
--============================================================

local function titleHeader(parent, text) 
	local x = Instance.new("TextLabel")
	x.BackgroundTransparency = 1
	x.Text = text
	x.TextSize = 14
	x.TextColor3 = ACCENT
	x.Font = Enum.Font.GothamBlack
	x.Size = UDim2.new(1, 0, 0, 25)
	x.TextXAlignment = Enum.TextXAlignment.Center
	x.ZIndex = 2
	x.Parent = parent
	local div = Instance.new("Frame")
	div.Size = UDim2.new(1, 0, 0, 2)
	div.BackgroundColor3 = BG_ELEMENT
	div.BorderSizePixel = 0
	div.Parent = parent
	return x 
end

local function header(parent, text, customColor) 
	local x = Instance.new("TextLabel")
	x.BackgroundTransparency = 1
	x.Text = text or ""
	x.TextSize = 11
	x.TextColor3 = customColor or TEXT_SUB
	x.Font = Enum.Font.GothamBold
	x.Size = UDim2.new(1, 0, 0, 20)
	x.TextXAlignment = Enum.TextXAlignment.Left
	x.ZIndex = 2
	x.Parent = parent
	return x 
end

local function input(parent, placeholder, height, clearOnFocus)
	local x = Instance.new("TextBox")
	x.PlaceholderText = placeholder or ""
	x.Text = ""
	x.ClearTextOnFocus = clearOnFocus or false
	x.PlaceholderColor3 = TEXT_SUB
	x.TextColor3 = TEXT_MAIN
	x.TextSize = 12
	x.Font = Enum.Font.Gotham
	x.BackgroundColor3 = BG_ELEMENT
	x.BorderSizePixel = 0
	x.Size = UDim2.new(1, 0, 0, height or 38)
	x.ZIndex = 2
	x.Parent = parent
	Instance.new("UICorner", x).CornerRadius = UDim.new(0, 8)
	local stroke = Instance.new("UIStroke", x)
	stroke.Color = Color3.fromRGB(45, 45, 55)
	
	x.Focused:Connect(function() 
		playSound(SOUNDS.Hover, 0.2, 1.5)
		tween(stroke, {Color = GRAD_2}, 0.2) 
	end)
	x.FocusLost:Connect(function() 
		tween(stroke, {Color = Color3.fromRGB(45, 45, 55)}, 0.2) 
	end)
	return x
end

local function button(parent, text, isGradient)
	local x = Instance.new("TextButton")
	x.Text = text or ""
	x.TextSize = 12
	x.TextColor3 = TEXT_MAIN
	x.Font = Enum.Font.GothamBold
	x.BackgroundColor3 = BG_ELEMENT
	x.BorderSizePixel = 0
	x.Size = UDim2.new(1, 0, 0, 38)
	x.AutoButtonColor = false
	x.ZIndex = 2
	x.Parent = parent
	Instance.new("UICorner", x).CornerRadius = UDim.new(0, 8)
	local stroke = Instance.new("UIStroke", x)
	stroke.Color = Color3.fromRGB(45, 45, 55)
	
	if isGradient then 
		applyGradient(x)
		x.TextColor3 = Color3.new(1,1,1)
		stroke:Destroy() 
	end
	
	x.MouseEnter:Connect(function() 
		playSound(SOUNDS.Hover, 0.1, 1.2)
		if not isGradient and x.BackgroundColor3 == BG_ELEMENT then tween(x, {BackgroundColor3 = BG_HOVER}, 0.15) end 
	end)
	x.MouseLeave:Connect(function() 
		if not isGradient and x.BackgroundColor3 == BG_HOVER then tween(x, {BackgroundColor3 = BG_ELEMENT}, 0.15) end 
	end)
	x.MouseButton1Click:Connect(function() 
		playSound(SOUNDS.Click, 0.4, 1.0) 
	end)
	return x
end

local function createToggle(parent, labelText, stateTable, stateKey, callback)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 35)
	row.BackgroundTransparency = 1
	row.Parent = parent
	
	local lbl = Instance.new("TextLabel")
	lbl.BackgroundTransparency = 1
	lbl.Text = labelText
	lbl.TextSize = 12
	lbl.TextColor3 = TEXT_MAIN
	lbl.Font = Enum.Font.GothamBold
	lbl.Size = UDim2.new(1, -50, 1, 0)
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = row
	
	local track = Instance.new("Frame")
	track.Size = UDim2.new(0, 42, 0, 22)
	track.AnchorPoint = Vector2.new(1, 0.5)
	track.Position = UDim2.new(1, 0, 0.5, 0)
	track.BackgroundColor3 = RADIO_OFF
	track.Parent = row
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
	
	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 16, 0, 16)
	knob.Position = stateTable[stateKey] and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
	knob.BackgroundColor3 = TEXT_MAIN
	knob.Parent = track
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
	
	if stateTable[stateKey] then track.BackgroundColor3 = SUCCESS end

	local btnOverlay = Instance.new("TextButton")
	btnOverlay.Size = UDim2.new(1, 0, 1, 0)
	btnOverlay.BackgroundTransparency = 1
	btnOverlay.Text = ""
	btnOverlay.Parent = row
	
	btnOverlay.MouseEnter:Connect(function() playSound(SOUNDS.Hover, 0.1, 1.2) end)
	btnOverlay.Activated:Connect(function()
		playSound(SOUNDS.Click, 0.4, 1.0)
		stateTable[stateKey] = not stateTable[stateKey]
		if stateTable[stateKey] then 
			tween(track, {BackgroundColor3 = SUCCESS}, 0.25)
			tween(knob, {Position = UDim2.new(1, -19, 0.5, -8)}, 0.25) 
		else 
			tween(track, {BackgroundColor3 = RADIO_OFF}, 0.25)
			tween(knob, {Position = UDim2.new(0, 3, 0.5, -8)}, 0.25) 
		end
		if callback then callback(stateTable[stateKey]) end
	end)
end

local function createDirectStepper(parent, labelText, min, max, stateTable, stateKey)
	-- Mobile-friendly slider with numeric editing and +/- precision controls.
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 66)
	row.BackgroundColor3 = BG_ELEMENT
	row.BorderSizePixel = 0
	row.Parent = parent
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
	local rStroke = Instance.new("UIStroke", row)
	rStroke.Color = Color3.fromRGB(45, 45, 55)

	local lbl = Instance.new("TextLabel")
	lbl.BackgroundTransparency = 1
	lbl.Text = labelText
	lbl.TextSize = 11
	lbl.TextColor3 = TEXT_SUB
	lbl.Font = Enum.Font.GothamBold
	lbl.Size = UDim2.new(1, -92, 0, 20)
	lbl.Position = UDim2.new(0, 10, 0, 5)
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = row

	local valInput = Instance.new("TextBox")
	valInput.BackgroundTransparency = 1
	valInput.Text = tostring(stateTable[stateKey])
	valInput.TextSize = 12
	valInput.TextColor3 = ACCENT
	valInput.Font = Enum.Font.GothamBlack
	valInput.Size = UDim2.new(0, 70, 0, 20)
	valInput.Position = UDim2.new(1, -80, 0, 5)
	valInput.TextXAlignment = Enum.TextXAlignment.Right
	valInput.ClearTextOnFocus = false
	valInput.Parent = row

	local minus = Instance.new("TextButton")
	minus.Size = UDim2.new(0, 24, 0, 24)
	minus.Position = UDim2.new(1, -58, 0, 35)
	minus.BackgroundColor3 = BG_MAIN
	minus.Text = "−"
	minus.TextSize = 15
	minus.TextColor3 = TEXT_MAIN
	minus.Font = Enum.Font.GothamBlack
	minus.AutoButtonColor = false
	minus.Parent = row
	Instance.new("UICorner", minus).CornerRadius = UDim.new(0, 6)

	local plus = Instance.new("TextButton")
	plus.Size = UDim2.new(0, 24, 0, 24)
	plus.Position = UDim2.new(1, -29, 0, 35)
	plus.BackgroundColor3 = BG_MAIN
	plus.Text = "+"
	plus.TextSize = 15
	plus.TextColor3 = TEXT_MAIN
	plus.Font = Enum.Font.GothamBlack
	plus.AutoButtonColor = false
	plus.Parent = row
	Instance.new("UICorner", plus).CornerRadius = UDim.new(0, 6)

	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, -82, 0, 6)
	track.Position = UDim2.new(0, 10, 0, 44)
	track.BackgroundColor3 = RADIO_OFF
	track.BorderSizePixel = 0
	track.Active = true
	track.Parent = row
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

	local fill = Instance.new("Frame")
	fill.BackgroundColor3 = GRAD_2
	fill.BorderSizePixel = 0
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.Parent = track
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("TextButton")
	knob.Size = UDim2.new(0, 16, 0, 16)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.BackgroundColor3 = TEXT_MAIN
	knob.Text = ""
	knob.AutoButtonColor = false
	knob.ZIndex = 4
	knob.Parent = track
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local function decimals()
		return (max <= 30 and min < 1) and 1 or 0
	end
	local step = (max <= 30 and min < 1) and 0.1 or 1
	local function formatValue(v)
		if decimals() == 1 then return string.format("%.1f", v) end
		return tostring(math.floor(v + 0.5))
	end
	local function applyValue(v)
		v = math.clamp(tonumber(v) or tonumber(stateTable[stateKey]) or min, min, max)
		if step < 1 then v = math.floor(v / step + 0.5) * step end
		stateTable[stateKey] = v
		valInput.Text = formatValue(v)
		local pct = (v - min) / math.max(max - min, 0.0001)
		fill.Size = UDim2.new(pct, 0, 1, 0)
		knob.Position = UDim2.new(pct, 0, 0.5, 0)
	end

	local dragging = false
	local function setFromX(x)
		local left = track.AbsolutePosition.X
		local width = math.max(track.AbsoluteSize.X, 1)
		local pct = math.clamp((x - left) / width, 0, 1)
		applyValue(min + (max - min) * pct)
	end
	track.InputBegan:Connect(function(io)
		if io.UserInputType == Enum.UserInputType.MouseButton1 or io.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			setFromX(io.Position.X)
		end
	end)
	knob.InputBegan:Connect(function(io)
		if io.UserInputType == Enum.UserInputType.MouseButton1 or io.UserInputType == Enum.UserInputType.Touch then dragging = true end
	end)
	UserInputService.InputChanged:Connect(function(io)
		if dragging and (io.UserInputType == Enum.UserInputType.MouseMovement or io.UserInputType == Enum.UserInputType.Touch) then setFromX(io.Position.X) end
	end)
	UserInputService.InputEnded:Connect(function(io)
		if io.UserInputType == Enum.UserInputType.MouseButton1 or io.UserInputType == Enum.UserInputType.Touch then dragging = false end
	end)
	valInput.FocusLost:Connect(function()
		applyValue(valInput.Text)
		tween(rStroke, {Color = Color3.fromRGB(45,45,55)}, 0.15)
	end)
	valInput.Focused:Connect(function() tween(rStroke, {Color = GRAD_2}, 0.15) end)
	minus.Activated:Connect(function() applyValue((tonumber(stateTable[stateKey]) or min) - step) end)
	plus.Activated:Connect(function() applyValue((tonumber(stateTable[stateKey]) or min) + step) end)
	applyValue(stateTable[stateKey])
	return row
end

local function createCyclicStepper(parent, labelText, optionsArray, stateTable, stateKey)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 38)
	row.BackgroundColor3 = BG_ELEMENT
	row.Parent = parent
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
	local rStroke = Instance.new("UIStroke", row)
	rStroke.Color = Color3.fromRGB(45, 45, 55)
	
	local lbl = Instance.new("TextLabel")
	lbl.BackgroundTransparency = 1
	lbl.Text = "  " .. labelText
	lbl.TextSize = 12
	lbl.TextColor3 = TEXT_SUB
	lbl.Font = Enum.Font.GothamBold
	lbl.Size = UDim2.new(0.5, 0, 1, 0)
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = row
	
	local valBtn = Instance.new("TextButton")
	valBtn.BackgroundTransparency = 1
	valBtn.Text = stateTable[stateKey] .. " ⟳"
	valBtn.TextSize = 12
	valBtn.TextColor3 = ACCENT
	valBtn.Font = Enum.Font.GothamBlack
	valBtn.Size = UDim2.new(0.5, -10, 1, 0)
	valBtn.Position = UDim2.new(0.5, 0, 0, 0)
	valBtn.TextXAlignment = Enum.TextXAlignment.Right
	valBtn.Parent = row
	
	local function getIndex() 
		for i, v in ipairs(optionsArray) do if v == stateTable[stateKey] then return i end end 
		return 1 
	end
	
	valBtn.MouseEnter:Connect(function() playSound(SOUNDS.Hover, 0.1, 1.2) end)
	valBtn.Activated:Connect(function() 
		playSound(SOUNDS.Click, 0.3, 1.1)
		local idx = getIndex() + 1
		if idx > #optionsArray then idx = 1 end
		stateTable[stateKey] = optionsArray[idx]
		valBtn.Text = stateTable[stateKey] .. " ⟳"
		tween(rStroke, {Color = GRAD_2}, 0.1)
		task.delay(0.15, function() tween(rStroke, {Color = Color3.fromRGB(45, 45, 55)}, 0.2) end) 
	end)
end

-- DeepHat Loader Controller: consolidated UI for the procedural Animation Manager.
-- This replaces the standalone TrollMenu/ReplicatedStorage loader and keeps
-- all state changes inside the existing V50 GUI/runtime.
local function createDeepHatController(parent)
    header(parent, "DEEPHAT ANIMATION LOADER")

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 30)
    status.BackgroundTransparency = 1
    status.Text = "STATE: " .. tostring(State.Pat.EngineState)
    status.TextColor3 = ACCENT
    status.TextSize = 12
    status.Font = Enum.Font.GothamBlack
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Parent = parent

    local stateButtons = Instance.new("Frame")
    stateButtons.Size = UDim2.new(1, 0, 0, 42)
    stateButtons.BackgroundTransparency = 1
    stateButtons.Parent = parent
    local grid = Instance.new("UIGridLayout")
    grid.CellPadding = UDim2.new(0, 6, 0, 0)
    grid.CellSize = UDim2.new(0.24, -4, 1, 0)
    grid.FillDirectionMaxCells = 4
    grid.Parent = stateButtons

    local buttons = {}
    local function setState(stateName)
        State.Pat.EngineState = stateName
        status.Text = "STATE: " .. stateName
        if stateName == "Idle" then
            PatMotion:SetState(LP.Character, "Idle")
        else
            PatMotion:SetState(LP.Character, stateName)
        end
        for name, btn in pairs(buttons) do
            btn.BackgroundColor3 = (name == stateName) and SUCCESS or BG_ELEMENT
        end
    end

    for _, stateName in ipairs({"Idle", "PatTroll", "EmoteTroll"}) do
        local btn = button(stateButtons, stateName)
        btn.TextSize = 11
        btn.AutoButtonColor = false
        btn.Activated:Connect(function() setState(stateName) end)
        buttons[stateName] = btn
    end
    for name, btn in pairs(buttons) do
        btn.BackgroundColor3 = (name == State.Pat.EngineState) and SUCCESS or BG_ELEMENT
    end

    local reset = button(parent, "RESET PROCEDURAL ANIMATION")
    reset.Activated:Connect(function()
        State.Pat.EngineState = "Idle"
        PatMotion:SetState(LP.Character, "Idle")
        status.Text = "STATE: Idle"
        for name, btn in pairs(buttons) do
            btn.BackgroundColor3 = (name == "Idle") and SUCCESS or BG_ELEMENT
        end
    end)

    local note = Instance.new("TextLabel")
    note.Size = UDim2.new(1, 0, 0, 34)
    note.BackgroundTransparency = 1
    note.Text = "One controller • one Heartbeat • stable Motor6D baselines"
    note.TextColor3 = TEXT_SUB
    note.TextSize = 10
    note.Font = Enum.Font.Gotham
    note.TextWrapped = true
    note.TextXAlignment = Enum.TextXAlignment.Left
    note.Parent = parent
end

local updateQuickBarVisuals

local function createGridRadioGroup(parent, options, stateKey, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.Parent = parent
	
	local grid = Instance.new("UIGridLayout")
	grid.CellSize = UDim2.new(0.5, -5, 0, 38)
	grid.CellPadding = UDim2.new(0, 10, 0, 10)
	grid.Parent = container
	grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() 
		container.Size = UDim2.new(1, 0, 0, grid.AbsoluteContentSize.Y) 
	end)
	
	local btns = {}
	for _, opt in ipairs(options) do
		local b = Instance.new("TextButton")
		b.Text = opt
		b.TextSize = 12
		b.TextColor3 = (opt == State.Moves.Mode) and TEXT_MAIN or TEXT_SUB
		b.Font = Enum.Font.GothamBold
		b.BackgroundColor3 = (opt == State.Moves.Mode) and Color3.fromRGB(40, 70, 45) or BG_ELEMENT
		b.AutoButtonColor = false
		b.Parent = container
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
		local s = Instance.new("UIStroke", b)
		s.Color = (opt == State.Moves.Mode) and SUCCESS or Color3.fromRGB(50, 50, 60)
		s.Thickness = 1.5
		btns[opt] = {btn = b, stroke = s}
		
		b.MouseEnter:Connect(function() if opt ~= State.Moves.Mode then playSound(SOUNDS.Hover, 0.1, 1.2) end end)
		b.MouseButton1Click:Connect(function()
			playSound(SOUNDS.Click, 0.4, 1.0)
			for _, v in pairs(btns) do 
				tween(v.btn, {BackgroundColor3 = BG_ELEMENT, TextColor3 = TEXT_SUB}, 0.2)
				tween(v.stroke, {Color = Color3.fromRGB(50, 50, 60)}, 0.2) 
			end
			tween(b, {BackgroundColor3 = Color3.fromRGB(40, 70, 45), TextColor3 = TEXT_MAIN}, 0.2)
			tween(s, {Color = SUCCESS}, 0.2)
			callback(opt)
            if updateQuickBarVisuals then updateQuickBarVisuals() end
		end)
	end
end

--============================================================
-- FLOATING QUICK TROLL DOCK
--============================================================
-- The quick dock lives directly under the ScreenGui so it remains visible
-- even when the main dashboard is minimized. It is intentionally compact,
-- pill-shaped, and touch-friendly like the supplied reference image.
local quickDock = Instance.new("Frame")
quickDock.Name = "QuickTrollDock"
quickDock.AnchorPoint = Vector2.new(0, 0.5)
quickDock.Size = UDim2.new(0, 132, 0, 410)
quickDock.Position = UDim2.new(0, 12, 0.5, 0)
quickDock.BackgroundColor3 = BG_MAIN
quickDock.BackgroundTransparency = 0.04
quickDock.BorderSizePixel = 0
quickDock.ZIndex = 900
quickDock.Parent = gui
Instance.new("UICorner", quickDock).CornerRadius = UDim.new(0, 28)
local qdStroke = Instance.new("UIStroke", quickDock)
qdStroke.Color = Color3.fromRGB(58, 62, 70)
qdStroke.Thickness = 1.5
createShadow(quickDock, 28, 0.55, 4)

local quickHeader = Instance.new("Frame")
quickHeader.Size = UDim2.new(1, 0, 0, 38)
quickHeader.BackgroundTransparency = 1
quickHeader.ZIndex = 901
quickHeader.Parent = quickDock
local quickTitle = Instance.new("TextLabel")
quickTitle.BackgroundTransparency = 1
quickTitle.Text = "TROLL"
quickTitle.TextSize = 10
quickTitle.TextColor3 = TEXT_SUB
quickTitle.Font = Enum.Font.GothamBlack
quickTitle.Size = UDim2.new(1, -20, 1, 0)
quickTitle.Position = UDim2.new(0, 10, 0, 0)
quickTitle.TextXAlignment = Enum.TextXAlignment.Center
quickTitle.ZIndex = 902
quickTitle.Parent = quickHeader

local quickList = Instance.new("ScrollingFrame")
quickList.Size = UDim2.new(1, -10, 1, -82)
quickList.Position = UDim2.new(0, 5, 0, 38)
quickList.BackgroundTransparency = 1
quickList.ZIndex = 901
quickList.Parent = quickDock
quickList.BorderSizePixel = 0
quickList.ScrollBarThickness = 0
quickList.CanvasSize = UDim2.new(0, 0, 0, 0)
local quickLayout = Instance.new("UIListLayout")
quickLayout.Padding = UDim.new(0, 7)
quickLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
quickLayout.SortOrder = Enum.SortOrder.LayoutOrder
quickLayout.Parent = quickList
quickLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    quickList.CanvasSize = UDim2.new(0, 0, 0, quickLayout.AbsoluteContentSize.Y + 4)
end)

local quickFooter = Instance.new("Frame")
quickFooter.Size = UDim2.new(1, -10, 0, 38)
quickFooter.Position = UDim2.new(0, 5, 1, -43)
quickFooter.BackgroundTransparency = 1
quickFooter.ZIndex = 901
quickFooter.Parent = quickDock

local quickSetupButton = Instance.new("TextButton")
quickSetupButton.Size = UDim2.new(0, 38, 0, 32)
quickSetupButton.Position = UDim2.new(0.5, -19, 0, 2)
quickSetupButton.BackgroundColor3 = BG_ELEMENT
quickSetupButton.Text = "⚙"
quickSetupButton.TextSize = 17
quickSetupButton.TextColor3 = TEXT_MAIN
quickSetupButton.Font = Enum.Font.GothamBold
quickSetupButton.AutoButtonColor = false
quickSetupButton.ZIndex = 902
quickSetupButton.Parent = quickFooter
Instance.new("UICorner", quickSetupButton).CornerRadius = UDim.new(0, 10)
local qsStroke = Instance.new("UIStroke", quickSetupButton)
qsStroke.Color = Color3.fromRGB(55, 58, 66)

local quickBarButtons = {}
local QUICK_ORDER = {
    "Pat", "Headsit", "Facebang", "Hipbang", "Close Contact", "Orbit",
    "Mount", "Tornado", "Fling", "Void Send", "Stomp", "Spin", "Attach", "Glitch"
}

local quickManager = nil

local function quickLabel(mode)
    if mode == "Close Contact" then return "Close" end
    if mode == "Void Send" then return "Void" end
    return mode
end

local function updateQuickBarVisuals()
    local count = 0
    for _, mode in ipairs(QUICK_ORDER) do
        if State.QuickBar.Modes[mode] then count += 1 end
    end
    quickDock.Visible = State.Unlocked and State.QuickBar.Enabled and count > 0
    if not quickDock.Visible and quickManager then quickManager.Visible = false end
    quickDock.Size = UDim2.new(0, 132, 0, math.clamp(82 + count * 45, 145, 620))
    quickDock.Position = UDim2.new(0, 12, 0.5, -quickDock.Size.Y.Offset / 2)
    quickList.Size = UDim2.new(1, -10, 1, -82)
    quickList.CanvasSize = UDim2.new(0, 0, 0, quickLayout.AbsoluteContentSize.Y + 4)
    quickFooter.Position = UDim2.new(0, 5, 1, -43)

    for mode, btnData in pairs(quickBarButtons) do
        local enabled = State.QuickBar.Modes[mode] == true
        btnData.button.Visible = quickDock.Visible and enabled
        local active = enabled and State.Moves.Mode == mode and State.Moves.Running
        btnData.dot.BackgroundColor3 = active and SUCCESS or Color3.fromRGB(82, 86, 94)
        btnData.button.BackgroundColor3 = active and Color3.fromRGB(28, 52, 38) or BG_MAIN
        btnData.label.TextColor3 = active and TEXT_MAIN or TEXT_SUB
        btnData.stroke.Color = active and SUCCESS or Color3.fromRGB(55, 58, 66)
    end
end

local function createQuickButton(mode)
    local buttonFrame = Instance.new("TextButton")
    buttonFrame.Name = "Quick_" .. mode:gsub("%W", "_")
    buttonFrame.Size = UDim2.new(1, -10, 0, 39)
    buttonFrame.BackgroundColor3 = BG_MAIN
    buttonFrame.BackgroundTransparency = 0.02
    buttonFrame.BorderSizePixel = 0
    buttonFrame.Text = ""
    buttonFrame.AutoButtonColor = false
    buttonFrame.ZIndex = 902
    buttonFrame.Parent = quickList
    Instance.new("UICorner", buttonFrame).CornerRadius = UDim.new(0, 20)
    local stroke = Instance.new("UIStroke", buttonFrame)
    stroke.Color = Color3.fromRGB(55, 58, 66)
    stroke.Thickness = 1.2

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 10, 0, 10)
    dot.Position = UDim2.new(0, 12, 0.5, -5)
    dot.BackgroundColor3 = Color3.fromRGB(82, 86, 94)
    dot.BorderSizePixel = 0
    dot.ZIndex = 903
    dot.Parent = buttonFrame
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = quickLabel(mode)
    label.TextSize = 12
    label.TextColor3 = TEXT_SUB
    label.Font = Enum.Font.GothamBold
    label.Size = UDim2.new(1, -35, 1, 0)
    label.Position = UDim2.new(0, 29, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.ZIndex = 903
    label.Parent = buttonFrame

    buttonFrame.MouseEnter:Connect(function()
        playSound(SOUNDS.Hover, 0.08, 1.12)
        if not (State.Moves.Mode == mode and State.Moves.Running) then
            tween(buttonFrame, {BackgroundColor3 = BG_HOVER}, 0.1)
        end
    end)
    buttonFrame.MouseLeave:Connect(function()
        if not (State.Moves.Mode == mode and State.Moves.Running) then
            tween(buttonFrame, {BackgroundColor3 = BG_MAIN}, 0.1)
        end
    end)
    buttonFrame.Activated:Connect(function()
        playSound(SOUNDS.Click, 0.25, 1.0)
        State.Moves.Mode = mode
        updateQuickBarVisuals()
        if Internal.StartMoves then
            Internal.StartMoves(true)
        end
    end)

    quickBarButtons[mode] = {button = buttonFrame, dot = dot, label = label, stroke = stroke}
end

for _, mode in ipairs(QUICK_ORDER) do
    createQuickButton(mode)
end

-- Compact add/remove panel. This keeps the main GUI clean while making every
-- troll option individually addable/removable from the floating dock.
quickManager = Instance.new("Frame")
quickManager.Name = "QuickTrollManager"
quickManager.Size = UDim2.new(0, 230, 0, 430)
quickManager.Position = UDim2.new(0, 152, 0.5, -215)
quickManager.BackgroundColor3 = BG_FLYOUT
quickManager.BorderSizePixel = 0
quickManager.Visible = false
quickManager.ZIndex = 910
quickManager.Parent = gui
Instance.new("UICorner", quickManager).CornerRadius = UDim.new(0, 16)
local qmStroke = Instance.new("UIStroke", quickManager)
qmStroke.Color = Color3.fromRGB(55, 58, 66)
qmStroke.Thickness = 1.5
createShadow(quickManager, 24, 0.55, 4)

local qmTitle = Instance.new("TextLabel")
qmTitle.BackgroundTransparency = 1
qmTitle.Text = "QUICK TROLL BUTTONS"
qmTitle.TextSize = 12
qmTitle.TextColor3 = TEXT_MAIN
qmTitle.Font = Enum.Font.GothamBlack
qmTitle.Size = UDim2.new(1, -40, 0, 34)
qmTitle.Position = UDim2.new(0, 14, 0, 4)
qmTitle.TextXAlignment = Enum.TextXAlignment.Left
qmTitle.ZIndex = 911
qmTitle.Parent = quickManager

local qmClose = Instance.new("TextButton")
qmClose.Size = UDim2.new(0, 28, 0, 28)
qmClose.Position = UDim2.new(1, -34, 0, 7)
qmClose.BackgroundColor3 = BG_ELEMENT
qmClose.Text = "×"
qmClose.TextSize = 18
qmClose.TextColor3 = TEXT_SUB
qmClose.Font = Enum.Font.GothamBold
qmClose.AutoButtonColor = false
qmClose.ZIndex = 912
qmClose.Parent = quickManager
Instance.new("UICorner", qmClose).CornerRadius = UDim.new(0, 8)

local qmList = Instance.new("ScrollingFrame")
qmList.Size = UDim2.new(1, -20, 1, -50)
qmList.Position = UDim2.new(0, 10, 0, 42)
qmList.BackgroundTransparency = 1
qmList.BorderSizePixel = 0
qmList.ScrollBarThickness = 2
qmList.ScrollBarImageColor3 = GRAD_2
qmList.ZIndex = 911
qmList.Parent = quickManager
local qmLayout = Instance.new("UIListLayout")
qmLayout.Padding = UDim.new(0, 5)
qmLayout.Parent = qmList
local qmPad = Instance.new("UIPadding", qmList)
qmPad.PaddingBottom = UDim.new(0, 8)
qmLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    qmList.CanvasSize = UDim2.new(0, 0, 0, qmLayout.AbsoluteContentSize.Y + 10)
end)

local function createQuickManagerRow(mode)
    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, -4, 0, 34)
    row.BackgroundColor3 = BG_ELEMENT
    row.Text = ""
    row.AutoButtonColor = false
    row.ZIndex = 912
    row.Parent = qmList
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 9)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = quickLabel(mode)
    label.TextSize = 11
    label.TextColor3 = TEXT_MAIN
    label.Font = Enum.Font.GothamBold
    label.Size = UDim2.new(1, -58, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 913
    label.Parent = row

    local state = Instance.new("TextLabel")
    state.BackgroundTransparency = 1
    state.TextSize = 10
    state.Font = Enum.Font.GothamBlack
    state.Size = UDim2.new(0, 42, 1, 0)
    state.Position = UDim2.new(1, -48, 0, 0)
    state.TextXAlignment = Enum.TextXAlignment.Right
    state.ZIndex = 913
    state.Parent = row

    local function refresh()
        local on = State.QuickBar.Modes[mode] == true
        state.Text = on and "ON" or "OFF"
        state.TextColor3 = on and SUCCESS or TEXT_SUB
        row.BackgroundColor3 = on and Color3.fromRGB(25, 43, 33) or BG_ELEMENT
    end
    row.Activated:Connect(function()
        State.QuickBar.Modes[mode] = not State.QuickBar.Modes[mode]
        refresh()
        updateQuickBarVisuals()
    end)
    refresh()
end
for _, mode in ipairs(QUICK_ORDER) do
    createQuickManagerRow(mode)
end

quickSetupButton.Activated:Connect(function()
    playSound(SOUNDS.Click, 0.25, 1.0)
    quickManager.Visible = not quickManager.Visible
end)
qmClose.Activated:Connect(function()
    quickManager.Visible = false
end)

updateQuickBarVisuals()

--============================================================
-- NAVIGATION BAR
--============================================================

local capLayout = Instance.new("UIListLayout")
capLayout.Padding = UDim.new(0, 4)
capLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
capLayout.VerticalAlignment = Enum.VerticalAlignment.Center
capLayout.Parent = navContainer

local function navIcon(symbol)
	local x = Instance.new("TextButton")
	x.Size = UDim2.new(0, 36, 0, 36)
	x.BackgroundTransparency = 1
	x.Text = symbol
	x.TextSize = 20
	x.TextColor3 = TEXT_SUB
	x.Font = Enum.Font.GothamBold
	x.ZIndex = 11
	x.Parent = navContainer
	x.MouseEnter:Connect(function() 
		playSound(SOUNDS.Hover, 0.1, 1.3)
		tween(x, {TextColor3 = ACCENT}, 0.2) 
	end)
	x.MouseLeave:Connect(function() tween(x, {TextColor3 = TEXT_SUB}, 0.2) end)
	return x
end

local btnTarget    = navIcon("⌖"); btnTarget.Activated:Connect(function() showTab(tabs.Target) end)
local btnMoves     = navIcon("⚡"); btnMoves.Activated:Connect(function() showTab(tabs.Moves) end)
local btnChat      = navIcon("💬"); btnChat.Activated:Connect(function() showTab(tabs.Chat) end)
local btnAnim      = navIcon("👁"); btnAnim.Activated:Connect(function() showTab(tabs.Anim) end)
local btnEmotes    = navIcon("✨"); btnEmotes.Activated:Connect(function() showTab(tabs.Emotes) end)
local btnFilling   = navIcon("🧪"); btnFilling.Activated:Connect(function() showTab(tabs.Filling) end)
local btnWhitelist = navIcon("🛡️"); btnWhitelist.Activated:Connect(function() showTab(tabs.Whitelist) end)
local btnMovement  = navIcon("🚀"); btnMovement.Activated:Connect(function() showTab(tabs.Movement) end)
local btnSafe      = navIcon("⚙"); btnSafe.Activated:Connect(function() showTab(tabs.Safety) end)
local btnPerformance = navIcon("◈"); btnPerformance.Activated:Connect(function()
	if State.Performance.Visible then showTab(tabs.Performance) end
end)

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 46, 0, 46)
minimize.Position = UDim2.new(0.5, -23, 0.5, -23)
minimize.BackgroundColor3 = BG_ELEMENT
minimize.Text = "−"
minimize.TextSize = 30
minimize.TextColor3 = TEXT_MAIN
minimize.Font = Enum.Font.GothamBlack
minimize.ZIndex = 12
minimize.Parent = minContainer
Instance.new("UICorner", minimize).CornerRadius = UDim.new(1, 0)
local mwStroke = Instance.new("UIStroke", minimize)
mwStroke.Color = Color3.fromRGB(45, 45, 55)
minimize.MouseEnter:Connect(function() playSound(SOUNDS.Hover, 0.1, 1.1) end)
minimize.Activated:Connect(function() playSound(SOUNDS.Click, 0.3, 0.9) end)

--============================================================
-- MINI-DASHBOARD INJECTION
--============================================================

local miniDashes = {}
local function createMiniDash(parentTab)
	local c = Instance.new("Frame")
	c.Size = UDim2.new(1, 0, 0, 50)
	c.BackgroundColor3 = BG_ELEMENT
	c.Parent = parentTab
	Instance.new("UICorner", c).CornerRadius = UDim.new(0, 10)
	Instance.new("UIStroke", c).Color = Color3.fromRGB(45, 45, 55)
	
	local av = Instance.new("ImageLabel")
	av.Size = UDim2.new(0, 38, 0, 38)
	av.Position = UDim2.new(0, 6, 0.5, -19)
	av.BackgroundTransparency = 1
	av.Parent = c
	Instance.new("UICorner", av).CornerRadius = UDim.new(1, 0)
	
	local nm = Instance.new("TextLabel")
	nm.BackgroundTransparency = 1
	nm.Text = "No Target"
	nm.TextSize = 13
	nm.TextColor3 = TEXT_SUB
	nm.Font = Enum.Font.GothamBlack
	nm.Size = UDim2.new(1, -60, 0, 20)
	nm.Position = UDim2.new(0, 50, 0, 6)
	nm.TextXAlignment = Enum.TextXAlignment.Left
	nm.Parent = c
	
	local hbBg = Instance.new("Frame")
	hbBg.Size = UDim2.new(1, -60, 0, 8)
	hbBg.Position = UDim2.new(0, 50, 0, 30)
	hbBg.BackgroundColor3 = BG_MAIN
	hbBg.Parent = c
	Instance.new("UICorner", hbBg).CornerRadius = UDim.new(1, 0)
	
	local hbFill = Instance.new("Frame")
	hbFill.Size = UDim2.new(0, 0, 1, 0)
	hbFill.BackgroundColor3 = SUCCESS
	hbFill.Parent = hbBg
	Instance.new("UICorner", hbFill).CornerRadius = UDim.new(1, 0)
	table.insert(miniDashes, { container = c, avatar = av, name = nm, hpFill = hbFill })
end

--============================================================
-- HTTP SERVICE DATA FETCHER (SAFE CLIENT PROXY)
--============================================================
local function fetchAdvancedInfo(uid)
    -- Use executor HTTP only when the host explicitly exposes a compatible
    -- request function; otherwise fall back to Roblox's local Player data.
    local info = { age = "N/A", friends = "N/A" }
    local requestOptions = {
        Url = "https://users.roblox.com/v1/users/" .. tostring(uid),
        Method = "GET"
    }
    local ok, res = universalRequest(requestOptions)
    if ok and res and res.Body then
        pcall(function()
            local d = HttpService:JSONDecode(res.Body)
            if d and d.created then
                local c = DateTime.fromIsoDate(d.created)
                local days = (DateTime.now().UnixTimestamp - c.UnixTimestamp) / 86400
                if days < 30 then info.age = math.floor(days) .. "d"
                elseif days < 365 then info.age = math.floor(days / 30) .. "mo"
                else info.age = math.floor(days / 365) .. "y" end
            end
        end)
        local okF, fRes = universalRequest({
            Url = "https://friends.roblox.com/v1/users/" .. tostring(uid) .. "/friends/count",
            Method = "GET"
        })
        if okF and fRes and fRes.Body then
            pcall(function()
                local d = HttpService:JSONDecode(fRes.Body)
                if d and d.count ~= nil then info.friends = tostring(d.count) end
            end)
        end
    end

    if info.age == "N/A" then
        local okP, player = pcall(function()
            return Players:GetPlayerByUserId(tonumber(uid))
        end)
        if okP and player then
            local days = tonumber(player.AccountAge) or 0
            if days < 30 then info.age = math.floor(days) .. "d"
            elseif days < 365 then info.age = math.floor(days / 30) .. "mo"
            else info.age = math.floor(days / 365) .. "y" end
        end
    end
    return info
end

--============================================================
-- 1. TARGET TAB 
--============================================================
titleHeader(tabs.Target, "🎯 TARGET INTEL")
local intelContainer = Instance.new("Frame")
intelContainer.Size = UDim2.new(1, 0, 0, 240)
intelContainer.BackgroundColor3 = BG_ELEMENT
intelContainer.Parent = tabs.Target
Instance.new("UICorner", intelContainer).CornerRadius = UDim.new(0, 14)
Instance.new("UIStroke", intelContainer).Color = Color3.fromRGB(45, 45, 55)
createShadow(intelContainer, 25, 0.3, 3)

local intelAvatar = Instance.new("ImageLabel")
intelAvatar.Size = UDim2.new(0, 75, 0, 75)
intelAvatar.Position = UDim2.new(0.5, -37.5, 0, 15)
intelAvatar.BackgroundTransparency = 1
intelAvatar.ScaleType = Enum.ScaleType.Fit
intelAvatar.Parent = intelContainer
Instance.new("UICorner", intelAvatar).CornerRadius = UDim.new(1, 0)
local avStroke = Instance.new("UIStroke", intelAvatar)
avStroke.Color = GRAD_1
avStroke.Thickness = 2.5

local intelName = Instance.new("TextLabel")
intelName.BackgroundTransparency = 1
intelName.Text = "No Target Selected"
intelName.TextSize = 15
intelName.TextColor3 = TEXT_SUB
intelName.Font = Enum.Font.GothamBlack
intelName.Size = UDim2.new(1, 0, 0, 20)
intelName.Position = UDim2.new(0, 0, 0, 100)
intelName.TextXAlignment = Enum.TextXAlignment.Center
intelName.Parent = intelContainer

local intelDist = Instance.new("TextLabel")
intelDist.BackgroundTransparency = 1
intelDist.Text = "Distance: N/A"
intelDist.TextSize = 12
intelDist.TextColor3 = YELLOW
intelDist.Font = Enum.Font.GothamMedium
intelDist.Size = UDim2.new(1, 0, 0, 20)
intelDist.Position = UDim2.new(0, 0, 0, 120)
intelDist.TextXAlignment = Enum.TextXAlignment.Center
intelDist.Parent = intelContainer

local hpBg = Instance.new("Frame")
hpBg.Size = UDim2.new(0.8, 0, 0, 12)
hpBg.Position = UDim2.new(0.1, 0, 0, 145)
hpBg.BackgroundColor3 = BG_MAIN
hpBg.Parent = intelContainer
Instance.new("UICorner", hpBg).CornerRadius = UDim.new(1, 0)

local hpFill = Instance.new("Frame")
hpFill.Size = UDim2.new(0, 0, 1, 0)
hpFill.BackgroundColor3 = SUCCESS
hpFill.Parent = hpBg
Instance.new("UICorner", hpFill).CornerRadius = UDim.new(1, 0)

local intelHealth = Instance.new("TextLabel")
intelHealth.BackgroundTransparency = 1
intelHealth.Text = "HP: 0/0"
intelHealth.TextSize = 12
intelHealth.TextColor3 = TEXT_MAIN
intelHealth.Font = Enum.Font.GothamBold
intelHealth.Size = UDim2.new(1, 0, 0, 20)
intelHealth.Position = UDim2.new(0, 0, 0, 160)
intelHealth.TextXAlignment = Enum.TextXAlignment.Center
intelHealth.Parent = intelContainer

local intelAdvAge = Instance.new("TextLabel")
intelAdvAge.BackgroundTransparency = 1
intelAdvAge.Text = "Account Age: -"
intelAdvAge.TextSize = 11
intelAdvAge.TextColor3 = TEXT_SUB
intelAdvAge.Font = Enum.Font.GothamMedium
intelAdvAge.Size = UDim2.new(1, 0, 0, 20)
intelAdvAge.Position = UDim2.new(0, 0, 0, 185)
intelAdvAge.TextXAlignment = Enum.TextXAlignment.Center
intelAdvAge.Parent = intelContainer

local intelAdvFriends = Instance.new("TextLabel")
intelAdvFriends.BackgroundTransparency = 1
intelAdvFriends.Text = "Friends: -"
intelAdvFriends.TextSize = 11
intelAdvFriends.TextColor3 = TEXT_SUB
intelAdvFriends.Font = Enum.Font.GothamMedium
intelAdvFriends.Size = UDim2.new(1, 0, 0, 20)
intelAdvFriends.Position = UDim2.new(0, 0, 0, 205)
intelAdvFriends.TextXAlignment = Enum.TextXAlignment.Center
intelAdvFriends.Parent = intelContainer

header(tabs.Target, "SEARCH & LOCK")
local tSearch = input(tabs.Target, "Search Username...", 40, true)
local tClear = button(tabs.Target, "CLEAR CURRENT TARGET"); tClear.TextColor3 = DANGER

createToggle(tabs.Target, "Show Target Highlight (ESP)", State, "TargetESP", function(isOn) 
	local tc = getTargetChar()
	if tc then updateESP(tc) else updateESP(nil) end 
end)

local playerListHeader = Instance.new("TextLabel")
playerListHeader.BackgroundTransparency = 1
playerListHeader.Text = "SERVER PLAYERS  •  LIVE"
playerListHeader.TextColor3 = TEXT_SUB
playerListHeader.Font = Enum.Font.GothamBlack
playerListHeader.TextSize = 10
playerListHeader.Size = UDim2.new(1, 0, 0, 20)
playerListHeader.TextXAlignment = Enum.TextXAlignment.Left
playerListHeader.Parent = tabs.Target

local tList = Instance.new("Frame")
tList.BackgroundTransparency = 1
tList.Size = UDim2.new(1, 0, 0, 0)
tList.Parent = tabs.Target
local tListLayout = Instance.new("UIListLayout")
tListLayout.Padding = UDim.new(0, 10)
tListLayout.Parent = tList
tListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() 
	tList.Size = UDim2.new(1, 0, 0, tListLayout.AbsoluteContentSize.Y) 
end)

local targetButtonData = {}

local function targetRoleData(target)
	if target and target.kind == "PLAYER" then
		return VIP_USERNAMES[string.lower(target.username or "")]
	end
	return nil
end

local function createTargetRow(parent, target)
	local role = targetRoleData(target)
	local isPlayer = target.kind == "PLAYER"

	local row = Instance.new("Frame")
	row.Name = "TargetRow"
	row.Size = UDim2.new(1, 0, 0, isPlayer and 58 or 42)
	row.BackgroundColor3 = BG_ELEMENT
	row.BorderSizePixel = 0
	row.ZIndex = 3
	row.Parent = parent
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 11)

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(45, 45, 55)
	stroke.Thickness = 1
	stroke.Parent = row

	if isPlayer then
		local avatar = Instance.new("ImageLabel")
		avatar.Size = UDim2.new(0, 42, 0, 42)
		avatar.Position = UDim2.new(0, 8, 0.5, -21)
		avatar.BackgroundColor3 = BG_MAIN
		avatar.ScaleType = Enum.ScaleType.Crop
		avatar.ZIndex = 4
		avatar.Parent = row
		Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)

		local avatarStroke = Instance.new("UIStroke")
		avatarStroke.Color = role and (role.tier == 3 and YELLOW or GRAD_2) or Color3.fromRGB(55,55,65)
		avatarStroke.Thickness = role and 2 or 1
		avatarStroke.Parent = avatar

		task.spawn(function()
			local ok, img = pcall(function()
				return Players:GetUserThumbnailAsync(
					target.player.UserId,
					Enum.ThumbnailType.HeadShot,
					Enum.ThumbnailSize.Size100x100
				)
			end)
			if ok and img and avatar.Parent then avatar.Image = img end
		end)

		local nameLabel = Instance.new("TextLabel")
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = target.name
		nameLabel.TextColor3 = TEXT_MAIN
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.TextSize = 12
		nameLabel.Size = UDim2.new(1, role and -125 or -82, 0, 22)
		nameLabel.Position = UDim2.new(0, 60, 0, 7)
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
		nameLabel.ZIndex = 4
		nameLabel.Parent = row

		local userLabel = Instance.new("TextLabel")
		userLabel.BackgroundTransparency = 1
		userLabel.Text = "@" .. target.username
		userLabel.TextColor3 = TEXT_SUB
		userLabel.Font = Enum.Font.Gotham
		userLabel.TextSize = 10
		userLabel.Size = UDim2.new(1, role and -125 or -82, 0, 18)
		userLabel.Position = UDim2.new(0, 60, 0, 29)
		userLabel.TextXAlignment = Enum.TextXAlignment.Left
		userLabel.TextTruncate = Enum.TextTruncate.AtEnd
		userLabel.ZIndex = 4
		userLabel.Parent = row

		if role and State.Badges.ShowRoleBadges then
			local badge = Instance.new("TextLabel")
			badge.BackgroundColor3 = role.tier == 3 and Color3.fromRGB(60, 45, 12) or Color3.fromRGB(45, 20, 70)
			badge.Text = role.icon .. " " .. (role.tier == 3 and "SUPREME" or "PREMIUM")
			badge.TextColor3 = role.tier == 3 and YELLOW or Color3.fromRGB(220, 175, 255)
			badge.Font = Enum.Font.GothamBlack
			badge.TextSize = 8
			badge.Size = UDim2.new(0, role.tier == 3 and 78 or 70, 0, 20)
			badge.Position = UDim2.new(1, role.tier == 3 and -84 or -76, 0.5, -10)
			badge.ZIndex = 5
			badge.Parent = row
			Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 6)
		end
		if target.protected and State.Badges.ShowRoleBadges then
			local lockBadge = Instance.new("TextLabel")
			lockBadge.BackgroundTransparency = 1
			lockBadge.Text = "🔒"
			lockBadge.TextSize = 13
			lockBadge.Size = UDim2.new(0, 24, 0, 24)
			lockBadge.Position = UDim2.new(1, -26, 0.5, -12)
			lockBadge.ZIndex = 5
			lockBadge.Parent = row
		end
	else
		local icon = Instance.new("TextLabel")
		icon.BackgroundTransparency = 1
		icon.Text = "🤖"
		icon.TextSize = 17
		icon.Size = UDim2.new(0, 35, 1, 0)
		icon.Position = UDim2.new(0, 7, 0, 0)
		icon.ZIndex = 4
		icon.Parent = row

		local nameLabel = Instance.new("TextLabel")
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = target.name
		nameLabel.TextColor3 = TEXT_MAIN
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.TextSize = 11
		nameLabel.Size = UDim2.new(1, -52, 1, 0)
		nameLabel.Position = UDim2.new(0, 45, 0, 0)
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
		nameLabel.ZIndex = 4
		nameLabel.Parent = row
	end

	local selectButton = Instance.new("TextButton")
	selectButton.BackgroundTransparency = 1
	selectButton.Text = ""
	selectButton.AutoButtonColor = false
	selectButton.Size = UDim2.new(1, 0, 1, 0)
	selectButton.ZIndex = 6
	selectButton.Parent = row
	selectButton.Activated:Connect(function()
		if target.protected then
			Notify("TARGETING", "This account is protected and cannot be selected.", YELLOW)
			return
		end
		Internal.ApplyTarget(target)
	end)

	return row
end

Internal.ApplyTarget = function(target)
    if target and target.protected then
        Notify("TARGETING", "This account is protected and cannot be selected.", YELLOW)
        return false
    end
	State.Target = target

	if not State.Target then
		updateESP(nil)
		intelAvatar.Image = ""
		intelName.Text = "No Target Selected"
		intelName.TextColor3 = TEXT_SUB
		intelHealth.Text = "HP: 0/0"
		intelDist.Text = "Distance: N/A"
		tween(hpFill, {Size = UDim2.new(0,0,1,0)}, 0.2)
		intelAdvAge.Text = "Account Age: -"
		intelAdvFriends.Text = "Friends: -"
		for _, md in ipairs(miniDashes) do
			md.avatar.Image = ""
			md.name.Text = "No Target"
			md.name.TextColor3 = TEXT_SUB
			tween(md.hpFill, {Size = UDim2.new(0,0,1,0)}, 0.2)
		end
		Internal.TargetUserId = nil
		Notify("SYSTEM", "Target lock disengaged.", DANGER)
	else
		intelName.Text = State.Target.name .. "  (@" .. State.Target.username .. ")"
		intelName.TextColor3 = TEXT_MAIN
		for _, md in ipairs(miniDashes) do
			md.name.Text = State.Target.name
			md.name.TextColor3 = ACCENT
		end

		if State.Target.kind == "PLAYER" and State.Target.player then
			Internal.TargetUserId = State.Target.player.UserId
			local targetId = State.Target.player.UserId
			task.spawn(function()
				local ok, img = pcall(function()
					return Players:GetUserThumbnailAsync(targetId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
				end)
				if ok and img and State.Target and State.Target.player
					and State.Target.player.UserId == targetId then
					intelAvatar.Image = img
					for _, md in ipairs(miniDashes) do md.avatar.Image = img end
				end
			end)
			task.spawn(function()
				intelAdvAge.Text = "Account Age: Fetching..."
				intelAdvFriends.Text = "Friends: Fetching..."
				local info = fetchAdvancedInfo(targetId)
				if State.Target and State.Target.player and State.Target.player.UserId == targetId then
					intelAdvAge.Text = "Account Age: " .. info.age
					intelAdvFriends.Text = "Friends: " .. info.friends
				end
			end)
		else
			Internal.TargetUserId = nil
			intelAvatar.Image = "rbxassetid://0"
			for _, md in ipairs(miniDashes) do md.avatar.Image = "rbxassetid://0" end
			intelAdvAge.Text = "Account Age: NPC"
			intelAdvFriends.Text = "Friends: NPC"
		end
		Notify("TARGETING", "Locked onto " .. State.Target.name, SUCCESS)
	end

	for _, data in ipairs(targetButtonData) do
		local isMatch = false
		if State.Target then
			isMatch = (State.Target.kind == "PLAYER" and State.Target.player == data.targetData.player)
				or (State.Target.kind == "NPC" and State.Target.instance == data.targetData.instance)
		end
		local rowStroke = data.btn:FindFirstChildOfClass("UIStroke")
		if isMatch then
			tween(data.btn, {BackgroundColor3 = Color3.fromRGB(38, 58, 46)}, 0.15)
			if rowStroke then rowStroke.Color = SUCCESS; rowStroke.Thickness = 1.5 end
		else
			tween(data.btn, {BackgroundColor3 = BG_ELEMENT}, 0.15)
			if rowStroke then rowStroke.Color = Color3.fromRGB(45,45,55); rowStroke.Thickness = 1 end
		end
	end
    return true
end

tClear.Activated:Connect(function() Internal.ApplyTarget(nil) end)

local targetRefreshBusy = false
Internal.RefreshTargets = function()
	if targetRefreshBusy then return end
	targetRefreshBusy = true

	local ok, targets = pcall(getTargets)
	if not ok or type(targets) ~= "table" then
		targetRefreshBusy = false
		warn("[COCA] Target refresh failed: " .. tostring(targets))
		return
	end

	for _, data in ipairs(targetButtonData) do
		if data.btn and data.btn.Parent then data.btn:Destroy() end
	end
	targetButtonData = {}

	local playerCount = 0
	for _, target in ipairs(targets) do
		if target.kind == "PLAYER" then playerCount += 1 end
	end
	playerListHeader.Text = "SERVER PLAYERS  •  " .. tostring(playerCount) .. " ONLINE"

	for _, target in ipairs(targets) do
		if targetMatches(target, tSearch.Text) then
			local rowOk, row = pcall(createTargetRow, tList, target)
			if not rowOk or not row then
				warn("[COCA] Target row error: " .. tostring(row))
			else
			table.insert(targetButtonData, {btn = row, targetData = target})
			if State.Target then
				local match = (State.Target.kind == "PLAYER" and State.Target.player == target.player)
					or (State.Target.kind == "NPC" and State.Target.instance == target.instance)
				if match then
					row.BackgroundColor3 = Color3.fromRGB(38,58,46)
					local s = row:FindFirstChildOfClass("UIStroke")
					if s then s.Color = SUCCESS; s.Thickness = 1.5 end
				end
				end
			end
		end
	end
	targetRefreshBusy = false
end

tSearch:GetPropertyChangedSignal("Text"):Connect(Internal.RefreshTargets)

--============================================================
-- 2. TARGET WHITELIST
--============================================================
titleHeader(tabs.Whitelist, "🛡️ IMMUNITY WHITELIST")
createMiniDash(tabs.Whitelist)

header(tabs.Whitelist, "ADD SECURE USER")
local wInput = input(tabs.Whitelist, "Enter exact username...", 40, true)
local wAddBtn = button(tabs.Whitelist, "➕ ADD TO WHITELIST")

header(tabs.Whitelist, "ACTIVE WHITELIST")
local wList = Instance.new("Frame")
wList.BackgroundTransparency = 1
wList.Size = UDim2.new(1, 0, 0, 0)
wList.Parent = tabs.Whitelist
local wListLayout = Instance.new("UIListLayout")
wListLayout.Padding = UDim.new(0, 10)
wListLayout.Parent = wList
wListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() 
	wList.Size = UDim2.new(1, 0, 0, wListLayout.AbsoluteContentSize.Y) 
end)

local wData = {}
Internal.RefreshImmunityList = function()
	for _, btn in ipairs(wData) do btn:Destroy() end
	wData = {}
	for name, _ in pairs(State.WhitelistedPlayers) do
		local b = button(wList, "  🛡️ " .. name)
		b.TextXAlignment = Enum.TextXAlignment.Left
		b.TextColor3 = SUCCESS
		local xBtn = Instance.new("TextButton")
		xBtn.Size = UDim2.new(0, 38, 0, 38)
		xBtn.Position = UDim2.new(1, -38, 0, 0)
		xBtn.BackgroundTransparency = 1
		xBtn.Text = "X"
		xBtn.TextColor3 = DANGER
		xBtn.Font = Enum.Font.GothamBold
		xBtn.TextSize = 14
		xBtn.Parent = b
		xBtn.Activated:Connect(function() 
			State.WhitelistedPlayers[name] = nil
			Notify("WHITELIST", name .. " immunity revoked.", DANGER)
			Internal.RefreshImmunityList()
			Internal.RefreshTargets() 
		end)
		table.insert(wData, b)
	end
	for username, vip in pairs(VIP_USERNAMES) do
		local p = Players:FindFirstChild(username)
		local roleRow = Instance.new("Frame")
		roleRow.Size = UDim2.new(1, 0, 0, 52)
		roleRow.BackgroundColor3 = BG_ELEMENT
		roleRow.Parent = wList
		Instance.new("UICorner", roleRow).CornerRadius = UDim.new(0, 10)
		local rs = Instance.new("UIStroke", roleRow)
		rs.Color = vip.tier == 3 and YELLOW or GRAD_2
		rs.Thickness = vip.tier == 3 and 2 or 1.2
		local av = Instance.new("ImageLabel")
		av.Size = UDim2.new(0, 40, 0, 40)
		av.Position = UDim2.new(0, 6, 0.5, -20)
		av.BackgroundTransparency = 1
		av.Parent = roleRow
		Instance.new("UICorner", av).CornerRadius = UDim.new(1, 0)
		task.spawn(function()
			local uid = p and p.UserId
			if not uid then
				pcall(function() uid = Players:GetUserIdFromNameAsync(username) end)
			end
			if uid then
				local ok, img = pcall(function() return Players:GetUserThumbnailAsync(uid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100) end)
				if ok and img and av.Parent then av.Image = img end
			end
		end)
		local crown = Instance.new("TextLabel")
		crown.BackgroundTransparency = 1
		crown.Text = vip.icon
		crown.TextSize = vip.tier == 3 and 20 or 16
		crown.TextColor3 = vip.tier == 3 and YELLOW or GRAD_2
		crown.Font = Enum.Font.GothamBlack
		crown.Size = UDim2.new(0, 28, 0, 28)
		crown.Position = UDim2.new(1, -34, 0.5, -14)
		crown.Visible = State.Badges.ShowRoleBadges
		crown.Parent = roleRow
		local roleText = Instance.new("TextLabel")
		roleText.BackgroundTransparency = 1
		roleText.Text = vip.role .. "  @" .. username
		roleText.TextSize = 11
		roleText.TextColor3 = vip.tier == 3 and YELLOW or TEXT_MAIN
		roleText.Font = Enum.Font.GothamBlack
		roleText.Size = UDim2.new(1, -56, 1, 0)
		roleText.Position = UDim2.new(0, 52, 0, 0)
		roleText.TextXAlignment = Enum.TextXAlignment.Left
		roleText.Parent = roleRow
		table.insert(wData, roleRow)
	end
	if State.Target and State.Target.kind == "PLAYER" and State.Target.player and isProtectedPlayer(State.Target.player) then
		Internal.ApplyTarget(nil)
		if State.Moves.Running then Internal.StopMoves() end
	end
	Internal.RefreshTargets()
end

wAddBtn.Activated:Connect(function()
	local targetName = string.lower(wInput.Text)
	if targetName ~= "" then
		if VIP_USERNAMES[targetName] then
			if VIP_USERNAMES[targetName].tier == 3 then
				Notify("WHITELIST", "Supreme Owner is already protected.", YELLOW)
			else
				Notify("WHITELIST", "Premium Guest remains targetable; no immunity was added.", YELLOW)
			end
			wInput.Text = ""
			return
		end
		State.WhitelistedPlayers[targetName] = true
		wInput.Text = ""
		Notify("WHITELIST", targetName .. " is now globally immune.", SUCCESS)
		Internal.RefreshImmunityList() 
	end
end)

--============================================================
-- 3. MOVES TAB
--============================================================
titleHeader(tabs.Moves, "⚡ TROLL ENGINE")
createMiniDash(tabs.Moves)

header(tabs.Moves, "EXECUTION STANCE")
createGridRadioGroup(tabs.Moves, {"Facebang", "Hipbang", "Close Contact", "Headsit", "Orbit", "Mount", "Tornado", "Fling", "Void Send", "Stomp", "Spin", "Attach", "Glitch", "Pat"}, State.Moves.Mode, function(sel) 
	State.Moves.Mode = sel 
end)

header(tabs.Moves, "ENGINE SETTINGS")
createDirectStepper(tabs.Moves, "Proximity (Studs)", 0.0, 30.0, State.Moves, "Distance")
createDirectStepper(tabs.Moves, "Thrust Speed", 5, 300, State.Moves, "Speed")
header(tabs.Moves, "PAT PROCEDURAL MOTION")
createDirectStepper(tabs.Moves, "Pat Speed", 1, 30, State.Pat, "Speed")
createDirectStepper(tabs.Moves, "Torso Bob", 0.0, 1.0, State.Pat, "TorsoBob")
createDirectStepper(tabs.Moves, "Hip Sway", 0.0, 1.0, State.Pat, "HipSway")
createDirectStepper(tabs.Moves, "Head Jitter", 0.0, 1.0, State.Pat, "HeadJitter")
createDirectStepper(tabs.Moves, "Pat Smoothness", 0.01, 1.0, State.Pat, "Smoothness")
createDirectStepper(tabs.Moves, "Sway Speed", 0.05, 5.0, State.Pat, "SwaySpeed")
createDirectStepper(tabs.Moves, "Head Bob Speed", 0.05, 10.0, State.Pat, "HeadBobSpeed")
createDirectStepper(tabs.Moves, "Head Bob Angle", 0.0, 1.0, State.Pat, "HeadBobAngle")
createDirectStepper(tabs.Moves, "Motion Intensity", 0.0, 3.0, State.Pat, "Intensity")
createDeepHatController(tabs.Moves)

header(tabs.Moves, "FLOATING QUICK TROLL BAR")
createToggle(tabs.Moves, "Show Quick Troll Bar", State.QuickBar, "Enabled", function()
    updateQuickBarVisuals()
end)
createToggle(tabs.Moves, "Auto-Acquire Nearest Target", State.Moves, "AutoAcquire", function(isOn)
    Notify("AUTO TARGET", isOn and "Nearest valid target will be acquired when none is selected." or "Manual target selection only.", isOn and SUCCESS or YELLOW)
end)

local quickModeOrder = {
    "Pat", "Headsit", "Facebang", "Hipbang", "Close Contact", "Orbit",
    "Mount", "Tornado", "Fling", "Void Send", "Stomp", "Spin", "Attach", "Glitch"
}
for _, mode in ipairs(quickModeOrder) do
    createToggle(tabs.Moves, "Quick: " .. mode, State.QuickBar.Modes, mode, function()
        updateQuickBarVisuals()
    end)
end

createDirectStepper(tabs.Moves, "Ping Comp (ms)", 0, 500, State, "PingComp")

local movesStart = button(tabs.Moves, "⚡ INITIATE TROLL", true)

Internal.StartMoves = function(fromQuickBar)
    if State.Moves.Running then
        -- A quick-bar press on another mode switches immediately without
        -- leaving the player stuck in the previous controller.
        if fromQuickBar then
            PatMotion:Stop()
            State.Moves.TargetLostAt = nil
        else
            Internal.StopMoves()
            return false
        end
    end

    if not State.Target and State.Moves.AutoAcquire then
        local acquired = false
        if targetAcquireCooldownReady() then
            local candidate, distance = findNearestValidTarget()
            if candidate and Internal.ApplyTarget then
                Internal.ApplyTarget(candidate)
                acquired = true
                if fromQuickBar then
                    Notify("AUTO TARGET", "Nearest target: " .. candidate.name .. " (" .. math.floor(distance + 0.5) .. " studs)", SUCCESS)
                end
            end
        end
        if not acquired then
            Notify("TROLL ENGINE", "No valid nearby target found.", DANGER)
            return false
        end
    end

    local tr = getTargetRoot()
    if not tr and State.Target and State.Target.kind == "PLAYER" and State.Target.player then
        local liveChar = State.Target.player.Character
        local liveRoot = resolveCharacterRoot(liveChar)
        if liveRoot then
            State.Target.instance = liveChar
            tr = liveRoot
        end
    end

    local myChar = LP.Character
    local myH = myChar and hum(myChar)
    if not tr or not myH then
        Notify("ERROR", "Target character is not ready yet. Auto-target will retry when available.", DANGER)
        return false
    end

    myH.PlatformStand = true
    myH.Sit = false
    State.Moves.TargetLostAt = nil
    State.Moves.LastAutoAcquire = os.clock()
    pcall(function() myChar:PivotTo(tr.CFrame) end)

    State.Moves.Running = true
    movesStart.Text = "■ ABORT TROLL"
    updateQuickBarVisuals()
    Notify("TROLL ENGINE", State.Moves.Mode .. " engaged.", SUCCESS)
    return true
end

Internal.StopMoves = function()
	State.Moves.Running = false
	PatMotion:Stop()
	State.Moves.TargetLostAt = nil
	local char = LP.Character
	if char then 
		local humanoid = hum(char)
		if humanoid then
			humanoid.AutoRotate = true
			humanoid.PlatformStand = false
			humanoid.Sit = false
		end
		for _, part in ipairs(char:GetDescendants()) do 
			if part:IsA("BasePart") then 
				part.CanCollide = true
				part.Massless = false 
			end 
		end
		local moveRoot = root(char)
		if moveRoot then
			moveRoot.AssemblyLinearVelocity = Vector3.zero
			moveRoot.AssemblyAngularVelocity = Vector3.zero
		end
		for _, joint in ipairs(char:GetDescendants()) do
			if joint:IsA("Motor6D") then
				joint.Transform = CFrame.identity
			end
		end
	end
	movesStart.Text = "⚡ INITIATE TROLL"
    updateQuickBarVisuals()
	Notify("TROLL ENGINE", "Sequence aborted. Physics restored.", DANGER)
end

movesStart.Activated:Connect(function()
    if State.Moves.Running then
        Internal.StopMoves()
    else
        Internal.StartMoves(false)
    end
end)

--============================================================
-- 4. AUTOMATIC 30-SECOND REVERSE
--============================================================
titleHeader(tabs.Moves, "↶ 30-SECOND REVERSE")
header(tabs.Moves, "AUTOMATIC MOVEMENT MEMORY")

local reverseStatus = Instance.new("TextLabel")
reverseStatus.Size = UDim2.new(1, 0, 0, 34)
reverseStatus.BackgroundTransparency = 1
reverseStatus.Text = "MEMORY: 0.0s / 30.0s  •  AUTO RECORDING"
reverseStatus.TextColor3 = TEXT_SUB
reverseStatus.Font = Enum.Font.GothamMedium
reverseStatus.TextSize = 11
reverseStatus.Parent = tabs.Moves

local reversePlayBtn = button(tabs.Moves, "↶ REVERSE LAST 30S", true)
reversePlayBtn.Activated:Connect(function()
    reversePlayOnce()
    if State.Reverse.Playing then
        reversePlayBtn.Text = "■ STOP REVERSE"
    else
        reversePlayBtn.Text = "↶ REVERSE LAST 30S"
    end
end)

local reverseLoopToggle = createToggle(tabs.Moves, "Repeat Reverse Playback", State.Reverse, "Loop", function(isOn)
    if isOn then
        Notify("REVERSE", "Reverse history will repeat.", SUCCESS)
    else
        Notify("REVERSE", "Repeat disabled.", YELLOW)
    end
end)

local reverseClearBtn = button(tabs.Moves, "CLEAR MOVEMENT MEMORY")
reverseClearBtn.Activated:Connect(function()
    reverseClear()
    reversePlayBtn.Text = "↶ REVERSE LAST 30S"
    Notify("REVERSE", "30-second movement memory cleared.", DANGER)
end)

local reverseStatusConn = RunService.Heartbeat:Connect(function()
    local count = #State.Reverse.Buffer
    local seconds = math.min(State.Reverse.MaxSeconds, math.max(0, count - 1) * State.Reverse.SampleRate)
    local mode = State.Reverse.Playing and "REPLAYING BACKWARD" or "AUTO RECORDING"
    reverseStatus.Text = string.format("MEMORY: %.1fs / 30.0s  •  %s", seconds, mode)
    if not State.Reverse.Playing and reversePlayBtn.Text == "■ STOP REVERSE" then
        reversePlayBtn.Text = "↶ REVERSE LAST 30S"
    end
end)

--============================================================
-- 4. COCA FILLING (COMPACT FLING ENGINE)
--============================================================
titleHeader(tabs.Filling, "🧪 COCA FILLING")
createMiniDash(tabs.Filling)

header(tabs.Filling, "FLING ENGINE")
local fillingStart = button(tabs.Filling, "▶ START COCA FLING", true)
createToggle(tabs.Filling, "Auto-Fling On Rejoin", State.Filling, "AutoRejoin", function(isOn)
    if not isOn then State.Filling.RejoinUserId = nil end
end)

local cocaOrbitAngle = 0
local cocaFlingConn = nil
local cocaSeatConn = nil

local function stopCocaFling()
	State.Filling.Running = false
    if not State.Filling.AutoRejoin then State.Filling.RejoinUserId = nil end
	fillingStart.Text = "▶ START COCA FLING"
	Notify("COCA FILLING", "Fling aborted.", DANGER)
	if cocaFlingConn then cocaFlingConn:Disconnect(); cocaFlingConn = nil end
	if cocaSeatConn then cocaSeatConn:Disconnect(); cocaSeatConn = nil end
	local c = LP.Character
	if c then 
		local mh = hum(c)
		if mh then mh.PlatformStand = false end
		for _,p in ipairs(c:GetDescendants()) do 
			if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then 
				pcall(function() p.CanCollide = true end) 
			end 
		end 
	end
end

fillingStart.Activated:Connect(function()
	if State.Filling.Running then stopCocaFling(); return end
	if not State.Target then Notify("ERROR", "No target selected.", DANGER); return end
	local tr = getTargetRoot()
	local mr = root(LP.Character)
	if not tr or not mr then Notify("ERROR", "Target not found.", DANGER); return end
	
	State.Filling.Running = true
    State.Filling.RejoinUserId = (State.Target and State.Target.kind == "PLAYER" and State.Target.player and State.Target.player.UserId) or nil
	fillingStart.Text = "■ ABORT COCA FLING"
	cocaOrbitAngle = 0
	Notify("COCA FILLING", "Compact Fling Initiated.", SUCCESS)
	
	local c = LP.Character
	local mh = hum(c)
	if mh then mh.PlatformStand = true; mh.Sit = false end
	
	cocaSeatConn = RunService.Heartbeat:Connect(function()
		local h = hum(LP.Character)
		if h and h.Sit then h.Sit = false; h.PlatformStand = true end
		local rp = root(LP.Character)
		if rp then 
			for _,w in ipairs(rp:GetChildren()) do 
				if w:IsA("Weld") and w.Part1 and w.Part1:IsA("Seat") then w:Destroy() end 
			end 
		end
	end)
	
	cocaFlingConn = RunService.RenderStepped:Connect(function(dt)
		if not State.Filling.Running then return end
		local liveTargetRoot = getTargetRoot()
		local liveMyRoot = root(LP.Character)
		if not liveTargetRoot or not liveMyRoot then return end
		cocaOrbitAngle = cocaOrbitAngle + (dt * 45)
		local tp = liveTargetRoot.Position
		local op = tp + Vector3.new(math.cos(cocaOrbitAngle)*2.2, 1.2 + math.sin(cocaOrbitAngle*2)*0.4, math.sin(cocaOrbitAngle)*2.2)
		liveMyRoot.CFrame = CFrame.new(op, tp)
		liveMyRoot.AssemblyLinearVelocity = (op - liveMyRoot.Position) * 80
		liveMyRoot.AssemblyAngularVelocity = Vector3.new(math.random(-600,600), math.random(-600,600), math.random(-600,600))
	end)
end)

Players.PlayerAdded:Connect(function(p)
    task.wait(0.3)
    Internal.RefreshTargets()

    if State.Filling.AutoRejoin and State.Filling.RejoinUserId and p.UserId == State.Filling.RejoinUserId
        and not isProtectedPlayer(p) then
        task.spawn(function()
            local tries = 0
            repeat
                task.wait(0.5)
                tries += 1
            until (p.Character and resolveCharacterRoot(p.Character)) or tries > 20

            if not (p.Character and resolveCharacterRoot(p.Character)) then
                Notify("COCA FILLING", "Target rejoined but did not spawn in time.", DANGER)
                return
            end

            Internal.ApplyTarget({
                kind = "PLAYER",
                player = p,
                instance = p.Character,
                name = p.DisplayName ~= "" and p.DisplayName or p.Name,
                username = p.Name,
                protected = false
            })
            Notify("COCA FILLING", "Target rejoined. Resuming fling...", YELLOW)

            if not State.Filling.Running then
                State.Filling.Running = true
                State.Filling.RejoinUserId = p.UserId
                fillingStart.Text = "■ ABORT COCA FLING"
                cocaOrbitAngle = 0
                local c = LP.Character
                local mh = hum(c)
                if mh then mh.PlatformStand = true; mh.Sit = false end

                if cocaFlingConn then cocaFlingConn:Disconnect() end
                cocaFlingConn = RunService.RenderStepped:Connect(function(dt)
                    if not State.Filling.Running then return end
                    local tr = getTargetRoot()
                    local mr = root(LP.Character)
                    if not tr or not mr then return end
                    cocaOrbitAngle += dt * 45
                    local tp = tr.Position
                    local op = tp + Vector3.new(math.cos(cocaOrbitAngle) * 2.2, 1.2 + math.sin(cocaOrbitAngle * 2) * 0.4, math.sin(cocaOrbitAngle) * 2.2)
                    mr.CFrame = CFrame.new(op, tp)
                    mr.AssemblyLinearVelocity = (op - mr.Position) * 80
                    mr.AssemblyAngularVelocity = Vector3.new(math.random(-600, 600), math.random(-600, 600), math.random(-600, 600))
                end)
            end
        end)
    end
end)

--============================================================
-- 5. CHAT SPAMMER
--============================================================
titleHeader(tabs.Chat, "💬 CHAT SPAMMER")
createMiniDash(tabs.Chat)

header(tabs.Chat, "MESSAGE OVERRIDE")
local chatMessage = input(tabs.Chat, "Enter message to send...", 60, false)
chatMessage.MultiLine = true

local chatMode = "ALL"
local chatModeBtn = button(tabs.Chat, "◎ SEND TO ALL")
chatModeBtn.Activated:Connect(function()
    if chatMode == "ALL" then
        chatMode = "TARGET"
        chatModeBtn.Text = "◎ WHISPER TARGET"
    else
        chatMode = "ALL"
        chatModeBtn.Text = "◎ SEND TO ALL"
    end
end)
chatMessage.TextWrapped = true
chatMessage.TextYAlignment = Enum.TextYAlignment.Top

header(tabs.Chat, "DELAY TIMER")
createDirectStepper(tabs.Chat, "Seconds Delay", 0.1, 10.0, State.Chat, "Delay")

local chatStart = button(tabs.Chat, "▶ START SPAM")
chatStart.Activated:Connect(function()
	if State.Chat.Running then 
		State.Chat.Running = false
		chatStart.Text = "▶ START SPAM"
		tween(chatStart, {BackgroundColor3 = BG_ELEMENT})
		Notify("CHAT", "Spammer disengaged.", DANGER)
	else
		State.Chat.Running = true
		chatStart.Text = "■ STOP SPAM"
		tween(chatStart, {BackgroundColor3 = DANGER})
		Notify("CHAT", "Spammer running (Bypass Active).", SUCCESS)
		task.spawn(function()
			local tcs = game:GetService("TextChatService")
			local rep = game:GetService("ReplicatedStorage")
			while State.Chat.Running do
				local text = chatMessage.Text
				if text == "" then text = "GG!" end

				if chatMode == "TARGET" then
					if State.Target and State.Target.kind == "PLAYER" and State.Target.player and State.Target.player.Parent then
						text = "/w " .. State.Target.player.Name .. " " .. text
					else
						Notify("CHAT", "Whisper mode needs a player target. Switching to SEND TO ALL.", YELLOW)
						chatMode = "ALL"
						chatModeBtn.Text = "◎ SEND TO ALL"
					end
				end

				local bypass = ""
				for i = 1, math.random(1, 4) do bypass = bypass .. "\226\128\139" end
				local finalText = text .. bypass
				pcall(function()
					if tcs.ChatVersion == Enum.ChatVersion.TextChatService then 
						local channel = tcs.TextChannels:FindFirstChild("RBXGeneral")
						if channel then channel:SendAsync(finalText) end
					else 
						local events = rep:FindFirstChild("DefaultChatSystemChatEvents")
						if events and events:FindFirstChild("SayMessageRequest") then 
							events.SayMessageRequest:FireServer(finalText, "All") 
						end 
					end
				end)
				task.wait(math.max(0.1, tonumber(State.Chat.Delay) or 1.5))
			end
		end)
	end
end)

--============================================================
-- 6. LIVE ANIMATION SYNC
--============================================================
titleHeader(tabs.Anim, "👁 LIVE ANIM SYNC")
createMiniDash(tabs.Anim)

header(tabs.Anim, "ANIMATION COPY & LIVE SYNC")

local activeCopiedTracks = {}

local function clearTracks()
	for sourceTrack, cache in pairs(activeCopiedTracks) do
		pcall(function()
			if cache.mTrack then cache.mTrack:Stop(0.08); cache.mTrack:Destroy() end
			if cache.animObj then cache.animObj:Destroy() end
		end)
	end
	table.clear(activeCopiedTracks)
end

local function syncCopiedTrack(sourceTrack, targetAnimator)
	if not sourceTrack or not sourceTrack.Animation then return nil end
	local animationId = sourceTrack.Animation.AnimationId
	if animationId == nil or animationId == "" then return nil end

	local cache = activeCopiedTracks[sourceTrack]
	if not cache or not cache.mTrack or cache.mTrack.Parent == nil then
		local animObj = Instance.new("Animation")
		animObj.AnimationId = animationId
		local ok, mTrack = pcall(function() return targetAnimator:LoadAnimation(animObj) end)
		if not ok or not mTrack then
			animObj:Destroy()
			return nil
		end
		mTrack.Looped = sourceTrack.Looped
		mTrack.Priority = sourceTrack.Priority
		mTrack:Play(0.08, math.clamp(sourceTrack.WeightCurrent or 1, 0, 1), sourceTrack.Speed or 1)
		cache = { mTrack = mTrack, animObj = animObj, animationId = animationId }
		activeCopiedTracks[sourceTrack] = cache
	end

	local mTrack = cache.mTrack
	pcall(function() mTrack.Looped = sourceTrack.Looped end)
	pcall(function() mTrack.Priority = sourceTrack.Priority end)
	pcall(function() mTrack:AdjustSpeed(sourceTrack.Speed or 1) end)
	pcall(function() mTrack:AdjustWeight(math.clamp(sourceTrack.WeightCurrent or 1, 0, 1), 0.05) end)
	pcall(function()
		if math.abs((mTrack.TimePosition or 0) - (sourceTrack.TimePosition or 0)) > 0.12 then
			mTrack.TimePosition = sourceTrack.TimePosition
		end
	end)
	return cache
end

LP.CharacterAdded:Connect(function(newChar)
	clearTracks()
	State.Emotes.Track = nil
	State.Emotes.OriginalAnimate = nil
	task.defer(function()
		if State.Anim.TrackSync then
			local animate = newChar:FindFirstChild("Animate")
			if animate then animate.Disabled = true end
		end
	end)
end)

createToggle(tabs.Anim, "Sync Server Animations", State.Anim, "TrackSync", function(isOn)
	local char = LP.Character
	local animate = char and char:FindFirstChild("Animate")
	if isOn then
        if not State.Target and State.Moves.AutoAcquire then
            local candidate = findNearestValidTarget()
            if candidate and Internal.ApplyTarget then
                Internal.ApplyTarget(candidate)
            end
        end
		if animate then animate.Disabled = true end
		clearAllEmoteTracks()
		Notify("ANIMATION", "Server sync engaged.", SUCCESS)
	else 
		if animate then animate.Disabled = false end
		clearTracks()
		Notify("ANIMATION", "Local animations restored.", DANGER) 
	end
end)

local copyNow = button(tabs.Anim, "⧉ COPY CURRENT TARGET ANIMATIONS")
copyNow.Activated:Connect(function()
    if not State.Target and State.Moves.AutoAcquire then
        local candidate, distance = findNearestValidTarget()
        if candidate and Internal.ApplyTarget then
            Internal.ApplyTarget(candidate)
            Notify("AUTO TARGET", "Using nearest target for animation copy: " .. candidate.name .. " (" .. math.floor(distance + 0.5) .. " studs)", SUCCESS)
        end
    end
	local targetChar = getTargetChar()
	local myChar = getCharacter()
	if not targetChar or not myChar then
		Notify("ANIMATION", "No valid spawned target is available for animation copy.", DANGER)
		return
	end
	local targetAnimator = hum(targetChar) and hum(targetChar):FindFirstChildOfClass("Animator")
	local myAnimator = getAnimator(myChar)
	if not targetAnimator or not myAnimator then
		Notify("ANIMATION", "Animator is not available yet.", DANGER)
		return
	end
	local copied = 0
	for _, sourceTrack in ipairs(targetAnimator:GetPlayingAnimationTracks()) do
		if sourceTrack.IsPlaying and sourceTrack.Animation and sourceTrack.Animation.AnimationId ~= "" then
			if syncCopiedTrack(sourceTrack, myAnimator) then copied += 1 end
		end
	end
	if copied > 0 then
		Notify("ANIMATION", "Copied " .. tostring(copied) .. " active target animation(s).", SUCCESS)
	else
		Notify("ANIMATION", "No copyable target animations are playing.", YELLOW)
	end
end)

createToggle(tabs.Anim, "Follow Target Lock", State.Anim, "Follow", function(isOn) 
	if isOn then Notify("MOVEMENT", "Anchor lock engaged.", SUCCESS) 
	else Notify("MOVEMENT", "Anchor lock disengaged.", DANGER) end 
end)

header(tabs.Anim, "360° ANCHOR POSITIONING")
createCyclicStepper(tabs.Anim, "Anchor Side", {"Right", "Left", "Front", "Back"}, State.Anim, "Side")
createDirectStepper(tabs.Anim, "Distance (Studs)", 0.0, 30.0, State.Anim, "Distance")

local animStop = button(tabs.Anim, "■ ABORT ALL SYNC HACKS"); animStop.TextColor3 = DANGER
animStop.Activated:Connect(function() 
	State.Anim.TrackSync = false
	State.Anim.Follow = false
	local char = LP.Character
	local animate = char and char:FindFirstChild("Animate")
	if animate then animate.Disabled = false end
	clearTracks()
	showTab(tabs.Anim)
	Notify("ANIMATION", "All overrides aborted.", DANGER) 
end)

--============================================================
-- 7. EMOTE HUB (CLEAN SELECTION & DESELECTION)
--============================================================
titleHeader(tabs.Emotes, "✨ EMOTE & PACK HUB")
createMiniDash(tabs.Emotes)

local emoteStop = button(tabs.Emotes, "■ STOP ANIMATION")
emoteStop.TextColor3 = DANGER
tween(emoteStop, {BackgroundColor3 = Color3.fromRGB(40, 15, 15)})

header(tabs.Emotes, "SEARCH LIBRARY")
local emoteSearch = input(tabs.Emotes, "Search animations...", 40, true)

local emoteList = Instance.new("Frame")
emoteList.BackgroundTransparency = 1
emoteList.Size = UDim2.new(1, 0, 0, 0)
emoteList.Parent = tabs.Emotes
local eListLayout = Instance.new("UIListLayout")
eListLayout.Padding = UDim.new(0, 8)
eListLayout.Parent = emoteList
eListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() 
	emoteList.Size = UDim2.new(1, 0, 0, eListLayout.AbsoluteContentSize.Y) 
end)

local EMOTES = {
	-- Movement packs
	{"Pack - DEFAULT (Reset)", "Pack", idle = "507766951", walk = "507777826", run = "507767714", jump = "507765000", fall = "507767968"},
	{"Pack - Zombie", "Pack", idle = "616158929", walk = "616168032", run = "616163682", jump = "616161112", fall = "616157476"},
	{"Pack - Vampire", "Pack", idle = "1083445855", walk = "1083473930", run = "1083462077", jump = "1083466542", fall = "1083443587"},
	{"Pack - Superhero", "Pack", idle = "782841498", walk = "782843345", run = "782842708", jump = "782847020", fall = "782846423"},
	-- Classic emotes
	{"Dance 1", "Emote", id = "507771019"},
	{"Dance 2", "Emote", id = "507776043"},
	{"Dance 3", "Emote", id = "507777268"},
	{"Laugh", "Emote", id = "507770818"},
	{"Cheer", "Emote", id = "507770677"},
	{"Point", "Emote", id = "507770453"},
	{"Wave", "Emote", id = "507770239"},
	{"Floss", "Emote", id = "582855105"},
	{"Tilt", "Emote", id = "3360692915"},
	{"Salute", "Emote", id = "3360689775"},
	{"Shrug", "Emote", id = "3334392772"},
	{"Applaud", "Emote", id = "5915779043"},
	{"Stadium", "Emote", id = "3360686498"},
	{"Monkey", "Emote", id = "3716636630"},
	{"Fancy Feet", "Emote", id = "3333432454"},
	{"Oldschool Dance", "Emote", id = "10714340543"},
	{"Rock On", "Emote", id = "5918726674"},
	{"Cha Cha", "Emote", id = "6862001786"},
	{"Line Dance", "Emote", id = "4049037604"},
	{"Top Rock", "Emote", id = "5915712534"},
	{"Flare", "Emote", id = "5915773999"},
	{"Breakdance", "Emote", id = "5915776835"},
	{"Hype Dance", "Emote", id = "3696759792"},
	{"Hero Landing", "Emote", id = "5104377791"},
	{"Old Dance", "Emote", id = "507771955"},
	{"Laugh 2", "Emote", id = "507770818"},
	{"Point 2", "Emote", id = "507770453"},
}


local emoteEntries = {}

local function resetEmoteSelectionUI()
	if selectedEmoteBtn then
		local s = selectedEmoteBtn:FindFirstChildOfClass("UIStroke")
		tween(selectedEmoteBtn, {BackgroundColor3 = BG_ELEMENT}, 0.2)
		if s then tween(s, {Color = Color3.fromRGB(45, 45, 55)}, 0.2) end
		selectedEmoteBtn = nil
	end
end

local function playEmote(id, btnObj)
	local char = getCharacter()
	local animator = getAnimator(char)
	if not animator then return end
	
	clearAllEmoteTracks()
	resetEmoteSelectionUI()
	
	if btnObj then
		selectedEmoteBtn = btnObj
		local s = btnObj:FindFirstChildOfClass("UIStroke")
		tween(btnObj, {BackgroundColor3 = Color3.fromRGB(40, 70, 45)}, 0.2)
		if s then tween(s, {Color = SUCCESS}, 0.2) end
	end
	
	local animation = Instance.new("Animation")
	animation.AnimationId = "rbxassetid://" .. id
	local ok, track = pcall(function() return animator:LoadAnimation(animation) end)
	animation:Destroy()
	
	if ok and track then 
		State.Emotes.Track = track
		track.Priority = Enum.AnimationPriority.Action4
		track.Looped = false
		track:Play(0.1, 1, 1)
		track.Stopped:Connect(function()
			if State.Emotes.Track == track then
				State.Emotes.Track = nil
				resetEmoteSelectionUI()
			end
		end)
		Notify("EMOTE", "Playing animation.", SUCCESS) 
	else
		Notify("EMOTE", "Animation could not be loaded in this client.", DANGER)
	end
end

local function saveOriginalAnimate(animate)
	if not animate or State.Emotes.OriginalAnimate then return end
	State.Emotes.OriginalAnimate = {}
	for _, stateName in ipairs({"idle", "walk", "run", "jump", "fall"}) do
		local state = animate:FindFirstChild(stateName)
		if state then
			State.Emotes.OriginalAnimate[stateName] = {}
			for _, obj in ipairs(state:GetChildren()) do
				if obj:IsA("Animation") then
					table.insert(State.Emotes.OriginalAnimate[stateName], {obj = obj, id = obj.AnimationId})
				end
			end
		end
	end
end

local function restoreOriginalAnimate(animate)
	local saved = State.Emotes.OriginalAnimate
	if not animate or not saved then return end
	for stateName, entries in pairs(saved) do
		for _, entry in ipairs(entries) do
			if entry.obj and entry.obj.Parent then entry.obj.AnimationId = entry.id end
		end
	end
	State.Emotes.OriginalAnimate = nil
	State.Emotes.Pack = nil
end

local function equipPack(packData, btnObj)
	State.Emotes.Pack = packData
	local char = getCharacter()
	local animate = char and char:FindFirstChild("Animate")
	if not animate then return end
	saveOriginalAnimate(animate)
	
	clearAllEmoteTracks()
	resetEmoteSelectionUI()
	
	if btnObj then
		selectedEmoteBtn = btnObj
		local s = btnObj:FindFirstChildOfClass("UIStroke")
		tween(btnObj, {BackgroundColor3 = Color3.fromRGB(40, 70, 45)}, 0.2)
		if s then tween(s, {Color = SUCCESS}, 0.2) end
	end
	
	local function replaceAnim(stateName, newId) 
		local state = animate:FindFirstChild(stateName)
		if state then 
			for _, obj in ipairs(state:GetChildren()) do 
				if obj:IsA("Animation") then obj.AnimationId = "rbxassetid://" .. newId end 
			end 
		end 
	end
	
	replaceAnim("idle", packData.idle)
	replaceAnim("walk", packData.walk)
	replaceAnim("run", packData.run)
	replaceAnim("jump", packData.jump)
	replaceAnim("fall", packData.fall)
	
	animate.Disabled = true
	task.wait(0.05)
	animate.Disabled = false
	
	local animator = getAnimator(char)
	if animator then 
		for _, track in ipairs(animator:GetPlayingAnimationTracks()) do 
			track:Stop() 
		end 
	end
	Notify("EMOTE", "Movement pack replaced.", SUCCESS)
end

emoteStop.Activated:Connect(function()
	clearAllEmoteTracks()
	resetEmoteSelectionUI()
	local char = LP.Character
	local animate = char and char:FindFirstChild("Animate")
	if animate then
		restoreOriginalAnimate(animate)
		animate.Disabled = false
	end
	Notify("EMOTE", "Animation halted and default movement restored.", DANGER)
end)

for _, entry in ipairs(EMOTES) do
	local b = button(emoteList, "  " .. (entry[2] == "Pack" and "❖ " or "▶ ") .. entry[1])
	b.TextXAlignment = Enum.TextXAlignment.Left
	if entry[2] == "Pack" then b.TextColor3 = YELLOW end
	b.Activated:Connect(function() 
		if entry[2] == "Emote" then 
			playEmote(entry.id, b) 
		else 
			equipPack(entry, b) 
		end 
	end)
	table.insert(emoteEntries, { Button = b, Search = string.lower(entry[1]) })
end

emoteSearch:GetPropertyChangedSignal("Text"):Connect(function() 
	local query = string.lower(emoteSearch.Text)
	for _, entry in ipairs(emoteEntries) do 
		entry.Button.Visible = string.find(entry.Search, query, 1, true) ~= nil 
	end 
end)

--============================================================
-- 8. MOVEMENT HACKS
--============================================================
titleHeader(tabs.Movement, "🚀 MOVEMENT GOD-MODE")
createMiniDash(tabs.Movement)

header(tabs.Movement, "PHYSICS OVERRIDES")
createToggle(tabs.Movement, "Noclip (Walk Through Walls)", State.Movement, "Noclip")
createToggle(tabs.Movement, "Infinite Jump (Hold Space)", State.Movement, "InfJump")

header(tabs.Movement, "SPEED OVERRIDE")
createToggle(tabs.Movement, "Enable Custom Speed", State.Movement, "SpeedEnabled")
createDirectStepper(tabs.Movement, "Walk Speed", 16, 500, State.Movement, "WalkSpeed")

header(tabs.Movement, "CINEMATIC FLIGHT")
local flyAnimInstance = Instance.new("Animation")
flyAnimInstance.AnimationId = "rbxassetid://3541114300"
local flyTrack = nil

local function toggleFlight(isOn)
	local char = getCharacter()
	local h = hum(char)
	local r = root(char)
	if not char or not h or not r then return end
	if isOn then 
		h.PlatformStand = true
		local animator = getAnimator(char)
		if animator then 
			pcall(function() 
				flyTrack = animator:LoadAnimation(flyAnimInstance)
				flyTrack:Play() 
			end) 
		end
		tween(r, {CFrame = r.CFrame + Vector3.new(0, 5, 0)}, 0.4)
		Notify("FLIGHT", "Anti-gravity engaged.", SUCCESS)
	else 
		h.PlatformStand = false
		if flyTrack then pcall(function() flyTrack:Stop(); flyTrack:Destroy() end); flyTrack = nil end
		local ray = workspace:Raycast(r.Position, Vector3.new(0, -500, 0))
		if ray then tween(r, {CFrame = CFrame.new(ray.Position + Vector3.new(0, 3, 0))}, 0.3) end
		Notify("FLIGHT", "Landing sequence initiated.", DANGER) 
	end
end

createToggle(tabs.Movement, "Anti-Gravity Flight", State.Movement, "FlyEnabled", function(isOn) 
	if not isOn then flyVelocity = Vector3.zero end
	toggleFlight(isOn) 
end)
createDirectStepper(tabs.Movement, "Flight Speed", 10, 500, State.Movement, "FlySpeed")

--============================================================
-- 9. SAFETY PAGE
--============================================================
titleHeader(tabs.Safety, "⚙ SYSTEM PROTECTIONS")
createMiniDash(tabs.Safety)

header(tabs.Safety, "ENVIRONMENT LOCKS")
createToggle(tabs.Safety, "Anti-Void", State.Safety, "AntiVoid", function(isOn) 
	if isOn then 
		local r = root(LP.Character)
		if r then State.Safety.SafeCFrame = r.CFrame end 
	end 
end)

local saveSafe = button(tabs.Safety, "⌖ Set Safe Teleport Point")
saveSafe.Activated:Connect(function() 
	local r = root(LP.Character)
	if r then 
		State.Safety.SafeCFrame = r.CFrame
		saveSafe.Text = "✓ Point Saved!"
		Notify("SAFETY", "Custom respawn point anchored.", SUCCESS)
		task.delay(1, function() if saveSafe.Parent then saveSafe.Text = "⌖ Set Safe Teleport Point" end end) 
	end 
end)

header(tabs.Safety, "AFK BYPASS")
createToggle(tabs.Safety, "Virtual Anti-AFK", State.Safety, "AntiAFK", function(isOn)
    if isOn then
        local getconnectionsFn = optionalGlobal("getconnections")
        if type(getconnectionsFn) == "function" then
            pcall(function()
                for _, connection in pairs(getconnectionsFn(LP.Idled)) do
                    if connection and type(connection.Disable) == "function" then
                        connection:Disable()
                    end
                end
            end)
        end
    end
end)

LP.Idled:Connect(function()
    if not State.Safety.AntiAFK or not VirtualUser then return end
    pcall(function()
        local camera = workspace.CurrentCamera
        if not camera then return end
        VirtualUser:Button2Down(Vector2.new(0, 0), camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), camera.CFrame)
    end)
end)

--============================================================
-- 10. PERFORMANCE / EXECUTOR MONITOR
--============================================================
titleHeader(tabs.Performance, "◈ PERFORMANCE CENTER")
createMiniDash(tabs.Performance)

local perfCard = Instance.new("Frame")
perfCard.Size = UDim2.new(1, 0, 0, 232)
perfCard.BackgroundColor3 = BG_ELEMENT
perfCard.BorderSizePixel = 0
perfCard.Parent = tabs.Performance
Instance.new("UICorner", perfCard).CornerRadius = UDim.new(0, 14)
local perfStroke = Instance.new("UIStroke", perfCard)
perfStroke.Color = Color3.fromRGB(45, 45, 55)
perfStroke.Thickness = 1

local perfTitle = Instance.new("TextLabel")
perfTitle.BackgroundTransparency = 1
perfTitle.Text = "LIVE CLIENT STATUS"
perfTitle.TextSize = 11
perfTitle.TextColor3 = TEXT_SUB
perfTitle.Font = Enum.Font.GothamBlack
perfTitle.Size = UDim2.new(1, -24, 0, 20)
perfTitle.Position = UDim2.new(0, 12, 0, 10)
perfTitle.TextXAlignment = Enum.TextXAlignment.Left
perfTitle.Parent = perfCard

local perfLine = Instance.new("Frame")
perfLine.Size = UDim2.new(1, -24, 0, 1)
perfLine.Position = UDim2.new(0, 12, 0, 35)
perfLine.BackgroundColor3 = Color3.fromRGB(45,45,55)
perfLine.BorderSizePixel = 0
perfLine.Parent = perfCard

local perfFPS = Instance.new("TextLabel")
perfFPS.BackgroundTransparency = 1
perfFPS.Text = "FPS  --"
perfFPS.TextSize = 18
perfFPS.TextColor3 = SUCCESS
perfFPS.Font = Enum.Font.GothamBlack
perfFPS.Size = UDim2.new(0.5, -18, 0, 32)
perfFPS.Position = UDim2.new(0, 12, 0, 50)
perfFPS.TextXAlignment = Enum.TextXAlignment.Left
perfFPS.Parent = perfCard

local perfPing = Instance.new("TextLabel")
perfPing.BackgroundTransparency = 1
perfPing.Text = "PING  --"
perfPing.TextSize = 18
perfPing.TextColor3 = YELLOW
perfPing.Font = Enum.Font.GothamBlack
perfPing.Size = UDim2.new(0.5, -18, 0, 32)
perfPing.Position = UDim2.new(0.5, 6, 0, 50)
perfPing.TextXAlignment = Enum.TextXAlignment.Right
perfPing.Parent = perfCard

local perfExecutor = Instance.new("TextLabel")
perfExecutor.BackgroundColor3 = BG_MAIN
perfExecutor.BackgroundTransparency = 0.15
perfExecutor.Text = "EXECUTOR  •  Detecting..."
perfExecutor.TextSize = 11
perfExecutor.TextColor3 = TEXT_MAIN
perfExecutor.Font = Enum.Font.GothamBold
perfExecutor.Size = UDim2.new(1, -24, 0, 34)
perfExecutor.Position = UDim2.new(0, 12, 0, 92)
perfExecutor.TextXAlignment = Enum.TextXAlignment.Center
perfExecutor.TextTruncate = Enum.TextTruncate.AtEnd
perfExecutor.Parent = perfCard
Instance.new("UICorner", perfExecutor).CornerRadius = UDim.new(0, 8)

local perfHint = Instance.new("TextLabel")
perfHint.BackgroundTransparency = 1
perfHint.Text = "Client metrics  •  refreshed twice per second"
perfHint.TextSize = 9
perfHint.TextColor3 = TEXT_SUB
perfHint.Font = Enum.Font.Gotham
perfHint.Size = UDim2.new(1, -24, 0, 22)
perfHint.Position = UDim2.new(0, 12, 0, 136)
perfHint.TextXAlignment = Enum.TextXAlignment.Center
perfHint.Parent = perfCard

local perfStatus = Instance.new("TextLabel")
perfStatus.BackgroundTransparency = 1
perfStatus.Text = "●  MONITORING ACTIVE"
perfStatus.TextSize = 9
perfStatus.TextColor3 = SUCCESS
perfStatus.Font = Enum.Font.GothamBlack
perfStatus.Size = UDim2.new(1, -24, 0, 20)
perfStatus.Position = UDim2.new(0, 12, 0, 178)
perfStatus.TextXAlignment = Enum.TextXAlignment.Center
perfStatus.Parent = perfCard

local perfHud = Instance.new("Frame")
perfHud.Name = "PerformanceHUD"
perfHud.Size = UDim2.new(0, 210, 0, 46)
perfHud.Position = UDim2.new(0, 14, 0, 14)
perfHud.BackgroundColor3 = BG_MAIN
perfHud.BackgroundTransparency = 0.08
perfHud.Visible = true
perfHud.ZIndex = 80
perfHud.Parent = gui
Instance.new("UICorner", perfHud).CornerRadius = UDim.new(0, 12)
local phStroke = Instance.new("UIStroke", perfHud)
phStroke.Color = GRAD_2
phStroke.Thickness = 1.5

local phText = Instance.new("TextLabel")
phText.BackgroundTransparency = 1
phText.Text = "FPS --   •   PING --"
phText.TextSize = 10
phText.TextColor3 = TEXT_MAIN
phText.Font = Enum.Font.GothamBlack
phText.Size = UDim2.new(1, -12, 1, 0)
phText.Position = UDim2.new(0, 6, 0, 0)
phText.TextXAlignment = Enum.TextXAlignment.Center
phText.Parent = perfHud

local perfExecutorName = getExecutorName()
perfExecutor.Text = "EXECUTOR  •  " .. perfExecutorName

-- Refreshing this display at a modest interval avoids adding unnecessary work to the
-- frame loop while still feeling live.
local perfAccum, perfFrames, perfLast = 0, 0, os.clock()
RunService.RenderStepped:Connect(function(dt)
	if not State.Unlocked then return end
	perfAccum = perfAccum + dt
	perfFrames = perfFrames + 1
	if perfAccum >= 0.5 then
		local fps = math.floor((perfFrames / perfAccum) + 0.5)
		local ping = getPingMs()
		perfFPS.Text = "FPS  " .. tostring(fps)
		perfPing.Text = "PING  " .. (ping and (tostring(ping) .. " ms") or "--")
		phText.Text = "FPS " .. tostring(fps) .. "  •  PING " .. (ping and (tostring(ping) .. "ms") or "--")
		perfFrames, perfAccum = 0, 0
	end
end)

header(tabs.Safety, "DASHBOARD OPTIONS")
createToggle(tabs.Safety, "Show Performance Tab", State.Performance, "Visible", function(isOn)
	btnPerformance.Visible = isOn
	if not isOn and activeTab == tabs.Performance then
		for _, other in pairs(tabs) do other.Visible = false end
		activeTab = nil
		tween(flyout, {Position = UDim2.new(1, -60, 0, 20), Size = UDim2.new(0, 0, 1, -40)}, 0.25, Enum.EasingStyle.Quint)
	end
end)
createToggle(tabs.Safety, "Show Performance HUD", State.Performance, "Hud", function(isOn)
	perfHud.Visible = isOn
end)
createToggle(tabs.Safety, "Show Premium Role Badges", State.Badges, "ShowRoleBadges", function()
	Internal.RefreshImmunityList()
end)

--============================================================
-- PHYSICS ENGINE (STEPPED) -> DYNAMIC SCALE OVERRIDES
--============================================================

UserInputService.JumpRequest:Connect(function() 
	if State.Movement.InfJump then 
		local char = LP.Character
		local h = hum(char)
		if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end 
	end 
end)

RunService.Heartbeat:Connect(function(dt)
	if not State.Unlocked then return end
	local char = LP.Character
	local myRoot = root(char)
	local myHum = hum(char)
	if not char or not myRoot or not myHum then return end

	-- Void Recovery
	if State.Safety.AntiVoid then 
		if myRoot.Position.Y > -40 then 
			State.Safety.SafeCFrame = myRoot.CFrame 
		elseif myRoot.Position.Y < -50 then
			if not State.Safety.SafeCFrame then 
				State.Safety.SafeCFrame = CFrame.new(0, 100, 0)
				local base = workspace:FindFirstChild("Baseplate") or workspace:FindFirstChildOfClass("SpawnLocation")
				if base then State.Safety.SafeCFrame = CFrame.new(base.Position + Vector3.new(0, 10, 0)) end
			end
			myRoot.AssemblyLinearVelocity = Vector3.zero
			myRoot.AssemblyAngularVelocity = Vector3.zero
			myRoot.CFrame = State.Safety.SafeCFrame
		end 
	end

	-- Collision Cancellation
	if State.Movement.Noclip then
		for _, p in ipairs(char:GetDescendants()) do
			if p:IsA("BasePart") then p.CanCollide = false end
		end
	else
		for _, p in ipairs(char:GetDescendants()) do
			if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.CanCollide = true end
		end
	end

	-- WalkSpeed Sync
	if State.Movement.SpeedEnabled then myHum.WalkSpeed = State.Movement.WalkSpeed end

	-- Flight Motion Loop
	if State.Movement.FlyEnabled and not State.Moves.Running and not State.Filling.Running then
		local cam = workspace.CurrentCamera
		local moveDir = Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end
		
		if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
		local targetVel = moveDir * math.max(0.1, State.Movement.FlySpeed)
		flyVelocity = flyVelocity:Lerp(targetVel, 0.15)
		if moveDir.Magnitude == 0 then 
			flyVelocity = Vector3.new(flyVelocity.X, math.sin(os.clock() * 3) * 1.5, flyVelocity.Z) 
		end
		myRoot.AssemblyLinearVelocity = flyVelocity
	end

	-- Target Verification
    if State.Moves.Running and State.Moves.AutoAcquire and not State.Target then
        autoAcquireNearestTarget(true)
    end
	local targetChar = getTargetChar()
	local targetRoot = targetChar and resolveCharacterRoot(targetChar)
	local targetHead = targetChar and targetChar:FindFirstChild("Head")

	-- Side-by-Side Anchor Tracking
	if State.Anim.Follow and targetRoot then
		pcall(function() 
			myHum.PlatformStand = true
			local dist = math.max(0.1, State.Anim.Distance)
			local pingOffset = targetRoot.AssemblyLinearVelocity * (math.clamp(State.PingComp, 0, 500) / 1000)
			local predictedPos = targetRoot.Position + pingOffset
			local flatTargetCF = flatCF(CFrame.new(predictedPos) * (targetRoot.CFrame - targetRoot.Position))
			
			local attachCF = flatTargetCF
			if State.Anim.Side == "Right" then attachCF = flatTargetCF * CFrame.new(dist, 0, 0) 
			elseif State.Anim.Side == "Left" then attachCF = flatTargetCF * CFrame.new(-dist, 0, 0) 
			elseif State.Anim.Side == "Front" then attachCF = flatTargetCF * CFrame.new(0, 0, -dist) 
			elseif State.Anim.Side == "Back" then attachCF = flatTargetCF * CFrame.new(0, 0, dist) end
			
			myRoot.CFrame = attachCF
			myRoot.AssemblyLinearVelocity = targetRoot.AssemblyLinearVelocity 
		end)
	end

	-- Master Troll Execution Pipeline
	if State.Moves.Running then
		if not targetRoot then
			local liveChar = getTargetChar()
			if liveChar then
				targetRoot = resolveCharacterRoot(liveChar)
				targetHead = liveChar:FindFirstChild("Head")
			end
		end

		if not targetRoot then
            State.Moves.TargetLostAt = State.Moves.TargetLostAt or os.clock()

            -- If the current target disappears, clear it and look for the
            -- nearest valid player/NPC instead of leaving the engine frozen.
            if State.Moves.AutoAcquire and os.clock() - State.Moves.TargetLostAt >= 0.65 then
                Internal.ApplyTarget(nil)
                autoAcquireNearestTarget(false)
                targetChar = getTargetChar()
                targetRoot = targetChar and resolveCharacterRoot(targetChar)
                targetHead = targetChar and targetChar:FindFirstChild("Head")
                State.Moves.TargetLostAt = targetRoot and nil or State.Moves.TargetLostAt
            end

            if not targetRoot then
                myRoot.AssemblyLinearVelocity = Vector3.zero
                myRoot.AssemblyAngularVelocity = Vector3.zero
                return
            end
		end

		State.Moves.TargetLostAt = nil
		local t = os.clock()
		local dist = math.max(0.1, State.Moves.Distance)
		local spd = math.max(0.1, State.Moves.Speed)
		myHum.PlatformStand = true 

		if State.Moves.Mode ~= "Pat" and PatMotion:IsActive() then
            PatMotion:Stop()
            State.Pat.EngineState = "Idle"
        end

		local ok, execErr = pcall(function()
			local pingOffset = targetRoot.AssemblyLinearVelocity * (math.clamp(State.PingComp, 0, 500) / 1000)
			local predictedPos = targetRoot.Position + pingOffset
			local predictedCF = CFrame.new(predictedPos) * (targetRoot.CFrame - targetRoot.Position)
			local flatPredictedCF = flatCF(predictedCF)
			
			local headYOffset = targetHead and (targetHead.Position.Y - targetRoot.Position.Y) or 1.5

			if State.Moves.Mode == "Fling" then 
				myRoot.AssemblyAngularVelocity = Vector3.new(0, 50000, 0)
				myRoot.AssemblyLinearVelocity = Vector3.new(0, 9999, 0)
				myRoot.CFrame = predictedCF * CFrame.new(math.sin(t*50)*0.5, 0, math.cos(t*50)*0.5)
			elseif State.Moves.Mode == "Void Send" then 
				myRoot.AssemblyAngularVelocity = Vector3.zero
				myRoot.AssemblyLinearVelocity = Vector3.zero
				myRoot.CFrame = predictedCF * CFrame.new(0, -500, 0)
			else
				myRoot.AssemblyLinearVelocity = targetRoot.AssemblyLinearVelocity
				myRoot.AssemblyAngularVelocity = Vector3.zero
				local cycle = (math.sin(t * spd) + 1) * 0.5
				local thrust = cycle * dist

				if State.Moves.Mode == "Facebang" then 
					local headPos = (targetHead and targetHead.Position or (targetRoot.Position + Vector3.new(0, 1.5, 0))) + pingOffset
					local headCF = flatCF(CFrame.new(headPos) * (targetRoot.CFrame - targetRoot.Position))
					myRoot.CFrame = headCF * CFrame.new(0, 0, -(dist - thrust)) * CFrame.Angles(0, math.pi, 0)
				elseif State.Moves.Mode == "Hipbang" then 
					myRoot.CFrame = flatPredictedCF * CFrame.new(0, -0.7, (dist - thrust))
                elseif State.Moves.Mode == "Close Contact" then
                    -- Non-sexual close-contact choreography: short forward/backward steps
                    -- while keeping the avatars upright and facing one another.
                    local contact = (math.sin(t * spd) + 1) * 0.5
                    local gap = math.clamp(dist, 0.9, 2.0)
                    local z = gap - contact * math.min(gap * 0.75, 0.8)
                    myRoot.CFrame = flatPredictedCF * CFrame.new(0, 0, z) * CFrame.Angles(0, math.pi, 0)
				elseif State.Moves.Mode == "Headsit" then 
					myRoot.CFrame = predictedCF * CFrame.new(0, headYOffset + 1.2, 0)
				elseif State.Moves.Mode == "Orbit" then 
					myRoot.CFrame = flatPredictedCF * CFrame.Angles(0, t * spd, 0) * CFrame.new(0, 0, -dist)
				elseif State.Moves.Mode == "Mount" then 
					myRoot.CFrame = predictedCF * CFrame.new(0, headYOffset, 1)
				elseif State.Moves.Mode == "Tornado" then 
					myRoot.CFrame = predictedCF * CFrame.Angles(0, t * spd, 0) * CFrame.new(0, math.sin(t * 10) * (headYOffset * 2), -dist)
				elseif State.Moves.Mode == "Stomp" then 
					myRoot.CFrame = flatPredictedCF * CFrame.new(0, headYOffset + 1 + math.abs(math.cos(t * (spd/2))) * 4, 0)
				elseif State.Moves.Mode == "Spin" then 
					myRoot.CFrame = flatPredictedCF * CFrame.new(0, 0, -dist) * CFrame.Angles(0, t * spd, 0)
				elseif State.Moves.Mode == "Attach" then 
					myRoot.CFrame = predictedCF * CFrame.new(0, headYOffset + 0.5, 0)
				elseif State.Moves.Mode == "Glitch" then 
					local rx = math.random() * (dist * 2) - dist
					local ry = math.random() * (dist * 2) - dist
					local rz = math.random() * (dist * 2) - dist
					myRoot.CFrame = flatPredictedCF * CFrame.new(rx, ry, rz)
                elseif State.Moves.Mode == "Pat" then
                    -- Non-explicit pat choreography using the supplied high-energy
                    -- procedural R15 Waist/Neck motion as the sole joint controller.
                    local patSide = math.clamp(dist, 1.25, 2.25)
                    local tap = (math.sin(t * math.max(State.Pat.Speed, 0.1)) + 1) * 0.5
                    local patPos = flatPredictedCF.Position
                        + flatPredictedCF.RightVector * patSide
                        + Vector3.new(0, math.clamp(headYOffset - 0.55, 0.5, 1.7) + tap * 0.12, 0)
                    myRoot.CFrame = CFrame.lookAt(patPos, flatPredictedCF.Position)
                    PatMotion:Update(char, dt, State.Pat.EngineState)
                    end
				end
			end
		end)
		if not ok then
            PatMotion:Stop()
			warn("[COCA] Troll execution error (" .. tostring(State.Moves.Mode) .. "): " .. tostring(execErr))
			State.Moves.Running = false
			myHum.PlatformStand = false
			myHum.AutoRotate = true
			movesStart.Text = "⚡ INITIATE TROLL"
		end
	end
end)

--============================================================
-- HEARTBEAT (UI & LIVE REPLICATION)
--============================================================

RunService.Heartbeat:Connect(function()
	if not State.Unlocked then return end
	local char = LP.Character
	local myRoot = char and root(char)
	local targetChar = getTargetChar()

	if State.Target then
		if targetChar then
			updateESP(targetChar)
			local tHum = hum(targetChar)
			local tRt = resolveCharacterRoot(targetChar)
			if tabs.Target.Visible and tHum then 
				local hpTxt = math.floor(tHum.Health) .. " / " .. math.floor(tHum.MaxHealth)
				local pct = math.clamp(tHum.Health / tHum.MaxHealth, 0, 1)
				local barColor = pct > 0.5 and SUCCESS or (pct > 0.2 and YELLOW or DANGER)
				intelHealth.Text = "HP: " .. hpTxt
				tween(hpFill, {Size = UDim2.new(pct, 0, 1, 0), BackgroundColor3 = barColor}, 0.2)
				for _, md in ipairs(miniDashes) do 
					tween(md.hpFill, {Size = UDim2.new(pct, 0, 1, 0), BackgroundColor3 = barColor}, 0.2) 
				end
			end
			if tabs.Target.Visible and tRt and myRoot then 
				intelDist.Text = "Distance: " .. math.floor((myRoot.Position - tRt.Position).Magnitude) .. " studs" 
			end
		else
			updateESP(nil)
			if tabs.Target.Visible then
				intelHealth.Text = "Status: Respawning..."
				tween(hpFill, {Size = UDim2.new(0, 0, 1, 0)}, 0.2)
				intelDist.Text = "Distance: N/A"
				for _, md in ipairs(miniDashes) do tween(md.hpFill, {Size = UDim2.new(0, 0, 1, 0)}, 0.2) end
			end
			if next(activeCopiedTracks) then clearTracks() end
			return
		end
	else
		updateESP(nil)
		if next(activeCopiedTracks) then clearTracks() end
		return
	end

	-- Live Server Animation Replication
	if State.Anim.TrackSync and targetChar and char then
		local tHum = hum(targetChar)
		local mHum = hum(char)
		if tHum and mHum then
			local tAnim = tHum:FindFirstChildOfClass("Animator")
			local mAnim = getAnimator(char)
			if tAnim and mAnim then
				local playingNow = {}
				for _, tTrack in ipairs(tAnim:GetPlayingAnimationTracks()) do
					if tTrack.IsPlaying and tTrack.Animation and tTrack.Animation.AnimationId ~= "" then
						playingNow[tTrack] = true
						syncCopiedTrack(tTrack, mAnim)
					end
				end
				for sourceTrack, cache in pairs(activeCopiedTracks) do
					if not playingNow[sourceTrack] or not sourceTrack.Parent or not sourceTrack.IsPlaying then
						pcall(function()
							cache.mTrack:Stop(0.08)
							cache.mTrack:Destroy()
							cache.animObj:Destroy()
						end)
						activeCopiedTracks[sourceTrack] = nil
					end
				end
			end
		end
	else
		-- Track sync was disabled or the target disappeared.
		if next(activeCopiedTracks) then clearTracks() end
	end
end)

--============================================================
-- CINEMATIC LOGIN & WEB-HOOK VERIFICATION
--============================================================

local verification = Instance.new("Frame")
verification.Name = "Verification"
verification.Size = UDim2.new(0, 320, 0, 380)
verification.Position = UDim2.new(0.5, -160, 0.5, -190)
verification.BackgroundColor3 = BG_MAIN
verification.BorderSizePixel = 0
verification.ZIndex = 1000
verification.Parent = gui
Instance.new("UICorner", verification).CornerRadius = UDim.new(0, 16)
local vStroke = Instance.new("UIStroke", verification)
vStroke.Color = GRAD_2
vStroke.Thickness = 2
createShadow(verification, 40, 0.5, 5)

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 6)
topBar.BorderSizePixel = 0
topBar.Parent = verification
applyGradient(topBar)
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 16)

local vTopBlock = Instance.new("Frame")
vTopBlock.Size = UDim2.new(1, 0, 0, 6)
vTopBlock.Position = UDim2.new(0,0,0,3)
vTopBlock.BackgroundColor3 = BG_MAIN
vTopBlock.BorderSizePixel = 0
vTopBlock.Parent = verification

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0, 100, 0, 100)
avatar.Position = UDim2.new(0.5, -50, 0, 30)
avatar.BackgroundTransparency = 1
avatar.ScaleType = Enum.ScaleType.Fit
avatar.Parent = verification
Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
local aStroke = Instance.new("UIStroke", avatar)
aStroke.Color = GRAD_1
aStroke.Thickness = 2

pcall(function() 
	task.spawn(function() 
		local ok, img = pcall(function() return Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150) end)
		if ok and img and avatar.Parent then avatar.Image = img end 
	end) 
end)

local dName = Instance.new("TextLabel")
dName.BackgroundTransparency = 1
dName.Text = LP.DisplayName
dName.TextSize = 20
dName.TextColor3 = TEXT_MAIN
dName.Font = Enum.Font.GothamBlack
dName.Size = UDim2.new(1, 0, 0, 20)
dName.Position = UDim2.new(0, 0, 0, 145)
dName.TextXAlignment = Enum.TextXAlignment.Center
dName.Parent = verification

local uName = Instance.new("TextLabel")
uName.BackgroundTransparency = 1
uName.Text = "@" .. LP.Name
uName.TextSize = 13
uName.TextColor3 = TEXT_SUB
uName.Font = Enum.Font.GothamMedium
uName.Size = UDim2.new(1, 0, 0, 20)
uName.Position = UDim2.new(0, 0, 0, 165)
uName.TextXAlignment = Enum.TextXAlignment.Center
uName.Parent = verification

local roleName = getVIPRole(LP.Name) or "AUTHORIZED USER"
local roleLabel = Instance.new("TextLabel")
roleLabel.BackgroundTransparency = 1
roleLabel.Text = "♛ " .. roleName
roleLabel.TextSize = 12
roleLabel.TextColor3 = getVIPRole(LP.Name) == "SUPREME OWNER" and YELLOW or GRAD_1
roleLabel.Font = Enum.Font.GothamBlack
roleLabel.Size = UDim2.new(1, 0, 0, 20)
roleLabel.Position = UDim2.new(0, 0, 0, 185)
roleLabel.TextXAlignment = Enum.TextXAlignment.Center
roleLabel.Parent = verification

local keyBox = input(verification, "🔒 Enter Access Key...", 40, true)
keyBox.Size = UDim2.new(1, -60, 0, 40)
keyBox.Position = UDim2.new(0, 30, 0, 220)
keyBox.TextXAlignment = Enum.TextXAlignment.Center

local getKeyBtn = button(verification, "◉ GET KEY", false)
getKeyBtn.Size = UDim2.new(0.5, -35, 0, 40)
getKeyBtn.Position = UDim2.new(0, 30, 0, 270)

local unlockBtn = button(verification, "✓ UNLOCK", true)
unlockBtn.Size = UDim2.new(0.5, -35, 0, 40)
unlockBtn.Position = UDim2.new(0.5, 5, 0, 270)

local verifyStatus = Instance.new("TextLabel")
verifyStatus.BackgroundTransparency = 1
verifyStatus.Text = "Awaiting authentication..."
verifyStatus.TextSize = 12
verifyStatus.TextColor3 = TEXT_SUB
verifyStatus.Font = Enum.Font.GothamMedium
verifyStatus.Size = UDim2.new(1, 0, 0, 30)
verifyStatus.Position = UDim2.new(0, 0, 0, 330)
verifyStatus.TextXAlignment = Enum.TextXAlignment.Center
verifyStatus.Parent = verification

getKeyBtn.Activated:Connect(function()
	local opened = false
    pcall(function()
        if GuiService and GuiService.OpenBrowserWindow then
            GuiService:OpenBrowserWindow(DISCORD_WEB_LINK)
            opened = true
        end
    end)
	if opened then 
		verifyStatus.Text = "Discord profile opened."
		verifyStatus.TextColor3 = SUCCESS 
	else 
		verifyStatus.Text = "Discord ID: 1543328830746403017"
		verifyStatus.TextColor3 = YELLOW 
	end
end)

local unlocking = false
local function unlockUI()
    if unlocking or State.Unlocked then return end
    unlocking = true
	local inputStr = string.match(keyBox.Text, "^%s*(.-)%s*$") or ""
	local playerName = string.lower(LP.Name)
	
	if not VIP_USERNAMES[playerName] then
		playSound(SOUNDS.Error, 0.8)
		verifyStatus.Text = "ACCESS DENIED: NOT WHITELISTED!"
		verifyStatus.TextColor3 = DANGER
		keyBox.Text = ""
		tween(keyBox, {Position = UDim2.new(0, 25, 0, 220)}, 0.05)
		task.delay(0.05, function() 
			tween(keyBox, {Position = UDim2.new(0, 35, 0, 220)}, 0.05)
			task.delay(0.05, function() tween(keyBox, {Position = UDim2.new(0, 30, 0, 220)}, 0.05) end) 
		end)
		task.delay(2, function() if verification.Visible then verifyStatus.Text = "Awaiting authentication..."; verifyStatus.TextColor3 = TEXT_SUB end end)
        unlocking = false
		return
	end
	
	if inputStr ~= ACCESS_KEY then
		playSound(SOUNDS.Error, 0.8)
		verifyStatus.Text = "Invalid Authorization Key!"
		verifyStatus.TextColor3 = DANGER
		keyBox.Text = ""
		tween(keyBox, {Position = UDim2.new(0, 25, 0, 220)}, 0.05)
		task.delay(0.05, function() 
			tween(keyBox, {Position = UDim2.new(0, 35, 0, 220)}, 0.05)
			task.delay(0.05, function() tween(keyBox, {Position = UDim2.new(0, 30, 0, 220)}, 0.05) end) 
		end)
		task.delay(1.5, function() if verification.Visible then verifyStatus.Text = "Awaiting authentication..."; verifyStatus.TextColor3 = TEXT_SUB end end)
        unlocking = false
		return
	end
	
    State.Unlocked = true
	playSound(SOUNDS.Success, 1.0)
	verifyStatus.Text = "Authentication Success!"
	verifyStatus.TextColor3 = SUCCESS
	tween(keyBox, {BackgroundTransparency = 1, TextTransparency = 1}, 0.3)
	tween(getKeyBtn, {BackgroundTransparency = 1, TextTransparency = 1}, 0.3)
	tween(unlockBtn, {BackgroundTransparency = 1, TextTransparency = 1}, 0.3)
	tween(avatar, {Size = UDim2.new(0, 120, 0, 120), Position = UDim2.new(0.5, -60, 0, 40)}, 0.5, Enum.EasingStyle.Back)
	
	task.wait(0.8)
	
	tween(verification, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	for _, v in pairs(verification:GetDescendants()) do 
		if v:IsA("TextLabel") or v:IsA("TextBox") or v:IsA("TextButton") then tween(v, {TextTransparency = 1}, 0.4) 
		elseif v:IsA("ImageLabel") then tween(v, {ImageTransparency = 1}, 0.4) 
		elseif v:IsA("Frame") then tween(v, {BackgroundTransparency = 1}, 0.4) 
		elseif v:IsA("UIStroke") then tween(v, {Transparency = 1}, 0.4) end 
	end
	
	task.delay(0.5, function()
		verification.Visible = false
		wrapper.Visible = true
		wrapper.Position = UDim2.new(1, 100, 0.5, -260)
		tween(wrapper, {Position = UDim2.new(1, -300, 0.5, -260)}, 0.6, Enum.EasingStyle.Back)
		Internal.ApplyTarget(nil)
		Internal.RefreshTargets()
        updateQuickBarVisuals()
		Notify("SYSTEM", "Coca Dashboard Unlocked.", SUCCESS)
	end)
end

unlockBtn.Activated:Connect(unlockUI)
keyBox.FocusLost:Connect(function(e) if e then unlockUI() end end)

--============================================================
-- THE AVATAR LOGO WIDGET (MINIMIZE ENGINE)
--============================================================

local openIcon = Instance.new("ImageButton")
openIcon.Size = UDim2.new(0, 56, 0, 56)
openIcon.Position = UDim2.new(1, -70, 0.5, 0)
openIcon.BackgroundColor3 = BG_MAIN
openIcon.Visible = false
openIcon.ZIndex = 999
openIcon.Parent = gui
openIcon.ScaleType = Enum.ScaleType.Fit
Instance.new("UICorner", openIcon).CornerRadius = UDim.new(1, 0)
local oiStroke = Instance.new("UIStroke", openIcon)
oiStroke.Color = GRAD_1
oiStroke.Thickness = 2
createShadow(openIcon, 40, 0.6, 0)

pcall(function() 
	task.spawn(function() 
		local ok, img = pcall(function() return Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150) end)
		if ok and img and openIcon.Parent then openIcon.Image = img end 
	end) 
end)

openIcon.MouseEnter:Connect(function() 
	playSound(SOUNDS.Hover, 0.1, 1.2)
	tween(openIcon, {Size = UDim2.new(0, 62, 0, 62), Position = UDim2.new(1, -73, 0.5, -3)}, 0.2) 
end)
openIcon.MouseLeave:Connect(function() 
	tween(openIcon, {Size = UDim2.new(0, 56, 0, 56), Position = UDim2.new(1, -70, 0.5, 0)}, 0.2) 
end)

minimize.Activated:Connect(function()
	if activeTab then activeTab.Visible = false; activeTab = nil end
	tween(flyout, {Size = UDim2.new(0, 0, 1, -40)}, 0.35, Enum.EasingStyle.Quint)
	task.wait(0.1)
	tween(wrapper, {Position = UDim2.new(1, -280, 0.5, -260)}, 0.2)
	task.delay(0.2, function() 
		wrapper.Visible = false
		openIcon.Visible = true
		openIcon.Size = UDim2.new(0,0,0,0)
		openIcon.Position = UDim2.new(1, -42, 0.5, 28)
		tween(openIcon, {Size = UDim2.new(0, 56, 0, 56), Position = UDim2.new(1, -70, 0.5, 0)}, 0.4, Enum.EasingStyle.Back)
		Notify("SYSTEM", "Dashboard minimized.", YELLOW) 
	end)
end)

openIcon.Activated:Connect(function()
	playSound(SOUNDS.Click, 0.3, 1.0)
	tween(openIcon, {Size = UDim2.new(0,0,0,0), Position = UDim2.new(1, -42, 0.5, 28)}, 0.2)
	task.delay(0.2, function() 
		openIcon.Visible = false
		wrapper.Visible = true
		wrapper.Position = UDim2.new(1, -280, 0.5, -260)
		tween(wrapper, {Position = UDim2.new(1, -300, 0.5, -260)}, 0.4, Enum.EasingStyle.Back)
		tween(flyout, {Size = UDim2.new(0, 0, 1, -40)}, 0.1) 
	end)
end)

--============================================================
-- DRAG SYSTEM
--============================================================

local function draggable(frame, handle)
	local dragging, dragStart, startPos = false, nil, nil
	handle.InputBegan:Connect(function(inputObject) 
		if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then 
			dragging = true
			dragStart = inputObject.Position
			startPos = frame.Position 
		end 
	end)
	UserInputService.InputChanged:Connect(function(inputObject) 
		if dragging and (inputObject.UserInputType == Enum.UserInputType.MouseMovement or inputObject.UserInputType == Enum.UserInputType.Touch) then 
			local delta = inputObject.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) 
		end 
	end)
	UserInputService.InputEnded:Connect(function(inputObject) 
		if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then 
			dragging = false 
		end 
	end)
end
draggable(wrapper, capsule)
draggable(verification, verification)
draggable(openIcon, openIcon)

Players.PlayerAdded:Connect(function() 
	task.wait(.5)
	if State.Unlocked then Internal.RefreshTargets() end 
end)

Players.PlayerRemoving:Connect(function(plr)
    if State.Target and State.Target.player == plr then
        if State.Filling.AutoRejoin then
            State.Filling.RejoinUserId = plr.UserId
        else
            State.Filling.RejoinUserId = nil
        end
        if State.Filling.Running then
            State.Filling.Running = false
            if cocaFlingConn then cocaFlingConn:Disconnect(); cocaFlingConn = nil end
            if cocaSeatConn then cocaSeatConn:Disconnect(); cocaSeatConn = nil end
            fillingStart.Text = "▶ START COCA FLING"
        end
        Internal.ApplyTarget(nil)
        if State.Moves.Running then Internal.StopMoves() end
    end
    if State.Unlocked then
        task.wait(0.2)
        Internal.RefreshTargets()
    end
end)

verification.Visible = true
quickDock.Visible = false
quickManager.Visible = false
verification.ZIndex = 1000
wrapper.Visible = false
wrapper.ZIndex = 100
gui.Enabled = true

task.spawn(function()
	while gui.Parent do
		task.wait(2)
		if State.Unlocked and activeTab == tabs.Target then
			Internal.RefreshTargets()
		end
	end
end)

task.defer(function()
	if not gui or not gui.Parent then return end
	gui.Enabled = true
	verification.Visible = not State.Unlocked
	wrapper.Visible = State.Unlocked
	if State.Unlocked then
		Internal.RefreshTargets()
        updateQuickBarVisuals()
	else
        quickDock.Visible = false
        quickManager.Visible = false
	end
end)
print("COCA CAPSULE: V52 UNIVERSAL EXECUTOR LUAU / TARGET / DEEPHAT / ANIMATION ENGINE INITIALIZED | Key: KINGCOCA")
