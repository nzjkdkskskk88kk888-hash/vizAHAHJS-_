-- Advanced Lag Switch GUI (FREEZE button)
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer
-- Settings
local lagStrength = 0.4
local buttonWidth = 180
local buttonHeight = 80
local transparencyPercent = 100
local dragEnabled = true
local pcBind = Enum.KeyCode.Unknown
local gamepadBind = Enum.KeyCode.Unknown
local settingPCBind = false
local settingGamepadBind = false
-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
MainFrame.Position = UDim2.new(0,20,0,20)
MainFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
MainFrame.BackgroundTransparency = (100-transparencyPercent)/100
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
-- Stroke (color transition)
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(160,160,160)
Stroke.Thickness = 2
Stroke.Parent = MainFrame
-- Continuous Stroke animation
spawn(function()
local direction = 1
while true do
local tween = TweenService:Create(Stroke,TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut),{Color=direction==1 and Color3.fromRGB(240,240,240) or Color3.fromRGB(160,160,160)})
tween:Play()
tween.Completed:Wait()
direction = direction==1 and -1 or 1
end
end)
-- FREEZE main text
local FreezeLabel = Instance.new("TextLabel")
FreezeLabel.Size = UDim2.new(1,0,1,0)
FreezeLabel.Position = UDim2.new(0,0,0,0)
FreezeLabel.BackgroundTransparency = 1
FreezeLabel.Text = "FREEZE LOADED"
FreezeLabel.TextColor3 = Color3.fromRGB(225,225,225)
FreezeLabel.Font = Enum.Font.GothamBold
FreezeLabel.TextSize = 22
FreezeLabel.TextXAlignment = Enum.TextXAlignment.Center
FreezeLabel.TextYAlignment = Enum.TextYAlignment.Center
FreezeLabel.Parent = MainFrame
-- Credit text
local CreditLabel = Instance.new("TextLabel")
CreditLabel.Size = UDim2.new(1,-10,0,12)
CreditLabel.Position = UDim2.new(0,5,1,-15)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Text = "by exorciqqsm"
CreditLabel.TextColor3 = Color3.fromRGB(150,150,150)
CreditLabel.Font = Enum.Font.Gotham
CreditLabel.TextSize = 10
CreditLabel.TextXAlignment = Enum.TextXAlignment.Right
CreditLabel.Parent = MainFrame
-- Settings button
local SettingsBtn = Instance.new("TextButton")
SettingsBtn.Size = UDim2.new(0,20,0,20)
SettingsBtn.Position = UDim2.new(1,-24,0,3)
SettingsBtn.BackgroundColor3 = Color3.fromRGB(43,43,45)
SettingsBtn.Text = "⚙"
SettingsBtn.TextColor3 = Color3.fromRGB(190,190,190)
SettingsBtn.TextSize = 14
SettingsBtn.BorderSizePixel = 0
SettingsBtn.Parent = MainFrame
-- Settings panel
local SettingsFrame = Instance.new("Frame")
SettingsFrame.Size = UDim2.new(0,210,0,200)
SettingsFrame.Position = UDim2.new(1,10,0,0)
SettingsFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
SettingsFrame.BorderSizePixel = 2
SettingsFrame.BorderColor3 = Color3.fromRGB(110,110,110)
SettingsFrame.Visible = false
SettingsFrame.Parent = MainFrame
-- Scrolling frame
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1,0,1,0)
ScrollingFrame.Position = UDim2.new(0,0,0,0)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.CanvasSize = UDim2.new(0,0,0,500)
ScrollingFrame.Parent = SettingsFrame
-- Helper functions
local function createOptionLabel(name,posY)
local lbl = Instance.new("TextLabel")
lbl.Size = UDim2.new(1,0,0,18)
lbl.Position = UDim2.new(0,0,0,posY)
lbl.BackgroundTransparency = 1
lbl.Text = name
lbl.TextColor3 = Color3.fromRGB(200,200,200)
lbl.Font = Enum.Font.Gotham
lbl.TextSize = 13
lbl.TextXAlignment = Enum.TextXAlignment.Left
lbl.Parent = ScrollingFrame
return lbl
end
local function createOptionBox(posY,default)
local box = Instance.new("TextBox")
box.Size = UDim2.new(1,-20,0,28)
box.Position = UDim2.new(0,10,0,posY)
box.Text = tostring(default)
box.BackgroundColor3 = Color3.fromRGB(38,38,38)
box.TextColor3 = Color3.new(1,1,1)
box.TextSize = 14
box.BorderSizePixel = 0
box.Parent = ScrollingFrame
return box
end
-- Delay
createOptionLabel("Delay (0.1-100 s):",0)
local DelayBox = createOptionBox(18,lagStrength)
DelayBox.FocusLost:Connect(function()
local num = tonumber(DelayBox.Text)
if num then lagStrength = math.clamp(num,0.1,100) end
DelayBox.Text = string.format("%.2f",lagStrength)
end)
-- Transparency
createOptionLabel("Transparency %:",50)
local TransBox = createOptionBox(68,transparencyPercent)
TransBox.FocusLost:Connect(function()
local val = tonumber(TransBox.Text)
if val then
transparencyPercent = math.clamp(val,0,100)
MainFrame.BackgroundTransparency = (100-transparencyPercent)/100
FreezeLabel.TextTransparency = (100-transparencyPercent)/100
CreditLabel.TextTransparency = (100-transparencyPercent)/100
end
TransBox.Text = tostring(transparencyPercent)
end)
-- Drag toggle
createOptionLabel("Drag:",100)
local DragBtn = Instance.new("TextButton")
DragBtn.Size = UDim2.new(1,-20,0,28)
DragBtn.Position = UDim2.new(0,10,0,118)
DragBtn.Text = dragEnabled and "ON" or "OFF"
DragBtn.BackgroundColor3 = dragEnabled and Color3.fromRGB(0,160,70) or Color3.fromRGB(160,0,0)
DragBtn.TextColor3 = Color3.new(1,1,1)
DragBtn.TextSize = 14
DragBtn.BorderSizePixel = 0
DragBtn.Parent = ScrollingFrame
DragBtn.MouseButton1Click:Connect(function()
dragEnabled = not dragEnabled
DragBtn.Text = dragEnabled and "ON" or "OFF"
DragBtn.BackgroundColor3 = dragEnabled and Color3.fromRGB(0,160,70) or Color3.fromRGB(160,0,0)
end)
-- Width/Height
createOptionLabel("Width / Height:",160)
local WidthBox = createOptionBox(178,buttonWidth)
local HeightBox = createOptionBox(208,buttonHeight)
WidthBox.PlaceholderText = "Width"
HeightBox.PlaceholderText = "Height"
-- Apply button
local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Size = UDim2.new(1,-20,0,28)
ApplyBtn.Position = UDim2.new(0,10,0,240)
ApplyBtn.Text = "APPLY"
ApplyBtn.BackgroundColor3 = Color3.fromRGB(55,55,55)
ApplyBtn.TextColor3 = Color3.new(1,1,1)
ApplyBtn.TextSize = 14
ApplyBtn.BorderSizePixel = 0
ApplyBtn.Parent = ScrollingFrame
ApplyBtn.MouseButton1Click:Connect(function()
local w = tonumber(WidthBox.Text)
local h = tonumber(HeightBox.Text)
if w and h then
buttonWidth = math.clamp(w,120,500)
buttonHeight = math.clamp(h,35,180)
MainFrame.Size = UDim2.new(0,buttonWidth,0,buttonHeight)
end
ApplyBtn.Text = "APPLIED"
ApplyBtn.BackgroundColor3 = Color3.fromRGB(0,160,70)
task.spawn(function()
task.wait(2)
ApplyBtn.Text = "APPLY"
ApplyBtn.BackgroundColor3 = Color3.fromRGB(55,55,55)
end)
end)
-- Binds (PC/Gamepad) and Bloxstrap
createOptionLabel("Keybind (PC):",280)
local PCBindBtn = Instance.new("TextButton")
PCBindBtn.Size = UDim2.new(1,-20,0,28)
PCBindBtn.Position = UDim2.new(0,10,0,300)
PCBindBtn.Text = pcBind==Enum.KeyCode.Unknown and "None" or pcBind.Name
PCBindBtn.BackgroundColor3 = Color3.fromRGB(38,38,38)
PCBindBtn.TextColor3 = Color3.new(1,1,1)
PCBindBtn.TextSize = 14
PCBindBtn.BorderSizePixel = 0
PCBindBtn.Parent = ScrollingFrame
PCBindBtn.MouseButton1Click:Connect(function()
settingPCBind = true
PCBindBtn.Text = "Press a key..."
end)
createOptionLabel("Bind (Gamepad):",340)
local GamepadBindBtn = Instance.new("TextButton")
GamepadBindBtn.Size = UDim2.new(1,-20,0,28)
GamepadBindBtn.Position = UDim2.new(0,10,0,360)
GamepadBindBtn.Text = gamepadBind==Enum.KeyCode.Unknown and "None" or gamepadBind.Name
GamepadBindBtn.BackgroundColor3 = Color3.fromRGB(38,38,38)
GamepadBindBtn.TextColor3 = Color3.new(1,1,1)
GamepadBindBtn.TextSize = 14
GamepadBindBtn.BorderSizePixel = 0
GamepadBindBtn.Parent = ScrollingFrame
GamepadBindBtn.MouseButton1Click:Connect(function()
settingGamepadBind = true
GamepadBindBtn.Text = "Press a button..."
end)
createOptionLabel("Launch Bloxstrap:",400)
local LaunchBtn = Instance.new("TextButton")
LaunchBtn.Size = UDim2.new(1,-20,0,28)
LaunchBtn.Position = UDim2.new(0,10,0,420)
LaunchBtn.Text = "Launch Bloxstrap"
LaunchBtn.BackgroundColor3 = Color3.fromRGB(100,100,200)
LaunchBtn.TextColor3 = Color3.new(1,1,1)
LaunchBtn.TextSize = 14
LaunchBtn.BorderSizePixel = 0
LaunchBtn.Parent = ScrollingFrame
LaunchBtn.MouseButton1Click:Connect(function()
    local success, errorMsg = pcall(function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/qwertyui-is-back/Bloxstrap/main/Initiate.lua', true))()
    end)
    
    LaunchBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    LaunchBtn.Text = "Bloxstrap Launched"
    
    if success then
        print("✅ Bloxstrap loaded successfully!")
    else
        warn("❌ Bloxstrap loading failed: " .. tostring(errorMsg))
    end
    
    -- Reset button after 3 seconds
    task.spawn(function()
        task.wait(3)
        LaunchBtn.Text = "Launch Bloxstrap"
        LaunchBtn.BackgroundColor3 = Color3.fromRGB(100,100,200)
    end)
end)
-- Freeze logic
local function activateFreeze()
    local Character = Player.Character
    if not Character then return end
    
    local Humanoid = Character:FindFirstChild("Humanoid")
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    
    if not Humanoid or Humanoid.Health <= 0 or not HumanoidRootPart then
        return
    end
    
    local startTime = os.clock()
    
    -- Visual feedback
    TweenService:Create(FreezeLabel,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{TextColor3=Color3.fromRGB(80,80,80)}):Play()
    FreezeLabel.Text = "FREEZING..."
    
    -- REAL LAG GENERATION
    local function causeOptimizedLag()
        local parts = {}
        local connections = {}
        
        local partCount = math.min(50 + (lagStrength * 10), 200)
        for i = 1, partCount do
            local part = Instance.new("Part")
            part.Anchored = true
            part.CanCollide = false
            part.Transparency = 1
            part.Size = Vector3.new(1, 1, 1)
            part.Position = HumanoidRootPart.Position + Vector3.new(math.random(-20, 20), math.random(-10, 10), math.random(-20, 20))
            part.Parent = workspace
            
            part.Velocity = Vector3.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10))
            
            table.insert(parts, part)
            
            local conn = part.Changed:Connect(function()
            end)
            table.insert(connections, conn)
        end
        
        while os.clock() - startTime < lagStrength do
            local iterations = math.min(400 + (lagStrength * 100), 2000)
            for j = 1, iterations do
                local x = math.sqrt(j) * math.sin(j) * math.cos(j)
            end
            
            if os.clock() - startTime > lagStrength * 0.5 then
                RunService.Heartbeat:Wait()
            end
        end
        
        for _, part in ipairs(parts) do
            part:Destroy()
        end
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
    end
    
    local success, err = pcall(causeOptimizedLag)
    if not success then
        warn("Lag generation error: " .. tostring(err))
        local start = os.clock()
        while os.clock() - start < lagStrength do
            RunService.Heartbeat:Wait()
        end
    end
    
    -- Reset visuals
    TweenService:Create(FreezeLabel,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{TextColor3=Color3.fromRGB(225,225,225)}):Play()
    FreezeLabel.Text = "FREEZE"
end
-- Click vs drag handling
MainFrame.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
local initialPos = input.Position
local connection
connection = input.Changed:Connect(function()
if input.UserInputState==Enum.UserInputState.End then
connection:Disconnect()
local delta = (input.Position - initialPos).Magnitude
if delta < 5 then -- обычный клик
activateFreeze()
end
end
end)
end
end)
SettingsBtn.MouseButton1Click:Connect(function()
SettingsFrame.Visible = not SettingsFrame.Visible
end)
-- Drag
local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
if dragEnabled and (input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch) then
dragging = true
dragStart = input.Position
startPos = MainFrame.Position
input.Changed:Connect(function()
if input.UserInputState==Enum.UserInputState.End then dragging=false end
end)
end
end)
UserInputService.InputChanged:Connect(function(input)
if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
local delta = input.Position - dragStart
MainFrame.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
end
end)
-- Keybinds
UserInputService.InputBegan:Connect(function(input,gameProcessed)
if gameProcessed then return end
if settingPCBind and input.UserInputType==Enum.UserInputType.Keyboard then
pcBind=input.KeyCode
PCBindBtn.Text=pcBind==Enum.KeyCode.Unknown and "None" or pcBind.Name
settingPCBind=false
return
end
if settingGamepadBind and input.UserInputType.Name:find("Gamepad") then
gamepadBind=input.KeyCode
GamepadBindBtn.Text=gamepadBind==Enum.KeyCode.Unknown and "None" or gamepadBind.Name
settingGamepadBind=false
return
end
if (pcBind~=Enum.KeyCode.Unknown and input.KeyCode==pcBind) or (gamepadBind~=Enum.KeyCode.Unknown and input.KeyCode==gamepadBind) then
activateFreeze()
end
end)
-- Auto-update character reference
Player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
end)
-- Animation on load: Show "FREEZE LOADED" and fade out
local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local fadeOut = TweenService:Create(FreezeLabel, tweenInfo, {TextTransparency = 1})
fadeOut:Play()
fadeOut.Completed:Connect(function()
    FreezeLabel.Text = "FREEZE"
    FreezeLabel.TextTransparency = (100 - transparencyPercent) / 100
end)
print("FREEZE GUI loaded | Initial size: 180x80 | Fixed drag & click on phone | Stroke animation active")
