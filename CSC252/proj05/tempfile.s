.text

execInstruction:
    # 5-arg prologue
    addiu   $sp, $sp, -28
    sw      $fp, 0($sp)
    sw      $ra, 4($sp)
    addiu   $fp, $sp, 24

    # save S-regs
    addiu   $sp, $sp, -32   # allocate space
    sw      $s0, 0($sp)
    sw      $s1, 4($sp)
    sw      $s2, 8($sp)
    sw      $s3, 12($sp)
    sw      $s4, 16($sp)
    sw      $s5, 20($sp)
    sw      $s6, 24($sp)
    sw      $s7, 28($sp)

    #   -vars in this section-
    #   $t6     mem-size
    #   $t7     progam counter               
    #   $v1     error code
    #
    #   REG     NAME     BITS 
    #   $s0     opcode   31-26
    #   $s1     rs       25-21
    #   $s2     rt       20-16
    #   $s3     rd       15-11
    #   $s4     shift    10-6
    #   $s5     func     5-0
    #   $s6     imm      15-0 
    #   $s7     offset   25-0

    #  <GET FIELDS>

    # opcode 
    addi $t0, $zero, 0x3FF   # create mask for 6 LSB
    srl  $t1, $a0, 26        # shift so opcode is in the 6 LSB
    and  $s0, $t1, $t0       # apply mask

    #li  $v0, 1               # DEBUG CODE REMOVE
    #add $a0, $s0, $zero      # DEBUG CODE REMOVE
    #syscall                  # DEBUG CODE REMOVE

    # rs
    addi $t0, $zero, 0x1F    # create mask for 5 LSB
    srl  $t1, $a0, 21        # shift so rs is in the 5 LSB
    and  $s1, $t1, $t0       # apply mask

    # rt
    srl  $t1, $a0, 16        # shift so rt is in the 5 LSB
    and  $s2, $t1, $t0       # apply mask
    
    # rd
    srl  $t1, $a0, 11        # shift so rd is in the 5 LSB
    and  $s3, $t1, $t0       # apply mask

    # shift
    srl  $t1, $a0, 6         # shift so rt is in the 5 LSB
    and  $s4, $t1, $t0       # apply mask

    # func
    andi  $s5, $a0, 0x3FF    # apply mask

    # imm/offset
    andi $s6, $a0, 0xFFFF    # mask 16 LSB

    # offset
    addi $t1, $zero, 0x3FF   # create a mask of len 10
    sll  $t1, $t1, 16        # shift mask
    ori  $t1, $t1, 0xFFFF    # combine to create mask of len 26
    and  $s7, $a0, $t1       # apply mask

    # <SET UP POINTERS TO REGS>
    # This section makes rs, rt, rd point to the correct place in the array

    # rs
    sll  $s1, $s1, 2         # s1 *= 4
    add  $s1, $s1, $a2       # $s1 = &regs[$s1]

    # rt
    sll  $s2, $s2, 2         # $s2 *= 4
    add  $s2, $s2, $a2       # $s2 = &regs[$s2]

    # rd
    sll  $s3, $s3, 2         # $s3 *= 4
    add  $s3, $s3, $a2       # $s3 = &regs[$s3]

    # <GET CURRENT PC>
    
    # load memsize
    lw   $t6, 56($sp)

    # load pc into $t7
    add  $t7, $zero, $a1

    # set error status to zero
    add  $v1, $zero, $zero   



    # <FIND INSTRUCTION TYPE>
opcode_switch:

    # R-type switch
    beq  $s0, $zero, func_switch 

    # addi: 0x8
    addi $t0, $zero, 0x8
    beq  $s0, $t0, _addi 
    # addiu: 0x9
    addi $t0, $zero, 0x9
    beq  $s0, $t0, _addiu 
    
    # lw: 0x23
    addi $t0, $zero, 0x23
    beq  $s0, $t0, _lw 
    # sw: 0x2B
    addi $t0, $zero, 0x2B
    beq  $s0, $t0, _sw

    # beq: 0x4
    addi $t0, $zero, 0x4
    beq  $s0, $t0, _beq 
    # bne: 0x5
    addi $t0, $zero, 0x5
    beq  $s0, $t0, _bne

    # j: 0x2
    addi $t0, $zero, 0x2
    beq  $s0, $t0, _j 
    # jal: 0x3
    addi $t0, $zero, 0x3
    beq  $s0, $t0, _jal 

    # if opcode invalid return 1
    addi $v1, $zero, 1
    j    execInstruction_done

func_switch:

    # add: 0x20
    addi $t0, $zero, 0x20
    beq  $s5, $t0, _add
    # sub: 0x22
    addi $t0, $zero, 0x22
    beq  $s5, $t0, _sub 

    # slt: 0x2A
    addi $t0, $zero, 0x2A
    beq  $s5, $t0, _slt

    # jr: 0x8
    addi $t0, $zero, 0x8
    beq  $s5, $t0, _jr 

    # syscall: 0xC
    addi $t0, $zero, 0xC
    beq  $s5, $t0, _syscall

    # if opcode invalid return 1
    addi $v1, $zero, 1
    j    execInstruction_done


    # <INSTRUCTIONS>
    
_add:
    lw   $t0, 0($s1)         # load rs
    lw   $t1, 0($s2)         # load rt
    add  $t0, $t0, $t1       # add rs and rt
    sw   $t0  0($s3)         # save result into rd
    j    inc_pc

_sub:
    lw   $t0, 0($s1)         # load rs
    lw   $t1, 0($s2)         # load rt
    sub  $t0, $t0, $t1       # sub rs and rt
    sw   $t0  0($s3)         # save result into rd
    j    inc_pc


_addi:
    # sign exstend imm
    sll  $s6, $s6, 16
    sra  $s6, $s6, 16

    lw   $t0, 0($s1)         # load rs
    add  $t0, $t0, $s6       # add the immediate value
    sw   $t0  0($s2)         # save result into rt 
    j    inc_pc

_addiu:
    j    _addi               # same as addi for this project

_lw:

    # sign exstend offset
    sll  $s6, $s6, 16
    sra  $s6, $s6, 16

    lw   $s1, 0($s1)         # load rs

    add  $t0, $s1, $s6       # add the ofset to rs

    # check if memory is in bonds
    slt  $t1, $t0, $t6 
    beq  $t1, $zero, out_of_bonds # !(address < memsize)

    # check to make sure pointer is word alligned
    andi $t1, $t0, 0x3       # $t1 = $t0 mod 4
    bne  $t1, $zero, bad_allignment # !($t0 == 0 mod 4)

    add  $t0, $t0, $a3       # point to virtual memory

    lw   $t0, 0($t0)         # load the word from virtual memory

    sw   $t0, 0($s2)         # save the word in virtual registers

    j    inc_pc

out_of_bonds:
    addi $v1, $zero, 3
    j    inc_pc

bad_allignment:
    addi $v1, $zero, 2
    j    inc_pc

_sw:
    # sign exstend imm
    sll  $s6, $s6, 16
    sra  $s6, $s6, 16


    lw   $s1, 0($s1)         # load rs
    lw   $s2, 0($s2)         # load rt

    add  $t0, $s1, $s6       # add the ofset to rs

    #li  $v0, 1              # DEBUG CODE REMOVE
    #add $a0, $s1, $zero     # DEBUG CODE REMOVE
    #syscall                 # DEBUG CODE REMOVE

    #li  $v0, 11             # DEBUG CODE REMOVE
    #addi $a0, $zero, 0xa    # DEBUG CODE REMOVE
    #syscall       

    # check if memory is in bonds
    slt  $t1, $t0, $t6 

    beq  $t1, $zero, out_of_bonds # !(address < memsize)

    # check to make sure pointer is word alligned
    andi $t1, $t0, 0x3       # $t1 = $t0 mod 4
    bne  $t1, $zero, bad_allignment # !($t0 == 0 mod 4)

    add  $t0, $t0, $a3       # point to virtual memory

    sw   $s2, 0($t0)         # save rt the the correct adress in memory

    j    inc_pc


_slt:
    lw  $s1, 0($s1)          # load rs
    lw  $s2, 0($s2)          # load rt 
    slt $t0, $s1, $s2
    sw  $t0, 0($s3)
    j   inc_pc


_beq:
    lw  $s1, 0($s1)          # load rs
    lw  $s2, 0($s2)          # load rt 
    beq $s1, $s2, beq_bne_branch
    j inc_pc

_bne:
    lw  $s1, 0($s1)          # load rs
    lw  $s2, 0($s2)          # load rt 
    bne $s1, $s2, beq_bne_branch
    j inc_pc

beq_bne_branch:
    # does the branching for both bne and beq
    # sign exstend imm
    sll  $s6, $s6, 16
    sra  $s6, $s6, 16

    sll  $s6, $s6, 2         # ofset *= 4

    add  $t7,  $t7, $s6      # pc += 4*(ofset)

    j inc_pc

_j:    
    sll  $s7, $s7, 2         # $s7 *= 4

    # add the upper 4 bits of the pc
    addi $t0, $zero, 0xF       # make a mask for 4 bits
    sll  $t0, $t0, 28        # shift the mask to the 10 most significant bit
    and  $t0, $t7, $t0       # appy the mask
    #ori  $t2, $t1, -1

    add  $t7, $t0, $s7

    j    execInstruction_done

_jal:
    addi $t0, $t7, 4         # add 4 to the program counter
    sw   $t0, 124($a2)       # save result into ra
    j    _j

_jr:
    lw   $t0, 0($s1)
    add  $t7, $zero, $t0
    j    execInstruction_done

_syscall:
    lw   $v0, 8($a2)         # load $v0 from virtual regs
    lw   $a0, 16($a2)        # load $a0 from virtual regs
    
    addi $t0, $zero, 10         
    beq  $t0, $v0, syscall_10 # if $v0 = 10 exit

    addi $t0, $zero, 4         
    beq  $t0, $v0, syscall_4 # if $v0 = 4 print string

    syscall

    j    inc_pc
    #syscall special cases
syscall_10:
    addi $v1, $zero, -1      # set error status to -1
    j   execInstruction_done

syscall_4:
    add $a0, $a0, $a3        # set pointer to virtual memory
    syscall
    j   inc_pc


inc_pc:
    # adds 4 to the program counter skiped by jumps
    addi $t7, $t7, 4               

execInstruction_done:
    add $v0, $t7, $zero

    # Load S-regs
    lw      $s0, 0($sp)
    lw      $s1, 4($sp)
    lw      $s2, 8($sp)
    lw      $s3, 12($sp)
    lw      $s4, 16($sp)
    lw      $s5, 20($sp)
    lw      $s6, 24($sp)
    lw      $s7, 28($sp)
    addiu   $sp, $sp, 32     # deallocate space



    # $t1 = opcode for the switch

    # 5-arg epilogue
    lw      $ra, 4($sp)
    lw      $fp, 0($sp)
    addiu   $sp, $sp, 28
    jr      $ra




.data

REGS:
	.space	128       # 32 words



PROGRAM:
	.word	0x2002ffff         # addi    $a0, $zero, -1
END_PROGRAM:



MEMORY:
	.space	4096               # 4 KB
	.asciiz	"The quick brown fox jumps over the lazy dog.\n"
	.space	8192               # 8 KB
END_MEMORY:



.text


main:
	# standard prologue
	addiu   $sp, $sp, -24
	sw      $fp, 0($sp)
	sw      $ra, 4($sp)
	addiu   $fp, $sp, 20


	# in this function, we'll use the following registers:
	#     s0 - address of register file
	#     s1 - address of program (in real memory)
	#     s2 - length of program
	#     s3 - address of virtual memory buffer, in real memory
	#     s4 - length of virtual memory
	#     s5 - current program counter

	la      $s0, REGS         # s0 = &regs

	la      $s1, PROGRAM      # s1 = &program_start

	la      $s2, END_PROGRAM
	sub     $s2, $s2, $s1             # s2 = &program_end - &program_start

	la      $s3, MEMORY       # s3 = &program_start

	la      $s4, END_MEMORY
	sub     $s4, $s4, $s3             # s4 = &mem_end - &mem_start

	addi    $s5, $zero, 0             # PC = 0


main_PROGRAM_LOOP:
	# print out all of the data about the current instruction
.data
main_MSG1:	.asciiz	"PC: "

.text
	addi    $v0, $zero, 4             # print_str(MSG1)
	la      $a0, main_MSG1
	syscall

	add     $a0, $s5, $zero           # printHex(PC, 8)
	addi    $a1, $zero, 8
	jal     printHex

	addi    $v0, $zero, 11            # print_char(newline)
	addi    $a0, $zero, 0xa
	syscall


	# is the program counter outside of the valid range?
	slt     $t0, $s5, $zero           # t0 = PC < 0
	bne     $t0, $zero, main_PC_INVALID

	slt     $t0, $s5, $s2             # t0 = PC < programSize
	beq     $t0, $zero, main_PC_INVALID


	# the instruction address is valid (although it might not be aligned!)
	# Go ahead and run it.

	# args 1-4 are in registers; the fifth arg is on the stack.
	add     $t0, $s1, $s5             # t0 = &program[PC]
	lw      $a0, 0($t0)               # a0 =  program[PC]

	add     $a1, $s5, $zero           # a1 = PC

	add     $a2, $s0, $zero           # a2 = regs

	add     $a3, $s3, $zero           # a3 = mem

	sw      $s4, -4($sp)              # arg5 = memSize

	jal     execInstruction

	# update the program counter
	add     $s5, $v0, $zero

	# if this is an error, then jump to the error handler.
	bne     $v1, $zero, main_END_ERROR

	j       main_PROGRAM_LOOP


main_PC_INVALID:
.data
main_PC_INVALID_msg:	.asciiz "ERROR: The program counter is invalid.  PC="
.text

	addi    $v0, $zero, 4
	la      $a0, main_PC_INVALID_msg
	syscall

	add     $a0, $s5, $zero
	addi    $a1, $zero, 8
	jal     printHex

	addi    $v0, $zero, 11
	addi    $a0, $zero, 0xa    # print_char('\n')
	syscall

	j       main_DONE


main_END_ERROR:
	addi    $t0, $zero, -1
	beq     $v1, $t0, main_DONE    # normal end - syscall 10

.data
main_END_ERROR_msg:	.asciiz	"ERROR: The program failed with error code "
.text
	addi    $v0, $zero, 4
	la      $a0, main_END_ERROR_msg
	syscall

	addi    $v0, $zero, 1
	add     $a0, $v1, $zero
	syscall

	addi    $v0, $zero, 11
	addi    $a0, $zero, 0xa    # print_char('\n')
	syscall

	j       main_DONE


main_DONE:
	add     $a0, $s5, $zero
	jal     dumpState

	# standard epilogue
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 24
	jr      $ra




# HELPER FUNCTION: printHex(value, minChars)
#
# This basically implements printf("%nx", value) , where 'n' is minChars
printHex:
	# standard prologue
	addiu   $sp, $sp, -24
	sw      $fp, 0($sp)
	sw      $ra, 4($sp)
	addiu   $fp, $sp, 20


	# if value == 0 && minChars <= 0, then this call is a NOP.
	bne    $a0, $zero, printHex_doPrint

	slt    $t0, $zero, $a1
	bne    $t0, $zero, printHex_doPrint

	# if we get here, then we don't have any reason to print.
	j      printHex_DONE

printHex_doPrint:
	# if we get here, then we *DO* want to print.  Recurse first - but
	# save the 'value' argument before that.
	sw     $a0, 8($sp)         # save a0 into its slot

	srl    $a0, $a0, 4         # printHex(value >> 4, minChars-1)
	addi   $a1, $a1, -1
	jal    printHex

	# restore that argument register.  Note that we didn't save minChars,
	# since it wasn't required later in this function.
	lw     $a0, 8($sp)

	# finally, print out this one character.  We extract the nibble first,
	# and then figure out whether or not it is a decimal or letter to
	# print.
	andi   $t0, $a0, 0xf       # t0 = value & 0xf

	slti   $t1, $t0, 10        # t1 = (value & 0xf) < 10
	bne    $t1, $zero, printHex_IS_A_DIGIT


	# t0 contains a number more than 9, but less than 16.  Print it out
	# as a character.
	addi   $v0, $zero, 11      # print_char('a'-10+ (value & 0xf))
	addi   $a0, $t0, 'a'-10
	syscall

	j      printHex_DONE


printHex_IS_A_DIGIT:
	# t0 contains a number less than 10, which we want to print.
	addi   $v0, $zero, 1       # print_int(value & 0xf)
	add    $a0, $t0, $zero
	syscall


printHex_DONE:
	# standard epilogue
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 24
	jr      $ra



dumpState:
	# standard prologue
	addiu   $sp, $sp, -24
	sw      $fp, 0($sp)
	sw      $ra, 4($sp)
	addiu   $fp, $sp, 20


	# save the sX registers that we'll be using
	sw      $s0,  -4($sp)
	sw      $s1,  -8($sp)
	sw      $s2, -12($sp)
	addiu   $sp, $sp, -12


.data
dumpState_MSG1:	.asciiz	"PC="
dumpState_MSG2:	.asciiz	" regs:"
.text


	# save the PC register, so that it's not messed up by the syscall.
	add    $s0, $a0, $zero

	# print out the first string...
	addi   $v0, $zero, 4
	la     $a0, dumpState_MSG1
	syscall

	# ...then the PC value...
	addi   $v0, $zero, 1
	add    $a0, $s0, $zero
	syscall

	# ...then the second string...
	addi   $v0, $zero, 4
	la     $a0, dumpState_MSG2
	syscall

	# ...then a loop over all of the regsiters.
	addi   $s0, $zero, 0
	la     $s1, REGS
	addi   $s2, $zero, 32

dumpState_LOOP:
	# print a space...
	addi   $v0, $zero, 11
	addi   $a0, $zero, ' '
	syscall

	# ...then the register number...
	addi   $v0, $zero, 1
	add    $a0, $s0, $zero
	syscall

	# ...then a colon...
	addi   $v0, $zero, 11
	addi   $a0, $zero, ':'
	syscall

	# ...then the register value
	lw     $a0, 0($s1)              # printHex(regs[s0], 1)
	addi   $a1, $zero, 1
	jal    printHex

	addi   $s0, $s0, 1
	addi   $s1, $s1, 4

	slt    $t0, $s0, $s2
	bne    $t0, $zero, dumpState_LOOP

	addi   $v0, $zero, 11           # print_char(newline)
	addi   $a0, $zero, 0xa
	syscall


dumpState_DONE:
	# restore the sX registers
	addiu   $sp, $sp, 12
	lw      $s0,  -4($sp)
	lw      $s1,  -8($sp)
	lw      $s2, -12($sp)

	# standard epilogue
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 24
	jr      $ra


