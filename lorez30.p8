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

intro_ent = [[1
0;1.62,-4,1.18;0.62,-4,1.9;0.93,-5,2.85;2.43,-5,1.76/0;0.62,-4,1.9;-0.62,-4,1.9;-0.93,-5,2.85;0.93,-5,2.85/0;-0.62,-4,1.9;-1.62,-4,1.18;-2.43,-5,1.76;-0.93,-5,2.85/0;-1.62,-4,1.18;-2,-4,0.0;-3,-5,0.0;-2.43,-5,1.76/0;-2,-4,0.0;-1.62,-4,-1.17;-2.43,-5,-1.76;-3,-5,0.0/0;-1.62,-4,-1.17;-0.62,-4,-1.9;-0.93,-5,-2.85;-2.43,-5,-1.76/0;-0.62,-4,-1.9;0.62,-4,-1.9;0.92,-5,-2.85;-0.93,-5,-2.85/0;0.62,-4,-1.9;1.62,-4,-1.18;2.43,-5,-1.77;0.92,-5,-2.85/0;1.62,-4,-1.18;2,-4,0.0;3,-5,0.0;2.43,-5,-1.77/0;2,-4,0.0;1.62,-4,1.17;2.43,-5,1.76;3,-5,0.0/0;1.21,-3,0.88;0.46,-3,1.43;0.62,-4,1.9;1.62,-4,1.18/0;0.46,-3,1.43;-0.46,-3,1.43;-0.62,-4,1.9;0.62,-4,1.9/0;-0.46,-3,1.43;-1.21,-3,0.88;-1.62,-4,1.18;-0.62,-4,1.9/0;-1.21,-3,0.88;-1.5,-3,0.0;-2,-4,0.0;-1.62,-4,1.18/0;-1.5,-3,0.0;-1.21,-3,-0.88;-1.62,-4,-1.17;-2,-4,0.0/0;-1.21,-3,-0.88;-0.46,-3,-1.43;-0.62,-4,-1.9;-1.62,-4,-1.17/0;-0.46,-3,-1.43;0.46,-3,-1.43;0.62,-4,-1.9;-0.62,-4,-1.9/0;0.46,-3,-1.43;1.21,-3,-0.88;1.62,-4,-1.18;0.62,-4,-1.9/0;1.21,-3,-0.88;1.5,-3,0.0;2,-4,0.0;1.62,-4,-1.18/0;1.5,-3,0.0;1.21,-3,0.88;1.62,-4,1.17;2,-4,0.0/0;1.21,2.5,0.88;0.46,2.5,1.43;0.46,-3,1.43;1.21,-3,0.88/0;0.46,2.5,1.43;-0.46,2.5,1.43;-0.46,-3,1.43;0.46,-3,1.43/0;-0.46,2.5,1.43;-1.21,2.5,0.88;-1.21,-3,0.88;-0.46,-3,1.43/0;-1.21,2.5,0.88;-1.5,2.5,0.0;-1.5,-3,0.0;-1.21,-3,0.88/0;-1.5,2.5,0.0;-1.21,2.5,-0.88;-1.21,-3,-0.88;-1.5,-3,0.0/0;-1.21,2.5,-0.88;-0.46,2.5,-1.43;-0.46,-3,-1.43;-1.21,-3,-0.88/0;-0.46,2.5,-1.43;0.46,2.5,-1.43;0.46,-3,-1.43;-0.46,-3,-1.43/0;0.46,2.5,-1.43;1.21,2.5,-0.88;1.21,-3,-0.88;0.46,-3,-1.43/0;1.21,2.5,-0.88;1.5,2.5,0.0;1.5,-3,0.0;1.21,-3,-0.88/0;1.5,2.5,0.0;1.21,2.5,0.88;1.21,-3,0.88;1.5,-3,0.0/0;1.62,4,1.18;0.62,4,1.9;0.46,2.5,1.43;1.21,2.5,0.88/0;0.62,4,1.9;-0.62,4,1.9;-0.46,2.5,1.43;0.46,2.5,1.43/0;-0.62,4,1.9;-1.62,4,1.18;-1.21,2.5,0.88;-0.46,2.5,1.43/0;-1.62,4,1.18;-2,4,0.0;-1.5,2.5,0.0;-1.21,2.5,0.88/0;-2,4,0.0;-1.62,4,-1.17;-1.21,2.5,-0.88;-1.5,2.5,0.0/0;-1.62,4,-1.17;-0.62,4,-1.9;-0.46,2.5,-1.43;-1.21,2.5,-0.88/0;-0.62,4,-1.9;0.62,4,-1.9;0.46,2.5,-1.43;-0.46,2.5,-1.43/0;0.62,4,-1.9;1.62,4,-1.18;1.21,2.5,-0.88;0.46,2.5,-1.43/0;1.62,4,-1.18;2,4,0.0;1.5,2.5,0.0;1.21,2.5,-0.88/0;2,4,0.0;1.62,4,1.17;1.21,2.5,0.88;1.5,2.5,0.0/0;1.21,4.5,0.88;0.46,4.5,1.43;0.62,4,1.9;1.62,4,1.18/0;0.46,4.5,1.43;-0.46,4.5,1.43;-0.62,4,1.9;0.62,4,1.9/0;-0.46,4.5,1.43;-1.21,4.5,0.88;-1.62,4,1.18;-0.62,4,1.9/0;-1.21,4.5,0.88;-1.5,4.5,0.0;-2,4,0.0;-1.62,4,1.18/0;-1.5,4.5,0.0;-1.21,4.5,-0.88;-1.62,4,-1.17;-2,4,0.0/0;-1.21,4.5,-0.88;-0.46,4.5,-1.43;-0.62,4,-1.9;-1.62,4,-1.17/0;-0.46,4.5,-1.43;0.46,4.5,-1.43;0.62,4,-1.9;-0.62,4,-1.9/0;0.46,4.5,-1.43;1.21,4.5,-0.88;1.62,4,-1.18;0.62,4,-1.9/0;1.21,4.5,-0.88;1.5,4.5,0.0;2,4,0.0;1.62,4,-1.18/0;1.5,4.5,0.0;1.21,4.5,0.88;1.62,4,1.17;2,4,0.0/0;1.62,7,1.18;0.62,7,1.9;0.46,4.5,1.43;1.21,4.5,0.88/0;0.62,7,1.9;-0.62,7,1.9;-0.46,4.5,1.43;0.46,4.5,1.43/0;-0.62,7,1.9;-1.62,7,1.18;-1.21,4.5,0.88;-0.46,4.5,1.43/0;-1.62,7,1.18;-2,7,0.0;-1.5,4.5,0.0;-1.21,4.5,0.88/0;-2,7,0.0;-1.62,7,-1.17;-1.21,4.5,-0.88;-1.5,4.5,0.0/0;-1.62,7,-1.17;-0.62,7,-1.9;-0.46,4.5,-1.43;-1.21,4.5,-0.88/0;-0.62,7,-1.9;0.62,7,-1.9;0.46,4.5,-1.43;-0.46,4.5,-1.43/0;0.62,7,-1.9;1.62,7,-1.18;1.21,4.5,-0.88;0.46,4.5,-1.43/0;1.62,7,-1.18;2,7,0.0;1.5,4.5,0.0;1.21,4.5,-0.88/0;2,7,0.0;1.62,7,1.17;1.21,4.5,0.88;1.5,4.5,0.0/0;11.49,-5,3.46;10.57,-5,5.68;7.93,-1,4.26;8.62,-1,2.6/0;12.37,0,4.0;11.58,0,5.92;11.8,0.8,5.45;12.2,0.8,4.49/0;12.15,-1.6,4.61;11.86,-1.6,5.33;11.69,0,5.68;12.29,0,4.24/0;10.2,-5,6.31;8.74,-5,8.22;6.56,-1,6.16;7.65,-1,4.74/0;10.91,0,7.06;9.65,0,8.71;9.99,0.8,8.32;10.62,0.8,7.49/0;10.55,-1.6,7.6;10.07,-1.6,8.22;9.82,0,8.52;10.77,0,7.28/0;8.22,-5,8.74;6.32,-5,10.2;4.74,-1,7.65;6.17,-1,6.56/0;8.72,0,9.65;7.07,0,10.91;7.5,0.8,10.62;8.32,0.8,9.99/0;8.22,-1.6,10.07;7.6,-1.6,10.54;7.28,0,10.77;8.52,0,9.82/0;5.68,-5,10.57;3.47,-5,11.49;2.6,-1,8.62;4.26,-1,7.93/0;5.92,0,11.57;4.0,0,12.37;4.49,0.8,12.2;5.45,0.8,11.8/0;5.34,-1.6,11.85;4.61,-1.6,12.15;4.25,0,12.29;5.69,0,11.69/0;2.75,-5,11.68;0.37,-5,11.99;0.28,-1,9.0;2.06,-1,8.76/0;2.73,0,12.71;0.67,0,12.98;1.18,0.8,12.95;2.22,0.8,12.81/0;2.08,-1.6,12.83;1.31,-1.6,12.93;0.93,0,12.97;2.47,0,12.76/0;-0.37,-5,11.99;-2.74,-5,11.68;-2.06,-1,8.76;-0.28,-1,9.0/0;-0.66,0,12.98;-2.72,0,12.71;-2.21,0.8,12.81;-1.17,0.8,12.95/0;-1.3,-1.6,12.93;-2.08,-1.6,12.83;-2.46,0,12.76;-0.92,0,12.97/0;-3.46,-5,11.49;-5.67,-5,10.57;-4.25,-1,7.93;-2.59,-1,8.62/0;-3.99,0,12.37;-5.92,0,11.58;-5.45,0.8,11.8;-4.49,0.8,12.2/0;-4.61,-1.6,12.16;-5.33,-1.6,11.86;-5.68,0,11.69;-4.24,0,12.29/0;-6.31,-5,10.2;-8.21,-5,8.75;-6.16,-1,6.56;-4.74,-1,7.65/0;-7.06,0,10.92;-8.71,0,9.65;-8.32,0.8,9.99;-7.49,0.8,10.63/0;-7.6,-1.6,10.55;-8.22,-1.6,10.07;-8.51,0,9.82;-7.28,0,10.77/0;-8.74,-5,8.22;-10.2,-5,6.32;-7.65,-1,4.74;-6.55,-1,6.17/0;-9.64,0,8.72;-10.91,0,7.07;-10.62,0.8,7.5;-9.99,0.8,8.32/0;-10.07,-1.6,8.22;-10.54,-1.6,7.61;-10.76,0,7.29;-9.82,0,8.52/0;-10.57,-5,5.68;-11.49,-5,3.47;-8.62,-1,2.6;-7.93,-1,4.26/0;-11.57,0,5.92;-12.37,0,4.01;-12.2,0.8,4.5;-11.8,0.8,5.46/0;-11.85,-1.6,5.34;-12.15,-1.6,4.62;-12.28,0,4.25;-11.69,0,5.69/0;-11.68,-5,2.75;-11.99,-5,0.38;-9.0,-1,0.28;-8.76,-1,2.07/0;-12.71,0,2.73;-12.98,0,0.67;-12.95,0.8,1.19;-12.81,0.8,2.22/0;-12.83,-1.6,2.09;-12.93,-1.6,1.32;-12.97,0,0.93;-12.76,0,2.47/0;-11.99,-5,-0.36;-11.68,-5,-2.74;-8.76,-1,-2.05;-9.0,-1,-0.27/0;-12.98,0,-0.65;-12.71,0,-2.71;-12.81,0.8,-2.2;-12.95,0.8,-1.17/0;-12.93,-1.6,-1.3;-12.83,-1.6,-2.08;-12.77,0,-2.46;-12.97,0,-0.91/0;-11.49,-5,-3.46;-10.58,-5,-5.67;-7.93,-1,-4.25;-8.62,-1,-2.59/0;-12.37,0,-3.99;-11.58,0,-5.91;-11.8,0.8,-5.45;-12.2,0.8,-4.48/0;-12.16,-1.6,-4.6;-11.86,-1.6,-5.32;-11.69,0,-5.68;-12.29,0,-4.24/0;-10.21,-5,-6.31;-8.75,-5,-8.21;-6.56,-1,-6.16;-7.66,-1,-4.73/0;-10.92,0,-7.06;-9.66,0,-8.7;-10.0,0.8,-8.31;-10.63,0.8,-7.49/0;-10.55,-1.6,-7.59;-10.08,-1.6,-8.21;-9.83,0,-8.51;-10.78,0,-7.27/0;-8.23,-5,-8.74;-6.33,-5,-10.2;-4.74,-1,-7.65;-6.17,-1,-6.55/0;-8.72,0,-9.64;-7.07,0,-10.91;-7.5,0.8,-10.62;-8.33,0.8,-9.98/0;-8.23,-1.6,-10.06;-7.61,-1.6,-10.54;-7.29,0,-10.76;-8.53,0,-9.81/0;-5.69,-5,-10.57;-3.47,-5,-11.49;-2.6,-1,-8.62;-4.26,-1,-7.93/0;-5.93,0,-11.57;-4.01,0,-12.37;-4.5,0.8,-12.2;-5.46,0.8,-11.8/0;-5.34,-1.6,-11.85;-4.62,-1.6,-12.15;-4.26,0,-12.28;-5.7,0,-11.68/0;-2.76,-5,-11.68;-0.38,-5,-11.99;-0.29,-1,-9.0;-2.07,-1,-8.76/0;-2.73,0,-12.71;-0.67,0,-12.98;-1.19,0.8,-12.95;-2.22,0.8,-12.81/0;-2.09,-1.6,-12.83;-1.32,-1.6,-12.93;-0.93,0,-12.97;-2.48,0,-12.76/0;0.36,-5,-11.99;2.74,-5,-11.68;2.05,-1,-8.76;0.27,-1,-9.0/0;0.65,0,-12.98;2.71,0,-12.72;2.2,0.8,-12.81;1.17,0.8,-12.95/0;1.3,-1.6,-12.93;2.07,-1.6,-12.83;2.45,0,-12.77;0.91,0,-12.97/0;3.45,-5,-11.49;5.66,-5,-10.58;4.25,-1,-7.93;2.59,-1,-8.62/0;3.99,0,-12.37;5.91,0,-11.58;5.44,0.8,-11.81;4.48,0.8,-12.2/0;4.6,-1.6,-12.16;5.32,-1.6,-11.86;5.68,0,-11.7;4.23,0,-12.29/0;6.31,-5,-10.21;8.21,-5,-8.75;6.16,-1,-6.56;4.73,-1,-7.66/0;7.05,0,-10.92;8.7,0,-9.66;8.31,0.8,-10.0;7.49,0.8,-10.63/0;7.59,-1.6,-10.55;8.21,-1.6,-10.08;8.51,0,-9.83;7.27,0,-10.78/0;8.74,-5,-8.23;10.19,-5,-6.33;7.65,-1,-4.75;6.55,-1,-6.17/0;9.64,0,-8.72;10.91,0,-7.08;10.61,0.8,-7.51;9.98,0.8,-8.33/0;10.06,-1.6,-8.23;10.54,-1.6,-7.61;10.76,0,-7.29;9.81,0,-8.53/0;10.57,-5,-5.69;11.49,-5,-3.47;8.61,-1,-2.61;7.92,-1,-4.27/0;11.57,0,-5.93;12.37,0,-4.01;12.19,0.8,-4.51;11.8,0.8,-5.46/0;11.85,-1.6,-5.35;12.15,-1.6,-4.63;12.28,0,-4.26;11.68,0,-5.7/0;11.68,-5,-2.76;11.99,-5,-0.39;9.0,-1,-0.29;8.76,-1,-2.07/0;12.71,0,-2.74;12.98,0,-0.68;12.95,0.8,-1.19;12.81,0.8,-2.23/0;12.83,-1.6,-2.1;12.93,-1.6,-1.32;12.97,0,-0.94;12.76,0,-2.48/0;11.99,-5,0.35;11.68,-5,2.73;8.76,-1,2.05;9.0,-1,0.27/0;12.98,0,0.64;12.72,0,2.71;12.81,0.8,2.19;12.95,0.8,1.16/0;12.94,-1.6,1.29;12.84,-1.6,2.07;12.77,0,2.45;12.97,0,0.91]]

bin_colors = {
    [1] = split("2,2,2,2,2,2,2,2,4,4,4,4,4,4,4,4,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10"),
    [2] = split("2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,8,8,14,14,14,14,14,14,14,14,14,14,14,14,14,14"),
}
-- turn into ints and string em
bin_patterns = split("32735.5,24415.5,23130.5,18970.5,2570.5,516.5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0")

---- GLOBALS ----
tf = 0
pulse_t = 0
last_music_timing = 0
on_beat = nil
recolor={1,1,13,1,13,1,13,7,0,12,12,12,12,12,12,12}
total_enemies = 0
enemies_killed = 0
score = 0

---- TRI FILL ----
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

function m_rot_xyz(a,b,c)
    sina, cosa, sinb, cosb, sinc, cosc = sin(a), cos(a), sin(b), cos(b), sin(c), cos(c)
    return {
        cosb * cosa, sinc * sinb * cosa - cosc * sina, cosc * sinb * cosa + sinc * sina, 0,
        cosb * sina, sinc * sinb * sina + cosc * cosa, cosc * sinb * sina - sinc * cosa, 0,
        -sinb, sinc * cosb, cosc * cosb, 0,
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
            sfx(10)
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
        --dying = false,
        die_time = 0,
        die_offset = {0,0,0},
        die_extra_time = 0,
        visible = true,
        score = 200,
        entgrid_pos = nil,
    }
    e.compute_transform = function()
        e.transform = m_rot_xyz(e.angles[1], e.angles[2], e.angles[3])
        e.transform[4], e.transform[8], e.transform[12] = e.pos[1], e.pos[2], e.pos[3]
    end
    e.hurt = function(poly)
        sfx(9)
        e.health -= 1
        if e.health <= 0 and not e.dying then
            e.dying = true
            enemies_killed += 1
            score += e.score
        end
    end
    e.base_update = function()
        if e.dying then
            
            if e.die_time % 5 == 0 then
                local rpart = flr(rnd(#e.parts)) + 1
                local rpol = flr(rnd(#e.parts[rpart].polys)) + 1
                circle_make(v_add(e.parts[rpart].polys[rpol].world_center, vec(rnd(2)-1,rnd(2)-1,rnd(2)-1)), 7, 2)
            end
            if e.die_time > 50 + e.die_extra_time then
                del(ents, e)
                need_entgrid_generation = true
            end            
            e.die_time += 1
        end
    end
    return e
end

num_transform_updates = 0
function update_internal_transforms(e)
    for p in all(e.parts) do
        local m = e.transform
        local m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12
        if e.dirty or p.dirty then
            if p.transform.is_identity then
                p.world_transform = e.transform
                m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12 = m[1],m[2],m[3],m[4],m[5],m[6],m[7],m[8],m[9],m[10],m[11],m[12]
            else
                p.world_transform = mm(e.transform, p.transform)
                m = p.world_transform
                m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12 = m[1],m[2],m[3],m[4],m[5],m[6],m[7],m[8],m[9],m[10],m[11],m[12]
            end
            for poly in all(p.polys) do
                local x,y,z = poly.center[1],poly.center[2],poly.center[3]
                local x2 = m1 * x + m2 * y + m3 * z + m4
                local y2 = m5 * x + m6 * y + m7 * z + m8
                local z2 = m9 * x + m10 * y + m11 * z + m12
                poly.world_center = {x2,y2,z2,1}
                local x,y,z = poly.normal[1],poly.normal[2],poly.normal[3]
                local x3 = m1 * x + m2 * y + m3 * z
                local y3 = m5 * x + m6 * y + m7 * z
                local z3 = m9 * x + m10 * y + m11 * z
                poly.world_normal = {x3, y3, z3}

                num_transform_updates += 1
            end
        end
        p.dirty = false
    end
    e.dirty = false
end

entgrid = {}
egsize = 5
egbounds = 200
function generate_entgrid()
    entgrid = {}
    for i = -egbounds, egbounds do
        entgrid[i] = {}
    end
    for e in all(ents) do
        local pos = e.entgrid_pos or e.pos
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
        --pattern = nil,
        target = target or false,
        --selected = false,
        die_time = 0,
        show_back = backface,
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


pointlist_cache = {}
function render_transform_pointlist(t, pts, i)
    local results = {}
    for p in all(pts) do
        local cache_key = p[1]..","..p[2]..","..p[3]..","..i
        if not pointlist_cache[cache_key] then
            local pta = mv(t, p)
            local ptb = {pta[1] / pta[4], pta[2] / pta[4], pta[3] / pta[4], 1}
            if ptb[3] < -1 or ptb[3] > 1 or ptb[1] < -1.75 or ptb[1] > 1.75 or ptb[2] < -1.75 or ptb[2] > 1.75 then
                return nil
            else
                local result = {ptb[1] * 64 + 64, ptb[2] * 64 + 64, ptb[3], 1}
                pointlist_cache[cache_key] = result
                add(results, result)
            end        
        else
            add(results, pointlist_cache[cache_key])
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
    local polycap = 60
    -- Initialize empty bins

    local i = 0
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
                    if num_polys >= polycap then break end
                    local norm = p.world_normal
                    
                    local delta = v_sub(p.world_center, camera.pos)
                    
                    local dot = delta[1] * norm[1] + delta[2] * norm[2] + delta[3] * norm[3]
                    if p.show_back or e.deadly or dot < 0 and p.die_time < 20 then
                        local dist = v_mag(delta)
                        local bin = 32 - clamp(flr(dist), 0, 31)
                        local poly2d = render_transform_pointlist(trans, p.points, i)
                        
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
                            num_polys += 1
                        end
                    end
                end
                if num_polys >= polycap then break end
            end
            if num_polys >= polycap then break end
        end
        i += 1
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

function make_crown_boss(pos)
    total_enemies += 1
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
    e.die_extra_time = 150
    e.hurt_time = 50
    e.score = 2000
    e.target_pos = {e.pos[1], e.pos[2], e.pos[3], 1}
    e.update = function() 
        local zdiff = abs(camera.pos[3] - z)
        if zdiff < 15 and not e.dying then
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
                need_entgrid_generation = true
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
        if e.die_time > 90 then del(sprites, e.eye); transitioning = true; boss=false; transition_time = 0; won=true end
        e.compute_transform()
        update_internal_transforms(e)
        
    end
    e.compute_transform()
    update_internal_transforms(e)
    add(ents, e)
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
    e.score = 50
    total_enemies += 1
    
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
    need_entgrid_generation = true
    return e
end

function make_artillery(pos, height)
    local e = deserialize_entity(enemy_artillery)
    total_enemies += 1
    e.score = 500
    height = height or 3

    for poly in all(e.parts[3].polys) do
        for pt in all(poly.points) do
            pt[2] += (height - 3)
        end
        poly.center[2] += (height - 3)
    end
    for poly in all(e.parts[2].polys) do
        for pt in all(poly.points) do
            if pt[2] == 3 then pt[2] += (height - 3) end
        end
        --poly.center[2] += (height - 3)
    end      


    local pi2 = 3.14159 / 2
    e.time = 0
    e.next_angle = pi2 + pi2/2
    e.current_angle = pi2/2
    e.i = 0
    e.last_frame_angle = 0
    
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
        
        if e.i < 58 then       
            e.i += 1 
        else
            if on_beat and on_beat % 4 == 0 then
                e.current_angle += pi2
                e.next_angle = e.current_angle + pi2
                e.i = 0
            end
        end
        local angle = sin(e.i / 58 * pi2) ^ 6 * pi2 + e.current_angle
        if abs(angle - e.last_frame_angle) > 0.02 then
            e.parts[3].transform = m_rot_y(angle)
            e.parts[3].dirty = true
            update_internal_transforms(e)
            e.last_frame_angle = angle
        end
        

        if zdiff > -22 and zdiff < -5 then
            e.time += 1
            if e.time % 380 == 20 then
                make_missile({e.pos[1],e.pos[2] + height,e.pos[3]}, vec(0,2,0))
                need_entgrid_generation = true
            end
        end
        
    end
    e.pos = pos
    e.health = 4
    e.compute_transform()
    add(ents,e)   
    update_internal_transforms(e)
end

function make_minion(pos, targetxy, vel, killer, spawn_zdiff)
    total_enemies += 1
    spawn_zdiff = spawn_zdiff or 22
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
        if zdiff > spawn_zdiff then return end
        e.visible = true
        e.time += 1
        local target = e.targetxy
        if e.time < 50 then
            target = {e.targetxy[1] + (e.targetxy[1] - pos[1]) * 2,e.targetxy[2] + (e.targetxy[2] - pos[2]) * 2,0}
        end
        local delta = {target[1] - e.pos[1], target[2] - e.pos[2], 0}
        local velsq = e.vel[1] * e.vel[1] + e.vel[2] * e.vel[2]
        if velsq > .01 or abs(delta[1]) + abs(delta[2]) > 0.1 or (e.killer and zdiff < 12) then
            local dist = abs(delta.z)
            local dir = v_norm(delta)
            e.vel = v_add(e.vel, v_mul(dir, 0.01 + clamp(e.time-40,0,20) / 10000 * dist))--0.04 / max(dist,0.5) * (dist / 10)))
            e.vel = v_mul(e.vel, 0.95 - min(e.time,20) / 2000)
            e.vel = v_limit(e.vel, 1)
            if zdiff < 11 then
                e.vel[3] = 0.05
            end                        
            e.pos = v_add(e.pos, e.vel)
            local q = sin(clamp(-e.vel[1], -1,1))
            e.angles[3] = q
            e.angles[2] = -q
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
    end
    e.compute_transform()
    update_internal_transforms(e)
    add(ents, e)
    return e
end

function make_enemies()
    
    for i = 0,3 do 
        make_minion({5,-2,30 - i * 0.5,1}, {-5 + i * 3.33,1,0}, {0,0.25,0}, i == 0)
    end
    for i = 0,3 do 
        make_minion({-5,2,24 - i * 0.5,1}, {5 - i * 3.33,-1,0}, {0,0.25,0}, i == 0)
    end    
    for i = 0,5 do
        local theta = i / 6 * 6.2818
        make_minion({0,-4,15 - i * 0.5,1}, {cos(theta) * 3,sin(theta) * 3,0}, {0,0.25,0}, i == 0, 20)
    end
    
    make_artillery({6, -3, 0,1}, 2)
    make_artillery({-6, -3, -6,1}, 3)
    
    for i = 0,7 do
        local theta = i / 8 * 6.2818
        make_minion({cos(theta) * 10,sin(theta) * 10, -18 - i % 4 * 4, 1}, {cos(theta + 3.14159) * 4.5,sin(theta + 3.14159) * 4.5,0}, {sin(theta) * 0.3,-cos(theta) * 0.3,0}, i < 4, 18)
    end    

    make_artillery({3, -3, -40,1}, 3.5)
    make_artillery({-3, -3, -40,1}, 6.5)

    for i = 0,3 do
        make_minion({10, 7, -50 - i, 1}, {-20, -14,0}, {0,-0.25,0}, false, 15)
        make_minion({-10, 7, -55 - i, 1}, {20, -14,0}, {0,0.25,0}, false, 15)
    end    

    make_crown_boss({0,1,-70,1})
    need_entgrid_generation = true
end

function init_level()
    for i = -100, 100 do
        local e = ent()
        local polys = {}
        for j = -1,1, 2 do
            local pol = poly({
                vec(-1 + j * 1.25 + i % 2 - 0.5, -3, 0.5 + i * 2),
                vec(1 + j * 1.25 + i % 2 - 0.5, -3, 0.5 + i * 2),
                vec(1 + j * 1.25 + i % 2 - 0.5, -3, -0.5 + i * 2),
                vec(-1 + j * 1.25 + i % 2 - 0.5, -3, -0.5 + i * 2),
            })
            --pol.pattern = 0b0011000011000000.1
            add(polys, pol)    
        end
        e.parts = {part(polys, m_identity())}
        e.update = function()
            local zdiff = abs(e.pos[3] - camera.pos[3])
            if zdiff < 10 then
                if pulse_t < 6 then
                    e.parts[1].polys[1].pattern = 0b0011000011000000.1
                    e.parts[1].polys[2].pattern = 0b0011000011000000.1
                else
                    e.parts[1].polys[1].pattern = 0b1100111100111111.1
                    e.parts[1].polys[2].pattern = 0b1100111100111111.1
                end
            else
                    e.parts[1].polys[1].pattern = nil
                    e.parts[1].polys[2].pattern = nil
            end
        end
        
        e.static = true
        e.pos = {0,-3,i * 2,1}
        e.entgrid_pos = {0,-3,i * 2,1}
        add(ents, e)
        update_internal_transforms(e)
    end
    
    generate_entgrid()
end

function start_game()
    intro = false
    ents = {}
    --circles = {}
    --lasers = {}
    sprites = {}
    transitioning = true
    transition_index = 1
    tf = 0

    music(2,1000,3)
end

function _init()
    music(0,1000,3)
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
        health = 3,
        hit_time = 100,        
    }

    local e = deserialize_entity(intro_ent)
    local count = 10
    function azv(theta, rad, y)
        return {cos(theta) * rad, y, sin(theta) * rad, 1}
    end
    local patterns = {0b0, 0b0000111100001111.1, 0b0111101111011110.1, 0b0000111100001111.1, 0b0, 0b0}
    for i = 1, 6 do
        for j = 1, count do
            e.parts[1].polys[(i-1) * 10 + j].pattern = patterns[i]
            p.pattern = patterns[i]
        end
    end
    count = 24
    for j = 1, count do
        e.parts[1].polys[58 + j * 3].pattern = 0b0101010101010101.1     
        add(sprites, sprite(azv((j + 0.5) / 24 * 6.2818, 13, 0.2),43 + flr(rnd(4)), 1,1))
    end    
    e.static = true
    e.entgrid_pos = {0,0,0,1}
    add(ents, e)
    update_internal_transforms(e)
    generate_entgrid()
    
end

function take_damage(source)
    player.hit_time = 0
    player.health -= 1
    score -= 500
end

function update_player()
    camera.pos = v_sub(camera.pos, vec(0,0,speed))
    if player.hit_time < 20 and player.hit_time % 5 == 0 then
        for i = 0, 2 do
            circle_make({camera.pos[1] + rnd(2) - 1,camera.pos[2] + rnd(2) - 1,camera.pos[3] - 3,1}, 7, 2)
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
        if btnp(5) and not player.selecting then sfx(12) end
        if not btn(5) and player.selecting then sfx(13) end
        player.selecting = btn(5)
        if not player.selecting and #player.selected > 0 then
            score += 2 ^ #player.selected
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
        pulse_t = 0
    end
    if beat % 1 == 0 then
        if #player.selected_chimes > 0 then
            sfx(8, -1, (#player.selected - 1) * 4, 2)
            deli(player.selected_chimes, 1)
        end
    end
end

intro = true
transitioning = false
transition_time = 0
transition_index = 0
speed = 0.02
need_entgrid_generation = true
fov = 90
boss = false
function _update()
    if ((won and won_time > 320) or player.health <= 0) and btnp(5) then
        run()
    end
    if player.health <= 0 then return end
    if transitioning then
        if transition_index == 1 and transition_time == 30 then
            camera.pos = {0,0,59,1}
            --camera.pos = {0,0,-5,1} -- artil2
            --camera.pos = {0,0,-54,1} -- crown boss
            init_level()
        end
        speed = 0.1 + (transition_index-1) / 4
        fov = max(fov - 0.25, 60)
        transition_time += 1
        if transition_time > 60 then
            transitioning = false
            transition_time = 0
            if transition_index == 1 then make_enemies() end
            transition_index += 1
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

    --camera.fwd = mv(m_rot_xyz(-camera.angles[1], -camera.angles[2], 0), vec(0,0,-1))
    camera.fwd = mv(mm(m_rot_y(-camera.angles[2]), m_rot_x(-camera.angles[1])), vec(0,0,-1))
    camera.view_mat = m_look(camera.fwd, vec(0,1,0))
    
    
    for e in all(get_visible_ents(camera.pos)) do
        if e.pos[3] < camera.pos[3] then
            if e.base_update then e.base_update() end
            if e.update then e.update() end
        end
    end
    for c in all(circles) do c.update() end
    for jl in all(jlasers) do jl.update() end

    update_player()
    
    if intro then
        if btnp(5) then
            start_game()
            sfx(11)
        end
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
    local c1 = 1
    
    local sy = final_point(t, v_add(camera.pos, vec(0,0,-50)))[2]
    for z = 0, 15 do
        local bha = z / 16 * 6.2818
        local y = background_heights[z + 1] * 4 + sy
        local deltabha = angledelta(camera.angles[2], bha)
        local x = 64 + deltabha * 72

        local yz3 = ((z) % 3) * 5 - ((pulse_t / 20) ^ 2 * sin(z * 2 + tf / 350) ^ 4) * 2
        fillp(0b0010000001000000)
        rectfill(x - 16, y + yz3 + 14, x + 16, y + 75, c1)        
        
        rectfill(x - 12, y + yz3 + 8, x + 12, y + 75, c1)
        for i = -2, 2 do
            rectfill(x + 4 * i - 2, y + yz3 + 5, x + 4 * i, y + 60, c1)
        end
        rectfill(x - 1, y + yz3 + 10, x + 1, y + yz3 + 15, 0)

        
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
    print("❎ to start\n\n\n\n\n\n\n\n\n\n\n\-c⬆️⬇️⬅️➡️:aim\n\-0hold ❎: target\n\-0let go ❎: fire", 82, 42, 7)
end

function draw_game_ui()
    if player.health <= 0 then
        print(" ...deleted...\n\n❎ to try again", 36, 33, 0)
        print(" ...deleted...\n\n❎ to try again", 36, 32, 8)
        return
    end
    local ss = "- "..score.." -"
    print(ss, 64 - #ss * 2, 2, 12) 

    for i = 0, 2 do
        local si = 48
        if player.health > i then
            si = 50
            if pulse_t < 4 then si = 52 end
        end
        spr(si, i * 18 + 38, 119, 2, 1)
    end
end

won = false
won_time = 0

function _draw()
    pointlist_cache = {}
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

    if won and not transitioning then
        won_time += 1
        local shutdown = flr(enemies_killed / total_enemies * 100)
        local winstr = "area complete!\n\narea analyzed: 100%\nshut down: "..shutdown.."%\nscore: "..score.."\n\n❎ to play again"
        print(sub(winstr, 0, won_time \ 4 + 1), 30,30,7)
        print(sub(winstr, 0, won_time \ 4), 30,30,12)
        boss = true
    end

    num_transform_updates = 0
end
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

