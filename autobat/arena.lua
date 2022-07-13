grid_size = 11
arena_width, arena_height, grid_offset_x, grid_offset_y = 6 * grid_size, 6 * grid_size, 32, 9

function tpx(x)
    if arena.my_team == 1 then return x end
    return 129 - x
end
function tpy(y)
    if arena.my_team == 1 then return y end
    return grid_size * 6 - (y - grid_offset_y) + grid_offset_y
end

function serialize_gpt(pt)
    return tostr(pt[1] + pt[2] * 6)
end

function deserialize_gpt(s)
    local n = tonum(s)
    return {s % 6, s \ 6}
end

function g2p(gx, gy)
    return {
        gx * grid_size + grid_offset_x,
        gy * grid_size + grid_offset_y
    }
end

function p2g(px, py)
    return {
        (px - grid_offset_x) \ grid_size,
        (py - grid_offset_y) \ grid_size
    }
end

function create_arena(my_team, enemy_team)
    arena = {
        heroes = {},
        ents = {},
        my_team = 1,
    }
    local teams = {my_team, enemy_team}
    if enemy_team then
        -- Team with the lower string value when serialized is team1
        if serialize_team(my_team) > serialize_team(enemy_team) then
            teams = {enemy_team, my_team}
            arena.my_team = 2
        end    
    end
    arena.teams = teams
    for i = 1, #teams do
        local team = teams[i]
        local j = 1
        for herospec in all(team) do
            local pos = herospec.pos
            if i == 2 then
                pos = {5 - pos[1], 5 - pos[2]}
            end
            add(arena.heroes, create_hero(
                herospec.name,
                herospec.pips,
                pos,
                i,
                j
            ))
            j += 1
        end
    end
end

function draw_arena()
    ent_rows = {}
    for i = 0, 127 do
        ent_rows[i] = {}
    end
    for hero in all(arena.heroes) do
        add(ent_rows[hero.y\1], hero)
    end
    rect(grid_offset_x - 2, grid_offset_y - 2, grid_offset_x + grid_size * 6, grid_offset_y + grid_size * 6, 5)
    rectfill(grid_offset_x - 1, grid_offset_y - 1, grid_offset_x + grid_size * 6 - 1, grid_offset_y + grid_size * 6 - 1, 7)
    for row = 0, 5 do
        for col = 0, 5 do
            local ppos = g2p(row, col)
            local c1 = 7
            if (row + col) % 2 == 1 then c1,c2 = 6 end
            rectfill(ppos[1] - 0, ppos[2] - 0, ppos[1] + grid_size - 2, ppos[2] + grid_size - 2, c1)
        end
    end
    for i = 0, 127 do
        for ent in all(ent_rows[i]) do
            ent:draw()
        end
    end

    for ent in all(arena.ents) do
        ent:draw() 
    end

    -- ui
    for hero in all(arena.heroes) do
        if hero.alive then
            hero:draw_ui()
        end
    end    
end