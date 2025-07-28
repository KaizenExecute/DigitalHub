-- Cleanup Old GUIs
local pg = game.Players.LocalPlayer:WaitForChild("PlayerGui")
for _, gui in ipairs(pg:GetChildren()) do
    if gui:IsA("ScreenGui") and (gui.Name == "TouchUI" or gui.Name == "LoadingScreen" or gui.Name == "CustomUI") then
        gui:Destroy()
    end
end

-- Loading Screen
local loadingScreen = Instance.new("ScreenGui", pg)
loadingScreen.Name = "LoadingScreen"

local frame = Instance.new("Frame", loadingScreen)
frame.Size = UDim2.new(0.4, 0, 0.2, 0)
frame.Position = UDim2.new(0.3, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = "Loading Custom UI..."
label.TextColor3 = Color3.new(1, 1, 1)
label.Font = Enum.Font.FredokaOne
label.TextScaled = true

task.wait(2)
loadingScreen:Destroy()

-- Main Custom UI
local gui = Instance.new("ScreenGui", pg)
gui.Name = "CustomUI"
gui.ResetOnSpawn = false

-- Main Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 300)
main.Position = UDim2.new(0.5, -200, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
main.BorderSizePixel = 0
main.Name = "MainFrame"
main.Active = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- Function: Dragify Frame
local function dragify(frame)
    local UIS = game:GetService("UserInputService")
    local dragging, dragInput, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Make MainFrame Draggable
dragify(main)

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🔥 99 Nights Utility 🔥"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true

-- Feature: Kill Aura Toggle
local killAuraToggle = Instance.new("TextButton", main)
killAuraToggle.Size = UDim2.new(0, 150, 0, 40)
killAuraToggle.Position = UDim2.new(0, 20, 0, 60)
killAuraToggle.Text = "Kill Aura: OFF"
killAuraToggle.Font = Enum.Font.GothamBold
killAuraToggle.TextScaled = true
killAuraToggle.TextColor3 = Color3.new(1, 1, 1)
killAuraToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Instance.new("UICorner", killAuraToggle).CornerRadius = UDim.new(0, 8)

local killAuraState = false
killAuraToggle.MouseButton1Click:Connect(function()
    killAuraState = not killAuraState
    _G.killAura = killAuraState
    killAuraToggle.Text = "Kill Aura: " .. (killAuraState and "ON" or "OFF")
end)

-- Mobile Toggle Button
local toggleGui = Instance.new("ScreenGui", pg)
toggleGui.Name = "TouchUI"
toggleGui.ResetOnSpawn = false

local toggleFrame = Instance.new("Frame", toggleGui)
toggleFrame.Size = UDim2.new(0, 100, 0, 40)
toggleFrame.Position = UDim2.new(1, -110, 1, -60)
toggleFrame.BackgroundTransparency = 1
toggleFrame.Active = true
dragify(toggleFrame)

local toggleBtn = Instance.new("TextButton", toggleFrame)
toggleBtn.Size = UDim2.new(1, 0, 1, 0)
toggleBtn.Text = "📂 Toggle"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextScaled = true
toggleBtn.AutoButtonColor = true
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

toggleBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- Optional: PC Keybind
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        main.Visible = not main.Visible
    end
end)
