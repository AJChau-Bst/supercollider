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
~freq = ~exitvelocity.asFloat.flat;
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
~panzone = ~predictedzone.asInteger.flat;
~panzone = ~panzone.asList;
)

(
var count = 0;
~num = (~exitvelocity.size);
while({count < ~num},{
	if (~panzone[count] == 1, {~panzone[count] = 0;});
	if (~panzone[count] == 2, {~panzone[count] = -1;});
	if (~panzone[count] == 3, {~panzone[count] = 1;});
	if (~panzone[count] == 4, {~panzone[count] = -1;});
	if (~panzone[count] == 5, {~panzone[count] = 1;});
	if (~panzone[count] == 6, {~panzone[count] = -1;});
	if (~panzone[count] == 7, {~panzone[count] = 1;});
	count = count + 1;
});
)

//Taken From inC Assignment
(
~clock = TempoClock(seconds: 10);
SynthDef(\bell, {
	arg outBus = 0, freq = 400, amp = 0.5, pan = 0;
	var sig;
	sig = Ringz.ar(Impulse.ar(0), freq, mul:5) * amp;
	DetectSilence.ar(sig, doneAction:2);
	sig = Pan2.ar(sig, pan);
	Out.ar(outBus, sig);
}).add;
)

(
~eventPlayer = Pbind(
	\instrument, \bell,
	\freq, Pseq(~freq.linlin(60, 110, 300, 950),1),
	\pan, Pseq(~panzone, 1).trace;
).play(~tempoclock);
)

(
r = Recorder(s);
r.prepareForRecord("~" +/+ "Desktop" +/+ "Flute2.wav");
r.recHeaderFormat = "WAV";
)

// Record
r.record;

(
r.stopRecording;
)