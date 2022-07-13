function infer_adjacency_map()
    local t, gx, gy, mgx, mgy = {}, 1, 1, 64, 64
    while gx < mgx do
        if mget(gx - 1, gy - 1) == 0 then mgx = gx
        else 
            while gy < mgy do
                local zerotile = mget(gx - 1,gy - 1)
                if zerotile == 0 then mgy = gy
                else
                    for nc in all(get_neighbor_coords(gx,gy,64,64)) do
                        local ntile = mget(nc[1] - 1, nc[2] - 1)
                        local delta_num = d2n({nc[1] - gx, nc[2] - gy})
                        if ntile != 0 then
                            if t[zerotile] then
                                if t[zerotile][delta_num] then
                                    t[zerotile][delta_num][ntile] = 1
                                else
                                    t[zerotile][delta_num] = {[ntile] = 1}
                                end
                            else
                                t[zerotile] = {[delta_num] = {[ntile] = 1}}
                            end
                        end
                    end
                end
                gy += 1
            end
        end
        gx += 1
        gy = 1
    end
    return t
end

hex = split("0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f")

function get_border_colors(tile, dir_name)
    local x,y,dx,dy,cs = 0,0,0,0,""
    if dir_name == "left" then x = 0; y = 0; dx = 0; dy = 1 end
    if dir_name == "right" then x = 7; y = 0; dx = 0; dy = 1 end
    if dir_name == "up" then x = 0; y = 0; dx = 1; dy = 0 end
    if dir_name == "down" then x = 0; y = 7; dx = 1; dy = 0 end
    local tx, ty = tile % 16 * 8, tile \ 16 * 8
    for i = 0,7 do
        cs ..= hex[sget(tx + x, ty + y)+1]
        x += dx
        y += dy
    end
    return cs
end

function infer_adjacency_colors(min_tile_index, max_tile_index)
    t = {}
    tile_borders = {}
    for tile = min_tile_index, max_tile_index do
        tile_borders[tile] = {}
        tile_borders[tile]['up'] = get_border_colors(tile, 'up')
        tile_borders[tile]['down'] = get_border_colors(tile, 'down')
        tile_borders[tile]['left'] = get_border_colors(tile, 'left')
        tile_borders[tile]['right'] = get_border_colors(tile, 'right')
    end

    for t1 = min_tile_index, max_tile_index do
        t[t1] = {[2] = {}, [4] = {}, [6] = {}, [8] = {}}
        for t2 = min_tile_index, max_tile_index do
            if tile_borders[t1]['up'] == tile_borders[t2]['down'] then 
                t[t1][2][t2] = 1
            end
            if tile_borders[t1]['left'] == tile_borders[t2]['right'] then 
                t[t1][4][t2] = 1
            end      
            if tile_borders[t1]['right'] == tile_borders[t2]['left'] then 
                t[t1][6][t2] = 1
            end                  
            if tile_borders[t1]['down'] == tile_borders[t2]['up'] then 
                t[t1][8][t2] = 1
            end            
        end
    end

    return t
end