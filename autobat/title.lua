function title_start()
end

function title_update()
    if btnp(4) then
        start_match()
        set_scene("shop")
    end
end

function title_draw()
    cls(7)
    print("unnamed autobattler", 26, 10, 0)
    lines = split("each hero costs 3 gold\nreroll costs 1 gold\nduplicates merge\nz to finish shopping\nshop freezes between rounds\nheroes spawn in buy order", "\n")
    i = 44
    for l in all(lines) do
        print('-'..l, 9, i, 5)
        i += 7
    end
    print("z to start", 42, 110, 0)
end

function title_finish()
end

scenes.title = {
    start = title_start,
    update = title_update,
    draw = title_draw,
    finish = title_finish
}