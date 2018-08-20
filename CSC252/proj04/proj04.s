#Author:Rowan Lochrin
#Assignment:CS252 Project 2
#File:proj04.s

.text
printRev:
    # standard prologue
    addiu   $sp, $sp, -24
    sw      $fp, 0($sp)
    sw      $ra, 4($sp)
    addiu   $fp, $sp, 20

    # vars for this function.

    # $s1 = strlen
    # $s3 = pointer to the string (stays at start of string)
    # $s4 = pointer to the string in stack
    # $s5 = start of the string in the stack

    # save S-regs
    addiu   $sp, $sp, -32 # allocate space
    sw      $s0, 0($sp)
    sw      $s1, 4($sp)
    sw      $s2, 8($sp)
    sw      $s3, 12($sp)
    sw      $s4, 16($sp)
    sw      $s5, 20($sp)
    sw      $s6, 24($sp)
    sw      $s7, 28($sp)

    add $s1, $zero $zero            # $s1 = 0
    add $s3, $a0, $zero             # $s3 = pointer to input string
                                    
    add     $s5, $zero, $sp         # used to restore the stack pointer when the function raps up
    addi    $sp, $sp, -4            # allocate enough space for the null char
    sb      $zero, 0($sp)           # add a null char at the end of the strings space in the stack
    
save_loop:                          # loaps throught the string in reverse orderxw
    lb      $s0, 0($s3)             # load byte from str
    beq     $s0, $zero, end_save_loop # go until we hit the null term

    addi    $sp, $sp, -1            # make room for the char on the stack
    sb      $s0, 0($sp)             # save byte into stack
    addi    $s3, $s3, 1
    addi    $s1, $s1, 1             # inc total
    j       save_loop

end_save_loop:
    add     $a0, $zero, $sp         # loads the pointer to the reversed into a0
    
    # round the stack pointer down to a multiple of 4
    srl     $sp, $sp, 2             # turn off last two bits of $sp
    sll     $sp, $sp, 2
    addi    $sp, $sp, -4            # adds -4

    #save $s1
    addi    $sp, $sp, -4
    sw      $s1, 0($sp)            # save the strlen for later user

    jal     printStr                # print the string

    lw      $v0, 0($sp)            # load strlen into v0 (return value)
    # restore the stack pointer to its position before the string was added
    add     $sp, $s5, $zero

    # Load S-regs
    lw      $s0, 0($sp)
    lw      $s1, 4($sp)
    lw      $s2, 8($sp)
    lw      $s3, 12($sp)
    lw      $s4, 16($sp)
    lw      $s5, 20($sp)
    lw      $s6, 24($sp)
    lw      $s7, 28($sp)
    addiu   $sp, $sp, 32 # deallocate space


    # standard epilogue
    lw      $ra, 4($sp)
    lw      $fp, 0($sp)
    addiu   $sp, $sp, 24
    jr      $ra

multiply:
    # standard prologue
    addiu   $sp, $sp, -24
    sw      $fp, 0($sp)
    sw      $ra, 4($sp)
    addiu   $fp, $sp, 20

    # save S-regs
    addiu   $sp, $sp, -32 # allocate space
    sw      $s0, 0($sp)
    sw      $s1, 4($sp)
    sw      $s2, 8($sp)
    sw      $s3, 12($sp)
    sw      $s4, 16($sp)
    sw      $s5, 20($sp)
    sw      $s6, 24($sp)
    sw      $s7, 28($sp)
    # vars for this function.

    # $s1 = running total
    # $s2 = shift amount
    # $s3 = shifted num
    # $s4 = lsb of $a1
    # $s5 = 32 (used to tell us when the mul loop should be over)

    add     $s1, $zero, $zero       # $s1 = 0
    add     $s2, $zero, $zero       # $s2 = 0
    addi    $s5, $zero, 32

mul_loop:
    beq     $s2, $s5, end_mul_loop  # break when $s2 = 32
    andi    $s4, $a1, 1             # get lsb of a1
    # skip adding to if the shifted num if of a1 lsb is 0 
    beq     $s4, $zero, skip_add 
    sllv    $s3, $a0, $s2
    addu    $s1, $s1, $s3           # add shifted amount
skip_add:
    srl     $a1, $a1, 1             # use next lsb of a1
    addi    $s2, $s2, 1             # inc shift amount
    j       mul_loop
end_mul_loop:
    add     $v0, $s1, 0

    # Load S-regs
    lw      $s0, 0($sp)
    lw      $s1, 4($sp)
    lw      $s2, 8($sp)
    lw      $s3, 12($sp)
    lw      $s4, 16($sp)
    lw      $s5, 20($sp)
    lw      $s6, 24($sp)
    lw      $s7, 28($sp)
    addiu   $sp, $sp, 32 # deallocate space

    # standard epilogue
    lw      $ra, 4($sp)
    lw      $fp, 0($sp)
    addiu   $sp, $sp, 24
    jr      $ra

nibbleScan:
    # standard prologue
    addiu   $sp, $sp, -24
    sw      $fp, 0($sp)
    sw      $ra, 4($sp)
    addiu   $fp, $sp, 20

    # save S-regs
    addiu   $sp, $sp, -32 # allocate space
    sw      $s0, 0($sp)
    sw      $s1, 4($sp)
    sw      $s2, 8($sp)
    sw      $s3, 12($sp)
    sw      $s4, 16($sp)
    sw      $s5, 20($sp)
    sw      $s6, 24($sp)
    sw      $s7, 28($sp)

    add     $s1, $zero, $zero       # $s1 = loop_index
    add     $s2, $a0, $zero         # $s2 = word we're working with
    add     $s3, $zero, $zero       # $s3 = the 4 lsb of the word
    add     $s4, $zero, $zero       # $s4 = number of non-zero nibbles
    addi    $s7, $zero, 8           # $s7 = 8 (constant)

    addi    $sp, $sp, -16           # allocate space for t-regs that we will need to save
print_nibble_loop:
    beq     $s1, $s7, end_print_nibble_loop
    andi    $s3, $s2, 15            # get the 4 lsb's of the word

    beq     $s3, $zero, zero_nibble # skip printing and inc the nibble if it's zero
    addi    $s4, $s4, 1             # inc non-zero nibble count
    #pack up our t-regs for the function call
    

    sw      $s1, 0($sp)             # save t-regs to the stack
    sw      $s2, 4($sp)
    sw      $s3, 8($sp)
    sw      $s4, 12($sp)

    add     $a0, $s1, $zero         # load index the nib into printNibble
    add     $a1, $s3, $zero         # load nib into printNibble

    jal     printNibble

    lw      $s1, 0($sp)             # load t-regs from the stack
    lw      $s2, 4($sp)          
    lw      $s3, 8($sp)
    lw      $s4, 12($sp)

    addi    $s7, $zero, 8           # $s7 = 8 (constant) no need save it 
zero_nibble:

    srl     $s2, $s2, 4             # shift to give us 4 new lsb's
    addi    $s1, $s1, 1             # inc loop index
    j       print_nibble_loop

end_print_nibble_loop:
    addi    $sp, $sp, 16            #deallocate the space for the t-regs
    add     $v0, $s4, $zero

    # Load S-regs
    lw      $s0, 0($sp)
    lw      $s1, 4($sp)
    lw      $s2, 8($sp)
    lw      $s3, 12($sp)
    lw      $s4, 16($sp)
    lw      $s5, 20($sp)
    lw      $s6, 24($sp)
    lw      $s7, 28($sp)
    addiu   $sp, $sp, 32 # deallocate space

    # standard epilogue
    lw      $ra, 4($sp)
    lw      $fp, 0($sp)
    addiu   $sp, $sp, 24
    jr      $ra








