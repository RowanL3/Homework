/*
*Author:Rowan Lochrin
*File:scanList.c
*Description:First takes in an integer, n, and allocates an array of that size,
Secound takes n more integers and fills the array with them. finally takes in 
int inputs and prints the number of occurrences of thouse ints in the array
until the EOF
*/

#include <stdio.h>
#include <stdlib.h>

int main()
{   
    int i,num,rec;
    if (scanf("%d", &num) == 0){ //Makes sure scanf recived integers
        fprintf(stderr,"Only integer values are accepted.\n");
        return 1;
    }
    int num_ints = num;
    if (num_ints < 0){ //Error checking to make sure a postive array size was entered
        fprintf(stderr,"The number of integers must be positve.\n");
        return 1;
    }
    int *comp_array = (int*)calloc(num,sizeof(int));
    if (comp_array == NULL){ //Checks to make sure calloc successfully allocated memory
        fprintf(stderr,"OUT OF MEMORY\n");
        return 1;

    }
    for(i=0;i<num_ints;i++){
        rec  = scanf("%d", &num); 
        if (rec == EOF){ //Makes sure scanf recived integers
            fprintf(stderr,"Unable to read a full set of integers.\n");
            return 1;
        }
        if (rec == 0){ //makes sure only integers were entered
            fprintf(stderr,"Only integer values are accepted.\n");
            return 1;
        }
        comp_array[i] = num;
    }
    printf("Comparison array (%d elements):",num_ints);
    for(i=0;i<num_ints;i++){ //Prints all elements in the array
        printf(" %d",comp_array[i]);
    }
    printf("}\n");
    while(1){ //Infinte loop doesn't break till scanf gets a EOF
        rec = scanf("%d", &num);
        if (rec == 1){
            int count = 0;
            for(i=0;i<num_ints;i++){ //cycles through array and counts the number of elements = num
                if(comp_array[i] == num){
                    count++;
                }
            }
            printf("Number: %d count=%d\n",num,count);
        }
        else if (rec == 0){ //Makes sure scanf recived integers
            fprintf(stderr,"Only integer values are accepted.\n");
            return 1;
        }
        else if (rec == EOF) return 0;
    }

    return 0;
}