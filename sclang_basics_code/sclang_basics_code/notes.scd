/************************** Basics of SuperCollider **************************/

/*********
 * Types *
 *********/

// Below are examples of several types in SuperCollider.  Every evaluated block of
// code (in Jupyter Notebooks, this is simply a cell) always returns the last
// expression calculated by the block of code.  The returned value is indicated in
// the post window by the prompt `->`.  In the SuperCollider IDE, a block of code
// is determined by highlight the block and hitting CMD plus Enter (MacOS).

4 // Integers

3.0 // Floats

"3" // Strings

true // Booleans

false // Booleans

nil // Equivalent to Python's None

// To get the type of any object in SuperCollider, use the `.class` method.

4.class

"3".class

true.class

/*************************************
 * Operators and Operator Precedence *
 *************************************/

// Here are some examples of some of the important operators for sclang.

3 < 4 // Relational operator

"panda" <= "zebra" // Strings with relational operators are evaluated by dictionary order.

true && false // Logical and

true || false // Logical or

true.not // Logical not is a method

// Predict the output of the cell below

3 + 2 * 4

// Operator precedence is determine from left to right regardless of your
// "intuition" about operator precedence.  For example, PEMDAS is not used for
// mathematical operators.  Parentheses are the only way to force the precedence of
// some expression.


// Predict what the output of the following expressions are:

(3 < 4) || (3.1 > -1)

(3 < 4) && (3.1 < -1)

3 + 4 < 9

4 - 2 < 3 + 4

/***********
 * Posting *
 ***********/

// Like any good programming language, printing can be done using the `.postln` or
// `.post` methods.  `.postln` prints to the post window and adds a newline
// character to the end.  `.post` simply prints to the post window.  Remember that
// any block of code returns the last expression evaluated so you will see both the
// return value **and** the posted text in the post window.

4.postln;

"Hello world".post; // Writes message to the post window without a newline

/***********************
 * Strings vs. Symbols *
 ***********************/

// SuperCollider has three forms of text: strings, symbols and characters.  Strings
// are denoted with double quotes, symbols with single quotes, and characters are
// actually created using the `.ascii` or `.asDigit` methods from the Integer
// class. Both strings and symbols are sequences of characters.


// The difference between strings and symbols according to the documentation:


// "Unlike strings, two symbols with exactly the same characters will be the exact
// same object. Symbols are optimized for recreating the same symbol over and over
// again. In practice, this means that symbols are best used for identifiers or
// tags that are only meaningful within your program, whereas you should use a
// string when your characters are really processed as text data. Use symbols to
// name things, use strings for input and output."


// Practically, strings provide much more flexibility for text processing with many
// additional methods.

"This is a string".class

'This is a symbol'.class

// Symbols can also be created by using a backslash.  If using the backslash, then
// the symbol must contain no spaces and only alphanumeric characters.

\hello.class

// Strings offer many convenience methods for string processing that symbols simply
// do not have.

"Hello world".find("world") // Find the starting index of the substring

'hello world'.find('world') // Will cause an error because there is no `find` method

/********
 * Char *
 ********/

// Strings are simply an array of characters.  We can access the characters in a
// string using indexing.

"Andy"[0]

"Andy"[4] // No index out of bounds error - simply evaluates to `nil`

// Characters are distinct types from strings.

"Andy"[0].class

// To write a literal character use the `$` before the character name.

$A // The character `A`

$A == "A" // Note that these are not equivalent because they are not the same type

// Note that while symbols are a collection of characters, we cannot access the
// characters within a symbol.  All text-based operations should be done with
// strings.  Symbols are a convention for naming.

/*****************
 * The Semicolon *
 *****************/

// Multiple expressions and statements need to be separated by semicolons.
// Evaluating a single expression or statement does not require the use of a
// semicolon.

(
4.postln;
3.postln
)

4.postln; 3.postln

/*************
 * Variables *
 *************/

// There are several different kinds of variables in SuperCollider:


// 1. Interpreter variables

// 2. Environment variables

// 3. Local variables

// #### Interpreter Variables

// Interpreter variables are global variables that persist throughout any sclang
// session.  SuperCollider provides 26 interpreter variables (the letters a through
// z).  The interpreter variable `s` is reserved specifically for communication
// with the audio server.  **YOU SHOULD NEVER REASSIGN `S`**.

a = 3 // binding of the value 3 to the interpreter variable a

a

// #### Environment Variables

// An environment is similar to a namespace in other languages.  An environment
// holds a series of global variables assigned through the use of a tilde.
// SuperCollider can switch between various environments.

~myVar = 4 // binding of the value 4 to the environment variable myVar

~myVar

currentEnvironment // see the bindings in the current environment

~myVar2 = "Hello"

currentEnvironment

// In general, you should not worry about in which environment you are working.  We
// will rarely, if ever, have a need to put global variables in separate
// environments.  Feel free to use interpreter variables as global variables
// throughout your program.

// #### Local Variables

// Local variables are variable whose scope extends only to the code block in which
// it was declared.

(
var myVar = 4 * 3;
myVar.postln
)

// We cannot access the variable myVar again because it was local only to block
// above.  This will produce an error that complains that the variable myVar is not
// defined.

myVar

/********************************** Functions **********************************/

// Below is a simple function in sclang.  Functions are declared using curly
// brackets.  Parameters are declared using vertical pipes.  Functions return the
// **last expression evaluated**.  There is no explicit return statement.
// Functions can be assigned to a variable in order to refer to them.

~square = {|x| x * x}

~square.value(4)

~square.value(3)

// Function parameters can also be declared using the keyword arg.

~square = {arg x; x * x}

~square.value(4)

~square.(4) // A shorthand for the .value method

value(~square, 4) // Alternate syntax.  Give the method name first.

// Local variables can also be declared within functions.  **All local variables
// must be declared at the top of the function's body**.

(
~distance = {
    arg x1, y1, x2, y2;
    var distance;
    distance = ((y2 - y1) ** 2) + ((x2 - x1) ** 2); // note parentheses
    distance.sqrt // Last expression evaluated is returned
}
)

~distance.value(2, 1, 5, 5)

// Note how the code below which computes the same result throws an error because
// the variable `result` is not declared at the top.

(
~distance = {
    arg x1, y1, x2, y2;
    var distance;
    distance = ((y2 - y1) ** 2) + ((x2 - x1) ** 2);
    var result = distance.sqrt;
    result
}
)

/******************************** Conditionals ********************************/

// SuperCollider uses the following control structure for conditionals:


// `if(expr, trueFunc, falseFunc)`


// A conditional in sclang evaluates the expression.  If the expression is true,
// then the true **function** is evaluated.  If the expression is false, then the
// false function is evaluated.  Furthermore, the if syntax is not a statement, it
// is an expression and will return the value of the true branch or the false
// branch.

(
var num = 4;
if(num > 3,
    {"Your number is greater than 3.".postln}, // True branch
    {"Your number is less or equal to 3.".postln} // False branch
);
)

// You can omit the else branch if you like as well.

(
var num = 4;
if(num > 3,
    {"Your number is greater than 3.".postln;}
)
)

// Remember that `if` is an expression.  If one of the branches is not defined, the
// if expression will resolve to `nil` if called.

(
var num = 2;
if(num > 3, // This will take the false branch that is not defined
    {"Your number is greater than 3.".postln;}
)
)

/********************************** Practice **********************************/

// Write a function `~sparta` that always returns the number 300.

(
// Your code here

~sparta = {300}
)

~sparta.value()

// Write a function called `~excited` that takes a string and returns the string
// with three exclamation points.  String concatenation can be done with the `++`
// operator.

(
// Your code here

~excited = {
    |str|
    str ++ "!!!"
}
)

~excited.value("Hooray")

~excited.value("Music")

// Write a function called `~absValue` that returns the absolute value of a number.

(
// Your code here

~absValue = {
    arg num;
    if(num < 0, {-1 * num}, {num})
}
)

~absValue.value(4)

~absValue.value(-3)

// Write a function called `isSpeeding` that takes a number and prints out "Slow
// down!" if the number is greater than 65 and does nothing otherwise.

(
// Your code here

~isSpeeding = {
    |speed|
    if(speed > 65, {"Slow down".postln})
}
)

~isSpeeding.value(70)

~isSpeeding.value(60)

// Write a recursive function `~fact` that computes the factorial of a number.

(
// Your code here

~fact = {
    |x|
    if (x == 0, {1}, {x * ~fact.value(x - 1)})
}
)

~fact.value(4)

~fact.value(1)

// Here's a little bit more a challenge.  Write a recursive function that takes a
// number `i` and computes the `i`th fibonacci number.  Here's a little info on the
// Fibonacci sequence: <https://en.wikipedia.org/wiki/Fibonacci_number>

(
// Your code here

~fib = {
    |i|
    if((i == 0) || (i == 1),
        {i},
        {~fib.value(i - 1) + ~fib.value(i - 2)}
    );
}
)

~fib.value(0) // should return 0

~fib.value(1) // should return 1

~fib.value(2) // should return 1

~fib.value(4) // should return 3

~fib.value(8) // should return 21

/************************************ Scope ************************************/

// SuperCollider has both lexical and dynamic scoping.  Lexical scoping allows for
// inner contexts to have access to outer variables as shown in the example below.
// The variable `num` referred to in `func` references the `num` declared on the
// first line.

(
var num = 4;
var func = {
    num + 1 // references num from first line
};
func.value(4)
)

// With environment variables, we can use dynamic scoping.  This means we can use
// environment variables in functions or other parts of our code before they have
// been defined.  All that matters is that the environment variable has been
// defined by the time the function/code is called/executed.

(
~func = {
    ~bar + 1 // no error!
}
)

// When we evaluate below, this throws an error because `~bar` is not defined.

~func.value()

// Once we assign `~bar` to a value though, everything will work.

~bar = 3

~func.value()

/********************************** Iteration **********************************/

/***************
 * While Loops *
 ***************/

// While loops are the best control structure for iteration in SuperCollider.
// SuperCollider does have syntatic sugar for for loops; however, there are edge
// cases with sclang for loops that are unintuitive.  We will discuss them
// momentarily.


// While loops in sclang have the following syntax:


// `while(testFunc, evalFunc)`


// A while loop in sclang evaluates the test function.  If the result is `True`
// then the evaluating function is evaluated.  If the result is `False`, the loop
// terminates.

(
var i = 0;
while({i < 4}, {
    i.postln;
    i = i + 1
});
)

(
// This block of code does repeated string concatenation

var string = "CDE";
var numIterations = 4;

var result = "";
var i = 0;
while({i < numIterations}, {
    result = result ++ string;
    i = i + 1
});
result
)

// Here is an example below of using iteration within the context of a function.
// This function computes the factorial of a number using iteration.

(
// Iterative code for computing factorial

~factIterative = {
    |num|

    var count = 1;
    var i = 1;
    while({i <= num}, {
        count = count * i;
        i = i + 1
    });
    count // last expression is returned
}
)

~factIterative.value(4)

~factIterative.value(8) // Should be 40320

~factIterative.value(1)

~factIterative.value(0)

/*************
 * For loops *
 *************/

// For loops in sclang are different than other languages.  For loops iterate over
// an integer series.


// `for ( startValue, endValue, function )`


// The for loop begins at the start value and increments by one up to and
// **including the end value**.  The function passed as the third argument can
// capture the iteration value using an argument.

for(1, 3, {|x| x.postln})

for(-2, 7, {|x| x.postln})

for(1, 1, {|x| x.postln}) // 1 is printed!

// If the second number is less than the first, then the loop decreases by one.

for(1, 0, {|x| x.postln}) // 1 and 0 is printed!

// **IMPORTANT:** for loops in sclang can work improperly with certain edge cases
// if there are scenarios where the loop should never execute.

/************
 * Do loops *
 ************/

// An alternative to for loops are do loops which are actually a method for
// integers.


// `int.do(function)`


// The function like the one in the for loop can capture the iteration number using
// an argument.

3.do({|x| x.postln})

0.do({|x| x.postln})

// When in doubt, use a while loop.  There are other syntactical structures for
// iteration that are conveniences.  A while loop will work in any scenario where
// you need iteration.

/***********************
 * Iteration Exercises *
 ***********************/

// Write a function called `~partials` which takes a number `fund` that represents
// the frequency of a particular sound and `numPartials` which represents the
// number of partials. We will learn soon that sound is composed of frequencies and
// that single notes often contain multiple frequencies called partials.  These
// partials tend to follow a particular pattern called the harmonic series.


// For example, given a frequency 440 (Concert A), the partials of 440 are simply
// multiples of 440.  The first five partials of 440 are 440, 880, 1320, 1760, and
// 2200.  Your function `~partials` should print out `numPartials` partials of a
// given frequency `fund` indicating the fundamental frequency of a note.


(
~partials = {
    arg numPartials, funds;

	var i = 1;
	var partials;


	while({i <= numPartials},{
		(i * funds).postln;
		i = i + 1
	});

}
	}


~partials.value(440, 5)

~partials.value(300, 1)

~partials.value(100, 30)

~partials.value(50, 0) // should print nothing

// Write a function `~countNumsInString` which takes a string and reports the
// number of decimal digits (i.e., the characters 0 - 9) in the string.  For
// example, the string `"abc123"` has three digits.  To solve this, you need to
// know that strings are arrays of characters.  To get the ith character from a
// string `str` simply use `str[i]`.  The `.isDecDigit` method returns a boolean
// stating whether the character is a decimal digit and the `.size` method gets the
// length of a string.

(
// Your code here

~countNumsInString = {
    |str|
    var i = 0;
    var count = 0;

    while({i < str.size}, {
        if(str[i].isDecDigit, {count = count + 1});
        i = i + 1;
    });
    count
}
)

~countNumsInString.value("a12b")

~countNumsInString.value("4a341b")

~countNumsInString.value("")

/*********************************** Arrays ***********************************/

// Arrays in sclang are an ordered collection of any item.  In many ways, they are
// similar to lists from Python.  Arrays though are used for fixed size storage.
// We do not accumulate arrays like we typically do in Python.  It turns out that
// this is not something we typically need for musical purposes.


// Literal arrays are declared using brackets with commas to delineate each item in
// the list.

~listOfNums = [42, 3, 0, -9, 17]

~listOfNums.class

// You can use indices and the indexing operator `[ ]` to get the elements in the
// array.

~listOfNums[3]

// You can also change the elements in the array as well using an assignment
// statement

~listOfNums[0] = 4 // Change index 0 to be 4

// You can also create an immutable array using the hashtag in front of the array.

~myList = #[1, true, nil, 0.9]

~myList[1] = false // we can't change the array because it is immutable

// Iterating over an array is easy with a `.do` loop.  The function for the `.do`
// loop can accept arguments for both the item and the index.

(
~listOfNums.do({
  arg item, i;
  ("Item:" + item.asString + "| Index:" + i.asString).postln;
})
)

/*******************
 * Array Exercises *
 *******************/

// Write a function called `~allPositive` that takes a list of numbers and returns
// `true` if every element in the list is positive and `false` otherwise.

(
// Your code here
~allPositive = {
  arg numList;
  var isPositive = true;

  numList.do({
    arg item;
    if(item <= 0, {isPositive = false;})
  });
  isPositive
}
)

~allPositive.value([45, 3, 1])

~allPositive.value([-5, 4])

// The end.

