-- ====== LOADING RAYFIELD UI LIBRARY ======

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Window = Rayfield:CreateWindow({
    Name = "Main Hub",
    LoadingTitle = "Main Hub Loading...",
    LoadingSubtitle = "by bạn 😎",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "MyHubSettings"
    },
})

-- ====== SERVICES ======
local Players = game:GetService("Players")
local Rep = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

local ChangeStats = Rep:FindFirstChild("ChangeStats")
local atk = char:FindFirstChild("AttackSpeed")

if not atk then
    atk = Instance.new("NumberValue")
    atk.Name = "AttackSpeed"
    atk.Value = 1
    atk.Parent = char
end

local starterWalk = humanoid.WalkSpeed
local starterJump = humanoid.JumpPower
local starterGravity = workspace.Gravity

-- ========= TABS =========
local Movement = Window:CreateTab("Movement", 4483362458)
local Combat = Window:CreateTab("Combat", 4483362458)

-- ========= MOVEMENT TAB =========

Movement:CreateSlider({
    Name = "Speed",
    Range = {0, 120},
    Increment = 1,
    Suffix = "WalkSpeed",
    CurrentValue = starterWalk,
    Flag = "SpeedSlider",
    Callback = function(val)
        if ChangeStats then
            ChangeStats:FireServer("Speed", val)
        else
            humanoid.WalkSpeed = val
        end
    end,
})

Movement:CreateSlider({
    Name = "Jump Power",
    Range = {0, 150},
    Increment = 1,
    Suffix = "Jump",
    CurrentValue = starterJump,
    Flag = "JumpSlider",
    Callback = function(val)
        if ChangeStats then
            ChangeStats:FireServer("Jump", val)
        else
            humanoid.JumpPower = val
        end
    end,
})

Movement:CreateSlider({
    Name = "Gravity",
    Range = {0, 196},
    Increment = 1,
    Suffix = "Gravity",
    CurrentValue = starterGravity,
    Flag = "GravitySlider",
    Callback = function(val)
        workspace.Gravity = val
    end,
})

Movement:CreateButton({
    Name = "Reset Movement",
    Callback = function()
        if ChangeStats then
            ChangeStats:FireServer("Speed", starterWalk)
            ChangeStats:FireServer("Jump", starterJump)
        end
        workspace.Gravity = starterGravity
        Rayfield:Notify({Title = "Reset", Content = "Movement Reset Successful!"})
    end,
})

-- ========= COMBAT TAB =========

Combat:CreateSlider({
    Name = "Attack Speed",
    Range = {1, 500},
    Increment = 1,
    Suffix = "%",
    CurrentValue = atk.Value * 100,
    Flag = "AtkSpeed",
    Callback = function(val)
        local newAtk = val / 100
        atk.Value = newAtk

        if ChangeStats then
            ChangeStats:FireServer("AttackSpeed", newAtk)
        end
    end,
})

Combat:CreateButton({
    Name = "Reset Attack",
    Callback = function()
        atk.Value = 1
        if ChangeStats then
            ChangeStats:FireServer("AttackSpeed", 1)
        end
        Rayfield:Notify({Title="Reset", Content="Attack Speed Reset!"})
    end,
})

-- ========= NOTIFICATION =========
Rayfield:Notify({
    Title = "Main Hub",
    Content = "Hub Loaded Successfully!",
})
