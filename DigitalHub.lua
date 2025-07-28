--[[
🔥 99 Nights GOA-Style UI by Ainsoft_Tech 🔥
--]]

-- SERVICES
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

-- CLEANUP OLD GUIS
for _, gui in ipairs(pg:GetChildren()) do
    if gui:IsA("ScreenGui") and (gui.Name == "TouchUI" or gui.Name == "LoadingScreen" or gui.Name == "CustomUI") then
        gui:Destroy()
    end
end

-- GOA LOADING SCREEN
local blur = Instance.new("BlurEffect")
blur.Size = 20
blur.Parent = Lighting

local loadingScreen = Instance.new("ScreenGui", pg)
loadingScreen.Name = "LoadingScreen"
loadingScreen.IgnoreGuiInset = true
loadingScreen.ResetOnSpawn = false

local bg = Instance.new("Frame", loadingScreen)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
bg.BackgroundTransparency = 0.2

local frame = Instance.new("Frame", bg)
frame.Size = UDim2.new(0, 250, 0, 80)
frame.Position = UDim2.new(0.5, -125, 0.5, -40)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = "Loading Custom UI..."
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.FredokaOne
label.TextScaled = true

task.wait(2)
loadingScreen:Destroy()
blur:Destroy()

-- MAIN UI
local mainGui = Instance.new("ScreenGui", pg)
mainGui.Name = "CustomUI"
mainGui.IgnoreGuiInset = true
mainGui.ResetOnSpawn = false

-- MAIN FRAME
local main = Instance.new("Frame", mainGui)
main.Size = UDim2.new(0, 400, 0, 300)
main.Position = UDim2.new(0.5, -200, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- DRAG FUNCTION
local function dragify(dragFrame, target)
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
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                        startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- TOP BAR
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 10)
dragify(topBar, main)

-- TITLE
local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "🔥 99 Nights Utility"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true

-- GOA BUTTON STYLING FUNCTION
local function createStyledButton(parent, position, text)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 160, 0, 45)
    btn.Position = position
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local gradient = Instance.new("UIGradient", btn)
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 140, 255))
    }

    local shadow = Instance.new("ImageLabel", btn)
    shadow.ZIndex = 0
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)

    -- Hover
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(0, 190, 255)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    end)

    return btn
end

-- KILL AURA TOGGLE
local killAuraToggle = createStyledButton(main, UDim2.new(0, 20, 0, 60), "Kill Aura: OFF")
local killAuraOn = false
killAuraToggle.MouseButton1Click:Connect(function()
    killAuraOn = not killAuraOn
    _G.killAura = killAuraOn
    killAuraToggle.Text = "Kill Aura: " .. (killAuraOn and "ON" or "OFF")
end)

-- MOBILE BUTTON
local toggleGui = Instance.new("ScreenGui", pg)
toggleGui.Name = "TouchUI"
toggleGui.ResetOnSpawn = false

local toggleFrame = Instance.new("Frame", toggleGui)
toggleFrame.Size = UDim2.new(0, 100, 0, 40)
toggleFrame.Position = UDim2.new(1, -110, 1, -60)
toggleFrame.BackgroundTransparency = 1
toggleFrame.Active = true
dragify(toggleFrame, toggleFrame)

local toggleBtn = createStyledButton(toggleFrame, UDim2.new(0, 0, 0, 0), "📂 Toggle")
toggleBtn.Size = UDim2.new(1, 0, 1, 0)
toggleBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- PC KEYBIND (RightCtrl)
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        main.Visible = not main.Visible
    end
end)
