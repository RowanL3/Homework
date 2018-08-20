/*
 * File:    arrFlex.h
 * Authors: Russell Lewis, student TODO
 *
 * Purpose: Declares types and functions for the arrFlex code.
 */


#ifndef _ARRFLEX_H_INCLUDED_
#define _ARRFLEX_H_INCLUDED_


/* ArrFlex is a struct which represents a resizable array of characters (not
 * necessarily a string).
 *
 * Originally, it was based off of ArrayList from Java - but we decided to
 * rename it because we're not requiring that students implement a linked
 * list.  We're expecting most implementations to simply be a single large
 * array, which is reallcoated as necessary.
 */
typedef struct ArrFlex
{
    int len; // length of the array
    int cap; // capacity of the array
    char* array;

} ArrFlex;


    /* makes sure the array has space for one more entry if it doesn't double
    the capacity of the array. note this does not effect the length as we are simply
    adding space for more elements

    ERROR HANDLING: Returns -1 if a malloc failed else 0.
    */

/* -------------------------------------------------- */
/* ----- DO NOT MODIFY ANY CODE BELOW THIS LINE ----- */
/* -------------------------------------------------- */



/* arrFlex_new()
 *
 * Creates a new ArrFlex object.  This should malloc() the struct, malloc()
 * the array inside it, and initialize all fields.  It returns a pointer to
 * the new object.
 *
 * ERROR HANDLING: Return NULL if there is any error allocating memory.
 *
 * RETURN VALUE: New object or NULL
 */
ArrFlex *arrFlex_new();



/* arrFlex_free()
 *
 * Frees an ArrFlex object, inclding freeing the array inside it.
 *
 * ERROR HANDLING: None
 *
 * RETURN VALUE: void
 */
void arrFlex_free(ArrFlex *obj);



/* arrFlex_clone()
 *
 * Creates a new ArrFlex object, which is a duplicate of a preivous one.  Make
 * sure that they do not share the same array!
 *
 * ERROR HANDLING: Return NULL if there is any error allocating memory.
 *
 * RETURN VALUE: New object or NULL
 */
ArrFlex *arrFlex_clone(ArrFlex *obj);



/* arrFlex_size()
 *
 * Return the number of elements in the ArrFlex object.  NOTE: This is the
 * number of active elements - we encourage you to have a 'capacity' which is
 * larger, in order to reduce the number of times you have to resize your
 * array.
 *
 * ERROR HANDLING: None
 *
 * RETURN VALUE: current size
 */
int arrFlex_size(ArrFlex *obj);



/* arrFlex_set()
 *
 * Set the value of a single element in the array.  The index given must be
 * non-negative, and less than the current size.
 *
 * ERROR HANDLING: Return -1 if the index is invalid.
 *
 * RETURN VALUE: -1 on error, 0 otherwise
 */
int arrFlex_set(ArrFlex *obj, int index, char val);


/* arrFlex_get()
 *
 * Get the value of a single element in the array.  The index given must be
 * non-negative, and less than the current size.
 *
 * ERROR HANDLING: Return -1 if the index is invalid.
 *
 * RETURN VALUE: -1 on error, the character at that index otherwise
 */
int arrFlex_get(ArrFlex *obj, int index);



/* arrFlex_add()
 *
 * Add a single value to the array, extending its capacity if necessary.
 *
 * ERROR HANDLING: Return -1 if there is any error allocating memory.
 *
 * RETURN VALUE: -1 on error, 0 otherwise
 */
int arrFlex_add(ArrFlex *obj, char newVal);



/* arrFlex_append()
 *
 * Extend the current array, adding to it *ALL* of the values in the other
 * array.
 *
 * ERROR HANDLING: Return -1 if there is any error allocating memory.
 *
 * RETURN VALUE: -1 on error, 0 otherwise
 */
int arrFlex_append(ArrFlex *obj, ArrFlex *arrayToAdd);


/* arrFlex_insert()
 *
 * Insert a single element, at a given index, shifting values over to make
 * space.  If the index is 0, insert at the head; if the index == size, then
 * this function is identical to add().
 *
 * ERROR HANDLING: Return -1 if the index is invalid, or if there is any
 *                 error allocating memory.
 *
 * RETURN VALUE: -1 on error, 0 otherwise
 */
int arrFlex_insert(ArrFlex *obj, int index, char value);


/* arrFlex_delete()
 *
 * Delete a single element, at a given index, shifting values over.  If the
 * index is 0, this deletes the first; if the index == size-1, then this
 * deletes the last.
 *
 * ERROR HANDLING: Return -1 if the index is invalid (including the case
 *                 where the array was already empty).
 *
 * RETURN VALUE: -1 on error, 0 otherwise
 */
int arrFlex_delete(ArrFlex *obj, int index);


/* arrFlex_subArray()
 *
 * Duplicate a subset of the array, into a new ArrFlex.  The range is from
 * start (inclusive) to end (exclusive).  If end==start, then the length
 * of the sliced array is zero.
 *
 * The indices must fulfill the following requirements:
 *    start >= 0
 *    end   >= start
 *    end   <= size
 *
 * ERROR HANDLING: Return NULL if the start or end indices are invalid.
 *                 Also return NULL if there is any error allocating memory.
 *
 * RETURN VALUE: Pointer to the newly-allocated object, or NULL.
 */
ArrFlex *arrFlex_subArray(ArrFlex *obj, int start, int end);


/* arrFlex_toString()
 *
 * Allocates a new array on the heap, large enough to store the current
 * contents of the array; copies the elements into that array, and returns
 * it.
 *
 * The array that is returned must have one more character than the contents
 * of the ArrFlex object; this last character is set to '\0'.
 *
 * Since the returned array is a duplicate, the caller may modify the array -
 * that will not affect the contents of this object.  Also, the caller is
 * responsible for freeing the array.
 *
 * If the object currently has 0 elements, this will still return a non-NULL
 * pointer; however, the buffer may have as few as 1 bytes in it.
 *
 * ERROR HANDLING: Return NULL if there is any error allocating memory.
 *
 * RETURN VALUE: The new buffer, or NULL.
 */
char *arrFlex_toString(ArrFlex *obj);

int arrFlex_expand(ArrFlex *obj);


#endif

