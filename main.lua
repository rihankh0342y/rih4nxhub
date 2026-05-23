--[[
    RIH4NX HUB V4 - PREMIER EDITION
    Features: Draggable, Tabs, Notifications, Sliders, Toggles, Fly, Noclip, ESP
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RIH4NX_PRO"
ScreenGui.Parent = (game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

-- Theme Colors
local Theme = {
    Main = Color3.fromRGB(20, 20, 20),
    Sidebar = Color3.fromRGB(15, 15, 15),
    Accent = Color3.fromRGB(0, 170, 255),
    Text = Color3.fromRGB(255, 255, 255),
    SecondaryText = Color3.fromRGB(200, 200, 200)
}

-- Notification System
local function Notify(text)
    local NotifyFrame = Instance.new("Frame")
    NotifyFrame.Size = UDim2.new(0, 250, 0, 50)
    NotifyFrame.Position = UDim2.new(1, 10, 0.85, 0)
    NotifyFrame.BackgroundColor3 = Theme.Main
    NotifyFrame.Parent = ScreenGui
    Instance.new("UICorner", NotifyFrame).CornerRadius = UDim.new(0, 8)
    
    local Border = Instance.new("Frame")
    Border.Size = UDim2.new(0, 4, 1, 0)
    Border.BackgroundColor3 = Theme.Accent
    Border.Parent = NotifyFrame
    Instance.new("UICorner", Border)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = NotifyFrame

    NotifyFrame:TweenPosition(UDim2.new(1, -260, 0.85, 0), "Out", "Quart", 0.4)
    task.delay(3, function()
        NotifyFrame:TweenPosition(UDim2.new(1, 10, 0.85, 0), "In", "Quart", 0.4)
        task.wait(0.5)
        NotifyFrame:Destroy()
    end)
end

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Theme.Main
Main.Size = UDim2.new(0, 550, 0, 350)
Main.Position = UDim2.new(0.5, -275, 0.5, -175)
Main.BorderSizePixel = 0
Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Make Draggable
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.Parent = Main
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "RIH4NX HUB"
Title.TextColor3 = Theme.Accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1
Title.Parent = Sidebar

-- Container
local Container = Instance.new("Frame")
Container.Position = UDim2.new(0, 160, 0, 10)
Container.Size = UDim2.new(1, -170, 1, -20)
Container.BackgroundTransparency = 1
Container.Parent = Main

local Pages = {}
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 0
    Page.Visible = false
    Page.Parent = Container
    local Layout = Instance.new("UIListLayout", Page)
    Layout.Padding = UDim.new(0, 10)
    Pages[name] = Page
    return Page
end

local Home = CreatePage("Home")
local Player = CreatePage("Player")
local Visuals = CreatePage("Visuals")

-- Component: Slider
local function CreateSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -10, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SliderFrame.Parent = parent
    Instance.new("UICorner", SliderFrame)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 25)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Text = text .. ": " .. default
    Label.TextColor3 = Theme.Text
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    Label.Parent = SliderFrame

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(0.9, 0, 0, 4)
    Bar.Position = UDim2.new(0.05, 0, 0.7, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Bar.Parent = SliderFrame

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Theme.Accent
    Fill.Parent = Bar

    local dragging = false
    local function Update()
        local percent = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(percent, 0, 1, 0)
        local val = math.floor(min + (max - min) * percent)
        Label.Text = text .. ": " .. val
        callback(val)
    end

    Bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update() end end)
end

-- Component: Toggle
local function CreateToggle(parent, text, callback)
    local State = false
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.Text = "  " .. text
    Btn.TextColor3 = Theme.Text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = parent
    Instance.new("UICorner", Btn)

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 40, 0, 20)
    Indicator.Position = UDim2.new(1, -50, 0.5, -10)
    Indicator.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Indicator.Parent = Btn
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 16, 0, 16)
    Dot.Position = UDim2.new(0, 2, 0.5, -8)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.Parent = Indicator
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    Btn.MouseButton1Click:Connect(function()
        State = not State
        TweenService:Create(Indicator, TweenInfo.new(0.3), {BackgroundColor3 = State and Theme.Accent or Color3.fromRGB(60, 60, 60)}):Play()
        TweenService:Create(Dot, TweenInfo.new(0.3), {Position = State and UDim2.new(0, 22, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        callback(State)
    end)
end

-- Tabs Creator
local function CreateTab(name, page)
    local Tab = Instance.new("TextButton")
    Tab.Size = UDim2.new(0.9, 0, 0, 35)
    Tab.Position = UDim2.new(0.05, 0, 0, 60 + (#Sidebar:GetChildren()-2)*40)
    Tab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Tab.Text = name
    Tab.TextColor3 = Theme.Text
    Tab.Font = Enum.Font.GothamBold
    Tab.Parent = Sidebar
    Instance.new("UICorner", Tab)

    Tab.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        page.Visible = true
    end)
end

CreateTab("Home", Home)
CreateTab("Player", Player)
CreateTab("Visuals", Visuals)

-- HOME PAGE
local Welcome = Instance.new("TextLabel")
Welcome.Size = UDim2.new(1, 0, 0, 30)
Welcome.Text = "Hello, " .. LocalPlayer.DisplayName
Welcome.TextColor3 = Theme.Accent
Welcome.Font = Enum.Font.GothamBold
Welcome.BackgroundTransparency = 1
Welcome.Parent = Home

-- PLAYER PAGE
CreateSlider(Player, "WalkSpeed", 16, 300, 16, function(v) LocalPlayer.Character.Humanoid.WalkSpeed = v end)
CreateSlider(Player, "JumpPower", 50, 500, 50, function(v) LocalPlayer.Character.Humanoid.JumpPower = v end)

local flyEnabled = false
CreateToggle(Player, "Fly Mode", function(state)
    flyEnabled = state
    local char = LocalPlayer.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if flyEnabled then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "FlyVel"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        task.spawn(function()
            while flyEnabled do
                bv.Velocity = char.Humanoid.MoveDirection * 100
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

local noclipEnabled = false
CreateToggle(Player, "Noclip", function(state)
    noclipEnabled = state
    RunService.Stepped:Connect(function()
        if noclipEnabled and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

-- VISUALS PAGE
CreateToggle(Visuals, "Player ESP", function(state)
    if state then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local highlight = Instance.new("Highlight", p.Character)
                highlight.Name = "RIH4NX_ESP"
                highlight.FillColor = Theme.Accent
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("RIH4NX_ESP") then
                p.Character.RIH4NX_ESP:Destroy()
            end
        end
    end
end)

-- Toggle Key (Right Control)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
    end
end)

Home.Visible = true
Notify("RIH4NX HUB Loaded! Press RightCtrl")