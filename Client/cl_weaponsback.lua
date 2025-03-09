local SETTINGS = {
    back_bone = 24816,
    x = 0.1,
    y = -0.18,
    z = 0.02,
    x_rotation = 0.0,
    y_rotation = 0.0,
    z_rotation = 0.0,    
    compatable_weapon_hashes = {
        ["WEAPON_BAT"] = {model = "w_me_bat", hash = -1786099057},
        ["WEAPON_JERRYCAN"] = {model = "prop_ld_jerrycan_01", hash = 883325847},
        -- assault rifles:
        ["WEAPON_CARBINERIFLE"] = {model = "w_ar_carbinerifle", hash = -2084633992},
        ["WEAPON_CARBINERIFLE_MK2"] = {model = "w_ar_carbineriflemk2", hash = GetHashKey("WEAPON_CARBINERIFLE_MK2")},
        ["WEAPON_ASSAULTRIFLE"] = {model = "w_ar_assaultrifle", hash = -1074790547},
        ["WEAPON_SPECIALCARBINE"] = {model = "w_ar_specialcarbine", hash = -1063057011},
        ["WEAPON_BULLPUPRIFLE"] = {model = "w_ar_bullpuprifle", hash = 2132975508},
        ["WEAPON_ADVANCEDRIFLE"] = {model = "w_ar_advancedrifle", hash = -1357824103},
        -- sub machine guns:
        ["WEAPON_MICROSMG"] = {model = "w_sb_microsmg", hash = 324215364},
        ["WEAPON_ASSAULTSMG"] = {model = "w_sb_assaultsmg", hash = -270015777},
        ["WEAPON_SMG"] = {model = "w_sb_smg", hash = 736523883},
        ["WEAPON_SMG_MK2"] = {model = "w_sb_smgmk2", hash = GetHashKey("WEAPON_SMG_MK2")},
        ["WEAPON_GUSENBERG"] = {model = "w_sb_gusenberg", hash = 1627465347},
        -- sniper rifles:
        ["WEAPON_SNIPERRIFLE"] = {model = "w_sr_sniperrifle", hash = 100416529},
        -- shotguns:
        ["WEAPON_ASSAULTSHOTGUN"] = {model = "w_sg_assaultshotgun", hash = -494615257},
        ["WEAPON_BULLPUPSHOTGUN"] = {model = "w_sg_bullpupshotgun", hash = -1654528753},
        ["WEAPON_PUMPSHOTGUN"] = {model = "w_sg_pumpshotgun", hash = 487013001},
        ["WEAPON_MUSKET"] = {model = "w_ar_musket", hash = -1466123874},
        ["WEAPON_HEAVYSHOTGUN"] = {model = "w_sg_heavyshotgun", hash = GetHashKey("WEAPON_HEAVYSHOTGUN")},
        ["WEAPON_FIREWORK"] = {model = "w_lr_firework", hash = 2138347493}
    }
}

local attached_weapons = {}

local function Debug(message)
end

Citizen.CreateThread(function()
    while true do
        local me = GetPlayerPed(-1)
        local inventory = exports.ox_inventory:GetPlayerItems()
        
        Debug("Vérification de l'inventaire...")
        if inventory then
            Debug("Comptage des items en stock: " .. #inventory)
            for _, item in pairs(inventory) do
                Debug("Item en stock: " .. item.name .. " (nombre: " .. item.count .. ")")
            end
        else
            Debug("L'inventaire est nul!")
        end

        for weapon_name, weapon_data in pairs(SETTINGS.compatable_weapon_hashes) do
            local hasWeapon = false
            
            if inventory then
                for _, item in pairs(inventory) do
                    if item.name == weapon_name then
                        hasWeapon = true
                        Debug("Arme trouvée dans l'inventaire: " .. weapon_name)
                        break
                    end
                end
            end

            if hasWeapon then
                local currentWeapon = exports.ox_inventory:getCurrentWeapon()
                Debug("Arme actuelle: " .. (currentWeapon and currentWeapon.name or "none"))
                
                if not attached_weapons[weapon_data.model] and (not currentWeapon or currentWeapon.name ~= weapon_name) then
                    Debug("Fixation de l'arme: " .. weapon_name .. " (modèle: " .. weapon_data.model .. ")")
                    AttachWeapon(weapon_data.model, weapon_data.hash, SETTINGS.back_bone, SETTINGS.x, SETTINGS.y, SETTINGS.z, SETTINGS.x_rotation, SETTINGS.y_rotation, SETTINGS.z_rotation, isMeleeWeapon(weapon_data.model))
                end
            end
        end

        for model, attached_object in pairs(attached_weapons) do
            local currentWeapon = exports.ox_inventory:getCurrentWeapon()
            local weaponStillInInventory = false

            local weaponName = nil
            for name, data in pairs(SETTINGS.compatable_weapon_hashes) do
                if data.model == model then
                    weaponName = name
                    break
                end
            end

            if weaponName and inventory then
                for _, item in pairs(inventory) do
                    if item.name == weaponName then
                        weaponStillInInventory = true
                        break
                    end
                end
            end

            if (currentWeapon and currentWeapon.name == weaponName) or not weaponStillInInventory then
                Debug("Retrait de l'arme attachée: " .. model)
                DeleteObject(attached_object.handle)
                attached_weapons[model] = nil
            end
        end
        Wait(1000)
    end
end)

function AttachWeapon(attachModel, modelHash, boneNumber, x, y, z, xR, yR, zR, isMelee)
    Debug("Démarrage de AttachWeapon pour le modèle: " .. attachModel)
    
    local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumber)
    Debug("Indice de l'os de Got: " .. bone)
    
    local modelHash = GetHashKey(attachModel)
    Debug("Modèle de hachoir: " .. modelHash)
    
    RequestModel(modelHash)
    Debug("Modèle demandé")
    
    local timeout = 0
    while not HasModelLoaded(modelHash) and timeout < 30 do
        Wait(100)
        timeout = timeout + 1
        Debug("Attente du chargement du modèle... Tentative " .. timeout)
    end
    
    if timeout >= 30 then
        Debug("Échec du chargement du modèle: " .. attachModel)
        return
    end
    
    Debug("Modèle chargé avec succès")
    
    local object = CreateObject(modelHash, 1.0, 1.0, 1.0, true, true, false)
    if not object or object == 0 then
        Debug("Échec de la création de l'objet")
        Debug("Poignée d'objet: " .. tostring(object))
        return
    end
    Debug("Objet créé avec poignée: " .. object)
    
    attached_weapons[attachModel] = {
        hash = modelHash,
        handle = object
    }

    if isMelee then 
        x = 0.11 
        y = -0.14 
        z = 0.0 
        xR = -75.0 
        yR = 185.0 
        zR = 92.0 
    end
    if attachModel == "prop_ld_jerrycan_01" then 
        x = x + 0.3 
    end

    SetEntityCollision(object, false, false)
    local result = AttachEntityToEntity(object, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
    Debug("Joindre le résultat: " .. tostring(result))
    
    if not IsEntityAttached(object) then
        Debug("Avertissement : L'entité n'est pas attachée correctement")
        SetEntityCoords(object, GetEntityCoords(GetPlayerPed(-1)))
        Wait(100)
        AttachEntityToEntity(object, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
        
        if not IsEntityAttached(object) then
            Debug("Échec du contrôle final de la pièce jointe")
            DeleteObject(object)
            attached_weapons[attachModel] = nil
            return
        end
    end
    
    Debug("Arme attachée avec succès")
end

function isMeleeWeapon(wep_name)
    if wep_name == "prop_golf_iron_01" then
        return true
    elseif wep_name == "w_me_bat" then
        return true
    elseif wep_name == "prop_ld_jerrycan_01" then
        return true
    else
        return false
    end
end