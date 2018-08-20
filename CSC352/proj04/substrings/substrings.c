/*
*Author:Rowan Lochrin
*File:substrings.c
*Description:Scans for input, the first input taken in is the master string the 
next lines of input are substrings to be searched for in the master string if a
match is found the index of the start of the substring in the master string is
printed if the string is not found within the master string -1 is printed
*/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int find_sub_string(char master_string[],char sub_string[]){
    /*Takes in a masterstring and a substring and returns the index that the substring
    first occur at in the the master string, returns -1 if the masterstring does not
    contain a substring */
    int i,j,match;
    int len_master = strlen(master_string);
    int len_sub = strlen(sub_string);
    for(i = 0;i <= len_master - len_sub;i++){
        match = 1; //set to zero if there is a mismatch bettwen 
        for(j=0;j < len_sub;j++){ //scans the next chars until a mismatch between the masterstring and the substring
            if ((sub_string[j]) != 10 && (sub_string[j] != master_string[i+j])){ //Does not count newlines as part of the substring
                match = 0; //flag set to zero if there was a mismatch
                break;
            }
        }
        if(match) return i; //returns the index of the match if theres a match
    }

    return -1;

}

int main()
{   
    size_t max_len = 121;
    char master_string[121];
    char sub_string[121];
    fgets(master_string, max_len, stdin);
    if(master_string[0] == '\0' || master_string[0] == 10){ //makes sure the master string was not NULL or a blank line
        fprintf(stderr,"Master string cannot be NULL\n");
        return 1;
    }

    while (fgets(sub_string, max_len, stdin) != NULL){ //Ends program 
        if(sub_string[0] != '\0' && sub_string[0] != 10){ //skips the substring test if the substring was NULL or a blank line
            printf("%d\n",find_sub_string(master_string,sub_string));
        }
    }

    
    return 0;
}