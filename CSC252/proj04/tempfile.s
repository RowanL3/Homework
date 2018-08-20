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

    # standard epilogue
    lw      $ra, 4($sp)
    lw      $fp, 0($sp)
    addiu   $sp, $sp, 24
    jr      $ra









.data

test01_str:	.asciiz "<<<<< .GNIKROW SI MARGORP RUOY ,SIHT DAER NAC UOY FI >>>>>"

init_regs:
	.word	0xdeadbeef
	.word	0xc0d4f00d
	.word	0x01010101
	.word	0xF0F0F0F0
	.word	0x12345678
	.word	0
	.word	-1
	.word	init_regs

sp_save:	.word   0    # will be *WRITTEN TO*
fp_save:        .word   0    # will be *WRITTEN TO*



.text

main:
	# standard prologue
	addiu   $sp, $sp, -24
	sw      $fp, 0($sp)
	sw      $ra, 4($sp)
	addiu   $fp, $sp, 20


	# preload every s register with a value, to confirm that the student
	# code preserved it.
	#
	# UPDATE: Don't do this to s0, since we'll use it as a loop variable
	# below!
	la      $t0, init_regs     # t0 = &init_regs[0]
    #	lw      $s0,  0($t0)       # s0 =  init_regs[0]
	lw      $s1,  4($t0)       # s1 =  init_regs[1]
	lw      $s2,  8($t0)       # s2 =  init_regs[2]
	lw      $s3, 12($t0)       # s3 =  init_regs[3]
	lw      $s4, 16($t0)       # s4 =  init_regs[4]
	lw      $s5, 20($t0)       # s5 =  init_regs[5]
	lw      $s6, 24($t0)       # s6 =  init_regs[6]
	lw      $s7, 28($t0)       # s7 =  init_regs[7]

	# save the current $sp and $fp for later comparison
	la      $t0, sp_save       # t0 = &sp_save
	sw      $sp, 0($t0)        # sp_save = $sp
	la      $t0, fp_save       # t0 = &fp_save
	sw      $fp, 0($t0)        # fp_save = $fp


	# load test01_str into $s0; if the student program is working, then
	# this will be saved over the call.
	la      $s0, test01_str

main_LOOP:
	# call printRev(s0)
	add     $a0, $s0, $zero
	jal     printRev

	# save the return value for later
	add     $t0, $v0, $zero

	# print out the return value
	add     $a0, $v0, $zero
	addi    $v0, $zero, 1
	syscall

	# print_char('\n')
	addi    $v0, $zero, 11     # print_char
	addi    $a0, $zero, 0xa    # ASCII '\n'
	syscall

	# loop back if the length (that is, the return value) was > 0
	addi    $s0, $s0, 1
	slt     $t1, $zero, $t0
	bne     $t1, $zero, main_LOOP


	# do comparison of all of the registers
	la      $t0, init_regs     # we'll use this base over and over

   #	lw      $t1,  0($t0)
   #	beq     $t1, $s0, main_DO_COMPARE_1

	# if we get here, then we had a MISCOMPARE on s0.  We need to report
	# it.
   #	addi	$a0, $zero, 0
   #	add 	$a1, $t1, $zero
   #	add 	$a2, $s0, $zero
   #	jal     reportMismatch

	# after we call the reporting function, we have to restore the $t1
	# variable, which might not be valid anymore.
   #	la      $t0, init_regs

	# NOTE: From here on, we'll not comment; we'll just do the same thing
	#       over and over, once for each s register.

main_DO_COMPARE_1:
	lw      $t1,  4($t0)
	beq     $t1, $s1, main_DO_COMPARE_2

	addi	$a0, $zero, 1
	add 	$a1, $t1, $zero
	add 	$a2, $s1, $zero
	jal     reportMismatch

	la      $t0, init_regs

main_DO_COMPARE_2:
	lw      $t1,  8($t0)
	beq     $t1, $s2, main_DO_COMPARE_3

	addi	$a0, $zero, 2
	add 	$a1, $t1, $zero
	add 	$a2, $s2, $zero
	jal     reportMismatch

	la      $t0, init_regs

main_DO_COMPARE_3:
	lw      $t1, 12($t0)
	beq     $t1, $s3, main_DO_COMPARE_4

	addi	$a0, $zero, 3
	add 	$a1, $t1, $zero
	add 	$a2, $s3, $zero
	jal     reportMismatch

	la      $t0, init_regs

main_DO_COMPARE_4:
	lw      $t1, 16($t0)
	beq     $t1, $s4, main_DO_COMPARE_5

	addi	$a0, $zero, 4
	add 	$a1, $t1, $zero
	add 	$a2, $s4, $zero
	jal     reportMismatch

	la      $t0, init_regs

main_DO_COMPARE_5:
	lw      $t1, 20($t0)
	beq     $t1, $s5, main_DO_COMPARE_6

	addi	$a0, $zero, 5
	add 	$a1, $t1, $zero
	add 	$a2, $s5, $zero
	jal     reportMismatch

	la      $t0, init_regs

main_DO_COMPARE_6:
	lw      $t1, 24($t0)
	beq     $t1, $s6, main_DO_COMPARE_7

	addi	$a0, $zero, 6
	add 	$a1, $t1, $zero
	add 	$a2, $s6, $zero
	jal     reportMismatch

	la      $t0, init_regs

main_DO_COMPARE_7:
	lw      $t1, 28($t0)
	beq     $t1, $s7, main_COMPARISONS_DONE

	addi	$a0, $zero, 7
	add 	$a1, $t1, $zero
	add 	$a2, $s7, $zero
	jal     reportMismatch

	la      $t0, init_regs

main_COMPARISONS_DONE:

main_DONE:
	# standard epilogue
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 24
	jr      $ra



.data

mismatch_str1:	.asciiz "MISMATCH: register s"
mismatch_str2:	.asciiz                   " was not saved during a function call.  Orig value: "
mismatch_str3:	.asciiz " after the call: "

.text

reportMismatch:
	# standard prologue
	addiu   $sp, $sp, -24
	sw      $fp, 0($sp)
	sw      $ra, 4($sp)
	addiu   $fp, $sp, 20

	# save the three parameters.  We do this because we make heavy use of
	# syscalls in this function.
	sw      $a0,  8($sp)
	sw      $a1, 12($sp)
	sw      $a2, 16($sp)


	# print the leading part of the string...
	addi    $v0, $zero, 4        # print_str
	la	$a0, mismatch_str1
	syscall

	# register number - essentially this is %d
	addi    $v0, $zero, 1        # print_int
	lw      $a0, 8($sp)
	syscall

	# print the second part of the string...
	addi    $v0, $zero, 4        # print_str
	la	$a0, mismatch_str2
	syscall

	# original value - again, this is %d
	addi    $v0, $zero, 1        # print_int
	lw      $a0, 12($sp)
	syscall

	# print the second part of the string...
	addi    $v0, $zero, 4        # print_str
	la	$a0, mismatch_str3
	syscall

	# actual value - again, this is %d
	addi    $v0, $zero, 1        # print_int
	lw      $a0, 16($sp)
	syscall

	# ending newline
	addi    $v0, $zero, 11       # print_char
	addi    $a0, $zero, 0xa      # ASCII '\n'
	syscall


	# standard epilogue
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 24
	jr      $ra



.data
printStr_msg:
	.asciiz	"This message only exists to make sure that you don't hard code the output.  Call printStr() instead!\n"

.text
printStr:
	# standard prologue
	addiu   $sp, $sp, -24
	sw      $fp, 0($sp)
	sw      $ra, 4($sp)
	addiu   $fp, $sp, 20


	# print_str(a0)
	addi 	$v0, $zero, 4
	syscall

	# print_char('\n')
	addi    $v0, $zero, 11
	addi    $a0, $zero, 0xa
	syscall

	# print_str(msg)
	addi    $v0, $zero, 4
	la      $a0, printStr_msg
	syscall


	# standard epilogue
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 24
	jr      $ra



.data
printNibble_msg:
	.asciiz " is the value at nibble "

.text
printNibble:
	# standard prologue
	addiu   $sp, $sp, -24
	sw      $fp, 0($sp)
	sw      $ra, 4($sp)
	addiu   $fp, $sp, 20

	# save a0, a1
	sw      $a0,  8($sp)
	sw      $a1, 12($sp)


	# printf("%d is the value at nibble %d\n", a1, a0);

	add     $a0, $a1, $zero     # print_int(a1)
	addi    $v0, $zero, 1
	syscall

	addi    $v0, $zero, 4       # print_string
	la      $a0, printNibble_msg
	syscall

	addi 	$v0, $zero, 1       # print_int
	lw      $a0, 8($sp)         # print_int(1st arg)
	syscall

	addi    $v0, $zero, 11      # print_char
	addi    $a0, $zero, 0xa     # ASCII '\n'
	syscall


	# standard epilogue
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 24
	jr      $ra


