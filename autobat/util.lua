function sort(a, cmp)
    for i=1,#a do
        local j = i
        while j > 1 and cmp(a[j-1], a[j]) do
            a[j],a[j-1] = a[j-1],a[j]
            j = j - 1
        end
    end
end

function roundrect(x1,y1,x2,y2)
    rectfill(x1,y1+1,x2,y2-1,5)
    rectfill(x1+1,y1,x2-1,y2,5)
end

function interp(s, ...)
    local parts = split(s, "%")
    local r = parts[1]
    for i,v in ipairs(arg) do
        r ..= v .. parts[i + 1]
    end
    return r
end