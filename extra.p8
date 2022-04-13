    local e = ent()
    for j = 0, 2 do
        local polys = {}
        local rad = 5 - j
        local count = 6
        if j == 1 then count = 12 end
        for i = 1, count do
            local y = j
            local s1 = sin(i / count * 6.28 + 0.05) * rad
            local c1 = cos(i / count * 6.28 + 0.05) * rad
            local s2 = sin((i + 1) / count * 6.28 - 0.05) * rad
            local c2 = cos((i + 1) / count * 6.28 - 0.05) * rad  
            local atten = 0.65
            if j == 1 then atten = 1 end
            add(polys, poly({
                vec(s1 * atten,0.8 + j * 2,c1 * atten),
                vec(s1,-0.6 + j * 2,c1),
                vec(s2,-0.6 + j * 2,c2),
                vec(s2 * atten,0.8 + j * 2, c2 * atten),
            }, j == 1))
        end
        add(e.parts, part(polys, m_translate(0, 0, 0)))
    end 