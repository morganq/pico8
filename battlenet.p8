pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
-- battlenet
-- by morganquirk


--[[

BASE TYPE (center)
    - sword, gun, bomb, timed shield? 
pips (br) - 1-10 or w/e
]]

--[[
       [5]
    [1][2][3][4]
       [6]
]]
local grid = { }
local shield_time = 30 * 15

local imgs_base = {sword=64, gun=66, bomb=68, none=70, shield=72, turret=74, wave=76, spear=78}
local bases = {"sword", "gun", "bomb", "shield", "turret", "wave", "spear"}
local animals = split("tiger,elephant,bat,frog,bee,snail,rabbit,snake,ox,monkey,fox,penguin,leaf")
local spranimals = {}
for k,v in pairs(animals) do
    spranimals[v] = k + 95
end
local enabled_animals = split("tiger,elephant,rabbit,fox")

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

function make_effect_dmgnumber(x, y, num)
    local ng = make_nongrid(x,y)
    ng.time = 0
    ng.draw = function()
        print("-"..num, x, y - ng.time \ 5, 7)
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

function make_bullet(x, y, side, speed, abil, spri, sprw, sprh)
    local ng = make_nongrid(x,y)
    ng.last_x = gp(x,y)[1]
    ng.side = side
    local dir = 1
    if ng.side != 'red' then dir = -1 end
    ng.draw = function()
        spr(spri, ng.pos[1], ng.pos[2], sprw or 1, sprh or 1)
    end
    ng.update = function()
        local gpp = gp(ng.pos[1] + 4 + 8 * speed * dir,ng.pos[2])
        if gpp[1] != ng.last_x then
            ng.last_x = gpp[1]
            make_damage_spot(gpp[1], gpp[2], abil.pips, ng.side, 10)
            if count_animal(abil, "elephant") > 0 and grid[gpp[2]][gpp[1]].space.side != ng.side then 
                grid[gpp[2]][gpp[1]].space.drop(30 * 10)
            end
        end
        local dir = 1
        if side != "red" then dir = -1 end
        ng.pos = {ng.pos[1] + dir * speed, ng.pos[2]}
        if ng.pos[1] < 0 or ng.pos[1] > 128 then
            del(nongrid, ng)
        end
    end
    return ng
end

function make_bomb(x1, x2, y, side, abil)
    local ng = make_nongrid(x1,y)
    ng.side = side
    ng.time = 0
    ng.draw = function()
        circfill(ng.pos[1], ng.pos[2], 3, 6)
    end
    ng.update = function()
        ng.time += 1
        local t = ng.time / 60
        ng.pos = {t * (x2 - x1) + x1 + 8, y + ((t * 2 - 1) ^ 2) * 20 - 16}
        if ng.time > 60 then
            del(nongrid, ng)
        end
    end
    return ng
end

function make_melee(x, y, user, dist, side, abil, onhit)
    local ng = make_nongrid(x, y)
    local dir = 1
    local returning = false
    local sx = x
    if side != 'red' then dir = -1 end
    ng.draw = function()
        fillp(0b1111000011110000.11)
        spr(user.spri, x, y + user.yo, 2, 2)
        fillp()
    end
    ng.update = function()
        if returning then
            x -= 4 * dir
            if dir == 1 and x <= sx or dir == -1 and x >= sx then
                del(nongrid, ng)
            end
        else 
            x += 4 * dir
            dist -= 4
            local np = gp(x + 8 + dir * 16, y)
            local hit_creature = grid[np[2]][np[1]].creature and grid[np[2]][np[1]].creature.side != side
            if hit_creature or np[1] == 1 or np[1] == 8 or dist <= 0 then
                returning = true
                onhit(np[1],np[2])
            end
        end
    end
end

function addfields(tbl,add)
    for k,v in pairs(add) do
        tbl[k] = v
    end
end

function abil_sword(user, a, x, y, side)
    local pp = tp(x,y)
    local onhit = function(gx,gy)
        for gyy = max(gy-1,1), min(gy+1,4) do
            make_damage_spot(gx, gyy, a.pips, side, 0)
            if count_animal(a, "elephant") > 0 then
                grid[gyy][gx].space.drop(30 * 10)
            end
        end
    end
    if side == 'red' and x <= 7 then 
        grid[y][x+1].space.flip('red', 30 * 5)
    end
    if side == 'blue' and x >= 2 then 
        grid[y][x-1].space.flip('blue', 30 * 5)
    end    
    make_melee(pp[1], pp[2], user, 0 + 16 * count_animal(a, "tiger"), side, a, onhit)
end

function abil_spear(user, a, x, y, side)
    local pp = tp(x,y)
    local dir = 1
    if side != 'red' then dir = -1 end
    local onhit = function(gx,gy)        
        for gxx = gx, clamp(gx + dir * (count_animal(a, "tiger") + 1),1,8), dir do
            make_damage_spot(gxx, gy, a.pips, side, 0)
            if count_animal(a, "elephant") > 0 then
                grid[gy][gxx].space.drop(30 * 10)
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
            make_damage_spot(i, y, damage, side, 0)
            break
        end
    end
    local lend = tp(x2, y)
    make_effect_laser(lstart[1] + 8, lstart[2] + 3, lend[1] + 8, lend[2] + 3, side)
end

function abil_wave(user, a, x, y, side)
    local pp = tp(x, y)
    make_bullet(pp[1], pp[2], side, 2 + count_animal(a, "fox") * 2, a, 128)
end

function abil_bomb(user, a, x, y, side)
    local time = 60
    local dist = 4
    local x2 = x
    local pp1 = tp(x, y)
    if side == 'red' then
        x2 = min(x + dist, 8)
    else
        x2 = max(x - dist, 1)
    end
    local pp2 = tp(x2, y)
    make_bomb(pp1[1], pp2[1], pp1[2], side, a)
    for i = x2-1, x2+1 do
        if i >= 1 and i <= 8 then
            make_damage_spot(i, y, a.pips, side, time, {hit_drop=count_animal(a,"elephant") * 300})
        end
    end
    if y > 1 then make_damage_spot(x2, y-1, a.pips, side, time, {hit_drop=count_animal(a,"elephant") * 300}) end
    if y < 4 then make_damage_spot(x2, y+1, a.pips, side, time, {hit_drop=count_animal(a,"elephant") * 300}) end
    
end

function abil_shield(user, a, x, y, side)
    local shield = a.pips
    shield += count_animal(a, "elephant") * 2
    user.shield = max(user.shield, shield)
    if count_animal(a, "elephant") > 0 then
        grid[y][x].space.drop(600)
    end
    user.shield_timer = shield_time
end

function abil_turret(user, a, x, y, side)
    local x1 = x
    if valid_move_target(x + 1, y, side) then
        x1 = x + 1
    elseif valid_move_target(x - 1, y, side) then
        x1 = x - 1    
    else
        return
    end
    local t = make_turret(x1, y, a)
    t.health += count_animal(a, "elephant") * 2
    user.stun_time += count_animal(a, "elephant") * 30
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
        {0,0}, {-dir, 0}, {dir, 0}, {0,-1}, {0,1}, {-dir,-1}, {-dir,1}, {dir,-1}, {dir,1}
    }
    for offset in all(attempts) do
        local tx, ty = gx + offset[1], gy + offset[2]
        if tx >= 1 and tx <= 8 and ty >= 1 and ty <= 8 then
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
        make_effect_dmgnumber(pp[1] + 10, pp[2] - 4, damage)
        if go.health <= 0 then
            go.kill()
        end
    end

    go.kill = function()
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

function make_monster(spri, x, y, abilities, health, speed, special_properties)
    local needs_push = false
    if grid[y][x].creature then needs_push = true end
    local c = make_creature(x,y,"blue", health, spri, 2, 2)
    c.abilities = abilities
    c.speed = speed
    c.time = 0
    c.next_ability = rnd(c.abilities)
    addfields(c, special_properties or {})
    if c.move_pattern then c.move_pattern_i = 1 end
    if c.abil_pattern then c.abil_pattern_i = 1 end

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
        basedraw()
        local pp = tp(c.pos[1], c.pos[2])
        local hpx = 8 - c.max_health + pp[1]
        local hpy = pp[2] + 10
        
        for i = 1, c.max_health do
            if c.health >= i then
                line(hpx, hpy, hpx, hpy + 1, 8)
            else
                line(hpx, hpy, hpx, hpy + 1, 5)
            end
            hpx += 2
        end
    end
    if needs_push then
        push_to_open_square(c)
    end
    return c
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
            if go.pos[1] == 0 or go.side == 'blue' and grid[go.pos[2]][go.pos[1] - 1].space.side == 'red' then
                can_revert = true
            end
            if can_revert then            
                go.flip_time -= 1
                if go.flip_time <= 0 then
                    go.side = go.main_side
                end
            end
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
        if a.num_growth < 3 then
            a.pips += count_animal(a, "leaf")
            a.num_growth += 1
        end
    end
    return a
end

function make_player()
    local pl = make_creature(1,2, 'red', 4, 37, 2, 2)
    addfields(pl, {
        max_health = 4,
        die = {},
        current_ability = nil,
    })
    return pl
end

function make_turret(x, y, a)
    local t = make_creature(x, y, 'red', a.pips, 33, 2, 2)
    local baseupdate = t.update
    local abil = make_ability("wave", a.pips)
    t.update = function()
        baseupdate()
        if tf % 120 == 0 then    
            abil.use(t, x, y, 'red')
        end
    end
    return t
end

function make_upgrade(faces, animal)
    local up = {
        faces = faces,
        animal = animal
    }
    local positions = {
        {0,3},{3,3},{6,3},{9,3},{3,0},{3,6}
    }
    up.draw = function(x,y)
        for i = 1, 6 do
            local px, py = positions[i][1] + x, positions[i][2] + y + 6
            local color = 5
            if faces[i] then color = 11 end
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
    if die2 then
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
end
level = 2
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

    --[[
    pl.die[1] = make_ability("shield", 1)
    pl.die[2] = make_ability("sword", 1)
    pl.die[3] = make_ability("sword", 1)
    pl.die[4] = make_ability("gun", 1)
    pl.die[5] = make_ability("gun", 1)
    pl.die[6] = make_ability("bomb", 1)
    ]]
    for i = 1,6 do
        pl.die[i] = abilities[i]
        --pl.die[i] = make_ability("sword", 1)
    end

    --make_monster(6,3, {make_ability("bomb", 1)}, 3, 80, 40)
    function m_mage1(r) make_monster(132, flr(rnd(4)) + 5, flr(rnd(4)) + 1, {make_ability("wave", 1)}, 3, 40, {move_pattern={true,true,false}, abil_pattern = {false, false, true}, favor_row=r}) end
    function m_fighter1(r) make_monster(41, flr(rnd(4)) + 5, flr(rnd(4)) + 1, {make_ability("sword", 1)}, 5, 45, {move_pattern={true,true}, abil_pattern = {false, true}, favor_row=r}) end
    function m_duelist1(r) make_monster(132, flr(rnd(4)) + 5, flr(rnd(4)) + 1, {make_ability("wave", 1, "fox"), make_ability("sword", 2)}, 5, 25, {move_pattern={true,true,true,false}, abil_pattern = {false, false, false, true}, favor_row=r}) end
    function m_bomber1(r) make_monster(5, flr(rnd(4)) + 5, flr(rnd(4)) + 1, {make_ability("bomb", 2)}, 4, 95, {favor_row=r}) end
    if level == 1 then
        m_mage1(1)
        m_mage1(2)
    elseif level == 2 then
        m_mage1()
        m_fighter1()
    elseif level == 3 then
        m_duelist1(1)
        m_bomber1(3)
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
        pl.die[pl.current_ability].draw_face(die3d.x - 8, die3d.y - 8)
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
        print("victory", 50, min(victory_time, 60), victory_time % 16)
    end
    if defeat then
        print("defeat", 52, min(defeat_time, 60), defeat_time % 16)
    end
end

function update_gameplay()
    if victory then
        victory_time += 1
        if victory_time > 30 then
            state = "upgrade"
        end
    end
    if defeat then
        defeat_time += 1
        if defeat_time > 120 then
            state="title"
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
        if btnp(4) then
            victory = true
            victory_time = 0
        end
    end
    tf += 1
    if die3d.visible then
        die3d.yv += 0.1
        if die3d.y > 100 then
            die3d.yv = die3d.yv * -0.5
            die3d.y = 100
            dvra = (0.5 - rnd()) * die3d.yv * die3d.xv
            dvrb = (0.5 - rnd()) * die3d.yv * die3d.xv
            dvrc = (0.5 - rnd()) * die3d.yv * die3d.xv
            if die3d.xv < 0.4 then
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

function update_title()
    if btnp(5) then
        state = "newgame"
    end
end

function draw_title()
    cls()
    --🅾️
    print("❎ to start", 42, 60, 7)
end

abilities = {}
classes = {
    {name="vanguard", abilities={
        make_ability("sword", 1),
        make_ability("sword", 2),
        make_ability("spear", 2),
        make_ability("spear", 1),
        make_ability("shield", 2),
        make_ability("bomb", 1),
    }},
    {name="wizard", abilities={
        make_ability("wave", 1),
        make_ability("wave", 2),
        make_ability("wave", 1),
        make_ability("sword", 1),
        make_ability("bomb", 2),
        make_ability("shield", 1),
    }},
    {name="druid", abilities={
        make_ability("gun", 1),
        make_ability("sword", 1, "leaf"),
        make_ability("shield", 1),
        make_ability("none", 1),
        make_ability("shield", 1, "leaf"),
        make_ability("bomb", 1, "leaf"),
    }},
    {name="engineer", abilities={
        make_ability("turret", 1),
        make_ability("turret", 2),
        make_ability("bomb", 1),
        make_ability("bomb", 2),
        make_ability("gun", 1),
        make_ability("shield", 1),
    }},
    {name="manipulator", abilities={
        make_ability("gun", 1),
        make_ability("sword", 1),
        make_ability("wave", 1, "elephant"),
        make_ability("wave", 1, "elephant"),
        make_ability("bomb", 1),
        make_ability("shield", 1, "elephant"),
    }},     
}
selected_class_index = 1
function update_newgame()
    if btnp(0) then
        selected_class_index = (selected_class_index - 2) % #classes + 1
    end
    if btnp(1) then
        selected_class_index = selected_class_index % #classes + 1
    end    
    if btnp(5) then
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
    print(cl.name, 64 - #cl.name * 2, 20, 7)
    draw_die2d(cl.abilities, 30, 36)
    local s = "❎ to choose "..cl.name
    print(s, 64 - #s * 2, 96, 7)
end

current_upgrades = nil
selected_upgrade_index = 1
applied = {}
faces_options = {
    {true,false,false,false,false,false},
    {false,true,false,false,false,false},
    {false,false,true,true,false,false},
    {false,false,false,false,true,true},
}
function update_upgrade()
    tf += 1
    if current_upgrades == nil then
        current_upgrades = {}
        current_upgrades[1] = make_upgrade(rnd(faces_options), "+1")
        current_upgrades[2] = make_upgrade(rnd(faces_options), rnd(enabled_animals))
        local rndfc = {false, false, false, false, false, false}
        rndfc[flr(rnd(6))+1] = true
        current_upgrades[3] = make_upgrade(rndfc, rnd(bases))
    end
    if btnp(0) then
        selected_upgrade_index = (selected_upgrade_index - 2) % #current_upgrades + 1
    end
    if btnp(1) then
        selected_upgrade_index = selected_upgrade_index % #current_upgrades + 1
    end    
    if btnp(5) then
        abilities = applied
        current_upgrades = nil
        state = "gameplay"
        start_level()
    end
end

function draw_upgrade()
    cls()
    print("⬅️", 4, 20, 7)    
    print("➡️", 120, 20, 7)    
    print("- choose upgrade -", 28, 2, 7)
    if current_upgrades != nil then
        local upgrade = current_upgrades[selected_upgrade_index]
        applied = {}
        for i = 1, 6 do
            applied[i] = abilities[i].copy()
            if upgrade.faces[i] then
                if sub(upgrade.animal,1,1) == "+" then
                    applied[i].pips += sub(upgrade.animal,2,2)
                elseif count(bases, upgrade.animal) > 0 then
                    applied[i].base = upgrade.animal
                else
                    applied[i].animal1 = upgrade.animal
                end
            end
        end
        for i = 1, #current_upgrades do
            current_upgrades[i].draw(i * 30 - 4, 17)
            local color = 5
            if i == selected_upgrade_index then
                color = 7
            end
            rect(i * 30 - 10, 12, i * 30 - 6 + 24, 35, color)
        end
        draw_die2d(abilities,30,56,applied,upgrade)
    end
end

state = "title"
states = {
    title = {update=update_title, draw=draw_title},
    newgame = {update=update_newgame, draw=draw_newgame},
    gameplay = {update=update_gameplay, draw=draw_gameplay},
    upgrade = {update=update_upgrade, draw=draw_upgrade},
}

function _draw()
    states[state].draw()
end
function _update()
    states[state].update()
end

__gfx__
000000008888888888888888cccccccccccccccc00000000000000000000000000000000000000080000000000000000a0000000000000000000000000000000
000000008228228222228888c11c11c11111cccc0000000000000000000000000000000000000008000000000000000090000000000000000000000000000000
000000008888888282822888ccccccc1c1c11ccc0000000000000000000000000000000000000088880000000000000998800000000000000000000000000000
000000008222222222222228c11111111111111c000000000000000000000000000000000000085515800000000000a551580000000000000000000000000000
000000008222222222222228c11111111111111c00000000000000000000000000000000000089851558000000000a9951558000000000000000000000000000
000000008222222222222228c11111111111111c0000000000000000000000000000000000028a828882200000004aa928882200000000000000000000000000
000000008222222222222228c11111111111111c0000000a99000000000000000000000000028a851555800000004aa951555800000000000000000000000000
000000008222222222222228c11111111111111c000000098880000000000000aaa00000000289851555800000004a9951555800000000000000000000000000
000000008222222222222228c11111111111111c000000098188800000000000a999900000081855155180000004199515518000000000000000000000000000
000000008222222222222228c11111111111111c000000008518580000000000a919590000025111111520000004511111152000000000000000000000000000
000000008222222222222228c11111111111111c000000008881118008899a000951114000008555155800000000955515580000000000000000000000000000
000000008222222222222228c11111111111111c08888808551552800851590a9515528000000855158000000000095515800000000000000000000000000000
000000008888888888888888cccccccccccccccc0851582555152580087154455515258000000022220000000000004222000000000000000000000000000000
00000000155555555555555515555555555555550871520222881580085158022288158000000851558000000000095155800000000000000000000000000000
00000000156565656565656515656565656565650851588558025180022222855802518000000088880000000000008888000000000000000000000000000000
00000000165656565656565516565656565656550222220220222200000000022022220000000000000000000000000000000000000000000000000000000000
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
909990900d600000002020000b0b0000066002000200000070700000a1a000007000070000440000080000000555000000bb0000000000000000000000000000
02292200d666000022020220b1b1b000062aa00044209000e0e000008a900000074470009499900007800000565650000b3b0000000000000000000000000000
09191900d616000022a2a220bbbbb0002a2a90004229000077700000000900000444400094191000891900005797500003b00000000000000000000000000000
07919700d6660000202220203bbb300009290000999900007177000009a0000000440000044940009977700005550000b0000000000000000000000000000000
077277006d0606000002000033033000000000000000000077700000a000a0000099000000990000970000005777500000000000000000000000000000000000
0007000000006000000000000000000000000000000000000000000009a900000000000000000000700000005777500000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070000000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007777700aaaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77755557a5555aaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007777700aaaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070000000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0008a800000bbb000000000000000000000000088888888000000000988888880000000000000000000000000000000000000000000000000000000000000000
0085558000b555b00000000000000000000000885152280000000009851522800000000000000000000000000000000000000000000000000000000000000000
00a222a000b111b00000000000000000000000788788200000000007987882000000000000000000000000000000000000000000000000000000000000000000
0085558000b555b00000000000000000000002155155800000000041551558000000000000000000000000000000000000000000000000000000000000000000
0008a800000bbb000000000000000000000008155155800000000091551558000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000088518800000000000a951880000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000008280000000000000092800000000000000000000000000000000000000000000000000000000000000000000
00111110001111100000000000000000000a9222815200000000a944481520000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000a9221118000000000a94411180000000000000000000000000000000000000000000000000000000000000000000
00006000006000000000000000000000000000085158800000000000951588000000000000000000000000000000000000000000000000000000000000000000
00000000000000600000000000000000000000088820800000000000998288000000000000000000000000000000000000000000000000000000000000000000
60000006000000000000000000000000000000855120888000000999551209800000000000000000000000000000000000000000000000000000000000000000
00000000060000000000000000000000000008582120088000000095921209800000000000000000000000000000000000000000000000000000000000000000
00060000000006000000000000000000000821111820000000909411118209800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000008888855152000000099985515200000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000088882200000000008888220000000000000000000000000000000000000000000000000000000000000000000
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
00888800008888000066660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888800008008000066660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888800008008000066660000066000000660000006600000066000000660000000000000000000000000000000000000000000000000000000000000000000
08888000080080000666600000600600006066000060660000606600006666000000000000000000000000000000000000000000000000000000000000000000
08888000080080000666600000600600006006000060660000666600006666000000000000000000000000000000000000000000000000000000000000000000
08888000080080000666600000066000000660000006600000066000000660000000000000000000000000000000000000000000000000000000000000000000
88880000800800006666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88880000888800006666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
