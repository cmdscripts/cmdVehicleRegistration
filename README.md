This script enhances vehicle management in your FiveM server by providing a comprehensive vehicle registration system. It dynamically adds blips on the map for registration points, handles vehicle plate creation and registration through interactive menus, and integrates notifications for user actions. The script supports both vehicle registration and unregistration, with functionality to check if a vehicle's plate is taken and ensure sufficient funds before processing. It also creates markers and interactive points in the game world where players can register or unregister their vehicles, complete with customizable options and notifications.

## Configuration

The configuration file `config.lua` was refactored to be easier to understand:

```lua
Config = {
    Locale = 'en',
    Price = 5000,
    UseAdvancedParking = true,
    Notification = 'ox', -- or 'esx'
    NotifyEvent = 'esx:showNotification',
    Positions = {
        { name = 'LS', coords = vec3(338.09, -1563.63, 30.3) },
        { name = 'BC', coords = vec3(154.18, 6392.65, 31.29) }
    }
}
```


![image](https://github.com/cmdscripts/cmdVehicleRegistration/assets/123102218/81b37827-1c81-4edf-8509-649add2045aa)

