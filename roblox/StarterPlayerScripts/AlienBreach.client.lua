-- Alien Breach FPS - starter first-person weapon/HUD
-- Put in StarterPlayer > StarterPlayerScripts as a LocalScript.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local UserInputService=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local player=Players.LocalPlayer
player.CameraMode=Enum.CameraMode.LockFirstPerson
local remote=ReplicatedStorage:WaitForChild("AlienBreachFire")
local gui=Instance.new("ScreenGui")
gui.Name="AlienBreachHUD"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
gui.Parent=player:WaitForChild("PlayerGui")
local function label(name,text,position,size)
    local l=Instance.new("TextLabel")
    l.Name=name
    l.BackgroundTransparency=0.35
    l.BackgroundColor3=Color3.fromRGB(4,16,20)
    l.TextColor3=Color3.fromRGB(118,255,186)
    l.Font=Enum.Font.Code
    l.TextScaled=true
    l.Text=text
    l.Size=size
    l.Position=position
    l.Parent=gui
    return l
end
label("Title","ALIEN BREACH | AREA 51",UDim2.fromScale(0.02,0.03),UDim2.fromScale(0.29,0.06))
local status=label("Status","PULSE PISTOL",UDim2.fromScale(0.02,0.91),UDim2.fromScale(0.25,0.06))
local cross=label("Crosshair","+",UDim2.fromScale(0.49,0.47),UDim2.fromScale(0.02,0.05))
cross.BackgroundTransparency=1
local fire=Instance.new("TextButton")
fire.Name="TouchFire"
fire.Size=UDim2.fromScale(0.14,0.18)
fire.Position=UDim2.fromScale(0.83,0.74)
fire.BackgroundColor3=Color3.fromRGB(16,57,49)
fire.TextColor3=Color3.fromRGB(175,255,209)
fire.Font=Enum.Font.GothamBold
fire.TextScaled=true
fire.Text="FIRE"
fire.Visible=UserInputService.TouchEnabled
fire.Parent=gui
local ammo=25
local maxAmmo=25
local cooldown=0
local reloading=false
local function update()
    status.Text="PULSE PISTOL | "..ammo.."/"..maxAmmo.." | R: RELOAD"
end
local function reload()
    if reloading or ammo==maxAmmo then return end
    reloading=true
    status.Text="RELOADING..."
    task.wait(1.4)
    ammo=maxAmmo
    reloading=false
    update()
end
local function shoot()
    if reloading or os.clock()<cooldown then return end
    if ammo<=0 then task.spawn(reload) return end
    cooldown=os.clock()+0.2
    ammo-=1
    update()
    local camera=workspace.CurrentCamera
    if camera then remote:FireServer(camera.CFrame.Position,camera.CFrame.LookVector) end
end
UserInputService.InputBegan:Connect(function(input,processed)
    if processed then return end
    if input.UserInputType==Enum.UserInputType.MouseButton1 then shoot() end
    if input.KeyCode==Enum.KeyCode.R then task.spawn(reload) end
end)
fire.Activated:Connect(shoot)
update()
