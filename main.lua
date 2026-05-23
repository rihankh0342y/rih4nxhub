--[[
    RIH4NX HUB ULTIMATE - V6
    Everything Combined: Draggable, Tabs, Sliders, Toggles, Fly, Noclip, ESP, Stalk, Orbit
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RIH4NX_ULTIMATE"
ScreenGui.Parent = (game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

-- Theme
local Theme = {
    Main = Color3.fromRGB(18, 18, 18),
    Sidebar = Color3.fromRGB(12, 12, 12),
    Accent = Color3.fromRGB(0, 170, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Button = Color3.fromRGB(30, 30, 30)
}

-- Notification System
local function Notify(text)
    local n = Instance.new("Frame")
    n.Size = UDim2.new(0, 220, 0, 50)
    n.Position = UDim2.new(1, 10, 0.8, 0)
    n.BackgroundColor3 = Theme.Main
    n.Parent = ScreenGui
    Instance.new("UICorner", n)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,-10,1,0); l.Position = UDim2.new(0,10,0,0); l.Text = text; l.TextColor3 = Theme.Text; l.Font = Enum.Font.GothamBold; l.TextXAlignment = Enum.TextXAlignment.Left; l.BackgroundTransparency = 1; l.Parent = n
    n:TweenPosition(UDim2.new(1, -230, 0.8, 0), "Out", "Quart", 0.4)
    task.delay(3, function() n:TweenPosition(UDim2.new(1, 10, 0.8, 0), "In", "Quart", 0.4); task.wait(0.5); n:Destroy() end)
end

-- Main Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 580, 0, 380)
Main.Position = UDim2.new(0.5, -290, 0.5, -190)
Main.BackgroundColor3 = Theme.Main
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Dragging
local dragToggle, dragStart, startPos
Main.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = true; dragStart = input.Position; startPos = Main.Position end end)
Main.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement and dragToggle then local delta = input.Position - dragStart; Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = false end end)

-- Sidebar & Container
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, 0); Sidebar.BackgroundColor3 = Theme.Sidebar; Sidebar.Parent = Main; Instance.new("UICorner", Sidebar)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,50); Title.Text = "RIH4NX HUB"; Title.TextColor3 = Theme.Accent; Title.Font = Enum.Font.GothamBold; Title.TextSize = 20; Title.BackgroundTransparency = 1; Title.Parent = Sidebar

local Container = Instance.new("Frame")
Container.Position = UDim2.new(0, 160, 0, 10); Container.Size = UDim2.new(1, -170, 1, -20); Container.BackgroundTransparency = 1; Container.Parent = Main

local Pages = {}
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0; Page.Parent = Container
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)
    Pages[name] = Page
    return Page
end

-- Creating Pages
local HomeP = CreatePage("Home")
local PlayerP = CreatePage("Player")
local VisualP = CreatePage("Visuals")
local TrollP = CreatePage("Troll")

-- Tab Function
local function CreateTab(name, page)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, 60 + (#Sidebar:GetChildren()-2)*42)
    btn.BackgroundColor3 = Theme.Button; btn.Text = name; btn.TextColor3 = Theme.Text; btn.Font = Enum.Font.GothamBold; btn.Parent = Sidebar; Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        page.Visible = true
    end)
end

CreateTab("Home", HomeP)
CreateTab("Player", PlayerP)
CreateTab("Visuals", VisualP)
CreateTab("Troll", TrollP)

-- UTILITY COMPONENTS
local function CreateSlider(parent, text, min, max, default, callback)
    local f = Instance.new("Frame"); f.Size = UDim2.new(1,-10,0,50); f.BackgroundColor3 = Theme.Button; f.Parent = parent; Instance.new("UICorner", f)
    local l = Instance.new("TextLabel"); l.Size = UDim2.new(1,0,0,25); l.Text = text..": "..default; l.TextColor3 = Theme.Text; l.BackgroundTransparency = 1; l.Parent = f
    local b = Instance.new("Frame"); b.Size = UDim2.new(0.8,0,0,4); b.Position = UDim2.new(0.1,0,0.7,0); b.BackgroundColor3 = Color3.fromRGB(60,60,60); b.Parent = f
    local fill = Instance.new("Frame"); fill.Size = UDim2.new((default-min)/(max-min),0,1,0); fill.BackgroundColor3 = Theme.Accent; fill.Parent = b
    b.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            local conn; conn = RunService.RenderStepped:Connect(function()
                local p = math.clamp((UserInputService:GetMouseLocation().X - b.AbsolutePosition.X) / b.AbsoluteSize.X, 0, 1)
                fill.Size = UDim2.new(p,0,1,0); local val = math.floor(min + (max-min)*p); l.Text = text..": "..val; callback(val)
                if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then conn:Disconnect() end
            end)
        end
    end)
end

local function CreateToggle(parent, text, callback)
    local state = false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-10,0,40); btn.BackgroundColor3 = Theme.Button; btn.Text = "  "..text; btn.TextColor3 = Theme.Text; btn.Font = Enum.Font.GothamBold; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.Parent = parent; Instance.new("UICorner", btn)
    local ind = Instance.new("Frame"); ind.Size = UDim2.new(0,35,0,18); ind.Position = UDim2.new(1,-45,0.5,-9); ind.BackgroundColor3 = Color3.fromRGB(60,60,60); ind.Parent = btn; Instance.new("UICorner", ind).CornerRadius = UDim.new(1,0)
    btn.MouseButton1Click:Connect(function()
        state = not state; callback(state)
        ind.BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(60,60,60)
    end)
end

-- HOME PAGE CONTENT
local Welcome = Instance.new("TextLabel")
Welcome.Size = UDim2.new(1,0,0,40); Welcome.Text = "Welcome, "..LocalPlayer.DisplayName; Welcome.TextColor3 = Theme.Accent; Welcome.Font = Enum.Font.GothamBold; Welcome.TextSize = 22; Welcome.BackgroundTransparency = 1; Welcome.Parent = HomeP

local Desc = Instance.new("TextLabel")
Desc.Size = UDim2.new(1,0,0,20); Desc.Text = "Ultimate Troll & Player Menu Loaded"; Desc.TextColor3 = Theme.Text; Desc.Font = Enum.Font.Gotham; Desc.BackgroundTransparency = 1; Desc.Parent = HomeP

-- PLAYER PAGE CONTENT
CreateSlider(PlayerP, "WalkSpeed", 16, 300, 16, function(v) LocalPlayer.Character.Humanoid.WalkSpeed = v end)
CreateSlider(PlayerP, "JumpPower", 50, 500, 50, function(v) LocalPlayer.Character.Humanoid.JumpPower = v end)

local flyOn = false
CreateToggle(PlayerP, "Fly Mode", function(s)
    flyOn = s
    local hrp = LocalPlayer.Character.HumanoidRootPart
    if flyOn then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "RIH_FLY"; bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
        task.spawn(function()
            while flyOn do
                bv.Velocity = LocalPlayer.Character.Humanoid.MoveDirection * 100
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

local noclipOn = false
CreateToggle(PlayerP, "Noclip", function(s) noclipOn = s end)
RunService.Stepped:Connect(function()
    if noclipOn and LocalPlayer.Character then
        for _,v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

-- VISUALS PAGE
CreateToggle(VisualP, "Player ESP Highlights", function(s)
    if s then
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = Instance.new("Highlight", p.Character); h.Name = "RH_ESP"; h.FillColor = Theme.Accent
            end
        end
    else
        for _,p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("RH_ESP") then p.Character.RH_ESP:Destroy() end end
    end
end)

-- TROLL PAGE CONTENT (STALKER & ORBIT)
local targetName = ""
local stalkOn = false
local orbitOn = false

local TargetInput = Instance.new("TextBox")
TargetInput.Size = UDim2.new(1,-10,0,40); TargetInput.PlaceholderText = "Target Player Name..."; TargetInput.Text = ""; TargetInput.BackgroundColor3 = Theme.Button; TargetInput.TextColor3 = Theme.Text; TargetInput.Font = Enum.Font.GothamBold; TargetInput.Parent = TrollP; Instance.new("UICorner", TargetInput)
TargetInput.FocusLost:Connect(function() targetName = TargetInput.Text:lower(); Notify("Targeted: "..targetName) end)

local function GetTarget()
    for _,p in pairs(Players:GetPlayers()) do if p.Name:lower():find(targetName) or p.DisplayName:lower():find(targetName) then return p end end
    return nil
end

local function TrollBtn(txt, cb)
    local b = Instance.new("TextButton"); b.Size = UDim2.new(1,-10,0,35); b.BackgroundColor3 = Color3.fromRGB(40,40,40); b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.Parent = TrollP; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

TrollBtn("Teleport to Target", function()
    local t = GetTarget()
    if t and t.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3) end
end)

CreateToggle(TrollP, "Auto-Stalk (Follow)", function(s)
    stalkOn = s
    task.spawn(function()
        while stalkOn do
            local t = GetTarget()
            if t and t.Character then
                LocalPlayer.Character.Humanoid:MoveTo(t.Character.HumanoidRootPart.Position + Vector3.new(2,0,2))
            end
            task.wait()
        end
    end)
end)

CreateToggle(TrollP, "Orbit Target", function(s)
    orbitOn = s
    local angle = 0
    task.spawn(function()
        while orbitOn do
            local t = GetTarget()
            if t and t.Character then
                angle = angle + 0.1
                local offset = Vector3.new(math.cos(angle)*6, 3, math.sin(angle)*6)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(t.Character.HumanoidRootPart.Position + offset, t.Character.HumanoidRootPart.Position)
            end
            task.wait()
        end
    end)
end)

-- Close / Hide UI
UserInputService.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.RightControl then Main.Visible = not Main.Visible end end)

HomeP.Visible = true
Notify("RIH4NX ULTIMATE LOADED!")