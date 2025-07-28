--[[
  🔥 99 Nights GOA-Style UI by Ainsoft_Tech 🔥
  - Loading screen, draggable GUI, mobile toggle, Kill Aura, GOA visuals
--]]

-- Cleanup Old GUIs
local pg = game.Players.LocalPlayer:WaitForChild("PlayerGui")
for _, gui in ipairs(pg:GetChildren()) do
    if gui:IsA("ScreenGui") and (gui.Name == "TouchUI" or gui.Name == "LoadingScreen" or gui.Name == "CustomUI") then
        gui:Destroy()
    end
end

-- GOA-Style Loading Screen
local blur = Instance.new("BlurEffect", game:GetService("Lighting"))
blur.Size = 20

local loadingScreen = Instance.new("ScreenGui", pg)
loadingScreen.Name = "LoadingScreen"
loadingScreen.IgnoreGuiInset = true
loadingScreen.ResetOnSpawn = false

local bg = Instance.new("Frame", loadingScreen)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
bg.BackgroundTransparency = 0.3

local frame = Instance.new("Frame", bg)
frame.Size = UDim2.new(0, 250, 0, 80)
frame.Position = UDim2.new(0.5, -125, 0.5, -40)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = "Loading Custom UI..."
label.TextColor3 = Color3.new(1, 1, 1)
label.Font = Enum.Font.FredokaOne
label.TextScaled = true

task.wait(2)
blur:Destroy()
loadingScreen:Destroy()

-- Create Main GUI
local gui = Instance.new("ScreenGui", pg)
gui.Name = "CustomUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- Main Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 300)
main.Position = UDim2.new(0.5, -200, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.Name = "MainFrame"
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Re-center just in case
task.wait()
main.Position = UDim2.new(0.5, -main.Size.X.Offset / 2, 0.5, -main.Size.Y.Offset / 2)

-- Drag Function
local function dragify(dragFrame, target)
    local UIS = game:GetService("UserInputService")
    local dragging, dragInput, dragStart, startPos

    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Drag Bar
local dragBar = Instance.new("Frame", main)
dragBar.Size = UDim2.new(1, 0, 0, 40)
dragBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
dragBar.BorderSizePixel = 0
dragBar.Name = "DragBar"
Instance.new("UICorner", dragBar).CornerRadius = UDim.new(0, 12)

dragify(dragBar, main)

-- Title
local title = Instance.new("TextLabel", dragBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "🔥 99 Nights Utility 🔥"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true

-- Kill Aura Toggle Button (GOA Style)
local killAuraToggle = Instance.new("TextButton", main)
killAuraToggle.Size = UDim2.new(0, 160, 0, 45)
killAuraToggle.Position = UDim2.new(0, 20, 0, 60)
killAuraToggle.Text = "Kill Aura: OFF"
killAuraToggle.Font = Enum.Font.GothamBold
killAuraToggle.TextScaled = true
killAuraToggle.TextColor3 = Color3.new(1, 1, 1)
killAuraToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Instance.new("UICorner", killAuraToggle).CornerRadius = UDim.new(0, 10)

-- Gradient
local gradient = Instance.new("UIGradient", killAuraToggle)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 140, 255))
}

-- Shadow
local shadow = Instance.new("ImageLabel", killAuraToggle)
shadow.ZIndex = 0
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)

-- Hover Effect
local function onHover(btn)
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(0, 190, 255)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    end)
end
onHover(killAuraToggle)

-- Toggle Behavior
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

dragify(toggleFrame, toggleFrame)

local toggleBtn = Instance.new("TextButton", toggleFrame)
toggleBtn.Size = UDim2.new(1, 0, 1, 0)
toggleBtn.Text = "📂 Toggle"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextScaled = true
toggleBtn.AutoButtonColor = true
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

onHover(toggleBtn)

toggleBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- PC Keybind (Right Ctrl)
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        main.Visible = not main.Visible
    end
end)
