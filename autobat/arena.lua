sample_team = "u1:33/o1:20/z1:31"

dimensions = {6,6}
grid_size = 11
grid_offset = {32, 8}
team_colors = {12, 10}

placement_coords = {}
for x = 0, dimensions[1]-1 do
    for y = 0, dimensions[2] \ 2 - 1 do
        add(placement_coords, {x,y + dimensions[2] \ 2})
    end
end

function tpx(x)
    if arena.my_team == 1 then return x end
    return 127 - x
end
function tpy(y)
    if arena.my_team == 1 then return y end
    return grid_size * dimensions[2] - (y - grid_offset[2]) + grid_offset[2]
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
                pos = {dimensions[1] - 1 - pos[1], dimensions[2] - 1 - pos[2]}
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
    rect(grid_offset[1] - 2, grid_offset[2] - 2, grid_offset[1] + grid_size * dimensions[1], grid_offset[2] + grid_size * dimensions[2], 5)
    rectfill(grid_offset[1] - 1, grid_offset[2] - 1, grid_offset[1] + grid_size * dimensions[1] - 1, grid_offset[2] + grid_size * dimensions[2] - 1, 7)
    for row = 0, dimensions[2] - 1 do
        for col = 0, dimensions[1] - 1 do
            local ppos = g2p(row, col)
            local c1, c2 = 7,6
            if (row + col) % 2 == 1 then c1,c2 = 6,13 end
            rectfill(ppos[1] - 0, ppos[2] - 0, ppos[1] + grid_size - 2, ppos[2] + grid_size - 2, c1)
            --rectfill(ppos[1] + 3, ppos[2] + 3, ppos[1] + grid_size - 5, ppos[2] + grid_size - 5, c2)
        end
    end
    for hero in all(arena.heroes) do
        local x, y = tpx(hero.x), tpy(hero.y)
        --line(x-3,y + 2, x+2,y+2,0)
        --ovalfill(x - 4, y + 0, x + 3, y + 4, 0)
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

    -- debug
    for hero in all(arena.heroes) do
        if hero.target then
            --line(hero.x, hero.y, hero.target.x, hero.target.y, 8)
        end
    end
end