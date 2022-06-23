function draw_game_ui()
    rectfill(115, 0, 127,46,5)
    rectfill(116, 0, 127,47,5)
    circfill(127,0,12,0)    
    if match.turn == "sim" then
        t = match.sim_time_left
        t = max(t,0)
        local st = tostr(t\1)
        
        print(st, 124 - #st * 2, 2, 7)
    end
    spr(208, 119, 14)
    print(match.wins .. "/" .. max_wins, 116, 22, 10)
    spr(209, 119, 32)
    print(match.losses .. "/" .. max_losses, 116, 40, 6)
end