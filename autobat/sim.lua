function make_attack_projectile(a, b, time, damage)
    debug(damage)
    e = {
        e1 = a,
        e2 = b,
        time = time,
        t = 0,
        x = a.x,
        y = a.y,
        damage = damage,
        draw = function(self)
            circfill(self.x, self.y, 2, 2)
        end,
        update = function(self)
            self.t += 1
            local t = (self.t / self.time)
            self.x = self.e1.x * t + self.e2.x * (1-t)
            self.y = self.e1.y * t + self.e2.y * (1-t)
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
end

function sim_update()
    for hero in all(arena.heroes) do
        if hero.alive then
            hero:sim_update()
        end
    end
    for ent in all(arena.ents) do
        ent:update()
    end    
    collide_ents()
end

function sim_draw()
    cls()
    draw_arena()
end

function sim_finish()
end

scenes.sim = {
    start = sim_start,
    update = sim_update,
    draw = sim_draw,
    finish = sim_finish
}