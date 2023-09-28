ESX, COOLDOWN, BUSY, SHOW = Config.EsxImport(), false, false, false
local DoesEntityExist = DoesEntityExist
local SetVehicleFixed = SetVehicleFixed
local SetVehicleDeformationFixed = SetVehicleDeformationFixed
local SetVehicleTyreFixed = SetVehicleTyreFixed

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
    local tyres = { 0, 1, 2, 3, 4, 5, 45, 47 }

    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)

    for i, data in pairs(tyres) do
        SetVehicleTyreFixed(vehicle, data)
    end
end)

exports('isBusy', function()
    return BUSY
end)

exports('hasCooldown', function()
    return COOLDOWN
end)