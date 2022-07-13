local mods = {
    {"$% mana cost", {33, 50}, function(h,v) h.max_mana = v / 100 * h.max_mana end},
    {"+$% damage", {50, 100, 150}, function(h,v) h.damage += v / 100 * h.damage end},
    {"+$% health", {100, 200, 300}, function(h,v) h.max_health += v / 100 * h.max_health end},
    {"+$% attack speed", {33, 50, 100}, function(h,v) h.attack_speed += v / 100 * h.attack_speed end},
    {"start with $% mana", {50, 100}, function(h,v) h.mana = v / 100 * h.max_mana end},
    {"+$ hp/sec", {2, 3, 4}, function(h,v) h.regen = v end},
    {"+$ range", {1,2}, function(h,v) h.range += v; h.ult_range += v end}
}

local places = split"1st,2nd,3rd,4th,5th,6th,7th,8th,9th"

function get_daily_mutators()
    srand(stat(91) * 50 + stat(92))
    local mutators, st, num, index = {}, "", rnd(2)\1 + 2, rnd(3)\1 + 1
    for i = 1, num do
        local mod = rnd(mods)
        local val = rnd(mod[2])
        mutators[index] = {mod[3], val}
        local s = split(mod[1], "$")
        st ..= places[index] .." hero: " .. s[1] .. val .. s[2] .. "\n"
        index += rnd(2)\1 + 1
    end
    return mutators, st
end