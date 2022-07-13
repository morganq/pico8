function debug_adjacency_table(t)
    for ti, adj in pairs(t) do
        printh(ti, "test.txt")
        for dir, ntiles in pairs(adj) do
            printh(" " .. dir, "test.txt")
            for nt, val in pairs(ntiles) do
                printh("  " .. nt, "test.txt")
            end
        end
    end
end

function debug_draw_grid(g)
    cls(7)
    for x,y,cell in data_iter(g) do
        --rectfill(x * 8 - 8, y * 8 - 8, x * 8, y * 8, ((x + y) % 2 == 0) and 6 or 7)
        if cell.picked then
            spr(cell.picked, x * 8 - 8, y * 8 - 8)
            --print(#cell.super, x * 8 - 7, y * 8 - 6, 0)
        elseif #cell.super > 0 then
            print(#cell.super, x * 8 - 7, y * 8 - 6, 0)
        else
            print("x", x * 8 - 7, y * 8 - 6, 0)
        end
    end
end