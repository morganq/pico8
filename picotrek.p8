pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
-- picotrek
-- by morganquirk

-- TODO
-- levels
-- hack lockin sound
-- win game
-- if possible: title screen
-- if possible: show icon on hal screen for other player


---- CONSTANTS ----
screen_height = 60
screen_halfheight = 30

walls = 130
maxspeed = 0.2
accel = 0.003
rotspeed = 0.0075

-- Using split to save on token count
powrows = split('reserve,weapons,shields,sensors,engines')
powcaps = split('8,5,5,5,5')
darken = split("0,0,0,1,2,1,5,6,2,4,9,3,13,1,8,9")

playercolors = {8, 12}


---- LEVEL DEFINITIONS ----
-- One slow enemy, one main asteroid
-- Two enemies, multiple asteroids
-- Two enemies near each other, one separate, two big asteroids
-- Station and 2 nearby enemies
-- 2 big enemies, 4 bugs

shiptypes = {
    bug='-0.15,3;-0.05,0;0,2;0.05,0;0.15,3;0.5,3:20:1:3:2',
    cruiser='-0.05,5;0.05,5;0.4,7;0.6,7:60:2:1:4',
    station='0,9;0.125,9;0.25,9;0.375,9;0.5,9;0.625,9;0.75,9;0.825,9;0,9;0,3;0.125,3;0.25,3;0.375,3;0.5,3;0.625,3;0.75,3;0.825,3;1.0,3:120:2:0:9',
    mothership='0,11;0.2,5;0.2,3;0.4,12;-0.4,12;-0.2,3;-0.2,11:280:4:1.5:9',
}

levels = {
    "cruiser,60,-50,10;a,60,-100,5;a,10,-45,7;a,-50,-80,12;a,65,-15,5;a,-50,-25,7;a,40,40,4;a,85,5,10;a,-5,60,20;a,-55,45,5",
    "cruiser,80,-50,14;cruiser,-80,50,9;a,-40,-20,20;a,-35,-70,5;a,50,50,24;a,60,-35,10",
    "bug,-100,-10,14;bug,100,110,15;station,80,100,9;a,-75,0,5;a,80,25,15;a,10,80,15;a,5,-30,3;a,-15,-50,3;a,45,-65,4",
    "cruiser,-100,-100,9;bug,-85,-95,15;cruiser,0,100,10;bug,15,95,14;a,-55,25,27;a,-85,-15,18;a,-80,-30,15;a,-50,-44,10;a,0,-45,3;a,40,-20,3;a,60,60,5",
    "mothership,0,-90,8;station,-90,20,10;cruiser,90,20,9;bug,-15,-80,15;bug,15,-80,14;a,-5,-50,10;a,-25,-45,8;a,30,-35,12;a,45,5,9;a,-15,45,6",
}

level = 1


---- GLOBALS ----

persistent = {
    hull = 100,
    loot = 0,
    bonus_quantum = 0,
    bonus_cores = 2
}

function init_level()
    playership = {
        pos = vec(),
        vel = vec(),
        angle = -0.25,
        shields = split("12,12,12,12"),
        hull = 1,--persistent.hull,
        radius = 3,
        mass = 1,
        loot = persistent.loot,
        --dead = false,
        dead_time = 0,
        p1_hit_enemy_time = 0,
        p2_hit_enemy_time = 0,
        mgun_hit_enemy_time = 0,
        map = make_map_control(),
        pow = make_pow_control(),
        wep = make_wep_control(),
        hax = make_hax_control(),
        hal = make_hal_control(),
        take_damage = player_take_damage
    }
    shake = vec()
    shaket = 1
    win_time = 0
    bought = 0

    recolor = nil
    damage_dir = nil
    lasers = {}
    bullets = {}
    ents = {}
    notices = {}

    tf = 0 -- time in frames

    for e in all(split(levels[level],";")) do
        local params = split(e,',')
        if params[1] == 'a' then
            add(ents, make_asteroid(params[2], params[3], params[4]))
        else
            add(ents, make_enemy(params[1], params[2], params[3], params[4]))
        end        
    end

    set_screen(1, 'map')
    set_screen(2, 'pow')
    generate_entgrid()
end

---- UTIL ----
function palparse(p) -- Parse a palette string. Subtract 1 from index because we need access to 0 color.
    local result = {}
    for k,v in pairs(split(p,",")) do
        result[k-1] = v
    end
    return result
end

-- Palettes for recoloring when you get hit
palgreen = palparse("3,3,4,3,3,3,11,7,10,10,11,11,11,11,10,11")
palorange = palparse("2,4,2,4,4,4,9,7,9,9,9,10,4,9,14,9")

-- Lerp function to bounce at the end (for shake)
function bounce(x)
    y = abs(cos(x * x)) * 2 / (x + 2)
    if x >= 1 then return 0 end
    return y
end

---- MATH ----

-- Radial distance between two angles
function angledelta(a,b)
    local delta = (b - a) % 1
    if (delta > 0.5) then
        delta = delta - 1
    elseif (a < -0.5) then
        delta = delta + 1
    end
    return delta
end

-- Round
function rd(x)
    if (x % 1 > 0.5) return flr(x+1) else return flr(x)
end

-- Clamp a value into a min/max range
function clamp(x,a,b)
    return min(max(x, a), b)
end

-- Insane function which returns an approximate distance
-- without using sqrt, and does not overflow like pythagoras can
function approx_dist(dx,dy)
    local maskx,masky=dx>>31,dy>>31
    local a0,b0=(dx+maskx)^^maskx,(dy+masky)^^masky
    if a0>b0 then
        return a0*0.9609+b0*0.3984
    end
    return b0*0.9609+a0*0.3984
end

---- VECTORS ----
vec_metatable = {
    __add = function(left, right) 
        return vec(left.x + right.x, left.y + right.y)
    end,
    __sub = function(left, right)
        return vec(left.x - right.x, left.y - right.y)
    end,
    __mul = function(left, right)
        return vec(left.x * right, left.y * right)
    end,
}

function vec(x,y)
    local v = {
        x=x or 0,
        y=y or 0,
    }
    setmetatable(v, vec_metatable)
    return v
end

-- Distance squared for a vector
function vdsq(v)
    return (v.x * v.x + v.y * v.y)
end

-- Return a vector clamped to impose magnitude limit
function vclamp(v, m)
    if vdsq(v) > m * m then
        vd = sqrt(vdsq(v))
        return vec(v.x / vd * m, v.y / vd * m)
    end
    return vec(v.x, v.y)
end

-- Return a normalized vector
function vnorm(v)
    local dist = sqrt(vdsq(v))
    return vec(v.x / dist, v.y / dist)
end

-- Return a unit vector from an angle
function angle2vec(angle)
    return vec(
        cos(angle), -sin(angle)
    )
end

-- Vector dot product
function dot(a,b)
    return a.x * b.x + a.y * b.y
end


---- GAME UTILS ----

function count_hostiles()
    local n = 0
    for e in all(ents) do
        if e.is_enemy then n += 1 end
    end
    return n
end

-- Get the starting UI y coordinate for player 1 or 2.
function player_ui_y(player)
    return (player - 1) * (screen_height + 8)
end

-- Given a player (to determine top or bottom screen)
-- return a point on the screen based on a point in the world.
function mappt(player, point)
    local scale = pow_map_scale()
    local center = vec(64, player_ui_y(player) + screen_halfheight)
    delta = playership.pos * -scale
    return point * scale + delta + center
end

-- Given a player (to determine top or bottom screen)
-- and some polygon points
-- and an offset (based on player pos typically)
-- and a color,
-- draws the polygon
function mappoly(player, points, offset, color)
    local scale = pow_map_scale()
    local y = player_ui_y(player)
    local center = vec(64, y + screen_halfheight)
    color = color or 11
    delta = (offset - playership.pos) * scale
    for i = 1, #points do
        local pt1 = points[i] * scale + delta + center
        local pt2 = points[i % #points + 1] * scale + delta + center
        line(rd(pt1.x), rd(pt1.y), rd(pt2.x), rd(pt2.y), color)
    end
end

-- Does entity a have Line-of-sight to entity b?
function has_los(a, b)
    local p1, p2 = a.pos, b.pos
    local delta = p2 - p1
    local dir = vnorm(delta)
    local dist = sqrt(vdsq(delta * (1/64))) * 64
    for i = 0, flr(dist), 4 do
        local pos = p1 + dir * i
        for e in all(nearby_ents_plus_me(pos)) do
            if e != a and e != b then
                local rad = 1 + e.radius
                local between = e.pos - pos
                if vdsq(between) < rad * rad then
                    return false
                end
            end
        end
    end 
    return true
end

-- Set the current screen for a player
function set_screen(player, screen)
    local oldstate = playership['p'..player..'s']
    if oldstate != nil and playership[oldstate].cleanup != nil then
        playership[oldstate].cleanup(player)
    end
    playership['p'..player..'s'] = screen
    if playership[screen].enter != nil then
        playership[screen].enter(player)
    end
end

-- Has a quantum power core in a given system?
function has_quantum(name) return count(playership.pow[name], 'q') > 0 end

function get_mgun_range() return 20 + 20 * #playership.pow.weapons end

function get_enemy_angles()
    local enemies = {}
    for e in all(ents) do
        if e.is_enemy then
            local delta = e.pos - playership.pos
            if approx_dist(delta.x, delta.y) < get_mgun_range() then
                add(enemies, {angle=atan2(delta.x, -delta.y), enemy=e})
            end
        end
    end
    return enemies
end

-- When we get hit
function player_take_damage(source)
    local delta = source.start - playership.pos
    local ang = atan2(delta.x, -delta.y)
    local sub = angledelta(playership.angle, ang)
    local dir = sub * 4 -- range between -2 and 2
    local dir_index = 1
    if abs(dir) <= 0.5 then dir_index = 1
    elseif dir <= 1.5 and dir > 0.5 then dir_index = 2
    elseif dir >= -1.5 and dir < -0.5 then dir_index = 4
    else dir_index = 3 end
    
    local bounce = false
    local shield_damage = min(playership.shields[dir_index], source.damage)
    if playership.shields[dir_index] > 12 and source.is_laser then
        local l2 = make_laser(playership, source.head, source.from.pos, darken[source.color+1], source.damage)
        add(lasers, l2)
        sfx(23)
        bounce = true
    end
    playership.shields[dir_index] -= shield_damage
    local damage = source.damage - shield_damage
    if damage > 0 then
        playership.hull -= damage
        shake = vnorm(delta) * (damage / 4 + 2)
        shaket = 0
        recolor = palorange
        sfx(17)
        if playership.hull < 25 then sfx(18) end
    else
        shake = vnorm(delta) * 2
        shaket = 0.5
        recolor = palgreen
        if not bounce then sfx(16) end
    end
    damage_dir = dir_index
    if source.from.is_enemy then
        hax_add_symbol(144, source.from)
    end
    if playership.hull < 0 then
        sfx(27)
        playership.dead = true
    end
end

-- Entity "constructor"
function make_ent(x,y)
    local e = {
        pos = vec(x,y),
        vel = vec(),
        hull = 100,
        radius = 2,
        mass = 1,
        dead = false,
        type=nil
    }
    return e
end

-- Screen (MAP, POW, etc.) "constructor"
function make_screen(name, draw_fn, update_fn, enter_fn, cleanup_fn)
    local screen = {
        name = name,
        draw = draw_fn,
        update = update_fn,
        enter = enter_fn,
        cleanup = cleanup_fn
    }
    return screen
end

-- Asteroid "constructor"
function make_asteroid(x, y, rad)
    local a = make_ent(x,y)
    a.points = {}
    a.mass = rad ^ 1.65
    a.radius = rad
    -- Pick some points defining a wobbly circle
    local num_points = rad * 2
    for i = 0,num_points-1 do
        local pt = vec(
            cos(i / num_points) * (rad * (rnd(0.2) + 0.9) + rnd(3)),
            sin(i / num_points) * (rad * (rnd(0.2) + 0.9) + rnd(3))
        )
        add(a.points, pt)
    end
    a.draw = function(player)
        mappoly(player, a.points, a.pos, 7)
    end
    return a
end

-- Return all entities plus player ship
function ents_plus_me()
    local total = {}
    for e in all(ents) do add(total, e) end
    add(total, playership)
    return total
end

---- ENTITY GRID ----
-- The entity grid is a space partitioning system which stores
-- the entities of the world in a regular grid. The point is 
-- so we don't test collisions with every entity, but just entities
-- that are in our grid square or an adjacent grid square.

entgrid = {}
eg_size = 30 -- Size of each grid square
eg_bounds = 8 -- -8 to +8 grid spaces in x and y

function generate_entgrid()
    entgrid = {}
    for i = -eg_bounds, eg_bounds do
        for j = -eg_bounds, eg_bounds do
            entgrid[i..','..j] = {} -- use string keys... lol
        end
    end
    for e in all(ents_plus_me()) do
        local gpx = e.pos.x \ eg_size
        local gpy = e.pos.y \ eg_size
        add(entgrid[gpx..','..gpy], e)
    end
end

-- This returns all entities, plus player ship, in adjacent grid squares
-- from a given position. This is how we use the entgrid.
function nearby_ents_plus_me(pos)
    local gpx = pos.x \ eg_size
    local gpy = pos.y \ eg_size
    
    local ne = {}
    for i = gpx - 1, gpx + 1 do
        for j = gpy - 1, gpy + 1 do
            for e in all(entgrid[i..','..j]) do
                add(ne, e)
            end
        end
    end
    return ne
end

-- Run collision detection
function do_collisions()
    local already_tested = {}
    for a in all(ents_plus_me()) do
        add(already_tested,a)
        -- Look only at nearby entities!
        for b in all(nearby_ents_plus_me(a.pos)) do
            if count(already_tested, b) == 0 then
                local rad = a.radius + b.radius
                local delta = b.pos - a.pos
                local betsq = vdsq(delta)
                -- If we find a collision, we want to bonk both sides away like
                -- pool balls. I just looked up the algorithm for this.
                -- Entity mass is taken into account
                if betsq < rad * rad then
                    local norm = vnorm(delta)
                    local between = sqrt(betsq)
                    mf = b.mass / (a.mass + b.mass)
                    a.pos = a.pos + norm * -1 * ((rad - between) * mf)
                    b.pos = b.pos + norm * ((rad - between) * (1 - mf))
                    local p = 2 * (dot(a.vel, norm) - dot(b.vel, norm)) / (a.mass + b.mass)
                    a.vel = a.vel - norm * p * b.mass
                    b.vel = b.vel + norm * p * a.mass
                    if a.on_collide then a.on_collide(b) end
                    if b.on_collide then b.on_collide(a) end
                end
            end
        end
    end
end

---- Bullets ----
-- from [entity] = the source of the bullet
-- start [vec] = starting pt
-- dir [vec] = normalized direction vector
-- color [int]
-- damage [int]
-- source_label [str] = what do we call this weapon, for the purposes of hax signal
function make_bullet(from, start, dir, color, damage, source_label)
    local b = {
        from=from,
        start=start + dir * from.radius,
        pos=vec(start.x,start.y),
        dir=dir,
        color=color,
        flytime=0,
        time=0,
        --hit = false,
        --done = false,
        source_label = source_label,
        damage = damage
    }
    return b
end

function bullet_draw(player, b)
    local p = mappt(player, b.pos)
    if b.hit then
        circ(p.x, p.y, b.time \ 4, b.color)
    else
        circ(p.x, p.y, 1, b.color)
    end
end

function bullet_update(b)
    local speed = 1.5
    if not b.done then
        b.pos += b.dir * speed
        for e in all(nearby_ents_plus_me(b.pos)) do
            if e != b.from then
                local rad = 1 + e.radius
                local between = e.pos - b.pos
                if vdsq(between) < rad * rad then
                    b.hit = true
                    b.done = true
                    if e.take_damage != nil then e.take_damage(b) end
                end
            end
        end
    end
    if b.done then
        b.time += 1
        if b.time > 15 then
            del(bullets, b)
        end
    else
        b.flytime += 1
        if b.flytime > get_mgun_range() / speed then
            b.done = true
        end
    end
end

---- Lasers ----

function make_laser(from, start, target, color, damage, source_label)
    local off = vnorm(target - start)
    local l = {
        from=from,
        start=start + off * from.radius,
        head=vec(start.x,start.y),
        target=target,
        color=color,
        time=0,
        speed=3 + 1.5 * #playership.pow.weapons,
        flytime = 0,
        i=0,
        is_laser=true,
        --done = false,
        --hit = false,
        source_label = source_label,
        damage = damage
    }
    return l
end

function laser_draw(player, l)
    local delta = l.head - l.start
    -- some hacky bullshit to make the tail end of the laser move too
    local dist = approx_dist(delta.x, delta.y)
    local n = vec(delta.x / dist, delta.y / dist)
    local fwd = clamp((l.flytime - l.damage * 1.5) * l.speed,0, dist)
    local p1 = mappt(player, l.start + n * fwd)
    local p2 = mappt(player, l.head)
    line(p1.x, p1.y, p2.x, p2.y, l.color)
    if l.hit then
        circ(p2.x, p2.y, 1 + l.time \ 4, l.color)
    end
end

function laser_update(l)
    local delta = l.target - l.start
    local dist_total = approx_dist(delta.x, delta.y)
    local step = 1
    l.flytime += 1
    
    if not l.done then
        for i = 1, l.speed, step do
            l.i = min(l.i + step / dist_total, 1)
            l.head = delta * l.i + l.start
            for e in all(nearby_ents_plus_me(l.head)) do
                if e != l.from then
                    local rad = 1 + e.radius
                    if vdsq(e.pos - l.head) < rad * rad then
                        l.done = true
                        l.hit = true
                        if e.take_damage != nil then e.take_damage(l) end
                    end
                end
            end
            if (l.i >= 1) l.done = true
            if (l.done) break
        end
    else
        l.time += 1
        if l.time > 15 then
            del(lasers, l)
        end
    end
end

---- ENEMIES ----
function make_enemy(name,x,y,color)
    local params = split(shiptypes[name],":")
    local pts = split(params[1], ";")
    local parsed_pts = {}
    for pt in all(pts) do
        add(parsed_pts, split(pt, ","))
    end
    local ship = make_ent(x,y)
    ship.is_enemy = true
    ship.angle = rnd()
    ship.radius = params[5]
    ship.target = playership
    ship.shields = {0,0,0,0}
    ship.nav_target = vec()
    ship.ai_state = "idle"
    ship.color = color
    ship.loot = 60 + rnd(100)
    --ship.downloaded = false
    ship.hack_time = 0
    ship.hull = params[2]
    ship.weapon_level = params[3]
    ship.speed_level = params[4]
    ship.notice = ""
    ship.hit_time = 0
    ship.idle_pos = vec(x,y)
    ship.mass = ship.radius ^ 1.5 / 9
    ship.draw = function(player)
        local points = {}
        for pt in all(parsed_pts) do
            add(points,angle2vec(ship.angle + pt[1]) * pt[2])
        end
        mappoly(player, points, ship.pos, ship.color)

        local near = mappt(player,ship.pos) + vec(5,-5)
        if ship.notice then
            print(ship.notice, near.x, near.y, ship.color)
        end
    end
    ship.update = function()
        enemy_update(ship)
    end
    ship.on_collide = function(other)
        ship.nav_target = angle2vec(ship.angle + 0.5) * (10 + rnd(20)) + playership.pos
    end
    ship.take_damage = function(l) 
        ship.hit_time = 30
        sfx(26)
        ship.hull -= l.damage
        ship.notice = ceil(ship.hull)
        if l.source_label == 'a' then
            hax_add_symbol(146, ship)
            playership['p1_hit_enemy_time'] = 10
        elseif l.source_label == 'b' then
            hax_add_symbol(147, ship)
            playership['p2_hit_enemy_time'] = 10
        elseif l.source_label == 'mgun' then
            playership['mgun_hit_enemy_time'] = 10
        end
        if ship.hull <= 0 then
            sfx(27,nil,7)
            ship.dead = true
            del(ents, ship)
        end
    end
    return ship
end

function enemy_update(ship)
    local rotrate = 0.0015 * ship.speed_level
    ship.hit_time -= 1
    if ship.hit_time == 0 then
        ship.notice = ""
    end
    ship.hack_time -= 1
    if ship.hack_time > 0 and tf % 10 == 0 then
        ship.notice = "?"
    elseif ship.hack_time == 0 then
        ship.notice = ""
        ship.target = playership
    end
    local target = ship.target
    if target == nil then ship.state = 'idle' end
    if ship.state == "combat" then
        if tf % 90 == 0 then
            ship.notice = ""
            ship.nav_target = angle2vec(rnd()) * (10 + rnd(20)) + target.pos
        end
    else
        if tf % 240 == 5 then
            ship.nav_target = ship.idle_pos + angle2vec(rnd()) * (10 + rnd(20))
        end
    end
    local delta = ship.nav_target - ship.pos
    local dist = sqrt(vdsq(delta))
    local speed = sqrt(vdsq(ship.vel))
    local thrust = 0
    local vang = atan2(delta.x, -delta.y)
    local tdelt = angledelta(vang, ship.angle)
    local ang1 = ship.angle
    if dist < 20 then
        if speed > 0.1 then
            local vecang = atan2(ship.vel.x, -ship.vel.y)
            local vecdelt = angledelta(vecang, ship.angle)
            
            if abs(vecdelt) < rotrate then
                ship.angle = vang
            elseif vecdelt > 0 then
                ship.angle = ship.angle - rotrate
            else 
                ship.angle = ship.angle + rotrate
            end      

            if abs(tdelt < 0.25) then
                thrust = -1
            elseif abs(tdelt > 0.5) then
                thrust = 1
            end                  
        end
    else
        if abs(tdelt) < rotrate then
            ship.angle = vang
        elseif tdelt > 0 then
            ship.angle = ship.angle - rotrate
        else 
            ship.angle = ship.angle + rotrate
        end
        if abs(tdelt < 0.125) then
            thrust = 1
        elseif abs(tdelt > 0.5) then
            thrust = -1
        end        
    end
    

    ship.vel += angle2vec(ship.angle) * thrust * 0.003 * ship.speed_level
    ship.vel = vclamp(ship.vel, 0.1 * ship.speed_level)

    if tf % 200 == 0 and has_quantum('sensors') then
        hax_add_symbol(149, ship)
    end

    player_delta = playership.pos - ship.pos
    if approx_dist(player_delta.x, player_delta.y) < 30 and tf % 90 == 0 then
        hax_add_symbol(145, ship)
    end    

    if target != nil then
        attack_delta = target.pos - ship.pos
        local theta = atan2(attack_delta.x, -attack_delta.y)
        local dist = approx_dist(attack_delta.x, attack_delta.y)

        if ship.state == "combat" then
            if (tf % (60 \ (ship.weapon_level + 1))) == 0 and rnd(1) < 0.33 and has_los(ship, target) and dist < (20 * ship.weapon_level) + 10 then
                if rnd(1) < 0.8 then
                    theta += (rnd(1) - 0.5) * 0.05
                else
                    theta += (rnd(1) - 0.5) * 0.25
                end
                local ldist = dist * ((rnd(1) - 0.5) * 0.25 + 1.25)
                local dmg = flr(rnd(7)) + 5
                add(lasers,make_laser(ship, ship.pos, ship.pos + angle2vec(theta) * ldist, ship.color, dmg))
                hax_add_symbol(143, ship)
                sfx(24, nil, 9 - min(dmg\1.5,9))
            end
            if dist > 110 then
                ship.state = "idle"
                ship.idle_pos = vec(ship.pos.x, ship.pos.y)
            end
        else
            if dist < 60 then
                ship.state = "combat"
                ship.notice = "!"
            end
        end
    end

end

-------- HAL ---------
function make_hal_control()
    local screen = make_screen('hal', hal_draw, hal_update)
    return screen
end

function hal_draw(player)
    local y = player_ui_y(player)
    spr(192, 48, y + 2, 4, 3)
    spr(196, 48, y + 34, 4, 3)
    spr(200, 2, y + 18, 4, 3)
    spr(204, 94, y + 18, 4, 3)
    rectfill(59,25 + y,68,34 + y,0)
    rect(58,24 + y,69,35 + y,7)
    spr(75 + player, 60,26 + y)
end

function hal_update(player)
    local ss = {'wep','hax','map','pow'}
    for i = 1,4 do
        if btnp(i-1, player-1) then
            set_screen(player, ss[i])
        end
    end
end

-------- MAP ---------
function make_map_control()
    local screen = make_screen('map', map_draw, map_update)
    screen.p1steer = 0
    screen.p2steer = 0
    screen.p1thrust = 0
    screen.p2thrust = 0
    screen.blink = 0
    return screen
end

function map_draw(player)
    local y = player_ui_y(player)
    rectfill(0, y, 127, screen_height + y - 1, 3)

    local scale = pow_map_scale()

    -- Draw background grid
    local gs = 40
    local gx1 = ((playership.pos.x - 64 / scale) \ gs) * gs
    local gy1 = ((playership.pos.y - 32 / scale) \ gs) * gs
    fillp(0b0011001111001100.1)
    for i = 1, (8 \ scale) do
        local gp = mappt(player, vec(gx1 + i * gs, 0))
        line(gp.x, y, gp.x, y + screen_height, 2)
    end
    for i = 1, (5 \ scale) do
        local gp = mappt(player, vec(0, gy1 + i * gs))
        line(0, gp.y, 127, gp.y, 2)
    end    
    fillp()

    -- Draw space objects
    for e in all(ents) do
        e.draw(player)
    end

    local wp1, wp2 = mappt(player, vec(-walls, -walls)), mappt(player, vec(walls, walls))
    line(wp1.x, wp1.y, wp2.x, wp1.y, 1)
    line(wp1.x, wp1.y, wp1.x, wp2.y, 1)
    line(wp2.x, wp1.y, wp2.x, wp2.y, 1)
    line(wp1.x, wp2.y, wp2.x, wp2.y, 1)

    -- Draw our ship
    local sp = {
        vec(cos(0 + playership.angle) * 5.5, -sin(0 + playership.angle) * 5.5),
        vec(cos(0.625 + playership.angle) * 3.5, -sin(0.625 + playership.angle) * 3.5),
        vec(cos(0.375 + playership.angle) * 3.5, -sin(0.375 + playership.angle) * 3.5),
    }
    mappoly(player, sp, playership.pos)

    foreach(lasers, function(l) laser_draw(player, l) end)
    foreach(bullets, function(b) bullet_draw(player, b) end)

    -- Draw thrust/steer arrows
    function map_draw_ship_line(angle, p)
            line(
                64 + cos(angle + playership.angle) * 6,
                screen_halfheight + y + -sin(angle + playership.angle) * 6,
                64 + cos(angle + playership.angle) * 12,
                screen_halfheight + y + -sin(angle + playership.angle) * 12,
                playercolors[p]
            )   
    end
    for p = 1,2 do
        if playership.map['p'..p..'steer'] < 0 then
            map_draw_ship_line(0.75, p)
        end
        if playership.map['p'..p..'steer'] > 0 then
            map_draw_ship_line(0.25, p)
        end
        if playership.map['p'..p..'thrust'] < 0 then
            map_draw_ship_line(0.5, p)    
        end
        if playership.map['p'..p..'thrust'] > 0 then
            map_draw_ship_line(0, p)       
        end           
    end

    -- Draw velocity
    if (playership.vel.x > 0) xo = -1 else xo = 1
    if (playership.vel.y > 0) yo = -1 else yo = 1
    local factor = 6 / (maxspeed * pow_engines_thrust())
    line(120, 7 + y, rd(120 + playership.vel.x * factor), 7 + y, 7)
    if (abs(playership.vel.x) > maxspeed / 2) then
        line(rd(120 + playership.vel.x * factor + xo), 6 + y, rd(120 + playership.vel.x * factor + xo), 8 + y, 7)
    end
    line(120, 7 + y, 120, rd(7 + y + playership.vel.y * factor), 7)
    if (abs(playership.vel.y) > maxspeed / 2) then
        line(119, rd(7 + y + playership.vel.y * factor + yo), 121, rd(7 + y + playership.vel.y * factor + yo), 7)
    end

    -- Draw speed number
    local speed = sqrt(vdsq(playership.vel))
    speed = rd(speed * 1000)
    print(speed, 114, y + screen_height - 8, 7)

    -- Draw scale circle
    local num_points = 12
    for i = 0, num_points-1 do
        --local pxo = cos(i / num_points + playership.angle)
        --local pyo = -sin(i / num_points + playership.angle)
        local pxo = cos(i / num_points - 0.25)
        local pyo = -sin(i / num_points - 0.25)
        local px = pxo * 30 * scale + 64
        local py = pyo * 30 * scale + y + screen_halfheight
        pset(px, py, 6)
        if (i / num_points * 4) % 1 == 0 then
            local ptx = pxo * 25 + 64
            local pty = pyo * 25 + y + screen_halfheight
            spr(i \ 3, ptx - 4, pty - 4)
        end
    end

    if has_quantum("engines") then
        local color = 6
        if playership.map.blink < 0 then color = 10 end
        print("blink", 2, y + screen_height - 7, 5)
        print(sub("blink",0,5-playership.map.blink\20), 2, y + screen_height - 7, color)
    end
end

function map_update(player)
    local map = playership.map
    psteer = 'p'..player..'steer'
    pthrust = 'p'..player..'thrust'
    if btn(0, player-1) then
        map[psteer] = -1
        sfx(21,2)
    elseif btn(1, player-1) then
        map[psteer] = 1
        sfx(21,2)
    else
        map[psteer] = 0
    end
    if btn(3, player-1) then
        map[pthrust] = -1
    elseif btn(2, player-1) then
        map[pthrust] = 1
    else
        map[pthrust] = 0
    end

    if btnp(4,player-1) then
        set_screen(player, 'hal')
    end    

    if btnp(5, player-1) and has_quantum('engines') and map.blink <= 0 then
        local nv = angle2vec(playership.angle)
        local final = playership.pos * 1
        local i = 0
        while i < 10 do
            i += 1
            local tp = playership.pos + nv * i * 5
            for e in all(nearby_ents_plus_me(tp)) do
                if e != playership then
                    local delta = tp - e.pos
                    if approx_dist(delta.x, delta.y) < (e.radius + 3) then
                        i = 11
                        break
                    else
                        final = tp
                    end
                end
            end 
        end
        playership.pos = final
        map.blink = 120
    end
end

-------- POW ---------
function make_pow_control()
    local screen = make_screen('pow', pow_draw, pow_update, pow_enter, nil)
    screen.reserve = {} -- power code
    for i = 1,persistent.bonus_cores do add(screen.reserve, 'n') end
    for i = 1,persistent.bonus_quantum do add(screen.reserve, 'q') end
    screen.weapons = {'n'}
    screen.shields = {'n'}
    screen.sensors = {'n','n','n','n','n'}
    screen.engines = {'n'}
    return screen
end

function pow_engines_thrust()
    local num = #playership.pow.engines
    if(num == 0) return 0
    return num
end

function pow_map_scale()
    local num = #playership.pow.sensors
    return 3 / (num * 1.5 + 0.7)
end

function pow_enter(player)
    playership.pow['p'..player..'row'] = 0
    playership.pow['p'..player..'col'] = 0
    playership.pow['p'..player..'pickup'] = nil
end

function pow_draw(player)
    local y = player_ui_y(player)
    rectfill(0, y, 127, screen_height + y - 1, 5)
    local pow = playership.pow
    local pickup = pow['p'..player..'pickup']

    function pow_rctoxy(r,c)
        cx = c * 8 + 45
        cy = r * 12 + 2 + y
        return vec(cx,cy)
    end

    for i = 1,#powrows do
        local name = powrows[i]
        local ry = y + (i-1) * 12 + 3
        print(name, 16, ry+1, 7)
        if i > 1 then spr(24 + i, 4, ry-1) end
        for j = 1, powcaps[i] do
            spr(9, 37 + j * 8, ry - 1)
        end
        for j = 1, #playership.pow[name] do
            if pickup != nil and pickup.x == j-1 and pickup.y == i-1 then        
                spr(7 + flr((tf / 7) % 2), 37 + j * 8, ry - 1)
            else
                local value = playership.pow[name][j]
                local si = 6
                if value == 'q' then
                    si = 22 + (tf / 10) % 4
                elseif value == 'd' then
                    si = 40 + (tf / 4) % 4
                end 
                spr(si, 37 + j * 8, ry - 1)
            end
        end
    end

    local pow = playership.pow
    for p = 1,2 do
        if pow['p'..p..'row'] != nil then
            local r,c = pow['p'..p..'row'], pow['p'..p..'col']
            pos = pow_rctoxy(r,c)
            spr(3 + p + (16 * flr((tf  \ 7) % 2)), pos.x, pos.y)
            if p == player then
                if pow['p'..p..'pickup'] != nil then
                    spr(7 + flr((tf \ 7) % 2), pos.x, pos.y)
                end
            end
        end
    end
end

function pow_update(player)
    local pow = playership.pow
    local pcol = 'p'..player..'col'
    local prow = 'p'..player..'row'
    local pickup = 'p'..player..'pickup'
    if btnp(0, player-1) then
        pow[pcol] -= 1
    end
    if btnp(1, player-1) then
        pow[pcol] += 1
    end
    if btnp(2, player-1) then
        pow[prow] -= 1
    end    
    if btnp(3, player-1) then
        pow[prow] += 1
    end        
    pow[prow] = clamp(pow[prow], 0, 4)
    pow[pcol] = clamp(pow[pcol], 0, powcaps[pow[prow]+1]-1)
    local r = pow[prow]
    local c = pow[pcol]
    local pick = pow[pickup]
    if pick == nil then
        if btnp(5, player-1) then
            local num = #pow[powrows[r+1]]
            if c < num then
                pow[pickup] = vec(c, r)
                sfx(22)
            end
        end
    else
        if btnp(5, player-1) then
            if #pow[powrows[r+1]] < powcaps[r+1] then
                local pick = pow[pickup]
                add(pow[powrows[r+1]], pow[powrows[pick.y + 1]][pick.x + 1])
                deli(pow[powrows[pick.y + 1]], pick.x + 1)
                pow[pickup] = nil
                sfx(22)
            end
        end
    end

    if btnp(4,player-1) then
        set_screen(player, 'hal')
    end
end

-------- WEP ---------
function make_wep_control()
    local screen = make_screen('wep', wep_draw, wep_update, wep_enter)
    screen.phaser1angle = 0
    screen.phaser1heat = 0
    screen.phaser1pressed = false
    screen.phaser2angle = 0
    screen.phaser2heat = 0
    screen.phaser2pressed = false
    screen.mgunheat = 0
    screen.mgunlock = nil
    screen.mgunangle = 0
    return screen
end

function wep_enter(player)
    playership.wep['p'..player..'row'] = 0
end

function wep_draw(player)
    local y = player_ui_y(player)
    rectfill(0, y, 127, screen_height + y - 1, 2)    
    -- could remove...
    if #playership.pow.weapons == 0 then
        print("unpowered", 46, y + screen_halfheight - 2, 6)
        return
    end
    local rows = {4, 22, 40}
    local labelx = {86, 5, 86}
    local labels = {'phaser a', 'phaser b', 'mgun'}
    rectfill(84, 4 + y, 119, 22 + y, 1)
    rectfill(3, 22+y, 38, 40 + y, 1)
    rectfill(84, 40 + y, 119, 59 + y, 1)

    print("hit", 20, 10 + y, 2 + max(playership.p1_hit_enemy_time))
    print("hit", 94, 28 + y, 2 + max(playership.p2_hit_enemy_time))
    print("hit", 20, 46 + y, 2 + max(playership.mgun_hit_enemy_time))

    palt(0, false)
    palt(11, true)
    spr(64, 40, rows[1] + y, 6, 2)
    spr(64, 40, rows[2] + y, 6, 2)
    spr(70, 40, rows[3] + y, 6, 2)
    palt(0, true)
    palt(11, false)
    for p = 1,2 do
        if playership.wep['p'..p..'row'] != nil then
            local sy = rows[playership.wep['p'..p..'row'] + 1]+y
            rect(39,sy,83,16+sy, playercolors[p])
        end
    end
    for i = 1,3 do 
        print(labels[i], labelx[i], rows[i] + 2 + y, 7)
    end
    for i = 1,2 do
        local ang = playership.wep['phaser'..i..'angle']
        local clk = flr(ang * 12)
        clip(42, rows[i] + y + 2, 28, 14)
        if has_quantum("weapons") then
            for t in all(get_enemy_angles()) do
                local x = angledelta(ang - 0.25, t.angle) * 200 + 57
                circfill(x, rows[i] + 8 + y, 2, 8)
            end
        end
        for t = clk-1, clk+1 do
            local ta = t / 12
            local x = angledelta(ang, ta) * 200 + 57
            line(x, rows[i] + 10 + y, x, rows[i] + 12 + y, 6)
            local xo = 1
            if t < 1 then t += 12 end
            if t > 9 then xo = 3 end
            print(t, x - xo, rows[i] + 4 + y, 6)
        end
        spr(14, 53, rows[i]+y+5)
        clip()
        if playership.wep['phaser'..i..'pressed'] then
            spr(96, 73, rows[i] + y + 4, 1, 2) 
        end 
        local heatkey = 'phaser'..i..'heat'
        rect(labelx[i], rows[i] + 10 + y, labelx[i] + 31, rows[i] + 14 + y + 2, 7)
        rectfill(labelx[i] + 2, rows[i] + 12 + y, labelx[i] + 2 + playership.wep[heatkey] * 28, rows[i] + 14 + y, 6)
        if playership.wep[heatkey] > 0.5 then
            rectfill(labelx[i] + 16, rows[i] + 12 + y, labelx[i] + 2 + playership.wep[heatkey] * 28, rows[i] + 14 + y, 8)
        end        
    end

    enemy_angles = get_enemy_angles()
    local cx, cy = 51, 48 + y
    for e in all(enemy_angles) do
        circfill(cx + cos(e.angle) * 5, cy - sin(e.angle) * 5, 2, 5)
        circfill(cx + cos(e.angle) * 5, cy - sin(e.angle) * 5, 1, e.enemy.color)
    end
    
    if playership.wep.mgunlock != nil then
        pal(7, playership.wep.mgunlock.color)
        spr(98, 68, 45 + y)
        pal()
    else
        spr(97, 68, 45 + y)
        circfill(cx + cos(playership.wep.mgunangle) * 5, cy - sin(playership.wep.mgunangle) * 5, 1, 11)
    end

    rect(86, 50 + y, 117, 56 + y, 7)
    rectfill(88, 52 + y, 88 + playership.wep['mgunheat'] * 28, 54 + y, 6)
    if playership.wep['mgunheat'] > 0.5 then
        rectfill(102, 52 + y, 88 + playership.wep['mgunheat'] * 28, 54 + y, 6)
    end  

end

function wep_update(player)
    if #playership.pow.weapons > 0 then
        if btnp(2,player-1) then
            playership.wep['p'..player..'row'] = (playership.wep['p'..player..'row'] - 1) % 3
        end
        if btnp(3,player-1) then
            playership.wep['p'..player..'row'] = (playership.wep['p'..player..'row'] + 1) % 3
        end    
        local row = playership.wep['p'..player..'row'] + 1
        if row < 3 then -- phasers
            if btn(0, player-1) then
                playership.wep['phaser'..row..'angle'] -= 0.01
            end
            if btn(1, player-1) then
                playership.wep['phaser'..row..'angle'] += 0.01
            end
            playership.wep['phaser'..row..'angle'] = playership.wep['phaser'..row..'angle'] % 1
            if btn(5, player-1) then
                playership.wep['phaser'..row..'pressed'] = true
            else
                playership.wep['phaser'..row..'pressed'] = false
            end 
            if btnp(5, player-1) then
                if playership.wep['phaser'..row..'heat'] < 0.8 then
                    playership.wep['phaser'..row..'heat'] += 0.2
                    local dist = (#playership.pow.weapons * 30 + 20)
                    --local target = angle2vec(playership.wep['phaser'..row..'angle'] + playership.angle) * dist + playership.pos
                    local target = angle2vec(playership.wep['phaser'..row..'angle'] - 0.25) * dist + playership.pos
                    local pn = {'a','b'}
                    local dmg = rnd(3) + 1 + #playership.pow.weapons * 2
                    add(lasers, make_laser(playership, playership.pos, target, 11, dmg, pn[row]))
                    sfx(25, nil, 9 - min(dmg\1.5,9))
                end
            end       
        end
        if row == 3 then
            if btnp(5, player-1) then
                if playership.wep.mgunlock == nil then
                    enemy_angles = get_enemy_angles()
                    for e in all(enemy_angles) do
                        if abs(angledelta(e.angle, playership.wep.mgunangle)) < 0.035 then
                            playership.wep.mgunlock = e.enemy
                            hax_add_symbol(148, e.enemy)
                            break
                        end
                    end
                else
                    playership.wep.mgunlock = nil
                end
            end
        end
    end
    if btnp(4,player-1) then
        set_screen(player, 'hal')
    end    
end

-------- HAX ---------

hax_btns = {'target','loot','virus','download','repair'}
--[[
    target - aim a random weapon (lock mgun possibly)
    loot - take 1/3 of remaining loot
    virus - force target an enemy for a while
    download - get an orb
    repair - gain 50 hull
]]--

function hax_get_random_symbol()
    return {symbol=flr(rnd(11)) + 128, color=6, ship=nil}
end

function make_hax_control()
    local screen = make_screen('hax', hax_draw, hax_update, hax_enter)
    screen.times = {0,-10,-20,-30,-40,-50,-60}
    screen.next = {nil,nil,nil,nil,nil}
    screen.grid = {{},{},{},{},{},{}}
    screen.locked = {}
    for i = 1,6 do
        for j = 1,6 do
            add(screen.grid[i], hax_get_random_symbol())
        end
        screen.next[i] = hax_get_random_symbol()
    end
    return screen
end

function hax_draw(player)
    y = player_ui_y(player)
    local hax = playership.hax
    for i = 1,6 do
        for j = 1,7 do
            local s = hax.grid[i][j]
            if s != nil then
                local lerp = 0
                if hax.times[i] >= 0 then lerp = cos(1 - hax.times[i] / 32) * 9 end
                pal(7,s.color)
                spr(s.symbol, i * 9 + 8, j * 9 + y - 6 - lerp)
            end
        end
    end
    pal()
    for i = 1,2 do
        local pc = hax['p'..i..'c']
        if pc != nil then
            if pc.x < 7 then
                spr(3 + i, pc.x * 9 + 8, pc.y * 9 + y - 6)
            end
        end
    end

    local sy = 6
    rectfill(2, 9 + y, 13, y + 57, 5)
    if #hax.locked > 0 then
        rect(2, 9 + y, 13, y + 57, hax.locked[1].color)
    end
    for s in all(hax.locked) do
        pal(7, s.color)
        spr(s.symbol, 4, sy + y + 6)
        sy += 9
    end
    pal()

    local pp = hax['p'..player..'c']
    for i = 1, 5 do 
        local name = hax_btns[i]
        local c = 5
        if #(hax.locked) >= i then c = 7 end
        if pp.x == 7 and pp.y == i and c==7 then c = playercolors[player] end
        print(i, 78, i * 11 + y - 5, c)
        print(name, 90 - #name \ 2, i * 11 + y - 5, c)
        if pp.x == 7 and pp.y == i then
            pal(11, playercolors[player])
            spr(15, 74, i * 11 + y - 7)
            pal()
        end
    end
end

function hax_update(player)
    local hax = playership.hax
    local pc = hax['p'..player..'c']
    if btnp(0, player-1) then pc.x -= 1 end
    if btnp(1, player-1) then pc.x += 1 end
    if btnp(2, player-1) then pc.y -= 1 end
    if btnp(3, player-1) then pc.y += 1 end
    pc.x = clamp(pc.x, 1, 7)
    pc.y = clamp(pc.y, 1, 6)
    if pc.x == 7 then pc.y = clamp(pc.y, 1, 5) end

    if btnp(5, player-1) then
        if pc.x < 7 then
            local yo = 0
            if hax.times[pc.x] > 0 then
                yo = -1
            end
            local py = max(pc.y + yo,1)
            local s = hax.grid[pc.x][py]
            if s.ship != nil then
                hax_lock_symbol(s,vec(pc.x,py))
            end
        else
            if #(hax.locked) >= pc.y then
                
                local ship = hax.locked[1].ship
                if pc.y == 1 then
                    local d = ship.pos - playership.pos
                    local ang = (atan2(d.x, -d.y) + 0.25) % 1
                    for i = 1,2 do
                        playership.wep['phaser'..i..'angle'] = ang
                    end
                    playership.wep.mgunlock = ship
                    --set_screen(player, "wep")
                elseif pc.y == 2 then
                    local l = ship.loot \ 3
                    playership.loot += l
                    ship.loot -= l
                elseif pc.y == 3 then
                    local hostiles = {}
                    for e in all(ents) do
                        if e.is_enemy and e != ship then
                            add(hostiles, e)
                        end
                    end
                    ship.target = nil
                    if #hostiles > 0 then
                        ship.target = hostiles[flr(rnd(#hostiles))+1]
                    end
                    ship.hack_time = 450
                elseif pc.y == 4 then
                    if ship.downloaded then sfx(30); return end
                    add(playership.pow.reserve, 'd')
                    ship.downloaded = true
                elseif pc.y == 5 then
                    playership.hull = min(playership.hull + 50, 100)
                end
                for i = 1,pc.y do
                    deli(hax.locked, flr(rnd(#hax.locked))+1)
                end
                sfx(29)
            end
        end
    end

    if btnp(4, player-1) then 
        set_screen(player, 'hal')
    end

end

function hax_enter(player)
    playership.hax['p'..player..'c'] = vec(1,1)
end

function hax_lock_symbol(s,pos)
    local hax = playership.hax
    for s2 in all(hax.locked) do
        if s.ship != s2.ship then
            hax.locked = {s}
            hax.grid[pos.x][pos.y] = hax_get_random_symbol()
            return
        else
            if s.symbol == s2.symbol then
                return
            end
        end
    end
    hax.grid[pos.x][pos.y] = hax_get_random_symbol()
    add(hax.locked, s)
    sfx(31)
end

function hax_symbols_update()
    local hax = playership.hax
    if #hax.locked > 0 and hax.locked[1].ship.dead then hax.locked = {} end
    for i = 1, 6 do
        hax.times[i] += 1
        local ht = hax.times[i]
        if ht == 0 then
            add(hax.grid[i], hax.next[i], 1)
            hax.next[i] = hax_get_random_symbol()
        end
        if ht == 8 then
            deli(hax.grid[i],7)
            hax.times[i] = -75 + flr(rnd(10))
        end
    end
end

function hax_add_symbol(name, ship)
    local hax = playership.hax
    local col = flr(rnd(6)+1)
    local s = {symbol=name, ship=ship, color=ship.color}
    hax.grid[col][1] = s
    hax.times[col] = max(hax.times[col],-1)
    playership.last_symbol = s
    playership.last_symbol_time = 0
end

-------- PICO-8 builtins ---------
started = false
function _init()
    music(0, 1000, 12)
    --init_level()

end

function _update()
    if not started then
        if btnp(4,0) or btnp(4,1) then
            started = true
            init_level()
        end
        return
    end
    -- Regenerate the entity grid space partitioning
    generate_entgrid()

    -- Move the player ship based on map controls
    local map = playership.map
    local steer = min(max(map['p1steer'] + map['p2steer'], -1),1)
    local thrust = min(max(map['p1thrust'] + map['p2thrust'], -1), 1)
    if thrust * pow_engines_thrust() != 0 then
        sfx(20,1)
    else
        sfx(-1,1)
    end    
    playership.angle += steer * rotspeed
    local direction = vec(
        cos(playership.angle),
        -sin(playership.angle)
    )
    playership.vel += direction * thrust * accel * pow_engines_thrust() ^ 1.35
    playership.vel = vclamp(playership.vel, maxspeed * pow_engines_thrust())

    -- Update all entities
    for e in all(ents_plus_me()) do
        if(e.update) e.update(e)
    end

    do_collisions()
    
    -- Bounce off boundary walls
    for e in all(ents_plus_me()) do
        if e.pos.x < -walls then e.vel.x = abs(e.vel.x) end
        if e.pos.x > walls then e.vel.x = -abs(e.vel.x) end
        if e.pos.y < -walls then e.vel.y = abs(e.vel.y) end
        if e.pos.y > walls then e.vel.y = -abs(e.vel.y) end        
        e.pos += e.vel
    end

    -- Projectiles
    foreach(lasers, laser_update)
    foreach(bullets, bullet_update)

    -- Scroll HAX feed
    hax_symbols_update()

    -- Update the screens for each player
    playership[playership.p1s].update(1)
    playership[playership.p2s].update(2)

    -- Update weapons... heat, machinegun targeting
    local wep = playership.wep
    wep.phaser1heat = max(wep.phaser1heat - 0.002 * (1 + #playership.pow.reserve), 0)
    wep.phaser2heat = max(wep.phaser2heat - 0.002 * (1 + #playership.pow.reserve), 0)
    wep.mgunangle += (sin(tf / 100) + 1) / 30
    if wep.mgunlock != nil and tf % 23 == 0 and wep.mgunheat < 0.925 then
        local delta = wep.mgunlock.pos - playership.pos
        local dir = vnorm(delta)
        if vdsq(delta) > get_mgun_range() ^ 2 or not has_los(playership, wep.mgunlock) or wep.mgunlock.dead then
            wep.mgunlock = nil
        else
            local leading = vnorm(wep.mgunlock.pos + wep.mgunlock.vel * (sqrt(vdsq(delta)) / 1.5) - playership.pos)
            add(bullets, make_bullet(playership, playership.pos, leading, 7, 1 + 0.33 * #playership.pow.weapons, 'mgun'))
            wep.mgunheat += 0.075
            sfx(28,nil,flr(rnd(3)), flr(rnd(3) + 3))
        end
    end
    wep.mgunheat = max(wep.mgunheat - 0.001 * (1 + #playership.pow.reserve), 0)

    -- Update shields
    local maxs = 12
    if has_quantum("shields") then maxs = 15 end
    if #playership.pow.shields > 0 and tf % (240 \ (#playership.pow.shields+1)) == 0 then
        for i = 1,4 do
            playership.shields[i] += 1
        end
    end
    for i = 1,4 do
        playership.shields[i] = min(playership.shields[i], maxs)
    end    

    playership.map.blink -= 1
    playership.p1_hit_enemy_time -= 1
    playership.p2_hit_enemy_time -= 1
    playership.mgun_hit_enemy_time -= 1

    if playership.dead then
        playership.dead_time += 1
    end

    tf += 1    
end

function _draw()
    reset()
    cls()
    for i = 1,2 do
        rect(0, player_ui_y(i), 127, player_ui_y(i) + screen_height-1, playercolors[i])   
    end 

    if not started then
        for i = 1,2 do
            spr(75 + i, 60, 18 + player_ui_y(i))
            print("press z to start", 32, 32 + player_ui_y(i), 6)
        end   
        rectfill(30, 55, 95, 72, 0)
        spr(160, 32, 56, 8, 2)   
        return
    end    
    
    -- Shake (messes with camera)
    shaket += 1 / vdsq(shake)

    if shaket < 1 then
        camera(shake.x * bounce(shaket),shake.y * bounce(shaket))
    end

    -- Player screens
    for i = 1,2 do
        --if playership.dead then camera(-playership.dead_time * 10, 0) end
        clip(1, player_ui_y(i)+1, 126, 58)
        playership[playership['p'..i..'s']].draw(i)
        --rect(0, player_ui_y(i), 127, player_ui_y(i) + screen_height-1, playercolors[i])
        rectfill(1,player_ui_y(i) + 1,12,player_ui_y(i) + 1 + 6,playercolors[i])
        print(playership['p'..i..'s'], 1, player_ui_y(i) + 2, 7)
    end

    -- Status bar
    clip()
    if not playership.dead then
        print("SHIELDS:   HULL:    LOOT:", 0, screen_height + 1, 7)
        print(flr(playership.hull), 64, screen_height + 2, 8 + (playership.hull \ 25.1))
        print("$"..flr(playership.loot), 100, screen_height + 2, 10)
        for i = 1,4 do
            local clr = min(8 + (playership.shields[i] \ 3.1),12)
            if playership.shields[i] > 0 then
                pal(11,clr,0)
                spr(9 + i, 31, screen_height)
            end
        end
        local sym = playership.last_symbol
        if sym then
            playership.last_symbol_time += 1
            if playership.last_symbol_time < 3 then
                pal(7,7)
            elseif playership.last_symbol_time < 22 then
                pal(7,sym.color)
            else
                pal(7, 0)
            end
            spr(sym.symbol, 120, screen_height)
        end
        pal()

    end

    -- Palette recoloring
    if shaket < 1 then
        pal(recolor,1)
    end
    if shaket < 4 then
        local col = 11
        if recolor == palorange then col = 9 end

        -- Which direction is damage coming from
        if tf % 4 < 2 then
            if damage_dir == 1 then rectfill(0,0,127,7,col) end
            if damage_dir == 2 then rectfill(120,0,127,127,col) end
            if damage_dir == 3 then rectfill(0,120,127,127,col) end
            if damage_dir == 4 then rectfill(0,0,7,127,col) end
        end
    end

    if playership.dead then
        msg = "you died"
        if playership.dead_time > 30 then cls() end
        print(sub(msg, 0, playership.dead_time \ 8), 64 - #msg * 2, 60, 8)
    end

    if count_hostiles() == 0 then
        cls()
        
        if win_time == 0 then
            msg = "level "..level.." complete!\n\nloot:$"..persistent.loot.."\nbought "..bought.." power cores: -$"..(bought*100)
            if level >= 5 then msg = "victory!\n\nthank you for playing\n\ngame by morganquirk" end
            persistent.loot += playership.loot
            bought = persistent.loot \ 100
            persistent.loot -= bought * 100
            persistent.bonus_cores += bought
            if level == 2 or level == 4 then
                persistent.bonus_quantum += 1
                msg = msg.."\nyou found a rare artifact:\n+1 quantum core"
            end
        end
        win_time += 1
        
        for i = 1,2 do
            rect(0, player_ui_y(i), 127, player_ui_y(i) + screen_height-1, playercolors[i])
            print(sub(msg, 0, win_time \ 2), 4, 4 + player_ui_y(i), 11)
        end
        
        if win_time > (240 + #msg\2) and level < 5 then level += 1; init_level() end
    end
end
__gfx__
0030330000033300000300000003330088000088cc0000cc0000000000000000000000000dddddd0000000000000000000000000000000000000000000000000
0363663000366630003630000036663080000008c000000c00ccc3000077770000666600dddddddd00bbbb000000000000000000000000000000000000000000
0363336300033630003633300036363000000000000000000c77cc100770077006600660dddddddd000bb000000000b0000000000b00000000000000b0000000
0363363000366630003666300036663000000000000000000c7ccc300700007006000060dddddddd0000000000000bb0000000000bb0000000000000bb000000
0363633000033630003636300003363000000000000000000ccccc100700007006000060dddddddd0000000000000bb0000000000bb0000000000000bbb00000
03636663003666300036663000003630000000000000000003ccc3100770077006600660dddddddd00000000000000b0000bb0000b000000000bb000bb000000
0030333000033300000333000000030080000008c000000c001311000077770000666600dddddddd000000000000000000bbbb0000000000000bb000b0000000
0000000000000000000000000000000088000088cc0000cc0000000000000000000000000dddddd00000000000000000000000000000000000bbbb0000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000777700000000000000000000000000
00000000000000000000000000000000088008800cc00cc000aaa900009a990000aaa90000a7aa000000000000bbbb0007115570000000000000000000000000
00000000000000000000000000000000080000800c0000c00a77aa9009aaa9900a77aa900a777aa0070787000b0bb0b070155b67008990d60000000000000000
0000000000000000000000000000000000000000000000000a7aaa900aaaaa900a7aaa9007777a90076787700bb00bb0700566678999aa670000000000000000
0000000000000000000000000000000000000000000000000aaaaa9009aaa9900aaaaa900a77aaa0066626600bb00bb0700777778999aad60000000000000000
00000000000000000000000000000000080000800c0000c009aaa990099a999009aaa9900aaaaa90060626000b0bb0b070000007008990dd0000000000000000
00000000000000000000000000000000088008800cc00cc000999900009999000099990000a9a9000000000000bbbb0007000070000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000777700000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000bbb30000b7730000bbb30000bbb30000bbb30000bbb30000000000000000000000000000000000
0000000000000000000000000000000000000000000000000bb77b100b7bb7100b7bb7300bb7b7300b7bbb6007bbbb6000000000000000000000000000000000
0000000000000000000000000000000000000000000000000b7bb7300bbbb7300b7b7b6007b7b73007b7bb600b7bb73000000000000000000000000000000000
0000000000000000000000000000000000000000000000000b7777100b7777100b7b7b6007b7b73007b7bb600b7bb73000000000000000000000000000000000
0000000000000000000000000000000000000000000000000377761003777610037bb63003b7b730037bbb6006bbbb6000000000000000000000000000000000
00000000000000000000000000000000000000000000000000131100001311000033330000333300003333000033330000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7777777777777777777777777777777777777777777bbbbb7777777777777777777777777777777777777777777bbbbb22288882111cc1110000000000000000
6666666666666666666666666666666666666666666bbbbb6666666666666666666666666666666666666666666bbbbb228ff88811cccc110000000000000000
6222222222222222222222222222222666666666666bbbbb6666666600000066666666666622222222222266666bbbbb28ffff88144999410000000000000000
6299999999999999999999999999992666666666666bbbbb666666604444440666666666662aaaaaaaaaa266666bbbbb283f3f82149090110000000000000000
6244444444444444444444444444442666688886666bbbbb6666660446666440666666666624444444444266666bbbbb22fffff2119444110000000000000000
6244444444444444444444444444442666888888666bbbbb6666604466666644066666666624444444444266666bbbbb22f8ff22114494110000000000000000
62444444444444444444444444444426688e8e88866bbbbb6666604666666664066666666624444444444266666bbbbb222ff222111441110000000000000000
624444444444444444444444444444266888e8e8866bbbbb6666644666666664466666666624444444444266666bbbbb22565522117777110000000000000000
62444444444444444444444444444426688e8e88866bbbbb6666644666666664466666666624444444444266666bbbbb00000000000000000000000000000000
624444444444444444444444444444266888e8e8866bbbbb6666644766666674466666666624444444444266666bbbbb00000000000000000000000000000000
6244444444444444444444444444442662888888266bbbbb6666644476666744466666666624444444444266666bbbbb00000000000000000000000000000000
6244444444444444444444444444442666288882666bbbbb6666664447777444666666666624444444444266666bbbbb00000000000000000000000000000000
6244444444444444444444444444442666622226666bbbbb6666666444444446666666666624444444444266666bbbbb00000000000000000000000000000000
6222222222222222222222222222222666666666666bbbbb6666666644444466666666666622222222222266666bbbbb00000000000000000000000000000000
6666666666666666666666666666666666666666666bbbbb6666666666666666666666666666666666666666666bbbbb00000000000000000000000000000000
5555555555555555555555555555555555555555555bbbbb5555555555555555555555555555555555555555555bbbbb00000000000000000000000000000000
00222200009999000077770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02888820099999900777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
28888882099009900770077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88e8e888000009900770077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
888e8e88099999900777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88e8e888099999900777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
888e8e88099999900777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07777700000070000000000000077700000070000000000000077700007777000000700007700770070000700000000000000000000000000000000070000000
00000700000777000770770000700000000070000070070000700070070000700000700007700770070007700000000000000000000000000000000070700000
00077700007700700070700007007700077777770077770000070070070770700000000000000000070070700000000000000000000000000000000077000000
00070000077000070070700007070070000070070070070000000700070770700077000000000000070700700000000000000000000000000000000070077777
00077770777770000070700007070070077777770077770000007000070000700000000007700000077000700000000000000000000000000000000077000000
00070000000000000070700007007700000070000070070000007000000000000000700007700000070077700000000000000000000000000000000070700000
00070000000000000077700000000000000070000000000000007000000000000000700000000000000000000000000000000000000000000000000070000000
00000000007777000070000007700000000770000000000000777700000000000000000000000000000000000000000000000000000000000000000000000000
70070070070000700707000007070000007007000770000007007070000000000000000000000000000000000000000000000000000000000000000000000000
07070700700000070777000007770000070000707007000070070707000000000000000000000000000000000000000000000000000000000000000000000000
00707000707007070707000007070000070000707007000070077077000000000000000000000000000000000000000000000000000000000000000000000000
77070770700000070707000007700000077777700000700770007777000000000000000000000000000000000000000000000000000000000000000000000000
00707000070000700000000700000007077777700000700770000077000000000000000000000000000000000000000000000000000000000000000000000000
07070700007007007777777777777777077007700000077007000070000000000000000000000000000000000000000000000000000000000000000000000000
70070070000770000000000700000007077777700000000000777700000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07777770077007777770077777770077770777007777770077777007700077000000000000000000000000000000000000000000000000000000000000000000
07777770077007777770077777770077707777007777770077777007700770000000000000000000000000000000000000000000000000000000000000000000
07700770077007700770077700770000077000007700770077000007700770000000000000000000000000000000000000000000000000000000000000000000
07700770077007700770077000770000077000007700770077000007707700000000000000000000000000000000000000000000000000000000000000000000
07700770077007700700077000770000077000007700770077000007707700000000000000000000000000000000000000000000000000000000000000000000
07707770077007700000077000770000077000007707770077007007777000000000000000000000000000000000000000000000000000000000000000000000
07077700077007700000077000770000077000007777700077077007770000000000000000000000000000000000000000000000000000000000000000000000
00777000077007700000077000770000077000007777070077077007707000000000000000000000000000000000000000000000000000000000000000000000
07770000077007700000077000770000077000007770770077070007777000000000000000000000000000000000000000000000000000000000000000000000
07700000077007700070077000770000077000007700770077000007707700000000000000000000000000000000000000000000000000000000000000000000
07700000077007700770077000770000077000007700770077000007707700000000000000000000000000000000000000000000000000000000000000000000
07700000077007700770077007770000077000007700770077000007700770000000000000000000000000000000000000000000000000000000000000000000
07700000077007777770077777770000077000007700770077777007700770000000000000000000000000000000000000000000000000000000000000000000
07700000077007777770077777770000077000007700770077777007700077000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
73333333333333333333333333333337755555555555555555555555555555577222222222222222222222222222222770000000000000000000000000000007
733333b3333777337733773333333337755555555555555555555555555555577222222222222222222222222222222770666000006660000000000000000007
73333333333777373737373333333337755555555cccccccccccc555555555577222222222222222266666666666662770606066606060aaa000000000000007
733333b3333737377737773333333337755577755cccccccccccc555555555577222222222222222264444444688862770666060606660a0a000000000000007
73333333333737373737333333333337755555555cccccccccccc555555555577222222222222222264444444688862770000066600000aaa000000000000007
733333b3333333333333333333333337755555555555555555555555555555577222222222222222264444444688862770aaa000006660000000000000000007
7333333333333333333333333333333775555b555ccccc5555555555555555577222222222222222266666666666662770a0a066606060666000000000000007
733333b33333333333333333333333377555bbb55ccccc5555555555555555577222222222222222222222222222222770aaa060606660606000000000000007
733333333333333333b333333333333775555b555ccccc5555555555555555577222222222222222222222222222222770000066600000666000000000000007
733333b333333333bb33333333333337755555555555555555555555555555577272727772277222266666666666662770666000006660000007070077070707
73333333333333bb3b33333333333337755566655cccccccccccccccc555555772727277227272222644444446888627706060ccc06060666007070707007007
733333b3333333b3b333333333333337755566655cccccccccccccccc555555772777272227772222644444446888627706660c0c06660606007770777007007
733333333333333bb333333333333337755566655cccccccccccccccc555555772777227727222222644444446888627700000ccc00000666007070707070707
733333b333333333333333333333333775555555555555555555555555555557722222222222222226666666666666277066600000aaa0000000000000000007
73333333333333333333333333333337755558855cc555555555555555555557722222222222222222222222222222277060606660a0a0666000000000000007
733333b3333333333333333333333337755588855cc555555555555555555557722222222222222222222222222222277066606060aaa0606000000000000007
73333333333333333333333333333337755558855cc5555555555555555555577222222222222222266666666666662770000066600000666000000000000007
73b3b3b3b3b3b3b3b3b3b3b3b3b3b3b7755555555555775577575755555555577222222222222222266466666644462770666000006660000000000000000007
73333333333333333333333333333337755555555557575757575755555555577222222222222222264646666646462770606066606060666000000000000007
733333b3333333333333333333333337755555555557775757577755555555577222222222222222266466666644462770666060606660606000000000000007
73333333333333333333333333333337755555555557555775577755555555577222222222222222266666666666662770000066600000666000000000000007
733333b3333333333333333333333337755555555555555555555555555555577222222222222222222222222222222770000000000000000000000000000007
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888883333333323333333333333333333333233333333333333333333333333333333333333333333333333333333333333333333333333133333338
87778777877783333333333333333333333333333333333333333333333366633332333333333333333333333323333333333333333333333323333133333338
87778787878783333333333333333333333333333333333333333333333363633332333333333333333333333323333333333333333333333323333133333338
87878777877783333333323333333333333333333333233333333333333366633333333333333333333333333333333333333333333333333333333133333338
87878787878883333333323333333333333333333333233333333333333333633333333333333333333333333333333333333333333333333333333173333338
87878787878883333333333333333333333333333333333333333333333333633332333333333333333333333323333333333333333333333323333777373338
88888888888883333333333333333333333333333333333333333333333333333332333333333333333333333323333333333333333333333323333177777338
83333333333333333333323333333333333333333333233333333333333333333333333333333333333333333333333333333333333333333333333133373338
83333333333333333333323333333333333333333333233333333333333333333333333333333333333333333333333333333333333333333333333133333338
83333333333333333333333333333333333333333333333333333333333333333332333333333333333333333323333333333333333333333323333133333338
83333333333333333333333333333333333333333333333333333333333333333332333333333333333333333323333333333333333333333323333133333338
83333333333333333333323333333333333333333333233333333333333333633333333333333333333333333333333333333333333333333333333133333338
83333333333333333333323333333333333333373333233333333333333333333333633333333333333333333333333333333333333333333333333133333338
83333333333333333333333333333333333777737733333333333336333333333332333333333333333333333323333333333333333333333323333133333338
83333333333333333333333333333333337333333373333333333333333333333332333333333333333333333323333333333333333333333323333133333338
83333333333333333333323333333333337333333337733333333333333333333333333333633333333333333333333333333333333333333333333133333338
83333333333333333333323333333337773333333333273333333333333333333333333333333333333333333333333333333333333333333333333133333338
83333333333333333333333333333337333333333333337333333333333333333332333333333333333333333323333333333333333333333323333133333338
83333333333333333333333333333333733333333333337333633333333333333332333333333333333333333323333333333333333333333323333133333338
83333333333333333333323333333333733333333333237333333333333333333333333333333333333333333333333333333333333333333333333133333338
82332233223322332233223322332237223322332233227322332233223322332233223322332236223322332233223322332233223322332233223122332238
83333333333333333333333333333333733333333333333733333333333333333332333333333333333333333323333333333333333333333323333133333338
83333333333333333333333333333333733333333333333733333333333333333332333333333333333333333323333333333333333333333323333133333338
83333333333333333333323333333333733333333333233733333333333333333333333333333333333333636633333333333333333333333333333133333338
83333333333333333333323333333333733333333333237633333333333333333333333333333333333333633363333333333333333333333333333133333338
83333333333333333333333333333333373333333333337333333333333333333332333333333333333333633633333333333333333333333323333133333338
83333333333333333333333333333333373333333333373333333333333333333332333333333333333333636333333333333333333333333323333133333338
83333333333333333333323333333333337733333377773333333333333333333333333333333333363333636663333333333333333333333333333133333338
83333333333333333333323333333333333373637733233333333333333333bbb333333333333333333333333333333333333333333333333333333133333338
83333333333333333333333333333333333333633333333333333333333333b33bbb333333333333333333333323333333333333333333333323333133333338
833333333333333333333333333333333333336663333363333333333333333b3bb2333333333333333333333323333333333333333333333323333133333338
833333333333333333333233333333333333336363332333333333333333333bb333333333333333333333333333333333333333333333333333333133333338
83333333333333333333323333333333333333666333233333333333333333333333333333333333333333333333333333333333333333333333333133333338
83333333333333333333333333333333333333333333333333333333333333333332333333333333633333333323333333333333333333333323333133333338
83333333333333333333333333333333333333333333333333333333333333333332333333333333333333333323333333333333333333333323333133333338
83333333333333333333323333333333333333333333233333333333333333333333333333333333333333333333333333333333333333333333333133333338
83333333333333333333323333333333333333333333233333333333333333333333333333333333333333333333333333333333333333333333333133333338
83333333333333333333333333333333333333333333333363333333333333333332333333333333333333333323333333333333333333333323333133333338
83333333333333333333333333333333333333333333333333333333333333333332333333333333333333333323333333333333333333333323333133333338
83333333333333333333323333333333333333333333233333333333333333333337777733333633333333333333333333333333333333333333333133333338
83333333333333333333323333333333333333333333233333333333333333333373333377333333333333333333333333333333333333333333333133333338
83333333333333333333333333333333333333333333333333333333333333333732333333733333333333333323333333333333333333333323333133333338
83333333337777333333333333333333333333333333333333333633333333337332333333373333333333333323333333333333333333333323333133333338
82332233773327332233223322332233223322332233223322332233223322772233223322372233223322332233223322332233223322332233223122332238
833333337333337333333233333333333333333333332333333333333333333733333333633373333333333333333333333a3333333333333333333133333338
833333337333337333333333333333333333333333333333333333333336333733323333333373333333333333233333333aaa33333333333323333133333338
833333337333373333333333333333333333333333333333333333333333333736323333333373333333333333233333333a33aa333333333323333133333338
83333333373337333333323333333333333333333333233333333333333333373333333333373333333333333333333333a333a3333333333333333133333338
83333333377773333333323333333333333333333333233333333333333333337333333333373333333333333333333333a33a33333333333333333133333338
83333333333333333333333333333333333333333333333333333333333333337333333333733333333333333323333333a3a333333333333323333133333338
83333333333333333333333333333333333333333333333333333333333333333666333337333333333333333323333333aa3333333333333323333133333338
83333333333333333333323333333333333333333333233333333333333333333336333773333333333333333333333333333333333333333377737773773338
83333333333333333333323333333333333333333333233333333333333333333666377333333333333333333333333333333333333333333333737173373338
83333333333333333333333333333333333333333333333333333333333333333336333333333333333333333323333333333333333333333327737173373338
83333333333333333333333333333333333333333333333333333333333333333666333333333333333333333323333333333333333333333323737173373338
83333333333333333333323333333333333333333333233333333333333333333333333333333333333333333333333333333333333333333377737773777338
83333333333333333333323333333333333333333333233333333333333333333333333333333333333333333333333333333333333333333333333133333338
83333333333333333333333333333333333333333333333333333333333333333332333333333333333333333323333333333333333333333323333133333338
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000bbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07707070777077707000770007700700b0bb0b000000000070707070700070000700bb00bbb0bbb00000000070000770077077700700aaa0aaa0000000000000
70007070070077007000707070000000bb00bb0000000000707070707000700000000b00b0b0b0b00000000070007070707007000000aa00a0a0000000000000
00707770070070007000707000700700bb00bb0000000000777070707000700007000b00b0b0b0b000000000700070707070070007000aa0a0a0000000000000
77007070777007700770770077000000b0bb0b0000000000707007700770077000000b00b0b0b0b00000000007707700770007000000aaa0a0a0000000000000
000000000000000000000000000000000bbbb0000000000000000000000000000000bbb0bbb0bbb000000000000000000000000000000a00aaa0000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccc222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222c
c7c7c777c777c222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222c
c7c7c7ccc7c7c222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222c
c7c7c77cc777c222222222222222222222222222777777777777777777777777777777777777777777721111111111111111111111111111111111112222222c
c777c7ccc7ccc222222222222222222222222222666666666666666666666666666666666666666666621111111111111111111111111111111111112222222c
c777c777c7ccc222222222222222222222222222622222222222222222222222222222266666666666621177717171777117717771777111117771112222222c
ccccccccccccc222222222222222222222222222629999999999999999999999999999266666666666621171717171717171117111717111117171112222222c
c222222222222222222222222222222222222222624664466444444444466446664444266668888666621177717771777177717711771111117771112222222c
c222222222222222222222222222222222222222624464446444444444446444464444266688888866621171117171717111717111717111117171112222222c
c22222222222222222222222222222222222222262446444644444444444644666444426688e8e8886621171117171717177117771717111117171112222222c
c222222222222222222222222222222222222222624464446444444444446446444444266888e8e886621111111111111111111111111111111111112222222c
c22222222222222222222222222222222222222262466646664444444446664666444426688e8e8886621111111111111111111111111111111111112222222c
c222222222222222222222222222222222222222624444444444444444444444444444266888e8e886621111111111111111111111111111111111112222222c
c2222222222222222222222222222222222222226244446444444444bb444464444444266288888826621177777777777777777777777777777777112222222c
c2222222222222222222222222222222222222226244446444444444bb444464444444266628888266621171111111111111111111111111111117112222222c
c222222222222222222222222222222222222222624444644444444bbbb44464444444266662222666621171611111111111111111111111111117112222222c
c222222222222222222222222222222222222222622222222222222222222222222222266666666666621171611111111111111111111111111117112222222c
c222222222222222222222222222222222222222666666666666666666666666666666666666666666621171611111111111111111111111111117112222222c
c222222222222222222222222222222222222222555555555555555555555555555555555555555555521171111111111111111111111111111117112222222c
c222222222222222222222222222222222222222222222222222222222222222222222222222222222221177777777777777777777777777777777112222222c
c222222222222222222222222222222222222222222222222222222222222222222222222222222222221111111111111111111111111111111111112222222c
c221111111111111111111111111111111111112777777777777777777777777777777777777777777721111111111111111111111111111111111112222222c
c221111111111111111111111111111111111112666666666666666666666666666666666666666666622222222222222222222222222222222222222222222c
c221177717171777117717771777111117771112622222222222222222222222222222266666666666622222222222222222222222222222222222222222222c
c221171717171717171117111717111117171112629999999999999999999999999999266666666666622222222222222222222222222222222222222222222c
c221177717771777177717711771111117711112626444444444446644666444444444266668888666622222222222222222222222222222222222222222222c
c221171117171717111717111717111117171112626444444444444644446444444444266688888866622222222222222222222222222222222222222222222c
c22117111717171717711777171711111777111262644444444444464466644444444426688e8e8886622222222222222222222222222222222222222222222c
c221111111111111111111111111111111111112626444444444444644644444444444266888e8e886622222222222222222222222222222222222222222222c
c22111111111111111111111111111111111111262664444444444666466644444444426688e8e8886622222222222222222222222222222222222222222222c
c221111111111111111111111111111111111112624444444444444444444444444444266888e8e886622222222222222222222222222222222222222222222c
c2211777777777777777777777777777777771126244444444444444bb444444444444266288888826622222222222222222222222222222222222222222222c
c2211711111111111111111111111111111171126244444444444444bb444444444444266628888266622222222222222222222222222222222222222222222c
c221171611111111111111111111111111117112624444444444444bbbb44444444444266662222666622222222222222222222222222222222222222222222c
c221171611111111111111111111111111117112622222222222222222222222222222266666666666622222222222222222222222222222222222222222222c
c221171611111111111111111111111111117112666666666666666666666666666666666666666666622222222222222222222222222222222222222222222c
c221171111111111111111111111111111117112555555555555555555555555555555555555555555522222222222222222222222222222222222222222222c
c221177777777777777777777777777777777112222222222222222222222222222222222222222222222222222222222222222222222222222222222222222c
c221111111111111111111111111111111111112222222222222222222222222222222222222222222222222222222222222222222222222222222222222222c
c22111111111111111111111111111111111111ccccccccccccccccccccccccccccccccccccccccccccc1111111111111111111111111111111111112222222c
c22222222222222222222222222222222222222c6666666666666666666666666666666666666666666c1111111111111111111111111111111111112222222c
c22222222222222222222222222222222222222c6666666600000066666666666622222222222266666c1177711771717177111111111111111111112222222c
c22222222222222222222222222222222222222c666666604444440666666666662aaaaaaaaaa266666c1177717111717171711111111111111111112222222c
c22222222222222222222222222222222222222c6666660446666440666666666624444444444266666c1171717111717171711111111111111111112222222c
c22222222222222222222222222222222222222c6666604466666644066666666624449999444266666c1171717171717171711111111111111111112222222c
c22222222222222222222222222222222222222c6666604666666664066666666624499999944266666c1171717771177171711111111111111111112222222c
c22222222222222222222222222222222222222c6666644666666664466666666624499449944266666c1111111111111111111111111111111111112222222c
c22222222222222222222222222222222222222c6666644666666655566666666624444449944266666c1111111111111111111111111111111111112222222c
c22222222222222222222222222222222222222c666664476666655a556666666624499999944266666c1111111111111111111111111111111111112222222c
c22222222222222222222222222222222222222c66666444766665aaa56666666624499999944266666c1177777777777777777777777777777777112222222c
c22222222222222222222222222222222222222c66666644b777755a556666666624499999944266666c1171111111111111111111111111111117112222222c
c22222222222222222222222222222222222222c6666666bbb444455566666666624444444444266666c1171611111111111111111111111111117112222222c
c22222222222222222222222222222222222222c66666666b4444466666666666622222222222266666c1171611111111111111111111111111117112222222c
c22222222222222222222222222222222222222c6666666666666666666666666666666666666666666c1171611111111111111111111111111117112222222c
c22222222222222222222222222222222222222c5555555555555555555555555555555555555555555c1171111111111111111111111111111117112222222c
c22222222222222222222222222222222222222ccccccccccccccccccccccccccccccccccccccccccccc1177777777777777777777777777777777112222222c
c222222222222222222222222222222222222222222222222222222222222222222222222222222222221111111111111111111111111111111111112222222c
c222222222222222222222222222222222222222222222222222222222222222222222222222222222221111111111111111111111111111111111112222222c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

__sfx__
490c060b180101801018010180201802018030180301872018030187301803018720180100c010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
900300001805018050197501803018020180101801000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
490500000461004610046100562007620096200d630156301e6401f6102f630296201c61016600116000b60007600006001660000000000000000000000000000000000000000000000000000000000000000000
000300001812018130181100010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100
300100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
940300000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000000000000000000000000000
020300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
300100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
152000000683006830060100601006830068300601006010028300283002010020100283002830020100201008830088300883008830080100801008010080100a8300a8300a0100a0100a0100a0100a8300a830
152000000983009830090100901009830098300901009010078300783007010070100782007820070100701006830068300683006830060100601006010060100383003830030100301003010030100382003820
152000000683012830060100600006830068000601006000028300280002010020000282002800020100200008830088300883008800080100800008010080000a8300a8000a0100a0000a0100a0000a8200a800
112000000983009b300902009b30098300983009010090100783007b300702007b300783007830070100701006830068000684006800060100600006010060000383003800030100300003010030000382003800
142000000683012b100683013b100683012b10068300fb1002830028000281002000028200280002810020000883012b100883013b100881012b10088200fb100a8300a8000a8100a0000a8100a0000a8200a800
a52000000683006830060100601000a2000a1006000060000283002830020100201000a2000a1002000020000183001830018300183000a2000a1008000080000183001830018300183000a2000a100a8000a800
a52000000883008830080100801000a0000a0006000060000a8300a8300a0100a01000a0000a0002000020000983009830098300983000a0000a0008000080000b8300b8300c8300c83000a0000a000a8000a800
300100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
480100003f050234503f450234503e450204501f4501d4501c4501b4401a4401c4401e430204302342023420234102341023410234102341023400234002340015400004000c4000040000400004000040000400
00030000066700d67014470256500d440056300d6400c6600b6400b6300a63009610086500764007620076200762005610056100462004610076000560000e000560005600046000360000600006000060000600
480600002831028310283101531015310153102832028320283201532015320153200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000500003a3503a3403a3303a4203a410003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300
990200150e7200d7100e7100e7101c7100d7100d7100d7200c7100f710197200d7100c7100c7101a720187100e7100c7100d7100d7200e7200c71000700007000070000700007000070000700007000070000700
940300000651024510005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
020300003a6502a620226200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3001000036450354503445032450304402e4302b4202a4102a4302a0402d040310203301034010340203402034020340203401034010340103401034010000000000000000000000000000000000000000000000
000200003c0103a0103702034020310202e0302b04027040230501d05017050130500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200001305016050190401c0402003025030290202c0203002034010380103b0100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
640200003723003040372003520000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a8030000021500814015130306602c6602965026650226501f6401c65019640186301564013630136300e6200e6200c6300862006620056300462003610016200161000610006200061003600000000000000000
4802000019430154200b6300762002610026300161000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
480e00002e75027750207500070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000000000000000000000000000000000000
041500001212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300002f55039520005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
__music__
01 484a4308
00 48424308
00 494a4309
00 494a4309
00 4142430a
00 4142430a
00 4142430b
00 4142430b
00 4142430c
00 4142430c
00 4142430d
00 4142430d
02 4142430e
00 4142434e

