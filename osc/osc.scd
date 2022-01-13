/* Assignment: PyCollider
 * **********************
 * Name(s):
 */


// Check the port on which sclang is listening
NetAddr.langPort; // Generally port 57120 but could be used by another application so check

(
SynthDef(\sine, {
	arg out = 0, freq = 440, amp = 0.1;
	var sig, env;

	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.linen(0.01, 0.2, 0.1, amp), doneAction: 2);
	Out.ar(out, sig * env ! 2);
}).add;

SynthDef(\tri, {
	arg out = 0, freq = 440, amp = 0.1;
	var sig, env;

	sig = LFTri.ar(freq);
	env = EnvGen.kr(Env.linen(0.01, 0.2, 0.1, amp), doneAction: 2);
	Out.ar(out,  sig * env ! 2);
}).add;

SynthDef(\square, {
	arg out = 0, freq = 440, amp = 0.1;
	var sig, env;

	sig = Pulse.ar(freq);
	env = EnvGen.kr(Env.linen(0.01, 0.2, 0.1, amp), doneAction: 2);
	Out.ar(out,  sig * env ! 2);
}).add;
)

// Your code here
// Write the three OSCdefs to play back the waves

(
~printUgenMsg = {
    |name, recAddr, freq, amp|
    var header, args;

	header = name ++ " Wave from " ++ recAddr ++ ": \n";
    args = " - Freq " ++ freq ++ "| Amp "
    ++ amp;
    postln(header ++ args)
};

OSCdef.new(
    \sine,
    {
        |msg, time, recAddr, recPort|
        var freq, amp;
        freq = msg[1];
		amp = msg[2];
		~printUgenMsg.value("Sine", recAddr, freq, amp);
		Synth(\sine, [\freq, freq, \amp, amp]);
    },
    '/sine',
	nil,
);

OSCdef.new(
    \tri,
    {
        |msg, time, recAddr, recPort|
        var freq, amp;
        freq = msg[1];
		amp = msg[2];
		Synth(\tri, [\freq, freq, \amp, amp]);
		~printUgenMsg.value("Tri", recAddr, freq, amp);
    },
    '/tri',
	nil,
);

OSCdef.new(
    \square,
    {
        |msg, time, recAddr, recPort|
        var freq, amp;
        freq = msg[1];
		amp = msg[2];
		Synth(\square, [\freq, freq, \amp, amp]);
		~printUgenMsg.value("Square", recAddr, freq, amp);
    },
    '/square',
	nil,
);

)
