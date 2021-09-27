// # Fundamental Waves


// Boot the server to get started!

s.boot;

/*********************** Additive Synthesis with Arrays ***********************/

/***************************************
 * Using Arrays for Additive Synthesis *
 ***************************************/

// To construct a wave of multiple sine waves, we first need some knowledge about
// how addition of arrays work in SuperCollider.  In Python, if we add two lists
// those lists are concatenated.  For example, `[1, 2] + [3, 4]` produces a new
// list of `[1, 2, 3, 4]`.  Observe though the behavior in sclang. 

[1, 2] + [3, 4]

// Notice how the elements of the two arrays are added together pointwise.  We can
// use the same strategy to add sine waves together.

(
{
  var sineArray1 = [SinOsc.ar(220, mul: 0.1), SinOsc.ar(220, mul: 0.1)];
  var sineArray2 = [SinOsc.ar(660, mul: 0.1), SinOsc.ar(660, mul: 0.1)];
  
  // Add each sine wave pointwise
  // This will result in an array of two items: the left channel at index 0 and the right channel at index 1
  sineArray1 + sineArray2
}.play
)

CmdPeriod.run // stop sound

// Here's a slightly more compact version of the same thing using multichannel
// expansion.

{SinOsc.ar([220, 220], mul: 0.1) + SinOsc.ar([660, 660], mul: 0.1)}.play

CmdPeriod.run // stop sound

/*****************************************************************
 * Aside: Be Careful using UGens outside the function definition *
 *****************************************************************/

// You might think the code below is reasonable.  Functions have access to
// variables in their outer context but nevertheless this code will fail silently
// and we won't hear anything.  This is a common mistake for first-time users of
// SuperCollider.

(
// Buggy!!
var test = SinOsc.ar(440, mul: 0.1);
{test}.play;
)

// The solution to this problem is to simply define UGens like `SinOsc` within the
// scope of the function definition.  

(
// Fixed
{SinOsc.ar(440, mul: 0.1)}.play;
)

CmdPeriod.run

// Full Confession: This is an issue that has long bothered me about the language
// and in my opinion is a design flaw.  Suffice it to say, functions that are
// intended to be played have special requirements.  We'll encounter other such
// quirks as we go.  This is something to watch out for though.

/******************************** Sawtooth Wave ********************************/

/********************************************
 * Creating a Sawtooth Wave with Sine Waves *
 ********************************************/

// We can build a sine wave by summing sine waves.  A true sawtooth wave is an
// infinite sum of sine waves.  Because computers can only perform finite
// calculations, our sine wave below will be capped.  Adding up around 25-30 sine
// waves should give us a good approximation.


// Recall that we can mathematically write the expression for a sawtooth wave
// $g(t)$ as:


// $$g(t) = \sum_{n=1}^{\infty}\frac{A}{n}\sin(2\pi fnt) $$


// Note that the distinctive characteristic of the sine wave is that the amplitude
// of each successive sine wave is $1/n$ times smaller than the fundamental where
// $n$ is the harmonic number of the sine wave.

(
~saw = {
    arg freq = 300, fundAmp = 0.2;
    var numHarmonics = 25;
    var sig = [0, 0];
    
    for(1, numHarmonics, {
        |n| // harmonic number
        sig = sig + (SinOsc.ar(freq * n, 0, fundAmp/n) ! 2) // add an array of two sines wave
    });
    
    sig // return value is the array for left/right speaker
};
)

~saw.play

~saw.plot

s.scope;

CmdPeriod.run

// In SuperCollider, you need not build up your own sawtooth wave using the
// additive synthesis technique above.  SuperCollider comes with two UGens to
// produce sine waves: [LFSaw](https://doc.sccode.org/Classes/LFSaw.html) and
// [Saw](https://doc.sccode.org/Classes/Saw.html).  `LFSaw` is a pure sawtooth wave
// in that contains every partial.  It has a perfectly straight ramp.  Because it
// contains all partials we say that the oscillator is **non-bandlimited**. 
// `LFSaw` contains a finite number of partials and is similar to the additive
// synthesis sawtooth we made above.  Because it contains only a finite number of
// partials we say that the oscillator is **bandlimited**. There are good reasons
// why you might want to use one over the other.  But we need to save that
// discussion until we discuss aliasing.

{LFSaw.ar(300, mul: 0.2) ! 2}.plot;

CmdPeriod.run

{Saw.ar(300, mul: 0.2) ! 2}.plot

CmdPeriod.run

/******************************** Triangle Wave ********************************/

// A triangle wave also sums harmonics from the harmonic series.  It has several
// distinct characteristics:

// - Only contains odd harmonics

// - Amplitude of each harmonic is (1/harmonic_number)^2

// - Every other odd harmonic is 180 degrees out of phase


// The equation for a triangle wave $g(t)$ can be written as follows where $n = 2i
// - 1$:


// $$g(t) = \sum_{i = 1}^{\infty}(-1)^i\frac{A}{n^2}\sin(2\pi fnt)$$


// Note that this equation accomplishes the phase shift by making use of the fact
// that $-\sin(x) = \sin(x + \pi)$.

(
~triangle = {
  arg freq = 300, fundAmp = 0.3;
  var numHarmonics = 30;
  var sig = [0, 0];
  
  for(1, numHarmonics, {
    |i|
    var n = 2 * i - 1; // Create the harmonic number
    var phase = if(i % 2 == 0, {0}, {pi}); // Alternate phase - a conditional is an expression
    sig = sig + SinOsc.ar(freq * n, phase, fundAmp * (1/n.squared));
  });
  
  sig
}
)

~triangle.play

~triangle.plot

CmdPeriod.run

// SuperCollider comes with a UGen for a triangle wave called
// [LFTri](https://doc.sccode.org/Classes/LFTri.html).  Like `LFSaw`, `LFTri` is
// **non-bandlimited**.  It is a pure triangle wave with all partials and has a
// perfectly smooth ramp up and down.  

{LFTri.ar(300, mul: 0.2) ! 2}.play

CmdPeriod.run

/******************************** Square Wave ********************************/

// A square wave has the following properties:

// - Only contains odd harmonics

// - Amplitude of each harmonic is scaled by 1/harmonic_number

// - All harmonics are in phase


// The equation for a square wave $g(t)$ can be written as follows where $n = 2i -
// 1$:



// $$g(t) = \sum_{i = 1}^{\infty}\frac{A}{n}\sin(2\pi nft)$$

// Your code here


~square.play

~square.plot

CmdPeriod.run

// SuperCollider has bandlimited and non-bandlimited UGens for creating square
// waves.  See the discussion of Pulse Waves below for examples.

/********************************* Pulse Wave *********************************/

// A square wave is a special instance of a pulse wave (also called a rectangle
// wave).  There is not a succinct set of criteria to describe the pulse wave as
// there are for the other waves because the scaling of each harmonic is more
// complicated.  


// Like the other waves, the pulse wave is also created from a sum of harmonic
// sinusoids.


// $$g(t)=dA + \sum _{n=1}^{\infty }\frac {2A}{\pi n}\sin(\pi dn)\cos(2\pi fnt)$$


// Notice that the sine is not a function of time.  It serves as a scaling factor
// for the amplitude of a series of cosine waves.  The $d$ in this equation is
// called the duty cycle.  The duty cycle is the percentage of the period where the
// pulse wave is high.  Therefore, a duty cycle of 0.5 is equivalent to a square
// wave.

(
~pulse = {
  arg freq = 300, fundAmp = 0.2, d = 0.5;
  var numHarmonics = 30;
  var sig = [0, 0];
  
  for(1, numHarmonics, {
    |n| // harmonic number
    var harmonic = (2 * fundAmp)/(pi * n) * (n * pi * d).sin * SinOsc.ar(freq * n, pi/2);
    sig = sig + harmonic;
  });
  
  (d * fundAmp) + sig // 2/pi multiplies each element in the array
}
)

~pulse.play

~pulse.plot

CmdPeriod.run

// SuperCollider has a bandlimited pulse wave called
// [Pulse](http://doc.sccode.org/Classes/Pulse.html) and a non-bandlimited pulse
// wave called [LFPulse](http://doc.sccode.org/Classes/LFPulse.html).  We can use
// these two UGens to create any pulse wave including a square wave.

{LFPulse.ar(300, width: 0.25, mul: 0.1) ! 2}.play // width here is the duty cycle - 0.5 is square wave

{Pulse.ar(300, width: 0.5, mul: 0.1) ! 2}.play // width here is the duty cycle - 0.5 is a square wave

CmdPeriod.run

/**************************** Play With A Keyboard ****************************/

// Below you can hook up a MIDI keyboard and try and play some of these waves.  You
// can change the wave type by adjusting the UGen set to `sig` in the code below. 
// We'll talk more about how this code works at a later date.

(
var notesDict = Dictionary.new;
MIDIClient.init;
MIDIIn.connectAll;

SynthDef(\classic, {
  arg out = 0, freq, amp = 0.1, gate = 1;
  var sig, env;
  sig = SinOsc.ar(freq, mul: amp); // Try with LFTri.ar, Saw.ar or Pulse.ar
  env = Env.adsr(0.1, 0.1, 0.9 * amp, 1, amp);
  env = EnvGen.kr(env, gate, doneAction: 2);
  sig = sig * env;
  Out.ar(out, sig ! 2);
}).add;

MIDIdef.noteOn(\adsrOn, {
  |vel, num, chan, src|
  var freq = num.midicps;
  var amp = vel.linexp(0, 127, 0.5, 0.6);
  var synth = Synth(\classic, [\freq, freq, \amp, amp]);
  notesDict[num] = synth;
});

MIDIdef.noteOff(\adsrOff, {
  |vel, num, chan, src|
  var synth = notesDict.at(num);
  synth.set(\gate, 0);
  notesDict.removeAt(num);
});
)

FreqScope.new

s.meter

