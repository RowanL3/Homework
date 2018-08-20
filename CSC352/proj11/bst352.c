/*
*   Author:  Rowan Lochrin
*   File:    bst352.c
*   Purpose: Simple implimation of a binary search tree, reads commands from
*   STDIN. suports the commands:
*       i <int>: inserts <int> into the tree
*       d <int>: delete's the tree node <int>
*       s <int>: searchs the tree for <int>
*       m: prints minimum of the tree
*       M: prints maximum of the tree
*       p: prints pre-order traversal
*       P: prints post-order traversal
*
*   Returns 0 if no errors occurred.
*   Returns 1 if:
*       An invalid line was read in (unrecognized command or too many/too few args)
*       M or m ran on an empty tree
*       i is attempted with a value that's already in the tree
*       d is attempted with a value that's not in the tree
*/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <limits.h>
#include <ctype.h>

struct bst_node
{
    int    num;
    struct bst_node *left;
    struct bst_node *right;
};
typedef struct bst_node bst_node;

bst_node *insert(bst_node* node, int n);
bst_node *delete(bst_node* node, int n);
int search(bst_node* node, int n);
int *bound(bst_node* node, char command);
void traversal(bst_node* node, char command);
void free_bst(bst_node* node);


int error_status = 0;
int delete_found = 0;

int main()
{
    char* buffer            = NULL;
    char* line              = NULL;
    size_t len              = 0; // Only used to give getlien an arg

    char command[13];
    char arg_buf[33];
    int arg                 = 0;
    char garbage; // Used to tell if the line contains garbage at the end

    int ret                 = 0;

    int *limit              = NULL; // stays NULL if bound does not
    char SC[2]              = ";";

    bst_node* head_node     = NULL;

    while (getline(&buffer, &len, stdin) != -1)
    {
        // if ret = 3 then the line contains garbage at the end
        line = strtok(buffer, SC);
        while (line != NULL) {
            if (strcmp(line, "\n") == 0) {
                line = strtok(NULL, SC);
                continue;
            }
            ret = sscanf(line, "%12s %32s %c", command, arg_buf, &garbage);
            
            if (ret > 1 && 1 != sscanf(arg_buf, "%32d%c", &arg, &garbage)) {
                fprintf(stderr, "line invalid");
                error_status = 1;
                line = strtok(NULL, SC);
                continue;
            }

            // Check the commands have the right number of args
            if ((strcmp(command, "i") == 0 || strcmp(command, "d") == 0 || strcmp(command, "s") == 0) && ret != 2)
            {
                fprintf(stderr, "line invalid: '%s', '%s' requires one args\n", line, command);
                error_status = 1;
                line = strtok(NULL, SC);
                continue;
            }

            if ((strcmp(command, "M") == 0 || strcmp(command, "m") == 0 ||
                    strcmp(command, "P") == 0 || strcmp(command, "p") == 0) && ret != 1)
            {

                fprintf(stderr, "line invalid: '%s' requires no arg\n", line);
                error_status = 1;
                line = strtok(NULL, SC);
                continue;
            }
            // The program should never take in more then 1 arg and the command
            //if (ret > 2)
            //{
              //  fprintf(stderr, "line invalid: too many args\n");
               // error_status = 1;
               // line = strtok(NULL, SC);
               // continue;
            //}
            // if the command is not one character it must not ve valid
            if (strlen(command) > 1)
            {
                fprintf(stderr, "command invalid: '%s'\n", command);
                error_status = 1;
                line = strtok(NULL, SC);
                continue;
            }

            // Switch to run the correct function for the command
            switch (*command)
            {
            case 'i': // if you squint it's python
                head_node = insert(head_node, arg);
                break;

            case 'd':
                delete_found = 0;
                head_node = delete(head_node, arg);
                if (!delete_found) {
                    fprintf(stderr, "%d NOT found\n", arg);
                    error_status = 1;
                }
                break;

            case 's':
                if (search(head_node, arg))
                    printf("%d found\n", arg);
                else
                    printf("%d NOT found\n", arg);
                break;

            case 'm':
            case 'M':
                limit = bound(head_node, *command);
                if (limit != NULL)
                    printf("%d\n", *limit);
                break;

            case 'p':
            case 'P':
                traversal(head_node, *command);
                printf("\n"); //print a newline after the traversal
                break;

            default: // This trigers if no case above is recognized
                fprintf(stderr, "command invalid: '%s'\n", command);
                error_status = 1;
            }
            line = strtok(NULL, SC);
        }

    }

    free(line);
    free_bst(head_node);

    return error_status;
}


// i <int>: insert
// EC: error if the int already in tree

bst_node *insert(bst_node* node, int n)
{
    /*
    *   Recursive function to handle insertions, will create a new node if
    *   passed a NULL pointer. If the pointer is not NULL it will place the
    *   the attempt to find the place in the tree where the node should be,
    *   create a new node by calling this function with a NULL pointer, and
    *   place the new node.
    *
    *   ERRORS: sets error status to 1 if the int is already in the tree
    */

    bst_node *new_node = NULL;
    // if the node passed is not null find a place to put it in the tree
    if (node != NULL) {
        if (n == node -> num)
        {
            fprintf(stderr, "%d already in tree\n", n);
            error_status = 1;
            return node;
        }
        if (n > node -> num)
        {
            if (node -> right == NULL)
            {
                node -> right = insert(NULL, n);
                return node;
            }

            if (node -> right != NULL)
            {
                insert(node -> right, n);
                return node;
            }

        }
        if (n < node -> num)
        {
            if (node -> left == NULL)
            {
                node -> left = insert(NULL, n);
                return node;
            }

            if (node -> left != NULL)
            {
                insert(node -> left, n);
                return node;
            }
        }
    }
    // if the nod passed was null create a new node
    new_node = malloc(sizeof(bst_node));

    if (new_node == NULL) { // Check the malloc
        fprintf(stderr, "OUT OF MEMORY\n");
        exit(1);
    }

    new_node -> num = n;
    new_node -> left = NULL;
    new_node -> right = NULL;
    return new_node;
}

// d <int>: delete
// EC: the value does not exist
bst_node *delete(bst_node* node, int n)
{   /*
    *   Recursive function to delete a node with the value n from the tree,
    *   returns the head node from the modified tree.
    *
    *   ERRORS: sets the error status to 1 if a node with value n was not
    *   found in the tree.
    *
    */
    bst_node *link = NULL;

    if (node == NULL)
        return NULL;

    if (node -> num == n)
    {
        if (node -> right != NULL && node -> left != NULL) {
            // replace the number in the node with the min of its right
            // tree and remove that node from the tree
            int replacement_num = *bound(node -> right, 'm');
            node -> num = replacement_num;
            node -> right = delete(node -> right, replacement_num);
            return node;
        }

        if (node -> right == NULL && node -> left != NULL)
        {
            link = node -> left;
            free(node);
            delete_found = 1;
            return link;
        }
        if (node -> left == NULL && node -> right != NULL) {
            link = node -> right;
            free(node);
            delete_found = 1;
            return link;
        }
        if (node -> right == NULL && node -> left == NULL) {
            free(node);
            delete_found = 1;
            return NULL;
        }
    }
    // recursivly search through the tree
    if (node -> num != n)
    {
        node -> right = delete(node -> right, n);
        node -> left = delete(node -> left, n);
    }

    return node;
}
// s <int>: search
// print:"<int> found\n" or "<int> NOT found\n" to STDOUT
int search(bst_node * node, int n)
{
    /*
    *   Recursive function to search for an int in the tree returns 1 if
    *   the int is in the tree and zero if not.
    */
    if (node == NULL)
        return 0;

    if (node -> num == n)
        return 1;

    else {
        return search(node -> left, n) | search(node -> right, n);
    }
    return 0;
}

// m: minimum
// print: prints the min value followed by a newline
// EC: prints to STDERR if the tree is blank

// M: maximum
// pretty much the same as minimum
int *bound(bst_node * node, char command)
{
    /*
    *   Recursive function that returns either the lowest or highest int
    *   in the tree passed in depending on the command, 'm' returns the
    *   minimum (farthest left) int in the tree and 'M' returns the maximum
    *   (farthest right) int in the tree. NOTE this function actually returns
    *   a pointer to the int and NULL if the tree is bank
    *
    *   ERRORS: sets error status to 1 and returns NULL if the tree is
    *   empty
    */
    if (node == NULL)
    {
        fprintf(stderr, "Tree is empty");
        error_status = 1;
        return NULL;
    }
    if (command == 'm')
    {
        if (node -> left == NULL)
            return &node -> num;
        else
            return bound(node -> left, command);
    }
    if (command == 'M')
    {
        if (node -> right == NULL)
            return &node -> num;
    
    }
    return bound(node -> right, command); // This should never happen
}
// p: pre-order traversal
// print: a pre-order of tree on one line (blank if tree empty)

// P: post-order traversal
// same as post-order
void traversal(bst_node * node, char command)
{
    /*
    *   Yet another recursive function this one to traverse the BST in
    *   pre-order ('p') or post-order ('P'). Works by printing the int that
    *   a node contains before or after the recursive step depending on the
    *   order of traversal.
    */
    if (node == NULL)
        return;

    if (command == 'p')
        printf(" %d", node -> num);

    if (node -> left != NULL)
        traversal(node -> left, command);

    if (command == 'P')
        printf(" %d", node -> num);

    if (node -> right != NULL)
        traversal(node -> right, command);
}

void free_bst(bst_node * node)
{
    /*
    *   Simple recursive function to free the BST given in the args.
    *   Function does nothing if passed a NULL pointer.
    */
    if (node == NULL)
        return;

    free_bst(node -> left);
    free_bst(node -> right);
    free(node);
}

// Have a fantastic break!
