FLAGS = -g -fprofile-arcs -ftest-coverage -Wall
.PHONEY: clean
makeThis: myMake.o helpers.o
	gcc $(FLAGS) myMake.o helpers.o -o makeThis

myMake.o: myMake.c
	gcc $(FLAGS) -c myMake.c -o myMake.o

helpers.o: helpers.c helpers.h
	gcc $(FLAGS) -c helpers.c -o helpers.o

clean:
	rm *.gcda *.gcno *.o
