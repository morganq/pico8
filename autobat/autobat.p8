pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
-- autobat
-- by morganquirk

#include src.lua
#include title.lua
#include shop.lua
#include sim.lua
#include match.lua
#include arena.lua

function debug_str(o)
    if type(o) == 'table' then
        local s = "{\n"
        for k,v in pairs(o) do
            s ..= ' ' .. tostr(k) .. ' = ' .. debug_str(v) .. "\n"
        end
        return s.."}"
    else
        return tostr(o)
    end
end

function debug(o)
    s = debug_str(o)
    printh(s, "test.txt")
    print(s)
end