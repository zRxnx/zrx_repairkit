ESX = Config.esxImport()
BUSY = false
SHOW = false

RegisterNetEvent('zrx_repairkit:client:startRepair', function(index)
    if BUSY then return end

    BUSY = true
    StartThread(index)
end)