lib.callback.register('vehreg:checkMoney', function(source, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer.getAccount('bank').money >= price
end)
