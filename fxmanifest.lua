fx_version 'cerulean'
games { 'gta5' }
author 'fsg'
description 'Misclick Script for FiveM'
version '1.0.0'
lua54 'enabled'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'ox_lib',
}
