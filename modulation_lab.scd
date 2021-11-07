(
SynthDef(\mod, {
	(SinOsc.ar(freq: 400.0) * SinOsc.ar(freq: 200.0)!2);
}).play;