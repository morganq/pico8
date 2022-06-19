function sim_start()
end

function sim_update()
end

function sim_draw()
end

function sim_finish()
end

scenes.sim = {
    start = sim_start,
    update = sim_update,
    draw = sim_draw,
    finish = sim_finish
}