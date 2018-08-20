.PHONEY: all
all: test_arrayFlex_01_eachCall_s test_arrayFlex_02_s 
	
test_arrayFlex_01_eachCall_s: test_arrayFlex_01_eachCall.o arrFlex.o
	gcc -Wall arrFlex.o test_arrayFlex_01_eachCall.o -o test_arrayFlex_01_eachCall_s

test_arrayFlex_02_s: test_arrayFlex_02.o arrFlex.o
	gcc -Wall arrFlex.o test_arrayFlex_02.o -o test_arrayFlex_02_s

test_arrayFlex_01_eachCall_e: test_arrayFlex_01_eachCall.o example_arrFlex.o
	gcc -Wall test_arrayFlex_01_eachCall.o example_arrFlex.o -o test_arrayFlex_01_eachCall_e

test_arrayFlex_02_e: test_arrayFlex_02.o example_arrFlex.o
	gcc -Wall example_arrFlex.o test_arrayFlex_02.o -o test_arrayFlex_02_e


arrFlex.o: arrFlex.c arrFlex.h
	gcc -fprofile-arcs -ftest-coverage -g -Wall -c arrFlex.c -o arrFlex.o


test_arrayFlex_01_eachCall.o: test_arrayFlex_01_eachCall.c 
	gcc -Wall -c -g test_arrayFlex_01_eachCall.c -o test_arrayFlex_01_eachCall.o

test_arrayFlex_02.o: test_arrayFlex_02.c 
	gcc -Wall -c -g test_arrayFlex_02.c -o test_arrayFlex_02.o

clean:
	rm arrFlex.o test_arrayFlex_01_eachCall.o test_arrayFlex_02.o

