ESX = Config.esxImport()
WEBHOOK = ''

CreateThread(function()
    Config.RegisterItems()
end)

RegisterNetEvent('zrx_repairkit:server:removeItem', function(index)
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem(Config.RepairKits[index].item, 1)
end)