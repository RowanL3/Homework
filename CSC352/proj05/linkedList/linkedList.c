/*
*File:linkedList.c
*Author:Rowan Lochrin
*Des: Implementation of a linked list data structure for storeing names and
favorite numbers. The list is kept orderd by name. supports the following comands:
>insert [name] [num]: inserts and element with that name and number into the list 
>print: prints all elements in the list (name/number)
>delete: [name]: removes and element with a specific name
>removeHead: removes the first element in the list
Error condtions
>A name/number is rejected if it already appears in the list
>A delete comand is given for a name which is not in the list
>removeHead is called when the list is already empty
>
*/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>


struct Node
/* this is the code for the node, any node holds 3 things:
>Name of the node
>a "favorite number" of the node
>a link to the next node in the list
*/
{
    int fav_num;
    char *name;
    struct Node* link;
};

struct Node* head_node = NULL;
int list_len = 0;
int error_status = 0;

void insert(char *name,int fav_num){
    /* insert takes in a name and a number and creates a node with those attributes 
    at the appropriate spot on the list. errors out if the name is already in the list
    or if the name recived is longer then 20 chars
    */
    if (strlen(name) >= 20){
        fprintf(stderr,"Names must be under 20 chars\n");
        error_status = 1;
        return;
    }
    struct Node* cursor = head_node;
    while (cursor != NULL){ //First loop to test if the name is already in the list
        if (strcmp(cursor->name,name) == 0){
            fprintf(stderr,"duplicate rejected\n");
            error_status = 1 ;
            return;
        }
        cursor = cursor -> link;

    }

    struct Node* insertion = (struct Node*)malloc(sizeof(struct Node));
    if (insertion == NULL){ //Checks to make sure malloc could allocate the required memeory
        fprintf(stderr,"OUT OF MEMORY\n");
        exit(1);
    }
    insertion -> name = name;
    insertion -> fav_num = fav_num;


    if (head_node == NULL || strcmp((head_node -> name),name) > 0){
        insertion -> link = head_node;
        head_node = insertion;
    }
    else{
        cursor = head_node; //sets the cursor back to the beging to find where the new node fits in
        while(cursor -> link != NULL && strcmp((cursor -> link -> name),name) < 0){
            cursor = cursor -> link;
        }
        insertion -> link = cursor -> link;
        cursor -> link  = insertion;
    }
    list_len++;
    return;
}

void remove_head(){
    /* Removes the head of the linked list, sets the 2nd node to the head if
    it exits prints an error if the list is already empty */
    if (head_node == NULL){ //empty list checking
        fprintf(stderr,"List is already empty!\n");
        error_status = 1;
        return;
    }
    struct Node* new_head = head_node -> link;
    free(head_node); //dealocates the memory for the node nolonger in the list
    head_node = new_head;
    list_len--; 
}

void delete_node(char *name){
    /* Delets the node with the sepesifed name, fixes the link of the previous node
    to point to the node after. prints an error if the list is empty or the node is
    not found */
    if (head_node == NULL){
        fprintf(stderr,"List is already empty!\n");
        error_status = 1;
        return;
    }
    else if (strcmp(head_node -> name,name) == 0){
        remove_head(); //speical case where the first node needs to be removed 
        return;
    }
    else{
        struct Node* cursor = head_node;
        while (cursor -> link != NULL){ //cycles throught the list
            if (strcmp(cursor -> link -> name,name) == 0){
                struct Node* removed_node  = cursor -> link;
                cursor -> link = cursor -> link -> link; 
                // now the linked list skips the node we wish to remove
                free(removed_node);//clears the node not linked to from memory
                list_len--;
                return;

            }
            cursor = cursor -> link;
        }
        fprintf(stderr,"Node %s not found\n",name);
        error_status = 1;
        return;

    }  
}

void print_list(){
    /* Prints the list in the format:
    [list_len]: [name_1]/[num_1] ... [name_n]/[num_n]\n
    e.g. if the list is empty should print:
    0:\n
    */
    struct Node* cursor = head_node;
    printf("%d:",list_len);
    while(cursor != NULL){
        printf(" %s/%d",cursor -> name,cursor -> fav_num); 
        cursor = cursor -> link;
    }
    printf("\n");
    return;
}

int main(){
    char input[81];
    head_node = NULL;
    while(fgets(input, 80, stdin) != NULL){ //reads a new line of input
        char command[10] = "void"; //If this is not overwritten the command was invalid
        int num;
        char *name; 
        name = (char*)malloc(sizeof(char)*30); //allowing some buffer for too-long names
        if (name == NULL){ //Checks to make sure malloc could allocate the required memeory
            fprintf(stderr,"OUT OF MEMORY\n");
            exit(1);
        }
        int input_len = strlen(input);
        if ((input_len > 0) && (input[input_len - 1] != '\n')){
            fprintf(stderr, "Input was longer then 80 chars\n");
            return 1;
        } 
        int rec = sscanf(input, "%10s %30s %d", command,name,&num);
        if (input_len > 1){ // checks to make sure the input wasen't a blank line
            if(strcmp(command, "print") == 0){
                print_list();
            }
            else if(strcmp(command, "insert") == 0){
                if (rec == 3) insert(name,num); //makes sure the scanf got 3 args
                else{
                    fprintf(stderr,"invalid number of arugments");
                    error_status = 1;
                }
            }
            else if(strcmp(command, "delete") == 0){
                if (rec >= 2) delete_node(name); //makes sure the scanf got at least 2 args
                else{
                    fprintf(stderr,"invalid number of arugments");
                    error_status = 1;
                }
            }
            else if(strcmp(command, "removeHead") == 0){
                remove_head();
            }
            else{
                fprintf(stderr,"Command not recognized\n");
                error_status = 1;
            }
        }
    }
    return error_status;
}