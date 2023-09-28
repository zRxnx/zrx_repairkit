local GetPlayerName = GetPlayerName
local GetNumPlayerTokens = GetNumPlayerTokens
local GetPlayerGuid = GetPlayerGuid
local GetPlayerIdentifierByType = GetPlayerIdentifierByType
local GetPlayerToken = GetPlayerToken
local PerformHttpRequest = PerformHttpRequest
local GetPlayerPing = GetPlayerPing
local GetResourceMetadata = GetResourceMetadata
local GetCurrentResourceName = GetCurrentResourceName

GetPlayerData = function(player)
    local p1, p2 = promise.new(), promise.new()
    local name = GetPlayerName(player)
    local numTokens = GetNumPlayerTokens(player)
    local guid = GetPlayerGuid(player)
    local fivem = GetPlayerIdentifierByType(player, 'fivem')
    local steam = GetPlayerIdentifierByType(player, 'steam')
    local license = GetPlayerIdentifierByType(player, 'license')
    local license2 = GetPlayerIdentifierByType(player, 'license2')
    local discord = GetPlayerIdentifierByType(player, 'discord')
    local xbl = GetPlayerIdentifierByType(player, 'xbl')
    local liveid = GetPlayerIdentifierByType(player, 'liveid')
    local ip = GetPlayerIdentifierByType(player, 'ip')
    local country = 'NOT FOUND'
    local vpn = false
    local hwids = {}

    for i = 0, numTokens, 1 do
        hwids[#hwids + 1] = GetPlayerToken(player, i)
    end

    PerformHttpRequest(('http://ip-api.com/json/%s?fields=61439'):format(ip), function(_, result, _)
        if result then
            local data = json.decode(result)

            p1:resolve(data.country)
            p2:resolve(not not (data.hosting or data.proxy))
        end
    end)

    country = Citizen.Await(p1)
    vpn = Citizen.Await(p2)

    return {
        player = player,
        name = name,
        guid = guid,
        hwids = hwids,
        steam = steam,
        license = license,
        license2 = license2,
        fivem = fivem,
        xbl = xbl,
        ip = ip,
        discord = discord,
        liveid = liveid,
        country = country,
        vpn = vpn
    }
end

DiscordLog = function(player, title, message, webhook)
    if Webhook.Links[webhook]:len() <= 0 then return end
    local description = ('%s\n\n'):format(message)

    if not Webhook.Execlude.name then
        description = ('%s `👤` **Player**: %s\n'):format(description, PLAYER_CACHE[player].name)
    end

    if not Webhook.Execlude.player then
        description = ('%s `#️⃣` **Server ID**: `%s`\n'):format(description, PLAYER_CACHE[player].player)
    end

    if not Webhook.Execlude.ping then
        description = ('%s `📶` **Player Ping**: `%sms`\n'):format(description, GetPlayerPing(player) )
    end

    if not Webhook.Execlude.discord then
        description = ('%s `📌` **Discord ID**: `%s` <@%s>\n'):format(description, PLAYER_CACHE[player].discord, PLAYER_CACHE[player].discord)
    end

    if not Webhook.Execlude.fivem then
        description = ('%s `🟧` **FiveM ID**: `%s`\n'):format(description, PLAYER_CACHE[player].fivem)
    end

    if not Webhook.Execlude.license then
        description = ('%s `📀` **License ID**: `%s`\n'):format(description, PLAYER_CACHE[player].license)
    end

    if not Webhook.Execlude.license2 then
        description = ('%s `💿` **License2 ID**: `%s`\n'):format(description, PLAYER_CACHE[player].license2)
    end

    if not Webhook.Execlude.hwid then
        description = ('%s `💻` **Hardware ID**: `%s`\n'):format(description, PLAYER_CACHE[player].hwids[1])
    end

    if not Webhook.Execlude.steam then
        description = ('%s `👾` **Steam ID**: `%s`\n'):format(description, PLAYER_CACHE[player].steam)
    end

    if not Webhook.Execlude.xbl then
        description = ('%s `🕹️` **XBOX Live ID**: `%s`\n'):format(description, PLAYER_CACHE[player].xbl)
    end

    if not Webhook.Execlude.guid then
        description = ('%s `⚙️` **GUID**: `%s`\n'):format(description, PLAYER_CACHE[player].guid)
    end

    if not Webhook.Execlude.ip then
        description = ('%s `🌐` **IP**: ||%s||\n'):format(description, PLAYER_CACHE[player].ip)
    end

    if not Webhook.Execlude.country then
        description = ('%s `🌍` **Country**: ||%s||\n'):format(description, PLAYER_CACHE[player].country)
    end

    if not Webhook.Execlude.vpn then
        description = ('%s `🤖` **VPN**: ||%s||\n'):format(description, PLAYER_CACHE[player].vpn)
    end

    local embed = {
        {
            ['color'] = 255,
            ['title'] = title,
            ['description'] = description,
            ['footer'] = {
                ['text'] = ('Made by %s | %s'):format(GetResourceMetadata(GetCurrentResourceName(), 'author'), os.date()),
                ['icon_url'] = 'https://i.imgur.com/QOjklyr.png'
            },

            ['author'] = {
                ['name'] = 'zrx_repairkit',
                ['icon_url'] = 'https://i.imgur.com/QOjklyr.png'
            }
        }
    }

    PerformHttpRequest(Webhook.Links[webhook], nil, 'POST', json.encode({
        username = 'ZRX LOGS',
        embeds = embed,
        avatar_url = 'https://i.imgur.com/QOjklyr.png'
    }), {
        ['Content-Type'] = 'application/json'
    })
end