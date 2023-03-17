local seconds, minutes = 1000, 60000
Config = {}
--| Discord Webhook in 'server/server.lua'
Config.Anim = {
    dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
    lib = 'machinic_loop_mechandplayer'
}

Config.RepairKits = {
    {
        item = 'repairkit', --| Item name
        usetime = 10 * seconds, --| Usetime
    }
}

--| Place your notification here
Config.Notification = function(source, msg)
    if IsDuplicityVersion() then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.showNotification(msg)
    else
        ESX.ShowNotification(msg)
    end
end

--| Place your esx Import here
Config.esxImport = function()
	if IsDuplicityVersion() then
		return exports['es_extended']:getSharedObject()
	else
		return exports['es_extended']:getSharedObject()
	end
end

--| Place your Register items here
Config.RegisterItems = function()
    if not IsDuplicityVersion() then return end

    for k, data in pairs(Config.RepairKits) do
        ESX.RegisterUsableItem(data.item, function(source)
            DiscordLog(source, Strings.logTitle, Strings.logDesc)
            TriggerClientEvent('zrx_repairkit:client:startRepair', source, k)
        end)
    end
end