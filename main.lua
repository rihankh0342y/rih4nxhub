--// RIH4NX Modern UI
--// Roblox Lua GUI Template
--// Draggable + Tabs + Notifications

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RIH4NX_UI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 600, 0, 350)
Main.Position = UDim2.new(0.5, -300, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,15)

-- Shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Parent = Main
Shadow.BackgroundTransparency = 1
Shadow.Size = UDim2.new(1,30,1,30)
Shadow.Position = UDim2.new(0,-15,0,-15)
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10,10,118,118)
Shadow.ZIndex = 0

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundTransparency = 1
Title.Text = "RIH4NX HUB"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 28

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Parent = Main
Sidebar.Size = UDim2.new(0,150,1,-50)
Sidebar.Position = UDim2.new(0,0,0,50)
Sidebar.BackgroundColor3 = Color3.fromRGB(15,15,15)
Sidebar.BorderSizePixel = 0

-- Pages
local HomePage = Instance.new("Frame")
HomePage.Parent = Main
HomePage.Size = UDim2.new(1,-160,1,-60)
HomePage.Position = UDim2.new(0,155,0,55)
HomePage.BackgroundTransparency = 1

local PlayerPage = HomePage:Clone()
PlayerPage.Parent = Main
PlayerPage.Visible = false

local TrollPage = HomePage:Clone()
TrollPage.Parent = Main
TrollPage.Visible = false

-- Tab Function
local function CreateTab(name, ypos, page)
	local Btn = Instance.new("TextButton")
	Btn.Parent = Sidebar
	Btn.Size = UDim2.new(1,-10,0,40)
	Btn.Position = UDim2.new(0,5,0,ypos)
	Btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
	Btn.Text = name
	Btn.TextColor3 = Color3.fromRGB(255,255,255)
	Btn.Font = Enum.Font.GothamBold
	Btn.TextSize = 16
	
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)

	Btn.MouseButton1Click:Connect(function()
		HomePage.Visible = false
		PlayerPage.Visible = false
		TrollPage.Visible = false
		
		page.Visible = true
		
		TweenService:Create(
			Btn,
			TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(0,170,255)}
		):Play()
	end)
end

CreateTab("Home",10,HomePage)
CreateTab("Player",60,PlayerPage)
CreateTab("Fun",110,TrollPage)

-- Notification
local function Notify(text)
	local NotifyFrame = Instance.new("Frame")
	NotifyFrame.Parent = ScreenGui
	NotifyFrame.Size = UDim2.new(0,250,0,60)
	NotifyFrame.Position = UDim2.new(1,-270,1,-80)
	NotifyFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
	
	Instance.new("UICorner", NotifyFrame).CornerRadius = UDim.new(0,10)

	local Label = Instance.new("TextLabel")
	Label.Parent = NotifyFrame
	Label.Size = UDim2.new(1,0,1,0)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.TextColor3 = Color3.fromRGB(255,255,255)
	Label.Font = Enum.Font.GothamBold
	Label.TextSize = 16

	TweenService:Create(
		NotifyFrame,
		TweenInfo.new(0.3),
		{Position = UDim2.new(1,-270,1,-100)}
	):Play()

	task.wait(3)

	TweenService:Create(
		NotifyFrame,
		TweenInfo.new(0.3),
		{Position = UDim2.new(1,300,1,-100)}
	):Play()

	task.wait(0.4)
	NotifyFrame:Destroy()
end

Notify("RIH4NX HUB Loaded!")

-- Speed Button
local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Parent = PlayerPage
SpeedBtn.Size = UDim2.new(0,180,0,45)
SpeedBtn.Position = UDim2.new(0,20,0,20)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
SpeedBtn.Text = "Speed Boost"
SpeedBtn.TextColor3 = Color3.new(1,1,1)
SpeedBtn.Font = Enum.Font.GothamBold
SpeedBtn.TextSize = 16

Instance.new("UICorner", SpeedBtn).CornerRadius = UDim.new(0,10)

SpeedBtn.MouseButton1Click:Connect(function()
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("Humanoid") then
		char.Humanoid.WalkSpeed = 50
		Notify("Speed Enabled")
	end
end)

-- Jump Button
local JumpBtn = SpeedBtn:Clone()
JumpBtn.Parent = PlayerPage
JumpBtn.Position = UDim2.new(0,20,0,80)
JumpBtn.Text = "High Jump"

JumpBtn.MouseButton1Click:Connect(function()
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("Humanoid") then
		char.Humanoid.JumpPower = 120
		Notify("Jump Boost Enabled")
	end
end)

-- Fun Spin
local SpinBtn = SpeedBtn:Clone()
SpinBtn.Parent = TrollPage
SpinBtn.Position = UDim2.new(0,20,0,20)
SpinBtn.Text = "Spin"

SpinBtn.MouseButton1Click:Connect(function()
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		while task.wait() do
			char.HumanoidRootPart.CFrame *= CFrame.Angles(0,math.rad(20),0)
		end
	end
end)
