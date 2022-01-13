/* GUI
 * ****************
 * Name(s):
 */


/****************
 * Sound Source *
 ****************/

(
SynthDef(\pulse, {
	arg out = 0, freq = 440, amp = 0.1, width = 0.5, cutoffFreq = 1000, pan = 0,
	atkTime = 0.02, decTime = 0.05, susLvl = 0.8, relTime = 0.4, gate = 1;
	var sig, env;

	sig = Pulse.ar([freq, 2 * freq], width, mul: amp / 2).sum;
	env = EnvGen.kr(Env.adsr(atkTime, decTime, susLvl, relTime), gate, doneAction: 2);
	sig = RLPF.ar(sig, Lag2.kr(cutoffFreq, 0.2)) * env;
	sig = Pan2.ar(sig, pan);

	Out.ar(out, sig);
}).add;

~pat = {
	~amp = 0.2;
	~dur = 0.1;
	~width = 0.5;
	~cutoffFreq = 1000;
	~pan = 0;
	~atkTime = 0.02;
	~evp = Pbind(
		\instrument, \pulse,
		\midinote, Pwrand([40, 42, 43, 45, Rest()], [0.24, 0.24, 0.24, 0.24, 0.04], inf),
		\amp, Pfunc({~amp}),
		\dur, Pfunc({~dur}),
		\width, Pfunc({~width}),
		\cutoffFreq, Pfunc({~cutoffFreq}),
		\pan, Pfunc({~pan}),
		\atkTime, Pfunc({~atkTime})
	).play;
	~evp.stop;
}
)

/*******
 * GUI *
 *******/

(
~pat.value;
~w = Window.new("Pattern", Rect(100, 200, 400, 800));
//buttons
~play = Button(~w, Rect(0, 0, 200, 200));
~play.states = [
    ["Play", Color.black, Color.green]
	];// value of 0
~play.font = Font("Monaco", 16);

~play.action = {
    arg view;
    ~evp.play;
};

~stop = Button(~w, Rect(200, 0, 200, 200));
~stop.states = [
    ["Stop", Color.black, Color.red]
	];// value of 1
~stop.font = Font("Monaco", 16);

~stop.action = {
    arg view;
    ~evp.stop;
};

//left
~a = Knob.new(~w, Rect(10, 225, 170, 200));
~a.value = 0.2;
~a.action = {
	arg view;
	~amp = view.value.linlin(0.0, 1, 0.0, 1);
};
~pwidth = Knob.new(~w, Rect(10, 425, 170, 200));
~pwidth.value = 0.5;
~pwidth.action = {
	arg view;
	~width = view.value.linlin(0.0,1,0.0,1);
};
~panknob = Knob.new(~w, Rect(10, 625, 170, 200));
~panknob.value = 0;
~panknob.action = {
	arg view;
	~pan = view.value.linlin(-1, 1, -1, 1);
};
//right button
~duration = Knob.new(~w, Rect(210, 225, 170, 200));
~duration.value = 0.1;
~duration.action = {
	arg view;
	~dur = view.value.linlin(0.1, 1, 0.1, 1);
};

~cutoff = Knob.new(~w, Rect(210, 425, 170, 200));
~cutoff.value = 1000.explin(200, 10000, 0, 1);
~cutoff.action = {
	arg view;
	~cutoffFreq = view.value.linexp(0, 1, 200, 10000);
	~cutoffFreq.postln;
};
~atk = Knob.new(~w, Rect(210, 625, 170, 200));
~atk.value = 0.02;
~atk.action = {
	arg view;
	~atkTime = view.value.linexp(0.001 ,0.4, 0.001, 0.4);
};
//amp text!
~amptext = StaticText.new(~w, Rect(0, 200, 200, 50));
~amptext.string = "Amp"; // set the text
~amptext.align = \center; // center the text
~amptext.font = Font("Monaco", 16);

//pwidth text
~pwidthtext = StaticText.new(~w, Rect(0, 400, 200, 50));
~pwidthtext.string = "Pulse Width"; // set the text
~pwidthtext.align = \center; // center the text
~pwidthtext.font = Font("Monaco", 16);

//pan text
~pantext = StaticText.new(~w, Rect(0, 600, 200, 50));
~pantext.string = "Pan"; // set the text
~pantext.align = \center; // center the text
~pantext.font = Font("Monaco", 16);

//duration text
~durtext = StaticText.new(~w, Rect(200, 200, 200, 50));
~durtext.string = "Duration"; // set the text
~durtext.align = \center; // center the text
~durtext.font = Font("Monaco", 16);

//cutoff text
~cuttext = StaticText.new(~w, Rect(200, 400, 200, 50));
~cuttext.string = "Cutoff Freq"; // set the text
~cuttext.align = \center; // center the text
~cuttext.font = Font("Monaco", 16);

//atk text
~atktext = StaticText.new(~w, Rect(200, 600, 200, 50));
~atktext.string = "Attack Time"; // set the text
~atktext.align = \center; // center the text
~atktext.font = Font("Monaco", 16);

~w.front;
)
s.free;