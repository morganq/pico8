function _init()
    adj = infer_adjacency_colors(1, 29)
    grid = make_grid(18, 18, adj)
    lookup_weights = {}
    calc()
end

function calc()
    lookup_weights = {}
    --for i = grid.max_tile_index, grid.max_tile_index do
    --    lookup_weights[i] = rnd(4) \ 1 ^ 4
    --end
    lookup_weights[rnd(grid.num_tiles + 1) \ 1 + grid.min_tile_index] = 32
    while not wave_step(grid, lookup_weights) do end
    stamp_grid_to_map(grid, 0, 0)    
end

function _draw()
    cls(7)
    map(2, 2, 0, 0, 16, 16)
end

function rec_side(x,y,dx,dy)
    saved = {}
    for i = 1, 16 do
        add(saved,mget(x, y))
        x += dx
        y += dy
    end
end

function lock_side(x,y,dx,dy)
    for i = 1, 16 do
        lock(grid, x, y, saved[i])
        x += dx
        y += dy
    end
end

function _update()
    if btn(0) then
        rec_side(2, 2, 0, 1)
        grid = make_grid(18, 18, adj)
        lock_side(18, 2, 0, 1)
        calc()
    end
    if btn(1) then
        rec_side(17, 2, 0, 1)
        grid = make_grid(18, 18, adj)
        lock_side(1, 2, 0, 1)
        calc()
    end
    if btn(2) then
        rec_side(2, 2, 1, 0)
        grid = make_grid(18, 18, adj)
        lock_side(2, 18, 1, 0)
        calc()
    end
    if btn(3) then
        rec_side(2, 17, 1, 0)
        grid = make_grid(18, 18, adj)
        lock_side(2, 1, 1, 0)
        calc()
    end    
end