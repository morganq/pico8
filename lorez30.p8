pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
-- lo-rez
-- by morganquirk

#include lowrez30src.lua

__gfx__
000000000000000000000000000000000000000000cccc000cccccc00cccccc00cccccc00cccccc00ccccc000cccccc00cccccc00cccccc00000000000000000
000000000000000000000000000000000000000000c00c000c0000c00c0000c00c0cc0c00c0000c00c000c000c0000c00c0000c00c0000c00000000000000000
000000000007770000777000000000000000000000cc0c000cccc0c00cccc0c00c0cc0c00c0cccc00c0cccc00cccc0c00c0cc0c00c0cc0c00000000000000000
0000000000700000000007000000ccc00ccc0000000c0c000c0000c00c0000c00c0000c00c0000c00c0000c00000c0c00c0000c00c0000c00000000000000000
000000000070000000000700000c00000000c000000c0c000c0cccc00cccc0c00cccc0c00cccc0c00c0cc0c00000c0c00c0cc0c00cccc0c00000000000000000
000000000070000000000700000c00000000c00000cc0cc00c0cccc00cccc0c00000c0c00cccc0c00c0cc0c00000c0c00c0cc0c00000c0c00000000000000000
000000000000000000000000000c00000000c00000c000c00c0000c00c0000c00000c0c00c0000c00c0000c00000c0c00c0000c00000c0c00000000000000000
000000000000000000000000000000000000000000ccccc00cccccc00cccccc00000ccc00cccccc00cccccc00000ccc00cccccc00000ccc00000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000c00000000c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000070000000000700000c00000000c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000070000000000700000c00000000c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000700000000007000000ccc00ccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000777000077700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000001111111100000000000000000000000000000000000000000000
0000000000999900008888000077770000000000000000000000000000000000000000000111eeee2eee11100000000000000000000000000000000000000000
000000000997799008877880077cc77000000000000000000000000000111111111111001eeeeee882eeeee10000000000000000000000000000000000000000
00000000097997900878878007c77c700009900000088000000cc000116666e7ee866611eeeeee87882eeeee0cc00cc000c00c00ccc0ccc000c00c0000000000
00000000097997900878878007c77c700009900000088000000cc000666611eeee81166622222288882222220cc00cc00cc00cc00000000000c00c0000000000
000000000997799008877880077cc7700000000000000000000000001166668eee866611eeeeee28882eeeee000000000c0000c0000000000000000000000000
0000000000999900008888000077770000000000000000000000000000011111111111000eeeeee222eeeee00000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000eeee2eee00000000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccc00000000000011111111000000001111111100000000000000000000000000000000000000000000
c00000000000000cc00000000000000cc00000000000000c00000000011177776777111001118888e88811100000000000000000000000000000000000000000
c00000000000000cc0cccccccccccc0cc07777777777770c000000001777777ee877777118888880008888810000000000000000000000000000000000000000
c00000000000000cc0cccccccccccc0cc07777777777770c00000000777777e7ee87777788888807000888880000000000000000000000000000000000000000
c00000000000000cc0cccccccccccc0cc07777777777770c00000000666666eeee866666eeeeee00000eeeee0000000000000000000000000000000000000000
c00000000000000cc0cccccccccccc0cc07777777777770c000000007777778eee87777788888800000888880000000000000000000000000000000000000000
c00000000000000cc00000000000000cc00000000000000c00000000077777788877777008888880008888800000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccc00000000000077776777000000008888e88800000000000000000000000000000000000000000000
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000007000000000000000000000000000000070000000000000000000000000000000700000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000c000c000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000c000c000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000ccc00000ccc0ccc00000ccc00000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000c0c0c0c0000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000ccc0ccc0000000000000000000000000000000000000000000000000000000000000
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000000000020000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000000000020000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000002000000002020000000000220000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000002000000002020000000000202000000000002000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000022000000020020000000002002000000000002000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000022000000020020000000002002000000000022000000000000
00000000000000000000000000000000000000000000000000000000000000000000000002000020200000200002000000020002000000000020200000000000
00000000000000000000000000000000000000000000000000000000000000000000000002000200200000200002000000020000200000000200200000000000
00000000000000000000000000000000000000000000000000000000000000000000000002000200200008888888000000899990200000000200200000002000
00000000000000000000000000000000000000000000010101010101010101010000000022000200200008990008000000997799800000002000200000002000
00000000000000000000000000000000000000000000011101110111011101110000000022002022200008990008000000979979800000002000200000022000
00000000000000000000000000000000000000000000001100110011007770110777000022009900200080000080000008979979800000022999020000022000
00000000000000000000000000000000000000000001111111111111171111111111700022009902000088888888888888997799800000099222920000022000
00000000000000000000000000000000000000000001110111011101170111011101700222020022288888800000088008899998800000097997220000022002
00000000000000000000000000000000000000000001111111111100071111111111700292022222288888888888888880000888888882097997920000200202
00000000000000000000000000000000000000000001101110111000001110111011000992220022000000000000000008888888000080299779920000200202
00000000000000000000000000000000000000000001111111111100011111111111000222222200000000000000000000000000888820009999020000020202
00000000000000000000000000000000000000000001110111011100010111011101000202220000000000000000000000000000000002220002220000002222
00000000000000000000000000000000000000011111111111111100011111111111112222200002000000000000000000000000000000002220002200000222
00000000000000000011001100110011001100011011101110111000071110111011702202210012001100110011000000000000000000000002220222000222
00000000000000000111011101110111011100011111111111111111171111111111712221210122011101110111000000000000000000000000002200200222
00000000000000000101010101010101010100011101110111011101170111011101712202210122010101210101111111100000000000000000000222022202
00000000000000011111111111111111111111111111111111111111117771111777111211111211211112211117777677711100000000000000000200202202
0000000000000001101110111011101110111011101110111011101110111011101110122011122120111221777777ee87777710000000020000002200022220
000000000000000111111111110001111111111111111111111111111111111111111111222111122100212777777e7ee8777770000000020000002200002220
000000000000000111011101110001011101110111011101110111011101110111011101122211011100210666666eeee8666662000000220000002020022020
0000000000000001111111111100011111111111111111111111111111111111111111111112221111022117777778eee8777772000000220000002020020020
00000000000000011011101110000011101110111011101110111011101110111011101110112222100002227777778887777702000002002000020220000020
00000000000111111111111111000111111111111111111111111111111111111111111111111122222001111117777677712000200002002000022000000220
00000000000111011101110111000101110111011101110111011101110111011101110111011101222222211101122211012222200022222000000000022020
00000000000111111111111111111111111111111111111111111111111117777711111111111111111222222221111111110000000000000000000002200200
00000000000110111011101110111011101110111011101110111011101770171077101110111011101110122222222110110000000000000000022220222000
00000000000111111111111111111111111111111111111111111111117111171111711111111111111111111112222822222222222222222222200222200000
00000000000111011101110111011101110111011101110111011101170111071101170111011101110111011101118882222200002000022222222000000000
00000000000111111111111111111111111111111111111111111111711111171111117111111111111111111111111811110022222222200000000000000000
00000000000110111011101110111011101110111011101110111011701110171011107110111011101110111011101110110000000000000000000000000000
00000000000111111111111111111111111111111111111111111117111111171111111711111111111111111111111111110111011101110111011100000000
00000000000111011101110111011101110111011101110111011107110111071101110711011101110111011101110111010101010101010101010100000000
00000000000111111111111111111111111111111111111111111117711111171111117711111111111111111111111111110111011101110111011100000000
00000000000110111011101110111011101110111011101110111017177710171017771710111011101110111011181110111011101110111011101110110000
00000000000111111111111111111111111111111111111111111117111177777771111711111111111111111111888111111111111111111111111111110000
00000000000111011101110111011101110111011101110111011101710111071101117111011101110111011101180111011101110111000101110111011101
11101110000111111111111111111111111111111111111111111111711111171111117111111111111111111111111111111111111111000111111111111111
10101010000110111011101110111011101110111011101110111011171110171011171110111011101110111011101110111011101110000011101110111011
11101110000111111111111111111111111111111111111111111111117111171111711111111111111111114811111111111111111111000111111111111111
11011101110111011101110111011101110111011101110111011101110771071177110111011101110111888881110111011101110111000101110111011101
11111111111111111111111111111111111111111111111111111111111117777711111111111111111144884811111111111111111111000111111111111111
10111011101110111011101110111011101110111011101110111071101110717011101170111011101444441411101110111011101110111011101110111011
11111111111111111111111111111111111111111111111111111717777777111777777717111111111111144411111111111111111111111111111111111111
11011101110111011101110111011101110111011101110111011171110111717101110171011101110111011101110111011101110111011101110111011101
11111111111111111111111111111111111111144444444441444444444411171111111111111111111111111111111111111111111111111111111111111111
10111011101110111011101110111011101110444444444444444444444444474011101110111011101110111011101110111011101110111011101110111011
11111111111111111111111111111111111111111144444444444114444444474411111111111111111111111111111111111111111111111111111111111111
11011101110111011101110111011101110144444444444411011101110111071101110111011101110111011101110111011101110111011101110111011101
11111111111111111111111111111111111444444444444411111111111114474444111111111111111111111111111111111111111111111111111111111111
10111011101110111011101110111011101110114444444444444014444440474444401110111011101110111011101110111011101110111011101110111011
11111111111111111111111111111111111111114444444444444411444444171111111111111111111111111111111111111111111111111111111111111111
00000000000000000000000000000000000000099999999009999999999999797000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000999999900000009009000000099999979000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000099999999999999990009999999900000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000009999999900099999999999999990000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000009999999990000000900090000000000000009000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000009000000099999999900099999999999999999900000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000099999999900000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000009999999999000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000009999999999900099999999990000000009000000000000000000000000000000000000000000000000000000000000
00000000000000000000000099999999990000000000900090000000000000000000900000000000000000000000000000000000000000000000000000000000
01010101010101010101010901010101010101010109010191010101019999999999910101010101010101010101010101010101010101010101010101010101
00000000000000000000000900000000099999999999000099999999990000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010109999999999901010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
00000000000000000000000000000000000000000000000000000000000000000000009999999999990000000000000000000000000000000000000000000000
01010101010101010101010101010101010101010199999999999991010999999999990199019901999101010101010101010101010101010101010101010101
00000000000000000000000000000099999999999900000000000090000900000000000000000000000900000000000000000000000000000000000000000000
10101010101010101010101010101999109910991099109910991090101090991099109910991099109990101010101010101010101010101010101010101010
00000000000000000000000000000900000000000000000000000090000090000000000009999999999999000000000000000000000000000000000000000000
01010101010101010101010101019901990199019999999999999991010199999999999991010101010101010101010101010101010101010101010101010101
00000000000000000000000000099999999999cccccccccccccccc00cccccccccccccccc00cccccccccccccccc00000000000000000000000000000000000000
01010101010101010101010101010101010101c10101010101010c01c10101010101010c01c10101010101010c01010101010101010101010101010101010101
10101010101010101010101010101010101010c0cccccccccccc1c10c0cccccccccccc1c10c0cccccccccccc1c10101010101010101010101010101010101010
01010101010101010101010101010101010101c1cccccccccccc0c01c1cccccccccccc0c01c1cccccccccccc0c01010101010101010101010101010101010101
10101010101010101010101010101010101010c0cccccccccccc1c10c0ccccccccccccacaacacccccccccccc1c10101010101010101010101010101010101010
01010101010101010101010101010101aaaaaacaccccccccccccacaacaccccccccccccac01cacccccccccccc0c01010101010101010101010101010101010101
1010101010101010aaaaaaaaaaaaaaaa101010ca1010101a10101c10c01010101010101c10c0a010101010101c10101010101010101010101010101010101010
01010101aaaaaaaaaa01aa01aa01aa01aa01aacccccccccccccccc01ccccccccccccccccaacccccccccccccccc01010101010101010101010101010101010101
1010101a101010101010101010101010101010a01010101a10101010101010101010101010101a10101010101010101010101010101010101010101010101010

__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
95100000285551b50021500045002a5550050000500005002b5550050000500005002d5550050000500005002f555005000050000500305550050000500005003255500500005000050034555005000050000500
490300000c5701363516620196101b6101c6101e6001f60020600056000d600066001f60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
910200002871028620285102851006610005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
01110000186650c625006150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
910600003c61500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
910600001863418000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000205300000000000000002053000000000000000020530000000000000000205300000000000000002053000000000000000020530000000000000000205300000000000000002053000000000000000
c11000001c755007001e740007001f7550070021740007001c755007001e740007001f7550070021740007001c755007001e740007001f7550070021740007001c755007001e740007001f755007002174000700
511000000455004550045500455004550045500415004150045510455004550045500455004550045500455504550045500455004550045500455004050040500455004550045500455004550045500455004555
511000000c5500c5500c5500c5500c5500c55000550005500c5500c5500c5500c5500c5500c5500c5500c55009550095500955009550095500955009130091300955009550095500955009550095500955009550
a51000000443504425044550445504435044250445504455044350442504455044550443504425044550445507435094250945509455094350942509455094550043500425004550045500435004250045500455
01100000001631550021735217151f7351d1051d105000050016300000000001c7251f72500000000000000000163000001c7351c7151f73500000000000000000163000001e7351e7151a735000000000000000
a51000000443504425044550445504435044250445504455044350442504455044550443504425044550445506435064250645506455064350642506455064550743507425074550745507435074250745507455
910800100455300000000000000000000000000000024654045530000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a51000000443504425042550425504435044250425504255044350442504255042550443504425042550425503435034250325503255034350342503255032550343503425034550345503435034250345503455
91080020045531c4051c4051c4051c40534400307542465404553000002f754001000000000000000000000004553000000000000000000000000000000246540455300000000000000000000000000000000000
91080020045531c4051c4051c4051c405344002b7542465404553000002f10400100000000000000000000000455300000000000000000000000002a754246540455300000000000000000000000000000000000
a51000000043500425002550025500435004250725506255044350442504255042550443504425042550425506435064250625506255064350642506255062550043500425004550045500435004250045500455
911000001e7061e7061e7060c7062a7262a7262a7362a7362b7462b7462b7562b75628756287561f706007060070600706007060c7062d7262d7262d7362d7362b7462b7462b7562b7562f7562f7560070600706
91080020045531c405045331c40504513344002b1042460404553000002f104001000000000000000000000004553000000453300000000000000004513246040455300000000000000000000000000000000000
__music__
01 12114344
02 13114344
01 14554344
00 16554344
00 14174344
00 16174344
00 18194344
00 181a4344
00 18194344
00 181a4344
00 1b5d4344
00 1b1c4344
00 1b1d4344
02 1b1d4344

