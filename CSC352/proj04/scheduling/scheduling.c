/*
*Author:Rowan Lochrin
*File:scheduling.c
*Description: First takes in an integer and allocates an array of that size. Then scans for
pairs of ints that form a range within the array and increments all elements of the array
within that range. Once an EOF is recived prints out
>The number of elements followed by the final array
>the minimum the array
>the indexs of all array elements with the min value
>the maximum the array
>the indexs of all array elements with the min value
*/

#include <stdio.h>
#include <stdlib.h>

int main(){
    int exit_status = 0; //stays zero if the program never encounters an error
    int num_slots, start, end, rc, i;
    scanf("%d",&num_slots); //first input is the number of slots
    int *schedule;
    schedule = calloc(num_slots,sizeof(int));
    if(schedule == NULL){ //Checks to make sure calloc successfully allocated memory
        fprintf(stderr,"OUT OF MEMORY\n");
        return 1;
    }
    while(1){
        rc =scanf("%d %d",&start,&end);
        if(rc == EOF) break; //Ends scaning for pairs at the EOF
        else if(rc != 2){ //Both elements must be ints
            fprintf(stderr,"Could not read in two ints\n")
            exit_status = 1;
        } 
        //Next 3 else if statments check to make sure the range recived is within [0,num_ints)
        else if(start > end){
            fprintf(stderr,"Start time must be less then end time\n"); 
            exit_status = 1;
        } 
        else if(start < 0){
            fprintf(stderr,"Start time must not be negative\n"); 
            exit_status = 1;
        } 
        else if(end >= num_slots){
            fprintf(stderr,"end time must be less the the number of slots\n");
            exit_status = 1;
        }
        else{
            for(i = start;i <= end;i++){
                schedule[i]++;
            }
        }
    }
    //declaring variables to be used in the final tally
    int total = 0;
    int min = schedule[0];
    int max = schedule[0];
    printf("%d:",num_slots);
    //loops through the array and finds the min,max,total of the array
    for (i = 0;i < num_slots;i++){
        printf(" %d",schedule[i]);
        total += schedule[i];
        if(schedule[i] < min){
            min = schedule[i]; 
        }
        if(schedule[i] > max){  
            max = schedule[i];
        }
    }
    float avg = (float) total/num_slots;
    printf("\nminimum: %d\n",min);
    printf("minimum-slots:");
    for (i = 0; i < num_slots;i++){ //prints all slots with the min
        if(schedule[i] == min){
            printf(" %d",i);
        }
    }
    printf("\nmaximum: %d\n",max);
    printf("maximum-slots:");
    for (i = 0; i < num_slots;i++){ //prints all slots with the max
        if(schedule[i] == max){
            printf(" %d",i);
        }
    }
    printf("\naverage: %.2f\n",avg);


    return exit_status;
}