fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'
name 'risky_santa'
author 'RiskyShot'
description 'Merry Christmas'

this_is_a_map "yes"

ox_lib 'locale'

shared_scripts{
    '@ox_lib/init.lua'
}

server_scripts {
    'server/main.lua'
}

client_scripts {
    'client/functions.lua',
    'client/main.lua'
}

files {
    'locales/*.json',
    'config/client.lua',
    'config/shared.lua',
    'data/gift.lua',

	'sounddata/audioexample_sounds.dat54.rel',
	'audiodirectory/custom_sounds.awc',
}

data_file 'AUDIO_WAVEPACK' 'audiodirectory'
data_file 'AUDIO_SOUNDDATA' 'sounddata/audioexample_sounds.dat'

data_file 'DLC_ITYP_REQUEST' 'stream/tr_christmas_props.ytyp'