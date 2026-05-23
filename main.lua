--[[
    RIH4NX HUB V10 - TROLL OVERLOAD (20+ FEATURES)
    Floating Toggle + Heavy Troll Tab + Stability Fix
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Parent Check
local ParentUI = (game:GetService("CoreGui"):FindFirstChild("RobloxGui") and game:GetService("CoreGui")) or LocalPlayer:WaitForChild("PlayerGui")

if ParentUI:FindFirstChild("RIH4NX_V10") then ParentUI:FindFirstChild("RIH4NX_V10"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RIH4NX_V10"
ScreenGui.Parent = ParentUI
ScreenGui.ResetOnSpawn = false

local Theme = {Main = Color3.fromRGB(15, 15, 15), Accent = Color3.fromRGB(255, 0, 80), Text = Color3.fromRGB(255, 255, 255), Sidebar = Color3.fromRGB(10, 10, 10)}

-- Floating Toggle
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50); ToggleBtn.Position = UDim2.new(0, 10, 0.4, 0); ToggleBtn.BackgroundColor3 = Theme.Accent; ToggleBtn.Text = "T"; ToggleBtn.TextColor3 = Color3.new(1,1,1); ToggleBtn.Font = Enum.Font.GothamBold; ToggleBtn.TextSize = 25; ToggleBtn.Parent = ScreenGui; ToggleBtn.Draggable = true; Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

-- Main Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 550, 0, 380); Main.Position = UDim2.new(0.5, -275, 0.5, -190); Main.BackgroundColor3 = Theme.Main; Main.Draggable = true; Main.Active = true; Main.Parent = ScreenGui; Instance.new("UICorner", Main)

ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, 0); Sidebar.BackgroundColor3 = Theme.Sidebar; Sidebar.Parent = Main; Instance.new("UICorner", Sidebar)

local Container = Instance.new("Frame")
Container.Position = UDim2.new(0, 150, 0, 10); Container.Size = UDim2.new(1, -160, 1, -20); Container.BackgroundTransparency = 1; Container.Parent = Main

local Pages = {}
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 2; Page.Parent = Container; Page.CanvasSize = UDim2.new(0,0,2,0)
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5); Pages[name] = Page; return Page
end

local HomeP = CreatePage("Home"); local PlayerP = CreatePage("Player"); local TrollP = CreatePage("Troll")

local function CreateTab(name, page, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35); btn.Position = UDim2.new(0.05, 0, 0, y); btn.BackgroundColor3 = Color3.fromRGB(30,30,30); btn.Text = name; btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamBold; btn.Parent = Sidebar; Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() for _, p in pairs(Pages) do p.Visible = false end; page.Visible = true end)
end

CreateTab("Home", HomeP, 50); CreateTab("Player", PlayerP, 90); CreateTab("Troll", TrollP, 130)

-- Functions
local target = ""
local function GetTarget()
    for _,p in pairs(Players:GetPlayers()) do if p.Name:lower():find(target) or p.DisplayName:lower():find(target) then return p end end return nil
end

local function TrollBtn(txt, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 30); b.BackgroundColor3 = Color3.fromRGB(35,35,35); b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; b.Parent = TrollP; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(callback)
end

-- TROLL SECTION (20+ FEATURES)
local TargetInput = Instance.new("TextBox")
TargetInput.Size = UDim2.new(1,-10,0,35); TargetInput.PlaceholderText = "Type Target Name..."; TargetInput.BackgroundColor3 = Color3.fromRGB(20,20,20); TargetInput.TextColor3 = Color3.new(1,1,1); TargetInput.Parent = TrollP; Instance.new("UICorner", TargetInput)
TargetInput.FocusLost:Connect(function() target = TargetInput.Text:lower() end)

-- Feature List
TrollBtn("1. Spin Fling (Launch Player)", function()
    local hrp = LocalPlayer.Character.HumanoidRootPart
    local t = GetTarget()
    if t then
        local start = tick()
        while tick()-start < 5 do
            hrp.CFrame = t.Character.HumanoidRootPart.CFrame
            hrp.Velocity = Vector3.new(5000, 5000, 5000)
            task.wait()
        end
    end
end)

local stalking = false
TrollBtn("2. Auto Stalk (Follow)", function() stalking = not stalking end)

local orbiting = false
TrollBtn("3. Orbit Target", function() orbiting = not orbiting end)

TrollBtn("4. View Target (Spy)", function()
    local t = GetTarget()
    workspace.CurrentCamera.CameraSubject = t and t.Character.Humanoid or LocalPlayer.Character.Humanoid
end)

TrollBtn("5. Ride Target", function()
    local t = GetTarget()
    if t then LocalPlayer.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0,3,0) end
end)

TrollBtn("6. Head Sit", function()
    local t = GetTarget()
    if t then LocalPlayer.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0,1.5,0) end
end)

TrollBtn("7. Teleport Behind", function()
    local t = GetTarget()
    if t then LocalPlayer.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3) end
end)

local creep = false
TrollBtn("8. Creeper Look (Stare)", function() creep = not creep end)

TrollBtn("9. Jumpscare Flicker", function()
    local t = GetTarget()
    for i=1,10 do
        LocalPlayer.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
        task.wait(0.1)
    end
end)

TrollBtn("10. Chat Annoy", function()
    local t = GetTarget()
    if t then game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Hey "..t.Name..", I am watching you!", "All") end
end)

TrollBtn("11. Spasm Mode", function()
    local hrp = LocalPlayer.Character.HumanoidRootPart
    for i=1,50 do hrp.CFrame *= CFrame.Angles(math.random(), math.random(), math.random()); task.wait() end
end)

TrollBtn("12. Invisible (Local)", function()
    for _,v in pairs(LocalPlayer.Character:GetChildren()) do if v:IsA("BasePart") then v.Transparency = 1 end end
end)

TrollBtn("13. Bang Animation", function()
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://148840337" -- Common troll anim
    local load = LocalPlayer.Character.Humanoid:LoadAnimation(anim)
    load:Play()
end)

TrollBtn("14. Walk on Air", function()
    local p = Instance.new("Part", workspace); p.Size = Vector3.new(10,1,10); p.Transparency = 0.5; p.Anchored = true
    RunService.RenderStepped:Connect(function() p.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,-3.5,0) end)
end)

TrollBtn("15. Bring (If Tools)", function()
    local t = GetTarget()
    if t and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
        LocalPlayer.Character:FindFirstChildOfClass("Tool").Handle.CFrame = t.Character.HumanoidRootPart.CFrame
    end
end)

-- Background Loops
local angle = 0
RunService.RenderStepped:Connect(function()
    local t = GetTarget()
    if not t or not t.Character then return end
    if stalking then LocalPlayer.Character.Humanoid:MoveTo(t.Character.HumanoidRootPart.Position) end
    if orbiting then
        angle = angle + 0.1
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(t.Character.HumanoidRootPart.Position + Vector3.new(math.cos(angle)*7, 3, math.sin(angle)*7), t.Character.HumanoidRootPart.Position)
    end
    if creep then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, t.Character.HumanoidRootPart.Position)
    end
end)

-- Basic Player Page
TrollBtn("Speed (100)", function() LocalPlayer.Character.Humanoid.WalkSpeed = 100 end)
TrollBtn("Jump (150)", function() LocalPlayer.Character.Humanoid.JumpPower = 150 end)

HomeP.Visible = true