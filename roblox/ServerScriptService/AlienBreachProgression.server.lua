-- Independent progression system. Does not control spawning, camera, menus or waves.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local DataStoreService=game:GetService("DataStoreService")
local store=DataStoreService:GetDataStore("AlienBreachProgression_v1")
local remote=Instance.new("RemoteEvent")
remote.Name="AlienBreachProgressionEvent"
remote.Parent=RS
local kills=Instance.new("BindableEvent")
kills.Name="AlienBreachProgressionKill"
kills.Parent=RS
local names={"RECRUIT","PRIVATE","CORPORAL","SERGEANT","LIEUTENANT","CAPTAIN","MAJOR","COMMANDER","LEGEND"}
local prices={[1]=300,[2]=600,[3]=1100,[4]=1800}
local valid={pulse=true,shotgun=true,rifle=true,viper=true,ar51=true,phantom=true,titan=true,plasma=true,obliterator=true}
local purchases=Instance.new("BindableEvent")
purchases.Name="AlienBreachWeaponPurchased"
purchases.Parent=RS
local profiles={}
local function rank(xp)
 local index=math.clamp(math.floor(math.sqrt(xp/125))+1,1,#names)
 return names[index],125*index*index
end
local function send(player)
 local p=profiles[player]
 if not p then return end
 local rankName,nextXP=rank(p.xp)
 remote:FireClient(player,"state",{xp=p.xp,rank=rankName,nextXP=nextXP,levels=p.levels})
end
local function save(player)
 local p=profiles[player]
 if not p then return end
 local ok,err=pcall(function()
  store:SetAsync("player_"..player.UserId,{xp=p.xp,levels=p.levels})
 end)
 if not ok then warn("Alien Breach progression save: "..tostring(err)) end
end
Players.PlayerAdded:Connect(function(player)
 local p={xp=0,levels={}}
 profiles[player]=p
 local ok,stored=pcall(function()return store:GetAsync("player_"..player.UserId)end)
 if ok and type(stored)=="table" then
  p.xp=math.max(0,tonumber(stored.xp) or 0)
  if type(stored.levels)=="table" then
   for id,level in pairs(stored.levels) do
    if valid[id] then p.levels[id]=math.clamp(math.floor(tonumber(level) or 3),1,5) end
   end
  end
 elseif not ok then warn("Alien Breach progression load: "..tostring(stored)) end
 if not player.Parent then return end
 for id,level in pairs(p.levels) do player:SetAttribute("ABWeaponLevel_"..id,level) end
 send(player)
end)
Players.PlayerRemoving:Connect(function(player)save(player);profiles[player]=nil end)
game:BindToClose(function()for player in pairs(profiles) do save(player) end end)
purchases.Event:Connect(function(player,id)
 local p=profiles[player]
 if p and valid[id] and not p.levels[id] then
  p.levels[id]=1
  player:SetAttribute("ABWeaponLevel_"..id,1)
  send(player)
 end
end)
kills.Event:Connect(function(player,kind)
 local p=profiles[player]
 if not p then return end
 p.xp+=kind=="boss" and 250 or kind=="armored" and 30 or 20
 send(player)
end)
remote.OnServerEvent:Connect(function(player,action,id)
 local p=profiles[player]
 if not p then return end
 if action=="sync" then send(player);return end
 if action~="upgrade" or type(id)~="string" or not valid[id] then return end
 local menuEvent=RS:FindFirstChild("AlienBreachMenuEvent")
 -- Ownership is checked against server-side menu data through a BindableFunction.
 local owns=RS:FindFirstChild("AlienBreachOwnsWeapon")
 if not owns or not owns:Invoke(player,id) then return end
 local level=p.levels[id] or 3
 if level>=5 then remote:FireClient(player,"notice","MAX WEAPON LEVEL");return end
 local credits=player:FindFirstChild("leaderstats")
 credits=credits and credits:FindFirstChild("Credits")
 if not credits or credits.Value<prices[level] then remote:FireClient(player,"notice","NOT ENOUGH CREDITS");return end
 credits.Value-=prices[level]
 level+=1
 p.levels[id]=level
 player:SetAttribute("ABWeaponLevel_"..id,level)
 send(player)
 if menuEvent then menuEvent:FireClient(player,"notice",string.upper(id).." UPGRADED TO LEVEL "..level) end
end)
