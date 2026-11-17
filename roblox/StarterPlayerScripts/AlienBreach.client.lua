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
-- Roblox's default camera can re-lock the cursor after a character dies.
-- Run after the camera update so home and death screens keep a free mouse.
RunService:BindToRenderStep("AlienBreachMenuCursor",Enum.RenderPriority.Camera.Value+2,function()
 if player:GetAttribute("AlienBreachDeployed")~=true then
  player.CameraMode=Enum.CameraMode.Classic
  UserInputService.MouseBehavior=Enum.MouseBehavior.Default
  UserInputService.MouseIconEnabled=true
 end
end)
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
rewardLabel.BackgroundTransparency=1
rewardLabel.BorderSizePixel=0
rewardLabel.Font=Enum.Font.GothamBlack
rewardLabel.TextScaled=false
rewardLabel.TextSize=34
rewardLabel.TextStrokeTransparency=.25
rewardLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)
rewardLabel.TextColor3=Color3.fromRGB(160,255,205)
rewardLabel.Size=UDim2.fromScale(.65,.095)
rewardLabel.Position=UDim2.fromScale(.175,.18)
rewardLabel.ZIndex=25
local function update()
 local magazine=player:GetAttribute("Magazine") or 0
 local reserve=player:GetAttribute("ReserveAmmo") or 0
 local weapon=string.upper(player:GetAttribute("Weapon") or "pulse")
 -- The total is uncapped; chest pickups increase ReserveAmmo.
 status.Text=weapon.."  |  AMMO "..tostring(magazine+reserve)
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
weaponFrame.Size=UDim2.fromScale(.22,.19)
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
 weaponFrame.Visible=false -- 3D viewmodel is the only visible weapon
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
 local metal=Color3.fromRGB(47,58,66)
 local dark=Color3.fromRGB(25,32,39)
 local steel=Color3.fromRGB(112,124,136)
 local function p(name,x,y,z,sx,sy,sz,color,material)
  return gunPart(name,Vector3.new(sx,sy,sz),CFrame.new(x,y,z),color or metal,material)
 end
 if id=="pulse" then
  p("CompactPistolSlide",0,0,0,.42,.25,.8)
  p("PistolMuzzle",0,.02,-.52,.17,.16,.32,steel)
  p("PistolGrip",0,-.32,.22,.25,.52,.27,dark)
  p("GreenSight",0,.18,-.28,.12,.09,.12,glow,Enum.Material.Neon)
 elseif id=="shotgun" then
  p("PumpShotgunReceiver",0,0,0,.54,.34,1.05)
  p("WideBore",0,.05,-1.02,.30,.30,1.25,steel)
  p("PumpForegrip",0,-.17,-.88,.49,.24,.56,dark)
  p("WoodStock",0,-.12,.75,.34,.36,.90,Color3.fromRGB(116,70,44))
  p("ShotgunShellRack",.30,.12,.06,.12,.20,.55,glow)
 elseif id=="rifle" then
  p("AssaultReceiver",0,0,0,.54,.34,1.1)
  p("RifleLongBarrel",0,.06,-1.14,.17,.17,1.75,steel)
  p("RifleMagazine",0,-.43,-.15,.28,.64,.31,dark)
  p("RifleStock",0,-.12,.86,.36,.36,.80,dark)
  p("RifleCarryHandle",0,.34,-.12,.32,.14,.58,glow)
 elseif id=="viper" then
  p("ViperCompactSMG",0,0,0,.60,.39,.82,dark)
  p("ViperTwinBarrelLeft",-.15,.02,-.68,.13,.14,.65,steel)
  p("ViperTwinBarrelRight",.15,.02,-.68,.13,.14,.65,steel)
  p("ViperDrumMagazine",0,-.36,-.12,.49,.47,.37,glow)
  p("ViperFoldStock",0,.04,.60,.20,.15,.55,steel)
 elseif id=="ar51" then
  p("AR51Upper",0,.08,0,.55,.31,1.24,metal)
  p("AR51Rail",0,.33,-.37,.45,.11,1.0,glow)
  p("AR51PrecisionBarrel",0,.07,-1.23,.16,.16,1.85,steel)
  p("AR51AngledMagazine",0,-.38,-.08,.27,.62,.38,dark)
  p("AR51SkeletonStock",0,-.1,.95,.28,.23,.95,steel)
  p("AR51Scope",0,.52,-.35,.26,.23,.48,dark)
 elseif id=="phantom" then
  p("PhantomSniperBody",0,0,0,.43,.29,1.5,dark)
  p("PhantomLongBarrel",0,.04,-1.70,.12,.12,2.65,steel)
  p("PhantomScope",0,.46,-.35,.28,.26,.9,glow)
  p("PhantomScopeMount",0,.26,-.35,.14,.25,.23,steel)
  p("PhantomButtstock",0,-.13,1.18,.35,.38,1.0,metal)
  p("PhantomBipod",0,-.31,-1.55,.48,.55,.12,steel)
 elseif id=="titan" then
  p("TitanMotorHousing",0,0,0,.85,.75,1.15,dark)
  for n=-1,1 do p("TitanRotaryBarrel"..n,n*.22,.12,-1.32,.17,.17,1.70,steel) end
  p("TitanAmmoDrum",.53,-.25,.08,.65,.72,.68,glow)
  p("TitanHandle",0,.57,.33,.55,.18,.38,steel)
  p("TitanHeavyStock",0,-.08,.85,.50,.50,.65,metal)
 elseif id=="plasma" then
  p("PlasmaEnergyBody",0,0,0,.74,.57,1.35,dark)
  p("PlasmaCore",0,.08,-.25,.43,.43,.55,glow,Enum.Material.Neon)
  p("PlasmaEmitter",0,.06,-1.1,.48,.48,.8,metal)
  p("PlasmaEmitterGlow",0,.06,-1.58,.30,.30,.17,glow,Enum.Material.Neon)
  p("PlasmaSideCoilLeft",-.43,.1,-.65,.15,.32,.9,glow)
  p("PlasmaSideCoilRight",.43,.1,-.65,.15,.32,.9,glow)
 elseif id=="obliterator" then
  p("ObliteratorHeavyCore",0,0,0,.94,.72,1.48,dark)
  p("ObliteratorCannon",0,.06,-1.30,.54,.50,1.5,metal)
  p("ObliteratorRedMuzzle",0,.06,-2.12,.47,.47,.20,glow,Enum.Material.Neon)
  p("ObliteratorLeftShield",-.55,.05,-.65,.16,.63,1.15,metal)
  p("ObliteratorRightShield",.55,.05,-.65,.16,.63,1.15,metal)
  p("ObliteratorWarningStripe",0,.48,-.3,.62,.11,.72,glow)
 elseif id=="laser" then
  p("LegendaryLaserBody",0,0,0,.54,.40,1.55,dark)
  p("LaserBeamChannel",0,.06,-1.38,.24,.24,2.0,glow,Enum.Material.Neon)
  p("LaserFocusLens",0,.06,-2.48,.34,.34,.19,glow,Enum.Material.Neon)
  p("LaserLeftProng",-.32,.04,-1.78,.15,.20,.88,steel)
  p("LaserRightProng",.32,.04,-1.78,.15,.20,.88,steel)
  p("LaserBattery",0,-.36,.20,.37,.42,.49,glow)
 end
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
  item.part.CFrame=camera.CFrame*CFrame.new(.88,-.64,-2.3+gunKick*.25)*CFrame.Angles(math.rad(-7-gunKick*11),math.rad(-11),0)*item.offset
 end
end)
local weaponStats={
 pulse={delay=.30,cost=1},shotgun={delay=.72,cost=1},rifle={delay=.60,cost=1},
 viper={delay=.12,cost=1},ar51={delay=.34,cost=1},phantom={delay=1.35,cost=1},
 titan={delay=.085,cost=2},plasma={delay=.68,cost=3},obliterator={delay=.85,cost=4},
 laser={delay=.18,cost=5}
}
local Debris=game:GetService("Debris")
local function showMuzzleShot(camera,id)
 -- Local first-person tracer so every shot is visible immediately, even before server replication.
 local laser=id=="laser"
 local part=Instance.new("Part")
 part.Name=laser and "VisibleLaserBeam" or "VisibleBulletTracer"
 part.Anchored=true;part.CanCollide=false;part.CanTouch=false;part.CanQuery=false
 part.Material=Enum.Material.Neon
 part.Color=laser and Color3.fromRGB(80,235,255) or Color3.fromRGB(255,225,130)
 part.Size=Vector3.new(laser and .16 or .09,laser and .16 or .09,laser and 13 or 7)
 local muzzle=camera.CFrame:PointToWorldSpace(Vector3.new(.68,-.5,-3.4))
 local target=camera.CFrame.Position+camera.CFrame.LookVector*(laser and 18 or 12)
 part.CFrame=CFrame.lookAt((muzzle+target)/2,target)
 part.Parent=camera
 Debris:AddItem(part,laser and .17 or .12)
end
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
 if camera then
  showMuzzleShot(camera,id)
  remote:FireServer(camera.CFrame.Position,camera.CFrame.LookVector)
 end
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
    task.delay(2.3,function() if rewardLabel.Text==stamp then rewardLabel.Visible=false end end)
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
