-- Alien Breach menu economy. Place in ServerScriptService.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local DataStoreService=game:GetService("DataStoreService")
local store=DataStoreService:GetDataStore("AlienBreachMenu_v1")
local event=RS:FindFirstChild("AlienBreachMenuEvent") or Instance.new("RemoteEvent")
event.Name="AlienBreachMenuEvent";event.Parent=RS
local prices={shotgun=500,rifle=750,viper=1000,ar51=1250,phantom=1750,titan=2500,plasma=3500,obliterator=5000,medkit=150,speed=250}
local weapons={pulse=true,shotgun=true,rifle=true,viper=true,ar51=true,phantom=true,titan=true,plasma=true,obliterator=true,laser=true}
local data={}
local function state(p)
 local d=data[p]
 if not d then
  d={credits=500,owned={pulse=true},medkit=0,speed=0,slots={"pulse","","","medkit","speed"},stats={games=0,kills=0,bestWave=0}}
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
 event:FireClient(p,"state",{credits=d.credits,owned=d.owned,medkit=d.medkit,speed=d.speed,slots=d.slots,stats=d.stats})
end
Players.PlayerAdded:Connect(function(p)
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
  if type(saved.slots)=="table" then
   for i=1,3 do if type(saved.slots[i])=="string" then d.slots[i]=saved.slots[i] end end
  end
 elseif not ok then warn("Alien Breach load failed: "..tostring(saved)) end
 task.defer(function() if p.Parent then snapshot(p) end end)
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
  if arg1=="medkit" or arg1=="speed" then d[arg1]+=1 else d.owned[arg1]=true end
 elseif action=="slot" then
  if not validSlot(d,arg1,arg2) then return end
  d.slots[arg1]=arg2
 elseif action=="save" then
  local ok=save(p)
  event:FireClient(p,"notice",ok and "LOADOUT SAVED" or "SAVE FAILED - ENABLE API SERVICES")
 elseif action=="deploy" then
  p:SetAttribute("AlienBreachDeployed",true)
  d.stats.games+=1
  save(p)
 else return end
 snapshot(p)
end)
