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
    scenes[scene].draw()
end

function _update()
    scenes[scene].update()
end