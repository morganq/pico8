herostats_fields = split"name,shortname,max_health,attack_speed,range,speed,damage,projectile_speed,targeting,max_mana,mana,ult,ult_base_num,ult_range"
herostats = {}
for s_line in all(split(herostats_str, "\n")) do
    local letter = sub(s_line, 0, 1)
    herostats[letter] = {}
    for i, field in ipairs(split(s_line)) do
        herostats[letter][herostats_fields[i]] = field
    end
end

scene = nil
function set_scene(s)
    if scene and scenes[scene].finish then scenes[scene].finish() end
    scene = s
    if scene and scenes[scene].start then scenes[scene].start() end
end

function _init()
    set_scene"title"
end

function _draw()
    cls(7)
    scenes[scene].draw()
end

function _update()
    scenes[scene].update()
end

global_message = ""
function message_start()
    message_time = 0
end
function message_draw()
    cls(7)
    print(global_message, 64 - #global_message * 2, 62, 0)
end
function message_update()
    message_time += 1
    if message_time >= 150 then
        set_scene"title"
    end
end

scenes = {message = {start = message_start, draw = message_draw, update = message_update}}