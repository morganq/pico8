function create_shop()
    for i = 1,5 do
        if match.shop[i] then
            add(match.shop_deck, match.shop[i])
        end
    end
    match.shop = {}
    for i = 1,5 do
        local ind = rnd(#match.shop_deck)\1 + 1
        local hero = match.shop_deck[ind]
        add(match.shop, hero)
        deli(match.shop_deck, ind)
    end
end

-- OPT: just pick a random spot entirely rather than worrying about range
function find_open_spot(hs, team)
    local open_spot, i = nil, 0
    while true do
        local occupied = false
        local random_x, random_y = rnd(6) \ 1, rnd(3) \ 1 + 3
        
        for hs in all(team) do
            if hs.pos[1] == random_x and hs.pos[2] == random_y then
                occupied = true
                break
            end
        end
        if not occupied then
            return {random_x, random_y}
        end
        i += 1
    end    
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
                local ol = h:get_level_filled_total_pips()
                h.pips += 1
                h.pop_time = 7
                local l = h:get_level_filled_total_pips()
                if l > ol then
                    h.pop_time = 16
                end
                
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
    local hero = create_hero(hero, 1, open_spot, 1, #match.team - 1)
    add(arena.heroes, hero)
    -- Success
    match.shop[index] = nil
    match.money -= 3
end

function draw_hero_card(x, y, hero, selected, owns)
    local w, h, bgcolor, fgcolor = 22, 30, 6, 5
    if hero then
        bgcolor = 15
        fgcolor = 4
    end
    if selected then y -= 2 end
    if owns then
        bgcolor = 10
    end    
    rectfill(x, y, x + w, y + h, bgcolor)
    rect(x,y,x+w,y+h,fgcolor)
    if hero then
        name = herostats[hero].shortname
        local ty = 24
        print(sub(name,0,1), x + 12 - #name * 2, y+ty, 8)
        print(' ' .. sub(name,2), x + 12 - #name * 2, y+ty, 2)
        local spri = 64 + ord(sub(name,1,1)) - 96
        
        pal(split"7,7,7,7,7,7,7,7,7,7,7,7,7,7,7")
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
    tf, shop_selected, repo_row, repo_ind, repo_picked, repo_cursor, repo_target, x_pos, modal_open, modal_option = 0, 1, 2, nil, false, {0,0}, {0,0}, {0,0}, false, 1
end

function hero_index_under_cursor()
    for i = 1, #match.team do
        local hs = match.team[i]
        if hs.pos[1] == repo_cursor[1] and hs.pos[2] == repo_cursor[2] then
            return i
        end
    end
end

function shop_update_repositioning()
    if repo_picked then
        if btnp(0) and repo_target[1] > 0 then repo_target[1] -= 1 end
        if btnp(1) and repo_target[1] < 5 then repo_target[1] += 1 end
        if btnp(2) and repo_target[2] > 3 then repo_target[2] -= 1 end
        if btnp(3) and repo_target[2] < 6 then repo_target[2] += 1 end
        if btnp(5) then
            for hs in all(match.team) do
                if hs.pos[1] == repo_target[1] and hs.pos[2] == repo_target[2] then
                    repo_picked = false
                    return
                end
            end
            if repo_target[2] == 6 then
                deli(match.team, repo_ind)
                deli(arena.heroes, repo_ind)
                repo_picked = false
                match.money += 3
            else
                match.team[repo_ind].pos = {repo_target[1], repo_target[2]}
                local pp = g2p(repo_target[1], repo_target[2])
                arena.heroes[repo_ind].x = pp[1] + 5
                arena.heroes[repo_ind].y = pp[2] + 5
                repo_picked = false
                repo_cursor = {repo_target[1], repo_target[2]}
            end
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
                create_shop()
            end
        else
            if match.shop[shop_selected] then
                buy_hero(shop_selected)
            end
        end
    end    
end

function shop_update()
    tf += 1
    if modal_open then
        if btnp(0) or btnp(1) then modal_option = 3 - modal_option end
    elseif repo_row == 1 then
        if btnp(3) and not repo_picked and repo_cursor[2] == 5 then
            repo_row = 2
            shop_selected = repo_cursor[1]
        else        
            shop_update_repositioning()
        end
    else
        shop_update_cards()
        if btnp(2) then
            repo_row = 1
            repo_cursor = {shop_selected, 5}
        end            
    end

    if modal_open and btnp(5) then
        if modal_option == 1 then
            modal_open = false
            modal_option = 1
        else
            start_sim_turn()
            set_scene"sim"            
        end
    end

    if btnp(4) then
        if match.money > 0 then
            modal_open = true
        else
            start_sim_turn()
            set_scene"sim"
        end
    end
end

function draw_status_for(hn, level)
    local h, px, py = herostats[hn], 0, 0
    level = level or 1
    status_str = "lvl" .. level .. " " .. h.name .. ": ".. h.ult
    local parts, insert = split(status_str, "$"), tostr(get_ult_number(hn, level) * 10 \ 1 / 10)
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
        rectfill(0,7,127,75,6)
    else
        rectfill(0,76,127,112, 6)
    end    
    draw_arena()
    if repo_picked then
        local c1, c2 = 6,5
        if repo_target[2] == 6 then
            c1, c2 = 14,7
        end
        rectfill(20, 80, 122, 110, c1)
        print("sell", 63, 92, c2)
    else
        for i = 1, 5 do
            local has_hero = false
            for hs in all(match.team) do
                if hs.name == match.shop[i] then has_hero = true end
            end
            draw_hero_card(i * 20, 80, match.shop[i], i == shop_selected and repo_row == 2, has_hero)
            if i == shop_selected then
                x_pos = {i * 20 - 2, 76}
            end
        end
    end

    draw_game_ui()
    
    -- Shop stats
    roundrect(-1,7,23,21)
    spr(210, 1, 10)
    local c = match.money > 0 and 10 or 8
    print(match.money, 11, 12, c)

    roundrect(-1,27,23,41)
    spr(211, 1, 30)
    local c = #match.team < match.max_heroes and 7 or 8
    print(#match.team .. "/" .. match.max_heroes, 11, 32, c)

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
            if repo_target[2] == 6 then
                x_pos = {56,85}
            else
                local pp = g2p(repo_target[1], repo_target[2])
                rect(pp[1], pp[2], pp[1] + grid_size - 2, pp[2] + grid_size - 2, tf\4 % 2 == 0 and 9 or 10)
                x_pos = {pp[1] - 2, pp[2] - 2}
            end
        end
        -- Status bar
        local i = hero_index_under_cursor()
        if i != nil then
            local sel = arena.heroes[i]
            draw_status_for(sel.initial, sel:get_level_filled_total_pips())
            local fields = split"max_health,damage,attack_speed,max_mana"
            for i = 1,4 do
                print(sel[fields[i]] * 10 \ 1 / 10, i * 30 - 22, 1, 0)
                spr(127+i, i * 30 - 30, 1)
            end
        end
        
    else
        -- Status bar
        if match.shop[shop_selected] then
            local hn = match.shop[shop_selected]
            draw_status_for(hn)
        end
    end

    spr(tf % 24 > 12 and 213 or 197, 104, 60, 2, 1)

    if modal_open then
        rectfill(0, 50, 127, 78, 9)
        local x = 45 * modal_option - 16
        rectfill(x, 67, x + 17, 75, 7)
        print("end turn with excess gold?", 12, 56, 0)
        print("no         yes", 34, 69, 0)
        x_pos = {x-2, 63}
    end

    spr(215, x_pos[1] - 1, x_pos[2] - 1,2,1)
    print("❎", x_pos[1], x_pos[2], tf \ 15 % 2 == 0 and 0 or 7)
end

scenes.shop = {
    start = shop_start,
    update = shop_update,
    draw = shop_draw,
}