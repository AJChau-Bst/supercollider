/* Catching A Wave
 * ****************
 * Name(s): Annette Chau
 */

/**************
 * Question 1 *
 **************/

{SinOsc.ar([400, 800],[0, pi], 0.2)}.play
CmdPeriod.run

/**************
 * Question 2 *
 **************/

(
~freq = {
	arg f_init, semitones;
	var value;
	value = ((semitones/12)*2)*f_init;
}
)

// Testing code
~freq.value(400, 12); // Should produce a number very close to 800
~freq.value(400, 7); // Should produce the frequency a P5 above 400Hz (i.e., 600Hz)

/**************
 * Question 3 *
 **************/

(
~thirdPartials = {
	arg fundFreq, fundAmp;
	var harmonic, frequency = 300, amplitude;

	amplitude = Array.fill(1, {harmonic ^ 3});
	harmonic = Array.fill(20, {arg i; i * 3 + 1 });
	//frequency = Array.fill(1, {harmonic * frequency});
	harmonic.postln;
	//frequency.postln;
	amplitude.postln;


	//while(count < 20),{
		//count + 1;
	}

	//{SinOsc.ar(frequency,0, amplitude)}.play

)


// Testing code
~thirdPartials.play;
~thirdPartials.play(args: [\fundFreq, 400, \fundAmp, 0.3]);
Server.killAll;

/**************
 * Question 4 *
 **************/

(
~sawRampUp = {
	// Your code here

};
)

// Testing code
~sawRampUp.plot;
~sawRampUp.play;
~sawRampUp.play(args: [\fundFreq, 40, \fundAmp, 0.5])

/**************
 * Question 5 *
 **************/

(
~pulse = {
	arg freq = 300, dutyCycle = 0.5, amp = 1;
	// Your code here

}
)

// Testing code
~pulse.plot;
~pulse.play;
~pulse.play(args: [\freq, 100, \dutyCycle, 0.2, \amp, 0.1]);
