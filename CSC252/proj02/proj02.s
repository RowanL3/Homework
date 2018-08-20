#Author:Rowan Lochrin
#Assignment:CS252 Project 2
#File:proj02.s

.text
main:    # Function prologue -- even main has one
    addiu $sp, $sp, -24 # allocate stack space -- default of 24 here
    sw    $fp, 0($sp) # save caller's frame pointer
    sw    $ra, 4($sp) # save return address
    addiu $fp, $sp, 20 # setup main's frame pointer

#---Variables for this section---#
# $s1 = forward
# $s2 = integers
# $s3 = numints
# $s4 = index (for use in int loops)
# $s5 = pointer (to the int array)
# $s6 = pointer (to the char array)
# $s7 = pointer (to end of the char array)

# $t1 = used for slt
# $t2 = pointer for arrays
# $t3 = 4*(numints-1)

#load control variables
    la    $t0, forward
    lb    $s1, 0($t0) # $s1 = forward
    la    $t0, integers
    lb    $s2, 0($t0) # $s2 = integers

#load numInts into $s3
    la    $t0, numInts
    lw    $s3, 0($t0)

#initialize index to 0
    add   $s4, $zero, $zero # $s4 = index = 0

#initialize pointer to int[0]
    la    $s5, ints

#initialize pointer to str[0]
    la    $s6, str

#initialize pointer to str[-2] (the last char before the null char)
    add   $s7, $s6, $zero # $s7 = $s6
loopstr:    
    lb    $t0, 0($s7)
    beq   $t0, $zero, done_setting_pointer
    addi  $s7, $s7, 1
    j     loopstr
done_setting_pointer:

#Goto correct function
    beq   $s2, $zero, char # Skips the chars functions if integer = 0 
    bne   $s1,  $zero, forwardint # jumps to forwardint if forward = 1
    j     backwardint # else jumps to backwardint
char:
    bne   $s1, $zero, forwardchar #jumps to forwardchar if forward = 1
    j     backwardchar # else jumps to backwardint



#Forward int loop
forwardint:
    beq   $s3, $s4, done, #Done when the loop has run numints times
    #loop body
    lw    $t0, 0($s5) # $t0 = ints[i]
    beq   $t0, $zero, skipzeros #Don't print anythin if the int loaded was 0
    add   $a0, $t0, $zero #load up the ints[i]
    addi  $v0, $zero, 1 #set syscall to print an int
    syscall # print int[i]
    addi  $a0, $zero, 0xa # ASCII ’\n’
    addi  $v0, $zero, 11 # print_int
    syscall # newline
skipzeros:
    addi  $s5, $s5, 4 # increment the pointer    
    addi  $s4, $s4, 1 # increment the loop
    # increment
    j     forwardint # jumps to the top of fwdint

#Backward int
backwardint:
    #start the pointer at the end of the array
    #end of array = start of array + 4*(numints)
    addi  $t3, $s3, -1 # t3 = numints-1
    add   $t3, $t3, $t3 # t3 = 2*(numints-1)
    add   $t3, $t3, $t3 # t3 = 4*(numints-1)
    add   $s5, $t3, $s5 # s5 = ints[-1]
    add   $s4, $s3, $zero 
bi_loop:
    beq   $s4, $zero, done, #Done when the index reaches 0
    #loop body
    lw    $t0, 0($s5) # $t0 = ints[i]
    add   $a0, $t0, $zero #load up the ints[i]
    addi  $v0, $zero, 1 #set syscall to print an int
    syscall # print int[i]
    addi  $a0, $zero, 0xa # ASCII ’\n’
    addi  $v0, $zero, 11 # print_int
    syscall # newline
    # increment
    addi  $s5, $s5, -4 # decrement the pointer.
    addi  $s4, $s4, -1 # decrement the loop.
    
    j     bi_loop # jumps to the top of the loop

#Forward char loop
forwardchar:
fc_loop:
    lb    $t0, 0($s6)
    beq   $t0, $zero, done #finish when null char is read in
    slti  $t1, $t0, 65 
    bne   $t1, $zero, lessthenA #jumps to less then A if $t0 > 41 
    slti  $t1, $t0, 91
    bne   $t1, $zero, lessthenZ #if A >= $t0 >= Z skips printing

lessthanA: #jumps here if the char is lessthen A and doesnt need to be skiped
    #prints out the char
    add   $a0, $zero, $t0 # loads the char int print_int
    addi  $v0, $zero, 11 # print_int
    syscall # newline
    addi  $a0, $zero, 0xa # ASCII ’\n’
    addi  $v0, $zero, 11 # print_int
    syscall # newline
lessthanZ: #Skips printing if number is bettwen A,Z
    addi  $s6, $s6, 1 # increment the pointer
    j     fc_loop # back to the top of the loop
#Backward char loop
backwardchar:
    addi $s6, $s6, -1 # s6 = s7 when s7 has run out of bonds
    addi $s7, $s7, -1 # dont print the null char
    
bc_loop:
    beq   $s7, $s6, done
    lb    $t0, 0($s7)
    add   $a0, $zero, $t0 # loads the char int print_int
    addi  $v0, $zero, 11 # print_int
    syscall # newline
    addi  $a0, $zero, 0xa # ASCII ’\n’
    addi  $v0, $zero, 11 # print_int
    syscall # newline
    addi  $s7, $s7, -1 # increment the pointer
    j bc_loop # back to top of loop

done: # Epilogue for main -- restore stack & frame pointers and return
    lw    $ra, 4($sp)     # get return address from stack
    lw    $fp, 0($sp)     # restore the caller's frame pointer
    addiu $sp, $sp, 24    # restore the caller's stack pointer
    jr    $ra        