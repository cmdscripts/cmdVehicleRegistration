lib.callback.register('vehreg:checkPlate', function(source, plate)
    local result = MySQL.scalar.await('SELECT 1 FROM owned_vehicles WHERE plate = ?', { plate })
    return result ~= nil
end)
