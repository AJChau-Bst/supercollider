/*
PROBLEM SET FIVE
--------------------------------------------------
NAME: Annette Chau
ID:
HOURS TO COMPLETE: incomplete
KEY: 0x54EFEA14
*/

/*************
 * EXERCISES *
 *************/

/*
 * EXERCISE 1: Create an octavizer that takes some frequency and produces a sine wave
 * of that frequency and a sine wave of twice that frequency.  You must use ring
 * modulation to arrive at your answer.
 */

(
SynthDef(\octavizer, {
	arg freq = 440, amp = 0.1;
	var ring = SinOsc.ar(3* freq/2, mul: amp) * SinOsc.ar(freq/2, mul:amp);
	Out.ar(0, ring);
}).add;
)

FreqScope.new;
~oct = Synth(\octavizer, [\freq, 440]);
~oct.set(\freq, 300);
CmdPeriod.run


/*
 * EXERCISE 2: choose one of the FM synthdefs from lecture or this assignment and
 * create a short snippet of music using three patterns on a TempoClock.
 * BE CREATIVE!
 */

//Harp Sound
(
SynthDef(\fmEnv, {
  arg out = 0, freq = 400, modIndex = 1, harmRatio = 1, atk = 0.05,
  rel = 1.5, amp = 0.6;
  var car, mod, freq_m, k_f, env;

  freq_m = harmRatio * freq;
  k_f = modIndex * freq_m;
  mod = SinOsc.ar(freq_m, 0, k_f);
  car = SinOsc.ar(freq + mod, 0, 1);
  env = Env.perc(atk, rel, amp);
  env = EnvGen.kr(env, doneAction: 2);
  Out.ar(out, car * env ! 2);
}).add;
)

~clock = TempoClock(120/60);
(
Synth(\fmEnv, [
  \modIndex, 2,
  \harmRatio, 3,
  \freq, 1200,
  \atk, 0.01,
  \rel, 1,
  \amp, 0.6
]);
)

//[77, 80, 84]
//Pshuf (shuffles a list)
(
Pbind(
  \instrument, \fmEnv,
  \dur, 1,
  \midinote, Pseq([[48, 51, 55], [50, 53, 56], [51, 55, 58]], inf)
).play(~clock, quant:1);
)

(
Pbind(
  \instrument, \fmEnv,
  \dur, 0.33,
  \midinote, Pseq([72, 75, 79], inf),
  \modIndex, Pseq([1,2,3,4,5,6,7,8,9,10])
).play(~clock, quant:1);
)

(
Pbind(
  \instrument, \fmEnv,
  \dur, 5,
  \midinote, Pxrand([84, 86, 87, 89, 91, 92, 94, 96],inf)
  \amp, 2
).play(~clock, quant:1);
)

(
Pbind(
  \instrument, \fmEnv,
  \dur, 1,
  \midinote, Pshuf([[60, 63, 67], [62, 65, 68], [63, 67, 70]],inf)
  \amp, 2
).play(~clock, quant:1);
)



/**************
 * DX7 Bass 1 *
 **************/

/* Description of the arguments to \bass1
 * - freq: the frequency heard.  All oscillator frequencies are ratios of this frequency.
 * - amp: the overall amplitude of the sound
 * - gate: used to trigger the onset and release of the amplitude envelope for *just* oscillator 1
 * - atkTime: the attack time for the envelope of *just* oscillator 1
 * - decTime: the decay time for the envelope of *just* oscillator 1
 * - susLvl: the sustain level for the envelope of *just* oscillator 1
 * - relTime: the release time for the envelope of *just* oscillator 1
 */

//(
//s.options.sampleRate = 48000;
//s.options.inDevice = "MME : Microphone Array (AMD Audio Dev";
//s.options.outDevice = "MME : Speakers (Realtek(R) Audio)";
//s.reboot;
//)
(
SynthDef(\bass1, {
	arg freq = 130.81, amp = 0.8, gate = 1, atkTime = 0.001, decTime = 0.05, susLvl = 0.3, relTime = 0.1;

	// I recommend using these variables for each part of the SynthDef
	var osc1, osc2, osc3, osc4, osc5, osc6;
	var env1, env2, env3, env4, env5, env6;


	env1 = EnvGen.kr(Env.adsr(atkTime, decTime, susLvl, relTime));
	env2 = EnvGen.kr(Env([1,0],[5]));
	env3 = EnvGen.kr (Env([0.6, 0],[0.5]));
	env4 = EnvGen.kr(Env([1, 0.8],[0.3]));
	env5 = EnvGen.kr(Env([1, 0],[7]));
	env6 = EnvGen.kr(Env([1, 0.2],[0.1]));

	osc2 = SinOsc.ar(freq * 0.5) * env2 * 1.5;
	osc4 = SinOsc.ar(freq * 5) * env4;
	osc3 = SinOsc.ar(freq * 0.5, osc4) * env3;
	osc6 = SinOsc.ar(freq * 9, SinOscFB.ar(feedback:7)) * env6;
	osc5 = SinOsc.ar(freq * 0.5, osc6) * env5;
	osc1 = SinOsc.ar(freq, osc2 + osc3 + osc5) * env1;
	Out.ar(0, osc1);
}).add;
)

~test = Synth(\bass1, [\freq, 130.81/2])
~test2 = Synth(\bass1, [\freq, 500])
~test.set(\gate, 0);
s.meter
~test.free
s.freeAll

// Execute once to connect with a MIDI keyboard.  You should be able to play and hear the SynthDef.

(
var notesDict = Dictionary.new;
MIDIClient.init;
MIDIIn.connectAll;

MIDIdef.noteOn(\adsrOn, {
  |vel, num, chan, src|
  var synth = Synth(\bass1, [\freq, num.midicps, \amp, vel.linexp(0, 127, 0.6, 1.0)]);
  notesDict[num] = synth;
});

MIDIdef.noteOff(\adsrOff, {
  |vel, num, chan, src|
  var synth = notesDict.at(num);
  synth.set(\gate, 0);
  notesDict.removeAt(num);
});
)



//var osc2, 3, 5 modulate (added to the phase shift of 1. See instructuions. Each osc has an env attached. Try to recreate the sound given. Ratios are that of the provided frequency. Lastly, sounds should be multiplied by factors to make it more or less prominent to match by ear.

(
//(
Synth(\fmEnv, [
  \modIndex, 2,
  \harmRatio, 3,
  \freq_c, 1200,
  \atk, 0.01,
  \rel, 1,
  \amp, 0.6
]);
)