{SinOsc.ar(440.0,0,[0,0.1])}.play;
CmdPeriod.run;

{SinOsc.ar(440.0,0,[0.05,0.05])}.play;
{[{SinOsc.ar(440.0,0,0.05)},{SinOsc.ar(440.0,0,0.05)}]}.play;
{SinOsc.ar([440,440],[0,0],[0.05,0.05])}.play;

{SinOsc.ar([300,600],0,0.1)}.play;

[1,2] + [3,4]
[3,4] + 1
[0,2] + (1!2)
[0,1] + 1 ! 2
[1,2] * 3 + [4,1]
[4,1] + [2,3] * 3

// Amplitude = .4, Freq 440, Phase 0, Stero Sound

(
var phase = 0;
{
  var sig = SinOsc.ar(440, 0, 0.1) + SinOsc.ar(440, phase, 0.1);
  [sig, sig]
}.play;
)