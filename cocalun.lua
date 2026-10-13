local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local StealEvent = ReplicatedStorage:WaitForChild("StealEvent")
local EggValuesEvent = ReplicatedStorage:WaitForChild("EggValuesEvent")

local player = Players.LocalPlayer
local character = player.Character
local humanoid = character:WaitForChild("Humanoid")

local eggValues = {}
local currentEgg = nil

local function autoSteal()
    for _, egg in pairs(workspace:GetDescendants()) do
        if egg.Name == "Egg" then
            local distance = (character.HumanoidRootPart.Position - egg.Position).Magnitude
            if distance < 10 then
                StealEvent:FireServer(egg)
                currentEgg = egg
            end
        end
    end
end

local function antiGuard()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= player then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 0
                end
            end
        end
    end
end

local function antiHit(hit)
    local players = Players:GetPlayers()
    if #players > 1 then
        local targetPlayer = players[math.random(1, #players)]
        if targetPlayer ~= player then
            local targetCharacter = targetPlayer.Character
            if targetCharacter then
                local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
                if targetHumanoid then
                    hit.Humanoid = targetHumanoid
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    autoSteal()
    antiGuard()
    if character:FindFirstChild("Humanoid") then
        humanoid.WalkSpeed = 50
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        if currentEgg then
            StealEvent:FireServer(currentEgg)
        end
    end
end)

EggValuesEvent.OnClientEvent:Connect(function(values)
    eggValues = values
    print("Egg values updated:")
    for egg, value in pairs(eggValues) do
        print(egg.Name .. ": " .. tostring(value))
    end
end)

character.Humanoid.Touched:Connect(antiHit)
