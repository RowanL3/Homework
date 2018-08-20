% Rowan Lochrin
% CSC 372
% 11/15/17

% 3. Magic Squares

% Tests to see if the elements of all rows, columns and diags sum to 15 for a
% 3 X 3 game board.
magic(board(A,B,C,D,E,F,G,H,I)) :- 
	sumTo15(A,B,C), % rows
	sumTo15(D,E,F),
	sumTo15(G,H,I), 
	sumTo15(A,D,G), % cols
	sumTo15(B,E,H),
	sumTo15(C,F,I),
	sumTo15(A,E,I), % diags
	sumTo15(C,E,G).


% X + Y + Z = 15
sumTo15(X,Y,Z) :- Sum is X + Y + Z, Sum = 15.

% 4. Prolog Arithmetic

% Absolute value function, Y will be the absolute value of X.
abs(X,Y) :- X < 0, Y is -X. 
abs(X,X) :- X >= 0.

% Sequence function, A generative range function to test if First <= N <= Last.
seq(First, Last, First) :- First =< Last.
seq(First, Last, N) :- First =< Last, F1 is First + 1, seq(F1, Last, N).

% 5. Chess

% Is true if the position ((R)ow (C)olumn), is on a standard chess board
% where both the rows and columns are indexed from 1 to 8 inclusive.
onBoard(R,C) :- seq(1,8,R), seq(1,8,C).

% True if (X,Y) -> (R,C) represents a valid night move, where (X,Y) are the
% squares the night starts in and (R,C) are the squares where the nights ends 
% in. A knight move is valid if it involves moving vertically one square and
% horizontally two squares or vice versa, and moves to a position that is on
% the board.
knight(X,Y,R,C) :- 
	knightMove(Xshift ,Yshift),
	R is X + Xshift,
	C is Y + Yshift,
	onBoard(R,C).

% Stores valid knight moves in terms of there (Row, Column) displacement. This
% function is designed so that knight tries possible moves in the order
% declared here. This is because knight first starts by looking at possible
% Xshifts and Yshifts that satisfy this function then derive values for R,C
% based on those shifts. The current ordering is clockwise starting from the 
% move +2,-1.
knightMove(2,-1).
knightMove(2,1).
knightMove(1,2).
knightMove(-1, 2).
knightMove(-2,1).
knightMove(-2,-1).
knightMove(-1,-2).
knightMove(1,-2).

% 6. Peano Axioms
% Sum two Peano Axiom numbers, where a Peano Axiom number is of the form:
% 	2 -> succ(succ(zero))
% That is to say '2' is denoted by being the successor of the successor of zero,
% or the successor of the Peano Axiom representation of one.
%
% This method works by striping one succ() from the outside of A and applying
% it to B. When A = zero, we can simply return B. 
% 	zero + B = B -> B = B.
sum(zero,B,B).
sum(succ(A),B,C) :- sum(A,succ(B),C).

% 7. Parts List
has(bicycle,wheel,2).
has(bicycle,handlebar,1).
has(bicycle,brake,2).
has(wheel,hub,1).
has(wheel,spoke,32).
has(bicycle,frame,1).
has(car,steering_wheel,1).
has(car,stereo,1).
has(car,tires,4).

% True if B is required to make A. e.g. bicycles have wheels, and wheels have 
% spokes so wheels and spokes are required to make bicycles.
%
% Works by first considering the case where A has B, e.g. a bicycle 'has' a 
% wheel. The recursive step takes all the things A has and returns true for
% all the things in components the previous list of components of A.
partof(A,B) :- has(A,B,_).
partof(A,B) :- has(A,X,_), partof(X,B). 

% 8. Dating Database

%person(Name,
%       is(IsGender, IsHeight, IsAge, HasEducation),
%       wants(WantsGender, WantsHeightMin-WantsHeightMax,
%                           WantsAgeMin-WantsAgeMax,
%                           WantsEducationMin)).

person(lisa,
	is(female, 170, 30, phd),
	wants(male, 180-190, 30-35, phd)).
person(john,
	is(male, 180, 25, masters),
	wants(female, 150-175, 20-24, high_school)).
person(alice,
	is(female, 165, 22, bachelor),
	wants(male, 175-200, 20-30, bachelor)).
person(bob,
	is(male, 182, 28, bachelor),
	wants(male, 160-190, 20-35, high_school)).
person(charles,
	is(male, 160, 21, high_school),
	wants(male, 180-220, 20-40, high_school)).

edu_less(high_school, bachelor).
edu_less(bachelor, masters).
edu_less(masters, phd).

% True iff L1 is a lower or equal education level then L2. Uses unity as a base
% case. If L1 < L2 will use the level bellow L1 until L1' = L2, and we've
% reached our base case. If not the recursion will continue until edu_less(X,L)
% is False for all 'X'. 
edu_lessOrEqual(L, L).
edu_lessOrEqual(L1,L2) :- edu_less(L1, X), edu_lessOrEqual(X, L2).

% True iff To <= A <=From. Non-generative.
between(A, From-To) :- A =< To, A >= From.

% True iff the person named Person1 can date the Person named Person2. Two 
% people can date iff they satisfy each others 'wants' so we first see if 
% Person1 does this for Person2 and then check the other way around.
dateable(Person1, Person2) :- likes(Person1, Person2), likes(Person2, Person1).

% True iff the person named P2 satisfies the wants of P1.
likes(P1,P2) :- P1 \= P2, person(P1,_,Wants), person(P2,Is,_), compatable(Wants,Is).

% True iff a set of wants is compatible with a set of characteristics.
compatable(wants(WG,WH,WA,WE), is(IG,IH,IA,IE)) :-
	WG = IG, between(IH,WH), between(IA,WA), edu_lessOrEqual(WE,IE).

