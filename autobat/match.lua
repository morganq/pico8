round_heroes = split"2,3,4,4,5,5,6,6,7,7,8,8,9"

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
    for s_hero in all(split(s, "/")) do
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
    match.round += 1
    match.max_heroes = round_heroes[match.round] or 9
    match.turn = "shop"
    match.money = 8
    create_arena(match.team)
end

function start_sim_turn()
    match.turn = "sim"
    match.sim_time_left = 45

    -- Load the enemy
    if match.mode == "arena" then
        create_arena(match.team, make_ai_team(match.round + (match.difficulty - 1)))
    else -- Head to head
        create_arena(match.team, match.progression[match.round])
    end
end

function start_match(gamemode, difficulty, mutators, progression)
    match = {
        mode = gamemode,
        difficulty = difficulty,
        mutators = mutators,
        round = 0,
        turn = "shop",
        team = {},
        money = 0,
        max_heroes = 1,
        wins_needed = gamemode == "arena" and 9 or 7,
        losses_needed = gamemode == "arena" and 5 or 7,
        wins = 0,
        losses = 0,
        shop_deck = {},
        shop = {},
        sim_time_left = 0,
        progression = progression
    }
    --[[
    local s = ""
    for i = 97,122 do
        local hn = chr(i)
        for j = 0, 14 do
            s ..= hn .. ","
            add(match.shop_deck, hn)
        end
    end
    printh(s, "test.txt")
    ]]--
    match.shop_deck = split"a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,d,d,d,d,d,d,d,d,d,d,d,d,d,d,d,e,e,e,e,e,e,e,e,e,e,e,e,e,e,e,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,h,h,h,h,h,h,h,h,h,h,h,h,h,h,h,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,j,j,j,j,j,j,j,j,j,j,j,j,j,j,j,k,k,k,k,k,k,k,k,k,k,k,k,k,k,k,l,l,l,l,l,l,l,l,l,l,l,l,l,l,l,m,m,m,m,m,m,m,m,m,m,m,m,m,m,m,n,n,n,n,n,n,n,n,n,n,n,n,n,n,n,o,o,o,o,o,o,o,o,o,o,o,o,o,o,o,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,u,u,u,u,u,u,u,u,u,u,u,u,u,u,u,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,y,y,y,y,y,y,y,y,y,y,y,y,y,y,y,z,z,z,z,z,z,z,z,z,z,z,z,z,z,z"
    srand(game_seed)
    create_shop()
    start_shop_turn()
end