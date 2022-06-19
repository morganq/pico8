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

function create_hero(name, gpos, team)
    local ppos = g2p(gpos[1], gpos[2])
    local h = {
        name = name,
        team = team,
        spri = 0,
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

        -- detail
        reload = 0,
        time_out_of_range = -30, -- start with negative as heroes run across the map

        draw = function(self)
            ovalfill(self.x - 4, self.y - 4, self.x + 3, self.y + 3, 0)
            ovalfill(self.x - 4, self.y - 5, self.x + 3, self.y + 2, team_colors[self.team])
            print(self.name, self.x - 2, self.y - 3, 1)
        end,

        update = function(self)
        end,

        find_target = function(self)
            function mydist(o)
                return (o.x - self.x)^2 + (o.y - self.y)^2
            end
            self.target = enemies(self, function(a,b) return mydist(a) > mydist(b) end)[1]            
        end,

        sim_init = function(self)
            self:find_target()
        end,
        sim_update = function(self)
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
                self.time_out_of_range += 1
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
        end,

        attack = function(self)
            make_attack_projectile(self, self.target, sqrt(hd(self, self.target)) / self.projectile_speed * 30, 10)
        end,

        take_damage = function(self, damage)
            self.health -= damage
            if self.health <= 0 then
                self.alive = false
            end
        end
    }
    return h
end