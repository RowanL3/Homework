/*
* File: dumpStrings.c
* Author: Rowan Lochrin
* Purpose: Takes in a string and dumps the index,hex and dec of every one of it's characters.
also returns observed length of the string and the string lenght as deterimend by the c's
strlen() function
*/ 
#include <stdio.h>
#include <string.h>


int main()
{   
    int i;
    char input_string[32]; //string of max length 32
    while(scanf("%32s",input_string) ==1){ //scans for strings of max length 32
        for (i = 0; input_string[i] != 0; i++){ //cycles through the input_string
            printf("index='%d' char=’%c’ dec=%d hex=0x%x\n",i,input_string[i],(int)input_string[i],input_string[i]);
        }
        printf("count=%d strlen=%lu\n\n",i,strlen(input_string));
    }
    return 0;
}