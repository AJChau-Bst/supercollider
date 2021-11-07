/* In C
 * ************
 * Name(s): Annette Chau
 */

/**********
 * SYNTHS *
 **********/
(
SynthDef(\tri, {
	arg outBus = 0, freq = 440, amp = 0.1, pan_pos = 0, cutoff_freq = 1000, res = 0.2,
	atkTime = 0.01, decTime = 0.05, susLvl = 0.8, relTime = 0.1, gate = 1;
	var sig, env;

	sig = LFTri.ar(freq);
	sig = RLPF.ar(sig, freq: cutoff_freq, rq: res);
	env = EnvGen.kr(
		Env.adsr(atkTime, decTime, susLvl, relTime, amp),
		gate,
		doneAction: 2
	);
	sig = sig * env;
	sig = Pan2.ar(sig, pan_pos);
	Out.ar(outBus, sig);
}).add;

SynthDef(\saw, {
	arg outBus = 0, freq = 440, amp = 0.1, pan_pos = 0, cutoff_freq = 1000, res = 0.2,
	atkTime = 0.01, decTime = 0.05, susLvl = 0.8, relTime = 0.1, gate = 1;
	var sig, env;

	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, freq: cutoff_freq, rq: res);
	env = EnvGen.kr(
		Env.adsr(atkTime, decTime, susLvl, relTime, amp),
		gate,
		doneAction: 2
	);
	sig = sig * env;
	sig = Pan2.ar(sig, pan_pos);
	Out.ar(outBus, sig);
}).add;

SynthDef(\bell, {
	arg outBus = 0, freq = 200, pos = 0, amp = 0.1, atk = 0.01;
	var sig;

	sig = Ringz.ar(Impulse.ar(0), freq, 1) * amp;
	DetectSilence.ar(sig, doneAction:2);
	sig = sig * EnvGen.kr(Env([0, 1], [atk]));
	sig = Pan2.ar(sig, pos);

	Out.ar(outBus, sig);
}).add;

SynthDef(\reverb, {
	arg outBus = 0, inBus, mix = 0.4;
	var dry, wet, sig, numFilters = 8;

	dry = In.ar(inBus, 2);

	wet = dry;
	numFilters.do({
		wet = AllpassN.ar(
			in: wet,
			maxdelaytime: 0.2,
			delaytime: {Rand(0.05, 0.15)} ! 2,
			decaytime: {Rand(1, 2)} ! 2
		);
	});

	wet = LPF.ar(wet, 3500);
	sig = dry.blend(wet, mix);

	Out.ar(outBus, sig);
}).add;
)

/*********
 * SETUP *
 *********/

/* REQUIREMENTS:
 * In this code block you should create a TempoClock and store it in a global variable
 * to use in the rest of your piece.  You should also instantiate a reverb Synth so sound
 * synths created from the Pbindefs are routed to the reverb.
 *
 * Additionally, you'll need to create arrays for the remaining patterns.  Refer to the
 * score and the problem set description for more information about how to do this.
 */

(
// Create a tempo clock and a reverb synth
// YOUR CODE HERE:
~clock = TempoClock(102/60);
~reverbBus = Bus.audio(s,1);
~rever = Synth(\reverb, [\inBus, ~reverbBus, \outBus, 0]);

// DO NOT MODIFY THESE TWO LINES
~pat1 = [[3, 0.8], [1, 0.2], [3, 0.8], [1, 0.2], [3, 0.8], [1, 0.2]];
~pat3 = [[Rest(), 0.5], [3, 0.5], [4, 0.5], [3, 0.5]];

// Create arrays for the rest of the patterns: 4, 5, 6, 7, 8, 50, 51, 52, 53
// YOUR CODE HERE:
~pat4 = [[Rest(),0.5],[3, 0.5], [4, 0.5], [5, 0.5]];
~pat5 = [[3,0.5],[4,0.5],[5, 0.5], [Rest(), 0.5]];
~pat6 = [[8, 2],[8,2]];
~pat7 = [[Rest(),1],[Rest(),1],[Rest(),1],[Rest(),0.5], [1, 0.25],[1,0.25],[1,0.5], [Rest(), 0.25], [Rest(), 0.5],[Rest(), 0.5], [Rest(),0.5], [Rest(), 0.5]];
~pat8 = [[5, 3],[4, 2], [4, 2]];
~pat50 = [[4,0.25],[5,0.25]];
~pat51 = [[4, 0.25],[5,0.25],[7,0.25]];
~pat52 = [[5,0.25],[7,0.25]];
~pat53 = [[7,0.25], [5,0.25]];

)

/*************
 * RECORDING *
 *************/

/* You should only run these two blocks of code if you intend to record the piece.
 * The recording will be a .wav file placed on your desktop.  If you would
 * like to record to another destination you need to change the filepath
 * passed to s.prepareForRecord.  Furthermore, any time you re-record the
 * file, it will be overwritten unless you change the name.
 */

// Prepare the recording
(
r = Recorder(s);
r.prepareForRecord("~" +/+ "Desktop" +/+ "inC.wav");
r.recHeaderFormat = "WAV";
)

// Record
r.record;

/***************
 * PERFORMANCE *
 ***************/

// The C pulse throughout the piece
(
Pbindef(
	\cPulse,
	\instrument, \bell,
	\amp, 0.1,
	\midinote, 84,
	\dur, 0.5,
	\outBus, ~reverbBus
).play(~clock, quant: 1);
)

/* REQUIREMENTS:
 * Create three other instruments for the piece and update their patterns
 * and arguments with Pbindefs.
 */
(
~one = Pbindef(
  \perf_one,
  \instrument, \saw,
  \melody, Pseq(~pat1, inf),
  \degree, Pkey(\melody).collect({|pair| pair[0] - 1}),
  \octave, 4,
  \scale, [0,2,4,5,7,9,11],
  \dur, Pkey(\melody).collect({|pair| pair[1]}),
).play(~clock, quant:1);
)
(
Pbindef(
  \perf_two,
  \instrument, \saw,
  \melody, Pseq(~pat1, inf),
  \degree, Pkey(\melody).collect({|pair| pair[0] - 1}),
  \octave, 3,
  \scale, [0,2,4,5,7,9,11],
  \dur, Pkey(\melody).collect({|pair| pair[1]}),
).play(~clock, quant:1);
)
(
Pbindef(
  \perf_three,
  \instrument, \tri,
  \melody, Pseq(~pat1, inf),
  \degree, Pkey(\melody).collect({|pair| pair[0] - 1}),
  \octave, 5,
  \scale, [0,2,4,5,7,9,11],
  \dur, Pkey(\melody).collect({|pair| pair[1]}),
  \amp, 0.1,
).play(~clock, quant:1);
)

//Performer One
Pbindef(\perf_one, \melody, Pseq(~pat3, inf))
Pbindef(\perf_one, \melody, Pseq(~pat4, inf))
Pbindef(\perf_one, \melody, Pseq(~pat5, inf))
Pbindef(\perf_one, \melody, Pseq(~pat6, inf))
Pbindef(\perf_one, \melody, Pseq(~pat7, inf), \relTime, 0.025)
Pbindef(\perf_one, \melody, Pseq(~pat8, inf), \amp, Pwhite(0.1, 0.12))
Pbindef(\perf_one, \melody, Pseq(~pat50, inf))
Pbindef(\perf_one, \melody, Pseq(~pat51, inf),\scale, [0,2,4,5,7,9,10])
Pbindef(\perf_one, \melody, Pseq(~pat52, inf),\scale, [0,2,4,5,7,9,10])
Pbindef(\perf_one, \melody, Pseq(~pat53, inf),\scale, [0,2,4,5,7,9,10])
//One-- Controls
Pbindef(\perf_one, \amp, Pseq([0.1, 0.2, 0.3, 0.3, 0.2, 0.1],inf))
Pbindef(\perf_one, \amp, 0.05)

//Performer Two
Pbindef(\perf_two, \melody, Pseq(~pat3, inf))
Pbindef(\perf_two, \melody, Pseq(~pat4, inf))
Pbindef(\perf_two, \melody, Pseq(~pat5, inf), \atkTime, 0.01)
Pbindef(\perf_two, \melody, Pseq(~pat6, inf))
Pbindef(\perf_two, \melody, Pseq(~pat7, inf))
Pbindef(\perf_two, \melody, Pseq(~pat8, inf), \susLvl = 0.5)
Pbindef(\perf_two, \melody, Pseq(~pat50, inf), \sus, Pwhite(0.05, 0.1))
Pbindef(\perf_two, \melody, Pseq(~pat51, inf),\scale, [0,2,4,5,7,9,10])
Pbindef(\perf_two, \melody, Pseq(~pat52, inf),\scale, [0,2,4,5,7,9,10])
Pbindef(\perf_two, \melody, Pseq(~pat53, inf),\scale, [0,2,4,5,7,9,10])
//Two-- Controls
Pbindef(\perf_two, \amp, Pseq([0.1, 0.2, 0.3, 0.3, 0.2, 0.1],inf))
Pbindef(\perf_one, \amp, 0.05)


//Performer Three
Pbindef(\perf_three, \melody, Pseq(~pat3, inf))
Pbindef(\perf_three, \melody, Pseq(~pat4, inf))
Pbindef(\perf_three, \melody, Pseq(~pat5, inf))
Pbindef(\perf_three, \melody, Pseq(~pat6, inf), \amp, Pseq([0.1, 0.2]))
Pbindef(\perf_three, \melody, Pseq(~pat7, inf), \decTime, 0.1)
Pbindef(\perf_three, \melody, Pseq(~pat8, inf), \cutoff_freq, Pseg([1000, 900, 800, 700],['lin', 'lin'],1))
Pbindef(\perf_three, \melody, Pseq(~pat50, inf))
Pbindef(\perf_three, \melody, Pseq(~pat51, inf),\scale, [0,2,4,5,7,9,10])
Pbindef(\perf_three, \melody, Pseq(~pat52, inf),\scale, [0,2,4,5,7,9,10])
Pbindef(\perf_three, \melody, Pseq(~pat53, inf),\scale, [0,2,4,5,7,9,10])
//Three-- Controls
Pbindef(\perf_three, \amp, Pseq([0.1, 0.2, 0.3, 0.3, 0.2, 0.1],inf))
Pbindef(\perf_three, \amp, 0.05)

//End
(
Pbindef(\perf_one, \amp, Pseg([0.1, 0], [10], ['lin', 'lin'], 1));
Pbindef(\perf_two, \amp, Pseg([0.1, 0], [10], ['lin', 'lin'], 1));
Pbindef(\perf_three, \amp, Pseg([0.1, 0], [10], ['lin', 'lin'], 1));
Pbindef(\cPulse, \amp, Pseg([0.1, 0], [10], ['lin', 'lin'], 1));

)

/***********
 * CLEANUP *
 ***********/
Pbindef.clear
s.meter

//Under the section “CLEANUP”, write a code block to stop the \cPulse pattern and remove all Pbindef references. Refer to your notes for help with the latter.


/* REQUIREMENTS:
 * Create a block of code that stops all instruments and the pulse.
 * Clear the references to the Pbindefs created during your piece.
 */

/******************
 * STOP RECORDING *
 ******************/

(
r.stopRecording;
)
