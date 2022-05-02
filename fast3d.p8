pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
-- fast3d
-- by morganquirk

models = {}

p8cos = cos function cos(angle) return p8cos(angle/(3.1415*2)) end
p8sin = sin function sin(angle) return -p8sin(angle/(3.1415*2)) end

function update_tri(model, tri_index)
    local t = {
        model.points[model.triangles[tri_index].point_indicies[1]],
        model.points[model.triangles[tri_index].point_indicies[2]],
        model.points[model.triangles[tri_index].point_indicies[3]]
    }
    local d1 = v_norm(v_sub(t[2], t[1]))
    local d2 = v_norm(v_sub(t[3], t[2]))    
    local norm = v_norm(v_cross(d1, d2))
    model.triangles[tri_index].normal = norm
    local center = {
        (t[1][1] + t[2][1] + t[3][1]) / 3,
        (t[1][2] + t[2][2] + t[3][2]) / 3,
        (t[1][3] + t[2][3] + t[3][3]) / 3,
    }    
    model.triangles[tri_index].center = center
end

function model(points, tris)
    local m = {
        points = points,
        triangles = {},
    }
    for i = 1, #tris do
        add(m.triangles, {point_indicies = tris[i]})
        update_tri(m, i)
    end
    return m
end

function add_cube(pos, mat)
    local base_pts = {
        {1 + pos[1],1 + pos[2],1 + pos[3],1}, -- 1 fbr
        {-1 + pos[1],1 + pos[2],1 + pos[3],1}, -- 2 fbl
        {-1 + pos[1],-1 + pos[2],1 + pos[3],1}, -- 3 ftl
        {1 + pos[1],-1 + pos[2],1 + pos[3],1}, -- 4 ftr
        {1 + pos[1],1 + pos[2],-1 + pos[3],1}, -- 5 kbr
        {-1 + pos[1],1 + pos[2],-1 + pos[3],1}, -- 6 kbl
        {-1 + pos[1],-1 + pos[2],-1 + pos[3],1}, -- 7 ktl
        {1 + pos[1],-1 + pos[2],-1 + pos[3],1}, -- 8 ktr      
    }
    local pts = {}
    for pt in all(base_pts) do
        add(pts, mv4(mat, pt))
    end
    

    local tris = {
        {1, 2, 3}, -- front
        {1, 3, 4},
        {5, 7, 6}, -- back
        {5, 8, 7},
        {2, 6, 3}, -- left
        {3, 6, 7},
        {1, 4, 5}, -- right
        {4, 8, 5},
        {1, 6, 2}, -- top
        {5, 6, 1},
        {3, 7, 4}, -- bottom
        {4, 7, 8},
    }
    local m = model(pts, tris)
    add(models, m)
end


-- Trifill routine stolen
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

function sm(m)
 local out = ""
 for i=1,16 do
  out = out..m[i]..","
  if i % 4 == 0 then
   out = out.."\n"
  end
 end
 return out
end

function sp(p)
    return p[1]..","..p[2]..","..p[3]..","..p[4]
end

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

function mv4(m, v)
    return {
        m[1] * v[1] +    m[2] * v[2] +    m[3] * v[3] +    m[4] * v[4],
        m[5] * v[1] +    m[6] * v[2] +    m[7] * v[3] +    m[8] * v[4],
        m[9] * v[1] +    m[10] * v[2] +   m[11] * v[3] +   m[12] * v[4],
        m[13] * v[1] +   m[14] * v[2] +   m[15] * v[3] +   m[16] * v[4]
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

function m_rot_x(theta)
    local c, s = cos(theta), sin(theta)
    return {
        1, 0, 0, 0,
        0, c, -s, 0,
        0, s, c, 0,
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

function _init()
    for i = 1,30 do
        add_cube({rnd(20) - 10, rnd(20) - 10,rnd(20) - 10}, mm4(m_rot_x(rnd(6.2818)), m_rot_y(rnd(6.2818))))
    end
end

camera = {
    pos = {0,2,10},
    angles = {-0.2,0,0},
    fwd = {0,0,-1},
}
tf = 0
stat_times = {}
function _update()
    stat_times = {}
    if btn(0) then camera.angles[2] += 0.02 end
    if btn(1) then camera.angles[2] -= 0.02 end
    if btn(2) then camera.angles[1] += 0.02 end
    if btn(3) then camera.angles[1] -= 0.02 end

    --camera.fwd = mv(m_rot_x(camera.angles[1]), mv(m_rot_y(camera.angles[2]), {0,0,-1}))
    --camera.pos[3] -= 0.01
    mat = mm4(m_rot_y(camera.angles[2]), m_rot_x(camera.angles[1]))
    camera.fwd = mv4(mat, {0,0,-1,1})
    
    if btn(4) then
        camera.pos = v_add(camera.pos, v_mul(camera.fwd, 0.1))
    end
    if btn(5) then
        camera.pos = v_add(camera.pos, v_mul(camera.fwd, -0.1))
    end
    tf += 1
end

function _draw()
    add(stat_times, stat(1))
    local nbins = 128
    cls()
    local m = mm4(m_perspective(-1, -50, 3.2, 3.2), m_look(camera.fwd, {0,1,0,1}))
    local tris = 0
    local drawn_tris = 0
    local zbins = {}
    local all_points = {}
    for i = 1,nbins do add(zbins, {}) end

    local m1,m2,m3,m5,m6,m7,m9,m10,m11,m12,m13,m14,m15 = m[1],m[2],m[3],m[5],m[6],m[7],m[9],m[10],m[11],m[12],m[13],m[14],m[15]
    local cpx, cpy, cpz = camera.pos[1], camera.pos[2], camera.pos[3]

    add(stat_times, stat(1))
    local single = 0
    local longest = 0
    local reject = false
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
                        local x2 = (m1 * x + m2 * y + m3 * z) / w2
                        local y2 = (m5 * x + m6 * y + m7 * z) / w2
                        local z2 = (m9 * x + m10 * y + m11 * z + m12) / w2
                        if x2 < -2 or x2 > 2 or y2 < -2 or y2 > 2 or z2 < -1 or z2 > 1 then
                            reject = true
                            break
                        end
                        transformed_points[index] = {x2 * 64 + 64,y2 * 64 + 64,z2}
                    end
                end
                if not reject then
                    local dist = sqrt(dirx * dirx + diry * diry + dirz * dirz)
                    local bin = nbins - flr(dist * nbins / 50 + 0.5)
                    add(zbins[bin], {
                        transformed_points[indicies[1]],
                        transformed_points[indicies[2]],
                        transformed_points[indicies[3]],
                        norm,
                    })
                    drawn_tris += 1
                
                end
            end
        end
    end
    add(stat_times, stat(1))
    for bin, contents in pairs(zbins) do
        for r in all(contents) do
            color(5 + r[4][1] * 3 + r[4][2])
            trifill(r[1][1],r[1][2],r[2][1],r[2][2],r[3][1],r[3][2])        
        end
    end
    add(stat_times, stat(1))
    local s_draw_init = flr((stat_times[2] - stat_times[1]) * 1398)
    local s_draw_transforms = flr((stat_times[3] - stat_times[2]) * 1398)
    local s_draw_renders = flr((stat_times[4] - stat_times[3]) * 1398)
    local tper = flr(s_draw_transforms / tris * 100)
    local rper = flr(s_draw_renders / drawn_tris * 100)    
    color(10)
    --cursor(0,100)
    cursor(0,90)
    print(drawn_tris.." drawn/"..tris.." total tris")
    print("init "..s_draw_init.."00")
    print("transforms "..s_draw_transforms.."00".." ("..tper.."/tri)")
    print("renders "..s_draw_renders.."00".." ("..rper.."/tri)")
    print("total "..s_draw_init + s_draw_transforms + s_draw_renders.."00/139,810 cycles")
    --print("special "..longest * 1398 * 100 - 38.3972)
end