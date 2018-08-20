/*
 * File:    helpers.c
 * Author:  Rowan Lochrin
 *
 * Purpose: contains the function malloc_safe for use with myMake.c a simple makefile builder
*/
#include <stdlib.h> 
#include <stdio.h>
#include "helpers.h"

void *malloc_safe(size_t size){
    /* function that malloc's memory and returns a pointer to 
    that memory. Kills the program and and reports an error
    if the malloc. I added this so I woulden't have
    to check mallocs every time */
    void *mem = malloc(size);
    if(mem == NULL){
        // these lines will only run if the malloc failed
        fprintf(stderr, "OUT OF MEMORY");
        exit(1);
    }
    return mem;
}