-- LocalScript (place inside StarterPlayerScripts)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Check if device is mobile
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Helper to create buttons (adaptive sizing based on platform)
local function createButton(name, text, position)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Text = text
	
	if isMobile then
		-- Mobile settings (smaller, responsive)
		button.Size = UDim2.new(0.25, 0, 0, 40)
		button.TextSize = 18
		button.TextScaled = true
	else
		-- PC settings (larger, fixed size)
		button.Size = UDim2.new(0, 150, 0, 50)
		button.TextSize = 24
		button.TextScaled = false
	end
	
	button.Position = position
	button.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.SourceSansBold
	button.BorderSizePixel = 0
	
	-- Add rounded corners
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = button
	button.Parent = screenGui
	return button
end

-- Create buttons with platform-specific positioning and text
local tpUpBtn, tpDownBtn

if isMobile then
	-- Mobile positioning and shorter text
	tpUpBtn = createButton("TPUpButton", "TP Up", UDim2.new(0, 10, 0, 50))
	tpDownBtn = createButton("TPDownButton", "TP Down", UDim2.new(0, 10, 0, 100))
else
	-- PC positioning (higher up) and full text
	tpUpBtn = createButton("TPUpButton", "TP Up", UDim2.new(0, 20, 0, 50))
	tpDownBtn = createButton("TPDownButton", "TP Down", UDim2.new(0, 20, 0, 110))
end

-- Create countdown label (adaptive sizing)
local countdownLabel = Instance.new("TextLabel")
countdownLabel.Name = "CountdownLabel"

if isMobile then
	-- Mobile sizing and positioning
	countdownLabel.Size = UDim2.new(0.5, 0, 0, 60)
	countdownLabel.Position = UDim2.new(0.25, 0, 0.4, 0)
	countdownLabel.TextSize = 24
	countdownLabel.TextScaled = true
else
	-- PC sizing and positioning
	countdownLabel.Size = UDim2.new(0, 200, 0, 50)
	countdownLabel.Position = UDim2.new(0.5, -100, 0.5, -25)
	countdownLabel.TextSize = 28
	countdownLabel.TextScaled = false
end

countdownLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
countdownLabel.BackgroundTransparency = 0.3
countdownLabel.TextColor3 = Color3.new(1, 1, 1)
countdownLabel.Font = Enum.Font.SourceSansBold
countdownLabel.Visible = false

-- Add rounded corners to countdown label
local labelCorner = Instance.new("UICorner")
labelCorner.CornerRadius = UDim.new(0, 12)
labelCorner.Parent = countdownLabel
countdownLabel.Parent = screenGui

-- Function to teleport player
local function teleportPlayer(offsetY)
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.CFrame = hrp.CFrame + Vector3.new(0, offsetY, 0)
	end
end

-- Function to start countdown and teleport down when finished
local function startCountdown(seconds)
	countdownLabel.Visible = true
	for i = seconds, 1, -1 do
		countdownLabel.Text = "TP down in: " .. i
		wait(1)
	end
	countdownLabel.Visible = false
	
	-- Actually teleport the player down after countdown
	teleportPlayer(-200)
end

-- Connect buttons to teleport actions
tpUpBtn.MouseButton1Click:Connect(function()
	teleportPlayer(200)
	-- Start countdown after teleporting up
	spawn(function()
		startCountdown(3)
	end)
end)

tpDownBtn.MouseButton1Click:Connect(function()
	teleportPlayer(-200)
end)
