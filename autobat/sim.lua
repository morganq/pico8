function make_attack_projectile(a, b, time, damage, spri)
    e = {
        spri = spri,
        e1 = a,
        e2 = b,
        time = time,
        t = 0,
        x = a.x,
        y = a.y,
        damage = damage,
        d = sqrt(hd(a,b)),
        draw = function(self)
            palt(0b0000000000000001)
            local flipx = false
            local flipy = false
            if self.e2.x < self.e1.x then flipx = true end
            if self.e2.y > self.e1.y then flipy = true end
            if arena.my_team == 2 then
                flipx, flipy = not flipx, not flipy
            end
            spr(self.spri, tpx(self.x) - 3, tpy(self.y) - 6, 1, 1, flipx, flipy)
            palt()
        end,
        update = function(self)
            self.t += 1
            local t = (self.t / self.time)
            if self.d < 15 then
                t = min(t * 1.5, 1)
            end
            local dx = (self.e2.x - self.e1.x) / self.d
            local dy = (self.e2.y - self.e1.y) / self.d
            local targetx, targety = self.e2.x - dx * 4, self.e2.y - dy * 4
            self.x = self.e1.x * (1 - t) + targetx * t
            self.y = self.e1.y * (1 - t) + targety * t
            if self.t > self.time then
                if self.e2.alive then
                    self.e2:take_damage(self.damage, self.e1)
                    sfx(18 - self.e2.apparent_team)
                end
                del(arena.ents, self)
            end
        end,
    }
    add(arena.ents,e)
end

function make_circle_particle(x, y, rad, color, from)
    local e = {
        x = x,
        y = y,
        rad = rad,
        color = color,
        time = 10,
        from = from,
        draw = function(self)
            local x, y = tpx(self.x), tpy(self.y)-2
            circ(x,y, self.rad, self.color) 
            if self.from then
                line(tpx(self.from.x), tpy(self.from.y)-2, x, y-2, self.color)
            end
        end,
        update = function(self)
            self.time -= 1
            if self.time < 0 then del(arena.ents, self) end
        end,
    }
    add(arena.ents, e)
end

function make_projectile(x, y, dx, dy, color, on_hit, rad)
    local e = {
        x = x, y = y,
        dx = dx, dy = dy,
        on_hit = on_hit,
        hit = {},
        time = 0,
        rad = rad or 3,
        color = color,
        draw = function(self) 
            circfill(tpx(self.x), tpy(self.y), self.rad, self.color)
        end,
        update = function(self)
            self.time += 1
            self.x += self.dx * 1.25
            self.y += self.dy * 1.25
            for h in all(arena.heroes) do
                if count(self.hit, h) == 0 and h.alive then
                    local dsq = (self.x - h.x) ^ 2 + (self.y - h.y) ^ 2
                    if dsq < (self.rad + 4) ^ 2 then
                        add(self.hit, h)
                        local res = self.on_hit(h)
                        if res then del(arena.ents, self) end
                    end
                end
            end
            if self.time > 150 then
                del(arena.ents, self)
            end
        end
    }
    add(arena.ents, e)
    return e
end

function collide_ents()
    local rad2 = 5
    local h = arena.heroes
    for i = 1, #h do
        for j = i + 1, #h do
            local a,b = h[i], h[j]
            if a.alive and b.alive then
                local d = sqrt(hd(a,b))
                if d < rad2 then
                    local ndx, ndy, mpx, mpy = (b.x - a.x)/d * rad2 / 2,(b.y - a.y)/d * rad2 / 2, (b.x + a.x) / 2, (b.y + a.y) / 2
                    a.x = mpx - ndx
                    a.y = mpy - ndy
                    b.x = mpx + ndx
                    b.y = mpy + ndy
                end
            end
        end
    end
end

function draw_stat(h, y, total_damage, total_heal)
    spr(64 + h.hero_index, 1, y)
    mw = 13
    if h.stat_damage > 0 then
        rectfill(10, y + 2, 10 + h.stat_damage / total_damage * mw, y + 3, 8)
    end
    if h.stat_heal > 0 then
        rectfill(10, y + 4, 10 + h.stat_heal / total_heal * mw, y + 5, 11)
    end
end

function sim_start()
    for hero in all(arena.heroes) do
        --hero:sim_init()
        if hero.index > 1 then
            hero.alive = false
            hero.spawn_time = hero.index * 60 - 29
        end
    end
    sim_done = false
    sim_done_timer = 0    
    pre_sim_time = 15
end

function sim_tick()
    for hero in all(arena.heroes) do
        hero:sim_update()
    end
    for ent in all(arena.ents) do
        ent:update()
    end    
    collide_ents()  
end

function sim_update()
    if pre_sim_time > 0 then
        pre_sim_time -= 1
        return
    end

    match.sim_time_left -= 1/30

    if sim_done then
        sim_done_timer -= 1
        if sim_done_timer <= 0 then
            if match.wins >= match.wins_needed then
                global_message = "you win! :D"
                set_scene"message"
            elseif match.losses >= match.losses_needed then
                global_message = "you lose! :("
                set_scene"message"
            else
                start_shop_turn()
                set_scene"shop"
            end
        end
        return 
    end    
    sim_tick()
    if match.sim_time_left < 0 then
        for i = 1, 4 do sim_tick() end
        for hero in all(arena.heroes) do
            hero.dot += 1/5
        end
    end

    local alive_mine, alive_enemy = 0,0
    for hero in all(arena.heroes) do
        if not hero.dead then
            if hero.team == arena.my_team then alive_mine += 1 else alive_enemy += 1 end
        end
    end
    if alive_mine == 0 then
        match.losses += 1
        sim_done = 'defeat'
        sim_done_timer = 60
    end
    if alive_enemy == 0 then
        match.wins += 1
        sim_done = 'victory'
        sim_done_timer = 60
    end      
end

function sim_draw()
    camera(0, cos((15 - pre_sim_time) / 30) * 10 - 10)
    draw_arena()
    camera()
    draw_game_ui()
    local t = mid(sim_done_timer - 30, 0, 999)
    if sim_done == 'victory' then
        print("victory", 50, 44 - t, 0)
        print("victory", 50, 43 - t, 11)
    elseif sim_done == 'defeat' then
        print("defeat", 52, 44 - t, 0)
        print("defeat", 52, 43 - t, 8)
    end

    local max_damage, max_heal, y, stats = 200, 100, 4, {}
    for h in all(arena.heroes) do
        if h.team == arena.my_team and (h.stat_damage > 0 or h.stat_heal > 0) then
            max_damage = max(max_damage, h.stat_damage)
            max_heal = max(max_heal, h.stat_heal)
            add(stats, {h, h.stat_damage})
        end
    end

    sort(stats, function(a,b) return a[2] < b[2] end)

    for stat in all(stats) do
        local h = stat[1]
        if h.team == arena.my_team then
            draw_stat(h, y, max_damage, max_heal)
            y += 10            
        end
    end    
end

scenes.sim = {
    start = sim_start,
    update = sim_update,
    draw = sim_draw,
}