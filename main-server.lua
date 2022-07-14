local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('sl-blackmarket:server:giveusb', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.AddItem("powerful_usb", 1, false)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["powerful_usb"], "add")
end)