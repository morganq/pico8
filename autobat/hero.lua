level_colors = split"6,9,14,11"

function create_herospec(name, pos, pips)
    return {
        name = name,
        pips = pips or 1,
        pos = pos
    }
end

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
        if hd(h, me) <= range ^ 2 and h.alive then
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

function create_hero(name, pips, gpos, team, index_on_team)
    local ppos = g2p(gpos[1], gpos[2])
    local initial = sub(name,1,1)
    local h = {
        initial = initial,
        index = index_on_team,
        name = name,
        pips = pips,
        team = team,
        apparent_team = (team == arena.my_team) and 1 or 2,
        hero_index = ord(initial) - 96,
        spri = ord(initial) - 32,
        x = ppos[1] + 5,
        y = ppos[2] + 5,
        alive = true,
        dead = false,
        
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
        ult_range = 10,
        spawn_time = 0,

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
        is_walking = false,
        recoil = {0,0},
        just_ulted_timer = 0,
        stat_damage = 0,
        stat_heal = 0,
        pop_time = 0,

        draw_sprite = function(self, xo, yo, head_offset, flip, scale)
            local x = tpx(self.x + self.recoil[1]) + xo - 4 - (scale - 1) * 4
            local y = tpy(self.y + self.recoil[2]) + yo - 6 - (scale - 1) * 4
            local sx = self.spri % 16 * 8
            local sy = self.spri \ 16 * 8
            sspr(sx, sy, 8, 5, x + head_offset, y, 8 * scale, 5 * scale, flip)
            sspr(sx, sy + 5, 8, 3, x, y + 5 * scale, 8 * scale, 3 * scale, flip)
        end,

        draw = function(self)
            local x, y = tpx(self.x), tpy(self.y)
            if not self.alive then
                if self.dead then
                    palt(0b0000000000000001)
                    spr(0, x - 4, y - 4)
                    palt()                        
                else
                    pal({[7]=0})
                    spr(mid(self.spawn_time / 15, 0, 8) + 224, x - 4, y - 4)
                    pal()
                end
                return
            end
            if self.just_ulted_timer > 0 then
                self.just_ulted_timer -= 1
                for i = 0, 2 do
                    circfill(x, y - 4 + i * 2, 5, 12)
                end
            end
            local flip = arena.my_team == 2
            if self.pop_time > 0 then self.pop_time -= 1 end
            local scale = mid(self.pop_time / 10 + 1, 2, 1)
            if self.target and self.target.x < self.x then flip = not flip end
            local fx, fy = tpx(self.x + self.recoil[1]), tpy(self.y + self.recoil[2])
            local oc = self.apparent_team == 1 and 7 or 14
            if self.is_walking then
                local off = sin(self.t / 12)
                for i = 1, 15 do pal(i, oc) end                
                self:draw_sprite(-1, 0, off, flip, scale)
                self:draw_sprite( 1, 0, off, flip, scale)
                self:draw_sprite(0, -1, off, flip, scale)
                self:draw_sprite(0,  1, off, flip, scale)
                pal()
                self:draw_sprite(0, 0, off, flip, scale)
            else
                for i = 1, 15 do pal(i, oc) end
                self:draw_sprite(-1, 0, 0, flip, scale)
                self:draw_sprite( 1, 0, 0, flip, scale)
                self:draw_sprite(0, -1, 0, flip, scale)
                self:draw_sprite(0,  1, 0, flip, scale)
                pal()
                self:draw_sprite(0, 0, 0, flip, scale)
            end

            if self.got_hit_timer > 0 then
                self.got_hit_timer -= 1
                local da = {{-1,-1},{1,-1},{1,1},{-1,1}}
                for i = 1, 4 do
                    local dx, dy, gh3 = da[i][1], da[i][2], (3 - self.got_hit_timer)
                    line(
                        x + dx * gh3 * 0.5,
                        y + dy * gh3 * 0.5,
                        x + dx * gh3 * 1.5, 
                        y + dy * gh3 * 1.5,
                        8
                    )
                end
            end
            local sei = 0
            if self.t \ 4 % 2 == 0 then
                if self.regen != 0 then
                    spr(193, x - 4 + sei, y - 8)
                    sei += 3
                end
                if self.dot != 0 then
                    spr(192, x - 4 + sei, y - 8)
                    sei += 3
                end
                if self.stun > 0 then
                    spr(194, x - 4 + sei, y - 8)
                    sei += 3
                end         
            end
        end,

        draw_ui = function(self)
            local x, y = tpx(self.x), tpy(self.y)
            level, filled, total = self:get_level_filled_total_pips()
            if true or match.turn == 'sim' then
                local hpbmw = 6 + level * 1
                local w2 = hpbmw/2
                local hpbw = hpbmw * mid(self.health / self.max_health, 0, 1)
                local c1, c2 = 3, 11
                if self.apparent_team == 2 then
                    c1, c2 = 2, 8
                end
                line(x - w2, y + 3, x + w2 - 1, y + 3, c1)
                line(x - w2, y + 3, x - w2 - 1 + hpbw, y + 3, c2)  
                local mbw = hpbmw * mid(self.mana / self.max_mana, 0, 1)
                line(x - w2, y + 4, x + w2 - 1, y + 4, 1)
                if mbw > 0.5 then
                    line(x - w2, y + 4, x - w2 - 1 + mbw, y + 4, 12)    
                end
                line(x - w2 - 1, y + 3, x - w2 - 1, y + 4, level_colors[level])
                line(x + w2, y + 3, x + w2, y + 4, level_colors[level])
            end
            if match.turn == 'shop' then
                
                if level > 0 then
                    local c = level_colors[level]
                    for i = 1, total do
                        px = x - 5 + i * 2
                        rectfill(px, y + 5, px, y + 6, filled >= i and level_colors[level] or 0)
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

        spawn = function(self)
            self.alive = true
            self:find_target()
        end,

        sim_update = function(self)
            self.t += 1
            -- Dead?
            if self.dead then return end
            if not self.alive then
                self.spawn_time -= 1
                if self.spawn_time == 0 then
                    self:spawn()
                end
                return
            end

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
                    self:heal(self.regen / 2, nil)
                end
                if self.dot != 0 then
                    self:take_damage(self.dot / 2, nil, true)
                end
            end

            -- Mana
            self.mana = min(self.mana + 1, self.max_mana)

            -- Recoil from attacks
            self.recoil = {self.recoil[1] * 0.8, self.recoil[2] * 0.8}

            -- Attack speed cap
            self.attack_speed = min(self.attack_speed, 4)

            self.x = mid(self.x, grid_offset_x, grid_offset_x + arena_width)
            self.y = mid(self.y, grid_offset_y, grid_offset_y + arena_height)

            -- Stun
            if self.stun > 0 then
                self.stun -= 1
                if self.stun <= 0 then
                    self.spri = self.hero_index + 64
                end
                return
            end

            -- Targeting
            if not self.target or (self.target and not self.target.alive) then
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
                self.is_walking = true
                if self.targeting == "near" then
                    self.time_out_of_range += 1
                end
                if self.time_out_of_range > 20 then
                    self:find_target()
                end
            else
                self.is_walking = false
                self.time_out_of_range = 0
                if self.reload <= 0 then
                    self:attack()
                    self.reload += 30
                end
            end
            if self.reload > 0 then
                self.reload -= self.attack_speed
            end

            -- Ult
            if self.mana >= self.max_mana then
                if dsq <= self.ult_range ^ 2 then                
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
            local d = sqrt(hd(self, self.target))
            local dx, dy = (self.target.x - self.x) / d, (self.target.y - self.y) / d
            self.recoil = {-dx * 2, -dy * 2}
            make_attack_projectile(self, self.target, d / self.projectile_speed * 30, self.damage, self.hero_index)
        end,

        take_damage = function(self, damage, from, truedamage)
            if not truedamage then
                damage = max(damage - self.armor, 0)
            end
            if from then
                from.stat_damage += damage
            end
            if damage > 0 then
                self.got_hit_timer = 4
                self.health -= damage
                if self.health <= 0 then
                    self.alive = false
                    self.dead = true
                    sfx(19)
                end
            end
        end,

        heal = function(self, amt, from)
            if from then
                from.stat_heal += amt
            end
            self.health = min(self.health + amt, self.max_health)
        end,

        use_ult = function(self)
            self.just_ulted_timer = 7
            heroults[self.hero_index](self)
        end
    }
    for field,value in pairs(herostats[h.name]) do
        h[field] = value
        if field == 'max_health' then h.health = value end
    end

    local level = h:get_level_filled_total_pips()
    h.max_health = h.max_health * (1 + (level - 1) * 0.75)
    h.damage = h.damage * (1 + (level - 1) * 0.5)
    h.ult_value = get_ult_number(h.initial, level)

    -- mutators
    if match.mutators then
        local mut = match.mutators[h.index]
        if mut then
            mut[1](h, mut[2])
        end
    end

    h.range = h.range * grid_size * 1.1
    h.ult_range = h.ult_range * grid_size * 1.1

    h.health = h.max_health

    local base_stat_names = split"max_health,max_mana,damage,attack_speed,speed"
    for sn in all(base_stat_names) do
        h['base_'..sn] = h[sn]
    end

    return h
end