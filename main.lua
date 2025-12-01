local Rep = game:GetService("ReplicatedStorage")
local ChangeStats = Rep:WaitForChild("ChangeStats")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local starterWalk = humanoid.WalkSpeed
local starterJump = humanoid.JumpPower

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "AdvancedControlGUI"

-- Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 120, 0, 40)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.Text = "Mở Menu"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Parent = ScreenGui
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 10)

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 320, 0, 360)
Frame.Position = UDim2.new(0, 20, 0, 70)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Visible = false
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "⚙️ Điều khiển nhân vật"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1,1,1)
Title.Parent = Frame

local UIS = game:GetService("UserInputService")

local function CreateSlider(yPos, text, min, max, default, callback)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1,-20,0,30)
    Label.Position = UDim2.new(0,10,0,yPos)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(200,200,200)
    Label.Parent = Frame

    local Slider = Instance.new("Frame")
    Slider.Size = UDim2.new(0,280,0,8)
    Slider.Position = UDim2.new(0,20,0,yPos+25)
    Slider.BackgroundColor3 = Color3.fromRGB(60,60,60)
    Slider.Parent = Frame
    Instance.new("UICorner", Slider)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0,14,0,14)
    Knob.Position = UDim2.new((default-min)/(max-min), -7,0.5,-7)
    Knob.BackgroundColor3 = Color3.new(1,1,1)
    Knob.Parent = Slider
    Instance.new("UICorner", Knob)

    local dragging = false

    Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local x = math.clamp(input.Position.X - Slider.AbsolutePosition.X, 0, Slider.AbsoluteSize.X)
            Knob.Position = UDim2.new(0,x-7,0.5,-7)

            local val = math.floor(min + (x / Slider.AbsoluteSize.X) * (max - min))
            Label.Text = text .. ": " .. val
            callback(val)
        end
    end)
end

-- SPEED
CreateSlider(50, "Tốc độ", 0, 120, starterWalk, function(val)
    ChangeStats:FireServer("Speed", val)
end)

-- JUMP
CreateSlider(120, "Nhảy cao", 0, 150, starterJump, function(val)
    ChangeStats:FireServer("Jump", val)
end)

-- ATTACK SPEED (1 → 5x)
CreateSlider(190, "Tốc độ đánh", 1, 500, 100, function(val)
    ChangeStats:FireServer("AttackSpeed", val/100)
end)

-- Toggle Menu
ToggleButton.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
    ToggleButton.Text = Frame.Visible and "Đóng Menu" or "Mở Menu"
end)
