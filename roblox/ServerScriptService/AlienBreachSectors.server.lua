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
-- Unlike the original dirty ceramic grid, this map has large charcoal
-- hex-like metal deck panels, glowing seam lines and high-tech floor grilles.
-- Group tiles into two-by-two blocks to reduce the part count on phones.
for y=3,42,2 do
 for x=67,112,2 do
  if open(x,y) then
   local cx,cy=x-.5,y-.5
   part("Research dark alloy deck",cx,cy,.23,Vector3.new(15.6,.42,15.6),
    ((x+y)%7==0) and Color3.fromRGB(54,67,76) or floor,Enum.Material.DiamondPlate)
   if x%6==1 then
    local strip=part("Floor cyan guiding strip",cx,cy,.47,Vector3.new(.16,.04,14),cyan,Enum.Material.Neon)
    strip.Transparency=.18
   end
   if (x*7+y*11)%13==0 then
    part("Broken floor hazard plate",cx,cy,.49,Vector3.new(5,.07,4),Color3.fromRGB(105,61,52),Enum.Material.CorrodedMetal)
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
-- Distinctive overhead construction: dark suspended ceiling bays,
-- exposed crossbeams, bright hanging surgical lights and damaged sections.
for y=5,41,4 do
 for x=69,111,4 do
  if open(x,y) then
   part("Suspended laboratory ceiling cassette",x-.5,y-.5,17.6,
    Vector3.new(22,.3,22),Color3.fromRGB(13,28,40))
   part("Ceiling ventilation truss",x-.5,y-.5,17.15,
    Vector3.new(20,.45,1.1),Color3.fromRGB(73,96,112))
   local lamp=part("Hanging cyan laboratory light",x-.5,y-.5,16.5,
    Vector3.new(8,.32,1.3),cyan,Enum.Material.Neon)
   light(lamp,cyan,1.2,38)
   if (x+y)%3==0 then
    local warning=part("Emergency red strobe",x+1,y-.5,16.3,
     Vector3.new(1,.3,1),red,Enum.Material.Neon)
    light(warning,red,.7,18)
   end
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
local function teleport(player)
 if not player:GetAttribute("AlienBreachDeployed") then return end
 if player:GetAttribute("AlienBreachSelectedMap")~="research" then return end
 local character=player.Character
 if not character then return end
 local hrp=character:FindFirstChild("HumanoidRootPart")
 if hrp then character:PivotTo(CFrame.new(pos(research.x-.5,research.y-.5,5))) end
end
local function track(player)
 player:GetAttributeChangedSignal("AlienBreachDeployed"):Connect(function()
  if player:GetAttribute("AlienBreachDeployed") then task.defer(teleport,player) end
 end)
 if player:GetAttribute("AlienBreachDeployed") then task.defer(teleport,player) end
end
Players.PlayerAdded:Connect(track)
for _,player in ipairs(Players:GetPlayers()) do track(player) end
