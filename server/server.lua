ESX, PLAYER_CACHE, USED = Config.EsxImport(), {}, {}
local TriggerClientEvent = TriggerClientEvent
local GetPlayers = GetPlayers

RegisterNetEvent('esx:playerLoaded', function(player)
    PLAYER_CACHE[player] = GetPlayerData(player)
end)

CreateThread(function()
    for i, data in pairs(Config.RepairKits) do
        ESX.RegisterUsableItem(data.item, function(source)
            USED[source] = true

            if Webhook.Settings.startRepair then
                DiscordLog(source, 'START REPAIR', 'Player started a repair', 'startRepair')
            end

            TriggerClientEvent('zrx_repairkit:client:startRepair', source, i)
        end)
    end

    for i, data in pairs(GetPlayers()) do
        data = tonumber(data)
        PLAYER_CACHE[data] = GetPlayerData(data)
    end
end)

RegisterNetEvent('zrx_repairkit:server:syncRepair', function(vehicle, index)
    if USED[source] and type(vehicle) == 'number' and type(index) == 'number' then
        USED[source] = false
        local xPlayer = ESX.GetPlayerFromId(source)

        if Webhook.Settings.endRepair then
            DiscordLog(xPlayer.source, 'END REPAIR', 'Player ended a repair', 'endRepair')
        end

        xPlayer.removeInventoryItem(Config.RepairKits[index].item, 1)
        TriggerClientEvent('zrx_repairkit:client:syncRepair', -1, vehicle)
    else
        Config.PunishPlayer(xPlayer.source, 'Tried to trigger "zrx_repairkit:server:syncRepair"')
    end
end)

RegisterNetEvent('zrx_repairkit:server:cancelRepair', function()
    if USED[source] then
        USED[source] = false

        if Webhook.Settings.cancelRepair then
            DiscordLog(source, 'CANCEL REPAIR', 'Player cancelled a repair', 'cancelRepair')
        end
    else
        Config.PunishPlayer(source, 'Tried to trigger "zrx_repairkit:server:cancelRepair"')
    end
end)