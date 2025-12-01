-- ======= SETUP =======

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local starterWalk = humanoid.WalkSpeed
local starterJump = humanoid.JumpPower
local starterGravity = workspace.Gravity

-- AttackSpeed Value (tự tạo cho game của bạn)
local atk = character:FindFirstChild("AttackSpeed")
if not atk then
    atk = Instance.new("NumberValue")
    atk.Name = "AttackSpeed"
    atk.Value = 1   -- 1.0x attack speed mặc định
    atk.Parent = character
end

-- ======= GUI =======

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "AdvancedControlGUI"

-- Nút mở menu
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 120, 0, 40)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.Text = "Mở Menu"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 18
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Parent = ScreenGui

local TBcorner = Instance.new("UICorner", ToggleButton)
TBcorner.CornerRadius = UDim.new(0, 10)

-- Khung menu
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 320, 0, 360) -- tăng chiều cao UI
Frame.Position = UDim2.new(0, 20, 0, 70)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Visible = false
Frame.Parent = ScreenGui

local Fcorner = Instance.new("UICorner", Frame)
Fcorner.CornerRadius = UDim.new(0, 12)

-- ======= TITLE =======
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "⚙️ Điều khiển nhân vật"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = Frame

-- ======= FUNCTION TẠO SLIDER =======

local UserInputService = game:GetService("UserInputService")

local function CreateSlider(parent, yPos, text, min, max, default, callback)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 30)
    Label.Position = UDim2.new(0, 10, 0, yPos)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. default
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 16
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = parent

    local Slider = Instance.new("Frame")
    Slider.Size = UDim2.new(0, 280, 0, 8)
    Slider.Position = UDim2.new(0, 20, 0, yPos + 25)
    Slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Slider.Parent = parent

    local SCorner = Instance.new("UICorner", Slider)
    SCorner.CornerRadius = UDim.new(0, 4)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new((default - min)/(max - min), -7, 0.5, -7)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Parent = Slider

    local KCorner = Instance.new("UICorner", Knob)
    KCorner.CornerRadius = UDim.new(0, 7)

    local dragging = false

    Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local x = math.clamp(input.Position.X - Slider.AbsolutePosition.X, 0, Slider.AbsoluteSize.X)
            Knob.Position = UDim2.new(0, x - 7, 0.5, -7)

            local value = math.floor(min + (x / Slider.AbsoluteSize.X) * (max - min))
            Label.Text = text .. ": " .. value
            callback(value)
        end
    end)
end

-- ======= TẠO SLIDER =======

CreateSlider(Frame, 50, "Tốc độ", 0, 120, starterWalk, function(val)
    humanoid.WalkSpeed = val
end)

CreateSlider(Frame, 120, "Nhảy cao", 0, 150, starterJump, function(val)
    humanoid.JumpPower = val
end)

CreateSlider(Frame, 190, "Gravity", 0, 196, starterGravity, function(val)
    workspace.Gravity = val
end)

-- ⭐ NEW: Attack Speed Slider ⭐
CreateSlider(Frame, 260, "Tốc độ đánh", 1, 500, atk.Value * 100, function(val)
    atk.Value = val / 100  -- 100 = 1.0x, 200 = 2.0x
end)

-- ======= RESET =======

local ResetButton = Instance.new("TextButton")
ResetButton.Size = UDim2.new(0, 120, 0, 35)
ResetButton.Position = UDim2.new(0, 100, 0, 310)
ResetButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ResetButton.Text = "Reset mặc định"
ResetButton.Font = Enum.Font.GothamBold
ResetButton.TextSize = 16
ResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetButton.Parent = Frame

local RCorner = Instance.new("UICorner", ResetButton)
RCorner.CornerRadius = UDim.new(0, 10)

ResetButton.MouseButton1Click:Connect(function()
    humanoid.WalkSpeed = starterWalk
    humanoid.JumpPower = starterJump
    workspace.Gravity = starterGravity
    atk.Value = 1
end)

-- ======= TOGGLE MENU =======

ToggleButton.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
    ToggleButton.Text = Frame.Visible and "Đóng Menu" or "Mở Menu"
end)
