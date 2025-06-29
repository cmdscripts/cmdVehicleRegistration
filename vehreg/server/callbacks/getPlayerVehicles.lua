lib.callback.register('vehreg:getPlayerVehicles', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    local result = MySQL.query.await('SELECT * FROM owned_vehicles WHERE owner = ?', { identifier })
    return result
end)
