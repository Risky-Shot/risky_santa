function SpawnReward(rewardCoords)
    local point = lib.points.new({
        coords = rewardCoords,
        distance = 20,
        rewardObj = nil,
        onEnter = function(self)
            if not lib.requestModel('prop_xmas_tree_int', 10000) then
                return 
            end

            self.rewardObj = CreateObject(`prop_xmas_tree_int`, self.coords.x, self.coords.y, self.coords.z, false, false, false)
            
            if not lib.waitFor(function()
                if DoesEntityExist(self.rewardObj) then return true end
            end, ("failed to create christams reward object. Please go far and come again.")) then 
                self.rewardObj = nil
                return 
            end

            PlaceObjectOnGroundProperly(self.rewardObj)
            FreezeEntityPosition(self.rewardObj, true)

            exports.ox_target:addLocalEntity(self.rewardObj, {
                label = locale('grab_gift'),
                name = 'risky_santa_reward_tree',
                icon = 'fa-solid fa-gift',
                onSelect = function()
                    TriggerServerEvent("risky_santa:server:collectGift")
                end
            })
        end,
        onExit = function(self)
            exports.ox_target:removeLocalEntity(self.rewardObj, 'risky_santa_reward_tree')

            if DoesEntityExist(self.rewardObj) then 
                DeleteEntity(self.rewardObj) 
                self.rewardObj = nil
            end

            SetModelAsNoLongerNeeded('prop_xmas_tree_int')
        end
    })

    return point
end