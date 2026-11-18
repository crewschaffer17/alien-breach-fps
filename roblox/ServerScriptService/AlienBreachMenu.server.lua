-- Alien Breach menu economy. Place in ServerScriptService.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local DataStoreService=game:GetService("DataStoreService")
local store=DataStoreService:GetDataStore("AlienBreachMenu_v1")
local event=RS:FindFirstChild("AlienBreachMenuEvent") or Instance.new("RemoteEvent")
event.Name="AlienBreachMenuEvent";event.Parent=RS
local prices={shotgun=500,rifle=750,viper=1000,ar51=1250,phantom=1750,titan=2500,plasma=3500,obliterator=5000,medkit=150,speed=250}
local weapons={pulse=true,shotgun=true,rifle=true,viper=true,ar51=true,phantom=true,titan=true,plasma=true,obliterator=true,laser=true}
local sectorPrices={containment=0,research=2500,reactor=5000,nest=8500}
local data={}
local owns=Instance.new("BindableFunction")
owns.Name="AlienBreachOwnsWeapon"
owns.Parent=RS
owns.OnInvoke=function(p,id)
 local d=data[p]
 return d~=nil and d.owned[id]==true and id~="laser"
end
local function state(p)
 local d=data[p]
 if not d then
  d={credits=500,owned={pulse=true},medkit=0,speed=0,slots={"pulse","","","medkit","speed"},stats={games=0,kills=0,bestWave=0},maps={containment=true},selectedMap="containment"}
  data[p]=d
 end
 return d
end
local function save(p)
 local d=data[p]
 if not d then return false end
 local ls=p:FindFirstChild("leaderstats")
 local credits=ls and ls:FindFirstChild("Credits")
 if credits then d.credits=credits.Value end
 local ok,err=pcall(function()store:SetAsync("player_"..p.UserId,d)end)
 if not ok then warn("Alien Breach save failed: "..tostring(err)) end
 return ok
end
local function snapshot(p)
 local d=state(p)
 local ls=p:FindFirstChild("leaderstats")
 local credits=ls and ls:FindFirstChild("Credits")
 if credits then d.credits=credits.Value end
 event:FireClient(p,"state",{credits=d.credits,owned=d.owned,medkit=d.medkit,speed=d.speed,slots=d.slots,stats=d.stats,maps=d.maps,selectedMap=d.selectedMap})
end
local function watchCharacter(p,character)
 local humanoid=character:WaitForChild("Humanoid",10)
 if not humanoid then return end
 humanoid.Died:Connect(function()
  -- Death ends this deployment. The menu LocalScript observes this attribute.
  p:SetAttribute("AlienBreachDeployed",false)
  p:SetAttribute("AlienBreachSelectedMap","containment") -- Respawn in the command area, not the previous sector.
  p:SetAttribute("HasLegendaryLaser",false)
  p:SetAttribute("Weapon","pulse")
  event:FireClient(p,"returnHome")
 end)
end
Players.PlayerAdded:Connect(function(p)
 p.CharacterAdded:Connect(function(character) watchCharacter(p,character) end)
 if p.Character then task.spawn(watchCharacter,p,p.Character) end
 local d=state(p)
 local ok,saved=pcall(function()return store:GetAsync("player_"..p.UserId)end)
 if ok and type(saved)=="table" then
  d.credits=math.max(0,tonumber(saved.credits) or 500)
  d.owned=type(saved.owned)=="table" and saved.owned or d.owned
  d.owned.pulse=true
  d.owned.laser=nil -- chest-only, not a permanent purchase
  d.medkit=math.max(0,tonumber(saved.medkit) or 0)
  d.speed=math.max(0,tonumber(saved.speed) or 0)
  d.stats=type(saved.stats)=="table" and saved.stats or d.stats
  d.maps=type(saved.maps)=="table" and saved.maps or d.maps
  d.maps.containment=true
  d.selectedMap=type(saved.selectedMap)=="string" and saved.selectedMap or "containment"
  if not d.maps[d.selectedMap] or (d.selectedMap~="research" and d.selectedMap~="containment") then d.selectedMap="containment" end
  if type(saved.slots)=="table" then
   for i=1,3 do if type(saved.slots[i])=="string" then d.slots[i]=saved.slots[i] end end
  end
 elseif not ok then warn("Alien Breach load failed: "..tostring(saved)) end
 task.defer(function()
  if not p.Parent then return end
  local ls=p:WaitForChild("leaderstats",5)
  local credits=ls and ls:WaitForChild("Credits",5)
  if credits then
   credits.Value=d.credits
   credits.Changed:Connect(function()
    if not p.Parent then return end
    d.credits=credits.Value
    snapshot(p)
   end)
  end
  snapshot(p)
 end)
end)
Players.PlayerRemoving:Connect(function(p) save(p);data[p]=nil end)
game:BindToClose(function()for p in pairs(data) do save(p) end end)
local function validSlot(d,index,item)
 if type(index)~="number" or index%1~=0 or index<1 or index>5 or type(item)~="string" then return false end
 if index==4 then return item=="medkit" end
 if index==5 then return item=="speed" end
 if item=="" then return true end
 if index<=2 then return weapons[item] and d.owned[item] end
 return (weapons[item] and d.owned[item]) or (item=="medkit" and d.medkit>0) or (item=="speed" and d.speed>0)
end
event.OnServerEvent:Connect(function(p,action,arg1,arg2)
 local d=state(p)
 if action=="sync" then snapshot(p);return end
 if action=="buy" then
  if type(arg1)~="string" then return end
  local cost=prices[arg1]
  if not cost or d.credits<cost then event:FireClient(p,"notice","Not enough credits");return end
  if weapons[arg1] and d.owned[arg1] then event:FireClient(p,"notice","Already owned");return end
  d.credits-=cost
  local ls=p:FindFirstChild("leaderstats")
  local credits=ls and ls:FindFirstChild("Credits")
  if credits then credits.Value=d.credits end
  if arg1=="medkit" or arg1=="speed" then d[arg1]+=1 else
   d.owned[arg1]=true
   local purchase=RS:FindFirstChild("AlienBreachWeaponPurchased")
   if purchase then purchase:Fire(p,arg1) end
  end
 elseif action=="buyMap" then
  if type(arg1)~="string" or not sectorPrices[arg1] then return end
  if arg1~="research" then event:FireClient(p,"notice","SECTOR UNDER CONSTRUCTION");return end
  if d.maps[arg1] then event:FireClient(p,"notice","SECTOR ALREADY UNLOCKED");return end
  local ls=p:FindFirstChild("leaderstats")
  local credits=ls and ls:FindFirstChild("Credits")
  local cost=sectorPrices[arg1]
  if not credits or credits.Value<cost then event:FireClient(p,"notice","NOT ENOUGH CREDITS");return end
  credits.Value-=cost
  d.credits=credits.Value
  d.maps[arg1]=true
  event:FireClient(p,"notice","SECTOR UNLOCKED: "..string.upper(arg1))
 elseif action=="selectMap" then
  if type(arg1)~="string" or not sectorPrices[arg1] or not d.maps[arg1] then return end
  if arg1~="research" and arg1~="containment" then event:FireClient(p,"notice","SECTOR UNDER CONSTRUCTION");return end
  d.selectedMap=arg1
  event:FireClient(p,"notice","SECTOR SELECTED: "..string.upper(arg1))
 elseif action=="slot" then
  if not validSlot(d,arg1,arg2) then return end
  d.slots[arg1]=arg2
 elseif action=="save" then
  local ok=save(p)
  event:FireClient(p,"notice",ok and "LOADOUT SAVED" or "SAVE FAILED - ENABLE API SERVICES")
 elseif action=="deploy" then
  local allowed={"pulse"}
  for id,owned in pairs(d.owned) do if owned and id~="pulse" and id~="laser" then table.insert(allowed,id) end end
  p:SetAttribute("AlienBreachAllowedWeapons",table.concat(allowed,","))
  local chosen=d.slots[1]
  if not d.owned[chosen] then chosen="pulse" end
  p:SetAttribute("Weapon",chosen)
  p:SetAttribute("AlienBreachSelectedMap",d.selectedMap)
  p:SetAttribute("AlienBreachDeployed",true)
  d.stats.games+=1
  save(p)
 else return end
 snapshot(p)
end)
