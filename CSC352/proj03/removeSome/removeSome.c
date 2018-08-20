/*
* File: removeSome.c
* Author: Rowan Lochrin
* Purpose: Takes in a string, if the string is all numbers it will print them without evens in
reverse order. If the string is all letters it will print them out without vowels. If the string
is a mix of returns an error.
*/ 
#include <stdio.h>
#include <string.h>
#include <ctype.h>

void only_alpha(char *alphas){
/*
*Takes in a string of ONLY alphebet chars and prints the string without vowels.
*/
    int i;
    char a;
    for (i = 0; alphas[i] != 0; i++){
        a = tolower(alphas[i]);
        if (!(a == 'a'|a == 'e'|a == 'i'|a == 'o'|a == 'u')){ //if a is not a vowel (a,e,i,o,u)
            printf("%c",alphas[i]); //print the char in question
        }
    }
}
void only_digits(char *digits){
/*
*Takes in a string of ONLY digits and prints the backwords without evens.
*/
    int i,n;
    for (i = strlen(digits) - 1; i >= 0; i--){ //cycles through the string backwards
        n = (int)digits[i];
        if (n % 2){ //if n is not even
            printf("%c",digits[i]);
        }
    }
}

int main()
{   
    int return_value = 0;//should never change if the program does not encounter an error
    int i;
    char input_string[32];
    while(scanf("%32s",input_string) == 1){
        int got_digit = 0; //keeping track of the types of elements in the string with Booleans
        int got_alpha = 0;
        int got_misc = 0;
        for (i = 0; input_string[i] != 0; i++){
            if(isalpha(input_string[i])){
                got_alpha = 1; 
            }
            else if(isdigit(input_string[i])){
                got_digit = 1;
            }
            else{
                got_misc = 1;
            }
        }
        if((got_alpha && got_digit) | got_misc){ //if theres a mix of alpha chars and digits or any misc symbols return an error
            fprintf(stderr,"The string '%s' does not appear to be either made of entirely letters, or entirely digits.\n",input_string);
            return_value = 1;
        }
        else if(got_alpha){
            only_alpha(input_string);
        }
        else if(got_digit){
           only_digits(input_string);
        }
        printf("\n");
 
    }
    return return_value;
}