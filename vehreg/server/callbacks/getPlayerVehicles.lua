ESX.RegisterServerCallback("vehreg:getPlayerVehicles", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner=@owner', {
        ['@owner'] = identifier
    }, function(result)
        if #result >= 1 then
            cb(result)
        end
    end)
end)