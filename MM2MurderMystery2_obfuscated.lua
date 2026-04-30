-- ==========================================
-- GAME CHECK & BOT SERVER CHECK 🗿
-- ==========================================
local currentPlaceId = game.PlaceId
if currentPlaceId ~= 142823291 and currentPlaceId ~= 80469437126309 then return end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Debris = game:GetService("Debris")
local PathfindingService = game:GetService("PathfindingService")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- GIGA BLACKLIST DATABASE (CLOUD SYNC) ☁️🛑
-- ==========================================
if StarterGui:FindFirstChild("Whitelist") then StarterGui.Whitelist:Destroy() end
if StarterGui:FindFirstChild("Blacklist") then StarterGui.Blacklist:Destroy() end

local authStatus = "Whitelist" 
pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Alone2718/Blacklist/refs/heads/main/auth.lua"))() end)

if StarterGui:FindFirstChild("Blacklist") then authStatus = "Blacklist" end

if authStatus == "Blacklist" then
    task.spawn(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") and ReplicatedStorage.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
        local tcs = game:GetService("TextChatService")
        while true do
            pcall(function()
                if chatEvent then chatEvent:FireServer("IM HACKER", "All")
                elseif tcs.ChatVersion == Enum.ChatVersion.TextChatService then tcs.TextChannels.RBXGeneral:SendAsync("IM HACKER") end
            end)
            task.wait(1)
        end
    end)
    RunService.RenderStepped:Connect(function()
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local tracerPart = Instance.new("Part"); tracerPart.Transparency = 1; tracerPart.Anchored = true; tracerPart.CanCollide = false; tracerPart.Size = Vector3.new(0.1, 0.1, 0.1); tracerPart.CFrame = char.HumanoidRootPart.CFrame; tracerPart.Name = "L_Bozo_Tracer"; tracerPart.Parent = workspace.CurrentCamera
                Debris:AddItem(tracerPart, 0.01)
            end
        end)
    end)
    return
end

-- ==========================================
-- UNC & BULLETPROOF SERVICES 🛡️
-- ==========================================
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Mouse = LocalPlayer:GetMouse()

local get_gc = type(getgc) == "function" and getgc or nil
local get_fenv = type(getfenv) == "function" and getfenv or nil
local get_constants = (type(debug) == "table" and type(debug.getconstants) == "function" and debug.getconstants) or (type(getconstants) == "function" and getconstants) or nil
local set_constant = (type(debug) == "table" and type(debug.setconstant) == "function" and debug.setconstant) or (type(setconstant) == "function" and setconstant) or nil
local _readfile = type(readfile) == "function" and readfile or nil
local _writefile = type(writefile) == "function" and writefile or nil
local _isfile = type(isfile) == "function" and isfile or nil

local env = (type(getgenv) == "function" and getgenv()) or _G
if env.MM2Running then env.MM2Running = false; task.wait(0.1) end 
env.MM2Running = true 

if env.MM2Connections then
    for _, conn in ipairs(env.MM2Connections) do if type(conn) == "table" and conn.Connected then pcall(function() conn:Disconnect() end) end end
    if env.MM2Gui then pcall(function() env.MM2Gui:Destroy() end) end
    if env.MM2Folder then pcall(function() env.MM2Folder:Destroy() end) end
end

env.MM2Connections = {}
local function saveConn(conn) table.insert(env.MM2Connections, conn) end

local espStorage = Instance.new("Folder"); espStorage.Name = "MM2_ESP_Storage"; espStorage.Parent = CoreGui; env.MM2Folder = espStorage

local keybindsFile = "MM2_GodEye_Keybinds.json"
local binds = { ESP="", CoinESP="", AntiFling="", AutoShoot="", Hitbox="", Bring="", BringClosest="", BringAll="", BringSheriff="", Panic="", Speed="", GrabGun="", AutoGrabGun="", AutoCoin="", AutoCoinSafe="", AutoCopyKnife="", LoopTrip="", PureInvis="", ToolInvis="", GodMode="", Orbit="" }

if _isfile and _isfile(keybindsFile) and _readfile then
    local success, decoded = pcall(function() return HttpService:JSONDecode(_readfile(keybindsFile)) end)
    if success and type(decoded) == "table" then for k, v in pairs(decoded) do binds[k] = v end end
end

local function saveBinds() if _writefile then pcall(function() _writefile(keybindsFile, HttpService:JSONEncode(binds)) end) end end 

local isESPOn = false; local espRoundState = "IDLE"; local hasGunDroppedThisRound = false 

-- ==========================================
-- GIGA GOD MODE STATE MANAGER 🔥
-- ==========================================
local godState = { enabled = false, method = "nohooks_strong", persistent = true, targetHealth = 1e9, connections = {} }

local function clearAllPlayerESP() 
    task.spawn(function()
        for _, child in ipairs(espStorage:GetChildren()) do 
            if child.Name ~= "GunDrop_ESP" and (child.Name:sub(-4) == "_ESP" or child.Name:sub(-9) == "_ESP_Text") then 
                child.Parent = nil; task.defer(function() pcall(function() child:Destroy() end) end)
            end 
        end 
    end)
end

local function clearAllCoinESP() 
    task.spawn(function()
        for _, child in ipairs(espStorage:GetChildren()) do 
            if child.Name:sub(1, 14) == "CoinAdornment_" then 
                child.Parent = nil; task.defer(function() pcall(function() child:Destroy() end) end)
            end 
        end 
    end)
end

local function isPlayerMurderer(player)
    if not player then return false end; local char = player.Character; local bp = player:FindFirstChild("Backpack")
    if char and char:FindFirstChild("Knife") then return true end; if bp and bp:FindFirstChild("Knife") then return true end; return false
end

local function isPlayerSheriff(player)
    if not player then return false end; local char = player.Character; local bp = player:FindFirstChild("Backpack")
    if char and char:FindFirstChild("Gun") then return true end; if bp and bp:FindFirstChild("Gun") then return true end; return false
end

local function getRoleColor(player) 
    if isPlayerMurderer(player) then return Color3.fromRGB(255, 0, 0) 
    elseif isPlayerSheriff(player) then return hasGunDroppedThisRound and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(0, 85, 255) 
    else return Color3.fromRGB(0, 255, 0) end 
end

local function executeFullESPScan()
    local validESP = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")
            local hum = char and char:FindFirstChild("Humanoid")
            
            if hrp and head and hum and hum.Health > 0 then
                local color = getRoleColor(player); local espName = player.Name .. "_ESP"; local textName = player.Name .. "_ESP_Text"
                validESP[espName] = true; validESP[textName] = true
                
                local highlight = espStorage:FindFirstChild(espName)
                if not highlight then highlight = Instance.new("Highlight"); highlight.Name = espName; highlight.Parent = espStorage; highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop end
                highlight.FillColor = color; highlight.FillTransparency = 0.6; highlight.OutlineColor = color; highlight.OutlineTransparency = 0.1
                
                -- MAP SUPREMACY FIX: Highlight Adornee locked to Char so it never vanishes
                highlight.Adornee = char
                
                local textGui = espStorage:FindFirstChild(textName)
                if not textGui then
                    textGui = Instance.new("BillboardGui"); textGui.Name = textName; textGui.Size = UDim2.new(0, 200, 0, 50); textGui.AlwaysOnTop = true; textGui.Parent = espStorage
                    local txt = Instance.new("TextLabel"); txt.Name = "NameLabel"; txt.Size = UDim2.new(1, 0, 1, 0); txt.BackgroundTransparency = 1; txt.Font = Enum.Font.GothamBold; txt.TextSize = 14; txt.TextStrokeTransparency = 0; txt.Parent = textGui
                end
                
                -- MAP SUPREMACY FIX: Text adornee drops to HRP on injury
                local isInjured = hum.Health < 100
                textGui.Adornee = isInjured and hrp or (head or hrp)
                textGui.StudsOffset = Vector3.new(0, 2, 0)
                
                local txt = textGui:FindFirstChild("NameLabel"); if txt then txt.Text = player.Name; txt.TextColor3 = color end
            end
        end
    end
    
    task.spawn(function()
        for _, child in ipairs(espStorage:GetChildren()) do
            if child.Name ~= "GunDrop_ESP" and (child.Name:sub(-4) == "_ESP" and not validESP[child.Name]) or (child.Name:sub(-9) == "_ESP_Text" and not validESP[child.Name]) then
                child.Parent = nil; task.defer(function() pcall(function() child:Destroy() end) end)
            end
        end
    end)
end

-- ==========================================
-- GIGA HOOK ENGINE (ZOMBIE MODE) 🧟‍♂️
-- ==========================================
pcall(function()
    if type(hookmetamethod) == "function" then
        local oldNamecall; oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if self == UserInputService and method == "GetPlatform" then return Enum.Platform.XBoxOne end
            if method == "InvokeServer" and self.Name == "GetChance" then task.spawn(function() if isESPOn then espRoundState = "WAITING_FOR_KNIFE"; executeFullESPScan() end end) end
            
            if godState.enabled and godState.method == "hooks" then
                local myChar = LocalPlayer.Character; local myHum = myChar and myChar:FindFirstChild("Humanoid"); local args = {...}
                if self == myHum then
                    if method == "ChangeState" and args[1] == Enum.HumanoidStateType.Dead then return end
                    if method == "SetStateEnabled" and args[1] == Enum.HumanoidStateType.Dead then return end
                    if method == "TakeDamage" then return end
                elseif self == myChar then 
                    if method == "BreakJoints" then return end 
                end
            end
            return oldNamecall(self, ...)
        end)
        
        local oldNewIndex; oldNewIndex = hookmetamethod(game, "__newindex", function(self, key, value)
            if godState.enabled and godState.method == "hooks" then
                local myChar = LocalPlayer.Character; local myHum = myChar and myChar:FindFirstChild("Humanoid")
                if self == myHum then
                    if key == "BreakJointsOnDeath" and value == true then return end
                end
            end
            return oldNewIndex(self, key, value)
        end)
    end
end)

-- ==========================================
-- GUI CREATION & SPACERS 🎨
-- ==========================================
local ScreenGui = Instance.new("ScreenGui"); ScreenGui.Name = "MM2_GodEye"; ScreenGui.Parent = CoreGui; env.MM2Gui = ScreenGui
local currentGuiX, currentGuiY = 480, 460

local MainFrame = Instance.new("Frame"); MainFrame.Size = UDim2.new(0, currentGuiX, 0, currentGuiY); MainFrame.Position = UDim2.new(0.5, -230, 0.5, -215); MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); MainFrame.BorderSizePixel = 0; MainFrame.Parent = ScreenGui; Instance.new("UICorner").Parent = MainFrame
local UIConstraint = Instance.new("UISizeConstraint"); UIConstraint.MinSize = Vector2.new(300, 250); UIConstraint.MaxSize = Vector2.new(1000, 1000); UIConstraint.Parent = MainFrame
local TopBar = Instance.new("Frame"); TopBar.Size = UDim2.new(1, 0, 0, 40); TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15); TopBar.Parent = MainFrame; Instance.new("UICorner").Parent = TopBar
local Title = Instance.new("TextLabel"); Title.Size = UDim2.new(1, -50, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0); Title.BackgroundTransparency = 1; Title.Text = "🔪 God-Eye Pro v81 GIGA"; Title.TextColor3 = Color3.fromRGB(85, 255, 127); Title.Font = Enum.Font.GothamBold; Title.TextSize = 15; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.Parent = TopBar
local MinButton = Instance.new("TextButton"); MinButton.Size = UDim2.new(0, 40, 0, 40); MinButton.Position = UDim2.new(1, -40, 0, 0); MinButton.BackgroundTransparency = 1; MinButton.Text = "-"; MinButton.TextColor3 = Color3.fromRGB(255, 255, 255); MinButton.Font = Enum.Font.GothamBold; MinButton.TextSize = 24; MinButton.Parent = TopBar

local TabBar = Instance.new("ScrollingFrame"); TabBar.Size = UDim2.new(0, 100, 1, -40); TabBar.Position = UDim2.new(0, 0, 0, 40); TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20); TabBar.ScrollingDirection = Enum.ScrollingDirection.Y; TabBar.ScrollBarThickness = 2; TabBar.BorderSizePixel = 0; TabBar.Parent = MainFrame
local TabList = Instance.new("UIListLayout", TabBar); TabList.FillDirection = Enum.FillDirection.Vertical; TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() TabBar.CanvasSize = UDim2.new(0, 0, 0, TabList.AbsoluteContentSize.Y) end)
TabBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseWheel then TabBar.CanvasPosition = Vector2.new(0, TabBar.CanvasPosition.Y - (input.Position.Z * 40)) end end)

local function createTabBtn(name) local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1, 0, 0, 35); btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); btn.Text = name; btn.TextColor3 = Color3.fromRGB(150, 150, 150); btn.Font = Enum.Font.GothamBold; btn.TextSize = 12; btn.Parent = TabBar; return btn end
local MainTabBtn = createTabBtn("Main"); local POVTabBtn = createTabBtn("POV"); local InnocentTabBtn = createTabBtn("Innocent"); local MurdererTabBtn = createTabBtn("Murderer"); local SheriffTabBtn = createTabBtn("Sheriff"); local FunTabBtn = createTabBtn("Fun"); local MiscTabBtn = createTabBtn("Misc"); local BindsTabBtn = createTabBtn("Keybinds"); local CreditsTabBtn = createTabBtn("Credits")

local function createContainer()
    local c = Instance.new("ScrollingFrame"); c.Size = UDim2.new(1, -100, 1, -40); c.Position = UDim2.new(0, 100, 0, 40); c.BackgroundTransparency = 1; c.ScrollBarThickness = 4; c.Visible = false; c.Parent = MainFrame
    local l = Instance.new("UIListLayout", c); l.SortOrder = Enum.SortOrder.LayoutOrder; l.Padding = UDim.new(0, 8); l.HorizontalAlignment = Enum.HorizontalAlignment.Center; Instance.new("UIPadding", c).PaddingTop = UDim.new(0, 10); return c, l
end
local MainContainer, mainUIList = createContainer(); local POVContainer, povUIList = createContainer(); local InnocentContainer, innocentUIList = createContainer(); local MurdererContainer, murdererUIList = createContainer(); local SheriffContainer, sheriffUIList = createContainer(); local FunContainer, funUIList = createContainer(); local MiscContainer, miscUIList = createContainer(); local BindsContainer, bindsUIList = createContainer(); local CreditsContainer, creditsUIList = createContainer()
MainContainer.Visible = true; MainTabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35); MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local tabs = { {Btn=MainTabBtn, Cont=MainContainer}, {Btn=POVTabBtn, Cont=POVContainer}, {Btn=InnocentTabBtn, Cont=InnocentContainer}, {Btn=MurdererTabBtn, Cont=MurdererContainer}, {Btn=SheriffTabBtn, Cont=SheriffContainer}, {Btn=FunTabBtn, Cont=FunContainer}, {Btn=MiscTabBtn, Cont=MiscContainer}, {Btn=BindsTabBtn, Cont=BindsContainer}, {Btn=CreditsTabBtn, Cont=CreditsContainer} }
local function switchTab(sel)
    for _, t in ipairs(tabs) do
        if t.Btn == sel then t.Cont.Visible = true; t.Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35); t.Btn.TextColor3 = Color3.fromRGB(255, 255, 255) else t.Cont.Visible = false; t.Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); t.Btn.TextColor3 = Color3.fromRGB(150, 150, 150) end
    end
end
for _, t in ipairs(tabs) do t.Btn.MouseButton1Click:Connect(function() switchTab(t.Btn) end) end

local function createToggle(p, t) local b = Instance.new("TextButton"); b.Size = UDim2.new(0.9, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(255, 50, 50); b.Text = t .. ": OFF"; b.TextColor3 = Color3.fromRGB(255, 255, 255); b.Font = Enum.Font.GothamBold; b.TextSize = 13; b.Parent = p; Instance.new("UICorner").Parent = b; return b end
local function createButton(p, t, c) local b = Instance.new("TextButton"); b.Size = UDim2.new(0.9, 0, 0, 40); b.BackgroundColor3 = c or Color3.fromRGB(50, 150, 255); b.Text = t; b.TextColor3 = Color3.fromRGB(255, 255, 255); b.Font = Enum.Font.GothamBold; b.TextSize = 13; b.Parent = p; Instance.new("UICorner").Parent = b; return b end
local function createSpacer(p) local s = Instance.new("Frame"); s.Size = UDim2.new(1, 0, 0, 10); s.BackgroundTransparency = 1; s.Parent = p end

-- ==========================================
-- UI BUILD OUTS
-- ==========================================
-- Main Tab
local ESPToggle = createToggle(MainContainer, "Player & Gun ESP")
local CoinToggle = createToggle(MainContainer, "Coin ESP")
createSpacer(MainContainer)
local AutoCoinToggle = createToggle(MainContainer, "Auto Coin")
local AutoCoinSafeToggle = createToggle(MainContainer, "Auto Coin Safe")
createSpacer(MainContainer)

local OrbitRow = Instance.new("Frame"); OrbitRow.Size = UDim2.new(0.9, 0, 0, 40); OrbitRow.BackgroundTransparency = 1; OrbitRow.Parent = MainContainer
local OrbitBtn = Instance.new("TextButton"); OrbitBtn.Size = UDim2.new(0.3, -2, 1, 0); OrbitBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0); OrbitBtn.Text = "Orbit Target"; OrbitBtn.TextColor3 = Color3.fromRGB(255, 255, 255); OrbitBtn.Font = Enum.Font.GothamBold; OrbitBtn.TextSize = 12; OrbitBtn.Parent = OrbitRow; Instance.new("UICorner").Parent = OrbitBtn
local OrbitInput = Instance.new("TextBox"); OrbitInput.Size = UDim2.new(0.3, 0, 1, 0); OrbitInput.Position = UDim2.new(0.3, 2, 0, 0); OrbitInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40); OrbitInput.Text = "Username"; OrbitInput.TextColor3 = Color3.fromRGB(255, 255, 255); OrbitInput.Font = Enum.Font.GothamBold; OrbitInput.TextSize = 12; OrbitInput.ClearTextOnFocus = true; OrbitInput.Parent = OrbitRow; Instance.new("UICorner").Parent = OrbitInput
local OrbitSpeedInput = Instance.new("TextBox"); OrbitSpeedInput.Size = UDim2.new(0.2, -2, 1, 0); OrbitSpeedInput.Position = UDim2.new(0.6, 4, 0, 0); OrbitSpeedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40); OrbitSpeedInput.Text = "0.2"; OrbitSpeedInput.PlaceholderText = "Spd"; OrbitSpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255); OrbitSpeedInput.Font = Enum.Font.GothamBold; OrbitSpeedInput.TextSize = 12; OrbitSpeedInput.ClearTextOnFocus = false; OrbitSpeedInput.Parent = OrbitRow; Instance.new("UICorner").Parent = OrbitSpeedInput
local OrbitDistInput = Instance.new("TextBox"); OrbitDistInput.Size = UDim2.new(0.2, -2, 1, 0); OrbitDistInput.Position = UDim2.new(0.8, 2, 0, 0); OrbitDistInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40); OrbitDistInput.Text = "6"; OrbitDistInput.PlaceholderText = "Dist"; OrbitDistInput.TextColor3 = Color3.fromRGB(255, 255, 255); OrbitDistInput.Font = Enum.Font.GothamBold; OrbitDistInput.TextSize = 12; OrbitDistInput.ClearTextOnFocus = false; OrbitDistInput.Parent = OrbitRow; Instance.new("UICorner").Parent = OrbitDistInput

createSpacer(MainContainer)
local AntiFlingToggle = createToggle(MainContainer, "Anti-Fling Safe Mode")
local TPLobbyBtn = createButton(MainContainer, "TP To Lobby", Color3.fromRGB(100, 50, 200))
local TPMapBtn = createButton(MainContainer, "TP To Map", Color3.fromRGB(100, 50, 200))

local IYBtnRow = Instance.new("Frame"); IYBtnRow.Size = UDim2.new(0.9, 0, 0, 50); IYBtnRow.BackgroundTransparency = 1; IYBtnRow.Parent = MainContainer
local IYBtn = Instance.new("TextButton"); IYBtn.Size = UDim2.new(0, 50, 0, 50); IYBtn.Position = UDim2.new(0.5, -25, 0, 0); IYBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35); IYBtn.RichText = true; IYBtn.Text = '<font color="#FFFFFF">I</font><font color="#FF7F7F">Y</font>'; IYBtn.Font = Enum.Font.GothamBold; IYBtn.TextSize = 22; IYBtn.Parent = IYBtnRow; Instance.new("UICorner", IYBtn).CornerRadius = UDim.new(1, 0)
IYBtn.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end) end)

-- POV Tab
local SpecMurdBtn = createButton(POVContainer, "Spectate Murderer", Color3.fromRGB(200, 50, 50))
local SpecSherBtn = createButton(POVContainer, "Spectate Sheriff", Color3.fromRGB(50, 50, 200))
local SpecRow = Instance.new("Frame"); SpecRow.Size = UDim2.new(0.9, 0, 0, 40); SpecRow.BackgroundTransparency = 1; SpecRow.Parent = POVContainer
local SpecBtn = Instance.new("TextButton"); SpecBtn.Size = UDim2.new(0.5, -2, 1, 0); SpecBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 50); SpecBtn.Text = "Spectate Player"; SpecBtn.TextColor3 = Color3.fromRGB(255, 255, 255); SpecBtn.Font = Enum.Font.GothamBold; SpecBtn.TextSize = 13; SpecBtn.Parent = SpecRow; Instance.new("UICorner").Parent = SpecBtn
local SpecInput = Instance.new("TextBox"); SpecInput.Size = UDim2.new(0.5, -2, 1, 0); SpecInput.Position = UDim2.new(0.5, 4, 0, 0); SpecInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40); SpecInput.Text = "Username"; SpecInput.TextColor3 = Color3.fromRGB(255, 255, 255); SpecInput.Font = Enum.Font.GothamBold; SpecInput.TextSize = 12; SpecInput.ClearTextOnFocus = true; SpecInput.Parent = SpecRow; Instance.new("UICorner").Parent = SpecInput
local UnspecBtn = createButton(POVContainer, "Unspectate", Color3.fromRGB(100, 100, 100))

-- Innocent Tab
local GrabGunBtn = createButton(InnocentContainer, "Grab Gun Drop", Color3.fromRGB(50, 200, 50))
local AutoGrabGunToggle = createToggle(InnocentContainer, "Auto Grab Gun")

-- Fun Tab (GIGA Upgraded)
local GodModeToggle = createToggle(FunContainer, "God Mode")
local GodMethodBtn = createButton(FunContainer, "God Method: Strong No-Hooks", Color3.fromRGB(150, 50, 200))
local GodPersistBtn = createButton(FunContainer, "God Persist: ON", Color3.fromRGB(50, 150, 200))

createSpacer(FunContainer)
local PureInvisBtn = createButton(FunContainer, "Pure Invis: OFF", Color3.fromRGB(150, 150, 150))
local ToolInvisBtn = createButton(FunContainer, "Tool Invis: OFF", Color3.fromRGB(150, 150, 150))

createSpacer(FunContainer)
local ForceEquipKnifeBtn = createButton(FunContainer, "Force Equip Knife", Color3.fromRGB(200, 150, 50))
local StealKnifeBtn = createButton(FunContainer, "Steal Knife from Murderer", Color3.fromRGB(200, 100, 50))
local AutoCopyKnifeToggle = createToggle(FunContainer, "Auto Copy Knife")
local LoopTripToggle = createToggle(FunContainer, "Loop Trip")

createSpacer(FunContainer)
local FlingModeBtn = createButton(FunContainer, "Fling Mode: GIGA", Color3.fromRGB(200, 50, 200))
local FlingRow = Instance.new("Frame"); FlingRow.Size = UDim2.new(0.9, 0, 0, 40); FlingRow.BackgroundTransparency = 1; FlingRow.Parent = FunContainer
local FlingBtn = Instance.new("TextButton"); FlingBtn.Size = UDim2.new(0.35, -2, 1, 0); FlingBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0); FlingBtn.Text = "Smart Fling Lock-On"; FlingBtn.TextColor3 = Color3.fromRGB(255, 255, 255); FlingBtn.Font = Enum.Font.GothamBold; FlingBtn.TextSize = 13; FlingBtn.Parent = FlingRow; Instance.new("UICorner").Parent = FlingBtn
local FlingInput = Instance.new("TextBox"); FlingInput.Size = UDim2.new(0.4, 0, 1, 0); FlingInput.Position = UDim2.new(0.35, 2, 0, 0); FlingInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40); FlingInput.Text = "Username"; FlingInput.TextColor3 = Color3.fromRGB(255, 255, 255); FlingInput.Font = Enum.Font.GothamBold; FlingInput.TextSize = 12; FlingInput.ClearTextOnFocus = true; FlingInput.Parent = FlingRow; Instance.new("UICorner").Parent = FlingInput
local PanicBtn = Instance.new("TextButton"); PanicBtn.Size = UDim2.new(0.25, -2, 1, 0); PanicBtn.Position = UDim2.new(0.75, 4, 0, 0); PanicBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0); PanicBtn.Text = "🚨 Panic!"; PanicBtn.TextColor3 = Color3.fromRGB(255, 255, 255); PanicBtn.Font = Enum.Font.GothamBold; PanicBtn.TextSize = 13; PanicBtn.Parent = FlingRow; Instance.new("UICorner").Parent = PanicBtn

local FlingRolesRow = Instance.new("Frame"); FlingRolesRow.Size = UDim2.new(0.9, 0, 0, 40); FlingRolesRow.BackgroundTransparency = 1; FlingRolesRow.Parent = FunContainer
local FlingMurdBtn = Instance.new("TextButton"); FlingMurdBtn.Size = UDim2.new(0.5, -2, 1, 0); FlingMurdBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); FlingMurdBtn.Text = "Fling Murderer Lock-On"; FlingMurdBtn.TextColor3 = Color3.fromRGB(255, 255, 255); FlingMurdBtn.Font = Enum.Font.GothamBold; FlingMurdBtn.TextSize = 13; FlingMurdBtn.Parent = FlingRolesRow; Instance.new("UICorner").Parent = FlingMurdBtn
local FlingSherBtn = Instance.new("TextButton"); FlingSherBtn.Size = UDim2.new(0.5, -2, 1, 0); FlingSherBtn.Position = UDim2.new(0.5, 2, 0, 0); FlingSherBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 200); FlingSherBtn.Text = "Fling Sheriff Lock-On"; FlingSherBtn.TextColor3 = Color3.fromRGB(255, 255, 255); FlingSherBtn.Font = Enum.Font.GothamBold; FlingSherBtn.TextSize = 13; FlingSherBtn.Parent = FlingRolesRow; Instance.new("UICorner").Parent = FlingSherBtn

-- Murderer Tab
local HitboxContainer = Instance.new("Frame"); HitboxContainer.Size = UDim2.new(0.9, 0, 0, 40); HitboxContainer.BackgroundTransparency = 1; HitboxContainer.Parent = MurdererContainer
local HitboxToggle = Instance.new("TextButton"); HitboxToggle.Size = UDim2.new(0.7, -5, 1, 0); HitboxToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50); HitboxToggle.Text = "Hitbox Expander: OFF"; HitboxToggle.TextColor3 = Color3.fromRGB(255, 255, 255); HitboxToggle.Font = Enum.Font.GothamBold; HitboxToggle.TextSize = 13; HitboxToggle.Parent = HitboxContainer; Instance.new("UICorner").Parent = HitboxToggle
local HitboxInput = Instance.new("TextBox"); HitboxInput.Size = UDim2.new(0.3, 0, 1, 0); HitboxInput.Position = UDim2.new(0.7, 5, 0, 0); HitboxInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40); HitboxInput.Text = "1"; HitboxInput.TextColor3 = Color3.fromRGB(255, 255, 255); HitboxInput.Font = Enum.Font.GothamBold; HitboxInput.TextSize = 16; HitboxInput.ClearTextOnFocus = false; HitboxInput.Parent = HitboxContainer; Instance.new("UICorner").Parent = HitboxInput
createSpacer(MurdererContainer)

local BringFrame = Instance.new("Frame"); BringFrame.Size = UDim2.new(0.9, 0, 0, 40); BringFrame.BackgroundTransparency = 1; BringFrame.Parent = MurdererContainer
local BringBtn = Instance.new("TextButton"); BringBtn.Size = UDim2.new(0.6, -5, 1, 0); BringBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 200); BringBtn.Text = "Bring Player"; BringBtn.TextColor3 = Color3.fromRGB(255, 255, 255); BringBtn.Font = Enum.Font.GothamBold; BringBtn.TextSize = 13; BringBtn.Parent = BringFrame; Instance.new("UICorner").Parent = BringBtn
local BringInput = Instance.new("TextBox"); BringInput.Size = UDim2.new(0.4, 0, 1, 0); BringInput.Position = UDim2.new(0.6, 5, 0, 0); BringInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40); BringInput.Text = "Username"; BringInput.TextColor3 = Color3.fromRGB(255, 255, 255); BringInput.Font = Enum.Font.GothamBold; BringInput.TextSize = 12; BringInput.ClearTextOnFocus = true; BringInput.Parent = BringFrame; Instance.new("UICorner").Parent = BringInput
local BringClosestBtn = createButton(MurdererContainer, "Bring Closest Player", Color3.fromRGB(200, 50, 200))
local BringAllBtn = createButton(MurdererContainer, "Bring ALL Players", Color3.fromRGB(200, 50, 50))
local BringSheriffBtn = createButton(MurdererContainer, "Bring Sheriff", Color3.fromRGB(50, 50, 200))

-- Sheriff Tab
local AutoShootToggle = createToggle(SheriffContainer, "Shoot Murderer: OFF")
local AutoShootAimToggle = createButton(SheriffContainer, "Auto Shoot Aim: Torso", Color3.fromRGB(150, 50, 200))
createSpacer(SheriffContainer)
local TargetShootFrame = Instance.new("Frame"); TargetShootFrame.Size = UDim2.new(0.9, 0, 0, 40); TargetShootFrame.BackgroundTransparency = 1; TargetShootFrame.Parent = SheriffContainer
local TargetShootToggle = Instance.new("TextButton"); TargetShootToggle.Size = UDim2.new(0.6, -2, 1, 0); TargetShootToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50); TargetShootToggle.Text = "Shoot Target: OFF"; TargetShootToggle.TextColor3 = Color3.fromRGB(255, 255, 255); TargetShootToggle.Font = Enum.Font.GothamBold; TargetShootToggle.TextSize = 13; TargetShootToggle.Parent = TargetShootFrame; Instance.new("UICorner").Parent = TargetShootToggle
local TargetShootInput = Instance.new("TextBox"); TargetShootInput.Size = UDim2.new(0.4, 0, 1, 0); TargetShootInput.Position = UDim2.new(0.6, 2, 0, 0); TargetShootInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40); TargetShootInput.Text = "Username"; TargetShootInput.TextColor3 = Color3.fromRGB(255, 255, 255); TargetShootInput.Font = Enum.Font.GothamBold; TargetShootInput.TextSize = 12; TargetShootInput.ClearTextOnFocus = true; TargetShootInput.Parent = TargetShootFrame; Instance.new("UICorner").Parent = TargetShootInput

local isAimHead = false
AutoShootAimToggle.MouseButton1Click:Connect(function()
    isAimHead = not isAimHead; AutoShootAimToggle.Text = isAimHead and "Auto Shoot Aim: Head" or "Auto Shoot Aim: Torso"; AutoShootAimToggle.BackgroundColor3 = isAimHead and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(150, 50, 200)
end)

-- Misc Tab
local TranspContainer = Instance.new("Frame"); TranspContainer.Size = UDim2.new(0.9, 0, 0, 40); TranspContainer.BackgroundTransparency = 1; TranspContainer.Parent = MiscContainer
local TranspLabel = Instance.new("TextLabel"); TranspLabel.Size = UDim2.new(0.6, -5, 1, 0); TranspLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50); TranspLabel.Text = "UI Transparency:"; TranspLabel.TextColor3 = Color3.fromRGB(255, 255, 255); TranspLabel.Font = Enum.Font.GothamBold; TranspLabel.TextSize = 13; TranspLabel.Parent = TranspContainer; Instance.new("UICorner").Parent = TranspLabel
local TranspInput = Instance.new("TextBox"); TranspInput.Size = UDim2.new(0.4, 0, 1, 0); TranspInput.Position = UDim2.new(0.6, 5, 0, 0); TranspInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40); TranspInput.Text = "0"; TranspInput.TextColor3 = Color3.fromRGB(255, 255, 255); TranspInput.Font = Enum.Font.GothamBold; TranspInput.TextSize = 16; TranspInput.ClearTextOnFocus = false; TranspInput.Parent = TranspContainer; Instance.new("UICorner").Parent = TranspInput

local MaxZoomContainer = Instance.new("Frame"); MaxZoomContainer.Size = UDim2.new(0.9, 0, 0, 40); MaxZoomContainer.BackgroundTransparency = 1; MaxZoomContainer.Parent = MiscContainer
local MaxZoomLabel = Instance.new("TextLabel"); MaxZoomLabel.Size = UDim2.new(0.6, -5, 1, 0); MaxZoomLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50); MaxZoomLabel.Text = "Max Zoom Dist:"; MaxZoomLabel.TextColor3 = Color3.fromRGB(255, 255, 255); MaxZoomLabel.Font = Enum.Font.GothamBold; MaxZoomLabel.TextSize = 13; MaxZoomLabel.Parent = MaxZoomContainer; Instance.new("UICorner").Parent = MaxZoomLabel
local MaxZoomInput = Instance.new("TextBox"); MaxZoomInput.Size = UDim2.new(0.4, 0, 1, 0); MaxZoomInput.Position = UDim2.new(0.6, 5, 0, 0); MaxZoomInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40); MaxZoomInput.Text = "200"; MaxZoomInput.TextColor3 = Color3.fromRGB(255, 255, 255); MaxZoomInput.Font = Enum.Font.GothamBold; MaxZoomInput.TextSize = 16; MaxZoomInput.ClearTextOnFocus = false; MaxZoomInput.Parent = MaxZoomContainer; Instance.new("UICorner").Parent = MaxZoomInput

local NoclipCamToggle = createToggle(MiscContainer, "Memory Noclip Cam")
local SpeedFrame = Instance.new("Frame"); SpeedFrame.Size = UDim2.new(0.9, 0, 0, 40); SpeedFrame.BackgroundTransparency = 1; SpeedFrame.Parent = MiscContainer
local SpeedBtn = Instance.new("TextButton"); SpeedBtn.Size = UDim2.new(0.6, -5, 1, 0); SpeedBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50); SpeedBtn.Text = "Lock WalkSpeed: OFF"; SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255); SpeedBtn.Font = Enum.Font.GothamBold; SpeedBtn.TextSize = 13; SpeedBtn.Parent = SpeedFrame; Instance.new("UICorner").Parent = SpeedBtn
local SpeedInput = Instance.new("TextBox"); SpeedInput.Size = UDim2.new(0.4, 0, 1, 0); SpeedInput.Position = UDim2.new(0.6, 5, 0, 0); SpeedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40); SpeedInput.Text = "25"; SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255); SpeedInput.Font = Enum.Font.GothamBold; SpeedInput.TextSize = 16; SpeedInput.ClearTextOnFocus = false; SpeedInput.Parent = SpeedFrame; Instance.new("UICorner").Parent = SpeedInput

createSpacer(MiscContainer)
local AnimWatcherBtn = createButton(MiscContainer, "Load Animation Watcher", Color3.fromRGB(150, 100, 200))
local CustomAnimFrame = Instance.new("Frame"); CustomAnimFrame.Size = UDim2.new(0.9, 0, 0, 40); CustomAnimFrame.BackgroundTransparency = 1; CustomAnimFrame.Parent = MiscContainer
local PlayAnimBtn = Instance.new("TextButton"); PlayAnimBtn.Size = UDim2.new(0.6, -5, 1, 0); PlayAnimBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 50); PlayAnimBtn.Text = "Play Animation"; PlayAnimBtn.TextColor3 = Color3.fromRGB(255, 255, 255); PlayAnimBtn.Font = Enum.Font.GothamBold; PlayAnimBtn.TextSize = 13; PlayAnimBtn.Parent = CustomAnimFrame; Instance.new("UICorner").Parent = PlayAnimBtn
local AnimInput = Instance.new("TextBox"); AnimInput.Size = UDim2.new(0.4, 0, 1, 0); AnimInput.Position = UDim2.new(0.6, 5, 0, 0); AnimInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40); AnimInput.Text = "Anim ID"; AnimInput.TextColor3 = Color3.fromRGB(255, 255, 255); AnimInput.Font = Enum.Font.GothamBold; AnimInput.TextSize = 12; AnimInput.ClearTextOnFocus = true; AnimInput.Parent = CustomAnimFrame; Instance.new("UICorner").Parent = AnimInput

createSpacer(MiscContainer)
local CustomSizeFrame = Instance.new("Frame"); CustomSizeFrame.Size = UDim2.new(0.9, 0, 0, 40); CustomSizeFrame.BackgroundTransparency = 1; CustomSizeFrame.Parent = MiscContainer
local CustomSizeLabel = Instance.new("TextLabel"); CustomSizeLabel.Size = UDim2.new(0.5, -5, 1, 0); CustomSizeLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50); CustomSizeLabel.Text = "GUI Size (X, Y):"; CustomSizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255); CustomSizeLabel.Font = Enum.Font.GothamBold; CustomSizeLabel.TextSize = 12; CustomSizeLabel.Parent = CustomSizeFrame; Instance.new("UICorner").Parent = CustomSizeLabel
local SizeXInput = Instance.new("TextBox"); SizeXInput.Size = UDim2.new(0.25, -2, 1, 0); SizeXInput.Position = UDim2.new(0.5, 2, 0, 0); SizeXInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40); SizeXInput.Text = tostring(currentGuiX); SizeXInput.TextColor3 = Color3.fromRGB(255, 255, 255); SizeXInput.Font = Enum.Font.GothamBold; SizeXInput.TextSize = 14; SizeXInput.ClearTextOnFocus = false; SizeXInput.Parent = CustomSizeFrame; Instance.new("UICorner").Parent = SizeXInput
local SizeYInput = Instance.new("TextBox"); SizeYInput.Size = UDim2.new(0.25, -2, 1, 0); SizeYInput.Position = UDim2.new(0.75, 4, 0, 0); SizeYInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40); SizeYInput.Text = tostring(currentGuiY); SizeYInput.TextColor3 = Color3.fromRGB(255, 255, 255); SizeYInput.Font = Enum.Font.GothamBold; SizeYInput.TextSize = 14; SizeYInput.ClearTextOnFocus = false; SizeYInput.Parent = CustomSizeFrame; Instance.new("UICorner").Parent = SizeYInput

local bindingAction = nil
local function createBindUI(id, displayName)
    local frame = Instance.new("Frame"); frame.Size = UDim2.new(0.9, 0, 0, 40); frame.BackgroundTransparency = 1; frame.Parent = BindsContainer
    local label = Instance.new("TextLabel"); label.Size = UDim2.new(0.6, 0, 1, 0); label.BackgroundTransparency = 1; label.Text = displayName; label.TextColor3 = Color3.fromRGB(255, 255, 255); label.Font = Enum.Font.GothamBold; label.TextSize = 13; label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = frame
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(0.4, 0, 1, 0); btn.Position = UDim2.new(0.6, 0, 0, 0); btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); btn.Text = binds[id] ~= "" and binds[id] or "NONE"; btn.TextColor3 = Color3.fromRGB(255, 255, 0); btn.Font = Enum.Font.GothamBold; btn.TextSize = 12; btn.Parent = frame; Instance.new("UICorner").Parent = btn
    btn.MouseButton1Click:Connect(function() btn.Text = "..."; bindingAction = {id = id, button = btn} end)
end

createBindUI("ESP", "Toggle ESP"); createBindUI("CoinESP", "Toggle Coin ESP"); createBindUI("AutoCoin", "Toggle Auto Coin"); createBindUI("AutoCoinSafe", "Toggle Safe Auto Coin")
createBindUI("AntiFling", "Toggle Anti-Fling"); createBindUI("Hitbox", "Toggle Hitbox"); createBindUI("Bring", "Trigger Bring Player"); createBindUI("BringClosest", "Trigger Bring Closest")
createBindUI("BringAll", "Trigger Bring ALL"); createBindUI("BringSheriff", "Trigger Bring Sheriff"); createBindUI("AutoShoot", "Toggle Auto-Shoot"); createBindUI("Panic", "Trigger Panic")
createBindUI("Speed", "Toggle Speed Lock"); createBindUI("GrabGun", "Trigger Grab Gun"); createBindUI("AutoGrabGun", "Toggle Auto Grab Gun"); createBindUI("AutoCopyKnife", "Toggle Auto Copy Knife")
createBindUI("LoopTrip", "Toggle Loop Trip"); createBindUI("PureInvis", "Trigger Pure Invis"); createBindUI("ToolInvis", "Trigger Tool Invis")
createBindUI("GodMode", "Trigger God Mode"); createBindUI("Orbit", "Toggle Orbit")

local CreditsTitle = Instance.new("TextLabel"); CreditsTitle.Size = UDim2.new(0.9, 0, 0, 40); CreditsTitle.BackgroundTransparency = 1; CreditsTitle.Text = "God-Eye Pro Credits"; CreditsTitle.TextColor3 = Color3.fromRGB(255, 215, 0); CreditsTitle.Font = Enum.Font.GothamBold; CreditsTitle.TextSize = 20; CreditsTitle.Parent = CreditsContainer
local OwnerLabel = Instance.new("TextLabel"); OwnerLabel.Size = UDim2.new(0.9, 0, 0, 40); OwnerLabel.BackgroundTransparency = 1; OwnerLabel.Text = "Owner: Alone2718"; OwnerLabel.TextColor3 = Color3.fromRGB(85, 255, 127); OwnerLabel.Font = Enum.Font.GothamBold; OwnerLabel.TextSize = 16; OwnerLabel.Parent = CreditsContainer
local CoOwnerLabel = Instance.new("TextLabel"); CoOwnerLabel.Size = UDim2.new(0.9, 0, 0, 40); CoOwnerLabel.BackgroundTransparency = 1; CoOwnerLabel.Text = "Co-Owner: Gemini 🗿"; CoOwnerLabel.TextColor3 = Color3.fromRGB(50, 150, 255); CoOwnerLabel.Font = Enum.Font.GothamBold; CoOwnerLabel.TextSize = 16; CoOwnerLabel.Parent = CreditsContainer

local function bindCanvas(container, layout) layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20) end) end
bindCanvas(MainContainer, mainUIList); bindCanvas(POVContainer, povUIList); bindCanvas(InnocentContainer, innocentUIList); bindCanvas(MurdererContainer, murdererUIList); bindCanvas(SheriffContainer, sheriffUIList); bindCanvas(FunContainer, funUIList); bindCanvas(MiscContainer, miscUIList); bindCanvas(BindsContainer, bindsUIList); bindCanvas(CreditsContainer, creditsUIList)

local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = MainFrame.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end
end)
TopBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
saveConn(UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end))

local minimized = false
MinButton.MouseButton1Click:Connect(function()
    minimized = not minimized; TabBar.Visible = not minimized
    for _, tab in ipairs(tabs) do if tab.Btn.BackgroundColor3 == Color3.fromRGB(35, 35, 35) then tab.Cont.Visible = not minimized end end
    if minimized then UIConstraint.MinSize = Vector2.new(100, 40); MainFrame.Size = UDim2.new(0, currentGuiX, 0, 40) else UIConstraint.MinSize = Vector2.new(300, 250); MainFrame.Size = UDim2.new(0, currentGuiX, 0, currentGuiY) end
    MinButton.Text = minimized and "+" or "-"
end)

local function ApplyCustomSize()
    local tempX = tonumber(SizeXInput.Text); local tempY = tonumber(SizeYInput.Text)
    if tempX and tempX >= 300 then currentGuiX = tempX else SizeXInput.Text = tostring(currentGuiX) end
    if tempY and tempY >= 250 then currentGuiY = tempY else SizeYInput.Text = tostring(currentGuiY) end
    if not minimized then MainFrame.Size = UDim2.new(0, currentGuiX, 0, currentGuiY) end
end
SizeXInput.FocusLost:Connect(ApplyCustomSize); SizeYInput.FocusLost:Connect(ApplyCustomSize)
TranspInput:GetPropertyChangedSignal("Text"):Connect(function()
    local val = tonumber(TranspInput.Text); if val then local alpha = math.clamp(val, 0, 1); MainFrame.BackgroundTransparency = alpha; TabBar.BackgroundTransparency = alpha; TopBar.BackgroundTransparency = alpha end
end)

local isNoclipCamOn = false; local maxZoomValue = 200
local function hookMemoryNoclipCam(state)
    pcall(function()
        if not LocalPlayer.PlayerScripts:FindFirstChild("PlayerModule") then return end
        local pop = LocalPlayer.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper
        if get_gc then
            for _, v in pairs(get_gc()) do
                if type(v) == 'function' and get_fenv and get_fenv(v).script == pop then
                    if get_constants then
                        local consts = get_constants(v)
                        for i, v1 in pairs(consts) do
                            if set_constant then if state and tonumber(v1) == 0.25 then set_constant(v, i, 0) elseif not state and tonumber(v1) == 0 then set_constant(v, i, 0.25) end end
                        end
                    end
                end
            end
        end
    end)
end
MaxZoomInput.FocusLost:Connect(function() local val = tonumber(MaxZoomInput.Text); if val and val > 0 then maxZoomValue = val else MaxZoomInput.Text = tostring(maxZoomValue) end; LocalPlayer.CameraMaxZoomDistance = maxZoomValue end)

local function getCurrentMap() 
    for _, child in ipairs(Workspace:GetChildren()) do if child.Name ~= "RegularLobby" and child.Name ~= "Lobby" and child:FindFirstChild("Spawns") then return child end end 
    return nil 
end

local function forceRestoreCollisions()
    for _, p in ipairs(Players:GetPlayers()) do if p.Character then for _, part in ipairs(p.Character:GetChildren()) do if part:IsA("BasePart") and (part.Name == "HumanoidRootPart" or part.Name == "Torso" or part.Name == "UpperTorso" or part.Name == "Head") then part.CanCollide = true end end end end
end

local function spectatePlayer(targetPlayer) 
    if targetPlayer and targetPlayer.Character then 
        local targetSubj = targetPlayer.Character:FindFirstChild("Head") or targetPlayer.Character:FindFirstChild("HumanoidRootPart") or targetPlayer.Character:FindFirstChild("Humanoid")
        if Workspace.CurrentCamera.CameraSubject ~= targetSubj then pcall(function() Workspace.CurrentCamera.CameraSubject = targetSubj end) end
    end 
end
local function unspectate() 
    if LocalPlayer.Character then local mySubj = LocalPlayer.Character:FindFirstChild("Humanoid"); if mySubj and Workspace.CurrentCamera.CameraSubject ~= mySubj then pcall(function() Workspace.CurrentCamera.CameraSubject = mySubj end) end end 
end

SpecMurdBtn.MouseButton1Click:Connect(function() for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and isPlayerMurderer(p) then spectatePlayer(p) break end end end)
SpecSherBtn.MouseButton1Click:Connect(function() for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and isPlayerSheriff(p) then spectatePlayer(p) break end end end)
SpecBtn.MouseButton1Click:Connect(function() local str = SpecInput.Text:lower(); if str == "" or str == "username" then return end; for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and (p.Name:lower():find(str) or p.DisplayName:lower():find(str)) then spectatePlayer(p) break end end end)
UnspecBtn.MouseButton1Click:Connect(unspectate)

local isCoinESPOn, isAutoShootOn = false, false; local isHitboxManual, isHitboxAuto, isAntiFlingOn = false, false, false
local isSpeedLocked, isAutoGrabGunOn = false, false; local isAutoCoinOn, isAutoCoinSafeOn, isAutoCopyKnifeOn = false, false, false
local isLoopTripOn = false; local autoCoinTween = nil; local lockedSpeed = 25; local hitboxMultiplier = 1
local isFlingToggleOn = false; local flingTargetPlayer = nil; local isFlinging = false; local isFlingNoclipping = false
local flingMode = "GIGA"; local currentlyFlingingPlayer = nil; local isTargetShootOn = false; local lastCopiedMap = nil
local unreachableCoins = setmetatable({}, {__mode = "k"}) 
local bringTargetPlayers = {}; local bringOriginalCFrames = {}; local bringEndTime = 0; local currentBringMode = nil 
local isOrbitOn = false; local orbitTarget = nil; local originalOrbitCFrame = nil; local orbitConn1, orbitConn2, orbitConn3, orbitConn4; local orbitRot = 0

local function SafeTeleport(targetCFrame)
    local myChar = LocalPlayer.Character; if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart"); local myHum = myChar:FindFirstChild("Humanoid")
    if myRoot and myHum then
        myHum.Sit = false; myRoot.Velocity = Vector3.zero; myRoot.RotVelocity = Vector3.zero; myRoot.CFrame = targetCFrame
        task.wait(0.05); myRoot.Velocity = Vector3.zero; myRoot.RotVelocity = Vector3.zero
    end
end

-- ==========================================
-- GIGA ESP DAMAGE TRACKER + DEBOUNCE FIX 👁️🩸
-- ==========================================
local playerHealthConns = {}
local playerHealthConnsDebounce = {}

local function hookPlayerHealth(player)
    if player == LocalPlayer then return end
    if playerHealthConns[player] then playerHealthConns[player]:Disconnect(); playerHealthConns[player] = nil end
    local char = player.Character
    if char then
        local hum = char:WaitForChild("Humanoid", 2)
        if hum then
            playerHealthConns[player] = hum.HealthChanged:Connect(function()
                if isESPOn then
                    if not playerHealthConnsDebounce[player] then
                        playerHealthConnsDebounce[player] = true
                        executeFullESPScan()
                        task.delay(1, function() playerHealthConnsDebounce[player] = false end)
                    end
                end
            end)
        end
    end
end

for _, p in ipairs(Players:GetPlayers()) do hookPlayerHealth(p); saveConn(p.CharacterAdded:Connect(function() hookPlayerHealth(p) end)) end
saveConn(Players.PlayerAdded:Connect(function(p) saveConn(p.CharacterAdded:Connect(function() hookPlayerHealth(p) end)) end))
saveConn(Players.PlayerRemoving:Connect(function(p) if playerHealthConns[p] then playerHealthConns[p]:Disconnect(); playerHealthConns[p] = nil end end))

-- ==========================================
-- GIGA GOD MODE ENGINE 🔥
-- ==========================================
local function clearGodConnections() for _, conn in ipairs(godState.connections) do if conn and type(conn) == "table" and conn.Connected then pcall(function() conn:Disconnect() end) end end; godState.connections = {} end
local function applyGodStats(hum) if not hum then return end; pcall(function() hum.MaxHealth = godState.targetHealth; hum.Health = godState.targetHealth; hum.BreakJointsOnDeath = false end) end

local function wireGodMode(char)
    if not char then return end; local hum = char:WaitForChild("Humanoid", 2); if not hum then return end
    applyGodStats(hum)
    local hc = hum.HealthChanged:Connect(function() if godState.enabled then applyGodStats(hum) end end); table.insert(godState.connections, hc)
    local rs = RunService.RenderStepped:Connect(function() if not godState.enabled then return end; applyGodStats(hum); pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false); if hum:GetState() == Enum.HumanoidStateType.Dead then hum:ChangeState(Enum.HumanoidStateType.Running) end end) end); table.insert(godState.connections, rs)
    local hb = RunService.Heartbeat:Connect(function() if not godState.enabled then return end; applyGodStats(hum); pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end) end); table.insert(godState.connections, hb)
end

local function toggleGodModeState()
    godState.enabled = not godState.enabled
    if godState.enabled then GodModeToggle.Text = "God Mode: ON"; GodModeToggle.BackgroundColor3 = Color3.fromRGB(50, 255, 50); wireGodMode(LocalPlayer.Character)
    else GodModeToggle.Text = "God Mode: OFF"; GodModeToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50); clearGodConnections(); local myChar = LocalPlayer.Character; local hum = myChar and myChar:FindFirstChild("Humanoid"); if hum then pcall(function() hum.MaxHealth = 100; hum.Health = 100; hum.BreakJointsOnDeath = true end) end end
end

GodModeToggle.MouseButton1Click:Connect(toggleGodModeState)
GodMethodBtn.MouseButton1Click:Connect(function() if godState.method == "nohooks_strong" then godState.method = "hooks"; GodMethodBtn.Text = "God Method: Hooks (Meta)"; GodMethodBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50) else godState.method = "nohooks_strong"; GodMethodBtn.Text = "God Method: Strong No-Hooks"; GodMethodBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 200) end end)
GodPersistBtn.MouseButton1Click:Connect(function() godState.persistent = not godState.persistent; GodPersistBtn.Text = godState.persistent and "God Persist: ON" or "God Persist: OFF"; GodPersistBtn.BackgroundColor3 = godState.persistent and Color3.fromRGB(50, 150, 200) or Color3.fromRGB(100, 100, 100) end)

-- ==========================================
-- GIGA DUAL INVISIBILITY ENGINE 🥷☁️
-- ==========================================
local isPureInvis = false; local pureInvisClone = nil; local realCharForInvis = nil; local originalPureInvisPos = nil
local function togglePureInvis()
    isPureInvis = not isPureInvis
    if isPureInvis then
        PureInvisBtn.Text = "Pure Invis: ON"; PureInvisBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            realCharForInvis = char; originalPureInvisPos = char.HumanoidRootPart.CFrame; char.Archivable = true
            pureInvisClone = char:Clone(); pureInvisClone.Name = "GodEye_Clone"; pureInvisClone.Parent = Workspace
            for _, v in ipairs(pureInvisClone:GetDescendants()) do if v:IsA("BasePart") then v.Transparency = v.Name:lower() == "humanoidrootpart" and 1 or 0.5 end end
            char.HumanoidRootPart.CFrame = CFrame.new(0, math.pi * 1000000, 0); task.wait(0.1)
            char.Parent = game:GetService("ReplicatedStorage"); pureInvisClone.HumanoidRootPart.CFrame = originalPureInvisPos
            LocalPlayer.Character = pureInvisClone; Workspace.CurrentCamera.CameraSubject = pureInvisClone:FindFirstChild("Humanoid")
        end
    else
        PureInvisBtn.Text = "Pure Invis: OFF"; PureInvisBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
        if pureInvisClone then pureInvisClone:Destroy() end
        if realCharForInvis then
            LocalPlayer.Character = realCharForInvis; realCharForInvis.Parent = Workspace
            if originalPureInvisPos and realCharForInvis:FindFirstChild("HumanoidRootPart") then realCharForInvis.HumanoidRootPart.CFrame = originalPureInvisPos end
            Workspace.CurrentCamera.CameraSubject = realCharForInvis:FindFirstChild("Humanoid")
        end
    end
end
PureInvisBtn.MouseButton1Click:Connect(togglePureInvis)

local isToolInvis = false; local toolInvisHandle = nil; local toolInvisOffset = 50000; local toolEquipConn = nil; local invisCamTarget = nil
local origToolInvisCollide = {} 

local function toggleToolInvis()
    isToolInvis = not isToolInvis
    local char = LocalPlayer.Character; local root = char and char:FindFirstChild("HumanoidRootPart"); local hum = char and char:FindFirstChild("Humanoid")
    if not char or not root or not hum then isToolInvis = false return end

    if isToolInvis then
        ToolInvisBtn.Text = "Tool Invis: ON"; ToolInvisBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        
        toolInvisHandle = Instance.new("Part"); toolInvisHandle.Transparency = 1; toolInvisHandle.CanCollide = true; toolInvisHandle.Anchored = true
        toolInvisHandle.Size = Vector3.new(5000, 1, 5000); toolInvisHandle.CFrame = root.CFrame * CFrame.new(0, toolInvisOffset - 3.5, 0); toolInvisHandle.Parent = Workspace
        
        invisCamTarget = Instance.new("Part"); invisCamTarget.Transparency = 1; invisCamTarget.CanCollide = false; invisCamTarget.Anchored = true
        invisCamTarget.CFrame = root.CFrame; invisCamTarget.Parent = Workspace
        Workspace.CurrentCamera.CameraSubject = invisCamTarget
        
        origToolInvisCollide = {}
        for _, part in ipairs(char:GetDescendants()) do 
            if part:IsA("BasePart") then 
                origToolInvisCollide[part] = part.CanCollide
                part.CanCollide = false 
            end 
        end
        root.CFrame = root.CFrame * CFrame.new(0, toolInvisOffset, 0)

        toolEquipConn = char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then task.wait(); if child:FindFirstChild("Grip") then child.Grip = child.Grip * CFrame.new(0, toolInvisOffset, 0) * CFrame.Angles(math.rad(-90), 0, 0) end end
        end)
        
        task.spawn(function()
            while isToolInvis and root and invisCamTarget and invisCamTarget.Parent do
                invisCamTarget.CFrame = root.CFrame * CFrame.new(0, -toolInvisOffset, 0)
                task.wait()
            end
        end)
    else
        ToolInvisBtn.Text = "Tool Invis: OFF"; ToolInvisBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
        if toolInvisHandle then toolInvisHandle:Destroy() end; if invisCamTarget then invisCamTarget:Destroy() end; if toolEquipConn then toolEquipConn:Disconnect() end
        
        root.CFrame = root.CFrame * CFrame.new(0, -toolInvisOffset, 0)
        
        for _, part in ipairs(char:GetDescendants()) do 
            if part:IsA("BasePart") and origToolInvisCollide[part] ~= nil then 
                part.CanCollide = origToolInvisCollide[part] 
            end 
        end
        origToolInvisCollide = {}
        Workspace.CurrentCamera.CameraSubject = hum
    end
end
ToolInvisBtn.MouseButton1Click:Connect(toggleToolInvis)

local function grabGunDrop()
    local currentMap = getCurrentMap(); if not currentMap then return end; local gunDrop = currentMap:FindFirstChild("GunDrop")
    if gunDrop then local myChar = LocalPlayer.Character; local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart"); if myRoot then GrabGunBtn.Text = "Grabbing..."; local originalCFrame = myRoot.CFrame; SafeTeleport(CFrame.new(gunDrop.Position)); task.wait(0.05); if myChar and myChar:FindFirstChild("HumanoidRootPart") then SafeTeleport(originalCFrame) end; GrabGunBtn.Text = "Grab Gun Drop" end end
end

local function stopOrbit()
    isOrbitOn = false
    if orbitConn1 then orbitConn1:Disconnect() orbitConn1 = nil end; if orbitConn2 then orbitConn2:Disconnect() orbitConn2 = nil end; if orbitConn3 then orbitConn3:Disconnect() orbitConn3 = nil end; if orbitConn4 then orbitConn4:Disconnect() orbitConn4 = nil end
    OrbitBtn.Text = "Orbit Target"; OrbitBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    local myChar = LocalPlayer.Character; if myChar then for _, part in ipairs(myChar:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end end
    if originalOrbitCFrame then SafeTeleport(originalOrbitCFrame); originalOrbitCFrame = nil end
end

local function toggleOrbit()
    if isOrbitOn then stopOrbit() return end
    local str = OrbitInput.Text:lower(); if str == "" or str == "username" then return end; local target = nil
    for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and (p.Name:lower():find(str) or p.DisplayName:lower():find(str)) then target = p break end end
    if not target then OrbitBtn.Text = "Not Found!"; task.wait(1); if not isOrbitOn then OrbitBtn.Text = "Orbit Target" end return end
    local myChar = LocalPlayer.Character; local root = myChar and myChar:FindFirstChild("HumanoidRootPart"); local hum = myChar and myChar:FindFirstChild("Humanoid")
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and root and hum then
        originalOrbitCFrame = root.CFrame; isOrbitOn = true; orbitTarget = target
        OrbitBtn.Text = "Orbiting: " .. target.Name; OrbitBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 200)
        orbitConn3 = RunService.Stepped:Connect(function() if myChar then for _, part in ipairs(myChar:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end end end)
        orbitConn1 = RunService.Heartbeat:Connect(function() pcall(function() if not isOrbitOn then return end; local tChar = orbitTarget.Character; local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart"); local tHum = tChar and tChar:FindFirstChild("Humanoid"); if not tRoot or not tHum or tHum.Health <= 0 then stopOrbit() return end; local s = tonumber(OrbitSpeedInput.Text) or 0.2; local d = tonumber(OrbitDistInput.Text) or 6; orbitRot = orbitRot + s; root.CFrame = CFrame.new(tRoot.Position) * CFrame.Angles(0, math.rad(orbitRot), 0) * CFrame.new(d, 0, 0) end) end)
        orbitConn2 = RunService.RenderStepped:Connect(function() pcall(function() if not isOrbitOn then return end; local tChar = orbitTarget.Character; local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart"); if tRoot then root.CFrame = CFrame.new(root.Position, tRoot.Position) end end) end)
        orbitConn4 = hum.Died:Connect(function() stopOrbit() end)
    end
end
OrbitBtn.MouseButton1Click:Connect(toggleOrbit)

local function executeKnifeSteal()
    local amIMurderer = isPlayerMurderer(LocalPlayer); if amIMurderer then return end
    local myChar = LocalPlayer.Character; local bp = LocalPlayer:FindFirstChild("Backpack"); local myKnife = (myChar and myChar:FindFirstChild("Knife")) or (bp and bp:FindFirstChild("Knife")); if myKnife then return end
    local targetKnife = nil
    for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and isPlayerMurderer(p) then local c = p.Character; local b = p:FindFirstChild("Backpack"); if c and c:FindFirstChild("Knife") then targetKnife = c.Knife elseif b and b:FindFirstChild("Knife") then targetKnife = b.Knife end break end end
    if targetKnife and bp then local clone = targetKnife:Clone(); clone.ToolTip = "Stolen by God-Eye 🤑"; clone:SetAttribute("CopiedByScript", true); local physicalTag = Instance.new("BoolValue"); physicalTag.Name = "CopiedByGodEye"; physicalTag.Value = true; physicalTag.Parent = clone; clone.Parent = bp end
end
StealKnifeBtn.MouseButton1Click:Connect(executeKnifeSteal)

ForceEquipKnifeBtn.MouseButton1Click:Connect(function() local bp = LocalPlayer:FindFirstChild("Backpack"); local myChar = LocalPlayer.Character; if bp and myChar then local knife = bp:FindFirstChild("Knife"); if knife then knife.Parent = myChar end end end)
FlingModeBtn.MouseButton1Click:Connect(function() if flingMode == "GIGA" then flingMode = "CLASSIC"; FlingModeBtn.Text = "Fling Mode: CLASSIC"; FlingModeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 200) else flingMode = "GIGA"; FlingModeBtn.Text = "Fling Mode: GIGA"; FlingModeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 200) end end)

TargetShootToggle.MouseButton1Click:Connect(function() isTargetShootOn = not isTargetShootOn; TargetShootToggle.Text = isTargetShootOn and "Shoot Target: ON" or "Shoot Target: OFF"; TargetShootToggle.BackgroundColor3 = isTargetShootOn and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50) end)

local speedConn = nil; local speedCharConn = nil
local function enforceSpeed(hum) if not isSpeedLocked then return end if hum.WalkSpeed ~= lockedSpeed then hum.WalkSpeed = lockedSpeed end end
local function setupSpeedLock(char) if not char then return end; local hum = char:WaitForChild("Humanoid", 2); if hum then if isSpeedLocked then hum.WalkSpeed = lockedSpeed end; if speedConn then speedConn:Disconnect() end; speedConn = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function() enforceSpeed(hum) end) end end
SpeedInput:GetPropertyChangedSignal("Text"):Connect(function() local val = tonumber(SpeedInput.Text); if val then lockedSpeed = val; if isSpeedLocked then local myChar = LocalPlayer.Character; if myChar and myChar:FindFirstChild("Humanoid") then myChar.Humanoid.WalkSpeed = lockedSpeed end end end end)

-- ==========================================
-- GIGA SPAWN HANDLER (GOD MODE PERSISTENCE)
-- ==========================================
saveConn(LocalPlayer.CharacterAdded:Connect(function(char) 
    task.wait(0.5); LocalPlayer.CameraMaxZoomDistance = maxZoomValue; if isNoclipCamOn then hookMemoryNoclipCam(true) end; if isSpeedLocked then setupSpeedLock(char) end
    if godState.enabled then if godState.persistent then clearGodConnections(); wireGodMode(char) else toggleGodModeState() end end
end))

local function toggleFeature(feature)
    if feature == "ESP" then
        isESPOn = not isESPOn; ESPToggle.BackgroundColor3 = isESPOn and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50); ESPToggle.Text = isESPOn and "Player & Gun ESP: ON" or "Player & Gun ESP: OFF"
        if not isESPOn then clearAllPlayerESP(); espRoundState = "IDLE"; hasGunDroppedThisRound = false else local hasKnife = false; for _, p in ipairs(Players:GetPlayers()) do if isPlayerMurderer(p) then hasKnife = true break end end; if hasKnife then espRoundState = "KNIFE_FOUND" else espRoundState = "WAITING_FOR_KNIFE" end; executeFullESPScan() end
    elseif feature == "CoinESP" then isCoinESPOn = not isCoinESPOn; CoinToggle.BackgroundColor3 = isCoinESPOn and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50); CoinToggle.Text = isCoinESPOn and "Coin ESP: ON" or "Coin ESP: OFF"; if not isCoinESPOn then local m = getCurrentMap(); if m and m:FindFirstChild("CoinContainer") then for _, c in ipairs(m.CoinContainer:GetChildren()) do local a = c:FindFirstChild("CoinAdornment"); if a then a:Destroy() end end end end
    elseif feature == "AutoCoin" then isAutoCoinOn = not isAutoCoinOn; AutoCoinToggle.BackgroundColor3 = isAutoCoinOn and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50); AutoCoinToggle.Text = isAutoCoinOn and "Auto Coin: ON" or "Auto Coin: OFF"; if isAutoCoinOn and isAutoCoinSafeOn then toggleFeature("AutoCoinSafe") end; if not isAutoCoinOn and autoCoinTween then autoCoinTween:Cancel() end
    elseif feature == "AutoCoinSafe" then isAutoCoinSafeOn = not isAutoCoinSafeOn; AutoCoinSafeToggle.BackgroundColor3 = isAutoCoinSafeOn and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50); AutoCoinSafeToggle.Text = isAutoCoinSafeOn and "Auto Coin Safe: ON" or "Auto Coin Safe: OFF"; if isAutoCoinSafeOn and isAutoCoinOn then toggleFeature("AutoCoin") end
    elseif feature == "AutoCopyKnife" then isAutoCopyKnifeOn = not isAutoCopyKnifeOn; AutoCopyKnifeToggle.BackgroundColor3 = isAutoCopyKnifeOn and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50); AutoCopyKnifeToggle.Text = isAutoCopyKnifeOn and "Auto Copy Knife: ON" or "Auto Copy Knife: OFF"
    elseif feature == "LoopTrip" then isLoopTripOn = not isLoopTripOn; LoopTripToggle.BackgroundColor3 = isLoopTripOn and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50); LoopTripToggle.Text = isLoopTripOn and "Loop Trip: ON" or "Loop Trip: OFF"; if not isLoopTripOn then local myChar = LocalPlayer.Character; if myChar and myChar:FindFirstChild("Humanoid") then myChar.Humanoid.PlatformStand = false end end
    elseif feature == "AntiFling" then isAntiFlingOn = not isAntiFlingOn; AntiFlingToggle.BackgroundColor3 = isAntiFlingOn and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50); AntiFlingToggle.Text = isAntiFlingOn and "Anti-Fling Safe Mode: ON" or "Anti-Fling Safe Mode: OFF"; if not isAntiFlingOn then forceRestoreCollisions() end
    elseif feature == "AutoShoot" then isAutoShootOn = not isAutoShootOn; AutoShootToggle.BackgroundColor3 = isAutoShootOn and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50); AutoShootToggle.Text = isAutoShootOn and "Shoot Murderer: ON" or "Shoot Murderer: OFF"
    elseif feature == "Hitbox" then isHitboxManual = not isHitboxManual; HitboxToggle.BackgroundColor3 = isHitboxManual and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50); HitboxToggle.Text = isHitboxManual and "Hitbox Expander: ON" or "Hitbox Expander: OFF"; if not isHitboxManual then forceRestoreCollisions() end
    elseif feature == "NoclipCam" then isNoclipCamOn = not isNoclipCamOn; NoclipCamToggle.BackgroundColor3 = isNoclipCamOn and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50); NoclipCamToggle.Text = isNoclipCamOn and "Memory Noclip Cam: ON" or "Memory Noclip Cam: OFF"; hookMemoryNoclipCam(isNoclipCamOn)
    elseif feature == "AutoGrabGun" then isAutoGrabGunOn = not isAutoGrabGunOn; AutoGrabGunToggle.BackgroundColor3 = isAutoGrabGunOn and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50); AutoGrabGunToggle.Text = isAutoGrabGunOn and "Auto Grab Gun: ON" or "Auto Grab Gun: OFF"
    elseif feature == "Speed" then isSpeedLocked = not isSpeedLocked; SpeedBtn.BackgroundColor3 = isSpeedLocked and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50); SpeedBtn.Text = isSpeedLocked and "Lock WalkSpeed: ON" or "Lock WalkSpeed: OFF"
        if isSpeedLocked then local val = tonumber(SpeedInput.Text); if val then lockedSpeed = val else SpeedInput.Text = tostring(lockedSpeed) end; setupSpeedLock(LocalPlayer.Character); if speedCharConn then speedCharConn:Disconnect() end; speedCharConn = LocalPlayer.CharacterAdded:Connect(setupSpeedLock)
        else if speedConn then speedConn:Disconnect(); speedConn = nil end; if speedCharConn then speedCharConn:Disconnect(); speedCharConn = nil end; local myChar = LocalPlayer.Character; if myChar and myChar:FindFirstChild("Humanoid") then myChar.Humanoid.WalkSpeed = 16 end end
    end
end

ESPToggle.MouseButton1Click:Connect(function() toggleFeature("ESP") end); CoinToggle.MouseButton1Click:Connect(function() toggleFeature("CoinESP") end)
AutoCoinToggle.MouseButton1Click:Connect(function() toggleFeature("AutoCoin") end); AutoCoinSafeToggle.MouseButton1Click:Connect(function() toggleFeature("AutoCoinSafe") end)
AutoCopyKnifeToggle.MouseButton1Click:Connect(function() toggleFeature("AutoCopyKnife") end); LoopTripToggle.MouseButton1Click:Connect(function() toggleFeature("LoopTrip") end)
AntiFlingToggle.MouseButton1Click:Connect(function() toggleFeature("AntiFling") end); AutoShootToggle.MouseButton1Click:Connect(function() toggleFeature("AutoShoot") end)
HitboxToggle.MouseButton1Click:Connect(function() toggleFeature("Hitbox") end); NoclipCamToggle.MouseButton1Click:Connect(function() toggleFeature("NoclipCam") end)
SpeedBtn.MouseButton1Click:Connect(function() toggleFeature("Speed") end); AutoGrabGunToggle.MouseButton1Click:Connect(function() toggleFeature("AutoGrabGun") end)
GrabGunBtn.MouseButton1Click:Connect(grabGunDrop)

AnimWatcherBtn.MouseButton1Click:Connect(function() AnimWatcherBtn.Text = "Loading..."; pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Alone2718/AnimTracker/refs/heads/main/AnimTracker"))() end); task.wait(1); AnimWatcherBtn.Text = "Load Animation Watcher" end)

local function getClosestAlivePlayer()
    local closest = nil; local minDist = math.huge; local myChar = LocalPlayer.Character; if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = myChar.HumanoidRootPart.Position
    for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then local dist = (p.Character.HumanoidRootPart.Position - myPos).Magnitude; if dist < minDist then minDist = dist; closest = p end end end
    return closest
end

local function executeBringSystem(mode, inputStr)
    bringTargetPlayers = {}; bringOriginalCFrames = {}; bringEndTime = tick() + 5; currentBringMode = mode
    if mode == "ALL" then
        for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then table.insert(bringTargetPlayers, p); bringOriginalCFrames[p] = p.Character.HumanoidRootPart.CFrame end end
        if #bringTargetPlayers > 0 then BringAllBtn.Text = "Bringing ALL..."; BringAllBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50) else BringAllBtn.Text = "Nobody Alive!"; task.wait(1); if currentBringMode ~= "ALL" then return end; BringAllBtn.Text = "Bring ALL Players" end
    elseif mode == "CLOSEST" then
        local target = getClosestAlivePlayer()
        if target then table.insert(bringTargetPlayers, target); bringOriginalCFrames[target] = target.Character.HumanoidRootPart.CFrame; BringClosestBtn.Text = "Bringing Closest..."; BringClosestBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50) else BringClosestBtn.Text = "Nobody Alive!"; task.wait(1); if currentBringMode ~= "CLOSEST" then return end; BringClosestBtn.Text = "Bring Closest Player" end
    elseif mode == "SHERIFF" then
        local target = nil; for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and isPlayerSheriff(p) then target = p break end end
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then table.insert(bringTargetPlayers, target); bringOriginalCFrames[target] = target.Character.HumanoidRootPart.CFrame; BringSheriffBtn.Text = "Bringing Sheriff..."; BringSheriffBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50) else BringSheriffBtn.Text = "No Sheriff Alive!"; task.wait(1); if currentBringMode ~= "SHERIFF" then return end; BringSheriffBtn.Text = "Bring Sheriff" end
    elseif mode == "NORMAL" then
        local str = inputStr:lower(); if str == "" or str == "username" then return end; local target = nil
        for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and (p.Name:lower():find(str) or p.DisplayName:lower():find(str)) then target = p break end end
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then table.insert(bringTargetPlayers, target); bringOriginalCFrames[target] = target.Character.HumanoidRootPart.CFrame; BringBtn.Text = "Bringing..."; BringBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50) else BringBtn.Text = "Not Found!"; task.wait(1); if currentBringMode ~= "NORMAL" then return end; BringBtn.Text = "Bring Player" end
    end
end

local function uiResetFling() isFlingToggleOn = false; flingTargetPlayer = nil; FlingBtn.Text = "Smart Fling Lock-On"; FlingBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0); FlingMurdBtn.Text = "Fling Murderer Lock-On"; FlingMurdBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 200); FlingSherBtn.Text = "Fling Sheriff Lock-On"; FlingSherBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 200) end

local function executePanic()
    isFlinging = false; isFlingNoclipping = false; isFlingToggleOn = false; currentlyFlingingPlayer = nil; if isOrbitOn then stopOrbit() end
    bringEndTime = 0; currentBringMode = nil; bringTargetPlayers = {}; bringOriginalCFrames = {}
    BringBtn.Text = "Bring Player"; BringBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 200); BringClosestBtn.Text = "Bring Closest Player"; BringClosestBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 200); BringAllBtn.Text = "Bring ALL Players"; BringAllBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); BringSheriffBtn.Text = "Bring Sheriff"; BringSheriffBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 200); uiResetFling()
    local myChar = LocalPlayer.Character
    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
        local myRoot = myChar.HumanoidRootPart; local spawnsFolder = Workspace:FindFirstChild("RegularLobby") and Workspace.RegularLobby:FindFirstChild("Spawns")
        if spawnsFolder then local validSpawns = {}; for _, s in ipairs(spawnsFolder:GetChildren()) do if s.Name == "Spawn" or s.Name == "PlayerSpawn" then table.insert(validSpawns, s) end end; if #validSpawns > 0 then local randomSpawn = validSpawns[math.random(1, #validSpawns)]; SafeTeleport(randomSpawn.CFrame + Vector3.new(0, 5, 0)); myRoot.Anchored = true; PanicBtn.Text = "🚨 PANICKING..."; PanicBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0); task.spawn(function() task.wait(1); if myChar and myChar:FindFirstChild("HumanoidRootPart") then myChar.HumanoidRootPart.Anchored = false end; PanicBtn.Text = "🚨 Panic!"; PanicBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0) end) end end
    end
end

BringBtn.MouseButton1Click:Connect(function() executeBringSystem("NORMAL", BringInput.Text) end); BringClosestBtn.MouseButton1Click:Connect(function() executeBringSystem("CLOSEST") end); BringAllBtn.MouseButton1Click:Connect(function() executeBringSystem("ALL") end); BringSheriffBtn.MouseButton1Click:Connect(function() executeBringSystem("SHERIFF") end); PanicBtn.MouseButton1Click:Connect(executePanic)

saveConn(UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if bindingAction then
        local keyName = input.KeyCode.Name; if input.KeyCode == Enum.KeyCode.Unknown then return end 
        if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.Backspace then keyName = "" end
        binds[bindingAction.id] = keyName; bindingAction.button.Text = keyName ~= "" and keyName or "NONE"; saveBinds(); bindingAction = nil; return
    end
    if not gameProcessed then
        for id, key in pairs(binds) do
            if key ~= "" and input.KeyCode.Name == key then
                if id == "Bring" then executeBringSystem("NORMAL", BringInput.Text) elseif id == "BringClosest" then executeBringSystem("CLOSEST") elseif id == "BringAll" then executeBringSystem("ALL") elseif id == "BringSheriff" then executeBringSystem("SHERIFF") elseif id == "Panic" then executePanic() elseif id == "GrabGun" then grabGunDrop() elseif id == "AutoCopyKnife" then toggleFeature(id) elseif id == "AutoCoin" then toggleFeature(id) elseif id == "AutoCoinSafe" then toggleFeature(id) elseif id == "LoopTrip" then toggleFeature(id) elseif id == "PureInvis" then togglePureInvis() elseif id == "ToolInvis" then toggleToolInvis() elseif id == "GodMode" then toggleGodModeState() elseif id == "Orbit" then toggleOrbit() else toggleFeature(id) end
            end
        end
    end
end))

local currentAnimTrack = nil
PlayAnimBtn.MouseButton1Click:Connect(function() local idStr = AnimInput.Text:match("%d+"); if idStr then local myChar = LocalPlayer.Character; if myChar and myChar:FindFirstChild("Humanoid") then local animator = myChar.Humanoid:FindFirstChild("Animator") or Instance.new("Animator", myChar.Humanoid); local anim = Instance.new("Animation"); anim.AnimationId = "rbxassetid://" .. idStr; if currentAnimTrack then currentAnimTrack:Stop() end; currentAnimTrack = animator:LoadAnimation(anim); currentAnimTrack:Play(); PlayAnimBtn.Text = "Playing..."; task.delay(1, function() if PlayAnimBtn.Text == "Playing..." then PlayAnimBtn.Text = "Play Animation" end end) end end end)
saveConn(RunService.Heartbeat:Connect(function() if currentAnimTrack and currentAnimTrack.IsPlaying then local myChar = LocalPlayer.Character; if myChar and myChar:FindFirstChild("HumanoidRootPart") then if myChar.HumanoidRootPart.Velocity.Magnitude > 10 then currentAnimTrack:Stop(); currentAnimTrack = nil end end end end))

-- ==========================================
-- GIGA SMART FLING TOGGLE (CHAD ENGINE) 🌪️🤑
-- ==========================================
FlingBtn.MouseButton1Click:Connect(function() if isFlingToggleOn then uiResetFling() return end; local str = FlingInput.Text:lower(); if str == "" or str == "username" then return end; for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and (p.Name:lower():find(str) or p.DisplayName:lower():find(str)) then flingTargetPlayer = p; isFlingToggleOn = true; FlingBtn.Text = "Locking: " .. p.Name; FlingBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 200) break end end; if not isFlingToggleOn then FlingBtn.Text = "Not Found!"; task.wait(1); if not isFlingToggleOn then FlingBtn.Text = "Smart Fling Lock-On" end end end)
FlingMurdBtn.MouseButton1Click:Connect(function() if isFlingToggleOn then uiResetFling() return end; for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and isPlayerMurderer(p) then flingTargetPlayer = p; isFlingToggleOn = true; FlingMurdBtn.Text = "Locking: " .. p.Name; FlingMurdBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 200) break end end end)
FlingSherBtn.MouseButton1Click:Connect(function() if isFlingToggleOn then uiResetFling() return end; for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and isPlayerSheriff(p) then flingTargetPlayer = p; isFlingToggleOn = true; FlingSherBtn.Text = "Locking: " .. p.Name; FlingSherBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 200) break end end end)

task.spawn(function()
    while env.MM2Running do
        task.wait()
        if isFlingToggleOn and flingTargetPlayer and not isFlinging then
            local tChar = flingTargetPlayer.Character; local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart"); local tHum = tChar and tChar:FindFirstChild("Humanoid")
            if tRoot and tHum and tHum.Health > 0 and tRoot.Velocity.Magnitude < 2 then
                local loggedPos = tRoot.Position; local myChar = LocalPlayer.Character; local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart"); local myHum = myChar and myChar:FindFirstChild("Humanoid")
                if myRoot and myHum and myHum.Health > 0 then
                    isFlinging = true; isFlingNoclipping = true; currentlyFlingingPlayer = flingTargetPlayer; local originalCFrame = myRoot.CFrame; local origCollide = {}
                    for _, child in ipairs(myChar:GetDescendants()) do if child:IsA("BasePart") then origCollide[child] = child.CanCollide; child.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5); child.CanCollide = false; child.Massless = true; child.Velocity = Vector3.zero end end
                    local bambam = Instance.new("BodyAngularVelocity"); bambam.Name = "GigaFlingBAV"; bambam.AngularVelocity = Vector3.new(9999999, 9999999, 9999999); bambam.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); bambam.P = math.huge; bambam.Parent = myRoot
                    local attachConn = RunService.Heartbeat:Connect(function() if isFlinging and currentlyFlingingPlayer and currentlyFlingingPlayer.Character then local ttRoot = currentlyFlingingPlayer.Character:FindFirstChild("HumanoidRootPart"); local ttTorso = currentlyFlingingPlayer.Character:FindFirstChild("Torso") or currentlyFlingingPlayer.Character:FindFirstChild("UpperTorso") or ttRoot; if ttRoot then if flingMode == "GIGA" then myRoot.CFrame = CFrame.new(ttTorso.Position) * CFrame.new(0, 1, 0) else myRoot.CFrame = CFrame.new(ttTorso.Position) end end end end)
                    local movel = 1000
                    while isFlinging and isFlingToggleOn do task.wait(); if not myChar or not myRoot or myHum.Health <= 0 then break end; if not tChar or not tRoot or tHum.Health <= 0 then break end; if (tRoot.Position - loggedPos).Magnitude >= 50 then isFlingToggleOn = false break end; if flingMode == "GIGA" then local vel = myRoot.Velocity; myRoot.Velocity = vel * 10000 + Vector3.new(0, 10000, 0); RunService.RenderStepped:Wait(); if myRoot then myRoot.Velocity = vel end; RunService.Stepped:Wait(); if myRoot then myRoot.Velocity = vel + Vector3.new(0, movel, 0); movel = movel * -1 end end end
                    isFlinging = false; isFlingNoclipping = false; currentlyFlingingPlayer = nil; if attachConn then attachConn:Disconnect() end; if bambam then bambam:Destroy() end
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") and myHum.Health > 0 then SafeTeleport(originalCFrame); for _, child in ipairs(myChar:GetDescendants()) do if child:IsA("BasePart") then child.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5); if origCollide[child] ~= nil then child.CanCollide = origCollide[child] end; child.Massless = false end end end
                    if not isFlingToggleOn then uiResetFling() end
                end
            end
        end
    end
end)

saveConn(RunService.Stepped:Connect(function()
    if isFlingNoclipping and LocalPlayer.Character then for _, part in ipairs(LocalPlayer.Character:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end end
    local shouldExpand = isHitboxManual or isHitboxAuto; local currentTime = tick()
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character; local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            if not hum or hum.Health <= 0 then continue end
            
            local isTargetFlinging = false
            if isAntiFlingOn and hrp then if (hrp.Velocity.Magnitude > 150 or hrp.RotVelocity.Magnitude > 150) and currentlyFlingingPlayer ~= p then char:SetAttribute("GodEyeFlingTag", currentTime) end; local lastFlingTime = char:GetAttribute("GodEyeFlingTag") or 0; if (currentTime - lastFlingTime) < 3 then isTargetFlinging = true end end
            if isTargetFlinging then for _, part in ipairs(char:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end; char:SetAttribute("WasFlinging", true)
            else if char:GetAttribute("WasFlinging") then for _, part in ipairs(char:GetChildren()) do if part:IsA("BasePart") and (part.Name == "HumanoidRootPart" or part.Name == "Torso" or part.Name == "UpperTorso" or part.Name == "Head") then part.CanCollide = true end end; char:SetAttribute("WasFlinging", nil) end; if shouldExpand and hrp then hrp.CanCollide = false end end
        end
    end
    
    if currentBringMode then
        local myChar = LocalPlayer.Character; local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if tick() < bringEndTime and myRoot then for i = #bringTargetPlayers, 1, -1 do local target = bringTargetPlayers[i]; local targetChar = target.Character; local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart"); local isAlive = targetChar and targetChar:FindFirstChild("Humanoid") and targetChar.Humanoid.Health > 0; if isAlive and targetRoot then targetRoot.CFrame = myRoot.CFrame * CFrame.new(0, 0, -3); targetRoot.Velocity = Vector3.zero else bringOriginalCFrames[target] = nil; table.remove(bringTargetPlayers, i) end end; if #bringTargetPlayers == 0 then bringEndTime = 0 end
        else for target, origCFrame in pairs(bringOriginalCFrames) do local targetChar = target and target.Character; local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart"); local isAlive = targetChar and targetChar:FindFirstChild("Humanoid") and targetChar.Humanoid.Health > 0; if isAlive and targetRoot then targetRoot.Velocity = Vector3.zero; targetRoot.CFrame = origCFrame end end; bringTargetPlayers = {}; bringOriginalCFrames = {}; currentBringMode = nil; BringBtn.Text = "Bring Player"; BringBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 200); BringClosestBtn.Text = "Bring Closest Player"; BringClosestBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 200); BringAllBtn.Text = "Bring ALL Players"; BringAllBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); BringSheriffBtn.Text = "Bring Sheriff"; BringSheriffBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 200) end
    end
end))

TPLobbyBtn.MouseButton1Click:Connect(function() local spawnsFolder = Workspace:FindFirstChild("RegularLobby") and Workspace.RegularLobby:FindFirstChild("Spawns"); if spawnsFolder then local validSpawns = {}; for _, s in ipairs(spawnsFolder:GetChildren()) do if s.Name == "Spawn" or s.Name == "PlayerSpawn" then table.insert(validSpawns, s) end end; if #validSpawns > 0 then local randomSpawn = validSpawns[math.random(1, #validSpawns)]; SafeTeleport(randomSpawn.CFrame + Vector3.new(0, 5, 0)) end end end)
TPMapBtn.MouseButton1Click:Connect(function() local map = getCurrentMap(); if map and map:FindFirstChild("Spawns") then local spawns = {}; for _, s in ipairs(map.Spawns:GetChildren()) do if s.Name == "Spawn" or s.Name == "PlayerSpawn" then table.insert(spawns, s) end end; if #spawns > 0 then local randomSpawn = spawns[math.random(1, #spawns)]; SafeTeleport(randomSpawn.CFrame + Vector3.new(0, 5, 0)) end end end)

-- ==========================================
-- GIGA ESP ENGINE & STATE OPTIMIZER 📉🔥
-- ==========================================
local frameCounter = 0; local knifeLastSeen = 0; local gunDropExisted = false; local lastMapExisted = false
saveConn(RunService.RenderStepped:Connect(function()
    frameCounter = frameCounter + 1; if frameCounter < 15 then return end; frameCounter = 0; local currentMap = getCurrentMap()
    
    -- CHAD FIX: MAP WIPE SUPREMACY 🗺️🔥 (The ONLY thing that resets the round state)
    if currentMap then
        if not lastMapExisted then lastMapExisted = true end
    else
        if lastMapExisted then
            lastMapExisted = false
            espRoundState = "IDLE"
            hasGunDroppedThisRound = false
            gunDropExisted = false
            unreachableCoins = {}
            if isESPOn then clearAllPlayerESP() end
            if isCoinESPOn then clearAllCoinESP() end
        end
    end

    if isESPOn then
        local hasKnife = false; local hasSheriff = false
        for _, p in ipairs(Players:GetPlayers()) do if isPlayerMurderer(p) then hasKnife = true end; if isPlayerSheriff(p) then hasSheriff = true end end
        
        local gunDrop = currentMap and currentMap:FindFirstChild("GunDrop")
        local currentGunDropStatus = gunDrop ~= nil
        
        -- CHAD FIX: YELLOW SAVIOR LATCH (Never resets until map wipe)
        if currentGunDropStatus ~= gunDropExisted then
            gunDropExisted = currentGunDropStatus
            if currentGunDropStatus then
                hasGunDroppedThisRound = true 
            end
            executeFullESPScan()
        end

        local newRoundState = espRoundState
        if espRoundState == "IDLE" then 
            if hasKnife then newRoundState = "KNIFE_FOUND"; knifeLastSeen = tick()
            elseif currentMap then newRoundState = "WAITING_FOR_KNIFE" end
        elseif espRoundState == "WAITING_FOR_KNIFE" then 
            -- MAP SUPREMACY: No more gun latch resetting here! 💀
            if hasKnife then newRoundState = "KNIFE_FOUND"; knifeLastSeen = tick() end
        elseif espRoundState == "KNIFE_FOUND" then 
            if hasKnife then knifeLastSeen = tick() 
            else if tick() - knifeLastSeen >= 10 then newRoundState = "IDLE" end end 
        end
        
        if newRoundState ~= espRoundState then
            espRoundState = newRoundState
            if espRoundState ~= "IDLE" then executeFullESPScan() end
        end

        local gunEsp = espStorage:FindFirstChild("GunDrop_ESP")
        if gunDrop then
            if not gunEsp then
                local highlight = Instance.new("Highlight"); highlight.Name = "GunDrop_ESP"; highlight.Adornee = gunDrop; highlight.FillColor = Color3.fromRGB(255, 255, 0); highlight.FillTransparency = 0.3; highlight.OutlineColor = Color3.fromRGB(255, 255, 0); highlight.Parent = espStorage; highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                local bbGui = Instance.new("BillboardGui"); bbGui.Name = "Text"; bbGui.Adornee = gunDrop; bbGui.Size = UDim2.new(0, 100, 0, 50); bbGui.StudsOffset = Vector3.new(0, 3, 0); bbGui.AlwaysOnTop = true; bbGui.Parent = highlight
                local text = Instance.new("TextLabel"); text.Size = UDim2.new(1, 0, 1, 0); text.BackgroundTransparency = 1; text.Text = "GUN!"; text.TextColor3 = Color3.fromRGB(255, 255, 0); text.TextStrokeTransparency = 0; text.Font = Enum.Font.GothamBold; text.TextSize = 22; text.Parent = bbGui
            end
        elseif not gunDrop and gunEsp then 
            gunEsp.Parent = nil; task.defer(function() pcall(function() gunEsp:Destroy() end) end)
        end
    end

    if isCoinESPOn and currentMap then
        local coinContainer = currentMap:FindFirstChild("CoinContainer")
        if coinContainer then
            for _, coin in ipairs(coinContainer:GetChildren()) do 
                if coin.Name == "Coin_Server" then 
                    local adorn = coin:FindFirstChild("CoinAdornment")
                    if not adorn then 
                        adorn = Instance.new("SphereHandleAdornment")
                        adorn.Name = "CoinAdornment"
                        adorn.Adornee = coin
                        adorn.Radius = 1.3
                        adorn.Color3 = Color3.fromRGB(255, 255, 0)
                        adorn.Transparency = 0.4
                        adorn.AlwaysOnTop = true
                        adorn.ZIndex = 0
                        adorn.Parent = coin 
                    end 
                end 
            end
        end
    end
end))

local function getClosestCoin()
    local map = getCurrentMap(); if not map then return nil, math.huge end; local coinContainer = map:FindFirstChild("CoinContainer"); if not coinContainer then return nil, math.huge end; local myChar = LocalPlayer.Character; if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil, math.huge end
    local myPos = myChar.HumanoidRootPart.Position; local closestCoin = nil; local minDist = math.huge
    for _, coin in ipairs(coinContainer:GetChildren()) do if coin.Name == "Coin_Server" and coin:FindFirstChild("TouchInterest") and not unreachableCoins[coin] then local dist = (coin.Position - myPos).Magnitude; if dist < minDist then minDist = dist; closestCoin = coin end end end
    return closestCoin, minDist
end

task.spawn(function()
    local currentTargetCoin = nil; local cooldownEndTime = 0
    while env.MM2Running do
        task.wait()
        if isAutoCoinOn and not isFlinging and not isOrbitOn then
            if tick() < cooldownEndTime then if autoCoinTween then autoCoinTween:Cancel() end continue end
            if currentTargetCoin then if not currentTargetCoin.Parent or not currentTargetCoin:FindFirstChild("TouchInterest") then cooldownEndTime = tick() + 1; currentTargetCoin = nil; if autoCoinTween then autoCoinTween:Cancel() end continue end end
            if not currentTargetCoin then
                local coin, dist = getClosestCoin(); local myChar = LocalPlayer.Character; local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if coin and dist < 1000 and myRoot then currentTargetCoin = coin; for _, part in ipairs(myChar:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end; if autoCoinTween then autoCoinTween:Cancel() end; autoCoinTween = TweenService:Create(myRoot, TweenInfo.new(2, Enum.EasingStyle.Linear), {CFrame = CFrame.new(coin.Position)}); autoCoinTween:Play() else if autoCoinTween then autoCoinTween:Cancel() end end
            else local myChar = LocalPlayer.Character; if myChar then for _, part in ipairs(myChar:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end end end
        else if autoCoinTween then autoCoinTween:Cancel() end; currentTargetCoin = nil end
    end
end)

task.spawn(function()
    while env.MM2Running do
        task.wait() 
        if isAutoCoinSafeOn and not isFlinging and not isOrbitOn then
            local coin, dist = getClosestCoin(); local myChar = LocalPlayer.Character; local myHum = myChar and myChar:FindFirstChild("Humanoid"); local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if coin and dist < 1000 and myHum and myRoot then
                local path = PathfindingService:CreatePath({ AgentRadius = 2, AgentHeight = 5, AgentCanJump = true }); local success, err = pcall(function() path:ComputeAsync(myRoot.Position, coin.Position) end)
                if success and path.Status == Enum.PathStatus.Success then
                    local waypoints = path:GetWaypoints(); local pathStartTime = tick()
                    for i, waypoint in ipairs(waypoints) do
                        if not isAutoCoinSafeOn or not coin or not coin.Parent or not coin:FindFirstChild("TouchInterest") then break end; if isFlinging or isOrbitOn then break end; if tick() - pathStartTime > 5 then unreachableCoins[coin] = true break end
                        if waypoint.Action == Enum.PathWaypointAction.Jump then myHum.Jump = true end; myHum:MoveTo(waypoint.Position)
                        local moveTimeout = tick() + 1.5; local lastPos = myRoot.Position; local stuckTimer = 0
                        repeat task.wait(); if not myRoot or not coin or not coin:FindFirstChild("TouchInterest") then break end; if (myRoot.Position - lastPos).Magnitude < 0.5 then stuckTimer = stuckTimer + task.wait(); if stuckTimer > 0.5 then myHum.Jump = true; stuckTimer = 0 end else lastPos = myRoot.Position; stuckTimer = 0 end until (myRoot.Position - waypoint.Position).Magnitude < 4 or tick() > moveTimeout
                    end
                    if coin and coin:FindFirstChild("TouchInterest") and (myRoot.Position - coin.Position).Magnitude < 5 then task.wait(0.2); if coin:FindFirstChild("TouchInterest") then unreachableCoins[coin] = true end end
                else unreachableCoins[coin] = true; task.wait(0.5) end
            end
        end
    end
end)

task.spawn(function()
    local lastAutoShoot = 0; local lastTargetShoot = 0; local lastAutoGrab = 0
    while env.MM2Running do
        task.wait(0.1) 
        local amIMurderer = isPlayerMurderer(LocalPlayer); local myChar = LocalPlayer.Character; local bp = LocalPlayer:FindFirstChild("Backpack"); local currentMap = getCurrentMap()
        if isLoopTripOn and myChar and myChar:FindFirstChild("Humanoid") then myChar.Humanoid.PlatformStand = true end

        if amIMurderer and not isHitboxManual then isHitboxAuto = true; HitboxToggle.Text = "Hitbox Expander: Auto"; HitboxToggle.BackgroundColor3 = Color3.fromRGB(150, 150, 255) 
        elseif not amIMurderer and isHitboxAuto then isHitboxAuto = false; if not isHitboxManual then HitboxToggle.Text = "Hitbox Expander: OFF"; HitboxToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50); forceRestoreCollisions() end end

        local shouldExpand = isHitboxManual or isHitboxAuto
        for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local hrp = p.Character.HumanoidRootPart; if shouldExpand then hrp.Size = Vector3.new(hitboxMultiplier, hitboxMultiplier, hitboxMultiplier); hrp.Transparency = 1 else hrp.Size = Vector3.new(2, 2, 1); hrp.Transparency = 1 end end end

        if isAutoGrabGunOn and (tick() - lastAutoGrab > 0.5) then if currentMap and currentMap:FindFirstChild("GunDrop") then grabGunDrop(); lastAutoGrab = tick() end end

        if isAutoCopyKnifeOn and not amIMurderer and bp and currentMap then
            if lastCopiedMap ~= currentMap then
                local myKnife = (myChar and myChar:FindFirstChild("Knife")) or (bp and bp:FindFirstChild("Knife"))
                if not myKnife then
                    local targetKnife = nil; for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and isPlayerMurderer(p) then local c = p.Character; local b = p:FindFirstChild("Backpack"); if c and c:FindFirstChild("Knife") then targetKnife = c.Knife elseif b and b:FindFirstChild("Knife") then targetKnife = b.Knife end break end end
                    if targetKnife then local clone = targetKnife:Clone(); clone:SetAttribute("CopiedByScript", true); local physicalTag = Instance.new("BoolValue"); physicalTag.Name = "CopiedByGodEye"; physicalTag.Value = true; physicalTag.Parent = clone; clone.ToolTip = "Stolen by God-Eye 🤑"; clone.Parent = bp; lastCopiedMap = currentMap end
                end
            end
        elseif not currentMap then lastCopiedMap = nil end

        if isTargetShootOn and (tick() - lastTargetShoot > 0.2) then
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                local myRoot = myChar.HumanoidRootPart; local myGun = myChar:FindFirstChild("Gun") or (bp and bp:FindFirstChild("Gun"))
                if myGun then
                    local str = TargetShootInput.Text:lower(); local targetToShoot = nil
                    if str ~= "" and str ~= "username" then local potentialTarget = nil; for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and (p.Name:lower():find(str) or p.DisplayName:lower():find(str)) then potentialTarget = p break end end; if potentialTarget and potentialTarget.Character and potentialTarget.Character:FindFirstChild("HumanoidRootPart") then local dist = (potentialTarget.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude; if dist <= 1000 then targetToShoot = potentialTarget end end end
                    if not targetToShoot then for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and isPlayerMurderer(p) then targetToShoot = p break end end end
                    if targetToShoot and targetToShoot.Character and targetToShoot.Character:FindFirstChild("HumanoidRootPart") then local targetHRP = targetToShoot.Character.HumanoidRootPart; local targetHead = targetToShoot.Character:FindFirstChild("Head"); local myPos = myChar.HumanoidRootPart.Position; local targetPos; if isAimHead and targetHead then targetPos = targetHead.Position else targetPos = targetHRP.Position end; if targetHRP.Velocity.Magnitude > 2 then targetPos = targetPos + (targetHRP.Velocity.Unit * 2.5) end; local shootRemote = myGun:FindFirstChild("Shoot"); if shootRemote then local args = { CFrame.new(myPos, targetPos), CFrame.new(targetPos) }; shootRemote:FireServer(unpack(args)); lastTargetShoot = tick() end end
                end
            end
        end

        if isAutoShootOn and not isTargetShootOn and (tick() - lastAutoShoot > 0.2) then
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                local myGun = myChar:FindFirstChild("Gun") or (bp and bp:FindFirstChild("Gun"))
                if myGun then
                    local murderer = nil; for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and isPlayerMurderer(p) then murderer = p break end end
                    if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then local targetHRP = murderer.Character.HumanoidRootPart; local targetHead = murderer.Character:FindFirstChild("Head"); local myPos = myChar.HumanoidRootPart.Position; local targetPos; if isAimHead and targetHead then targetPos = targetHead.Position else targetPos = targetHRP.Position end; if targetHRP.Velocity.Magnitude > 2 then targetPos = targetPos + (targetHRP.Velocity.Unit * 2.5) end; local shootRemote = myGun:FindFirstChild("Shoot"); if shootRemote then local args = { CFrame.new(myPos, targetPos), CFrame.new(targetPos) }; shootRemote:FireServer(unpack(args)); lastAutoShoot = tick() end end
                end
            end
        end
    end
end)

LocalPlayer.CameraMaxZoomDistance = maxZoomValue 
print("MM2 God-Eye Pro v81 GIGA Loaded!")
