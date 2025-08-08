-- LocalScript (place inside StarterPlayerScripts)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Helper to create buttons
local function createButton(name, text, position)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Text = text
	button.Size = UDim2.new(0, 150, 0, 50)
	button.Position = position
	button.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.SourceSansBold
	button.TextSize = 24
	button.Parent = screenGui
	return button
end

-- Create TP Up button
local tpUpBtn = createButton("TPUpButton", "TP Up 400", UDim2.new(0, 20, 0, 100))

-- Create TP Down button
local tpDownBtn = createButton("TPDownButton", "TP Down 200", UDim2.new(0, 20, 0, 160))

-- Create countdown label (initially invisible)
local countdownLabel = Instance.new("TextLabel")
countdownLabel.Name = "CountdownLabel"
countdownLabel.Size = UDim2.new(0, 200, 0, 50)
countdownLabel.Position = UDim2.new(0.5, -100, 0.5, -25)
countdownLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
countdownLabel.BackgroundTransparency = 0.5
countdownLabel.TextColor3 = Color3.new(1, 1, 1)
countdownLabel.Font = Enum.Font.SourceSansBold
countdownLabel.TextSize = 28
countdownLabel.Visible = false
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
	teleportPlayer(180)
	-- Start countdown after teleporting up
	spawn(function()
		startCountdown(3)
	end)
end)

tpDownBtn.MouseButton1Click:Connect(function()
	teleportPlayer(-200)
end)
