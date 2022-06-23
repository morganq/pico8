heroults = {
    function(h) -- a
        h.target.stun = 3 * 30
        h.target:take_damage(h.ult_value, h)
    end,
    function(h) -- b
        h.attack_speed += h.base_attack_speed * h.ult_value / 100
    end,
    function(h) -- c
        for o in all(nearby_allies(h, 20)) do o:heal(h.ult_value, h) end
        make_circle_particle(h.x, h.y, 20, 11)
    end,
    function(h) -- d
        h:apply_effect(make_stat_add_effect("attack_speed", h.base_attack_speed * h.ult_value / 100, 4 * 30))
    end,
    function(h) -- e
        for o in all(nearby_allies(h.target, 16)) do o:take_damage(h.ult_value, h, true) end
        make_circle_particle(h.target.x, h.target.y, 16, 8)        
    end,
    function(h) -- f
        h.target:apply_effect(make_stat_add_effect("dot", h.ult_value, 5 * 30))
        h.stat_damage += h.ult_value * 5 -- hack
    end,
    function(h) -- g
        for o in all(nearby_allies(h, 25)) do o:apply_effect(
            make_stat_add_effect("armor", h.ult_value, 5 * 30)
        ) end
        make_circle_particle(h.x, h.y, 25, 5)
    end,
    function(h) -- h
        local healable = allies(h, function(a,b) return a.health > b.health end)
        if healable then
            healable[1]:heal(h.ult_value, h)
        end
    end,
    function(h) -- i
        if rnd() < h.ult_value / 100 and #enemies(h) > 0 then
            h.target.target = rnd(enemies(h))
        else
            h.target.target = rnd(enemies(h.target))
        end
        h.time_out_of_range = -60
    end,
    function(h) -- j
        for o in all(nearby_enemies(h, 25)) do o:apply_effect(
            make_stat_add_effect("armor", -h.ult_value, 8 * 30)
        ) end
        make_circle_particle(h.x, h.y, 25, 9)
    end,
    function(h) -- k
        for o in all(nearby_enemies(h, 15)) do
            o:take_damage(h.ult_value, h)
            h:heal(10, h)
        end
        make_circle_particle(h.x, h.y, 15, 8)
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
    end,
    function(h) -- m
        h.target = rnd(enemies(h))
        h.target:apply_effect(make_stat_add_effect("dot", h.ult_value, 9999))
        h.stat_damage += h.ult_value * 12 -- total hack
    end,
    function(h) -- n
        local deads = {}
        for h in all(arena.heroes) do
            if h.dead then add(deads, h) end
        end
        if #deads > 0 then
            local d = rnd(deads)
            for o in all(heroes_near(d.x, d.y, 16)) do
                if o.team != h.team then
                    o:take_damage(h.ult_value, h, true)
                end
            end
            make_circle_particle(d.x, d.y, 16, 8)                    
        end
    end,
    function(h) -- o
        local e = enemies(h, function(a,b) return hd(a,h) > hd(b,h) end)
        for i = 1,3 do
            e[min(i,#e)]:take_damage(h.ult_value, h)
        end
    end,
    function(h) -- p
        for o in all(nearby_allies(h, 22)) do
            o:apply_effect(
                make_stat_add_effect("regen", h.ult_value, 4 * 30)
            )
            h.stat_heal += h.ult_value * 4
        end
        make_circle_particle(h.x, h.y, 22, 11)
    end,
    function(h) -- q
        for o in all(nearby(h, 27)) do 
            if o.team == h.team then
                if o != h then
                    o.stun = 1 * 30
                end
            else
                o.stun = (1 + h.ult_value) * 30
            end
        end
        make_circle_particle(h.x, h.y, 27, 0)
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
    end,
    function(h) -- s
        local dx, dy = h.target.x - h.x, h.target.y - h.y
        local d = sqrt(dx * dx + dy * dy)        
        make_projectile(h.x, h.y, dx / d, dy / d, 0, function(o)
            if o.team != h.team then
                o:take_damage(h.ult_value, h)
            end
        end,2)
    end,
    function(h) -- t
        h.damage += h.ult_value
        h.max_health += 15
        h.health += 15
    end,
    function(h) -- u
        h.target:take_damage(h.target.max_health * h.ult_value / 100, h)
    end,
    function(h) -- v
        h:apply_effect(make_stat_add_effect("max_health", h.ult_value, 10 * 30))
        h:apply_effect(make_stat_add_effect("health", h.ult_value, 10 * 30))
    end,
    function(h) -- w
        h.target.stun = h.ult_value * 30
    end,
    function(h) -- x
        h:apply_effect(make_stat_add_effect("armor", h.ult_value, 5 * 30))
    end,
    function(h) -- y
        for o in all(nearby_allies(h, 22)) do o:apply_effect(
            make_stat_add_effect("attack_speed", o.base_attack_speed * h.ult_value / 100, 5 * 30)
        ) end
        make_circle_particle(h.x, h.y, 22, 14)
    end,
    function(h) -- z
        h.target:take_damage(h.target.max_mana * h.ult_value / 100, h)
    end,
}

function get_ult_number(h, level)
    level = level or 1
    return herostats[h].ult_base_num * (1 + (level - 1) * 0.66)
end