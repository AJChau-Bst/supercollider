//Write a SynthDef called \saw that simply plays back a sawtooth wave with the following default arguments: outBus = 0, freq = 440, amp = 0.1. Your code should use the UGen Saw and should playback the sawtooth wave in stereo. Write an additional line to play the synth and then another to free it.

(
SynthDef(\saw, {
	arg freq = 440, amp = 0.1;
	Saw.ar(freq, amp)!2
}).play
)
CmdPeriod.run;