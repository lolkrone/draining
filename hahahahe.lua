-- REAUTOEXEC 

local urls = {
    "https://raw.githubusercontent.com/lolkrone/draining/hahahahe/bot.lua", -- main
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
    "there goes ur game hahahahhah ur so mad /hassle | krone",
    "RBLX vs krone??? LOL | krone | /hassle",
    "sucks to see ur game die out like this | krone was here",
    "hii im alyssa im on stage rn at /hassle",
    "immune to getting flung /hassle | krone",
    "LOL get trolled come to /hassle | krone",
    "come get a whitelist at /hassle | krone",
    "cam stage at /hassle tn | krone",
    "join /hassle come get a whitelist | krone",
    "krone was here hehe /hassle",
    "comgirl on stage /hassle",
    " DAILY GAME RE-UPLOADS | /hassle",
    "Stay with the RE-UPLOADS | /hassle",
    "Game RE-UPLOADS | /hassle",
    "So Cry RE-UPLOADS | /hassle",

}

local function shuffle(t)
    for i = #t,2,-1 do
        local j = math.random(i)
        t[i],t[j] = t[j],t[i]
    end
end

task.spawn(function()
    task.wait(1.95)
    if TextChatService.ChatVersion ~= Enum.ChatVersion.TextChatService then return end
    local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
    if not channel then return end
    while true do
        local msgs = table.clone(JoinMessages)
        shuffle(msgs)
        for _,msg in ipairs(msgs) do
            channel:SendAsync(msg)
            task.wait(1.95)
        end
    end
end)

------------------------------------------------
-- AVOID LIST
------------------------------------------------

local AvoidUserIds = {
    123456789,987654321,10253861328,10253908110,10283443701,
    10395776007,2561094270,2427285,10214659178
}

local function isAvoided(player)
    for _,id in ipairs(AvoidUserIds) do
        if player.UserId == id then return true end
    end
    return false
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
