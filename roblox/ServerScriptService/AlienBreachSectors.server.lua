-- Alien Breach: separate Research Lab map (stage 1).
-- Requires the updated AlienBreach.server.lua floorplan. Leave Reactor/Nest for later.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local map=string.split(RS:WaitForChild("AlienBreachMap").Value,"\n")
local root=workspace:WaitForChild("AlienBreachRoblox")
local TILE=8
local W,H=#map[1],#map
local research={x=89,y=15}
local decor=Instance.new("Folder")
decor.Name="ResearchLabEnvironment"
decor.Parent=root
local function pos(x,y,h)
 return Vector3.new((x-W/2)*TILE,h or 0,(y-H/2)*TILE)
end
local function open(x,y)
 local row=map[y]
 return row~=nil and row:sub(x,x)=="0"
end
local function part(name,x,y,h,size,color,material,collide)
 local p=Instance.new("Part")
 p.Name=name
 p.Size=size
 p.CFrame=CFrame.new(pos(x,y,h))
 p.Anchored=true
 p.CanCollide=collide==true
 p.CanTouch=false
 p.CanQuery=collide==true
 p.CastShadow=false
 p.Material=material or Enum.Material.Metal
 p.Color=color
 p.Parent=decor
 return p
end
local function light(p,color,brightness,range)
 local l=Instance.new("PointLight")
 l.Color=color;l.Brightness=brightness;l.Range=range;l.Shadows=false;l.Parent=p
end
local cyan=Color3.fromRGB(65,227,241)
local red=Color3.fromRGB(249,60,75)
local steel=Color3.fromRGB(30,54,71)
local floor=Color3.fromRGB(38,51,61)
local glass=Color3.fromRGB(88,180,203)
local function sign(x,y,message,color)
 local p=part("LAB SIGN / "..message,x,y,10,Vector3.new(12,3,.35),Color3.fromRGB(7,19,29))
 local sg=Instance.new("SurfaceGui")
 sg.Face=Enum.NormalId.Front;sg.CanvasSize=Vector2.new(600,150);sg.LightInfluence=0;sg.Parent=p
 local t=Instance.new("TextLabel")
 t.Size=UDim2.fromScale(1,1);t.BackgroundTransparency=1;t.Text=message
 t.TextColor3=color;t.Font=Enum.Font.SciFi;t.TextScaled=true;t.Parent=sg
end
-- Floor panels now follow EACH walkable tile, never bridging solid walls.
-- Decorative panels sit flush with the original foundation and do not collide.
for y=3,42 do
 for x=67,112 do
  if open(x,y) then
   local cx,cy=x-.5,y-.5
   local panel=part("Research precision alloy floor",cx,cy,.095,
    Vector3.new(7.88,.17,7.88),
    ((x+y)%11==0) and Color3.fromRGB(55,72,81) or floor,
    Enum.Material.DiamondPlate)
   if x%7==0 and open(x,y-1) and open(x,y+1) then
    local strip=part("Embedded cyan route guide",cx,cy,.205,
     Vector3.new(.16,.025,7.1),cyan,Enum.Material.Neon)
    strip.Transparency=.25
   end
   if (x*7+y*11)%41==0 then
    part("Scorched floor impact",cx,cy,.21,
     Vector3.new(3,.025,3),Color3.fromRGB(86,55,52),Enum.Material.CorrodedMetal)
   end
  end
 end
end
-- Architectural wall treatment: black composite ribs, bright edge trims,
-- frosted observation windows, red hazard bulkheads and fractured panels.
for y=4,41,2 do
 for x=68,111,2 do
  if open(x,y) then
   for _,d in ipairs({{1,0},{-1,0},{0,1},{0,-1}}) do
    if not open(x+d[1],y+d[2]) then
     local wx,wy=x-.5+d[1]*.5,y-.5+d[2]*.5
     local side=d[1]~=0
     part("Research composite wall cladding",wx,wy,9,
      side and Vector3.new(.3,16,7) or Vector3.new(7,16,.3),steel)
     local edge=part("Wall cyan power conduit",wx,wy,15.5,
      side and Vector3.new(.38,.25,7) or Vector3.new(7,.25,.38),cyan,Enum.Material.Neon)
     edge.Transparency=.12
    end
   end
  end
 end
end
-- Every ceiling cassette is tile-sized: no roofs cutting through walls.
-- Higher central specimen hall remains open above its tall original roof.
for y=4,41 do
 for x=68,111 do
  if open(x,y) then
   local high=x>=81 and x<=99 and y>=9 and y<=20
   local ceilingY=high and 33.6 or 17.45
   part("Research sealed ceiling cassette",x-.5,y-.5,ceilingY,
    Vector3.new(7.9,.22,7.9),Color3.fromRGB(13,28,40))
   if x%4==0 and y%4==0 then
    part("Research ceiling service beam",x-.5,y-.5,ceilingY-.35,
     Vector3.new(7.2,.38,.7),Color3.fromRGB(73,96,112))
    local lamp=part("Surgical cyan light",x-.5,y-.5,ceilingY-.85,
     Vector3.new(4,.25,1.1),cyan,Enum.Material.Neon)
    light(lamp,Color3.fromRGB(188,237,246),2.1,48)
   elseif (x*3+y)%19==0 then
    local warning=part("Emergency red lamp",x-.5,y-.5,ceilingY-.6,
     Vector3.new(1,.24,1),red,Enum.Material.Neon)
    light(warning,red,.55,16)
   end
  end
 end
end
-- Soft white overhead fill lights keep the lab readable while retaining
-- cyan/red emergency accents. Local lights do not wash out the original map.
for y=6,39,7 do
 for x=71,109,7 do
  if open(x,y) then
   local high=x>=81 and x<=99 and y>=9 and y<=20
   local fixture=part("Research wide-area white floodlight",x-.5,y-.5,
    high and 31.5 or 16,Vector3.new(3,.22,3),
    Color3.fromRGB(199,225,238),Enum.Material.Neon)
   light(fixture,Color3.fromRGB(204,228,246),2.3,57)
  end
 end
end
-- Huge central containment tanks and research benches. All display parts
-- are non-collidable so enemies retain clear paths and no player gets stuck.
for _,p in ipairs({{83,11},{89,11},{95,11},{83,17},{89,17},{95,17}}) do
 local x,y=p[1],p[2]
 if open(x,y) then
  part("Specimen pod reinforced foundation",x-.5,y-.5,1,Vector3.new(6,2,6),steel)
  local tube=part("CRYO / GLASS CONTAINMENT CYLINDER",x-.5,y-.5,8,
   Vector3.new(5,12,5),glass,Enum.Material.Glass)
  tube.Shape=Enum.PartType.Cylinder;tube.Transparency=.65
  local fluid=part("Suspended alien specimen",x-.5,y-.5,7,
   Vector3.new(2.5,6,2.5),Color3.fromRGB(57,168,142),Enum.Material.Glass)
  fluid.Shape=Enum.PartType.Ball;fluid.Transparency=.22
  part("Cryo pod overhead seal",x-.5,y-.5,14.3,Vector3.new(6,1.4,6),steel)
  local ring=part("Specimen diagnostic ring",x-.5,y-.5,15.2,Vector3.new(6,.3,6),cyan,Enum.Material.Neon)
  light(ring,cyan,.8,20)
 end
end
for _,p in ipairs({{70,12},{78,17},{103,12},{109,17},{70,30},{80,37},{89,32},{96,37},{104,30},{110,37}}) do
 local x,y=p[1],p[2]
 if open(x,y) then
  part("Research workstation",x-.5,y-.5,2.4,Vector3.new(5,1,3),Color3.fromRGB(64,83,98))
  local screen=part("Flickering holographic terminal",x-.5,y-.5,4.2,
   Vector3.new(4,2,.3),cyan,Enum.Material.Neon)
  screen.Transparency=.28
 end
end
for _,p in ipairs({{70,6},{97,6},{72,23},{103,23},{70,39},{97,39}}) do
 local x,y=p[1],p[2]
 if open(x,y) then
  local spill=part("Containment breach chemical spill",x-.5,y-.5,.53,
   Vector3.new(5,.08,5),Color3.fromRGB(79,165,119),Enum.Material.Neon)
  spill.Transparency=.48
  part("Shattered observation glass",x-.5,y-.5,1.2,
   Vector3.new(3,.08,1.5),Color3.fromRGB(122,195,205),Enum.Material.Glass)
 end
end
sign(89,7,"PROJECT ECHO // RESEARCH LAB",cyan)
sign(90,23,"BIOHAZARD // CONTAINMENT FAILURE",red)
sign(90,39,"EVACUATE // EXPERIMENTAL WING",red)
-- Environmental storytelling: overturned desks, broken consoles, shelving,
-- equipment crates, pipework, wall-mounted status monitors, loose debris.
-- Placement is deterministic and kept non-collidable for safe alien routing.
local rng=Random.new(51027)
for y=5,40,3 do
 for x=69,110,3 do
  if open(x,y) and (x<84 or x>99 or y>21) then
   local cx,cy=x-.5,y-.5
   local variant=(x*17+y*29)%9
   if variant<=2 then
    part("Lab equipment cabinet",cx,cy,3.2,Vector3.new(4,6,2.2),
     Color3.fromRGB(46,68,82))
    part("Cabinet warning stripe",cx,cy-0.15,5.4,
     Vector3.new(3.4,.24,2.3),variant==0 and red or cyan,Enum.Material.Neon)
   elseif variant<=4 then
    part("Abandoned instrument cart",cx,cy,1.8,Vector3.new(4,2.8,3),
     Color3.fromRGB(70,85,97))
    part("Portable diagnostic screen",cx,cy,3.7,Vector3.new(2.6,1.8,.25),
     cyan,Enum.Material.Neon).Transparency=.22
   elseif variant==5 then
    part("Spilled cargo case",cx,cy,.9,Vector3.new(3,1.8,2.5),
     Color3.fromRGB(91,72,65),Enum.Material.CorrodedMetal)
   elseif variant==6 then
    part("Medical examination table",cx,cy,2.3,Vector3.new(5,.45,2.6),
     Color3.fromRGB(128,145,149))
    part("Emergency med display",cx,cy,3.5,Vector3.new(2.2,1.3,.2),
     Color3.fromRGB(72,192,146),Enum.Material.Neon)
   elseif variant==7 then
    local pod=part("Biohazard disposal canister",cx,cy,2.3,
     Vector3.new(2.6,4.5,2.6),Color3.fromRGB(91,112,84))
    pod.Shape=Enum.PartType.Cylinder
    part("Canister red seal",cx,cy,4.6,Vector3.new(3,.3,3),red,Enum.Material.Neon)
   end
   if (x*13+y*7)%5==0 then
    local scrap=part("Scattered broken lab panel",cx+rng:NextNumber(-1.6,1.6),
     cy+rng:NextNumber(-1.6,1.6),.3,
     Vector3.new(rng:NextNumber(1,2.5),.1,rng:NextNumber(1,2.5)),
     Color3.fromRGB(92,125,131),Enum.Material.Metal)
    scrap.CFrame=scrap.CFrame*CFrame.Angles(0,rng:NextNumber(0,6.28),0)
   end
  end
 end
end
for _,p in ipairs({{70,8},{78,12},{103,12},{109,18},{71,30},{81,35},{90,30},{97,38},{108,33}}) do
 local x,y=p[1],p[2]
 if open(x,y) then
  local c=part("Suspended research display",x-.5,y-.5,10,
   Vector3.new(5,3,.3),Color3.fromRGB(18,42,58))
  local screen=part("Live diagnostics hologram",x-.5,y-.65,10,
   Vector3.new(4.5,2.5,.12),cyan,Enum.Material.Neon)
  screen.Transparency=.3
 end
end
-- A sector change is a deployment transition, not a permanent respawn location.
-- Always relocate the character for BOTH sectors, including after a death.
local function teleport(player,character)
 if not player:GetAttribute("AlienBreachDeployed") then return end
 local sector=player:GetAttribute("AlienBreachSelectedMap")
 if sector~="research" and sector~="containment" then return end
 local hrp=character:WaitForChild("HumanoidRootPart",10)
 if not hrp or character~=player.Character or not character.Parent then return end
 if not player:GetAttribute("AlienBreachDeployed") or player:GetAttribute("AlienBreachSelectedMap")~=sector then return end
 if sector=="research" then
  character:PivotTo(CFrame.new(pos(research.x-.5,research.y-.5,5)))
 else
  local spawn=root:FindFirstChild("Starting Room Spawn")
  if spawn then character:PivotTo(spawn.CFrame*CFrame.new(0,4,0)) end
 end
end
local function track(player)
 local function move()
  if player.Character and player:GetAttribute("AlienBreachDeployed") then
   task.defer(teleport,player,player.Character)
  end
 end
 player.CharacterAdded:Connect(function(character)
  task.defer(teleport,player,character)
 end)
 player:GetAttributeChangedSignal("AlienBreachSelectedMap"):Connect(move)
 player:GetAttributeChangedSignal("AlienBreachDeployed"):Connect(move)
 move()
end
Players.PlayerAdded:Connect(track)
for _,player in ipairs(Players:GetPlayers()) do track(player) end
