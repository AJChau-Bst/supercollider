/*
 * ASSIGNMENT: Filters and Delay
 ********************************
 * Name(s): Annette Chau
 */

/***********
 * FLANGER *
 ***********/
CmdPeriod.run
// Sound source: White Noise
(
SynthDef(\whiteNoise, {
	arg out = 0;
	var sig;
	sig = WhiteNoise.ar(0.1);
	Out.ar(out, sig)
}).add;
)

// Test white noise
Synth(\whiteNoise);

// Sound source: Guitar riff
(
var path = thisProcess.nowExecutingPath.dirname +/+ "audio_files" +/+ "guitarMono.wav";
path.postln;
~guitarBuf = Buffer.read(s, path);
SynthDef(\play, {
	arg out = 0, bufnum, amp = 0.7;
	var sig;
	sig = PlayBuf.ar(1, bufnum, doneAction: 2) * amp;
	Out.ar(out, sig);
}).add;
)

// Test guitar noise
Synth(\play, [\bufnum, ~guitarBuf]);

// Build the flanger here

(
SynthDef(\flanger, {
	arg in, out = 0, depth = 1, rate = 0.5, sweep = 0.0045, centerDelay = 0.005, amp = 1;
	var sig, delay, wave;

	sig = In.ar(in, 1);
	wave = SinOsc.kr(rate, mul:sweep, add:centerDelay);
	// Eqn of Wave: 0.0045 sin(x)+0.005
	delay = DelayL.ar(in: sig, delaytime: wave);
	sig = delay * depth + sig;
	Out.ar(out, sig);

}).add;
)
// put sin wave into delayL to input a varying delaytime to modulate the sound

// Establish a bus to route incoming sound into the flanger
(
~flangBus = Bus.audio(s, 1);
~flang = Synth(\flanger, [\in, ~flangBus]);
)

// Pass the white noise into the flanger
~wn = Synth(\whiteNoise, [\out, ~flangBus], ~flang, 'addBefore');
~wn.free;

// Pass the guitar into the flanger
(
~guitar = Synth(\play, [\bufnum, ~guitarBuf, \out, ~flangBus], ~flang, 'addBefore');
~flang.set(\depth, 0.5);
~flang.set(\rate, 0.25);
)

/***********
 * VOCODER *
 ***********/

(
SynthDef(\vocoder, {
	arg out = 0, modulatorInBus, carrierInBus, amp = 0.5,  q = 50;

	var lowestFreq = 300, highestFreq = 8000, numFilters = 41, boost = 20;
	var sig, car, mod, ratio, centerFreq;

	// Write two lines of code to read in the modulator signal and the carrier signal
	mod = In.ar(modulatorInBus,2);
	car = In.ar(carrierInBus, 2);

	// This is an accumulation pattern where we will build up the resulting signal
	// so initialize it to zero.
	sig = [0, 0];

	// Each pass through the loop will use a bandpass filter to track the amplitude
	// of the modulating signal.  The tracked amplitude will be used to scale another
	// bandpass filter of the same frequency applied to the carrier.  The output of
	// the carrier's filter is added to the outputted signal.
	numFilters.do({
		arg filterNum;
		var bandpasscar, bandpassmod, trkamp;

		// Find the ratio of the center frequencies between each bandpass filter.
		ratio = (highestFreq/lowestFreq)**(1/(numFilters-1));


		// Calculate the center frequency of the current bandpass filter
		// based on the filter number and the ratio.
		// YOUR CODE HERE

		centerFreq = lowestFreq * (ratio ** filterNum);

		// Track the amplitude of the modulating signal using Amplitude.ar
		// and BPF.ar.
		// YOUR CODE HERE


		bandpassmod = BPF.ar(in: mod, freq: centerFreq, rq: 1/q);
		bandpasscar = BPF.ar(in: car, freq: centerFreq, rq: 1/q);
		trkamp = Amplitude.ar(in: bandpassmod);

		// Using the tracked amplitude, scale a BPF applied to the carrier
		// signal and add the output to the variable sig.  You should also
		// scale the signal by the boost as BPF with a high Q are often quite soft.
		// YOUR CODE HERE

		bandpasscar = bandpasscar * trkamp * boost;
		sig = bandpasscar + sig;


	});

	// Write a line of code to output the signal.  The resulting signal should be
	// scaled by the amplitude and by the boost.
	// YOUR CODE HERE

	Out.ar(out, sig * boost * amp);

}).add;
)

// Testing

// Modulator - a playback synthdef for speech
// The speech file here is "I wanna make some more sounds"

(
var path = thisProcess.nowExecutingPath.dirname +/+ "audio_files" +/+ "makeMoreSounds.aiff";
~buf = Buffer.read(s, path);

SynthDef(\play, {
	arg out = 0, amp = 1, bufnum;
	Out.ar(out, PlayBuf.ar(2, bufnum, loop: 1) * amp);
}).add;

SynthDef(\saws, {
	arg out = 0, offset = 0;
	var sig = 0;
	var chord = [60, 63, 67, 70] + offset;
	chord.do({
		arg note;
		sig = sig + Saw.ar(note.midicps * (1.0.rrand(1.01)), 0.1) +
		Saw.ar(note.midicps * (1.0.rrand(1.01)), 0.1) + Saw.ar(note.midicps * (1.0.rrand(1.01)), 0.1);
	});
	Out.ar(out, sig ! 2);
}).add;
)


// Test to make sure both synths work
Synth(\play, [\bufnum, ~buf])
Synth(\saws)

// Play the vocoder
(
var carIn = Bus.audio(s, 2);
var modIn = Bus.audio(s, 2);
~play = Synth(\play, [\bufnum, ~buf, \out, modIn]);
~saws = Synth(\saws, [\out, carIn], ~play, \addAfter);
~vocoder = Synth(\vocoder, [\modulatorInBus, modIn, \carrierInBus, carIn], ~saws, \addAfter);
)

// Change the transposition of the chord
~saws.set(\offset, 0) // Choose a number between -12 and 12
