/*
* File: collatz.c
* Author: Rowan Lochrin
* Purpose: Computes the collatz sequence for an arbitrary number of inputs
*/ 
#include <stdio.h>

int return_value = 0;

void collatz(int n)
/* collatz(n) -- takes in an int n and prints that int followed by a colon then
 * the collatz sequence for that int. prints an error to stderr if the n is not postive.
 */
{   
    int initial_n = n;
    if (n <= 0){ //Checking to make sure the input is positive
        fprintf(stderr,"ERROR: The input %d cannot be tested, because it is non-positive.\n",n);
        return_value = 1; //Sets the return value of the program to indicate an error occurred
        return; 
    }

    printf("%d:",initial_n);
    while(1){
        if (n % 2 == 0){ //if n is even
            n /= 2; 
        }
        else { // if n is odd
            n = n * 3 + 1;
        }
        printf(" %d",n);
        if (n <= initial_n){
            break;
        }
    }
    printf("\n");
}

int main()
/* main() -- Scans for int inputs and feeds those input into collatz(n), stops scaning when it
 * gets an EOF. Prints an error and dies if any input recived is not an int.
 */
{   
int n,rc;
while (1) {
    rc = scanf("%d", &n);
    if (rc == EOF) { //if stdin received the EOF char
       break;
    }
    if (rc == 0) { //if stdin did not receive an int
        fprintf(stderr,"ERROR: An element on the input stream is not an integer.\n");
        return 1;
    }
    else {
       collatz(n); //run the collatz conjecture on an int n
    }
}
    return return_value;
}