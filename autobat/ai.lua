function make_ai_team(round_num)
    local team = {}
    for i = 1, round_num do
        team = do_ai_team_round(team, round_num)
    end
    return team
end

function do_ai_team_round(old_team, round_num, money_bonus)
    local max_heroes = round_heroes[round_num] or 9
    local money = 8 + (money_bonus or 0)
    local team = {}
    for h in all(old_team) do add(team, create_herospec(h.name, h.pos, h.pips)) end
    function incpips(h) h.pips = min(h.pips + 1, 7) end

    while money >= 3 do
        if #team < max_heroes then
            local initial = chr(rnd(26)\1 + 97)
            local found = false
            for h in all(team) do
                if h.name == initial then
                    incpips(h)
                    money -= 3
                    found = true
                    break
                end
            end
            if not found then
                add(team, create_herospec(initial, find_open_spot(herostats[initial], team), 1))
                money -= 3
            end
        else
            if rnd() > 2 / (#team + 4) then
                incpips(rnd(team))
                money -= 3
            end
        end
        money -= 1
    end

    return team 

end