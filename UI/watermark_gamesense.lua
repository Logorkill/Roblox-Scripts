-- Instances:
local screenGui = Instance.new("ScreenGui")
local rainbowLine = Instance.new("Frame")
local background = Instance.new("Frame")
local titleLabel = Instance.new("TextLabel")
local UserInputService = game:GetService("UserInputService")

-- Properties:
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

background.Parent = screenGui
background.AnchorPoint = Vector2.new(1, 0)
background.Position = UDim2.new(1, -20, 0, -40)
background.Size = UDim2.new(0, 500, 0, 15)
background.BackgroundColor3 = Color3.fromRGB(36, 36, 36)

rainbowLine.Parent = background
rainbowLine.AnchorPoint = Vector2.new(1, 0)
rainbowLine.Position = UDim2.new(1, 0, 0, 0)
rainbowLine.Size = UDim2.new(0, 500, 0, 2)
rainbowLine.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

titleLabel.Parent = background
titleLabel.AnchorPoint = Vector2.new(1, 0)
titleLabel.Position = UDim2.new(1, 0, 0, 2)
titleLabel.Size = UDim2.new(0, 470, 0, 12)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Blocks n Props Menu by Logorkill | V1.37 | Loading..."
titleLabel.Font = Enum.Font.SciFi
titleLabel.TextScaled = true
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextStrokeTransparency = 0.8 -- Optional stroke for better visibility
titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

-- Variables for the color cycling algorithm:
local colorTable = { r = 255, g = 0, b = 0 } -- Start with red
local increment = 2 -- Adjust this for smoother or faster transitions

-- Dragging functionality:
local dragging = false
local dragStart = nil
local startPos = nil

background.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then -- Left mouse button
        dragging = true
        dragStart = input.Position
        startPos = background.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        background.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then -- Left mouse button released
        dragging = false
    end
end)

-- Function to update the color based on the algorithm:
local function updateColor()
    if colorTable.r > 0 and colorTable.b == 0 then
        colorTable.r = colorTable.r - increment
        colorTable.g = colorTable.g + increment
    elseif colorTable.g > 0 and colorTable.r == 0 then
        colorTable.g = colorTable.g - increment
        colorTable.b = colorTable.b + increment
    elseif colorTable.b > 0 and colorTable.g == 0 then
        colorTable.b = colorTable.b - increment
        colorTable.r = colorTable.r + increment
    end

    -- Clamp values between 0 and 255
    colorTable.r = math.clamp(colorTable.r, 0, 255)
    colorTable.g = math.clamp(colorTable.g, 0, 255)
    colorTable.b = math.clamp(colorTable.b, 0, 255)

    return Color3.fromRGB(colorTable.r, colorTable.g, colorTable.b)
end

local function updateTitle()
    local hour = os.date("%H:%M") -- Local hour in 24-hour format (HH:MM)
    local playerCount = game.Players.NumPlayers
    local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) -- Get the player's ping

    -- Update the text with hour, player count, and ping
    titleLabel.Text = string.format("Blocks n Props Menu by Logorkill | V1.37 | Time: %s | Players: %d | Ping: %d ms", hour, playerCount, ping)
end

-- Animate the rainbow line and update title in real-time
game:GetService("RunService").RenderStepped:Connect(function()
    rainbowLine.BackgroundColor3 = updateColor()
    updateTitle()
end)

-- Animate the rainbow line:
game:GetService("RunService").RenderStepped:Connect(function()
    rainbowLine.BackgroundColor3 = updateColor()
end)
