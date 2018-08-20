/*
* File: primePair.c
* Author: Rowan Lochrin
* Purpose: Takes two inputs a,b and returns n: p q for every n in [a,b] if n = p*q for some primes p,q
*/ 
#include <stdio.h>

int get_first_factor(int n)
/* get_first_factor(n) -- takes an int n and returns the the first int m s.t. 2 < m < n and m divides n
returns 0 if there are no factors. 
 */
{
int factor = 0;
for(int i = 2;i < n;i++){
    if (n % i == 0){
        factor = i;
        break; //Makes sure it always finds the lowest factor, this means the factor will necessarily be prime
        }
}
return factor;
}
int main()
/* main() -- Scans for two int inputs a,b then feeds every element of [a,b] into get first prime factor then divides n
by that factor to get a second factor and checks to make sure the secound factor is also prime (No factors itself)
 */
{   
int a,b;
if (scanf("%d %d",&a,&b) != 2){ //error checking for non-integer inputs
    fprintf(stderr,"ERROR: Start must be <= end\n");
    return 1;
}
if (a < 2){ //error checking for a starting value >= 2
    fprintf(stderr,"ERROR: Start must be >= %d\n",a);
    return 1;
}
if (a > b){ //error checking for starting values greater then ending values
    fprintf(stderr,"ERROR: Start must be >= %d\n",a);
    return 1;
}
int n = a; 

while(n<b){ 
    int factor = get_first_factor(n);
    if (factor != 0 && get_first_factor(n/factor) == 0){ //checks to make sure n has two factors
        printf("%d: %d %d\n",n,factor,n/factor);
    }
n++;
}
return 0;
}