local giftLoc = require 'data.gift'

-- Stores all Reward Data? Use Point instead ?
local RewardPoint = nil

local RewardBlip = nil

AddEventHandler('QBCore:Client:OnPlayerLoaded', function() 
    local Reward = lib.callback.await('risky_santa:server:fetchPlayerRewards', false)

    if not Reward then return end

    lib.notify({
        title = locale('reward_received'),
        icon = 'snowflake',
        duration = 10000,
        iconAnimation = 'spin',
    })

    PlaySound()

    local rewardCoords = giftLoc[Reward]

    RewardPoint = SpawnReward(rewardCoords)
end)

local function PlaySound()
    while not RequestScriptAudioBank('audiodirectory/custom_sounds', false) do 
        Wait(0) 
    end
    local soundId = GetSoundId()
    PlaySoundFrontend(soundId, 'christmas_bells', 'risky_soundset', true)
    ReleaseSoundId(soundId)
    ReleaseNamedScriptAudioBank('audiodirectory/custom_sounds')
end

lib.callback.register('risky_santa:client:spawnReward', function(rewardLocation)
    if not rewardLocation then return end

    local rewardCoords = giftLoc[rewardLocation]

    lib.notify({
        title = locale('reward_received'),
        icon = 'snowflake',
        duration = 5000,
        iconAnimation = 'spin',
    })
    PlaySound()

    if RewardPoint then
        if DoesEntityExist(RewardPoint.rewardObj) then
            DeleteEntity(RewardPoint.rewardObj)
        end
        RewardPoint:remove()
        RewardPoint = nil
    end

    if RewardBlip then
        RemoveBlip(RewardBlip)
        RewardBlip = nil
    end

    RewardPoint = SpawnReward(rewardCoords)
    RewardBlip = AddBlipForRadius(rewardCoords.x, rewardCoords.y, rewardCoords.z, 50)
    SetBlipColour(RewardBlip, 6)
    SetBlipAlpha(RewardBlip, 200)
end)

lib.callback.register('risky_santa:client:openedReward', function(giftModel)
    local retval = false
    if not lib.waitFor(function()
        RequestNamedPtfxAsset('proj_indep_firework')
        if HasNamedPtfxAssetLoaded('proj_indep_firework') then
            return true
        end
    end, 'Failed to load ParticleFx : proj_indep_firework' , 5000) then 
        return true 
    end

    local coords = GetEntityCoords(cache.ped)

    local ptfxHandler

    ptfxHandler = lib.timer(1000, function()
        UseParticleFxAssetNextCall('proj_indep_firework')
        StartParticleFxNonLoopedAtCoord('scr_indep_firework_grd_burst', coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.3, false, false, false)
        ptfxHandler:restart()
    end, true)

    if lib.progressBar({
        duration = 5000,
        label = locale('open_gift'),
        anim = {
            dict = 'amb@prop_human_parking_meter@male@base',
            clip = 'base'
        },
        prop = {
            model = giftModel,
            pos = vec3(0.03, 0.03, 0.02),
            rot = vec3(0.0, 0.0, -1.5)
        }
    }) then 
        retval = true
    else
        retval = false
    end

    ptfxHandler:forceEnd()
	RemoveNamedPtfxAsset('proj_indep_firework')

    return retval
end)

lib.callback.register('risky_santa:client:collectReward', function()
    if lib.progressBar({
        duration = 5000,
        label = locale('grabbing_gift'),
        anim = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            clip = 'machinic_loop_mechandplayer',
            flag = 1 
        }
    }) then 
        ClearPedTasks(cache.ped)
        if DoesEntityExist(RewardPoint.rewardObj) then
            DeleteEntity(RewardPoint.rewardObj)
        end
        RewardPoint:remove()
        RewardPoint = nil

        if RewardBlip then
            RemoveBlip(RewardBlip)
            RewardBlip = nil
        end
        return true
    else
        ClearPedTasks(cache.ped)
        return false
    end

    return false
end)