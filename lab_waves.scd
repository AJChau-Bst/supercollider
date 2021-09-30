"4".dup(2);
"true".dup(4);
{|x| x + 1}.dup(4);
{|x = 1| x ** 2}.dup(6);
{arg x; x = x+1; x**2}.dup(5);



{Saw.ar(440,0.1) + LFTri.ar(880,0.1)}.play;

{Pulse.ar([100,100],0.1)}.play;

{Pulse.ar(freq: 200.0, width: 0.75, mul: 0.1) + LFTri.ar(400, 0.1)}.play;

s.scope;
CmdPeriod.run
