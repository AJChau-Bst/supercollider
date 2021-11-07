/* Assignment: Building Blocks
 *****************************
* Name(s): Annette Chau
 */

//WRITTEN



CmdPeriod.run
/**************
 * EXERCISE 1 *
 **************/
//JUST NEED ONE NUMBER
{SinOsc.ar([400, 400], 0, 0.1)}.play;

// Part a - Find a frequency between 44100/2 and 44100 that produces the same sine
// wave of 400Hz as above.

(
var testFreq = ???; // Enter your new frequency here
{SinOsc.ar([testFreq, testFreq], 0, 0.1)}.play;
)

// Part b - Find a frequency greater than 44100 the produces the same sine wave
// of 400Hz above.

(
var testFreq = ???; // Enter your new frequency here
{SinOsc.ar([testFreq, testFreq], 0, 0.1)}.play;
)

/**************
 * EXERCISE 2 *
 **************/
//JUST NEED ONE NUMBER

(
var testFreq = ???; // Write your answer here
{SinOsc.ar(testFreq, 0, 1) ! 2}.play;
)

s.meter // Check the output here - it should be zero

/**************
 * EXERCISE 3 *
 **************/

/* Function: ~gain
 * ****************
 * Increase/decrease the gain of samples by a scalar
 *
 * Inputs:
 * - samples: the input samples as a Signal
 * - gain_factor: a number to be multiplied by each sample
 *
 * Output:
 * - a new Signal containing the scaled samples
 */

(
~gain = {
	arg samples, gain_factor;

	// Your code here

};
)

// Test cases
// Note that you may get different rounding errors depending upon the approach due
// to the digital representation of floats in a computer.  Your answers should be
// accurate to at least 6 significant digits.

~gain.(Signal[0, 1, 0, 1], 2); // should return Signal[ 0.0, 2.0, 0.0, 2.0 ]
~gain.(Signal[-0.2, 0.1, 0.3], 0.5); // should return Signal[ -0.10000000149012, 0.050000000745058, 0.15000000596046 ]


/* Function: ~reverse
 * ******************
 * Reverse the ordering of samples stored in a Signal.
 *
 * Inputs:
 * - samples: the input samples as a Signal
 *
 * Output:
 * - a new Signal containing the reversed samples
 */

// IMPORTANT: you may *not* use .reverse because that is in place.  You should return
// a *new* Signal.

(
~reverse = {
	arg samples;

	// Your code here

};
)

// Tests
~reverse.(Signal[0, 1, 2, 3]); // should return Signal[ 3.0, 2.0, 1.0, 0.0 ]
~reverse.(Signal[0, 1, 2]); // should return Signal[ 2.0, 1.0, 0.0 ]
~reverse.(Signal[1]); // should return Signal[ 1.0 ]


/* Function: ~lfSaw
 * ****************
 * Creates a sawtooth wave that starts at 0 and ramps upward.  This sawtooth
 * wave assumes that the frequency is below the Nyquist frequency (i.e.,
 * freq * 2 <= sampleRate).
 *
 * Inputs:
 * - numSamples: the number of samples to be produced as an Integer
 * - freq: the frequency of the sawtooth wave
 * - sampleRate: the sample rate (must be >= freq * 2)
 * - mul: a scalar factor applied to each sawtooth sample
 * - add: a scalar added to each sawtooth sample
 *
 * Output:
 * - a new Signal containing sawtooth samples
 */

(
~lfSaw = {
	arg numSamples, freq, sampleRate, mul, add;

	// Your code here

};
)

// Tests
~lfSaw.(5, 1, 5, 1, 0); // Signal[ 0.0, 0.40000000596046, 0.80000001192093, -0.80000001192093, -0.40000000596046 ]
~lfSaw.(5, 2, 5, 1, 0); // Signal[ 0.0, 0.80000001192093, -0.40000000596046, 0.40000000596046, -0.80000001192093 ]
~lfSaw.(5, 1, 5, 0.5, 0); // Signal[ 0.0, 0.20000000298023, 0.40000000596046, -0.40000000596046, -0.20000000298023 ]
~lfSaw.(5, 1, 5, 0.5, 1); // Signal[ 1.0, 1.2000000476837, 1.3999999761581, 0.60000002384186, 0.80000001192093 ]


// Plot check - the following should show one period of a sawtooth ramp that
// ramps up to 1 at 0.5 seconds, drops immediately to -1 and then ramps
// back up to 0 at 1 second
~lfSaw.(101, 1, 100, 1, 0).plot;

// Plot check - should show two periods of a saw wave that starts at 0.5 goes
// up to 1 drops to 0 and back up.
~lfSaw.(101, 2, 100, 0.5, 0.5).plot;

// Test with audio
~lfSaw.(44100 * 5, 100, 44100, 0.1, 0).play(mul: 1);
{LFSaw.ar(100, 0, 0.1, 0)}.play; // should sound the same as this

/**************
 * EXERCISE 4 *
 **************/

/* Function: ~interpolate
 * **********************
 * Creates a Signal of samples based on a wavetable.  The wavetable is
 * assumed to contain exactly one period of the desired waveform. The
 * samples are generated using linear interpolation.
 *
 * Inputs:
 * - table: the table containing the waveform as a Signalfrom one period
 * - freq: the desired frequency
 * - sampleRate: the sample rate
 * - numSamples: the number of samples to be produced as an Integer
 *
 * Output:
 * - a new Signal containing the interpolated waveform
 */

(
~interpolate = {
	arg table, freq, sampleRate, numSamples;

	// Your code here

};
)

// Test Cases
~interpolate.value(Signal[0, 0.25, 0.5, 0.75], 0.5, 2, 4); // should return Signal[ 0.0, 0.25, 0.5, 0.75 ]
~interpolate.value(Signal[0, 0.25, 0.5, 0.75], 0.5, 4, 8); // should return Signal[ 0.0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.375 ]
~interpolate.value(Signal[0, 0.25, 0.5, 0.75], 1, 2, 4); // should return Signal[ 0.0, 0.5, 0.0, 0.5 ]
~interpolate.value(Signal[0, 0.25, 0.5, 0.75], 0.3, 4, 4); // should return Signal[ 0.0, 0.075, 0.15, 0.225 ]
~interpolate.value(Signal[0, 0.25, 0.5, 0.75], 4/3, 4, 4); // should return Signal[ 0.0, 0.33333333333333, 0.66666666666667, 0.0 ]

// should return Signal[ 0.0, 0.25, 0.5, 0.75, 0.0, 0.25, 0.5, 0.75 ]
~interpolate.value(Signal[0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.825], 8, 32, 8);

// should return Signal[ 0.0, 0.09375, 0.1875, 0.28125, 0.375, 0.46875, 0.5625, 0.65625 ]
~interpolate.value(Signal[0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.825], 3, 32, 8);

// should return Signal[ 0.5, 0.375, 0.25, 0.125, 0.0, 0.375, 0.75, 0.625 ]
~interpolate.value(Signal[0.5, 0.25, 0, 0.75], 0.5, 4, 8);

// should return Signal[ 0.5, 0.075, 0.65, 0.225, 0.6, 0.375, 0.15, 0.525 ]
~interpolate.value(Signal[0.5, 0.25, 0, 0.75], 1.7, 4, 8);

// Audio Testing
(
var testSamples;
var newSamples;

~arrayConcatenation = {
	arg signal, num_samples;
	var i = 0;
	var result = Signal.newClear(num_samples);

	while({i < num_samples}, {
		result[i] = signal[i.mod(signal.size)];
		i = i + 1;
	});
	result.postln;
	result
};

testSamples = Signal.sineFill(8192, [1], [0]);
newSamples = ~interpolate.value(testSamples, 440, 44100, 44100 * 5);
~buf = newSamples.play(mul: 0.2); // play at amplitude of 0.2
)

// Test against the real SinOsc and they should be exactly the same
{SinOsc.ar(440, mul: 0.2)}.play;