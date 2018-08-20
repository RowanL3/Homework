lineSort: utilities.o lineSort.o
	gcc -Wall -lgcov utilities.o lineSort.o -o lineSort

utilities.o: utilities.c utilities.h
	gcc -Wall -fprofile-arcs -ftest-coverage -c -g utilities.c -o utilities.o

lineSort.o: lineSort.c 
	gcc -Wall -fprofile-arcs -ftest-coverage -c -g lineSort.c  -o lineSort.o

#clean:
	#rm lineSort.gcda utilities.gcda 