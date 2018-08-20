/* Author: Rowan Lochrin
 * File: utilities.c
 * Purpose: contains the helper functions extendArray and sortArray
 * for lineSort.c:
 *
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "utilities.h"


char **extendArray(char **oldArray, int oldLen, int newLen){
    /* allocates space for a char pointer array of length newLen
    and copys everything in the oldArray to start of the new array
    returns a pointer to a new array or NULL if a malloc failed.
    This function is analogous to realloc.
    NOTE: this function assume newLen > oldLen */
    char **new_array = malloc(sizeof(char*)*newLen);
    if (new_array == NULL){
        // THESE LINES SHOULDEN'T RUN UNLESS MALLOC FAILED
        if(oldArray != NULL) free(oldArray);
        return NULL;
    }
    int i;
    for(i = 0; i < oldLen; i++){
        new_array[i] = oldArray[i];
    }
    free(oldArray);
    return new_array;
}


void sortArray(char **array, int len){
    /* Uses the notoriously slow bubble sort algorithm to sort a
    array of strings by there ascii values. len is the length of 
    the array.
    NOTE: this function shoulden't allocate much memory as the swaping
    of elements is done with pointers */
    if(len == 1 || len == 0) return;
    int swapped = 1;

    while(swapped != 0){
        swapped = 0;

        int i;
        for(i = 1; i < len; i++){
            if(strcmp(array[i - 1], array[i]) > 0){
                //swap the two elements
                char *temp = array[i - 1];
                array[i - 1] = array[i];
                array[i] = temp;

                swapped = 1;
            }
        }
    }
    return;
}
