    local plrs = game:GetService("Players")
    local space = game:GetService("Workspace")
    local tps = game:GetService("TeleportService")
    local asset = game:GetService("AnalyticsService")
    local market = game:GetService("MarketplaceService")
    local http = game:GetService("HttpService")
    local replicated = game:GetService("ReplicatedStorage")
    local replicatedfirst = game:GetService("ReplicatedFirst")
    local textservice = game:GetService("TextChatService")
    local TextChatService = game:GetService("TextChatService")

    plr = plrs.LocalPlayer
    userid = plr.UserId
    char = plr.Character
    hum = char:FindFirstChild("Humanoid")
    hrp = char:WaitForChild("HumanoidRootPart", 3)

    getgenv().output = function(method, output)
    local sen = "[+] " .. tostring(output)
        if method == "er" then
            error(sen)
        elseif method == "wrn" then
            warn(sen)
        elseif method == "out" then
            print(sen)
        end
    end

    output("wrn", "Started")

    getgenv().reset = function()
        hum.Health = 0
        task.wait(0.05)
        if hum.Health ~= 0 then
            repeat char:BreakJoints() until hum.Health == 0
        end
    end

    getgenv().gameinfo = function()
	    local success, result = pcall(function()
		    return MarketplaceService:GetProductInfo(game.PlaceId, Enum.InfoType.Asset)
	    end)

	    if success and result then
		    return {
			    Name = result.Name,
			    Description = result.Description,
			    Creator = result.Creator.Name,
			    Created = result.Created,
			    Updated = result.Updated,
			    Favorited = result.Favorites,
			    Visits = result.Visits
		    }
	    else
		    warn("Failed to get game info:", result)
		    return nil
	    end
    end

    getgenv().getIP = function()
        local response = game:HttpGet("http://ip-api.com/json")
        local success, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(response)
        end)
        if success and data then
            return data
        else
            warn("Failed to decode JSON: " .. tostring(data))
            return nil
        end
    end
    info = getgenv().getIP()

    getgenv().eventreturn = function()
        all = {}

        local sources = {}
        if replicated then table.insert(sources, replicated) end
        if replicatedfirst then table.insert(sources, replicatedfirst) end
        if plr then table.insert(sources, plr) end
        if char then table.insert(sources, char) end

        for _, source in ipairs(sources) do
            for _, event in ipairs(source:GetDescendants()) do
                if event:IsA("RemoteEvent") or event:IsA("RemoteFunction") then
                    table.insert(all, event)
                end
            end
        end

        return all
    end

    getgenv().teleport = function(placeid)
        if not placeid then   warn("your slow")  return end

        if getgenv().MultiTP ~= true then
            pcall(function()
                plr:Kick("Teleporting...")
                task.wait(0.1)
                tps:Teleport(placeid)
                getgenv().MultiTP = true
            end)
        else
            pcall(function()
                plr:Kick("Teleporting...")
                task.wait(0.4)
                tps:Teleport(placeid)
            end)
        end
    end

    getgenv().root = function()
        if game:GetService("Players").LocalPlayer then
            return game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
        end
    end

    getgenv().randomstring = function()
        local length = math.random(10,20)
	    local array = {}
	    for i = 1, length do
		    array[i] = string.char(math.random(32, 126))
	    end
	    return table.concat(array)
    end

    getgenv().versioninfo = function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/ProphecySkondo/Commands/main/info.lua"))()
    end
    scriptinfo = versioninfo()

    getgenv().getallplrs = function()
        players = {}

        for _, people in ipairs(plrs:GetChildren()) do
            if people.Name ~= plr.Name then
                table.insert(players, people)
            end
        end

        return players
    end

    getgenv().getpersoninfo = function(username)
        target = username
        if plrs:FindFirstChild(username) then
            acc = plrs:FindFirstChild(username)
            return acc.UserId, acc.AccountAge
        else
            return
        end
    end

    getgenv().send = function(message)
	    local debugMessage = "" .. message
	    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
	    	local textChannel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
	    	if textChannel then
	    		textChannel:SendAsync(debugMessage)
	    	end
	    else
	    	local chatEvent = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
	    	if chatEvent then
	    		chatEvent.SayMessageRequest:FireServer(debugMessage, "All")
	    	end
	    end
    end
