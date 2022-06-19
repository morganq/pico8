pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
-- vecdrawer
-- by morganquirk

poke(0x5f2d, 0x01)

record = {}

function _init()

end

function _update60()
    local x,y = stat(32), stat(33)
    if stat(34) == 1 then
        add(record, {x,y})
    end
    if btnp(5) then
        local s = ""
        local last = {0,0}
        for p in all(record) do
            if abs(p[1] - last[1]) >= 1 or abs(p[2] - last[2]) >= 1 then
                s ..= p[1] + p[2] * 128 .. ","
                last = p
            end
            
        end
        printh(s, "test.txt")
    end
end

function _draw()
    cls(7)
    line(0, 5, 128, 5, 6)
    line(0, 40, 128, 40, 6)
    line(64, 6, 64, 40, 6)
    for p in all(record) do
        pset(p[1], p[2], 0)
    end
    pset(stat(32), stat(33), 8)
end