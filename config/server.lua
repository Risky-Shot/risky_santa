return {
    -- Time Interval after which reward will be given
    timeForReward = 5, -- in minutes

    -- 1 item will be chosen random based on box size and added with count 
    rewards = {
        ['santa_small_gift'] = {
            [0] = {
                item = 'lockpick',
                count = 1
            },
            [1] = {
                item = 'armour',
                count = 1
            },
        },
        ['santa_large_gift'] = {
            [0] = {
                item = 'lockpick',
                count = 2
            },
            [1] = {
                item = 'armour',
                count = 2
            },
        }
    }
}