--[[
    RIH4NX HUB V12 - THE GOD FATHER FINAL VERSION
    Added: ESP Pro, Anti-AFK, Server Utils, Chat Spammer, Gravity
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Parent UI
local ParentUI = (game:GetService("CoreGui"):FindFirstChild("RobloxGui") and game:GetService("CoreGui")) or LocalPlayer:WaitForChild("PlayerGui")
if ParentUI:FindFirstChild("RIH4NX_V12") then ParentUI:FindFirstChild("RIH4NX_V12"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RIH4NX_V12"; ScreenGui.Parent = ParentUI; ScreenGui.ResetOnSpawn = false

local Theme = {
    Main = Color3.fromRGB(15, 15, 15),
    Accent = Color3.fromRGB(0, 255, 120),
    Text = Color3.fromRGB(255, 255, 255),
    Sidebar = Color3.fromRGB(10, 10, 10),
    Button = Color3.fromRGB(25, 25, 25)
}

-- Notification
local function Notify(txt)
    local n = Instance.new("Frame")
    n.Size = UDim2.new(0, 200, 0, 45); n.Position = UDim2.new(1, 10, 0.8, 0); n.BackgroundColor3 = Theme.Main; n.Parent = ScreenGui; Instance.new("UICorner", n)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,0,1,0); l.Text = txt; l.TextColor3 = Theme.Accent; l.BackgroundTransparency = 1; l.Parent = n; l.Font = Enum.Font.GothamBold
    n:TweenPosition(UDim2.new(1, -210, 0.8, 0), "Out", "Back", 0.5)
    task.delay(3, function() n:TweenPosition(UDim2.new(1, 10, 0.8, 0), "In", "Back", 0.5); task.wait(0.5); n:Destroy() end)
end

-- Smooth Dragging (Fixed)
local function Drag(obj)
    local dragging, input, startPos, startObjPos
    obj.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; startPos = i.Position; startObjPos = obj.Position end end)
    obj.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then input = i end end)
    UserInputService.InputChanged:Connect(function(i) if i == input and dragging then local delta = i.Position - startPos; obj.Position = UDim2.new(startObjPos.X.Scale, startObjPos.X.Offset + delta.X, startObjPos.Y.Scale, startObjPos.Y.Offset + delta.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

-- Main Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 580, 0, 400); Main.Position = UDim2.new(0.5, -290, 0.5, -200); Main.BackgroundColor3 = Theme.Main; Main.Parent = ScreenGui; Instance.new("UICorner", Main)
Drag(Main)

-- Floating Toggle
local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0, 50, 0, 50); Toggle.Position = UDim2.new(0, 20, 0.5, 0); Toggle.BackgroundColor3 = Theme.Accent; Toggle.Text = "R"; Toggle.Parent = ScreenGui; Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1,0)
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
Drag(Toggle)

-- Tabs System
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, 0); Sidebar.BackgroundColor3 = Theme.Sidebar; Sidebar.Parent = Main; Instance.new("UICorner", Sidebar)

local Container = Instance.new("Frame")
Container.Position = UDim2.new(0, 150, 0, 10); Container.Size = UDim2.new(1, -160, 1, -20); Container.BackgroundTransparency = 1; Container.Parent = Main

local Pages = {}
local function CreatePage(name)
    local p = Instance.new("ScrollingFrame")
    p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 0; p.Parent = Container
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8); Pages[name] = p; return p
end

local HomeP = CreatePage("Home"); local PlayerP = CreatePage("Player"); local VisualP = CreatePage("Visuals"); local TrollP = CreatePage("Troll"); local MiscP = CreatePage("Misc")

local function Tab(name, page, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.9, 0, 0, 35); b.Position = UDim2.new(0.05, 0, 0, y); b.BackgroundColor3 = Theme.Button; b.Text = name; b.TextColor3 = Color3.new(1,1,1); b.Parent = Sidebar; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() for _, v in pairs(Pages) do v.Visible = false end; page.Visible = true end)
end

Tab("Home", HomeP, 50); Tab("Player", PlayerP, 90); Tab("Visuals", VisualP, 130); Tab("Troll", TrollP, 170); Tab("Misc", MiscP, 210)

-- Reusable Components
local function NewButton(parent, text, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-10,0,35); b.BackgroundColor3 = Theme.Button; b.Text = text; b.TextColor3 = Color3.new(1,1,1); b.Parent = parent; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

-- 1. VISUALS (ESP)
local espEnabled = false
NewButton(VisualP, "Toggle ESP Pro (Box/Name)", function()
    espEnabled = not espEnabled
    if espEnabled then
        Notify("ESP Enabled")
        RunService.RenderStepped:Connect(function()
            if not espEnabled then return end
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if not p.Character:FindFirstChild("Highlight") then
                        local h = Instance.new("Highlight", p.Character)
                        h.FillTransparency = 0.5; h.OutlineColor = Theme.Accent
                    end
                end
            end
        end)
    else
        Notify("ESP Disabled")
        for _, p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end end
    end
end)

-- 2. TROLLING (Overloaded)
local target = ""
local TargetInp = Instance.new("TextBox")
TargetInp.Size = UDim2.new(1,-10,0,35); TargetInp.PlaceholderText = "Target Name..."; TargetInp.Parent = TrollP; TargetInp.BackgroundColor3 = Theme.Sidebar; TargetInp.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", TargetInp)
TargetInp.FocusLost:Connect(function() target = TargetInp.Text:lower() end)

local function getT()
    for _,p in pairs(Players:GetPlayers()) do if p.Name:lower():find(target) or p.DisplayName:lower():find(target) then return p end end return nil
end

NewButton(TrollP, "Spin Fling Target", function()
    local t = getT()
    if t and t.Character then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local oldPos = hrp.CFrame
        Notify("Flinging "..t.Name)
        for i=1, 50 do
            hrp.CFrame = t.Character.HumanoidRootPart.CFrame
            hrp.Velocity = Vector3.new(5000, 5000, 5000)
            task.wait()
        end
        hrp.CFrame = oldPos
    end
end)

local spamming = false
NewButton(TrollP, "Toggle Chat Spam", function()
    spamming = not spamming
    task.spawn(function()
        while spamming do
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("RIH4NX HUB IS WATCHING YOU", "All")
            task.wait(2)
        end
    end)
end)

-- 3. MISC (Server Utils)
NewButton(MiscP, "Server Hop", function()
    local x = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, v in pairs(x.data) do if v.playing < v.maxPlayers then game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id) end end
end)

NewButton(MiscP, "Rejoin Server", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
end)

NewButton(MiscP, "Anti-AFK", function()
    LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end)
    Notify("Anti-AFK Activated")
end)

-- 4. PLAYER
NewButton(PlayerP, "God Speed (200)", function() LocalPlayer.Character.Humanoid.WalkSpeed = 200 end)
NewButton(PlayerP, "Infinite Jump", function()
    UserInputService.JumpRequest:Connect(function() LocalPlayer.Character.Humanoid:ChangeState("Jumping") end)
end)

HomeP.Visible = true; Notify("RIH4NX V12 FINAL LOADED")
