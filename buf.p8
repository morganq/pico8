pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
-- buf
-- by morganquirk

-- sleeping
-- zoomies - go fast 
-- scratch - ?
-- play with toy
-- eat - ?
-- kill bugs

darken = split("0,1,1,2,1,5,6,4,4,9,3,13,5,8,9")
darken[0] = 0
selected_cat_index = 1

debugs = {}

function vec(x,y)
    local v = {
        x or 0,
        y or 0,
    }
    return v
end
function vdsq(v)
    return (v[1] * v[1] + v[2] * v[2])
end
function vnorm(v)
    local dist = sqrt(vdsq(v))
    return vec(v[1] / dist, v[2] / dist)
end

pal_black = {[2]=0,[4]=0}
pal_orange = {[2]=4,[4]=9,[10]=3}
pal_grey = {[2]=1,[4]=5,[10]=9}
pal_brown = {[10]=7}

cats = {
    {palette=pal_black, personality="black cat\naggressive but nervous\nloves to catch critters", love="catch", frames={54,55}, anim_rate=3},
    {palette=pal_orange, personality="orange cat\nvery silly\nloves to play with toys", love="play", frames={56,57,58,59,60,57,58,59,60,57,56}, anim_rate=6},
    {palette=pal_brown, personality="tabby cat\nvery social\nloves to lie in the sun", love="sun", frames={1,1,17,33,17,33,17,33,17,33,17,1}, anim_rate=18},
    {palette=pal_grey, personality="grey cat\ndignified and calm\nloves to scratch", love="scratch", frames={2,3,4,5,6,7}, anim_rate=8},
}

dleft, dright, dup, ddown = 1,2,4,8
pl = nil
function make_player()
    pl = {
        x = 50, y = 50,
        xv = 0, yv = 0,
        z = 0, zv = 0, -- jumping
        decel = 0.9,
        max_speed = 0.6,
        dir = 2,
        palette = cats[selected_cat_index].palette,
        in_sun = false,
        state = "sit",
        set_state = function(ns)
            if states[pl.state].exit then states[pl.state].exit() end
            pl.state = ns
            if states[pl.state].enter then states[pl.state].enter() end
            states[pl.state].update()
        end,
        draw_state = {flip=false, spri=1, frame=0},
        anim_t = 0,
        meter = 0,
        add_meter = function(amt)
            pl.meter = min(pl.meter + amt, 100)
        end,
        zoomy_times = {{6,8}, {12,15}},
        --zoomy_times = {{0,16}},
        charge_t = 0,
        charge_dir = {},
    }
end

function check_interaction_triggers()
    if pl.in_sun then
        set_action_message("❎  to sleep in the sun")
        if btnp(5) then
            pl.set_state("sleep")
            set_action_message("")
        end
    else
        if zoomy_time() and zoomy_time() < 1 then
            set_action_message("zoomies!")
        else    
            set_action_message("")
        end
    end 
end

function zoomy_time()
    for span in all(pl.zoomy_times) do
        if time >= span[1] and time < span[2] then return time - span[1] end
    end
    return false
end

function get_move_state()
    if zoomy_time() then return "zoom" end
    return "walk"
end

function sit_update()
    pl.draw_state.spri = 1
    pl.draw_state.frame = 0
    if btnp(0) or btnp(1) or btnp(2) or btnp(3) then
        pl.set_state(get_move_state())
    end 
    if btnp(5) and zoomy_time() then
        pl.set_state("charge")
        return
    end    
    check_interaction_triggers()
end

function move_update(speed, spri)
    local d = {0,0}
    if btn(0) then
        d[1] = -1
    end
    if btn(1) then
        d[1] = 1
    end
    if btn(2) then
        d[2] = -1
    end
    if btn(3) then
        d[2] = 1
    end
    if d[1] == 0 and d[2] == 0 then
        pl.set_state("sit")
    else
        if pl.dir != dleft then pl.dir = dright end
        if d[1] != 0 or d[2] != 0 then
            d = vnorm(d)
            d = {d[1] * speed, d[2] * speed}
            if d[1] != 0 or d[2] != 0 then
                if d[2] > 0 then
                    pl.dir = ddown
                    pl.draw_state.spri = spri + 32
                elseif d[2] < 0 then
                    pl.dir = dup
                    pl.draw_state.spri = spri + 16
                end

                -- not elseif so that left/right take priority
                if d[1] > 0 then
                    pl.dir = dright
                    pl.draw_state.flip = false
                    pl.draw_state.spri = spri
                elseif d[1] < 0 then
                    pl.dir = dleft
                    pl.draw_state.flip = true
                    pl.draw_state.spri = spri
                end

                pl.xv += d[1]
                pl.yv += d[2]
                pl.anim_t += 1
            end
        end
    end
    check_interaction_triggers()
end

function walk_update()
    pl.decel = 0.7
    pl.max_speed = 0.6
    if zoomy_time() then pl.set_state("zoom") end
    move_update(0.3, 2)
    pl.draw_state.frame = (pl.anim_t \ 6) % 6
end

function zoom_update()
    if btnp(5) then
        pl.set_state("charge")
        return
    end

    pl.decel = 0.9
    pl.max_speed = 2.2
    
    if vdsq({pl.xv, pl.yv}) >= pl.max_speed then
        pl.add_meter(0.25)
    end

    if not zoomy_time() then pl.set_state("walk") end
    move_update(0.3, 8)
    pl.draw_state.frame = (pl.anim_t \ 2) % 7
end

function sleep_update()
    pl.draw_state.spri = 17 + min((pl.anim_t % 80) \ 10, 1) * 16
    pl.anim_t += 1
    pl.draw_state.frame = 0
    pl.add_meter(0.25)
    if btnp(0) or btnp(1) or btnp(2) or btnp(3) then
        pl.set_state(get_move_state())
    end     
    if not pl.in_sun then
        pl.set_state("sit")
    end
end

function charge_update()
    pl.charge_t += 1
    pl.draw_state.spri = 54
    pl.draw_state.frame = (pl.anim_t \ 3) % 2
    pl.anim_t += 1    
    if not btn(5) or pl.charge_t > 30 then
        pl.set_state("pounce")
    end
end

function pounce_enter()
    pl.zv = mid(pl.charge_t, 10, 30) / 30 + 0.5
end

function pounce_update()
    pl.draw_state.spri = 52
    pl.draw_state.frame = (pl.anim_t \ 2) % 2
    pl.anim_t += 1
    if pl.dir == dleft then pl.xv = -0.6 end
    if pl.dir == dright then pl.xv = 0.6 end
    if pl.dir == dup then pl.yv = -0.6 end
    if pl.dir == ddown then pl.yv = 0.6 end
    pl.z += pl.zv
    if pl.z < 0 then
        pl.zv = 0
        pl.z = 0
        pl.set_state("sit")
    else
        pl.zv -= 0.1
    end
end

states = {
    sit = {update = sit_update},
    walk = {update = walk_update},
    zoom = {update = zoom_update},
    sleep = {update = sleep_update, enter = function() pl.anim_t = 0 end},
    charge = {update = charge_update, enter = function() pl.charge_t = 0; pl.charge_dir = {} end},
    pounce = {update = pounce_update, enter = pounce_enter}
}

ray = vnorm({1, 1})
sun_angle = 45
tf = 0
time = 0

ceiling_tiles = {}


function move()
    function do_x()
        local dir = 1
        if pl.xv < 0 then dir = -1 end
        step = abs(pl.xv)
        while step > 0 do
            if collides(pl.x + step * dir + 1 * dir, pl.y - 1) or collides(pl.x + step * dir + 1 * dir, pl.y - 1) then
                if dir > 0 then pl.xv = min(pl.xv, 0)
                else pl.xv = max(pl.xv, 0) end
                break
            else
                pl.x += dir * min(step, 1)
            end
            step -= 1
        end
    end
    function do_y()
        local dir = 1
        if pl.yv < 0 then dir = -1 end
        step = abs(pl.yv)
        while step > 0 do
            if collides(pl.x - 1, pl.y + step * dir + 1 * dir) or collides(pl.x + 1, pl.y + step * dir + 1 * dir) then
                if dir > 0 then pl.yv = min(pl.yv, 0)
                else pl.yv = max(pl.yv, 0) end
                break
            else
                pl.y += dir * min(step, 1)
            end
            step -= 1
        end
    end   
    if abs(pl.xv) > abs(pl.yv) then
        do_x()
        do_y()
    else
        do_y()
        do_x()
    end
end

function hash(p)
    return p[1] + p[2] * 16
end

function pt_to_col_addr(pt)
    return 0x8000 + flr(pt[1]) + flr(pt[2]) * 128
end

function collides(x,y)
    return @pt_to_col_addr({x,y}) != 0
end

non_colliders = split("0,111,127")
flood_blockers = split("64,65,66,67,68,69,70,71,74,75,76,77,78,111")


action_message = ""
action_message_time = 0
function set_action_message(msg)
    if msg == "" then
        action_message = ""
    else
        if action_message != msg or action_message_time < 0 then
            action_message_time = 0
            action_message = msg
        end
    end
end

function _init()
    -- collision
    memset(0x8000, 0x00, 128 * 128)
    map(0,0,0,0,16,16)
    for gx = 0, 15 do
        for gy = 0, 15 do
            local t = mget(gx,gy)
            if count(non_colliders, t) == 0 then
                for x = 0, 7 do
                    for y = 0, 7 do
                        local fx, fy = x + gx * 8 + 1, y + gy * 8 + 1
                        local c = pget(fx, fy)
                        if c != 0 then
                            poke(pt_to_col_addr({fx,fy}), 1)
                        end
                    end
                end
            end
            
        end
    end

    local flood_positions = {}
    for y = 0, 15 do
        for x = 0, 15 do
            local t = mget(x,y)
            if t > 0 then
                if t == 127 then
                    mset(x,y,0)
                    add(flood_positions, {x,y})
                elseif t == 111 then
                    --
                else
                    mset(x,y-1 + 16, t + 16)
                    mset(x+16,y + 16, t + 32)
                end
            end
        end
    end
    for fp in all(flood_positions) do
        local all_flooded = flood_tiles(fp)
        local all_flooded_hash = {}
        for t in all(all_flooded) do
            add(all_flooded_hash, hash(t))
        end
        function has_pt(pt)
            return count(all_flooded_hash, hash(pt)) != 0
        end
        for t in all(all_flooded) do
            local x1o, y1o, x2o, y2o = 0,0,0,0
            if not has_pt({t[1] - 1, t[2]}) then x1o -= 4 end
            if not has_pt({t[1], t[2] - 2}) then y1o -= 4 end
            if not has_pt({t[1] + 1, t[2]}) then x2o += 4 end
            if not has_pt({t[1], t[2] + 1}) then y2o += 4 end
            add(ceiling_tiles, {t[1] * 8 + x1o, t[2] * 8 + y1o, t[1] * 8 + 8 + x2o, t[2] * 8 + 8 + y2o})
        end
    end
    for y = 0, 15 do
        for x = 0, 15 do
            local t = mget(x,y)
            if t == 111 then mset(x,y,0) end
        end
    end    
end

function get_neighbors(xy)
    local neighbors = {}
    if xy[1] > 0 then add(neighbors, {xy[1] - 1, xy[2]}) end
    if xy[1] < 15 then add(neighbors, {xy[1] + 1, xy[2]}) end
    if xy[2] > 0 then add(neighbors, {xy[1], xy[2] - 1}) end
    if xy[2] < 15 then add(neighbors, {xy[1], xy[2] + 1}) end
    return neighbors
end
function flood_tiles(fp)
    local tiles = {}
    local open = {fp}
    local closed = {}
    while #open > 0 do
        local tt = open[1]
        deli(open, 1)
        --printh("looking at: "..tt[1]..","..tt[2], "test.txt")
        local tv = mget(tt[1], tt[2])
        if count(flood_blockers, tv) > 0 then
            -- nothing
        else
            add(tiles, tt)
            for n in all(get_neighbors(tt)) do
                if count(closed, hash(n)) == 0 then
                    --printh(n[1]..","..n[2].."--"..hash(n),"test.txt")
                    add(open, n)
                    add(closed, hash(n))
                else
                    
                end
            end
        end
    end
    return tiles
end

function _update()
    scenes[scene].update()
end

title_anim = 0
function update_title()
    title_anim += 1
    if btnp(0) then
        selected_cat_index = (selected_cat_index - 2) % #cats + 1
        title_anim = 0
    end
    if btnp(1) then
        selected_cat_index = selected_cat_index % #cats + 1
        title_anim = 0
    end
    if btnp(5) then
        scene = "name"
    end
end

keyboard_cursor = {1,1}
cat_name = ""
ntf = 0
function update_name()
    if btnp(0) then keyboard_cursor[1] -= 1 end
    if btnp(1) then keyboard_cursor[1] += 1 end    
    if btnp(2) then keyboard_cursor[2] -= 1 end
    if btnp(3) then keyboard_cursor[2] += 1 end
    keyboard_cursor[2] = mid(keyboard_cursor[2], 1, 4)
    keyboard_cursor[1] = mid(keyboard_cursor[1], 1, #keyboard[keyboard_cursor[2]])
    if btnp(5) then
        if keyboard_cursor[2] == 4 then
            make_player()
            scene = "game"
        else
            cat_name ..= sub(keyboard[keyboard_cursor[2]],keyboard_cursor[1], ".")
        end
    end
    title_anim += 1
    ntf += 1
end

function update_game()
    debugs = {}
    tf += 1
    time = (tf / 60) % 24
    if btn(4) then
        tf += 10
    end
    --time = 7
    --ray = vnorm({sin(tf / 100), cos(tf / 100)})
    ray = {sin((time + 12) / 48) * 0.2 - 0.01, sin((time + 12) / 48) }
    sun_angle = 80--abs(sin(tf / 300) * 80)
    states[pl.state].update()
    pl.xv *= pl.decel
    pl.yv *= pl.decel
    local vel = {pl.xv, pl.yv}
    if vdsq(vel) > pl.max_speed * pl.max_speed then
        vel = vnorm(vel)
        pl.xv = vel[1]* pl.max_speed
        pl.yv = vel[2]* pl.max_speed
    end
    move()
end

function _draw()
    scenes[scene].draw()
end

function draw_selected_cat(x,y)
    local cat = cats[selected_cat_index]
    local spri = cat.frames[(title_anim \ cat.anim_rate) % #cat.frames + 1]
    palt(12)
    pal(cat.palette)
    spr(spri, x, y)
    pal()
end

function draw_title()
    cls(7)
    palt(12)
    
    print("⬅️", 34, 60, 0)    
    print("➡️", 88, 60, 0)    

    local cat = cats[selected_cat_index]
    local spri = cat.frames[(title_anim \ cat.anim_rate) % #cat.frames + 1]

    local y = 80
    for row in all(split(cat.personality, "\n")) do
        print(row, 64 - #row * 2, y, 0)
        y += 8
    end

    draw_selected_cat(60, 58)

    print("x to choose", 42, 110, 0)    
end

keyboard = split("qwertyuiop,asdfghjkl,zxcvbnm , ")
function draw_name()
    cls(7)
    if ntf > 30 then
        local x, y = 14, 50
        for row = 1,3 do
            for i = 1, #keyboard[row] do
                if keyboard_cursor[1] == i and keyboard_cursor[2] == row then
                    rectfill(x, y, x + 8, y + 8, 11)
                end
                rect(x, y, x + 8, y + 8, 0)
                print(sub(keyboard[row], i, "."), x + 3, y + 2)
                x += 10
            end
            y += 10
            x = 14 + row * 1
        end
        if keyboard_cursor[2] == 4 then
            rectfill(53, 80, 74, 88, 11)
        end
        print("done", 56, 82, 0)
        rect(53, 80, 74, 88,0)
        local name = "name: ".. cat_name
        print(name, 64 - #name * 2, 38, 0)
        if title_anim \ 8 % 2 == 0 then
            print("_", 64 + #name * 2, 38)
        end
    end
    local cy = 41 + cos(min(ntf / 50, 0.5)) * 17
    draw_selected_cat(60, cy)
end

function draw_game()
    
    local shadow_color = 13
    if time < 3 or time > 21 then
        cls(1)
        shadow_color = 1
    --elseif time < 6 or time > 18 then
    --    rectfill(0,0,128,128,13)
    --    shadow_color = 1
    else
        cls(15)
        shadow_color = 13
    end

    -- Draw shadows
    local sa = sun_angle / 360
    local shadow_length = min(abs(sin(sa) / cos(sa)), 8) * 5

    local mrx, mry = ray[1] * shadow_length, ray[2] * shadow_length
    for t in all(ceiling_tiles) do
        rectfill(t[1] + mrx, t[2] + mry, t[3] + mrx, t[4] + mry, shadow_color)
    end

    local ox, oy, rx, ry = 0.5,0.5,ray[1],ray[2]
    for i = 1, flr(shadow_length) do
        local t = i / shadow_length
        ox += rx
        oy += ry
        local layers = 0x01
        if t < 0.25 or t > 0.8 then layers |= 0x02 end
        if t < 0.4 then layers |= 0x04 end
        local p = {}
        for c = 0, 15 do
            if t * 12 < c then
                p[c] = shadow_color
            else
                p[c] = 0
                palt(c, true)
            end
        end
        pal(p)
        map(0, 0, flr(ox), flr(oy), 16,16, layers)
    end
    local spt = {}
    for i = 0,15 do spt[i] = shadow_color end
    pal(spt)
    palt()
    --map(0, 16, flr(ox), flr(oy), 16,16)
    pal()
    
    pl.in_sun = pget(pl.x, pl.y - 3) == 15
    --[[
    if cat_in_sun then
        local rad = 6 + sin(tf / 20) - 1
        circfill(pl.x, pl.y - 3, rad + 1, 7)
        for i = 0, 5 do
            local theta = i / 6 + tf / 200
            circfill(pl.x + sin(theta) * rad, pl.y - 3 + cos(theta) * rad, 2, 7)
        end
    end
    ]]

    -- Draw cat shadow
    palt(12)
    pal(spt)
    function draw_player(ox, oy)
        spr(pl.draw_state.spri + pl.draw_state.frame, pl.x - 4 + ox, pl.y - 7 + oy, 1, 1, pl.draw_state.flip)
    end
    draw_player(rx * shadow_length / 20, ry * shadow_length / 20)
    draw_player(rx * shadow_length / 10, ry * shadow_length / 10)

    pal()
    if pl.z > 0 then
        --pal(split("0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"))
        --draw_player(0,0)
        local w = 3 / (pl.z / 5 + 1)
        
        ovalfill(pl.x - w, pl.y - w * 0.75, pl.x + w, pl.y + w * 0.75, 1)
    end


    -- Draw bottom map layer 
    palt()
    for i = 0, 16 do
        map(16,16 + i,0,i * 8,16,1)

    end

    -- Draw top map layer
    palt()
    pal()
    local layer_y = pl.y - 4
    for i = 0, 16 do
        if layer_y > i * 8 and layer_y <= (i + 1) * 8 then
            palt(12)
            pal(pl.palette)
            draw_player(0,-pl.z)
            palt()
        end    
        map(0,16 + i,0,i * 8,16,1)
    end

    if action_message != "" then
        local color = 14
        action_message_time += 1
        local x = 64 - #action_message * 2
        for i = 1, #action_message do
            local t = mid(action_message_time / 10 - i / #action_message * 2, 0, 1)
            local t2 = action_message_time / 65 + i / 6
            print(sub(action_message,i,""), x, 124 + cos(t * 0.65) * 5 + sin(t2) * 0.5 + 1, 7)
            print(sub(action_message,i,""), x, 124 + cos(t * 0.65) * 5 + sin(t2) * 0.5, color)
            x += 4
        end
    end

    draw_clock(117,11)

    if pl.meter > -1 then
        rectfill(1, 1, 2, 126, 5)
        local t = 125 * pl.meter / 100
        rectfill(1, 126, 2, 126 - t, 14)
    end

    local time_msg = "midnight"
    local color = 7
    if flr(time) > 0 and flr(time) < 12 then
        time_msg = flr(time) .. " am"
    elseif flr(time) == 12 then time_msg = "noon" 
    elseif flr(time) > 12 and flr(time) < 24 then
        time_msg = flr(time - 12) .. " pm"
    end
    if flr(time) > 2 and flr(time) < 21 then color = 0 end
    print(time_msg, 105 - #time_msg * 4, 10, color)

    fade_val = max(4 - tf \ 5, 0)
    fade_pal = {}
    for i = 0, 15 do
        local col = i
        for i = 1, fade_val do
            col = darken[col]
        end
        fade_pal[i] = col
    end
    pal(fade_pal, 1)

    local n = 0
    for msg in all(debugs) do
        print(msg, 0, n, 7)
        n += 6
    end
    
end

function draw_clock(x,y)
    local rad1 = 9
    local rad2 = 6
    local rad3 = 8
    circfill(x,y,rad1, 7)
    circ(x,y,rad1, 5)

    local start_time = time \ 12 * 12
    for span in all(pl.zoomy_times) do
        local t1 = span[1]
        local t2 = span[2]    
        
        if t1 < 12 and t2 > 12 then
            if start_time == 0 then t2 = 11.9 end
            if start_time == 12 then t1 = 12 end
        end
        if (start_time == 0 and t2 <= 12) or (start_time == 12 and t1 >= 12) then
            t1 = (t1 % 12) / 12
            t2 = (t2 % 12) / 12
            local t = t1
            while t < t2 do
                circfill(x + sin(t + 0.5) * 6 + 0.5, y + cos(t + 0.5) * 6 + 0.5, 1, 12)
                t += 0.025
            end
        end
    end

    for i = 0, 3 do
        theta = i / 4
        line(x + sin(theta) * 8 + 0.5, y + cos(theta) * 8 + 0.5, x + sin(theta) * 9 + 0.5, y + cos(theta) * 9 + 0.5, 5)
    end
    local mt = time % 1 - 0.5
    line(x,y,sin(mt) * rad3 + x, cos(mt) * rad3 + y, 6)
    local ht = (time / 12) % 1 - 0.5
    line(x,y,sin(ht) * rad2 + x, cos(ht) * rad2 + y, 8)
end

scene = "title"
scenes = {
    title={update=update_title, draw=draw_title},
    name={update=update_name, draw=draw_name},
    game={update=update_game, draw=draw_game}
}

__gfx__
00000000cccccccccccc24c4cccc24c4cccc24c4cccc24c4cccc24c4cccc24c4cccc24c4cccc24c4cccc24c4cccccccccccccccccccccccccccc24c400000000
00000000cccccccccccc4444cccc4444cccc4444cccc4444cccc4444cccc4444cccc4444cccc4444cccc4444cccc24c4cccc24c4cccc24c4cccc444400000000
00000000cccc24c4cccc4a4acccc4a4acccc4a4acccc4a4acccc4a4acccc4a4acccc4a4acccc4a4acccc4a4acccc4444cccc4444cccc4444cccc4a4a00000000
00000000cccc44444ccc44444ccc44444ccc44444ccc44444ccc44444ccc44444ccc44444ccc44444ccc44444ccc4a4a4ccc4a4a4ccc4a4a4ccc444400000000
000000004c444a4a4444422c4444422c4444422c4444422c4444422c4444422c4444422c4444422c4444422c4444444444444444444444444444422c00000000
0000000044424444c44444ccc44444ccc44444ccc44424ccc44424ccc44444ccc44444ccc44444ccc44444ccc444422cc444422cc444422cc444444c00000000
00000000c444222c442c2c4c642c24ccc644c45cc2c64c2c54cc42ccc45cc24c442cc24c44cc2c4cc442c4cccc424ccccc424ccccc4ccc6cc44ccc5600000000
00000000c444646c6c5c5cc6cc55cc6cc5ccc6cc5ccc6cc5c6c6cc5cc6ccc6cc65cccc5665ccc5c6c6c5cc6ccc56c6cccc566ccccc52ccccc52ccccc00000000
00000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc44c4cccc44c4cccc44c4cccccccccccccccccccccccccccc4c44cc00000000
00000000cccccccccc44c4cccc44c4cccc44c4cccc4c44cccc4c44cccc4c44cccc4444cccc4444cccc4444cccc4cc4cccc4c44cccc4c44cccc4444cc00000000
00000000cccc24c4cc4444cccc4444cccc4444cccc4444cccc4444cccc4444cccc4444cccc4444cccc4444cccc4444cccc4444cccc4444cccc4444cc00000000
00000000cccc4444cc4444cccc4444cccc4444cccc4444cccc4444cccc4444cccc4224cccc4224cccc4224cccc4444cccc4444cccc4444cccc4224cc00000000
000000004c444222cc4224cccc4224cccc4224cccc4224cccc4224cccc4224cccc4444cccc4444cccc4444cccc4224cccc4224cccc4224cccc4444cc00000000
0000000044424424cc4444cccc4444cccc4444cccc4444cccc4444cccc4444cccc4444cccc4444cccc4444cccc4444cccc4444cccc4444cccc4444cc00000000
00000000c444222ccc4444cccc4444cccc4444cccc4444cccc4444cccc4444cccc4cc4cccc4cc4cccc4cc4cccc4444cccc4444cccc4444cccc4cc4cc00000000
00000000c444646ccc6cc5cccc6ccccccc6cc6cccc5cc6ccccccc6cccc6cc6cccc6cc6cccc6cc6cccc5cc5cccc5cc5cccc5cc5cccc5cc5cccc6cc6cc00000000
00000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc44c4cccc44c4cccc44c4cccccccccccccccccccccccccccc4c44cc00000000
00000000cccccccccc24c4cccc24c4cccc24c4cccc4c42cccc4c42cccc4c42cccc4444cccc4444cccc4444cccc4cc4cccc4c44cccc4c44cccc4444cc00000000
00000000cccccccccc4444cccc4444cccc4444cccc4444cccc4444cccc4444cccca4a4cccca4a4cccca4a4cccc4444cccc4444cccc4444cccca4a4cc00000000
00000000cccc24c4cc4a4acccc4a4acccc4a4acccca4a4cccca4a4cccca4a4cccc4442cccc4442cccc4442cccc4a4acccc4a4acccc4a4acccc4442cc00000000
000000004c444444cc2444cccc2444cccc2444cccc4442cccc4442cccc4442cccc2224cccc2224cccc2224cccc2444cccc2444cccc2444cccc2224cc00000000
0000000044424222cc4222cccc4222cccc4222cccc2224cccc2224cccc2224cccc4444cccc4444cccc4444cccc4222cccc4222cccc4222cccc4444cc00000000
00000000c442442ccc4444cccc4444cccc4444cccc4444cccc4444cccc4444cccc4cc4cccc4cc4cccc2cc2cccc2222cccc2222cccc2222cccc6446cc00000000
00000000c444626ccc6cc5cccc6ccccccc6cc6cccc5cc6ccccccc6cccc6cc6cccc6cc6cccc6cc6cccc5cc5cccc5cc5cccc5cc5cccc5cc5cccccccccc00000000
00000000000000000000000000000000cc24c4cccc24c4cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc000000000000000000000000
00000000000000000000000000000000cc4444cccc4444cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc000000000000000000000000
00000000000000000000000000000000cc4a4a4ccc4a4a4ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc000000000000000000000000
000000000000000000000000000000004c4422cc4c44445ccccc24c4cccc24c4cccc24c4ccccc4ccccccc4ccccc6c4ccccccc4cc000000000000000000000000
000000000000000000000000000000004442442544422ccc4ccc4444c4cc44444ccc4444cccc4a44ccc64a44ccc42a44cc6c4a44000000000000000000000000
00000000000000000000000000000000c4444c6cc44444cc44424a4a44424a4a44424a4a6c62444c6cc4244c6cc4244c6cc4244c000000000000000000000000
00000000000000000000000000000000c444ccccc444cc6c44224444244244444442444444424a4444442a4444442a4444442a44000000000000000000000000
00000000000000000000000000000000c52cccccc52ccccc62262226624622266446222664462444644624446446244464462444000000000000000000000000
00000000000ff0000000000000000000000ff000000ff00000000000000ee0000000000000000000000000000000000000000000000dd000000dd00000000000
00000000000ff0000000000000000000000ff000000ff00000000000000ee0000f0000f000066000000000000000000000000000000dd000000ddd0000000000
00000000000ff0000000000000000000000ff000000ff00000000000000ee0000ffffff000666600000000000000000000000000000dd0000000ddd000000000
ffffffff000ff000fffff000000ffffffffff000000fffffeeeeeeee000ee0000ffffff0066ff660edddddddddddddddddddddde000dd00000000ddd00000000
ffffffff000ff000fffff000000ffffffffff000000fffffeeeeeeee000ee0000ffffff0066ff660edddddddddddddddddddddde000dd000000000dd00000000
00000000000ff000000ff000000ff000000000000000000000000000000ee0000ffffff000666600000000000000000000000000000dd0000000000d00000000
00000000000ff000000ff000000ff000000000000000000000000000000ee0000ffffff000066000000000000000000000000000000dd0000000000000000000
00000000000ff000000ff000000ff000000000000000000000000000000ee0000000000000000000000000000000000000000000000dd0000000000000000000
00000000000770000000000000000000000770000007700000000000000770000000000000000000000000000000000000000000000770000009900000000000
00000000000770000000000000000000000770000007700000000000000770000000000000000000000000000000000000000000006776000009970000000000
0000000000077000000000000000000000077000000770000000000000077000000000000003c000000000000000000000000000006776000004777000000000
77777777000770007777700000077777777770000007777777777777000770000000000000cc3c00777777777777777777777777006776000004677700000000
777777770007700077777000000777777777700000077777777777770007700000000000000c3000777777777777777777777777006776000004667700000000
6666666600077000666770000007766666666000000666666666666600077000000000000003c000666666666666666666666666006776000004666600000000
666666660007700066677000000776666666600000066666777777770067760007000070000c3000706000000006000000000007006776000004666600000000
666666660007700066677000000776666666600000066666700000070067760007666670007c3700707000000006000000000007006776000004667600000000
666666660006600066666000000666666666600000066666700070070066660007666670077c3770707007000006000000070007006666000004667600000000
6666666600066000666660000006666666666000000666667007000700666600077777700773377070707000000600000070000700666600000466660a0000a0
66666666000660006666600000066666666660000006666676666667006666000666666006777760707000000006000000000007006666000000666600a00a00
666666660006600066666000000666666666600000066666777777770006600006666660066776607070000000060000000000070066660000000666000a0000
6666666600066000666660000006666666666000000666666666666600066000066666600666666066766666666666666666666600066000000000660000a000
00000000000660000006600000066000000000000000000000000000000660000000000000666600000000000000000000000000000660000000000000a00a00
0000000000066000000660000006600000000000000000000000000000066000000000000006600000000000000000000000000000066000000000000a0000a0
00000000000660000006600000066000000000000000000000000000000660000000000000000000000000000000000000000000000660000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0c00c0
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0cc0c0
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0c0cc0
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0c00c0
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010102020401080808080100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080100000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000434046404200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000434046440000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000410000000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000470048000000004540464042000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000410000000000000000000047000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000047000000000000007f004344000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000410000000049000000004100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000045404040404a4c4042004700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000041004540420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000004344000000410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000041000000004e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000004546404046440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
