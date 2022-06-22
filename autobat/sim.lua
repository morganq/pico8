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
            --circfill(, 2, 2)
            palt(0b0000000000000001)
            local flipx = false
            local flipy = false
            if self.e2.x < self.e1.x then flipx = true end
            if self.e2.y > self.e1.y then flipy = true end
            if arena.my_team == 2 then
                flipx, flipy = not flipx, not flipy
            end
            spr(self.spri, tpx(self.x) - 3, tpy(self.y) - 3, 1, 1, flipx, flipy)
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
                    self.e2:take_damage(self.damage)
                end
                del(arena.ents, self)
            end
        end,
    }
    add(arena.ents,e)
end

function make_circle_particle(x, y, rad, color)
    local e = {
        x = x,
        y = y,
        rad = rad,
        color = color,
        time = 10,
        draw = function(self)
            local x, y = tpx(self.x), tpy(self.y)
            circ(x,y, self.rad, self.color) 
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
            local x, y = tpx(self.x), tpy(self.y)
            circfill(x, y, self.rad, self.color)
        end,
        update = function(self)
            self.time += 1
            self.x += self.dx * 1.25
            self.y += self.dy * 1.25
            for h in all(arena.heroes) do
                if count(self.hit, h) == 0 then
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
    local rad2 = 8
    local h = arena.heroes
    for i = 1, #h do
        for j = i + 1, #h do
            local a,b = h[i], h[j]
            if a.alive and b.alive then
                local dsq = hd(a,b)
                if dsq < rad2^2 then
                    local dx, dy = b.x - a.x, b.y - a.y
                    local d = sqrt(dsq)
                    local ndx, ndy = dx/d,dy/d
                    a.x = (b.x + a.x) / 2 - ndx * rad2 / 2
                    a.y = (b.y + a.y) / 2 - ndy * rad2 / 2
                    b.x = (b.x + a.x) / 2 + ndx * rad2 / 2
                    b.y = (b.y + a.y) / 2 + ndy * rad2 / 2                
                end
            end
        end
    end
end

function sim_start()
    for hero in all(arena.heroes) do
        hero:sim_init()
    end
    sim_done = false
    sim_done_timer = 0    
end


function sim_update()
    if sim_done then
        sim_done_timer -= 1
        if sim_done_timer <= 0 then
            start_shop_turn()
            set_scene("shop")            
        end
        return 
    end
    match.sim_time_left -= 1/30
    for hero in all(arena.heroes) do
        if hero.alive then
            hero:sim_update()
        end
    end
    for ent in all(arena.ents) do
        ent:update()
    end    
    collide_ents()

    if #heroes_by_team(arena.my_team) == 0 then
        match.losses += 1
        sim_done = 'defeat'
        sim_done_timer = 60
    end
    if #heroes_by_team(3 - arena.my_team) == 0 then
        match.wins += 1
        sim_done = 'victory'
        sim_done_timer = 60
    end
end

function sim_draw()
    draw_arena()
    draw_game_ui()
    local t = mid(sim_done_timer - 30, 0, 999)
    if sim_done == 'victory' then
        print("victory", 50, 44 - t, 0)
        print("victory", 50, 43 - t, 11)
    elseif sim_done == 'defeat' then
        print("defeat", 52, 44 - t, 0)
        print("defeat", 52, 43 - t, 8)
    end
end

function sim_finish()
end

scenes.sim = {
    start = sim_start,
    update = sim_update,
    draw = sim_draw,
    finish = sim_finish
}