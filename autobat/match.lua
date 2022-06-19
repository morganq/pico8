function create_herospec(name, pos)
    return {
        name = name,
        pos = pos
    }
end

function create_shop()
    -- Pull 5 random heroes from the deck
    for i = 1,5 do
        local ind = rnd(#match.shop_deck) + 1
        local hero = match.shop_deck[ind\1]
        add(match.shop, hero)
        deli(match.shop_deck, ind)
    end
end

function buy_hero(index)
    local hero = match.shop[index]
    -- todo: merge etc.
    local open_spot = nil
    while open_spot == nil do
        local random_spot = rnd(placement_coords)
        local occupied = false
        for hs in all(match.team) do
            if hs.pos[1] == random_spot.pos[1] and hs.pos[2] == random_spot.pos[2] then
                occupied = true
                break
            end
        end
        if not occupied then
            open_spot = random_spot
        end
    end
    local spec = create_herospec(hero, open_spot)
    add(match.team, spec) 
    match.shop[index] = nil
end

function start_shop_turn()
    match.round += 1
    match.turn = "shop"
    match.shop_time_left = 30
    create_shop()
end

function start_sim_turn()
    -- Put unbought heroes back into the deck
    for i = 1,5 do
        if match.shop[i] != nil then
            add(match.shop_deck, match.shop[i])
        end
    end
    match.shop = {}
    match.turn = "sim"
    match.sim_time_left = 30
end

function start_match()
    match = {
        round = 0,
        turn = "shop",
        seed = rnd(32767),
        team = {},

        shop_deck = {},
        shop = {},
        shop_time_left = 0,

        sim_time_left = 0,
    }
    for i = 97,123 do
        local hn = chr(i)
        for j = 0, 9 do
            add(match.shop_deck, hn)
        end
    end
    srand(match.seed)
    start_shop_turn()
end