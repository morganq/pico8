dimensions = {6,6}
grid_size = 10
grid_offset = {34, 14}

placement_coords = {}
for x = 0, dimensions[1]-1 do
    for y = 0, dimensions[2] \ 2 - 1 do
        add(placement_coords, {x,y})
    end
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
    }
    for team in all(teams) do
        for herospec in all(team) do
            create_hero(herospec.name, g2p(herospec.pos[1], herospec.pos[2]))
        end
    end
end