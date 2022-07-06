round_heroes = split("2,3,4,4,5,5,6,6,7,7,8,8,9")

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
    --printh(#match.shop_deck, "test.txt")
end

function start_sim_turn()
    match.turn = "sim"
    match.sim_time_left = 45

    -- Load the enemy
    if match.mode == "arena" then
        local team2 = make_ai_team(match.round + (match.difficulty - 1))
        create_arena(match.team, team2)
    elseif match.mode == "head2head" then
        local bonus = 0
        if match.difficulty == 2 then
            bonus = match.round \ 2
        end
        match.running_enemy_team = do_ai_team_round(match.running_enemy_team, match.round, bonus)
        create_arena(match.team, match.running_enemy_team)
    else -- daily
        create_arena(match.team, daily_progression[match.round])
    end
end

function start_match(gamemode, difficulty, mutators, progression)
    local modes = {'arena','head2head','daily_challenge'}
    match = {
        mode = modes[gamemode],
        difficulty = difficulty,
        mutators = mutators,
        round = 0,
        turn = "shop",
        seed = game_seed,
        team = {},

        money = 0,
        max_heroes = 1,
        wins_needed = gamemode == 2 and 7 or 9,
        losses_needed = gamemode == 2 and 7 or 5,
        wins = 0,
        losses = 0,

        shop_deck = {},
        shop = {},
        shop_time_left = 0,

        sim_time_left = 0,

        running_enemy_team = {},
    }
    for i = 97,122 do
        local hn = chr(i)
        for j = 0, 14 do
            add(match.shop_deck, hn)
        end
    end
    srand(match.seed)
    daily_progression = progression
    create_shop()
    start_shop_turn()
end