-- Config Loads
local sharedConfig = require 'config.shared'
local config = require 'config.server'

local giftLoc = require 'data.gift'

-- Store Active Players
local ActivePlayers = {}

-- Table to store rewards for players
local Rewards = {}

-- Used Locations for Reward
local usedLocations = {}

function GenerateReward(cid)
    local rewardLocation = 1

    local Player = exports.qbx_core:GetPlayerByCitizenId(cid)

    if not Player then return end

    local source = Player.PlayerData.source

    repeat 
        rewardLocation = math.random(1, #giftLoc)
    until not lib.table.contains(usedLocations, rewardLocation)

    table.insert(usedLocations, rewardLocation)

    if Rewards[cid] ~= nil then
        for index, loc in pairs(usedLocations) do
            if loc == Rewards[cid] then
                table.remove(usedLocations, index)
                break
            end
        end
    end

    Rewards[cid] = rewardLocation

    lib.callback.await('risky_santa:client:spawnReward', source, rewardLocation)
end

function GenerateGiftBox(source)
    if not lib.callback.await('risky_santa:client:collectReward', source) then return false end

    local random = math.random(0, 1)

    local giftBoxItem = random == 0 and 'santa_small_gift' or 'santa_large_gift'

    if exports.ox_inventory:CanCarryItem(source, giftBoxItem, 1) then
        exports.ox_inventory:AddItem(source, giftBoxItem, 1)
        TriggerClientEvent('ox_lib:notify', source, {title = locale('awarded_gift'):format(random == 0 and 'Small Gift Box' or 'Large Gift Box'), duration = 5000, icon = 'snowflake'})
        return true
    else
        TriggerClientEvent('ox_lib:notify', source, {title = 'Pockets are full. Failed to reward gift. Better luck next time.', duration = 5000, icon = 'snowflake'})
        return false
    end
end

lib.callback.register('risky_santa:server:fetchPlayerRewards', function(source)
    local Player = exports.qbx_core:GetPlayer(source)

    if not Player then return end

    return Rewards[Player.PlayerData.citizenid] or nil
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function() 
    local source = source

    local Player = exports.qbx_core:GetPlayer(source)

    if not Player then return end

    if ActivePlayers[Player.PlayerData.citizenid] then
        ActivePlayers[Player.PlayerData.citizenid].loggedIn = true
    else
        ActivePlayers[Player.PlayerData.citizenid] = {
            loggedIn = true, -- is logged in ?
            rewardMinute = 0 -- last time rewarded
        }
    end
end)

AddEventHandler('QBCore:Server:OnPlayerUnload', function(source)
    local source = source

    local Player = exports.qbx_core:GetPlayer(source)

    if not Player then print('Failed to Get Player Entity') return end

    if ActivePlayers[Player.PlayerData.citizenid] then
        ActivePlayers[Player.PlayerData.citizenid].loggedIn = false
    end
end)

AddEventHandler('playerDropped', function (reason)
    local source = source

    local Player = exports.qbx_core:GetPlayer(source)

    if not Player then print('Failed to Get Player Entity') return end

    if ActivePlayers[Player.PlayerData.citizenid] then
        ActivePlayers[Player.PlayerData.citizenid].loggedIn = false
    end
end)

RegisterServerEvent('risky_santa:server:collectGift', function()
    local source = source

    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then print('Failed to Get Player Entity') return end

    local rewardLocation = Rewards[Player.PlayerData.citizenid]

    if not rewardLocation then 
        print('Failed To Find Gift For Player',Player.PlayerData.citizenid)
        return 
    end

    local giftCoords = giftLoc[rewardLocation]

    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    if #(playerCoords - giftCoords) > 10.0 then 
        print('Player Tried to Grab Gift From Far Location', Player.PlayerData.citizenid)
        return 
    end

    if not GenerateGiftBox(source) then return end

    for index, loc in pairs(usedLocations) do
        if loc == Rewards[cid] then
            table.remove(usedLocations, index)
            Rewards[cid] = nil
            break
        end
    end
end)

exports('santa_small_gift', function(event, item, inventory, slot, data)
    local source = inventory.id
    if event == 'usingItem' then
        if not lib.callback.await('risky_santa:client:openedReward', source, `tr_chris_present1`) then 
            TriggerClientEvent('ox_lib:notify', source, {title = 'Failed to Open Gift. Try Again!', duration = 5000, icon = 'snowflake'})
            return false 
        end

        local random = math.random(0, #config.rewards['santa_small_gift'])

        local rewardItem = config.rewards['santa_small_gift'][random]

        if exports.ox_inventory:CanCarryItem(source, rewardItem.item, rewardItem.count) then
            exports.ox_inventory:AddItem(source, rewardItem.item, rewardItem.count)
            return true
        else
            TriggerClientEvent('ox_lib:notify', source, {title = 'Pockets are full. Failed to reward gift. Try Again!.', duration = 5000, icon = 'snowflake'})
            return false
        end
    end

    if event == 'usedItem' then
        TriggerClientEvent('ox_lib:notify', source, {title = 'Used Small Gift Box.', duration = 5000, icon = 'snowflake'})
    end
end)

exports('santa_large_gift', function(event, item, inventory, slot, data)
    local source = inventory.id
    if event == 'usingItem' then
        if not lib.callback.await('risky_santa:client:openedReward', source, `tr_chris_present4`) then 
            TriggerClientEvent('ox_lib:notify', source, {title = 'Failed to Open Gift. Try Again!', duration = 5000, icon = 'snowflake'})
            return false 
        end

        local random = math.random(0, #config.rewards['santa_large_gift'])

        local rewardItem = config.rewards['santa_large_gift'][random]

        if exports.ox_inventory:CanCarryItem(source, rewardItem.item, rewardItem.count) then
            exports.ox_inventory:AddItem(source, rewardItem.item, rewardItem.count)
            return true
        else
            TriggerClientEvent('ox_lib:notify', source, {title = 'Pockets are full. Failed to reward gift. Try Again!.', duration = 5000, icon = 'snowflake'})
            return false
        end
    end

    if event == 'usedItem' then
        TriggerClientEvent('ox_lib:notify', source, {title = 'Used Large Gift Box.', duration = 5000, icon = 'snowflake'})
    end
end)

lib.cron.new("* * * * *", function()
    for cid, data in pairs(ActivePlayers) do
        if data.loggedIn then
            data.rewardMinute += 1
        end

        if data.rewardMinute >= config.timeForReward then
            -- Trigger Reward Generate Here
            data.rewardMinute = 0
            GenerateReward(cid)
        end
    end
end)

-- RegisterCommand("startscript", function(source)
--     local source = source

--     local Player = exports.qbx_core:GetPlayer(source)

--     if not Player then return end

--     if ActivePlayers[Player.PlayerData.citizenid] then
--         print('Logged In Player',Player.PlayerData.citizenid)
--         ActivePlayers[Player.PlayerData.citizenid].loggedIn = true
--     else
--         print('Initiated Player',Player.PlayerData.citizenid)
--         ActivePlayers[Player.PlayerData.citizenid] = {
--             loggedIn = true, -- is logged in ?
--             rewardMinute = 0 -- last time rewarded
--         }
--     end
--     -- GenerateReward(Player.PlayerData.citizenid)
-- end)