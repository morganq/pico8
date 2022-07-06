function title_start()
    tt = 0
    game_seed = rnd(32767)
end

gamemode = 1
difficulty = 1
function title_update()
    tt += 1
    if btnp(4) then
        if gamemode == 3 then
            start_match(gamemode, 1, get_daily_mutators(), get_daily_team_progression())
        else
            start_match(gamemode, difficulty)
        end
        
        set_scene("shop")
    end
    if btnp(2) and gamemode > 1 then gamemode -= 1; difficulty = 1 end
    if btnp(3) and gamemode < 3 then gamemode += 1; difficulty = 1 end
    if btnp(0) and difficulty == 2 then difficulty = 1 end
    if btnp(1) and difficulty == 1 then difficulty = 2 end
end

--random_offset = rnd(26)\1

function title_draw()
    cls(7)
    rectfill(34,8,92, 16, 8)
    print("pico autochess", 36, 10, 7)

    local y = 32
    local mutators, mut_string = get_daily_mutators()

    print("- mode -", 48, y, 4)
    rectfill(0, y - 2 + gamemode * 10, 127, y + 6 + gamemode * 10, tt \ 12 % 2 == 0 and 4 or 2)
    local names = split("arena,head to head,head to head daily challenge")
    for i = 1,3 do
        print(names[i], 4, y + i * 10, 9)
        if gamemode == i and gamemode < 3 then
            print("normal", 68, y + i * 10, difficulty == 1 and 7 or 5)
            print("unfair", 98, y + i * 10, difficulty == 2 and 7 or 5)
        end
    end
    rectfill(0,94,127,127,6)
    
    local ss = ""
    if gamemode == 1 then
        ss = "> defeat random teams each\nround. 9   to win."
        spr(217, 40, 101)
    elseif gamemode == 2 then
        ss = "> fight against a single ai\nteam. first to 7   wins."
        spr(217, 72, 101)
    elseif gamemode == 3 then
        ss = "> "..stat(91).."/"..stat(92).." challenge:\n" .. mut_string
    end
    print(ss, 6, 96, 13)
    spr(213, 108, 117, 2, 1)
    print("🅾️", 113, 118, tt \ 12 % 2 == 0 and 0 or 7)
end

function title_finish()
end

scenes.title = {
    start = title_start,
    update = title_update,
    draw = title_draw,
    finish = title_finish
}