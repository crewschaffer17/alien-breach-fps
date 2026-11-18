-- Alien Breach menu economy. Place in ServerScriptService.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local DataStoreService=game:GetService("DataStoreService")
local store=DataStoreService:GetDataStore("AlienBreachMenu_v1")
local event=RS:FindFirstChild("AlienBreachMenuEvent") or Instance.new("RemoteEvent")
event.Name="AlienBreachMenuEvent";event.Parent=RS
local prices={shotgun=500,rifle=750,viper=1000,ar51=1250,phantom=1750,titan=2500,plasma=3500,obliterator=5000,medkit=150,speed=250}
local weapons={pulse=true,shotgun=true,rifle=true,viper=true,ar51=true,phantom=true,titan=true,plasma=true,obliterator=true,laser=true}
local maps={containment=0,research=2500,reactor=5000,nest=8500}
local upgradePrices={[1]=300,[2]=600,[3]=1100,[4]=1800}
local rankNames={"RECRUIT","PRIVATE","CORPORAL","SERGEANT","LIEUTENANT","CAPTAIN","MAJOR","COMMANDER","LEGEND"}
local function rankFor(xp)
 local rank=math.clamp(math.floor(math.sqrt(math.max(0,xp)/125))+1,1,#rankNames)
 return rank,rankNames[rank],125*rank*rank
end
local data={}
local function state(p)
 local d=data[p]
 if not d then
  d={credits=500,owned={pulse=true},medkit=0,speed=0,slots={"pulse","","","medkit","speed"},stats={games=0,kills=0,bestWave=0},xp=0,levels={pulse=1},maps={containment=true},selectedMap="containment"}
  data[p]=d
 end
 return d
end
local function save(p)
 local d=data[p]
 if not d then return false end
 local ok,err=pcall(function()store:SetAsync("player_"..p.UserId,d)end)
 if not ok then warn("Alien Breach save failed: "..tostring(err)) end
 return ok
end
local function snapshot(p)
 local d=state(p)
 local rank,rankName,nextXP=rankFor(d.xp or 0)
 event:FireClient(p,"state",{credits=d.credits,owned=d.owned,medkit=d.medkit,speed=d.speed,slots=d.slots,stats=d.stats,xp=d.xp,rank=rank,rankName=rankName,nextXP=nextXP,levels=d.levels,maps=d.maps,selectedMap=d.selectedMap})
end
local function watchCharacter(p,character)
 local humanoid=character:WaitForChild("Humanoid",10)
 if not humanoid then return end
 humanoid.Died:Connect(function()
  -- Death ends this deployment. The menu LocalScript observes this attribute.
  p:SetAttribute("AlienBreachDeployed",false)
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
  d.xp=math.max(0,tonumber(saved.xp) or 0)
  d.levels=type(saved.levels)=="table" and saved.levels or d.levels
  d.maps=type(saved.maps)=="table" and saved.maps or d.maps
  d.maps.containment=true
  d.selectedMap=d.maps[saved.selectedMap] and saved.selectedMap or "containment"
  if type(saved.slots)=="table" then
   for i=1,3 do if type(saved.slots[i])=="string" then d.slots[i]=saved.slots[i] end end
  end
 elseif not ok then warn("Alien Breach load failed: "..tostring(saved)) end
 task.defer(function()
  if not p.Parent then return end
  p:SetAttribute("AlienBreachSelectedMap",d.selectedMap)
  local leader=p:FindFirstChild("leaderstats")
  if leader and leader:FindFirstChild("Credits") then leader.Credits.Value=d.credits end
  for id,level in pairs(d.levels) do p:SetAttribute("WeaponLevel_"..id,math.clamp(tonumber(level) or 3,1,5)) end
  snapshot(p)
 end)
end)
-- Combat awards update saved currency, XP and lifetime stats on the server.
local reward=RS:FindFirstChild("AlienBreachKillReward") or Instance.new("BindableEvent")
reward.Name="AlienBreachKillReward";reward.Parent=RS
reward.Event:Connect(function(p,kind)
 if not p or not p.Parent then return end
 local d=state(p)
 d.credits+=kind=="boss" and 350 or 20
 d.xp+=kind=="boss" and 250 or kind=="armored" and 30 or 20
 d.stats.kills=(d.stats.kills or 0)+1
 local stats=p:FindFirstChild("leaderstats")
 if stats and stats:FindFirstChild("Credits") then stats.Credits.Value=d.credits end
 snapshot(p)
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
 if action=="earnKill" then return end -- XP is awarded only by the combat server
 if action=="upgrade" then
  if type(arg1)~="string" or not weapons[arg1] or not d.owned[arg1] or arg1=="laser" then return end
  local level=math.clamp(tonumber(d.levels[arg1]) or 3,1,5)
  local cost=upgradePrices[level]
  if not cost then event:FireClient(p,"notice","MAX WEAPON LEVEL");return end
  if d.credits<cost then event:FireClient(p,"notice","NOT ENOUGH CREDITS");return end
  d.credits-=cost;d.levels[arg1]=level+1
  p:SetAttribute("WeaponLevel_"..arg1,level+1)
 elseif action=="buyMap" then
  if type(arg1)~="string" or not maps[arg1] then return end
  if d.maps[arg1] then return end
  if d.credits<maps[arg1] then event:FireClient(p,"notice","NOT ENOUGH CREDITS");return end
  d.credits-=maps[arg1];d.maps[arg1]=true
 elseif action=="selectMap" then
  if type(arg1)~="string" or not d.maps[arg1] then return end
  d.selectedMap=arg1
  p:SetAttribute("AlienBreachSelectedMap",arg1)
 if action=="buy" then
  if type(arg1)~="string" then return end
  local cost=prices[arg1]
  if not cost or d.credits<cost then event:FireClient(p,"notice","Not enough credits");return end
  if weapons[arg1] and d.owned[arg1] then event:FireClient(p,"notice","Already owned");return end
  d.credits-=cost
  if weapons[arg1] then d.levels[arg1]=1;p:SetAttribute("WeaponLevel_"..arg1,1) end
  if arg1=="medkit" or arg1=="speed" then d[arg1]+=1 else d.owned[arg1]=true end
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
