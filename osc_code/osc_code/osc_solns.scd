// # OSC and Networking


// Boot the server to get going.

s.boot;

/************************ Peeling Back the Abstraction ************************/

// In SuperCollider, UGens and Synths are simply client-side abstractions for OSC
// messages that get sent to the server where the audio is actually produced.  The
// information for SynthDefs, Synths, and other audio producing classes are
// translated to OSC messages and sent using the method `.sendMsg`.

(
SynthDef(\sine, {
    arg out = 0, freq = 440, mul = 0.1;
    Out.ar(out, SinOsc.ar(freq, 0, mul) ! 2);
}).add;
)

// A Synth in SuperCollider is simply a convenience class for sending an OSC
// message to the server to produce a particular instrument created through a
// SynthDef.

x = Synth(\sine);

x.free;

// Below we can set up execute the equivalent of `x = Synth(\sine)` by sending an
// OSC message below.  The address `/s_new` specifies a function on the serve that
// will process the message.  In this case, the function is responsible for
// creating a new instance of a SynthDef.

(
// node number -> 2000, addAction -> 1 (add to tail), addTarget ID -> 1 (group 1)

s.sendMsg("/s_new", "sine", 2000, 1, 1); 
)

s.sendMsg("/n_free", 2000); // Free node 2000

// This is also true when we want to create synths with specific arguments.

x = Synth(\sine, [\freq, 880, \mul, 0.15]);

x.free;

s.sendMsg("/s_new", "sine", 2000, 1, 1, "freq", 880, "mul", 0.15);

s.sendMsg("/n_free", 2000);

// #### Your Turn

// Create two sine nodes in octaves of a frequency of your choosing.  Make the
// amplitude of each sine wave 0.2.

(
// Your code here
s.sendMsg("/s_new", "sine", 2000, 1, 1, "freq", 440, "mul", 0.2);
s.sendMsg("/s_new", "sine", 2001, 1, 1, "freq", 880, "mul", 0.2);
)

// Free both of those nodes.

(
// Your code here
s.sendMsg("/n_free", 2000);
s.sendMsg("/n_free", 2001);
)

/****************************** Simple Loopback ******************************/

// Below we will write some code to interact with SuperCollider and your localhost
// network on your computer.


// Note that sclang generally listens on port 57120 but if that port is alreeady
// taken by your system then another port may be used.  Furthermore, these are UDP
// ports, not TCP.

NetAddr.langPort; // Generally sclang listens on port 57120

thisProcess.openPorts; // All the open ports sclang is listening

// Let's create a function to listen for incoming osc messages with a specific
// address.  This can be done using the class
// [OSCdef](https://doc.sccode.org/Classes/OSCdef.html).  

(
OSCdef.new(
    key: \msg, // Name in the global dictionary - should be a symbol
    func: {
    |msg, time, recAddr, recPort|
        // msg in the form of [OSC address, arg1, arg2, ...]
        postln("Message from " ++ recAddr ++ ": " + msg[1]);
    },
    path: '/msg', // The OSC address
    srcID: nil, // nil means to listen to all incoming IPs/ports
);
)

// Now we can see that we have one matching function called `\msg` that is
// listening for OSC messages with the address `/msg`.  **Note the differences
// between the two slashes**.

OSCdef.all // Will show just our 

// To send a message to sclang from sclang, we first need to know the address and
// port number where sclang is listening.

c = NetAddr.localAddr; // This will show the IP address and the port number

c.sendMsg("/msg", "Hello from myself");

c.sendMsg("/msg", "Hello from the other side");

/**************** Exercise: Using OSC Messages to Play Sounds ****************/

// Below is a SynthDef for playing a sine wave with an envelope and a function
// called `~printUgenMsg` that nicely formats an OSC message for posting.  Below
// write an OSC definition called `\sine` that will receive OSC messages at address
// `"/sounds/sine"`.  If a message is received it should play the sine wave by
// creating a Synth and post to the window that the message was received using the
// `~printUgenMsg`.  You can assume each OSC message has five arguments in this
// order: frequency, phase, amplitude, duration, and pan position.

(
SynthDef(\sine, {
    arg out = 0, freq, phase, amp, dur, pan;
    var sig, env;
    sig = SinOsc.ar(freq, phase, amp);
    env = Env.linen(0.01, dur, 0.1);
    sig = sig * EnvGen.kr(env, doneAction: 2);
    sig = Pan2.ar(sig, pan);
    Out.ar(out, sig);
}).add;

~printUgenMsg = {
    |name, recAddr, freq, phase, amp, dur, pan|
    var header, args;
    
    header = name ++ " message from " ++ recAddr ++ ": ";
    args = "Freq " ++ freq ++ ", Phase " ++ phase ++ ", Amp " 
    ++ amp ++ ", Dur " ++ dur ++ ", Pan " ++ pan;
    postln(header ++ args)
};
)

(
// Your code here

OSCdef.new(
    \sine,
    {
        |msg, time, recAddr, recPort|
        var freq, phase, amp, dur, pan;
        freq = msg[1];
        phase = msg[2];
        amp = msg[3];
        dur = msg[4];
        pan = msg[5];
        ~printUgenMsg.value("Sine", recAddr, freq, phase, amp, dur, pan);
        Synth(\sine, [\freq, freq, \phase, phase, \amp, amp, \dur, dur, \pan, pan]);
    },
    '/sounds/sine',
);
)

NetAddr.localAddr.sendMsg('/sounds/sine', 400, 0, 0.1, 1, 0);

// The End!

