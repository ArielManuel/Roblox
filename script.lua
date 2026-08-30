local Workspace = game:GetService("Workspace")

local triggered = {}

local function setupPrompt(v)
    if not v:IsA("ProximityPrompt") then
        return
    end

    v.HoldDuration = 0
    v.MaxActivationDistance = 100

    if triggered[v] then
        return
    end

    triggered[v] = true

    task.spawn(function()
        task.wait(0.05)

        if v.Parent and v.Enabled then
            fireproximityprompt(v)
        end
    end)
end

-- Existing prompts
for _, v in ipairs(Workspace:GetDescendants()) do
    setupPrompt(v)
end

-- New prompts that appear later
Workspace.DescendantAdded:Connect(setupPrompt)
