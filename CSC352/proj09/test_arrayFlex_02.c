
#include <stdio.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "arrFlex.h"

int test_index = 0;

void print_test(int ret, ArrFlex* arr){
    /* simple printing function used for debuging prints a int and 
    the contense of an array as a string also keeps track of an index
    so I can find the command that went wrong*/
    printf("%d) ", test_index);
    printf("%d: ", ret);
    char* arrFlex_to_string = arrFlex_toString(arr);
    printf("%s\n", arrFlex_to_string);
    free(arrFlex_to_string);
    test_index++;
}

int main(int argc, char **argv)
{
    /* this is intentionally written so that - unless you pass an
     * argument, which is not normal for this project - none of these
     * calls will run.
     */

    ArrFlex *arr1 = arrFlex_new();
    ArrFlex *arr2 = arrFlex_clone(arr1);
    ArrFlex *arr3 = arrFlex_subArray(arr1, 0,10);

    int ret;

    // 0
    ret = arrFlex_size(arr1);
    print_test(ret, arr1);

    // 1
    ret = arrFlex_set(arr1, 666, 'a');
    print_test(ret, arr1);

    // 2
    ret = arrFlex_get(arr1, 0);
    print_test(ret, arr1);

    // 3
    ret = arrFlex_add(arr1, 'a');
    print_test(ret, arr1);

    // 4
    ret = arrFlex_append(arr1, arr2);
    print_test(ret, arr1);

    // 5
    ret = arrFlex_insert(arr1, 0, 'a');
    print_test(ret, arr1);

    // 6
    ret = arrFlex_delete(arr1, 0);
    print_test(ret, arr1);
    
    // 7
    ret = arrFlex_delete(arr1, 0);
    print_test(ret, arr1);

    // 8
    ret = arrFlex_delete(arr1, 666);
    print_test(ret, arr1);

    // 9
    ret = arrFlex_add(arr1, 'a');
    print_test(ret, arr1);

    // 10
    ret = arrFlex_add(arr1, 'b');
    print_test(ret, arr1);

    // 11
    ret = arrFlex_add(arr1, 'c');
    print_test(ret, arr1);

    // 12
    ret = arrFlex_append(arr1, arr1);
    print_test(ret, arr1);

    // 13
    ret = arrFlex_set(arr1, 0, '1');
    print_test(ret, arr1);

    // 14
    ret = arrFlex_set(arr1, 3, '3');
    print_test(ret, arr1);

    // 15
    ret = arrFlex_append(arr1, arr2);
    print_test(ret, arr1);

    // 16
    ret = arrFlex_append(arr1, arr1);
    print_test(ret, arr1);

    // 17
    ArrFlex *arr4 = arrFlex_subArray(arr1, 3, 7);
    print_test(ret, arr4);

    // 18
    ret = arrFlex_get(arr4, 3);
    print_test(ret, arr4);

    // 19
    ret = arrFlex_get(arr4, 0);
    print_test(ret, arr4);

    // 20
    ret = arrFlex_get(arr4, 2);
    print_test(ret, arr4);


    // 21
    ret = arrFlex_append(arr4, arr1);
    ret = arrFlex_append(arr4, arr4);
    ret = arrFlex_append(arr4, arr4);
    ret = arrFlex_append(arr4, arr4);
    ret = arrFlex_append(arr4, arr4);
    ret = arrFlex_append(arr4, arr4);
    ret = arrFlex_append(arr4, arr4);
    print_test(ret, arr4);
    printf("arr4 size:%d\n",arrFlex_size(arr4));

    // 22
    ret = arrFlex_delete(arr1, 3);
    print_test(ret, arr1);
    printf("arr1 size:%d\n",arrFlex_size(arr1));

    // 23
    ret = arrFlex_delete(arr1, 7);
    print_test(ret, arr1);
    printf("arr1 size:%d\n",arrFlex_size(arr1));

    // 24
    ret = arrFlex_size(arr1);
    print_test(ret, arr1);
    printf("arr1 size:%d\n",arrFlex_size(arr1));

    // 25
    ret = arrFlex_size(arr4);
    print_test(ret, arr1);
    printf("arr1 size:%d\n",arrFlex_size(arr1));

    // 26
    ArrFlex *arr5 = arrFlex_clone(arr1);
    print_test(ret, arr5);
    printf("arr5 size:%d\n",arrFlex_size(arr5));

    // 27
    ret = arrFlex_insert(arr1, 6666666, 'a');
    print_test(ret, arr1);
    printf("arr1 size:%d\n",arrFlex_size(arr1));

    // 28 
    ret = arrFlex_size(arr5);
    print_test(ret, arr5);
    printf("arr5 size:%d\n",arrFlex_size(arr5));

    // 29 
    ret = arrFlex_size(arr1);
    print_test(ret, arr1);
    printf("arr5 size:%d\n",arrFlex_size(arr1));

    // 30
    ret = arrFlex_append(arr1, arr1);
    print_test(ret, arr1);
    printf("arr1 size:%d\n",arrFlex_size(arr1));

    // 31
    ret = arrFlex_append(arr1, arr2);
    print_test(ret, arr1);
    printf("arr1 size:%d\n",arrFlex_size(arr2));

    // 32
    ret = arrFlex_add(arr1, 'b');
    print_test(ret, arr1);

    // 33
    ret = arrFlex_add(arr1, 'c');
    print_test(ret, arr1);

    // 34
    ArrFlex *arr6 = arrFlex_clone(arr1);
    print_test(ret, arr6);

    // 35
    ret = arrFlex_insert(arr1, 2, '$');
    print_test(ret, arr1);

    // 36
    ret = arrFlex_insert(arr1, 2, '*');
    print_test(ret, arr1);

    // 37
    ret = arrFlex_insert(arr1, 30, '?');
    print_test(ret, arr1);

    // 38
    ret = arrFlex_delete(arr1, 38);
    print_test(ret, arr1);

    // 39
    ret = arrFlex_delete(arr1, 0);
    print_test(ret, arr1);

    // 40
    print_test(ret, arr2);

    // 41 
    print_test(ret, arr4);

    // 42 
    print_test(ret, arr5);

    // 43
    print_test(ret, arr6);
    printf("arr5 size:%d\n",arrFlex_size(arr1));



    arrFlex_free(arr1);
    arrFlex_free(arr2);
    // arr4 should be a null ptr
    arrFlex_free(arr4);
    arrFlex_free(arr5);
    arrFlex_free(arr6);



    return 0;
}
