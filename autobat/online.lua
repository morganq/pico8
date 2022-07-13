function get_online_team_record()
    local teamstr = rnd(scoresub('autobattle'))
    local team = {}
    for roundstr = split(teamstr,"|") do
        add(team, deserialize_team(roundstr))
    end
    return team
end

function save_team_record(team_record)
    local s = ""
    for i,team in ipairs(team_record) do
        s .. = serialize_team(team)
        if i < #team_record then s ..= "|" end
    end
    scoresub('autobattle', len(team_record), s)
end