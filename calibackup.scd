/* SuperCollider Calisthenics
 * **************************
 * Name(s): Annette Chau
 */

/***********************
 * ORDER OF OPERATIONS *
 ***********************/

/*
In math, PEMDAS (parentheses, exponents, multiplication, division, addition, subtraction)
defines the order of operations to compute mathematical expressions.  For example,
the following expression 11 + 12 * ((7 / 3) - 1) evaluates to 27.  sclang evaluates
mathematical expressions from left to right.  There is no precedence of operators like
PEMDAS.  Precedence, however, can be forced with parentheses in sclang.  Rearrange the
mathematical example above WITHOUT parentheses (i.e., use exactly one instance of the
following operands 11, 12, 7, 3, 1 and the operators +, *, /, - ) to compute 27 in sclang.
Note that you cannot do something like 3 * 7 + 7 - 1 = 27 because the operand 7 is used more
than once and the expression lacks operands 11 and 12 and the / operator.  Set the expression
equal to ~result.  For example, your final answer might be ~result = 1 - 11 + 12 * 7 / 3.
This, of course, is incorrect because ~result = 4.6666.
*/

(
~result = ???
~result.postln;
)

/********************
 * SIMPLE FUNCTIONS *
 ********************/

/*
Write a function called `fortyTwo` that returns the number 42
*/

(
~fortyTwo = {
	arg x;
	x = 42;
	x.postln
}
)
~fortyTwo.value; // should return 42

/*
Write a function called `plusTwo` that takes a number and adds two to it.
*/

(
~plusTwo = {
	arg input;
	input = input + 2;
	input.postln
}
);

~plusTwo.value(3); // should return 5
~plusTwo.value(-1); // should return 1

/*
Write a function called `hashtag` that takes a string and prepends a hashtag
*/

(
~hashtag = {
	arg y;
	y = "#" ++ y;
	y.postln
}
)

~hashtag.value("blessed"); // should return `#blessed`
~hashtag.value("tgif"); // should return `#tgif`

/*
Write a function called `password` that returns `true` if the string "12345" is passed in
and `false` otherwise
*/

(
~password = {
	arg pass;
	if (pass == "12345",
		{"true".postln;},
		{"false".postln;})
}
)

~password.value("12345"); // should return `true`
~password.value("incorrect"); // should return `false`

/*
Write a function called `addSeven` that takes a number and returns the number plus seven if the number is
less than zero and returns just the number otherwise.
*/

(
~addSeven = {
	arg seven;
	if (seven < 0, {seven = seven + 7}, {seven = seven + 0})
}
)

~addSeven.value(-10); // should return -3
~addSeven.value(0); // should return 0
~addSeven.value(15); // should return 15

/*
Write a function called `isFreezing` that posts the string "It's cold outside" if called
with a number less than or equal to 32 and posts the string "It's above freezing" otherwise.
*/

(
~isFreezing = {
	arg degree;
	if (degree > 32, {"It's above freezing".postln}, {"It's cold outside".postln})
}
)

~isFreezing.value(10); // should post `It's cold outside`
~isFreezing.value(32); // should post `It's cold outside`
~isFreezing.value(33); // should post `It's above freezing`

/*
Write a function that posts "Say this tongue twister ten times fast" ten times.
*/

(
~tongueTwister = {
	10.do({"Say this tongue twister ten times fast".postln });
}
)

~tongueTwister.value; // Should post "Say this tongue twister ten times fast" ten times.


/*********************
 * FUNCTION PRACTICE *
 *********************/

/*
Write a function called `isBetween` that takes a number, lower bound as a number, and
a higher bound as a number and returns `true` if the number is between those bounds
inclusive and `false` otherwise.
*/

(
~isBetween = {
	arg check, lower, higher;
	if (((check - lower) >= 0) && ((higher - check) >= 0),{"true".postln},{"false".postln})
}
)


~isBetween.value(3, 2, 7); // should return `true`
~isBetween.value(2, 2, 7); // should return `true`
~isBetween.value(7, 2, 7); // should return `true`
~isBetween.value(1, 2, 7); // should return `false`
~isBetween.value(9, 2, 7); // should return `false`

/*
Write a simple function that accepts a string like "hello" and returns a new string with
exclamation points appended. The number of exclamation points is determined by the index.  For
example, ~exclamation.value("hello", 3) returns "hello!!!".  You can assume the input string is
in fact a string and that the index is a non-negative integer.  Note, two strings can be
concatenated together with the ++ operator.
*/
(
~hidaniel = {
	arg plop, secnum,
	if ((secnum > 0),
		{plop == plop ++ "!";
		~hidaniel.value(plop, secnum - 1)},
		{""});
}
)

(
~exclamation = {
	arg text, num;
	var exclamate, statement;

	//exclamate = num.do({"!".postln});
	while ({num > 0},{
		text = text ++ "!";
		num = num - 1});
	text.postln;
};
)


~exclamation.value("hello", 3); // Should return hello!!!
~exclamation.value("", 1); // Should return !
~exclamation.value("andy", 0); // Should return andy

/*
Write a function called `hasChar` that takes a string and a single character
and returns `true` whether that string has that character and `false` otherwise.  Note that
Char is actually a distinct type from string.  To access a character in a string use
the index operator [ ].
*/

(
~hasChar = {
    arg input, cha;
    var bool= False;
    for(0,input.size-1, {arg x;
        if (input.containsStringAt(x, cha.asString), {bool = True}, {})});
	bool;
};
)


~hasChar.value("Andy", $A); // Should return `true`
~hasChar.value("Andy", $a); // Should return `false`
~hasChar.value("Andy", $d); // Should return `true`
~hasChar.value("", $z); // should return `false`

/*
Below, write a function called `~gcf` that takes two positive integers and returns
the greatest common factor of those two numbers.  Remember a factor is a number
that divides in evenly to another number with no remainder.  There are many ways
to approach this problem.  An efficient solution has actually been around for
hundreds of years: https://en.wikipedia.org/wiki/Euclidean_algorithm.  You don't
have to approach the problem this way.  We will not concern ourselves with efficiency.

It turns out that calculating the greatest common factor will become important
when we start dealing with frequencies, sinusoids and our perception of pitch.  So
it's good to start thinking about this now.
*/

(
~gcf = {
	arg numone, numtwo;
	gcd(numone,numtwo);
	//i found this when reading documentation on arrays, which was actually kind of funny
};
)

~gcf.value(16, 6); // Should return 2
//~gcf.value(16, 27); // Should return 1
//~gcf.value(1071, 462); // Should return 21
//~gcf.value(12324, 120); // Should return 12

/*
Write a function below called ~gcf_list that computes the greatest common factor from a list of numbers.
This can be done iteratively.  Given an array of numbers [a, b, c], one can compute
the GCF of the list by taking the GCF of a and b and then taking the GCF
of that result and c.  In other words, ~gcf.value(~gcf.value(a, b), c).  To compute
the GCF of four elements, we simply take the GCF of the fourth element with the GCF of
the three elements.  This pattern extends to any number of positive integers in the list.

You should call your implementation of `~gcf` in `~gcf_list`.
*/

(
~gcf_list = {
	arg arr;
	var len, counter = 1, currentgcf;
	len = arr.size;
	if ((len > 1), {currentgcf = ~gcf.value(arr[1], arr[2])},{currentgcf = arr[0]});
	//len.postln;
	currentgcf.postln;
};
)


~gcf_list.value([43, 7, 2]); // should return 1
~gcf_list.value([1024, 64, 128]); // should return 64
~gcf_list.value([75, 25, 45, 105]); // should return 5
~gcf_list.value([100]); // should return 100

//while({len >= counter}, {
		//currentgcf = ~gcf.value(currentgcf, arr[counter + 2]);
		//counter = counter + 1;
	//});


/*************************
 * READING DOCUMENTATION *
 *************************/

/*
Reading documentation is an important skill as a programmer.  Documentation for a
language details all the types, constructs, and nuances of the language.
Memorizing the basics of any language is important but many tasks require
examining the documentation.  In these exercises, I will ask you to complete
some tasks using methods and objects we have not dicussed in class.  You should
refer to the documentation in the Help Browser.  A good way to start is by looking
up the particular class you are working with.  For example, if the question revolves
around arrays, spend some time reading over the Array class documentation.

Objects in SuperCollider inherit methods from their parent objects. In other words,
the methods of a particular class include those that are defined for the class as well
as those defined for its parent class, its parent's parent, and so forth. For
example, the Array class inherits methods from ArrayedCollection which inherits from
SequenceableCollection which inherits from Collection which inherits from Object.
Therefore, the Array class has all the methods from those other classes as well.
The top of the documentation for a particular class will always detail the inheritance
tree.  Importantly, this means that the solution to a problem in the Array class
actually will be found in a method detailed in the Collection class.  It's generally
a good idea to read through the documentation of each parent class.

In these next few problems, you will write a single line of code that uses a method
found in the documentation to solve each problem.  The first one is done as an
example.
*/

/*
Write a single line of code that returns a new array that rotates the array `arr` by one.
*/

(
var arr = [1, 2, 3, 4, 5]; // should work for any array
arr.rotate(1); // Single line of code
)

/*
Write a single line of code that returns a new array of only the odd numbers from `arr`.
*/

(
var arr = [27, 1, 17, 4, 2, 9]; // should work for any array

arr.do({arg i; if (i.odd, {i.postln})});
// Your single line of code her
)
/* if( false, { "condition is TRUE".postln;}, {"condition is FALSE”.postln;});

Write a single line of code that takes the array `arr` and returns a new
array with all nesting removed.  For example you should return an array
of [1, 2, 3, 4, 5] if the original array is [1, [2, [3, 4, [5]]]].
*/


(
var arr = [3, [4, 5], [[1, 2]]]; // should work for any array
arr.flat.postln;
)

/*
Write a single line of code returns a new string that is a reversal of the
string `str`
*/

(
var str = "Testing"; // should work for any string
// Your single line of code here
str.reverse.postln;
)

/*
Write a single line of code that creates a new array of the square of every
number from 1 to 100 (i.e., [1.0, 4.0, 9.0, ... 10000.0])
*/

(
Array.fill(100, { arg i; i.squared });
)

/*
Write a single line of code that counts the number of vowels in a string
regardless of case.
*/

(
var str = "sEquOia"; // should work for any string here
var count = 0;
while({index < str.size}, {var index = 1, if(str[index].isVowel; {count = count + 1}); index = index + 1});
count.postln;

)
/**********************
 * CHALLENGE EXERCISE *
 **********************/

/*
Mapping Notes to Frequencies

The letter naming convention of notes in Western music identifies pitch but does not
indicate in which octave a pitch falls.  For example, the note A could be an A on a
flute or an A on a tuba.  To distinguish between the octave of a note, we can use
"scientific pitch notation" which specifies both the note and the octave that the note
is in.  For example, A4 is A in the 4th octave (a.k.a, concert A).  We can also
identify specific notes using their frequency.

Your task is to take a list of notes in scientific pitch notation and convert them to
their frequencies.  Implement the function ~notesToFreqs which accepts two arguments:
1) an array or list of notes in scientific pitch notation, and 2) a mapping dictionary
where the keys are pitches in scientific notation and whose values are frequencies of
those notes in the 0th octave.  You can assume that all of the note names of the note array
in scientific pitch notation can be found in the dictionary. You can also assume that all
octaves are from 0 to 9.  ~notesToFreqs should return an array (not a list!) of those
frequencies.

To calculate the correct frequency based on the octave, the frequency of the nth octave
is always twice the frequency of the n - 1 frequency.  Frequency is based on powers of
two.  For example, A0 = 27.50Hz; A1 = 27.50 * 2 = 55Hz; A2 = 55 * 2 = 110Hz;
A3 = 110 * 2 = 220Hz; A4 = 220 * 2 = 440Hz; ... etc.

This is an advanced problem and will require to sort through the documentation to think
about the best way to solve this problem.
*/

(
~notesToFreqs = {
	arg arrayOfNotes, mapping;
	// Your code here
};
)

(
~arrayOfNotes = ['A4', 'C#3', 'Eb7', 'Gb2'];
~mapping = Dictionary.newFrom(List['C', 16.35, 'C#', 17.32, 'Db', 17.32, 'D', 18.35,
	'D#', 19.45, 'Eb', 19.45, 'E', 20.60, 'F', 21.83, 'F#', 23.12, 'Gb', 23.12, 'G', 24.50,
	'G#', 25.96, 'Ab', 25.96, 'A', 27.50, 'A#', 29.14, 'Bb', 29.14, 'B', 30.87]);
)
~notesToFreqs.value(~arrayOfNotes, ~mapping).postln; // Should post [ 440.0, 138.56, 2489.6, 92.48 ]

// Add your own testing here if you like