(
var counter = 0, k = 4, a, b, ap = 0, bp = 0, ab;
y = List[-0.1768, 1.198, 0.36503, -0.4743, -0.9119,-0.1768, 1.198, 0.36503, -0.4743, -0.9119];

while ( { counter < 10}, {
	a = y[counter] * (cos((2 * pi * k * counter)/10));
	b = y[counter] * (sin((2 * pi * k * counter)/10));
	counter = counter + 1;
	ap = ap + a;
	bp = bp + b;

});
ap.postln;
bp.postln;
)

