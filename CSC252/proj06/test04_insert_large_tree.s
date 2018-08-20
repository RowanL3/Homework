
# RUSS'S MAGICAL EASY-MODIFY TESTCASE
#
# Each testcase consists of a "script" (just below), and then code which
# interprets and executes it.  All of the testcases have the same code - they
# only differ in the data section.
#
# Each command is represented by an 8-byte sequence: a character which gives
# the command, a half-word (with one byte padding beforehand) which indicates
# which tree to use, and then a word which gives a parameter.  The first two
# are always used; the third is only used for commands which need it (but it
# must always be present!
#
# I mentioned that there is a way to choose different trees.  In order to
# confirm that students use the root pointer (rather than saving it as a
# global), some testcases will have multiple active trees with different
# contents.  The code allows a maximum of 4 of these trees at the same time.
#
# To write a new script, modify the lines between the 'BEGIN_SCRIPT' and
# 'END_SCRIPT' labels.  Add as many steps as you want.  All 4 of the trees
# will start out as NULL (empty tree), and you can run as many commands as
# you want.
#
# The available commands are:
#    'i'    - insert (parameter required)
#    's'    - search (parameter required)
#    'c'    - count  (parameter must be present, but is ignored)
#    't'    - pre-order traversal (parameter must be present, but is ignored)
#    'T'    -  in-order traversal (parameter must be present, but is ignored)



.data

testcase_DEBUG:
	.word	0    # set this to 1 if you want more debugging info in your script

testcase_BEGIN_SCRIPT:
	# write your script here!

	.byte	'i'
	.half		0
	.word			8

	.byte	't'
	.half		0
	.word			-1  # ignored

	.byte	'T'
	.half		0
	.word			-1  # ignored

	.byte	'i'
	.half		0
	.word			4

	.byte	't'
	.half		0
	.word			-1  # ignored

	.byte	'T'
	.half		0
	.word			-1  # ignored

	.byte	'i'
	.half		0
	.word			12

	.byte	't'
	.half		0
	.word			-1  # ignored

	.byte	'T'
	.half		0
	.word			-1  # ignored

	.byte	'i'
	.half		0
	.word			2

	.byte	't'
	.half		0
	.word			-1  # ignored

	.byte	'T'
	.half		0
	.word			-1  # ignored

	.byte	'i'
	.half		0
	.word			6

	.byte	't'
	.half		0
	.word			-1  # ignored

	.byte	'T'
	.half		0
	.word			-1  # ignored

	.byte	'i'
	.half		0
	.word			10

	.byte	't'
	.half		0
	.word			-1  # ignored

	.byte	'T'
	.half		0
	.word			-1  # ignored

	.byte	'i'
	.half		0
	.word			14

	.byte	't'
	.half		0
	.word			-1  # ignored

	.byte	'T'
	.half		0
	.word			-1  # ignored

	.byte	'i'
	.half		0
	.word			1

	.byte	't'
	.half		0
	.word			-1  # ignored

	.byte	'T'
	.half		0
	.word			-1  # ignored

	.byte	'i'
	.half		0
	.word			3

	.byte	't'
	.half		0
	.word			-1  # ignored

	.byte	'T'
	.half		0
	.word			-1  # ignored

	.byte	'i'
	.half		0
	.word			5

	.byte	't'
	.half		0
	.word			-1  # ignored

	.byte	'T'
	.half		0
	.word			-1  # ignored

	.byte	'i'
	.half		0
	.word			7

	.byte	't'
	.half		0
	.word			-1  # ignored

	.byte	'T'
	.half		0
	.word			-1  # ignored

	.byte	'i'
	.half		0
	.word			9

	.byte	't'
	.half		0
	.word			-1  # ignored

	.byte	'T'
	.half		0
	.word			-1  # ignored

	.byte	'i'
	.half		0
	.word			11

	.byte	't'
	.half		0
	.word			-1  # ignored

	.byte	'T'
	.half		0
	.word			-1  # ignored

	.byte	'i'
	.half		0
	.word			13

	.byte	't'
	.half		0
	.word			-1  # ignored

	.byte	'T'
	.half		0
	.word			-1  # ignored

	.byte	'i'
	.half		0
	.word			15

	.byte	't'
	.half		0
	.word			-1  # ignored

	.byte	'T'
	.half		0
	.word			-1  # ignored

testcase_END_SCRIPT:
	# don't modify anyting below this, unless you are *VERY* certain
	# that you know what you are doing.  :)



# these are variables used by the code below - you're welcome to examine how
# it all works, but it's not really designed for you to modify.

testcase_THE_TREES:
	.word	0
	.word	0
	.word	0
	.word	0



.text


main:
	# standard prologue
	addiu   $sp, $sp, -24
	sw      $fp, 0($sp)
	sw      $ra, 4($sp)
	addiu   $fp, $sp, 20


	# in this function, we'll use the following registers:
	#     s0 -  pointer to the current position in the script
	#     s1 - &END_SCRIPT
	#     s2 - &THE_TREES
	#     s3 -  DEBUG (actual value)
	#     s4 - &curTree

	la      $s0, testcase_BEGIN_SCRIPT        # s0 = &BEGIN_SCRIPT
	la      $s1, testcase_END_SCRIPT          # s1 = &END_SCRIPT
	la      $s2, testcase_THE_TREES           # s2 = &THE_TREES

	la      $s3, testcase_DEBUG               # s3 = &DEBUG
	lw      $s3, 0($s3)                       # s3 =  DEBUG

	add     $s7, $s0, $zero                   # s7 = save start of instruction list


main_SCRIPT_LOOP:
	# are we at the end of the script?
	slt     $t0, $s0,$s1                      # t0 = (curPos < end)
	beq     $t0, $zero, main_DONE


	# should we do debug?
	beq     $s3, $zero, main_DEBUG_DONE       # if (!DEBUG) skip it

	#######################################
	#
	# DEBUG INFO:
	#
	#   - Current script pointer
	#   - Current operation and parameters
	#
	#######################################
.data
main_DEBUG_MSG1:   .asciiz "Instruction Index: "
main_DEBUG_MSG2:   .asciiz "\n  command: "
main_DEBUG_MSG3:   .asciiz "\n  treeNo : "
main_DEBUG_MSG4:   .asciiz "\n  param  : "
.text
	addi    $v0, $zero, 4
	la      $a0, main_DEBUG_MSG1
	syscall

	sub     $t0, $s0, $s7           # t0 = byte-wise offset from script start
	sra     $a0, $t0, 3             # a0 = script_offset

	addi    $v0, $zero, 1           # print_int(script index)
	syscall

	addi    $v0, $zero, 4
	la      $a0, main_DEBUG_MSG2
	syscall

	addi    $v0, $zero, 11          # print_char(cmd)
	lb      $a0, 0($s0)
	syscall

	addi    $v0, $zero, 4
	la      $a0, main_DEBUG_MSG3
	syscall

	addi    $v0, $zero, 1           # print_int(treeNo)
	lh      $a0, 2($s0)
	syscall

	addi    $v0, $zero, 4
	la      $a0, main_DEBUG_MSG4
	syscall

	addi    $v0, $zero, 1           # print_int(param)
	lw      $a0, 4($s0)
	syscall

	addi    $v0, $zero, 11          # print_char('\n')
	addi    $a0, $zero, 0xa
	syscall


main_DEBUG_DONE:
	# read the three parameters at the current script location, and
	# then advance the script pointer.
	lb      $t0, 0($s0)             # t0 = curPos->cmd
	lh      $t1, 2($s0)             # t0 = curPos->treeNo
	lw      $t2, 4($s0)             # t0 = curPos->param

	addi    $s0, $s0, 8


	# sanity check that the tree # is valid.
	slt     $t3, $t1, $zero         # t3 = (curPos->treeNo < 0)
	bne     $t3, $zero, main_TESTCASE_ERR

	addi    $t3, $t1, -3
	slt     $t3, $zero, $t3         # t3 = (3 < curPos->treeNo)
	bne     $t3, $zero, main_TESTCASE_ERR


	# load s4 with the address of the proper tree.  Then load the
	# tree itself into $t8; we'll use it later.
	sll     $s4, $t1, 2             # s4 = curPos->treeNo * 4
	add     $s4, $s2, $s4           # s4 = &tree[curPos->treeNo]

	lw	$t8, 0($s4)


	# is the command something we recognize?
	addi    $t3, $zero, 'i'
	beq     $t0, $t3, main_INSERT

	addi    $t3, $zero, 's'
	beq     $t0, $t3, main_SEARCH

	addi    $t3, $zero, 'c'
	beq     $t0, $t3, main_COUNT

	addi    $t3, $zero, 't'
	beq     $t0, $t3, main_PRE_ORDER

	addi    $t3, $zero, 'T'
	beq     $t0, $t3, main_IN_ORDER

	j       main_TESTCASE_ERR      # unrecognized command


main_TESTCASE_ERR:

.data
main_TESTCASE_ERR_MSG1:   .asciiz "Testcase configuration error at 0x"
.text

	addi    $v0, $zero, 4
	la      $a0, main_TESTCASE_ERR_MSG1
	syscall

	add     $a0, $s4, $zero
	addi    $a1, $zero, 8
	jal     printHex

	addi    $v0, $zero, 11
	addi    $a0, $zero, 0xa
	syscall

	j       main_SCRIPT_LOOP


main_INSERT:
	add     $a0, $t8, $zero
	add     $a1, $t2, $zero
	jal     bst_insert

	sw      $v0, 0($s4)

	j       main_SCRIPT_LOOP

main_SEARCH:
	# save the parameter for later...
	add     $s5, $t2, $zero

	# call bst_search()
	add     $a0, $t8, $zero
	add     $a1, $t2, $zero
	jal     bst_search

.data
main_SEARCH_MSG1: .asciiz " found\n"
main_SEARCH_MSG2: .asciiz " NOT found\n"
.text

	# print out "%d found\n" or "%d NOT found\n"

	# save the return value for later, while we print the number.
	add     $s6, $v0, $zero

	addi    $v0, $zero, 1
	add     $a0, $s5, $zero
	syscall

	# branch to decide which string to print
	beq     $s6, $zero, main_SEARCH_NOT_FOUND

	# print "found"
	addi    $v0, $zero, 4
	la      $a0, main_SEARCH_MSG1
	syscall

	j       main_SEARCH_DONE

main_SEARCH_NOT_FOUND:
	# print " NOT found"
	addi    $v0, $zero, 4
	la      $a0, main_SEARCH_MSG2
	syscall

main_SEARCH_DONE:
	j       main_SCRIPT_LOOP

main_COUNT:
	add     $a0, $t8, $zero
	jal     bst_count

	# print out the integer
	add     $a0, $v0, $zero
	addi    $v0, $zero, 1
	syscall

	addi    $v0, $zero, 11
	addi    $a0, $zero, 0xa
	syscall

	j       main_SCRIPT_LOOP

main_PRE_ORDER:
	add     $a0, $t8, $zero
	jal     bst_preOrderTraversal

	# print out the trailing newline

	addi    $v0, $zero, 11
	addi    $a0, $zero, 0xa
	syscall

	j       main_SCRIPT_LOOP

main_IN_ORDER:
	add     $a0, $t8, $zero
	jal     bst_inOrderTraversal

	# print out the trailing newline

	addi    $v0, $zero, 11
	addi    $a0, $zero, 0xa
	syscall

	j       main_SCRIPT_LOOP


main_DONE:
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


