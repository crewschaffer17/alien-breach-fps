-- Alien Breach FPS - Roblox conversion, phase 1
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
-- Preserve the original 35x27 layout in the northwest corner, then expand
-- into new east research wings and a south office/maintenance complex.
local WIDTH,HEIGHT=57,45
local cells={}
for y=1,HEIGHT do
    cells[y]={}
    for x=1,WIDTH do
        cells[y][x]=(map[y] and map[y]:sub(x,x)=="0") and "0" or "1"
    end
end
local function carve(x1,y1,x2,y2)
    for y=y1,y2 do for x=x1,x2 do cells[y][x]="0" end end
end
-- Three large laboratories, connecting hallways, small offices and storage.
carve(34,5,39,5) -- access from original upper storage room
carve(37,3,54,11) -- advanced research laboratory
carve(34,18,40,18) -- east central corridor
carve(37,14,54,25) -- containment laboratory
carve(38,11,40,15) -- north/south connecting corridor
carve(42,26,44,29) -- lower east passage
carve(37,29,54,42) -- operations and office wing
carve(18,26,19,31) -- original maintenance connection
carve(3,30,34,32) -- south main hallway
carve(3,34,15,42) -- west cubicle office
carve(18,34,34,42) -- south technical lab
carve(15,31,18,35)
carve(32,31,38,32)
-- Thin dividers and doorways make several small rooms off the main corridors.
for _,x in ipairs({7,11}) do
    for y=34,42 do if y~=37 then cells[y][x]="1" end end
end
for _,x in ipairs({23,29}) do
    for y=34,42 do if y~=37 then cells[y][x]="1" end end
end
for _,x in ipairs({43,49}) do
    for y=30,42 do if y~=35 then cells[y][x]="1" end end
end
-- Ensure the east wing connects to the lower south wing.
carve(42,24,44,30)
-- Seal the outside boundary.
for x=1,WIDTH do cells[1][x]="1";cells[HEIGHT][x]="1" end
for y=1,HEIGHT do cells[y][1]="1";cells[y][WIDTH]="1" end
map={}
for y=1,HEIGHT do map[y]=table.concat(cells[y]) end
local props = {{6.2,3.2,"computer"},{6.4,5.7,"table"},{16.5,3.3,"computer"},{20.0,6.2,"cabinet"},{15.8,6.4,"table"},{29.5,3.2,"cabinet"},{31.5,6.2,"computer"},{3.2,17.0,"computer"},{7.2,19.5,"table"},{5.5,15.8,"cabinet"},{15.5,15.5,"table"},{20.0,19.5,"cabinet"},{29.5,16.2,"computer"},{31.5,19.5,"table"},{16.0,24.8,"cabinet"},{20.0,24.8,"computer"}}

for _,p in ipairs({
 {40.5,5.5,"table"},{45.5,7.5,"computer"},{51.5,5.5,"cabinet"},
 {41.5,17.5,"table"},{47.5,19.5,"computer"},{52.5,22.5,"cabinet"},
 {39.5,33.5,"computer"},{46.5,32.5,"table"},{52.5,38.5,"cabinet"},
 {5.0,36.5,"computer"},{9.0,39.0,"computer"},{13.0,36.5,"cabinet"},
 {20.5,36.5,"computer"},{26.5,39.0,"table"},{32.0,36.5,"cabinet"},
 {5.5,40.0,"table"},{20.0,40.0,"cabinet"},{47.0,39.5,"computer"}
}) do table.insert(props,p) end
local chestPoints = {{2.5,2.5},{7.5,6.5},{15.0,2.0},{21.0,7.0},{28.5,2.5},{32.0,7.0},{2.5,20.5},{8.0,15.5},{14.5,20.5},{21.0,14.5},{28.5,20.5},{32.0,14.5},{15.0,24.5},{21.0,24.5}}
for _,p in ipairs({{42.5,5.5},{52.5,9.5},{40.5,22.5},{51.5,18.5},{40.5,38.5},{52.5,39.5},{5.5,31.5},{24.5,31.5}}) do table.insert(chestPoints,p) end
local old = workspace:FindFirstChild("AlienBreachRoblox")
if old then old:Destroy() end
local oldRemote = ReplicatedStorage:FindFirstChild("AlienBreachFire")
if oldRemote then oldRemote:Destroy() end
local remote = Instance.new("RemoteEvent")
remote.Name = "AlienBreachFire"
remote.Parent = ReplicatedStorage
local mapValue=ReplicatedStorage:FindFirstChild("AlienBreachMap") or Instance.new("StringValue")
mapValue.Name="AlienBreachMap"
mapValue.Value=table.concat(map,"\n")
mapValue.Parent=ReplicatedStorage
-- Apply visibility immediately, before constructing any geometry.
Lighting.ClockTime=0
Lighting.Brightness=2.8
Lighting.Ambient=Color3.fromRGB(115,126,126)
Lighting.OutdoorAmbient=Color3.fromRGB(88,100,104)
Lighting.FogEnd=320
Lighting.FogColor=Color3.fromRGB(18,31,36)
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
-- Expanded 57x45 facility, retaining the original 35x27 section. Runs of walls are combined for performance.
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
-- Industrial grating copied from the original browser game's floor design:
-- framed steel panels, dark recessed channels, silver raised ribs.
-- Use anchored Parts with no collision for decorative details.
local lightingFixtures = {}
local redFixtures = {}
local floorColor = Color3.fromRGB(126,145,151)
local trimColor = Color3.fromRGB(167,187,192)
local grooveColor = Color3.fromRGB(35,48,53)
local function detail(name,size,cf,color,material)
    local p=block(name,size,cf,color,material)
    p.CanCollide=false
    p.CanTouch=false
    p.CanQuery=false
    p.CastShadow=false
    return p
end
-- Keep the corridor bright enough to navigate even during flicker.
-- Create all overhead fixtures FIRST, before slow decorative tile generation.
-- This prevents the initial multi-second wait for the laboratory lights.
for y,row in ipairs(map) do
    for x=1,#row do
        if row:sub(x,x)=="0" and x%4==0 and y%4==0 then
            local center=pos(x-0.5,y-0.5,0)
            -- Evenly spaced overhead fluorescent lamps and independent red alarms.
            if x%4==0 and y%4==0 then
                local lamp=detail("Always-on ceiling light",Vector3.new(4.5,0.35,1.1),
                    CFrame.new(center+Vector3.new(0,WALL_HEIGHT-0.8,0)),
                    Color3.fromRGB(193,245,236),Enum.Material.Neon)
                local light=Instance.new("PointLight")
                light.Color=Color3.fromRGB(200,246,238)
                light.Brightness=2.3
                light.Range=42
                light.Shadows=false
                light.Parent=lamp
                table.insert(lightingFixtures,{part=lamp,light=light})
                local alarm=detail("Breach warning lamp",Vector3.new(1.2,0.35,1.2),
                    CFrame.new(center+Vector3.new(2.5,WALL_HEIGHT-0.7,0)),
                    Color3.fromRGB(70,16,17),Enum.Material.Neon)
                local alarmLight=Instance.new("PointLight")
                alarmLight.Color=Color3.fromRGB(255,42,37)
                alarmLight.Brightness=0
                alarmLight.Range=35
                alarmLight.Shadows=false
                alarmLight.Parent=alarm
                table.insert(redFixtures,{part=alarm,light=alarmLight})
            end
        end
    end
end
for y,row in ipairs(map) do
    for x=1,#row do
        if row:sub(x,x)=="0" then
            local px,py=x-0.5,y-0.5
            local center=pos(px,py,0)
            -- Abandoned laboratory tiles: varied dirty concrete, uneven staining,
            -- chipped seams and occasional hairline cracks (deterministic by tile).
            local shade=((x*37+y*61)%7)-3
            local base=math.clamp(115+shade*5,70,145)
            detail("Abandoned floor tile",Vector3.new(TILE-0.18,0.13,TILE-0.18),
                CFrame.new(center+Vector3.new(0,0.05,0)),
                Color3.fromRGB(base,base+2,base+1),Enum.Material.Concrete)
            local tileSize=(TILE-0.35)/2
            for ix=-1,1,2 do
                for iz=-1,1,2 do
                    local noise=(x*17+y*29+ix*13+iz*7)%17
                    local grey=math.clamp(base+noise-12,67,155)
                    detail("Dirty ceramic tile",Vector3.new(tileSize,0.035,tileSize),
                        CFrame.new(center+Vector3.new(ix*2.02,0.135,iz*2.02)),
                        Color3.fromRGB(grey,grey+2,grey+1),Enum.Material.Concrete)
                end
            end
            -- Patchy grime appears on some tiles, not in a repeating grid.
            if (x*19+y*23)%5==0 then
                detail("Ground-in dirt",Vector3.new(1.5+((x+y)%3),0.018,1.2),
                    CFrame.new(center+Vector3.new(1.1,0.16,-0.7))*CFrame.Angles(0,math.rad(21),0),
                    Color3.fromRGB(68,70,65),Enum.Material.Concrete)
            end
            if (x*11+y*31)%9==0 then
                -- Thin zig-zag crack, dark and flush with the tile surface.
                local crackCenter=center+Vector3.new(-0.7,0.18,0.35)
                detail("Floor crack",Vector3.new(2.2,0.018,0.07),
                    CFrame.new(crackCenter)*CFrame.Angles(0,math.rad(27),0),
                    Color3.fromRGB(35,37,36),Enum.Material.SmoothPlastic)
                detail("Branching crack",Vector3.new(1.4,0.018,0.055),
                    CFrame.new(crackCenter+Vector3.new(1,0,-0.6))*CFrame.Angles(0,math.rad(-39),0),
                    Color3.fromRGB(38,40,38),Enum.Material.SmoothPlastic)
            end
            -- Exposed wall panels: horizontal seams and dark inset metal strips.
            -- Only decorate faces adjacent to walkable tiles.
            local sides={
                {dx=1,dy=0,angle=90},
                {dx=-1,dy=0,angle=90},
                {dx=0,dy=1,angle=0},
                {dx=0,dy=-1,angle=0}
            }
            for _,side in ipairs(sides) do
                if not free(px+side.dx,py+side.dy) then
                    local face=center+Vector3.new(side.dx*TILE*0.5,0,side.dy*TILE*0.5)
                    local cf=CFrame.new(face)*CFrame.Angles(0,math.rad(side.angle),0)
                    detail("Wall steel inset",Vector3.new(TILE-0.6,WALL_HEIGHT-1.4,0.1),
                        cf*CFrame.new(0,WALL_HEIGHT/2,0),Color3.fromRGB(76,91,99))
                    for height=4,12,4 do
                        detail("Wall horizontal seam",Vector3.new(TILE-0.5,0.12,0.18),
                            cf*CFrame.new(0,height,0),Color3.fromRGB(25,39,45))
                    end
                    detail("Wall vertical trim",Vector3.new(0.2,WALL_HEIGHT-1.3,0.2),
                        cf*CFrame.new(-TILE/2+0.4,WALL_HEIGHT/2,0),trimColor)
                end
            end

        end
    end
end
-- Ceiling tiles (non-collidable so a player's camera is not trapped).
local ceiling=block("Industrial ceiling",Vector3.new(#map[1]*TILE,0.5,#map*TILE),
    CFrame.new(pos(#map[1]/2,#map/2,WALL_HEIGHT+0.4)),
    Color3.fromRGB(58,73,82))
ceiling.CanCollide=false
-- Lighting never goes fully dark; occasional brief flicker retains safe visibility.
local breachIntermission=false
task.spawn(function()
    while root.Parent do
        local now=os.clock()
        local flicker=(math.sin(now*1.7)>0.995) and 0.72 or 1
        for _,fixture in ipairs(lightingFixtures) do
            fixture.light.Brightness=2.3*flicker
            fixture.part.Color=flicker<1 and Color3.fromRGB(143,185,181)
                or Color3.fromRGB(193,245,236)
        end
        local redPulse=breachIntermission and (math.sin(now*9)>0 and 2.8 or 0.7) or 0
        for _,fixture in ipairs(redFixtures) do
            fixture.light.Brightness=redPulse
            fixture.part.Color=redPulse>0 and Color3.fromRGB(255,43,36)
                or Color3.fromRGB(70,16,17)
        end
        task.wait(0.12)
    end
end)
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
            breachIntermission=true
            task.wait(7) -- Red alarms flash between alien breaches.
            breachIntermission=false
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
-- Breadth-first flow fields guide every alien through connected corridors.
-- One field per active player, refreshed at intervals (not per frame).
local fields={}
local fieldTimer=0
local directions={{1,0},{-1,0},{0,1},{0,-1}}
local function tileKey(x,y) return y*WIDTH+x end
local function gridOf(v)
    return math.floor(v.X/TILE+WIDTH/2)+1,math.floor(v.Z/TILE+HEIGHT/2)+1
end
local function buildField(hrp)
    local sx,sy=gridOf(hrp.Position)
    if not free(sx-0.5,sy-0.5) then return {} end
    local distances={[tileKey(sx,sy)]=0}
    local queue={{sx,sy}}
    local head=1
    while head<=#queue do
        local item=queue[head];head+=1
        local distance=distances[tileKey(item[1],item[2])]
        for _,d in ipairs(directions) do
            local nx,ny=item[1]+d[1],item[2]+d[2]
            local k=tileKey(nx,ny)
            if distances[k]==nil and free(nx-0.5,ny-0.5) then
                distances[k]=distance+1
                table.insert(queue,{nx,ny})
            end
        end
    end
    return distances
end
RunService.Heartbeat:Connect(function(dt)
    fieldTimer+=dt
    if fieldTimer>=0.65 then
        fieldTimer=0
        for _,player in ipairs(Players:GetPlayers()) do
            local character=player.Character
            local hrp=character and character:FindFirstChild("HumanoidRootPart")
            local hum=character and character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health>0 then fields[player]=buildField(hrp) else fields[player]=nil end
        end
    end
    for _,alien in ipairs(enemies:GetChildren()) do
        local part=alien.PrimaryPart
        if not part then continue end
        local ax,ay=gridOf(part.Position)
        local bestPlayer,bestDistance,bestField=nil,math.huge,nil
        for _,player in ipairs(Players:GetPlayers()) do
            local field=fields[player]
            local d=field and field[tileKey(ax,ay)]
            if d and d<bestDistance then
                bestDistance=d;bestPlayer=player;bestField=field
            end
        end
        if bestPlayer then
            local hrp=bestPlayer.Character and bestPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local tx,ty=ax,ay
                if bestDistance>0 then
                    for _,d in ipairs(directions) do
                        local nx,ny=ax+d[1],ay+d[2]
                        local nd=bestField[tileKey(nx,ny)]
                        if nd and nd<bestDistance then bestDistance=nd;tx=nx;ty=ny end
                    end
                end
                local target=bestDistance==0 and hrp.Position or pos(tx-0.5,ty-0.5,part.Position.Y)
                local delta=Vector3.new(target.X-part.Position.X,0,target.Z-part.Position.Z)
                if delta.Magnitude>0.12 then
                    local step=delta.Unit*math.min(10*dt,delta.Magnitude)
                    alien:PivotTo(alien:GetPivot()+step)
                end
                if (hrp.Position-part.Position).Magnitude<6 and os.clock()-(damageClock[alien] or 0)>1.2 then
                    damageClock[alien]=os.clock()
                    local hum=bestPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum:TakeDamage(10) end
                end
            end
        end
    end
end)
