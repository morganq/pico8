0b1100111100111111.1 -- brick

0b0111111111011111.1 -- 2/16
0b0101111101011111.1 -- 4/16
0b0101111001011011.1 -- 6/16
0b0101101001011010.1 -- 8/16
0b0100101000011010.1 -- 10/16
0b0000101000001010.1 -- 12/16
0b0000001000000100.1 -- 14/16
0b0000000000000000 -- 16/16

    local count = 16
    local rad = 5
    local polys = {}
    local parts = {part({}), part({}), part({})}
    for i = 1, count do
        local s1 = sin(i / count * 6.28 + 0.1) * rad
        local c1 = cos(i / count * 6.28 + 0.1) * rad
        local s2 = sin((i + 1) / count * 6.28 - 0.1) * rad
        local c2 = cos((i + 1) / count * 6.28 - 0.1) * rad
        local s3 = sin((i + 0.5) / count * 6.28) * rad
        local c3 = cos((i + 0.5) / count * 6.28) * rad    
        local s4 = sin(i / count * 6.28) * rad
        local c4 = cos(i / count * 6.28) * rad
        local s5 = sin((i + 1) / count * 6.28) * rad
        local c5 = cos((i + 1) / count * 6.28) * rad            
        add(parts[1].polys, poly({
            vec(s4, 0, c4),
            vec(s5, 0, c5),
            vec(s5, 0.3, c5),
            vec(s4, 0.3, c4),
        }, false, true, 2))
        add(parts[2].polys, poly({
            vec(s1, 0.3, c1),
            vec(s2, 0.3, c2),
            vec(s2, 1, c2),
            vec(s1, 1, c1),
        }, false, false, 2))
        add(parts[3].polys, poly({
            vec(s1, 1, c1),
            vec(s2, 1, c2),
            vec(s3, 2.5, c3),
            vec(s3, 2.5, c3),
        }, false, true, 2))       
    end    


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


    --[[
    local polys = {
    }
    for i = 1, 3 do
        local t = i / 3 * 6.2818
        local s1, c1, s2, c2 = sin(t + 0.8), cos(t + 0.8), sin(t - 0.8), cos(t - 0.8)
        add(polys, 
            poly({
                {s2 * 0.35, c2 * 0.35, 0, 1},
                {s2 * 0.01, c2 * 0.01, -1, 1},
                {s1 * 0.01, c1 * 0.01, -1, 1},
                {s1 * 0.35, c1 * 0.35, 0, 1},
            }, false)
        )
    end
    add(polys, 
        poly({
            {0.1, -0.1, -0.25, 1},
            {0.1, 0.1, -0.25, 1},
            {-0.1, 0.1, -0.25, 1},
            {-0.1, -0.1, -0.25, 1},
        }, true)
    )  ]]
    --e.parts = {part(polys)}    

local e = ent()
    local rads = {2, 1}
    local attens = {0.5,1}
    local heights = {1, 3}
    local y =0
    for j = 1, 2 do
        local polys = {}
        local rad = rads[j]
        local count = 4
        for i = 1, count do
            local s1 = sin(i / count * 6.28 + 0.05 + 0.8) * rad
            local c1 = cos(i / count * 6.28 + 0.05 + 0.8) * rad
            local s2 = sin((i + 1) / count * 6.28 - 0.05 + 0.8) * rad
            local c2 = cos((i + 1) / count * 6.28 - 0.05 + 0.8) * rad  
            local atten = attens[j]
            add(polys, poly({
                vec(s1 * atten,heights[j],c1 * atten),
                vec(s1,y,c1),
                vec(s2,y,c2),
                vec(s2 * atten,heights[j], c2 * atten),
            }, false))
        end
        y += 1
        add(e.parts, part(polys, m_translate(0, 0, 0)))
    end
    local polys = {}
    local count = 4
    local rad = 1.5
    for i = 1, count do
        local s1 = sin(i / count * 6.28 + 0.05) * rad
        local c1 = cos(i / count * 6.28 + 0.05) * rad
        local s2 = sin((i + 1) / count * 6.28 - 0.05) * rad
        local c2 = cos((i + 1) / count * 6.28 - 0.05) * rad
        add(polys, poly({
            vec(s1,heights[2] + 1,c1),
            vec(s1,heights[2],c1),
            vec(s2,heights[2],c2),
            vec(s2,heights[2] + 1,c2),
        }, true))
        add(polys, poly({
            vec(s1,heights[2] + 1.5,c1),
            vec(s1,heights[2] + 1,c1),
            vec(s1 * 0.66 + s2 * 0.33,heights[2] + 1,c1 * 0.66 + c2 * 0.33),
            vec(s1 * 0.66 + s2 * 0.33,heights[2] + 1.5,c1 * 0.66 + c2 * 0.33),
        }, false))
        add(polys, poly({
            vec(s1 * 0.33 + s2 * 0.66,heights[2] + 1.5,c1 * 0.33 + c2 * 0.66),
            vec(s1 * 0.33 + s2 * 0.66,heights[2] + 1,c1 * 0.33 + c2 * 0.66),
            vec(s2,heights[2] + 1,c2),
            vec(s2,heights[2] + 1.5,c2),
        }, false))        
        --polys[i].pattern = 0b0110011001100110.1
        --polys[i+1].pattern = 0b0110011001100110.1
        --polys[i+2].pattern = 0b0110011001100110.1
    end    

--[[
function make_lock(pos)
    local e = ent()
    e.health = 8
    e.pos = pos
    local count = 8
    local rad = 4
    local polys = {}
    for i = 1, count do
        local s1 = sin(i / count * 6.28 + 0.1) * rad
        local c1 = cos(i / count * 6.28 + 0.1) * rad
        local s2 = sin((i + 1) / count * 6.28 - 0.1) * rad
        local c2 = cos((i + 1) / count * 6.28 - 0.1) * rad
        local s3 = sin(i / count * 6.28 + 0.3) * rad
        local c3 = cos(i / count * 6.28 + 0.3) * rad
        local s4 = sin((i + 1) / count * 6.28 - 0.3) * rad
        local c4 = cos((i + 1) / count * 6.28 - 0.3) * rad        
        add(polys, poly({
            vec(s1 * 0.8, c1 * 0.8, 0),
            vec(s2 * 0.8, c2 * 0.8, 0),
            vec(s2, c2, 0),
            vec(s1, c1, 0),
        }, true))
        add(e.parts, part({poly({
            vec(s3 * 0.2, c3 * 0.2, 0),
            vec(s4 * 0.2, c4 * 0.2, 0),
            vec(s4 * 0.65, c4 * 0.65, 0),
            vec(s3 * 0.65, c3 * 0.65, 0),
        },false)}))
        e.parts[#e.parts].polys[1].pattern = 0b0
    end
    add(e.parts,part(polys))
    add(ents, e)
    e.compute_transform()
    update_internal_transforms(e)
    need_entgrid_generation = true
end
]]--

function serialize_entity(e)
    str = "[[" .. e.health .. "\n"
    for k = 1, #e.parts do
        local part = e.parts[k]
        for i = 1, #part.polys do
            local poly = part.polys[i]
            str = str .. (poly.target and 1 or 0) .. ';'
            for j = 1, #poly.points do
                local pt = poly.points[j]
                str = str .. pt[1] .. "," .. pt[2] .. "," .. pt[3]
                if j < #poly.points then str ..= ";" end
            end
            if i < #part.polys then str ..= '/' end
        end
        if k < #e.parts then str = str .. "\n" end
    end
    str = str .. "]]"
    return str
end