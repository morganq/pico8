pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
-- lo-rez
-- by morganquirk

background_heights = split("-8,-6,-4,-2,-2,-1,0,0,1,1,2,1,1,0,-2,-5",",")

enemy_artillery = [[4
0;0.6607,1,-0.7507;1.3214,0,-1.5013;-1.3612,0,-1.4653;-0.6806,1,-0.7327/0;-0.7504,1,-0.661;-1.5008,0,-1.322;-1.4663,0,1.3601;-0.7332,1,0.68/0;-0.6616,1,0.7499;-1.3231,0,1.4998;1.3589,0,1.4674;0.6795,1,0.7337/0;0.7494,1,0.6621;1.4988,0,1.3242;1.4684,0,-1.3578;0.7342,1,-0.6789
0;0.6607,3,-0.7507;0.6607,1,-0.7507;-0.6806,1,-0.7327;-0.6806,3,-0.7327/0;-0.7504,3,-0.661;-0.7504,1,-0.661;-0.7332,1,0.68;-0.7332,3,0.68/0;-0.6616,3,0.7499;-0.6616,1,0.7499;0.6795,1,0.7337;0.6795,3,0.7337/0;0.7494,3,0.6621;0.7494,1,0.6621;0.7342,1,-0.6789;0.7342,3,-0.6789
1;1.4982,4,-0.0736;1.4982,3,-0.0736;0.077,3,-1.498;0.077,4,-1.498/0;1.4982,4.5,-0.0736;1.4982,4,-0.0736;1.0142,4,-0.5429;1.0142,4.5,-0.5429/0;0.5452,4.5,-1.013;0.5452,4,-1.013;0.077,4,-1.498;0.077,4.5,-1.498/1;-0.0724,4,-1.4983;-0.0724,3,-1.4983;-1.498,3,-0.0782;-1.498,4,-0.0782/0;-0.0724,4.5,-1.4983;-0.0724,4,-1.4983;-0.5421,4,-1.0147;-0.5421,4.5,-1.0147/0;-1.0126,4.5,-0.5461;-1.0126,4,-0.5461;-1.498,4,-0.0782;-1.498,4.5,-0.0782/1;-1.4983,4,0.0713;-1.4983,3,0.0713;-0.0794,3,1.4979;-0.0794,4,1.4979/0;-1.4983,4.5,0.0713;-1.4983,4,0.0713;-1.0151,4,0.5413;-1.0151,4.5,0.5413/0;-0.5468,4.5,1.0121;-0.5468,4,1.0121;-0.0794,4,1.4979;-0.0794,4.5,1.4979/1;0.0707,4,1.4983;0.0707,3,1.4983;1.4978,3,0.0805;1.4978,4,0.0805/0;0.0707,4.5,1.4983;0.0707,4,1.4983;0.5409,4,1.0154;0.5409,4.5,1.0154/0;1.0119,4.5,0.5475;1.0119,4,0.5475;1.4978,4,0.0805;1.4978,4.5,0.0805]]

enemy_minion = [[1
0;-1,-0.3,1;-0.9,-0.5,-1;-0.9,0.5,-1;-1,0.3,1/0;-1.1,-0.5,-1;-1,-0.3,1;-1,0.3,1;-1.1,0.5,-1
1;-0.2,-0.3,0;0.2,-0.3,0;0.5,0.3,0;-0.5,0.3,0
0;0.9,-0.5,-1;1,-0.3,1;1,0.3,1;0.9,0.5,-1/0;1,-0.3,1;1.1,-0.5,-1;1.1,0.5,-1;1,0.3,1]]

enemy_missile = [[1
0;0.3367,0.0957,0;0.0096,0.0027,-1;0.0024,-0.0097,-1;0.0858,-0.3393,0/0;-0.0853,-0.3394,0;-0.0024,-0.0097,-1;-0.0096,0.0027,-1;-0.3368,0.0953,0/0;-0.2513,0.2436,0;-0.0072,0.0069,-1;0.0072,0.007,-1;0.2508,0.2441,0/1;0.1,-0.1,-0.25;0.1,0.1,-0.25;-0.1,0.1,-0.25;-0.1,-0.1,-0.25]]

enemy_crown = [[33
0;1.9116,0,4.6201;3.5342,0,3.5369;3.5342,0.3,3.5369;1.9116,0.3,4.6201/0;3.5342,0,3.5369;4.6187,0,1.9152;4.6187,0.3,1.9152;3.5342,0.3,3.5369/0;4.6187,0,1.9152;5,0,0.0038;5,0.3,0.0038;4.6187,0.3,1.9152/0;5,0,0.0038;4.6209,0,-1.9099;4.6209,0.3,-1.9099;5,0.3,0.0038/0;4.6209,0,-1.9099;3.5396,0,-3.5315;3.5396,0.3,-3.5315;4.6209,0.3,-1.9099/0;3.5396,0,-3.5315;1.9187,0,-4.6172;1.9187,0.3,-4.6172;3.5396,0.3,-3.5315/0;1.9187,0,-4.6172;0.0077,0,-5;0.0077,0.3,-5;1.9187,0.3,-4.6172/0;0.0077,0,-5;-1.9064,0,-4.6223;-1.9064,0.3,-4.6223;0.0077,0.3,-5/0;-1.9064,0,-4.6223;-3.5287,0,-3.5423;-3.5287,0.3,-3.5423;-1.9064,0.3,-4.6223/0;-3.5287,0,-3.5423;-4.6157,0,-1.9223;-4.6157,0.3,-1.9223;-3.5287,0.3,-3.5423/0;-4.6157,0,-1.9223;-5,0,-0.0115;-5,0.3,-0.0115;-4.6157,0.3,-1.9223/0;-5,0,-0.0115;-4.6238,0,1.9028;-4.6238,0.3,1.9028;-5,0.3,-0.0115/0;-4.6238,0,1.9028;-3.545,0,3.526;-3.545,0.3,3.526;-4.6238,0.3,1.9028/0;-3.545,0,3.526;-1.9258,0,4.6143;-1.9258,0.3,4.6143;-3.545,0.3,3.526/0;-1.9258,0,4.6143;-0.0153,0,5;-0.0153,0.3,5;-1.9258,0.3,4.6143/0;-0.0153,0,5;1.8993,0,4.6252;1.8993,0.3,4.6252;-0.0153,0.3,5
0;2.3637,0.3,4.406;3.1631,0.3,3.8724;3.1631,1,3.8724;2.3637,1,4.406/0;3.8699,0.3,3.166;4.4041,0.3,2.3671;4.4041,1,2.3671;3.8699,1,3.166/0;4.7864,0.3,1.4459;4.9746,0.3,0.5035;4.9746,1,0.5035;4.7864,1,1.4459/0;4.9754,0.3,-0.4958;4.7886,0.3,-1.4386;4.7886,1,-1.4386;4.9754,1,-0.4958/0;4.4078,0.3,-2.3604;3.8747,0.3,-3.1601;3.8747,1,-3.1601;4.4078,1,-2.3604/0;3.169,0.3,-3.8675;2.3705,0.3,-4.4024;2.3705,1,-4.4024;3.169,1,-3.8675/0;1.4496,0.3,-4.7852;0.5073,0.3,-4.9742;0.5073,1,-4.9742;1.4496,1,-4.7852/0;-0.492,0.3,-4.9757;-1.4349,0.3,-4.7897;-1.4349,1,-4.7897;-0.492,1,-4.9757/0;-2.3569,0.3,-4.4096;-3.1571,0.3,-3.8772;-3.1571,1,-3.8772;-2.3569,1,-4.4096/0;-3.8651,0.3,-3.172;-4.4006,0.3,-2.3739;-4.4006,1,-2.3739;-3.8651,1,-3.172/0;-4.7842,0.3,-1.4532;-4.9738,0.3,-0.5111;-4.9738,1,-0.5111;-4.7842,1,-1.4532/0;-4.9761,0.3,0.4882;-4.7908,0.3,1.4312;-4.7908,1,1.4312;-4.9761,1,0.4882/0;-4.4114,0.3,2.3536;-3.8796,0.3,3.1541;-3.8796,1,3.1541;-4.4114,1,2.3536/0;-3.1749,0.3,3.8626;-2.3772,0.3,4.3987;-2.3772,1,4.3987;-3.1749,1,3.8626/0;-1.4569,0.3,4.783;-0.5149,0.3,4.9734;-0.5149,1,4.9734;-1.4569,1,4.783/0;0.4844,0.3,4.9765;1.4275,0.3,4.7919;1.4275,1,4.7919;0.4844,1,4.9765
0;2.3637,1,4.406;3.1631,1,3.8724;2.7763,2.5,4.1584;2.7763,2.5,4.1584/0;3.8699,1,3.166;4.4041,1,2.3671;4.1563,2.5,2.7795;4.1563,2.5,2.7795/0;4.7864,1,1.4459;4.9746,1,0.5035;4.9032,2.5,0.9792;4.9032,2.5,0.9792/0;4.9754,1,-0.4958;4.7886,1,-1.4386;4.9047,2.5,-0.9717;4.9047,2.5,-0.9717/0;4.4078,1,-2.3604;3.8747,1,-3.1601;4.1605,2.5,-2.7731;4.1605,2.5,-2.7731/0;3.169,1,-3.8675;2.3705,1,-4.4024;2.7827,2.5,-4.1541;2.7827,2.5,-4.1541/0;1.4496,1,-4.7852;0.5073,1,-4.9742;0.983,2.5,-4.9024;0.983,2.5,-4.9024/0;-0.492,1,-4.9757;-1.4349,1,-4.7897;-0.9679,2.5,-4.9054;-0.9679,2.5,-4.9054/0;-2.3569,1,-4.4096;-3.1571,1,-3.8772;-2.7699,2.5,-4.1627;-2.7699,2.5,-4.1627/0;-3.8651,1,-3.172;-4.4006,1,-2.3739;-4.152,2.5,-2.7858;-4.152,2.5,-2.7858/0;-4.7842,1,-1.4532;-4.9738,1,-0.5111;-4.9017,2.5,-0.9867;-4.9017,2.5,-0.9867/0;-4.9761,1,0.4882;-4.7908,1,1.4312;-4.9062,2.5,0.9642;-4.9062,2.5,0.9642/0;-4.4114,1,2.3536;-3.8796,1,3.1541;-4.1648,2.5,2.7666;-4.1648,2.5,2.7666/0;-3.1749,1,3.8626;-2.3772,1,4.3987;-2.789,2.5,4.1499;-2.789,2.5,4.1499/0;-1.4569,1,4.783;-0.5149,1,4.9734;-0.9905,2.5,4.9009;-0.9905,2.5,4.9009/0;0.4844,1,4.9765;1.4275,1,4.7919;0.9604,2.5,4.9069;0.9604,2.5,4.9069]]

bin_colors = {
    [1] = split("2,2,2,2,2,2,2,2,4,4,4,4,4,4,4,4,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10"),
    [2] = split("2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,8,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14"),
}
-- turn into ints and string em
bin_patterns = split("32735.5,24415.5,24155.5,24155.5,23130.5,23130.5,23130.5,18970.5,18970.5,18970.5,2570.5,2570.5,2570.5,516.5,516.5,516.5,516.5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0")
for p in all(bin_patterns) do printh(p, "patterns.txt") end

---- GLOBALS ----
tf = 0
pulse_t = 0
last_music_timing = 0
on_beat = nil
recolor={1,1,13,1,13,1,13,7,0,12,12,12,12,12,12,12}

mmd = 0
mvd = 0

---- CLIPPING ----
clip_inside = 0
clip_left = 1
clip_right = 2
clip_bottom = 4
clip_top = 8
function clipcode(x,y)
    local code = 0
    if x < -1 then code |= clip_left
    elseif x > 1 then code |= clip_right end
    if y < -1 then code |= clip_top
    elseif y > 1 then code |= clip_bottom end
    return code
end
-- from: https://www.geeksforgeeks.org/line-clipping-set-1-cohen-sutherland-algorithm/
function clip_line(x1,y1,x2,y2)
    local code1, code2, accept = clipcode(x1,y1), clipcode(x2,y2), false
    while true do
        if code1 == code2 == 0 then -- Both endpoints inside
            accept = true
            break
        elseif code1 & code2 != 0 then -- Both endpoints outside
            break
        else -- Some segment inside rect
            local x,y,code_out = 1.0, 1.0, 0
            if code1 != 0 then code_out = code1 else code_out = code2 end
            -- Find intersection point
            if code_out & code_top then
                x = x1 + (x2 - x1) * (-1 - y1) / (y2 - y1)
                y = -1
            elseif code_out & code_bottom then
                x = x1 + (x2 - x1) * (1 - y1) / (y2 - y1)
                y = 1
            elseif code_out & code_left then
                y = y1 + (y2 - y1) * (-1 - x1) / (x2 - x1)
                x = -1
            elseif code_out & code_right then
                y = y1 + (y2 - y1) * (1 - x1) / (x2 - x1)
                x = 1
            end
            if code_out == code1 then 
                x1,y1,code1 = x,y,clipcode(x1,y1)
            else 
                x2,y2,code2 = x,y,clipcode(x2,y2)
            end
        end
    end
    if not accept then return nil end
    return {x1,y1,x2,y2}
end

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
    -- remove norms
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
            if c.time < 3 then c.color = 9 else c.color = 7 end
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
    order = {0,1,2,3}
    local jl = {
        from = from,
        to = target,
        points = {vec(), vec(), vec(), vec()},
        fired = false,
        t = 0,
        hit = false,
    }
    jl.update = function()
        jl.t += 0.1
        jl.points[1] = player.pos
        local a = player.pos
        local b = jl.to.world_center
        if true or jl.fired then
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
        if jl.t > 3 and not jl.hit then
            circle_make(jl.to.world_center, 12, 2)
            add(dying_polys,target)
            ent.hurt(to)
            jl.hit = true
        end
        if jl.t > 4 then
            del(jlasers, jl)
        end
    end
    add(jlasers, jl)
    return jl
end

sprites = {}
function sprite(pos, si, w, h)
    local s = {
        si = si,
        pos = {pos[1], pos[2], pos[3], 1},
        w = w,
        h = h
    }
    s.update = function() end

    return s
end

ents = {}
function ent()
    local e = {
        pos = {0,0,0,1},
        angles = {0,0,0},
        transform = m_identity(),
        parts = {},
        health = 1,
        dying = false,
        die_time = 0,
        die_offset = {0,0,0},
        visible = true,
        deadly = false,
        entgrid_pos = nil,
        name=nil,
    }
    e.compute_transform = function()
        e.transform = mm(m_translate(e.pos[1], e.pos[2], e.pos[3]), mm(mm(m_rot_x(e.angles[1]), m_rot_y(e.angles[2])), m_rot_z(e.angles[3])))
    end
    e.hurt = function(poly)
        e.health -= 1
        if e.health <= 0 then
            e.dying = true
        end
    end
    e.base_update = function()
        if e.dying then
            
            if e.die_time % 5 == 0 then
                local rpart = flr(rnd(#e.parts)) + 1
                local rpol = flr(rnd(e.parts[rpart])) + 1
                circle_make(v_add(e.parts[rpart].polys[rpol].world_center, vec(rnd(2)-1,rnd(2)-1,rnd(2)-1)), 7, 2)
            end
            if e.die_time > 50 then
                del(ents, e)
                need_entgrid_generation = true
            end            
            e.die_time += 1
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
egbounds = 100
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

function poly(points, target, backface, color_index)
    local avg = vec()
    local points2 = {}
    for p in all(points) do
        avg = v_add(avg, v_mul(p, 1 / #points))
        add(points2, {p[1], p[2], p[3], 1})
    end
    local d1 = v_norm(v_sub(points[2], points[1]))
    local d2 = v_norm(v_sub(points[3], points[2]))
    local p = {
        points = points,
        original_points = points2,
        center = avg,
        normal = v_cross(d1, d2),
        pattern = nil,
        target = target or false,
        selected = false,
        shadow = true,
        die_time = 0,
        show_back = backface or false,
        color_index = color_index or 1,
    }
    p.normoffset = v_add(p.center, p.normal)
    if target then p.fill = 0b0000000001000000 end
    return p
end

function check_target(target, cursor, p, e)
    if abs(target[1] - cursor[1]) < 5 and abs(target[2] - cursor[2]) < 5 then
        if p.target and not p.selected and player.selecting and #player.selected < 8 then
            local data = {ent=e, poly=p}
            add(player.selected, data)
            add(player.selected_chimes, data)
            p.selected = true
            player.last_select_time = 0
        end
    end
end

function final_point(t, p)
    local pta = mv(t, p)
    return vec(pta[1] / pta[4] * 64 + 64, pta[2] / pta[4] * 64 + 64, pta[3] / pta[4], pta[4])
end

function render_transform_pointlist(t, pts)
    local results = {}
    for p in all(pts) do
        local pta = mv(t, p)
        local ptb = {pta[1] / pta[4], pta[2] / pta[4], pta[3] / pta[4], 1}
        if ptb[3] < -1 or ptb[3] > 1 or ptb[1] < -1.75 or ptb[1] > 1.75 or ptb[2] < -1.75 or ptb[2] > 1.75 then
            return nil
        else
            add(results, {ptb[1] * 64 + 64, ptb[2] * 64 + 64, ptb[3], 1})
        end        
    end
    return results
end

function render_quad_wireframe(p, c)
    local p1x,p1y,p2x,p2y,p3x,p3y,p4x,p4y = p[1][1], p[1][2], p[2][1],p[2][2], p[3][1], p[3][2], p[4][1],p[4][2]
    if c then color(c) end
    line(p1x, p1y, p2x, p2y)
    line(p2x, p2y, p3x, p3y)
    line(p3x, p3y, p4x, p4y)
    line(p4x, p4y, p1x, p1y)
end

function render_quad_pattern(p, pattern, c)
    local p1x,p1y,p2x,p2y,p3x,p3y,p4x,p4y = p[1][1], p[1][2], p[2][1],p[2][2], p[3][1], p[3][2], p[4][1],p[4][2]
    fillp(pattern)
    if c then color(c) end
    trifill(p1x,p1y,p2x,p2y,p3x,p3y)
    trifill(p1x,p1y,p3x,p3y,p4x,p4y)    
end

function render_target(p, deadly, selected)
    local sn = 33
    if deadly then sn = 34 end
    if selected then sn = 35 end
    if -p[4] > 15 then
        sn += 3
    end
    spr(sn, p[1]-4, p[2]-4)
end
--[[
function render_debug(t,e)
    local pt = final_point(t, e.entgrid_pos or e.pos)
    if e.name then print(e.name) end
    if pt[3] < 1 and pt[3] > -1 then
        circfill(pt[1], pt[2], 2, 8)
    end
end
]]
function render_lasers(t)
    for jl in all(jlasers) do
        local pt1 = jl.points[1]
        local pt12d = final_point(t, pt1)
        for i = 1, min(flr(jl.t + 1),3) do
            
            local pt2 = jl.points[i+1]
            local pt22d = final_point(t, pt2)
            circfill(pt12d[1], pt12d[2], 2, 12)
            circfill(pt22d[1], pt22d[2], 2, 7)
            
            line(pt12d[1], pt12d[2], pt22d[1], pt22d[2], 12)
            pt1 = pt2
            pt12d = pt22d            
        end
    end
end

function render_zbinz_add_circles(zbins, t)
    for c in all(circles) do
        local pos2d = final_point(t, c.pos)
        local dist = -pos2d[4] -- work??
        local bin = 32 - clamp(flr(dist), 0, 31)
        add(zbins[bin], function() circfill(pos2d[1], pos2d[2], c.radius / (dist / 10), c.color) end)
    end
    return zbins
end

function render_zbinz_add_sprites(zbins, t)
    for s in all(sprites) do
        local pos2d = final_point(t, s.pos)
        local dist = -pos2d[4]
        if dist > 0 then
            local bin = 32 - clamp(flr(dist), 0, 31)
            local size = min(2 / (dist / 10),2)
            add(zbins[bin], function()
                local sx,sy = s.si % 16 * 8, s.si \ 16 * 8
                sspr(sx, sy, s.w * 8, s.h * 8, pos2d[1] - s.w * 4 * size, pos2d[2] - s.h * 4 * size, s.w * 8 * size, s.h * 8 * size)
            end)
        end
    end
    return zbins
end

function render_zbinz_add_polys(zbins, t, cursor)
    local num_polys = 0
    local polycap = 9999
    -- Initialize empty bins

    -- Add polygons to the correct bin based on distance
    for e in all(get_visible_ents(camera.pos)) do
        --render_debug(t, e)
        if e.visible then
            for part in all(e.parts) do
                local trans
                if e.static then
                    trans = t
                else
                    trans = mm(t, part.world_transform) -- slow
                end
                
                for p in all(part.polys) do
                    --if num_polys >= polycap then break end
                    local norm = p.world_normal
                    
                    local delta = v_sub(p.world_center, camera.pos)
                    
                    local dot = delta[1] * norm[1] + delta[2] * norm[2] + delta[3] * norm[3]
                    if p.show_back or e.deadly or dot < 0 and p.die_time < 20 then
                        local dist = v_mag(delta)
                        local bin = 32 - clamp(flr(dist), 0, 31)
                        local poly2d = render_transform_pointlist(trans,p.points)
                        
                        if poly2d then
                            add(zbins[bin], function() render_quad_wireframe(poly2d, bin_colors[p.color_index][bin]) end)
                            -- Extras - pattern quads get an extra render
                            if p.pattern then
                                add(zbins[bin], function() render_quad_pattern(poly2d, bin_patterns[bin] | p.pattern,bin_colors[p.color_index][bin]) end)
                            end
                            -- Target quads get a render too
                            if dist < 20 and p.target then
                                local target_pt = final_point(t, p.world_center)
                                if target_pt[3] > -1 and target_pt[3] < 1 then
                                    add(zbins[bin], function() render_target(target_pt, e.deadly, p.selected) end)
                                    -- For efficiency, best to check target selection here
                                    check_target(target_pt, cursor, p, e)
                                end
                            end
                            
                            
                            --num_polys += 1
                        end
                    end
                end
                --if num_polys >= polycap then break end
            end
            --if num_polys >= polycap then break end
        end
    end

    return zbins
end

function render(t, cursor2d)
    reset()
    local zbins = {}
    for i = 1, 32 do
        add(zbins, {})
    end    
    -- Add items to zbins
    render_zbinz_add_polys(zbins, t, cursor2d)
    render_zbinz_add_circles(zbins, t)
    render_zbinz_add_sprites(zbins, t)
    for bin, bin_contents in pairs(zbins) do
        for renderer in all(bin_contents) do
            color(bin_colors[1][bin+1])
            fillp(bin_patterns[bin+1])
            renderer()
        end
    end
    fillp()
    render_lasers(t)
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

function make_crown_boss(pos)
    local e = deserialize_entity(enemy_crown)
    e.health = 50
    e.pos = pos
    local z = pos[3]     
    for poly in all(e.parts[1].polys) do poly.show_back = true; poly.color_index = 2 end
    for poly in all(e.parts[2].polys) do poly.color_index = 2 end
    for poly in all(e.parts[3].polys) do poly.show_back = true; poly.color_index = 2 end
    e.respawn_time = 0
    e.time = 150
    e.eye = nil
    e.hurt_time = 50
    e.target_pos = {e.pos[1], e.pos[2], e.pos[3], 1}
    e.update = function() 
        local zdiff = abs(camera.pos[3] - z)
        if zdiff < 15 then
            if not boss then
                e.eye = sprite({0,1,0,1}, 39, 2, 1)
                add(sprites, e.eye)            
                boss = true
                for poly in all(e.parts[2].polys) do
                    poly.target = true
                end
            end
            e.time += 1
            local et500 = e.time % 500
            if et500 == 0 then
                e.target_pos = {rnd(10) - 5, rnd(5) - 2, z + 5}
            elseif et500 == 300 then
                e.target_pos = {rnd(36) - 18, rnd(15), z - 5}
            end
            if et500 == 360 or (e.health <= 32 and et500 == 420) or (e.health <= 16 and et500 == 450) then
                make_missile({e.pos[1],e.pos[2],e.pos[3],1}, {rnd(2) - 1,rnd(2) - 1,rnd(2)-1,1})
            end
            e.pos = v_add(v_mul(e.pos, 0.95), v_mul(e.target_pos, 0.05))
            e.eye.pos = e.pos
            if e.time > 180 then
                if e.health > 34 then
                    e.eye.si = 55
                elseif e.health > 17 then
                    e.eye.si = 41
                else
                    e.eye.si = 57
                end
            end
        end
        
        if e.hurt_time > 0 then
            e.hurt_time -= 1
        end
        e.angles[3] = sin(tf / 40 - 1 - (10 - e.hurt_time / 5)) * (0.25 + e.hurt_time / 100)
        e.angles[1] = cos(tf / 45 - 1 - (10 - e.hurt_time \ 5)) * (0.25 + e.hurt_time / 100)
        e.angles[2] = tf / 210 - (5 - e.hurt_time / 10)
        e.dirty = true
        if e.health == 17 or e.health == 34 then
            if e.respawn_time == 0 then
                e.hurt_time = 50            
            end
            e.respawn_time += 1
            if e.respawn_time > 30 then
                e.health -= 1
                e.respawn_time = 0
                for poly in all(e.parts[2].polys) do
                    poly.points = poly.original_points
                    poly.original_points = {}
                    for point in all(poly.points) do
                        add(poly.original_points, {point[1], point[2], point[3], 1})
                    end
                    poly.dying = false
                    poly.die_time = 0
                    poly.target = true
                end
            end
        end
        e.compute_transform()
        update_internal_transforms(e)
    end
    e.compute_transform()
    update_internal_transforms(e)
    add(ents, e)
end

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

function make_missile(pos, vel)
    local e = ent()
    e = deserialize_entity(enemy_missile)  
    e.deadly = true
    e.pos = vec(pos[1],pos[2],pos[3])
    e.vel = {vel[1],vel[2],vel[3]}
    e.speed = 0.5
    e.time = 0
    e.visible = true
    e.name="missile"
    
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
    --printh(serialize_entity(e), "entity.txt")
    need_entgrid_generation = true
    return e
end

function make_artillery(pos)
    local e = deserialize_entity(enemy_artillery)

    for poly in all(e.parts[3].polys) do
        poly.pattern = 0b0110011001100110.1
    end
    for poly in all(e.parts[1].polys) do
        poly.pattern = 0b0110011001100110.1
    end        

    local pi2 = 3.14159 / 2
    e.time = 0
    e.next_angle = pi2 + pi2/2
    e.current_angle = pi2/2
    e.i = 0
    
    e.update = function()
        if e.dying then
            for part in all(e.parts) do
                for poly in all(part.polys) do
                    for pt in all(poly.points) do
                        pt[2] = pt[2] * 0.98
                    end
                end
            end
        end
        local zdiff = e.pos[3] - player.pos[3]
        e.i += 1        
        if e.i == 60 then
            e.current_angle += pi2
            e.next_angle = e.current_angle + pi2
            e.i = 0
        end
        e.parts[3].transform = m_rot_y(sin(e.i / 60 * pi2)^6 * pi2 + e.current_angle)
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
    e.parts[2].polys[1].pattern = 0b0101101001011010
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
            local dist = abs(delta.z)
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
function init_level()
    --make_artillery({8, -2, 0})
    --make_artillery({-8, -2, -24})


    --[[
    for i = 0,3 do 
        make_minion({5,-2,30 - i * 0.5,1}, {-5 + i * 3.33,1,0}, {0,0.25,0}, i == 0)
    end
    for i = 0,3 do 
        make_minion({-5,2,23 - i * 0.5,1}, {5 - i * 3.33,-1,0}, {0,0.25,0}, i == 0)
    end    
    for i = 0,5 do
        local theta = i / 6 * 6.2818
        make_minion({0,-4,15 - i * 0.5,1}, {cos(theta) * 3,sin(theta) * 3,0}, {0,0.25,0}, i == 0)
    end
    ]]--
    make_artillery({6, -3, 0,1})
    --make_artillery({-6, -3, -6,1})
    --make_lock({0, 1, 0,1})
    --make_crown_boss({0,1,0,1})

    for i = 0, 100 do
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
            --pol.pattern = 0b1100111100111111.1
            pol.pattern = 0b0011000011000000.1
            add(polys, pol)    
        end
        e.parts = {part(polys, m_identity())}
        
        e.static = true
        e.entgrid_pos = {0,-3,i * 2,1}
        add(ents, e)
        update_internal_transforms(e)
    end
    
    generate_entgrid()
end
function start_game()
    intro = false
    ents = {}
    circles = {}
    lasers = {}
    sprites = {}
    transitioning = true
    transition_index = 1

    music(0,0,1)
end

function _init()
    camera = {
        pos=vec(0,0,10),
        fwd=vec(0,0,1),
        angles=vec(0.1,0,0),
        angle_velocities = vec(),
        view_mat = nil,
        near = -0.5,
        far = -32,
    }

    player = {
        pos = v_add(camera.pos, vec(0,-1,-5.5)),
        cursor_angles = vec(),
        selecting = false,
        selected = {},
        selected_chimes = {},
        last_select_time = 0,
        stage = 2,
        health = 0,
        hit_time = 100,        
    }

    e = ent()
    polys = {}
    count = 10
    function azv(theta, rad, y)
        return {cos(theta) * rad, y, sin(theta) * rad, 1}
    end
    local dims = {{-5, 3}, {-4, 2}, {-3, 1.5}, {2.5, 1.5}, {4, 2}, {4.5, 1.5}, {7,2}}
    local patterns = {0b0, 0b0000111100001111.1, 0b0111101111011110.1, 0b0000111100001111.1, 0b0, 0b0}
    local colors = {1,1,1,1,1,1}
    --local patterns = {0b0, 0b0000111100001111.1, 0b1101110111011101.1, 0b0000111100001111.1, 0b0, 0b0}
    polys = {}
    for i = 1, #dims-1 do
        for j = 1, count do
            local t1 = j / count * 6.2818
            local t2 = (j + 1) / count * 6.2818
            local p = poly({
                azv(t1, dims[i+1][2], dims[i+1][1]),
                azv(t2, dims[i+1][2], dims[i+1][1]),
                azv(t2, dims[i][2], dims[i][1]),
                azv(t1, dims[i][2], dims[i][1]),
            })
            p.pattern = patterns[i]
            p.color_index = colors[i]
            add(polys, p)
        end
    end
    count = 24
    for j = 1, count do
        local t1 = (j + 0.5) / count * 6.2818
        local p = poly({
            azv(t1 - 0.1, 12, -5),
            azv(t1 + 0.1, 12, -5),
            azv(t1 + 0.1, 9, -1),
            azv(t1 - 0.1, 9, -1),
        })
        p.pattern = 0b0101010101010101.1
        add(polys, p)

        add(polys, poly({
            azv(t1 - 0.08, 13, 0),
            azv(t1 + 0.08, 13, 0),
            azv(t1 + 0.04, 13, 0.8),
            azv(t1 - 0.04, 13, 0.8),
        }, nil, nil, j % 2 + 1))
        add(polys, poly({
            azv(t1 - 0.03, 13, -1.6),
            azv(t1 + 0.03, 13, -1.6),
            azv(t1 + 0.06, 13, 0),
            azv(t1 - 0.06, 13, 0),
        }, nil, nil, j % 2 + 1))        
        add(sprites, sprite(azv(t1, 13, 0.2),43, 1,1))
    end    
    e.parts = {part(polys)}
    e.static = true
    e.entgrid_pos = {0,0,0,1}
    add(ents, e)
    update_internal_transforms(e)
    generate_entgrid()
    
end

function take_damage(source)
    player.hit_time = 0
    player.stage -= 1
end

function update_player()
    camera.pos = v_sub(camera.pos, vec(0,0,speed))
    if player.hit_time < 20 and player.hit_time % 5 == 0 then
        for i = 0, 2 do
            circle_make({camera.pos[1] + rnd(2) - 1,camera.pos[2] + rnd(2) - 1,camera.pos[3] - 3,1}, 7, 2)
            --0.5 = -1, 1 = 0.017, 2 = 0.525, 4 = 0.77, 8 = 0.9, 15 = 0.966, 30 = 1.0
            
            --circle_make({camera.pos[1],camera.pos[2],camera.pos[3] - 3,1}, 7, 2)
        end
    end
    player.hit_time += 1

    if not intro then
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
        player.cursor_angles[1] = clamp(player.cursor_angles[1], -1, 1)
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
    end

    if intro then
        local side = {camera.fwd[3] / 2, camera.fwd[2], -camera.fwd[1] / 2, 1}
        player.pos = v_add(
            v_mul(player.pos, 0.9),
            v_mul(v_add(camera.pos, v_add(side,v_add(v_mul(camera.fwd, 2), vec(0,-0.5 + sin(tf / 13) * 0.05 + 0.25,0)))), 0.1)
        )
    else
        player.pos = v_add(
            v_mul(player.pos, 0.9),
            v_mul(v_add(camera.pos, v_add(v_mul(camera.fwd, 2), vec(0,-0.5 + sin(tf / 13) * 0.05,0))), 0.1)
        )
    end
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

intro = true
transitioning = false
transition_time = 0
transition_index = 0
speed = 0.02
need_entgrid_generation = true
fov = 90
boss = false
function _update60()
    if transitioning then
        if transition_index == 1 and transition_time == 30 then
            camera.pos = {0,0,50,1}
            init_level()
        end
        speed = 0.1
        fov = max(fov - 0.25, 60)
        transition_time += 1
        if transition_time > 60 then
            transitioning = false
            transition_time = 0
        end
    else
        speed = 0.02
        fov = min(fov + 2, 90)
    end
    if boss or intro then
        speed = 0
    end

    if intro then
        local theta = tf / 320
        camera.pos = vec(sin(theta) * 10, 0, cos(theta) * 10)
        camera.angles[2] = -theta + sin(tf / 170) * 0.04
        camera.angles[1] = sin(tf / 133) * 0.07
    end
    
    pulse_t += 1
    debugs = {}
    if need_entgrid_generation then
        generate_entgrid()
        need_entgrid_generation = false
    end
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
        else 
            del(dying_polys, p)
        end
    end

    camera.fwd = mv(mm(m_rot_y(-camera.angles[2]), m_rot_x(-camera.angles[1])), vec(0,0,-1))
    camera.view_mat = m_look(camera.fwd, vec(0,1,0))
    
    
    for e in all(get_visible_ents(camera.pos)) do
        if e.base_update then e.base_update() end
        if e.update then e.update() end
    end
    for c in all(circles) do c.update() end
    for jl in all(jlasers) do jl.update() end

    update_player()
    
    if intro and btnp(5) then
        start_game()
    end

    tf += 1
    last_music_timing = current_music_timing
end

function draw_bg_intro(t)
    local sy = final_point(t, v_add(camera.pos, vec(0,0,-50)))[2]
    fillp(0b0101111110101111)
    rectfill(0, sy + 30, 128, sy + 40, 0x01)
    fillp(0b1010010110100101)
    rectfill(0, sy + 40, 128, sy + 50, 0x01)
    fillp(0b1010000001010000)
    rectfill(0, sy + 50, 128, 128, 0x01)

    fillp(0b0101111110101111)
    rectfill(0, sy - 40, 128, sy - 50, 0x01)
    fillp(0b1010010110100101)
    rectfill(0, sy - 50, 128, sy - 60, 0x01)
    fillp(0b1010000001010000)
    rectfill(0, sy - 60, 128, 0, 0x01)

end

function draw_bg_early(t)
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

        rectfill(x - 12, y + ((z) % 3) * 5 + 8, x + 12, y + 60 + 15, c1)
        for i = -2, 2 do
            rectfill(x + 4 * i - 2, y + ((z) % 3) * 5 + 5, x + 4 * i, y + 60, c1)
        end
        rectfill(x - 16, y + ((z) % 3) * 5 + 14, x + 16, y + 60 + 15, c1)
        rectfill(x - 1, y + ((z) % 3) * 5 + 10, x + 1, y + ((z) % 3) * 5 + 15, 0)
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
    if pos[3] > -1 and pos[3] < 1 then
        local w = 32--min(8 / pos[3],32)
        local h = w
        local offset = 0
        local flip = false
        if abs(cx - 64) > 8 then offset = 32 end
        if abs(cx - 64) > 24 then offset = 64 end
        if cx < 64 then flip = true end
        if intro then offset = 32; flip = false end
        sspr(0 + offset,32,32,32, pos[1] - w / 2, pos[2] - h / 2, w, h, flip, false)
    end
end

function draw_cursor(target2d)
    if target2d[3] > -1 and target2d[3] < 1 then
        fillp()
        spr(1 + (player.selecting and 2 or 0), target2d[1] - 8, target2d[2] - 8, 2, 2)
        if #player.selected > 0 and player.last_select_time < 12 then
            spr(4 + #player.selected, target2d[1] - 4, target2d[2] - 12)
        end
    end
end

function draw_intro_ui()
    spr(128, 84, 27, 5, 2)
    print("❎ to start", 82, 42, 7)
end

function draw_game_ui()

end

function _draw()
    if not transitioning then
        cls()
    end
    local w = -2 * camera.near * (1.62 * (fov / 90))
    perspective_transform = m_perspective(camera.near, camera.far, w, w)
    local t = mm(mm(perspective_transform, camera.view_mat), m_translate(-camera.pos[1], -camera.pos[2], -camera.pos[3]))
    local cursorm = mm(m_rot_y(-player.cursor_angles[2]), m_rot_x(-player.cursor_angles[1]))
    local target2d = final_point(t, v_add(camera.pos, mv(cursorm, vec(0,0,-5))))

    if intro then
        draw_bg_intro(t)
    else
        if not transitioning then
            draw_bg_early(t)
        end
    end
    render(t, target2d)
    if not intro then draw_cursor(target2d) end
    draw_player(t, target2d[1])

    pal()
    if player.hit_time < 20 then
        pal({2,2,2,2,2,8,7,8,8,8,8,8,8,8,8}, 1)
    end

    if intro then
        draw_intro_ui()
    else
        draw_game_ui()
    end

    color(7)
    cursor()
    for d in all(debugs) do
        print(d)
    end
    --print(stat(20))
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
00000000000000000000000000000000000000000000000000000000000000000000000000001111111100000000000000000000000000000000000000000000
0000000000999900008888000077770000000000000000000000000000000000000000000111eeee2eee11100000000000000000000000000000000000000000
000000000997799008877880077cc77000000000000000000000000000111111111111001eeeeee882eeeee10000000000000000000000000000000000000000
00000000097997900878878007c77c700009900000088000000cc000116666e7ee866611eeeeee87882eeeee0cc00cc000000000000000000000000000000000
00000000097997900878878007c77c700009900000088000000cc000666611eeee81166622222288882222220cc00cc000000000000000000000000000000000
000000000997799008877880077cc7700000000000000000000000001166668eee866611eeeeee28882eeeee0000000000000000000000000000000000000000
0000000000999900008888000077770000000000000000000000000000011111111111000eeeeee222eeeee00000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000eeee2eee00000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000011111111000000001111111100000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000011177776777111001118888e88811100000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000001777777ee877777118888880008888810000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000777777e7ee87777788888807000888880000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000666666eeee866666eeeeee00000eeeee0000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000007777778eee87777788888800000888880000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000077777788877777008888880008888800000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000077776777000000008888e88800000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000777770000000000000000000000000007777700000000000000000000000000077777000000000000000000000000000000000000000000000
00000000000077007007700000000000000000000000770070077000000000000000000000007700700770000000000000000000000000000000000000000000
00000000000700007000070000000000000000000007000070000700000000000000000000070007000007000000000000000000000000000000000000000000
00000000007000007000007000000000000000000070000070000070000000000000000000700007000000700000000000000000000000000000000000000000
00000000070000007000000700000000000000000700000700000007000000000000000007000007000000070000000000000000000000000000000000000000
00000000070000007000000700000000000000000700000700000007000000000000000007000070000000070000000000000000000000000000000000000000
00000000700000007000000070000000000000007000000700000000000000000000000070000070000000007000000000000000000000000000000000000000
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777777777777777777777777777777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000000000000000000000000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70700000777777000007777707777707777770700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70700000700007000007000707000000000070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70700000700007000007000707000000000700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70700000700007000007000707777000007000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70700000700007077707777007000000070000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70700000700007000007070007000000700000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70700000700007000007007007000007000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70777770777777000007000707777707777770700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000000000000000000000000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777777777777777777777777777777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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

