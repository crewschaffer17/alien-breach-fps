-- Alien Breach FPS - starter first-person weapon/HUD
-- Put in StarterPlayer > StarterPlayerScripts as a LocalScript.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local UserInputService=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local player=Players.LocalPlayer
local function syncDeploymentCamera()
 local deployed=player:GetAttribute("AlienBreachDeployed")==true
 player.CameraMode=deployed and Enum.CameraMode.LockFirstPerson or Enum.CameraMode.Classic
 UserInputService.MouseBehavior=deployed and Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default
 UserInputService.MouseIconEnabled=not deployed
end
player:GetAttributeChangedSignal("AlienBreachDeployed"):Connect(syncDeploymentCamera)
syncDeploymentCamera()
local remote=ReplicatedStorage:WaitForChild("AlienBreachFire")
local gui=Instance.new("ScreenGui")
gui.Name="AlienBreachHUD"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
gui.Parent=player:WaitForChild("PlayerGui")
local function label(name,text,position,size)
    local l=Instance.new("TextLabel")
    l.Name=name
    l.BackgroundTransparency=0.35
    l.BackgroundColor3=Color3.fromRGB(4,16,20)
    l.TextColor3=Color3.fromRGB(118,255,186)
    l.Font=Enum.Font.Code
    l.TextScaled=true
    l.Text=text
    l.Size=size
    l.Position=position
    l.Parent=gui
    return l
end
label("Title","ALIEN BREACH | AREA 51",UDim2.fromScale(0.02,0.03),UDim2.fromScale(0.29,0.06))
local status=label("Status","PULSE PISTOL",UDim2.fromScale(0.02,0.91),UDim2.fromScale(0.25,0.06))
local cross=label("Crosshair","+",UDim2.fromScale(0.49,0.47),UDim2.fromScale(0.02,0.05))
cross.BackgroundTransparency=1
local fire=Instance.new("TextButton")
fire.Name="TouchFire"
fire.Size=UDim2.fromScale(0.14,0.18)
fire.Position=UDim2.fromScale(0.83,0.74)
fire.BackgroundColor3=Color3.fromRGB(16,57,49)
fire.TextColor3=Color3.fromRGB(175,255,209)
fire.Font=Enum.Font.GothamBold
fire.TextScaled=true
fire.Text="FIRE"
fire.Visible=UserInputService.TouchEnabled
fire.Parent=gui
local control=ReplicatedStorage:WaitForChild("AlienBreachControl")
local breachState=ReplicatedStorage:WaitForChild("AlienBreachState")
local breachLabel=label("BreachStatus","BREACH LOADING",UDim2.fromScale(0.34,0.025),UDim2.fromScale(0.33,0.06))
local rewardLabel=label("LootNotification","",UDim2.fromScale(0.27,0.14),UDim2.fromScale(0.46,0.055))
rewardLabel.Visible=false
local cooldown=0
local function update()
    local magazine=player:GetAttribute("Magazine") or 25
    local reserve=player:GetAttribute("ReserveAmmo") or 0
    local weapon=player:GetAttribute("Weapon")=="laser" and "LEGENDARY LASER" or "PULSE PISTOL"
    local kits=player:GetAttribute("Medkits") or 0
    status.Text=weapon.." | "..magazine.." / "..reserve.." | KITS "..kits
    local remaining=breachState:FindFirstChild("AliensRemaining")
    local wave=breachState:FindFirstChild("Breach")
    local timer=breachState:FindFirstChild("NextBreachIn")
    if timer and timer.Value>0 then
        breachLabel.Text="NEXT BREACH IN "..timer.Value.."s"
    else
        breachLabel.Text="BREACH "..(wave and wave.Value or 0).." | ALIENS "..(remaining and remaining.Value or 0)
    end
end
local function shoot()
    if os.clock()<cooldown then return end
    local magazine=player:GetAttribute("Magazine") or 0
    if magazine<=0 then control:FireServer("reload");return end
    cooldown=os.clock()+(player:GetAttribute("Weapon")=="laser" and 0.13 or 0.21)
    local camera=workspace.CurrentCamera
    if camera then remote:FireServer(camera.CFrame.Position,camera.CFrame.LookVector) end
end
UserInputService.InputBegan:Connect(function(input,processed)
    if processed then return end
    if input.UserInputType==Enum.UserInputType.MouseButton1 then shoot() end
    if input.KeyCode==Enum.KeyCode.R then control:FireServer("reload") end
    if input.KeyCode==Enum.KeyCode.H then control:FireServer("heal") end
    if input.KeyCode==Enum.KeyCode.One then control:FireServer("pulse") end
    if input.KeyCode==Enum.KeyCode.Two then control:FireServer("laser") end
end)
fire.Activated:Connect(shoot)
for _,name in ipairs({"Magazine","ReserveAmmo","Medkits","Weapon"}) do
    player:GetAttributeChangedSignal(name):Connect(update)
end
for _,v in ipairs(breachState:GetChildren()) do
    if v:IsA("IntValue") then v.Changed:Connect(update) end
end
player:GetAttributeChangedSignal("LastCacheReward"):Connect(function()
    rewardLabel.Text=player:GetAttribute("LastCacheReward") or ""
    rewardLabel.Visible=true
    local stamp=rewardLabel.Text
    task.delay(5,function() if rewardLabel.Text==stamp then rewardLabel.Visible=false end end)
    update()
end)
update()
local healButton=Instance.new("TextButton")
healButton.Name="TouchHeal";healButton.Text="MEDKIT"
healButton.TextScaled=true;healButton.Font=Enum.Font.GothamBold
healButton.TextColor3=Color3.fromRGB(225,255,225)
healButton.BackgroundColor3=Color3.fromRGB(28,90,60)
healButton.Size=UDim2.fromScale(0.14,0.07)
healButton.Position=UDim2.fromScale(0.83,0.65)
healButton.Visible=UserInputService.TouchEnabled
healButton.Parent=gui
healButton.Activated:Connect(function() control:FireServer("heal") end)
-- Interactive facility map: tap the corner radar or press M to enlarge.
local mapValue=ReplicatedStorage:WaitForChild("AlienBreachMap")
local rows=string.split(mapValue.Value,"\n")
local mapHeight=#rows
local mapWidth=#rows[1]
local TILE=8
local radar=Instance.new("TextButton")
radar.Name="MapToggle"
radar.Text="EXPAND MAP [M]"
radar.Font=Enum.Font.GothamBold
radar.TextScaled=true
radar.TextColor3=Color3.fromRGB(172,255,203)
radar.BackgroundColor3=Color3.fromRGB(9,28,33)
radar.Size=UDim2.fromScale(0.13,0.055)
radar.Position=UDim2.fromScale(0.85,0.04)
radar.Parent=gui
local panel=Instance.new("Frame")
panel.Name="FacilityMap"
panel.BackgroundColor3=Color3.fromRGB(5,16,20)
panel.BackgroundTransparency=0.08
panel.BorderSizePixel=2
panel.BorderColor3=Color3.fromRGB(64,155,139)
panel.AnchorPoint=Vector2.new(0.5,0.5)
panel.Position=UDim2.fromScale(0.85,0.20)
panel.Size=UDim2.fromScale(0.22,0.22)
panel.Visible=true
panel.Parent=gui
local constraint=Instance.new("UIAspectRatioConstraint")
constraint.AspectRatio=mapWidth/mapHeight
constraint.AspectType=Enum.AspectType.FitWithinMaxSize
constraint.DominantAxis=Enum.DominantAxis.Width
constraint.Parent=panel
local cells=Instance.new("Frame")
cells.Name="MapTiles"
cells.BackgroundTransparency=1
cells.Size=UDim2.fromScale(1,1)
cells.Parent=panel
for y,row in ipairs(rows) do
    for x=1,#row do
        if row:sub(x,x)=="0" then
            local tile=Instance.new("Frame")
            tile.Name="HallwayOrRoom"
            tile.BorderSizePixel=0
            tile.BackgroundColor3=Color3.fromRGB(73,103,108)
            tile.Position=UDim2.fromScale((x-1)/mapWidth,(y-1)/mapHeight)
            tile.Size=UDim2.fromScale(1/mapWidth+0.0002,1/mapHeight+0.0002)
            tile.Parent=cells
        end
    end
end
local markerLayer=Instance.new("Frame")
markerLayer.BackgroundTransparency=1
markerLayer.Size=UDim2.fromScale(1,1)
markerLayer.Parent=panel
local markers={}
local function marker(color,size)
    local m=Instance.new("Frame")
    m.AnchorPoint=Vector2.new(0.5,0.5)
    m.BorderSizePixel=0
    m.BackgroundColor3=color
    m.Size=UDim2.fromScale(size/mapWidth,size/mapHeight)
    m.Parent=markerLayer
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(1,0)
    corner.Parent=m
    return m
end
local playerDot=marker(Color3.fromRGB(70,255,100),1.3)
local function place(dot,position)
    local gx=position.X/TILE+mapWidth/2
    local gy=position.Z/TILE+mapHeight/2
    dot.Position=UDim2.fromScale(gx/mapWidth,gy/mapHeight)
end
local expanded=false
local function toggleMap()
    expanded=not expanded
    panel.Size=expanded and UDim2.fromScale(0.76,0.76) or UDim2.fromScale(0.22,0.22)
    panel.Position=expanded and UDim2.fromScale(0.5,0.51) or UDim2.fromScale(0.85,0.20)
    radar.Text=expanded and "SMALL MAP [M]" or "EXPAND MAP [M]"
end
radar.Activated:Connect(toggleMap)
UserInputService.InputBegan:Connect(function(input,processed)
    if input.KeyCode==Enum.KeyCode.M and not processed then toggleMap() end
end)
local elapsed=0
RunService.RenderStepped:Connect(function(dt)
    if not panel.Visible then return end
    elapsed+=dt
    if elapsed<0.12 then return end
    elapsed=0
    local char=player.Character
    local hrp=char and char:FindFirstChild("HumanoidRootPart")
    if hrp then place(playerDot,hrp.Position) end
    local folder=workspace:FindFirstChild("AlienBreachRoblox")
    local aliens=folder and folder:FindFirstChild("Aliens")
    local live={}
    if aliens then
        for _,alien in ipairs(aliens:GetChildren()) do
            local part=alien.PrimaryPart
            if part then
                live[alien]=true
                if not markers[alien] then markers[alien]=marker(Color3.fromRGB(255,61,57),1.1) end
                place(markers[alien],part.Position)
            end
        end
    end
    for alien,dot in pairs(markers) do
        if not live[alien] then dot:Destroy();markers[alien]=nil end
    end
end)
