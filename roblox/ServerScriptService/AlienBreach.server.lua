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
for _,p in ipairs({{40.5,7.5},{48.5,5.5},{39.5,19.5},{49.5,23.5},{43.5,34.5},{51.5,35.5},{6.5,37.5},{12.5,40.5},{20.5,38.5},{31.5,37.5},{15.5,31.5},{29.5,30.5}}) do table.insert(chestPoints,p) end
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
Lighting.ClockTime=14
Lighting.Brightness=1.45
Lighting.ExposureCompensation=-0.35
Lighting.GlobalShadows=false
Lighting.Ambient=Color3.fromRGB(124,137,139)
Lighting.OutdoorAmbient=Color3.fromRGB(100,112,118)
Lighting.FogEnd=320
Lighting.FogColor=Color3.fromRGB(18,31,36)
local breachState=ReplicatedStorage:FindFirstChild("AlienBreachState") or Instance.new("Folder")
breachState.Name="AlienBreachState"
breachState.Parent=ReplicatedStorage
local function state(name,initial)
    local v=breachState:FindFirstChild(name) or Instance.new("IntValue")
    v.Name=name;v.Value=initial;v.Parent=breachState
    return v
end
local waveValue=state("Breach",0)
local aliveValue=state("AliensRemaining",0)
local timerValue=state("NextBreachIn",0)
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
local function tallRoom(x,y)
    return (x>=38 and x<=53 and y>=3 and y<=10)
        or (x>=38 and x<=53 and y>=15 and y<=24)
        or (x>=19 and x<=33 and y>=35 and y<=41)
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
            local fixtureHeight=tallRoom(x,y) and 34 or WALL_HEIGHT
            -- Evenly spaced overhead fluorescent lamps and independent red alarms.
            if x%4==0 and y%4==0 then
                local lamp=detail("Always-on ceiling light",Vector3.new(4.5,0.35,1.1),
                    CFrame.new(center+Vector3.new(0,fixtureHeight+0.05,0)),
                    Color3.fromRGB(193,245,236),Enum.Material.Neon)
                local light=Instance.new("PointLight")
                light.Color=Color3.fromRGB(200,246,238)
                light.Brightness=1.0
                light.Range=tallRoom(x,y) and 65 or 48
                light.Shadows=false
                light.Parent=lamp
                table.insert(lightingFixtures,{part=lamp,light=light})
                local alarm=detail("Breach warning lamp",Vector3.new(1.2,0.35,1.2),
                    CFrame.new(center+Vector3.new(2.5,fixtureHeight+0.05,0)),
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
-- Separate ceiling panels allow the three major labs to have soaring 34-stud ceilings.
-- Their raised upper wall sections remain visible above the regular corridor height.
for y,row in ipairs(map) do
    local x=1
    while x<=#row do
        if row:sub(x,x)=="0" then
            local first=x
            local high=tallRoom(x,y)
            while x<=#row and row:sub(x,x)=="0" and tallRoom(x,y)==high do x+=1 end
            local count=x-first
            local h=high and 34 or WALL_HEIGHT
            local ceiling=block(high and "High laboratory ceiling" or "Corridor ceiling",
                Vector3.new(count*TILE,0.5,TILE),
                CFrame.new(pos(first-1+count/2,y-0.5,h+0.4)),Color3.fromRGB(49,61,68))
            ceiling.CanCollide=false
        else x+=1 end
    end
end
for y,row in ipairs(map) do
    for x=1,#row do
        if row:sub(x,x)=="0" and tallRoom(x,y) then
            local center=pos(x-0.5,y-0.5,0)
            for _,d in ipairs({{1,0},{-1,0},{0,1},{0,-1}}) do
                if not tallRoom(x+d[1],y+d[2]) then
                    local edge=center+Vector3.new(d[1]*TILE/2,26,d[2]*TILE/2)
                    local size=d[1]~=0 and Vector3.new(0.45,16,TILE) or Vector3.new(TILE,16,0.45)
                    block("Tall lab upper wall",size,CFrame.new(edge),Color3.fromRGB(68,78,85))
                end
            end
        end
    end
end
-- Lighting never goes fully dark; occasional brief flicker retains safe visibility.
local breachIntermission=false
local alarm=Instance.new("Sound")
alarm.Name="Emergency breach siren"
alarm.SoundId="rbxasset://sounds/alarm.wav"
alarm.Volume=1.8
alarm.Looped=true
alarm.Parent=root
local flickerUntil=0
local nextFlicker=os.clock()+math.random(30,40)/10
task.spawn(function()
    while root.Parent do
        local now=os.clock()
        -- 0.3 second dip, followed by 3-4 seconds of steady full brightness.
        if now>=nextFlicker then
            flickerUntil=now+0.3
            nextFlicker=flickerUntil+math.random(30,40)/10
        end
        local flicker=now<flickerUntil and 0.18 or 1
        Lighting.Brightness=1.45*flicker
        Lighting.ExposureCompensation=-0.35-(1-flicker)*0.5
        for _,fixture in ipairs(lightingFixtures) do
            fixture.light.Brightness=1.0*flicker
            fixture.part.Color=flicker<1 and Color3.fromRGB(143,185,181)
                or Color3.fromRGB(193,245,236)
        end
        local redPulse=breachIntermission and (math.sin(now*11)>0 and 4.2 or 0.3) or 0
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
    local inLab=tallRoom(math.floor(x)+1,math.floor(y)+1)
    local function item(name,size,offset,color,material)
        return block(name,size,CFrame.new(at+offset),color,material)
    end
    if kind=="table" then
        local topp=item("Stainless laboratory bench",Vector3.new(6,0.38,3),Vector3.new(0,3.2,0),Color3.fromRGB(123,131,132))
        for dx=-1,1,2 do for dz=-1,1,2 do
            item("Bench leg",Vector3.new(0.28,3,0.28),Vector3.new(dx*2.5,1.5,dz),metal)
        end end
        if inLab then
            item("Abandoned specimen tray",Vector3.new(1.7,0.15,1.1),Vector3.new(1,3.52,0),Color3.fromRGB(71,87,85))
        end
    elseif kind=="cabinet" then
        item("Metal filing cabinet",Vector3.new(3.6,6.2,2.5),Vector3.new(0,3.1,0),Color3.fromRGB(78,86,91))
        for h=1,5,2 do
            item("Cabinet drawer front",Vector3.new(3.35,1.7,0.12),Vector3.new(0,h+0.1,-1.3),Color3.fromRGB(104,111,112))
            item("Drawer handle",Vector3.new(0.9,0.12,0.16),Vector3.new(0,h+0.2,-1.4),Color3.fromRGB(28,36,40))
        end
    else
        -- Real workstation: thin desktop, two pedestal drawers, monitor, keyboard,
        -- mouse, paper stack and a separate office chair.
        item("Office desk top",Vector3.new(6.2,0.35,3.2),Vector3.new(0,2.7,0),Color3.fromRGB(115,100,83),Enum.Material.Wood)
        for _,dx in ipairs({-2.65,2.65}) do
            item("Desk pedestal",Vector3.new(0.9,2.45,2.5),Vector3.new(dx,1.25,0.15),Color3.fromRGB(71,78,82))
            for h=0.7,2.0,0.65 do
                item("Desk drawer",Vector3.new(0.75,0.48,0.09),Vector3.new(dx,h,-1.17),Color3.fromRGB(100,107,109))
            end
        end
        item("Computer monitor",Vector3.new(2.5,1.65,0.24),Vector3.new(-0.4,4.0,0.6),Color3.fromRGB(24,30,34))
        item("Dim computer screen",Vector3.new(2.2,1.35,0.05),Vector3.new(-0.4,4.0,0.45),Color3.fromRGB(37,58,54),Enum.Material.SmoothPlastic)
        item("Monitor stand",Vector3.new(0.18,0.8,0.18),Vector3.new(-0.4,3.1,0.65),metal)
        item("Keyboard",Vector3.new(2.0,0.12,0.6),Vector3.new(-0.4,2.96,-0.75),Color3.fromRGB(32,36,39))
        item("Mouse",Vector3.new(0.3,0.13,0.48),Vector3.new(1.1,2.96,-0.8),Color3.fromRGB(36,40,43))
        item("Paperwork",Vector3.new(0.9,0.06,0.8),Vector3.new(1.7,2.96,0.7),Color3.fromRGB(192,188,166),Enum.Material.SmoothPlastic)
        item("Office chair seat",Vector3.new(2.0,0.35,1.9),Vector3.new(0,1.8,-3.1),Color3.fromRGB(44,53,59))
        item("Office chair back",Vector3.new(2.0,2.5,0.3),Vector3.new(0,3,-4),Color3.fromRGB(42,51,57))
        item("Chair post",Vector3.new(0.22,1.5,0.22),Vector3.new(0,0.8,-3.1),metal)
    end
end
-- Scattered abandoned laboratory debris only; offices stay relatively tidy.
local function labDebris(x,y,seed)
    local at=pos(x,y,0)
    local rng=Random.new(seed)
    for i=1,rng:NextInteger(3,7) do
        local dx=rng:NextNumber(-2.7,2.7)
        local dz=rng:NextNumber(-2.7,2.7)
        local sheet=block("Discarded laboratory report",Vector3.new(rng:NextNumber(0.8,1.5),0.025,rng:NextNumber(1,1.9)),
            CFrame.new(at+Vector3.new(dx,0.24,dz))*CFrame.Angles(0,rng:NextNumber(-3.1,3.1),0),
            Color3.fromRGB(rng:NextInteger(160,209),rng:NextInteger(156,201),rng:NextInteger(140,185)),Enum.Material.SmoothPlastic)
        sheet.CanCollide=false;sheet.CanTouch=false;sheet.CastShadow=false
    end
end
for _,spot in ipairs({{40.5,4.5},{46.5,6.5},{51.5,8.5},{41.5,20.5},{48.5,17.5},{52.5,23.5},{22.5,37.5},{30.5,39.5}}) do
    labDebris(spot[1],spot[2],math.floor(spot[1]*101+spot[2]*79))
end
-- Several toppled workbenches, angled onto their sides with scattered equipment.
for _,spot in ipairs({{43.5,9.5},{50.5,21.5},{27.5,40.5}}) do
    local at=pos(spot[1],spot[2],0)
    local tipped=block("Overturned lab table",Vector3.new(5.5,0.45,3),
        CFrame.new(at+Vector3.new(0,1.7,0))*CFrame.Angles(0,0,math.rad(73)),
        Color3.fromRGB(107,114,116))
    for _,dx in ipairs({-2,2}) do
        block("Bent table leg",Vector3.new(0.3,2.6,0.3),
            tipped.CFrame*CFrame.new(dx,-1.45,0),Color3.fromRGB(63,72,76))
    end
end
for _,p in ipairs(props) do furniture(p[1],p[2],p[3]) end

-- AREA 51 containment wing: slimmer transparent cylinders, suspended specimens,
-- hanging umbilical hoses, illuminated caps, and realistic segmented utilities.
local function cylinder(name,radius,height,cf,color,material,parent,transparency)
    local p=block(name,Vector3.new(height,radius*2,radius*2),cf*CFrame.Angles(0,0,math.rad(90)),color,material,parent)
    p.Shape=Enum.PartType.Cylinder
    p.Transparency=transparency or 0
    return p
end
local function segment(name,a,b,radius,color,material,parent)
    local mid=(a+b)*0.5
    local delta=b-a
    local p=cylinder(name,radius,delta.Magnitude,CFrame.lookAt(mid,b)*CFrame.Angles(math.rad(90),0,0),color,material,parent)
    p.CanCollide=false
    return p
end
-- Large containment chambers: grouped in pairs and rows.
local function specimenTank(x,y,empty)
    local origin=pos(x,y,0)
    local model=Instance.new("Model")
    model.Name=empty and "Empty giant containment chamber" or "Alien containment chamber"
    model.Parent=root
    local function disc(name,radius,height,yPos,color,material)
        return cylinder(name,radius,height,CFrame.new(origin+Vector3.new(0,yPos,0)),color,material,model)
    end
    disc("Heavy chamber foundation",3.55,0.85,0.42,Color3.fromRGB(55,66,73))
    disc("Lower steel seal",3.4,0.4,1.05,Color3.fromRGB(113,131,136))
    local fluid=disc("Subdued preservation fluid",3.08,15.2,8.95,Color3.fromRGB(60,109,100),Enum.Material.Glass)
    fluid.Transparency=0.94;fluid.CanCollide=false;fluid.CanQuery=false
    local glass=disc("Giant glass cylinder",3.3,15.6,9.0,Color3.fromRGB(151,199,191),Enum.Material.Glass)
    glass.Transparency=0.84;glass.CanCollide=false;glass.CanQuery=false
    disc("Upper reinforced steel seal",3.55,0.5,17.0,Color3.fromRGB(77,91,99))
    disc("Top industrial chamber cap",3.7,0.65,17.5,Color3.fromRGB(79,90,98))
    if not empty then
        local template=game:GetService("ServerStorage"):FindFirstChild("AlienMesh")
        if template and template:IsA("MeshPart") then
            local specimen=template:Clone()
            specimen.Name="Contained AlienBody"
            specimen.Anchored=true
            specimen.CanCollide=false
            specimen.CanTouch=false
            specimen.CanQuery=false
            specimen.TextureID=""
            specimen.Material=Enum.Material.SmoothPlastic
            specimen.Color=Color3.fromRGB(76,126,61)
            local size=template.Size
            local longest=math.max(size.X,size.Y,size.Z)
            local scale=math.min(12/longest,5.0/math.max(0.01,math.min(size.X,size.Z)))
            specimen.Size=size*scale
            local rotation=CFrame.identity
            if size.X>size.Y and size.X>size.Z then rotation=CFrame.Angles(0,0,math.rad(90))
            elseif size.Z>size.Y and size.Z>size.X then rotation=CFrame.Angles(math.rad(90),0,0) end
            specimen.CFrame=CFrame.new(origin+Vector3.new(0,8.0,0))*rotation
            specimen.Parent=model
        else
            warn("AlienMesh MeshPart missing from ServerStorage; containment chamber left empty")
        end
    end
end
-- Rows of oversized chambers, including adjacent pairs.
for _,spec in ipairs({
    {40.5,5.5,false},{48.5,5.5,false},
    {40.5,9.5,false},{48.5,9.5,true},
    {40.5,17.5,false},{48.5,17.5,false},
    {40.5,23.5,true},{48.5,23.5,false},
    {21.5,36.5,false},{29.5,36.5,false},
    {21.5,40.5,false},{29.5,40.5,true}
}) do
    specimenTank(spec[1],spec[2],spec[3])
end
-- Industrial yellow pipe networks: elbows, brackets, junction collars and
-- parallel overhead runs, rather than huge unbroken floating rods.
local yellow=Color3.fromRGB(157,121,48)
local function pipeRun(points,radius)
    for i=1,#points-1 do
        local a,b=pos(points[i][1],points[i][2],points[i][3]),pos(points[i+1][1],points[i+1][2],points[i+1][3])
        local pipe=segment("Yellow coolant pipe",a,b,radius,yellow,Enum.Material.SmoothPlastic,root)
        pipe.Reflectance=0
        cylinder("Pipe coupling flange",radius*1.35,0.38,CFrame.new(a)*CFrame.Angles(0,0,0),Color3.fromRGB(89,91,83),Enum.Material.Metal,root).CanCollide=false
        if i==#points-1 then
            cylinder("Pipe end coupling",radius*1.35,0.38,CFrame.new(b),Color3.fromRGB(89,91,83),Enum.Material.Metal,root).CanCollide=false
        end
    end
end
pipeRun({{38.5,6,29},{43,6,29},{47,6,29},{52.5,6,29},{52.5,10,29}},0.58)
pipeRun({{38.5,8,30},{44,8,30},{50,8,30},{50,15,30},{50,20,30},{52.5,20,30}},0.42)
pipeRun({{38.5,19,29},{44,19,29},{48,19,29},{53,19,29}},0.58)
pipeRun({{39,22,30},{44,22,30},{49,22,30},{53,22,30}},0.4)
pipeRun({{20,37,29},{25,37,29},{31,37,29},{31,40,29}},0.5)
-- Distinctive hazard-striped bulkhead frames around lab entries.
local function bulkhead(x,y,axis)
    local base=pos(x,y,0)
    local frame=Instance.new("Model")
    frame.Name="Hazard striped laboratory airlock"
    frame.Parent=root
    local horizontal=axis=="x"
    local function bar(name,size,offset,color)
        local p=block(name,size,CFrame.new(base+offset),color,Enum.Material.Metal,frame)
        p.CanCollide=false
        return p
    end
    local sideSize=horizontal and Vector3.new(0.8,15,1.3) or Vector3.new(1.3,15,0.8)
    for _,side in ipairs({-1,1}) do
        local off=horizontal and Vector3.new(0,7.5,side*3.5) or Vector3.new(side*3.5,7.5,0)
        bar("Reinforced airlock jamb",sideSize,off,Color3.fromRGB(47,58,65))
        for j=0,4 do
            local stripe=bar("Yellow caution stripe",horizontal and Vector3.new(0.86,1.15,1.34) or Vector3.new(1.34,1.15,0.86),off+Vector3.new(0,-5.5+j*2.8,0),yellow)
            stripe.CFrame=stripe.CFrame*CFrame.Angles(0,0,math.rad(25))
        end
    end
    bar("Airlock header",horizontal and Vector3.new(0.8,1.5,8) or Vector3.new(8,1.5,0.8),Vector3.new(0,15,0),Color3.fromRGB(43,53,61))
    local lamp=bar("Airlock status light",horizontal and Vector3.new(0.85,0.4,2) or Vector3.new(2,0.4,0.85),Vector3.new(0,14.1,0),Color3.fromRGB(160,244,211))
    lamp.Material=Enum.Material.Neon
end
bulkhead(38.5,5.5,"x")
bulkhead(38.5,18.5,"x")
bulkhead(25.5,34.5,"z")
-- Extra laboratory set dressing: machinery, specimen carts, cable trays.
for _,p in ipairs({{46.5,10.5},{47.5,23.5},{25.5,40.5}}) do
    local at=pos(p[1],p[2],0)
    block("Research equipment trolley",Vector3.new(3.3,0.35,2.3),CFrame.new(at+Vector3.new(0,2.7,0)),Color3.fromRGB(109,121,126))
    block("Lab diagnostic machine",Vector3.new(1.8,1.6,1.5),CFrame.new(at+Vector3.new(0,3.6,0)),Color3.fromRGB(53,68,74))
    block("Diagnostic screen",Vector3.new(1.3,0.9,0.06),CFrame.new(at+Vector3.new(0,3.8,-0.78)),Color3.fromRGB(46,82,76),Enum.Material.SmoothPlastic)
end
local function wallPoster(x,y,title,subtitle,bg,ink)
    local origin=pos(x,y,0)
    local plate=block("Area 51 wall warning poster",Vector3.new(5.5,5.7,0.14),
        CFrame.new(origin+Vector3.new(0,9,-TILE/2+0.18)),Color3.fromRGB(25,30,33))
    plate.CanCollide=false
    local gui=Instance.new("SurfaceGui")
    gui.Name="Printed warning signage"
    gui.Face=Enum.NormalId.Front
    gui.CanvasSize=Vector2.new(520,540)
    gui.LightInfluence=0
    gui.Parent=plate
    local background=Instance.new("Frame")
    background.Size=UDim2.fromScale(1,1)
    background.BackgroundColor3=bg
    background.BorderSizePixel=0
    background.Parent=gui
    local heading=Instance.new("TextLabel")
    heading.BackgroundTransparency=1
    heading.Position=UDim2.fromScale(0.05,0.08)
    heading.Size=UDim2.fromScale(0.9,0.55)
    heading.Text=title
    heading.TextWrapped=true
    heading.TextScaled=true
    heading.Font=Enum.Font.GothamBlack
    heading.TextColor3=ink
    heading.Parent=background
    local sub=Instance.new("TextLabel")
    sub.BackgroundTransparency=1
    sub.Position=UDim2.fromScale(0.08,0.7)
    sub.Size=UDim2.fromScale(0.84,0.22)
    sub.Text=subtitle
    sub.TextWrapped=true
    sub.TextScaled=true
    sub.Font=Enum.Font.Code
    sub.TextColor3=ink
    sub.Parent=background
end
wallPoster(43.5,3.5,"AREA 51","CLASSIFIED RESEARCH / LEVEL 5",Color3.fromRGB(219,205,152),Color3.fromRGB(24,39,36))
wallPoster(47.5,3.5,"KEEP OUT","BIOHAZARD / AUTHORIZED PERSONNEL ONLY",Color3.fromRGB(219,180,38),Color3.fromRGB(40,28,15))
wallPoster(43.5,15.5,"SPECIMEN 07","GREY TYPE / DO NOT OPEN TANK",Color3.fromRGB(205,218,202),Color3.fromRGB(22,61,51))
wallPoster(48.5,15.5,"ALIEN ANATOMY","EXTRATERRESTRIAL BIOLOGY DIVISION",Color3.fromRGB(190,216,202),Color3.fromRGB(27,70,62))
wallPoster(25.5,35.5,"DANGER","CONTAINMENT BREACH PROTOCOL",Color3.fromRGB(211,172,47),Color3.fromRGB(50,24,20))

local spawn = Instance.new("SpawnLocation")
spawn.Name="Starting Room Spawn"
spawn.Size=Vector3.new(5,1,5)
spawn.CFrame=CFrame.new(pos(3.5,3.5,0.5))
spawn.Anchored=true
spawn.Neutral=true
spawn.Transparency=0.5
spawn.Color=neon
spawn.Parent=root
-- Original browser game: 90-second supply rotation, laser 1/150,
-- medkit probability (1/20 + 1/7 - 1/150), otherwise 15-35 ammo.
-- The larger facility deploys 12 caches per rotation instead of 5.
local activeChests=Instance.new("Folder")
activeChests.Name="SupplyCaches"
activeChests.Parent=root
local function newChest(x,y,index)
    local base=pos(x,y,0)
    local model=Instance.new("Model")
    model.Name="Armored supply cache "..index
    model.Parent=activeChests
    local box=block("Heavy reinforced storage case",Vector3.new(5.5,2.8,3.8),CFrame.new(base+Vector3.new(0,1.5,0)),Color3.fromRGB(62,83,77),Enum.Material.Metal,model)
    local lid=block("Hinged steel lid",Vector3.new(5.8,0.6,4.0),CFrame.new(base+Vector3.new(0,3.15,0)),Color3.fromRGB(95,117,97),Enum.Material.Metal,model)
    for _,dx in ipairs({-2.2,2.2}) do
        local strap=block("Armored locking band",Vector3.new(0.45,3.25,4.1),CFrame.new(base+Vector3.new(dx,1.85,0)),Color3.fromRGB(38,48,53),Enum.Material.Metal,model)
        strap.CanCollide=false
    end
    local emblem=block("Illuminated medical supply insignia",Vector3.new(1.8,0.12,1),CFrame.new(base+Vector3.new(0,3.52,0)),Color3.fromRGB(115,231,163),Enum.Material.Neon,model)
    emblem.CanCollide=false
    local prompt=Instance.new("ProximityPrompt")
    prompt.ActionText="OPEN CACHE"
    prompt.ObjectText="AREA 51 SUPPLY CHEST"
    prompt.HoldDuration=0.6
    prompt.MaxActivationDistance=12
    prompt.RequiresLineOfSight=false
    prompt.Parent=box
    local claimed=false
    prompt.Triggered:Connect(function(player)
        if claimed then return end
        local character=player.Character
        local hrp=character and character:FindFirstChild("HumanoidRootPart")
        if not player:GetAttribute("AlienBreachDeployed") or not hrp or (hrp.Position-box.Position).Magnitude>16 then return end
        claimed=true
        prompt.Enabled=false
        local roll=math.random()
        local message=""
        if roll<1/150 then
            player:SetAttribute("HasLegendaryLaser",true)
            message="LEGENDARY LASER UNLOCKED! Press 2 to equip."
        elseif roll<1/20+1/7 then
            player:SetAttribute("Medkits",(player:GetAttribute("Medkits") or 0)+1)
            message="MEDKIT FOUND! Press H to heal."
        else
            local count=math.random(15,35)
            player:SetAttribute("ReserveAmmo",(player:GetAttribute("ReserveAmmo") or 0)+count)
            message="AMMO FOUND: +"..count.." charges"
        end
        player:SetAttribute("LastCacheReward",message)
        lid.CFrame=lid.CFrame*CFrame.new(0,0.7,1.3)*CFrame.Angles(math.rad(35),0,0)
        task.delay(2,function() if model.Parent then model:Destroy() end end)
    end)
end
local function rotateChests()
    activeChests:ClearAllChildren()
    local shuffled=table.clone(chestPoints)
    for i=#shuffled,2,-1 do
        local j=math.random(1,i)
        shuffled[i],shuffled[j]=shuffled[j],shuffled[i]
    end
    local count=0
    for _,p in ipairs(shuffled) do
        if free(p[1],p[2]) then
            count+=1
            newChest(p[1],p[2],count)
            if count>=12 then break end
        end
    end
end
rotateChests()
task.spawn(function()
    while root.Parent do
        task.wait(90)
        if root.Parent then rotateChests() end
    end
end)
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
-- Browser game weapon balancing: one map unit = TILE (8 Roblox studs).
local weaponStats={
 pulse={range=12,delay=.30,cost=1,damage=1},
 shotgun={range=12,delay=.72,cost=1,damage=1,pellets=4},
 rifle={range=15.6,delay=.60,cost=1,damage=1},
 viper={range=12,delay=.12,cost=1,damage=1},
 ar51={range=19,delay=.34,cost=1,damage=1},
 phantom={range=48,delay=1.35,cost=1,damage=4},
 titan={range=15,delay=.085,cost=2,damage=1},
 plasma={range=17,delay=.68,cost=3,damage=4},
 obliterator={range=48,delay=.85,cost=4,damage=4},
 laser={range=60,delay=.18,cost=5,damage=4}
}
local tracerColors={pulse=Color3.fromRGB(100,245,189),shotgun=Color3.fromRGB(230,164,108),rifle=Color3.fromRGB(129,198,237),viper=Color3.fromRGB(110,255,169),ar51=Color3.fromRGB(144,180,200),phantom=Color3.fromRGB(97,228,255),titan=Color3.fromRGB(255,180,91),plasma=Color3.fromRGB(178,122,255),obliterator=Color3.fromRGB(255,91,99),laser=Color3.fromRGB(72,223,255)}

local lastShot={}
local shotAmmo={}
local lastReload={}
local lastHeal={}
Players.PlayerAdded:Connect(function(player)
    player:SetAttribute("ReserveAmmo",0) -- Start with exactly 25 total rounds (25 in magazine)
    player:SetAttribute("Medkits",0)
    player:SetAttribute("HasLegendaryLaser",false)
    player:SetAttribute("Weapon","pulse")
    player:SetAttribute("Magazine",25)
end)
local control=ReplicatedStorage:FindFirstChild("AlienBreachControl") or Instance.new("RemoteEvent")
control.Name="AlienBreachControl";control.Parent=ReplicatedStorage
local function equip(player,id)
 local allowed=player:GetAttribute("AlienBreachAllowedWeapons") or "pulse"
 if id=="laser" then
  if not player:GetAttribute("HasLegendaryLaser") then return end
 elseif not string.find(","..allowed..",",","..id..",",1,true) then return end
 if not weaponStats[id] then return end
 player:SetAttribute("Weapon",id)
 player:SetAttribute("Magazine",math.min(25,player:GetAttribute("Magazine") or 25))
end
control.OnServerEvent:Connect(function(player,action)
 if not player:GetAttribute("AlienBreachDeployed") then return end
 if action=="reload" then
  local last=lastReload[player] or 0
  if os.clock()-last<1.4 then return end
  lastReload[player]=os.clock()
  local magazine=player:GetAttribute("Magazine") or 0
  local reserve=player:GetAttribute("ReserveAmmo") or 0
  local amount=math.min(25-magazine,reserve)
  if amount>0 then
   player:SetAttribute("Magazine",magazine+amount)
   player:SetAttribute("ReserveAmmo",reserve-amount)
  end
 elseif type(action)=="string" and weaponStats[action] then
  equip(player,action)
 elseif action=="heal" then
  if os.clock()-(lastHeal[player] or 0)<1 then return end
  local char=player.Character
  local hum=char and char:FindFirstChildOfClass("Humanoid")
  local kits=player:GetAttribute("Medkits") or 0
  if hum and hum.Health>0 and hum.Health<hum.MaxHealth and kits>0 then
   lastHeal[player]=os.clock()
   player:SetAttribute("Medkits",kits-1)
   hum.Health=math.min(hum.MaxHealth,hum.Health+35)
  end
 end
end)
local Debris=game:GetService("Debris")
local function tracer(startPos,endPos,id)
 local delta=endPos-startPos
 if delta.Magnitude<.1 then return end
 local beam=Instance.new("Part")
 beam.Name="Player_"..id.."_Projectile"
 beam.Anchored=true;beam.CanCollide=false;beam.CanTouch=false;beam.CanQuery=false
 beam.Material=Enum.Material.Neon
 beam.Color=tracerColors[id] or tracerColors.pulse
 beam.Size=Vector3.new(id=="laser" and .25 or .11,id=="laser" and .25 or .11,math.min(delta.Magnitude,id=="laser" and 20 or 4))
 beam.CFrame=CFrame.lookAt(endPos-delta.Unit*(beam.Size.Z/2),endPos)
 beam.Parent=workspace
 Debris:AddItem(beam,id=="laser" and .17 or .11)
end
local function hurtAlien(player,alien,amount)
 if not alien or alien.Parent~=enemies then return end
 local hp=(alien:GetAttribute("HP") or 50)-amount*25
 alien:SetAttribute("HP",hp)
 if hp<=0 then
  alien:Destroy()
  local stats=player:FindFirstChild("leaderstats")
  if stats then
   stats.Kills.Value+=1
   stats.Credits.Value+=20
  end
 end
end
remote.OnServerEvent:Connect(function(player,origin,direction)
 if not player:GetAttribute("AlienBreachDeployed") then return end
 if typeof(origin)~="Vector3" or typeof(direction)~="Vector3" then return end
 if direction.Magnitude<.9 or direction.Magnitude>1.1 then return end
 local character=player.Character
 local head=character and character:FindFirstChild("Head")
 if not head or (origin-head.Position).Magnitude>12 then return end
 local id=player:GetAttribute("Weapon") or "pulse"
 local w=weaponStats[id] or weaponStats.pulse
 local now=os.clock()
 if now-(lastShot[player] or 0)<w.delay-.012 then return end
 local mag=player:GetAttribute("Magazine") or 0
 if mag<w.cost then return end
 lastShot[player]=now
 player:SetAttribute("Magazine",mag-w.cost)
 local params=RaycastParams.new()
 params.FilterType=Enum.RaycastFilterType.Exclude
 params.FilterDescendantsInstances={character}
 local maxDist=w.range*TILE
 local hits={}
 local pellets=w.pellets or 1
 for i=1,pellets do
  local angle=pellets==1 and 0 or (i-2.5)*.045
  local dir=(CFrame.lookAt(Vector3.zero,direction)*CFrame.Angles(0,angle,0)).LookVector
  local result=workspace:Raycast(origin,dir*maxDist,params)
  local endPos=result and result.Position or origin+dir*maxDist
  tracer(origin+dir*2,endPos,id)
  if result and result.Instance:IsDescendantOf(enemies) then
   local alien=result.Instance:FindFirstAncestorOfClass("Model")
   if alien and alien.Parent==enemies then hits[alien]=(hits[alien] or 0)+1 end
  end
 end
 for alien,count in pairs(hits) do
  if id=="laser" then
   hurtAlien(player,alien,alien:GetAttribute("Kind")=="armored" and 2 or alien:GetAttribute("Kind")=="boss" and 8 or 100)
  else
   hurtAlien(player,alien,w.damage*count*({[1]=.55,[2]=.78,[3]=1,[4]=1.3,[5]=1.65})[math.clamp(tonumber(player:GetAttribute("WeaponLevel_"..id)) or 3,1,5)])
  end
 end
 if id=="plasma" then
  for target in pairs(hits) do
   local center=target.PrimaryPart
   if center then
    for _,alien in ipairs(enemies:GetChildren()) do
     if alien~=target and alien.PrimaryPart and (alien.PrimaryPart.Position-center.Position).Magnitude<1.8*TILE then hurtAlien(player,alien,1.8) end
    end
   end
  end
 elseif id=="obliterator" then
  for _,alien in ipairs(enemies:GetChildren()) do
   if not hits[alien] and alien.PrimaryPart then
    local delta=alien.PrimaryPart.Position-origin
    if delta.Magnitude<maxDist and delta.Magnitude>0 and direction:Dot(delta.Unit)>math.cos(.075) then
     local r=workspace:Raycast(origin,delta,params)
     if r and r.Instance:IsDescendantOf(alien) then hurtAlien(player,alien,6) end
    end
   end
  end
 end
end)
Players.PlayerRemoving:Connect(function(player)lastShot[player]=nil end)
-- Three browser-game species: stalker, armored, crawler.
-- Every body part belongs to one anchored Model and moves together via PivotTo.
local alienAnimation={}
local function makeAlien(x,y,kind,wave)
    kind=kind or "stalker"
    local model=Instance.new("Model")
    model.Name=(kind=="boss" and "BREACH OVERLORD" or kind=="armored" and "Armored Alien" or kind=="crawler" and "Crawler Alien" or "Stalker Alien")
    model:SetAttribute("Kind",kind)
    model:SetAttribute("Speed",kind=="boss" and 6.2 or kind=="crawler" and 15 or kind=="armored" and 7.5 or 10.5)
    model:SetAttribute("HP",kind=="boss" and 900+wave*75 or kind=="armored" and 100 or 50)
    model.Parent=enemies
    local origin=pos(x,y,0)
    -- Prefer a single imported MeshPart for a continuous alien silhouette.
    -- Put an imported MeshPart named AlienMesh in ServerStorage to activate it.
    local meshTemplate=game:GetService("ServerStorage"):FindFirstChild("AlienMesh")
    if meshTemplate and meshTemplate:IsA("MeshPart") then
        local mesh=meshTemplate:Clone()
        mesh.Name="AlienBody"
        mesh.Anchored=true
        mesh.CanCollide=false
        mesh.CanTouch=false
        mesh.Transparency=0
        mesh.Material=Enum.Material.SmoothPlastic
        mesh.Reflectance=0
        mesh.CastShadow=true
        -- Imported mesh textures can override part color; remove glowing texture overrides.
        mesh.TextureID=""
        mesh.Color=kind=="boss" and Color3.fromRGB(132,35,65) or kind=="armored" and Color3.fromRGB(57,100,48) or Color3.fromRGB(76,126,61)
        mesh.Size=meshTemplate.Size*(kind=="boss" and 2.9 or kind=="crawler" and 0.85 or kind=="armored" and 1.3 or 1.1)
        -- OBJ imports can use X or Z as the vertical axis. Rotate the longest
        -- dimension upright and use the rotated bounds to put feet on the floor.
        local size=mesh.Size
        local upright=CFrame.identity
        if size.X>size.Y and size.X>size.Z then
            upright=CFrame.Angles(0,0,math.rad(90))
        elseif size.Z>size.Y and size.Z>size.X then
            upright=CFrame.Angles(math.rad(90),0,0)
        end
        local right,up,back=upright.RightVector,upright.UpVector,upright.LookVector
        local standingHeight=math.abs(right.Y)*size.X+math.abs(up.Y)*size.Y+math.abs(back.Y)*size.Z
        local centerHeight=standingHeight/2
        mesh.CFrame=CFrame.new(origin+Vector3.new(0,centerHeight,0))*upright
        mesh.Parent=model
        model.PrimaryPart=mesh
        -- Dark eyes are kept facing the target and attached to the head by
        -- the movement loop. Do not assume imported OBJ local forward axis.
        local eyeRadius=math.clamp(standingHeight*0.055,0.22,0.6)
        local eyes={}
        for side=-1,1,2 do
            local eye=Instance.new("Part")
            eye.Name="BlackEye"
            eye.Shape=Enum.PartType.Ball
            eye.Size=Vector3.new(eyeRadius*2,eyeRadius*2,eyeRadius*0.8)
            eye.Color=Color3.fromRGB(5,7,5)
            eye.Material=Enum.Material.SmoothPlastic
            eye.Anchored=true
            eye.CanCollide=false
            eye.CanTouch=false
            eye.CanQuery=false
            eye.Parent=model
            table.insert(eyes,{part=eye,side=side})
        end
        model:SetAttribute("MeshAlien",true)
        model:SetAttribute("MeshUprightX",size.X>size.Y and size.X>size.Z)
        model:SetAttribute("MeshUprightZ",size.Z>size.Y and size.Z>size.X)
        model:SetAttribute("MeshCenterHeight",centerHeight)
        model:SetAttribute("MeshFloorY",origin.Y)
        -- Imported OBJ visible geometry can be offset from its MeshPart pivot.
        -- Lower the imported alien relative to its collision bounds.
        model:SetAttribute("VisualGroundCorrection",math.min(standingHeight*0.36,3.0))
        alienAnimation[model]={phase=math.random()*6.28,mesh=true,upright=upright,centerHeight=centerHeight,eyes=eyes,standingHeight=standingHeight}
        model.Destroying:Connect(function() alienAnimation[model]=nil end)
        return model
    end
    local scale=kind=="boss" and 2.6 or kind=="crawler" and 0.83 or kind=="armored" and 1.42 or 1.22
    local color=kind=="boss" and Color3.fromRGB(175,48,85) or kind=="armored" and Color3.fromRGB(100,171,46) or Color3.fromRGB(147,223,67)
    local function body(name,size,offset,shape)
        local p=block(name,size*scale,CFrame.new(origin+offset*scale),color,Enum.Material.SmoothPlastic,model)
        p.CanCollide=false;p.CanTouch=false;p.Transparency=0
        if shape then p.Shape=shape end
        return p
    end
    -- Tall insectoid humanoid: rounded shell, narrow waist, oversized compound eyes,
    -- long jointed limbs, and a forward-leaning threatening silhouette.
    local torso=body("Tall insectoid thorax",Vector3.new(2.05,3.4,1.45),Vector3.new(0,4.45,0),Enum.PartType.Ball)
    model.PrimaryPart=torso
    local abdomen=body("Tapered abdomen",Vector3.new(1.45,2.5,1.2),Vector3.new(0,2.95,0.12),Enum.PartType.Ball)
    abdomen.Color=Color3.fromRGB(96,164,49)
    local neck=body("Long flexible neck",Vector3.new(0.66,1.2,0.75),Vector3.new(0,6.65,0))
    local head=body("Broad elongated alien head",Vector3.new(3.0,2.65,2.05),Vector3.new(0,8.0,-0.4),Enum.PartType.Ball)
    for _,side in ipairs({-1,1}) do
        local eye=body("Huge glossy compound eye",Vector3.new(1.15,1.65,0.46),Vector3.new(side*0.83,8.12,-1.28),Enum.PartType.Ball)
        eye.Color=Color3.fromRGB(16,27,18)
        eye.Reflectance=0.04
        eye.CFrame=eye.CFrame*CFrame.Angles(0,0,math.rad(side*14))
        local eyeGlint=body("Eye reflective speck",Vector3.new(0.18,0.26,0.07),Vector3.new(side*0.77,8.52,-1.55),Enum.PartType.Ball)
        eyeGlint.Color=Color3.fromRGB(112,142,110)
        local shoulder=body("Insectoid shoulder joint",Vector3.new(0.95,1.0,0.9),Vector3.new(side*1.1,5.6,0),Enum.PartType.Ball)
        local upper=body("Long slender forearm",Vector3.new(0.54,3.0,0.62),Vector3.new(side*1.5,4.2,-0.2),Enum.PartType.Ball)
        upper.CFrame=upper.CFrame*CFrame.Angles(0,0,math.rad(side*10))
        local hand=body("Three fingered hand",Vector3.new(0.63,1.0,0.65),Vector3.new(side*1.8,2.5,-0.35),Enum.PartType.Ball)
        for finger=1,3 do
            local claw=body("Curved finger claw",Vector3.new(0.15,0.8,0.16),Vector3.new(side*(1.58+finger*0.13),1.85,-0.55),Enum.PartType.Ball)
            claw.Color=Color3.fromRGB(61,105,35)
        end
        local thigh=body("Organic thigh",Vector3.new(0.82,2.35,0.82),Vector3.new(side*0.55,2.4,0.1),Enum.PartType.Ball)
        local shin=body("Lower leg",Vector3.new(0.59,2.0,0.63),Vector3.new(side*0.58,0.95,-0.3),Enum.PartType.Ball)
        body("Wide alien foot",Vector3.new(0.92,0.35,1.45),Vector3.new(side*0.58,0.2,-0.55),Enum.PartType.Ball)
    end
    local jaw=body("Small mandible ridge",Vector3.new(0.85,0.36,0.35),Vector3.new(0,6.95,-1.25),Enum.PartType.Ball)
    jaw.Color=Color3.fromRGB(72,137,39)
    if kind=="armored" or kind=="boss" then
        local armor=body("Heavy chitin chest plate",Vector3.new(2.25,2.8,1.5),Vector3.new(0,4.6,-0.1),Enum.PartType.Ball)
        armor.Color=Color3.fromRGB(65,118,36)
        for _,side in ipairs({-1,1}) do
            local spike=body("Shoulder carapace",Vector3.new(1.1,1.25,1.1),Vector3.new(side*1.3,5.55,0),Enum.PartType.Ball)
            spike.Color=Color3.fromRGB(55,103,34)
        end
    elseif kind=="crawler" then
        model:PivotTo(model:GetPivot()*CFrame.Angles(math.rad(65),0,0))
    end
    local joints={}
    for _,part in ipairs(model:GetChildren()) do
        if part:IsA("BasePart") and (part.Name=="Long slender forearm" or part.Name=="Organic thigh" or part.Name=="Lower leg" or part.Name=="Three fingered hand") then
            table.insert(joints,{part=part,relative=torso.CFrame:ToObjectSpace(part.CFrame),arm=part.Name=="Long slender forearm" or part.Name=="Three fingered hand",side=part.Position.X>torso.Position.X and 1 or -1})
        end
    end
    alienAnimation[model]={joints=joints,phase=math.random()*6.28}
    model.Destroying:Connect(function() alienAnimation[model]=nil end)
    return model
end
local wave=0
local function spawnWave(number)
    local count=math.min(110,math.ceil(7+number*4+math.max(0,number-1)^1.16))
    local spawned=0
    local bossWave=number%3==0
    for i=1,count do
        local kind="stalker"
        if bossWave then
            kind=i<=math.floor(count/2) and "armored" or "stalker"
        elseif number>=2 then
            local roll=math.random()
            if roll<math.min(0.30,0.10+number*0.018) then kind="crawler"
            elseif i==1 or roll<math.min(0.70,0.40+number*0.035) then kind="armored" end
        end
        for attempt=1,100 do
            local x=math.random(1,#map[1]-2)+0.5
            local y=math.random(1,#map-2)+0.5
            if free(x,y) and (math.abs(x-3.5)+math.abs(y-3.5)>9) then
                makeAlien(x,y,kind,number)
                spawned+=1
                break
            end
        end
    end
    if bossWave then
        for attempt=1,100 do
            local x=math.random(1,#map[1]-2)+0.5
            local y=math.random(1,#map-2)+0.5
            if free(x,y) and (math.abs(x-3.5)+math.abs(y-3.5)>12) then
                makeAlien(x,y,"boss",number)
                spawned+=1
                break
            end
        end
    end
    aliveValue.Value=spawned
end
-- A breach starts only after all aliens from the preceding wave are eliminated.
task.spawn(function()
    while root.Parent do
        if #enemies:GetChildren()==0 then
            breachIntermission=true
            alarm:Play()
            for remaining=7,1,-1 do
                timerValue.Value=remaining
                task.wait(1)
                if not root.Parent then return end
            end
            timerValue.Value=0
            wave+=1
            waveValue.Value=wave
            spawnWave(wave)
            breachIntermission=false
            alarm:Stop()
        else
            aliveValue.Value=#enemies:GetChildren()
            task.wait(0.4)
        end
    end
end)

local damageClock={}
local function alienShoot(alien,origin,target,hum)
    local direction=target-origin
    if direction.Magnitude<1 then return end
    local rayParams=RaycastParams.new()
    rayParams.FilterType=Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances={alien}
    local result=workspace:Raycast(origin,direction,rayParams)
    local hit=result and result.Position or target
    local beam=Instance.new("Part")
    beam.Name="Alien projectile tracer"
    beam.Anchored=true;beam.CanCollide=false;beam.CanTouch=false;beam.CanQuery=false
    beam.Material=Enum.Material.SmoothPlastic
    beam.Color=Color3.fromRGB(135,170,86)
    beam.Transparency=0.22
    beam.Size=Vector3.new(0.17,0.17,(hit-origin).Magnitude)
    beam.CFrame=CFrame.lookAt((origin+hit)/2,hit)
    beam.Parent=root
    game:GetService("Debris"):AddItem(beam,0.15)
    if result and hum and result.Instance:IsDescendantOf(hum.Parent) and Players:GetPlayerFromCharacter(hum.Parent) and Players:GetPlayerFromCharacter(hum.Parent):GetAttribute("AlienBreachDeployed") then
        hum:TakeDamage(alien:GetAttribute("Kind")=="boss" and 22 or alien:GetAttribute("Kind")=="armored" and 13 or 8)
    end
end
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
            if player:GetAttribute("AlienBreachDeployed") and hrp and hum and hum.Health>0 then fields[player]=buildField(hrp) else fields[player]=nil end
        end
    end
    for _,alien in ipairs(enemies:GetChildren()) do
        local part=alien.PrimaryPart
        if not part then continue end
        local ax,ay=gridOf(part.Position)
        local bestPlayer,bestDistance,bestField=nil,math.huge,nil
        for _,player in ipairs(Players:GetPlayers()) do
            local field=player:GetAttribute("AlienBreachDeployed") and fields[player]
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
                -- Trace to actual walkable ground, ignoring the alien itself.
                local groundParams=RaycastParams.new()
                groundParams.FilterType=Enum.RaycastFilterType.Exclude
                groundParams.FilterDescendantsInstances={alien, bestPlayer.Character,root}
                local groundHit=workspace:Raycast(
                    Vector3.new(part.Position.X,60,part.Position.Z),
                    Vector3.new(0,-90,0),groundParams)
                local groundY=groundHit and groundHit.Position.Y or 0
                                local playerDistance=(hrp.Position-part.Position).Magnitude
                -- Ranged aliens hold position once they reach firing distance.
                if delta.Magnitude>0.12 and playerDistance>27 then
                    local step=delta.Unit*math.min((alien:GetAttribute("Speed") or 10)*dt,delta.Magnitude)
                    local current=alien:GetPivot()
                    local facing=CFrame.lookAt(current.Position+step,current.Position+step+Vector3.new(step.X,0,step.Z))
                    if alien:GetAttribute("MeshAlien") then
                        local anim=alienAnimation[alien]
                        local base=anim and anim.upright or CFrame.identity
                        local floorY=groundY
                        local centerY=(alien:GetAttribute("MeshCenterHeight") or 0)-(alien:GetAttribute("VisualGroundCorrection") or 0)
                        facing=CFrame.new(current.Position.X+step.X,floorY+centerY,current.Position.Z+step.Z)*facing.Rotation*base
                    end
                    alien:PivotTo(facing)
                end
                local animation=alienAnimation[alien]
                if animation and animation.mesh then
                    -- Correct ground height even while stationary.
                    local current=alien:GetPivot()
                    local desiredY=groundY+(animation.centerHeight or 0)-(alien:GetAttribute("VisualGroundCorrection") or 0)
                    if math.abs(current.Position.Y-desiredY)>0.01 then
                        alien:PivotTo(CFrame.new(current.Position.X,desiredY,current.Position.Z)*current.Rotation)
                    end
                    -- Position black eyes on the visible front of the head,
                    -- looking toward the player rather than OBJ's arbitrary axes.
                    local body=alien.PrimaryPart
                    local look=Vector3.new(hrp.Position.X-body.Position.X,0,hrp.Position.Z-body.Position.Z)
                    if look.Magnitude>0.1 then
                        local forward=look.Unit
                        local right=Vector3.new(-forward.Z,0,forward.X)
                        local h=animation.standingHeight or body.Size.Y
                        local eyeHeight=body.Position.Y+h*0.37
                        local spread=h*0.09
                        local depth=math.min(body.Size.X,body.Size.Z)*0.34
                        for _,eyeInfo in ipairs(animation.eyes or {}) do
                            eyeInfo.part.CFrame=CFrame.new(
                                Vector3.new(body.Position.X,eyeHeight,body.Position.Z)
                                +right*(eyeInfo.side*spread)+forward*depth)
                        end
                    end
                end
                if animation then
                    animation.phase+=dt*(alien:GetAttribute("Kind")=="crawler" and 14 or 8)
                    for _,joint in ipairs(animation.joints or {}) do
                        if joint.part.Parent then
                            local swing=math.sin(animation.phase+ (joint.side==1 and math.pi or 0))*0.34
                            if joint.arm then swing=-swing end
                            joint.part.CFrame=part.CFrame*joint.relative*CFrame.Angles(swing,0,0)
                        end
                    end
                end
                if playerDistance<=75 and os.clock()-(damageClock[alien] or 0)>1.8 then
                    damageClock[alien]=os.clock()
                    local hum=bestPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health>0 then
                        local muzzle=part.Position+Vector3.new(0,1.0,0)
                        local aim=hrp.Position+Vector3.new(0,1.2,0)
                        alienShoot(alien,muzzle,aim,hum)
                    end
                end
            end
        end
    end
end)
