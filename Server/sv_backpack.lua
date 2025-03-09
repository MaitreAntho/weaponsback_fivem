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
    
    -- La sauvegarde est automatique avec la persistance activée
    -- Pas besoin d'appeler une fonction de sauvegarde supplémentaire
end)

-- La sauvegarde est gérée automatiquement par ox_inventory
-- Pas besoin d'une sauvegarde périodique manuelle
-- Le paramètre 'true' dans RegisterStash active la persistance automatique
