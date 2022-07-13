-- Given x,y and grid width and height, supply the 4 adjacent neighbors
-- Skips out-of-bounds tiles
function neighbors_iter(x,y,gw,gh)
    local n = {}
    if x > 1  then add(n, {x-1, y}) end
    if x < gw then add(n, {x+1, y}) end
    if y > 1  then add(n, {x, y-1}) end
    if y < gh then add(n, {x, y+1}) end

    -- Return an iterator thru n
    local i = 0
    return function()
        if i < #n then i += 1; return n[i][1], n[i][2] end
    end
end

-- Given a grid, supply all the cells... returns each with: x, y, cell data.
function data_iter(grid)
    local x, y = 0,1
    return function()
        x += 1
        if x > grid.w then
            x = 1
            y += 1
        end
        if y <= grid.h then
            return x, y, grid.data[y][x]
        end
    end
end

-- Expects an array-table of tuples
-- {{value1, weight1}, {value2, weight2}, ...
function weighted_rnd(t)
    local total = 0
    for r in all(t) do
        total += r[2]
    end
    local n = rnd(total + 1) \ 1 
    for r in all(t) do
        n -= max(r[2],0)
        if n < 0 then
            return r[1]
        end
    end
    return t[#t][1]
end

-- Delta offset {x,y} to number (1-9), 1 = top left, 3 = top right, 7 = bottom left, 9 = bottom right
function d2n(delta)
    return (delta[1] + 1) + (delta[2] + 1) * 3 + 1
end

-- Opposite of ^
function n2d(num)
    num = num - 1
    return {(num % 3) - 1, num \ 3 - 1}
end

-- Given dimensions and an adjacency table, return a new grid object.
-- This is the data structure that the wave function collapse algorithm runs on
function make_grid(w, h, adjacency)
    local g = {
        w = w, h = h,
        min_tile_index = 256,
        max_tile_index = 0,
        num_tiles = 0,
        data = {},
        adjacency = adjacency
    }
    -- Infer the min and max tile indices from the adjacency table
    for k,v in pairs(adjacency) do
        g.max_tile_index = max(k, g.max_tile_index)
        g.min_tile_index = min(k, g.min_tile_index)
    end
    g.num_tiles = g.max_tile_index - g.min_tile_index + 1

    -- Populate the grid with max-entropy cells
    for y = 1, h do
        g.data[y] = {}
        for x = 1, w do
            -- This is the structure of a cell:
            g.data[y][x] = {
                super={}, -- Superposition - array of tiles this could possibly be
                picked=nil, -- Tile index of picked tile
                locked=false -- Boolean, true if this can never be changed by the algorithm
            }
            for z = g.min_tile_index, g.max_tile_index do
                add(g.data[y][x].super, z) -- Add every tile to the superposition
            end
        end
    end
    return g
end

-- mset based on the grid
function stamp_grid_to_map(grid, xo, yo)
    xo = xo or 0; yo = yo or 0
    for x, y, cell in data_iter(grid) do
        mset(x + xo, y + yo, cell.picked)
    end
end

-- radix sort, create a bin for each possible entropy-value
-- range is [0, total number of tiles]
-- and put each grid square into its appropriate bin.
-- Necessary because in wave_step we need to find the lowest-entropy
-- or highest-entropy grid squares.
function get_entropy_bins(grid, include_picked)
    local bins = {[0]={}}
    for i = 1, grid.num_tiles do
        bins[i] = {}
    end
    for x, y, cell in data_iter(grid) do
        if include_picked or not cell.picked then
            add(bins[#cell.super],{x=x, y=y, cell=cell})
        end
    end
    return bins
end

function constrain(grid, x, y)
    local cell = grid.data[y][x]
    for nx, ny in neighbors_iter(x,y,grid.w,grid.h) do
        local ncell = grid.data[ny][nx]
        if ncell.picked then
            local dir = d2n({nx - x, ny - y})
            local i = #cell.super
            while i > 0 do 
                local option = cell.super[i]
                if grid.adjacency[option] then
                    local diroption = grid.adjacency[option][dir]
                    if diroption == nil or diroption[ncell.picked] == nil then
                        deli(cell.super, i)
                    end
                end
                i -= 1
            end           
        end
    end
    if #cell.super == 0 then
        cell.picked = nil
    end
end

function reset_tile(grid,x,y)
    grid.data[y][x].picked = nil
    grid.data[y][x].super = {}
    for i = grid.min_tile_index, grid.max_tile_index do
        add(grid.data[y][x].super, i)
    end
end

function wave_step(grid, lookup_weights)
    local bins, bini, found, picked = get_entropy_bins(grid), 1, false, nil
    lookup_weights = lookup_weights or {}

    -- Pick a random tile for the step
    -- Most of the time, pick the lowest entropy
    while not found do
        if bini > grid.num_tiles then break end
        if #bins[bini] > 0 then
            picked = rnd(bins[bini])
            found = true
        end
        bini += 1
    end

    -- Rarely, highest entropy (to pick some random tile way out there)
    if rnd() < 0.1 then
        found = false
        bini = grid.num_tiles
        while not found do
            if bini == 0 then break end
            if #bins[bini] > 0 then
                picked = rnd(bins[bini])
                found = true
            end
            bini -= 1
        end
    end

    -- If we didn't find any that means we only have invalid tiles remaining
    if not found then
        picked = rnd(bins[0])
        if picked == nil then return true end
        for nx,ny in neighbors_iter(picked.x,picked.y,grid.w,grid.h) do
            local cell = grid.data[ny][nx]
            if not cell.locked then
                if rnd() < 0.02 or #cell.super == 1 then
                    reset_tile(grid, nx, ny)
                else
                    cell.picked = rnd(cell.super)
                end
            end
        end   
        for nx,ny in neighbors_iter(picked.x,picked.y,grid.w,grid.h) do
            constrain(grid, nx,ny)
        end
        reset_tile(grid, picked.x, picked.y)
        constrain(grid, picked.x, picked.y)
        return false
    end    

    local weights = {}
    for t in all(picked.cell.super) do
        weight = 1
        if fget(t, 0) then weight += 2 end
        if fget(t, 1) then weight += 4 end
        if fget(t, 2) then weight += 8 end
        if fget(t, 3) then weight += 16 end
        if weight == 1 and lookup_weights[t] != nil then
            weight += lookup_weights[t]
        end
        add(weights, {t, weight})
    end    

    grid.data[picked.y][picked.x].picked = weighted_rnd(weights)
    constrain(grid, picked.x, picked.y)
    for nx,ny in neighbors_iter(picked.x, picked.y, grid.w, grid.h) do
        constrain(grid, nx, ny)
    end
    return false
end

function lock(grid, x, y, t)
    grid.data[y][x].picked = t
    grid.data[y][x].locked = true
    for nx,ny in neighbors_iter(x,y, grid.w, grid.h) do
        constrain(grid, nx, ny)
    end
end