-- LocalScript (place inside StarterPlayerScripts)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Helper to create buttons (mobile-friendly sizing)
local function createButton(name, text, position)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Text = text
	-- Use scale-based sizing for mobile compatibility
	button.Size = UDim2.new(0.25, 0, 0, 40) -- 25% screen width, 40 pixels height
	button.Position = position
	button.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.SourceSansBold
	button.TextSize = 18 -- Smaller text for mobile
	button.TextScaled = true -- Auto-scale text to fit button
	-- Add rounded corners and better mobile touch response
	button.BorderSizePixel = 0
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = button
	button.Parent = screenGui
	return button
end

-- Create TP Up button (positioned better for mobile)
local tpUpBtn = createButton("TPUpButton", "TP Up", UDim2.new(0, 10, 0, 50))

-- Create TP Down button
local tpDownBtn = createButton("TPDownButton", "TP Down", UDim2.new(0, 10, 0, 100))

-- Create countdown label (mobile-friendly sizing)
local countdownLabel = Instance.new("TextLabel")
countdownLabel.Name = "CountdownLabel"
countdownLabel.Size = UDim2.new(0.5, 0, 0, 60) -- 50% screen width for mobile
countdownLabel.Position = UDim2.new(0.25, 0, 0.4, 0) -- Centered horizontally, 40% from top
countdownLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
countdownLabel.BackgroundTransparency = 0.3
countdownLabel.TextColor3 = Color3.new(1, 1, 1)
countdownLabel.Font = Enum.Font.SourceSansBold
countdownLabel.TextSize = 24
countdownLabel.TextScaled = true -- Auto-scale text for mobile
countdownLabel.Visible = false
-- Add rounded corners to countdown label too
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
