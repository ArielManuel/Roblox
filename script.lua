local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local enabled = false
local triggered = {}

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "AutoInstantUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 140, 0, 45)
button.Position = UDim2.new(0.5, -70, 0, 50)
button.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 16
button.Font = Enum.Font.GothamBold
button.Text = "AUTO: OFF"
button.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = button

local function triggerPrompt(prompt)
    if not enabled then
        return
    end

    if not prompt:IsA("ProximityPrompt") then
        return
    end

    -- Instant
    prompt.HoldDuration = 0
    prompt.MaxActivationDistance = 100

    -- Huwag paulit-ulit sa parehong prompt
    if triggered[prompt] then
        return
    end

    triggered[prompt] = true

    if prompt.Enabled and prompt.Parent then
        fireproximityprompt(prompt)
    end
end

local function scanPrompts()
    for _, object in ipairs(Workspace:GetDescendants()) do
        triggerPrompt(object)
    end
end

-- ON / OFF
button.MouseButton1Click:Connect(function()
    enabled = not enabled

    if enabled then
        button.Text = "AUTO: ON"
        button.BackgroundColor3 = Color3.fromRGB(55, 180, 95)

        -- Allow prompts to activate again when turned ON
        triggered = {}
        scanPrompts()
    else
        button.Text = "AUTO: OFF"
        button.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end
end)

-- New prompts
Workspace.DescendantAdded:Connect(function(object)
    if enabled then
        task.wait(0.05)
        triggerPrompt(object)
    end
end)
