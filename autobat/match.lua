round_heroes = {
    2, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9
}
max_wins = 9
max_losses = 5

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

function start_shop_turn()
    --match.max_heroes = min(match.max_heroes + 1, 9)
    match.round += 1
    if round_heroes[match.round] then
        match.max_heroes = round_heroes[match.round]
    end
    match.turn = "shop"
    match.shop_time_left = 30
    match.money = 8
    create_arena(match.team)
end

function start_sim_turn()
    -- Put unbought heroes back into the deck
    --[[for i = 1,5 do
        if match.shop[i] != nil then
            add(match.shop_deck, match.shop[i])
        end
    end]]--
    --match.shop = {}
    match.turn = "sim"
    match.sim_time_left = 45

    -- Load an enemy
    local team2 = make_ai_team(match.round) --deserialize_team(sample_team)
    create_arena(match.team, team2)
end

function start_match()
    match = {
        round = 0,
        turn = "shop",
        seed = rnd(32767),
        team = {},

        money = 0,
        max_heroes = 1,
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
    create_shop()
    start_shop_turn()
    --[[buy_hero(1)
    buy_hero(2)
    buy_hero(3)]]
    debug(serialize_team(match.team))
    --debug(serialize_team(deserialize_team(serialize_team(match.team))))
end