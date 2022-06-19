darken = split("0,1,1,2,1,5,6,4,4,9,3,13,5,8,9")
darken[0] = 0

debugs = {}

-- TODO:
-- make level

-- ACTIONS:
-- sleep in sun ****
-- scratch ****
-- run a lot ****
-- smell + find **
-- pounce **
-- play with toys *
-- open and close doors (meow)

--title_vector = split("1546,1545,1544,1543,1671,1670,1798,1797,1925,2052,2180,2308,2307,2435,2563,2691,2819,2947,3075,3203,3331,3587,3715,3843,3844,3972,3973,3974,4102,4103,4104,4232,4233,4234,4235,4236,4242,4114,3986,3859,3731,3603,3475,3347,3348,3220,3092,2965,2837,2838,2710,2582,2455,2327,2199,2071,2072,1944,1816,1688,1560,1561,1433,1689,1817,2074,2202,2459,2715,2971,3099,3228,3356,3484,3612,3613,3741,3869,3870,3998,4126,3221,3222,3223,3224,3225,3226,3227,1573,1574,1575,1576,1577,1578,1579,1580,1581,1582,1583,1584,1585,1580,1708,1836,2092,2220,2348,2476,2604,2732,2860,2988,3116,3244,3372,3500,3628,3756,3884,4012,1596,1597,1598,1599,1600,1601,1602,1604,1605,1606,1607,1608,1609,1482,1483,1732,1988,2116,2244,2372,2500,2628,2756,2884,3012,3140,3268,3396,3524,3652,3780,1493,1749,1877,2005,2133,2261,2389,2517,2773,2774,2902,3030,3158,3286,3414,3542,3670,3798,1489,1490,1491,1493,1495,1497,1499,1372,1373,1501,1500,3921,3922,3923,3924,3925,3926,3927,3928,3800,3801,3802,3803,3937,3809,3681,3553,3298,3042,2659,2531,2404,2276,2148,2020,1892,1893,1765,1637,1766,1894,2151,2408,2536,2664,2792,2537,2409,2281,2282,2154,2026,1898,1899,1771,1643,1771,1899,2027,2155,2284,2412,2668,2796,2924,3052,3180,3308,3436,3564,3565,3693,3821,1649,1777,2034,2162,2290,2418,2546,2674,2802,2930,3058,3186,3314,3442,3570,3698,3699,3700,3701,3702,3703,2803,2804,2805,2679,2680,2681,2680,1649,1650,1651,1523,1524,1525,1526,1527,1528")
title_vector = split("2194,2195,2067,2068,1940,1812,1684,1683,1682,1681,1680,1678,1806,1805,1804,1932,1931,2058,2186,2185,2313,2440,2568,2696,2823,2951,3079,3206,3334,3462,3590,3718,3847,3975,4103,4231,4359,4488,4616,4617,4745,4873,4874,4875,4876,5004,5005,5006,5007,5008,5009,5010,5011,4883,4884,5015,4887,4759,4631,4503,4375,4376,4248,4120,3992,3865,3737,3610,3482,3355,3227,3099,3100,2972,2844,2716,2717,2589,2461,2333,2205,2077,1949,1821,1822,1694,1822,1950,2078,2207,2463,2591,2720,2848,2976,3104,3233,3361,3489,3617,3746,3874,4002,4003,4131,4259,4387,4388,4516,4644,4772,4773,4901,5029,3865,3866,3868,3869,3870,3871,3872,3873,3874,5034,4906,4778,4650,4522,4394,4266,4138,4010,3882,3754,3755,3627,3499,3371,3243,3115,2987,2859,2731,2603,2475,2347,2219,2091,1964,1836,1835,1570,1571,1572,1573,1574,1575,1576,1577,1578,1579,1581,1582,1583,1584,1585,1586,1587,1588,1716,1717,1595,1596,1598,1600,1602,1603,1604,1605,1606,1607,1608,1736,1737,1602,1730,1858,2242,2370,2498,2626,2754,2882,3010,3138,3266,3394,3522,3650,3778,3906,4034,4162,4290,4418,4546,4674,4803,4931,4930,4944,4816,4688,4560,4432,4305,4177,4049,3921,3793,3665,3537,3409,3281,3153,3025,2897,2769,2641,2642,2514,2386,2258,2130,2002,1874,1746,1618,1614,1615,1616,1617,1618,1619,1620,1621,5069,5070,5071,5072,5073,5074,5075,5076,5081,4953,4954,4826,4698,4699,4571,4443,4444,4316,4188,4060,4061,3933,3805,3677,3678,3550,3422,3294,3167,3039,2911,2783,2784,2656,2528,2400,2272,2145,2017,1889,1761,1633,1761,2018,2274,2531,2659,2787,2915,3043,3171,3300,3172,3044,2916,2917,2789,2661,2533,2534,2406,2278,2151,2023,1895,1896,1768,1640,1641,1769,1897,2025,2153,2409,2537,2666,2794,3050,3178,3306,3434,3562,3690,3818,3946,3947,4075,4203,4331,4459,4587,4588,4716,4844,4972,5100,5228,1648,1776,1904,2032,2161,2289,2417,2545,2673,2801,2929,3056,3184,3312,3440,3568,3696,3824,3952,4080,4208,4336,4464,4592,4720,4848,4976,5104,5105,5233,5105,5106,5107,5108,5109,5110,5111,5112,5113,1521,1522,1523,1524,1525,1526,1527,1528,1529,1530,3569,3570,3571,3572,3573,3574,3575,3576")

--flags: 0 = full height, 1 = window, 2 = half height, 3 = see-thru, 4 = scratchable

layer1_map_offset = {32, 0}
layer2_map_offset = {64, 0}

function draw_aa_line(x1,y1,x2,y2,c1,c2)
    function psetaa(x,y,b,c1,c2)
        if b < 0.5 then
            pset(x,y,c1)
        else
            pset(x,y,c2)
        end
    end

    function frac(n)
        if n > 0 then return n - (n \ 1)
        else return n - (n\1 + 1)
        end
    end

    local steep = abs(y2-y1) > abs(x2-x1)
    if steep then
        x1, x2, y1, y2 = y1, y2, x1, x2
    end
    if x1 > x2 then
        x1, x2, y1, y2 = x2, x1, y2, y1
    end
    local dx, dy = x2 - x1, y2 - y1
    local gradient = 1
    if dx != 0 then gradient = dy / dx end
    local xpxl1, xpxl2, intersecty = x1, x2, y1
    if steep then
            for x = xpxl1, xpxl2 do
                psetaa(intersecty \ 1, x, 1 - frac(intersecty), c1,c2)
                psetaa(intersecty \ 1 - 1, x, frac(intersecty), c1,c2)
                intersecty += gradient
            end
    else
        for x = xpxl1, xpxl2 do
            psetaa(x, intersecty \ 1, 1 - frac(intersecty), c1,c2)
            psetaa(x, intersecty \ 1 - 1, frac(intersecty), c1,c2)
            intersecty += gradient
        end        
    end
end

function vec(x,y)
    local v = {
        x or 0,
        y or 0,
    }
    return v
end
function vdsq(v)
    return (v[1] * v[1] + v[2] * v[2])
end
function vnorm(v)
    local dist = sqrt(vdsq(v))
    return vec(v[1] / dist, v[2] / dist)
end
function vdot(v1,v2)
    return v1[1] * v2[1] + v1[2] * v2[2]
end

particles = {}

function make_particle(x, y)
    local p = {
        x=x,y=y,z=0,
        update = function(self) end,
        draw = function(self) end,
    }
    add(particles, p)
    return p
end

function make_arrow_particle(x,y,x2,y2)
    local p = make_particle(x,y)
    p.draw = function(self)
        draw_aa_line(x, y, x2, y2, 5, 6)
    end
    return p
end

function make_smell_particle(x, y, color, intensity)
    local p = make_particle(x,y)
    p.freq = rnd()
    p.time = rnd(30)
    p.center_x = x
    p.draw = function(self)
        local c = 7
        if self.time > 20 then c = 6 end
        if self.time > 40 then c = 5 end
        if (self.time / 10) % 1 < intensity then
            c = color
        end
        pset(p.x, p.y - p.z, c)
    end
    p.update = function(self)
        self.time += 1
        --self.x = sin(self.time * self.freq / 20) * 2 + self.center_x
        --self.z += 0.125
        self.x = self.center_x
        if self.time > 70 then
            del(particles, self)
        end
    end
    return p
end

pal_black = {[2]=0,[4]=0}
pal_orange = {[2]=4,[4]=9,[10]=3}
pal_grey = {[2]=1,[4]=5,[10]=9}
pal_brown = {[10]=7}

cats = {
    {palette=pal_black, personality="black cat\naggressive but nervous\nloves to catch critters", love="catch", frames={54,55}, anim_rate=3},
    {palette=pal_orange, personality="orange cat\nvery silly\nloves to play with toys", love="play", frames={56,57,58,59,60,57,58,59,60,57,56}, anim_rate=6},
    {palette=pal_brown, personality="tabby cat\neither running or napping\nloves to lie in the sun", love="sun", frames={1,1,17,33,17,33,17,33,17,33,17,1}, anim_rate=18},
    {palette=pal_grey, personality="grey cat\ndignified and calm\nloves to scratch", love="scratch", frames={2,3,4,5,6,7}, anim_rate=8},
}

dleft, dright, dup, ddown = 1,2,4,8
pl = nil
function make_player()
    pl = {
        x = 50, y = 50,
        xv = 0, yv = 0,
        z = 0, zv = 0, -- jumping
        decel = 0.9,
        max_speed = 0.6,
        dir = 2,
        palette = cats[selected_cat_index].palette,
        in_sun = false,
        state = "sit",
        set_state = function(ns)
            if states[pl.state].exit then states[pl.state].exit() end
            pl.state = ns
            pl.state_t = 0
            if states[pl.state].enter then states[pl.state].enter() end
            states[pl.state].update()
        end,
        draw_state = {flip=false, spri=1, frame=0},
        anim_t = 0,
        meter = 0,
        add_meter = function(amt)
            pl.meter = min(pl.meter + amt, 100)
        end,
        zoomy_times = {{6,8}, {12,15}},
        --zoomy_times = {{0,16}},
        charge_t = 0,
        charge_dir = {},
        completed_goals = {},
        last_goal_completion_time = 0,
        goal = {
            progress=0,
            last_progress_time = 0,
        },
        state_t = 0,
    }
end

function goal_progress(name, amt)
    if count(pl.completed_goals, name) > 0 then return end
    if pl.goal.name != name then
        pl.goal.name = name
        pl.goal.progress = amt
    else 
        pl.goal.progress += amt
    end
    pl.goal.last_progress_time = tf
    if pl.goal.progress >= 100 then
        pl.goal.progress = 0
        pl.last_goal_completion_time = tf
        pl.goal.name = nil
        add(pl.completed_goals, name)
    end    
end

function draw_paw(x, y, angle, size, color1, color2)
    circfill(x + cos(angle) * size * 0.1, y + sin(angle) * size * 0.1, size*1.1, color1)
    for i = -2, 1 do
        local ta = angle + i * 0.125 + 0.0625
        local cx, cy = cos(ta) * size + x, sin(ta) * size + y
        circfill(cx, cy, size * 0.5, color1)
        
    end
    for i = -2, 1 do
        local ta = angle + i * 0.125 + 0.0625
        local cx, cy = cos(ta) * size + x, sin(ta) * size + y
        circfill(cx, cy, size * 0.30, color2)
    end
    for i = 0, 2 do
        local ta = angle + 0.33 * i
        local cx = cos(ta) * size * 0.3 + x + cos(angle) * size * -0.1
        local cy = sin(ta) * size * 0.3 + y + sin(angle) * size * -0.1
        circfill(cx, cy, size * 0.40, color2)
    end
end

function can_scratch()
    local off = 3
    if pl.draw_state.flip then off = -3 end
    return get_collision_flag(pl.x + off, pl.y - 1) & 0x10 != 0
end

function check_interaction_triggers()
    if pl.in_sun then
        set_action_message("❎  to sleep in the sun")
        if btnp(❎) then
            pl.set_state("sleep")
            set_action_message("")
        end
    else
        if zoomy_time() and zoomy_time() < 1 then
            set_action_message("zoomies!")
        else
            if can_scratch() then
                set_action_message("❎  to scratch")
                if btnp(❎) then
                    pl.set_state("scratch")
                    set_action_message("")
                end
            else
                set_action_message("")
            end
        end
    end 
end

function zoomy_time()
    for span in all(pl.zoomy_times) do
        if time >= span[1] and time < span[2] then return time - span[1] end
    end
    return false
end

function get_move_state()
    if zoomy_time() then return "zoom" end
    return "walk"
end

function sit_update()
    pl.draw_state.spri = 1
    pl.draw_state.frame = 0
    if btnp(0) or btnp(1) or btnp(2) or btnp(3) then
        pl.set_state(get_move_state())
    end 
    if btnp(🅾️) then
        if zoomy_time() then
            pl.set_state("charge")
            return
        else
            pl.set_state("smell")
            return
        end
    end    
    check_interaction_triggers()
end

function move_update(speed, spri)
    local d = {0,0}
    if btn(0) then
        d[1] = -1
    end
    if btn(1) then
        d[1] = 1
    end
    if btn(2) then
        d[2] = -1
    end
    if btn(3) then
        d[2] = 1
    end
    if d[1] == 0 and d[2] == 0 then
        pl.set_state("sit")
    else
        if pl.dir != dleft then pl.dir = dright end
        if d[1] != 0 or d[2] != 0 then
            d = vnorm(d)
            d = {d[1] * speed, d[2] * speed}
            if d[1] != 0 or d[2] != 0 then
                if d[2] > 0 then
                    pl.dir = ddown
                    pl.draw_state.spri = spri + 32
                elseif d[2] < 0 then
                    pl.dir = dup
                    pl.draw_state.spri = spri + 16
                end

                -- not elseif so that left/right take priority
                if d[1] > 0 then
                    pl.dir = dright
                    pl.draw_state.flip = false
                    pl.draw_state.spri = spri
                elseif d[1] < 0 then
                    pl.dir = dleft
                    pl.draw_state.flip = true
                    pl.draw_state.spri = spri
                end

                pl.xv += d[1]
                pl.yv += d[2]
                pl.anim_t += 1
            end
        end
    end
    check_interaction_triggers()
end

function walk_update()
    pl.decel = 0.7
    pl.max_speed = 0.6
    if zoomy_time() then pl.set_state("zoom") end
    move_update(0.3, 2)
    pl.draw_state.frame = (pl.anim_t \ 6) % 6
    if btnp(🅾️) then
        pl.set_state("smell")
        return
    end
end

function zoom_update()
    if btnp(🅾️) then
        pl.set_state("charge")
        return
    end

    pl.decel = 0.9
    pl.max_speed = 2.2
    
    if vdsq({pl.xv, pl.yv}) >= pl.max_speed then
        goal_progress("zoom", 0.33)
    end

    if not zoomy_time() then pl.set_state("walk") end
    move_update(0.3, 8)
    pl.draw_state.frame = (pl.anim_t \ 1.5) % 7
end

function sleep_update()
    pl.draw_state.spri = 17 + min((pl.anim_t % 80) \ 10, 1) * 16
    pl.anim_t += 1
    pl.draw_state.frame = 0
    if btnp(0) or btnp(1) or btnp(2) or btnp(3) then
        pl.set_state(get_move_state())
    end     
    goal_progress("sleep", 0.33)
    if not pl.in_sun then
        pl.set_state("sit")
    end
end

function charge_update()
    pl.charge_t += 1
    pl.draw_state.spri = 54
    pl.draw_state.frame = (pl.anim_t \ 3) % 2
    pl.anim_t += 1    
    if not btn(🅾️) or pl.charge_t > 30 then
        pl.set_state("pounce")
    end
end

function pounce_enter()
    pl.zv = mid(pl.charge_t, 10, 30) / 30 + 0.5
end

function pounce_update()
    pl.draw_state.spri = 52
    pl.draw_state.frame = (pl.anim_t \ 2) % 2
    pl.anim_t += 1
    if pl.dir == dleft then pl.xv = -0.6 end
    if pl.dir == dright then pl.xv = 0.6 end
    if pl.dir == dup then pl.yv = -0.6 end
    if pl.dir == ddown then pl.yv = 0.6 end
    pl.z += pl.zv
    if pl.z < 0 then
        pl.zv = 0
        pl.z = 0
        pl.set_state("sit")
    else
        pl.zv -= 0.1
    end
end

function scratch_update()
    pl.draw_state.spri = 52
    pl.draw_state.frame = (pl.anim_t \ 9) % 2
    pl.anim_t += 1
    goal_progress("scratch", 1)
    if btnp(0) or btnp(1) or btnp(2) or btnp(3) then
        pl.set_state("sit")
    end
end

smell_targets = {}
function smell_update()
    pl.draw_state.spri = 49
    pl.draw_state.frame = (pl.anim_t \ 9) % 2
    pl.anim_t += 1
    local nx, ny = pl.x + 3, pl.y
    if pl.draw_state.flip then nx = pl.x - 3 end
    local rad = pl.anim_t / 3 - 1
    local theta = rnd(10)
    local sx, sy = cos(theta) * rad, sin(theta) * rad
    for target in all(smell_targets) do
        local delta = {target[1] - nx, target[2] - ny}
        local deltan = vnorm(delta)
        local dp = vdot(deltan, {sx / rad,sy / rad})
        local d = sqrt(vdsq(delta))
        if d < 5 then
            del(smell_targets, target)
            pl.set_state("found_toy")
            return
        end
        if dp > 0.75 then
            make_smell_particle(nx + sx, ny + sy, target[3], 1)
        end
    end
    if rnd() < 0.25 then
        --p = make_smell_particle(nx + sx, ny + sy, 0, 0)
    end
    if pl.anim_t > 30 then
        pl.set_state("sit")
    end
end

function smell_draw()
    local nx, ny = pl.x + 3, pl.y
    if pl.draw_state.flip then nx = pl.x - 3 end
    local rad = pl.anim_t / 3
    circ(nx, ny, rad, 7)
end

function found_toy_update()
    pl.state_t += 1
    pl.draw_state.spri = 57
    pl.draw_state.frame = (pl.state_t \ 4) % 4
    if pl.state_t > 60 then
        pl.set_state("sit")
    end
end

function found_toy_draw()
    local yo = -11 - sin(pl.state_t / 16 - 0.125) * 2
    spr(48, pl.x - 4, pl.y + yo)
    for i = 0, 5 do
        local theta = i / 6 + tf / 60
        local rx,ry = cos(theta), sin(theta)
        line(pl.x + rx * 5, pl.y + yo + 4 + ry * 5, pl.x + rx * 30, pl.y + yo + 4 + ry * 30, 10)
    end
end

states = {
    sit = {update = sit_update},
    walk = {update = walk_update},
    zoom = {update = zoom_update},
    sleep = {update = sleep_update, enter = function() pl.anim_t = 0 end},
    charge = {update = charge_update, enter = function() pl.charge_t = 0; pl.charge_dir = {} end},
    pounce = {update = pounce_update, enter = pounce_enter},
    scratch = {update = scratch_update},
    smell = {update=smell_update, enter=function() pl.anim_t = 0 end, draw = smell_draw},
    found_toy = {update=found_toy_update, draw = found_toy_draw}
}

ray = vnorm({1, 1})
sun_angle = 45
tf = 0
time = 0

ceiling_tiles = {}


function move()
    function do_x()
        local dir = 1
        if pl.xv < 0 then dir = -1 end
        step = abs(pl.xv)
        while step > 0 do
            if gcol(pl.x + step * dir + 1 * dir, pl.y - 1) or gcol(pl.x + step * dir + 1 * dir, pl.y - 1) then
                if dir > 0 then pl.xv = min(pl.xv, 0)
                else pl.xv = max(pl.xv, 0) end
                break
            else
                pl.x += dir * min(step, 1)
            end
            step -= 1
        end
    end
    function do_y()
        local dir = 1
        if pl.yv < 0 then dir = -1 end
        step = abs(pl.yv)
        while step > 0 do
            if gcol(pl.x - 1, pl.y + step * dir + 1 * dir) or gcol(pl.x + 1, pl.y + step * dir + 1 * dir) then
                if dir > 0 then pl.yv = min(pl.yv, 0)
                else pl.yv = max(pl.yv, 0) end
                break
            else
                pl.y += dir * min(step, 1)
            end
            step -= 1
        end
    end   
    if abs(pl.xv) > abs(pl.yv) then
        do_x()
        do_y()
    else
        do_y()
        do_x()
    end
end

function hash(p)
    return p[1] + p[2] * 32
end

function scol(x, y)
    local bits = 0b00000001 << (7 - ((x\1) % 8))
    local base_addr = 0x8000 + x \ 8 + y \ 1 * 32
    poke(base_addr, @base_addr | bits)
end

function gcol(x, y)
    local base_addr = 0x8000 + x \ 8 + y \ 1 * 32
    local byte = @base_addr
    local n = 7 - ((x\1) % 8)
    return (byte >> n) & 0b00000001 == 1
end

function pt_to_col_addr(pt)
    return 0x8000 + flr(pt[1]) + flr(pt[2]) * 256
end

function collides(x,y)
    return @pt_to_col_addr({x,y}) != 0
end

function get_collision_flag(x,y)
    return @pt_to_col_addr({x,y})
end

non_colliders = split("0,111,127")
flood_blockers = split("64,65,66,67,68,69,70,71,74,75,76,77,78,111")


action_message = ""
action_message_time = 0
function set_action_message(msg)
    if msg == "" then
        action_message = ""
    else
        if action_message != msg or action_message_time < 0 then
            action_message_time = 0
            action_message = msg
        end
    end
end

function load_level()
    -- collision
    num_goals = 3
    smell_targets = {}
    make_player()
    particles = {}        
    memset(0x8000, 0x00, 32 * 256)
    for gx = 0, 31 do
        for gy = 0, 31 do
            rectfill(0,0,8,8,0)
            map(gx,gy,0,0,1,1)
            local t = mget(gx,gy)
            if count(non_colliders, t) == 0 then
                for x = 0, 7 do
                    for y = 0, 7 do
                        local fx, fy = x + gx * 8, y + gy * 8
                        local c = pget(x, y)
                        if c != 0 then
                            scol(fx,fy)    
                        end
                    end
                end
            end
            
        end
    end

    local flood_positions = {}
    for y = 0, 31 do
        for x = 0, 31 do
            local t = mget(x,y)
            if t > 0 then
                if t == 127 then
                    mset(x,y,0)
                    add(flood_positions, {x,y})
                elseif t == 111 then
                    --
                else
                    mset(x + layer2_map_offset[1],y + layer2_map_offset[2] - 1, t + 16)
                    mset(x + layer1_map_offset[1],y + layer1_map_offset[2], t + 32)
                end
            end
        end
    end
    for fp in all(flood_positions) do
        local all_flooded = flood_tiles(fp)
        local all_flooded_hash = {}
        for t in all(all_flooded) do
            add(all_flooded_hash, hash(t))
        end
        function has_pt(pt)
            return count(all_flooded_hash, hash(pt)) != 0
        end
        for t in all(all_flooded) do
            local x1o, y1o, x2o, y2o = 0,0,0,0
            if not has_pt({t[1] - 1, t[2]}) then x1o -= 4 end
            if not has_pt({t[1], t[2] - 2}) then y1o -= 4 end
            if not has_pt({t[1] + 1, t[2]}) then x2o += 4 end
            if not has_pt({t[1], t[2] + 1}) then y2o += 4 end
            add(ceiling_tiles, {t[1] * 8 + x1o, t[2] * 8 + y1o, t[1] * 8 + 8 + x2o, t[2] * 8 + 8 + y2o})
        end
    end
    for y = 0, 31 do
        for x = 0, 31 do
            local t = mget(x,y)
            if t == 111 then mset(x,y,0) end
        end
    end    
    cls(7)
    
    for i = 1, 3 do 
        local tile = rnd(ceiling_tiles)
        add(smell_targets, {tile[1] + 4, tile[2] + 4, i + 7})
    end    
end

function get_neighbors(xy)
    local neighbors = {}
    if xy[1] > 0 then add(neighbors, {xy[1] - 1, xy[2]}) end
    if xy[1] < 31 then add(neighbors, {xy[1] + 1, xy[2]}) end
    if xy[2] > 0 then add(neighbors, {xy[1], xy[2] - 1}) end
    if xy[2] < 31 then add(neighbors, {xy[1], xy[2] + 1}) end
    return neighbors
end
function flood_tiles(fp)
    local tiles = {}
    local open = {fp}
    local closed = {}
    while #open > 0 do
        local tt = open[1]
        deli(open, 1)
        --printh("looking at: "..tt[1]..","..tt[2], "test.txt")
        local tv = mget(tt[1], tt[2])
        if count(flood_blockers, tv) > 0 then
            -- nothing
        else
            add(tiles, tt)
            for n in all(get_neighbors(tt)) do
                if count(closed, hash(n)) == 0 then
                    --printh(n[1]..","..n[2].."--"..hash(n),"test.txt")
                    add(open, n)
                    add(closed, hash(n))
                else
                    
                end
            end
        end
    end
    return tiles
end

function _update()
    scenes[scene].update()
end

title_anim = 0
cat_anim = 0
function update_title()
    title_anim += 1
    cat_anim += 1
    if btnp(0) then
        selected_cat_index = (selected_cat_index - 2) % #cats + 1
        cat_anim = 0
    end
    if btnp(1) then
        selected_cat_index = selected_cat_index % #cats + 1
        cat_anim = 0
    end
    if btnp(5) then
        scene = "name"
    end
end

keyboard_cursor = {1,1}
cat_name = ""
ntf = 0
function update_name()
    if btnp(0) then keyboard_cursor[1] -= 1 end
    if btnp(1) then keyboard_cursor[1] += 1 end    
    if btnp(2) then keyboard_cursor[2] -= 1 end
    if btnp(3) then keyboard_cursor[2] += 1 end
    keyboard_cursor[2] = mid(keyboard_cursor[2], 1, 4)
    keyboard_cursor[1] = mid(keyboard_cursor[1], 1, #keyboard[keyboard_cursor[2]])
    if btnp(5) then
        if keyboard_cursor[2] == 4 then
            game_start()
        else
            local letter = sub(keyboard[keyboard_cursor[2]],keyboard_cursor[1], ".")
            if letter == "<" then
                cat_name = sub(cat_name, 0, #cat_name - 1)
            else
                cat_name ..= letter
            end
        end
    end
    title_anim += 1
    cat_anim += 1
    ntf += 1
end

function print_shadowed(text, x, y)
    print(text,x,y+1,2)
    print(text,x,y,14)
end

function game_start()
    load_level()
    scene = "game"
end

function update_game()
    debugs = {}
    tf += 1
    time = (tf / 300) % 24 + 3
    if btn(4) and btn(5) then
        tf += 10
    end
    --time = 7
    --ray = vnorm({sin(tf / 100), cos(tf / 100)})
    ray = {sin((time + 12) / 48) * 0.2 - 0.01, sin((time + 12) / 48) }
    sun_angle = 80--abs(sin(tf / 300) * 80)
    states[pl.state].update()
    pl.xv *= pl.decel
    pl.yv *= pl.decel
    local vel = {pl.xv, pl.yv}
    if vdsq(vel) > pl.max_speed * pl.max_speed then
        vel = vnorm(vel)
        pl.xv = vel[1]* pl.max_speed
        pl.yv = vel[2]* pl.max_speed
    end
    move()
    for i = #particles, 1, -1 do 
        particles[i]:update()
    end
end

function _draw()
    scenes[scene].draw()
end

function draw_selected_cat(x,y)
    local cat = cats[selected_cat_index]
    local spri = cat.frames[(cat_anim \ cat.anim_rate) % #cat.frames + 1]
    --ovalfill(x, y + 6, x + 7, y + 8, 13)
    palt(12)
    pal(cat.palette)
    spr(spri, x, y)
    pal()
end


function draw_title()
    cls(7)

    --draw_paw(8.5, 8.5, 0.375, 3.25, 2, 6)

    for i = 0, 8 do
        local o = i % 2
        local t = (title_anim / 5 - i) % 40
        if t > 5 and t < 30 then
            draw_paw(0.5 + i * 19 - 2 - o * 5, 0.5 + i * 6.5 + 64 + o * 10, -0.05 + o * -0.1, 8, 7, 15)
        end
    end

    for i = 1, min(title_anim * 5, #title_vector) do
        local tv = title_vector[i]
        local tx, ty = tv % 128, tv \ 128
        tx += 0
        --circfill(tx, ty, 1 + sin(i / 1.414) * 0.5 + 0.75, 0)
        for j = 0, 1 do
            local colors = {0,0,0}
            local c = colors[flr((sin(i / 10) * 0.5 + 0.5) * #colors + 1)]
            circfill(tx, ty + sin(tx / 50 + title_anim / 100) * 1.25, 3, c)
        end
    end

    for i = 1, min(title_anim * 5, #title_vector) do
        local tv = title_vector[i]
        local tx, ty = tv % 128, tv \ 128
        tx += 0
        --circfill(tx, ty, 1 + sin(i / 1.414) * 0.5 + 0.75, 0)
        for j = 0, 4 do
            local colors = {4,9}
            local c = colors[flr((sin(i / 10) * 0.5 + 0.5) * #colors + 1)]
            circfill(tx, ty + sin(tx / 50 + title_anim / 100) * 1.25, 1, c)
        end
    end  

    spr(16, 33, 58, 1, 1, true)
    spr(16, 87, 58)

    local cat = cats[selected_cat_index]
    local spri = cat.frames[(cat_anim \ cat.anim_rate) % #cat.frames + 1]

    local y = 80
    for row in all(split(cat.personality, "\n")) do
        print(row, 64 - #row * 2, y, 0)
        y += 8
    end

    draw_selected_cat(60, 58)

    print_shadowed("❎", 42, 110)
    print("to choose", 53, 111)

end

keyboard = split("qwertyuiop,asdfghjkl,zxcvbnm <, ")
function draw_name()
    cls(7)
    if ntf > 30 then
        local x, y = 14, 50
        for row = 1,3 do
            for i = 1, #keyboard[row] do
                if keyboard_cursor[1] == i and keyboard_cursor[2] == row then
                    rectfill(x, y, x + 8, y + 8, 11)
                end
                rect(x, y, x + 8, y + 8, 0)
                print(sub(keyboard[row], i, "."), x + 3, y + 2)
                x += 10
            end
            y += 10
            x = 14 + row * 1
        end
        if keyboard_cursor[2] == 4 then
            rectfill(53, 80, 74, 88, 11)
        end
        print("done", 56, 82, 0)
        rect(53, 80, 74, 88,0)
        local name = "name: ".. cat_name
        print(name, 64 - #name * 2, 38, 0)
        if title_anim \ 8 % 2 == 0 then
            print("_", 64 + #name * 2, 38)
        end
    end
    local cy = 41 + cos(min(ntf / 50, 0.5)) * 17
    draw_selected_cat(60, cy)
end

function draw_game()
    
    local shadow_color = 13
    if time < 3 or time > 21 then
        cls(1)
        shadow_color = 1
    --elseif time < 6 or time > 18 then
    --    rectfill(0,0,128,128,13)
    --    shadow_color = 1
    else
        cls(15)
        shadow_color = 13
    end

    camera(pl.x - 64, pl.y - 64)

    -- Draw shadows
    local sa = sun_angle / 360
    local shadow_length = min(abs(sin(sa) / cos(sa)), 8) * 5

    local mrx, mry = ray[1] * shadow_length, ray[2] * shadow_length
    for t in all(ceiling_tiles) do
        rectfill(t[1] + mrx, t[2] + mry, t[3] + mrx, t[4] + mry, shadow_color)
    end

    local ox, oy, rx, ry = 0.5,0.5,ray[1],ray[2]
    for i = 1, flr(shadow_length) do
        local t = i / shadow_length
        ox += rx
        oy += ry
        local layers = 0x01
        if t < 0.25 or t > 0.8 then layers |= 0x02 end
        if t < 0.4 then layers |= 0x04 end
        local p = {}
        for c = 0, 15 do
            if t * 12 < c then
                p[c] = shadow_color
            else
                p[c] = 0
                palt(c, true)
            end
        end
        pal(p)
        map(0, 0, flr(ox), flr(oy), 32,32, layers)
    end
    local spt = {}
    for i = 0,15 do spt[i] = shadow_color end
    pal(spt)
    palt()
    --map(0, 16, flr(ox), flr(oy), 16,16)
    pal()
    
    pl.in_sun = pget(pl.x, pl.y - 3) == 15

    -- Draw cat shadow
    palt(12)
    pal(spt)
    function draw_player(ox, oy)
        spr(pl.draw_state.spri + pl.draw_state.frame, pl.x - 4 + ox, pl.y - 7 + oy, 1, 1, pl.draw_state.flip)
    end
    draw_player(rx * shadow_length / 20, ry * shadow_length / 20)
    draw_player(rx * shadow_length / 10, ry * shadow_length / 10)

    pal()
    if pl.z > 0 then
        --pal(split("0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"))
        --draw_player(0,0)
        local w = 3 / (pl.z / 5 + 1)
        
        ovalfill(pl.x - w, pl.y - w * 0.75, pl.x + w, pl.y + w * 0.75, 1)
    end


    -- Draw bottom map layer 
    palt()
    for i = 0, 31 do
        map(layer1_map_offset[1],layer1_map_offset[2] + i,0,i * 8,32,1)

    end

    -- Interleave with map tiles probably
    for i = 1, #particles do 
        particles[i]:draw()
    end

    -- Draw top map layer
    palt()
    pal()
    local layer_y = pl.y - 4
    for i = 0, 31 do
        if layer_y > i * 8 and layer_y <= (i + 1) * 8 then
            if states[pl.state].draw then states[pl.state].draw() end
            palt(12)
            pal(pl.palette)            
            draw_player(0,-pl.z)
            palt()
        end    
        map(layer2_map_offset[1],layer2_map_offset[2] + i,0,i * 8,32,1)
    end

    -- debug
    --draw_collisions()

    camera()

    if action_message != "" then
        local color = 14
        action_message_time += 1
        local x = 64 - #action_message * 2
        for i = 1, #action_message do
            local t = mid(action_message_time / 10 - i / #action_message * 2, 0, 1)
            local t2 = action_message_time / 65 + i / 6
            print(sub(action_message,i,""), x, 124 + cos(t * 0.65) * 5 + sin(t2) * 0.5 + 1, 7)
            print(sub(action_message,i,""), x, 124 + cos(t * 0.65) * 5 + sin(t2) * 0.5, color)
            x += 4
        end
    end

    draw_clock(117,11)

    local time_msg = "midnight"
    local color = 7
    if flr(time) > 0 and flr(time) < 12 then
        time_msg = flr(time) .. " am"
    elseif flr(time) == 12 then time_msg = "noon" 
    elseif flr(time) > 12 and flr(time) < 24 then
        time_msg = flr(time - 12) .. " pm"
    end
    if flr(time) > 2 and flr(time) < 21 then color = 0 end
    print(time_msg, 105 - #time_msg * 4, 10, color)


    pal()
    local y = 29.5
    for i = 1, num_goals do
        local c1,c2 = 5,13
        if i <= #pl.completed_goals then c1,c2 = 3,11 end
        local is_next_goal, offset = false, 0
        if i == #pl.completed_goals + 1 and pl.goal.progress > 0 and tf < pl.goal.last_progress_time + 30 then
            ao = pl.goal.progress / 100
            c1,c2 = 4, 10
            is_next_goal = true
            offset = (tf \ 5) % 2
        end
        local scale = 0
        if i == #pl.completed_goals then
            scale = max(0, 10 - (tf - pl.last_goal_completion_time) / 2)
        end
        draw_paw(120.5 + offset, y, 0.125 + i % 2 * 0.25, 3.25 + scale, c1, c2)
        if is_next_goal then
            print(pl.goal.name, 114 - #pl.goal.name * 4, y - 2, 9)
        end
        y += 10
    end


    fade_val = max(4 - tf \ 5, 0)
    fade_pal = {}
    for i = 0, 15 do
        local col = i
        for i = 1, fade_val do
            col = darken[col]
        end
        fade_pal[i] = col
    end
    pal(fade_pal, 1)

    local n = 0
    for msg in all(debugs) do
        print(msg, 0, n, 7)
        n += 6
    end
end

function draw_collisions()
    for x = max(pl.x-64,0), min(pl.x+64,255) do
        for y = max(pl.y-64,0), min(pl.y+64,255) do
            local flag = gcol(x,y)
            if flag then
                pset(x,y, 8)
            end
        end
    end
end

function draw_clock(x,y)
    local rad1 = 9
    local rad2 = 6
    local rad3 = 8
    circfill(x,y,rad1, 7)
    circ(x,y,rad1, 5)

    local start_time = time \ 12 * 12
    for span in all(pl.zoomy_times) do
        local t1 = span[1]
        local t2 = span[2]    
        
        if t1 < 12 and t2 > 12 then
            if start_time == 0 then t2 = 11.9 end
            if start_time == 12 then t1 = 12 end
        end
        if (start_time == 0 and t2 <= 12) or (start_time == 12 and t1 >= 12) then
            t1 = (t1 % 12) / 12
            t2 = (t2 % 12) / 12
            local t = t1
            while t < t2 do
                circfill(x + sin(t + 0.5) * 6 + 0.5, y + cos(t + 0.5) * 6 + 0.5, 1, 12)
                t += 0.025
            end
        end
    end

    for i = 0, 3 do
        theta = i / 4
        line(x + sin(theta) * 8 + 0.5, y + cos(theta) * 8 + 0.5, x + sin(theta) * 9 + 0.5, y + cos(theta) * 9 + 0.5, 5)
    end
    local mt = time % 1 - 0.5
    line(x,y,sin(mt) * rad3 + x, cos(mt) * rad3 + y, 6)
    local ht = (time / 12) % 1 - 0.5
    line(x,y,sin(ht) * rad2 + x, cos(ht) * rad2 + y, 8)
end


scenes = {
    title={update=update_title, draw=draw_title},
    name={update=update_name, draw=draw_name},
    game={update=update_game, draw=draw_game}
}

function reset()
    selected_cat_index = 1
    scene = "title"
end

function _init() reset() end