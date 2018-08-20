/*
 * File:    myMake.c
 * Author:  Rowan Lochrin
 *
 * Purpose: Simple makefile builder takes in two args [-f filename] and [target].
 * then does a depth first traveral of the makefile to 'build' the lowest dependinces
 * first building a dependinces consits of printing out all the commands bellow it, commands
 * are denoted by a line that starts wtih a tab. if no filename is spescified "makefileDefault"
 * will be loaded up instead if no target is specisfied the top target from the makefile is 
 * choosen.
 *
 * ERROR CONDITIONS: 
 * prints a message to stderr frees memory and dies and returns a value of 1 if:
 * > the makefile starts with a command
 * > one target is declared twice
 * > the file does not exist
 * The only nonfatel error is if a circular dependency exsits, then the program should print message to
 * stderror and return a value of 1 when its done.
 *
 *
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>

#include "helpers.h"


struct target_node
{
    char* line; // Stored so this memory can be freed before the program exits
    char* filename;
    struct target_node *next;
    struct dependency_node *dependencies;
    char** commands;
    int num_commands;
    int counted;
};

struct dependency_node
{
    char* dependency_name;
    struct target_node *link;
    struct dependency_node *next;
};


typedef struct target_node target_node;
typedef struct dependency_node dependency_node;

void print_list(target_node *current);
target_node *scan_file(FILE *fp);
int is_blank(char *line);
void free_list(target_node *node);
void free_dependencies(dependency_node *node);
target_node *make_target_node(char* target_line);
target_node *find_in_list(target_node *node, char* filename);
void traverse_graph(target_node *graph);
void traverse_dependencies(dependency_node *dependancy, char *target_filename);
char *trim(char *string);

int error_status = 0;

int main(int argc, char **argv)
{

    char* makefile_filename = "makefileDefault"; // should remain like this be default
    char* target = NULL;
    // the makefile_filename and target to
    int i;
    for (i = 1; i < argc; i++)
    {
        if (strcmp(argv[i], "-f") == 0)
        {
            if (i + 1 < argc)
            {
                makefile_filename = argv[i + 1];
                i++; //skip makefile_filename
            }
        }
        else
            target = argv[i];
    }

    FILE *fp = fopen(makefile_filename, "r");
    // check a file was opend
    if (fp == NULL)
    {
        fprintf(stderr, "ERROR: File:'%s' does not exist\n", makefile_filename);
        exit(1);
    }
    target_node *make_graph = scan_file(fp);

    fclose(fp);

    if (target == NULL)
        traverse_graph(make_graph);
    else
    {
        target_node *target_head = find_in_list(make_graph, target);
        if(target_head != NULL){
            traverse_graph(target_head);
        }
        else{
            fprintf(stderr, "Target not found\n");
            free_list(make_graph);
            exit(1);
        }
    }

    free_list(make_graph);

    return error_status;
}

void traverse_graph(target_node *graph)
{   
    /* does a depth first traveral of the graph printing out all targets and
    there commands. marks counted files with the counted flag */
    if (graph -> counted == 0)
    {
        graph -> counted = 1;
        if (graph -> dependencies)
            traverse_dependencies(graph -> dependencies, graph -> filename);

        printf("%s\n", graph -> filename);
        // print out the commands
        int i;
        for (i = 0; i < graph -> num_commands; i++ ) {
            printf("  %s\n", trim(graph -> commands[i]));
        }
        graph -> counted = 2;

    }
}

void traverse_dependencies(dependency_node *dependency, char *target_filename)
{
    /* helper function for traverse_graph: recurses traverse_graph
    to the dependencys of a target one by one */
    if (dependency -> link -> counted == 0)
        traverse_graph(dependency -> link);
    if (dependency -> link -> counted == 1) {
        fprintf(stderr, "makeThis: Circular %s <- %s dependency dropped\n", target_filename, dependency -> link -> filename);
        error_status = 1;
    }
    if (dependency -> next != NULL)
        traverse_dependencies(dependency -> next, target_filename);
}

target_node *scan_file(FILE *fp)
{
    /* creates a graph of the makeFile where every node is a target and every edge is a dependancy

    Error Condtions: Kills the program if an invalid line was read in, the Makefile started with a
    comand or the same target is in the makefile twice. */
    char* line = NULL;
    size_t len = 0;
    char* target_line = NULL;

    //char** line_freer = calloc(sizeof(char*), 1000);
    //int numlines = 0;
    // head_node should only contain a pointer to the first node on the list

    /* first pass set up all the nodes of the graph (target nodes) and get
    add the names of all of there dependencies to there sublists (the actual
    linkeing is done on the second pass */

    target_node *head_node = NULL;
    target_node *new_target_node = NULL;
    target_node *tail_node = NULL;
    int commands;

    while (getline(&line, &len, fp) != -1)
    {
        target_line = malloc_safe(len);
        strcpy(target_line, line);

        if (is_blank(target_line)) {
            free(target_line);
        }
        else if (target_line[0] == '\t')
        {
            // check there is a most recent target
            if (new_target_node == NULL)
            {
                fprintf(stderr, "Makefile must not start with a command\n");
                free_list(head_node);
                exit(1);
            }
            // Add commands to the most recent target
            else
            {
                commands = new_target_node -> num_commands;
                if (commands == 0) {
                    new_target_node -> commands = malloc_safe(sizeof(char*) * 200);
                }
                else if ((commands % 200) == 199) { // add more space if nessary
                    new_target_node -> commands = realloc(new_target_node -> commands, sizeof(char*) * (200 + commands));
                    if (new_target_node -> commands == NULL) {
                        free_list(head_node);
                        fprintf(stderr, "out of memory");
                        exit(1);
                    }
                }
                (new_target_node -> commands)[commands] = target_line;
                new_target_node -> num_commands++;
            }
        }

        else if (target_line[0] != '\t')
        {
            if(strchr(target_line, ':') == NULL)
            {
                fprintf(stderr, "%s\n","INVALID LINE");
                free_list(head_node);
                exit(1);
            }
            strtok(target_line, "\n"); // trim newline from targetline
            new_target_node = make_target_node(target_line);


            if (head_node == NULL)
                head_node = new_target_node;

            else
                tail_node -> next = new_target_node;

            tail_node = new_target_node;

        }
        free(line);
        line = NULL;
    }
    free(line);

    /* second pass to strip newlines form the ends of strings and */
    target_node *current = head_node; // set current back to the start of the list

    while (current != NULL)
    {
        /* make sure no target is in the makefile twice*/
        if (current != find_in_list(head_node, current->filename))
        {
            fprintf(stderr, "target: %s declared twice\n", current->filename);
            free_list(head_node);
            exit(1);
        }
        if (current -> dependencies != NULL)
        {
            dependency_node *dependancy_cursors = current -> dependencies;
            while (dependancy_cursors != NULL)
            {
                target_node *dependency_link = find_in_list(head_node, dependancy_cursors -> dependency_name);
                // make sure every dependency is in the makefile
                if (dependency_link == NULL)
                {
                    fprintf(stderr, "dependency %s not in file\n", dependancy_cursors -> dependency_name);
                    free_list(head_node);
                    exit(1);
                }
                else {
                    dependancy_cursors -> link = dependency_link;
                    dependancy_cursors = dependancy_cursors -> next;
                }
            }
        }
        current = current -> next;

    }

    return head_node;
}

target_node *make_target_node(char* target_line)
{
    /* makes a node with a linked list of dependencies out of a target in the
    makefile strips whitespace off the begining and end of the target and
    dependencies */

    // remove newline characters
    char space_delim[3] = " \t";
    char colon_delim[2] = ":";

    target_node *current = malloc_safe(sizeof(target_node));
    current -> line = target_line;

    char *filename = strtok(target_line, colon_delim);

    char *target_dependencies = strtok(NULL, colon_delim);
    // add the filename to the dependancys
    if (target_dependencies && !is_blank(target_dependencies))
    {

        dependency_node *dependencies_tail = malloc_safe(sizeof(dependency_node));
        current -> dependencies = dependencies_tail;

        dependencies_tail -> next = NULL;

        char *dependency_name = strtok(target_dependencies, space_delim);
        dependencies_tail -> dependency_name = dependency_name;

        dependency_name = strtok(NULL, space_delim);
        while (dependency_name != NULL && !is_blank(dependency_name))
        {
            dependency_node *current_dependency = malloc_safe(sizeof(dependency_node));
            current_dependency -> next = NULL;
            current_dependency -> dependency_name = dependency_name;
            dependencies_tail -> next = current_dependency;
            dependencies_tail = current_dependency;
            dependency_name = strtok(NULL, space_delim);
        }

    }
    else
        current -> dependencies = NULL;

    current -> counted = 0;
    current -> num_commands = 0;
    current -> commands = NULL;
    current -> filename = strtok(filename, space_delim); // removes whitespace
    current -> next = NULL;

    return current;

}


target_node *find_in_list(target_node * node, char* filename)
{
    /* recurrentsive method to find a node with node with a given filename in
    *  a linked list returns a pointer to the fist list_node with filename
    * returns NULL if there are no nodes in the list with that filename */
    if (node == NULL)
        return NULL;

    else if (strcmp(node -> filename, filename) == 0)
        return node;

    else
        return find_in_list(node -> next, filename);
}

void print_list(target_node * currsor)
{
    /* ONLY USED FOR DEBUGING
    prints the current target list and all of the dependancys for every target */
    while (currsor != NULL) {
        printf("%s:\n", currsor -> filename);
        dependency_node *dependency_currsor = currsor -> dependencies;
        while (dependency_currsor != NULL) {
            printf("  dependency:%s\n", dependency_currsor -> link -> filename);
            dependency_currsor = dependency_currsor -> next;
        }
        currsor = currsor -> next;
    }
}

int is_blank(char *line)
{
    /* like isspace but for strings and with an underscore because it's 2016.
    returns 1 iff the line is made up of all isspace characters */
    while (*line != '\0') {
        if (!isspace(*line))
            return 0;
        line++;
    }
    return 1;
}

void free_list(target_node * node)
{
    /* recursive function to free the list of target nodes uses the fact
    that we save the address of the line malloced for every target node
    so we can free it here */

    if (node -> dependencies != NULL)
        free_dependencies(node -> dependencies);
    // Free the next node first
    if (node -> next != NULL)
        free_list(node -> next);

    if (node -> line != NULL) {
        free(node -> line);
        node -> line = NULL;
    }
    if (node -> commands != NULL) {
        int i;
        for (i = 0; i < node -> num_commands; i++) {
            if (node -> commands[i] != NULL) {
                free(node -> commands[i]);
                node -> commands[i] = NULL;
            }
        }
        free(node -> commands);
        node -> commands = NULL;
    }

    free(node);
}

void free_dependencies(dependency_node * node)
{
    /* recursive helper function for free_list made to free sublists */
    if (node -> next != NULL)
        free_dependencies(node -> next);

    free(node);

}

char *trim(char *string)
{ /* trims the whitesapce from a string returns a pointer to the trimed string
    used when printing out the commands */
  char *stop;

  stop = string + strlen(string) - 1;
  while(stop > string && isspace(*stop)) stop--;
  *(stop+1) = 0; // put a null char at the last nonwhite char of the string

  while(isspace(*string)) string++;
  
  return string;
}
