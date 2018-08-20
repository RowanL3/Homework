% 3. L33t Translator. (12 lines)

% If the first argument is an ascii representation of a uppercase letter retruns
% the ascii representation of the lowercase version of it. Returns the same char
% if not. This works because upper case characters always between 89-64, and
% there lowercase counterparts are always 32 higher.
asciiLC(C,C) :- C >= 89.
asciiLC(C,C) :- C =< 64.
asciiLC(C,L) :- C < 89, C > 64, L is C + 32.


% Lowercases a list of ascii values.
toLower([], []).
toLower([C|AnyCase], LowerCase) :- asciiLC(C,L),
				toLower(AnyCase, LCTail),
				append([L], LCTail, LowerCase).
% Replaces English characters with leet characters in the given list of ascii
% values.
english2l33t([], []).
english2l33t([X|Rest], Leet) :- translate([X], AsciiChar),
			english2l33t(Rest, LeetTail),
			append(AsciiChar, LeetTail, Leet).
			
% Top level function for this section, lowercases and 1337izes the English text
l33t(English, Leet) :- toLower(English, LowerAscii),
			english2l33t(LowerAscii,LeetAscii),
			name(Leet, LeetAscii).

% 4. Facebook Database. (8 lines)
				
% Returns a list of possible paths of length <= maxLength from 'From' to 'To',
% without using the same person twice.
% Using unity as our base case, our recursive step will be to shorten a
% possible path by one an append the current node to that list. 
fb(From, From, _, [From]). 
fb(From, To, MaxLength, Result) :- MaxLength >= 0,
			        friend(From, X),
				MaxSub1 is MaxLength - 1,
				fb(X, To, MaxSub1, Res),
				not(member(From, Res)), % (*) 
				append([From], Res, Result).
% (*) Necessary to prevent paths like A -> B -> A -> C

% Prints all paths of length <= max between A,B.
fball(A,B,Max) :- forall(fb(A, B, Max, Res), writeln(Res)).

% 5. Generating vanity plates. (13 lines)

% Top level function for this section, should print out all possible 
% substitutions on all vanity plates given in short.txt.
vanity :- forall(rulesOnWord(S,SS,V), printSub(S,SS,V)).

% prints the substitution in S of SS for V in the format given by the spec:
%   ([a,n,t,e,a,t,e,r]-->[a,n,t,e,8,r]).
% Note, considered the first 2 calls of append to mean: S = Pre + SS + Post,
% where Pre and Post are free variables. In other words what parts of S are
% before and after SS?
printSub(S,SS,V) :- append(Pre, SS, X),
		append(X, Post, S),
		append(Pre, V, Y),
		append(Y, Post, R), 
		write(S),
		write(-->),
		writeln(R).

% True iff S is in SS and V is a valid substitution for V, given in rules.pl
rulesOnWord(S,SS,V) :- word(S),
		    rule(SS,V),
		    subString(S,SS).

% True iff SS is a substring of S.
subString(S,SS) :- name(NSS,SS),
		name(NS,S),
		sub_string(NS,_,_,_,NSS).
