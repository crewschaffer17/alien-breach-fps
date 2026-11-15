-- Alien Breach FPS home screen. Place in StarterPlayerScripts as LocalScript.
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
local body=make("Frame",backdrop,{BackgroundTransparency=1,Position=UDim2.fromScale(0.035,0.2),Size=UDim2.fromScale(0.93,0.72)})
local grid=make("UIListLayout",body,{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,12),SortOrder=Enum.SortOrder.LayoutOrder,HorizontalAlignment=Enum.HorizontalAlignment.Center})
local function card(name,width)
 local f=make("Frame",body,{Name=name,Size=UDim2.new(width,-8,1,0),BackgroundColor3=C.panel,BorderSizePixel=0})
 round(f);stroke(f)
 local pad=make("UIPadding",f,{PaddingTop=UDim.new(0,16),PaddingBottom=UDim.new(0,12),PaddingLeft=UDim.new(0,14),PaddingRight=UDim.new(0,14)})
 vertical(f,10)
 return f
end
local playCard=card("PlayNow",0.24)
text(playCard,"▶  PLAY NOW",22,C.green,true)
text(playCard,"ENTER THE FACILITY",15,C.white,true)
text(playCard,"Survive the breaches. Earn credits. Find legendary weapons inside supply chests.",14,C.muted)
local playBtn=button(playCard,"DEPLOY  ▶",function()
 event:FireServer("deploy")
 backdrop.Visible=false
 player.CameraMode=Enum.CameraMode.LockFirstPerson
 UIS.MouseIconEnabled=false
end)
local shopCard=card("Shop",0.38)
text(shopCard,"▣  FIELD SUPPLIES",22,C.green,true)
local creditsLabel=text(shopCard,"CREDITS: 500",16,C.gold,true)
local shopScroll=make("ScrollingFrame",shopCard,{BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=5,Size=UDim2.new(1,0,1,-125),CanvasSize=UDim2.fromScale(0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y})
vertical(shopScroll,7)
local products={
 {"shotgun","SHOTGUN","▰",500},{"rifle","ASSAULT RIFLE","▰",750},{"viper","VIPER SMG","▰",1000},
 {"ar51","AR-51 ASSAULT RIFLE","▰",1250},{"phantom","PHANTOM SNIPER","⌖",1750},
 {"titan","TITAN MINIGUN","▤",2500},{"plasma","PLASMA BLASTER","✦",3500},
 {"obliterator","OBLITERATOR X","✹",5000},{"medkit","MED-KIT","✚",150},{"speed","SPEED BOOST","⚡",250}
}
local productButtons={}
for _,p in ipairs(products) do
 local line=make("Frame",shopScroll,{BackgroundColor3=Color3.fromRGB(20,45,46),Size=UDim2.new(1,-6,0,58),BorderSizePixel=0})
 round(line,6)
 local icon=text(line,p[3],24,C.green,true);icon.Position=UDim2.fromOffset(10,11);icon.Size=UDim2.fromOffset(30,36)
 local name=text(line,p[2],13,C.white,true);name.Position=UDim2.new(0,45,0,3);name.Size=UDim2.new(1,-154,0,25)
 local price=text(line,tostring(p[4]).." CR",12,C.gold,true);price.Position=UDim2.new(0,45,0,27);price.Size=UDim2.new(1,-154,0,25)
 local buy=make("TextButton",line,{Text="BUY",Font=Enum.Font.ArialBold,TextSize=12,BackgroundColor3=C.green,TextColor3=C.bg,Size=UDim2.fromOffset(83,33),Position=UDim2.new(1,-90,0,12)})
 round(buy,5);buy.Activated:Connect(function()event:FireServer("buy",p[1])end)
 productButtons[p[1]]=buy
end
local loadCard=card("Loadout",0.38)
text(loadCard,"▤  YOUR LOADOUT",22,C.green,true)
local stats=text(loadCard,"GAMES: 0   |   KILLS: 0",12,C.muted,true)
local tabs=make("Frame",loadCard,{BackgroundTransparency=1,Size=UDim2.new(1,0,0,36)})
make("UIListLayout",tabs,{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,5)})
local content=make("ScrollingFrame",loadCard,{BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=4,Size=UDim2.new(1,0,1,-155),AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.fromScale(0,0)})
vertical(content,8)
local selected="inventory"
local names={pulse="PULSE SMG",shotgun="SHOTGUN",rifle="ASSAULT RIFLE",viper="VIPER SMG",ar51="AR-51 ASSAULT RIFLE",phantom="PHANTOM SNIPER",titan="TITAN MINIGUN",plasma="PLASMA BLASTER",obliterator="OBLITERATOR X",laser="LEGENDARY LASER",medkit="MED-KIT",speed="SPEED BOOST"}
local function clear()
 for _,child in ipairs(content:GetChildren()) do if not child:IsA("UIListLayout") then child:Destroy() end end
end
local function choices(index)
 local a={""}
 if index==4 then return {"medkit"} end
 if index==5 then return {"speed"} end
 for _,id in ipairs({"pulse","shotgun","rifle","viper","ar51","phantom","titan","plasma","obliterator","laser"}) do
  if state.owned[id] then table.insert(a,id) end
 end
 if index==3 then
  if state.medkit>0 then table.insert(a,"medkit") end
  if state.speed>0 then table.insert(a,"speed") end
 end
 return a
end
local function render()
 creditsLabel.Text="CREDITS: "..tostring(state.credits)
 stats.Text="GAMES: "..tostring(state.stats.games or 0).."   |   KILLS: "..tostring(state.stats.kills or 0).."   |   BEST WAVE: "..tostring(state.stats.bestWave or 0)
 for _,p in ipairs(products) do
  local b=productButtons[p[1]]
  local owned=state.owned[p[1]]
  b.Text=owned and "OWNED" or "BUY"
  b.Active=not owned;b.BackgroundColor3=owned and C.muted or C.green
 end
 clear()
 if selected=="inventory" then
  text(content,"FIVE-SLOT FIELD INVENTORY",15,C.white,true)
  for i=1,5 do
   local slot=make("Frame",content,{Size=UDim2.new(1,-5,0,58),BackgroundColor3=Color3.fromRGB(21,44,46),BorderSizePixel=0})
   round(slot,6)
   local typeName=i<=2 and "GUN" or i==3 and "FLEX" or "EQUIPMENT"
   local current=state.slots[i] or ""
   local label=text(slot,tostring(i).."  "..typeName.."  /  "..(names[current] or "EMPTY"),13,C.white,true)
   label.Position=UDim2.fromOffset(8,4);label.Size=UDim2.new(1,-90,0,47)
   local b=make("TextButton",slot,{Text="CHANGE",Font=Enum.Font.ArialBold,TextSize=11,BackgroundColor3=C.green,TextColor3=C.bg,Size=UDim2.fromOffset(72,32),Position=UDim2.new(1,-79,0,13)})
   round(b,4)
   b.Activated:Connect(function()
    local opts=choices(i)
    local at=table.find(opts,current) or 0
    local nextItem=opts[(at%#opts)+1]
    event:FireServer("slot",i,nextItem)
   end)
  end
 elseif selected=="guns" then
  text(content,"OWNED WEAPONS",16,C.white,true)
  for _,id in ipairs({"pulse","shotgun","rifle","viper","ar51","phantom","titan","plasma","obliterator","laser"}) do
   if state.owned[id] then text(content,"▰  "..names[id],14,id=="laser" and C.gold or C.green,true) end
  end
 elseif selected=="equipment" then
  text(content,"✚  MED-KITS: "..state.medkit,16,C.white,true)
  text(content,"⚡  SPEED BOOSTS: "..state.speed,16,C.white,true)
  text(content,"LEGENDARY LASER: CHEST-ONLY REWARD",13,C.gold,true)
 end
end
for _,tab in ipairs({"inventory","guns","equipment"}) do
 local b=make("TextButton",tabs,{Text=string.upper(tab),Size=UDim2.new(0.32,0,1,0),BackgroundColor3=C.edge,TextColor3=C.white,Font=Enum.Font.ArialBold,TextSize=12})
 round(b,5);b.Activated:Connect(function()selected=tab;render()end)
end
event.OnClientEvent:Connect(function(action,payload)
 if action=="state" then state=payload;render()
 elseif action=="notice" then creditsLabel.Text=tostring(payload) end
end)
event:FireServer("sync")
render()
-- Keep the existing first-person controls and HUD disabled until deployment.
local function hideHUD()
 for _,item in ipairs(player.PlayerGui:GetChildren()) do
  if item:IsA("ScreenGui") and item~=gui and item.Name=="AlienBreachHUD" then item.Enabled=not backdrop.Visible end
 end
end
player.PlayerGui.ChildAdded:Connect(function()task.defer(hideHUD)end)
backdrop:GetPropertyChangedSignal("Visible"):Connect(hideHUD)
player.CameraMode=Enum.CameraMode.Classic
hideHUD()
