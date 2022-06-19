function shop_start()
end

function shop_update()
    if btnp(4) then
        start_sim_turn()
        set_scene("sim")
    end
end

function shop_draw()
    cls()
    draw_arena()
end

function shop_finish()
end

scenes.shop = {
    start = shop_start,
    update = shop_update,
    draw = shop_draw,
    finish = shop_finish
}