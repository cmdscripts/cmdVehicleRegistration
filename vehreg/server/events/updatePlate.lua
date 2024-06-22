RegisterNetEvent("vehreg:updatePlate")
AddEventHandler("vehreg:updatePlate", function(oldPlate, newPlate, price)
    MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE plate=@plate LIMIT 1', {
        ['@plate'] = oldPlate
    }, function(result)
        local vehMods = json.decode(result[1].vehicle)

        vehMods.plate = newPlate

        MySQL.Async.execute('UPDATE owned_vehicles SET plate=@newPlate, vehicle=@vehicle WHERE plate=@oldPlate', {
            ['@newPlate'] = tostring(newPlate),
            ['@vehicle'] = json.encode(vehMods),
            ['@oldPlate'] = tostring(oldPlate)
        })
        MySQL.Async.execute('UPDATE inventories SET identifier=@newPlate WHERE identifier=@oldPlate', {
            ['@newPlate'] = tostring(newPlate),
            ['@oldPlate'] = tostring(oldPlate)
        })
    end)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeAccountMoney('bank', price)
end)