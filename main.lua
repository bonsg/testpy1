--// ESP CHEST MODULE BY TV LE PHONG //--

local ESPChest = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Hàm tạo ESP cho một Chest
function ESPChest.Create(model)
    if model:FindFirstChild("ChestESP_Highlight") then return end

    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "ChestESP_Highlight"
    highlight.FillColor = Color3.fromRGB(255, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 180, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Adornee = model
    highlight.Parent = model

    -- Billboard
    local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    if not part then return end

    local bill = Instance.new("BillboardGui")
    bill.Name = "ChestESP_Billboard"
    bill.Size = UDim2.new(0, 130, 0, 30)
    bill.AlwaysOnTop = true
    bill.Adornee = part
    bill.Parent = model

    local text = Instance.new("TextLabel")
    text.Parent = bill
    text.BackgroundTransparency = 1
    text.Size = UDim2.new(1, 0, 1, 0)
    text.Font = Enum.Font.FredokaOne
    text.TextScaled = true
    text.TextColor3 = Color3.fromRGB(255, 255, 0)
    text.TextStrokeTransparency = 0.3
    text.Text = "Chest"

    -- Update Distance
    task.spawn(function()
        while model.Parent do
            local root = Character:FindFirstChild("HumanoidRootPart")
            if root and part then
                local dist = (part.Position - root.Position).Magnitude
                text.Text = "Chest [" .. math.floor(dist) .. "m]"
            end
            task.wait(0.1)
        end
    end)
end

-- Tự động scan Chest trong map
function ESPChest.Start()
    task.spawn(function()
        while true do
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v.Name:lower():find("chest") then
                    ESPChest.Create(v)
                end
            end
            task.wait(2)
        end
    end)
end

return ESPChest
