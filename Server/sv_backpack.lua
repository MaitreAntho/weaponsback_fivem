local ox_inventory = exports.ox_inventory

RegisterServerEvent('weaponsback:registerStash')
AddEventHandler('weaponsback:registerStash', function(data)
    local src = source
    if not data or not data.id then return end
    
    print('Tentative de création du stash côté serveur:', data.id) -- Debug
    
    exports.ox_inventory:RegisterStash(data.id, data.label, data.slots, data.weight, true)
end)

AddEventHandler('playerDropped', function()
    local src = source
    local stashId = ('backpack_%s'):format(src)
    
    exports.ox_inventory:SaveStash(stashId)
end)

CreateThread(function()
    while true do
        Wait(Config.Backpack.saveInterval or 300000)
        
        local players = GetPlayers()
        for _, playerId in ipairs(players) do
            local stashId = ('backpack_%s'):format(playerId)
            exports.ox_inventory:SaveStash(stashId)
        end
        
        print('Sauvegarde automatique des sacs à dos effectuée')
    end
end)
