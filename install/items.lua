return {
    -- Copy From Here to ox_inventory/data/items.lua (Make Sure to Add comma before adding this data)
    ['santa_small_gift'] = {
        label = 'Gift Box [S]',
        description = 'A charming box filled with festive surprises and petite holiday treats.',
        weight = 1000,
        stack = true,
        client = {
            image = 'santa_small_gift.png'
        },
        server = {
            export = 'risky_santa.santa_small_gift'
        }
    },
    ['santa_large_gift'] = {
        label = 'Gift Box [L]',
        description = 'A generous box overflowing with premium holiday treasures and joyful surprises.',
        weight = 2000,
        stack = true,
        client = {
            image = 'santa_large_gift.png'
        },
        server = {
            export = 'risky_santa.santa_large_gift'
        }
    }
}