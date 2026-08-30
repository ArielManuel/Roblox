local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local enabled = true

local gui = Instance.new("ScreenGui")
gui.Name = "PromptToggle"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 70)
frame.Position = UDim2.new(0.5, -90, 0, 40)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(55, 55, 65)
stroke.Thickness = 1
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 25)
title.Position = UDim2.new(0, 10, 0, 7)
title.BackgroundTransparency = 1
title.Text = "Auto Prompts"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamSemibold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 65, 0, 27)
toggle.Position = UDim2.new(1, -75, 0, 36)
toggle.BackgroundColor3 = Color3.fromRGB(55, 180, 95)
toggle.BorderSizePixel = 0
toggle.Text = "ON"
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.TextSize = 13
toggle.Font = Enum.Font.GothamBold
toggle.Parent = frame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 9)
toggleCorner.Parent = toggle

local status = Instance.new("TextLabel")
status.Size = UDim2.new(0, 80, 0, 27)
status.Position = UDim2.new(0, 10, 0, 36)
status.BackgroundTransparency = 1
status.Text = "Enabled"
status.TextColor3 = Color3.fromRGB(180, 180, 190)
status.TextSize = 13
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = frame

toggle.MouseButton1Click:Connect(function()
    enabled = not enabled

    if enabled then
        toggle.Text = "ON"
        toggle.BackgroundColor3 = Color3.fromRGB(55, 180, 95)
        status.Text = "Enabled"
    else
        toggle.Text = "OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(180, 60, 65)
        status.Text = "Disabled"
    end
end)

-- Draggable UI
local dragging = false
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart

        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

local function setupPrompt(v)
    if v:IsA("ProximityPrompt") then
        v.HoldDuration = 0
        v.MaxActivationDistance = 100

        task.spawn(function()
            while v.Parent do
                if enabled and v.Enabled then
                    fireproximityprompt(v)
                end

                task.wait(0.05)
            end
        end)
    end
end

-- Existing prompts
for _, v in ipairs(Workspace:GetDescendants()) do
    setupPrompt(v)
end

-- Prompts added later
Workspace.DescendantAdded:Connect(setupPrompt)
