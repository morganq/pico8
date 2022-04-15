pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
-- wireframe
-- by morganquirk

--level:
-- part 1 floor: cobblestone, bg: castle type stuff --
-- 4 minion
-- 4 minion
-- crown turret
-- crown turret
-- lock 
-- part 2 floor: road bg: gears? --
-- 3 buildings (5 each)
-- 6 minion
-- 8 buildings
-- stock exchange
-- lock
-- part 3 floor: map. bg: current one --
-- guns
-- minion swarm
-- boss?

background_heights = split("-8,-6,-4,-2,-2,-1,0,0,1,1,2,1,1,0,-2,-5",",")

enemy_artillery = [[12
0;2.8917,0.8,1.4834;4.4488,-0.6,2.2823;4.4522,-0.6,-2.2754;2.8939,0.8,-1.479/0;2.7316,0.8,-1.7608;4.2026,-0.6,-2.7089;0.2568,-0.6,-4.9934;0.1669,0.8,-3.2457/0;-0.157,0.8,-3.2462;-0.2415,-0.6,-4.9942;-4.1943,-0.6,-2.7218;-2.7263,0.8,-1.7691/0;-2.8894,0.8,-1.4879;-4.4453,-0.6,-2.289;-4.4557,-0.6,2.2686;-2.8962,0.8,1.4746/0;-2.7344,0.8,1.7566;-4.2068,-0.6,2.7025;-0.2645,-0.6,4.993;-0.1719,0.8,3.2454/0;0.1532,0.8,3.2463;0.2357,-0.6,4.9944;4.1901,-0.6,2.7282;2.7235,0.8,1.7733
1;2.1697,2.8,3.3604;2.1697,1.4,3.3604;3.3588,1.4,2.1723;3.3588,2.8,2.1723/1;3.559,2.8,1.8258;3.559,1.4,1.8258;3.9949,1.4,0.2024;3.9949,2.8,0.2024/1;3.9952,2.8,-0.1963;3.9952,1.4,-0.1963;3.5618,1.4,-1.8203;3.5618,2.8,-1.8203/1;3.3621,2.8,-2.1671;3.3621,1.4,-2.1671;2.1749,1.4,-3.3571;2.1749,2.8,-3.3571/1;1.8286,2.8,-3.5576;1.8286,1.4,-3.5576;0.2054,1.4,-3.9947;0.2054,2.8,-3.9947/1;-0.1932,2.8,-3.9954;-0.1932,1.4,-3.9954;-1.8176,1.4,-3.5632;-1.8176,2.8,-3.5632/1;-2.1646,2.8,-3.3637;-2.1646,1.4,-3.3637;-3.3554,1.4,-2.1774;-3.3554,2.8,-2.1774/1;-3.5562,2.8,-1.8312;-3.5562,1.4,-1.8312;-3.9946,1.4,-0.2086;-3.9946,2.8,-0.2086/1;-3.9955,2.8,0.1901;-3.9955,1.4,0.1901;-3.5646,1.4,1.8149;-3.5646,2.8,1.8149/1;-3.3654,2.8,2.162;-3.3654,1.4,2.162;-2.18,1.4,3.3538;-2.18,2.8,3.3538/1;-1.834,2.8,3.5548;-1.834,1.4,3.5548;-0.2116,1.4,3.9944;-0.2116,2.8,3.9944/1;0.1886,2.8,3.9955;0.1886,1.4,3.9955;1.8121,1.4,3.566;1.8121,2.8,3.566
0;1.735,4.8,0.8901;2.6693,3.4,1.3694;2.6713,3.4,-1.3652;1.7363,4.8,-0.8874/0;1.639,4.8,-1.0565;2.5215,3.4,-1.6253;0.1541,3.4,-2.996;0.1001,4.8,-1.9474/0;-0.0942,4.8,-1.9477;-0.1449,3.4,-2.9965;-2.5166,3.4,-1.6331;-1.6358,4.8,-1.0615/0;-1.7336,4.8,-0.8927;-2.6672,3.4,-1.3734;-2.6734,3.4,1.3612;-1.7377,4.8,0.8847/0;-1.6406,4.8,1.054;-2.5241,3.4,1.6215;-0.1587,3.4,2.9958;-0.1032,4.8,1.9472/0;0.0919,4.8,1.9478;0.1414,3.4,2.9967;2.514,3.4,1.6369;1.6341,4.8,1.064]]

enemy_minion = [[1
0;-1,-0.3,1;-0.9,-0.5,-1;-0.9,0.5,-1;-1,0.3,1/0;-1.1,-0.5,-1;-1,-0.3,1;-1,0.3,1;-1.1,0.5,-1
1;-0.2,-0.3,0;0.2,-0.3,0;0.5,0.3,0;-0.5,0.3,0
0;0.9,-0.5,-1;1,-0.3,1;1,0.3,1;0.9,0.5,-1/0;1,-0.3,1;1.1,-0.5,-1;1.1,0.5,-1;1,0.3,1]]

enemy_missile = [[1
0;0.3367,0.0957,0;0.0096,0.0027,-1;0.0024,-0.0097,-1;0.0858,-0.3393,0/0;-0.0853,-0.3394,0;-0.0024,-0.0097,-1;-0.0096,0.0027,-1;-0.3368,0.0953,0/0;-0.2513,0.2436,0;-0.0072,0.0069,-1;0.0072,0.007,-1;0.2508,0.2441,0/1;0.1,-0.1,-0.25;0.1,0.1,-0.25;-0.1,0.1,-0.25;-0.1,-0.1,-0.25]]

---- GLOBALS ----
tf = 0
pulse_t = 0
last_music_timing = 0
on_beat = nil
recolor={1,1,13,1,13,1,13,7,0,12,12,12,12,12,12,12}

---- TRI FILL ----

-- todo: use clip to draw sprite textures?
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
    return p[1]..","..p[2]..","..p[3]..","..p[4]
end

---- MATH ----
p8cos = cos function cos(angle) return p8cos(angle/(3.1415*2)) end
p8sin = sin function sin(angle) return -p8sin(angle/(3.1415*2)) end

function vec(x,y,z,w)
    return {x or 0,y or 0,z or 0,w or 1}
end

function v_add(a,b) return {a[1] + b[1], a[2] + b[2], a[3] + b[3], 1} end
function v_sub(a,b) return {a[1] - b[1], a[2] - b[2], a[3] - b[3], 1} end
function v_mul(a,s) return {a[1] * s, a[2] * s, a[3] * s, 1} end

function v_limit(v, s) 
    if v[1] * v[1] + v[2] * v[2] + v[3] * v[3] > s * s then
        return v_mul(v_norm(v), s)
    end
    return v
end

function v_mag(v)
    return sqrt(v[1] * v[1] + v[2] * v[2] + v[3] * v[3])
end

function v_norm(v)
    local d = v_mag(v)
    return {v[1] / d, v[2] / d, v[3] / d, 1}
end

function v_cross(a,b)
    return {a[2] * b[3] - b[2] * a[3], a[3] * b[1] - b[3] * a[1], a[1] * b[2] - b[1] * a[2], 1}
end

function v_dot(a,b)
    return a[1]*b[1] + a[2] * b[2] + a[3] * b[3]
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
    return {
        m[1] * v[1] +    m[2] * v[2] +    m[3] * v[3] +    m[4] * v[4],
        m[5] * v[1] +    m[6] * v[2] +    m[7] * v[3] +    m[8] * v[4],
        m[9] * v[1] +    m[10] * v[2] +   m[11] * v[3] +   m[12] * v[4],
        m[13] * v[1] +   m[14] * v[2] +   m[15] * v[3] +   m[16] * v[4]
    }
end

function mvx(m, v)
    return {
        m[1] * v[1] +    m[2] * v[2] +    m[3] * v[3],
        m[5] * v[1] +    m[6] * v[2] +    m[7] * v[3],
        m[9] * v[1] +    m[10] * v[2] +   m[11] * v[3],
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

function m_rot_z(theta)
    local c, s = cos(theta), sin(theta)
    return {
        c, -s, 0, 0,
        s, c, 0, 0,
        0, 0, 1, 0,
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

function m_look(fwd, up)
    local left = v_norm(v_cross(up, fwd))
    local new_up = v_norm(v_cross(fwd, left))
    return {
        left[1], left[2], left[3], 0,
        new_up[1], new_up[2], new_up[3], 0,
        fwd[1], fwd[2], fwd[3], 0,
        0, 0, 0, 1
    }
end

---- ENGINE ----

circles = {}
function circle_make(pos, color, type)
    local c = {
        pos = pos,
        color = color,
        type = type,
        time = 0,
        radius = 3,
    }
    add(circles,c)
    c.update = function()
        c.time += 1
        if c.type == 1 then
            c.radius = 3 - c.time \ 35
            if c.time % 10 == 0 then c.color = 7 else c.color = 8 end
            if c.time > 80 then
                del(circles, c)
            end
        elseif c.type == 2 then
            c.radius = 10 - c.time/2
            --if c.time % 10 == 0 then c.color = 7 else c.color = 8 end
            if c.time > 20 then
                del(circles, c)
            end
        end
    end
    return c
end

jlasers = {}
function jlaser_make(from,target,ent)
    local three = {1,2,3}
    local order = {0}
    for i = 3,1,-1 do
        local val = flr(rnd(i))+1
        add(order, three[val])
        deli(three, val)
    end
    local jl = {
        from = from,
        to = target,
        points = {vec(), vec(), vec(), vec()},
        fired = false,
        t = 0,
    }
    jl.update = function()
        jl.t += 0.2
        jl.points[1] = player.pos
        local a = player.pos
        local b = jl.to.world_center
        --print(order[1] .. order[2] .. order[3] .. order[4])
        if jl.fired then
            for i = 2,4 do
                local xo = (b[order[i]] - a[order[i]]) * clamp(jl.t - (i - 2),0,1)
                jl.points[i] = {
                    jl.points[i - 1][1],
                    jl.points[i - 1][2],
                    jl.points[i - 1][3],
                    1
                }
                jl.points[i][order[i]] += xo
            end
        end
        if not jl.fired and on_beat != nil and jl.t >0 then
            sfx(10, 1)
            jl.fired = true
        end
        if jl.t > 3 and jl.t - 0.2 <= 3 then
            circle_make(jl.to.world_center, 12, 2)
            add(dying_polys,target)
            ent.hurt()
        end
        if jl.t > 4 then
            del(jlasers, jl)
        end
    end
    add(jlasers, jl)
    return jl
end


ents = {}
function ent()
    local e = {
        pos = {0,0,0},
        angles = {0,0,0},
        transform = m_identity(),
        parts = {},
        health = 1,
        dying = false,
        die_time = 0,
        die_offset = {0,0,0},
        visible = true,
        deadly = false,
    }
    e.compute_transform = function()
        e.transform = mm(m_translate(e.pos[1], e.pos[2], e.pos[3]), mm(mm(m_rot_x(e.angles[1]), m_rot_y(e.angles[2])), m_rot_z(e.angles[3])))
    end
    e.hurt = function()
        e.health -= 1
        if e.health <= 0 then
            e.dying = true
        end
    end
    e.base_update = function()
        if e.dying then
            e.die_time += 1
            if e.die_time == 1 or e.die_time == 10 or e.die_time == 20 then
                --circle_make(v_add(e.pos, vec(rnd(2)-1,rnd(2)-1,rnd(2)-1)), 7, 2)
            end
            if e.die_time > 80 then
                del(ents, e)
                need_entgrid_generation = true
            end            
        end
    end
    return e
end

function update_internal_transforms(e)
    for p in all(e.parts) do
        if e.dirty or p.dirty then
            if p.transform.is_identity then
                p.world_transform = e.transform
            else
                p.world_transform = mm(e.transform, p.transform)
            end
            for poly in all(p.polys) do
                poly.world_center = mv(p.world_transform, poly.center)
                poly.world_normal = v_sub(mv(p.world_transform, poly.normoffset), poly.world_center)
            end
        end
        p.dirty = false
    end
    e.dirty = false
end

entgrid = {}
egbounds = 30
egsize = 5
function generate_entgrid()
    entgrid = {}
    for i = -egbounds, egbounds do
        entgrid[i] = {}
    end
    for e in all(ents) do
        local pos = e.entgrid_pos or mv(e.transform, vec())
        local bin = clamp(pos[3] \ egsize, -egbounds, egbounds)
        add(entgrid[bin],e)
    end
end

function get_visible_ents(pos)
    local results = {}
    local bin = pos[3] \ egsize
    for i = min(bin + 2, egbounds), max(bin - 5, -egbounds), -1 do
        for e in all(entgrid[i]) do
            add(results, e)
        end
    end
    return results
end

function part(polys, transform)
    return {
        polys = polys,
        transform = transform or m_identity(),
        dirty = true
    }
end

dying_polys = {}

function poly(points, target)
    local avg = vec()
    for p in all(points) do
        avg = v_add(avg, v_mul(p, 1 / #points))
    end
    local d1 = v_norm(v_sub(points[2], points[1]))
    local d2 = v_norm(v_sub(points[3], points[2]))
    local p = {
        points = points,
        center = avg,
        normal = v_cross(d1, d2),
        palette = nil,
        target = target or false,
        selected = false,
        shadow = true,
        die_time = 0,
    }
    p.normoffset = v_add(p.center, p.normal)
    if target then p.fill = 0b0000000001000000 end
    return p
end

function final_point(t, p)
    local pta = mv(t, p)
    return vec(pta[1] / pta[4] * 64 + 64, pta[2] / pta[4] * 64 + 64, pta[3] / pta[4], pta[4])
end

function draw_3d_scene(t, target2d)
    -- Make a set of bins to place all polygons into based on distance from camera
    -- This is like a Radix sort. 
    local num_polys_queued = 0
    local polycap = 600

    zbins = {}
    for i = 1, 32 do
        add(zbins, {})
    end

    for c in all(circles) do
        local dist = v_mag(v_sub(c.pos, camera.pos))
        local bin = 32 - clamp((dist * 32 \ -(camera.far - camera.near)), 0, 31)
        add(zbins[bin], {type='circle', circle=c, dist=dist})
    end

    for e in all(get_visible_ents(camera.pos)) do
        if e.visible then
            for part in all(e.parts) do
                local trans
                if e.static then
                    trans = t
                else
                    trans = mm(t, part.world_transform) -- slow
                end
                
                for p in all(part.polys) do
                    if num_polys_queued >= polycap then break end--print("over poly limit!!") break end
                    local norm = p.world_normal
                    
                    local delta = v_sub(p.world_center, camera.pos)
                    
                    -- delta needs normalize or no?
                    local dot = delta[1] * norm[1] + delta[2] * norm[2] + delta[3] * norm[3]
                    if e.deadly or dot < 0 and p.die_time < 20 then
                        local dist = v_mag(delta)
                        --local t_center = mv(trans, p.center)
                        --local d = v_mag(t_center)
                        local bin = 32 - clamp((dist * 32 \ -(camera.far - camera.near)), 0, 31)
                        add(zbins[bin], {type='ent', ent=e, part=part, poly=p, transform=trans, center_2d=t_center, center=p.center, dot = dot, die_time = e.die_time})
                        num_polys_queued += 1
                    end
                end
                if num_polys_queued >= polycap then break end
            end
            if num_polys_queued >= polycap then break end
        end
    end
    add(debugs,num_polys_queued)

    --return end function _QWERTY()

    if false then
        fillp()
        for i, bin in pairs(zbins) do
            for p in all(bin) do
                if p.type=="ent" and p.poly.shadow and p.center_2d[3] / p.center_2d[4] > -1 and p.center_2d[3]/ p.center_2d[4] < 1 then
                    circfill(p.center_2d[1] / p.center_2d[4] * 64 + 64, p.center_2d[2] / p.center_2d[4] * 64 + 64, 4 / (p.center_2d[3] / p.center_2d[4]), 0)
                end
            end
        end
    end

    --return end function _QWERTY()

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
            if p.type == "ent" then
                -- Figure out 2d coords of each pt
                local pts2d = {}
                local reject = false
                for j = 1, #p.poly.points do
                    local pt = p.poly.points[j]
                    local pta = mv(p.transform, pt)
                    local ptb = {pta[1] / pta[4], pta[2] / pta[4], pta[3] / pta[4], 1}
                    if ptb[3] < -1 or ptb[3] > 1 then
                        reject = true
                        break
                    else
                        add(pts2d, {ptb[1] * 64 + 64, ptb[2] * 64 + 64, ptb[3], 1})
                    end
                end
                local diefill = nil
                if not reject then
                    fill = p.poly.fill
                    if p.poly.pulse and i > 16 then
                        if pulse_t < 4 then fill = 0b000000000000
                        elseif pulse_t < 8 then fill = 0b0101101001011010 end
                    end
                    if p.die_time > 0 then
                        diefill = flr(rnd(65535))
                        for i = 1, p.die_time \ 10 do
                            diefill |= flr(rnd(65535))
                        end
                        fill = diefill
                    end                
                    if fill and #pts2d == 4 then
                        fillp(fill)
                        trifill(pts2d[1][1],pts2d[1][2],pts2d[2][1],pts2d[2][2],pts2d[3][1],pts2d[3][2],color)
                        trifill(pts2d[1][1],pts2d[1][2],pts2d[3][1],pts2d[3][2],pts2d[4][1],pts2d[4][2],color)                
                    end

                    if p.poly.target and i > 8 then
                        local pc = mv(p.transform, p.center)
                        local pch = {pc[1] / pc[4], pc[2] / pc[4], pc[3] / pc[4], 1}
                        if pch[3] > -1 and pch[3] < 1 then
                            --DRAW NORMALS 
                            --[[
                            local normoff = v_add(p.center, p.poly.normal)
                            local norm2d = final_point(p.transform, normoff)
                            fillp(█)
                            line(pc[1] / pc[4] * 64 + 64, pc[2] / pc[4] * 64 + 64, norm2d[1], norm2d[2], 7)
                            ]]--
                            --print(p.dot, pc[1] / pc[4] * 64 + 64, pc[2] / pc[4] * 64 + 64, 7)
                            local xd = abs(pc[1] / pc[4] * 64 + 64 - target2d[1])
                            local yd = abs(pc[2] / pc[4] * 64 + 64 - target2d[2])
                            if p.ent.deadly or p.poly.selected or xd < 25 and yd < 25 then
                                local ccolor = 5
                                if xd < 5 and yd < 5 then
                                    ccolor = 7
                                    if p.poly.target and not p.poly.selected and player.selecting and #player.selected < 8 then
                                        local data = {ent=p.ent, part=p.part, poly=p.poly}
                                        add(player.selected, data)
                                        add(player.selected_chimes, data)
                                        p.poly.selected = true
                                        player.last_select_time = 0
                                    end
                                end
                                --circfill(pc[1] / pc[4] * 64 + 64, pc[2] / pc[4] * 64 + 64, 1, ccolor)
                                local sn = 33
                                if p.ent.deadly then sn = 34 end
                                if p.poly.selected then sn = 35 end
                                spr(sn, pc[1] / pc[4] * 64 + 60, pc[2] / pc[4] * 64 + 60)
                            end 
                        end
                        if p.poly.selected then
                            --circfill(pc[1] / pc[4] * 64 + 64, pc[2] / pc[4] * 64 + 64, 1, 7)               
                        end
                    end

                    -- Draw lines between each point pair
                    if not p.poly.fill or extra_line then
                        fillp(diefill or pattern)
                        for i = 1, #pts2d do
                            if p.poly.selected then special_color = 7 else special_color = nil end
                            local pt1 = pts2d[i]
                            local pt2 = pts2d[i % #pts2d + 1]
                            line(pt1[1], pt1[2], pt2[1], pt2[2], special_color or color)
                        end
                    end
                end
            elseif p.type == "circle" then
                local pos2d = final_point(t, p.circle.pos)
                circfill(pos2d[1], pos2d[2], p.circle.radius / (p.dist / 10), p.circle.color)
            end
        end
    end

    -- Could isolate each line, move to bins, etc
    for jl in all(jlasers) do
        for i = 1, min(jl.t + 1,3) do
            
            local pt1 = jl.points[i]
            local pt2 = jl.points[i+1]
            local pt12d = final_point(t, pt1)
            local pt22d = final_point(t, pt2)
            circfill(pt12d[1], pt12d[2], 2, 12)
            circfill(pt22d[1], pt22d[2], 2, 7)
            
            line(pt12d[1], pt12d[2], pt22d[1], pt22d[2], 12)
        end
    end
end

function deserialize_entity(str)
    local parts = split(str, "\n")
    local e = ent()
    e.health = parts[1]
    for i = 2, #parts do
        local strpolys = split(parts[i], "/")
        local polys = {}
        for j = 1, #strpolys do
            local strpts = split(strpolys[j], ";")
            local pts = {}
            for k = 2, #strpts do
                local pt = strpts[k]
                local comps = split(pt, ",")
                add(pts, {comps[1],comps[2],comps[3],1})
            end
            add(polys, poly(pts, strpts[1] == 1))
        end
        p = part(polys)
        add(e.parts, p)
    end
    return e
end

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

function make_missile(pos, vel)
    local e = ent()
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
    e = deserialize_entity(enemy_missile)  
    e.deadly = true
    e.pos = vec(pos[1],pos[2],pos[3])
    e.vel = {vel[1],vel[2],vel[3]}
    e.speed = 0.5
    e.time = 0
    
    e.update = function()
        if e.dying then return end
        e.time += 1
        if e.time % 30 == 0 then
            circle_make(v_sub(vec(e.pos[1],e.pos[2],e.pos[3]),v_mul(e.vel, 2)), 8, 1)
        end
        local off = min(-16 / ((e.time / 100)+1) + (2 / abs(e.pos[1] + e.pos[2])),0)
        local delta = v_sub(v_add(camera.pos,{0,0,off}), e.pos)
        local towards = v_norm(delta)
        local dist = v_mag(delta)
        if v_mag(v_sub(camera.pos, e.pos)) < 1 then
            del(ents, e)
            need_entgrid_generation = true
            take_damage(e)
        end
        local distinc = 1--max(10 / dist,1)
        e.vel = v_add(e.vel, v_mul(towards, 0.001 * distinc))
        e.vel = v_limit(e.vel, max(0.05 / distinc, 0.03))
        e.pos = v_add(e.pos, e.vel)
        local t = e.time / 20
        e.transform = mm(
            m_translate(e.pos[1],e.pos[2],e.pos[3]),
            m_look(v_norm({e.vel[1],e.vel[2],e.vel[3]}), vec(0,1,0))
        )
        e.parts[1].dirty = true
        update_internal_transforms(e)
    end
    add(ents, e)
    update_internal_transforms(e)
    printh(serialize_entity(e), "entity.txt")
    return e
end

function make_artillery(pos)
    --local e = deserialize_entity(enemy_artillery)
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
    local rad = 1.25
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
    end
    add(e.parts, part(polys, m_translate(0, 0, 0)))

    e.time = 0
    e.update = function()
        local zdiff = e.pos[3] - player.pos[3]
        e.parts[3].transform = m_rot_y(tf / 350 * 4)
        e.parts[3].dirty = true
        if zdiff > -22 and zdiff < -5 then
            e.time += 1
            if e.time % 380 == 20 then
                make_missile({e.pos[1],e.pos[2] + 3,e.pos[3]}, vec(0,2,0))
                need_entgrid_generation = true
            end
        end
        update_internal_transforms(e)        
    end
    e.pos = pos
    e.health = 4
    e.compute_transform()
    add(ents,e)   
    update_internal_transforms(e)
end

function make_minion(pos, targetxy, vel, killer)
    local e = deserialize_entity(enemy_minion)
    e.pos = pos
    e.vel = vel
    e.targetxy = targetxy
    e.time = 0
    e.visible = false
    e.killer = killer
    e.update = function()
        if e.dying then return end
        local zdiff = abs(camera.pos[3] - e.pos[3])
        if zdiff > 22 then return end
        e.visible = true
        e.time += 1
        local target = e.targetxy
        if e.time < 50 then
            target = {e.targetxy[1] + (e.targetxy[1] - pos[1]) * 2,e.targetxy[2] + (e.targetxy[2] - pos[2]) * 2,0}
        end
        local delta = {target[1] - e.pos[1], target[2] - e.pos[2], 0}
        if abs(delta[1]) + abs(delta[2]) > 0.1 or (e.killer and zdiff < 12) then
            local dist = v_mag(delta)
            local dir = v_norm(delta)
            e.vel = v_add(e.vel, v_mul(dir, 0.01 + clamp(e.time-40,0,20) / 10000 * dist))--0.04 / max(dist,0.5) * (dist / 10)))
            e.vel = v_mul(e.vel, 0.97 - min(e.time,20) / 2000)
            e.vel = v_limit(e.vel, 1)
            if zdiff < 11 then
                e.vel[3] = 0.05
            end                        
            e.pos = v_add(e.pos, v_mul(e.vel, 1))
            e.angles[3] = sin(clamp(-e.vel[1], -1,1)) * 1
            e.angles[2] = sin(clamp(-e.vel[1], -1,1)) * -1
            e.dirty = true
            e.compute_transform()
            update_internal_transforms(e)          
        end
        if zdiff < 12 then
            if e.killer then
                e.deadly = true
                e.targetxy = v_mul(e.targetxy, 0.1)
                if zdiff < 4 then
                    take_damage(e)
                    del(ents, e)
                    need_entgrid_generation = true
                end
            else
                e.targetxy = {0,30,0}
                if e.pos[2] > 20 then
                    del(ents, e)
                    need_entgrid_generation = true
                end
            end
        end
            
    
        --add(debugs, #e.parts[1].polys[2].points)
        
    end
    e.compute_transform()
    update_internal_transforms(e)
    add(ents, e)
    return e
end

---- PICO ----
function _init()
    camera = {
        --pos=vec(0,0,57),
        pos=vec(0,0,15),
        fwd=vec(0,0,1),
        angles=vec(),
        angle_velocities = vec(),
        view_mat = nil,
        near = -0.5,
        far = -30,
    }

    player = {
        pos = v_add(camera.pos, vec(0,0,-5.5)),
        cursor_angles = vec(),
        selecting = false,
        selected = {},
        selected_chimes = {},
        last_select_time = 0,
        stage = 2,
        health = 0,
        hit_time = 100,        
    }
    perspective_transform = m_perspective(camera.near, camera.far, -2 * camera.near * 1.62, -2 * camera.near * 1.62)

    --make_artillery({8, -2, 0})
    --make_artillery({-8, -2, -24})

    for i = 0,3 do 
        make_minion({5,-2,30 - i * 0.5}, {-5 + i * 3.33,1,0}, {0,0.25,0}, i == 0)
    end
    for i = 0,3 do 
        make_minion({-5,2,23 - i * 0.5}, {5 - i * 3.33,-1,0}, {0,0.25,0}, i == 0)
    end    
    for i = 0,5 do
        local theta = i / 6 * 6.2818
        make_minion({0,-4,15 - i * 0.5}, {cos(theta) * 3,sin(theta) * 3,0}, {0,0.25,0}, i == 0)
    end

    make_artillery({6, -2, 0})

    for i = -30, 30 do
        local e = ent()
        local polys = {}
        for j = -1,1, 2 do
            local pol = poly({
                vec(-1 + j * 1.25 + i % 2 - 0.5, -3, 0.5 + i * 2),
                vec(1 + j * 1.25 + i % 2 - 0.5, -3, 0.5 + i * 2),
                vec(1 + j * 1.25 + i % 2 - 0.5, -3, -0.5 + i * 2),
                vec(-1 + j * 1.25 + i % 2 - 0.5, -3, -0.5 + i * 2),
            })
            pol.shadow = false
            pol.pulse = true
            --pol.fill = 0b0101101101011110
            add(polys, pol)    
        end
        e.parts = {part(polys, m_identity())}
        e.static = true
        e.entgrid_pos = {0,-3,i * 2}
        add(ents, e)
        update_internal_transforms(e)
    end
    

    generate_entgrid()

    music(0,0,1)
end

function take_damage(source)
    player.hit_time = 0
    player.stage -= 1
end

function update_player()
    
    if player.hit_time < 20 and player.hit_time % 5 == 0 then
        for i = 0, 2 do
            circle_make({player.pos[1] + rnd(2) - 1,player.pos[2] + rnd(2) - 1,player.pos[3] - 1,1}, 7, 2)
        end
    end
    player.hit_time += 1

    if btn(0) then
        player.cursor_angles[2] -= 0.02
    end
    if btn(1) then
        player.cursor_angles[2] += 0.02
    end    
    if btn(2) then
        player.cursor_angles[1] -= 0.02
    end
    if btn(3) then
        player.cursor_angles[1] += 0.02
    end 
    player.cursor_angles[2] = clamp(player.cursor_angles[2], -1.6, 1.6)
    player.cursor_angles[1] = clamp(player.cursor_angles[1], -0.75, 1)
    player.selecting = btn(5)
    if not player.selecting and #player.selected > 0 then
        sfx(9,1)
        local n = 0
        for data in all(player.selected) do
            data.poly.selected = false
            data.poly.target = false
            local jl = jlaser_make(player, data.poly, data.ent)
            jl.t -= n
            n += 1.25
        end
        player.selected = {}
    end
    player.last_select_time += 1

    for axis in all({2,1}) do
        yad = angledelta(player.cursor_angles[axis], camera.angles[axis])
        amt = abs(yad) * 1
        if yad > 0.1 then
            camera.angle_velocities[axis] -= 0.01 * amt
            camera.angles[axis] -= 0.000
        elseif yad < -0.1 then
            camera.angle_velocities[axis] += 0.01 * amt
            camera.angles[axis] += 0.000
        end
        camera.angle_velocities[axis] *= 0.9
        camera.angles[axis] += camera.angle_velocities[axis]
    end

    player.pos = v_add(
        v_mul(player.pos, 0.9),
        v_mul(v_add(camera.pos, v_add(v_mul(camera.fwd, 2), vec(0,-0.5 + sin(tf / 13) * 0.05,0))), 0.1)
    )
end

function on_beat_update(beat)
    
    if beat % 4 == 0 then
        --camera.pos -= vec(0,0,0.3)
        pulse_t = 0
    end
    if beat % 1 == 0 then
        if #player.selected_chimes > 0 then
            sfx(8, 1, flr(rnd(6)) * 4, 2)
            deli(player.selected_chimes, 1)
        end
    end

    --music(0, 0, 4)
end

speed = 0.02
need_entgrid_generation = true
function _update60()
    pulse_t += 1
    debugs = {}
    if need_entgrid_generation then
        generate_entgrid()
        need_entgrid_generation = false
    end
    camera.pos = v_sub(camera.pos, vec(0,0,speed))
    local current_music_timing = stat(20)
    if current_music_timing != last_music_timing and current_music_timing then
        on_beat_update(current_music_timing)
        on_beat = current_music_timing
    else
        on_beat = nil
    end

    for p in all(dying_polys) do
        p.die_time += 1
        if p.die_time < 20 then
            for i = 1, #p.points do
                local delta = v_sub(p.center, p.points[i])
                p.points[i] = v_add(p.points[i], v_mul(delta, 0.1))
            end
        end
    end

    local rot = mm(m_rot_x(camera.angles[1]), m_rot_y(camera.angles[2]))
    camera.view_mat = mm(m_look({0,0,-1},{0,1,0}), rot)
    camera.fwd = mv(mm(m_rot_y(-camera.angles[2]), m_rot_x(-camera.angles[1])), vec(0,0,-1))
    
    for e in all(get_visible_ents(camera.pos)) do
        if e.base_update then e.base_update() end
        if e.update then e.update() end
    end
    for c in all(circles) do c.update() end
    for jl in all(jlasers) do jl.update() end

    update_player()

    tf += 1
    last_music_timing = current_music_timing
end

function draw_bg(t)
    local c1 = 5
    local c2 = 5
    if on_beat != nil and on_beat % 4 == 0 then
        c1, c2 = 5, 10
    end    
    local sy = final_point(t, v_add(camera.pos, vec(0,0,-50)))[2]
    for z = 0, 15 do
        local bha = z / 16 * 6.2818
        local y = background_heights[z + 1] * 4 + sy-- - sin(camera.angles[1]) * 80
        local deltabha = angledelta(camera.angles[2], bha)
        local x = 64 + deltabha * 72

        circfill(x, y + 25, 20 + z % 6, c2)
        rectfill(x - 12, y + (z % 3) * 5, x + 12, y + 10, c2)
        fillp(0b0000111100001111)
        circfill(x, y + 30, 22 + z % 6, c1)
        rectfill(x - 10, y + ((z) % 3) * 5 + 2, x + 10, y + 60, c1) 
        fillp(0b0000000000000000)
        circfill(x, y + 35, 23 + z % 6, 0)
        rectfill(x - 7, y + ((z) % 3) * 5 + 5, x + 7, y + 60, 0) 
    end
    rectfill(0, sy + 20, 128, 128, 0)

    --rectfill(0, sy + 20, 128, sy + 30, c1)
    fillp(0b0101111110101111)
    rectfill(0, sy + 30, 128, sy + 40, 0x01)
    fillp(0b1010010110100101)
    rectfill(0, sy + 40, 128, sy + 50, 0x01)
    
    fillp(0b1010000001010000)
    rectfill(0, sy + 50, 128, 128, 0x01)      
end

function draw_player(t, cx)
    local pos = final_point(t, player.pos)
    if pos[3] > 0 and pos[3] < 1 then
        local w = 32--min(8 / pos[3],32)
        local h = w
        local offset = 0
        local flip = false
        if abs(cx - 64) > 8 then offset = 32 end
        if abs(cx - 64) > 24 then offset = 64 end
        if cx < 64 then flip = true end
        sspr(0 + offset,32,32,32, pos[1] - w / 2, pos[2] - h / 2, w, h, flip, false)
        for i = 0, 14 do
            for j = 0, 14 do
                local x = i + pos[1] - w / 2 + 9
                local y = j + pos[2] - h / 2 + 2
                local dx = i - 7
                local dy = j - 7
                if dx*dx + dy*dy < 8 * 8 then
                    pset(x,y, recolor[pget(x,y)+1])
                end
            end
        end
    end
end

function _draw()
    local t = mm(mm(perspective_transform, camera.view_mat), m_translate(-camera.pos[1], -camera.pos[2], -camera.pos[3]))
    cls()  
    draw_bg(t)
    local cursorm = mm(m_rot_y(-player.cursor_angles[2]), m_rot_x(-player.cursor_angles[1]))
    local target2d = final_point(t, v_add(camera.pos, mv(cursorm, vec(0,0,-5))))

    draw_3d_scene(t, target2d)

    if target2d[3] > -1 and target2d[3] < 1 then
        fillp()
        spr(1 + (player.selecting and 2 or 0), target2d[1] - 8, target2d[2] - 8, 2, 2)
        if #player.selected > 0 and player.last_select_time < 12 then
            spr(4 + #player.selected, target2d[1] - 4, target2d[2] - 12)
        end
    end

    draw_player(t, target2d[1])

    pal()
    if player.hit_time < 20 then
        pal({2,2,2,2,2,8,7,8,8,8,8,8,8,8,8}, 1)
    end

    color(7)
    cursor()
    for d in all(debugs) do
        print(d)
    end
    print(stat(20))
end
__gfx__
000000000000000000000000000000000000000000cccc000cccccc00cccccc00cccccc00cccccc00ccccc000cccccc00cccccc00cccccc00000000000000000
000000000000000000000000000000000000000000c00c000c0000c00c0000c00c0cc0c00c0000c00c000c000c0000c00c0000c00c0000c00000000000000000
000000000057770000777500000000000000000000cc0c000cccc0c00cccc0c00c0cc0c00c0cccc00c0cccc00cccc0c00c0cc0c00c0cc0c00000000000000000
0000000000700000000007000001ccc00ccc1000000c0c000c0000c00c0000c00c0000c00c0000c00c0000c00000c0c00c0000c00c0000c00000000000000000
000000000070000000000700000c00000000c000000c0c000c0cccc00cccc0c00cccc0c00cccc0c00c0cc0c00000c0c00c0cc0c00cccc0c00000000000000000
000000000070000000000700000c00000000c00000cc0cc00c0cccc00cccc0c00000c0c00cccc0c00c0cc0c00000c0c00c0cc0c00000c0c00000000000000000
000000000000000000000000000c00000000c00000c000c00c0000c00c0000c00000c0c00c0000c00c0000c00000c0c00c0000c00000c0c00000000000000000
000000000000000000000000000000000000000000ccccc00cccccc00cccccc00000ccc00cccccc00cccccc00000ccc00cccccc00000ccc00000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000c00000000c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000070000000000700000c00000000c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000070000000000700000c00000000c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000700000000007000001ccc00ccc10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000005777000077750000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009999000088880000777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000997799008877880077cc770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000097997900878878007c77c70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000097997900878878007c77c70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000997799008877880077cc770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009999000088880000777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000777770000000000000000000000000007777700000000000000000000000000077777000000000000000000000000000000000000000000000
00000000000077007007700000000000000000000000770070077000000000000000000000007700700770000000000000000000000000000000000000000000
00000000000700007000070000000000000000000007000070000700000000000000000000070007000007000000000000000000000000000000000000000000
00000000007000007000007000000000000000000070000070000070000000000000000000700007000000700000000000000000000000000000000000000000
00000000070000007000000700000000000000000700000700000007000000000000000007000007000000070000000000000000000000000000000000000000
00000000070000007000000700000000000000000700000700000007000000000000000007000070000000070000000000000000000000000000000000000000
00000000700000007000000070000000000000007000000700000000700000000000000070000070000000007000000000000000000000000000000000000000
00000000700000007000000070000000000000007000000700000000700000000000000070000070000000007000000000000000000000000000000000000000
00000000770000007000000770000000000000007700000700000007700000000000000077000070000000077000000000000000000000000000000000000000
00000000707770007000777070000000000000007077700700007770700000000000000070777070000077707000000000000000000000000000000000000000
00000000700007777777000070000000000000007000077777770000700000000000000070000777777700007000000000000000000000000000000000000000
00000000070000007000000700000000000000000700000700000007000000000000000007000070000000070000000000000000000000000000000000000000
00000000070000007000000700000000000000000700000700000007000000000000000007000070000000070000000000000000000000000000000000000000
00000000007000007000007000000000000000000070000700000070000000000000000000700007000000700000000000000000000000000000000000000000
00000000000700007000070000000000000000000007000700000700000000000000000000070007000007000000000000000000000000000000000000000000
00000000000077007007700000000000000000000000770070077000000000000000000070007700700770000000000000000000000000000000000000000000
00000000000000777770000000000000000000007000007777700000000000000000000707700077777000000000000000000000000000000000000000000000
00000007000000070700000007000000000000070777000707000000000000000000000070077707070000000000000000000000000000000000000000000000
00000070777777700077777770700000000000007000777000777000700000000000000000000070007000000000000000000000000000000000000000000000
00000007000000070700000007000000000000000000000707000777070000000000000000000007070777007000000000000000000000000000000000000000
00000000000000007000000000000000000000000000000070000000700000000000000000000000700000770700000000000000000000000000000000000000
00000000000000007000000000000000000000000000000070000000000000000000000000000000700000007000000000000000000000000000000000000000
00000000000000007000000000000000000000000000000070000000000000000000000000000000700000000000000000000000000000000000000000000000
00000000000000007000000000000000000000000000000070000000000000000000000000000000700000000000000000000000000000000000000000000000
00000000000000007000000000000000000000000000000070000000000000000000000000000000700000000000000000000000000000000000000000000000
00000000000000007000000000000000000000000000000070000000000000000000000000000000700000000000000000000000000000000000000000000000
00000000000000007000000000000000000000000000000070000000000000000000000000000000700000000000000000000000000000000000000000000000
00000000000000070700000000000000000000000000000707000000000000000000000000000007070000000000000000000000000000000000000000000000
00000000000000007000000000000000000000000000000070000000000000000000000000000000700000000000000000000000000000000000000000000000
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
95100000245551b50021500045002855500500005000050026555005000050000500295550050000500005002b5550050000500005002d5550050000500005002f55500500005000050030555005000050000500
490300000c5701363516620196101b6101c6101e6001f60020600056000d600066001f60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
910200002871028620285102851006610005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000205300000000000000002053000000000000000020530000000000000000205300000000000000002053000000000000000020530000000000000000205300000000000000002053000000000000000
__music__
03 10424344

