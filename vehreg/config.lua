Config = {}

Config.Locale = "en"
Config.positions = { 
    {
        name = "LS",
        x = 338.09,
        y = -1563.63,
        z = 30.3,
    },
    {
        name = "BC",
        x = 154.18,
        y = 6392.65,
        z = 31.29,
    }
}

Config.price = 5000
Config.advancedParking = true

sendNotify = function(color, title, message)
    if Config.useESXNotify then
        MSK.Notification(title, message, 'general', 5000)
    else
        TriggerEvent(Config.notifyEvent, color, title, message)
    end
end