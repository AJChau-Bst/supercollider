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
	var size = 10, sig = [0,0], freq = [100, 400, 600, 1000];
	size.do({
		sig = sig + SinOsc.ar(freq, 0, 0.03)!2;
	});
	Out.ar(out,sig);
}).play;
)

s.scope;

