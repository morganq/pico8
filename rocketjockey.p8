pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
-- pocketjockey
-- by morganquirk

#include engine1.lua

-- impl 2d
-- up-down = fast/slow, maybe slow = rise, fast = fall too
-- circle-circle for posts
-- circle-ellipse collision
-- springy rope... 
-- whole level geometry = 1 model
-- see how much budget

local model_rocket = [[-0.25,-0.50,0.50/-0.25,0.50,0.50/-0.25,0.50,-0.50/-0.25,-0.50,-0.50/-1.50,0.00,0.00/-0.25,0.50,0.50/0.75,0.50,0.50/0.75,-0.50,0.50/-0.25,-0.50,0.50/-0.25,0.50,-0.50/0.75,0.50,-0.50/0.75,-0.50,-0.50/-0.25,-0.50,-0.50
1,2,5/2,3,5/3,4,5/4,1,5/9,8,7/9,7,6/12,13,10/12,10,11/6,7,11/6,11,10/8,12,11/8,11,7/13,12,8/13,8,9]]

local model_rocket2 = [[1.25,0.75,0.25/1.25,0.75,-0.25/1.25,0.00,-0.75/1.25,-0.75,-0.50/1.25,-0.75,0.50/1.25,0.00,0.75/-1.00,0.75,0.25/-1.00,0.75,-0.25/-1.00,0.00,-0.75/-1.00,-0.75,-0.50/-1.00,-0.75,0.50/-1.00,0.00,0.75/-2.25,0.25,0.00/-2.25,0.25,0.00/-2.25,0.00,0.25/-2.25,-0.25,0.25/-2.25,-0.25,-0.25/-2.25,0.00,-0.25/-1.00,-0.25,1.50/-0.25,-0.25,1.00/-1.00,-0.25,0.75/-0.25,-0.25,0.75/1.00,1.25,0.00/2.25,1.25,0.00/0.50,0.75,0.00/1.50,0.50,0.00/-1.00,-0.25,-0.75/-0.25,-0.25,-0.75/-1.00,-0.25,-1.50/-0.25,-0.25,-1.00
6,5,4/6,4,3/6,3,2/6,2,1/3,9,8/3,8,2/4,10,9/4,9,3/5,11,10/5,10,4/11,5,6/11,6,12/1,7,12/1,12,6/2,8,7/2,7,1/14,7,8/14,8,13/15,12,7/15,7,14/16,11,12/16,12,15/17,10,11/17,11,16/18,9,10/18,10,17/13,8,9/13,9,18/18,17,16/18,16,15/18,15,14/18,14,13/19,20,22/19,22,21/23,24,26/23,26,25/26,24,23/25,26,23/27,28,30/27,30,29]]

local stadium_radius = 25
local post_radius = 0.5

local num_players = 2
local cameras = {}
local sprites = {}
local models = {}
local rockets = {}
local ents = {}
local ropes = {}
local posts = {{10,0,0,1},{-10,0,0,1},{0,0,10,1},{0,0,-10,1}}

function cross2d(x1,y1,x2,y2)
    return x1 * y2 - y1 * x2
end

--[[
    line_vec = vector(start, end)
    pnt_vec = vector(start, pnt)
    line_len = length(line_vec)
    line_unitvec = unit(line_vec)
    pnt_vec_scaled = scale(pnt_vec, 1.0/line_len)
    t = dot(line_unitvec, pnt_vec_scaled)    
    if t < 0.0:
        t = 0.0
    elif t > 1.0:
        t = 1.0
    nearest = scale(line_vec, t)
    dist = distance(nearest, pnt_vec)
    nearest = add(nearest, start)
    return (dist, nearest)    
]]

function line_pt_dist(l1, l2, pt)
    local ld = v_sub(l1, l2)
    local dd = v_sub(l1, pt)
    local ll = v_mag(ld)
    local ln = v_norm(ld)
    local ptscaled = v_mul(dd, 1 / ll)
    local t = clamp(v_dot(ln, ptscaled),0,1)
    local nearest = v_mul(ld, t)
    return v_mag(v_sub(nearest, dd))
end

function make_ent(model, pos, mass, radius)
    model.vel = {0,0,0,1}
    model.pos = pos
    model.mass = mass
    model.collision_radius = radius
    model.update = function() end
    model.is_model = true
    return model
end

function make_stadium()
    step = 32
    local points = {}
    local triangles = {}
    for i = 0, step-1 do
        local ct = i / step * 6.2818
        local cs = sin(ct) * stadium_radius
        local cc = cos(ct) * stadium_radius 
        add(points, {cs, 0, cc, 1})
        add(points, {cs, 3, cc, 1})
        local ni = (i + 1) % step
        add(triangles, {i * 2 + 1, i * 2 + 2, ni * 2 + 2})
        add(triangles, {i * 2 + 1, ni * 2 + 2, ni * 2 + 1})
    end
    
    for j = 1, #posts do
        local pstep = 4
        local pos = posts[i]
        local ti = step * 2 + (j-1) * 8
        for i = 0, pstep-1 do
            local ct = i / pstep * 6.2818
            local cs = sin(ct) * post_radius
            local cc = cos(ct) * post_radius 
            add(points, {cs + posts[j][1], 6, cc + posts[j][3], 1})
            add(points, {cs + posts[j][1], 0, cc + posts[j][3], 1})
            
            local ni = (i + 1) % pstep
            add(triangles, {i * 2 + 1 + ti, i * 2 + 2 + ti, ni * 2 + 2 + ti})
            add(triangles, {i * 2 + 1 + ti, ni * 2 + 2 + ti, ni * 2 + 1 + ti})
        end
    end
    
    local m = model(points, triangles)
    for i = 1, #triangles - 31 do
        m.triangles[i].color_num = 3
    end
    for i = #triangles - 31, #triangles do
        m.triangles[i].color_num = 0
    end    
    return m
end

function launch_rope(source, dir, which)
    local rope = model({{0,0,0,1},{0,0,0,1},{0,0,0,1},{0,0,0,1}},{{1,2,3},{1,3,4},{3,2,1},{4,3,1}})
    for i = 1, #rope.triangles do rope.triangles[i].color_num=5 end
    add(models, rope)
    add(ropes, rope)
    rope.source = source
    rope.pos1 = source.pos
    rope.pos2 = source.pos
    rope.dir = dir
    rope.state = "flying"
    rope.time = 0
    rope.update_points = function()
        rope.points[1] = v_add(rope.pos1, {0,0.1,0,1})
        rope.points[2] = v_add(rope.pos1, {0,-0.1,0,1})
        rope.points[3] = v_add(rope.pos2, {0,-0.1,0,1})
        rope.points[4] = v_add(rope.pos2, {0,0.1,0,1})    
        update_tri(rope, 1)
        update_tri(rope, 2)
        update_tri(rope, 3)
        update_tri(rope, 4)
    end
    rope.update = function()
        if rope.state == "flying" then
            rope.pos1 = source.pos
            rope.pos2 = v_add(rope.pos2, rope.dir)
            rope.update_points()
            rope.time += 1
            if rope.time > 30 or rope.pos2[2] < 0 then
                del(models, rope)
                del(ropes, rope)
                rope.source["rope_"..which] = nil
            end
        elseif rope.state == "rocket/post" then
            rope.pos1 = source.pos
            rope.update_points()
            try_collide_circle(rope.source, rope.pos2, rope.len + rope.source.collision_radius, true, 1, true)
            rope.len = max(rope.len - 0.02, 2)
        elseif rope.state == "rocket/rocket" then
            rope.pos1 = rope.source.pos
            rope.pos2 = rope.other.pos
            rope.update_points()
            try_collide_circle(rope.source, rope.pos2, rope.len + rope.source.collision_radius, true, 0.025, true, true)
            try_collide_circle(rope.other, rope.pos1, rope.len + rope.source.collision_radius, true, 0.025, true, true)
            rope.len = max(rope.len - 0.02, 2)
        elseif rope.state == "rocket/guy" then
            rope.pos1 = rope.source.pos
            rope.pos2 = rope.other.pos
            rope.update_points()
            try_collide_circle(rope.other, rope.pos1, rope.len + rope.source.collision_radius, true, 1, true)
            rope.len = max(rope.len - 0.02, 2)
        end
    end
    rope.hit = function(what, obj, pos)
        if what == "post" then
            rope.state = "rocket/post"
            rope.pos2 = pos
            rope.len = v_mag(v_sub(rope.pos2, rope.pos1))
        elseif what == "ent" then
            if obj.name == "rocket" and rope.source != obj then
                if rope.pos2[2] > obj.pos[2] then
                    rope.state = "rocket/guy"
                    local guy = obj.eject_guy()
                    rope.other = guy
                else
                    rope.state = "rocket/rocket"
                    rope.other = obj
                end
                rope.len = v_mag(v_sub(obj.pos, rope.source.pos))
            end
        end
    end
    return rope
end

function _init()
    cameras = {
        {
            pos={0,1,-13,1},
            angles={0,0,0},
            fwd={0,0,-1,1},
        },
        {
            pos={0,1,-5,1},
            angles={0,0,0},
            fwd={0,0,1,1},
        }
    }
    add(models, make_stadium())
    for i = 1,num_players do
        local r = make_ent(deserialize_model(model_rocket2, 0.65), {i * 10 - 5, 1, -8, 1}, 10, 0.75)
        r.fwd = {-1,0,0,1}
        r.up = {0,1,0,1}
        r.roll = 0
        r.angle = 0
        r.speed = 0.3
        r.rope_right = nil
        r.rope_left = nil
        r.pitch = 0
        r.guy = make_ent(sprite(1,{0,0,0,1}, 2, 2, true), {0,0,0,1}, 1, 0.3)
        r.guy.is_model = false
        r.guy.angle = 0
        r.name = "rocket"
        r.player = i
        r.ejected = false
        for j = 1, #r.triangles do
            r.triangles[j].color_num = 2
        end
        for j = 33, 40 do
            r.triangles[j].color_num = 0
        end
        
        add(sprites, r.guy)
        add(ents, r)
        add(models, r)
        add(rockets, r)
        r.update = function()
            r.fwd = {sin(r.angle), 0, cos(r.angle), 1}
            local target_vel =  v_mul(r.fwd, r.speed)
            r.speed = r.speed + (0.3 - r.speed) * 0.9
            if r.ejected then target_vel = {0,0,0,1} end
            r.vel = v_add(v_mul(r.vel, 0.9), v_mul(target_vel, 0.1))
            r.pos[2] = r.pos[2] * 0.95 + 1.5 * 0.05
            r.roll = r.roll * 0.94
            r.pitch = r.pitch * 0.94
            r.rotation = m_rot_xyz(r.roll, r.angle + 3.14/2, r.pitch) --m_look({-r.fwd[3], r.fwd[2], -r.fwd[1],1}, r.up)
            if r.ejected then
                if r.guy.pos[2] < 0.4 then
                    r.guy.pos[2] = 0.4
                end
                r.guy.vel = v_mul(r.guy.vel, 0.6)
                r.guy.vel = v_add(r.guy.vel, {0,-0.1,0,1})
                r.vel = v_mul(r.vel, 0.9)
            else
                r.guy.pos = v_add(r.pos, {0,1,0,1})
                r.guy.fwd = v_norm({r.fwd[1], 0, r.fwd[3], 1})
            end
        end
        
        r.eject_guy = function()
            local g = r.guy
            g.ejected = true
            r.ejected = true
            add(ents, g)
            return g
        end
    end
end

function update_player(i)
    if rockets[i].ejected then
        if btn(0, i-1) then
            rockets[i].guy.fwd = v_norm(mv4(m_rot_y(0.05), rockets[i].guy.fwd))
        end
        if btn(1, i-1) then
            rockets[i].guy.fwd = v_norm(mv4(m_rot_y(-0.05), rockets[i].guy.fwd))
        end    
        if btn(2, i-1) then
            rockets[i].guy.vel = v_add(v_mul(rockets[i].guy.fwd, 0.1), rockets[i].guy.vel)
            rockets[i].guy.si = 7
            if tf % 8 < 4 then rockets[i].guy.si = 33 end
        elseif btn(3, i-1) then
            rockets[i].guy.vel = v_add(v_mul(rockets[i].guy.fwd, -0.1), rockets[i].guy.vel)
            rockets[i].guy.si = 7
            if tf % 8 < 4 then rockets[i].guy.si = 33 end
        else 
            rockets[i].guy.si = 1
        end       
    else 
        if btn(0, i-1) then
            rockets[i].angle += 0.03
            rockets[i].roll += 0.02
        end
        if btn(1, i-1) then
            rockets[i].angle -= 0.03
            rockets[i].roll -= 0.02
        end    
        if btn(2, i-1) then
            rockets[i].speed += 0.15
            rockets[i].pos = v_add(rockets[i].pos, {0,-0.06,0,1})
            rockets[i].pitch += 0.02
        end
        if btn(3, i-1) then
            rockets[i].speed -= 0.15
            rockets[i].pos = v_add(rockets[i].pos, {0,0.06,0,1})
            rockets[i].pitch -= 0.02
        end
    end
    --local side = mv4(rockets[i].rotation, {0,0,-1,1})--
    local side = v_cross(rockets[i].fwd, rockets[i].up)
    if btnp(4, i-1) then
        if rockets[i].rope_right then
            del(ropes, rockets[i].rope_right)
            del(models, rockets[i].rope_right)
            rockets[i].rope_right = nil
        else
            rockets[i].rope_right = launch_rope(rockets[i], v_mul(side,-1), "right")
        end
    end
    if btnp(5, i-1) then
        if rockets[i].rope_left then
            del(ropes, rockets[i].rope_left)
            del(models, rockets[i].rope_left)
            rockets[i].rope_left = nil
        else    
            rockets[i].rope_left = launch_rope(rockets[i], side, "left")
        end
    end    
end

function _draw()
    cls()
    for i = 1, num_players do
        local y = (i-1) * 128 / num_players
        local h = 128 / num_players
        camera(0, -y)
        clip(0, y, 128, y + h)
        print(#sprites)
        render(models, sprites, cameras[i], 128, h)
    end
    camera()
    clip()
    color(7)
    for d in all(debugs) do
        print(d)
    end
end

function try_collide_circle(e, pos, rad, inside, vmul, y0, vadd)
    local vmul = vmul or 1
    local intended_next_pos = v_add(e.pos, e.vel)
    local deltax = intended_next_pos[1] - pos[1]
    local deltay = intended_next_pos[2] - pos[2]
    local deltaz = intended_next_pos[3] - pos[3]
    if y0 then deltay = 0 end
    local xzdsq = deltax * deltax + deltay * deltay + deltaz * deltaz
    local subrad = 0
    local collision = false
    if inside then
        subrad = rad - e.collision_radius
        if xzdsq > subrad * subrad then
            collision = true
        end
    else
        subrad = rad + e.collision_radius
        if xzdsq < subrad * subrad then
            collision = true
        end
    end
    if collision then
        local xzd = sqrt(xzdsq)
        local x = deltax / xzd * subrad
        local y = deltay / xzd * subrad
        local z = deltaz / xzd * subrad
        local adj_pos = {pos[1] + x, pos[2] + y, pos[3] + z,1}
        if vadd then
            e.vel = v_add(e.vel, v_mul(v_sub(adj_pos, e.pos), vmul))
        else
            e.vel = v_mul(v_sub(adj_pos, e.pos), vmul)
        end
        if y0 then e.vel[2] = 0 end
        local rot = v_cross(e.fwd, e.vel)
        e.angle += rot[2] * vmul
    end
end

function try_collide_ents(a, b)

end

tf = 0
function _update()
    debugs = {}
    for i = 1, #ents do
        try_collide_circle(ents[i], {0,0,0,1}, stadium_radius, true, 0.9, true)
        
        for j = 1, #posts do
            try_collide_circle(ents[i], posts[j], post_radius, false, 0.9, true)
        end
        
        for j = i+1, #ents do
            try_collide_ents(ents[i], ents[j])
        end
    end
    for rope in all(ropes) do
        rope.update()
        if rope.state == "flying" then
            for i = 1, #posts do
                local d = line_pt_dist(
                    {rope.pos1[1], 0, rope.pos1[3], 1},
                    {rope.pos2[1], 0, rope.pos2[3], 1},
                    {posts[i][1], 0, posts[i][3], 1}
                )
                if d < post_radius then
                    rope.hit("post", nil, {posts[i][1], rope.pos2[2], posts[i][3],1})
                end
            end
            for i = 1, #ents do
                local d = line_pt_dist(
                    rope.pos1,
                    rope.pos2,
                    ents[i].pos
                )
                -- Add to the radius so it's easy to grab things
                if d < ents[i].collision_radius * 2 then
                    rope.hit("ent", ents[i], ents[i].pos)
                end
            end
        end
    end
    for i = 1, #ents do
        ents[i].update()
        ents[i].pos = v_add(ents[i].pos, ents[i].vel)
        if ents[i].is_model then
            ents[i].update_points() 
        end
    end    
    for i = 1, num_players do
        update_player(i)
        cameras[i].pos = v_add(
            v_mul(v_add(rockets[i].guy.pos, v_add(v_mul(rockets[i].guy.fwd, -4), {0,2,0})), 0.1),
            v_mul(cameras[i].pos, 0.9)
        )
        cameras[i].fwd = v_norm(v_sub(v_add(rockets[i].guy.pos, v_mul(rockets[i].guy.fwd, 4)), cameras[i].pos))
    end
    tf += 1
end
__gfx__
00000000000000444400000000000444440000000000004444000000000000444400000000000444440000000000004444000000000000000000000000000000
00000000000044aaaa44000000004444444000000000444444440000000044aaaa44000000004444444000000000444444440000000000000000000000000000
000000000000aaaaaaaa0000000044444aaa000000004444444400000000aaaaaaaa0000000044444aaa00000000444444440000000000000000000000000000
00000000000aa0aaaa0aa000000444aaaa0a00000004444444444000000aa0aaaa0aa000000444aaaa0a00000004444444444000000000000000000000000000
00000000000aa0aaaa0aa000000aaaaaaa0a0000000a44444444a000000aa0aaaa0aa000000aaaaaaa0a0000000a44444444a000000000000000000000000000
00000000000aaaaaaaaaa000000aaaaaaaaa0000000aaaaaaaaaa000000aaaaaaaaaa000000aaaaaaaaa0000000aaaaaaaaaa000000000000000000000000000
00000000000aaaa00aaaa000000aaaaaaaa00000000aaaaaaaaaa000000aaaa00aaaa000000aaaaaaaa00000000aaaaaaaaaa000000000000000000000000000
000000000000aaaaaaaa00000000aaaaaaaa00000000aaaaaaaa00000000aaaaaaaa00000000aaaaaaaa00000000aaaaaaaa0000000000000000000000000000
28888ee700000aaaaaa0000000000aaaaaa0000000000aaaaaa0000000000aaaaaa0000000000aaaaaa0000000000aaaaaa00000000000000000000000000000
056005000000000aa00000000000000aa00000000000000aa00000000000000aa00000000000000aa00000000000000aa0000000000000000000000000000000
1dddccc7000000dccd0000000000000cd0000000000000cccc000000000000cccd000000000000dcc0000000000000dccc000000000000000000000000000000
050050000000cc0cc0cc00000000000ccc0000000000dd0cc0dd000000000cacc0d000000000090cc0a0000000000d0cc0c00000000000000000000000000000
44999aaa000a000cc000a0000000000cc0ca00000009000cc000900000000aacc09000000000000ccc00000000000d9cc0a00000000000000000000000000000
0050050000000cddddc000000000000cc000000000000cccccc00000000000c00c000000000000c00d0000000000000cc0000000000000000000000000000000
5dd666770000c000000c00000000000c000000000000d000000d0000000009000d00000000000ac000d00000000000c00d000000000000000000000000000000
05050050000aa000000aa0000000000aa00000000009900000099000000000000aa00000000000000009000000000aa009000000000000000000000000000000
33bbbba7000000444400000000000444440000000000004444000000000000000000000000000000000000000000000000000000000000000000000000000000
50500050000044aaaa44000000004444444000000000444444440000000000000000000000000000000000000000000000000000000000000000000000000000
8888eeee0000aaaaaaaa0000000044444aaa00000000444444440000000000000000000000000000000000000000000000000000000000000000000000000000
00005000000aa0aaaa0aa000000444aaaa0a00000004444444444000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000aa0aaaa0aa000000aaaaaaa0a0000000a44444444a000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000aaaaaaaaaa000000aaaaaaaaa0000000aaaaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000aaaa00aaaa000000aaaaaaaa00000000aaaaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000aaaaaaaa00000000aaaaaaaa00000000aaaaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000aaaaaa0000000000aaaaaa0000000000aaaaaa00000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000aa00000000000000aa00000000000000aa0000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000dccc00000000000cccc0900000000000cccd000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000d0ccac000000000c00ccd00000000000c0cc0d00000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000090ccaa000000000000cc000000000000a0cc9d00000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000c00c0000000000000d0c0000000000000cc0000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000c000900000000009d000c00000000000d00a000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000aa0000000000000000000a00000000000900aa00000000000000000000000000000000000000000000000000000000000000000000000000000
