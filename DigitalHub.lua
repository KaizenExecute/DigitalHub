-- Cleanup Old GUIs
local pg = game.Players.LocalPlayer:WaitForChild("PlayerGui")
for _, gui in ipairs(pg:GetChildren()) do
    if gui:IsA("ScreenGui") and (gui.Name == "TouchUI" or gui.Name == "LoadingScreen") then
        gui:Destroy()
    end
end

-- Loading Screen
local loadingScreen = Instance.new("ScreenGui", pg)
loadingScreen.Name = "LoadingScreen"
local frame = Instance.new("Frame", loadingScreen)
frame.Size = UDim2.new(0.4, 0, 0.2, 0)
frame.Position = UDim2.new(0.3, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1
local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 12)

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = "Loading 99 Nights Utility..."
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.FredokaOne
label.TextScaled = true

task.wait(2)
loadingScreen:Destroy()

-- Load Kavo UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🔥 99 Nights Utility 🔥", "Ocean")

-- Mobile Button Toggle UI
local UIS = game:GetService("UserInputService")
local toggleGui = Instance.new("ScreenGui", pg)
toggleGui.Name = "TouchUI"
toggleGui.ResetOnSpawn = false

local toggleBtn = Instance.new("TextButton", toggleGui)
toggleBtn.Size = UDim2.new(0, 100, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 1, -60)
toggleBtn.Text = "📂 Toggle"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextScaled = true
toggleBtn.AutoButtonColor = true

local btnCorner = Instance.new("UICorner", toggleBtn)
btnCorner.CornerRadius = UDim.new(0, 8)

toggleBtn.MouseButton1Click:Connect(function()
    Library:ToggleUI()
end)

-- KEYBIND (PC support)
Window:NewTab("UI"):NewKeybind("RightCtrl", "Toggle GUI", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)

-- Now continue below with your existing features (Kill Aura, Auto Gather, etc.)
-- Example:
local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("Core Cheats")

Section:NewLabel("Mobile UI Enabled ✅")
Section:NewLabel("Touch Button: Lower Left")

-- Re-add your full features here
-- (Kill Aura, Auto Gather, ESP, etc.)

-- Example Toggle
Section:NewToggle("Kill Aura", "Automatically attack nearby mobs", function(state)
    _G.killAura = state
    -- Add logic...
end)
