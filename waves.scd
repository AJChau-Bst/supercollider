/* Catching A Wave
 * ****************
 * Name(s):
 */

/**************
 * Question 1 *
 **************/

// Your code here


/**************
 * Question 2 *
 **************/

(
~freq = {
	// Your code here

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
	// Your code here

}
)

// Testing code
~thirdPartials.play;
~thirdPartials.play(args: [\fundFreq, 400, \fundAmp, 0.3]);

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
