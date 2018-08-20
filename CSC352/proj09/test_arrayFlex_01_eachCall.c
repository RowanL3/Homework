/*
 * File:   test_arrayFlex_01_dummyCalls.c
 * Author: Russell Lewis
 *
 * Purpose: Calls each function in the ArrFlex library - but the code is
 *          written such that none if it will ever run.  This is just dummy
 *          code to make sure that your implemenation has all of the basic
 *          types.
 */

#include <stdio.h>
#include <stdlib.h>
//#include <malloc.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>

#include "arrFlex.h"


int main(int argc, char **argv)
{
	/* this is intentionally written so that - unless you pass an
	 * argument, which is not normal for this project - none of these
	 * calls will run.
	 */

	ArrFlex *arr1 = arrFlex_new();
	ArrFlex *arr2 = arrFlex_clone(arr1);
	ArrFlex *arr3 = arrFlex_subArray(arr1, 0,10);

	int rc1 = arrFlex_size  (arr1);
	int rc2 = arrFlex_set   (arr1, 0, 'a');
	int rc3 = arrFlex_get   (arr1, 0);
	int rc4 = arrFlex_add   (arr1, 'a');
	int rc5 = arrFlex_append(arr1, arr2);
	int rc6 = arrFlex_insert(arr1, 0, 'a');
	int rc7 = arrFlex_delete(arr1, 0);

	char *str = arrFlex_toString(arr1);

	arrFlex_free(arr1);



	return 0;
}


