blip = nil

local QBCore = exports['qb-core']:GetCoreObject()
local ped = PlayerPedId()
local pedCoords = GetEntityCoords(ped)
local PlayerData = QBCore.Functions.GetPlayerData()
local nousbonpc = false

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then 
        PlayerJob = QBCore.Functions.GetPlayerData().job 
    end
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

local function openBlackmarketShop()
    local ShopItems = {}

    QBCore.Functions.Notify('Tell anyone where I am, I will move somewhere else you pig!', "primary", 5000)
    ShopItems.label = "Blackmarket"
    ShopItems.items = Config.BlackmarketItems
    ShopItems.slots = #Config.BlackmarketItems
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "blackmarket", ShopItems)
end

local function BlackmarketLocation()
    local blackmarketcoords = vector4(-1000.51, 4853.12, 273.61, 126.24)
    SetNewWaypoint(blackmarketcoords)
end

RegisterNetEvent('sl-blackmarket:searchcomputer', function()
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    QBCore.Functions.Progressbar("searchpc", "Searching the laptop...", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function()
            if nousbonpc == false then 
                nousbonpc = true
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify('You found a USB connected to the laptop!', 'success', 5000)
                TriggerServerEvent('sl-blackmarket:server:giveusb')
                Wait(1000)
                QBCore.Functions.Notify('Seems like the USB is too powerful to be ran on this laptop. Find a stronger one.', 'error', 5000)
            else
                QBCore.Functions.Notify('You already searched this laptop!', 'error', 5000)
            end
    end, function()
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    end, "fa-solid fa-laptop")
end)

RegisterNetEvent('sl-blackmarket:hackcomputer', function()
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    QBCore.Functions.Progressbar("hackpc", "Connecting USB to computer...", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function()
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        QBCore.Functions.Notify('You must bypass the encryption', 'primary', 5000)

        exports['ps-ui']:Scrambler(function(success)
            if success then
                Wait(1000)
                exports['ps-ui']:Thermite(function(success)
                    if success then
                        QBCore.Functions.Notify('Looks like there is a blackmarket! Make sure to go to him during night!', "success", 5000)
                        BlackmarketLocation()
                        TriggerServerEvent('sl-blackmarket:server:removeusb')
                    else
                        QBCore.Functions.Notify('You failed to bypass encryption!', "error", 5000)
                    end
                 end, 10, 5, 3)
            end
        end, "numeric", 30, 0)

    end, function()
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    end, "fa-solid fa-code")
end)

RegisterNetEvent('sl-blackmarket:client:openshop', function()
    local hours = GetClockHours()

    if hours >= Config.BlackmarketOpen or hours < Config.BlackmarketClose then
        openBlackmarketShop()
    end
end)