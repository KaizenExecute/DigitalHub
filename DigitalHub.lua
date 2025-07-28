-- Load Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("99 Nights Utility", "Serpent")

-- Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Main Tab
local Tab = Window:NewTab("Cheats")
local Section = Tab:NewSection("Main Features")

-- Kill Aura with Range
_G.killAura = false
_G.auraRange = 20
Section:NewToggle("Kill Aura", "Auto attack nearby mobs", function(state)
    _G.killAura = state
    if state then
        task.spawn(function()
            while _G.killAura and task.wait(0.1) do
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, mob in ipairs(Workspace:GetDescendants()) do
                        if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and mob ~= char then
                            local mobHRP = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChildWhichIsA("BasePart")
                            if mobHRP and (mobHRP.Position - hrp.Position).Magnitude <= _G.auraRange then
                                mob.Humanoid:TakeDamage(10)
                            end
                        end
                    end
                end
            end
        end)
    end
end)
Section:NewSlider("Aura Range", "Set Kill Aura range", 100, 10, function(val)
    _G.auraRange = val
end)

-- Auto Gather Items
_G.autoGather = false
Section:NewToggle("Auto Gather", "Pull resources to you", function(state)
    _G.autoGather = state
    if state then
        task.spawn(function()
            while _G.autoGather and task.wait(1) do
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, item in ipairs(Workspace:GetDescendants()) do
                        if item:IsA("BasePart") and table.find({"Wood", "Fuel", "Food"}, item.Name) then
                            item.CFrame = hrp.CFrame + Vector3.new(math.random(-3,3), 0, math.random(-3,3))
                        end
                    end
                end
            end
        end)
    end
end)

-- ESP
_G.espEnabled = false
local function createESP(target)
    if not target:IsA("Model") or target:FindFirstChild("ESPBox") then return end
    local base = target:FindFirstChildWhichIsA("BasePart")
    if base then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "ESPBox"
        box.Adornee = base
        box.Size = target:GetExtentsSize()
        box.Color3 = (target.Name == "LostChild" and Color3.new(0,1,0) or target.Name == "Chest" and Color3.new(1,1,0) or Color3.new(1,0,0))
        box.Transparency = 0.5
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Parent = target
    end
end
local function removeESP()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:FindFirstChild("ESPBox") then obj.ESPBox:Destroy() end
    end
end
Section:NewToggle("ESP", "See mobs, chests, etc.", function(state)
    _G.espEnabled = state
    if state then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name == "Chest" or obj.Name == "Wolf" or obj.Name == "LostChild") then
                createESP(obj)
            end
        end
    else
        removeESP()
    end
end)

-- Teleport To Dropdown
Section:NewDropdown("Teleport To", "Go to NPCs or items", {"Camp", "LostChild", "Chest", "Fuel"}, function(choice)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name == choice and obj:IsA("Model") then
                local base = obj:FindFirstChildWhichIsA("BasePart")
                if base then
                    hrp.CFrame = base.CFrame + Vector3.new(0, 3, 0)
                    break
                end
            end
        end
    end
end)

-- Bring Items Section
local Items = {"Scrap", "Fuel", "Food", "Gear"}
Section:NewDropdown("Bring Item", "Teleport item to you", Items, function(choice)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _, item in ipairs(Workspace:GetDescendants()) do
            if item:IsA("BasePart") and item.Name == choice then
                item.CFrame = hrp.CFrame + Vector3.new(math.random(-3, 3), 0, math.random(-3, 3))
            end
        end
    end
end)

-- Instant Chest Open
Section:NewButton("Open All Chests", "Simulate instant open", function()
    for _, chest in ipairs(Workspace:GetDescendants()) do
        if chest:IsA("Model") and chest.Name == "Chest" and chest:FindFirstChild("ClickDetector") then
            fireclickdetector(chest.ClickDetector)
        end
    end
end)

-- Speed
Section:NewSlider("Speed", "Adjust WalkSpeed", 200, 16, function(val)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = val end
end)

-- ESP Refresh
Section:NewButton("Refresh ESP", "Reapplies ESP highlights", function()
    removeESP()
    task.wait(0.1)
    if _G.espEnabled then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name == "Chest" or obj.Name == "Wolf" or obj.Name == "LostChild") then
                createESP(obj)
            end
        end
    end
end)

-- Extra Tab
local Extra = Tab:NewSection("Extra Utilities")

-- Infinite Jump
_G.infJump = false
Extra:NewToggle("Infinite Jump", "Jump repeatedly in air", function(state)
    _G.infJump = state
end)
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.infJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- No Clip
_G.noclip = false
Extra:NewToggle("No Clip", "Walk through walls", function(state)
    _G.noclip = state
    task.spawn(function()
        while _G.noclip and task.wait() do
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end)

-- Auto Eat
_G.autoEat = false
Extra:NewToggle("Auto Eat", "Eats when hungry", function(state)
    _G.autoEat = state
    task.spawn(function()
        while _G.autoEat and task.wait(2) do
            for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                if item.Name:lower():find("food") or item.Name == "Apple" then
                    item:Activate()
                end
            end
        end
    end)
end)

-- Fly
_G.flying = false
Extra:NewToggle("Fly", "Fly upward", function(state)
    _G.flying = state
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local bv = Instance.new("BodyVelocity", hrp)
    bv.Name = "FlyVel"
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    while _G.flying and task.wait() do
        bv.Velocity = Vector3.new(0, 50, 0)
    end
    bv:Destroy()
end)

-- Reset
Extra:NewButton("Reset", "Respawn character", function()
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end)

-- Open/Close UI Keybind
Tab:NewKeybind("Toggle UI", "Show/Hide GUI", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)
