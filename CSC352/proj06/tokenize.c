/*  Author: Rowan Lochrin
*   File: tokenize.c
*   Purpose: Takes in lines of input and splits them into tokens stored in a linked list.
    stops takeing input when an EOF is recived. After that prints the tokens recived in this format:

Lines={Total_lines} Tokens={total tokens}
Line=0 Tokens: {tokens on line 0}
  Line=0 Token=0: "{first token}"
  ...
Line=1 Tokens: {tokens on line 1}
...

Note this program works by modify the buffer the input line was read into NOT duplicateing the tokens
out of hte buffer
*/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>


struct list_node
{
    struct list_node *next;
    char** tokens;
    int num_tokens; 
};
typedef struct list_node list_node;

void print_list();
void add_node(char **tokens, int num_tokens);
int word_count(char *line);

int total_tokens = 0;
int list_size = 0;
list_node* head_node = NULL;

int main(){
    size_t size = 0;
    while(1){ // main loop to tokenize input lines
        char* buffer = NULL;
        if(getline(&buffer, &size, stdin) == -1) break; //break when getline gets a EOF
        int num_words = word_count(buffer);
        char** tokens = (char**)malloc(num_words*sizeof(char*));
        if (tokens == NULL){ //error checking for malloc
            fprintf(stderr,"OUT OF MEMORY");
            exit(1);
        }
        char** token_ptr = tokens; // copy the pointer to save the start place while we add tokens
        char* new_token = buffer;
        char* last_space = buffer;
        int tokens_addedd = 0;
        while(tokens_addedd < num_words){
            //advance through blankspace untill a word is hit
            while(*buffer && *buffer != ' '  && *buffer != '\t' && *buffer != '\n') buffer++; 
            last_space = buffer;
            *buffer = 0; // add a null character at the space
            if(*new_token){ //if the first char of the new token is not null
                *token_ptr = new_token;
                tokens_addedd++;
                token_ptr++;
                total_tokens++; //keeping track of this for the first line of the print statment
            }
            buffer = ++last_space;
            new_token = buffer;
        }
        add_node(tokens,num_words);
    }
    print_list();
    return 0;
}

int word_count(char *line){
    /* Word count that works based to detecting the edges of words
    takes in a line and returns the number of words*/
    int reading_blank = 1; // flag to make sure func doesn't read consecutive spaces as multiple words
    int count = 0;

    while(*line){ // reads chars until the null char is hit
        if(*line != ' ' && *line != '\t' && *line != '\n'){
            if(reading_blank){ // is the char if the char the start of a word?
                count++;
                reading_blank = 0;
            }
        }
        else{
            reading_blank = 1; 
        }
        line++;
    }
    return count;
}

void add_node(char **tokens, int num_tokens){
    /* takes in a pointer to an array of tokens and the number of tokens then adds that
     to the linked list and increment the size of the list */
    list_node* new_node = malloc(sizeof(list_node));
    if (new_node == NULL){ // error checking for malloc
        fprintf(stderr,"OUT OF MEMORY");
        exit(1);
    }
    // sets up the new node
    new_node -> tokens = tokens;
    new_node -> num_tokens = num_tokens;
    new_node -> next = NULL;
    // put new node in the head node spot if the head DNE. 
    if(head_node == NULL){
        head_node = new_node; 
         list_size++; // inc size of list
    }
    //put the new node at the end of the list if else
    else{
        list_node* cur = head_node;
        while(cur -> next != NULL){ //cycles through the list until it finds a node w/o a link
            cur = cur -> next;
        }
        cur -> next = new_node;
        list_size++; // inc size of list
    }
    return;
}

void print_list(){
    /* cycles through the list and prints the required information in the format 
    described above */
    int line_num = 0;
    printf("Lines=%d Tokens=%d\n",list_size,total_tokens);
    list_node* cur = head_node;
    while(cur != NULL){ // go until end of linked list
        int token_num = 0; // keeps track of current token (for printing)
        char** tokens = cur -> tokens;
        int num_tokens = cur -> num_tokens;
        printf("Line=%d Tokens: %d\n",line_num,num_tokens);
        while(token_num < num_tokens){
            printf("  Line=%d Token=%d: \"%s\"\n", line_num, token_num, *tokens);
            tokens++;
            token_num++;
        }
        line_num++;
        cur = cur -> next; //ad
    }
    return;
}
