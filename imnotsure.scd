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
    arg fundFreq = 300, fundAmp = 0.2;
    var numHarmonics = 20;
    var sig = [0, 0];
    for(1, numHarmonics, {
        arg n; // harmonic number
		fundAmp = (1/fundAmp);
		sig = sig + (SinOsc.ar(fundFreq * n, 0, fundAmp**3)! 2);
		n = (n * 3)+1;
    });
    sig // return value is the array for left/right speaker
};
)
~thirdPartials.value;
~thirdPartials.play;
~thirdPartials.play(args: [\fundFreq,1600, \fundAmp, 0.3]);

/**************
 * Question 4 *
 **************/

(
~sawRampUp = {
	arg fundFreq = 300, fundAmp = 0.3;
    var numHarmonics = 30;
    var sig = [0, 0];
    for(1, numHarmonics, {
        arg n; // harmonic number
		sig = sig + (SinOsc.ar(fundFreq * n * -1, 0, fundAmp/n) ! 2)
    });
    sig // return value is the array for left/right speaker
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
	var sig = LFSaw.ar(freq, 0, amp) - LFSaw.ar(freq, dutyCycle*2, amp);
	sig!2
}
)

// Testing code
~pulse.plot;
~pulse.play;
~pulse.play(args: [\freq, 100, \dutyCycle, 0.2, \amp, 0.1]);


