Config = {
    Locale = 'en',

    -- price to register or unregister a vehicle
    Price = 5000,

    -- use AdvancedParking export when available
    UseAdvancedParking = true,

    -- notification system: 'ox' or 'esx'
    Notification = 'ox',

    -- event triggered when Notification is set to 'esx'
    NotifyEvent = 'esx:showNotification',

    Positions = {
        { name = 'LS', coords = vec3(338.09, -1563.63, 30.3) },
        { name = 'BC', coords = vec3(154.18, 6392.65, 31.29) }
    }
}

function SendNotify(type, title, message)
    if Config.Notification == 'ox' then
        lib.notify({
            title = title,
            description = message,
            type = type,
            position = 'top-right',
            duration = 5000
        })
    else
        TriggerEvent(Config.NotifyEvent, message)
    end
end

