--[[
    RIH4NX HUB ULTIMATE V7 - THE TROLL GOD UPDATE
    Added: Spin Fling, View Player, Creeper Look, Attach Ride
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RIH4NX_V7"
ScreenGui.Parent = (game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

local Theme = {
    Main = Color3.fromRGB(15, 15, 15),
    Sidebar = Color3.fromRGB(10, 10, 10),
    Accent = Color3.fromRGB(0, 255, 150),
    Text = Color3.fromRGB(255, 255, 255),
    Button = Color3.fromRGB(25, 25, 25)
}

-- Notification System
local function Notify(text)
    local n = Instance.new("Frame")
    n.Size = UDim2.new(0, 220, 0, 50); n.Position = UDim2.new(1, 10, 0.8, 0); n.BackgroundColor3 = Theme.Main; n.Parent = ScreenGui
    Instance.new("UICorner", n); local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,-10,1,0); l.Position = UDim2.new(0,10,0,0); l.Text = text; l.TextColor3 = Theme.Text; l.Font = Enum.Font.GothamBold; l.BackgroundTransparency = 1; l.Parent = n; l.TextSize = 13
    n:TweenPosition(UDim2.new(1, -230, 0.8, 0), "Out", "Quart", 0.4)
    task.delay(3, function() n:TweenPosition(UDim2.new(1, 10, 0.8, 0), "In", "Quart", 0.4); task.wait(0.5); n:Destroy() end)
end

-- Main Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 580, 0, 400); Main.Position = UDim2.new(0.5, -290, 0.5, -200); Main.BackgroundColor3 = Theme.Main; Main.Parent = ScreenGui; Instance.new("UICorner", Main)

-- Smooth Dragging
local dragToggle, dragStart, startPos
Main.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = true; dragStart = input.Position; startPos = Main.Position end end)
Main.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement and dragToggle then local delta = input.Position - dragStart; Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = false end end)

-- Sidebar & Container
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, 0); Sidebar.BackgroundColor3 = Theme.Sidebar; Sidebar.Parent = Main; Instance.new("UICorner", Sidebar)
local Container = Instance.new("Frame")
Container.Position = UDim2.new(0, 160, 0, 10); Container.Size = UDim2.new(1, -170, 1, -20); Container.BackgroundTransparency = 1; Container.Parent = Main

local Pages = {}
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0; Page.Parent = Container
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10); Pages[name] = Page; return Page
end

local HomeP = CreatePage("Home"); local PlayerP = CreatePage("Player"); local VisualP = CreatePage("Visuals"); local TrollP = CreatePage("Troll")

local function CreateTab(name, page)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35); btn.Position = UDim2.new(0.05, 0, 0, 60 + (#Sidebar:GetChildren()-2)*42); btn.BackgroundColor3 = Theme.Button; btn.Text = name; btn.TextColor3 = Theme.Text; btn.Font = Enum.Font.GothamBold; btn.Parent = Sidebar; Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() for _, p in pairs(Pages) do p.Visible = false end; page.Visible = true end)
end

CreateTab("Home", HomeP); CreateTab("Player", PlayerP); CreateTab("Visuals", VisualP); CreateTab("Troll", TrollP)

-- COMPONENTS
local function CreateToggle(parent, text, callback)
    local state = false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-10,0,35); btn.BackgroundColor3 = Theme.Button; btn.Text = "  "..text; btn.TextColor3 = Theme.Text; btn.Font = Enum.Font.GothamBold; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.Parent = parent; Instance.new("UICorner", btn)
    local ind = Instance.new("Frame"); ind.Size = UDim2.new(0,30,0,15); ind.Position = UDim2.new(1,-40,0.5,-7); ind.BackgroundColor3 = Color3.fromRGB(60,60,60); ind.Parent = btn; Instance.new("UICorner", ind).CornerRadius = UDim.new(1,0)
    btn.MouseButton1Click:Connect(function() state = not state; callback(state); ind.BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(60,60,60) end)
end

-- TROLL LOGIC
local targetName = ""
local function GetTarget()
    for _,p in pairs(Players:GetPlayers()) do if p.Name:lower():find(targetName) or p.DisplayName:lower():find(targetName) then return p end end
    return nil
end

-- TROLL TAB CONTENT
local TargetInput = Instance.new("TextBox")
TargetInput.Size = UDim2.new(1,-10,0,40); TargetInput.PlaceholderText = "Enter Target Name..."; TargetInput.Text = ""; TargetInput.BackgroundColor3 = Theme.Button; TargetInput.TextColor3 = Theme.Text; TargetInput.Parent = TrollP; Instance.new("UICorner", TargetInput)
TargetInput.FocusLost:Connect(function() targetName = TargetInput.Text:lower(); Notify("Targeted: "..targetName) end)

-- 1. Fling
local flingOn = false
CreateToggle(TrollP, "Spin Fling (Kill Target)", function(s)
    flingOn = s
    task.spawn(function()
        local hrp = LocalPlayer.Character.HumanoidRootPart
        while flingOn do
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(50), 0)
            local t = GetTarget()
            if t and t.Character then hrp.Position = t.Character.HumanoidRootPart.Position end
            task.wait()
        end
    end)
end)

-- 2. View Player
local viewing = false
CreateToggle(TrollP, "View Player (Spy)", function(s)
    viewing = s
    if viewing then
        local t = GetTarget()
        if t then workspace.CurrentCamera.CameraSubject = t.Character.Humanoid end
    else
        workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
    end
end)

-- 3. Creeper Look
local creepOn = false
CreateToggle(TrollP, "Creeper Look (Stare)", function(s)
    creepOn = s
    RunService.RenderStepped:Connect(function()
        if creepOn then
            local t = GetTarget()
            if t and t.Character then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, t.Character.HumanoidRootPart.Position)
            end
        end
    end)
end)

-- 4. Attach Ride
local attachOn = false
CreateToggle(TrollP, "Attach / Ride Player", function(s)
    attachOn = s
    task.spawn(function()
        while attachOn do
            local t = GetTarget()
            if t and t.Character then
                LocalPlayer.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
            end
            task.wait()
        end
    end)
end)

-- 5. Orbit
local orbitOn = false
CreateToggle(TrollP, "Orbit (Fast Spin)", function(s)
    orbitOn = s; local angle = 0
    task.spawn(function()
        while orbitOn do
            local t = GetTarget()
            if t and t.Character then
                angle = angle + 0.2
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(t.Character.HumanoidRootPart.Position + Vector3.new(math.cos(angle)*7, 2, math.sin(angle)*7), t.Character.HumanoidRootPart.Position)
            end
            task.wait()
        end
    end)
end)

-- Adding Basic Features to Player Tab
local function CreateSlider(parent, text, min, max, cb)
    local f = Instance.new("Frame"); f.Size = UDim2.new(1,-10,0,45); f.BackgroundColor3 = Theme.Button; f.Parent = parent; Instance.new("UICorner", f)
    local l = Instance.new("TextLabel"); l.Size = UDim2.new(1,0,0,20); l.Text = text; l.TextColor3 = Theme.Text; l.BackgroundTransparency = 1; l.Parent = f
    local b = Instance.new("Frame"); b.Size = UDim2.new(0.8,0,0,4); b.Position = UDim2.new(0.1,0,0.7,0); b.BackgroundColor3 = Color3.fromRGB(50,50,50); b.Parent = f
    local fill = Instance.new("Frame"); fill.Size = UDim2.new(0.2,0,1,0); fill.BackgroundColor3 = Theme.Accent; fill.Parent = b
    b.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            local conn; conn = RunService.RenderStepped:Connect(function()
                local p = math.clamp((UserInputService:GetMouseLocation().X - b.AbsolutePosition.X) / b.AbsoluteSize.X, 0, 1)
                fill.Size = UDim2.new(p,0,1,0); cb(math.floor(min + (max-min)*p))
                if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then conn:Disconnect() end
            end)
        end
    end)
end

CreateSlider(PlayerP, "WalkSpeed", 16, 300, function(v) LocalPlayer.Character.Humanoid.WalkSpeed = v end)
CreateSlider(PlayerP, "JumpPower", 50, 500, function(v) LocalPlayer.Character.Humanoid.JumpPower = v end)
CreateToggle(VisualP, "ESP Highlights", function(s)
    if s then
        for _,p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then Instance.new("Highlight", p.Character).Name = "RH_ESP" end end
    else
        for _,p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("RH_ESP") then p.Character.RH_ESP:Destroy() end end
    end
end)

-- Toggle Menu
UserInputService.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.RightControl then Main.Visible = not Main.Visible end end)

HomeP.Visible = true; Notify("RIH4NX TROLL GOD LOADED!")