// # SynthDefs

// To get started, boot the server!

s.boot;

/****************************** Review: `.play` ******************************/

// The quickest way to produce sound in SuperCollider is to use the `.play` method
// from [Function](https://doc.sccode.org/Classes/Function.html).  The function
// should output a UGen or array of UGens to be played back by the audio server.

{SinOsc.ar(440, mul: 0.1) ! 2}.play;

CmdPeriod.run; // stop sound

/********************************** SynthDefs **********************************/

// It turns out that behind the scenes `.play` does several things.  It defines an
// instrument based on the contents of the function, sends that information to the
// audio server, and then sends a message to the server to play an instance of that
// instrument.  The initial definition of the instrument is called a
// [SynthDef](https://doc.sccode.org/Classes/SynthDef.html).  SynthDefs are the way
// to create instruments and effects in SuperCollider.  SynthDefs are some of the
// more complicated pieces of machinery in SuperCollider.


// In the documentation of
// [Function](https://doc.sccode.org/Classes/Function.html), you will note under
// the `.play` method that "play wraps the UGens in a SynthDef and sends it to the
// target".  The target by default is the audio server.  `.play` is just a
// convenience method to make a SynthDef and play it simultaneously.


// Below is our first example of a SynthDef.  It is semantically equivalent to
// `{SinOsc.ar(440, mul: 0.1) ! 2}.play`.  A SynthDef takes two arguments: a name
// for the definition as a symbol and a function.

(
SynthDef(\sine, {
  var sig = SinOsc.ar(440, mul: 0.1) ! 2;
  Out.ar(0, sig);
}).play
)

CmdPeriod.run; // stop sound


(
SynthDef(\pulse, {
	arg freq = 440, amp = 0.1, duty = 0.5;
	Out.ar (0,Pulse.ar(freq, duty, amp)!2)
}).add
)
CmdPeriod.run;

// The end of every SynthDef should contain a UGen called
// [Out](https://doc.sccode.org/Classes/Out.html).  This UGen takes two arguments:
// a bus and a channel array.  The purpose of `Out` is to specify where to send the
// outputted signal.  Busses are a means of routing audio signals through different
// paths.  The term comes from analog mixers.  For now, we want to hear the signal
// out of our speakers.  For most systems, the default output bus is zero.  A more
// complete discussion of busses will follow later in this notebook.  The output
// signal is simply the same signal that we would typically output using `.play`
// for a function.  Here the variable `sig` makes explicit what is being passed to
// `Out`.


// The `.play` method for a SynthDef accomplishes the same purpose as `.play` for a
// function.  It creates the definition, sends it to the audio server, and then
// triggers the server to play an instance of that instrument instantly.

/***************************************************
 * Separating Definition from Playing using `.add` *
 ***************************************************/

// It turns out that `.play` for either a SynthDef or a Function is limiting.  Many
// times we want to be able to separate the definition of an instrument from the
// playing of the instrument in much the same way that we do not always want to
// define a function and invoke it immediately in a program.  To simply register
// the instrument with the audio server, we would use the `.add` method for a
// SynthDef

(
SynthDef(\sine, {
  var sig = SinOsc.ar(440, mul: 0.1) ! 2;
  Out.ar(0, sig);
}).add;  // Note the .add here
)

// Note that you should not hear anything.  We've only defined the instrument.  We
// have not played it.

/**********
 * Synths *
 **********/

// To play the instrument, we need to create an instance of that instrument.  These
// instances are called [Synths](https://doc.sccode.org/Classes/Synth.html).  To
// create an instance of our instrument `\sineWave`.  We simply pass the name of
// the instrument into Synth.

Synth(\sine)

CmdPeriod.run // stop sound

// So far we have learned that Command+Period is the only way to stop sound in
// SuperCollider.  It is a brute force method though because it stops **all** sound
// on the audio server.  What if we wanted to stop just one specific sound?  To do
// so, we should capture our synths using a variable.  When you are ready to stop
// the sound, you can simply free the synth from the audio server using a variable.

x = Synth(\sine)

x.free

// It turns out we can also do this with `.play` for a function as well.  The
// object returned by `.play` is a Synth that we can free.

x = {SinOsc.ar(440, mul: 0.1) ! 2}.play

x.free

/***********************************
 * Setting Arguments to a SynthDef *
 ***********************************/

// We can also write arguments for a SynthDef in the same way we use arguments for
// a function.  The difference now between `\sineArgs` and `\sine` is that
// `\sineArgs` can create a sine wave of any frequency and of any amplitude.  By
// default, if the user does not pass in an argument when they create a Synth for
// `\sineArgs`, the frequency will be 440Hz with an amplitude of 0.1.

(
SynthDef(\sineArgs, {
  arg freq = 440, amp = 0.1;
  var sig = SinOsc.ar(freq, mul: amp) ! 2;
  Out.ar(0, sig);
}).add;
)

x = Synth(\sineArgs) // Uses default value of 440

x.free;

// If we want to create a Synth with different arguments, we need to pass an array
// of arguments to Synth with the name of the argument followed by its value.

x = Synth(\sineArgs, [\freq, 500])

x.free

x = Synth(\sineArgs, [\amp, 0.05, \freq, 600])

x.free

/*******************************************
 * Changing Sound Dynamically using `.set` *
 *******************************************/

// We can also change the sound dynamically as it is playing using the `.set`
// method of Synth.  Here, we pass a series of comma-separated values with the name
// of the argument followed by its value.

x = Synth(\sineArgs, [\freq, 500])

x.set(\freq, 400) // Change the frequency to 400Hz as it is playing

x.set(\freq, 1000, \amp, 0.3) // Change the frequency to 1000Hz and amp to 0.3 as it is playing

x.free

/****************************************
 * Be Careful with Reexcution of Synths *
 ****************************************/

// A common mishap occurs when re-executing Synths.  For example, run the cell
// below twice in a row and then attempt to free the Synth.  You will notice that
// the sine wave still plays.  By running the cell twice, two synths are created on
// the server.  The variable `x` is reassigned to latter synth object.  That synth
// is freed but the first synth is not assigned to any variable.  Therefore, there
// is no way to free it.  The only way to stop the sine wave is by using
// Command+Period or a similar brute force method like rebooting the server or
// interpreter.

x = Synth(\sineArgs)

x.free

CmdPeriod.run

/**********************
 * Exercise: `\pulse` *
 **********************/

// Below write a simple SynthDef called `\pulse` that plays back a stereo
// bandlimited pulse wave using [Pulse](http://doc.sccode.org/Classes/Pulse.html).
// The SynthDef should accept three arguments: a frequency with a default value of
// 440Hz, an amplitude with a default value of 0.1, and a duty cycle with a default
// value of 0.5.

(
// Your code here

SynthDef(\pulse, {
  arg freq = 440, amp = 0.1, duty = 0.5;
  var sig = Pulse.ar(freq, duty, amp) ! 2;
  Out.ar(0, sig);
}).add
)

~pulse = Synth(\pulse)

~pulse.free

// Create an instance of `\pulse` with a frequency of 300Hz, amplitude of 0.05, and
// duty cycle of 0.75.  Then change the sound dynamically by setting the frequency
// to 600Hz after creating it.  Free the sound when you are done.

(
// Your code here
// Create a synth with a frequency of 300Hz, amplitude of 0.05, and duty cycle of 0.75 and store it in a variable
~pulse = Synth(\pulse, [\freq, 300, \amp, 0.05, \duty, 0.75])
)

(
// Your code here
// Set the frequency to 600Hz
~pulse.set(\freq, 600)
)

(
// Your code here
~pulse.free
)

/************************
 * Exercise: `\sineTri` *
 ************************/

// Write a SynthDef that takes arguments for frequency, amplitude and a blend
// factor and outputs a mix between a sine wave and a triangle wave.  To do so, you
// will need to make use of the UGen `XFade2`.

// [XFade2](https://doc.sccode.org/Classes/XFade2.html) takes any two signals and
// blends them together.  The third argument to `XFade2` is a number between -1 and
// 1 where -1 is all of the signal passed to the first argument, 1 is all of the
// signal passed to second argument, and 0 is an even mix between the two.  The
// output signal should be stereo and scaled by the amplitude.

(
// Your code here

SynthDef(\sineTri, {
  arg freq = 100, amp = 0.2, blend = 0;
  var sine, tri, sig;

  sine = SinOsc.ar(freq);
  tri = LFTri.ar(freq);
  sig = XFade2.ar(sine, tri, blend);

  Out.ar(0, sig * amp ! 2)
}).add;
)

x = Synth(\sineTri)

x.set(\blend, -1)

x.free;

/**************************
 * Debugging Tip: `.poll` *
 **************************/

// The method `.poll` can be applied to any UGen.  When the method is applied and a
// synth is instantiated, the post window will output the values of the UGen at a
// fast, regular clip.

(
SynthDef(\sine_poll, {
  arg freq = 440, amp = 0.1;
  var sig = SinOsc.ar(freq, mul: amp).poll;
  sig = sig! 2;
  Out.ar(0, sig);
}).add;
)

Synth(\sine_poll)

CmdPeriod.run

/********************************** PlotTree **********************************/

// SuperCollider has a helpful GUI to show the active synths playing on the audio
// server.  Try it below and play some synths.


// By default, all synths are put into the default group.  The default group can
// also contain other groups which can contain any number of synths or groups.
// Groups are useful because you can send the same message to all synths within the
// group. For example, you can free instruments from the group.  SuperCollider
// assigns a unique number for each Synth which can be found to the left of the
// synth name.

s.plotTree

~sine1 = Synth(\sineArgs, [\freq, 300])

~sine2 = Synth(\sineArgs, [\freq, 600])

~sine1.free

~sine2.free

/*********************************** Groups ***********************************/

// [Groups](https://doc.sccode.org/Classes/Group.html) are a way to organize synths
// and can contain other groups or synths.  By default, every group or synth is
// placed in the "Default Group" as can be seen in the Plot Tree example above.
// Groups can be powerful organizational tools because they allow a single message
// to be sent to all of its elements.


// To create a group, we use the object `Group` and pass in the location of where
// to place the group called the `target`.

~group = Group(s) // passing the argument s places the group in the default group

// To add synths to the group, we need to specify in the creation of the synth
// where to place it.  This is called the `target`.

(
// `target` is the third argument to Synth
Synth(\sineArgs, target: ~group);
Synth(\sineArgs, [\freq, 1100], ~group);
)

~group.set(\amp, 0.02) // make both synths softer by sending message to the group

~group.set(\amp, 0.2) // make both synths softer by sending message to the group

~group.free

/************************
 * Exercise: Two Groups *
 ************************/

// Create two groups on the default server: one that has a sine wave of 400Hz and
// one that has two sine waves of 600Hz and 800Hz.  Write code that can free each
// group individually.

(
// Your code here
// Create two groups and add the requisite sine waves to each group

~group1 = Group(s);
~group2 = Group(s);
Synth(\sineArgs, [\freq, 400], ~group1);
Synth(\sineArgs, [\freq, 600], ~group2);
Synth(\sineArgs, [\freq, 800], ~group2)
)

(
// Your code here
// Write a line of code to free the first group
~group1.free
)

(
// Your code here
// Write a line of code to free the second group
~group2.free
)

CmdPeriod.run // Just in case you need to stop everything :)

/*********************************** Busses ***********************************/

// A bus is a way to route information in SuperCollider.  We can send one or more
// signals to a bus and have that information routed to a particular destination
// like our speakers or an audio effect.  When multiple signals are sent to the
// same bus, those signals are summed together.


// The UGen `Out` from earlier sends a signal to a bus.  In that example, the bus
// was 0.  All busses in sclang are represented as numbers.  SuperCollider
// allocates 1024 busses for audio rate transmission of data.

s.options.numAudioBusChannels // Will show 1024 in the post window

// By default, SuperCollider sets the output device (i.e., your speakers) to be the
// default audio output of your computer.  You can change that, especially if you
// have a complicated audio setup.  Audio busses are numbered starting at zero.
// The first set of busses correspond to the number of audio outputs for your
// output device.  For most people, the number of audio outputs for a given output
// device is two: one for the left speaker and one for the right speaker.
// Therefore, the left and right speakers corresponds to busses 0 and 1,
// respectively.


// The next set of busses is for your default audio input device, usually the
// built-in microphone on your computer.  Again the default is usually two to
// capture stereo audio input.  Those input channels are set to busses 2 and 3.
// The busses after 3 are available for your program to use to route audio.

s.options.numOutputBusChannels // Will show 2 corresponding to busses 0 and 1

s.options.numInputBusChannels // Will show 2 corresponding to busses 3 and 3

// Opening up the audio meter helps confirm that our current audio setup has two
// input busses and two output busses.

s.meter

/***********************
 * Multichannel Busses *
 ***********************/

// Most audio signals are stereo.  Recall that stereo audio signals are passed
// using an array of two channels.  You'll notice with the `\sine` example that an
// array of two channels was passed to a single audio bus (i.e., 0).
// Instinctually, we might expect to hear audio only in the left speaker because we
// never sent anything to bus 1, the typical destination of the right speaker.
// Nevertheless, we do.


// It turns out that audio signals that are an array of channels are sent through
// adjacent bus indices.  Each bus supports only a mono signal (i.e., 1 channel).
// Therefore, index 1 of `sig` in the example below is indeed sent to Bus 1 even
// though it is not explicitly stated.


// Out is deceptive in the sense that the user only provides a single integer for a
// bus index regardless of how many channels constitute the signal.  Because
// signals are adjacent, any array of signals is laid out in contiguous order.

(
SynthDef(\sine, {
  var sig = SinOsc.ar(440, mul: 0.1) ! 2; // an array of two sine waves due to the duplicate operator (!)
  Out.ar(0, sig); // sent to busses 0 **and** 1
}).add;
)

/********************
 * Declaring Busses *
 ********************/

// A common need for busses is to send audio signals to some sort of effect.  We
// generally take some sound source like a sawtooth wave or an audio file perhaps
// and route the output to some effect like reverb or delay to color the sound
// before sending it to our speakers.  We will use our SynthDef `\sineArgs` from
// above but with a slight modification.  We'll also make the output bus an
// argument as well.  By default, we will set it to zero but we shall see shortly
// that we will need to change the destination bus to send it to an effect.

(
SynthDef(\sineArgsWithOut, {
  arg out = 0, freq = 440, amp = 0.1;
  var sig = SinOsc.ar(freq, mul: amp) ! 2;
  Out.ar(out, sig);
}).add;
)

~sine = Synth(\sineArgsWithOut)

~sine.free

// Now we need to create an audio effect.  Here we will create an effect called a
// Frequency Shift which we will use to add 200Hz to every partial in the sound.
// To do so, we will use a UGen called
// [FreqShift](https://doc.sccode.org/Classes/FreqShift.html).  We will talk more
// about Frequency Shifting when we discuss amplitude modulation.


// Our effect needs to be able to read the input source signal.  To do so, we use
// the UGen [In](https://doc.sccode.org/Classes/In.html).  `In` takes two
// arguments: a bus to read from and the number of channels to read.  In our
// example below, we will define an argument called `in` for the bus which the user
// can set.  The number of channels we expect to read from is 2 because our effect
// will be designed to accept stereo signals.  Therefore, our second argument to
// `In` will be 2.  Because we are asking for a stereo input signal, we will
// actually read from the integer `in` **and** the integer `in + 1`.

(
SynthDef(\add200, {
  arg out = 0, in;
  var sig;

  sig = In.ar(in, 2); // Read from bus in and in + 1 because we are reading a stereo signal

  // Sanity check: what is the type of sig at this moment? Answer: an array of two audio signals
  // When we add a single signal to an array of signals as we do with FreqShift below,
  // that frequency shift is added to both channels.
  //
  // This is also true for any array [1, 2] + 3 evaluates to [4, 5]
  sig = sig + FreqShift.ar(sig, 200);

  // Sanity check: what is the type of sig at this moment? Answer: an array of two audio signals
  Out.ar(out, sig); // Signal will be outputted to busses `out` and `out + 1`
}).add;
)

// Now that we have a sound source and an effect, we need to connect them together.
//  To do so, we need to reserve two audio busses to route our stereo signal from
// `\sineArgsWithOut` to `\add200`.  The UGen
// [Bus](https://doc.sccode.org/Classes/Bus.html) allocates any number of
// contiguous busses for private use.  We will want to create an audio bus since we
// will be sending audio signals.  We will also need to specify the server (i.e.,
// `s`) and the number of busses we will need (i.e., 2).

~bus = Bus.audio(s, 2);

// The variable `~bus` now has a Bus object.  The post window shows when the above
// line is evaluated that we have created an audio bus.  The second of those
// comma-delineated values is the lowest bus number.  In most cases, that will be 4
// which is the first available bus after the default output busses of 0 and 1 and
// the default input busses of 2 and 3.

(
// Here we set the output of ~sine to go to the bus and have the input of ~effect read from the bus
~effect = Synth(\add200, [\out, 0, \in, ~bus]);
~sine = Synth(\sineArgsWithOut, [\out, ~bus, \freq, 1000]); // Change to any frequency
)

// It is important not only to free synths to reduce computational resources on the
// server but also to free audio busses as there are only a finite number of them.

(
~bus.free;
~sine.free;
~effect.free;
)

/***************************** Order of Execution *****************************/

// Suppose we innocently change the order of the creation of the synths ~effect and
// ~sine like below.  Do we hear any sound?

(
~bus = Bus.audio(s, 2);
~sine = Synth(\sineArgsWithOut, [\out, ~bus, \freq, 1000]);
~effect = Synth(\add200, [\out, 0, \in, ~bus]);
)

(
~bus.free;
~sine.free;
~effect.free;
)

// Open up the plot tree and run the code again.  Notice how the `~effect` synth
// `\add200` is on top of the `~sine` synth `\sineArgsWithOut`.  It turns out the
// order matters!


// SuperCollider processes each synth in a top-down order.  The issue is that
// `\add200` attempts to read its input before `\sineArgsWithOut` has a chance to
// send its output.  Therefore, the ordering of the synths needs to be rearranged.
// By default, SuperCollider adds the latest synth to the top of the tree.  That's
// why we see `~effect` precede `~sine`.


// When you create a synth or a group you can specify a relationship to some other
// node in the tree to make your order explicit.  Here we would like to say that
// the `~effect` synth should come **after** our `~sine` synth.  Recall that a
// synth can accept a target as its third argument.  If we provide a fourth
// argument, then we can specify a relationship to the target.  Below we use one of
// several uniquely defined relationships to express the relationship of `~effect`
// to the target `~sine`.  Now we hear audio!

(
~bus = Bus.audio(s, 2);
~sine = Synth(\sineArgsWithOut, [\out, ~bus, \freq, 1000]);
~effect = Synth(\add200, [\out, 0, \in, ~bus], ~sine, \addAfter);
)

(
~bus.free;
~sine.free;
~effect.free;
)

// There are several different kinds of relationships we can express.  See the
// discussion of [Synth](https://doc.sccode.org/Classes/Synth.html) for more
// details.

/**********************************
 * Exercise: Sketching a PlotTree *
 **********************************/

// Below figure out the plot tree from the following code.  Sketch it on a piece of
// paper.  Then run the code and examine the plot tree to see if it matches your
// expectations.

s.plotTree

(
~group1 = Group(s);
~group2 = Group(~group1, \addBefore);
~group3 = Group(~group1);
~sine1 = Synth(\sineArgsWithOut, [\freq, 400], ~group1);
~sine2 = Synth(\sineArgsWithOut, [\freq, 600], ~group2, \addAfter);
~sine3 = Synth(\sineArgsWithOut, [\freq, 800], ~sine1, \addBefore);
~sine4 = Synth(\sineArgsWithOut, [\freq, 1000], ~group3);
)

(
~group1.free;
~group2.free;
~group3.free;
~sine2.free;
)

/******************** Fun Example Putting It All Together ********************/

(
// Creates a swelling sawtooth wave with a chorus effect
SynthDef(\sineExample, {
  arg out = 0, freq = 440, amp = 0.2, ampFreq = 0.5;
  var volume = SinOsc.kr(ampFreq, 3 * pi / 2, amp/2, amp/2);
  Out.ar(out, [Saw.ar(freq, mul: volume), Saw.ar(freq + 1, mul: volume)]);
}).add;

// Delays and repeats the incoming audio signal by 0.6 seconds
SynthDef(\delay, {
  arg out = 0, in;
  var sig, delaySig;
  sig = In.ar(in, 2);
  delaySig = DelayN.ar(sig, 2, 0.6);
  Out.ar(out, sig + delaySig);
}).add;
)

(
~delayBus = Bus.audio(s, 2);
~synthGroup = Group(s);

// Create four synths that form an Am7 chord and add them to ~synthGroup
[440, 523.25, 659.25, 783.99].do({
  arg freq, index;
  var synth = Synth(\sineExample, [
    \out, ~delayBus,
    \freq, freq,
    \amp, 0.1,
    \ampPhase, index * pi/2,
    \ampFreq, 0.3 - (0.05 * index)
  ], ~synthGroup);
});

// Add the delay effect after the synth group
~delay = Synth(\delay, [\in, ~delayBus], ~synthGroup, \addAfter);
)

(
~synthGroup.free;
~delay.free;
~delayBus.free;
)

