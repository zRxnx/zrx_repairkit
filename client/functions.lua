RepairVehicle = function(vehicle, index)
    local ped = PlayerPedId()
    SetVehicleUndriveable(vehicle, true)
    SetVehicleDoorOpen(vehicle, 4, false, false)
    Config.Notification(nil,Strings.rep_started)
    ESX.Progressbar(Strings.rep_progress, Config.RepairKits[index].usetime, {
        FreezePlayer = true,
        animation = {
            type = 'anim',
            dict = Config.Anim.dict,
            lib = Config.Anim.lib
        },
        onFinish = function()
            BUSY = false
            SetVehicleDoorShut(vehicle, 4, false)
            SetVehicleFixed(vehicle)
            ClearPedTasksImmediately(ped)
            SetVehicleUndriveable(vehicle, false)
            Config.Notification(nil, Strings.rep_success)
            TriggerServerEvent('zrx_repairkit:server:removeItem', index)
    end})
end

StartThread = function(index)
    local ped = PlayerPedId()
    local pedCar = GetVehiclePedIsIn(ped, false)

    if pedCar == 0 then
        Config.Notification(nil, Strings.not_in_vehicle)
        return
    end

    CreateThread(function()
        SHOW = true
        local carHood = GetWorldPositionOfEntityBone(pedCar, GetEntityBoneIndexByName(pedCar, 'bonnet'))
        local pedCoords
        if carHood.x == 0 and carHood.y == 0 then
            RepairVehicle(pedCar, index)
        else
            TaskLeaveVehicle(ped, pedCar, 0)
            Wait(1000)
            while SHOW do
                pedCoords = GetEntityCoords(ped)
                Draw3dText(carHood.x, carHood.y - 1.0, carHood.z, Strings.press)
                if #(vector3(pedCoords.x, pedCoords.y, pedCoords.z) - vector3(carHood.x, carHood.y, carHood.z)) < 2 and not IsPedInAnyVehicle(ped, false) and IsControlJustPressed(0, 51) then
                    SHOW = false
                    RepairVehicle(ESX.Game.GetClosestVehicle(), index)
                elseif IsPedInAnyVehicle(ped, true) then
                    SHOW = false
                    BUSY = false
                    Config.Notification(nil, Strings.rep_error)
                elseif #(vector3(pedCoords.x, pedCoords.y, pedCoords.z) - vector3(carHood.x, carHood.y, carHood.z)) > 5 then
                    SHOW = false
                    BUSY = false
                    Config.Notification(nil, Strings.rep_error)
                end
                Wait()
            end
        end
    end)
end

Draw3dText = function(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(250, 250, 250, 255)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    SetDrawOrigin(x, y + 1, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end