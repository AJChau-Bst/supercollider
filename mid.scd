//Annette Chau CS203 Midterm Exam

//Random Samples
~randomSamples = {arg size; Array.rand(size, -1.0, 1.0);}
~randomSamples.value(2);

//Midi To Freq
(
~midiToFreqs = {
	arg midiNotes;
	var num, count = 0, added;
	num = midiNotes.size;
	while ({count < num}, {
		//.put
		added = midiNotes[count].midicps;
		midiNotes.put(count, added);
		count = count + 1;
	};);
midiNotes;
}
)
~midiToFreqs.value([61, 69]);

//Buggy Code

(SynthDef(\buggy, {
	arg out = 0;
	var size = 10, sig = [0,0];
	size.do({
		sig = sig + (SinOsc.ar(Rand(200,1000), 0, 0.03)!2);
	});
	Out.ar(out,sig);
}).play;
)

s.scope;

(
SynthDef(\whiteNoise, {
	arg out = 0;
	var sig;
	sig = WhiteNoise.ar(0.1);
	Out.ar(out, sig)
 }).play;
)

Synth(\whiteNoise);


(
SynthDef(\allpass, {
	arg out = 0, in, depth = 1, sweep = 0.005, centerDelay = 0.005, rate = 2;
	var sig, lfo, alp;

	sig = In.ar(in, 1);
	lfo = SinOsc.kr(rate, mul:sweep, add:centerDelay);
	alp = AllpassN.ar(in: sig, maxdelaytime: 1, delaytime: lfo, decaytime: 0.01);
	sig = alp * depth + sig;

	Out.ar(out, sig!2);

}).add;
)

(
~flangBus = Bus.audio(s, 1);
~flang = Synth(\allpass, [\in, ~flangBus]);
)

// Pass the white noise into the flanger
~wn = Synth(\whiteNoise, [\out, ~flangBus], ~flang, 'addBefore');
~wn.free;




(
SynthDef(\mystery1, {
	var sig;
	sig = SinOsc.ar(800) * SinOsc.ar(400) * 0.5;
	Out.ar(0,sig);
}).play;
)

(
SynthDef(\mystery2, {
	var sig, x = 100;
	sig = SinOsc.ar(800+(x * SinOsc.ar(400)));
	Out.ar(0, sig);
}).play;
)

{SinOsc.ar(800)}.play;
{SinOsc.ar(400)}.play;
{SinOsc.ar(800) * SinOsc.ar(400)}.play;