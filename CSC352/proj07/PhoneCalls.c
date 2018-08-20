/* Author: Rowan Lochrin
*  File: PhoneCalls.c
*  Description: accepts comand line arguments of the form:
*   file_1, file_2,...,file_n, phone_number_1, phone_number_2.
*   where the files names corospond to files format:
*   number1 number2
*   number3 number4
*    ...
*   where every pair of numbers corsponds to the a phone call bettween
*   the two numbers. after all files in the list have been scaned returns
*   how many times the two numbers inputed in args called each other
*   and "yes" if they have both talked to the same person, "no" if they
*   have not.
*
*  NOTE TO GRADER: all malloc checking is done by the malloc_safe function.
*/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

struct list_node
{
    char* phone_number;
    struct list_node *next;
    // the sublist node should be blank for every node in a sublist
    struct list_node *sublist;
};
typedef struct list_node list_node;


int valid_phone_number(char *phone_number);
int scan_file(char *file_name);
void add_to_list(char *phone_number_1, char *phone_number_2);
void free_list(list_node *head_node);
void *malloc_safe(size_t size);

list_node* head_node = NULL;

int main(int argc, char *argv[]) {
    int error_status = 0;
    char *phone_number_1 = NULL;
    char *phone_number_2 = NULL;
    int got_input = 0;
    // set the index to grab the two phone numbers from args first
    if (argc <= 3) {
        fprintf(stderr, "not enough args entered\n");
        return 1;
    }
    phone_number_1 = argv[argc - 2];
    phone_number_2 = argv[argc - 1];
    // check to make sure both inputed numbers are valid
    if (valid_phone_number(phone_number_1) == 0 ||
            valid_phone_number(phone_number_2) == 0) {
        fprintf(stderr, "invalid phone number entered\n");
        return 1;
    }
    int i;
    for (i = 1; i < argc - 2; i++) {
        int error_inc = scan_file(argv[i]);
        if (error_inc) {
            // checks the type of error
            if (error_inc == 1)  // if any valid lines were read in
                got_input = 1;
            error_status = 1;
        }
        else got_input = 1;
    }
    //check to make sure at least one file was scanned
    if (got_input == 0) {
        fprintf(stderr, "Please enter at least one valid file\n");
        return 1;
    }


    // check to see how many times they called each other and if there was a mutal 3rd party
    int call_count = 0;
    int mutual_call = 0;
    list_node* cur = head_node;
    list_node* phone_number_1_list = NULL;
    list_node* phone_number_2_list = NULL;
    list_node* phone_number_2_list_first = NULL;
    while (cur != NULL) {
        if (strcmp(cur -> phone_number, phone_number_1) == 0) {
            phone_number_1_list = cur -> sublist;
        }
        if (strcmp(cur -> phone_number, phone_number_2) == 0) {
            phone_number_2_list = cur -> sublist;
            phone_number_2_list_first = cur -> sublist;
            // this will allow us to "rewind" phone nubmer 2's list after looping through it
        }
        cur = cur -> next;
    }

    while (phone_number_1_list != NULL) {
        if (strcmp(phone_number_2, phone_number_1_list -> phone_number) == 0) {
            call_count++;
        }
        while (phone_number_2_list != NULL) {
            if (strcmp(phone_number_2_list -> phone_number, phone_number_1_list -> phone_number) == 0) {
                mutual_call = 1;
            }
            phone_number_2_list = phone_number_2_list -> next;
        }
        phone_number_2_list = phone_number_2_list_first;
        phone_number_1_list = phone_number_1_list -> next;
    }
    free_list(head_node);
    printf("%d\n", call_count);

    if (mutual_call) printf("yes\n");
    else printf("no\n");

    // return zero if everything ran fine
    return error_status;
}

int scan_file(char *file_name) {
    /* scans a file and ads its content to the linked list, note
    this function double add's entrys so the line xxx-xxxx yyy-yyyy
    will add yyy-yyyy to the list of people xxx-xxxx's called and
    add xxx-xxxx to the list of people yyy-yyyy's called if a non-
    fatal error was enconterd 2 if no lines were read in, zero if
    everying worked correctly. */
    int at_least_one_valid_line = 0;
    char phone_number_1[9];
    char phone_number_2[9];
    int error_status = 0;
    char* line = NULL;
    size_t len = 0;
    FILE * call_logs = NULL;
    call_logs = fopen(file_name, "r");
    // make the file name represents a file in the directory
    if (call_logs == NULL) {
        fprintf(stderr, "could not find file %s\n", file_name);
    }
    // else read that file line by line
    else {
        while (getline(&line, &len, call_logs) != -1) {
            if (*line != '\n') {
                // checks to make sure line valid
                if (sscanf(line, "%8s %8s", phone_number_1, phone_number_2) != 2 || // must have two numbers
                        valid_phone_number(phone_number_1) == 0 || //both numbers must be valid
                        valid_phone_number(phone_number_2) == 0 ||
                        strlen(line) != 18 || // line must be of length 18
                        line[8] != ' ') { // there must be a space in bettwen both numbers
                    fprintf(stderr, "invalid line read in\n");
                    error_status = 1;
                }
                else {
                    at_least_one_valid_line = 1;
                    add_to_list(phone_number_1, phone_number_2);
                    add_to_list(phone_number_2, phone_number_1);
                }
            }
        }
        free(line);
        fclose(call_logs);
    }
    if (at_least_one_valid_line) {
        return error_status;
    }
    else return 2;
}

int valid_phone_number(char *num) {
    /* cylces through a string representing a phone number and returns
    true if that number is of the for xxx-xxxx. false if it does not. */
    if (num == NULL) return 0;
    if (strlen(num) != 8) return 0;
    if (num[3] != '-') return 0;
    int i;
    for (i = 0; i <= 7; i++) {
        if (i != 3) {
            if (isdigit(num[i]) == 0) return 0;
        }
    }
    return 1;
}

void add_to_list(char *phone_number_1, char *phone_number_2) {
    /* if phone number 1 is not in the meta list adds phone number 1
    to the begining of the meta list if not it adds phone number 2 to
    the begining of phone number 1s list */
    // create the sub node
    list_node* sub_node = malloc_safe(sizeof(list_node));
    sub_node -> phone_number = malloc_safe(9 * sizeof(char));
    strcpy(sub_node -> phone_number, phone_number_2);

    sub_node -> next = NULL;
    sub_node -> sublist = NULL;

    list_node* cur = head_node;
    list_node* prev = head_node;

    // cycles throught the list until the end cur is the last element.
    while (cur != NULL) {
        /* if a node with the first phone number is already in
           the list just add the sub node containing a the second phone
           number node to that numbers list */
        if (strcmp(cur -> phone_number, phone_number_1) == 0) {
            sub_node -> next = cur -> sublist;
            cur -> sublist = sub_node;
            return;
        }
        prev = cur; // prev is one node behind current
        cur = cur -> next;
    }
    /* this code only excutes if there was no node with the first
    / phone number already in the linekd list. */
    list_node* new_node = malloc_safe(sizeof(list_node));
    new_node -> phone_number = malloc_safe(9 * sizeof(char));
    strcpy(new_node -> phone_number, phone_number_1);
    new_node -> next = NULL;
    // starts the new nodes sublist with the phone_number_2
    new_node -> sublist = sub_node;
    if (head_node == NULL) {
        head_node = new_node;
    }
    else {
        prev -> next = new_node;
    }

}

void free_list(list_node *node) {
    /* recursive function to clean up the linked list and sublists */
    // Free the sublist if there is one
    if (node -> sublist != NULL) {
        free_list(node -> sublist);
    }
    // Free the next node first
    if (node -> next != NULL) {
        free_list(node -> next);
    }
    free(node -> phone_number);
    free(node);
}

void *malloc_safe(size_t size) {
    /* function that malloc's memory and returns a pointer to
    that memory. Kills the program and and reports an error
    if the malloc failed. Just added this so I woulden't have
    to check mallocs every single time */
    void *mem = malloc(size);
    if (mem == NULL) {
        // these lines will only run if the malloc failed
        fprintf(stderr, "OUT OF MEMORY");
        free_list(head_node);
        exit(1);
    }
    return mem;
}
