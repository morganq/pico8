----- AA -----

function shadepixpair(x,y,k,dx,dy)   
    pset(x,   y,pget(x,y)*k)
    pset(x+dx,y+dy,pget(x+dx,y+dy)*(1-k))
end
function shadepix(x,y,k)   
    pset(x,   y,pget(x,y)*k)
end

-- algorithm credits: felice
-- based off: http://jamesarich.weebly.com/uploads/1/4/0/3/14035069/480xprojectreport.pdf
function aaline(x0,y0,x1,y1)
    local w,h=abs(x1-x0),abs(y1-y0)
 
 if h>w then
     if y0>y1 then
         x0,y0,x1,y1=x1,y1,x0,y0
     end
 
     local dx=x1-x0
    
     y0+=0.5
     y1+=0.5
    local k=h/(h*0.9609+w*0.3984)
            
     for y=flr(y0)+0.5-y0,flr(y1)+0.5-y0 do   
         local x=x0+dx*y/h
         local px=flr(x)
         pset(px,  y0+y,pget(px,  y0+y)*k*(x-px  ))
         pset(px+1,y0+y,pget(px+1,y0+y)*k*(px-x+1))
     end
 elseif w>0 then
     if x0>x1 then
         x0,y0,x1,y1=x1,y1,x0,y0
     end
 
     local dy=y1-y0
     x0+=0.5
     x1+=0.5
    local k=w/(w*0.9609+h*0.3984)

     for x=flr(x0)+0.5-x0,flr(x1)+0.5-x0 do   
         local y=y0+dy*x/w
         local py=flr(y)
         pset(x0+x,py,  pget(x0+x,py  )*k*(y-py  ))
         pset(x0+x,py+1,pget(x0+x,py+1)*k*(py-y+1))
     end
    end
end


----- MATH -----

p8cos = cos function cos(angle) return p8cos(angle/(3.1415*2)) end
p8sin = sin function sin(angle) return -p8sin(angle/(3.1415*2)) end
function clamp(x, a, b) return min(max(x, a), b) end
function angledelta(a,b)
    local delta = (b - a + 3.14159) % 6.2818 - 3.14159
    if delta < -3.14159 then return delta + 6.2818 else return delta end
end

----- VECTORS -----

function v_add(a,b) return {a[1] + b[1], a[2] + b[2], a[3] + b[3], 1} end
function v_sub(a,b) return {a[1] - b[1], a[2] - b[2], a[3] - b[3], 1} end
function v_mul(a,s) return {a[1] * s, a[2] * s, a[3] * s, 1} end
function v_mag(v) return sqrt(v[1] * v[1] + v[2] * v[2] + v[3] * v[3]) end
function v_norm(v)
    local d = v_mag(v)
    return {v[1] / d, v[2] / d, v[3] / d, 1}
end
function v_cross(a,b)
    return {a[2] * b[3] - b[2] * a[3], a[3] * b[1] - b[3] * a[1], a[1] * b[2] - b[1] * a[2], 1}
end
function v_dot(a,b) return a[1]*b[1] + a[2] * b[2] + a[3] * b[3] end

function v_limit(v, s) 
    if v[1] * v[1] + v[2] * v[2] + v[3] * v[3] > s * s then
        return v_mul(v_norm(v), s)
    end
    return v
end

function mm4(a,b)
    return {
        a[1]*b[1]+a[2]*b[5]+a[3]*b[9]+a[4]*b[13],
        a[1]*b[2]+a[2]*b[6]+a[3]*b[10]+a[4]*b[14],
        a[1]*b[3]+a[2]*b[7]+a[3]*b[11]+a[4]*b[15],
        a[1]*b[4]+a[2]*b[8]+a[3]*b[12]+a[4]*b[16],

        a[5]*b[1]+a[6]*b[5]+a[7]*b[9]+a[8]*b[13],
        a[5]*b[2]+a[6]*b[6]+a[7]*b[10]+a[8]*b[14],
        a[5]*b[3]+a[6]*b[7]+a[7]*b[11]+a[8]*b[15],
        a[5]*b[4]+a[6]*b[8]+a[7]*b[12]+a[8]*b[16],

        a[9]*b[1]+a[10]*b[5]+a[11]*b[9]+a[12]*b[13],
        a[9]*b[2]+a[10]*b[6]+a[11]*b[10]+a[12]*b[14],
        a[9]*b[3]+a[10]*b[7]+a[11]*b[11]+a[12]*b[15],
        a[9]*b[4]+a[10]*b[8]+a[11]*b[12]+a[12]*b[16],

        a[13]*b[1]+a[14]*b[5]+a[15]*b[9]+a[16]*b[13],
        a[13]*b[2]+a[14]*b[6]+a[15]*b[10]+a[16]*b[14],
        a[13]*b[3]+a[14]*b[7]+a[15]*b[11]+a[16]*b[15],
        a[13]*b[4]+a[14]*b[8]+a[15]*b[12]+a[16]*b[16],
    }
end

----- MATRICES -----

function mv4(m, v)
    return {
        m[1] * v[1] +    m[2] * v[2] +    m[3] * v[3] +    m[4] * v[4],
        m[5] * v[1] +    m[6] * v[2] +    m[7] * v[3] +    m[8] * v[4],
        m[9] * v[1] +    m[10] * v[2] +   m[11] * v[3] +   m[12] * v[4],
        m[13] * v[1] +   m[14] * v[2] +   m[15] * v[3] +   m[16] * v[4]
    }
end

function m_rot_x(theta)
    local c, s = cos(theta), sin(theta)
    return {
        1, 0, 0, 0,
        0, c, -s, 0,
        0, s, c, 0,
        0,0,0,1
    }
end

function m_rot_y(theta)
    local c, s = cos(theta), sin(theta)
    return {
        c, 0, s, 0,
        0, 1, 0, 0,
        -s, 0, c, 0,
        0,0,0,1
    }
end

function m_rot_z(theta)
    local c, s = cos(theta), sin(theta)
    return {
        c, -s, 0, 0,
        s, c, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    }
end

function m_rot_xyz(a,b,c)
    --this is slightly wrong, multiplications in the wrong order. 

    --[[local sina, cosa, sinb, cosb, sinc, cosc = sin(a), cos(a), sin(b), cos(b), sin(c), cos(c)
    return {
        cosb * cosa, sinc * sinb * cosa - cosc * sina, cosc * sinb * cosa + sinc * sina, 0,
        cosb * sina, sinc * sinb * sina + cosc * cosa, cosc * sinb * sina - sinc * cosa, 0,
        -sinb, sinc * cosb, cosc * cosb, 0,
        0,0,0,1
    }]]--
    
    return mm4(m_rot_y(b), mm4(m_rot_z(c), m_rot_x(a)))
end

function m_look(fwd, up)
    local left = v_norm(v_cross(up, fwd))
    local new_up = v_norm(v_cross(fwd, left))
    return {
        left[1], left[2], left[3], 0,
        new_up[1], new_up[2], new_up[3], 0,
        fwd[1], fwd[2], fwd[3], 0,
        0,0,0,1
    }
end

function m_perspective(near, far, width, height)
    return {
        (2 - near) / width, 0, 0, 0,
        0, (2-near) / height, 0, 0,
        0, 0, -(far + near) / (far - near), (-2 * far * near) / (far - near),
        0,0,-1,0
    }
end

function m_identity()
    local m = {
        1,0,0,0,
        0,1,0,0,
        0,0,1,0,
        0,0,0,1
    }
    m.is_identity = true
    return m
end

----- TRIFILL -----
function p01_trapeze_h(l,r,lt,rt,y0,y1)
    lt,rt=(lt-l)/(y1-y0),(rt-r)/(y1-y0)
    if(y0<0)l,r,y0=l-y0*lt,r-y0*rt,0
    y1=min(y1,128)
    for y0=y0,y1 do
        rectfill(l,y0,r,y0)
        l+=lt
        r+=rt
    end
end
function p01_trapeze_w(t,b,tt,bt,x0,x1)
    tt,bt=(tt-t)/(x1-x0),(bt-b)/(x1-x0)
    if(x0<0)t,b,x0=t-x0*tt,b-x0*bt,0
    x1=min(x1,128)
    for x0=x0,x1 do
        rectfill(x0,t,x0,b)
        t+=tt
        b+=bt
    end
end
function trifill(x0,y0,x1,y1,x2,y2)
    if(y1<y0)x0,x1,y0,y1=x1,x0,y1,y0
    if(y2<y0)x0,x2,y0,y2=x2,x0,y2,y0
    if(y2<y1)x1,x2,y1,y2=x2,x1,y2,y1
    if max(x2,max(x1,x0))-min(x2,min(x1,x0)) > y2-y0 then
        local col=x0+(x2-x0)/(y2-y0)*(y1-y0)
        p01_trapeze_h(x0,x0,x1,col,y0,y1)
        p01_trapeze_h(x1,col,x2,x2,y1,y2)
    else
        if(x1<x0)x0,x1,y0,y1=x1,x0,y1,y0
        if(x2<x0)x0,x2,y0,y2=x2,x0,y2,y0
        if(x2<x1)x1,x2,y1,y2=x2,x1,y2,y1
        local col=y0+(y2-y0)/(x2-x0)*(x1-x0)
        p01_trapeze_w(y0,y0,y1,col,x0,x1)
        p01_trapeze_w(y1,col,y2,y2,x1,x2)
    end
end


----- 3D -----

COLOR_LIGHTING_SPRITE = 16
PATTERNS = {[0] = 0b0, [5] = 0b0101101001011010, [6] = 0b0101100001011000}
function set_color_lighting(color_num, light)
    local sx = (COLOR_LIGHTING_SPRITE % 16) * 8
    local sy = (COLOR_LIGHTING_SPRITE \ 16) * 8
    local cx = flr(clamp(light, 0, 1) * 7.99)
    local cy = color_num * 2
    local patc = sget(sx + cx, sy + cy + 1)
    local c1 = sget(sx + cx, sy + cy)
    if patc > 0 then
        local other_color = nil
        local cxm = 1
        if cx == 0 then other_color = 0 end
        while other_color == nil do
            if cx - cxm < 0 then other_color = 0
            else
                local step_other = sget(sx + cx - cxm, sy + cy)
                --add(debugs,step_other..","..cxm)
                if step_other != c1 then
                    other_color = step_other
                    break
                end
                cxm += 1
            end
        end
        local c = 0x00 + c1 * 16 + other_color
        color(c)
        --add(debugs, other_color)
        fillp(PATTERNS[patc])
        return c
    else
        color(c1)
        fillp(0b0)
        return c1
    end
end


-- Redo so we can do lighting curves for each color
local colors = {1,0x15,5,0x5d,13,0xd6,6,0x6f,15,0xf7,7,0x77}
local patterns = {0b0, 0b1010010110100101, 0b0, 0b1010010110100101, 0b0, 0b1010010110100101, 0b0, 0b1010010110100101, 0b0, 0b1010010110100101, 0b0, 0b1010010110100101}

function render(models, sprites, camera, w, h, floor, sky, shadows)
    w = w or 128
    h = h or 128
    local hw = w \ 2
    local hh = h \ 2
    local nbins = 256 -- opt: inline
    local zfar = 80
    local m = mm4(m_perspective(-1, -zfar, 3.2, 3.2 * h / w), m_look(camera.fwd, {0,1,0,1}))
    local tris = 0
    local drawn_tris = 0
    local zbins = {}
    local all_points = {}
    for i = 1,nbins do add(zbins, {}) end

    local m1,m2,m3,m5,m6,m7,m9,m10,m11,m12,m13,m14,m15 = m[1],m[2],m[3],m[5],m[6],m[7],m[9],m[10],m[11],m[12],m[13],m[14],m[15]
    local cpx, cpy, cpz = camera.pos[1], camera.pos[2], camera.pos[3]

    local single = 0
    local longest = 0
    local reject = false

    local sundir = v_norm({0.5,1,0.25,1})

    for mi = 1, #models do
        local model = models[mi]
        local transformed_points = {}
        for ti = 1,#model.triangles do
            local t = model.triangles[ti]
            tris += 1
            local indicies = t.point_indicies
            local norm = t.normal
            local dirx = t.center[1] - cpx
            local diry = t.center[2] - cpy
            local dirz = t.center[3] - cpz
            local dot = dirx * norm[1] + diry * norm[2] + dirz * norm[3]   
            if dot < 0 then
                reject = false
                for i = 1,3 do
                    local index = indicies[i]
                    local cached = transformed_points[index]
                    if not cached then
                        local mpi = model.points[index]
                        local x = (mpi[1] - cpx)
                        local y = (mpi[2] - cpy)
                        local z = (mpi[3] - cpz) 
                        local w2 = m13 * x + m14 * y + m15 * z
                        local x2 = (m1 * x + m2 * y + m3 * z)
                        local y2 = (m5 * x + m6 * y + m7 * z)
                        local z2 = (m9 * x + m10 * y + m11 * z + m12)
                        --if x2 < -2 or x2 > 2 or y2 < -2 or y2 > 2 or z2 < -1 or z2 > 1 then
                        aw2 = abs(w2) * 4
                        if abs(z2) > abs(w2) or abs(x2) > aw2 or abs(y2) > aw2 then
                            reject = true
                            break
                        end
                        transformed_points[index] = {x2 / w2 * hw + hw,y2 / w2 * hh + hh,z2 / w2}
                    end
                end
                if not reject then
                    local distsq = dirx * dirx + diry * diry + dirz * dirz
                    local bin = nbins - flr(distsq / (zfar * zfar) * nbins + 1)
                    add(zbins[bin], {
                        1,
                        transformed_points[indicies[1]],
                        transformed_points[indicies[2]],
                        transformed_points[indicies[3]],
                        norm,
                        t.center,
                        t.color_num
                    })
                    drawn_tris += 1
                end
            end
        end
    end

    for si = 1, #sprites do
        local s = sprites[si]
        local x = (s.pos[1] - cpx)
        local y = (s.pos[2] - cpy)
        local z = (s.pos[3] - cpz) 
        local w2 = m13 * x + m14 * y + m15 * z
        local x2 = (m1 * x + m2 * y + m3 * z)
        local y2 = (m5 * x + m6 * y + m7 * z)
        local z2 = (m9 * x + m10 * y + m11 * z + m12) 
        aw2 = abs(w2) * 2
        if abs(z2) < abs(w2) and abs(x2) < aw2 and abs(y2) < aw2 then
            local sprindex = s.si
            local scalex = 1
            if s.rotator then
                local cxz = v_norm({camera.fwd[1], 0, camera.fwd[3], 1})
                local across = v_cross(cxz, s.fwd)[2]
                local adot = v_dot(cxz, s.fwd)
                if adot > 0.95 then
                    sprindex = s.si + s.w * 2
                elseif adot > -0.95 then
                    if across > 0 then
                        sprindex = s.si + s.w
                        scalex = -1
                    else
                        sprindex = s.si + s.w
                    end
                else
                    sprindex = s.si
                end
            end
            local distsq = x * x + y * y + z * z
            local bin = nbins - flr(distsq / (zfar * zfar) * nbins + 1)
            local size = 5 / sqrt(distsq)--min(2 / (sqrt(dist) / 10),1)
            local sx,sy = sprindex % 16 * 8, sprindex \ 16 * 8
            local fx = x2 / w2 * hw + hw
            local fy = y2 / w2 * hh + hh
            add(zbins[bin], {
                2, 
                sx, sy,
                s.w * 8, s.h * 8,
                fx - s.w * 4 * size * scalex, fy - s.h * 4 * size,
                s.w * 8 * size * scalex, s.h * 8 * size
            })
        end        
    end

    local horizon_pt = {camera.fwd[1] * 50, 0, camera.fwd[3] * 50, 1}
    local h2d = mv4(m, horizon_pt)
    h2d[1] = h2d[1] / h2d[4]
    h2d[2] = h2d[2] / h2d[4]
    fillp(0b0)
    rectfill(0, 0, w, h2d[2] * hh + hh, sky)
    rectfill(0, h2d[2] * hh + hh, w, h, floor)
    
    local floor_ratio = 0.5 - camera.fwd[2]
    color(0)
    function do_shadows(models)
        for mi = 1, #models do
            local model = models[mi]
            if model.shadow then
                local s2d = mv4(m, {model.pos[1] - cpx, -cpy, model.pos[3] - cpz, 1})
                local sz = s2d[3] / s2d[4]
                if sz > -1 and sz < 1 then
                    local sx = s2d[1] / s2d[4] * hw + hw
                    local sy = s2d[2] / s2d[4] * hh + hh + (model.shadow_offset or 0)
                    ss = clamp(35 / -s2d[4], 0, 8) * (model.shadow_size or 1)
                    ovalfill(sx - ss, sy - ss * floor_ratio, sx + ss, sy + ss * floor_ratio)
                end
            end
        end  
    end
    do_shadows(models)
    do_shadows(sprites)
    do_shadows(shadows)

    for bin = 1, nbins do   
        local contents = zbins[bin]
        for j = 1, #contents do
            local r = contents[j]
            local rtype = r[1]
            if rtype == 1 then
                --pal()
                --fillp()
                local norm = r[5]
                local p1 = r[2]
                local p2 = r[3]
                local p3 = r[4]
                local dot = norm[1] * sundir[1] + norm[2] * sundir[2] + norm[3] * sundir[3]
                local ind = flr(max(dot,0) * 12 + 1)
                --color(colors[ind])
                --fillp(patterns[ind])
                local c = set_color_lighting(r[7], dot)
                if bin < 10 then
                    fillp(0b1010010110100101.1)
                end
                --printh(p1[1], "test.txt")
                trifill(p1[1],p1[2],p2[1],p2[2],p3[1],p3[2])
                line(p1[1],p1[2],p2[1],p2[2]) -- Fill in the gap

                -- Wireframe
                --fillp()
                --[[for i = 0, 15 do
                    pal(i,i \ 2,0)
                end
                aaline(p1[1],p1[2],p2[1],p2[2])
                aaline(p2[1],p2[2],p3[1],p3[2])
                aaline(p1[1],p1[2],p3[1],p3[2])
                ]]--
            elseif rtype == 2 then
                sspr(r[2],r[3],r[4],r[5],r[6],r[7],r[8],r[9])
            end
            
        end
    end
    pal()
    local draw_normals = false
    if draw_normals then
        for bin, contents in pairs(zbins) do
            for r in all(contents) do
                local center = v_add(r[5], v_mul(camera.pos,-1))
                local p1 = mv4(m, center)
                local p2 = mv4(m, v_add(r[4], center))
                line(p1[1] / p1[4] * hw + hw,p1[2] / p1[4] * hh + hh,p2[1] / p2[4] * hw + hw,p2[2] / p2[4] * hh + hh, 12)
                
            end
        end
    end
end

----- MODELS -----

function deserialize_model(s, scale)
    local scale = scale or 1
    local vertsfaces = split(s,"\n")
    local verts = split(vertsfaces[1], "/")
    local faces = split(vertsfaces[2], "/")
    local points = {}
    local triangles = {}
    for i = 1, #verts do
        local xyz = split(verts[i], ",")
        add(points, {xyz[1] * scale, xyz[2] * scale, xyz[3] * scale,1})
    end
    for i = 1, #faces do
        local tri = split(faces[i], ",")
        add(triangles, {tri[1], tri[2], tri[3]})
    end    
    return model(points, triangles)
end

function update_tri(model, tri_index)
    local t = {
        model.points[model.triangles[tri_index].point_indicies[1]],
        model.points[model.triangles[tri_index].point_indicies[2]],
        model.points[model.triangles[tri_index].point_indicies[3]]
    }
    -- opt local t1-t3
    local d1 = v_norm(v_sub(t[2], t[1]))
    local d2 = v_norm(v_sub(t[3], t[2]))    
    local norm = v_norm(v_cross(d1, d2))
    model.triangles[tri_index].normal = norm
    local center = {
        (t[1][1] + t[2][1] + t[3][1]) / 3,
        (t[1][2] + t[2][2] + t[3][2]) / 3,
        (t[1][3] + t[2][3] + t[3][3]) / 3,
        1
    }    
    model.triangles[tri_index].center = center
end

function model(points, tris)
    local m = {
        points = points,
        base_points = {},
        triangles = {},
        pos = {0,0,0,1},
        rotation = m_identity(),
        shadow = false,
    }
    for p in all(points) do add(m.base_points, p) end    
    m.update_points = function()
        for i = 1, #m.base_points do
            local rotated_pt = mv4(m.rotation, m.base_points[i])
            points[i] = v_add(rotated_pt, m.pos)
        end
        for i = 1, #m.triangles do
            update_tri(m, i)
        end
    end
    for i = 1, #tris do
        add(m.triangles, {point_indicies = tris[i]})
        update_tri(m, i)
        m.triangles[i].color_num = 0
    end
    return m
end

function sprite(si, pos, w, h, rotator)
    local s = {
        si = si,
        w = w or 1,
        h = h or 1,
        pos = pos,
        fwd = {0,0,-1,1},
        rotator = rotator,
        shadow = false,
        shadow_offset = h * 3
    }
    return s
end