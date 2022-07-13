pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
-- serial
-- by morganquirk

function serialize(t)
    if type(t) != "table" then return tostr(t) end
    local s = "{"
    for k,v in pairs(t) do
        s ..= k .. "=" .. serialize(v) .. ','
    end
    return s .. "}"
end

function deserialize(s)
    local i = 1
    local start = 1
    local t = {}
    local key = nil
    local val = nil
    while i < #s do
        local c = sub(s,i,i)
        if c == "=" then
            key = sub(s,start,i - 1)
            if tonum(key) != nil then key = tonum(key) end
            start = i + 1
        end
        if c == "," then
            if val then
                t[key] = val
                val = nil
            else
                t[key] = sub(s,start,i - 1)
                start = i + 1
                val = nil
            end
        end
        if c == "{" then
            local obj, ending = deserialize(sub(s,i + 1))
            if key != nil then
                val = obj
                i = ending + i
            else
                return obj
            end
        end    
        if c == "}" then
            return t, i
        end
        i += 1
    end
    return t, i
end

function _init()
    local t = {"hello", "world", {[0] = "zero", [1] = "one", five = 5}}
    --local t = {"hello", "world", {"joe"}}
    local st = serialize(t)
    print(st)
    local t2 = deserialize(st)
    print(serialize(t2))
    print(t2[1])
    print(t2[3].five)
end