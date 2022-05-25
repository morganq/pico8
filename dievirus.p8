pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
-- dievirus
-- by morganquirk

shield_time = 30 * 15
max_hp = 4
local monster_palettes = {
    split("1,2,5,4,5,6,7,9,10,7,11,12,13,14,15"),
    split("1,2,5,4,5,6,7,4,6,7,11,12,13,14,15")
}

imgs_base = {sword=64, gun=66, bomb=68, none=70, shield=72, turret=74, wave=76, spear=78}
bases = split("sword,gun,bomb,shield,turret,wave,spear")
animals = split("tiger,elephant,bat,frog,bee,snail,rabbit,snake,ox,monkey,fox,penguin,leaf,monster")
spranimals = {}
for k,v in pairs(animals) do
    spranimals[v] = k + 95
end
enabled_animals = split("elephant,rabbit,fox")

function parse_descriptions(s)
    local descs = {}
    for line in all(split(s,"\n")) do
        local parts = split(line,":")
        descs[parts[1]] = parts[2]
    end
    return descs
end
local descriptions = parse_descriptions([[
sword:slice ahead, claim 1 tile
spear:stab forward
gun:instant hit at range
bomb:throw explosive
shield:gain shield
turret:build turret
wave:cast damaging wave
sword/leaf:gain +1 pip on use
spear/leaf:gain +1 pip on use
gun/leaf:gain +1 pip on use
bomb/leaf:gain +1 pip on use
shield/leaf:gain +1 pip on use
turret/leaf:gain +1 pip on use
wave/leaf:gain +1 pip on use
sword/elephant:drop tiles
spear/elephant:drop tiles
gun/elephant:stun enemy
bomb/elephant:drop tiles
shield/elephant:+2 shield, drop tile below
turret/elephant:+2 turret health, stun self
wave/elephant:drop tiles
sword/rabbit:v shape
spear/rabbit:sideways, +1 damage
gun/rabbit:quick roll
bomb/rabbit:x shape
shield/rabbit:quick roll
turret/rabbit:jumps every shot
wave/rabbit:diagonal, +1 damage
sword/fox:burn tiles
spear/fox:burn tiles
gun/fox:burn tile
bomb/fox:burn tiles
shield/fox:burn tile ahead
turret/fox:random fires
wave/fox:fast wave
]])

function count_animal(a, name)
    local num = 0
    if a.animal1 == name then num += 1 end
    if a.animal2 == name then num += 1 end
    return num
end

function tp(gx,gy)
    return {gx * 16 - 16, gy * 13 + 4}
end

function gp(x, y)
    return {clamp(x \ 16 + 1,1,8), clamp((y - 12) \ 13 + 1,1,4)}
end

function clamp(a,b,c)
    return min(max(a,b),c)
end

local nongrid = {}
function make_nongrid(x,y)
    local ng = {
        pos = {x,y},
        draw = function() end,
        update = function() end,
    }
    add(nongrid, ng)
    return ng
end

function make_effect_simple(x, y, num, spri)
    local ng = make_nongrid(x,y)
    ng.time = 0
    ng.draw = function()
        if spri != nil then
            spr(spri, x, y - ng.time \ 5)
        else
            print("-"..num, x, y - ng.time \ 5, 7)
        end
    end
    ng.update = function()
        ng.time += 1
        if ng.time > 30 then del(nongrid, ng) end
    end
    return ng
end

function make_effect_laser(x1, y1, x2, y2, side)
    local ng = make_nongrid(x1,y1)
    ng.time = 0
    ng.draw = function()
        local color = 8
        if side != 'red' then color = 12 end
        
        rectfill(x1,y1 -1 ,x2,y2 + 1, color)
        line(x1,y1,x2,y2,7)
    end
    ng.update = function()
        ng.time += 1
        if ng.time > 10 then del(nongrid, ng) end
    end
    return ng
end

function make_creature_particle(x, y, color, xv, floor)
    local ng = make_nongrid(x,y)
    local freezetime = -50 + rnd(2)
    addfields(ng, {
        color = color,
        yv = -1 + (0.5 - rnd()) * 0.8,
        xv = xv + (0.5 - rnd()) * 0.25,
        time = -rnd(100),
    })
    ng.draw = function()
        pset(ng.pos[1], ng.pos[2], ng.color)
        if freezetime > 8 and rnd() < 0.125 then
            line(ng.pos[1], 0, ng.pos[1], ng.pos[2], ng.color)
        end        
    end
    ng.update = function()
        freezetime += 1
        if freezetime >= 0 then ng.color = 7 end
        if freezetime >= 3 and rnd() < 0.25 then ng.color = 11 end
        ng.time += 1
        
        if freezetime < 0 then
            ng.yv += 0.1
            if ng.pos[2] > floor then
                ng.yv = ng.yv * -.5
                if ng.yv > -0.1 then
                    ng.yv = 0
                    ng.xv = ng.xv * 0.9
                    ng.y = floor
                end
            end
            ng.pos = {ng.pos[1] + ng.xv, ng.pos[2] + ng.yv}
        end
        if freezetime > 12 then
            del(nongrid, ng)
        end
    end
    return ng
end

function make_effect_ghost(x, y, spri, sprw, sprh)
    local ng = make_nongrid(x,y)
    ng.time = 0
    ng.draw = function()
        fillp(0b0101010101010101.11)
        spr(spri, ng.pos[1], ng.pos[2], sprw, sprh)
        fillp()
    end
    ng.update = function()
        ng.time += 1
        ng.pos = {ng.pos[1], ng.pos[2] - ng.time}
        if ng.time > 3 then del(nongrid, ng) end
    end
    return ng
end

function make_effect_fire(x, y)
    local ng = make_nongrid(x,y)
    ng.time = rnd() * 10
    ng.draw = function()
        pal({[9]=(8 + ng.time \ 20)})
        spr(116 + (ng.time \ 5) % 5, x, y)
        pal()
    end
    ng.update = function()
        ng.time += 1
        y -= 0.1
        if ng.time > 50 then
            del(nongrid, ng)
        end
    end
end

function make_bullet(x, y, side, speed, abil, spri, sprw, sprh)
    local ng = make_nongrid(x,y)
    ng.last_x = gp(x,y)[1]
    ng.side = side
    local dir = 1
    if ng.side != 'red' then dir = -1 end
    ng.yv = count_animal(abil, "rabbit")
    if rnd() < 0.5 then ng.yv = -ng.yv end
    ng.draw = function()
        spr(spri, ng.pos[1], ng.pos[2], sprw or 1, sprh or 1)
    end
    ng.update = function()        
        gpp = gp(ng.pos[1] + 4 + 8 * speed * dir, ng.pos[2] + 8 * speed * ng.yv * 1)
        if gpp[1] != ng.last_x then
            ng.last_x = gpp[1]
            make_damage_spot(gpp[1], gpp[2], abil.pips + flr(ng.yv), ng.side, 10, {hit_drop=count_animal(abil, "elephant") * 300})
            --if count_animal(abil, "elephant") > 0 and grid[gpp[2]][gpp[1]].space.side != ng.side then 
            --    grid[gpp[2]][gpp[1]].space.drop(30 * 10)
            --end
        end

        ng.pos = {ng.pos[1] + dir * speed, ng.pos[2] + ng.yv * speed * 13/16}
        if ng.pos[1] < 0 or ng.pos[1] > 128 then
            del(nongrid, ng)
        end
        if ng.pos[2] > 58 then
            ng.yv = -abs(ng.yv)
        elseif ng.pos[2] < 12 then
            ng.yv = abs(ng.yv)
        end        
    end
    return ng
end

function make_bomb(x1, x2, y1, y2, side, abil, total_time)
    local ng = make_nongrid(x1,y1)
    ng.side = side
    ng.time = 0
    ng.total_time = total_time or 60
    ng.draw = function()
        if ng.side == 'red' then
            spr(131, ng.pos[1] - 4, ng.pos[2] - 4)
        else
            spr(130, ng.pos[1] - 4, ng.pos[2] - 4)
        end
        --circfill(ng.pos[1], ng.pos[2], 3, 6) --improve
    end
    ng.update = function()
        ng.time += 1
        local t = ng.time / ng.total_time
        ng.pos = {t * (x2 - x1) + x1 + 8, t * (y2 - y1) + y1 + ((t * 2 - 1) ^ 2) * 20 - 16}
        if ng.time > ng.total_time then
            del(nongrid, ng)
        end
    end
    return ng
end

function make_melee(x, y, user, dist, side, abil, onhit)
    local dir = 1
    if side != 'red' then dir = -1 end
    local np = gp(x + 8 + dir * 16, y)
    onhit(np[1],np[2])    
end

function addfields(tbl,add)
    for k,v in pairs(add) do
        tbl[k] = v
    end
end

function abil_sword(user, a, x, y, side)
    local pp = tp(x,y)
    local props = {hit_drop = count_animal(a, "elephant") * 600, hit_fire_enemy = count_animal(a, "fox") * 180}
    local onhit = function(gx,gy)
        local lim = 1 + count_animal(a, "rabbit")
        for gyy = max(gy-lim,1), min(gy+lim,4) do
            local gxx = gx
            if count_animal(a, "rabbit") > 0 then
                gxx += abs(gyy - gy)
            end
            make_damage_spot(gxx, gyy, a.pips, side, 0, props)
        end
    end
    if side == 'red' and x <= 7 then 
        grid[y][x+1].space.flip('red', 30 * 13)
    end
    if side == 'blue' and x >= 2 then 
        grid[y][x-1].space.flip('blue', 30 * 13)
    end    
    make_melee(pp[1], pp[2], user, 0 + 16 * count_animal(a, "tiger"), side, a, onhit)
end

function abil_spear(user, a, x, y, side)
    local pp = tp(x,y)
    local dir = 1
    if side != 'red' then dir = -1 end
    local props = {hit_drop = count_animal(a, "elephant") * 300, hit_fire_enemy = count_animal(a, "fox") * 180}
    local onhit = function(gx,gy)
        if count_animal(a, "rabbit") > 0 then
            for gyy = 1, 4 do
                if gyy != gy then
                    make_damage_spot(gx - dir, gyy, a.pips + 1, side, 0, props)
                end
            end        
        else
            for gxx = gx, clamp(gx + dir * (count_animal(a, "tiger") + 1),1,8), dir do
                make_damage_spot(gxx, gy, a.pips, side, 0, props)
            end
        end
    end    
    make_melee(pp[1], pp[2], user, 0, side, a, onhit)
end

function abil_gun(user, a, x, y, side)
    local dir = 1
    if side != 'red' then dir = -1 end
    
    local lstart = tp(x,y)
    local x2 = 0
    local damage = a.pips
    
    for i = x, 4.5 + 3.5 * dir, dir do
        x2 = i
        local creature = grid[y][i].creature
        if creature and creature.side != side then
            creature.stun_time = count_animal(a, "elephant") * 90 * creature.stun_co
            make_damage_spot(i, y, damage, side, 0, {hit_fire = count_animal(a, "fox") * 120})
            break
        end
    end
    local lend = tp(x2, y)
    make_effect_laser(lstart[1] + 8, lstart[2] + 3, lend[1] + 8, lend[2] + 3, side)
    if count_animal(a, "rabbit") > 0 then pl.die_speed = 3.0 end
end

function abil_wave(user, a, x, y, side)
    local pp = tp(x, y)
    make_bullet(pp[1], pp[2], side, 2 + count_animal(a, "fox") * 2, a, 128)
end

function abil_bomb(user, a, x, y, side)
    local time = 40
    local dist = 4
    local x2 = x
    local pp1 = tp(x, y)
    if side == 'red' then
        x2 = min(x + dist, 8)
    else
        x2 = max(x - dist, 1)
    end
    local props = {hit_drop=count_animal(a,"elephant") * 300, hit_fire=count_animal(a,"fox") * 90}
    if count_animal(a, "monster") > 0 then
        for y2 = 1, 4 do
            local pp2 = tp(x2, y2)
            make_bomb(pp1[1], pp2[1], pp1[2], pp2[2], side, a, y2 * 15 + 15)
            make_damage_spot(x2, y2, a.pips, side, y2 * 15 + 15, props)
        end
    elseif count_animal(a, "rabbit") > 0 then
        local pp2 = tp(x2, y)
        make_bomb(pp1[1], pp2[1], pp1[2], pp2[2], side, a, time)    
        for i = 1, 8 do
            for j = 1, 4 do
                local dx, dy = abs(x2 - i), abs(y - j)
                if dx == dy then
                    make_damage_spot(i, j, a.pips, side, time, props)
                end
            end
        end
    else
        local pp2 = tp(x2, y)
        make_bomb(pp1[1], pp2[1], pp1[2], pp2[2], side, a, time)
        for i = x2-1, x2+1 do
            if i >= 1 and i <= 8 then
                make_damage_spot(i, y, a.pips, side, time, props)
            end
        end
        if y > 1 then make_damage_spot(x2, y-1, a.pips, side, time, props) end
        if y < 4 then make_damage_spot(x2, y+1, a.pips, side, time, props) end
    end
    
end

function abil_shield(user, a, x, y, side)
    local shield = a.pips
    shield += count_animal(a, "elephant") * 2
    user.shield = max(user.shield, shield)
    if count_animal(a, "elephant") > 0 then
        grid[y][x].space.drop(600)
    end
    dir = 1
    if side != 'red' then dir = -1 end
    if count_animal(a, "fox") > 0 and x + dir > 0 and x + dir < 9 then
        grid[y][x + dir].space.fire_time = 300
    end    
    if count_animal(a, "rabbit") > 0 then
        pl.die_speed = 3.0
        make_effect_simple(28, 80, nil, 102)
    end
    user.shield_timer = shield_time
    local pp = tp(x,y)
    make_effect_simple(pp[1] + 4, pp[2] - 14, 0, 114)
end

function abil_turret(user, a, x, y, side)
    local dir = 1
    if side != 'red' then dir = -1 end
    local x1 = x
    if valid_move_target(x + dir, y, side) then
        x1 = x + dir
    elseif valid_move_target(x - dir, y, side) then
        x1 = x - dir  
    else
        return
    end
    local t = make_turret(x1, y, a, side)
    t.health += count_animal(a, "elephant") * 2
    user.stun_time = count_animal(a, "elephant") * 40
end

local fns_base = {sword=abil_sword, gun=abil_gun, bomb=abil_bomb, none=abil_none, shield=abil_shield, wave=abil_wave, turret=abil_turret, spear=abil_spear}

function valid_move_target(x,y,side)
    if x < 1 or x > 8 or y < 1 or y > 4 then return false end
    local spot = grid[y][x]
    return spot.space.side == side and not spot.space.dropped and not spot.creature
end

function add_go_to_grid(go)
    local newgrid = grid[go.pos[2]][go.pos[1]]
    -- Add the obj to the grid location. But add based on layer.
    if #newgrid == 0 then
        add(newgrid, go)
    else
        local i = 1
        while true do
            if i > #newgrid then
                add(newgrid, go)
                break 
            elseif go.layer <= newgrid[i].layer then
                add(newgrid, go, i)
                break
            end
            i += 1
        end
    end
end

function make_gridobj(x,y,layer,spri,sprw,sprh) 
    local go = {
        pos = {x,y},
        layer = layer or 10,
        spri = spri,
        sprw = sprw,
        sprh = sprh,
        draw = function() end,
        update = function() end,
    }
    add_go_to_grid(go)
    go.move = function(x,y)
        del(grid[go.pos[2]][go.pos[1]], go)
        go.pos = {x,y}
        add_go_to_grid(go)
    end
    if spri != nil then
        go.draw = function()
            local pp = tp(go.pos[1], go.pos[2])
            spr(go.spri, pp[1], pp[2], go.sprw, go.sprh)
        end
    end
    return go
end

function push_to_open_square(c)
    local gx, gy = c.pos[1], c.pos[2]
    local spot = grid[gy][gx]
    local dir = 1
    if c.side != 'red' then dir = -1 end
    local attempts = {
        {0,0}, {-dir,-1}, {-dir,1}, {dir,-1}, {dir,1}, {-dir, 0}, {dir, 0}, {0,-1}, {0,1}
    }
    for offset in all(attempts) do
        local tx, ty = gx + offset[1], gy + offset[2]
        if tx >= 1 and tx <= 8 and ty >= 1 and ty <= 4 then
            local new_spot = grid[ty][tx]
            if new_spot.space.side == c.side and new_spot.creature == nil and not new_spot.space.dropped then
                c.move(tx,ty)
                return
            end
        end
    end
end

creature_index = 1
function make_creature(x, y, side, health, spri, sprw, sprh)
    local go = make_gridobj(x, y, 10, spri, sprw, sprh)
    addfields(go, {
        movetime = 0,
        lastpos = {0,0},
        animate_time = 0,
        yo = -7,
        side = side,
        damage_time = 0,
        health = health,
        max_health = health,
        shield = 0,
        shield_timer = 0,
        stun_time = 0,
        stun_co = 1,
        alive=true,
        index=creature_index
    })
    creature_index += 1
    go.draw = function()
        local spri = go.spri
        if go.movetime > 0 then
            fillp(0b0101010101010101.11)
        end
        if go.damage_time > 0 then
            pal({7,7,7,7,7,7,7,7,7,7,7,7,7,7,7})
        end
        if go.animate_time > 0 then
            spri = go.spri + go.sprw
        end
        local pp = tp(go.pos[1], go.pos[2])
        spr(spri, pp[1] - 1, pp[2] + go.yo, go.sprw, go.sprh)
        fillp()
        pal()
        if go.stun_time > 0 then
            spr(144 + (tf \ 10) % 2, pp[1] + 3, pp[2] - 6)
            print(go.stun_time, 100, go.index * 5 + 64, 7 + go.index)
        end
    end

    local baseupdate = go.update
    go.update = function()
        local space = grid[go.pos[2]][go.pos[1]].space
        if space.dropped or space.side != go.side then
            push_to_open_square(go)
        end
        if space.fire_time > 0 and space.fire_time % 20 == 0 then
            go.take_damage(1)
        end
        go.damage_time -= 1
        go.movetime -= 1
        go.animate_time -= 1
        go.shield_timer -= 1
        if go.shield_timer <= 0 then
            go.shield = 0
        end
        go.stun_time -= 1
        baseupdate()
    end

    local basemove = go.move
    go.move = function(x,y)
        if not go.alive then return end
        local pp = tp(go.pos[1],go.pos[2])
        make_effect_ghost(pp[1], pp[2] + go.yo, go.spri, go.sprw, go.sprh)
        grid[go.pos[2]][go.pos[1]].creature = nil
        go.lastpos = {go.pos[1], go.pos[2]}
        go.movetime = 3
        basemove(x,y)
        grid[y][x].creature = go
    end

    go.take_damage = function(damage)
        if damage >= go.shield then
            local damage_after = damage - go.shield
            go.shield = 0
            go.shield_timer = 0
            go.health -= damage_after
        else
            go.shield -= damage
        end
        go.damage_time = 5
        local pp = tp(go.pos[1],go.pos[2])
        make_effect_simple(pp[1] + 10, pp[2] - 4, damage)
        if go.health <= 0 then
            go.kill()
        end
    end

    go.kill = function()
        go.alive = false
        local sx = go.spri % 16 * 8
        local sy = go.spri \ 16 * 8
        for x = 0, go.sprw * 8 - 1 do
            local xv = (x / (go.sprw * 8 - 1)) - 0.5
            for y = 0, go.sprh * 8 - 1 do 
                local c = sget(sx + x, sy + y)
                local pp = tp(go.pos[1], go.pos[2])
                if c > 0 then
                    make_creature_particle(pp[1] + x, pp[2] + y + go.yo, c, xv / 2, pp[2] + 6 + rnd(4))
                end
            end
        end
        grid[go.pos[2]][go.pos[1]].creature = nil
        del(grid[go.pos[2]][go.pos[1]], go)
    end

    grid[go.pos[2]][go.pos[1]].creature = go
    return go
end

-- supported special properties:
-- flies (can teleport when moving)
-- move_pattern (table of bools, move on index or not)
-- abil_pattern (table of bools, use abil on index or not)

function make_monster(spri, palette_index, x, y, abilities, health, speed, special_properties)
    local needs_push = false
    if grid[y][x].creature then needs_push = true end
    local c = make_creature(x,y,"blue", health, spri, 2, 2)
    c.palette = monster_palettes[palette_index]
    --printh(pal, "test.txt")
    c.abilities = abilities
    c.speed = speed
    c.time = 0
    c.next_ability = rnd(c.abilities)
    addfields(c, special_properties or {})
    if special_properties.move_pattern then
        c.move_pattern = {}
        for i = 1, #special_properties.move_pattern do
            add(c.move_pattern, sub(special_properties.move_pattern, i, 'x') == 'x')
        end
        c.move_pattern_i = 1
    end
    if special_properties.abil_pattern then
        c.abil_pattern = {}
        for i = 1, #special_properties.abil_pattern do
            add(c.abil_pattern, sub(special_properties.abil_pattern, i, 'x') == 'x')
        end    
        c.abil_pattern_i = 1
    end

    local baseupdate = c.update
    c.update = function()
        baseupdate()
        if c.stun_time > 0 then return end
        c.time += 1
        if c.time % c.speed == 0 then
            local will_move = true
            if c.move_pattern then
                if not c.move_pattern[c.move_pattern_i] then will_move = false end
                c.move_pattern_i = c.move_pattern_i % #c.move_pattern + 1
            end
            if will_move then -- Move pattern allows move
                local abiltx = {sword=0, gun=8, bomb=6}
                local tx = nil
                local ty = nil
                if rnd() < 0.4 then tx = abiltx[c.next_ability.base] end
                if c.favor_row and rnd() < 0.25 then ty = c.favor_row end
                if c.flies then
                    local rx = tx or flr(rnd(4)) + 5
                    local ry = ty or flr(rnd(4)) + 1            
                    if valid_move_target(rx, ry, c.side) then
                        c.move(rx, ry)
                    end
                else
                    local spots = {}
                    for i = -1,1 do for j = -1,1 do add(spots, {i,j}) end end
                    for i = 1,9 do
                        local spot = rnd(spots)
                        del(spots, spot)
                        local dx,dy = nil,nil
                        if tx then dx = clamp(tx - c.pos[1], -1, 1) end
                        if ty then dy = clamp(ty - c.pos[2], -1, 1) end
                        local rx = (dx or spot[1]) + c.pos[1]
                        local ry = (dy or spot[2]) + c.pos[2]
                        if valid_move_target(rx, ry, c.side) then
                            c.move(rx, ry)
                            break
                        end
                    end
                end
            end
        end
        if c.time % c.speed == (c.speed \ 2) then
            local will_abil = true
            if c.abil_pattern then
                if not c.abil_pattern[c.abil_pattern_i] then will_abil = false end
                c.abil_pattern_i = c.abil_pattern_i % #c.abil_pattern + 1
            end        
            if will_abil then
                c.next_ability.use(c, c.pos[1], c.pos[2], c.side)        
                c.animate_time = 5
                c.next_ability = rnd(c.abilities)
            end
        end
    end
    local basedraw = c.draw
    c.draw = function()
        if c.palette != nil then
            pal(c.palette)
            basedraw()
            pal()
        else
            basedraw()
        end
        local pp = tp(c.pos[1], c.pos[2])
        local hpx = pp[1] + 3
        local hpy = pp[2] + 10
        
        line(hpx, hpy, hpx + 9, hpy, 6)
        line(hpx, hpy, hpx + 9 * (c.health / c.max_health), hpy, 8)
    end
    if needs_push then
        push_to_open_square(c)
    end
    return c
end

function parse_monster(s)
    local parts = split(s, "|")
    local abils_s = split(parts[5],"/")
    local abilities = {}
    for abil_s in all(abils_s) do add(abilities, parse_ability(abil_s)) end
    local special_properties = {}
    for i = 8, #parts do
        local kv = split(parts[i],"=")
        special_properties[kv[1]] = kv[2]
    end
    return make_monster(parts[1], parts[2], parts[3], parts[4], abilities, parts[6], parts[7], special_properties)
end

function make_damage_spot(x,y,damage,side,warning,special_properties)
    local go = make_gridobj(x,y,1)
    addfields(go, {
        side=side,
        damage=damage,
        countdown_max = warning or 0,
        countdown = warning or 0,
        decay = 0,
    })
    addfields(go, special_properties or {})
    go.update = function()
        local spot = grid[go.pos[2]][go.pos[1]]
        if go.countdown > 0 then
            go.countdown -= 1
        elseif go.countdown == 0 then
            
            if spot.creature and spot.creature.side != go.side then
                spot.creature.take_damage(go.damage)
            end
            go.countdown -= 1             
            if go.hit_drop and go.hit_drop > 0 then
                spot.space.drop(go.hit_drop)
            end
            if go.hit_fire and go.hit_fire > 0 then
                spot.space.fire_time = go.hit_fire
            end           
            if go.hit_fire_enemy and go.side != spot.space.side and go.hit_fire_enemy > 0 then
                spot.space.fire_time = go.hit_fire_enemy
            end            
        else
            go.decay += 1
            if go.decay > 4 then
                del(spot, go)
            end
        end
    end
    go.draw = function()
        local pp = tp(go.pos[1], go.pos[2])
        local color = 7
        if go.side != 'red' then color = 10 end
        if go.countdown > 0 then
            local t = 1 - (go.countdown / go.countdown_max)
            local hw = 6 * t + 2
            local hh = 4 * t + 2
            local x1,y1,x2,y2 = pp[1] + 1, pp[2] + 1, pp[1] + 14, pp[2] + 11
            
            --[[if go.countdown < 5 then
                fillp(0b0101101001011010.1)
                rectfill(pp[1] + 1, pp[2] + 1, pp[1] + 14, pp[2] + 11, color)
                fillp()
            end]]
            line(x1, y1, x1 + hw, y1, color)
            line(x1, y1, x1, y1 + hh, color)
            line(x1, y2, x1 + hw, y2, color)
            line(x1, y2, x1, y2 - hh, color)
            line(x2, y1, x2 - hw, y1, color)
            line(x2, y1, x2, y1 + hh, color)
            line(x2, y2, x2 - hw, y2, color)
            line(x2, y2, x2, y2 - hh, color)            
        else
            rectfill(pp[1] + 1, pp[2] + 1, pp[1] + 14, pp[2] + 11, color)
        end
    end
end

function make_gridspace(x,y)
    local spri = 1
    local side = 'red'
    if x > 4 then
        spri = 3
        side = 'blue'
    end
    local go = make_gridobj(x,y,0,spri,2,2)
    go.side = side
    go.dropped = false
    go.drop_time = 0
    go.main_side = side
    go.flip_time = 0
    go.drop_finish_time = 0
    go.fire_time = 0
    local baseupdate = go.update
    go.update = function()
        if go.dropped then
            go.drop_time += 1
            if go.drop_time >= go.drop_finish_time then
                go.dropped = false
                go.drop_time = 0
            end
        end
        if go.flip_time > 0 then
            local dir = 1
            if go.main_side != 'red' then dir = -1 end
            local can_revert = false
            if go.pos[1] == 8 or go.side == 'red' and grid[go.pos[2]][go.pos[1] + 1].space.side == 'blue' then
                can_revert = true
            end
            if go.pos[1] == 1 or go.side == 'blue' and grid[go.pos[2]][go.pos[1] - 1].space.side == 'red' then
                can_revert = true
            end
            if can_revert then            
                go.flip_time -= 1
                if go.flip_time <= 0 then
                    go.side = go.main_side
                end
            end
        end
        if go.fire_time > 0 then
            go.fire_time -= 1
        end
    end
    local basedraw = go.draw
    go.draw = function()
        local pp = tp(go.pos[1], go.pos[2])
        local spri = 1
        if go.side == 'blue' then spri = 3 end
        spr(spri, pp[1], pp[2] + (go.drop_time / 2.5) ^ 2, go.sprw, go.sprh)
        if go.dropped and go.drop_time > go.drop_finish_time - 4 then
            pal({7,7,7,7,7,7,7,7,7,7,7,7,7,7,7})
            spr(go.spri, pp[1], pp[2], go.sprw, go.sprh)
            pal()
        end
        if go.fire_time > 0 and go.fire_time % 5 == 0 then
            make_effect_fire(pp[1] + rnd() * 12, pp[2] + rnd() * 8 - 2)
        end
    end
    go.drop = function(time)
        if go.dropped then return end
        go.drop_time = 0
        go.drop_finish_time = time
        go.dropped = true
    end
    grid[go.pos[2]][go.pos[1]].space = go
    go.flip = function(side, time)
        if side == go.side then return end
        if side == go.main_side then
            go.side = go.main_side
            go.flip_time = 0
            return
        end
        go.main_side = go.side
        go.side = side
        go.flip_time = time
    end
    return go
end

pl = nil

function make_ability(base, pips, animal1, animal2)
    local a = {
        base = base,
        pips = pips,
        animal1 = animal1,
        animal2 = animal2,
        num_growth = 0,
    }
    a.copy = function()
        return make_ability(a.base, a.pips, a.animal1, a.animal2)
    end
    a.draw_face = function(x,y)
        spr(imgs_base[a.base], x, y, 2, 2)
        rect(x, y, x + 15, y + 15, 12)
        if a.animal1 then
            pal(split("0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"))
            spr(spranimals[a.animal1], x + 1, y + 2)
            spr(spranimals[a.animal1], x + 3, y + 2)
            spr(spranimals[a.animal1], x + 2, y + 1)
            spr(spranimals[a.animal1], x + 2, y + 3)
            pal()
            spr(spranimals[a.animal1], x + 2, y + 2)
        end
        --if a.animal2 then
            --spr(spranimals[a.animal2], x + 2, y + 8)
        --end        
        
        local fives = a.pips \ 5
        local ones = a.pips - (fives * 5)
        local iy = 0
        for i = 1,fives do
            rectfill(x + 11, y + 13 - iy - 2, x + 13, y + 13 - iy, 10)
            iy += 4
        end
        for i = 1, ones do
            rectfill(x + 11, y + 13 - iy, x + 13, y + 13 - iy, 10)
            iy += 2
        end
    end    
    a.use = function(user, gx, gy, side)
        if a.base == "none" then return end
        fns_base[a.base](user, a, gx, gy, side)
        if a.num_growth < 3 and count_animal(a, "leaf") > 0 then
            a.pips += count_animal(a, "leaf")
            local pp = tp(gx,gy)
            make_effect_simple(pp[1] + 4, pp[2] - 14, nil, 108)
            a.num_growth += 1
        end
    end
    return a
end

function parse_ability(s)
    return make_ability(unpack(split(s)))
end

function make_player()
    local pl = make_creature(1,2, 'red', max_hp, 37, 2, 2)
    addfields(pl, {
        max_health = pl.health,
        die = {},
        die_speed = 1,
        current_ability = nil,
    })
    return pl
end

function make_turret(x, y, a, side)
    local spri = 33
    if side == 'blue' then spri = 136 end
    local t = make_creature(x, y, side, a.pips, spri, 2, 2)
    local baseupdate = t.update
    local abil = make_ability("wave", a.pips)
    t.rate = 80 - count_animal(a, "fox") * 25
    t.time = 0
    t.update = function()
        baseupdate()
        t.time += 1
        if t.time % t.rate == t.rate \ 2 then    
            if count_animal(a, "fox") > 0 then
                local rx = flr(rnd(4)) + 1
                if t.side == 'red' then rx += 4 end
                local ry = flr(rnd(4)) + 1
                grid[ry][rx].space.fire_time = 120
                t.animate_time = 5
            else
                abil.use(t, x, y, t.side)
            end
            if count_animal(a, "rabbit") > 0 then
                local rx = flr(rnd(4)) + 1
                if t.side == 'blue' then rx += 4 end
                local ry = flr(rnd(4)) + 1
                if valid_move_target(rx, ry, t.side) then
                    t.move(rx, ry)
                end
            end
        end
        if t.time >= 750 then
            t.kill()
        end
    end
    return t
end

function make_upgrade(faces, animal)
    local up = {
        faces = {},
        animal = animal
    }
    for i = 1,6 do up.faces[i] = sub(faces,i,"x") == 'x' end
    local positions = {
        {0,3},{3,3},{6,3},{9,3},{3,0},{3,6}
    }
    up.draw = function(x,y)
        --print(up.animal, x,y,6)
        if up.animal == "hp" then
            spr(122, x + 5, y)
            print("+1 hp", x-1, y + 9, 7)
        else
            for i = 1, 6 do
                local px, py = positions[i][1] + x, positions[i][2] + y + 6
                local color = 5
                if up.faces[i] then color = 11 end
                rectfill(px,py,px+1,py+1,color)
            end        
            if sub(up.animal,1,1) == "+" then
                print(up.animal, x + 8, y, 10)
            elseif count(bases, up.animal) > 0 then
                spr(imgs_base[up.animal], x + 6, y - 5,2,2)
            else
                spr(spranimals[up.animal], x+8, y)
            end        
        end
    end
    return up
end

-- front faces = 1,2,3,4, top left cw
-- back faces = 5,6,7,8, top left cw
die3d = {}

function mv4(m, v)
    return {
        m[1] * v[1] +    m[2] * v[2] +    m[3] * v[3] +    m[4] * v[4],
        m[5] * v[1] +    m[6] * v[2] +    m[7] * v[3] +    m[8] * v[4],
        m[9] * v[1] +    m[10] * v[2] +   m[11] * v[3] +   m[12] * v[4],
        m[13] * v[1] +   m[14] * v[2] +   m[15] * v[3] +   m[16] * v[4]
    }
end

function gen_die(die, a,b,c)
    local sina, cosa, sinb, cosb, sinc, cosc = sin(a), cos(a), sin(b), cos(b), sin(c), cos(c)
    m = {
        cosb * cosa, sinc * sinb * cosa - cosc * sina, cosc * sinb * cosa + sinc * sina, 0,
        cosb * sina, sinc * sinb * sina + cosc * cosa, cosc * sinb * sina - sinc * cosa, 0,
        -sinb, sinc * cosb, cosc * cosb, 0,
        0,0,0,1
    }
    die.pts[1] = mv4(m, {-1,-1,-1,1})
    die.pts[2] = mv4(m, {1,-1,-1,1})
    die.pts[3] = mv4(m, {1,1,-1,1})
    die.pts[4] = mv4(m, {-1,1,-1,1})
    die.pts[5] = mv4(m, {-1,-1,1,1})
    die.pts[6] = mv4(m, {1,-1,1,1})
    die.pts[7] = mv4(m, {1,1,1,1})
    die.pts[8] = mv4(m, {-1,1,1,1})
    for i = 1, #die.pts do
        die.pts[i] = {die.pts[i][1] * 10, die.pts[i][2] * 10, die.pts[i][3] * 0.5 + 2}
    end
end

function draw_die3d(die)
    local i = 0
    for face in all(die.faces) do
        color(12)
        local pts = die.pts
        local p1,p2,p3,p4 = pts[face[1]],pts[face[2]],pts[face[3]],pts[face[4]]
        if p1[3] < 2 or p2[3] < 2 or p3[3] < 2 or p4[3] < 2 then
            line(p1[1] / p1[3] + die.x, p1[2] / p1[3] + die.y, p2[1] / p2[3] + die.x, p2[2] / p2[3] + die.y)
            line(p3[1] / p3[3] + die.x, p3[2] / p3[3] + die.y)
            line(p4[1] / p4[3] + die.x, p4[2] / p4[3] + die.y)
            line(p1[1] / p1[3] + die.x, p1[2] / p1[3] + die.y)
        end
        i += 1
    end
end

function draw_die2d(die,x,y, die2, upgrade)
    local d1 = true
    if die2 and upgrade.animal != "hp" then
        d1 = (tf \ 14) % 2 == 0
    end
    if d1 then
        die[1].draw_face(x,y + 18)
        die[2].draw_face(x + 18,y + 18)
        die[3].draw_face(x + 36,y + 18)
        die[4].draw_face(x + 54,y + 18)
        die[5].draw_face(x + 18,y)
        die[6].draw_face(x + 18,y + 36)
    else
        die2[1].draw_face(x,y + 18)
        if upgrade.faces[1] then rect(x-1,y+17,x+16,y+34,7) end
        die2[2].draw_face(x + 18,y + 18)
        if upgrade.faces[2] then rect(x+17,y+17,x+34,y+34,7) end
        die2[3].draw_face(x + 36,y + 18)
        if upgrade.faces[3] then rect(x+35,y+17,x+52,y+34,7) end
        die2[4].draw_face(x + 54,y + 18)
        if upgrade.faces[4] then rect(x+53,y+17,x+70,y+34,7) end
        die2[5].draw_face(x + 18,y)
        if upgrade.faces[5] then rect(x+17,y-1,x+34,y+16,7) end
        die2[6].draw_face(x + 18,y + 36)        
        if upgrade.faces[6] then rect(x+17,y+35,x+34,y+52,7) end
    end
end

function _init()
    state = "title"
    cartdata("dievirus")
    menuitem(1, "clear wins", function()
        dset(0,0)
    end)
end

level = 0
function start_level()
    level += 1
    nongrid = {}
    grid = { }
    for i = 1,4 do
        grid[i] = {}
        for j = 1, 8 do
            grid[i][j] = {}
        end
    end    
    for j = 1,4 do
        for i = 1, 8 do
            make_gridspace(i,j)
        end
    end    
    victory = false
    defeat = false
    die3d = {
        pts = {},
        faces = {
            {1,2,3,4}, -- front
            {2,1,5,6}, -- top
            {3,4,8,7}, -- bottom
            {1,4,8,5}, -- left
            {2,3,7,6}, -- right
            {5,6,7,8} -- back
        },
        x = 10, 
        y = 84,
        xv = 0,
        yv = 0,
        visible = false,
    }
    gen_die(die3d, 0, 0, 0)
    pl = make_player()
    for i = 1,6 do
        pl.die[i] = abilities[i]
        --pl.die[i] = make_ability("turret", 1, "elephant")
    end

    local monsters = {
        mage1 = "164|0|6|1|wave,1|3|40|move_pattern=xx_|abil_pattern=__x",
        fighter1 = "41|0|6|1|sword,1|3|25|move_pattern=xx_|abil_pattern=__x",
        duelist1 = "168|0|6|1|wave,1,fox/sword,2|5|25|move_pattern=xxx_|abil_pattern=___x",
        engineer1 = "9|0|6|1|turret,2/gun,1|8|55|flies=1|abil_pattern=_x",
        boss1 = "132|0|6|1|bomb,2,monster/wave,1,elephant/shield,1/sword,3|20|15|flies=1|abil_pattern=____x_x_|move_pattern=xxxx____",
        bomber1 = "5|0|6|1|bomb,2|10|99",
        mage2 = "164|1|6|1|wave,2,rabbit|8|40|move_pattern=xx_|abil_pattern=__x",
        fighter2 = "41|1|6|1|sword,3,fox/spear,3,fox|10|30|abil_pattern=_x",
        boss2 = "132|1|6|1|gun,3,monster/turret,3,tiger/shield,3/wave,3,rabbit|30|20|flies=1|abil_pattern=______x_x_x_|move_pattern=xxxx___x_x_x",
        bomber2 = "5|2|6|1|bomb,2,fox|15|39|abil_pattern=_x_",
        engineer2 = "9|2|6|1|turret,4,rabbit/gun,2/shield,2|10|45|flies=1|abil_pattern=_x",
        duelist2 = "168|2|6|1|wave,3,elephant,rabbit/sword,4/spear,4/shield,2|14|21|move_pattern=xxx_|abil_pattern=___x",
        mage3 = "164|2|6|1|wave,4,rabbit/wave,4|15|40|move_pattern=xx_|abil_pattern=__x",
        boss3 = "168|2|6|1|wave,3,rabbit/wave,1,fox,leaf/shield,1,leaf/spear,1,tiger,leaf|40|21|move_pattern=xxx_|abil_pattern=___x",
    }
    function place_monster(name, x, y, favor_row)
        local mon = parse_monster(monsters[name])
        mon.move(x or flr(rnd(4)) + 5,y or flr(rnd(4)) + 1)
        mon.favor_row = favor_row
        return mon
    end  
    if level == 1 then
        place_monster("mage1", 6, 1, 2)
        place_monster("mage1", 6, 4, 3)
    elseif level == 2 then
        place_monster("mage1")
        place_monster("fighter1")
    elseif level == 3 then
        place_monster("duelist1")
        place_monster("duelist1")
    elseif level == 4 then
        place_monster("engineer1")
    elseif level == 5 then
        place_monster("boss1")
    elseif level == 6 then
        place_monster("mage2")
        place_monster("mage2").abil_pattern_i = 2
    elseif level == 7 then
        place_monster("fighter2")
        place_monster("fighter1")
        place_monster("fighter1")
    elseif level == 8 then
        place_monster("engineer1")
        place_monster("engineer1")
        place_monster("fighter1")
    elseif level == 9 then -- too easy
        place_monster("bomber1")
        place_monster("bomber1").time = 33
        place_monster("bomber1").time = 66
    elseif level == 10 then
        place_monster("boss2")
    elseif level == 11 then
        place_monster("bomber2")
        place_monster("engineer2")
    elseif level == 12 then
        place_monster("duelist2")
    elseif level == 13 then
        place_monster("mage1")
        local m2 = place_monster("mage2")
        m2.abil_pattern_i = 2
        m2.move_pattern_i = 2
        local m3 = place_monster("mage3")
        m3.abil_pattern_i = 3
        m3.move_pattern_i = 3        
    elseif level == 14 then
        place_monster("fighter2")
        local m2 = place_monster("fighter2")
        m2.abil_pattern_i = 2
        m2.move_pattern_i = 2    
        place_monster("boss2")
    elseif level == 15 then
        place_monster("boss3")
        place_monster("engineer1")
        place_monster("fighter1")
    end

    throw()
end

dra, drb, drc, dvra, dvrb, dvrc = 0,0,0,0,0,0

function throw()
    die3d.visible = true
    die3d.x = 20
    die3d.y = 84
    die3d.xv = 1.5
    die3d.yv = 0
    dvra = (0.5 - rnd())
    dvrb = (0.5 - rnd())
    dvrc = (0.5 - rnd())  
end


tf = 0
victory = false
victory_time = 0
defeat = false
defeat_time = 0

function draw_gameplay()
    cls()
    fillp(0b0)
    -- Sort by binning grid objs and non-grid objs by y grid space
    -- then draw them top to bottom. ez.
    local bins = {{},{},{},{}}
    for i = 1, #nongrid do
        local ng = nongrid[i]
        local gpp = gp(ng.pos[1],ng.pos[2])
        add(bins[gpp[2]],ng)
    end
    for i = 1,4 do
        for j = 1, 8 do
            local gridspace = grid[i][j]
            for k = 1, #gridspace do
                gridspace[k].draw()
            end
        end
        for o in all(bins[i]) do o.draw() end
    end
    if die3d.visible then
        draw_die3d(die3d)
    elseif pl.current_ability != nil then
        local abil = pl.die[pl.current_ability]
        abil.draw_face(die3d.x - 8, die3d.y - 8)

        local line1 = descriptions[abil.base]
        print(line1, 64 - #line1 * 2, 114, 11)
        if abil.animal1 != nil then
            local line2 = descriptions[abil.base .. "/" .. abil.animal1]
            print(line2, 64 - #line2 * 2, 122, 10)
        end
    end

    local hpx = 1
    for i = 1, pl.max_health do
        if i <= pl.health then
            spr(192, hpx, 0)
        else
            spr(193, hpx, 0)
        end
        hpx += 6
    end
    if pl.shield_timer > 0 then
        for i = 1, pl.shield do
            spr(194, hpx, 0)
            hpx += 6
        end
        local frame = flr((pl.shield_timer / shield_time) * 5) + 195
        spr(frame, hpx - 1, -2)
    end   

    if victory then
        local y = min(victory_time, 40)
        rectfill(34, y - 5, 94, y + 8, 0)
        rect(34, y - 5, 94, y + 9, 9)
        print("victory", 50, y, 10)
    end
    if defeat then
        local y = min(defeat_time, 40)
        rectfill(34, y - 5, 94, y + 8, 0)
        rect(34, y - 5, 94, y + 9, 2)
        print("defeat", 52, y, 8)
    end
end

function update_gameplay()
    if victory then
        victory_time += 1
        if victory_time > 90 then
            if level == 15 then
                dset(0, dget(0) + 1)
                state = "win"
            else
                state = "upgrade"
            end
        end
    end
    if defeat then
        defeat_time += 1
        if defeat_time > 120 then
            --
        end
    end

    if pl.health <= 0 and not defeat then 
        defeat = true
        defeat_time = 0
    end
    local living_monsters = 0

    local need_update = {}
    for i = 1, 8 do
        for j = 1, 4 do
            local gridspace = grid[j][i]
            if gridspace.creature and gridspace.creature.health > 0 and gridspace.creature.side != 'red' then
                living_monsters += 1
            end
            for o in all(gridspace) do
                add(need_update, o)
            end
        end
    end
    for o in all(need_update) do o.update() end

    for ng in all(nongrid) do
        ng.update()
    end

    if living_monsters == 0 and not victory then
        victory = true
        victory_time = 0
    end

    if pl.stun_time <= 0 and not victory and not defeat then
        local target = nil
        if btnp(0) and pl.pos[1] > 1 then
            target = {pl.pos[1] - 1, pl.pos[2]}
        end
        if btnp(1) and pl.pos[1] < 8 then
            target = {pl.pos[1] + 1, pl.pos[2]}
        end
        if btnp(2) and pl.pos[2] > 1 then
            target = {pl.pos[1], pl.pos[2] - 1}
        end        
        if btnp(3) and pl.pos[2] < 4 then
            target = {pl.pos[1], pl.pos[2] + 1}
        end        
        if target then
            if valid_move_target(target[1], target[2], pl.side) then
                pl.move(target[1], target[2])
            end
        end
        if btnp(5) and pl.current_ability != nil then
            pl.die[pl.current_ability].use(pl, pl.pos[1], pl.pos[2], 'red')
            pl.current_ability = nil
            pl.animate_time = 5
            throw()
        end
        --[[if btnp(4) then
            victory = true
            victory_time = 0
        end]]
    end
    tf += 1
    if die3d.visible then
        die3d.yv += 0.1 * pl.die_speed
        if die3d.y > 100 then
            die3d.yv = die3d.yv * -0.5
            die3d.y = 100
            dvra = (0.5 - rnd()) * die3d.yv * die3d.xv
            dvrb = (0.5 - rnd()) * die3d.yv * die3d.xv
            dvrc = (0.5 - rnd()) * die3d.yv * die3d.xv
            if die3d.xv < 0.4 + pl.die_speed * 0.1 then
                pl.die_speed = 1
                die3d.visible = false
                die3d.xv = 0
                die3d.yv = 0
                pl.current_ability = flr(rnd(6)) + 1
            end
        end
        die3d.xv *= 0.975
        die3d.x += die3d.xv
        die3d.y += die3d.yv
        dra += dvra / 10
        drb += dvrb / 10
        drc += dvrc / 10
        gen_die(die3d, dra,drb,drc)
    end
end

titlef = 0
function update_title()
    titlef += 1
    if btnp(5) then
        state = "newgame"
    end
end


function draw_title()
    cls()
    --[[for i = 1, 45 do
        local x1 = rnd() * 128
        line(x1, 0, x1, 128, 0)
    end
    ]]
    --[[
    for i = 0, 10 do
        for j = -1, 10 do
            local x1 = (i * 20) + (((titlef % 100) * (sin(j / 2.3 + titlef + 0.25) * 2.5) + j * 4) / 5) % 20 - 20
            local y1 = j * 16
            local color = 1
            local val = sin((x1 - 24) / 128)
            if val > 0.75 then
                color = 8
            elseif val > 0.4 then
                color = 2
            end
            rect(x1, y1, x1 + 16, y1 + 13, color)
        end
    end
    ]]--
    print("die virus", 46, 32, 7)
    spr(13, 55 + rnd() * sin(titlef / 100) * 2, 56 + rnd() * sin(titlef / 100) * 2, 2, 2)
    print("❎ to start", 42, 88)
end

abilities = {}
function parse_class(name, wins, s)
    local class = {
        name=name,
        wins_needed=wins,
        abilities = {},
    }
    for abil_s in all(split(s,"/")) do
        add(class.abilities, parse_ability(abil_s))
    end
    return class
end
classes = {
    parse_class("commander", 0, "gun,1/gun,1/sword,2/shield,1/bomb,1/bomb,1"),
    parse_class("vanguard", 0, "sword,1/sword,2/spear,2/spear,1/shield,2/bomb,1"),
    parse_class("wizard", 0, "wave,1/wave,2/wave,1/sword,1/bomb,2/shield,1"),
    parse_class("engineer", 0, "turret,1/turret,2/bomb,2/bomb,1/gun,1/shield,1"),
    parse_class("druid", 3, "gun,1/sword,1,leaf/shield,1/none,1/shield,1,leaf/bomb,1,leaf"),
}
selected_class_index = 1
function update_newgame()
    if btnp(0) then
        selected_class_index = (selected_class_index - 2) % #classes + 1
    end
    if btnp(1) then
        selected_class_index = selected_class_index % #classes + 1
    end    
    if btnp(5) and dget(0) >= classes[selected_class_index].wins_needed then
        state = "gameplay"
        for i = 1,6 do
            abilities[i] = classes[selected_class_index].abilities[i]
        end
        start_level(1)
    end
end

function draw_newgame()
    cls()
    print("⬅️", 4, 20, 7)    
    print("➡️", 120, 20, 7)
    local cl = classes[selected_class_index]
    local color = 7
    if dget(0) < cl.wins_needed then
        color = 6
        print("unlocked after " .. cl.wins_needed .. " wins", 22, 28, 6)
    else
        local s = "❎ to choose "..cl.name
        print(s, 64 - #s * 2, 96, 7)
    end
    print(cl.name, 64 - #cl.name * 2, 20, color)
    draw_die2d(cl.abilities, 30, 36)
    
    
end

current_upgrades = nil
selected_upgrade_index = 1
applied = {}
faces_options1 = split("xx____,xx____,xx____,____xx,____xx,__x___,__x___,___x__,___x__")
faces_options2 = split("x_____,_x____,__x___,___x__,____x_,_____x")
function update_upgrade()
    tf += 1
    if current_upgrades == nil then
        current_upgrades = {}
        local options = {"+1", "hp", rnd(enabled_animals), rnd(bases)}
        for i = 1, 3 do
            local ind = flr(rnd(#options) + 1)
            local v = options[ind]
            deli(options, ind)
            local rndfc = '______'
            if v == '+1' then
                rndfc = rnd(faces_options1)
            else
                rndfc = rnd(faces_options2)
            end
            current_upgrades[i] = make_upgrade(rndfc, v)
        end
    end
    if btnp(0) then
        selected_upgrade_index = (selected_upgrade_index - 2) % #current_upgrades + 1
    end
    if btnp(1) then
        selected_upgrade_index = selected_upgrade_index % #current_upgrades + 1
    end    
    if btnp(5) then
        abilities = applied
        if current_upgrades[selected_upgrade_index].animal == "hp" then
            max_hp += 1
        end
        current_upgrades = nil
        selected_upgrade_index = 1
        state = "gameplay"
        start_level()
    end
end

function draw_upgrade()
    cls()
    local ls = "level "..(level + 1).."/15"
    print(ls, 64 - #ls * 2, 2, 6)
    print("⬅️", 4, 30, 7)    
    print("➡️", 120, 30, 7)    
    print("- choose upgrade -", 28, 12, 7)
    if current_upgrades != nil then
        local upgrade = current_upgrades[selected_upgrade_index]
        applied = {}
        for i = 1, 6 do
            applied[i] = abilities[i].copy()
            if upgrade.faces[i] then
                if upgrade.animal == "hp" then
                    --
                elseif sub(upgrade.animal,1,1) == "+" then
                    applied[i].pips += sub(upgrade.animal,2,2)
                elseif count(bases, upgrade.animal) > 0 then
                    applied[i].base = upgrade.animal
                else
                    applied[i].animal1 = upgrade.animal
                    local animal_descriptions = {
                        leaf="leaf: growth",
                        fox="fox: fire or speed",
                        elephant="elephant: drop tiles or stun",
                        rabbit="rabbit: quick roll or angular"
                    }
                    local desc = animal_descriptions[upgrade.animal]
                    print(desc, 64 - #desc * 2, 112, 6)
                end
            end
        end
        for i = 1, #current_upgrades do
            current_upgrades[i].draw(i * 30 - 4, 27)
            local color = 5
            if i == selected_upgrade_index then
                color = 7
            end
            rect(i * 30 - 10, 22, i * 30 - 6 + 24, 45, color)
        end
        draw_die2d(abilities,30,56,applied,upgrade)
    end
end

function update_win()
end

function draw_win()
    cls()
    print("you win!!!", 44, 50, 7)
    print("wins: " .. dget(0), 50, 60, 7)
end

state = "title"
states = {
    title = {update=update_title, draw=draw_title},
    newgame = {update=update_newgame, draw=draw_newgame},
    gameplay = {update=update_gameplay, draw=draw_gameplay},
    upgrade = {update=update_upgrade, draw=draw_upgrade},
    win = {update=update_win, draw=draw_win}
}

function _draw()
    states[state].draw()
end
function _update()
    states[state].update()
end

__gfx__
000000008888888888888888cccccccccccccccc00000000000000000000000000000000000000080000000000000000a0000000000000006000000000000000
000000008228228222228888c11c11c11111cccc0000000000000000000000000000000000000008000000000000000090000000000000666660000000000000
000000008888888282822888ccccccc1c1c11ccc0000000000000000000000000000000000000088880000000000000998800000000066661666600000000000
000000008222222222222228c11111111111111c000000000000000000000000000000000000085515800000000000a55158000000666666666a888000000000
000000008222222222222228c11111111111111c00000000000000000000000000000000000089851558000000000a99515580000666616666618a8800000000
000000008222222222222228c11111111111111c0000000000000000000000000000000000028a828882200000004aa9288822000dd666666666685200000000
000000008222222222222228c11111111111111c0000000a99000000000000000000000000028a851555800000004aa9515558000dddd8661666555500000000
000000008222222222222228c11111111111111c000000098880000000000000aaa00000000289851555800000004a99515558000d1dd8d66655555500000000
000000008222222222222228c11111111111111c000000098188800000000000a9999000000818551551800000041995155180000dddaddd6555555500000000
000000008222222222222228c11111111111111c000000008518580000000000a9195900000251111115200000045111111520000a8d88ad6555115500000000
000000008222222222222228c11111111111111c000000008881118008899a000951114000008555155800000000955515580000088a888a6555115500000000
000000008222222222222228c11111111111111c08888808551552800851590a9515528000000855158000000000095515800000088888886555585500000000
000000008888888888888888cccccccccccccccc0851582555152580087154455515258000000022220000000000004222000000088888886555555500000000
00000000155555555555555515555555555555550871520222881580085158022288158000000851558000000000095155800000000888188858880000000000
00000000156565656565656515656565656565650851588558025180022222855802518000000088880000000000008888000000000008886888000000000000
00000000165656565656565516565656565656550222220220222200000000022022220000000000000000000000000000000000000000088800000000000000
000000000000000000000000000000000000000000000000bbbb0000000000000bbb700000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000b5155b00000000000b515570000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000bb7bb7b0000000000bb7b777000000000000000000000000000000000000000000000000000000000
000000000000000bbb000000000000bb700000000000000b5155b00000000000b515570000000000000000000000000000000000000000000000000000000000
0000000000000000b00000000000000b000000000000000b5155b00000000000b515570000000022220000000000044220000000000000000000000000000000
000000000000000b1b000000000000b17000000000000000b15b0000000000000b1570000a99888820000000aaaa988200000000000000000000000000000000
00000000000000b515b0000000000b5157000000000000bb515b000000000000b5157777000a98515822200000a9951582220000000000000000000000000000
00000000000000b111b3b00000000b1116b7000000000b55bbb3000000000000b7b7755700008857558200000009857558200000000000000000000000000000
00000000000000b5b5b3b00000000b5b56b700000000b1b111133000000000000b11777700000251555800080000451555800000000000000000000000000000
00000000000000b111b0000000000b1117000000000b5b0b5130353000000000bbb57000000ee8528888808800ae952888880888000000000000000000000000
00000000000000b515b0000000000b5157000000000bbb0b5130033000000003005b700000e02558555158800a04558555158800000000000000000000000000
00000000000000bbbbb0000000000bbbbb70000000000033515b00000000000551570000000008885551858000e0988555185800000000000000000000000000
0000000000000300330300000000300330060000000003530bbb0000000003550bbb000000008888855855580000988885815580000000000000000000000000
000000000000b001b100b0000000b001b00070000000033111b100000000b33311b100000008558808808858000a558858088858000000000000000000000000
0000000000033111b111330000033111b11133000001b11111bbb1000000b11111bb70000008582000002288000a590520000288000000000000000000000000
0000000000011013331011000001101333101000000bbb11111100000000bb1111111000008880000000088800a9800000000088000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000088000000000000000000000000002800000000500000000005000000000000000000000000000000000000000000000000000000000000000000
00000000000828000000000000000000000000080020000000050000000050000000088828800000000000000000000000000000008880000000000000000000
00000000008280000000200000002000000000020000000000005000000500000000888828880000000008888000000000000000888008000000000000000000
00000000082800000008888888888800000000888000000000000500005000000008888828888000000088888800000000000088880000000000000000080000
00002000828000000000888888888800000088888820000000000050050000000002222222222000000088888828880000000888800000800000000008088000
00002208880000000002880080000000000088888880000000000005500000000000888828880000000088888800000000008888000000000088888888888880
00000228800000000008280080000000000888282882000000000005500000000000888828880000000088888800000000088888800000000000000008088000
00000822000000000082828800000000000888828882000000000050050000000000088828800000000002002000000000888888880000000000000000080000
00008882200000000028280000000000000888282882000000000500005000000000088828800000000080000800000008888888888880000000000000000000
00088800220000000082800000000000000088888820000000005000000500000000008828000000000800000080000008888888888888000000000000000000
00008000000000000000000000000000000028888220000000050000000050000000000820000000002220000222000000000000000000000000000000000000
00000000000000000000000000000000000000222000000000500000000005000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
909990900d600000002020000b0b0000066002000200000070700000a1a000007000070000440000080000000555000000bb00000eee00000000000000000000
02292200d666000022020220b1b1b000062aa00044209000e0e000008a900000074470009499900007800000565650000b3b0000e1e1e0000000000000000000
09191900d616000022a2a220bbbbb0002a2a90004229000077700000000900000444400094191000891900005797500003b00000eeeee0000000000000000000
07919700d6660000202220203bbb300009290000999900007177000009a0000000440000044940009977700005550000b00000000eee00000000000000000000
077277006d0606000002000033033000000000000000000077700000a000a00000990000009900009700000057775000000000000e0e00000000000000000000
0007000000006000000000000000000000000000000000000000000009a900000000000000000000700000005777500000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000007670000000cc0000000000000909000000000000000000000000000000000000880000000000000000000000000000000000000000000
0070000000000a000077677000000cc0000900000000900000090000000000000009000000000000000880000000000000000000000000000000000000000000
007777700aaaaa00006666600000cc00000900000000090000000000000900000009000000000000088888800000000000000000000000000000000000000000
77755557a5555aaa00076700cc0cc000009900000009090000090000009000000000000000000000088888800000000000000000000000000000000000000000
007777700aaaaa0000076700000cccc0009990000009990000090000009900000090000000000000000880000000000000000000000000000000000000000000
0070000000000a0000006000cc0ccccc000990000000900000099000009990000999090000000000000880000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0008a800000bbb000002200000033000000000088888888000000000988888880000000000000000000000000000000000000000000000000000000000000000
0085558000b555b000288200003bb300000000885152280000000009851522800000000000000000000000000000000000000000000000000000000000000000
00a222a000b111b002a55a2003155130000000788788200000000007987882000000000000000000000000000000000000000000000000000000000000000000
0085558000b555b0285155823b5155b30000021551558000000000415515580000000080800000000000000a0800000000000000000000000000000000000000
0008a800000bbb00285515823b5515b3000008155155800000000091551558000000000800000000000000008000000000000000000000000000000000000000
000000000000000002a55a200315513000000088518800000000000a9518800000000081800000000000000a1800000000000000000000000000000000000000
000000000000000000288200003bb300000000008280000000000000092800000000085158000000000000a51580000000000000000000000000000000000000
00111110001111100002200000033000000a9222815200000000a9444815200000082811180000000000a8911180000000000000000000000000000000000000
000000000000000000000000000000000000a9221118000000000a944111800000082858580000000000a8958580000000000000000000000000000000000000
00006000006000000000000000000000000000085158800000000000951588000000081118000000000000a11180000000000000000000000000000000000000
00000000000000600000000000000000000000088820800000000000998288000000085158000000000000a51580000000000000000000000000000000000000
6000000600000000000000000000000000000085512088800000099955120980000008888800000000000a888880000000000000000000000000000000000000
00000000060000000000000000000000000008582120088000000095921209800000202200200000000090022002000000000000000000000000000000000000
00060000000006000000000000000000000821111820000000909411118209800008000800080000000a00080008000000000000000000000000000000000000
00000000000000000000000000000000008888855152000000099985515200000022000800022000002200080002200000000000000000000000000000000000
00000000000000000000000000000000000000088882200000000008888220000000002220000000000000222000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000088000002200000000a900000220000000000000000000000000000000000
0000000000000000000000000000000000000008888200000000000099882000000082888888200000000a498888820000000000000000000000000000000000
0000000000000000000000000000000000000085552200000000000955542000000085272558200000000a547255820000000000000000000000000000000000
0000000000000000000000000000000000000008585200000000000095852000000088888888200000000a988888820000000000000000000000000000000000
0000000000000000000000000000000000000085855200000000000a595520000000000025202000000000000452200000000000000000000000000000000000
000000000000000000000000000000000000081718520000000000a171852000000000088820000000000000a882000000000000000000000000000000000000
000000000000000000000000000000000000085555200000000000a55552000000000085552000000000000a5552000000000000000000000000000000000000
0000000000000000000000000000000000000088820000000000000a982000000000008882200000000000098822000000000000000000000000000000000000
00000000000000000000000000000000000088515880000000000aa5158800000000008555200000000000a55520000000000000000000000000000000000000
000000000000000000000000000000000000085152000000000000a5152000000000028888000000000004988800000000000000000000000000000000000000
000000000000000000000000000000000000008180000000000000a1580000000000080008000000000008000800000000000000000000000000000000000000
00000000000000000000000000000000000000852000000000000095200000000000800008000000000080000800000000000000000000000000000000000000
00000000000000000000000000000000000000020000000000000004000000000000800000200000000080000020000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000800000020000000080000002000000000000000000000000000000000000
00888800008888000066660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888800008008000066660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888800008008000066660000066000000660000006600000066000000660000000000000000000000000000000000000000000000000000000000000000000
08888000080080000666600000600600006066000060660000606600006666000000000000000000000000000000000000000000000000000000000000000000
08888000080080000666600000600600006006000060660000666600006666000000000000000000000000000000000000000000000000000000000000000000
08888000080080000666600000066000000660000006600000066000000660000000000000000000000000000000000000000000000000000000000000000000
88880000800800006666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88880000888800006666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
00088880088880088880088880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088880088880088880088880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088880088880088880088880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888800888800888800888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888800888800888800888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888800888800888800888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08888008888008888008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08888008888008888008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8888888888888888888888888888888888888888888888888888888888888888cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
8228228222228888822822822222888882282282222288888228228222228888c11c11c11111ccccc11c11c11111ccccc11c11c11111ccccc11c11c11111cccc
8888888282822888888888828282288888888882828228888888888282822888ccccccc1c1c11cccccccccc1c1c11cccccccccc1c1c11cccccccccc1c1c11ccc
8222222222222228822222222222222882222222222222288222222222222228c11111111111111cc11111111111111cc11111111111111cc11111111111111c
8222222222222228822222222222222882222222222222288222222222222228c11111111111111cc11111111111111cc11111111111111cc11111111111111c
8222222222222228822222222222222882222222222222288222222222222228c11111111111111cc11111111111111cc11111111111111cc11111111111111c
8222222222222228822222222222222882222222222222288222222222222228c11111111111111cc11111111111111cc11111111111111cc11111111111111c
8222222222222228822222222222222882222222222222288222222222222228c11111111111111cc11111111111111cc11111111111111cc11111111111111c
8222222222222228822222222222222882222222222222288222222222222228c11111111111111cc11111111111111cc11111111111111cc11111111111111c
8222222222222228822222222222222882222222222222288222222222222228c11111111111111cc11111111111111cc11111888821111cc11111111111111c
8222222222222228822222222222222882222222222222288222222222222228c11111111111111cc11111111111111cc11118555221111cc11111111111111c
8222222222222228822222222222222882222222222222288222222222222228c11111111111111cc11111111111111cc11111858521111cc11111111111111c
8888888888888888888888888888888888888888888888888888888888888888ccccccccccccccccccccccccccccccccccccc858552ccccccccccccccccccccc
88888888888888888888888888888888888888888888888888888888888888888888a88888888888cccccccccccccccccccc8171852ccccccccccccccccccccc
8228228222228888822822822222888882282282222288888aaaaa822aaaaaa88a85558aaaaaaaa8caaaaaaaaaaaaaacc11c85555211ccccc11c11c11111cccc
8888888282822888888888828282288888888882828228888a888882828228a88aa222aaaaaaaaa8caaaaaaaaaaaaaacccccc88821c11cccccccccc1c1c11ccc
8222222222222228822222222222222882222222222222288a222222222222a88a85558aaaaaaaa8caaaaaaaaaaaaaacc11885158811111cc11111111111111c
8222222222222228822222222222222882222222222222288a222222222222a88aa8a8aaaaaaaaa8caaaaaaaaaaaaaacc11185152111111cc11111111111111c
82222222222222288222222222222228822222222222222882222222222222288aaaaaaaaaaaaaa8caaaaaaaaaaaaaacc11118181111111cc11111111111111c
82222222222222288222222bbbb22228822222222222222882222222222222288aaaaaaaaaaaaaa8caaaaaaaaaaaaaacc11118521111111cc11111111111111c
8222222222222228822222b5155b222882222222222222288a222222222222a88a11111aaaaaaaa8caaaaaaaaaaaaaacc11111211111111cc11111111111111c
8222222222222228822222bb7bb7b22882222222222222288a222222222222a88aaaaaaaaaaaaaa8caaaaaaaaaaaaaacc11111111111111cc11111111111111c
8222222222222228822222b5155b222882222222222222288a222222222222a88aaaaaaaaaaaaaa8caaaaaaaaaaaaaacc11111111111111cc11111888821111c
8222222222222228822222b5155b222882222222222222288a222222222222a88aaaaaaaaaaaaaa8caaaaaaaaaaaaaacc11888888888811cc11118555221111c
82222222222222288222222b15b2222882222222222222288aaaaa222aaaaaa88aaaaaaaaaaaaaa8caaaaaaaaaaaaaacc11111111111111cc11111858521111c
888888888888888888888bb515b88888888888888888888888888888888888888888888888888888ccccccccccccccccccccccccccccccccccccc858552ccccc
88888888888888888888b55bbb38888888888888888888888888888888888888ccccccccccccccccccc8a8cccccccccccccccccccccccccccccc8171852ccccc
8228228222228888822b1b111133888882282282222288888228228222228888caaaaac11aaaaaacca85558aaaaaaaaccaaaaaaaaaaaaaacc11c85555211cccc
888888828282288888b5b8b51383538888888882828228888888888282822888caccccc1c1c11caccaa222aaaaaaaaaccaaaaaaaaaaaaaacccccc88821c11ccc
822222222222222882bbb2b51322332882222222222222288222222222222228ca111111111111acca85558aaaaaaaaccaaaaaaaaaaaaaacc11885158811111c
82222222222222288222233515b2222882222222222222288222222222222228ca111111111111accaa8a8aaaaaaaaaccaaaaaaaaaaaaaacc11185152111111c
822222222222222882223532bbb2222882222222222222288222222222222228c11111111111111ccaaaaaaaaaaaaaaccaaaaaaaaaaaaaacc11118181111111c
8222222222222228822233111b12222882222222222222288222222222222228c11111111111111ccaaaaaaaaaaaaaaccaaaaaaaaaaaaaacc11118521111111c
8222222222222228821b11111bbb122882222222222222288222222222222228ca111111111111acca11111aaaaaaaaccaaaaaaaaaaaaaacc11111211111111c
822222222222222882bbb1111112222882222222222222288222222222222228ca111111111111accaaaaaaaaaaaaaaccaaaaaaaaaaaaaacc11111111111111c
8222222222222228822222222222222882222222222222288222222222222228ca111111111111accaaaaaaaaaaaaaaccaaaaaaaaaaaaaacc11111111111111c
8222222222222228822222222222222882222222222222288222222222222228ca111111111111accaaaaaaaaaaaaaaccaaaaaaaaaaaaaacc11888888888811c
8222222222222228822222222222222882222222222222288222222222222228caaaaa111aaaaaaccaaaaaaaaaaaaaaccaaaaaaaaaaaaaacc11111111111111c
8888888888888888888888888888888888888888888888888888888888888888cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
8888888888888888888888888888888888888888888888888888888888888888cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
8228228222228888822822822222888882282282222288888228228222228888c11c11c11111ccccc11c11c11111ccccc11c11c11111ccccc11c11c11111cccc
8888888282822888888888828282288888888882828228888888888282822888ccccccc1c1c11cccccccccc1c1c11cccccccccc1c1c11cccccccccc1c1c11ccc
8222222222222228822222222222222882222222222222288222222222222228c11111111111111cc11111111111111cc11111111111111cc11111111111111c
8222222222222228822222222222222882222222222222288222222222222228c11111111111111cc11111111111111cc11111111111111cc11111111111111c
8222222222222228822222222222222882222222222222288222222222222228c11111111111111cc11111111111111cc11111111111111cc11111111111111c
8222222222222228822222222222222882222222222222288222222222222228c11111111111111cc11111111111111cc11111111111111cc11111111111111c
8222222222222228822222222222222882222222222222288222222222222228c11111111111111cc11111111111111cc11111111111111cc11111111111111c
8222222222222228822222222222222882222222222222288222222222222228c11111111111111cc11111111111111cc11111111111111cc11111111111111c
8222222222222228822222222222222882222222222222288222222222222228c11111111111111cc11111111111111cc11111111111111cc11111111111111c
8222222222222228822222222222222882222222222222288222222222222228c11111111111111cc11111111111111cc11111111111111cc11111111111111c
8222222222222228822222222222222882222222222222288222222222222228c11111111111111cc11111111111111cc11111111111111cc11111111111111c
8888888888888888888888888888888888888888888888888888888888888888cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
15555555555555551555555555555555155555555555555515555555555555551555555555555555155555555555555515555555555555551555555555555555
15656565656565651565656565656565156565656565656515656565656565651565656565656565156565656565656515656565656565651565656565656565
16565656565656551656565656565655165656565656565516565656565656551656565656565655165656565656565516565656565656551656565656565655
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000cccccccccccccccc0000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000c00000000000000c0000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000c00000000000000c0000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000c00008882880000c0000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000c00088882888000c0000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000c00888882888800c0000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000c00222222222200c0000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000c00088882888000c0000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000c00088882888000c0000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000c00008882880000c0000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000c00008882880000c0000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000c0000088280aaa0c0000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000c00000082000000c0000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000c0000000000aaa0c0000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000c00000000000000c0000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000cccccccccccccccc0000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000bb0bbb0bbb0bb0000000bb0b0b0bbb0bbb0b000bb00000000000000000000000000000000000000000000
000000000000000000000000000000000000000000b000b0b00b00b0b00000b000b0b00b00b000b000b0b0000000000000000000000000000000000000000000
000000000000000000000000000000000000000000b000bbb00b00b0b00000bbb0bbb00b00bb00b000b0b0000000000000000000000000000000000000000000
000000000000000000000000000000000000000000b0b0b0b00b00b0b0000000b0b0b00b00b000b000b0b0000000000000000000000000000000000000000000
000000000000000000000000000000000000000000bbb0b0b0bbb0b0b00000bb00b0b0bbb0bbb0bbb0bbb0000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

