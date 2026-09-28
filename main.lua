--============================================================
-- COCA SCRIPT : V44 PROFESSIONAL EDITION
-- Key: KINGCOCA | Pure Lua | 100% Crash-Proof | Zero Delay
--============================================================

local cloneref = cloneref or function(...) return ... end
local S = setmetatable({}, {__index=function(_,n) return cloneref(game:GetService(n)) end})
local Players, RunService, UserInputService, TextChatService, TweenService, VirtualUser, CoreGui, HttpService, GuiService, Stats =
	S.Players, S.RunService, S.UserInputService, S.TextChatService, S.TweenService, S.VirtualUser, S.CoreGui, S.HttpService, S.GuiService, S.Stats

local LP = Players.LocalPlayer

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
	Moves = { Running = false, Mode = "Facebang", Distance = 1.2, Speed = 40 },
	Chat = { Running = false, Count = 0, Delay = 1.5, Message = "" },
	Anim = { TrackSync = false, Follow = false, Distance = 3.0, Side = "Right" },
	Movement = { SpeedEnabled = false, WalkSpeed = 50, FlyEnabled = false, FlySpeed = 100, Noclip = false, InfJump = false },
	Safety = { AntiVoid = false, AntiAFK = false, SafeCFrame = nil },
	Emotes = { Track = nil, Pack = nil },
	Filling = { Running = false, AutoRejoin = false },
	Performance = { Visible = true, Hud = true },
	Badges = { ShowRoleBadges = true }
}

local Internal = { ApplyTarget = nil, StopMoves = nil, RefreshTargets = nil, RefreshImmunityList = nil, TargetUserId = nil }
local flyVelocity = Vector3.zero 
local selectedEmoteBtn = nil

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
		s.Parent = CoreGui
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
-- SAFE GUI PARENTING & HIGHLIGHTS
--============================================================

local targetGuiParent = nil
pcall(function() if gethui then targetGuiParent = gethui() else targetGuiParent = CoreGui end end)
if not targetGuiParent then targetGuiParent = LP:WaitForChild("PlayerGui") end

local oldGui = targetGuiParent:FindFirstChild("COCA_Capsule_V44") or targetGuiParent:FindFirstChild("COCA_Capsule_V42")
if oldGui then oldGui:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "COCA_Capsule_V44"
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

local function hum(model) return model and model:FindFirstChildOfClass("Humanoid") end
local function root(model) return model and model:FindFirstChild("HumanoidRootPart") end
local function getCharacter() return LP.Character or LP.CharacterAdded:Wait() end

local function flatCF(cf) 
	local _, y, _ = cf:ToOrientation()
	return CFrame.new(cf.Position) * CFrame.Angles(0, y, 0) 
end

local function getTargetChar()
	if not State.Target then return nil end
	if State.Target.kind == "PLAYER" then
		local p = State.Target.player
		if p and p.Parent and p.Character then 
			State.Target.instance = p.Character
			if hum(p.Character) and root(p.Character) then return p.Character end 
		end
	elseif State.Target.kind == "NPC" then
		local m = State.Target.instance
		if m and m.Parent and hum(m) and root(m) then return m end
	end
	return nil
end

local function getTargetRoot()
	local tc = getTargetChar()
	return tc and root(tc)
end

-- IMPORTANT: declare this before getTargets. The previous build referenced
-- isProtectedPlayer before its local declaration, which made Lua resolve it
-- as a nil global and stopped the entire server roster from being created.
local function isProtectedPlayer(player)
	if not player then return false end
	local name = string.lower(player.Name)
	return VIP_USERNAMES[name] ~= nil or State.WhitelistedPlayers[name] == true
end

local function getTargets()
	local result = {}
	local seenPlayers = {}
	local seenNPCs = {}

	-- Server player roster is collected first and independently.
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LP and not isProtectedPlayer(player) then
			local key = tostring(player.UserId)
			if not seenPlayers[key] then
				table.insert(result, {
					kind = "PLAYER",
					player = player,
					instance = player.Character,
					name = player.DisplayName ~= "" and player.DisplayName or player.Name,
					username = player.Name
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
	local probes = {
		function() return identifyexecutor and identifyexecutor() end,
		function() return getexecutorname and getexecutorname() end,
		function() return (syn and syn.get_executor_name and syn.get_executor_name()) end,
	}
	for _, probe in ipairs(probes) do
		local ok, value = pcall(probe)
		if ok and value and tostring(value) ~= "" then
			return tostring(value)
		end
	end
	return "Unknown / Roblox"
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
		end)
	end
end

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
	local info = { age = "N/A", friends = "N/A" }
	pcall(function()
		local req = (http_request or request or syn.request or (http and http.request))
		if req then
			local res = req({Url = "https://users.roblox.com/v1/users/"..uid, Method = "GET"})
			if res and res.Body then
				local d = HttpService:JSONDecode(res.Body)
				if d.created then
					local c = DateTime.fromISO(d.created)
					local days = (DateTime.now().UnixTimestamp - c.UnixTimestamp) / 86400
					if days < 30 then info.age = math.floor(days).."d" 
					elseif days < 365 then info.age = math.floor(days/30).."mo" 
					else info.age = math.floor(days/365).."y" end
				end
			end
			local fRes = req({Url = "https://friends.roblox.com/v1/users/"..uid.."/friends/count", Method = "GET"})
			if fRes and fRes.Body then
				local d = HttpService:JSONDecode(fRes.Body)
				if d.count then info.friends = tostring(d.count) end
			end
		end
	end)
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
		Internal.ApplyTarget(target)
	end)

	return row
end

Internal.ApplyTarget = function(target)
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
	playerListHeader.Text = "SERVER PLAYERS  •  " .. tostring(playerCount) .. " AVAILABLE"

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
			Notify("WHITELIST", "Built-in premium access is already protected.", YELLOW)
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
createGridRadioGroup(tabs.Moves, {"Facebang", "Hipbang", "Headsit", "Orbit", "Mount", "Tornado", "Void Send", "Stomp", "Spin", "Attach", "Glitch", "Pat"}, State.Moves.Mode, function(sel) 
	State.Moves.Mode = sel 
end)

header(tabs.Moves, "ENGINE SETTINGS")
createDirectStepper(tabs.Moves, "Proximity (Studs)", 0.0, 30.0, State.Moves, "Distance")
createDirectStepper(tabs.Moves, "Thrust Speed", 5, 300, State.Moves, "Speed")
createDirectStepper(tabs.Moves, "Ping Comp (ms)", 0, 500, State, "PingComp")

local movesStart = button(tabs.Moves, "⚡ INITIATE TROLL", true)

Internal.StopMoves = function()
	State.Moves.Running = false
	local char = LP.Character
	if char then 
		local humanoid = hum(char)
		if humanoid then 
			humanoid.AutoRotate = true
			humanoid.PlatformStand = false 
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
	end
	movesStart.Text = "⚡ INITIATE TROLL"
	Notify("TROLL ENGINE", "Sequence aborted. Physics restored.", DANGER)
end

movesStart.Activated:Connect(function()
	if State.Moves.Running then 
		Internal.StopMoves()
		return 
	end
	if not State.Target then 
		Notify("ERROR", "You must select a target first!", DANGER)
		return 
	end
	
	local tr = getTargetRoot()
	local myChar = LP.Character
	local myH = myChar and hum(myChar)
	
	if not tr or not myH then
		Notify("ERROR", "Target not spawned or dead.", DANGER)
		return
	end
	
	myH.PlatformStand = true
	myH.Sit = false
	pcall(function() myChar:PivotTo(tr.CFrame) end)
	
	State.Moves.Running = true
	movesStart.Text = "■ ABORT TROLL"
	Notify("TROLL ENGINE", State.Moves.Mode .. " engaged.", SUCCESS)
end)

--============================================================
-- 4. COCA FILLING (COMPACT FLING ENGINE)
--============================================================
titleHeader(tabs.Filling, "🧪 COCA FILLING")
createMiniDash(tabs.Filling)

header(tabs.Filling, "COMPACT FLING OVERRIDE")
local fillingStart = button(tabs.Filling, "▶ START COCA FLING", true)
createToggle(tabs.Filling, "Auto-Fling On Rejoin", State.Filling, "AutoRejoin")

local cocaOrbitAngle = 0
local cocaFlingConn = nil
local cocaSeatConn = nil

local function stopCocaFling()
	State.Filling.Running = false
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
	if State.Filling.AutoRejoin and Internal.TargetUserId and p.UserId == Internal.TargetUserId and not State.WhitelistedPlayers[string.lower(p.Name)] then
		Internal.ApplyTarget({ kind = "PLAYER", player = p, instance = p.Character, name = p.DisplayName, username = p.Name })
		Notify("COCA FILLING", "Target rejoined. Resuming Fling...", YELLOW)
		task.spawn(function()
			local tries = 0
			repeat task.wait(0.5); tries = tries + 1 until (p.Character and root(p.Character)) or tries > 20
			if p.Character and root(p.Character) and not State.Filling.Running then
				task.wait(0.4)
				fillingStart.Text = "■ ABORT COCA FLING"
				State.Filling.Running = true
				cocaOrbitAngle = 0
				local c = LP.Character
				local mh = hum(c)
				if mh then mh.PlatformStand = true; mh.Sit = false end
				cocaFlingConn = RunService.RenderStepped:Connect(function(dt)
					if not State.Filling.Running then return end
					local tr = getTargetRoot()
					local mr = root(LP.Character)
					if not tr or not mr then return end
					cocaOrbitAngle = cocaOrbitAngle + (dt * 45)
					local tp = tr.Position
					local op = tp + Vector3.new(math.cos(cocaOrbitAngle)*2.2, 1.2 + math.sin(cocaOrbitAngle*2)*0.4, math.sin(cocaOrbitAngle)*2.2)
					mr.CFrame = CFrame.new(op, tp)
					mr.AssemblyLinearVelocity = (op - mr.Position) * 80
					mr.AssemblyAngularVelocity = Vector3.new(math.random(-600,600), math.random(-600,600), math.random(-600,600))
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
local chatMessage = input(tabs.Chat, "Enter message to spam...", 60, false)
chatMessage.MultiLine = true
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
				if State.Target and State.Target.kind == "PLAYER" and State.Target.player then 
					text = "/w " .. State.Target.player.Name .. " " .. text 
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

header(tabs.Anim, "SERVER REPLICATION HACKS")

local activeCopiedTracks = {}
local function clearTracks() 
	for id, track in pairs(activeCopiedTracks) do 
		pcall(function() track.mTrack:Stop(0.1); track.mTrack:Destroy() end) 
	end
	activeCopiedTracks = {} 
end

createToggle(tabs.Anim, "Sync Server Animations", State.Anim, "TrackSync", function(isOn)
	local char = LP.Character
	local animate = char and char:FindFirstChild("Animate")
	if isOn then 
		if animate then animate.Disabled = true end
		clearAllEmoteTracks()
		Notify("ANIMATION", "Server sync engaged.", SUCCESS)
	else 
		if animate then animate.Disabled = false end
		clearTracks()
		Notify("ANIMATION", "Local animations restored.", DANGER) 
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
	{"Pack - DEFAULT (Reset)", "Pack", idle = "507766951", walk = "507777826", run = "507767714", jump = "507765000", fall = "507767968"},
	{"Pack - Zombie", "Pack", idle = "616158929", walk = "616168032", run = "616163682", jump = "616161112", fall = "616157476"},
	{"Pack - Vampire", "Pack", idle = "1083445855", walk = "1083473930", run = "1083462077", jump = "1083466542", fall = "1083443587"},
	{"Pack - Superhero", "Pack", idle = "782841498", walk = "782843345", run = "782842708", jump = "782847020", fall = "782846423"},
	{"Dance 1", "Emote", id = "507771019"}, {"Dance 2", "Emote", id = "507776043"}, {"Dance 3", "Emote", id = "507777268"},
	{"Laugh", "Emote", id = "507770818"}, {"Cheer", "Emote", id = "507770677"}, {"Point", "Emote", id = "507770453"},
	{"Wave", "Emote", id = "507770239"}, {"Floss", "Emote", id = "5828456208"}, {"Tilt", "Emote", id = "3360692915"}
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
		track:Play(0.1, 1, 1)
		Notify("EMOTE", "Playing server animation.", SUCCESS) 
	end
end

local function equipPack(packData, btnObj)
	State.Emotes.Pack = packData
	local char = getCharacter()
	local animate = char and char:FindFirstChild("Animate")
	if not animate then return end
	
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
	Notify("EMOTE", "Animation halted.", DANGER)
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
	if isOn then pcall(function() if getconnections then for _, v in pairs(getconnections(LP.Idled)) do v:Disable() end end end) end 
end)

LP.Idled:Connect(function() 
	if State.Safety.AntiAFK then 
		pcall(function() 
			VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
			task.wait(1)
			VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) 
		end) 
	end 
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

perfExecutor.Text = "EXECUTOR: " .. perfExecutorName

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

RunService.Heartbeat:Connect(function()
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
	local targetChar = getTargetChar()
	local targetRoot = targetChar and root(targetChar)
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
			State.Moves.Running = false
			myHum.PlatformStand = false
			myHum.AutoRotate = true
			movesStart.Text = "⚡ INITIATE TROLL"
			return
		end
		local t = os.clock()
		local dist = math.max(0.1, State.Moves.Distance)
		local spd = math.max(0.1, State.Moves.Speed)
		myHum.PlatformStand = true 

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
				local thrust = math.clamp(math.sin(t * spd), 0, 1) * dist

				if State.Moves.Mode == "Facebang" then 
					local headPos = (targetHead and targetHead.Position or (targetRoot.Position + Vector3.new(0, 1.5, 0))) + pingOffset
					local headCF = flatCF(CFrame.new(headPos) * (targetRoot.CFrame - targetRoot.Position))
					myRoot.CFrame = headCF * CFrame.new(0, 0, -(dist - thrust)) * CFrame.Angles(0, math.pi, 0)
				elseif State.Moves.Mode == "Hipbang" then 
					myRoot.CFrame = flatPredictedCF * CFrame.new(0, -0.7, (dist - thrust))
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
					local armReachY = headYOffset - 1.5 
					local sidePos = flatPredictedCF.Position + (flatPredictedCF.RightVector * math.clamp(dist, 1.2, 2.5)) + Vector3.new(0, armReachY, 0)
					local targetPos = Vector3.new(flatPredictedCF.Position.X, sidePos.Y, flatPredictedCF.Position.Z)
					local bob = math.sin(t * 8) * 0.25
					
					myRoot.CFrame = CFrame.lookAt(sidePos, targetPos) * CFrame.new(0, bob, 0)
					
					local shoulder = char:FindFirstChild("Right Shoulder", true) or char:FindFirstChild("RightShoulder", true)
					if shoulder and shoulder:IsA("Motor6D") then
						shoulder.Transform = CFrame.Angles(math.rad(85) + math.sin(t * 8) * 0.35, math.rad(-15), math.rad(-10))
					end
				end
			end
		end)
		if not ok then
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
			local tRt = root(targetChar)
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
			for id, track in pairs(activeCopiedTracks) do pcall(function() track.mTrack:Stop() end) end
			return
		end
	else
		updateESP(nil)
		for id, track in pairs(activeCopiedTracks) do pcall(function() track.mTrack:Stop() end) end
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
					if tTrack.Animation and tTrack.Animation.AnimationId ~= "" then
						local id = tTrack.Animation.AnimationId
						playingNow[id] = true
						if not activeCopiedTracks[id] then
							local newAnim = Instance.new("Animation")
							newAnim.AnimationId = id
							newAnim.Parent = char 
							pcall(function() 
								local mTrack = mAnim:LoadAnimation(newAnim)
								mTrack.Priority = Enum.AnimationPriority.Action4
								mTrack:Play()
								activeCopiedTracks[id] = { mTrack = mTrack, animObj = newAnim }
							end)
						end
						if activeCopiedTracks[id] then 
							pcall(function() activeCopiedTracks[id].mTrack:AdjustSpeed(tTrack.Speed) end) 
						end
					end
				end
				for id, cache in pairs(activeCopiedTracks) do 
					if not playingNow[id] then 
						pcall(function() cache.mTrack:Stop(); cache.animObj:Destroy() end)
						activeCopiedTracks[id] = nil 
					end 
				end
			end
		end
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
	pcall(function() GuiService:OpenBrowserWindow(DISCORD_WEB_LINK); opened = true end)
	if opened then 
		verifyStatus.Text = "Discord profile opened."
		verifyStatus.TextColor3 = SUCCESS 
	else 
		verifyStatus.Text = "Discord ID: 1543328830746403017"
		verifyStatus.TextColor3 = YELLOW 
	end
end)

local function unlockUI()
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
		return
	end
	
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
		State.Unlocked = true
		verification.Visible = false
		wrapper.Visible = true
		wrapper.Position = UDim2.new(1, 100, 0.5, -260)
		tween(wrapper, {Position = UDim2.new(1, -300, 0.5, -260)}, 0.6, Enum.EasingStyle.Back)
		Internal.ApplyTarget(nil)
		Internal.RefreshTargets()
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
		Internal.ApplyTarget(nil)
		if State.Moves.Running then Internal.StopMoves() end 
	end
	if State.Unlocked then 
		task.wait(0.2)
		Internal.RefreshTargets() 
	end 
end)

verification.Visible = true
wrapper.Visible = false
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
	if not verification.Visible and not State.Unlocked then verification.Visible = true end
end)
print("COCA CAPSULE: V44 PROFESSIONAL ENGINE INITIALIZED | Key: KINGCOCA")
