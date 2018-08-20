:- use_module(library(random)).
% Rowan Lochrin

% - Description -
% Idea of this was basically to use markov chains based on a loadable
% text like War and Peace but favor words that the users used and use backtracking
% to try and find links to the words. I tried something like this in python and it
% worked pretty well.
% However while writing this project I realized that prolog is not able to create
% enough items in dynamic memory to store enough pairs to make this really viable.
% After much searching I discovered that, This is because there is a hard cap on
% the number of items in dynamic memory 
% That limits the number of possible pairs so you usually get fairly boring 
% sentences that don't contain user input, however occasionally it produces some 
% pretty interesting pros along the lines of:
% 	> How do you start a fire.
% 	: I am only fire.
% But mostly stuff like this:
% 	> This is a test of my program.
% 	: kissed her social vocation and tell me and tell me
% - Instructions -
% FIRST
% 'loadFile(filename)' to load in a source file from which converstaions % will be 
% based. 
% loadFile(wap). % loads an included copy of war and peace.
%
% NEXT
% enter 'main.', and type a sentence.
% NOTE
% You might have to enter a few lines in order for it to have enough of your words
% to find ways to use any. Works best when your talking about things in your source
% file e.g. You might not get to many responses about your friend Alice unless you
% loaded up Alice in Wonderland.


% Should be used to keep track of pairs of words loaded from files.
:- dynamic pair/2. % dynamic duo
% Should be used to keep track of words used by the user, the idea here is to 
% create chains that prioritize user words so it looks look the computer is
% talking about the same things you are.
:- dynamic used/1.


% MAIN
main :- getsentence(S),
	loadUsed(S),
	randomWord(Seed),
	sentence(Seed, 10, O),
	printSentence(O),
	main.

printSentence([]) :- nl.
printSentence([S|SS]) :- write(S), write(" "), printSentence(SS).
% LOADFILE 
% MUST BE RUN IN ORDER TO THE PROGRAM TO WORK (try 'loadFile(wap)')
% Should be called to load all the pairs that will be used for the central markov
% function, as touched on above we cannot store all the pairs of word in War and 
% Peace. This kind of cripples the program along with then the massive size of the
% search space but it works OK.
loadFile(Filename) :- open(Filename, read, OS),
			nextWord(OS, W),
			loadCorpus(OS, W).


%  Load the words the user uses into a database, so that hopefull they will be 
%  spit back out.
loadUsed([_]).
loadUsed([W|WS]) :- boring(W), loadUsed(WS).
loadUsed([W|WS]) :- assert(used(W)), loadUsed(WS).

randomPair(S0,S1) :- findall(X, pair(S0, X), L),
			random_member(S1, L).	

% Gives a random word to start the sentence.
randomWord(S) :- findall(X, pair(X,_), L),
			random_member(S, L).	

% Words used to start the sentence
swap(W, WS) :- pair(X, W), pair(X, WS), W \= WS.

% Should get word after W1 in the sentence, ordered in terms of priority 
next(W, WN) :- pair(W, WN), used(WN), !. % If possible include a user term
next(W, WN) :- swap(W,WS), pair(WS,WN), pair(W,WN), !. % Else use a 'strong' pair
next(W, WN) :- pair(W,WN), !.
next(W, WN) :- randomPair(W,WN), !.
next(_, WN) :- randomWord(WN), !. % Used to catch case where (X,Y) but not (Y,_)
next(_, the). % Goes to the if there are no other options 

% The core function should return a sentence constructed by markov chains
sentence(_, 0, ['.']).
sentence(W1,N,R) :- N1 is N - 1, next(W1,W2), sentence(W2,N1,R1), append([W1],R1,R).

% Recursive part of load word, asserts every pair of words in the text.
loadCorpus(_, '').
loadCorpus(In, L0) :- nextWord(In, W), 
			assert(pair(L0, W)),
			loadCorpus(In, W).

% Common words used to make sure the program doesn't focus to much on user inputs 
% like 'is' and 'the', these should have no effect on words loaded from file.
boring(the).
boring(be).
boring(to).
boring(of).
boring(and).
boring(a).
boring(in).
boring(that).
boring(have).
boring(i).
boring(it).
boring(for).
boring(not).
boring(on).
boring(with).


% Helper method next word
% This works by cutting recursion when we reach one of our characters, and was 
% inspired by: http://cs.union.edu/~striegnk/learn-prolog-now/html/node106.html
 
nextWord(In, W) :-
        get0(In, C),
        nextBlankSpace(C, CS, In),
        atom_chars(W, CS).
 

nextBlankSpace(10, [], _) :- !.
nextBlankSpace(32, [], _) :- !.
nextBlankSpace(-1, [], _) :- !.
nextBlankSpace(end_of_file, [], _) :- !.
nextBlankSpace(Char, [Char|Chars], InStream) :-
        get0(InStream, NextChar),
        nextBlankSpace(NextChar, Chars, InStream).

% INSTRUCTOR CODE BELLOW 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Read a sentence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getsentence(Words, In, Out) :-
   get0(C),
   ((C = 46, name(W, In), append(Words,[W],Out), !); 
    (C = 32, name(W, In), append(Words,[W],Words1), getsentence(Words1, [], Out));
    append(In,[C],In1), getsentence(Words, In1,Out)).

getsentence(Words) :-
   getsentence([],[],Words).

% Read sentence and map chars to atoms.
readsentence(S1) :-
   getsentence(R),
   mapwords(R, S),
   strip(S, S1).

% Strip blanks
strip_initial([],[]).
strip_initial([blank|S],R) :-
   !, strip_initial(S,R).
strip_initial(S,S).

strip_final(S,R) :-
   reverse(S,S1),
   strip_initial(S1,S2),
   reverse(S2,R).

strip_inside([],[]).
strip_inside([blank,blank|S],R) :-
   !, strip_inside([blank|S],R).
strip_inside([blank|S],[blank|R]) :-
   !, strip_inside(S,R).
strip_inside([C|S],[C|R]) :-
   strip_inside(S,R).

strip(S,R):-
   strip_initial(S,S1),
   strip_inside(S1,S2),
   strip_final(S2, R).

% Split words into letters.
mapwords([W|WL],S) :-
   name(W, N),
   mapchars(N, S1),
   mapwords(WL, S2),
   append(S1,[blank|S2], S).
mapwords([],[]).

mapchars([C|N], [C1|S]) :-
   mapchar([C], C1),
   mapchars(N, S).
mapchars([],[]).

mapchar("A",a). mapchar("B",b). mapchar("C",c). mapchar("D",d). mapchar("E",e).
mapchar("F",f). mapchar("G",g). mapchar("H",h). mapchar("I",i). mapchar("J",j).
mapchar("K",k). mapchar("L",l). mapchar("M",m). mapchar("N",n). mapchar("O",o).
mapchar("P",p). mapchar("Q",q). mapchar("R",r). mapchar("S",s). mapchar("T",t).
mapchar("U",u). mapchar("V",v). mapchar("W",w). mapchar("X",x). mapchar("Y",y).
mapchar("Z",z).

mapchar("a",a). mapchar("b",b). mapchar("c",c). mapchar("d",d). mapchar("e",e).
mapchar("f",f). mapchar("g",g). mapchar("h",h). mapchar("i",i). mapchar("j",j).
mapchar("k",k). mapchar("l",l). mapchar("m",m). mapchar("n",n). mapchar("o",o).
mapchar("p",p). mapchar("q",q). mapchar("r",r). mapchar("s",s). mapchar("t",t).
mapchar("u",u). mapchar("v",v). mapchar("w",w). mapchar("x",x). mapchar("y",y).
mapchar("z",z).

mapchar("!", excl_mark).  mapchar("?", quest_mark).
mapchar(".", full_stop).  mapchar(",", comma).
mapchar("-", hyphen).     mapchar(";", semicolon).
mapchar("$", dollar).     mapchar("'",apostrophe).

mapchar("0", 0). mapchar("1", 1). mapchar("2", 2). mapchar("3", 3). 
mapchar("4", 4). mapchar("5", 5). mapchar("6", 6). mapchar("7", 7). 
mapchar("8", 8). mapchar("9", 9). 

mapchar(X, X).
