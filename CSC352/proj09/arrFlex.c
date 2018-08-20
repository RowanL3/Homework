/* File:    arrFlex.c
* Author:   Rowan Lochrin
* Purpose:  Implement methods for the ArrFlex object. ArrFlex is a java like library for arrays includes methods:
* int arrFlex_clone(ArrFlex *obj): Clones an array.
* int arrFlex_size(ArrFlex *obj): Gives size of an array.
* int arrFlex_set(ArrFlex *obj, int index, char val): Sets the value of an element at an index.
* int arrFlex_get(ArrFlex *obj, int index): Gets the value of an element at an index.
* int arrFlex_size(ArrFlex *obj); Returns the size of an arrFlex.
* int arrFlex_append(ArrFlex *obj, ArrFlex *arrayToAdd): Concatenates two arrays.
* int arrFlex_insert(ArrFlex *obj, int index, char value): Inserts array element into index.
* int arrFlex_delete(ArrFlex *obj, int index): Deletes an array element and shifts over elements after
* ArrFlex *arrFlex_subArray(ArrFlex *obj, int start, int end):
* char *arrFlex_toString(ArrFlex *obj): returns the value of an array as a string
*/
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "arrFlex.h"

int arrFlex_expand(ArrFlex *obj); // Private method.

ArrFlex *arrFlex_new(){
    /* creates a new Arr_Flex with len = 0 and space for 20 elements
    returns NULL if there is not enough memeory for the arrFlex object
    or the array it contains else returns a pointer to the new arrFlex
    object. */
    ArrFlex *newArr = (ArrFlex *)malloc(sizeof(ArrFlex));
    if (newArr == NULL){
        return NULL; //SHOULD ONLY RUN IF MALLOC FAILED
    }
    newArr -> len = 0;
    newArr -> cap = 40;
    char *data_array = (char*)malloc(20*sizeof(char));
    if (data_array == NULL){
        return NULL; //SHOULD ONLY RUN IF MALLOC FAILED
    }
    newArr -> array = data_array;
    return newArr;
}

void arrFlex_free(ArrFlex *obj){
    /* frees an ArrFlex object and the data array it contains */ 
    char *data_array = obj -> array;
    free(data_array);
    free(obj);

    return;
}

ArrFlex *arrFlex_clone(ArrFlex *obj){
    /* returns a pointer to a duplicate of the ArrFlex passed in 
    creates a new char array so that that duplicate array may be
    modified without changeing the first */
    int orig_cap = obj -> cap;
    int orig_len = obj -> len;
    char* orig_data = obj -> array;
    ArrFlex *cloneArr = (ArrFlex *)malloc(sizeof(ArrFlex));
    if (cloneArr == NULL){
        return NULL; // SHOULD ONLY RUN IF MALLOC FAILED
    }
    cloneArr -> len = orig_len;
    cloneArr -> cap = orig_cap;
    char *clone_data = (char*)malloc(sizeof(char)*orig_cap);
    if (clone_data == NULL){
        return NULL; // SHOULD ONLY RUN IF MALLOC FAILED
    }
    strncpy(clone_data, orig_data, obj->len);

    cloneArr -> array = clone_data;
    return cloneArr;
}

int arrFlex_size(ArrFlex *obj){
    /* returns the number of chars in the array. NOTE: this is diffrent
    then the cappacity of the array which may be greater then the number 
    of chars */
    int len = obj -> len;
    return len;
}

int arrFlex_set(ArrFlex *obj, int index, char val){
    /* Sets the element at the index:index to the value:val,
    returns -1 if the index was invalid and 0 otherwise  */
    if(index < 0 || index >= obj -> len){ // if index is out of range
        return -1;
    }
    (obj ->  array)[index] = val;

    return 0;
}

int arrFlex_get(ArrFlex *obj, int index){
    /* Gets the element at the index:index returns -1 if the index was
    invalid and 0 otherwise.  */
     if(index < 0 || index >= obj -> len){ // if index is out of range
        return -1;
    }
    int val = (obj ->  array)[index];

    return val;
}


int arrFlex_add(ArrFlex *obj, char newVal){
    /* Adds an element to the end of the array. Returns 1 the program
    ran out of memory and 0 otherwise. */
    if(arrFlex_expand(obj) == -1){
        return -1; //SHOULD ONLY RUN IF MALLOC FAILED
    }

    (obj ->  array)[obj -> len] = newVal;
    (obj -> len)++;

    return 0;
}

int arrFlex_append(ArrFlex *obj, ArrFlex *arrayToAdd){
    /* The array must be null-terminated for strncat to place the new string
    at the end of the first. */
    /* Make sure the array is null terminated so strncat knows where to  
    concatenated new array */
    (obj -> array)[obj -> len] = '\0'; 
    obj -> len += arrayToAdd -> len;
    if(arrFlex_expand(obj) == -1){
        return -1; //SHOULD ONLY RUN IF MALLOC FAILED
    }
    /* strncat can't be used for overlapping strings so we copy one of the
    * of the strings to a new place in the heap if we have to append an
    * arrFlex to itself.
    */
    if(obj == arrayToAdd){ 
        char* data_to_add = (char*)malloc(sizeof(char)*(arrayToAdd -> len + 1));
        if(data_to_add == NULL){
            return -1; //SHOULD ONLY RUN IF MALLOC FAILED
        }
        strncpy(data_to_add, arrayToAdd->array, arrayToAdd->len);
        strncat(obj->array, data_to_add, arrayToAdd->len);
        free(data_to_add);
    }
    else{
        strncat(obj->array,arrayToAdd -> array, arrayToAdd->len);
    }
    
    return 0;
}


int arrFlex_insert(ArrFlex *obj, int index, char value){
    /* inserts an the value:value at the index:index and moves shifts all
    elements after that index to the right one to make room returns -1 if the 
    program is out of memory or the index is out of the range of the array.
    0 otherwise
    */
    if(index < 0 || index >= obj -> len){ // if index is out of range
        return -1;
    }
    if(arrFlex_expand(obj) == -1){
        return -1; //SHOULD ONLY RUN IF MALLOC FAILED
    }
    int i;
    for(i = obj -> len - 1; i >= index; i--){
        (obj -> array)[i + 1] = (obj -> array)[i];
    }
    (obj -> array)[index] = value;
    (obj -> len)++;
    return 0;
}


int arrFlex_delete(ArrFlex *obj, int index){
    /* delets the object at index and shifts every element after one to the
    left to fill the space left, returns -1 if the index was out of range
    0 otherwise */
    if(index < 0 || index >= obj -> len){ // if index is out of range
        return -1; //SHOULD ONLY RUN IF MALLOC FAILED
    }
    int i;
    for(i = index; i < (obj -> len) - 1; i++){
        (obj -> array)[i] = (obj -> array)[i+1];
    }
    obj -> len -= 1;
    return 0;
}

ArrFlex *arrFlex_subArray(ArrFlex *obj, int start, int end){
    /* similear to clone except subArray only clones a slice of the array given
    by the indexs start and end returns  NULL if either the start or end index were
    out of range, the start index was after the end index or the program ran
    out of memory otherwise returns a pointer to the new array */
    int len_data = end - start;
    if(!(start >= 0 && end >= start && end <= (obj -> len))){ // check to make sure the indexs are valid
        return NULL;
    }
    ArrFlex *subArray = arrFlex_new();
    if(arrFlex_expand(subArray) == -1){
        return NULL; //SHOULD ONLY RUN IF MALLOC FAILED
    }

    subArray -> len = len_data;


    memcpy(subArray -> array, (obj -> array) + start, len_data);

    return subArray;
}


char *arrFlex_toString(ArrFlex *obj){
    /* returns a pointer to a null terminated string allocated in the heap
     containg the elements of the array. Returns NULL if the program ran out 
     of memory otherwise returns a pointer to the string. It's up to the caller
     to free the malloc space for the string. */
    char *output_string = (char *)malloc(sizeof(char)*(obj -> len+1));
    if (output_string == NULL){
        return NULL; //SHOULD ONLY RUN IF MALLOC FAILED
    }
    strncpy(output_string,obj->array,obj->len);
    output_string[obj -> len] = '\0';
    
    return output_string;
}

int arrFlex_expand(ArrFlex *obj){
    /* makes sure the array has space for one more entry if it doesn't double
    the capacity of the array. note this does not effect the length as we are simply
    adding space for more elements

    ERROR HANDLING: Returns -1 if a malloc failed, 0 otherwise.
    */
    if(obj -> len - 1 < obj -> cap){
        return 0;
    }
    int newCap = (obj -> len)*2;
    obj -> array = (char*)realloc(obj -> array, newCap*sizeof(char));
    if(obj -> array == NULL){
        return -1; //SHOULD ONLY RUN IF REALLOC FAILED
    }
    obj -> cap = newCap;
    return 0;
}
