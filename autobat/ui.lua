function draw_game_ui()
    local t = match.shop_time_left
    if match.turn == "sim" then
        t = match.sim_time_left
    end
    local st = tostr(t\1)
    
    rectfill(116, 0, 127,46,5)
    rectfill(117, 0, 127,47,5)
    circfill(127,0,12,0)
    print(st, 124 - #st * 2, 2, 7)
    spr(208, 119, 14)
    print(match.wins, 121, 22, 10)
    spr(209, 119, 32)
    print(match.losses, 121, 40, 6)
end