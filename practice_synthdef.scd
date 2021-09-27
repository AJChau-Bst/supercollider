// Your code here

SynthDef(\sineTri, {
	arg freq = 440, amp = 0.1, blend;
	var sine, tri, sig

	sine = SinOsc.ar(freq);
	tri = LFTri.ar(freq);
	XFade2.ar(sin, tri, pan: 0.0, level: 1.0)

	Out.ar(0, sig * amp ! 2)

}).add


//Groups

~group1 = Group(s);
~group2 = Group(s);
Synth(\sineArgs, [\freq], ~group1);
Synth(\sineArgs, [\freq], ~group2);
Synth(\sineArgs, [\freq], ~group2);