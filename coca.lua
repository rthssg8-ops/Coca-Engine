-- ====================================================================
-- EGG GOD MODE: ENTERPRISE EDITION (OPTIMIZED & BUG-FREE)
-- ====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- CONFIGURATION
local BASE_HOVER_OFFSET = Vector3.new(0, 3, 0)
local AUTO_FARM_INTERVAL = 0.6       -- Cycle delay between farm loops
local STEAL_TIMEOUT = 1.2            -- Maximum wait for server to register the egg
local USE_SMOOTH_TELEPORT = false    -- Set true to fly instead of instant-warp
local TELEPORT_FLY_SPEED = 160       -- Studs/sec if smooth teleport is enabled
local ESP_ENABLED = true

-- STATE
local isAutoFarming = false
local currentSpeedMultiplier = 1
local isAirJumping = false
local lastMirrorTime = 0

local customBaseCFrame = nil
local cachedBaseCFrame = nil
local eggCache = {}
local connections = {}
local espHighlight = nil
local decoy = nil

-- ====================================================================
-- 1. BASE IDENTIFICATION SYSTEM (BY USERNAME & DISPLAY NAME)
-- ====================================================================
local function findPlayerBase()
    -- Priority 1: User-set override (Keybind 'B')
    if customBaseCFrame then return customBaseCFrame end
    
    -- Priority 2: Cached plot (avoids unnecessary workspace scans)
    if cachedBaseCFrame then return cachedBaseCFrame end

    local pName = player.Name:lower()
    local dName = player.DisplayName:lower()
    local uId = tostring(player.UserId)

    local candidateFolders = {
        workspace:FindFirstChild("Plots"),
        workspace:FindFirstChild("Bases"),
        workspace:FindFirstChild("Tycoons"),
        workspace:FindFirstChild("Islands"),
        workspace:FindFirstChild("Houses"),
        workspace
    }

    for _, container in ipairs(candidateFolders) do
        if container then
            for _, obj in ipairs(container:GetChildren()) do
                if obj:IsA("Model") or obj:IsA("Folder") or obj:IsA("BasePart") then
                    local objName = obj.Name:lower()
                    local isMatch = false

                    -- Check 1: Direct name match
                    if objName:find(pName, 1, true) or objName:find(dName, 1, true) or obj.Name == uId then
                        isMatch = true
                    end

                    -- Check 2: Attributes ("Owner", "Player", "OwnerName")
                    if not isMatch then
                        local ownerAttr = obj:GetAttribute("Owner") 
                            or obj:GetAttribute("Player") 
                            or obj:GetAttribute("OwnerName") 
                            or obj:GetAttribute("OwnerUserId")
                        if ownerAttr then
                            local strAttr = tostring(ownerAttr):lower()
                            if strAttr:find(pName, 1, true) or strAttr:find(dName, 1, true) or strAttr == uId then
                                isMatch = true
                            end
                        end
                    end

                    -- Check 3: ValueObjects (StringValue or ObjectValue)
                    if not isMatch then
                        local ownerVal = obj:FindFirstChild("Owner") or obj:FindFirstChild("Player")
                        if ownerVal then
                            if ownerVal:IsA("StringValue") then
                                local valLower = ownerVal.Value:lower()
                                if valLower:find(pName, 1, true) or valLower:find(dName, 1, true) then
                                    isMatch = true
                                end
                            elseif ownerVal:IsA("ObjectValue") and ownerVal.Value == player then
                                isMatch = true
                            end
                        end
                    end

                    -- Check 4: Base signs / SurfaceGui TextLabels
                    if not isMatch then
                        for _, desc in ipairs(obj:GetDescendants()) do
                            if desc:IsA("TextLabel") or desc:IsA("TextButton") then
                                local txt = desc.Text:lower()
                                if txt:find(pName, 1, true) or txt:find(dName, 1, true) then
                                    isMatch = true
                                    break
                                end
                            end
                        end
                    end

                    if isMatch then
                        local rootCFrame
                        if obj:IsA("Model") then
                            rootCFrame = obj:GetPivot()
                        elseif obj:IsA("BasePart") then
                            rootCFrame = obj.CFrame
                        else
                            local part = obj:FindFirstChildWhichIsA("BasePart", true)
                            if part then rootCFrame = part.CFrame end
                        end

                        if rootCFrame then
                            cachedBaseCFrame = rootCFrame + BASE_HOVER_OFFSET
                            print("Base locked at plot: " .. obj.Name)
                            return cachedBaseCFrame
                        end
                    end
                end
            end
        end
    end

    -- Fallback: Static common instances
    local static = workspace:FindFirstChild("House") or workspace:FindFirstChild("Base") or workspace:FindFirstChild("SpawnLocation")
    if static then
        cachedBaseCFrame = (static:IsA("Model") and static:GetPivot() or static.CFrame) + BASE_HOVER_OFFSET
        return cachedBaseCFrame
    end

    return nil
end

-- ====================================================================
-- 2. MOMENTUM-SAFE TELEPORTATION
-- ====================================================================
local function teleportSafely(targetCFrame)
    if not humanoidRootPart or not humanoid or humanoid.Health <= 0 then return false end

    -- Kill momentum to eliminate rubberbanding & physics flings
    humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
    humanoidRootPart.AssemblyAngularVelocity = Vector3.zero

    if USE_SMOOTH_TELEPORT then
        local dist = (humanoidRootPart.Position - targetCFrame.Position).Magnitude
        local duration = math.clamp(dist / TELEPORT_FLY_SPEED, 0.1, 5)
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
        tween.Completed:Wait()
    else
        humanoidRootPart.CFrame = targetCFrame
    end

    humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
    humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
    return true
end

-- ====================================================================
-- 3. SCANNING & ESP
-- ====================================================================
local function highlightBestEgg(eggObject)
    if not ESP_ENABLED or not eggObject then return end
    if not espHighlight then
        espHighlight = Instance.new("Highlight")
        espHighlight.FillColor = Color3.fromRGB(255, 215, 0)
        espHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        local ok = pcall(function() espHighlight.Parent = CoreGui end)
        if not ok then espHighlight.Parent = player:WaitForChild("PlayerGui") end
    end
    espHighlight.Adornee = eggObject
end

local function scanEggs()
    table.clear(eggCache)
    local eggsFolder = workspace:FindFirstChild("Eggs") or workspace:FindFirstChild("Spawn") or workspace
    local searchArea = (eggsFolder == workspace) and workspace:GetChildren() or eggsFolder:GetDescendants()

    for _, obj in ipairs(searchArea) do
        if (obj:IsA("BasePart") or obj:IsA("Model")) and string.find(obj.Name, "Egg", 1, true) then
            local multiplier = obj:GetAttribute("Multiplier") or 1
            local rarity = obj:GetAttribute("Rarity") or 1
            local size = obj:IsA("BasePart") and obj.Size or Vector3.new(2, 2, 2)
            local value = (size.X + size.Y + size.Z) * multiplier * rarity

            local pos
            if obj:IsA("Model") then
                pos = obj:GetPivot().Position
            else
                pos = obj.Position
            end

            table.insert(eggCache, {
                Object = obj,
                Name = obj.Name,
                Value = value,
                Position = pos
            })
        end
    end

    table.sort(eggCache, function(a, b) return a.Value > b.Value end)

    if #eggCache > 0 and eggCache[1].Object then
        highlightBestEgg(eggCache[1].Object)
    end

    return eggCache
end

-- ====================================================================
-- 4. SERVER-VERIFIED AUTO-FARM CYCLE
-- ====================================================================
local function countPlayerEggs()
    local count = 0
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if string.find(item.Name, "Egg", 1, true) then count = count + 1 end
        end
    end
    if character then
        for _, item in ipairs(character:GetChildren()) do
            if item:IsA("Tool") and string.find(item.Name, "Egg", 1, true) then count = count + 1 end
        end
    end
    return count
end

local function executeFarmCycle()
    local eggs = scanEggs()
    if #eggs == 0 then return end

    local targetEgg = eggs[1]
    local eggInstance = targetEgg.Object
    if not eggInstance or not eggInstance:IsDescendantOf(workspace) then return end

    -- 1. Warp to the Egg
    local reached = teleportSafely(CFrame.new(targetEgg.Position + Vector3.new(0, 2.5, 0)))
    if not reached then return end
    task.wait(0.15)

    -- 2. Snapshot current state before steal attempt
    local initialInventoryCount = countPlayerEggs()

    -- 3. Trigger Steal Action
    local stealRemote = ReplicatedStorage:FindFirstChild("StealEgg") 
        or ReplicatedStorage:FindFirstChild("CollectEgg") 
        or ReplicatedStorage:FindFirstChild("PickEgg")

    if stealRemote and stealRemote:IsA("RemoteEvent") then
        stealRemote:FireServer(eggInstance)
    else
        local cd = eggInstance:FindFirstChildWhichIsA("ClickDetector", true)
        if cd and typeof(fireclickdetector) == "function" then
            fireclickdetector(cd)
        end
    end

    -- 4. Wait for Server to Register Collection
    local registered = false
    local startTime = tick()

    while (tick() - startTime) < STEAL_TIMEOUT do
        -- Condition A: Target egg was despawned/destroyed by server
        if not eggInstance or not eggInstance:IsDescendantOf(workspace) or eggInstance.Parent == nil then
            registered = true
            break
        end

        -- Condition B: Player picked it up into character/backpack
        if countPlayerEggs() > initialInventoryCount then
            registered = true
            break
        end

        -- Condition C: Transparency check (some games hide before deleting)
        if eggInstance:IsA("BasePart") and eggInstance.Transparency >= 0.9 then
            registered = true
            break
        end

        task.wait(0.05)
    end

    -- 5. Directly Teleport Home Once Confirmed
    if registered then
        local baseCF = findPlayerBase()
        if baseCF then
            teleportSafely(baseCF)

            -- Automatically deposit if game uses deposit remotes
            local depositRemote = ReplicatedStorage:FindFirstChild("DepositEgg") 
                or ReplicatedStorage:FindFirstChild("BankEgg")
                or ReplicatedStorage:FindFirstChild("DropEgg")

            if depositRemote and depositRemote:IsA("RemoteEvent") then
                depositRemote:FireServer()
            end
        else
            warn("Could not find your base! Press 'B' while standing at your base to set it manually.")
        end
    end
end

-- ====================================================================
-- 5. HIT PROXY & MIRROR SHIELD (MEMORY LEAK FREE)
-- ====================================================================
local function cleanupConnections()
    for _, conn in ipairs(connections) do
        if conn.Connected then conn:Disconnect() end
    end
    table.clear(connections)
end

local function createDecoy()
    if decoy and decoy.Parent then return decoy end
    decoy = Instance.new("Part")
    decoy.Name = "PlayerDecoy"
    decoy.Size = Vector3.new(2, 2, 2)
    decoy.Anchored = true
    decoy.CanCollide = false
    decoy.Transparency = 1
    decoy.Parent = workspace

    RunService.Heartbeat:Connect(function()
        if decoy and decoy.Parent and humanoidRootPart then
            decoy.CFrame = humanoidRootPart.CFrame
        end
    end)
    return decoy
end

local function mirrorHits()
    if not character then return end
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") and part ~= humanoidRootPart then
            local conn = part.Touched:Connect(function(hitPart)
                local hitPlayer = Players:GetPlayerFromCharacter(hitPart.Parent)
                if hitPlayer and hitPlayer ~= player then
                    if (tick() - lastMirrorTime) > 0.1 then
                        lastMirrorTime = tick()
                        if decoy and decoy.Parent then
                            decoy.CFrame = CFrame.new(hitPart.Position)
                            local enemyRoot = hitPart.Parent:FindFirstChild("HumanoidRootPart")
                            if enemyRoot then
                                enemyRoot.CFrame = enemyRoot.CFrame * CFrame.new(0, 0, -3)
                            end
                        end
                    end
                end
            end)
            table.insert(connections, conn)
        end
    end
end

createDecoy()
mirrorHits()

-- Clean state rebuild on respawn
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")

    cleanupConnections()
    mirrorHits()
    humanoid.WalkSpeed = 16 * currentSpeedMultiplier
end)

-- ====================================================================
-- 6. SPEED & MOVEMENT
-- ====================================================================
local function setSpeed(mult)
    currentSpeedMultiplier = mult
    if humanoid then humanoid.WalkSpeed = 16 * mult end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.One then setSpeed(1)
    elseif input.KeyCode == Enum.KeyCode.Two then setSpeed(5)
    elseif input.KeyCode == Enum.KeyCode.Three then setSpeed(10)
    elseif input.KeyCode == Enum.KeyCode.Four then isAirJumping = not isAirJumping
    elseif input.KeyCode == Enum.KeyCode.Five then
        isAutoFarming = not isAutoFarming
        print("Auto-Farm: " .. (isAutoFarming and "ENABLED" or "DISABLED"))
    elseif input.KeyCode == Enum.KeyCode.B then
        if humanoidRootPart then
            customBaseCFrame = humanoidRootPart.CFrame
            print("Custom base locked manually at:", customBaseCFrame.Position)
        end
    end
end)

-- Fixed, bug-free air jump using modern raycasts
RunService.RenderStepped:Connect(function()
    if isAirJumping and character and humanoid and humanoidRootPart then
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {character}
        params.FilterType = Enum.RaycastFilterType.Exclude

        local hit = workspace:Raycast(humanoidRootPart.Position, Vector3.new(0, -9, 0), params)
        if not hit and not humanoid.Jump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ====================================================================
-- 7. GUI CREATION
-- ====================================================================
local playerGui = player:WaitForChild("PlayerGui")
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "EggGodGUI"
mainGui.ResetOnSpawn = false
mainGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 360, 0, 440)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -220)
mainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = mainGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "🥚 Egg God Mode [Pro]"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -110)
scrollFrame.Position = UDim2.new(0, 10, 0, 50)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 5
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = scrollFrame

local function refreshGUI()
    for _, item in ipairs(scrollFrame:GetChildren()) do
        if item:IsA("TextButton") then item:Destroy() end
    end

    local eggs = scanEggs()
    for _, egg in ipairs(eggs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 36)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        btn.BorderSizePixel = 0
        btn.Text = "  " .. egg.Name .. "  [Val: " .. math.floor(egg.Value) .. "]"
        btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = scrollFrame

        btn.MouseButton1Click:Connect(function()
            teleportSafely(CFrame.new(egg.Position + Vector3.new(0, 2.5, 0)))
        end)
    end
end

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(1, -20, 0, 40)
refreshBtn.Position = UDim2.new(0, 10, 1, -50)
refreshBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 60)
refreshBtn.BorderSizePixel = 0
refreshBtn.Text = "Scan & Refresh"
refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextSize = 14
refreshBtn.Parent = mainFrame
refreshBtn.MouseButton1Click:Connect(refreshGUI)

task.spawn(refreshGUI)

-- ====================================================================
-- 8. AUTOFARM THREAD RUNNER
-- ====================================================================
task.spawn(function()
    while true do
        if isAutoFarming and humanoid and humanoid.Health > 0 then
            executeFarmCycle()
        end
        task.wait(AUTO_FARM_INTERVAL)
    end
end)

print("--------------------------------------------------")
print("Egg God Mode Initialized!")
print("Keybinds: [1] 1x | [2] 5x | [3] 10x | [4] AirJump | [5] AutoFarm | [B] Save Base Manually")
print("--------------------------------------------------")
