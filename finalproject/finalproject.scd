//ExitVelocity, Turning into Float, Flat, Removing Zeroes
(
var extpath = thisProcess.nowExecutingPath.dirname +/+ "exitvelocity.csv", count = 0;
~exitvelocity = FileReader.read(extpath, delimiter:",");
~exitvelocity= ~exitvelocity.asFloat.flat;
~exitvelocity.postln;

~num = 906;
while({count < ~num},{
	count = count + 1;
	if ((count.odd),(~exitvelocity.removeAt(count)));
});

~attack = ~exitvelocity.asFloat.flat;
~decay = ~exitvelocity.asFloat.flat;
~sustain = ~exitvelocity.asFloat.flat;
~release = ~exitvelocity.asFloat.flat;
)


//Predicted Zone, Importing File, Turning into an Integer, Flat, Taking out Zeroes
(
var predpath = thisProcess.nowExecutingPath.dirname +/+ "predictedzone.csv", count = 0;
~predictedzone = FileReader.read(predpath);
~predictedzone = ~predictedzone.asFloat.flat;
~num = 906;
while({count < ~num},{
	count = count + 1;
	if ((count.odd),(~predictedzone.removeAt(count)));
});
~midinotes = ~predictedzone.asFloat.flat;

)
~predictedzone.postln;

//Attack
(
var count = 0, temporary;
~num = (~exitvelocity.size);
while({count < ~num},{
	temporary = (~attack[count])/200;
	~attack.put(count, temporary);
	if (~attack[count] == 0.0, {~attack[count] = 0.1;});
	count = count + 1;
});
)
~attack.postln;


//Decay
(
var count = 0, temporary;
~num = (~exitvelocity.size);
while({count < ~num},{
	temporary = (~decay[count])/100;
	~decay.put(count, temporary);
	if (~decay[count] == 0.0, {~decay[count] = 0.5;});
	count = count + 1;
});
)
~decay.postln;

//Sustain
(
var count = 0, temporary;
~num = (~exitvelocity.size);
while({count < ~num},{
	temporary = (((~sustain[count])/20)-3);
	~sustain.put(count, temporary);
	if (~sustain[count] == -3, {~sustain[count] = 0.6;});
	count = count + 1;
});
)
~sustain.postln;

//Release
(
var count = 0, temporary;
~num = (~exitvelocity.size);
while({count < ~num},{
	temporary = ((~release[count])/10);
	~release.put(count, temporary);
	if (~release[count] == 0.0, {~release[count] = 5;});
	count = count + 1;
});
)
~release.postln;

//Midi Notes
(
var count = 0, temporary;
~num = (~exitvelocity.size);
while({count < ~num},{
	temporary = (((~midinotes[count])*3)+45);
	~midinotes.put(count, temporary);
	count = count + 1;
});
)
~midinotes.postln;

//Taken From inC Assignment
(
~clock = TempoClock(450/60);
SynthDef(\bell, {
	arg outBus = 0, freq = 400, amp = 0.5, atk = 0.5, dec = 0.1, sus = 0.1, rel = 0.1;
	var sig;
	sig = Ringz.ar(Impulse.ar(0), freq, mul:5) * amp;
	DetectSilence.ar(sig, doneAction:2);
	sig = sig * EnvGen.kr(Env.adsr(atk, dec, sus, rel));
	Out.ar(outBus, sig!2);
}).add;
)

(
~midinotes = ~midinotes.asList;
~attack = ~attack.asList;
~sustain = ~sustain.asList;
~release = ~release.asList;
~decay = ~decay.asList;
)

(
~eventPlayer = Pbind(
	\instrument, \bell,

).play(~tempoclock);
)

//pan can do location
//velocity to pitch, higher the velocity, the higher the pitch-- Frequency range
// .linlin == map ranges
// sig = pan2.ar (sig, argument for position) -1 to +1 (left to right)
//don't need the duplicating 2 