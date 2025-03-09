Config = {}

Config.Backpack = {
    item = 'backpack', -- item dans le ox_inventory
    
    -- Taille maximale du sac à dos (poids/slots selon votre configuration ox_inventory)
    size = 15,
    
    -- Types d'items autorisés dans le sac à dos
    allowedItems = {
        ['weapon'] = true,  -- Permet les armes
        ['item'] = true,    -- Permet les items standards
        ['ammo'] = true     -- Permet les munitions
    },
    
    -- Poids maximum que le sac peut contenir (si vous utilisez le système de poids)
    maxWeight = 50000,
    
    -- Désactiver l'affichage des armes sur le dos quand elles sont dans le sac
    hideWeaponsInBag = true,
    
    -- Configuration de l'animation à l'ouverture du sac
    animation = {
        enabled = true,
        duration = 1500,
        dict = 'clothingshirt',
        clip = 'try_shirt_positive_d',
        canCancel = true,
        disableInCar = true
    },
    
    -- Configuration de la sauvegarde
    saveInterval = 300000, -- Intervalle de sauvegarde automatique en ms (300000 = 5 minutes)
    persistentStorage = true -- Activer la persistance du stockage
}
