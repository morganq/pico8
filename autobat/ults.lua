heroults = {
    function(h) -- a
        h.target.stun = 3 * 30
        h.target:take_damage(h.ult_value, h)
        make_circle_particle(h.target.x, h.target.y, 0, 1, h)
        sfx(24)
    end,
    function(h) -- b
        h.attack_speed += h.base_attack_speed * h.ult_value / 100
        sfx(22)
    end,
    function(h) -- c
        for o in all(nearby_allies(h, 20)) do
            o:heal(h.ult_value, h)
            o.mana += 10
        end
        make_circle_particle(h.x, h.y, 20, 11)
        sfx(21)
    end,
    function(h) -- d
        local t = rnd(allies(h))
        make_circle_particle(t.x, t.y, 6, 0, h)
        if t == h then
            t.health = max(t.health - h.ult_value / 2, 1)
            t.attack_speed += h.base_attack_speed * 0.33
            return
        end
        t.health = max(t.health - h.ult_value, 1)
        t.mana = t.max_mana
        sfx(22)
    end,
    function(h) -- e
        for o in all(nearby_allies(h.target, 16)) do o:take_damage(h.ult_value, h, true) end
        make_circle_particle(h.target.x, h.target.y, 16, 8, h)
        sfx(24)
    end,
    function(h) -- f
        h.target:apply_effect(make_stat_add_effect("dot", h.ult_value, 5 * 30))
        h.stat_damage += h.ult_value * 5 -- hack
        make_circle_particle(h.target.x, h.target.y, 0, 9, h)
        sfx(23)
    end,
    function(h) -- g
        for o in all(nearby_allies(h, 25)) do o:apply_effect(
            make_stat_add_effect("armor", h.ult_value, 5 * 30)
        ) end
        make_circle_particle(h.x, h.y, 25, 5)
        sfx(22)
    end,
    function(h) -- h
        local healable = allies(h, function(a,b) return a.health > b.health end)
        if healable then
            local t = healable[1]
            t:heal(h.ult_value, h)
            make_circle_particle(t.x, t.y, 0, 11, h)
            t.attack_speed += (t.attack_speed * 0.1)
        end
        sfx(21)
    end,
    function(h) -- i
        h.target.target = rnd(allies(h))
        if rnd() < h.ult_value / 100 then
            local t = rnd(enemies(h))
            if t != h.target then
                h.target.target = t
            end
        end
        h.target.time_out_of_range = -60
        h.target = rnd(enemies(h))
        sfx(23)
    end,
    function(h) -- j
        for o in all(nearby_enemies(h, 25)) do o:apply_effect(
            make_stat_add_effect("armor", -h.ult_value, 8 * 30)
        ) end
        make_circle_particle(h.x, h.y, 25, 9)
        sfx(23)
    end,
    function(h) -- k
        for o in all(nearby_enemies(h, 15)) do
            o:take_damage(h.ult_value, h)
            h:heal(10, h)
            make_circle_particle(o.x, o.y, 0, 8, h)
        end
        make_circle_particle(h.x, h.y, 15, 8)
        sfx(24)
    end,
    function(h) -- l
        local dx, dy = h.target.x - h.x, h.target.y - h.y
        local d = sqrt(dx * dx + dy * dy)
        make_projectile(h.x, h.y, dx/d,dy/d, 10, function(o)
            if o.team != h.team then
                o:take_damage(h.ult_value, h)
            else
                o:heal(h.ult_value, h)
            end
        end)
        sfx(24)
    end,
    function(h) -- m
        h.target = rnd(enemies(h))
        h.target:apply_effect(make_stat_add_effect("dot", h.ult_value, 9999))
        h.stat_damage += h.ult_value * 12 -- total hack
        make_circle_particle(h.target.x, h.target.y, 0, 8, h)
        sfx(23)
    end,
    function(h) -- n
        local deads = {}
        for oh in all(arena.heroes) do
            if oh.dead then add(deads, oh) end
        end
        if #deads > 0 then
            local d = rnd(deads)
            for o in all(heroes_near(d.x, d.y, 16)) do
                if o.team != h.team then
                    o:take_damage(h.ult_value, h, true)
                end
            end
            make_circle_particle(d.x, d.y, 16, 8, h)
            sfx(24)
        end
    end,
    function(h) -- o
        local e = enemies(h, function(a,b) return hd(a,h) > hd(b,h) end)
        for i = 1,3 do
            --e[min(i,#e)]:take_damage(h.ult_value, h)
            make_attack_projectile(h, e[min(i,#e)], 5 + i * 3, h.ult_value, 48)
        end
        sfx(25)
    end,
    function(h) -- p
        for o in all(nearby_allies(h, 22)) do
            o:apply_effect(
                make_stat_add_effect("regen", h.ult_value, 4 * 30)
            )
            h.stat_heal += h.ult_value * 4
        end
        make_circle_particle(h.x, h.y, 22, 11)
        sfx(20)
    end,
    function(h) -- q
        for o in all(nearby(h, 27)) do 
            o.stun = (1 + (o.team != h.team and h.ult_value or 0)) * 30
        end
        make_circle_particle(h.x, h.y, 27, 0)
        sfx(23)
    end,
    function(h) -- r
        local dx, dy = h.target.x - h.x, h.target.y - h.y
        local angle = atan2(dx,dy)        
        local ct = h.ult_value
        for i = 1, ct do
            theta = angle - 0.125 + (i-1) / (ct-1) * 0.25
            local vx, vy = cos(theta), sin(theta)
            make_projectile(h.x, h.y, vx, vy, 0, function(o)
                if o.team != h.team then
                    o:take_damage(h.damage, h)
                    return true
                end
            end, 1)
        end
        sfx(25)
    end,
    function(h) -- s
        local dx, dy = h.target.x - h.x, h.target.y - h.y
        local d = sqrt(dx * dx + dy * dy)        
        make_projectile(h.x, h.y, dx / d, dy / d, 0, function(o)
            if o.team != h.team then
                o:take_damage(h.ult_value, h)
            end
        end,2)
        sfx(24)
    end,
    function(h) -- t
        h.damage += h.ult_value
        h.max_health += 15
        h.health += 15
        sfx(22)
    end,
    function(h) -- u
        h.target:take_damage(h.target.max_health * h.ult_value / 100, h)
        make_circle_particle(h.target.x, h.target.y, 0, 1, h)
        sfx(24)
    end,
    function(h) -- v
        h.target.mana = max(h.target.mana - h.ult_value, 0)
        sfx(23)
    end,
    function(h) -- w
        h.target.stun = h.ult_value * 30
        h.target.spri = 96
        make_circle_particle(h.target.x, h.target.y, 0, 1, h)
        sfx(23)
        h.target = rnd(enemies(h))
        h.time_out_of_range = 0
    end,
    function(h) -- x
        h:apply_effect(make_stat_add_effect("armor", h.ult_value, 5 * 30))
        sfx(22)
    end,
    function(h) -- y
        for o in all(nearby_allies(h, 22)) do o:apply_effect(
            make_stat_add_effect("attack_speed", o.base_attack_speed * h.ult_value / 100, 5 * 30)
        ) end
        make_circle_particle(h.x, h.y, 22, 14)
        sfx(22)
    end,
    function(h) -- z
        h.target:take_damage(h.target.max_mana * h.ult_value / 100, h)
        make_circle_particle(h.target.x, h.target.y, 0, 9, h)
        sfx(24)
    end,
    function(h) -- skele
    end,
}

function get_ult_number(h, level)
    level = level or 1
    if h == "d" then
        return herostats[h].ult_base_num / level
    end
    return herostats[h].ult_base_num * (1 + (level - 1) * 0.66)
end