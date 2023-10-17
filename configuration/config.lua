local seconds, minutes = 1000, 60000
Config = {}

Config.CheckForUpdates = true --| Check for updates?
Config.Cooldown = 3 --| Note: Between actions | In seconds
Config.UseVehicleDeformation = false --| https://forum.cfx.re/t/release-vehicledeformation-get-set-and-sync-vehicle-deformations-now-a-full-resource/4796026

Config.RepairKits = {
    {
        item = 'repairkit_bike', --| Item name
        usetime = 10 * seconds, --| Usetime
        allowedClasses = { --| https://docs.fivem.net/natives/?_0x29439776AAA00A62
            [8] = true
        },
        allowedVehicles = { --| Allowed vehicles
            [`bati`] = true --| as hash
        },
        allowedJobs = { --| Allowed jobs
            unemployed = true --| job name
        },
        anim = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            lib = 'machinic_loop_mechandplayer'
        }
    },

    {
        item = 'repairkit_car',
        usetime = 10 * seconds,
        --allowedClasses = {}, --| Remove if not used
        allowedJobs = {
            police = true
        },
        allowedVehicles = {
            [`t20`] = true
        },
        anim = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            lib = 'machinic_loop_mechandplayer'
        }
    },
}

--| Place here your texui
Config.TextUI = function(action, msg)
    if action == 'open' then
        lib.showTextUI(msg)
    elseif action == 'close' then
        lib.hideTextUI()
    end
end

--| Place here your punish actions
Config.PunishPlayer = function(player, reason)
    if not IsDuplicityVersion() then return end
    if Webhook.Links.punish:len() > 0 then
        local message = ([[
            The player got punished

            Reason: **%s**
        ]]):format(reason)

        CORE.Server.DiscordLog(player, 'PUNISH', message, Webhook.Links.punish)
    end

    DropPlayer(player, reason)
end