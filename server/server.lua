CORE = exports.zrx_utility:GetUtility()
PLAYER_CACHE, USED = {}, {}
local TriggerClientEvent = TriggerClientEvent
local GetPlayers = GetPlayers
local GetEntityModel = GetEntityModel
local GetHashKey = GetHashKey
local NetworkGetEntityFromNetworkId = NetworkGetEntityFromNetworkId

RegisterNetEvent('zrx_utility:bridge:playerLoaded', function(player)
    PLAYER_CACHE[player] = CORE.Server.GetPlayerCache(player)
end)

CreateThread(function()
    if Config.CheckForUpdates then
        CORE.Server.CheckVersion('zrx_repairkit')
    end

    for i, data in pairs(Config.RepairKits) do
        CORE.Bridge.registerUsableItem(data.item, function(source)
            USED[source] = true

            if Webhook.Links.endRepair:len() > 0 then
                local message = [[
                    The player started a repair
                ]]

                CORE.Server.DiscordLog(source, 'START REPAIR', message, Webhook.Links.startRepair)
            end

            TriggerClientEvent('zrx_repairkit:client:startRepair', source, i)
        end)
    end

    for i, player in pairs(GetPlayers()) do
        player = tonumber(player)
        PLAYER_CACHE[player] = CORE.Server.GetPlayerCache(player)
    end
end)

RegisterNetEvent('zrx_repairkit:server:syncRepair', function(vehicle, index, network)
    if USED[source] and type(vehicle) == 'number' and type(index) == 'number' then
        USED[source] = false
        local veh = NetworkGetEntityFromNetworkId(network)
        local model = GetEntityModel(veh)

        if Webhook.Links.endRepair:len() > 0 then
            local message = ([[
                The player made a repair
    
                Vehicle: **%s**
                Vehicle Model: **%s**
                Vehicle Hash: **%s**
                Config Index: **%s**
            ]]):format(veh, model, GetHashKey(model), index)

            CORE.Server.DiscordLog(source, 'END REPAIR', message, Webhook.Links.endRepair)
        end

        CORE.Bridge.removeInventoryItem(source, Config.RepairKits[index].item, 1)
        TriggerClientEvent('zrx_repairkit:client:syncRepair', -1, vehicle)
    else
        Config.PunishPlayer(source, 'Tried to trigger "zrx_repairkit:server:syncRepair"')
    end
end)

RegisterNetEvent('zrx_repairkit:server:cancelRepair', function()
    if USED[source] then
        USED[source] = false

        if Webhook.Links.cancelRepair:len() > 0 then
            local message = [[
                The player cancelled a repair
            ]]

            CORE.Server.DiscordLog(source, 'CANCEL REPAIR', message, Webhook.Links.cancelRepair)
        end
    else
        Config.PunishPlayer(source, 'Tried to trigger "zrx_repairkit:server:cancelRepair"')
    end
end)