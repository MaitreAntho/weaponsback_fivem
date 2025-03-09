local ox_inventory = exports.ox_inventory

local function openBackpack()
    print('Tentative d\'ouverture du sac à dos')  -- Debug
    local playerServerId = GetPlayerServerId(PlayerId())
    local stashId = ('backpack_%s'):format(playerServerId)
    
    if Config.Backpack.animation.enabled then
        if Config.Backpack.animation.disableInCar and IsPedInAnyVehicle(PlayerPedId(), true) then
            TriggerEvent('esx:showNotification', 'Vous ne pouvez pas ouvrir votre sac à dos en voiture')
            return
        end
        
        lib.requestAnimDict(Config.Backpack.animation.dict)
        ExecuteCommand('me Ouvre son sac à dos')
        local success = lib.progressBar({
            duration = Config.Backpack.animation.duration,
            label = 'Ouverture du sac à dos...',
            useWhileDead = false,
            canCancel = Config.Backpack.animation.canCancel,
            disable = {
                car = Config.Backpack.animation.disableInCar,
            },
            anim = {
                dict = Config.Backpack.animation.dict,
                clip = Config.Backpack.animation.clip
            },
        })
        
        if not success then return end
    end
    
    local stashData = {
        id = stashId,
        label = 'Sac à dos',
        slots = Config.Backpack.size,
        weight = Config.Backpack.maxWeight
    }
    
    TriggerServerEvent('weaponsback:registerStash', stashData)
    
    Wait(100)
    
    TriggerEvent('ox_inventory:openInventory', 'stash', stashId)
end

if Config.Backpack.hideWeaponsInBag then
    AddEventHandler('ox_inventory:updateInventory', function(changes)
        if changes and changes.type == 'weapon' then
            TriggerEvent('weaponsback:updateWeaponVisibility')
        end
    end)
end

exports('backpack', function(data, slot)
    openBackpack()
    return false
end)

RegisterNetEvent('weaponsback:useBackpack')
AddEventHandler('weaponsback:useBackpack', function()
    openBackpack()
end)
