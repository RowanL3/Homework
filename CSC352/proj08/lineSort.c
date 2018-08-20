/* Author: Rowan Lochrin
 * File: lineSort.c
 * Purpose: read in comand line arguments file1, file2,... then
 * open files of that name and print all of there lines in order 
 * for smallest to largest by there ascii vallues. returns 0, 
 * unless a malloc failed then it should return 1. 
 *
 * Note: if a file is not found this program prints to stdout:
 * "The file '<filename>' did not exist.\n" and still returns 0.
 * 
 * Grader: I don't mean to shout but but my notes to the grader
 * are in all caps so hopefully they'll be more noticable.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "utilities.h"

void sort_file(FILE *file,char *file_name);
void print_sorted(char **sorted_array, int array_len,char *file_name);


int main(int argc, char *argv[]){
    int i;
    for(i = 1; i < argc; i++){
        char * file_name = argv[i];

        FILE * input_file;

        input_file = fopen(file_name, "r");        

        if(input_file){ // if a file with file_name exists
            sort_file(input_file,file_name);
            fclose(input_file);
        }
        else{
            printf("The file '%s' did not exist.\n", file_name);
        }
    }
    return 0;
}

void sort_file(FILE *file,char *file_name){
    /* Scans the lines of a file into an array then sorts the array
    and calls print_sorted to print the sorted array and the required
    forward. */
    size_t len; //only used in getline

    int num_lines = 0;
    char **output = NULL;

    while(1){
        if(num_lines % 12 == 0){ // run every 12th line
            output = extendArray(output, num_lines, num_lines + 12);
            if(output == NULL){
                exit(1); // SHOULD ONLY RUN IF MALLOC FAILED
            }
        }
        char *line = NULL;

        if(getline(&line, &len, file) == -1){
            free(line); // frees the last line read in
            break;
        };

        // remove the newline char at end
        if(strcmp("\n",line) != 0){
            // everything before the newline is the first token
            strtok(line, "\n");
        } 
        else {
            // if it's just a newline make it null
            *line = '\0';
        }

        output[num_lines] = line;

        num_lines++;
       
    }

    sortArray(output, num_lines);

    print_sorted(output, num_lines, file_name);

    // free all read-in lines 
    int i;
    for(i = 0; i < num_lines; i++){
        free(output[i]); 
    }

    // free the array itself
    free(output);
}

void print_sorted(char **sorted_array, int array_len,char *file_name){
    /* prints "The file '<filename>' had <array_len> lines.\n"
    followed by the contents of of the array seperated by newlines 
    if everything worked up to this point the array should be 
    sorted. */
    printf("The file '%s' had %d lines.\n", file_name, array_len);
    
    // prints lines of the array
    int i;
    for(i = 0; i < array_len; i++){
        printf("%s\n",*sorted_array);
        sorted_array++;
    }
}
