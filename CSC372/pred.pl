%yes(A,or,B) :- yes(A).
%yes(A,or,B) :- yes(B).



wff(A) :- word(A).
wff(nt(A)) :- wff(A).
wff(imp(A,B)) :- wff(A), wff(B).

and(A,B) :- nt(imp(A,nt(B))).
or(A,B) :- imp(nt(A),B).
eq(A,B) :- and(imp(A,B),imp(B,A)).

inv(0,1).
inv(1,0).

v(t,1).
v(f,0). 

v(nt(A),0) :- v(A,1).
v(nt(A),1) :- v(A,0).

v(imp(A,B),1) :- v(A,1),v(B,1).
v(imp(A,B),0) :- v(A,1),v(B,0).
v(imp(A,B),1) :- v(A,0),v(B,1).
v(imp(A,B),1) :- v(A,0),v(B,0).

v(and(A,B),1) :- v(A,1),v(B,1).
v(and(A,B),0) :- v(A,1),v(B,0).
v(and(A,B),0) :- v(A,0),v(B,1).
v(and(A,B),0) :- v(A,0),v(B,0).

v(or(A,B),1) :- v(A,1),v(B,1).
v(or(A,B),1) :- v(A,1),v(B,0).
v(or(A,B),1) :- v(A,0),v(B,1).
v(or(A,B),0) :- v(A,0),v(B,0).

%v(or(A,B),N) :- imp(nt(A),B).
%v(eq(A,B),N) :- and(imp(A,B),imp(B,A)).

word(t).
word(f).
