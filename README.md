# 🎒 WeaponsBack avec système de sac à dos

Un script FiveM qui ajoute un système de sac à dos avec persistance des données et affichage des armes sur le dos.

## ✨ Fonctionnalités

- Système de sac à dos intégré avec ox_inventory
- Affichage des armes sur le dos des joueurs
- Animation personnalisable à l'ouverture du sac
- Persistance des données (le contenu du sac est sauvegardé)
- Système de sauvegarde automatique
- Compatibilité complète avec ox_inventory
- Message /me et animation à l'ouverture du sac
- Protection contre l'utilisation en voiture (configurable)

## 📋 Prérequis

- ox_inventory
- ox_lib

## 🛠️ Installation

1. Téléchargez et extrayez le script dans votre dossier resources
2. Ajoutez `ensure weaponsback` dans votre server.cfg
3. Configurez l'item dans ox_inventory
4. Redémarrez votre serveur

## ⚙️ Configuration

Le fichier `config.lua` permet de personnaliser :

- Taille du sac à dos (slots)
- Poids maximum
- Types d'items autorisés
- Animation d'ouverture
- Intervalle de sauvegarde
- Et plus encore...

```lua
Config.Backpack = {
    size = 15,              -- Nombre de slots
    maxWeight = 50000,      -- Poids maximum
    saveInterval = 300000,  -- Intervalle de sauvegarde (5 minutes)
    
    -- Animation personnalisable
    animation = {
        enabled = true,
        duration = 1500,
        dict = 'clothingshirt',
        clip = 'try_shirt_positive_d',
        canCancel = true,
        disableInCar = true
    }
}
```

## 📦 Configuration de l'item

A mettre dans ox_inventory/data/items.lua :

```lua
['backpack'] = {
    label = 'Sac à dos',
    weight = 1000,
    stack = false,
    close = true,
    description = "Un sac à dos pour transporter plus d'objets",
    consume = 0,
    client = {
        event = 'weaponsback:useBackpack'
    }
}
```

## 🔄 Persistance des données

Le contenu du sac à dos est automatiquement sauvegardé :
- Toutes les 5 minutes (configurable)
- À la déconnexion du joueur
- Conservé après redémarrage du serveur

## 🎮 Utilisation

- Utilisez le sac à dos depuis votre inventaire
- Une animation et un message /me s'afficheront
- Le contenu est sauvegardé automatiquement
- Impossible d'utiliser en voiture (configurable)

## 📄 Licence

Ce projet est sous licence libre d'utilisation pour vos serveurs FiveM.

## ⚠️ Avertissement
*Note : Ce script nécessite ox_inventory et ox_lib pour fonctionner correctement.*