# ----- STUDENT CODE BELOW -----
#Author:Rowan Lochrin
#Assignment:CS252 Project 3
#File:proj03.s

.text
main:    # Function prologue -- even main has one
    addiu $sp, $sp, -24     # allocate stack space -- default of 24 here
    sw    $fp, 0($sp)       # save caller's frame pointer
    sw    $ra, 4($sp)       # save return address
    addiu $fp, $sp, 20      # setup main's frame pointer

# - VARS IN THIS SECTION -
    # $s0 = numStrs
    # $s1 = pointer to strings
    # $s2 = index for loops
    # $s3 = string1
    # $s4 = string2
    # $s5 = c

#load Vars from data
    la   $t0, numStrs 
    lb   $s0, 0($t0)        # load numStrs into $s0
    la   $s1, strings       # load pointer to strings into $s1    
    la   $t0, s1
    lb   $s3, 0($t0)        # load string1 into $s3
    la   $t0, s2            
    lb   $s4, 0($t0)        # load string2 into $s4
    la   $t0, c
    lh   $s5  0($t0)        # load c into $s5

#initialize vars
    add  $s2, $zero, $zero  # loop index ($s2) = 0

#Mode Selector 
    la    $t0, mode         # load mode into t0
    lb    $t0, 0($t0)       # *$t0    
    addi  $t1, $zero, 2     # set up a constant 2
    beq   $t0, $t1, mode2   # branch if mode = 2
    addi  $t1, $zero, 3     # set up a constant 3
    beq   $t0, $t1, mode3   # branch if mode = 3
    addi  $t1, $zero, 4     # set up a constant 4
    beq   $t0, $t1, mode4   # branch if mode = 4
    j     done              # jump to done if no valid mode selected

mode2: #Print strings
    print_loop:
    beq   $s2, $s0  done    # breaks the loop index = numstrs
    lw    $t0, 0($s1)       # load the address pointed to by the string pointer into memory
    la    $a0, 0($t0)       # loads the string that address was pointing at into print_str

    # Print(*strpointer) 
    addi  $v0, $zero, 4     # set syscall to print a string
    syscall
                     
    #newline
    addi  $a0, $zero, 0xa   # ASCII ’\n’
    addi  $v0, $zero, 11    # print_int
    syscall

    # increment and go back to top
    addi  $s1, 4            # string pointer++
    addi  $s2, $s2, 1       # index++
    j print_loop            # jumps back to the top of the loop

mode3: #Double index
    sll   $s3, $s3, 2       # $s3 = 4 * $s3 (string1)
    add   $s1, $s1, $s3     # sets s1 to point to str[string1]
    lw    $t0, 0($s1)       # load the address pointed to by the string pointer into memory
    add   $t0, $t0, $s5     # adds c to the index of the char printed
    lb    $a0, 0($t0)       # loads the char that address was pointing at into $t0

    # Print(*strpointer) 
    addi  $v0, $zero, 11    # set syscall to print a char
    syscall

    #newline
    addi  $a0, $zero, 0xa   # ASCII ’\n’
    addi  $v0, $zero, 11    # print_int
    syscall

    j       done            # jumps to end when double index is done

mode4: #Compare two strings and swap
    #---VARS in this section---#
    # $s6 = the pointer to the address of string one
    # $s7 = the pointer to the address of string two
    # $t6 = address of string1
    # $t7 = address of string2
    # $t3 = adress of char i in string1
    # $t4 = adress of char i in string2
    # $t2 = 1 (used for beq)

    sll   $s3, $s3, 2       # $s3 *= 4 (string1)
    sll   $s4, $s4, 2       # $s4 *= 4 (string2)
    add   $s6, $s1, $s3     # $s6 = str[string1]
    add   $s7, $s1, $s4     # $s7 = str[string2]
    lw    $t6, 0($s6)       # $s8 = address of a char in string1
    lw    $t7, 0($s7)       # $s9 = address of a char in string2
    addi  $t2, $zero, 1

    #--decide to swap--#
    decision_loop:
    lb    $t3, 0($t6)       # load the relevant char from string1
    lb    $t4, 0($t7)       # load the relevant char from string2
    beq   $t3, $zero, dontswap # dont swap if the char being considerd in string1 is null
    beq   $t4, $zero, swap  # swap if the char being consided in string2 is null
    slt   $t0, $t3, $t4     # $t0 = $t3 < $t4, a < b (true)
    beq   $t0, $t2, dontswap # if $t3 < $t4 dontswap
    slt   $t0, $t4, $t3     # $t0 = $t3 < $t4, b < a (false)
    beq   $t0, $t2, swap    # if $s3 < $s4 don't swap
    addi  $t6, $t6, 1       # point to next char in string1
    addi  $t7, $t7, 1       # point to next char in string2
    j     decision_loop     # back to top of the loop

    swap:
    lw    $t6, 0($s6)       # move pointers back to the start of the word
    lw    $t7, 0($s7)       
    sw    $t6, 0($s7)       # swap words
    sw    $t7, 0($s6)

    dontswap:
    j     mode2             # jumps to print once compare two strings is done

done: # Epilogue for main -- restore stack & frame pointers and return
    lw    $ra, 4($sp)       # get return address from stack
    lw    $fp, 0($sp)       # restore the caller's frame pointer
    addiu $sp, $sp, 24      # restore the caller's stack pointer
    jr    $ra    