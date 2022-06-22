function serialize_team(team)
    local s = ""
    for i = 1, #team do
        local herospec = team[i]
        s ..= herospec.name .. herospec.pips .. ':' .. serialize_gpt(herospec.pos)
        if i != #team then s ..= "/" end
    end
    return s
end

function deserialize_team(s)
    local team = {}
    local s_heroes = split(s, "/")
    for s_hero in all(s_heroes) do
        local s_parts = split(s_hero, ":")
        add(team, create_herospec(
            sub(s_parts[1],1,1),
            deserialize_gpt(s_parts[2]),
            tonum(sub(s_parts[1],2,2)))
        )
    end
    return team
end

function create_herospec(name, pos, pips)
    return {
        name = name,
        pips = pips or 1,
        pos = pos
    }
end

function start_shop_turn()
    match.round += 1
    match.turn = "shop"
    match.shop_time_left = 30
    create_shop()
    create_arena(match.team)
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

    -- Load an enemy
    local team2 = deserialize_team(sample_team)
    create_arena(match.team, team2)
end

function start_match()
    match = {
        round = 0,
        turn = "shop",
        seed = rnd(32767),
        team = {},

        money = 10,
        wins = 0,
        losses = 0,

        shop_deck = {},
        shop = {},
        shop_time_left = 0,

        sim_time_left = 0,
    }
    for i = 97,122 do
    --for i = 97,98 do
        local hn = chr(i)
        for j = 0, 9 do
            add(match.shop_deck, hn)
        end
    end
    srand(match.seed)
    start_shop_turn()
    --[[buy_hero(1)
    buy_hero(2)
    buy_hero(3)]]
    debug(serialize_team(match.team))
    --debug(serialize_team(deserialize_team(serialize_team(match.team))))
end