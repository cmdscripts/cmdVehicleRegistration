fx_version 'adamant'

game 'gta5'

name ''
description ''

shared_script '@es_extended/imports.lua'

client_scripts {
    'client.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/**/*.lua'
}

shared_scripts {
    'config.lua',
    '@es_extended/locale.lua',
    'locales/*.lua',
    '@msk_core/import.lua',
    '@ox_lib/init.lua',
}

lua54 'yes'