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
local status=label("Status","AMMO 125",UDim2.fromScale(0.35,0.91),UDim2.fromScale(0.30,0.065))
status.Font=Enum.Font.GothamBold
status.TextColor3=Color3.fromRGB(215,255,225)
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
local function update()
 local magazine=player:GetAttribute("Magazine") or 0
 local reserve=player:GetAttribute("ReserveAmmo") or 0
 local weapon=string.upper(player:GetAttribute("Weapon") or "pulse")
 -- The total is uncapped; chest pickups increase ReserveAmmo.
 status.Text=weapon.."  |  AMMO "..tostring(magazine+reserve).."  (LOADED "..tostring(magazine)..")"
 local remaining=breachState:FindFirstChild("AliensRemaining")
 local wave=breachState:FindFirstChild("Breach")
 local timer=breachState:FindFirstChild("NextBreachIn")
 if timer and timer.Value>0 then
  breachLabel.Text="NEXT BREACH IN "..timer.Value.."s"
 else
  breachLabel.Text="BREACH "..(wave and wave.Value or 0).." | ALIENS "..(remaining and remaining.Value or 0)
 end
end
local function gunArt(parent,id,pos,size)
 local art=Instance.new("Frame")
 art.Name="WeaponArt_"..id;art.BackgroundTransparency=1;art.Position=pos;art.Size=size;art.ClipsDescendants=false;art.Parent=parent
 local accents={pulse=Color3.fromRGB(100,245,189),shotgun=Color3.fromRGB(230,164,108),rifle=Color3.fromRGB(129,198,237),viper=Color3.fromRGB(110,255,169),ar51=Color3.fromRGB(144,180,200),phantom=Color3.fromRGB(97,228,255),titan=Color3.fromRGB(255,180,91),plasma=Color3.fromRGB(178,122,255),obliterator=Color3.fromRGB(255,91,99),laser=Color3.fromRGB(72,223,255),medkit=Color3.fromRGB(92,255,151),speed=Color3.fromRGB(255,213,100)}
 local accent=accents[id] or Color3.fromRGB(100,245,189)
 local function part(name,x,y,w,h,color,rotation)
  local f=Instance.new("Frame");f.Name=name;f.BorderSizePixel=0;f.BackgroundColor3=color;f.Position=UDim2.fromScale(x,y);f.Size=UDim2.fromScale(w,h);f.Rotation=rotation or 0;f.Parent=art;return f
 end
 if id=="medkit" then
  local box=part("MedicalCase",.22,.15,.56,.68,Color3.fromRGB(45,77,70))
  local c=Instance.new("UICorner");c.CornerRadius=UDim.new(.15,0);c.Parent=box
  part("CrossVertical",.46,.27,.08,.42,accent);part("CrossHorizontal",.34,.41,.32,.12,accent)
 elseif id=="speed" then
  part("Booster",.25,.15,.5,.7,Color3.fromRGB(42,60,65))
  part("BoltTop",.48,.22,.13,.34,accent,27);part("BoltBottom",.38,.45,.13,.33,accent,27)
 else
  local long=id=="phantom" or id=="rifle" or id=="ar51"
  local heavy=id=="titan" or id=="plasma" or id=="obliterator"
  part("Stock",.07,.38,.23,.18,Color3.fromRGB(82,98,105))
  part("StockCutout",.10,.41,.12,.08,Color3.fromRGB(13,32,34))
  part("Receiver",.26,heavy and .26 or .32,heavy and .44 or .39,heavy and .35 or .27,Color3.fromRGB(51,68,77))
  part("ReceiverHighlight",.28,.33,.29,.055,accent)
  part("Barrel",.65,heavy and .34 or .39,long and .34 or .26,heavy and .18 or .10,Color3.fromRGB(95,110,120))
  part("Muzzle",long and .95 or .88,.35,.045,.18,accent)
  part("Grip",.43,.57,.10,.30,Color3.fromRGB(33,44,51),-12)
  if id=="phantom" then part("Scope",.40,.20,.27,.08,accent);part("ScopeMount",.51,.27,.04,.09,accent)
  elseif heavy then part("PowerCore",.48,.37,.12,.13,accent)
  elseif id=="shotgun" then part("Pump",.69,.53,.20,.07,accent)
  else part("Sight",.55,.24,.055,.09,accent) end
 end
 return art
end

-- First-person weapon display; HUD art tracks camera and recoils on each shot.
local weaponFrame=Instance.new("Frame")
weaponFrame.Name="FirstPersonWeapon"
weaponFrame.BackgroundTransparency=1
weaponFrame.AnchorPoint=Vector2.new(1,1)
weaponFrame.Position=UDim2.fromScale(.99,.99)
weaponFrame.Size=UDim2.fromScale(.37,.32)
weaponFrame.ZIndex=10
weaponFrame.Parent=gui
local currentArt
local recoil=0
local function refreshWeaponArt()
 if currentArt then currentArt:Destroy() end
 local id=player:GetAttribute("Weapon") or "pulse"
 currentArt=gunArt(weaponFrame,id,UDim2.fromScale(.03,.02),UDim2.fromScale(.97,.97))
 currentArt.Rotation=-22
 currentArt.ZIndex=10
 for _,child in ipairs(currentArt:GetDescendants()) do
  if child:IsA("GuiObject") then child.ZIndex=11 end
 end
end
refreshWeaponArt()
player:GetAttributeChangedSignal("Weapon"):Connect(refreshWeaponArt)
RunService.RenderStepped:Connect(function(dt)
 recoil=math.max(0,recoil-dt*5)
 weaponFrame.Position=UDim2.fromScale(.99,.99+recoil*.08)
 weaponFrame.Visible=player:GetAttribute("AlienBreachDeployed")==true
end)
-- 3D first-person weapon built from local Roblox Parts (no external assets).
local viewModel=Instance.new("Model")
viewModel.Name="AlienBreachFirstPersonGun"
local weaponPieces={}
local function gunPart(name,size,offset,color,material)
 local part=Instance.new("Part")
 part.Name=name;part.Size=size;part.Anchored=true
 part.CanCollide=false;part.CanTouch=false;part.CanQuery=false
 part.CastShadow=false;part.Material=material or Enum.Material.Metal
 part.Color=color;part.Parent=viewModel
 table.insert(weaponPieces,{part=part,offset=offset})
 return part
end
local function rebuildGun()
 for _,p in ipairs(viewModel:GetChildren()) do p:Destroy() end
 table.clear(weaponPieces)
 local id=player:GetAttribute("Weapon") or "pulse"
 local colors={pulse=Color3.fromRGB(80,245,178),shotgun=Color3.fromRGB(224,148,82),rifle=Color3.fromRGB(109,194,242),viper=Color3.fromRGB(95,255,133),ar51=Color3.fromRGB(140,187,210),phantom=Color3.fromRGB(77,221,255),titan=Color3.fromRGB(255,171,75),plasma=Color3.fromRGB(184,106,255),obliterator=Color3.fromRGB(255,73,91),laser=Color3.fromRGB(74,223,255)}
 local glow=colors[id] or colors.pulse
 local heavy=id=="titan" or id=="plasma" or id=="obliterator"
 local long=id=="phantom" or id=="rifle" or id=="ar51"
 gunPart("Receiver",Vector3.new(.7,.45,heavy and 1.7 or 1.35),CFrame.new(0,0,0),Color3.fromRGB(47,58,66))
 gunPart("Barrel",Vector3.new(heavy and .28 or .18,heavy and .28 or .18,long and 2.3 or 1.4),CFrame.new(0,.06,-1.25),Color3.fromRGB(110,122,135))
 gunPart("MuzzleGlow",Vector3.new(.25,.25,.15),CFrame.new(0,.06,long and -2.45 or -1.95),glow,Enum.Material.Neon)
 gunPart("Grip",Vector3.new(.25,.65,.35),CFrame.new(0,-.47,.37)*CFrame.Angles(math.rad(-16),0,0),Color3.fromRGB(25,32,39))
 gunPart("Sight",Vector3.new(.14,.18,.22),CFrame.new(0,.33,-.42),glow,Enum.Material.Neon)
 gunPart("SideRail",Vector3.new(.1,.13,.7),CFrame.new(.39,.06,-.15),glow,Enum.Material.Neon)
end
rebuildGun()
player:GetAttributeChangedSignal("Weapon"):Connect(rebuildGun)
local gunKick=0
RunService.RenderStepped:Connect(function(dt)
 local deployed=player:GetAttribute("AlienBreachDeployed")==true
 local camera=workspace.CurrentCamera
 if not camera then return end
 viewModel.Parent=camera
 gunKick=math.max(0,gunKick-dt*7)
 for _,item in ipairs(weaponPieces) do
  item.part.Transparency=deployed and 0 or 1
  item.part.CFrame=camera.CFrame*CFrame.new(.68,-.53,-1.65+gunKick*.25)*CFrame.Angles(math.rad(-7-gunKick*11),math.rad(-11),0)*item.offset
 end
end)
local weaponStats={
 pulse={delay=.30,cost=1},shotgun={delay=.72,cost=1},rifle={delay=.60,cost=1},
 viper={delay=.12,cost=1},ar51={delay=.34,cost=1},phantom={delay=1.35,cost=1},
 titan={delay=.085,cost=2},plasma={delay=.68,cost=3},obliterator={delay=.85,cost=4},
 laser={delay=.18,cost=5}
}
local cooldown=0
local function shoot()
 if player:GetAttribute("AlienBreachDeployed")~=true then return end
 local id=player:GetAttribute("Weapon") or "pulse"
 local w=weaponStats[id] or weaponStats.pulse
 if os.clock()<cooldown then return end
 local magazine=player:GetAttribute("Magazine") or 0
 if magazine<w.cost then control:FireServer("reload");return end
 cooldown=os.clock()+w.delay
 recoil=1
 gunKick=1
 local camera=workspace.CurrentCamera
 if camera then remote:FireServer(camera.CFrame.Position,camera.CFrame.LookVector) end
end
local holdingFire=false
RunService.RenderStepped:Connect(function()
 if holdingFire then shoot() end
end)
UserInputService.InputBegan:Connect(function(input,processed)
    if processed then return end
    if input.UserInputType==Enum.UserInputType.MouseButton1 then holdingFire=true;shoot() end
    if input.KeyCode==Enum.KeyCode.R then control:FireServer("reload") end
    if input.KeyCode==Enum.KeyCode.H then control:FireServer("heal") end
    if input.KeyCode==Enum.KeyCode.One then control:FireServer("pulse") end
    if input.KeyCode==Enum.KeyCode.Two then control:FireServer("laser") end
    if input.KeyCode==Enum.KeyCode.Three then control:FireServer("shotgun") end
    if input.KeyCode==Enum.KeyCode.Four then control:FireServer("rifle") end
end)
UserInputService.InputEnded:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1 then holdingFire=false end
end)
-- Scroll through purchased weapons without requiring a separate hotkey for each gun.
UserInputService.InputChanged:Connect(function(input,processed)
 if processed or player:GetAttribute("AlienBreachDeployed")~=true then return end
 if input.UserInputType~=Enum.UserInputType.MouseWheel then return end
 local list={}
 for id in string.gmatch(player:GetAttribute("AlienBreachAllowedWeapons") or "pulse","[^,]+") do
  if weaponStats[id] then table.insert(list,id) end
 end
 if player:GetAttribute("HasLegendaryLaser") then table.insert(list,"laser") end
 if #list<2 then return end
 local current=table.find(list,player:GetAttribute("Weapon") or "pulse") or 1
 local step=input.Position.Z>0 and -1 or 1
 control:FireServer(list[((current-1+step)%#list)+1])
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
