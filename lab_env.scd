(
SynthDef(\bass, {
    arg out = 0, freq = 100, amp = 0.2;
    var sig, numWaves = 6;

    sig = 0;
    numWaves.do({
        sig = sig + VarSaw.ar(
            freq: Rand(freq * 0.995, freq * 1.005),
            iphase: Rand(0, 1),
            width: Rand(0.1, 0.2),
            mul: amp/numWaves
        );
    });

    Out.ar(out, sig ! 2);
}).add;
)

//STEP ONE
//First copy the original SynthDef \bass and rename it to be \bassEnv. Add an amplitude envelope to the sound that ramps up to full volume over five seconds, sustains for one seconds, and releases over five seconds. Have the envelope free the synth when it is done.

//For fun create several synths each with different frequencies, for example like 100Hz, 150Hz, or 200Hz. You can create nice, rich chords.

(
SynthDef(\bassEnv, {
    arg out = 0, freq = 100, amp = 0.2;
    var sig, numWaves = 6, env;

    sig = 0;
	env = Env.linen(0, 5, 5);
	env = EnvGen.kr(env, Done.freeself);
    numWaves.do({
        sig = sig + VarSaw.ar(
            freq: Rand(freq * 0.995, freq * 1.005),
            iphase: Rand(0, 1),
            width: Rand(0.1, 0.2),
            mul: amp/numWaves
        );
    });
    Out.ar(out, sig * env ! 2);

}).play;
)

k = Synth(\bassEnv, [\freq, 200])
k = Synth(\bassEnv, [\freq, 100])
k = Synth(\bassEnv, [\freq, 150])
k.free

//Next copy your solution to \bassEnv and rename it to be \bassEnvWidth. Here add an envelope generator to the width argument of VarSaw. Envelopes do not always need to be used to control the amplitude of a sound. We can shape other parameters as well! Here have the envelope ramp from 0.9 to 0.1 over five seconds, sustain at 0.1 for one second and return to 0.9 over the last five seconds. Notice here that the width will change in conjunction with the amplitude. This is a really nice quality to have in a synthesizer. Changing the width will affect the harmonics of the sound over time. In real instruments, the harmonics of a sound tend to change with volume as well.


(
SynthDef(\bassEnvWidth, {
    arg out = 0, freq = 100, amp = 0.2;
    var sig, numWaves = 6, env, envSaw;

    sig = 0;
	env = Env.linen(5, 1, 5, 1);
	env = EnvGen.kr(env, doneAction: Done.freeSelf);
	envSaw = Env([0.9,0.1, 0.1, 0.9], [5,1,5]);
	envSaw = EnvGen.kr(envSaw, doneAction:Done.freeSelf);
    numWaves.do({
        sig = sig + VarSaw.ar(
            freq: Rand(freq * 0.995, freq * 1.005),
            iphase: Rand(0, 1),
			width: Rand(0,1) * envSaw,
            mul: amp/numWaves
        );
    });
    Out.ar(out, sig * env ! 2);

}).add;
)

l = Synth(\bassEnvWidth, [\freq, 200])
l = Synth(\bassEnvWidth, [\freq, 100])
l = Synth(\bassEnvWidth, [\freq, 150])
l.free


//Copy your solutions to the original \bass SynthDef, not the one from \bassEnvWidth, and rename it to \bassADSR. Try working this time with a sustain envelope where a gate is used to trigger the onset and to trigger the release. Use the Env class method .adsr to create an ADSR envelope to the sound. Add arguments to the SynthDef so the user can supply arguments to control the envelope and, of course, the gate.

//Try playing around with different values for ADSR. What does it sound like when the attack is really short, like 0.001 seconds? Can you create a forte-piano attack with a loud attack followed by a soft sustain?

(
SynthDef(\bassADSR, {
    arg out = 0, freq = 100, amp = 0.2, gate = 1, release = 1.55, attack = 0.5, sustain = 0.3, decay = 2.5;
    var sig, numWaves = 6, env;

    sig = 0;
	env = Env.adsr(attack, decay, sustain, release);
    env = EnvGen.kr(env, gate, doneAction: Done.freeSelf);
    numWaves.do({
        sig = sig + VarSaw.ar(
            freq: Rand(freq * 0.995, freq * 1.005),
            iphase: Rand(0, 1),
            width: Rand(0.1, 0.2),
            mul: amp/numWaves
        );
    });

    Out.ar(out, env * sig ! 2);
}).add;
)

m = Synth(\bassADSR, [\freq, 200])
m = Synth(\bassADSR, [\freq, 100])
m = Synth(\bassADSR, [\freq, 150])
m.set(\gate, 0);

//Write some code to load both sounds into audio buffers on the server. Note that both of these audio files are stereo.

(
~barracuda_buff = Buffer.read (s, thisProcess.nowExecutingPath.dirname +/+ "barracuda.wav");
~workit_buff = Buffer.read (s, thisProcess.nowExecutingPath.dirname +/+ "work_it.wav");


SynthDef(\play, {
    arg out = 0, buf;
    var x, y, rate = 1 , loop = 0;
	x = PlayBuf.ar(2, buf, rate, loop: loop, doneAction:2);

    Out.ar(out, x);
}).add;

)
o = Synth(\play, [\buf, ~barracuda_buff]);
o.free

// Next copy your SynthDef for \play and rename it as \fadeIn. Here write an amplitude envelope that will fade in a song over a certain amount of time. Create an argument for fade-in time so that the user can control how long the fade in will be. For the fade-in have the audio start at an amplitude of 0.01 and slowly ramp up 1 across whatever the fade time is specified by the user. Set the curve here to be exponential. Why exponential? Our perception of volume, like musical intervals, is roughly logarithmic. Here I recommend testing this with Barracuda as it is a better candidate for a long fade in.

(
~barracuda_buff = Buffer.read (s, thisProcess.nowExecutingPath.dirname +/+ "barracuda.wav");
~workit_buff = Buffer.read (s, thisProcess.nowExecutingPath.dirname +/+ "work_it.wav");


SynthDef(\fadeIn, {
	arg out = 0, buf, fadein = 10;
    var sig, numWaves = 6, env, x, y, rate = 1, loop = 0;

	env = Env.new([0.01,1],[fadein],\exp);
    env = EnvGen.kr(env);
	x = PlayBuf.ar(2, buf, rate, loop: loop, doneAction:2);

    Out.ar(out, x * env);
}).add;

)
p = Synth(\fadeIn, [\buf, ~barracuda_buff]);
p.free

// Next copy your SynthDef for \fadeIn and rename it to \fadeInOut. Add another amplitude envelope that can be triggered at any time through a gate to fade out the song to silence. The fade out should have the same fade time as the fade in. When the fade out is done, no matter where the song is, the synth should be freed.

(
~barracuda_buff = Buffer.read (s, thisProcess.nowExecutingPath.dirname +/+ "barracuda.wav");
~workit_buff = Buffer.read (s, thisProcess.nowExecutingPath.dirname +/+ "work_it.wav");


SynthDef(\fadeOut, {
	arg out = 0, buf, fadein = 10;
    var sig, numWaves = 6, env, x, y, rate = 1, loop = 0;

	env = Env.new([0.01,1],[fadein],\exp);
    env = EnvGen.kr(env);
	fout = Env.new([1, 0.01],[fadein], \exp);
	fout = EnvGen.kr(fout);
	x = PlayBuf.ar(2, buf, rate, loop: loop, doneAction:2);
	gate.ar(x * env

    Out.ar(out, x * fout);
}).add;

)
q = Synth(\fadeOut, [\buf, ~barracuda_buff]);
q.free


