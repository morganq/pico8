herostats_fields = split("name,max_health,attack_speed,range,speed,damage,projectile_speed,targeting,max_mana,mana,ult,ult_base_num")
herostats = {}
for s_line in all(split(herostats_str, "\n")) do
    local letter = sub(s_line, 0, 1)
    herostats[letter] = {}
    local i = 1
    for field in all(split(s_line)) do
        herostats[letter][herostats_fields[i]] = field
        i += 1
    end
end

scenes = {}

scene = nil
function set_scene(s)
    if scene and scenes[scene].finish then scenes[scene].finish() end
    scene = s
    if scene and scenes[scene].start then scenes[scene].start() end
end

function _init()
    set_scene("title")
end

function _draw()
    cls(7)
    scenes[scene].draw()
end

function _update()
    scenes[scene].update()
end