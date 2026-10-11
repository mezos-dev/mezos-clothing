fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'mezos-clothing'
author 'Mezos'
description 'Next-gen appearance suite for QBCore: character creator, clothing, barber, surgeon, tattoos, wardrobe, outfit sharing and outfit bags'
version '1.0.0'

-- Drop-in replacement: resources that depend on qb-clothing keep working
provide 'qb-clothing'

shared_scripts {
    'config/config.lua',
    'config/prices.lua',
    'config/stores.lua',
    'config/creator.lua',
    'config/joboutfits.lua',
    'config/peds.lua',
    'shared/schema.lua',
    'shared/tattoos.lua',
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/appearance.lua',
    'client/camera.lua',
    'client/main.lua',
    'client/nui.lua',
    'client/tattoos.lua',
    'client/outfits.lua',
    'client/outfitbag.lua',
    'client/creator.lua',
    'client/zones.lua',
    'client/compat.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/payments.lua',
    'server/outfits.lua',
    'server/sharing.lua',
    'server/outfitbag.lua',
    'server/compat.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
    'html/js/views/*.js',
    'html/fonts/*',
    'html/img/*',
}

dependencies {
    'qb-core',
    'oxmysql',
    'PolyZone',
}
