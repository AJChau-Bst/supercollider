//Write a SynthDef called \saw that simply plays back a sawtooth wave with the following default arguments: outBus = 0, freq = 440, amp = 0.1. Your code should use the UGen Saw and should playback the sawtooth wave in stereo. Write an additional line to play the synth and then another to free it.

(
SynthDef(\saw, {
	arg freq = 440, amp = 0.1;
	var saw = Saw.ar(freq, amp)!2;
	Out.ar(0,saw);
}).play
)

x = Synth(\saw)
x.free
CmdPeriod.run;


// Write a SynthDef called \sawOctaves that plays back a sawtooth wave and a sawtooth wave one octave above. The SynthDef should use the UGen Saw and should accept arguments outBus = 0, freq = 440, amp = 0.1. The frequency argument specifies the frequency of the lower note in the octave. The amplitude of each sawtooth wave should be half the provided amp. Write an additional line to play the synth with a frequency of 300Hz. Then write a line to set the frequency to 200Hz and then a line to free the synth. You should produce a stereo wave.

(
SynthDef(\sawOctaves, {
	arg freq = 440, amp = 0.1;
	var saw = Saw.ar([freq, freq*2], [amp/2])!2;
	Out.ar(0, saw);

}).play
)

y = Synth(\sawOctaves, [\freq, 300])
y = Synth(\sawOctaves, [\freq, 200])
y.free
CmdPeriod.run;

//Write a SynthDef called \varSaw that creates a variable sawtooth wave. A variable sawtooth wave is a waveform that can be modulated from a sawtooth wave to a triangle wave. We will not concern ourselves with the details of such an implementation. Instead we will simply use a UGen called VarSaw that can provide such a waveform. Examine the Help Documents on VarSaw to understand how exactly to use its inputs. Notice that VarSaw has a parameter for width. This controls the shape of the waveform. To add some interest to the sound, we will change the width of the waveform over time using a sine wave. In essence, this will shape the strength of the partials, creating an interesting sweeping effect. Some additional requirements:

//The SynthDef should accept the following default arguments: outBus = 0, freq = 440, amp = 0.1. Note here that the amp and freq refer to the amplitude and frequency of the variable sawtooth wave and not the amplitude and frequency of the modulating sine wave.
//Again, you will need to create a sine wave and use it to control the width of the variable sawtooth wave. The sine wave should have frequency 0.5 and should span the range from 0 to 1. Note that a sine wave is -1 to 1 by default so you will need to consider how to change the arguments to the sine wave to accomplish that goal. Note that the add argument can shift a waveform vertically.
//Create a stereo signal.
//Write a line to create the synth and then free it.
//If you like, try opening up a scope to watch the waveform change in realtime using s.scope.

(
SynthDef(\varSaw, {
	arg freq = 440, amp = 0.1, outBus = 0;
	var sinwave = SinOsc.ar(0.5, phase: 0.0, mul: 0.1);
	var vsaw = VarSaw.ar(freq, 0, sinwave, amp)!2;
	Out.ar(outBus, vsaw);

}).play
)

z = Synth(\varSaw, [\freq, 300])
z.free
CmdPeriod.run;


//Write a SynthDef called \sawChorus that creates a chorus effect. When singers sing the same note, each singer’s pitch is slightly different from the other singer. It’s why the sound of a choir is so rich. The same principle holds for a string section of an orchestra. To create a choir effect using sawtooth waves, we simply create several copies of the sawtooth wave, each with a pitch that shifts around the target frequency. For the purposes of this SynthDef, use six sawtooth waves.

//You must use a for loop, do loop or while loop to add the six sawtooth waves together.
//The SynthDef should accept the following default arguments: outBus = 0, freq = 440, amp = 0.1
//To generate the deviation around the center pitch use the UGen LFNoise1.kr which will generate a changing random number -1 and 1. You can use the range method on LFNoise1 or any UGen for that matter and it will scale the output to a different range. For example, the code LFNoise1.kr(0.5).range(1, 3) will create a changing random number every two seconds between 1 and 3. Here, the idea is to use LFNoise1.kr to create a changing frequency. If each sawtooth wave has a random value close to the desired frequency, you will achieve the chorus effect. Ensure that the chorus effect works equally well for low sounds and high sounds. Think ratios! I would also have LFNoise1 change random numbers at a low rate, somewhere between every half and two seconds.
//Each sawtooth wave’s amplitude should be divided by the number of sawtooth waves used (i.e., six).
//Create a stereo signal. Here ensure that a different LFNoise1 controls the left channel and the right channel for each saw wave. That will create a more interesting stereo audio effect. You should be a bit careful here. If you do something like LFNoise1.kr ! 2 that will duplicate the exact same unit generator. Here we want two different copies of LFNoise1. Instead you should use {LFNoise1.kr} ! 2 which evaluates the function twice and places those contents in an array. This will give you two different UGens.
//Create a line to play the Synth and a line to free it.

(
SynthDef(\sawChorus,{
	arg outBus = 0, freq = 440, amp = 0.1;
	var numHarmonics = 6;
	var sig = [0,0];
	for(1, numHarmonics, {
		sig = sig + (Saw.ar([LFNoise1.kr(440).range(0.99 * freq, 1.01 * freq)], [amp/numHarmonics]) ! 2);
	});
	Out.ar(outBus, sig);
}).play
)
a = Synth(\sawChorus)
s.scope
a.free



