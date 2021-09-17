//Simple Functions
//1 Add Five
~addFive = {arg num; num+5}
~addFive.value(5);

//2 Add Print Five
~addPrintFive = {arg num; num = num + 5; num.postln;}
~addPrintFive.value(5);

//3 Pluralize
~pluralize = {arg str; str ++ "s";}
~pluralize.value("apple");

//4 Cool Off
~coolOff = {arg temp; if(temp > 80,{"find some shade".postln},{"it's not hot".postln})}
~coolOff.value(2);

//More Functions
//1 Ends in S
~endsInS = {arg str;or(str.last==$s, str.last==$S)}
~endsInS.value("CatS");

//2 count plurals
~countPlurals = {arg arr; var count=0; arr.do({arg i; if(~endsInS.value(i),{count=count+1})});count}
~countPlurals.value(["dogs","problem","sets"]);

//3 Longest Word
~longestWord = {arg arr; var king=""; arr.do({arg i; if(king.size<i.size,{king=i})});king}
~longestWord.value(["dogs","problem","sets"]);

//4 Check Password INCOMPLETE
(
~checkPassword = {arg str;
	var bool = true;
	var hasSpec = false;
	var spec = [$!,$#,$$,$%,$&,$*];
	str.do({arg i; if(i.isUpper,{},{bool=false})});
	str.do({arg i; if(i.isLower,{},{bool=false})});
	str.do({arg i; if(i.isDecDigit,{},{bool=false})});
	str.do({arg i; spec.do({arg n; if(i==n,{hasSpec=true;})})});
	bool.and(hasSpec);}
)
~checkPassword.value("An12!");

