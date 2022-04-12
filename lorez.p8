pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
-- wireframe
-- by morganquirk

---- GLOBALS ----

---- TRI FILL ----

-- todo: use clip to draw sprite textures?
function p01_trapeze_h(l,r,lt,rt,y0,y1)
    lt,rt=(lt-l)/(y1-y0),(rt-r)/(y1-y0)
    if(y0<0)l,r,y0=l-y0*lt,r-y0*rt,0
    y1=min(y1,128)
    for y0=y0,y1 do
        --for q = min(l,r),max(l,r) do pset(q,y0) end
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
function trifill(x0,y0,x1,y1,x2,y2,col)
    color(col)
    if(y1<y0)x0,x1,y0,y1=x1,x0,y1,y0
    if(y2<y0)x0,x2,y0,y2=x2,x0,y2,y0
    if(y2<y1)x1,x2,y1,y2=x2,x1,y2,y1
    if max(x2,max(x1,x0))-min(x2,min(x1,x0)) > y2-y0 then
        col=x0+(x2-x0)/(y2-y0)*(y1-y0)
        p01_trapeze_h(x0,x0,x1,col,y0,y1)
        p01_trapeze_h(x1,col,x2,x2,y1,y2)
    else
        if(x1<x0)x0,x1,y0,y1=x1,x0,y1,y0
        if(x2<x0)x0,x2,y0,y2=x2,x0,y2,y0
        if(x2<x1)x1,x2,y1,y2=x2,x1,y2,y1
        col=y0+(y2-y0)/(x2-x0)*(x1-x0)
        p01_trapeze_w(y0,y0,y1,col,x0,x1)
        p01_trapeze_w(y1,col,y2,y2,x1,x2)
    end
end

---- DEBUG ----
function str_matrix(m)
 local out = ""
 for i=1,16 do
  out = out..m[i]..","
  if i % 4 == 0 then
   out = out.."\n"
  end
 end
 return out
end

function str_point(p)
    return p.x..","..p.y..","..p.z..","..p.w
end

---- MATH ----
p8cos = cos function cos(angle) return p8cos(angle/(3.1415*2)) end
p8sin = sin function sin(angle) return -p8sin(angle/(3.1415*2)) end

vec_metatable = {
    __add = function(left, right)
        return vec(left.x + right.x, left.y + right.y, left.z + right.z)
    end,
    __sub = function(left, right)
        return vec(left.x - right.x, left.y - right.y, left.z - right.z)
    end,
    __mul = function(v, s)
        return vec(v.x * s, v.y * s, v.z * s)
    end    
}

function vec(x,y,z,w)
    local v = {x=x or 0,y=y or 0,z=z or 0,w=w or 1}
    setmetatable(v,vec_metatable)
    return v
end

function v_mag(v)
    return sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
end

function v_norm(v)
    local d = v_mag(v)
    return vec(v.x / d, v.y / d, v.z / d)
end

function v_cross(a,b)
    return vec(a.y * b.z - b.y * a.z, a.z * b.x - b.z * a.x, a.x * b.y - b.x * a.y)
end

function v_dot(a,b)
    return a.x*b.x + a.y * b.y + a.z * b.z
end

function clamp(x, a, b)
    return min(max(x, a), b)
end

function angledelta(a,b)
    local delta = (b - a + 3.14159) % 6.2818 - 3.14159
    if delta < -3.14159 then return delta + 6.2818 else return delta end
end

---- MATRIX MATH ----

function mm(a,b)
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

function mv(m, v)
    return vec(
        m[1] * v.x +    m[2] * v.y +    m[3] * v.z +    m[4] * v.w,
        m[5] * v.x +    m[6] * v.y +    m[7] * v.z +    m[8] * v.w,
        m[9] * v.x +    m[10] * v.y +   m[11] * v.z +   m[12] * v.w,
        m[13] * v.x +   m[14] * v.y +   m[15] * v.z +   m[16] * v.w
    )
end

function m_identity()
    return {
        1,0,0,0,
        0,1,0,0,
        0,0,1,0,
        0,0,0,1
    }
end

-- opt could precompute all args?
function m_perspective(near, far, width, height)
    return {
        (2 - near) / width, 0, 0, 0,
        0, (2-near) / height, 0, 0,
        0, 0, -(far + near) / (far - near), (-2 * far * near) / (far - near),
        0,0,-1,0
    }
end

function m_rot_y(theta)
    local c, s = cos(theta), sin(theta)
    return {
        c, 0, s, 0,
        0, 1, 0, 0,
        -s, 0, c, 0,
        0, 0, 0, 1
    }
end

function m_rot_x(theta)
    local c, s = cos(theta), sin(theta)
    return {
        1, 0, 0, 0,
        0, c, -s, 0,
        0, s, c, 0,
        0, 0, 0, 1
    }
end

function m_translate(x,y,z)
    return {
        1,0,0,x,
        0,1,0,y,
        0,0,1,z,
        0,0,0,1
    }
end

function m_look()
    return {
        -1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, -1, 0,
        0, 0, 0, 1
    }
end

---- ENGINE ----

ents = {}
function ent()
    local e = {
        transform = m_identity(),
        parts = {},
    }
    return e
end

function update_internal_transforms(e)
    for p in all(e.parts) do
        p.world_transform = mm(e.transform, p.transform)
    end
end

entgrid = {}
egbounds = 30
egsize = 10
function generate_entgrid()
    entgrid = {}
    for i = -egbounds, egbounds do
        entgrid[i] = {}
    end
    for e in all(ents) do
        local pos = mv(e.transform, vec())
        local bin = clamp(pos.z \ egsize, -egbounds, egbounds)
        add(entgrid[bin],e)
    end
end

function get_visible_ents(pos)
    local results = {}
    local bin = pos.z \ egsize
    for i = max(bin - 2, -egbounds), min(bin + 2, egbounds) do
        for e in all(entgrid[i]) do
            add(results, e)
        end
    end
    return results
end

function poly(points)
    local avg = vec()
    for p in all(points) do
        avg += p * (1 / #points)
    end
    local d1 = v_norm(points[2] - points[1])
    local d2 = v_norm(points[3] - points[2])
    local p = {
        points = points,
        center = avg,
        normal = v_cross(d1, d2),
        palette = nil
    }
    return p
end

function final_point(t, p)
    local pta = mv(t, p)
    return vec(pta.x / pta.w * 64 + 64, pta.y / pta.w * 64 + 64, pta.z / pta.w, pta.w)
end

function draw_3d_scene(t, target2d)
    -- Make a set of bins to place all polygons into based on distance from camera
    -- This is like a Radix sort. 
    zbins = {}
    for i = 1, 32 do
        add(zbins, {})
    end

    add(debugs, #get_visible_ents(camera.pos))

    for e in all(get_visible_ents(camera.pos)) do
        for part in all(e.parts) do
            for p in all(part.polys) do
                --local mvt = mm(e.transform, part.transform)
                local mvt = part.world_transform
                local world_center = mv(mvt, p.center)
                local norm = mv(mvt, p.center + p.normal) - world_center
                local delta = v_norm(world_center - camera.pos)
                local dot = v_dot(delta, norm)
                if dot < 0 then -- backface culling
                    local trans = mm(t, mvt) -- slow
                    local t_center = mv(trans, p.center)
                    local d = v_mag(t_center)
                    local bin = 32 - clamp((d * 32 \ -(camera.far - camera.near)), 0, 31)
                    add(zbins[bin], {poly=p, transform=trans, center_2d=t_center, center=p.center, dot = dot})
                end
            end
        end
    end

    -- Go thru bins and draw each polygon
    for i, bin in pairs(zbins) do
        -- Pick line properties based on bin index
        local pattern = █
        local color = 2
        local width = 1
        local extra_line = false
        if i > 27 then
            color = 10
            width = 2
            extra_line = true
        elseif i > 25 then
            color = 10            
            extra_line = true
        elseif i > 20 then
            color = 9
            extra_line = true
        elseif i > 12 then
            color = 4
            extra_line = true
        elseif i > 8 then
            color = 2
        elseif i > 5 then
            color = 2
            pattern = ▒
        else
            color = 2
            pattern = ░
        end
        for p in all(bin) do
            -- Figure out 2d coords of each pt
            local pts2d = {}
            for pt in all(p.poly.points) do
                local pta = mv(p.transform, pt)
                local ptb = vec(pta.x / pta.w, pta.y / pta.w, pta.z / pta.w)
                
                if ptb.z > -1 and ptb.z < 1 then
                    add(pts2d, vec(ptb.x * 64 + 64, ptb.y * 64 + 64, ptb.z))
                end
            end

            if p.poly.fill and #pts2d == 4 then
                fillp(p.poly.fill)
                trifill(pts2d[1].x,pts2d[1].y,pts2d[2].x,pts2d[2].y,pts2d[3].x,pts2d[3].y,color)
                trifill(pts2d[1].x,pts2d[1].y,pts2d[3].x,pts2d[3].y,pts2d[4].x,pts2d[4].y,color)                
            end

            local highlight = false
            local pc = p.center_2d
            local pch = vec(pc.x / pc.w, pc.y / pc.w, pc.z / pc.w)
            if pch.z > -1 and pch.z < 1 then
                --DRAW NORMALS 
                --[[
                local normoff = p.center + p.poly.normal * 1
                local norm2d = final_point(p.transform, normoff)
                fillp(█)
                line(pc.x / pc.w * 64 + 64, pc.y / pc.w * 64 + 64, norm2d.x, norm2d.y, 7)
                ]]--
                --print(p.dot, pc.x / pc.w * 64 + 64, pc.y / pc.w * 64 + 64, 7)
                local xd = abs(pc.x / pc.w * 64 + 64 - target2d.x)
                local yd = abs(pc.y / pc.w * 64 + 64 - target2d.y)
                if xd < 15 and yd < 15 then
                    local ccolor = color
                    if xd < 5 and yd < 5 then ccolor = 8 end
                    circfill(pc.x / pc.w * 64 + 64, pc.y / pc.w * 64 + 64, 1, ccolor)
                    highlight = true
                end                
            end

            -- Draw lines between each point pair
            if not p.poly.fill or extra_line then
                for i = 1, #pts2d do
                    local pt1 = pts2d[i]
                    local pt2 = pts2d[i % #pts2d + 1]
                    fillp(pattern)
                    line(pt1.x, pt1.y, pt2.x, pt2.y, color)
                end
            end
        end
    end
end

---- PICO ----

function _init()
    camera = {
        pos=vec(0,0,0),
        fwd=vec(0,0,1),
        angles=vec(),
        angle_velocities = vec(),
        view_mat = nil,
        near = -1,
        far = -25,
    }

    player = {
        health = 1,
        cursor_angles = vec(),
    }
    camera.pos = vec(0,0,20)
    perspective_transform = m_perspective(camera.near, camera.far, -2 * camera.near * 1.62, -2 * camera.near * 1.62)

    -- thing
    local e = ent()
    for j = 0, 4 do
        local polys = {}
        local rad = sin(j / 4 * 3.14) * 2 + 2
        local count = 8
        for i = 0, count do
            local y = j
            local s1 = sin(i / count * 6.28 + 0.05) * rad
            local c1 = cos(i / count * 6.28 + 0.05) * rad
            local s2 = sin((i + 1) / count * 6.28 - 0.05) * rad
            local c2 = cos((i + 1) / count * 6.28 - 0.05) * rad  
            add(polys, poly({
                vec(s1,0.4,c1),
                vec(s1,-0.4,c1),
                vec(s2,-0.4,c2),
                vec(s2,0.4,c2),
            }))
            --polys[#polys].fill=0b1101110111011101
        end
        add(e.parts, {polys=polys, transform = m_translate(0, j, 0)})
    end 
    e.transform = m_translate(5,0,0)
    add(ents,e)   
    update_internal_transforms(e)

    for i = - 30, 30 do
        local e = ent()
        local polys = {}
        for j = -1,1 do
            local pol = poly({
                vec(-3 + j * 8, 0, 3),
                vec(3 + j * 8, 0, 3),
                vec(3 + j * 8, 0, -3),
                vec(-3 + j * 8, 0, -3),
            })
            pol.fill = 0b0101101101011110
            add(polys, pol)    
        end
        e.parts = {{polys=polys, transform = m_identity()}}
        e.transform = m_translate((i % 2) * 4 - 2,-3,i * 8)
        add(ents, e)
        update_internal_transforms(e)
    end
    generate_entgrid()
end

function update_player()
    if btn(0) then
        player.cursor_angles.y -= 0.02
    end
    if btn(1) then
        player.cursor_angles.y += 0.02
    end    
    if btn(2) then
        player.cursor_angles.x -= 0.02
    end
    if btn(3) then
        player.cursor_angles.x += 0.02
    end 

    for axis in all({"y","x"}) do
        yad = angledelta(player.cursor_angles[axis], camera.angles[axis])
        if yad > 0.2 then
            camera.angle_velocities[axis] -= 0.01
            camera.angles[axis] -= 0.005
        elseif yad < -0.2 then
            camera.angle_velocities[axis] += 0.01
            camera.angles[axis] += 0.005
        end
        camera.angle_velocities[axis] *= 0.8
        camera.angles[axis] += camera.angle_velocities[axis]
    end
end

tf = 0
function _update60()
    debugs = {}
    camera.pos -= vec(0,0,0.03)
    --camera.angles = player.cursor_angles
    local rot = mm(m_rot_x(camera.angles.x), m_rot_y(camera.angles.y))
    camera.view_mat = mm(m_look(), rot)
    camera.fwd = mv(mm(m_rot_y(-camera.angles.y), m_rot_x(-camera.angles.x)), vec(0,0,-1))
    --add(debugs, str_matrix(camera.view_mat))
    --add(debugs, str_point(camera.fwd))
    local e = ents[1]
    for i = 1,5 do
        e.parts[i].transform = mm(m_translate(0,i,0), m_rot_y(tf / 350 * i))
    end
    update_internal_transforms(e)

    update_player()

    tf += 1
end

function _draw()
    cls()
    local t = mm(mm(perspective_transform, camera.view_mat), m_translate(-camera.pos.x, -camera.pos.y, -camera.pos.z))
    local cursorm = mm(m_rot_y(-player.cursor_angles.y), m_rot_x(-player.cursor_angles.x))
    local target2d = final_point(t, camera.pos + mv(cursorm, vec(0,0,-5)))

    draw_3d_scene(t, target2d)

    if target2d.z > -1 and target2d.z < 1 then
        fillp()
        spr(1, target2d.x - 8, target2d.y - 8, 2, 2)
    end

    color(7)
    for d in all(debugs) do
        print(d)
    end    
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000005777000077750000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000005777000077750000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
