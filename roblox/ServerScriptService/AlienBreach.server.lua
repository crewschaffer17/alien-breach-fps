-- Alien Breach FPS - Roblox conversion, phase 1
-- Put in ServerScriptService as a Script. Generated from the original GitHub map.
-- Source: index.html; does not modify the browser game.
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local RunService = game:GetService("RunService")
-- Set baseline illumination before generating any map geometry.
-- This removes startup darkness even while fixtures are still being built.
Lighting.ClockTime=14
Lighting.Brightness=3
Lighting.ExposureCompensation=0.2
Lighting.GlobalShadows=false
Lighting.Ambient=Color3.fromRGB(165,176,185)
Lighting.OutdoorAmbient=Color3.fromRGB(140,153,165)
Lighting.FogEnd=900
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
local WIDTH,HEIGHT=260,45
local NEST_START=180
local REACTOR_START=119
local RESEARCH_START=66
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
-- Research Lab: a second, physically isolated 49x40-tile facility.
-- Its own floorplan, architecture and materials are deliberately unrelated
-- to the original containment facility. No hallway joins the two maps.
carve(68,4,111,7)   -- northern observation concourse
carve(68,9,78,20)  -- west clean rooms
carve(81,9,98,20)  -- central specimen hall
carve(101,9,111,20) -- east quarantine
carve(68,22,111,25) -- main cross-corridor
carve(68,27,83,40) -- broken diagnostics
carve(86,27,99,40) -- surgical labs
carve(102,27,111,40) -- decontamination
carve(72,7,75,10)
carve(88,7,92,10)
carve(105,7,108,10)
carve(73,19,76,23)
carve(89,19,93,23)
carve(105,19,108,23)
carve(73,24,76,28)
carve(89,24,93,28)
carve(105,24,108,28)
for _,x in ipairs({73,91,106}) do
 for y=10,19 do if y~=14 and y~=15 then cells[y][x]="1" end end
end
for _,x in ipairs({76,92,106}) do
 for y=28,39 do if y~=33 and y~=34 then cells[y][x]="1" end end
end
-- Reactor Core: connected perimeter hallways, enclosed utility rooms,
-- and one vast central chamber. Walls are real map collision geometry.
carve(120,4,171,7)     -- north corridor
carve(120,38,171,41)   -- south corridor
carve(120,7,123,38)    -- west corridor
carve(168,7,171,38)   -- east corridor
carve(143,7,148,38)   -- central north-south hallway
carve(123,20,168,24)  -- central east-west hallway
-- Four large, separate equipment rooms, each connected to a hallway.
carve(126,10,139,17)  -- north-west turbine room
carve(152,10,165,17)  -- north-east control room
carve(126,28,139,35)  -- south-west coolant room
carve(152,28,165,35)  -- south-east generator room
-- Doorways between the outer ring and each equipment room.
carve(128,7,131,10)
carve(159,7,162,10)
carve(128,35,131,38)
carve(159,35,162,38)
-- Doors leading from equipment rooms toward the central corridors.
carve(137,16,143,18)
carve(148,16,154,18)
carve(137,25,143,29)
carve(148,25,154,29)
-- THE OMEGA VAULT: one huge uninterrupted central room with four entrances.
carve(132,17,159,27)
carve(138,14,153,30)
-- Reinstate solid partitions between machinery rooms and outer corridors,
-- leaving only the intentional four-tile door openings.
for x=125,140 do
 if x<128 or x>131 then cells[9][x]="1" end
 if x<128 or x>131 then cells[36][x]="1" end
end
for x=151,166 do
 if x<159 or x>162 then cells[9][x]="1" end
 if x<159 or x>162 then cells[36][x]="1" end
end
-- Distinct service closets and side passages, not one continuous empty floor.
carve(125,18,130,19)
carve(161,18,166,19)
carve(125,26,130,27)
carve(161,26,166,27)
-- Expanded reactor service wings: additional rooms and looped hallways
-- inside the sector's existing reserved footprint, away from other maps.
carve(125,8,139,8)      -- north-west service gallery
carve(152,8,166,8)      -- north-east service gallery
carve(125,37,139,37)    -- south-west service gallery
carve(152,37,166,37)    -- south-east service gallery
carve(125,10,125,17)    -- west utility passage
carve(166,10,166,17)    -- east utility passage
carve(125,28,125,35)    -- lower west utility passage
carve(166,28,166,35)    -- lower east utility passage
carve(126,18,130,19)    -- west diagnostics annex
carve(161,18,166,19)    -- east diagnostics annex
carve(126,26,130,27)    -- west pump annex
carve(161,26,166,27)    -- east pump annex
-- Alien Nest: a continuous, winding subterranean burrow, not rectangular rooms.
-- 78x38 tile footprint: 1.5x Reactor's length, with three secluded queen dens.
local function burrow(cx,cy,rx,ry)
 for yy=math.max(3,math.floor(cy-ry)),math.min(42,math.ceil(cy+ry)) do
  for xx=math.max(181,math.floor(cx-rx)),math.min(257,math.ceil(cx+rx)) do
   local dx=(xx-cx)/rx
   local dy=(yy-cy)/ry
   local wobble=.09*math.sin(xx*.59+yy*.27)+.06*math.cos(xx*.31-yy*.62)
   if dx*dx+dy*dy<=1+wobble then cells[yy][xx]="0" end
  end
 end
end
local function tunnel(x1,y1,x2,y2,radius)
 local steps=math.max(math.abs(x2-x1),math.abs(y2-y1))*2
 for i=0,steps do
  local t=i/steps
  local x=x1+(x2-x1)*t+math.sin(t*math.pi*2)*1.4
  local y=y1+(y2-y1)*t+math.sin(t*math.pi*3)*1.1
  burrow(x,y,radius,radius*.78)
 end
end
-- Main winding spine and branching return loops.
for _,v in ipairs({
 {185,7,195,14,3.4},{195,14,208,9,3.2},{208,9,219,7,3.4},
 {219,7,231,14,3.4},{231,14,245,12,3.5},{245,12,253,21,3.4},
 {253,21,243,31,3.5},{243,31,228,36,3.3},{228,36,216,34,3.4},
 {216,34,202,35,3.4},{202,35,187,29,3.3},{187,29,185,7,3.3},
 {195,14,208,23,3.2},{208,23,218,22,3.6},{218,22,231,24,3.5},
 {231,24,243,31,3.3},{208,23,202,35,3.0},{218,22,216,34,3.2},
 {231,14,231,24,3.2},{195,14,187,29,3.1}
}) do tunnel(v[1],v[2],v[3],v[4],v[5]) end
-- Irregular incubation caverns, fungal groves and the three queen dens.
for _,v in ipairs({
 {195,14,8.2,6.5},{218,22,10.3,8.3},{243,31,8.6,7},
 {207,9,6.5,5.1},{234,12,6.2,5.2},{188,29,6.3,5.5},
 {202,35,7.4,5.0},{228,36,7.2,4.8},{252,21,5.2,7.0},
 {219,7,6.3,4.1}
}) do burrow(v[1],v[2],v[3],v[4]) end
-- Dedicated, safely walkable entry pocket.
burrow(219,6,5,3)
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
Lighting.Brightness=3
Lighting.ExposureCompensation=0.2
Lighting.GlobalShadows=false
Lighting.Ambient=Color3.fromRGB(165,176,185)
Lighting.OutdoorAmbient=Color3.fromRGB(140,153,165)
Lighting.FogEnd=900
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
local versionTag=Instance.new("StringValue")
versionTag.Name="NEST_MAP_BUILD_2026_11_18_V2"
versionTag.Value="Winding burrows / grass floor / rooted wall sacs"
versionTag.Parent=root
print("[Alien Breach] NEST_MAP_BUILD_2026_11_18_V2 loaded")
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
    if x>=REACTOR_START then return x>=132 and x<=159 and y>=14 and y<=30 end
    if x>=RESEARCH_START then return x>=81 and x<=99 and y>=9 and y<=20 end
    return (x>=38 and x<=53 and y>=3 and y<=10)
        or (x>=38 and x<=53 and y>=15 and y<=24)
        or (x>=19 and x<=33 and y>=35 and y<=41)
end
local function free(x,y)
    local row = map[math.floor(y)+1]
    return row ~= nil and row:sub(math.floor(x)+1,math.floor(x)+1) == "0"
end
-- Expanded 57x45 facility, retaining the original 35x27 section. Runs of walls are combined for performance.
-- Leave a true opening under the Omega chamber; a separate lower
-- collision floor and four physical stairways are built below.
local OMEGA_X1,OMEGA_X2,OMEGA_Y1,OMEGA_Y2=132,159,14,30
local OMEGA_DROP=8
local function foundationRect(x1,x2,y1,y2)
 block("Industrial foundation",Vector3.new((x2-x1+1)*TILE,1,(y2-y1+1)*TILE),
  CFrame.new(pos((x1+x2-1)/2,(y1+y2-1)/2,-.5)),metal)
end
foundationRect(1,NEST_START-1,1,OMEGA_Y1-1)
foundationRect(1,NEST_START-1,OMEGA_Y2+1,HEIGHT)
foundationRect(1,OMEGA_X1-1,OMEGA_Y1,OMEGA_Y2)
foundationRect(OMEGA_X2+1,NEST_START-1,OMEGA_Y1,OMEGA_Y2)
-- One single, collidable grassy hive floor instead of thousands of tiles.
local nestGround=block("ALIEN NEST continuous overgrown floor",
 Vector3.new((WIDTH-NEST_START+1)*TILE,1,HEIGHT*TILE),
 CFrame.new(pos((NEST_START+WIDTH-1)/2,(HEIGHT-1)/2,.65)),
 Color3.fromRGB(49,91,43),Enum.Material.Grass)
nestGround.CastShadow=false
-- Grass top is at Y=1.15, safely above any default Studio Baseplate
-- or old industrial foundation at Y=0, preventing coplanar z-fighting.
block("Omega lowered collision floor",Vector3.new((OMEGA_X2-OMEGA_X1+1)*TILE,1,(OMEGA_Y2-OMEGA_Y1+1)*TILE),CFrame.new(pos((OMEGA_X1+OMEGA_X2-1)/2,(OMEGA_Y1+OMEGA_Y2-1)/2,-OMEGA_DROP-.5)),metal)

for y,row in ipairs(map) do
    local x=1
    while x<=#row do
        if row:sub(x,x)=="1" then
            local first=x
            while x<=#row and row:sub(x,x)=="1" do x+=1 end
            local count=x-first
            block("Lab wall",Vector3.new(count*TILE,WALL_HEIGHT,TILE),
                CFrame.new(pos(first-1+count/2,y-0.5,WALL_HEIGHT/2)),
                 first>=NEST_START and Color3.fromRGB(29,55,32) or first>=REACTOR_START and Color3.fromRGB(55,68,81) or first>=RESEARCH_START and Color3.fromRGB(22,39,53) or wallColor)
        else x+=1 end
    end
end
-- Continuous structural walls: every walkable high-ceiling tile has
-- a full-height boundary wherever it touches solid geometry.
-- This includes the outside edge of Omega, previously missed by the old loop.
for y=1,HEIGHT do
 for x=1,WIDTH do
  if map[y]:sub(x,x)=="1" then
   local needed=18
   local warm=false
   for _,d in ipairs({{1,0},{-1,0},{0,1},{0,-1}}) do
    local nx,ny=x+d[1],y+d[2]
    if nx>=1 and nx<=WIDTH and ny>=1 and ny<=HEIGHT
      and map[ny]:sub(nx,nx)=="0" then
     if nx>=132 and nx<=159 and ny>=14 and ny<=30 then
      needed=66;warm=true
     elseif tallRoom(nx,ny) then
      needed=math.max(needed,34)
     end
    end
   end
   if needed>WALL_HEIGHT then
    local lower=warm and OMEGA_DROP or 0
    block("Full-height sealed ceiling wall",Vector3.new(TILE,needed-WALL_HEIGHT+lower,TILE),
     CFrame.new(pos(x-.5,y-.5,(needed+WALL_HEIGHT-lower)/2)),
     warm and Color3.fromRGB(108,58,38) or Color3.fromRGB(61,77,88))
   end
  end
 end
end
-- Eight solid, collidable treads per flight, with visible amber nosings.
-- Descend from the four chamber approaches into the 8-stud sunken floor.
local function stairFlight(startX,startY,dx,dy)
 for i=1,8 do
  local x=startX+dx*(i-1)
  local y=startY+dy*(i-1)
  local top=-i
  local step=block("Omega walkable stair "..i,
   Vector3.new(dx~=0 and TILE or TILE*3,1,dy~=0 and TILE or TILE*3),
   CFrame.new(pos(x-.5,y-.5,top-.5)),
   Color3.fromRGB(113,69,45),Enum.Material.DiamondPlate)
  step.CanCollide=true
  local stripe=block("Omega stair tread amber marker",
   Vector3.new(dx~=0 and .6 or TILE*2.7,.08,dy~=0 and .6 or TILE*2.7),
   CFrame.new(pos(x-.5,y-.5,top+.06)),Color3.fromRGB(255,174,57),Enum.Material.Neon)
  stripe.CanCollide=false;stripe.CanQuery=false
 end
end
stairFlight(145,14,0,1)
stairFlight(145,30,0,-1)
stairFlight(132,22,1,0)
stairFlight(159,22,-1,0)
-- Seal every HIGH-TO-LOW ceiling transition. These boundaries are
-- WALKABLE on both sides, so solid-tile perimeter checks miss them.
-- Only fill ABOVE the 18-stud doorway height; passages stay open.
for y=1,HEIGHT do
 for x=1,WIDTH do
  if map[y]:sub(x,x)=="0" and tallRoom(x,y) then
   local ceilingHeight=x>=REACTOR_START and 66 or 34
   for _,d in ipairs({{1,0},{0,1},{-1,0},{0,-1}}) do
    local nx,ny=x+d[1],y+d[2]
    if nx>=1 and nx<=WIDTH and ny>=1 and ny<=HEIGHT
      and map[ny]:sub(nx,nx)=="0" and not tallRoom(nx,ny) then
     local center=pos(x-.5+d[1]*.5,y-.5+d[2]*.5,(ceilingHeight+WALL_HEIGHT)/2)
     local size=d[1]~=0
      and Vector3.new(.9,ceilingHeight-WALL_HEIGHT,TILE+.2)
      or Vector3.new(TILE+.2,ceilingHeight-WALL_HEIGHT,.9)
     local seal=block("SEALED HIGH-CEILING UPPER BULKHEAD",size,
      CFrame.new(center),
      x>=REACTOR_START and Color3.fromRGB(107,52,35) or Color3.fromRGB(61,77,88))
     seal.CastShadow=false
    end
   end
  end
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
        if row:sub(x,x)=="0" and x<RESEARCH_START and x%4==0 and y%4==0 then
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
        if row:sub(x,x)=="0" and x<RESEARCH_START then
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
            local h=high and (first>=REACTOR_START and 66 or 34) or WALL_HEIGHT
            local ceiling=block(high and "High laboratory ceiling" or "Corridor ceiling",
                Vector3.new(count*TILE,0.5,TILE),
                CFrame.new(pos(first-1+count/2,y-0.5,h+0.4)),first>=REACTOR_START and Color3.fromRGB(34,24,24) or first>=RESEARCH_START and Color3.fromRGB(14,27,41) or Color3.fromRGB(49,61,68))
            ceiling.CanCollide=false
        else x+=1 end
    end
end
for y,row in ipairs(map) do
    for x=1,#row do
        if row:sub(x,x)=="0" and x<RESEARCH_START and tallRoom(x,y) then
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
-- Keep both facilities fully illuminated from the first frame.
-- Do not periodically dim global Lighting or the white fixtures.
task.spawn(function()
    while root.Parent do
        Lighting.Brightness=3
        Lighting.ExposureCompensation=0.2
        for _,fixture in ipairs(lightingFixtures) do
            fixture.light.Brightness=1.0
            fixture.part.Color=Color3.fromRGB(193,245,236)
        end
        local now=os.clock()
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
-- Research Lab uses the exact same chest rewards, quantity and rotation.
local researchChestPoints={}
local reactorChestPoints={}
local nestChestPoints={}
for y=5,40,3 do for x=182,256,3 do
 if map[y] and map[y]:sub(x,x)=="0" then table.insert(nestChestPoints,{x-.5,y-.5}) end
end end
for y=4,40,3 do
 for x=123,169,3 do
  if map[y] and map[y]:sub(x,x)=="0" then table.insert(reactorChestPoints,{x-0.5,y-0.5}) end
 end
end
for y=4,40,3 do
    for x=69,110,3 do
        if map[y] and map[y]:sub(x,x)=="0" then
            table.insert(researchChestPoints,{x-0.5,y-0.5})
        end
    end
end
-- Wave selection must exist even though caches now rotate independently.
-- Without this function the wave coroutine errors before creating any aliens.
local function activeChestSector()
 local counts={containment=0,research=0,reactor=0,nest=0}
 for _,player in ipairs(Players:GetPlayers()) do
  if player:GetAttribute("AlienBreachDeployed") then
   local hum=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
   if hum and hum.Health>0 then
    local sector=player:GetAttribute("AlienBreachSelectedMap") or "containment"
    counts[sector]=(counts[sector] or 0)+1
   end
  end
 end
 local selected="containment"
 for _,sector in ipairs({"research","reactor","nest"}) do
  if counts[sector]>counts[selected] then selected=sector end
 end
 return selected
end
local activeChests=Instance.new("Folder")
activeChests.Name="SupplyCaches"
activeChests.Parent=root
local function newChest(x,y,index,sector)
    local base=pos(x,y,0)
    local model=Instance.new("Model")
    model.Name=sector.." armored supply cache "..index
    model:SetAttribute("Sector",sector)
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
-- Independent supply rotation in EACH sector: twelve caches per map,
-- ninety-second refresh, identical loot odds and rewards everywhere.
local function rotateChests()
 activeChests:ClearAllChildren()
 for _,entry in ipairs({
  {sector="containment",points=chestPoints},
  {sector="research",points=researchChestPoints},
  {sector="reactor",points=reactorChestPoints},
  {sector="nest",points=nestChestPoints}
 }) do
  local shuffled=table.clone(entry.points)
  for i=#shuffled,2,-1 do
   local j=math.random(1,i)
   shuffled[i],shuffled[j]=shuffled[j],shuffled[i]
  end
  local count=0
  for _,p in ipairs(shuffled) do
   if free(p[1],p[2]) then
    count+=1
    newChest(p[1],p[2],count,entry.sector)
    if count>=12 then break end
   end
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
 local sector=alien:GetAttribute("SectorEnemy")
 if sector and player:GetAttribute("AlienBreachSelectedMap")~=sector then return end
 local hp=(alien:GetAttribute("HP") or 50)-amount*25
 alien:SetAttribute("HP",hp)
 if hp<=0 then
  local defeatedKind=alien:GetAttribute("Kind")
  alien:Destroy()
  local rewardEvent=ReplicatedStorage:FindFirstChild("AlienBreachProgressionKill")
  if rewardEvent then rewardEvent:Fire(player,defeatedKind) end
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
 local level=math.clamp(tonumber(player:GetAttribute("ABWeaponLevel_"..id)) or 3,1,5)
 local damageScale=({0.55,0.78,1,1.3,1.65})[level]
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
   hurtAlien(player,alien,(alien:GetAttribute("Kind")=="boss" and 5 or alien:GetAttribute("Kind")=="armored" and 2 or 100)*damageScale)
  else
   hurtAlien(player,alien,w.damage*count*damageScale)
  end
 end
 if id=="plasma" then
  for target in pairs(hits) do
   local center=target.PrimaryPart
   if center then
    for _,alien in ipairs(enemies:GetChildren()) do
     if alien~=target and alien.PrimaryPart and (alien.PrimaryPart.Position-center.Position).Magnitude<1.8*TILE then hurtAlien(player,alien,1.8*damageScale) end
    end
   end
  end
 elseif id=="obliterator" then
  for _,alien in ipairs(enemies:GetChildren()) do
   if not hits[alien] and alien.PrimaryPart then
    local delta=alien.PrimaryPart.Position-origin
    if delta.Magnitude<maxDist and delta.Magnitude>0 and direction:Dot(delta.Unit)>math.cos(.075) then
     local r=workspace:Raycast(origin,delta,params)
     if r and r.Instance:IsDescendantOf(alien) then hurtAlien(player,alien,6*damageScale) end
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
    model:SetAttribute("Speed",kind=="boss" and 7 or kind=="crawler" and 15 or kind=="armored" and 7.5 or 10.5)
    model:SetAttribute("HP",kind=="boss" and (650+wave*65) or kind=="armored" and 100 or 50)
    model.Parent=enemies
    local origin=pos(x,y,0)
    -- Optional professionally rigged models: ServerStorage/AlienModels/
    -- Stalker, Armored, Crawler. Each model needs a PrimaryPart (prefer
    -- HumanoidRootPart), Motor6D joints and an AnimationController/Animator.
    -- AnimationId attributes WalkAnimationId, AttackAnimationId, IdleAnimationId
    -- can be set on each template to use animations owned by this experience.
    -- No external assets or unverified IDs are injected into the game.
    if kind~="boss" then
        local library=game:GetService("ServerStorage"):FindFirstChild("AlienModels")
        local template=library and library:FindFirstChild(
            kind=="armored" and "Armored" or kind=="crawler" and "Crawler" or "Stalker")
        if template and template:IsA("Model") then
            local rig=template:Clone()
            local rigRoot=rig.PrimaryPart or rig:FindFirstChild("HumanoidRootPart",true)
            if rigRoot and rigRoot:IsA("BasePart") then
                for _,p in ipairs(rig:GetDescendants()) do
                    if p:IsA("BasePart") then
                        p.CanCollide=false;p.CanTouch=false
                        p.Anchored=(p==rigRoot)
                        p.CastShadow=(p==rigRoot)
                    end
                end
                rig.PrimaryPart=rigRoot
                rig:PivotTo(CFrame.new(origin+Vector3.new(0,3,0)))
                rig.Name="AnimatedAlienRig"
                rig.Parent=model
                model.PrimaryPart=rigRoot
                local controller=rig:FindFirstChildOfClass("AnimationController")
                if not controller then
                    controller=Instance.new("AnimationController")
                    controller.Parent=rig
                end
                local animator=controller:FindFirstChildOfClass("Animator")
                if not animator then
                    animator=Instance.new("Animator")
                    animator.Parent=controller
                end
                local tracks={}
                for _,name in ipairs({"Idle","Walk","Attack"}) do
                    local id=template:GetAttribute(name.."AnimationId")
                    if typeof(id)=="string" and id:match("^rbxassetid://%d+$") then
                        local animation=Instance.new("Animation")
                        animation.Name=name.."Animation"
                        animation.AnimationId=id
                        animation.Parent=rig
                        local ok,track=pcall(function() return animator:LoadAnimation(animation) end)
                        if ok and track then
                            track.Priority=name=="Attack" and Enum.AnimationPriority.Action
                                or name=="Walk" and Enum.AnimationPriority.Movement
                                or Enum.AnimationPriority.Idle
                            track.Looped=name~="Attack"
                            tracks[string.lower(name)]=track
                        end
                    end
                end
                -- Built-in procedural gait works immediately with the supplied
                -- Motor6D models, without uploaded Roblox animation IDs.
                local motors={}
                for _,joint in ipairs(rig:GetDescendants()) do
                    if joint:IsA("Motor6D") then
                        local n=joint.Name
                        if n:find("UpperArm") or n:find("Thigh")
                          or n:find("UpperLeg") or n:find("LowerLeg")
                          or n:find("Forearm") or n:find("Head") then
                            table.insert(motors,{motor=joint,name=n})
                        end
                    end
                end
                if tracks.idle then tracks.idle:Play(.2) end
                alienAnimation[model]={rig=true,tracks=tracks,motors=motors,phase=0,animationState="idle",lastAttack=0,kind=kind}
                model.Destroying:Connect(function()
                    alienAnimation[model]=nil
                    for _,track in pairs(tracks) do track:Stop(0) end
                end)
                return model
            end
            rig:Destroy()
            warn("[Alien Breach] AlienModels/"..template.Name.." needs a PrimaryPart")
        end
    end
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
        mesh.Color=kind=="boss" and Color3.fromRGB(164,48,86) or kind=="armored" and Color3.fromRGB(57,100,48) or Color3.fromRGB(76,126,61)
        mesh.Size=meshTemplate.Size*(kind=="boss" and 2.45 or kind=="crawler" and 0.85 or kind=="armored" and 1.3 or 1.1)
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
    local scale=kind=="boss" and 2.2 or kind=="crawler" and 0.83 or kind=="armored" and 1.42 or 1.22
    local color=kind=="boss" and Color3.fromRGB(180,50,85) or kind=="armored" and Color3.fromRGB(100,171,46) or Color3.fromRGB(147,223,67)
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
local sectorWaves={containment=0,research=0,reactor=0,nest=0}
local lastWaveSector=nil
local nestQueenSpot=({{195,14},{218,22},{243,31}})[math.random(1,3)]
-- Choose a nearby OPEN tile with unobstructed map-grid sight from deployment.
-- Bosses never spawn in a disconnected room or outside their own sector.
local bossEntry={containment={4,4},research={89,15},reactor={145,7},nest={219,6}}
local function bossVisibleTile(sector)
    local origin=bossEntry[sector] or bossEntry.containment
    local ox,oy=origin[1],origin[2]
    local bestX,bestY,bestScore=nil,nil,-math.huge
    for radius=5,11 do
        for dy=-radius,radius do
            for dx=-radius,radius do
                local distance=math.sqrt(dx*dx+dy*dy)
                if distance>=radius-.7 and distance<=radius+.7 then
                    local tx,ty=ox+dx,oy+dy
                    if free(tx-.5,ty-.5) then
                        local clear=true
                        local steps=math.max(2,math.ceil(distance*4))
                        for s=1,steps do
                            local t=s/steps
                            if not free(ox-.5+dx*t,oy-.5+dy*t) then clear=false;break end
                        end
                        if clear then
                            local score=distance-(math.abs(dy)*.08)
                            if score>bestScore then bestX,bestY,bestScore=tx,ty,score end
                        end
                    end
                end
            end
        end
    end
    if bestX then return bestX,bestY end
    -- Safe fallback directly in the entry pocket.
    for radius=0,4 do
        for dy=-radius,radius do
            for dx=-radius,radius do
                if free(ox+dx-.5,oy+dy-.5) then return ox+dx,oy+dy end
            end
        end
    end
    return ox,oy
end
local function spawnWave(number,selectedSector)
    -- ONE shared spawn-count curve for Containment, Research Lab and Reactor Core.
    -- Wave 1 is exactly 9 normal aliens; later waves follow Reactor Core's
    -- existing 15%-reduced scaling. Bosses are added separately on waves 3,6,...
    local count
    if number==1 then
        count=9
    else
        count=math.max(1,math.floor(math.min(110,math.ceil(7+number*4+math.max(0,number-1)^1.16))*0.85+0.5))
    end
    local spawned=0
    local bossWave=number%3==0
    local minX,maxX=2,55
    local minY,maxY=3,43
    if selectedSector=="research" then minX,maxX=68,111;maxY=41
    elseif selectedSector=="reactor" then minX,maxX=122,170;maxY=41
    elseif selectedSector=="nest" then minX,maxX=182,256;maxY=40 end
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
            local x=math.random(minX,maxX)+0.5
            local y=math.random(minY,maxY)+0.5
            if free(x,y) and (math.abs(x-3.5)+math.abs(y-3.5)>9) then
                local alien=makeAlien(x,y,kind,number)
                if selectedSector=="nest" then
                    alien:SetAttribute("HiveSpawn",true)
                    for _,piece in ipairs(alien:GetDescendants()) do
                        if piece:IsA("BasePart") then piece.Color=Color3.fromRGB(132,65,195) end
                    end
                end
                if selectedSector~="containment" then alien:SetAttribute("SectorEnemy",selectedSector) end
                spawned+=1
                break
            end
        end
    end
    if bossWave and selectedSector~="nest" then
        local bx,by=bossVisibleTile(selectedSector)
        local boss=makeAlien(bx-.5,by-.5,"boss",number)
        boss.Name="BREACH OVERLORD"
        boss:SetAttribute("SectorEnemy",selectedSector)
        boss:SetAttribute("BossWave",number)
        spawned+=1
        print("[Alien Breach] "..selectedSector.." boss spawned on wave "..number.." at "..bx..","..by)
    end
    -- Queen returns to her regular boss waves (3, 6, 9...).
    if selectedSector=="nest" and bossWave then
        local bx,by=bossVisibleTile("nest")
        local queenTile={bx,by}
        local q=makeAlien(queenTile[1]-.5,queenTile[2]-.5,"boss",number)
        q.Name="THE HIVE QUEEN"
        q:SetAttribute("SectorEnemy","nest")
        q:SetAttribute("HiveQueen",true)
        print("[Alien Nest] HIVE QUEEN spawned for wave "..number.." at tile "..queenTile[1]..","..queenTile[2])
        q:SetAttribute("HP",1800+number*180)
        q:SetAttribute("Speed",6.5)
        -- Eight-legged spider anatomy attached to the moving enemy model.
        local pivot=q.PrimaryPart
        if pivot then
            for _,piece in ipairs(q:GetDescendants()) do
                if piece:IsA("BasePart") then piece.Transparency=1 end
            end
            local function anatomy(name,size,cf,color,shape)
                local p=Instance.new("Part")
                p.Name=name;p.Size=size;p.Shape=shape or Enum.PartType.Block
                p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CastShadow=false
                p.Material=Enum.Material.SmoothPlastic;p.Color=color
                p.CFrame=pivot.CFrame*cf;p.Parent=q
                return p
            end
            local shell=Color3.fromRGB(65,32,84)
            anatomy("QUEEN ARMORED ABDOMEN",Vector3.new(12,7,14),CFrame.new(0,3,3),shell,Enum.PartType.Ball)
            anatomy("QUEEN CEPHALOTHORAX",Vector3.new(9,6,9),CFrame.new(0,4,-4),Color3.fromRGB(115,53,142),Enum.PartType.Ball)
            anatomy("QUEEN PLASMA SAC",Vector3.new(6,4,7),CFrame.new(0,4,7),Color3.fromRGB(171,59,232),Enum.PartType.Ball).Material=Enum.Material.Neon
            for side=-1,1,2 do
                for leg=1,4 do
                    local z=-8+(leg-1)*4.8
                    local hip=Vector3.new(side*3.5,4,z)
                    local knee=Vector3.new(side*(10+leg*.6),7,z+(leg-2.5)*2)
                    local foot=Vector3.new(side*(14+leg*.7),-2,z+(leg-2.5)*3.5)
                    for _,pair in ipairs({{hip,knee},{knee,foot}}) do
                        local d=pair[2]-pair[1]
                        anatomy("Queen articulated spider leg",Vector3.new(1.5,1.5,d.Magnitude),
                            CFrame.lookAt((pair[1]+pair[2])/2,pair[2]),shell)
                    end
                end
                for eye=1,3 do
                    anatomy("Queen glowing eye",Vector3.new(1.3,1.3,1.3),
                        CFrame.new(side*(1.1+eye*.8),5.3,-8),Color3.fromRGB(180,255,80),Enum.PartType.Ball).Material=Enum.Material.Neon
                end
            end
        end
        spawned+=1
    end
    aliveValue.Value=spawned
end
-- Remove enemies abandoned in a sector. Otherwise they keep the global wave
-- blocked when the last player leaves Research Lab for Containment (or vice versa).
local function clearEmptySectors()
 local occupied={containment=false,research=false,reactor=false,nest=false}
 for _,player in ipairs(Players:GetPlayers()) do
  if player:GetAttribute("AlienBreachDeployed") then
   local character=player.Character
   local hum=character and character:FindFirstChildOfClass("Humanoid")
   if hum and hum.Health>0 then
    local sector=player:GetAttribute("AlienBreachSelectedMap") or "containment"
    occupied[sector]=true
   end
  end
 end
 for _,alien in ipairs(enemies:GetChildren()) do
  local sector=alien:GetAttribute("SectorEnemy") or "containment"
  if not occupied[sector] then alien:Destroy() end
 end
 return occupied
end
-- Each sector keeps its own progression. Moving to Research Lab cannot
-- inherit Wave 3 (20 aliens) from Containment or another sector.
-- The existing shared HUD follows the currently active sector.
task.spawn(function()
    while root.Parent do
        local occupied=clearEmptySectors()
        local hasDeployed=occupied.containment or occupied.research or occupied.reactor or occupied.nest
        local selectedSector=activeChestSector()
        if not hasDeployed then
            -- New deployment sessions always begin at Wave 1.
            for sector in pairs(sectorWaves) do sectorWaves[sector]=0 end
            lastWaveSector=nil
            wave=0;waveValue.Value=0;aliveValue.Value=0
            timerValue.Value=0
            task.wait(.5)
        else
            if lastWaveSector~=selectedSector then
                -- Sector switching must not carry the old sector's enemies
                -- or wave number into the newly selected sector.
                for _,alien in ipairs(enemies:GetChildren()) do alien:Destroy() end
                lastWaveSector=selectedSector
                wave=sectorWaves[selectedSector]
                waveValue.Value=wave
                aliveValue.Value=0
            end
            if #enemies:GetChildren()==0 then
                breachIntermission=true
                alarm:Play()
                local interrupted=false
                for remaining=7,1,-1 do
                    timerValue.Value=remaining
                    task.wait(1)
                    if not root.Parent then return end
                    local current=clearEmptySectors()
                    if not (current.containment or current.research or current.reactor or current.nest)
                      or activeChestSector()~=selectedSector then
                        interrupted=true
                        break
                    end
                end
                timerValue.Value=0
                if not interrupted then
                    sectorWaves[selectedSector]+=1
                    wave=sectorWaves[selectedSector]
                    waveValue.Value=wave
                    spawnWave(wave,selectedSector)
                end
                breachIntermission=false
                alarm:Stop()
            else
                aliveValue.Value=#enemies:GetChildren()
                task.wait(.4)
            end
        end
    end
end)

-- Queen summons violet broodlings while alive. Summons count toward the
-- active wave, preventing a wave from finishing before the nest is cleared.
task.spawn(function()
 while root.Parent do
  for _,queen in ipairs(enemies:GetChildren()) do
   if queen:GetAttribute("HiveQueen") and queen.PrimaryPart then
    local now=os.clock()
    if now-(queen:GetAttribute("LastBrood") or 0)>=11 then
     queen:SetAttribute("LastBrood",now)
     local qx,qy=0,0 -- convert world coordinates to map tiles
     qx=math.floor(queen.PrimaryPart.Position.X/TILE+WIDTH/2)+1
     qy=math.floor(queen.PrimaryPart.Position.Z/TILE+HEIGHT/2)+1
     for i=1,3 do
      for attempt=1,16 do
       local x=qx+math.random(-5,5)
       local y=qy+math.random(-5,5)
       if free(x-.5,y-.5) then
        local brood=makeAlien(x-.5,y-.5,"crawler",math.max(1,wave))
        brood.Name="VIOLET QUEEN BROOD"
        brood:SetAttribute("SectorEnemy","nest")
        brood:SetAttribute("HiveSpawn",true)
        for _,piece in ipairs(brood:GetDescendants()) do
         if piece:IsA("BasePart") then piece.Color=Color3.fromRGB(156,68,218) end
        end
        break
       end
      end
     end
    end
   end
  end
  task.wait(1)
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
        hum:TakeDamage(alien:GetAttribute("Kind")=="boss" and 20 or alien:GetAttribute("Kind")=="armored" and 13 or 8)
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
        -- Sector enemies use the same flow-field movement as original aliens.
        local part=alien.PrimaryPart
        if not part then continue end
        local ax,ay=gridOf(part.Position)
        local bestPlayer,bestDistance,bestField=nil,math.huge,nil
        for _,player in ipairs(Players:GetPlayers()) do
            local sameSector=(player:GetAttribute("AlienBreachSelectedMap") or "containment")==(alien:GetAttribute("SectorEnemy") or "containment")
            local field=sameSector and player:GetAttribute("AlienBreachDeployed") and fields[player]
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
                groundParams.FilterDescendantsInstances={alien, bestPlayer.Character}
                local groundHit=workspace:Raycast(
                    Vector3.new(part.Position.X,12,part.Position.Z),
                    Vector3.new(0,-40,0),groundParams)
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
                if animation and animation.rig and animation.motors then
                    local moving=playerDistance>27 and delta.Magnitude>0.12
                    animation.phase+=dt*(moving and (animation.kind=="crawler" and 13 or animation.kind=="armored" and 5 or 8) or 1.8)
                    local phase=animation.phase
                    local strength=moving and 1 or .12
                    local attacking=os.clock()-(damageClock[alien] or -100)<.42
                    for _,joint in ipairs(animation.motors) do
                        local name=joint.name
                        local side=name:sub(1,1)=="L" and 1 or -1
                        local rear=name:find("Back")~=nil
                        local offset=(side==1 and 0 or math.pi)+(rear and math.pi or 0)
                        local swing=math.sin(phase+offset)*strength
                        local target=CFrame.identity
                        if name:find("UpperArm") then
                            target=CFrame.Angles(attacking and -.85 or swing*.42,0,side*.08)
                        elseif name:find("Thigh") then
                            target=CFrame.Angles(swing*.35,0,0)
                        elseif name:find("UpperLeg") then
                            target=CFrame.Angles(0,0,side*(.12+swing*.26))
                        elseif name:find("LowerLeg") then
                            target=CFrame.Angles(0,0,side*(-.15-swing*.2))
                        elseif name:find("Forearm") then
                            target=CFrame.Angles(attacking and -.65 or math.sin(phase+offset+1)*.17,0,0)
                        elseif name:find("Head") then
                            target=CFrame.Angles(math.sin(phase*.45)*.045,0,0)
                        end
                        joint.motor.Transform=target
                    end
                end
                if animation and animation.rig then
                    local moving=playerDistance>27 and delta.Magnitude>0.12
                    local desired=moving and "walk" or "idle"
                    if desired~=animation.animationState then
                        local previous=animation.tracks[animation.animationState]
                        if previous then previous:Stop(.18) end
                        local nextTrack=animation.tracks[desired]
                        if nextTrack then nextTrack:Play(.18) end
                        animation.animationState=desired
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
                if playerDistance<= (alien:GetAttribute("HiveQueen") and 115 or 75)
                    and os.clock()-(damageClock[alien] or 0)>(alien:GetAttribute("HiveQueen") and 2.8 or 1.8) then
                    damageClock[alien]=os.clock()
                    local rigAnim=alienAnimation[alien]
                    if rigAnim and rigAnim.rig and rigAnim.tracks.attack then
                        rigAnim.tracks.attack:Play(.08)
                    end
                    local hum=bestPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health>0 then
                        local muzzle=part.Position+Vector3.new(0,1.0,0)
                        local aim=hrp.Position+Vector3.new(0,1.2,0)
                        if alien:GetAttribute("HiveQueen") then
                            local orb=Instance.new("Part")
                            orb.Name="Queen violet plasma orb"
                            orb.Shape=Enum.PartType.Ball
                            orb.Material=Enum.Material.Neon
                            orb.Color=Color3.fromRGB(175,70,255)
                            orb.Size=Vector3.new(3.2,3.2,3.2)
                            orb.Anchored=true;orb.CanCollide=false;orb.CanTouch=false;orb.CanQuery=false
                            orb.Position=muzzle;orb.Parent=root
                            local start=muzzle
                            local direction=(aim-start).Unit
                            local travel=0
                            task.spawn(function()
                                while orb.Parent and travel<110 do
                                    local dtOrb=task.wait(.045)
                                    local step=direction*math.min(65*dtOrb,110-travel)
                                    local rayFilter=RaycastParams.new()
                                    rayFilter.FilterType=Enum.RaycastFilterType.Exclude
                                    rayFilter.FilterDescendantsInstances={alien,orb}
                                    local hit=workspace:Raycast(orb.Position,step,rayFilter)
                                    orb.Position+=step;travel+=step.Magnitude
                                    if hit then
                                        local victim=Players:GetPlayerFromCharacter(hit.Instance:FindFirstAncestorOfClass("Model"))
                                        if victim and victim:GetAttribute("AlienBreachSelectedMap")=="nest" then
                                            local h=victim.Character and victim.Character:FindFirstChildOfClass("Humanoid")
                                            if h then h:TakeDamage(28) end
                                        end
                                        break
                                    end
                                end
                                orb:Destroy()
                            end)
                        else
                            alienShoot(alien,muzzle,aim,hum)
                        end
                    end
                end
            end
        end
    end
end)
