  // SynthDefs
(
SynthDef(\oscillator, {
	arg outBus, select = 0, freq = 440, duty = 0.5, noiseLevel = 0, lagTime = 0, octave = 4;
	var a, whtnoise, cross, sel, output;

	freq = (2**(octave-4)*freq);
	freq = Lag2.kr(freq, lagTime);
	a = [SinOsc.ar (freq),
		LFTri.ar (freq),
		Saw.ar (freq),
		Pulse.ar (freq, duty)
        ];
	sel = Select.ar(select, a);
	whtnoise = WhiteNoise.ar();
	//combine a select and white noise
	noiseLevel = (noiseLevel*2)-1 ;
	cross = XFade2.ar(sel, whtnoise, noiseLevel);
	Out.ar(outBus, cross);
}).add;

SynthDef(\vcf, {
	arg outBus, inBus, freq = 1000;
	var in, moog;
	in = In.ar(inBus);
	moog = MoogFF.ar(in,freq);
	Out.ar(outBus, moog);

}).add;

SynthDef(\vca, {
	arg outBus, inBus, aTime = 0.01, dTime = 0.05, sLevel = 0.8,
	rTime = 0.1, pLevel = 1, gate = 0;
	var env, in;
	in = In.ar(inBus);
	env = Env.adsr(aTime, dTime, sLevel, rTime, pLevel);
    env = EnvGen.kr(env, gate);
	Out.ar (outBus, env * in);
}).add;

SynthDef(\reverb, {
	arg outBus, inBus, mix = 0.5, room = 0.2;
	var in, verb;
	in = In.ar(inBus);
	verb = FreeVerb.ar(in, mix, room);
	Out.ar (outBus, verb ! 2);
}).add;

~start = {
	"Synthesizers intialized".postln;
	~group1 = Group(s);
	//busses
	~otovc = Bus.audio (s,1);
	~vctovc = Bus.audio (s,1);
	~vctovr = Bus.audio (s,1);
	//~final = Bus.audio (s,1);
	~osc = Synth(\oscillator, [\outBus, ~otovc], target:~group1);
	~vca = Synth(\vca, [\inBus, ~otovc, \outBus, ~vctovc], target:~osc, addAction: \addAfter);
	~vcf = Synth(\vcf, [\inBus, ~vctovc, \outBus, ~vctovr], target:~vca, addAction: \addAfter);
	~verb = Synth(\reverb, [\inBus, ~vctovr, \outBus, 0], target:~vcf, addAction:\addAfter);
};
//CHECK THIS
//add before or add after

//~effect = Synth(\add200, [\out, 0, \in, ~bus]);
//~sine = Synth(\sineArgsWithOut, [\out, ~bus, \freq, 1000]);

~free = {
	"All synths freed from server and all busses freed".postln;
	~group1.free;
};
)
s.plotTree;
CmdPeriod.run

/***********
 * Testing *
 ***********/



/********************************
 * Starter Code - DO NOT MODIFY *
 ********************************/

// Keyboard function listener and gui

(
var currentFreq = -1;
var gate = 0;
var getFreqFromUnicode = {
	arg unicode;
	switch(unicode,
		// switch statement based on keyboard
		//  s d   g h j
		// z x c v b n m ,

		122, {261.63},  // 'z' -> C4
		115, {277.18}, // 's' -> C#4
		120, {293.66}, // 'x' -> D4
		100, {311.13}, // 'd' -> D#4
		99,  {329.00}, // 'c' -> E4
		118, {349.23}, // 'v' -> F4
		103, {369.99}, // 'g' -> F#4
		98,  {392},    // 'b' -> G4
		104, {415.3},  // 'h' -> G#4
		110, {440},    // 'n' -> A4
		106, {466.16}, // 'j' -> A#4
		109, {493.88}, // 'm' -> B4
		44,  {523.25}, // ',' -> C5
		{nil} // default is nothing
	);
};
var title, volText, volSlider, oscType, octave, duty, noise,
freq, port, atk, decay, sus, rel, mix, room, damp, im;
var width = 380, height = 480;

w = Window.new("Micro-Moog", Rect(400, 400, width, height));
w.front;
w.view.keyDownAction = {
	|view, char, modifiers, unicode, keycode, key|
	var freq;

	freq = getFreqFromUnicode.value(unicode);

	// Update Frequency
	if((freq != currentFreq) && (freq != nil), {
		currentFreq = freq;
		~osc.set(\freq, freq);
		~vca.set(\gate, 1);
	});
};

w.view.keyUpAction = {
	|view, char, modifiers, unicode, keycode, key|
	var freq;

	freq = getFreqFromUnicode.value(unicode);

	if(freq == currentFreq, {
		~vca.set(\gate, 0);
		currentFreq = -1;
	});
};

// Start the synthesizer
~start.value;

// Title
title = StaticText(w, Rect(5, 0, 400, 30));
title.string = "The Micro-Moog";
title.font = Font("Arial", 20);

// Volume (i.e., ADSR peak level)
volText = StaticText.new(w, Rect(5, 35, 80, 10));
volText.align = \center;
volText.string = "Volume";

volSlider = Slider.new(w, Rect(5, 55, 80, 100));
volSlider.action = {
	arg view;
	~vca.set(\pLevel, view.value);
};
volSlider.value = 1;
volSlider.keyDownAction = {false}; // Will use default key down action otherwise

// Octave
octave = EZNumber(w, Rect(125, 35, 70, 25), "Octave", ControlSpec(2, 7, step: 1), initVal: 4, numberWidth: 25);
octave.action ={arg box; ~osc.set(\octave, box.value)};

// Oscillator - select
oscType = PopUpMenu(w, Rect(5, 160, 80, 20));
oscType.items = ["sine", "triangle", "saw", "pulse"];
oscType.action = {arg menu; ~osc.set(\select, menu.value)};

// Oscillator - duty
duty = EZSlider.new(w, Rect(5, 190, 120, 40), "Pulse Width", initVal: 0.5, labelWidth: 50, numberWidth: 30);
duty.action = {arg slider; ~osc.set(\duty, slider.value)};
duty.sliderView.keyDownAction = {false};

// Oscillator - noise percentage
noise = EZSlider.new(w, Rect(130, 190, 120, 40), "Noise %", labelWidth: 50, numberWidth: 30);
noise.action = {arg slider; ~osc.set(\noiseLevel, slider.value);};
noise.sliderView.keyDownAction = {false};

// Frequency Portamento
port = EZSlider.new(w, Rect(255, 190, 120, 40), "Glide", initVal: 0, labelWidth: 50, numberWidth: 30);
port.action = {arg slider; ~osc.set(\lagTime, slider.value)};
port.sliderView.keyDownAction = {false};

// Filter - Freq
freq = EZSlider.new(w, Rect(5, 235, 370, 30), "Cutoff Freq", ControlSpec(20, 10000), initVal: 1000, labelWidth: 80, numberWidth: 40);
freq.action = {arg slider; ~vcf.set(\freq, slider.value)};
freq.sliderView.keyDownAction = {false};

// VCA - attack time
atk = EZSlider.new(w, Rect(5, 275, 370, 30), "Attack Time", ControlSpec(0, 5), initVal: 0.01, labelWidth: 80, numberWidth: 40);
atk.action = {arg slider; ~vca.set(\aTime, slider.value)};
atk.sliderView.keyDownAction = {false};

// VCA - decay time
decay = EZSlider.new(w, Rect(5, 310, 370, 30), "Decay Time", ControlSpec(0, 1), initVal: 0.05, labelWidth: 80, numberWidth: 40);
decay.action = {arg slider; ~vca.set(\dTime, slider.value)};
decay.sliderView.keyDownAction = {false};

// VCA - sustain level
sus = EZSlider.new(w, Rect(5, 345, 370, 30), "Sustain Level", initVal: 0.8, labelWidth: 80, numberWidth: 40);
sus.action = {arg slider; ~vca.set(\sLevel, slider.value)};
sus.sliderView.keyDownAction = {false};

// VCA - release time
rel = EZSlider.new(w, Rect(5, 380, 370, 30), "Release Time", ControlSpec(0, 10), initVal: 0.1, labelWidth: 80, numberWidth: 40);
rel.action = {arg slider; ~vca.set(\rTime, slider.value)};
rel.sliderView.keyDownAction = {false};

// Reverb - mix
mix = EZSlider.new(w, Rect(5, 420, 120, 40), "Mix", initVal: 0.5, labelWidth: 50, numberWidth: 30);
mix.action = {arg slider; ~verb.set(\mix, slider.value)};
mix.sliderView.keyDownAction = {false};

// Reverb - room
room = EZSlider.new(w, Rect(130, 420, 120, 40), "Room", initVal: 0.2, labelWidth: 50, numberWidth: 30);
room.action = {arg slider; ~verb.set(\room, slider.value)};
room.sliderView.keyDownAction = {false};

// Reverb - damp
/*damp = EZSlider.new(w, Rect(255, 420, 120, 40), "Damp", initVal: 0.3, labelWidth: 50, numberWidth: 30);
damp.action = {arg slider; ~verb.set(\damp, slider.value)};
damp.sliderView.keyDownAction = {false};*/

// Create image of keyboard using Image class?
im = Image.new(thisProcess.nowExecutingPath.dirname +/+ "keyboard.png");

// Drawn images and lines
w.drawFunc_({
	Pen.line(Point(0, 30), Point(width, 30)); // first line
	Pen.line(Point(0, 185), Point(width, 185)); // second line
	Pen.line(Point(0, 270), Point(width, 270)); // third third
	Pen.line(Point(0, 415), Point(width, 415)); // fourth line
	Pen.stroke;
	im.drawInRect(Rect(125, 60, 205, 120), Rect(0, 0, 936, 576));
});
w.onClose = {~free.value; im.free;};
)