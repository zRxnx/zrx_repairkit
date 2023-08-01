ESX, COOLDOWN, BUSY, SHOW = Config.EsxImport(), false, false, false

RegisterNetEvent('esx:playerLoaded',function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('zrx_repairkit:client:startRepair', function(index)
    if BUSY then
        return Config.Notification(nil, Strings.rep_busy)
    elseif COOLDOWN then
        return Config.Notification(nil, Strings.rep_cooldown)
    end

    StartCooldown()
    StartThread(index)
end)

RegisterNetEvent('zrx_repairkit:client:syncRepair', function(vehicle)
    if not DoesEntityExist(vehicle) then return end

    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
end)

exports('isBusy', function()
    return BUSY
end)

exports('hasCooldown', function()
    return COOLDOWN
end)