-- Alien Breach playable sector wings.
-- Add as a NEW Script in ServerScriptService.
-- Uses the original map, aliens, wave manager and weapons; does not rebuild them.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local mapValue=RS:WaitForChild("AlienBreachMap")
local root=workspace:WaitForChild("AlienBreachRoblox")
local TILE=8
local map=string.split(mapValue.Value,"\n")
local width=#map[1]
local height=#map
local sectors={
 containment={x=18,y=18,name="CONTAINMENT WING"},
 research={x=45,y=7,name="RESEARCH LAB"},
 reactor={x=45,y=19,name="REACTOR CORE"},
 nest={x=45,y=36,name="ALIEN NEST"}
}
local decor=Instance.new("Folder")
decor.Name="PlayableSectorDecor"
decor.Parent=root
local function position(x,y,h)
 return Vector3.new((x-.5-width/2)*TILE,h or 0,(y-.5-height/2)*TILE)
end
local function open(x,y)
 return map[y] and map[y]:sub(x,x)=="0"
end
local function safeTile(x,y)
 if open(x,y) then return x,y end
 for radius=1,10 do
  for dy=-radius,radius do
   for dx=-radius,radius do
    if open(x+dx,y+dy) then return x+dx,y+dy end
   end
  end
 end
 return 4,5
end
local function part(name,x,y,offset,size,color,material,transparency)
 local p=Instance.new("Part")
 p.Name=name
 p.Size=size
 p.Anchored=true
 p.CanCollide=false
 p.CanTouch=false
 p.CanQuery=false
 p.CastShadow=false
 p.Color=color
 p.Material=material or Enum.Material.Metal
 p.Transparency=transparency or 0
 p.CFrame=CFrame.new(position(x,y,offset))
 p.Parent=decor
 return p
end
local function glow(p,color,range,brightness)
 local light=Instance.new("PointLight")
 light.Color=color
 light.Range=range or 25
 light.Brightness=brightness or 1
 light.Shadows=false
 light.Parent=p
end
local function sign(x,y,label,color)
 local anchor=part(label.." directory",x,y,9,Vector3.new(7,2.7,.5),Color3.fromRGB(14,28,36))
 local surface=Instance.new("SurfaceGui")
 surface.Face=Enum.NormalId.Front
 surface.AlwaysOnTop=true
 surface.PixelsPerStud=32
 surface.Parent=anchor
 local t=Instance.new("TextLabel")
 t.Size=UDim2.fromScale(1,1)
 t.BackgroundTransparency=1
 t.Font=Enum.Font.SciFi
 t.TextScaled=true
 t.TextColor3=color
 t.Text=label
 t.Parent=surface
end
local function nearestOpen(x,y)
 return safeTile(x,y)
end
-- Sector landmarks are placed only on walkable floor tiles. Decorations do not
-- collide with players, shots or alien pathfinding.
local function research()
 local color=Color3.fromRGB(68,237,235)
 for _,p in ipairs({{40,5},{46,5},{52,5},{40,9},{46,9},{52,9}}) do
  local x,y=nearestOpen(p[1],p[2])
  local base=part("Research cryo pod base",x,y,1,Vector3.new(4.5,2,4.5),Color3.fromRGB(38,77,88))
  local glass=part("Research glowing specimen tube",x,y,6.8,Vector3.new(3,10,3),color,Enum.Material.Glass,.68)
  local core=part("Research specimen hologram",x,y,6,Vector3.new(.8,6,.8),color,Enum.Material.Neon,.24)
  glow(core,color,22,.7)
 end
 sign(45,7,"RESEARCH LAB",color)
end
local function reactor()
 local color=Color3.fromRGB(255,164,58)
 for _,p in ipairs({{40,17},{46,17},{52,17},{40,22},{46,22},{52,22}}) do
  local x,y=nearestOpen(p[1],p[2])
  part("Reactor armored pedestal",x,y,1.5,Vector3.new(5,3,5),Color3.fromRGB(78,65,56))
  local core=part("Reactor hot plasma core",x,y,7,Vector3.new(2.5,8,2.5),color,Enum.Material.Neon,.22)
  part("Reactor upper heat sink",x,y,12,Vector3.new(5,2,5),Color3.fromRGB(96,91,88))
  glow(core,color,27,1)
 end
 sign(45,19,"REACTOR CORE",color)
end
local function nest()
 local color=Color3.fromRGB(182,61,225)
 for _,p in ipairs({{40,32},{46,32},{52,32},{40,39},{46,39},{52,39}}) do
  local x,y=nearestOpen(p[1],p[2])
  local base=part("Hive fungal spread",x,y,.35,Vector3.new(7,.5,7),Color3.fromRGB(91,35,87),Enum.Material.Slate,.25)
  local egg=part("Alien nest egg",x,y,3.7,Vector3.new(3.6,6,3.6),Color3.fromRGB(107,35,122),Enum.Material.Glass,.22)
  egg.Shape=Enum.PartType.Ball
  local core=part("Hive bioluminescence",x,y,4,Vector3.new(1.2,2.6,1.2),color,Enum.Material.Neon,.15)
  core.Shape=Enum.PartType.Ball
  glow(core,color,24,.65)
 end
 sign(45,36,"ALIEN NEST",color)
end
research()
reactor()
nest()
local function deployToSector(player)
 if not player:GetAttribute("AlienBreachDeployed") then return end
 local id=player:GetAttribute("AlienBreachSelectedMap") or "containment"
 local sector=sectors[id] or sectors.containment
 local character=player.Character
 local hrp=character and character:FindFirstChild("HumanoidRootPart")
 if not hrp then return end
 local x,y=safeTile(sector.x,sector.y)
 -- Elevate above the floor and allow Roblox's collision solver to settle.
 character:PivotTo(CFrame.new(position(x,y,5)))
end
local function track(player)
 player:GetAttributeChangedSignal("AlienBreachDeployed"):Connect(function()
  if player:GetAttribute("AlienBreachDeployed") then
   task.defer(deployToSector,player)
  end
 end)
 if player:GetAttribute("AlienBreachDeployed") then task.defer(deployToSector,player) end
end
Players.PlayerAdded:Connect(track)
for _,p in ipairs(Players:GetPlayers()) do track(p) end
