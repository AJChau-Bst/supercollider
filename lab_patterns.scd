(
SynthDef(\ping, {
      arg outBus = 0, freq = 440, amp = 0.1, atk = 0.01,
      sus = 0.1, rel = 0.1, pos = 0;
      var sig, env, numSines = 8;

      sig = SinOsc.ar(freq, mul: amp);

      env = EnvGen.kr(Env.linen(atk, sus, rel), doneAction: 2);

      sig = sig * env;
      sig = Pan2.ar(sig, pos);

      Out.ar(outBus, sig);
}).add;

SynthDef(\pulse, {
      arg outBus = 0, freq = 440, width = 0.5, amp = 0.1, atk = 0.01, dec = 0.1,
      sLevel = 0.9, rel = 0.1, gate = 1, pos = 0, cutoff = 3000;
      var sig, env;

      sig = Pulse.ar(freq, width, amp);
      sig = MoogFF.ar(sig, cutoff);
      env = EnvGen.kr(Env.adsr(atk, dec, sLevel, rel), gate, doneAction: 2);

      sig = sig * env;
      sig = Pan2.ar(sig, pos);

      Out.ar(outBus, sig);
}).add;
)





y = Synth(\ping);
z = Synth(\pulse);
z.set(\gate, 0);
CmdPeriod.run;

(
var bpm = 66;
~clock = TempoClock(bpm/60);
)

(
~eventPlayer = Pbind(
	\instrument, \ping, // set the instrument
	\midinote, Pseq([69,71,72],inf), // set the time in seconds between each instrument created
	\dur, 0.5,
	\amp, 0.3,
).play

)

(
~eventPlayer = Pbind(
	\instrument, \ping, // set the instrument
	\midinote, Pseq([71,73,74,76,78],inf), // set the time in seconds between each instrument created
	\dur, Pseq([1, 0.25, 0.5, 0.25], inf),
	\amp, Pwhite(0.1, 0.2),
).play

)

(
var bpm = 66;
~clock = TempoClock(bpm/60);
Pbindef(\eventPlayer,
	\instrument, \ping, // set the instrument
	\midinote, Pseq([71,73,74,76,78],inf), // set the time in seconds between each instrument created
	\dur, Pseq([1, 0.25, 0.5, 0.25], inf),
	\amp, Pwhite(0.1, 0.2),
	\ctranspose, 0,
).play(~clock);
)


Pbindef(\eventPlayer, \midinote, Pseq([69, 73, 74, 76, 78, 80],inf));
Pbindef(\eventPlayer, \ctranspose, -12);
Pbindef.clear





(
~orangepulp = Pbind(
    \instrument, \pulse,
	\midinote, Pseq([60, 63, 65],inf),
	\dur, Pseq([1,1,1],inf),
	\pan, Pwhite(),
).play;
)



(
var bpm = 66;
~clock = TempoClock(bpm/60);
Pbindef(\orangee,
	\instrument, \pulse, // set the instrument
	\midinote, Pseq([60, 63, 65, 66, 65, 58],inf), // set the time in seconds between each instrument created
	\dur, Pseq([0.5,0.5,0.25,1.75, 1], inf),
	\amp, Pwhite(0.1, 0.2),
	\ctranspose, 0,
).play(~clock);
)