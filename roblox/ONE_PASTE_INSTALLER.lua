-- Alien Breach FPS - ONE-PASTE ROBLOX STUDIO INSTALLER (phase 1)
-- Run ONCE in Studio Command Bar while NOT playing.
-- Creates a ServerScript and LocalScript. Does not edit the browser game.
local ServerScriptService=game:GetService("ServerScriptService")
local StarterPlayer=game:GetService("StarterPlayer")
local scripts=StarterPlayer:WaitForChild("StarterPlayerScripts")
local function install(parent,name,kind,source)
    local existing=parent:FindFirstChild(name)
    if existing then existing:Destroy() end
    local obj=Instance.new(kind)
    obj.Name=name
    obj.Source=source
    obj.Parent=parent
end
install(ServerScriptService,"AlienBreach","Script",[======[-- Alien Breach FPS - Roblox conversion, phase 1
-- Put in ServerScriptService as a Script. Generated from the original GitHub map.
-- Source: index.html; does not modify the browser game.
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local RunService = game:GetService("RunService")
local TILE = 8
local WALL_HEIGHT = 18
local map = {
    "11111111111111111111111111111111111",
    "10000000011111000000000111100000001",
    "10000000011111000000000111100000001",
    "10000000011111000000000111100000001",
    "10000000000000000000000000000000001",
    "10000000000000000000000000000000001",
    "10000000011111000000000111100000001",
    "10000000011111000000000111100000001",
    "11111111111111000000000111100000001",
    "11111111111111111100111111111111111",
    "11111111111111111100111111111111111",
    "11111111111111111100111111111111111",
    "11111111111111111100111111111111111",
    "11111111111110000000000111100000001",
    "10000000001110000000000111100000001",
    "10000000001110000000000111100000001",
    "10000000001110000000000111100000001",
    "10000000000000000000000000000000001",
    "10000000000000000000000000000000001",
    "10000000001110000000000111100000001",
    "10000000001110000000000111100000001",
    "10000000001110000000000111100000001",
    "10000000001110000000000111100000001",
    "11111111111111111001111111111111111",
    "11111111111111000000000111111111111",
    "11111111111111000000000111111111111",
    "11111111111111111111111111111111111",
}
local props = {{6.2,3.2,"computer"},{6.4,5.7,"table"},{16.5,3.3,"computer"},{20.0,6.2,"cabinet"},{15.8,6.4,"table"},{29.5,3.2,"cabinet"},{31.5,6.2,"computer"},{3.2,17.0,"computer"},{7.2,19.5,"table"},{5.5,15.8,"cabinet"},{15.5,15.5,"table"},{20.0,19.5,"cabinet"},{29.5,16.2,"computer"},{31.5,19.5,"table"},{16.0,24.8,"cabinet"},{20.0,24.8,"computer"}}
local chestPoints = {{2.5,2.5},{7.5,6.5},{15.0,2.0},{21.0,7.0},{28.5,2.5},{32.0,7.0},{2.5,20.5},{8.0,15.5},{14.5,20.5},{21.0,14.5},{28.5,20.5},{32.0,14.5},{15.0,24.5},{21.0,24.5}}
local old = workspace:FindFirstChild("AlienBreachRoblox")
if old then old:Destroy() end
local oldRemote = ReplicatedStorage:FindFirstChild("AlienBreachFire")
if oldRemote then oldRemote:Destroy() end
local remote = Instance.new("RemoteEvent")
remote.Name = "AlienBreachFire"
remote.Parent = ReplicatedStorage
local root = Instance.new("Folder")
root.Name = "AlienBreachRoblox"
root.Parent = workspace
local enemies = Instance.new("Folder")
enemies.Name = "Aliens"
enemies.Parent = root
local function block(name, size, cf, color, material, parent)
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.CFrame = cf
    p.Anchored = true
    p.Material = material or Enum.Material.Metal
    p.Color = color
    p.Parent = parent or root
    return p
end
local metal = Color3.fromRGB(44, 54, 60)
local wallColor = Color3.fromRGB(62, 76, 83)
local neon = Color3.fromRGB(85, 255, 166)
local function pos(x,y,h)
    return Vector3.new((x - #map[1]/2)*TILE, h, (y - #map/2)*TILE)
end
local function free(x,y)
    local row = map[math.floor(y)+1]
    return row ~= nil and row:sub(math.floor(x)+1,math.floor(x)+1) == "0"
end
-- Exact 35x27 source tile footprint. Runs of walls are combined for performance.
block("Industrial foundation",Vector3.new(#map[1]*TILE,1,#map*TILE),CFrame.new(pos(#map[1]/2,#map/2,-0.5)),metal)
for y,row in ipairs(map) do
    local x=1
    while x<=#row do
        if row:sub(x,x)=="1" then
            local first=x
            while x<=#row and row:sub(x,x)=="1" do x+=1 end
            local count=x-first
            block("Lab wall",Vector3.new(count*TILE,WALL_HEIGHT,TILE),
                CFrame.new(pos(first-1+count/2,y-0.5,WALL_HEIGHT/2)),wallColor)
        else x+=1 end
    end
end
-- Floor grating accents and light strips in actual open corridors.
for y,row in ipairs(map) do
    for x=1,#row do
        if row:sub(x,x)=="0" then
            local px,py=x-0.5,y-0.5
            if (x+y)%3==0 then
                block("Grated floor seam",Vector3.new(TILE-0.4,0.08,0.15),
                    CFrame.new(pos(px,py,0.07)),Color3.fromRGB(115,129,133))
            end
            if x%6==0 and y%5==0 then
                local lamp=block("Ceiling light",Vector3.new(4,0.4,2),
                    CFrame.new(pos(px,py,WALL_HEIGHT-1)),neon,Enum.Material.Neon)
                local light=Instance.new("PointLight")
                light.Color=neon
                light.Brightness=1.4
                light.Range=35
                light.Parent=lamp
            end
        end
    end
end
local function furniture(x,y,kind)
    local at=pos(x,y,0)
    if kind=="table" then
        block("Research table",Vector3.new(5,0.6,3),CFrame.new(at+Vector3.new(0,3,0)),Color3.fromRGB(105,115,119))
        for dx=-1,1,2 do
            for dz=-1,1,2 do
                block("Table leg",Vector3.new(0.35,3,0.35),
                    CFrame.new(at+Vector3.new(dx*2,1.5,dz)),metal)
            end
        end
    elseif kind=="cabinet" then
        block("Storage cabinet",Vector3.new(4,7,2.4),CFrame.new(at+Vector3.new(0,3.5,0)),Color3.fromRGB(71,84,91))
    else
        block("Computer desk",Vector3.new(5,3,2.5),CFrame.new(at+Vector3.new(0,1.5,0)),metal)
        block("Glowing terminal",Vector3.new(3,2,0.25),
            CFrame.new(at+Vector3.new(0,4,0)),neon,Enum.Material.Neon)
    end
end
for _,p in ipairs(props) do furniture(p[1],p[2],p[3]) end
local spawn = Instance.new("SpawnLocation")
spawn.Name="Starting Room Spawn"
spawn.Size=Vector3.new(5,1,5)
spawn.CFrame=CFrame.new(pos(3.5,3.5,0.5))
spawn.Anchored=true
spawn.Neutral=true
spawn.Transparency=0.5
spawn.Color=neon
spawn.Parent=root
for i,p in ipairs(chestPoints) do
    local chest=block("Supply chest "..i,Vector3.new(3,2,2),CFrame.new(pos(p[1],p[2],1)),
        Color3.fromRGB(95,114,78))
    chest:SetAttribute("Credits",50)
    local prompt=Instance.new("ProximityPrompt")
    prompt.ActionText="Collect 50 credits"
    prompt.ObjectText="Supply Chest"
    prompt.HoldDuration=0.35
    prompt.Parent=chest
    prompt.Triggered:Connect(function(player)
        local stats=player:FindFirstChild("leaderstats")
        local credits=stats and stats:FindFirstChild("Credits")
        if credits then credits.Value+=50 end
        chest:Destroy()
    end)
end
Lighting.ClockTime=0
Lighting.Brightness=1.2
Lighting.Ambient=Color3.fromRGB(23,41,42)
Lighting.OutdoorAmbient=Color3.fromRGB(12,22,27)
Lighting.FogEnd=240
Lighting.FogColor=Color3.fromRGB(8,20,22)
StarterPlayer.CameraMode=Enum.CameraMode.LockFirstPerson
Players.PlayerAdded:Connect(function(player)
    local stats=Instance.new("Folder")
    stats.Name="leaderstats"
    stats.Parent=player
    local credits=Instance.new("IntValue")
    credits.Name="Credits"
    credits.Parent=stats
    local kills=Instance.new("IntValue")
    kills.Name="Kills"
    kills.Parent=stats
end)
local lastShot={}
remote.OnServerEvent:Connect(function(player,origin,direction)
    if typeof(origin)~="Vector3" or typeof(direction)~="Vector3" then return end
    if direction.Magnitude<0.9 or direction.Magnitude>1.1 then return end
    local character=player.Character
    local head=character and character:FindFirstChild("Head")
    if not head or (origin-head.Position).Magnitude>12 then return end
    local now=os.clock()
    if now-(lastShot[player] or 0)<0.18 then return end
    lastShot[player]=now
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances={character}
    local hit=workspace:Raycast(origin,direction*240,params)
    if hit and hit.Instance:IsDescendantOf(enemies) then
        local alien=hit.Instance:FindFirstAncestorOfClass("Model")
        if alien and alien.Parent==enemies then
            local hp=(alien:GetAttribute("HP") or 50)-25
            alien:SetAttribute("HP",hp)
            if hp<=0 then
                alien:Destroy()
                local stats=player:FindFirstChild("leaderstats")
                if stats then
                    stats.Kills.Value+=1
                    stats.Credits.Value+=15
                end
            end
        end
    end
end)
Players.PlayerRemoving:Connect(function(player)lastShot[player]=nil end)
local function makeAlien(x,y)
    local model=Instance.new("Model")
    model.Name="Stalker Alien"
    model:SetAttribute("HP",50)
    model.Parent=enemies
    local origin=pos(x,y,0)
    local torso=block("Torso",Vector3.new(2.2,4.5,1.4),
        CFrame.new(origin+Vector3.new(0,4.2,0)),Color3.fromRGB(72,174,158),Enum.Material.SmoothPlastic,model)
    torso.CanCollide=false
    model.PrimaryPart=torso
    local head=block("Oversized head",Vector3.new(3.2,3.6,2.2),
        CFrame.new(origin+Vector3.new(0,7.6,0)),Color3.fromRGB(89,194,177),Enum.Material.SmoothPlastic,model)
    head.Shape=Enum.PartType.Ball
    head.CanCollide=false
    for _,side in ipairs({-1,1}) do
        local eye=block("Black eye",Vector3.new(0.9,1.4,0.3),
            CFrame.new(origin+Vector3.new(side*0.85,7.8,-1.05)),Color3.fromRGB(4,9,12),Enum.Material.SmoothPlastic,model)
        eye.Shape=Enum.PartType.Ball
        eye.CanCollide=false
        for _,kind in ipairs({"Arm","Leg"}) do
            local h=kind=="Arm" and 3.6 or 3.8
            local py=kind=="Arm" and 3.8 or 1.9
            local px=kind=="Arm" and 1.55 or 0.65
            local limb=block(kind,Vector3.new(0.5,h,0.6),
                CFrame.new(origin+Vector3.new(side*px,py,0)),Color3.fromRGB(71,168,153),Enum.Material.SmoothPlastic,model)
            limb.CanCollide=false
        end
    end
    return model
end
local wave=1
task.spawn(function()
    while root.Parent do
        if #enemies:GetChildren()==0 then
            for i=1,math.min(3+wave,12) do
                for attempt=1,60 do
                    local x=math.random(1,#map[1]-2)+0.5
                    local y=math.random(1,#map-2)+0.5
                    if free(x,y) and (math.abs(x-3.5)+math.abs(y-3.5)>9) then
                        makeAlien(x,y)
                        break
                    end
                end
            end
            wave+=1
        end
        task.wait(3)
    end
end)
local damageClock={}
RunService.Heartbeat:Connect(function(dt)
    for _,alien in ipairs(enemies:GetChildren()) do
        local part=alien.PrimaryPart
        if not part then continue end
        local closest,dist=nil,math.huge
        for _,player in ipairs(Players:GetPlayers()) do
            local char=player.Character
            local hrp=char and char:FindFirstChild("HumanoidRootPart")
            local hum=char and char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health>0 then
                local d=(hrp.Position-part.Position).Magnitude
                if d<dist then closest=player;dist=d end
            end
        end
        if closest and dist<85 then
            local hrp=closest.Character.HumanoidRootPart
            local delta=hrp.Position-part.Position
            local flat=Vector3.new(delta.X,0,delta.Z)
            if flat.Magnitude>0.1 then
                local movement=flat.Unit*math.min(9*dt,flat.Magnitude)
                local target=part.Position+movement
                local gx=target.X/TILE+#map[1]/2
                local gy=target.Z/TILE+#map/2
                if free(gx,gy) then
                    alien:PivotTo(alien:GetPivot()+movement)
                end
            end
            if dist<6 and os.clock()-(damageClock[alien] or 0)>1.2 then
                damageClock[alien]=os.clock()
                local hum=closest.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum:TakeDamage(10) end
            end
        end
    end
end)
print("Alien Breach: original GitHub map, props, chests and starter alien combat loaded.")
]======])
install(scripts,"AlienBreachClient","LocalScript",[======[-- Alien Breach FPS - starter first-person weapon/HUD
-- Put in StarterPlayer > StarterPlayerScripts as a LocalScript.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local UserInputService=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local player=Players.LocalPlayer
player.CameraMode=Enum.CameraMode.LockFirstPerson
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
local ammo=25
local maxAmmo=25
local cooldown=0
local reloading=false
local function update()
    status.Text="PULSE PISTOL | "..ammo.."/"..maxAmmo.." | R: RELOAD"
end
local function reload()
    if reloading or ammo==maxAmmo then return end
    reloading=true
    status.Text="RELOADING..."
    task.wait(1.4)
    ammo=maxAmmo
    reloading=false
    update()
end
local function shoot()
    if reloading or os.clock()<cooldown then return end
    if ammo<=0 then task.spawn(reload) return end
    cooldown=os.clock()+0.2
    ammo-=1
    update()
    local camera=workspace.CurrentCamera
    if camera then remote:FireServer(camera.CFrame.Position,camera.CFrame.LookVector) end
end
UserInputService.InputBegan:Connect(function(input,processed)
    if processed then return end
    if input.UserInputType==Enum.UserInputType.MouseButton1 then shoot() end
    if input.KeyCode==Enum.KeyCode.R then task.spawn(reload) end
end)
fire.Activated:Connect(shoot)
update()
]======])
print("ALIEN BREACH installed. Delete/disable old lab test scripts; click Play.")
