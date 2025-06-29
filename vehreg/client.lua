function starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

RegisterNetEvent('esx:playerLoaded', function()
    getBlips()
end)

AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        getBlips()
    end
end)

function getBlips()
    for k, v in pairs(Config.Positions) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)

        SetBlipSprite(blip, 525)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 47)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(_U('register_menu_title'))
        EndTextCommandSetBlipName(blip)
    end
end

function sendNotify(type, title, message)
    SendNotify(type, title, message)
end

function createPlate(location)
    local readyPlate
    local doBreak = false

    while true do
        Wait(5)
        math.randomseed(GetGameTimer())

        readyPlate = string.upper(location .. ' ' .. randomNumber(5))
        local taken = lib.callback.await('vehreg:checkPlate', false, readyPlate)
        if not taken then
            break
        end
    end
    return readyPlate
end

local NumberCharset = {}

for i = 48, 57 do table.insert(NumberCharset, string.char(i)) end

function randomNumber(amount)
    Citizen.Wait(0)
    math.randomseed(GetGameTimer())
    if amount > 0 then
        return randomNumber(amount - 1) .. NumberCharset[math.random(1, #NumberCharset)]
    else
        return ''
    end
end

function registerVehicle(ownedVeh, playerVeh, location)
    lib.registerContext({
        id = 'register_vehicle_menu',
        title = ownedVeh.plate .. " - " .. GetLabelText(GetDisplayNameFromVehicleModel(ownedVeh.model)), -- Anpassung für Modellanzeige
        options = {
            {
                title = _U("register_vehicle_menu_item_submit"),
                description = "Submit to register vehicle",
                icon = 'car',
                onSelect = function()
                    local enoughMoney = lib.callback.await('vehreg:checkMoney', false, Config.Price)
                    if enoughMoney then
                        local newPlate = createPlate(location)
                        if Config.UseAdvancedParking then
                            exports["AdvancedParking"]:UpdatePlate(playerVeh, newPlate)
                        else
                            SetVehicleNumberPlateText(playerVeh, newPlate)
                        end
                        local vehicleProps = ESX.Game.GetVehicleProperties(playerVeh)
                        TriggerServerEvent('vehreg:updatePlate', ownedVeh.plate, newPlate, Config.Price)
                        sendNotify('success', _U('register_menu_title'), _U("register_vehicle_notify_success") .. newPlate)
                    else
                        sendNotify('error', _U('register_menu_title'), _U("register_vehicle_notify_error") .. Config.Price)
                    end
                end,
                metadata = {
                    {label = 'Price', value = '$' .. Config.Price}
                }
            },
            {
                title = _U("unregister_vehicle_menu_item_submit"),
                description = "Submit to unregister vehicle",
                icon = 'car',
                onSelect = function()
                    local enoughMoney = lib.callback.await('vehreg:checkMoney', false, -Config.Price)
                    if enoughMoney then
                        local originalPlate = ownedVeh.originalPlate or ownedVeh.plate
                            if Config.UseAdvancedParking then
                                exports["AdvancedParking"]:UpdatePlate(playerVeh, originalPlate)
                            else
                                SetVehicleNumberPlateText(playerVeh, originalPlate)
                            end
                            local vehicleProps = ESX.Game.GetVehicleProperties(playerVeh)
                            TriggerServerEvent('vehreg:updatePlate', ownedVeh.plate, originalPlate, -Config.Price)
                            sendNotify('success', _U('register_menu_title'), _U("unregister_vehicle_notify_success") .. originalPlate)
                    else
                        sendNotify('error', _U('register_menu_title'), _U("unregister_vehicle_notify_error") .. Config.Price)
                    end
                end,
                metadata = {
                    {label = 'Price', value = '$' .. Config.Price}
                }
            }
        }
    })

    lib.showContext("register_vehicle_menu")
end

function openRegistrationMenu(location)
    local ownedVehicles = lib.callback.await('vehreg:getPlayerVehicles', false)
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    local nearVehicles = lib.getNearbyVehicles(playerPos, 20.0, false)
    local menuOptions = {}

        for i = 1, #nearVehicles do
            for j = 1, #ownedVehicles do
                if string.match(GetVehicleNumberPlateText(nearVehicles[i].vehicle), ownedVehicles[j].plate) then
                    local ownedVeh = ownedVehicles[j]
                    local playerVeh = nearVehicles[i].vehicle
                    if starts(ownedVeh.plate, "LS ") or starts(ownedVeh.plate, "BC ") then
                        table.insert(menuOptions, {
                            title = GetVehicleNumberPlateText(nearVehicles[i].vehicle),
                            description = "Registered Vehicle",
                            icon = 'car',
                            metadata = {
                                {label = 'Plate', value = ownedVeh.plate}
                            }
                        })
                    else
                        table.insert(menuOptions, {
                            title = ownedVeh.plate .. " - " .. GetLabelText(GetDisplayNameFromVehicleModel(ownedVeh.model)), -- Anpassung für Modellanzeige
                            description = "Register or Unregister this vehicle",
                            icon = 'car',
                            onSelect = function()
                                registerVehicle(ownedVeh, playerVeh, location)
                            end,
                            metadata = {
                                {label = 'Unregistered', value = true}
                            }
                        })
                    end
                end
            end
        end

    lib.registerContext({
        id = 'register_menu',
        title = _U('register_menu_title'),
        options = menuOptions
    })

    lib.showContext('register_menu')
end

    function createMarkers()
        for _, v in pairs(Config.Positions) do
            local marker = lib.marker.new({
                type = 27,
                coords = vector3(v.x, v.y, v.z - 0.98),
                color = { r = 136, g = 0, b = 136, a = 75 },
                width = 0.9,
                height = 1.0,
            })
            
            local point = lib.points.new({
                coords = vector3(v.x, v.y, v.z),
                distance = 7.5,
            })
    
            function point:nearby()
                marker:draw()
    
                if self.currentDistance <= 1.0 then
                    lib.showTextUI('[E] - Vehicle Registration', {position = "left-center", icon = 'hand'})
                    if IsControlJustPressed(0, 38) then
                        openRegistrationMenu(v.name)
                    end
                else
                    lib.hideTextUI()
                end
            end
        end
    end
    

CreateThread(function()
    createMarkers()
end)

