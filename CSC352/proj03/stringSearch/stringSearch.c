/*
* File: stringSearch.c
* Author: Rowan Lochrin
* Purpose: Takes in a number of strings and prints..
>Mat: (str) if the string entered was the same as the first one enterd
>Dup: (str) if the string enterd was the same as the one previously enterd
>Rev: (str) if the string was the reverse of the first one enterd
Once the input ends it prints the total number of strings and the number of 
reverses, matches and dups.
*/ 
#include <stdio.h>
#include <string.h>

char *str_rev(char str[]){
/* takes in a string and returns that string reversed e.g. "abc" -> "cba"
*/
    int i,n;
    char *rev_str = strdup(str); //alocates memory for the reversed string
    for(i = 0,n = strlen(str) -1;n >= 0;i++,n--){ //iterates i:0 -> len(str), n: len(str) -> 0
        rev_str[i] = str[n];
    } 
    rev_str[strlen(rev_str)] = '\0'; //appends the null char to the end of the string
    return rev_str;
} 
int str_cmp(char str1[],char str2[]){
/* takes in two strings and returns 1 (True), if they are the same and 0 (False) if they
differ */
    int i;
    if(strlen(str1) != strlen(str2)){
        return 0;
    }
    for(i = 0;str1[i] != 0;i++){ //compares both strings char by char
        if (str1[i] != str2[i]) return 0;
    } 
    return 1;
}

int main()
{   int m, r, d;
    m = r = d = 0;
    int index = 0;
    char input_string[32];
    char previous_input[32];
    char search_string[32];
    char rev_search_string[32];
    while(scanf("%32s", input_string) == 1){ //scans for strings of max length 32
        if (index == 0){
            strcpy(search_string, input_string);
            strcpy(rev_search_string, str_rev(input_string));
        }
        else{
            if(strcmp(input_string, search_string) == 0){ // checks for matches useing the builtin
                printf("Mat: %s\n", input_string);
                m++;
            }
            if(str_cmp(input_string, rev_search_string)){ // checks for reverses useing the custom str_cmp function
                printf("Rev: %s\n", input_string);
                r++;
            }
            if(str_cmp(input_string, previous_input)){  // checks for reverses useing the custom str_cmp function
                printf("Dup: %s\n", input_string);
                d++;
            }
        }
        strcpy(previous_input, input_string);
        index++;

    }
    if (index == 0){ //checks to make sure a string was read in
        fprintf(stderr, "ERROR: Could not read the first string from stdin!\n");
        return 1;
    }
    printf("Totals: strings=%d : m=%d r=%d d=%d\n",(index-1),m,r,d); //prints the counts for everstring search
    return 0;
}