function draw_game_ui()
    roundrect(115,0,127,47)
    circfill(127,0,12,0)    
    if match.turn == "sim" then
        local st = tostr(max(match.sim_time_left, 0)\1)
        print(st, 124 - #st * 2, 2, 7)
    end
    spr(208, 119, 14)
    print(match.wins .. "/" .. match.wins_needed, 116, 22, 10)
    spr(209, 119, 32)
    print(match.losses .. "/" .. match.losses_needed, 116, 40, 6)
end