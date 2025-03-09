fx_version "cerulean"
lua54 "yes"
game "gta5"
author "MaitreAntho"
description "WeaponsBack with Backpack System"
version "1.0.0"

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    "Client/*.lua"
}

server_scripts {
    "Server/*.lua"
}

dependencies {
    'ox_inventory',
    'ox_lib'
}

exports {
    'backpack'
}