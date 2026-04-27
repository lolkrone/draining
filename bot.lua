
-- REAUTOEXEC 

local urls = {
    "https://raw.githubusercontent.com/lolkrone/draining/main/bot.lua", -- main
    "https://pastebin.com/raw/806KNdB0" -- backup
}

local function getWorkingUrl()
    for _, url in ipairs(urls) do
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        if success and result and #result > 0 then
            return url
        end
    end
    return nil
end

local workingUrl = getWorkingUrl()

if workingUrl then
    local queue = queue_on_teleport or (syn and syn.queue_on_teleport)
    if queue then
        queue('loadstring(game:HttpGet("'..workingUrl..'"))()')
    end
else
    warn("No working script URL found")
end

-- CONFIRMATION
print("lol the script works g")

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

------------------------------------------------
-- LOCAL ANIMATION PLAYER (SAFE)
------------------------------------------------

local Emotes = {
    3333499508,3695333486,3333136415,3338042785,4940561610,
    4940564896,4841399916,4641985101,4555782893,4265725525,
    3338097973,3333432454,3333387824,4406555273,4212455378,
    4049037604,3695300085,3695322025,5915648917,5915714366,
    5918726674,5917459365,5915712534,5915713518,5937558680,
    5918728267,5937560570,507776043,507777268,507771019,
}
local AnimationId = "rbxassetid://" .. Emotes[math.random(1,#Emotes)]
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local anim = Instance.new("Animation")
anim.AnimationId = AnimationId
local track = hum:LoadAnimation(anim)
track.Looped = true
track:Play()

------------------------------------------------
-- AUTO CHAT MESSAGES
------------------------------------------------

local JoinMessages = {
    "there goes ur game hahahahhah ur so mad | krone | /asking",
    "i know yall hate to see me coming HHAHAH ; krone | /asking",
    "RBLX VS krone? lol | join /asking",
    "i own the entire server lol ",
    "wanna be friends lul join /asking",
    "ik yall missd me hyb lol {krone} /asking",
    " be immune to fling and join /asking | krone",
    "krone is running ROBLOX again AHHHH!!! send help NOW /asking",
    "boost the server to be immune to getting flung | /asking",
    " join /asking for comgirls",
    " hii im alyssa and im going on cam in /asking TN",
    " krone owns you lol /asking",
    "yall ready or nah | krone | /asking",
    "do something about me then LOL ||| krone",
    "look me in my hunter eyes while i do this [krone]",
    "yeah go  and serverhop | /asking",
    "ayo watch out!!!!! /asking | krone",
    "yes krone is the best person ever lolll /asking",


}

local function shuffle(t)
    for i = #t,2,-1 do
        local j = math.random(i)
        t[i],t[j] = t[j],t[i]
    end
end

task.spawn(function()
    task.wait(2.5)
    if TextChatService.ChatVersion ~= Enum.ChatVersion.TextChatService then return end
    local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
    if not channel then return end
    while true do
        local msgs = table.clone(JoinMessages)
        shuffle(msgs)
        for _,msg in ipairs(msgs) do
            channel:SendAsync(msg)
            task.wait(2.5)
        end
    end
end)

------------------------------------------------
-- AVOID LIST
------------------------------------------------

local AvoidUserIds = {
    10395766369,987654321,10253861328,10253908110,10283443701,
    10395776007,2561094270,2427285,10214659178,2561094270, 1004380
    
}

local function isAvoided(player)
    for _,id in ipairs(AvoidUserIds) do
        if player.UserId == id then return true end
    end
    return false
end

------------------------------------------------
-- MULTI-TARGET FLING FUNCTION (BURGER)
------------------------------------------------

local FlingActive = true -- Automatically start
local getgenv = getgenv or function() return _G end
getgenv().OldPos = nil
getgenv().FPDH = workspace.FallenPartsDestroyHeight

local function Message(title,text,time)
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = title, Text = text, Duration = time or 5
    })
end

local function SkidFling(TargetPlayer)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    local TCharacter = TargetPlayer.Character
    if not TCharacter then return end

    local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = Accessory and Accessory:FindFirstChild("Handle")
    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then getgenv().OldPos = RootPart.CFrame end
        if THumanoid and THumanoid.Sit then return end

        if THead then workspace.CurrentCamera.CameraSubject = THead
        elseif Handle then workspace.CurrentCamera.CameraSubject = Handle
        elseif THumanoid and TRootPart then workspace.CurrentCamera.CameraSubject = THumanoid
        end

        if not TCharacter:FindFirstChildWhichIsA("BasePart") then return end

        local FPos = function(BasePart,Pos,Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position)*Pos*Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position)*Pos*Ang)
            RootPart.Velocity = Vector3.new(9e7,9e7*10,9e7)
            RootPart.RotVelocity = Vector3.new(9e8,9e8,9e8)
        end

        local SFBasePart = function(BasePart)
            local TimeToWait,Time = 2,tick()
            local Angle = 0
            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle = Angle + 100
                        FPos(BasePart, CFrame.new(0,1.5,0)+THumanoid.MoveDirection*BasePart.Velocity.Magnitude/1.25,
                            CFrame.Angles(math.rad(Angle),0,0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0,-1.5,0)+THumanoid.MoveDirection*BasePart.Velocity.Magnitude/1.25,
                            CFrame.Angles(math.rad(Angle),0,0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0,1.5,THumanoid.WalkSpeed),CFrame.Angles(math.rad(90),0,0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0,-1.5,-THumanoid.WalkSpeed),CFrame.Angles(0,0,0))
                        task.wait()
                    end
                end
            until Time + TimeToWait < tick() or not FlingActive
        end

        workspace.FallenPartsDestroyHeight = 0/0
        local BV = Instance.new("BodyVelocity")
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(0,0,0)
        BV.MaxForce = Vector3.new(9e9,9e9,9e9)
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)

        if TRootPart then SFBasePart(TRootPart)
        elseif THead then SFBasePart(THead)
        elseif Handle then SFBasePart(Handle)
        end

        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
        workspace.CurrentCamera.CameraSubject = Humanoid

        if getgenv().OldPos then
            repeat
                RootPart.CFrame = getgenv().OldPos*CFrame.new(0,.5,0)
                Character:SetPrimaryPartCFrame(getgenv().OldPos*CFrame.new(0,.5,0))
                Humanoid:ChangeState("GettingUp")
                for _, part in pairs(Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Velocity,part.RotVelocity = Vector3.new(),Vector3.new()
                    end
                end
                task.wait()
            until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
            workspace.FallenPartsDestroyHeight = getgenv().FPDH
        end
    end
end

------------------------------------------------
-- AUTO-SELECT ALL VALID PLAYERS
------------------------------------------------

local SelectedTargets = {}
for _,player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and not isAvoided(player) then
        SelectedTargets[player.Name] = player
    end
end

------------------------------------------------
-- AUTO-FLING LOOP
------------------------------------------------

task.spawn(function()
    while FlingActive do
        for _,player in pairs(SelectedTargets) do
            if FlingActive then
                SkidFling(player)
                task.wait(0.1)
            end
        end
        task.wait(0.5)
    end
end)

------------------------------------------------
-- RANDOM TP & FOLLOW (IN FACE + FACING)
------------------------------------------------

local function getRandomizedPlayers()
    local list = {}
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and not isAvoided(p) then table.insert(list,p) end
    end
    for i=#list,2,-1 do
        local j = math.random(1,i)
        list[i],list[j] = list[j],list[i]
    end
    return list
end

task.spawn(function()
    while task.wait() do
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")
        for _, target in ipairs(getRandomizedPlayers()) do
            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local targetRoot = target.Character.HumanoidRootPart
                local startTime = tick()
                while tick() - startTime < 2 do
                    if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                        root.CFrame = CFrame.lookAt(targetRoot.Position + targetRoot.CFrame.LookVector*1.5,
                                                     targetRoot.Position)
                    else break end
                    task.wait(0.05)
                end
            end
        end
    end
end)

------------------------------------------------
-- SERVER HOP
------------------------------------------------

local function serverHop()
    local servers,cursor = {}, ""
    repeat
        local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"..(cursor~="" and "&cursor="..cursor or "")
        local success,response = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
        if success and response and response.data then
            for _,server in ipairs(response.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    table.insert(servers,server.id)
                end
            end
            cursor = response.nextPageCursor or ""
        else break end
    until cursor == ""
    if #servers>0 then
        TeleportService:TeleportToPlaceInstance(PlaceId,servers[math.random(1,#servers)],LocalPlayer)
    end
end

task.spawn(function()
    while task.wait(45) do serverHop() end
end)

-- SUCCESS MESSAGE
Message("Loaded","Merged Auto-Fling + Old Script Loaded!",3)
