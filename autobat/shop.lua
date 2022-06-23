
function create_shop()
    for i = 1,5 do
        if match.shop[i] then
            add(match.shop_deck, match.shop[i])
        end
    end
    scroll_time = 0
    match.shop = {}
    -- Pull 5 random heroes from the deck
    for i = 1,5 do
        local ind = rnd(#match.shop_deck) + 1
        local hero = match.shop_deck[ind\1]
        add(match.shop, hero)
        deli(match.shop_deck, ind)
    end
end

function find_open_spot(hs, team)
    local open_spot = nil
    local i = 0
    while open_spot == nil do
        local random_x = rnd(6) \ 1
        local random_y = 0
        if i > 6 then
            random_y = mid(2 + hs.range + rnd(5)\1 - 2, 3, 5)
        elseif i > 3 then
            random_y = mid(2 + hs.range + rnd(3)\1 - 1, 3, 5)
        else
            if hs.range <= 1 then
                random_y = mid(2 + hs.range, 3, 5)
            else
                random_y = mid(2 + hs.range + rnd(3)\1 - 1, 3, 5)
            end
            
        end 
        local occupied = false
        for hs in all(team) do
            if hs.pos[1] == random_x and hs.pos[2] == random_y then
                occupied = true
                break
            end
        end
        if not occupied then
            open_spot = {random_x, random_y}
        end
        i += 1
    end    
    return open_spot
end

function buy_hero(index)
    if match.money < 3 then
        return
    end
    local hero = match.shop[index]
    
    -- Try to merge first
    merged = false
    for hs in all(match.team) do
        if hs.name == hero and hs.pips < 7 then
            hs.pips += 1
            merged = true
        end
    end
    if merged then
        for h in all(arena.heroes) do
            if h.initial == hero and h.pips < 7 then
                h.pips += 1
            end
        end
        -- Success
        match.money -= 3
        match.shop[index] = nil
        return
    end

    if #match.team >= match.max_heroes then
        return
    end

    -- Now add (only if merge didn't happen)
    local open_spot = find_open_spot(herostats[hero], match.team)
    local spec = create_herospec(hero, open_spot, 1)
    add(match.team, spec)
    local hero = create_hero(hero, 1, open_spot, 1)
    add(arena.heroes, hero)
    -- Success
    match.shop[index] = nil
    match.money -= 3
end

function draw_hero_card(x, y, hero, selected)
    w = 22
    h = 30
    local bgcolor = 6
    local fgcolor = 5
    if hero then
        bgcolor = 15
        fgcolor = 4
    end
    if selected then y -= 2 end
    rectfill(x, y, x + w, y + h, bgcolor)
    rect(x,y,x+w,y+h,fgcolor)
    if hero then
        name = herostats[hero].shortname
        local ty = 24
        clip(x+1,y+ty,w-1,5)
        --local excess = max(#name * 4 - (w-2),0)
        --debug(name.." "..(#name * 4).." "..excess)
        --local off = -cos(scroll_time / (#name * 4) / 4) * excess
        --off = mid(off, -excess/2 - 1, excess/2 + 1)
        print(sub(name,0,1), x + 12 - #name * 2, y+ty, 8)
        print(' ' .. sub(name,2), x + 12 - #name * 2, y+ty, 2)
        clip()
        local spri = 64 + ord(sub(name,1,1)) - 96
        
        pal({7,7,7,7,7,7,7,7,7,7,7,7,7,7,7})
        spr(spri, x + 7, y + 3)
        spr(spri, x + 9, y + 3)
        spr(spri, x + 8, y + 2)
        spr(spri, x + 8, y + 4)
        pal()
        spr(spri, x + 8, y + 3)
    end
    if selected then
        rect(x - 1, y - 1, x + w + 1, y + h + 1, 9)
    end
end

function shop_start()
    tf = 0
    shop_selected = 1
    repo_row = 2
    repo_ind = nil
    repo_picked = false
    repo_cursor = {0,0}
    repo_target = {0,0}
    x_pos = {0,0}
end

function hero_index_under_cursor()
    for i = 1, #match.team do
        local hs = match.team[i]
        if hs.pos[1] == repo_cursor[1] and hs.pos[2] == repo_cursor[2] then
            return i
        end
    end
    return nil
end

function shop_update_repositioning()
    if repo_picked then
        if btnp(0) and repo_target[1] > 0 then repo_target[1] -= 1 end
        if btnp(1) and repo_target[1] < 5 then repo_target[1] += 1 end
        if btnp(2) and repo_target[2] > 3 then repo_target[2] -= 1 end
        if btnp(3) and repo_target[2] < 5 then repo_target[2] += 1 end
        if btnp(5) then
            for hs in all(match.team) do
                if hs.pos[1] == repo_target[1] and hs.pos[2] == repo_target[2] then
                    repo_picked = false
                    return
                end
            end
            match.team[repo_ind].pos[1] = repo_target[1]
            match.team[repo_ind].pos[2] = repo_target[2]
            local pp = g2p(repo_target[1], repo_target[2])
            arena.heroes[repo_ind].x = pp[1] + 5
            arena.heroes[repo_ind].y = pp[2] + 5
            repo_picked = false
            repo_cursor = {repo_target[1], repo_target[2]}
        end
    else
        if btnp(0) and repo_cursor[1] > 0 then repo_cursor[1] -= 1 end
        if btnp(1) and repo_cursor[1] < 5 then repo_cursor[1] += 1 end
        if btnp(2) and repo_cursor[2] > 3 then repo_cursor[2] -= 1 end
        if btnp(3) and repo_cursor[2] < 5 then repo_cursor[2] += 1 end
        if btnp(5) then
            local i = hero_index_under_cursor()
            if i != nil then
                repo_ind = i
                repo_picked = true
                repo_target = p2g(arena.heroes[repo_ind].x, arena.heroes[repo_ind].y)
            end
        end
    end
end

function shop_update_cards()
    if btnp(0) then
        shop_selected = max(shop_selected - 1, 0)
    end
    if btnp(1) then
        shop_selected = min(shop_selected + 1, 5)
    end
    if btnp(5) then
        if shop_selected == 0 then
            if match.money > 0 then
                match.money -= 1
            end
            create_shop()
            
        else
            if match.shop[shop_selected] then
                buy_hero(shop_selected)
            end
        end
    end    
end

function shop_update()
    scroll_time += 1
    match.shop_time_left -= 1/30
    tf += 1
    if repo_row == 1 then
        if btnp(3) and not repo_picked and repo_cursor[2] == 5 then
            repo_row = 2
            shop_selected = repo_cursor[1]
        else        
            shop_update_repositioning()
        end
    else
        shop_update_cards()
        if btnp(2) then -- and #match.team > 0 then
            repo_row = 1
            repo_cursor = {shop_selected, 5}
        end            
    end

    if btnp(4) then
        start_sim_turn()
        set_scene("sim")
    end
end

function draw_status_for(hn, level)
    local h = herostats[hn]
    level = level or 1
    status_str = "lvl" .. level .. " " .. h.name .. ": ".. h.ult
    local px, py = 0,0
    local parts = split(status_str, "$")
    local insert = tostr(get_ult_number(hn, level) * 10 \ 1 / 10)
    if #parts > 1 then
        px = #parts[1] * 4
        status_str = parts[1]
        for i = 1, #insert do
            status_str ..= " "
        end
        status_str ..= parts[2]
    end
    local line1, line2 = status_str, ""
    if #status_str > 30 then
        line1, line2 = sub(status_str, 1, 30), sub(status_str, 31)
        if #parts[1] > 30 then
            px -= 117
            py += 7
        end
    end
    print(h.name, 21, 115, 2)
    rectfill(2,114,18,120, 0)
    print(sub(line1, 1, 5), 3, 115, level_colors[level])
    print(sub(line1, 6 + #h.name), 4 + (#h.name + 4) * 4, 115, 1)
    print(line2, 3, 122, 1)
    print(insert, px, 115 + py, 3)    
end

function shop_draw()
    if repo_row == 1 then
        rectfill(0,6,127,74,6)
    else
        rectfill(0,76,127,112, 6)
    end    
    draw_arena()
    for i = 1, 5 do
        draw_hero_card(i * 20, 80, match.shop[i], i == shop_selected and repo_row == 2)
        if i == shop_selected then
            x_pos = {i * 20 - 2, 76}
        end
    end

    draw_game_ui()
    
    -- Shop stats
    rectfill(0, 8, 22, 21, 5)
    rectfill(0, 9, 23, 20, 5)
    spr(210, 1, 11)
    local c = match.money > 0 and 10 or 8
    print(match.money, 11, 13, c)

    rectfill(0, 28, 22, 41, 5)
    rectfill(0, 29, 23, 40, 5)
    spr(211, 1, 31)
    local c = #match.team < match.max_heroes and 7 or 8
    print(#match.team .. "/" .. match.max_heroes, 11, 33, c)

    local rrx, rry = 2, 88
    rectfill(rrx, rry, rrx + 13, rry + 13, 15)
    rect(rrx, rry, rrx + 13, rry + 13, 4)
    if shop_selected == 0 and repo_row == 2 then
        x_pos = {rrx - 3, rry - 2}
        rect(rrx-1,rry-1,rrx+14,rry+14,9)
    end
    spr(212, rrx+3, rry+3)

    if repo_row == 1 then
        local pp = g2p(repo_cursor[1], repo_cursor[2])
        rect(pp[1] - 1, pp[2] - 1, pp[1] + grid_size - 1, pp[2] + grid_size - 1, 9)
        x_pos = {pp[1] - 2, pp[2] - 2}
        if repo_picked then
            local pp = g2p(repo_target[1], repo_target[2])
            rect(pp[1], pp[2], pp[1] + grid_size - 2, pp[2] + grid_size - 2, tf\4 % 2 == 0 and 9 or 10)
            x_pos = {pp[1] - 2, pp[2] - 2}
        end
        -- Status bar
        local i = hero_index_under_cursor()
        if i != nil then
            local sel = arena.heroes[i]
            draw_status_for(sel.initial, sel:get_level_filled_total_pips())
        end
    else
        -- Status bar
        if match.shop[shop_selected] then
            local hn = match.shop[shop_selected]
            draw_status_for(hn)
        end
    end

    spr(213, 104, 60, 2, 1)
    print("🅾️", 109, 61, tf \ 15 % 2 == 0 and 0 or 7)
    spr(215, x_pos[1] - 1, x_pos[2] - 1,2,1)
    print("❎", x_pos[1], x_pos[2], tf \ 15 % 2 == 0 and 0 or 7)
end

function shop_finish()
end

scenes.shop = {
    start = shop_start,
    update = shop_update,
    draw = shop_draw,
    finish = shop_finish
}