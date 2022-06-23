function make_ai_team(round)
    local team = {}
    local max_heroes = 1
    for i = 1, round do
        max_heroes += 1
        local money = 8

        while money >= 3 do
            if #team < max_heroes then
                -- Sometimes we merge
                if #team > 0 and rnd() < 0.25 then
                    rnd(team).pips += 1
                else -- Other times we pick randomly
                    local initial = chr(rnd(26)\1 + 97)
                    local found = false
                    for h in all(team) do
                        if h.name == initial then
                            h.pips += 1
                            found = true
                            break
                        end
                    end
                    if not found then
                        add(team, create_herospec(initial, find_open_spot(herostats[initial], team), 1))
                    end
                end
                
            else
                if rnd() < 0.5 then
                    rnd(team).pips += 1
                end
            end
            money -= 3
        end
    end
    return team
end