ESX.RegisterServerCallback("vehreg:checkPlate", function(source, cb, plate)
    MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function(result)
        cb(result[1] ~= nil)
    end)
end)