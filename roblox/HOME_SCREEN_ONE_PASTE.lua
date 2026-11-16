-- Run in Roblox Studio Command Bar while NOT playing. Replaces only menu scripts.
local function install(parent,name,kind,source)
 local old=parent:FindFirstChild(name)
 if old then old:Destroy() end
 local o=Instance.new(kind)
 o.Name=name
 o.Source=source
 o.Parent=parent
end
install(game:GetService("ServerScriptService"),"AlienBreachMenu","Script",[========[-- Alien Breach menu economy. Place in ServerScriptService.
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
]========])
install(game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts"),"AlienBreachMenu","LocalScript",[========[-- Alien Breach FPS home screen. Place in StarterPlayerScripts as LocalScript.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
local event=RS:WaitForChild("AlienBreachMenuEvent")
local gui=Instance.new("ScreenGui")
gui.Name="AlienBreachHome"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
gui.DisplayOrder=100
gui.Parent=player:WaitForChild("PlayerGui")
local C={bg=Color3.fromRGB(6,14,19),panel=Color3.fromRGB(13,32,34),edge=Color3.fromRGB(58,116,98),green=Color3.fromRGB(105,232,167),white=Color3.fromRGB(223,246,235),muted=Color3.fromRGB(155,184,177),gold=Color3.fromRGB(250,214,125)}
local state={credits=500,owned={pulse=true},medkit=0,speed=0,slots={"pulse","","","medkit","speed"},stats={}}
local function make(class,parent,props)
 local o=Instance.new(class)
 for k,v in pairs(props or {}) do o[k]=v end
 o.Parent=parent
 return o
end
local function round(o,r) make("UICorner",o,{CornerRadius=UDim.new(0,r or 9)}) end
local function stroke(o) make("UIStroke",o,{Color=C.edge,Thickness=1,Transparency=0.15}) end
local function text(parent,value,size,color,bold)
 return make("TextLabel",parent,{BackgroundTransparency=1,Text=value,Font=bold and Enum.Font.ArialBold or Enum.Font.Arial,TextColor3=color or C.white,TextSize=size or 16,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,Size=UDim2.new(1,0,0,size and size+14 or 34)})
end
local function button(parent,value,fn)
 local b=make("TextButton",parent,{Text=value,Font=Enum.Font.ArialBold,TextSize=15,TextColor3=C.bg,BackgroundColor3=C.green,Size=UDim2.new(1,0,0,39),AutoButtonColor=true})
 round(b,6);b.Activated:Connect(fn);return b
end
local function vertical(parent,gap)
 make("UIListLayout",parent,{Padding=UDim.new(0,gap or 8),SortOrder=Enum.SortOrder.LayoutOrder})
end
local backdrop=make("Frame",gui,{Size=UDim2.fromScale(1,1),BackgroundColor3=C.bg,BorderSizePixel=0})
local title=text(backdrop,"ALIEN BREACH FPS  /  AREA 51",30,C.green,true)
title.Position=UDim2.fromScale(0.045,0.035);title.Size=UDim2.fromScale(0.91,0.075)
local subtitle=text(backdrop,"DEPLOYMENT COMMAND  •  SELECT YOUR NEXT MOVE",13,C.muted,true)
subtitle.Position=UDim2.fromScale(0.045,0.115)

-- Full-screen home navigation; only one panel is visible at a time.
local names={pulse="PULSE SMG",shotgun="SHOTGUN",rifle="ASSAULT RIFLE",viper="VIPER SMG",ar51="AR-51 ASSAULT RIFLE",phantom="PHANTOM SNIPER",titan="TITAN MINIGUN",plasma="PLASMA BLASTER",obliterator="OBLITERATOR X",laser="LEGENDARY LASER",medkit="MED-KIT",speed="SPEED BOOST"}
local catalog={{"shotgun",500,"▰"},{"rifle",750,"▰"},{"viper",1000,"▰"},{"ar51",1250,"▰"},{"phantom",1750,"⌖"},{"titan",2500,"▤"},{"plasma",3500,"✦"},{"obliterator",5000,"✹"},{"medkit",150,"✚"},{"speed",250,"⚡"}}
local weaponOrder={"pulse","shotgun","rifle","viper","ar51","phantom","titan","plasma","obliterator","laser"}
local root=make("Frame",backdrop,{BackgroundTransparency=1,Position=UDim2.fromScale(0.05,0.21),Size=UDim2.fromScale(0.9,0.72)})
local pages={}
local function page(id)
 local p=make("Frame",root,{Name=id,BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Visible=false})
 pages[id]=p
 return p
end
local home=page("Home")
local shop=page("Shop")
local load=page("Loadout")
local function show(id)
 for name,p in pairs(pages) do p.Visible=(name==id) end
end
local homeLayout=make("UIListLayout",home,{FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Center,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,18)})
local function homeCard(heading,description,action)
 local card=make("Frame",home,{Size=UDim2.new(0.3,0,0.62,0),BackgroundColor3=C.panel,BorderSizePixel=0})
 round(card,12);stroke(card)
 local pad=make("UIPadding",card,{PaddingTop=UDim.new(0,22),PaddingLeft=UDim.new(0,16),PaddingRight=UDim.new(0,16)})
 vertical(card,18)
 local h=text(card,heading,24,C.green,true);h.TextXAlignment=Enum.TextXAlignment.Center
 local desc=text(card,description,15,C.muted);desc.Size=UDim2.new(1,0,0,82);desc.TextXAlignment=Enum.TextXAlignment.Center
 button(card,"OPEN  ▶",action)
end
homeCard("▶  PLAY NOW","Enter the facility and start the breach.",function()
 event:FireServer("deploy")
 backdrop.Visible=false
 player.CameraMode=Enum.CameraMode.LockFirstPerson
 UIS.MouseIconEnabled=false
end)
homeCard("▣  SHOP","Purchase guns and field supplies.",function()show("Shop")end)
homeCard("▤  LOADOUT","Weapons, equipment and inventory.",function()show("Loadout")end)
local function topbar(parent,heading)
 local bar=make("Frame",parent,{Size=UDim2.new(1,0,0,62),BackgroundTransparency=1})
 local headingText=text(bar,heading,25,C.green,true);headingText.Size=UDim2.new(0.6,0,1,0)
 local credits=text(bar,"CREDITS: 500",17,C.gold,true)
 credits.Name="CreditsDisplay";credits.Position=UDim2.fromScale(0.65,0);credits.Size=UDim2.fromScale(0.35,1);credits.TextXAlignment=Enum.TextXAlignment.Right
 local back=make("TextButton",parent,{Text="◀  BACK TO HOME",Font=Enum.Font.ArialBold,TextSize=15,BackgroundColor3=C.edge,TextColor3=C.white,Position=UDim2.new(0,0,1,-43),Size=UDim2.fromOffset(195,38)})
 round(back,6);back.Activated:Connect(function()show("Home")end)
 return credits
end
local shopCredits=topbar(shop,"AREA 51  /  FIELD SUPPLIES")
local shopScroll=make("ScrollingFrame",shop,{Position=UDim2.fromOffset(0,72),Size=UDim2.new(1,0,1,-128),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=7,CanvasSize=UDim2.fromScale(0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y})
make("UIGridLayout",shopScroll,{CellSize=UDim2.new(0.31,0,0,155),CellPadding=UDim2.new(0.02,0,0,12),SortOrder=Enum.SortOrder.LayoutOrder})
local buyButtons={}
for _,p in ipairs(catalog) do
 local item=make("Frame",shopScroll,{BackgroundColor3=C.panel,BorderSizePixel=0})
 round(item,9);stroke(item)
 local icon=text(item,p[3],32,C.green,true);icon.Position=UDim2.fromScale(0.06,0.06);icon.Size=UDim2.fromScale(0.22,0.35)
 local n=text(item,names[p[1]],16,C.white,true);n.Position=UDim2.fromScale(0.3,0.07);n.Size=UDim2.fromScale(0.66,0.28)
 local cost=text(item,p[2].." CREDITS",14,C.gold,true);cost.Position=UDim2.fromScale(0.06,0.44)
 local buy=make("TextButton",item,{Text="BUY",Font=Enum.Font.ArialBold,TextSize=14,BackgroundColor3=C.green,TextColor3=C.bg,Position=UDim2.fromScale(0.06,0.72),Size=UDim2.fromScale(0.88,0.23)})
 round(buy,5);buy.Activated:Connect(function()event:FireServer("buy",p[1])end)
 buyButtons[p[1]]=buy
end
local loadCredits=topbar(load,"AREA 51  /  YOUR LOADOUT")
local tabs=make("Frame",load,{Position=UDim2.fromOffset(0,66),Size=UDim2.new(0.72,0,0,42),BackgroundTransparency=1})
make("UIListLayout",tabs,{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,9)})
local content=make("ScrollingFrame",load,{Position=UDim2.fromScale(0,0.17),Size=UDim2.fromScale(0.72,0.67),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=6,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.fromScale(0,0)})
vertical(content,8)
local statsPanel=make("Frame",load,{Position=UDim2.fromScale(0.75,0.17),Size=UDim2.fromScale(0.25,0.65),BackgroundColor3=C.panel})
round(statsPanel,8);stroke(statsPanel)
local statsText=text(statsPanel,"PLAYER STATS",17,C.green,true);statsText.Position=UDim2.fromOffset(12,12);statsText.Size=UDim2.new(1,-24,0,40)
local statsBody=text(statsPanel,"",15,C.white);statsBody.Position=UDim2.fromOffset(12,55);statsBody.Size=UDim2.new(1,-24,1,-65);statsBody.TextYAlignment=Enum.TextYAlignment.Top
local selected="guns"
local render
local function choices(index)
 if index==4 then return {"medkit"} end
 if index==5 then return {"speed"} end
 local a={""}
 for _,id in ipairs(weaponOrder) do if state.owned[id] then table.insert(a,id) end end
 if index==3 then
  if state.medkit>0 then table.insert(a,"medkit") end
  if state.speed>0 then table.insert(a,"speed") end
 end
 return a
end
local function clearContent()
 for _,child in ipairs(content:GetChildren()) do if not child:IsA("UIListLayout") then child:Destroy() end end
end
local function line(labelValue,color)
 local frame=make("Frame",content,{Size=UDim2.new(1,-12,0,57),BackgroundColor3=C.panel,BorderSizePixel=0})
 round(frame,7);stroke(frame)
 local l=text(frame,labelValue,15,color or C.white,true)
 l.Position=UDim2.fromOffset(12,8);l.Size=UDim2.new(1,-24,1,-16)
 return frame
end
render=function()
 shopCredits.Text="CREDITS: "..tostring(state.credits)
 loadCredits.Text=shopCredits.Text
 local st=state.stats or {}
 statsBody.Text="GAMES PLAYED: "..tostring(st.games or 0).."\n\nTOTAL KILLS: "..tostring(st.kills or 0).."\n\nBEST WAVE: "..tostring(st.bestWave or 0)
 for _,p in ipairs(catalog) do
  local b=buyButtons[p[1]]
  local owned=state.owned[p[1]]
  b.Text=owned and "OWNED" or "BUY"
  b.Active=not owned;b.BackgroundColor3=owned and C.muted or C.green
 end
 clearContent()
 if selected=="guns" then
  for _,id in ipairs(weaponOrder) do
   local owned=state.owned[id]
   local labelValue="▰  "..names[id].."    •    "..(owned and "OWNED" or id=="laser" and "CHESTS ONLY" or "LOCKED")
   line(labelValue,owned and C.green or C.muted)
  end
 elseif selected=="equipment" then
  line("✚  MED-KITS    •    OWNED: "..state.medkit,C.green)
  line("⚡  SPEED BOOSTS    •    OWNED: "..state.speed,C.green)
 elseif selected=="inventory" then
  for i=1,5 do
   local item=state.slots[i] or ""
   local kind=i<=2 and "GUN" or i==3 and "FLEX" or "EQUIPMENT"
   local frame=line("SLOT "..i.."  /  "..kind.."  /  "..(names[item] or "EMPTY"),C.white)
   local l=frame:FindFirstChildOfClass("TextLabel")
   if l then l.Size=UDim2.new(1,-130,1,-16) end
   local b=make("TextButton",frame,{Text="CHANGE",Font=Enum.Font.ArialBold,TextSize=13,BackgroundColor3=C.green,TextColor3=C.bg,Position=UDim2.new(1,-110,0,12),Size=UDim2.fromOffset(100,34)})
   round(b,5)
   b.Activated:Connect(function()
    local opts=choices(i)
    local current=table.find(opts,item) or 0
    event:FireServer("slot",i,opts[(current%#opts)+1])
   end)
  end
 end
end
for _,tab in ipairs({"guns","equipment","inventory"}) do
 local b=make("TextButton",tabs,{Text=string.upper(tab),Size=UDim2.new(0.3,0,1,0),BackgroundColor3=C.edge,TextColor3=C.white,Font=Enum.Font.ArialBold,TextSize=14})
 round(b,6);b.Activated:Connect(function()selected=tab;render()end)
end
local saveButton=make("TextButton",load,{Text="SAVE LOADOUT",Font=Enum.Font.ArialBold,TextSize=15,TextColor3=C.bg,BackgroundColor3=C.green,Position=UDim2.new(1,-195,1,-43),Size=UDim2.fromOffset(195,38)})
round(saveButton,6);saveButton.Activated:Connect(function()event:FireServer("save")end)
local notice=text(backdrop,"",14,C.gold,true);notice.Position=UDim2.fromScale(0.35,0.93);notice.Size=UDim2.fromScale(0.4,0.04);notice.TextXAlignment=Enum.TextXAlignment.Center
event.OnClientEvent:Connect(function(action,payload)
 if action=="state" then state=payload;render()
 elseif action=="notice" then notice.Text=tostring(payload) end
end)
local function hideHUD()
 for _,item in ipairs(player.PlayerGui:GetChildren()) do
  if item:IsA("ScreenGui") and item~=gui and item.Name=="AlienBreachHUD" then item.Enabled=not backdrop.Visible end
 end
end
player.PlayerGui.ChildAdded:Connect(function()task.defer(hideHUD)end)
backdrop:GetPropertyChangedSignal("Visible"):Connect(hideHUD)
player.CameraMode=Enum.CameraMode.Classic
show("Home")
render()
hideHUD()
event:FireServer("sync")
]========])
print("Alien Breach updated menu installed.")
