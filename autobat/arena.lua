sample_team = "u:33/o:20/z:31"

dimensions = {6,6}
grid_size = 11
grid_offset = {31, 10}
team_colors = {12, 10}

placement_coords = {}
for x = 0, dimensions[1]-1 do
    for y = 0, dimensions[2] \ 2 - 1 do
        add(placement_coords, {x,y + dimensions[2] \ 2})
    end
end

function serialize_gpt(pt)
    return tostr(pt[1] + pt[2] * dimensions[1])
end
function deserialize_gpt(s)
    local n = tonum(s)
    return {s % dimensions[1], s \ dimensions[1]}
end

function g2p(gx, gy)
    return {
        gx * grid_size + grid_offset[1],
        gy * grid_size + grid_offset[2]
    }
end

function p2g(px, py)
    return {
        (px - grid_offset[1]) \ grid_size,
        (py - grid_offset[2]) \ grid_size
    }
end

function create_arena(teams)
    arena = {
        heroes = {},
        ents = {},
    }
    for i = 1, 2 do
        local team = teams[i]
        for herospec in all(team) do
            local pos = herospec.pos
            if i == 2 then
                pos = {dimensions[1] - 1 - pos[1], dimensions[2] - 1 - pos[2]}
            end
            add(arena.heroes, create_hero(
                herospec.name,
                pos,
                i
            ))
        end
    end
end

function draw_arena()
    ent_rows = {}
    for i = 0, 127 do
        ent_rows[i] = {}
    end
    for hero in all(arena.heroes) do
        if hero.alive then
            add(ent_rows[hero.y\1], hero)
        end
    end
    for ent in all(arena.ents) do
        add(ent_rows[ent.y\1], ent)
    end
    rectfill(grid_offset[1] - 1, grid_offset[2] - 1, grid_offset[1] + grid_size * dimensions[1] - 1, grid_offset[2] + grid_size * dimensions[2] - 1, 7)
    for row = 0, dimensions[2] - 1 do
        for col = 0, dimensions[1] - 1 do
            local ppos = g2p(row, col)
            local color = 6
            if (row + col) % 2 == 1 then color = 13 end
            rectfill(ppos[1], ppos[2], ppos[1] + grid_size - 2, ppos[2] + grid_size - 2, color)
        end
    end
    for i = 0, 127 do
        for ent in all(ent_rows[i]) do
            ent:draw()
        end
    end

    -- debug
    for hero in all(arena.heroes) do
        if hero.target then
            --line(hero.x, hero.y, hero.target.x, hero.target.y, 8)
        end
    end
end