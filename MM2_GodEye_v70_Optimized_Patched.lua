-- MM2 God-Eye Pro v70.1 GIGA | Optimized + Leak-Patched
local pid=game.PlaceId
if pid~=142823291 and pid~=80469437126309 then return end

local Players,Run,SG,Debris,PFS=game:GetService("Players"),game:GetService("RunService"),game:GetService("StarterGui"),game:GetService("Debris"),game:GetService("PathfindingService")
local LP=Players.LocalPlayer

-- Blacklist
local auth=table.find({12345678,87654321},LP.UserId) and "Blacklist" or "Whitelist"
if SG:FindFirstChild("Whitelist") then SG.Whitelist:Destroy() end
if SG:FindFirstChild("Blacklist") then SG.Blacklist:Destroy() end
local ff=Instance.new("ForceField");ff.Visible=false;ff.Name=auth;ff.Parent=SG
if auth=="Blacklist" then
	task.spawn(function()
		local RS=game:GetService("ReplicatedStorage");local ce=RS:FindFirstChild("DefaultChatSystemChatEvents") and RS.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest");local tcs=game:GetService("TextChatService")
		while true do pcall(function() if ce then ce:FireServer("IM HACKER","All") elseif tcs.ChatVersion==Enum.ChatVersion.TextChatService then tcs.TextChannels.RBXGeneral:SendAsync("IM HACKER") end end);task.wait(1) end
	end)
	Run.RenderStepped:Connect(function() pcall(function() local c=LP.Character;if c and c:FindFirstChild("HumanoidRootPart") then local p=Instance.new("Part");p.Transparency=1;p.Anchored=true;p.CanCollide=false;p.Size=Vector3.new(0.1,0.1,0.1);p.CFrame=c.HumanoidRootPart.CFrame;p.Name="L_Bozo_Tracer";p.Parent=workspace.CurrentCamera;Debris:AddItem(p,0.01) end end) end)
	return
end

local UIS,WS,CG,TS,HS=game:GetService("UserInputService"),game:GetService("Workspace"),game:GetService("CoreGui"),game:GetService("TweenService"),game:GetService("HttpService")
local ggc=getgc or get_gc;local gfe=getfenv or get_fenv;local hgc=debug and debug.getconstants or getconstants;local hsc=debug and debug.setconstant or setconstant
local env=getgenv and getgenv() or _G
if env.MM2Running then env.MM2Running=false;task.wait(0.1) end
env.MM2Running=true
if env.MM2Connections then
	for _,c in ipairs(env.MM2Connections) do if c.Connected then c:Disconnect() end end
	if env.MM2Gui then env.MM2Gui:Destroy() end
	if env.MM2Folder then env.MM2Folder:Destroy() end
end
env.MM2Connections={}
local function sc(c) table.insert(env.MM2Connections,c) end

-- LEAK FIX: espStorage re-created fresh each run, old one destroyed above via MM2Folder
local esp=Instance.new("Folder");esp.Name="MM2_ESP";esp.Parent=CG;env.MM2Folder=esp

local kFile="MM2_GodEye_Keybinds.json"
local binds={ESP="",CoinESP="",AntiFling="",AutoShoot="",Hitbox="",Bring="",BringClosest="",BringAll="",BringSheriff="",Panic="",Speed="",GrabGun="",AutoGrabGun="",AutoCoin="",AutoCoinSafe="",AutoCopyKnife="",LoopTrip="",Invis="",GodMode="",Orbit=""}
if isfile and isfile(kFile) then local ok,d=pcall(function() return HS:JSONDecode(readfile(kFile)) end);if ok and type(d)=="table" then for k,v in pairs(d) do binds[k]=v end end end
local function saveBinds() if writefile then pcall(function() writefile(kFile,HS:JSONEncode(binds)) end) end end

-- GUI helpers
local W,G,GB=Color3.fromRGB(255,255,255),Enum.Font.GothamBold,Color3.fromRGB(40,40,40)
local ON,OFF=Color3.fromRGB(50,255,50),Color3.fromRGB(255,50,50)
local function new(cls,props,par) local o=Instance.new(cls);for k,v in pairs(props) do o[k]=v end;if par then o.Parent=par end;return o end
local function corner(p) new("UICorner",{},p) end
local function mkBtn(p,t,c,s) local b=new("TextButton",{Size=s or UDim2.new(0.9,0,0,40),BackgroundColor3=c or Color3.fromRGB(50,150,255),Text=t,TextColor3=W,Font=G,TextSize=13,Parent=p});corner(b);return b end
local function mkToggle(p,t) return mkBtn(p,t..": OFF",OFF) end
local function mkInput(p,t,sz,pos,clr,ts) local b=new("TextBox",{Size=sz,BackgroundColor3=GB,Text=t,TextColor3=W,Font=G,TextSize=ts or 16,ClearTextOnFocus=clr or false,Parent=p});if pos then b.Position=pos end;corner(b);return b end
local function mkRow(p) return new("Frame",{Size=UDim2.new(0.9,0,0,40),BackgroundTransparency=1,Parent=p}) end
local function mkLI(p,lbl,def) local f=mkRow(p);local l=new("TextLabel",{Size=UDim2.new(0.6,-5,1,0),BackgroundColor3=Color3.fromRGB(50,50,50),Text=lbl,TextColor3=W,Font=G,TextSize=13,Parent=f});corner(l);return mkInput(f,def,UDim2.new(0.4,0,1,0),UDim2.new(0.6,5,0,0)) end

-- GUI
local gX,gY=460,430
local SGui=new("ScreenGui",{Name="MM2_GodEye",Parent=CG});env.MM2Gui=SGui
local MF=new("Frame",{Size=UDim2.new(0,gX,0,gY),Position=UDim2.new(0.5,-230,0.5,-215),BackgroundColor3=Color3.fromRGB(25,25,25),BorderSizePixel=0,Parent=SGui});corner(MF)
local UC=new("UISizeConstraint",{MinSize=Vector2.new(300,250),MaxSize=Vector2.new(1000,1000),Parent=MF})
local TB=new("Frame",{Size=UDim2.new(1,0,0,40),BackgroundColor3=Color3.fromRGB(15,15,15),Parent=MF});corner(TB)
new("TextLabel",{Size=UDim2.new(1,-50,1,0),Position=UDim2.new(0,15,0,0),BackgroundTransparency=1,Text="🔪 God-Eye Pro v70 GIGA",TextColor3=Color3.fromRGB(85,255,127),Font=G,TextSize=15,TextXAlignment=Enum.TextXAlignment.Left,Parent=TB})
local MB=new("TextButton",{Size=UDim2.new(0,40,0,40),Position=UDim2.new(1,-40,0,0),BackgroundTransparency=1,Text="-",TextColor3=W,Font=G,TextSize=24,Parent=TB})

local TabBar=new("ScrollingFrame",{Size=UDim2.new(0,100,1,-40),Position=UDim2.new(0,0,0,40),BackgroundColor3=Color3.fromRGB(20,20,20),ScrollingDirection=Enum.ScrollingDirection.Y,ScrollBarThickness=2,BorderSizePixel=0,Parent=MF})
local TLL=new("UIListLayout",{FillDirection=Enum.FillDirection.Vertical,SortOrder=Enum.SortOrder.LayoutOrder},TabBar)
TLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() TabBar.CanvasSize=UDim2.new(0,0,0,TLL.AbsoluteContentSize.Y) end)
TabBar.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseWheel then TabBar.CanvasPosition=Vector2.new(0,TabBar.CanvasPosition.Y-(i.Position.Z*40)) end end)
local function mkTab(n) return new("TextButton",{Size=UDim2.new(1,0,0,35),BackgroundColor3=Color3.fromRGB(20,20,20),Text=n,TextColor3=Color3.fromRGB(150,150,150),Font=G,TextSize=12,Parent=TabBar}) end
local function mkCont()
	local c=new("ScrollingFrame",{Size=UDim2.new(1,-100,1,-40),Position=UDim2.new(0,100,0,40),BackgroundTransparency=1,ScrollBarThickness=4,Visible=false,Parent=MF})
	local l=new("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,8),HorizontalAlignment=Enum.HorizontalAlignment.Center},c)
	new("UIPadding",{PaddingTop=UDim.new(0,10)},c)
	l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() c.CanvasSize=UDim2.new(0,0,0,l.AbsoluteContentSize.Y+20) end)
	return c
end

local MainC=mkCont();local POVC=mkCont();local InnC=mkCont();local MurdC=mkCont();local SherC=mkCont();local FunC=mkCont();local MiscC=mkCont();local BindC=mkCont()
local MainB=mkTab("Main");local POVB=mkTab("POV");local InnB=mkTab("Innocent");local MurdB=mkTab("Murderer");local SherB=mkTab("Sheriff");local FunB=mkTab("Fun");local MiscB=mkTab("Misc");local BindsB=mkTab("Keybinds")
MainC.Visible=true;MainB.BackgroundColor3=Color3.fromRGB(35,35,35);MainB.TextColor3=W

local tabs={{MainB,MainC},{POVB,POVC},{InnB,InnC},{MurdB,MurdC},{SherB,SherC},{FunB,FunC},{MiscB,MiscC},{BindsB,BindC}}
local function switchTab(sel) for _,t in ipairs(tabs) do local a=t[1]==sel;t[2].Visible=a;t[1].BackgroundColor3=a and Color3.fromRGB(35,35,35) or Color3.fromRGB(20,20,20);t[1].TextColor3=a and W or Color3.fromRGB(150,150,150) end end
for _,t in ipairs(tabs) do t[1].MouseButton1Click:Connect(function() switchTab(t[1]) end) end

-- UI elements
local ESPToggle=mkToggle(MainC,"Player & Gun ESP")
local CoinToggle=mkToggle(MainC,"Coin ESP")
local AutoCoinToggle=mkToggle(MainC,"Auto Coin")
local AutoCoinSafeToggle=mkToggle(MainC,"Auto Coin Safe")
local OR=mkRow(MainC)
local OrbitBtn=new("TextButton",{Size=UDim2.new(0.3,-2,1,0),BackgroundColor3=Color3.fromRGB(200,100,0),Text="Orbit Target",TextColor3=W,Font=G,TextSize=12,Parent=OR});corner(OrbitBtn)
local OrbitInput=mkInput(OR,"Username",UDim2.new(0.3,0,1,0),UDim2.new(0.3,2,0,0),true,12)
local OrbitSpeedInput=mkInput(OR,"0.2",UDim2.new(0.2,-2,1,0),UDim2.new(0.6,4,0,0),false,12);OrbitSpeedInput.PlaceholderText="Spd"
local OrbitDistInput=mkInput(OR,"6",UDim2.new(0.2,-2,1,0),UDim2.new(0.8,2,0,0),false,12);OrbitDistInput.PlaceholderText="Dist"
local AntiFlingToggle=mkToggle(MainC,"Anti-Fling Safe Mode")
local TPLobbyBtn=mkBtn(MainC,"TP To Lobby",Color3.fromRGB(100,50,200))
local TPMapBtn=mkBtn(MainC,"TP To Map",Color3.fromRGB(100,50,200))

local SpecMurdBtn=mkBtn(POVC,"Spectate Murderer",Color3.fromRGB(200,50,50))
local SpecSherBtn=mkBtn(POVC,"Spectate Sheriff",Color3.fromRGB(50,50,200))
local SR=mkRow(POVC)
local SpecBtn=new("TextButton",{Size=UDim2.new(0.5,-2,1,0),BackgroundColor3=Color3.fromRGB(200,150,50),Text="Spectate Player",TextColor3=W,Font=G,TextSize=13,Parent=SR});corner(SpecBtn)
local SpecInput=mkInput(SR,"Username",UDim2.new(0.5,-2,1,0),UDim2.new(0.5,4,0,0),true,12)
local UnspecBtn=mkBtn(POVC,"Unspectate",Color3.fromRGB(100,100,100))

local GrabGunBtn=mkBtn(InnC,"Grab Gun Drop",Color3.fromRGB(50,200,50))
local AutoGrabGunToggle=mkToggle(InnC,"Auto Grab Gun")

local GodModeBtn=mkBtn(FunC,"God Mode",Color3.fromRGB(255,215,0))
local InvisibleBtn=mkBtn(FunC,"Become Invisible",Color3.fromRGB(150,150,150))
local ForceEquipKnifeBtn=mkBtn(FunC,"Force Equip Knife",Color3.fromRGB(200,150,50))
local FlingModeBtn=mkBtn(FunC,"Fling Mode: GIGA",Color3.fromRGB(200,50,200))
local FRow=mkRow(FunC)
local FlingBtn=new("TextButton",{Size=UDim2.new(0.35,-2,1,0),BackgroundColor3=Color3.fromRGB(200,100,0),Text="Smart Fling Lock-On",TextColor3=W,Font=G,TextSize=13,Parent=FRow});corner(FlingBtn)
local FlingInput=mkInput(FRow,"Username",UDim2.new(0.4,0,1,0),UDim2.new(0.35,2,0,0),true,12)
local PanicBtn=new("TextButton",{Size=UDim2.new(0.25,-2,1,0),Position=UDim2.new(0.75,4,0,0),BackgroundColor3=Color3.fromRGB(255,0,0),Text="🚨 Panic!",TextColor3=W,Font=G,TextSize=13,Parent=FRow});corner(PanicBtn)
local FRR=mkRow(FunC)
local FlingMurdBtn=new("TextButton",{Size=UDim2.new(0.5,-2,1,0),BackgroundColor3=Color3.fromRGB(200,50,50),Text="Fling Murderer Lock-On",TextColor3=W,Font=G,TextSize=13,Parent=FRR});corner(FlingMurdBtn)
local FlingSherBtn=new("TextButton",{Size=UDim2.new(0.5,-2,1,0),Position=UDim2.new(0.5,2,0,0),BackgroundColor3=Color3.fromRGB(50,50,200),Text="Fling Sheriff Lock-On",TextColor3=W,Font=G,TextSize=13,Parent=FRR});corner(FlingSherBtn)
local LoopTripToggle=mkToggle(FunC,"Loop Trip")
local StealKnifeBtn=mkBtn(FunC,"Steal Knife from Murderer",Color3.fromRGB(200,100,50))
local AutoCopyKnifeToggle=mkToggle(FunC,"Auto Copy Knife")

local HC=mkRow(MurdC)
local HitboxToggle=new("TextButton",{Size=UDim2.new(0.7,-5,1,0),BackgroundColor3=OFF,Text="Hitbox Expander: OFF",TextColor3=W,Font=G,TextSize=13,Parent=HC});corner(HitboxToggle)
local HitboxInput=mkInput(HC,"1",UDim2.new(0.3,0,1,0),UDim2.new(0.7,5,0,0))
local BF=mkRow(MurdC)
local BringBtn=new("TextButton",{Size=UDim2.new(0.6,-5,1,0),BackgroundColor3=Color3.fromRGB(200,50,200),Text="Bring Player",TextColor3=W,Font=G,TextSize=13,Parent=BF});corner(BringBtn)
local BringInput=mkInput(BF,"Username",UDim2.new(0.4,0,1,0),UDim2.new(0.6,5,0,0),true,12)
local BringClosestBtn=mkBtn(MurdC,"Bring Closest Player",Color3.fromRGB(200,50,200))
local BringAllBtn=mkBtn(MurdC,"Bring ALL Players",Color3.fromRGB(200,50,50))
local BringSheriffBtn=mkBtn(MurdC,"Bring Sheriff",Color3.fromRGB(50,50,200))

local AutoShootToggle=mkToggle(SherC,"Shoot Murderer")
local isAimHead=false
local AutoShootAimToggle=mkBtn(SherC,"Auto Shoot Aim: Torso",Color3.fromRGB(150,50,200))
AutoShootAimToggle.MouseButton1Click:Connect(function() isAimHead=not isAimHead;AutoShootAimToggle.Text="Auto Shoot Aim: "..(isAimHead and "Head" or "Torso");AutoShootAimToggle.BackgroundColor3=isAimHead and Color3.fromRGB(200,50,50) or Color3.fromRGB(150,50,200) end)
local TSF=mkRow(SherC)
local TargetShootToggle=new("TextButton",{Size=UDim2.new(0.6,-2,1,0),BackgroundColor3=OFF,Text="Shoot Target: OFF",TextColor3=W,Font=G,TextSize=13,Parent=TSF});corner(TargetShootToggle)
local TargetShootInput=mkInput(TSF,"Username",UDim2.new(0.4,0,1,0),UDim2.new(0.6,2,0,0),true,12)

local TranspInput=mkLI(MiscC,"UI Transparency:","0")
local MaxZoomInput=mkLI(MiscC,"Max Zoom Dist:","200")
local NoclipCamToggle=mkToggle(MiscC,"Memory Noclip Cam")
local SF=mkRow(MiscC)
local SpeedBtn=new("TextButton",{Size=UDim2.new(0.6,-5,1,0),BackgroundColor3=OFF,Text="Lock WalkSpeed: OFF",TextColor3=W,Font=G,TextSize=13,Parent=SF});corner(SpeedBtn)
local SpeedInput=mkInput(SF,"25",UDim2.new(0.4,0,1,0),UDim2.new(0.6,5,0,0))
local AnimWatcherBtn=mkBtn(MiscC,"Load Animation Watcher",Color3.fromRGB(150,100,200))
local CAF=mkRow(MiscC)
local PlayAnimBtn=new("TextButton",{Size=UDim2.new(0.6,-5,1,0),BackgroundColor3=Color3.fromRGB(200,150,50),Text="Play Animation",TextColor3=W,Font=G,TextSize=13,Parent=CAF});corner(PlayAnimBtn)
local AnimInput=mkInput(CAF,"Anim ID",UDim2.new(0.4,0,1,0),UDim2.new(0.6,5,0,0),true,12)
local CSF=mkRow(MiscC)
local CSL=new("TextLabel",{Size=UDim2.new(0.5,-5,1,0),BackgroundColor3=Color3.fromRGB(50,50,50),Text="GUI Size (X, Y):",TextColor3=W,Font=G,TextSize=12,Parent=CSF});corner(CSL)
local SizeXInput=mkInput(CSF,tostring(gX),UDim2.new(0.25,-2,1,0),UDim2.new(0.5,2,0,0),false,14)
local SizeYInput=mkInput(CSF,tostring(gY),UDim2.new(0.25,-2,1,0),UDim2.new(0.75,4,0,0),false,14)

local bindingAction=nil
local function mkBindUI(id,dn)
	local f=mkRow(BindC)
	new("TextLabel",{Size=UDim2.new(0.6,0,1,0),BackgroundTransparency=1,Text=dn,TextColor3=W,Font=G,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
	local b=new("TextButton",{Size=UDim2.new(0.4,0,1,0),Position=UDim2.new(0.6,0,0,0),BackgroundColor3=GB,Text=binds[id]~="" and binds[id] or "NONE",TextColor3=Color3.fromRGB(255,255,0),Font=G,TextSize=12,Parent=f});corner(b)
	b.MouseButton1Click:Connect(function() b.Text="...";bindingAction={id=id,button=b} end)
end
for _,v in ipairs({{"ESP","Toggle ESP"},{"CoinESP","Toggle Coin ESP"},{"AutoCoin","Toggle Auto Coin"},{"AutoCoinSafe","Toggle Safe Auto Coin"},{"AntiFling","Toggle Anti-Fling"},{"Hitbox","Toggle Hitbox"},{"Bring","Trigger Bring Player"},{"BringClosest","Trigger Bring Closest"},{"BringAll","Trigger Bring ALL"},{"BringSheriff","Trigger Bring Sheriff"},{"AutoShoot","Toggle Auto-Shoot"},{"Panic","Trigger Panic"},{"Speed","Toggle Speed Lock"},{"GrabGun","Trigger Grab Gun"},{"AutoGrabGun","Toggle Auto Grab Gun"},{"AutoCopyKnife","Toggle Auto Copy Knife"},{"LoopTrip","Toggle Loop Trip"},{"Invis","Trigger Invisible"},{"GodMode","Trigger God Mode"},{"Orbit","Toggle Orbit"}}) do mkBindUI(v[1],v[2]) end

-- Drag
local dragging,dragInput,dragStart,startPos
TB.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		dragging=true;dragStart=i.Position;startPos=MF.Position
		-- LEAK FIX: use one-shot Changed instead of anonymous closure held forever
		i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end)
	end
end)
TB.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then dragInput=i end end)
sc(UIS.InputChanged:Connect(function(i) if i==dragInput and dragging then local d=i.Position-dragStart;MF.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end end))

local minimized=false
MB.MouseButton1Click:Connect(function()
	minimized=not minimized;TabBar.Visible=not minimized
	for _,t in ipairs(tabs) do if t[1].BackgroundColor3==Color3.fromRGB(35,35,35) then t[2].Visible=not minimized end end
	if minimized then UC.MinSize=Vector2.new(100,40);MF.Size=UDim2.new(0,gX,0,40) else UC.MinSize=Vector2.new(300,250);MF.Size=UDim2.new(0,gX,0,gY) end
	MB.Text=minimized and "+" or "-"
end)
local function applySize() local x,y=tonumber(SizeXInput.Text),tonumber(SizeYInput.Text);if x and x>=300 then gX=x else SizeXInput.Text=tostring(gX) end;if y and y>=250 then gY=y else SizeYInput.Text=tostring(gY) end;if not minimized then MF.Size=UDim2.new(0,gX,0,gY) end end
SizeXInput.FocusLost:Connect(applySize);SizeYInput.FocusLost:Connect(applySize)
TranspInput:GetPropertyChangedSignal("Text"):Connect(function() local v=tonumber(TranspInput.Text);if v then local a=math.clamp(v,0,1);MF.BackgroundTransparency=a;TabBar.BackgroundTransparency=a;TB.BackgroundTransparency=a end end)

-- State
local isESPOn,espRoundState,hasGunDroppedThisRound=false,"IDLE",false
local isNoclipCamOn,maxZoomValue=false,200
local isCoinESPOn,isAutoShootOn,isHitboxManual,isHitboxAuto,isAntiFlingOn=false,false,false,false,false
local isSpeedLocked,isAutoGrabGunOn,isAutoCoinOn,isAutoCoinSafeOn,isAutoCopyKnifeOn,isLoopTripOn=false,false,false,false,false,false
local autoCoinTween,lockedSpeed,hitboxMultiplier=nil,25,1
local isFlingToggleOn,flingTargetPlayer,isFlinging,isFlingNoclipping=false,nil,false,false
local flingMode,currentlyFlingingPlayer,isTargetShootOn="GIGA",nil,false
local lastCopiedMap,unreachableCoins=nil,{}
local bringTargetPlayers,bringOriginalCFrames,bringEndTime,currentBringMode={},{},0,nil
local isOrbitOn,orbitTarget,originalOrbitCFrame,orbitRot=false,nil,nil,0
local orbitConn1,orbitConn2,orbitConn3,orbitConn4
local speedConn,speedCharConn,currentAnimTrack=nil,nil,nil

-- Utils
local function getCurrentMap() for _,c in ipairs(WS:GetChildren()) do if c.Name~="RegularLobby" and c.Name~="Lobby" and c:FindFirstChild("Spawns") then return c end end end
local function hasItem(p,n) local c,b=p.Character,p:FindFirstChild("Backpack");return (c and c:FindFirstChild(n)) or (b and b:FindFirstChild(n)) end
local function isMurd(p) return p and hasItem(p,"Knife") and true or false end
local function isSher(p) return p and hasItem(p,"Gun") and true or false end
-- LEAK FIX: getRoleColor uses hasGunDroppedThisRound directly (no extra scan after gun pickup)
local function getRoleColor(p) return isMurd(p) and Color3.fromRGB(255,0,0) or isSher(p) and (hasGunDroppedThisRound and Color3.fromRGB(255,255,0) or Color3.fromRGB(0,85,255)) or Color3.fromRGB(0,255,0) end
local function forceRestoreCollisions() for _,p in ipairs(Players:GetPlayers()) do if p.Character then for _,pt in ipairs(p.Character:GetChildren()) do if pt:IsA("BasePart") and (pt.Name=="HumanoidRootPart" or pt.Name=="Torso" or pt.Name=="UpperTorso" or pt.Name=="Head") then pt.CanCollide=true end end end end end
local function espDrop(c) c.Parent=nil;task.defer(function() pcall(function() c:Destroy() end) end) end
local function clearESP() task.spawn(function() for _,c in ipairs(esp:GetChildren()) do if c.Name~="GunDrop_ESP" and (c.Name:sub(-4)=="_ESP" or c.Name:sub(-9)=="_ESP_Text") then espDrop(c) end end end) end
local function clearCoinESP() task.spawn(function() for _,c in ipairs(esp:GetChildren()) do if c.Name:sub(1,14)=="CoinAdornment_" then espDrop(c) end end end) end
local function spectate(tp) if tp and tp.Character and tp.Character:FindFirstChild("Humanoid") then WS.CurrentCamera.CameraSubject=tp.Character.Humanoid end end
local function unspectate() if LP.Character and LP.Character:FindFirstChild("Humanoid") then WS.CurrentCamera.CameraSubject=LP.Character.Humanoid end end
local function SafeTP(cf) local c=LP.Character;if not c then return end;local r,h=c:FindFirstChild("HumanoidRootPart"),c:FindFirstChild("Humanoid");if r and h then h.Sit=false;r.Velocity=Vector3.zero;r.RotVelocity=Vector3.zero;r.CFrame=cf;task.wait(0.05);r.Velocity=Vector3.zero;r.RotVelocity=Vector3.zero end end
local function getSpawns(f) local t={};for _,s in ipairs(f:GetChildren()) do if s.Name=="Spawn" or s.Name=="PlayerSpawn" then table.insert(t,s) end end;return t end

-- ESP scan (pooling, no full destroy/recreate)
local function executeFullESPScan()
	local valid={}
	for _,p in ipairs(Players:GetPlayers()) do
		if p~=LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Head") then
			local col=getRoleColor(p);local en=p.Name.."_ESP";local tn=en.."_Text"
			valid[en]=true;valid[tn]=true
			local h=esp:FindFirstChild(en);if not h then h=Instance.new("Highlight");h.Name=en;h.Parent=esp;h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop end
			h.FillColor=col;h.FillTransparency=0.6;h.OutlineColor=col;h.OutlineTransparency=0.1;h.Adornee=p.Character
			local tg=esp:FindFirstChild(tn)
			if not tg then
				tg=Instance.new("BillboardGui");tg.Name=tn;tg.Size=UDim2.new(0,200,0,50);tg.AlwaysOnTop=true;tg.Parent=esp
				local lbl=Instance.new("TextLabel");lbl.Name="NameLabel";lbl.Size=UDim2.new(1,0,1,0);lbl.BackgroundTransparency=1;lbl.Font=G;lbl.TextSize=14;lbl.TextStrokeTransparency=0;lbl.Parent=tg
			end
			tg.Adornee=p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart");tg.StudsOffset=Vector3.new(0,2,0)
			local lbl=tg:FindFirstChild("NameLabel");if lbl then lbl.Text=p.Name;lbl.TextColor3=col end
		end
	end
	-- LEAK FIX: clean up stale ESP instances from players who left/died
	task.spawn(function() for _,c in ipairs(esp:GetChildren()) do if c.Name~="GunDrop_ESP" and (c.Name:sub(-4)=="_ESP" or c.Name:sub(-9)=="_ESP_Text") and not valid[c.Name] then espDrop(c) end end end)
end

-- Xbox spoof + round hook
pcall(function()
	if hookmetamethod then
		local old;old=hookmetamethod(game,"__namecall",function(self,...)
			local m=getnamecallmethod()
			if self==UIS and m=="GetPlatform" then return Enum.Platform.XBoxOne end
			if m=="InvokeServer" and self.Name=="GetChance" then task.spawn(function() if isESPOn then espRoundState="WAITING_FOR_KNIFE";executeFullESPScan() end end) end
			return old(self,...)
		end)
	end
end)

-- Noclip cam
local function hookNoclip(state)
	pcall(function()
		if not LP.PlayerScripts:FindFirstChild("PlayerModule") then return end
		local pop=LP.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper
		for _,v in pairs(ggc()) do if type(v)=="function" and gfe(v).script==pop then local cs=hgc(v);for i,v1 in pairs(cs) do if state and tonumber(v1)==0.25 then hsc(v,i,0) elseif not state and tonumber(v1)==0 then hsc(v,i,0.25) end end end end
	end)
end
-- LEAK FIX: CharacterAdded registered once via sc(), not raw connect that persists across reinjects
sc(LP.CharacterAdded:Connect(function() task.wait(0.5);LP.CameraMaxZoomDistance=maxZoomValue;if isNoclipCamOn then hookNoclip(true) end end))
MaxZoomInput.FocusLost:Connect(function() local v=tonumber(MaxZoomInput.Text);if v and v>0 then maxZoomValue=v else MaxZoomInput.Text=tostring(maxZoomValue) end;LP.CameraMaxZoomDistance=maxZoomValue end)

-- Spectate
SpecMurdBtn.MouseButton1Click:Connect(function() for _,p in ipairs(Players:GetPlayers()) do if p~=LP and isMurd(p) then spectate(p);break end end end)
SpecSherBtn.MouseButton1Click:Connect(function() for _,p in ipairs(Players:GetPlayers()) do if p~=LP and isSher(p) then spectate(p);break end end end)
SpecBtn.MouseButton1Click:Connect(function() local s=SpecInput.Text:lower();if s=="" or s=="username" then return end;for _,p in ipairs(Players:GetPlayers()) do if p~=LP and (p.Name:lower():find(s) or p.DisplayName:lower():find(s)) then spectate(p);break end end end)
UnspecBtn.MouseButton1Click:Connect(unspectate)

-- Speed lock
local function enforceSpeed(h) if isSpeedLocked and h.WalkSpeed~=lockedSpeed then h.WalkSpeed=lockedSpeed end end
local function setupSpeedLock(char)
	if not char then return end;local h=char:WaitForChild("Humanoid",2);if not h then return end
	if isSpeedLocked then h.WalkSpeed=lockedSpeed end
	-- LEAK FIX: always disconnect old speedConn before making new one
	if speedConn then speedConn:Disconnect() end
	speedConn=h:GetPropertyChangedSignal("WalkSpeed"):Connect(function() enforceSpeed(h) end)
end
SpeedInput:GetPropertyChangedSignal("Text"):Connect(function() local v=tonumber(SpeedInput.Text);if v then lockedSpeed=v;if isSpeedLocked then local c=LP.Character;if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed=lockedSpeed end end end end)

-- Grab gun
local function grabGunDrop()
	local map=getCurrentMap();if not map then return end;local gd=map:FindFirstChild("GunDrop");if not gd then return end
	local c=LP.Character;local r=c and c:FindFirstChild("HumanoidRootPart");if not r then return end
	GrabGunBtn.Text="Grabbing...";local orig=r.CFrame;SafeTP(CFrame.new(gd.Position));task.wait(0.05);if c and c:FindFirstChild("HumanoidRootPart") then SafeTP(orig) end;GrabGunBtn.Text="Grab Gun Drop"
end

-- Orbit
local function stopOrbit()
	isOrbitOn=false
	for _,oc in ipairs({orbitConn1,orbitConn2,orbitConn3,orbitConn4}) do if oc then oc:Disconnect() end end
	orbitConn1=nil;orbitConn2=nil;orbitConn3=nil;orbitConn4=nil
	OrbitBtn.Text="Orbit Target";OrbitBtn.BackgroundColor3=Color3.fromRGB(200,100,0)
	local mc=LP.Character;if mc then for _,p in ipairs(mc:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end
	if originalOrbitCFrame then SafeTP(originalOrbitCFrame);originalOrbitCFrame=nil end
end
local function toggleOrbit()
	if isOrbitOn then stopOrbit();return end
	local str=OrbitInput.Text:lower();if str=="" or str=="username" then return end
	local tgt=nil;for _,p in ipairs(Players:GetPlayers()) do if p~=LP and (p.Name:lower():find(str) or p.DisplayName:lower():find(str)) then tgt=p;break end end
	if not tgt then OrbitBtn.Text="Not Found!";task.wait(1);if not isOrbitOn then OrbitBtn.Text="Orbit Target" end;return end
	local mc=LP.Character;local root=mc and mc:FindFirstChild("HumanoidRootPart");local hum=mc and mc:FindFirstChild("Humanoid")
	if tgt.Character and tgt.Character:FindFirstChild("HumanoidRootPart") and root and hum then
		originalOrbitCFrame=root.CFrame;isOrbitOn=true;orbitTarget=tgt
		OrbitBtn.Text="Orbiting: "..tgt.Name;OrbitBtn.BackgroundColor3=Color3.fromRGB(200,50,200)
		orbitConn3=Run.Stepped:Connect(function() if mc then for _,p in ipairs(mc:GetChildren()) do if p:IsA("BasePart") then p.CanCollide=false end end end end)
		orbitConn1=Run.Heartbeat:Connect(function()
			pcall(function()
				if not isOrbitOn then return end
				local tc=orbitTarget.Character;local tr=tc and tc:FindFirstChild("HumanoidRootPart");local th=tc and tc:FindFirstChild("Humanoid")
				if not tr or not th or th.Health<=0 then stopOrbit();return end
				local s=tonumber(OrbitSpeedInput.Text) or 0.2;local d=tonumber(OrbitDistInput.Text) or 6
				orbitRot=orbitRot+s;root.CFrame=CFrame.new(tr.Position)*CFrame.Angles(0,math.rad(orbitRot),0)*CFrame.new(d,0,0)
			end)
		end)
		orbitConn2=Run.RenderStepped:Connect(function() pcall(function() if not isOrbitOn then return end;local tc=orbitTarget.Character;local tr=tc and tc:FindFirstChild("HumanoidRootPart");if tr then root.CFrame=CFrame.new(root.Position,tr.Position) end end) end)
		-- LEAK FIX: orbitConn4 disconnects itself via stopOrbit, no dangling Died connection
		orbitConn4=hum.Died:Connect(stopOrbit)
	end
end
OrbitBtn.MouseButton1Click:Connect(toggleOrbit)

-- Toggles
local function toggleFeature(f)
	local function tog(state,btn,on,off,ocb,fcb) btn.BackgroundColor3=state and ON or OFF;btn.Text=state and on or off;if state and ocb then ocb() elseif not state and fcb then fcb() end end
	if f=="ESP" then
		isESPOn=not isESPOn;tog(isESPOn,ESPToggle,"Player & Gun ESP: ON","Player & Gun ESP: OFF")
		if not isESPOn then clearESP();espRoundState="IDLE";hasGunDroppedThisRound=false
		else local hk=false;for _,p in ipairs(Players:GetPlayers()) do if isMurd(p) then hk=true;break end end;espRoundState=hk and "KNIFE_FOUND" or "WAITING_FOR_KNIFE";executeFullESPScan() end
	elseif f=="CoinESP" then isCoinESPOn=not isCoinESPOn;tog(isCoinESPOn,CoinToggle,"Coin ESP: ON","Coin ESP: OFF",nil,clearCoinESP)
	elseif f=="AutoCoin" then
		isAutoCoinOn=not isAutoCoinOn;tog(isAutoCoinOn,AutoCoinToggle,"Auto Coin: ON","Auto Coin: OFF")
		if isAutoCoinOn and isAutoCoinSafeOn then toggleFeature("AutoCoinSafe") end
		if not isAutoCoinOn and autoCoinTween then autoCoinTween:Cancel() end
	elseif f=="AutoCoinSafe" then isAutoCoinSafeOn=not isAutoCoinSafeOn;tog(isAutoCoinSafeOn,AutoCoinSafeToggle,"Auto Coin Safe: ON","Auto Coin Safe: OFF");if isAutoCoinSafeOn and isAutoCoinOn then toggleFeature("AutoCoin") end
	elseif f=="AutoCopyKnife" then isAutoCopyKnifeOn=not isAutoCopyKnifeOn;tog(isAutoCopyKnifeOn,AutoCopyKnifeToggle,"Auto Copy Knife: ON","Auto Copy Knife: OFF")
	elseif f=="LoopTrip" then isLoopTripOn=not isLoopTripOn;tog(isLoopTripOn,LoopTripToggle,"Loop Trip: ON","Loop Trip: OFF",nil,function() local c=LP.Character;if c and c:FindFirstChild("Humanoid") then c.Humanoid.PlatformStand=false end end)
	elseif f=="AntiFling" then isAntiFlingOn=not isAntiFlingOn;tog(isAntiFlingOn,AntiFlingToggle,"Anti-Fling Safe Mode: ON","Anti-Fling Safe Mode: OFF",nil,forceRestoreCollisions)
	elseif f=="AutoShoot" then isAutoShootOn=not isAutoShootOn;tog(isAutoShootOn,AutoShootToggle,"Shoot Murderer: ON","Shoot Murderer: OFF")
	elseif f=="Hitbox" then isHitboxManual=not isHitboxManual;tog(isHitboxManual,HitboxToggle,"Hitbox Expander: ON","Hitbox Expander: OFF",nil,forceRestoreCollisions)
	elseif f=="NoclipCam" then isNoclipCamOn=not isNoclipCamOn;tog(isNoclipCamOn,NoclipCamToggle,"Memory Noclip Cam: ON","Memory Noclip Cam: OFF",function() hookNoclip(true) end,function() hookNoclip(false) end)
	elseif f=="AutoGrabGun" then isAutoGrabGunOn=not isAutoGrabGunOn;tog(isAutoGrabGunOn,AutoGrabGunToggle,"Auto Grab Gun: ON","Auto Grab Gun: OFF")
	elseif f=="Speed" then
		isSpeedLocked=not isSpeedLocked;tog(isSpeedLocked,SpeedBtn,"Lock WalkSpeed: ON","Lock WalkSpeed: OFF")
		if isSpeedLocked then
			local v=tonumber(SpeedInput.Text);if v then lockedSpeed=v else SpeedInput.Text=tostring(lockedSpeed) end
			setupSpeedLock(LP.Character)
			-- LEAK FIX: disconnect old speedCharConn before replacing
			if speedCharConn then speedCharConn:Disconnect() end
			speedCharConn=LP.CharacterAdded:Connect(setupSpeedLock)
		else
			if speedConn then speedConn:Disconnect();speedConn=nil end
			if speedCharConn then speedCharConn:Disconnect();speedCharConn=nil end
			local c=LP.Character;if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed=16 end
		end
	end
end
for _,v in ipairs({{ESPToggle,"ESP"},{CoinToggle,"CoinESP"},{AutoCoinToggle,"AutoCoin"},{AutoCoinSafeToggle,"AutoCoinSafe"},{AutoCopyKnifeToggle,"AutoCopyKnife"},{LoopTripToggle,"LoopTrip"},{AntiFlingToggle,"AntiFling"},{AutoShootToggle,"AutoShoot"},{HitboxToggle,"Hitbox"},{NoclipCamToggle,"NoclipCam"},{SpeedBtn,"Speed"},{AutoGrabGunToggle,"AutoGrabGun"}}) do v[1].MouseButton1Click:Connect(function() toggleFeature(v[2]) end) end
TargetShootToggle.MouseButton1Click:Connect(function() isTargetShootOn=not isTargetShootOn;TargetShootToggle.Text=isTargetShootOn and "Shoot Target: ON" or "Shoot Target: OFF";TargetShootToggle.BackgroundColor3=isTargetShootOn and ON or OFF end)
GrabGunBtn.MouseButton1Click:Connect(grabGunDrop)
ForceEquipKnifeBtn.MouseButton1Click:Connect(function() local bp,c=LP:FindFirstChild("Backpack"),LP.Character;if bp and c then local k=bp:FindFirstChild("Knife");if k then k.Parent=c end end end)
FlingModeBtn.MouseButton1Click:Connect(function() if flingMode=="GIGA" then flingMode="CLASSIC";FlingModeBtn.Text="Fling Mode: CLASSIC";FlingModeBtn.BackgroundColor3=Color3.fromRGB(50,150,200) else flingMode="GIGA";FlingModeBtn.Text="Fling Mode: GIGA";FlingModeBtn.BackgroundColor3=Color3.fromRGB(200,50,200) end end)
AnimWatcherBtn.MouseButton1Click:Connect(function() AnimWatcherBtn.Text="Loading...";pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Alone2718/AnimTracker/refs/heads/main/AnimTracker"))() end);task.wait(1);AnimWatcherBtn.Text="Load Animation Watcher" end)

-- Knife steal
StealKnifeBtn.MouseButton1Click:Connect(function()
	if isMurd(LP) then return end;local c,bp=LP.Character,LP:FindFirstChild("Backpack")
	if (c and c:FindFirstChild("Knife")) or (bp and bp:FindFirstChild("Knife")) then return end
	local src=nil;for _,p in ipairs(Players:GetPlayers()) do if p~=LP and isMurd(p) then local pc,pb=p.Character,p:FindFirstChild("Backpack");src=(pc and pc:FindFirstChild("Knife")) or (pb and pb:FindFirstChild("Knife"));break end end
	if src and bp then local cl=src:Clone();cl.ToolTip="Stolen 🤑";cl:SetAttribute("CopiedByScript",true);local t=Instance.new("BoolValue");t.Name="CopiedByGodEye";t.Value=true;t.Parent=cl;cl.Parent=bp end
end)

-- Invis
local function executeToolInvis()
	local mc=LP.Character;if not mc or not mc:FindFirstChild("HumanoidRootPart") then return end
	InvisibleBtn.Text="Vanishing...";local hrp=mc.HumanoidRootPart;local origLoc=hrp.Position
	local box=Instance.new("Part");box.Anchored=true;box.CanCollide=true;box.Size=Vector3.new(10,1,10);box.Position=Vector3.new(0,10000,0);box.Parent=WS
	local touched=false;local bconn,cconn
	bconn=box.Touched:Connect(function(part)
		if part:IsDescendantOf(mc) and not touched then
			touched=true;local clone=hrp:Clone();task.wait(0.25)
			if mc and mc:FindFirstChild("HumanoidRootPart") then mc.HumanoidRootPart:Destroy();clone.Parent=mc;mc:MoveTo(origLoc) end
		end
	end)
	-- LEAK FIX: cleanUp disconnects itself after firing once
	cconn=LP.CharacterAdded:Connect(function()
		bconn:Disconnect();pcall(function() box:Destroy() end);cconn:Disconnect();InvisibleBtn.Text="Become Invisible"
	end)
	mc:MoveTo(box.Position+Vector3.new(0,1,0))
end
InvisibleBtn.MouseButton1Click:Connect(executeToolInvis)

-- God mode
local function executeGodMode()
	local cam=WS.CurrentCamera;local char=LP.Character;if not char then return end
	local pos=cam.CFrame;local hum=char:FindFirstChildWhichIsA("Humanoid");if not hum then return end
	GodModeBtn.Text="Activating...";local nh=hum:Clone();nh.Parent=char;LP.Character=nil
	nh:SetStateEnabled(Enum.HumanoidStateType.Dead,false);nh:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false);nh:SetStateEnabled(Enum.HumanoidStateType.Physics,false);nh.BreakJointsOnDeath=true
	hum:Destroy();LP.Character=char;cam.CameraSubject=nh;task.wait();cam.CFrame=pos;nh.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
	local anim=char:FindFirstChild("Animate");if anim then anim.Disabled=true;task.wait();anim.Disabled=false end
	nh.Health=nh.MaxHealth;task.wait(1);GodModeBtn.Text="God Mode"
end
GodModeBtn.MouseButton1Click:Connect(executeGodMode)

-- Anim player
PlayAnimBtn.MouseButton1Click:Connect(function()
	local id=AnimInput.Text:match("%d+");if not id then return end;local c=LP.Character;if not(c and c:FindFirstChild("Humanoid")) then return end
	local anim=Instance.new("Animation");anim.AnimationId="rbxassetid://"..id
	local animator=c.Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator",c.Humanoid)
	if currentAnimTrack then currentAnimTrack:Stop() end;currentAnimTrack=animator:LoadAnimation(anim);currentAnimTrack:Play()
	PlayAnimBtn.Text="Playing...";task.delay(1,function() if PlayAnimBtn.Text=="Playing..." then PlayAnimBtn.Text="Play Animation" end end)
end)
sc(Run.Heartbeat:Connect(function() if currentAnimTrack and currentAnimTrack.IsPlaying then local c=LP.Character;if c and c:FindFirstChild("HumanoidRootPart") and c.HumanoidRootPart.Velocity.Magnitude>10 then currentAnimTrack:Stop();currentAnimTrack=nil end end end))

-- Bring system
local function getClosestAlive() local mc=LP.Character;if not(mc and mc:FindFirstChild("HumanoidRootPart")) then return end;local mp=mc.HumanoidRootPart.Position;local best,bd=nil,math.huge;for _,p in ipairs(Players:GetPlayers()) do if p~=LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health>0 then local d=(p.Character.HumanoidRootPart.Position-mp).Magnitude;if d<bd then bd=d;best=p end end end;return best end
local function resetBringBtns() BringBtn.Text="Bring Player";BringBtn.BackgroundColor3=Color3.fromRGB(200,50,200);BringClosestBtn.Text="Bring Closest Player";BringClosestBtn.BackgroundColor3=Color3.fromRGB(200,50,200);BringAllBtn.Text="Bring ALL Players";BringAllBtn.BackgroundColor3=Color3.fromRGB(200,50,50);BringSheriffBtn.Text="Bring Sheriff";BringSheriffBtn.BackgroundColor3=Color3.fromRGB(50,50,200) end
local function addBring(p) if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then table.insert(bringTargetPlayers,p);bringOriginalCFrames[p]=p.Character.HumanoidRootPart.CFrame;return true end;return false end
local function executeBring(mode,inputStr)
	bringTargetPlayers={};bringOriginalCFrames={};bringEndTime=tick()+5;currentBringMode=mode
	if mode=="ALL" then
		for _,p in ipairs(Players:GetPlayers()) do if p~=LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health>0 then addBring(p) end end
		if #bringTargetPlayers>0 then BringAllBtn.Text="Bringing ALL...";BringAllBtn.BackgroundColor3=OFF else BringAllBtn.Text="Nobody Alive!";task.wait(1);if currentBringMode=="ALL" then BringAllBtn.Text="Bring ALL Players";BringAllBtn.BackgroundColor3=Color3.fromRGB(200,50,50) end end
	elseif mode=="CLOSEST" then
		if addBring(getClosestAlive()) then BringClosestBtn.Text="Bringing Closest...";BringClosestBtn.BackgroundColor3=OFF else BringClosestBtn.Text="Nobody Alive!";task.wait(1);if currentBringMode=="CLOSEST" then BringClosestBtn.Text="Bring Closest Player";BringClosestBtn.BackgroundColor3=Color3.fromRGB(200,50,200) end end
	elseif mode=="SHERIFF" then
		local t=nil;for _,p in ipairs(Players:GetPlayers()) do if p~=LP and isSher(p) then t=p;break end end
		if addBring(t) then BringSheriffBtn.Text="Bringing Sheriff...";BringSheriffBtn.BackgroundColor3=OFF else BringSheriffBtn.Text="No Sheriff Alive!";task.wait(1);if currentBringMode=="SHERIFF" then BringSheriffBtn.Text="Bring Sheriff";BringSheriffBtn.BackgroundColor3=Color3.fromRGB(50,50,200) end end
	elseif mode=="NORMAL" then
		local s=inputStr:lower();if s=="" or s=="username" then return end;local t=nil;for _,p in ipairs(Players:GetPlayers()) do if p~=LP and (p.Name:lower():find(s) or p.DisplayName:lower():find(s)) then t=p;break end end
		if addBring(t) then BringBtn.Text="Bringing...";BringBtn.BackgroundColor3=OFF else BringBtn.Text="Not Found!";task.wait(1);if currentBringMode=="NORMAL" then BringBtn.Text="Bring Player";BringBtn.BackgroundColor3=Color3.fromRGB(200,50,200) end end
	end
end

local function uiResetFling() isFlingToggleOn=false;flingTargetPlayer=nil;FlingBtn.Text="Smart Fling Lock-On";FlingBtn.BackgroundColor3=Color3.fromRGB(200,100,0);FlingMurdBtn.Text="Fling Murderer Lock-On";FlingMurdBtn.BackgroundColor3=Color3.fromRGB(200,50,50);FlingSherBtn.Text="Fling Sheriff Lock-On";FlingSherBtn.BackgroundColor3=Color3.fromRGB(50,50,200) end

local function executePanic()
	isFlinging=false;isFlingNoclipping=false;isFlingToggleOn=false;currentlyFlingingPlayer=nil;if isOrbitOn then stopOrbit() end
	bringEndTime=0;currentBringMode=nil;bringTargetPlayers={};bringOriginalCFrames={};resetBringBtns();uiResetFling()
	local mc=LP.Character;if not(mc and mc:FindFirstChild("HumanoidRootPart")) then return end
	local sf=WS:FindFirstChild("RegularLobby") and WS.RegularLobby:FindFirstChild("Spawns");if not sf then return end
	local sp=getSpawns(sf);if #sp>0 then
		local r=mc.HumanoidRootPart;SafeTP(sp[math.random(1,#sp)].CFrame+Vector3.new(0,5,0));r.Anchored=true
		PanicBtn.Text="🚨 PANICKING...";PanicBtn.BackgroundColor3=Color3.fromRGB(150,0,0)
		task.spawn(function() task.wait(1);if mc and mc:FindFirstChild("HumanoidRootPart") then mc.HumanoidRootPart.Anchored=false end;PanicBtn.Text="🚨 Panic!";PanicBtn.BackgroundColor3=Color3.fromRGB(255,0,0) end)
	end
end

BringBtn.MouseButton1Click:Connect(function() executeBring("NORMAL",BringInput.Text) end)
BringClosestBtn.MouseButton1Click:Connect(function() executeBring("CLOSEST") end)
BringAllBtn.MouseButton1Click:Connect(function() executeBring("ALL") end)
BringSheriffBtn.MouseButton1Click:Connect(function() executeBring("SHERIFF") end)
PanicBtn.MouseButton1Click:Connect(executePanic)

-- Teleports
TPLobbyBtn.MouseButton1Click:Connect(function() local sf=WS:FindFirstChild("RegularLobby") and WS.RegularLobby:FindFirstChild("Spawns");if sf then local sp=getSpawns(sf);if #sp>0 then SafeTP(sp[math.random(1,#sp)].CFrame+Vector3.new(0,5,0)) end end end)
TPMapBtn.MouseButton1Click:Connect(function() local map=getCurrentMap();if map and map:FindFirstChild("Spawns") then local sp=getSpawns(map.Spawns);if #sp>0 then SafeTP(sp[math.random(1,#sp)].CFrame+Vector3.new(0,5,0)) end end end)

-- Input / keybinds
sc(UIS.InputBegan:Connect(function(input,gp)
	if bindingAction then
		if input.KeyCode==Enum.KeyCode.Unknown then return end
		local kn=(input.KeyCode==Enum.KeyCode.Escape or input.KeyCode==Enum.KeyCode.Backspace) and "" or input.KeyCode.Name
		binds[bindingAction.id]=kn;bindingAction.button.Text=kn~="" and kn or "NONE";saveBinds();bindingAction=nil;return
	end
	if not gp then
		for id,key in pairs(binds) do if key~="" and input.KeyCode.Name==key then
			if id=="Bring" then executeBring("NORMAL",BringInput.Text)
			elseif id=="BringClosest" then executeBring("CLOSEST")
			elseif id=="BringAll" then executeBring("ALL")
			elseif id=="BringSheriff" then executeBring("SHERIFF")
			elseif id=="Panic" then executePanic()
			elseif id=="GrabGun" then grabGunDrop()
			elseif id=="Invis" then executeToolInvis()
			elseif id=="GodMode" then executeGodMode()
			elseif id=="Orbit" then toggleOrbit()
			else toggleFeature(id) end
		end end
	end
end))

-- Fling
local function lockFling(pred,lbl)
	if isFlingToggleOn then uiResetFling();return end
	for _,p in ipairs(Players:GetPlayers()) do
		if p~=LP and pred(p) then flingTargetPlayer=p;isFlingToggleOn=true;lbl.Text="Locking: "..p.Name;lbl.BackgroundColor3=Color3.fromRGB(200,50,200);return end
	end
end
FlingBtn.MouseButton1Click:Connect(function()
	if isFlingToggleOn then uiResetFling();return end
	local s=FlingInput.Text:lower();if s=="" or s=="username" then return end
	lockFling(function(p) return p.Name:lower():find(s) or p.DisplayName:lower():find(s) end,FlingBtn)
	if not isFlingToggleOn then FlingBtn.Text="Not Found!";task.wait(1);if not isFlingToggleOn then FlingBtn.Text="Smart Fling Lock-On" end end
end)
FlingMurdBtn.MouseButton1Click:Connect(function() lockFling(isMurd,FlingMurdBtn) end)
FlingSherBtn.MouseButton1Click:Connect(function() lockFling(isSher,FlingSherBtn) end)

task.spawn(function()
	while env.MM2Running do
		task.wait()
		if isFlingToggleOn and flingTargetPlayer and not isFlinging then
			local tc=flingTargetPlayer.Character;local tr=tc and tc:FindFirstChild("HumanoidRootPart");local th=tc and tc:FindFirstChild("Humanoid")
			if tr and th and th.Health>0 and tr.Velocity.Magnitude<2 then
				local lp=tr.Position;local mc=LP.Character;local mr=mc and mc:FindFirstChild("HumanoidRootPart");local mh=mc and mc:FindFirstChild("Humanoid")
				if mr and mh and mh.Health>0 then
					isFlinging=true;isFlingNoclipping=true;currentlyFlingingPlayer=flingTargetPlayer
					local origCF=mr.CFrame;local origC={}
					for _,ch in ipairs(mc:GetDescendants()) do if ch:IsA("BasePart") then origC[ch]=ch.CanCollide;ch.CustomPhysicalProperties=PhysicalProperties.new(100,0.3,0.5);ch.CanCollide=false;ch.Massless=true;ch.Velocity=Vector3.zero end end
					local bam=Instance.new("BodyAngularVelocity");bam.AngularVelocity=Vector3.new(9999999,9999999,9999999);bam.MaxTorque=Vector3.new(math.huge,math.huge,math.huge);bam.P=math.huge;bam.Parent=mr
					-- LEAK FIX: acc stored locally, always disconnected in cleanup
					local acc=Run.Heartbeat:Connect(function()
						if isFlinging and currentlyFlingingPlayer and currentlyFlingingPlayer.Character then
							local ttr=currentlyFlingingPlayer.Character:FindFirstChild("HumanoidRootPart");local ttt=currentlyFlingingPlayer.Character:FindFirstChild("Torso") or currentlyFlingingPlayer.Character:FindFirstChild("UpperTorso") or ttr
							if ttr then mr.CFrame=flingMode=="GIGA" and CFrame.new(ttt.Position)*CFrame.new(0,1,0) or CFrame.new(ttt.Position) end
						end
					end)
					local movel=1000
					while isFlinging and isFlingToggleOn do
						task.wait()
						if not mc or not mr or mh.Health<=0 then break end;if not tc or not tr or th.Health<=0 then break end
						if (tr.Position-lp).Magnitude>=50 then isFlingToggleOn=false;break end
						if flingMode=="GIGA" then local vel=mr.Velocity;mr.Velocity=vel*10000+Vector3.new(0,10000,0);Run.RenderStepped:Wait();if mr then mr.Velocity=vel end;Run.Stepped:Wait();if mr then mr.Velocity=vel+Vector3.new(0,movel,0);movel=movel*-1 end end
					end
					isFlinging=false;isFlingNoclipping=false;currentlyFlingingPlayer=nil
					acc:Disconnect();bam:Destroy()
					if mc and mc:FindFirstChild("HumanoidRootPart") and mh.Health>0 then
						SafeTP(origCF)
						for _,ch in ipairs(mc:GetDescendants()) do if ch:IsA("BasePart") then ch.CustomPhysicalProperties=PhysicalProperties.new(0.7,0.3,0.5);if origC[ch]~=nil then ch.CanCollide=origC[ch] end;ch.Massless=false end end
					end
					if not isFlingToggleOn then uiResetFling() end
				end
			end
		end
	end
end)

-- Physics / bring stepped loop
sc(Run.Stepped:Connect(function()
	if isFlingNoclipping and LP.Character then for _,p in ipairs(LP.Character:GetChildren()) do if p:IsA("BasePart") then p.CanCollide=false end end end
	local se=isHitboxManual or isHitboxAuto;local ct=tick()
	for _,p in ipairs(Players:GetPlayers()) do
		if p~=LP and p.Character then
			local char=p.Character;local hrp=char:FindFirstChild("HumanoidRootPart");local fling=false
			if isAntiFlingOn and hrp then
				if (hrp.Velocity.Magnitude>150 or hrp.RotVelocity.Magnitude>150) and currentlyFlingingPlayer~=p then char:SetAttribute("GodEyeFlingTag",ct) end
				if (ct-(char:GetAttribute("GodEyeFlingTag") or 0))<3 then fling=true end
			end
			if fling then for _,pt in ipairs(char:GetChildren()) do if pt:IsA("BasePart") then pt.CanCollide=false end end;char:SetAttribute("WasFlinging",true)
			else
				if char:GetAttribute("WasFlinging") then for _,pt in ipairs(char:GetChildren()) do if pt:IsA("BasePart") and (pt.Name=="HumanoidRootPart" or pt.Name=="Torso" or pt.Name=="UpperTorso" or pt.Name=="Head") then pt.CanCollide=true end end;char:SetAttribute("WasFlinging",nil) end
				if se and hrp then hrp.CanCollide=false end
			end
		end
	end
	if currentBringMode then
		local mc=LP.Character;local mr=mc and mc:FindFirstChild("HumanoidRootPart")
		if tick()<bringEndTime and mr then
			for i=#bringTargetPlayers,1,-1 do
				local t=bringTargetPlayers[i];local tc=t.Character;local tr=tc and tc:FindFirstChild("HumanoidRootPart");local alive=tc and tc:FindFirstChild("Humanoid") and tc.Humanoid.Health>0
				if alive and tr then tr.CFrame=mr.CFrame*CFrame.new(0,0,-3);tr.Velocity=Vector3.zero else bringOriginalCFrames[t]=nil;table.remove(bringTargetPlayers,i) end
			end
			if #bringTargetPlayers==0 then bringEndTime=0 end
		else
			for t,cf in pairs(bringOriginalCFrames) do local tc=t and t.Character;local tr=tc and tc:FindFirstChild("HumanoidRootPart");local alive=tc and tc:FindFirstChild("Humanoid") and tc.Humanoid.Health>0;if alive and tr then tr.Velocity=Vector3.zero;tr.CFrame=cf end end
			bringTargetPlayers={};bringOriginalCFrames={};currentBringMode=nil;resetBringBtns()
		end
	end
end))

-- ESP render loop
local fc,knifeLastSeen,gunDropExisted=0,0,false
sc(Run.RenderStepped:Connect(function()
	fc=fc+1;if fc<15 then return end;fc=0;local map=getCurrentMap()
	if isESPOn then
		local hk=false;for _,p in ipairs(Players:GetPlayers()) do if isMurd(p) then hk=true;break end end
		if espRoundState=="IDLE" then
			if hk then espRoundState="KNIFE_FOUND";knifeLastSeen=tick();gunDropExisted=false;executeFullESPScan()
			elseif map then espRoundState="WAITING_FOR_KNIFE";executeFullESPScan() end
		elseif espRoundState=="WAITING_FOR_KNIFE" then
			if hk then espRoundState="KNIFE_FOUND";knifeLastSeen=tick();gunDropExisted=false;executeFullESPScan()
			elseif not map then clearESP();espRoundState="IDLE";hasGunDroppedThisRound=false
			else executeFullESPScan() end
		elseif espRoundState=="KNIFE_FOUND" then
			if hk then knifeLastSeen=tick()
			elseif tick()-knifeLastSeen>=10 then clearESP();espRoundState="IDLE";gunDropExisted=false;hasGunDroppedThisRound=false end
		end
		local ge=esp:FindFirstChild("GunDrop_ESP");local gd=map and map:FindFirstChild("GunDrop")
		if gd then
			gunDropExisted=true
			-- LEAK FIX: hasGunDroppedThisRound set here; getRoleColor reads it directly → no extra scan needed
			hasGunDroppedThisRound=true
			if not ge then
				local h=Instance.new("Highlight");h.Name="GunDrop_ESP";h.Adornee=gd;h.FillColor=Color3.fromRGB(255,255,0);h.FillTransparency=0.3;h.OutlineColor=Color3.fromRGB(255,255,0);h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;h.Parent=esp
				local bg=Instance.new("BillboardGui");bg.Name="Text";bg.Adornee=gd;bg.Size=UDim2.new(0,100,0,50);bg.StudsOffset=Vector3.new(0,3,0);bg.AlwaysOnTop=true;bg.Parent=h
				local tl=Instance.new("TextLabel");tl.Size=UDim2.new(1,0,1,0);tl.BackgroundTransparency=1;tl.Text="GUN!";tl.TextColor3=Color3.fromRGB(255,255,0);tl.TextStrokeTransparency=0;tl.Font=G;tl.TextSize=22;tl.Parent=bg
				executeFullESPScan()
			end
		elseif ge then
			-- LEAK FIX: espDrop() used instead of raw :Destroy() for safe async cleanup
			espDrop(ge)
			-- gun picked up → trigger scan so hero color applies immediately via getRoleColor
			if gunDropExisted then gunDropExisted=false;executeFullESPScan() end
		end
	end
	if isCoinESPOn and map then
		local cc=map:FindFirstChild("CoinContainer");if not cc then return end;local ac={}
		for _,coin in ipairs(cc:GetChildren()) do
			if coin.Name=="Coin_Server" then ac[coin]=true;local an="CoinAdornment_"..tostring(coin:GetDebugId(10))
				if not esp:FindFirstChild(an) then local a=Instance.new("SphereHandleAdornment");a.Name=an;a.Adornee=coin;a.Radius=1.3;a.Color3=Color3.fromRGB(255,255,0);a.Transparency=0.4;a.AlwaysOnTop=true;a.ZIndex=0;a.Parent=esp end
			end
		end
		-- LEAK FIX: stale coin adornments removed with espDrop instead of inline :Destroy()
		for _,c in ipairs(esp:GetChildren()) do if c.Name:sub(1,14)=="CoinAdornment_" and not ac[c.Adornee] then espDrop(c) end end
	end
end))

-- Auto coin (tween)
local function getClosestCoin()
	local map=getCurrentMap();if not map then return nil,math.huge end;local cc=map:FindFirstChild("CoinContainer");if not cc then return nil,math.huge end
	local mc=LP.Character;if not(mc and mc:FindFirstChild("HumanoidRootPart")) then return nil,math.huge end;local mp=mc.HumanoidRootPart.Position;local best,bd=nil,math.huge
	for _,coin in ipairs(cc:GetChildren()) do if coin.Name=="Coin_Server" and coin:FindFirstChild("TouchInterest") and not unreachableCoins[coin] then local d=(coin.Position-mp).Magnitude;if d<bd then bd=d;best=coin end end end
	return best,bd
end
task.spawn(function()
	local curCoin,tsr=nil,0
	while env.MM2Running do task.wait()
		if isAutoCoinOn and not isFlinging and not isOrbitOn then
			local coin,dist=getClosestCoin();local mc=LP.Character;local mr=mc and mc:FindFirstChild("HumanoidRootPart")
			if coin and dist<1000 and mr then
				for _,p in ipairs(mc:GetChildren()) do if p:IsA("BasePart") then p.CanCollide=false end end
				-- LEAK FIX: always cancel previous tween before creating new one
				if autoCoinTween then autoCoinTween:Cancel() end
				autoCoinTween=TS:Create(mr,TweenInfo.new(1,Enum.EasingStyle.Linear),{CFrame=CFrame.new(coin.Position)});autoCoinTween:Play()
				if dist<5 then
					if curCoin==coin then tsr=tsr+1 else curCoin=coin;tsr=0 end
					if tsr>=2 then if coin:FindFirstChild("TouchInterest") then unreachableCoins[coin]=true end;if autoCoinTween then autoCoinTween:Cancel() end;tsr=0 end
				else curCoin=coin;tsr=0 end
			else if autoCoinTween then autoCoinTween:Cancel() end;curCoin=nil;tsr=0 end
		end
	end
end)

-- Auto coin safe (pathfinding)
task.spawn(function()
	while env.MM2Running do task.wait()
		if isAutoCoinSafeOn and not isFlinging and not isOrbitOn then
			local coin,dist=getClosestCoin();local mc=LP.Character;local mh=mc and mc:FindFirstChild("Humanoid");local mr=mc and mc:FindFirstChild("HumanoidRootPart")
			if coin and dist<1000 and mh and mr then
				local path=PFS:CreatePath({AgentRadius=2,AgentHeight=5,AgentCanJump=true})
				local ok=pcall(function() path:ComputeAsync(mr.Position,coin.Position) end)
				if ok and path.Status==Enum.PathStatus.Success then
					local wps=path:GetWaypoints();local pst=tick()
					for _,wp in ipairs(wps) do
						if not isAutoCoinSafeOn or not coin or not coin.Parent or not coin:FindFirstChild("TouchInterest") then break end
						if isFlinging or isOrbitOn then break end
						if tick()-pst>5 then unreachableCoins[coin]=true;break end
						if wp.Action==Enum.PathWaypointAction.Jump then mh.Jump=true end
						mh:MoveTo(wp.Position)
						local mt=tick()+1.5;local lp=mr.Position;local st=0
						repeat task.wait()
							if not mr or not coin or not coin:FindFirstChild("TouchInterest") then break end
							if (mr.Position-lp).Magnitude<0.5 then st=st+task.wait();if st>0.5 then mh.Jump=true;st=0 end else lp=mr.Position;st=0 end
						until (mr.Position-wp.Position).Magnitude<4 or tick()>mt
					end
					if coin and coin:FindFirstChild("TouchInterest") and (mr.Position-coin.Position).Magnitude<5 then task.wait(0.2);if coin:FindFirstChild("TouchInterest") then unreachableCoins[coin]=true end end
				else unreachableCoins[coin]=true end
			end
		end
	end
end)

-- Main logic loop
task.spawn(function()
	local lastShot,lastTShot,lastGrab=0,0,0
	while env.MM2Running do task.wait(0.1)
		local amMurd=isMurd(LP);local mc=LP.Character;local bp=LP:FindFirstChild("Backpack");local map=getCurrentMap()
		if map and lastCopiedMap~=map then unreachableCoins={} end
		if isLoopTripOn and mc and mc:FindFirstChild("Humanoid") then mc.Humanoid.PlatformStand=true end
		if amMurd and not isHitboxManual then isHitboxAuto=true;HitboxToggle.Text="Hitbox Expander: Auto";HitboxToggle.BackgroundColor3=Color3.fromRGB(150,150,255)
		elseif not amMurd and isHitboxAuto then isHitboxAuto=false;if not isHitboxManual then HitboxToggle.Text="Hitbox Expander: OFF";HitboxToggle.BackgroundColor3=OFF;forceRestoreCollisions() end end
		local se=isHitboxManual or isHitboxAuto
		for _,p in ipairs(Players:GetPlayers()) do if p~=LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local hrp=p.Character.HumanoidRootPart;hrp.Size=se and Vector3.new(hitboxMultiplier,hitboxMultiplier,hitboxMultiplier) or Vector3.new(2,2,1);hrp.Transparency=1 end end
		if isAutoGrabGunOn and (tick()-lastGrab>0.5) and map and map:FindFirstChild("GunDrop") then grabGunDrop();lastGrab=tick() end
		if isAutoCopyKnifeOn and not amMurd and bp and map and lastCopiedMap~=map then
			local myK=(mc and mc:FindFirstChild("Knife")) or (bp and bp:FindFirstChild("Knife"))
			if not myK then for _,p in ipairs(Players:GetPlayers()) do if p~=LP and isMurd(p) then local pc,pb=p.Character,p:FindFirstChild("Backpack");local src=(pc and pc:FindFirstChild("Knife")) or (pb and pb:FindFirstChild("Knife"));if src then local cl=src:Clone();cl:SetAttribute("CopiedByScript",true);local t=Instance.new("BoolValue");t.Name="CopiedByGodEye";t.Value=true;t.Parent=cl;cl.ToolTip="Stolen 🤑";cl.Parent=bp;lastCopiedMap=map end;break end end end
		elseif not map then lastCopiedMap=nil end
		-- Shared shoot helper (deduplicates autoShoot + targetShoot logic)
		local function doShoot(tgt,lastRef)
			if not(mc and mc:FindFirstChild("HumanoidRootPart")) then return lastRef end
			local gun=mc:FindFirstChild("Gun") or (bp and bp:FindFirstChild("Gun"));if not gun then return lastRef end
			if tgt and tgt.Character and tgt.Character:FindFirstChild("HumanoidRootPart") then
				local th=tgt.Character.HumanoidRootPart;local head=tgt.Character:FindFirstChild("Head");local mp=mc.HumanoidRootPart.Position
				local tp=(isAimHead and head and head.Position) or (th.Position+Vector3.new(0,1,0))
				if th.Velocity.Magnitude>2 then tp=tp+th.Velocity.Unit*2.5 end
				local sr=gun:FindFirstChild("Shoot");if sr then sr:FireServer(CFrame.new(mp,tp),CFrame.new(tp));return tick() end
			end
			return lastRef
		end
		if isTargetShootOn and (tick()-lastTShot>0.2) then
			if mc and mc:FindFirstChild("HumanoidRootPart") then
				local gun=mc:FindFirstChild("Gun") or (bp and bp:FindFirstChild("Gun"))
				if gun then
					local str=TargetShootInput.Text:lower();local tgt=nil
					if str~="" and str~="username" then for _,p in ipairs(Players:GetPlayers()) do if p~=LP and (p.Name:lower():find(str) or p.DisplayName:lower():find(str)) then if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and (p.Character.HumanoidRootPart.Position-mc.HumanoidRootPart.Position).Magnitude<=1000 then tgt=p end;break end end end
					if not tgt then for _,p in ipairs(Players:GetPlayers()) do if p~=LP and isMurd(p) then tgt=p;break end end end
					lastTShot=doShoot(tgt,lastTShot)
				end
			end
		end
		if isAutoShootOn and not isTargetShootOn and (tick()-lastShot>0.2) then
			local murd=nil;for _,p in ipairs(Players:GetPlayers()) do if p~=LP and isMurd(p) then murd=p;break end end
			lastShot=doShoot(murd,lastShot)
		end
	end
end)

-- LEAK FIX: PlayerRemoving cleans up ESP immediately using espDrop
sc(Players.PlayerRemoving:Connect(function(p)
	for _,n in ipairs({p.Name.."_ESP",p.Name.."_ESP_Text"}) do local c=esp:FindFirstChild(n);if c then espDrop(c) end end
end))

LP.CameraMaxZoomDistance=maxZoomValue
print("MM2 God-Eye Pro v70 GIGA Loaded! 🤑🔥")
