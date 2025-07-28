-- Load Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("99 Nights Utility", "Serpent")

-- Main tab
local Tab = Window:NewTab("Cheats")
local Section = Tab:NewSection("Main Features")

-- Kill Aura
_G.killAura = false
Section:NewToggle("Kill Aura", "Automatically attack nearby foes", function(state)
    _G.killAura = state
    if state then
        task.spawn(function()
            while _G.killAura and task.wait(0.1) do
                local player = game.Players.LocalPlayer
                local char = player.Character
                if char and char:FindFirstChild("Humanoid") then
                    for _, mob in ipairs(workspace:GetDescendants()) do
                        if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and mob ~= char then
                            mob.Humanoid:TakeDamage(10)
                        end
                    end
                end
            end
        end)
    end
end)

-- Auto Gather
_G.autoGather = false
Section:NewToggle("Auto Gather", "Collect resources automatically", function(state)
    _G.autoGather = state
    if state then
        task.spawn(function()
            while _G.autoGather and task.wait(1) do
                local player = game.Players.LocalPlayer
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, item in ipairs(workspace:GetDescendants()) do
                        if item:IsA("BasePart") and (item.Name == "Wood" or item.Name == "Fuel" or item.Name == "Food") then
                            item.CFrame = hrp.CFrame + Vector3.new(math.random(-3, 3), 0, math.random(-3, 3))
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
    if not target:IsA("Model") then return end
    if target:FindFirstChild("ESPBox") then return end
    local base = target:FindFirstChildWhichIsA("BasePart")
    if base then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "ESPBox"
        box.Adornee = base
        box.Size = target:GetExtentsSize()
        box.Color3 = (target.Name == "LostChild" and Color3.new(0,1,0) or target.Name == "Chest" and Color3.new(1,0.8,0) or Color3.new(1,0,0))
        box.Transparency = 0.5
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Parent = target
    end
end
local function removeESP()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:FindFirstChild("ESPBox") then
            obj.ESPBox:Destroy()
        end
    end
end
Section:NewToggle("ESP", "Show items, chests, mobs through walls", function(state)
    _G.espEnabled = state
    if state then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name == "Chest" or obj.Name == "Wolf" or obj.Name == "LostChild") then
                createESP(obj)
            end
        end
    else
        removeESP()
    end
end)

-- Teleport Dropdown
Section:NewDropdown("Teleport To", "Select point of interest", {"LostChild", "Chest", "Fuel"}, function(choice)
    local player = game.Players.LocalPlayer
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _, obj in ipairs(workspace:GetDescendants()) do
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

-- Walk Speed
Section:NewSlider("Speed", "Set walk speed (default 16)", 200, 16, function(val)
    local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = val end
end)

-- Refresh ESP Button
Section:NewButton("Refresh ESP", "Reapply ESP highlights", function()
    removeESP()
    task.wait(0.1)
    if _G.espEnabled then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name == "Chest" or obj.Name == "Wolf" or obj.Name == "LostChild") then
                createESP(obj)
            end
        end
    end
end)

-- ========= NEW FEATURES SECTION =========
local Extra = Tab:NewSection("Extra Utilities")

-- Infinite Jump
_G.infJump = false
Extra:NewToggle("Infinite Jump", "Jump repeatedly mid-air", function(state)
    _G.infJump = state
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.infJump then
        local player = game.Players.LocalPlayer
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- No Clip
_G.noclip = false
Extra:NewToggle("No Clip", "Walk through walls", function(state)
    _G.noclip = state
    task.spawn(function()
        while _G.noclip and task.wait() do
            local char = game.Players.LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end)

-- Auto Eat
_G.autoEat = false
Extra:NewToggle("Auto Eat Food", "Eats food when hungry", function(state)
    _G.autoEat = state
    task.spawn(function()
        while _G.autoEat and task.wait(2) do
            -- Simulated example, change if game has actual hunger values
            local backpack = game.Players.LocalPlayer.Backpack
            for _, item in pairs(backpack:GetChildren()) do
                if item.Name:lower():find("food") or item.Name == "Apple" or item.Name == "Meat" then
                    item:Activate() -- try consume
                end
            end
        end
    end)
end)

-- Fly Mode
_G.flying = false
Extra:NewToggle("Fly Mode", "Toggle flying on/off", function(state)
    _G.flying = state
    local player = game.Players.LocalPlayer
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local bv = Instance.new("BodyVelocity", hrp)
    bv.Name = "FlyVel"
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    while _G.flying and task.wait() do
        bv.Velocity = Vector3.new(0, 50, 0)
    end
    bv:Destroy()
end)

-- Reset Button
Extra:NewButton("Reset Character", "Respawn instantly", function()
    local player = game.Players.LocalPlayer
    if player.Character then
        player.Character:BreakJoints()
    end
end)

-- Label
Section:NewLabel("Features: Kill Aura, Gather, ESP, Fly, Jump, AutoEat, Teleport")
