#Author:Rowan Lochrin
#Assignment:CS252 Project 6
#File:proj06.s

.data
BST:                   
    .space 384                     # enough room for 32 nodes * 3 words * 4 bytes/word
END_BST:

BST_PTR:                           # points to the first free space in the bst array
    .word BST                      # modifed throught the program to point to the first avaliable slot

.text

#node *bst insert(node *oldRoot, int val)
bst_insert:    
    # standard prologue
    addiu   $sp, $sp, -24
    sw      $fp, 0($sp)
    sw      $ra, 4($sp)
    addiu   $fp, $sp, 20            

    bne     $a0, $zero, try_left   # if oldRoot != NULL go deaper in the tree

    # add a new node at the correct spot
    la      $t1, BST_PTR
    lw      $v0, 0($t1)             # $v0 points to the location of the new node
    sw      $a1, 0($v0)             # node -> n = val
    sw      $zero, 4($v0)           # node -> left = NULL
    sw      $zero, 8($v0)           # node -> right = NULL
    
    # sets the BST_PTR to point at the next free space in the array
    addi    $t2, $v0, 12            # inc BST 3 words (1 node)
          
    sw      $t2, 0($t1)             # Save the BST_PTR back into memory
    j       insert_done

try_left:

    # else if n < node -> n
    lw     $t1, 0($a0)              # $t1 = node -> n
    slt    $t0, $a1, $t1
    
    add     $v0, $a0, $zero        # set the current node to the return value

    beq    $t0, $zero, try_right   # try the right if n !< node -> n
    
    # pack up a0
    addi   $sp, $sp, -4
    sw     $a0, 0($sp)

    lw     $a0, 4($a0)             # load the left pointer from the node
    jal    bst_insert              # recurse left

    lw     $a0, 0($sp)
    addi   $sp, $sp, 4

    sw     $v0, 4($a0)             # save back the left ptr

    add   $v0, $zero, $a0          # load the ptr to the current node into the return value

    j      insert_done

try_right:    

    lw     $t1, 0($a0)             # $t1 = node -> n
    sgt    $t0, $a1, $t1        

    beq    $t0, $zero, insert_done # if node -> n !> val, return;

    addi   $sp, $sp, -4            # allocate space
    sw     $a0, 0($sp)             

    lw     $a0, 8($a0)             # load the right pointer from the node
    jal    bst_insert              # recurse right

    lw     $a0, 0($sp)             # restore $a0 from the stack
    addi   $sp, $sp, 4

    sw     $v0, 8($a0)             # save the right nod pointer

    add    $v0, $zero, $a0         # load the ptr to the current node into the return value

    j      insert_done

insert_done:
    # standard epilogue
    lw      $ra, 4($sp)
    lw      $fp, 0($sp)
    addiu   $sp, $sp, 24
    jr      $ra

#bool bst search(node *root, int val)
bst_search:
    # standard prologue
    addiu   $sp, $sp, -24
    sw      $fp, 0($sp)
    sw      $ra, 4($sp)
    addiu   $fp, $sp, 20

    beq     $a0, $zero, search_not_found # return 0 if fed in a null ptr

    lw      $t1, 0($a0)            # $t1 = node -> n
    beq     $t1, $a1, search_found # if val == node -> n, return 1

    addi    $sp, $sp, -4           # allocate space
    sw      $a0, 0($sp)            # pack up a0

    # recurse left
    lw      $a0, 4($a0)            # load left ptr into $a0
    jal     bst_search             # recurse left

    lw      $a0, 0($sp)            # unpack $a0
    addi    $sp, $sp, 4            # deallocate space

    bne     $v0, $zero, search_found # if $v0 == 1 return 1

    # recurse right
    lw      $a0, 8($a0)            # load right ptr into $a0
    jal     bst_search             # recurse right

    # if $v0 == 1 return 1
    bne     $v0, $zero, search_found # if $v0 == 1 return 1

    j       search_not_found

search_found:
    addi    $v0, $zero, 1
    j       search_done

search_not_found:
    add     $v0, $zero, $zero
    j       search_done

search_done:
    # standard epilogue
    lw      $ra, 4($sp)
    lw      $fp, 0($sp)
    addiu   $sp, $sp, 24
    jr      $ra

#int bst count(node *root)
bst_count:
    # standard prologue
    addiu   $sp, $sp, -24
    sw      $fp, 0($sp)
    sw      $ra, 4($sp)
    addiu   $fp, $sp, 20

    beq     $a0, $zero, count_null_case  # dont do anything if read in a NULL pointer

    addi    $t2, $zero, 1           # $t2 = running total (starts at 1 counting current node)
   

    addi    $sp, $sp, -8            # allocate space
    sw      $a0, 0($sp)             # pack up $a0
    sw      $t2, 4($sp)             # pack up $t2

    # recurse left
    lw      $a0, 4($a0)            # load left ptr
    jal     bst_count
    
    lw      $a0, 0($sp)            # load up $a0
    lw      $t2, 4($sp)            # load up $t2

    add     $t2, $v0, $t2          # add the count on the left side

    sw      $a0, 0($sp)            # pack up $a0
    sw      $t2, 4($sp)            # pack up $t2

    # recurse right
    lw      $a0, 8($a0)            # load right ptr
    jal     bst_count
    
    lw      $a0, 0($sp)            # load up $a0
    lw      $t2, 4($sp)            # load up $t2
    addi    $sp, $sp, 8            # deallocate space


    add     $v0, $v0, $t2          # add the count on the right side to the return value

    j       done_count

count_null_case:
    add     $v0, $zero, $zero

done_count:
    # standard epilogue
    lw      $ra, 4($sp)
    lw      $fp, 0($sp)
    addiu   $sp, $sp, 24
    jr      $ra

#void bst preOrderTraversal(node *root)
bst_preOrderTraversal:
    # standard prologue
    addiu   $sp, $sp, -24
    sw      $fp, 0($sp)
    sw      $ra, 4($sp)
    addiu   $fp, $sp, 20

    add     $t2, $a0, $zero

    beq     $a0, $zero, preOrderTraversal_done # if passed a null pointer do nothing
    lw      $t0, 0($a0)             # $t0 = node -> n

    # print a space
    addi    $a0, $zero, ' '        # ASCII ’ ’
    addi    $v0, $zero, 11         # print char
    syscall

    # print the int
    add     $a0, $zero, $t0        # load $t2 into $a0
    addi    $v0, $zero, 1          # print int
    syscall

    # save the ptr to the current node
    addi    $sp, $sp, -4           # make room in the stack
    sw      $t2, 0($sp)            # save the ptr to the node

    # recurse left
    lw      $a0, 4($t2)            # load the left node to $a0
    jal     bst_preOrderTraversal  # recurse left

    # load the ptr to the current node
    lw      $t2, 0($sp)
    addi    $sp, $sp, 4

    # recurse right
    lw      $a0, 8($t2)            # load the right node to $a0
    jal     bst_preOrderTraversal  # recurse right


preOrderTraversal_done:
    # standard epilogue
    lw      $ra, 4($sp)
    lw      $fp, 0($sp)
    addiu   $sp, $sp, 24
    jr      $ra

#void bst inOrderTraversal(node *root)
bst_inOrderTraversal:
    # standard prologue
    addiu   $sp, $sp, -24
    sw      $fp, 0($sp)
    sw      $ra, 4($sp)
    addiu   $fp, $sp, 20

    add     $t2, $a0, $zero

    beq     $a0, $zero, inOrderTraversal_done # if passed a null pointer do nothing
   
    # save the ptr to the current node
    addi    $sp, $sp, -4           # make room in the stack
    sw      $t2, 0($sp)            # allocate stack spaces for the node ptr

    # recurse left
    lw      $a0, 4($t2)            # load the left node to $a0
    jal     bst_inOrderTraversal

    # load the ptr to the current node
    lw      $t2, 0($sp)
    addi    $sp, $sp, 4            # deallocate stack spaces for the node ptr

    lw      $t0, 0($t2)            # $t0 = node -> n

    # print a space
    addi    $a0, $zero, ' '        # ASCII ’ ’
    addi    $v0, $zero, 11         # print char
    syscall

    # print the int
    add     $a0, $zero, $t0        # load $t2 into $a0
    addi    $v0, $zero, 1          # print int
    syscall

    # recurse right
    lw      $a0, 8($t2)            # load the right node to $a0
    jal     bst_inOrderTraversal

inOrderTraversal_done:
    # standard epilogue
    lw      $ra, 4($sp)
    lw      $fp, 0($sp)
    addiu   $sp, $sp, 24
    jr      $ra