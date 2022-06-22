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

function buy_hero(index)
    local hero = match.shop[index]
    match.shop[index] = nil
    
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
        
        return
    end

    -- Now add (only if merge didn't happen)
    local open_spot = nil
    local i = 0
    while open_spot == nil do
        local random_x = rnd(6) \ 1
        local random_y = 0
        local hs = herostats[hero]
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
        for hs in all(match.team) do
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
    local spec = create_herospec(hero, open_spot, 1)
    add(match.team, spec)
    local hero = create_hero(hero, 1, open_spot, 1)
    add(arena.heroes, hero)
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
        name = herostats[hero].name
        clip(x+1,y+3,w-1,5)
        local excess = max(#name * 4 - (w-2),0)
        --debug(name.." "..(#name * 4).." "..excess)
        local off = -cos(scroll_time / (#name * 4) / 4) * excess
        off = mid(off, -excess/2 - 1, excess/2 + 1)
        print(sub(name,0,1), x + 2 - off - excess / 2, y+3, 8)
        print(' ' .. sub(name,2), x + 2 - off - excess / 2, y+3, 2)
        clip()

        cx,cy = 12, 20
        --ovalfill(x + cx, y + cy, x + cx + 8, y + cy + 8, 0)
        --ovalfill(x + cx, y + cy - 1, x + cx + 8, y + cy + 8 - 1, 12)
        --print(sub(name,0,1), x + cx + 3, y + cy + 1, 1)            
        spr(64 + ord(sub(name,1,1)) - 96, x + cx, y + cy)
    end
    if selected then
        rect(x - 1, y - 1, x + w + 1, y + h + 1, 9)
    end
end

function shop_start()
    tf = 0
    shop_selected = 1
end

function shop_update()
    scroll_time += 1
    match.shop_time_left -= 1/30
    tf += 1
    if btnp(0) then
        shop_selected = max(shop_selected - 1, 0)
    end
    if btnp(1) then
        shop_selected = min(shop_selected + 1, 5)
    end
    if btnp(5) then
        if shop_selected == 0 then
            create_shop()
        else
            if match.shop[shop_selected] then
                buy_hero(shop_selected)
            end
        end
    end
    if btnp(4) or match.shop_time_left <= 0 then
        start_sim_turn()
        set_scene("sim")
    end
end

function shop_draw()
    draw_arena()
    for i = 1, 5 do
        draw_hero_card(i * 24 - 20, 82, match.shop[i], i == shop_selected)
    end
    draw_game_ui()
    
    if match.shop[shop_selected] then
        local hn = match.shop[shop_selected]
        local h = herostats[hn]
        status_str = h.name .. ": ".. h.ult
        local px, py = 0,0
        local parts = split(status_str, "$")
        local insert = tostr(get_ult_number(hn))
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
                px -= 120
                py += 6
            end
        end
        print(h.name, 3, 115, 2)
        print(sub(line1, #h.name+1), 3 + #h.name * 4, 115, 1)
        print(line2, 3, 121, 1)
        print(insert, 3 + px, 115 + py, 3)
    end
end

function shop_finish()
end

scenes.shop = {
    start = shop_start,
    update = shop_update,
    draw = shop_draw,
    finish = shop_finish
}