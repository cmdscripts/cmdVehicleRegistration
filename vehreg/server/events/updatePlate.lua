RegisterNetEvent('vehreg:updatePlate', function(oldPlate, newPlate, price)
    local result = MySQL.single.await('SELECT vehicle FROM owned_vehicles WHERE plate = ? LIMIT 1', { oldPlate })
    if not result then return end

    local vehMods = json.decode(result.vehicle)
    vehMods.plate = newPlate

    MySQL.update('UPDATE owned_vehicles SET plate = ?, vehicle = ? WHERE plate = ?', {
        tostring(newPlate),
        json.encode(vehMods),
        tostring(oldPlate)
    })

    MySQL.update('UPDATE inventories SET identifier = ? WHERE identifier = ?', {
        tostring(newPlate),
        tostring(oldPlate)
    })

    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeAccountMoney('bank', price)
end)
