level_colors = {
    15, 11, 14, 9
}

function make_effect(startfn, endfn, time)
    return {
        startfn = startfn,
        endfn = endfn,
        time = time,
    }
end

function make_stat_add_effect(stat_name, value, time)
    return make_effect(
        function(self, target) target[stat_name] += value end,
        function(self, target) target[stat_name] -= value end,
        time
    )
end

function make_stat_mul_effect(stat_name, value, time)
    return make_effect(
        function(self, target) target[stat_name] *= value end,
        function(self, target) target[stat_name] /= value end,
        time
    )
end

function hd(a,b)
    return (a.x-b.x)^2 + (a.y-b.y)^2
end

function htowards(me,t)
    local dx, dy = t.x - me.x, t.y - me.y
    local d = sqrt(hd(me,t))
    return dx / d, dy / d
end

function heroes_by_team(team)
    local results = {}
    for h in all(arena.heroes) do
        if h.team == team and h.alive then
            add(results, h)
        end
    end
    return results
end

function heroes_near(x, y, range)
    local results = {}
    for h in all(arena.heroes) do
        if ((h.x - x) ^ 2 + (h.y - y) ^ 2) <= range ^ 2 then
            add(results, h)
        end
    end
    return results        
end

function nearby(me, range)
    local results = {}
    for h in all(arena.heroes) do
        if hd(h, me) <= range ^ 2 then
            add(results, h)
        end
    end
    return results    
end

function nearby_allies(me, range)
    results = {}
    for h in all(nearby(me, range)) do
        if h.team == me.team then add(results, h) end
    end
    return results
end

function nearby_enemies(me, range)
    results = {}
    for h in all(nearby(me, range)) do
        if h.team != me.team then add(results, h) end
    end
    return results
end

function enemies(me, cmp)
    local h = heroes_by_team(3 - me.team)
    if not cmp then return h end
    sort(h, cmp)
    return h
end

function allies(me, cmp)
    local h = heroes_by_team(me.team)
    if not cmp then return h end
    sort(h, cmp)
    return h 
end

function create_hero(name, pips, gpos, team)
    local ppos = g2p(gpos[1], gpos[2])
    local h = {
        initial = sub(name,1,1),
        name = name,
        pips = pips,
        team = team,
        apparent_team = (team == arena.my_team) and 1 or 2,
        hero_index = ord(sub(name,0,1)) - 96,
        x = ppos[1] + 5,
        y = ppos[2] + 5,
        alive = true,
        
        -- stats
        max_health = 100,
        health = 100,
        speed = 0.25,
        range = 10,
        attack_speed = 0.75,
        damage = 10,
        projectile_speed = 30, --pix/sec
        targeting = 'near', -- default
        max_mana = 150,
        mana = 0,
        ult_value = 1,

        -- effects
        effects = {},
        dot = 0,
        regen = 0,
        stun = 0,
        armor = 0,

        -- detail
        reload = 0,
        time_out_of_range = -30, -- start with negative as heroes run across the map
        t = 0,
        got_hit_timer = 0,

        draw = function(self)
            local x, y = tpx(self.x), tpy(self.y)
            if not self.alive then
                palt(0b0000000000000001)
                spr(0, x - 4, y - 4)
                palt()
                return
            end
            spr(64 + self.hero_index, x - 4, y - 6)
            --[[
            ovalfill(x - 4, y - 4, x + 4, y + 4, 0)
            ovalfill(x - 4, y - 5, x + 4, y + 3, team_colors[self.apparent_team])
            level = self:get_level_filled_total_pips()
            oval(x-4, y-5, x+4, y+3, level_colors[level])
            if level == 4 then
                oval(x-3, y-4, x+3, y+2, 7)
            end
            print(sub(self.name,0,1), x - 1, y - 3, 1)
            ]]--
            if self.got_hit_timer > 0 then
                self.got_hit_timer -= 1
                local da = {{-1,-1},{1,-1},{1,1},{-1,1}}
                for i = 1, 4 do
                    local dx, dy = da[i][1], da[i][2]
                    line(
                        x + dx * (3 - self.got_hit_timer) * 0.5,
                        y + dy * (3 - self.got_hit_timer) * 0.5,
                        x + dx * (3 - self.got_hit_timer) * 1.5, 
                        y + dy * (3 - self.got_hit_timer) * 1.5,
                        8
                    )
                end
            end
            local sei = 0
            if self.regen != 0 then
                spr(193, x + 4, y - 4 + sei)
                sei += 4
            end
            if self.dot != 0 then
                spr(192, x + 4, y - 4 + sei)
                sei += 4
            end
            if self.stun > 0 then
                spr(194, x + 4, y - 4 + sei)
                sei += 4
            end         
            --[[if #self.effects > 0 then
                print(#self.effects, x + 4, y - 4 + sei, 0)
            end]]
        end,

        draw_ui = function(self)
            local x, y = tpx(self.x), tpy(self.y)
            if match.turn == 'sim' then
                
                local hpbmw = 8
                local hpbw = hpbmw * mid(self.health / self.max_health, 0, 1)
                line(x - 4, y + 5, x + 4, y + 5, 2)
                line(x - 4, y + 5, x - 4 + hpbw, y + 5, 8)  
                local mbw = hpbmw * mid(self.mana / self.max_mana, 0, 1)
                line(x - 4, y + 6, x + 4, y + 6, 1)
                if mbw > 0.5 then
                    line(x - 4, y + 6, x - 4 + mbw, y + 6, 12)    
                end

            else
                level, filled, total = self:get_level_filled_total_pips()
                if level > 0 then
                    local c = level_colors[level]
                    for i = 1, total do
                        px = x - 3 - total + i * 2
                        circ(px, y - 6, 1, 0)
                        if filled >= i then
                            pset(px, y-6, 7)
                        else
                            pset(px, y-6, 0)
                        end
                    end
                end                
            end
        end,

        get_level_filled_total_pips = function(self)
            if self.pips == 1 then return 1, 0, 1
            elseif self.pips < 4 then return 2, self.pips-2, 2
            elseif self.pips < 7 then return 3, self.pips-4, 3
            else return 4, 0, 0 end  
        end,

        update = function(self)
        end,

        find_target = function(self)
            function mydist(o)
                return (o.x - self.x)^2 + (o.y - self.y)^2
            end
            if self.targeting == 'far' then
                self.target = enemies(self, function(a,b) return mydist(a) < mydist(b) end)[1]
            else
                self.target = enemies(self, function(a,b) return mydist(a) > mydist(b) end)[1]
            end
        end,

        sim_init = function(self)
            self:find_target()
        end,
        sim_update = function(self)
            self.t += 1
            -- Dead?
            if not self.alive then return end

            -- Effects
            for effect in all(self.effects) do
                effect.time -= 1
                if effect.time <= 0 then
                    effect:endfn(self)
                    del(self.effects, effect)
                end
            end

            -- Regen and DOT
            if self.t % 15 == 0 then 
                if self.regen != 0 then
                    self:heal(self.regen / 2)
                end
                if self.dot != 0 then
                    self:take_damage(self.dot / 2, true)
                end
            end

            -- Mana
            self.mana = min(self.mana + 1, self.max_mana)

            -- Stun
            if self.stun > 0 then
                self.stun -= 1
                return
            end

            -- Targeting
            if self.target and not self.target.alive then
                self:find_target()
            end

            -- Done if no target
            if self.target == nil then return end

            -- Walk to target
            local dsq = hd(self, self.target)
            if dsq > self.range ^ 2 then
                local dx, dy = htowards(self, self.target)
                self.x += dx * self.speed
                self.y += dy * self.speed
                if self.targeting == "near" then
                    self.time_out_of_range += 1
                end
                if self.time_out_of_range > 20 then
                    self:find_target()
                end
            else
                self.time_out_of_range = 0
                if self.reload <= 0 then
                    self:attack()
                    self.reload += 30
                end
            end
            if self.reload > 0 then
                self.reload -= self.attack_speed
            end
            if self.mana >= self.max_mana then
                -- Ult half way to the next attack
                if self.reload >= 15 and self.reload - self.attack_speed < 15 then
                    self.mana = 0
                    self:use_ult()
                end
            end
        end,

        apply_effect = function(self, effect)
            add(self.effects, effect)
            effect:startfn(self)
        end,

        attack = function(self)
            make_attack_projectile(self, self.target, sqrt(hd(self, self.target)) / self.projectile_speed * 30, 10, self.hero_index)
        end,

        take_damage = function(self, damage, truedamage)
            if not truedamage then
                damage = max(damage - self.armor, 0)
            end
            if damage > 0 then
                self.got_hit_timer = 4
                self.health -= damage
                if self.health <= 0 then
                    self.alive = false
                end
            end
        end,

        heal = function(self, amt)
            self.health = min(self.health + amt, self.max_health)
        end,

        use_ult = function(self)
            heroults[self.hero_index](self)
            --debug(self.name.." ULT!")
        end
    }
    for field,value in pairs(herostats[h.name]) do
        h[field] = value
        if field == 'max_health' then h.health = value end
    end
    h.range = h.range * grid_size * 1.1

    local level = h:get_level_filled_total_pips()
    h.max_health = h.max_health * (1 + (level - 1) * 0.75)
    h.health = h.max_health
    h.damage = h.damage * (1 + (level - 1) * 0.5)
    h.ult_value = get_ult_number(h.initial) * (1 + (level - 1) * 0.66)

    local base_stat_names = {"max_health", "max_mana", "damage", "attack_speed", "speed"}
    for sn in all(base_stat_names) do
        h['base_'..sn] = h[sn]
    end

    return h
end