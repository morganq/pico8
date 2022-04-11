pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
-- wireframe
-- by morganquirk

p8cos = cos function cos(angle) return p8cos(angle/(3.1415*2)) end
p8sin = sin function sin(angle) return -p8sin(angle/(3.1415*2)) end

function vec(x,y,z,w)
    return {x=x,y=y,z=z or 0,w=w or 1}
end

function dist(v, divfactor)
    divfactor = divfactor or 1
    return sqrt((v.x / divfactor) ^ 2 + (v.y / divfactor) ^ 2 + (v.z / divfactor) ^ 2) * divfactor
end

function norm(v, divfactor)
    local d = dist(v, divfactor)
    return vec(v.x / d, v.y / d, v.z / d)
end

function clamp(x, a, b)
    return min(max(x, a), b)
end

polys = {
}

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

function m_translation(x,y,z)
    return {
        1,0,0,x,
        0,1,0,y,
        0,0,1,z,
        0,0,0,1
    }
end

function v_add(a,b)
    return vec(a.x + b.x, a.y + b.y, a.z + b.z)
end

function v_sub(a,b)
    return vec(a.x - b.x, a.y - b.y, a.z - b.z)
end

function cross(a,b)
    return vec(a.y * b.z - b.y * a.z, a.z * b.x - b.z * a.x, a.x * b.y - b.x * a.y)
end

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
function p01_triangle_335(x0,y0,x1,y1,x2,y2,col)
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

function look_at(target)
    local delta = v_sub(target, camera.pos)
    local fwd = norm(delta)
    --add(debugs, str_point(fwd))
    local side = cross(vec(0,1,0), fwd)
    --add(debugs, str_point(side))
    local up = cross(fwd, side)
    --add(debugs, str_point(up))    
    camera.fwd = fwd
    camera.view_mat = {
        side.x, side.y, side.z, 0,
        up.x, up.y, up.z, 0,
        fwd.x, fwd.y, fwd.z, 0,
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

-- stolen

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

function m_perspective(near, far, width, height)
    return {
        (2 - near) / width, 0, 0, 0,
        0, (2-near) / height, 0, 0,
        0, 0, -(far + near) / (far - near), (-2 * far * near) / (far - near),
        0,0,-1,0
    }
end

camera = {
    pos=vec(0,0,15),
    pitch=0,
    yaw=0,
    pitchv = 0,
    yawv = 0,
    tp = 0,
    ty = 0,
    view_mat = nil,
}

function _update()
    debugs = {}
end

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

function _init()
    cls()
    near = -0.5
    far = -20
    local width = -2 * near * 1.62
    local height = width
    perspective_transform = m_perspective(near, far, width, height)
    look_at(vec(0,0,0))

    for j = 0, 4 do
        local rad = sin(j / 4 * 3.14) * 2 + 2
        local count = j + 6
        for i = 0, count do
            local y = j
            local s1 = sin(i / count * 6.28 + 0.05) * rad
            local c1 = cos(i / count * 6.28 + 0.05) * rad
            local s2 = sin((i + 1) / count * 6.28 - 0.05) * rad
            local c2 = cos((i + 1) / count * 6.28 - 0.05) * rad  
            add(polys, {
                vec(s1 + 5,y-0.3,c1),
                vec(s1 + 5,y+0.3,c1),
                vec(s2 + 5,y+0.3,c2),
                vec(s2 + 5,y-0.3,c2),
                center=vec((s1+s2)/2, y, (c1+c2)/2)
            })
        end
    end
end

-- Radial distance between two angles
function angledelta(a,b)
    local delta = (b - a + 3.14159) % 6.2818 - 3.14159
    if delta < -3.14159 then return delta + 6.2818 else return delta end
end

tf = 0
function _update60()
    local rotated = false
    if btn(0) then
        camera.ty -= 0.02
    end
    if btn(1) then
        camera.ty += 0.02
    end    
    if btn(2) then
        camera.tp -= 0.02
    end
    if btn(3) then
        camera.tp += 0.02
    end 
    yad = angledelta(camera.ty, camera.yaw)
    if yad > 0.2 then
        camera.yawv -= 0.01
        camera.yaw -= 0.005
    elseif yad < -0.2 then
        camera.yawv += 0.01
        camera.yaw += 0.005
    end
    pad = angledelta(camera.tp, camera.pitch)
    if pad > 0.2 then
        camera.pitchv -= 0.01
        camera.pitch -= 0.005
    elseif pad < -0.2 then
        camera.pitchv += 0.01
        camera.pitch += 0.005
    end    
    camera.yawv *= 0.8
    camera.pitchv *= 0.8
    camera.yaw += camera.yawv
    camera.pitch += camera.pitchv
    camera.view_mat = mm(m_look(), mm(m_rot_x(camera.pitch), m_rot_y(camera.yaw)))
    camera.pos = v_add(camera.pos, vec(0,0,-0.025))
    camera.cursor_pos = v_add(camera.pos, mv(mm(m_rot_y(-camera.ty), m_rot_x(-camera.tp)), camera.fwd))
    tf += 1
end

function transform_pt(pt)
    local t = mm(mm(perspective_transform, camera_look_transform), camera_location_transform)
    local pt3 = mv(t, pt)
    pt4 = vec(pt3.x / pt3.w, pt3.y / pt3.w, pt3.z / pt3.w)
    return vec(pt4.x * 64 + 64, pt4.y * 64 + 64, pt4.z)
end

recolor={0,1,0,13,0,0,0,0,12,12,0,0,0,0,0}

function _draw() --return end function __draw()
    pz = {}
    for i = 1, 64 do
        add(pz, {})
    end
    cls()
    print(stat(7), 0, 0, 7)
    camera_location_transform = m_translation(-camera.pos.x, -camera.pos.y, -camera.pos.z)
    camera_look_transform = camera.view_mat

    local t = mm(mm(perspective_transform, camera_look_transform), camera_location_transform)
    add(debugs, str_matrix(camera.view_mat))

    for p in all(polys) do
        local delta = v_sub(p.center,camera.pos)
        local d = dist(delta,10)
        local bin = 64 - clamp((d * 64 \ -(far - near)), 0, 64)
        add(pz[bin], p)
    end

    local cursor_screen = transform_pt(
        camera.cursor_pos
    )
    print(str_point(cursor_screen))

    for bin,ps in pairs(pz) do
        for p in all(ps) do
            local pts2d = {}
            for pt in all(p) do
                local pt3 = mv(t, pt)
                local pt4 = vec(pt3.x / pt3.w, pt3.y / pt3.w, pt3.z / pt3.w)
                --if pt4.x < -2 or pt4.x > 2 or pt4.y < -2 or pt4.y > 2 or pt4.z < -1 or pt4.z > 1 then
                if pt4.z < -1 or pt4.z > 1 then
                else                
                    local pt5 = vec(pt4.x * 64 + 64, pt4.y * 64 + 64, pt4.z)
                    add(pts2d, pt5)
                end
            end
            local fill = false
            local cz = 100
            for i = 1, #pts2d do
                local p2d1 = pts2d[i]
                local p2d2 = pts2d[i % #pts2d + 1]
                local c = 2
                local pat = █
                local z = (p2d1.z + p2d2.z)
                if z > 1.98 then
                    pat = ░
                    c = 2
                elseif z > 1.95 then                
                    pat = ▒
                    c = 2
                elseif z > 1.94 then
                    c = 2
                elseif z > 1.90 then
                    c = 4                
                elseif z > 1.82 then
                    c = 9
                elseif z > 1.75 then
                    c = 10
                else
                    c = 10
                    fill = true
                    cz = min(z,cz)
                end
                fillp(pat)
                line(p2d1.x, p2d1.y, p2d2.x, p2d2.y, c)
                if z < 1.75 then
                    line(p2d1.x + 0.75, p2d1.y, p2d2.x + 0.75, p2d2.y, c)
                    line(p2d1.x, p2d1.y + 0.75, p2d2.x, p2d2.y + 0.75, c)
                end
                --pset(p2d1.x, p2d1.y, 10+i)
            end
            --fill = true
            if fill then
                if cz > 1.70 then
                    pat = ░
                elseif cz > 1.5 then
                    pat = ▒
                else
                    pat = █
                end      
                --fillp(pat)      
                --draw_polygon148(pts2d, 10)
                --line(pts2d[1].x, pts2d[1].y, pts2d[3].x, pts2d[3].y, 10)
                --p01_triangle_335(pts2d[1].x,pts2d[1].y,pts2d[2].x,pts2d[2].y,pts2d[3].x,pts2d[3].y,10)
                --p01_triangle_335(pts2d[1].x,pts2d[1].y,pts2d[3].x,pts2d[3].y,pts2d[4].x,pts2d[4].y,10)
            end
        end
    end

    for x = cursor_screen.x - 3, cursor_screen.x + 2 do
        for y = cursor_screen.y - 3, cursor_screen.y + 2 do
            pset(x,y,recolor[pget(x,y)])
        end
    end
    spr(1, cursor_screen.x - 4, cursor_screen.y - 4)

    for d in all(debugs) do
        print(d)
    end
end
__gfx__
00000000077007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000077007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
