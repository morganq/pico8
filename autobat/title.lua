function title_start()
end

function title_update()
    if btnp(4) or btnp(5) then
        set_scene("shop")
    end
end

function title_draw()
    cls()
end

function title_finish()
end

scenes.title = {
    start = title_start,
    update = title_update,
    draw = title_draw,
    finish = title_finish
}