RegisterCommand("animations", function(source, args, rawCommand)
    TriggerClientEvent('mth-animations:menu', source)
end, Config.AdminOnly)