.data
printmsg:  .asciiz "Printing the four values:\n"
summsg:  .asciiz "Running totals:\n"
mulmsg:  .asciiz "\"Multiplying\" each value by 7:\n"
minmsg:  .asciiz "Minimum: "

newline: .asciiz "\n"

.text

main:    # Function prologue -- even main has one
    addiu $sp, $sp, -24 # allocate stack space -- default of 24 here
    sw    $fp, 0($sp) # save caller's frame pointer
    sw    $ra, 4($sp) # save return address
    addiu $fp, $sp, 20 # setup main's frame pointer


    #set up constants 1-4 and initialize t1 to 0
    add     $t1, $zero, $zero #Useing t1 as the index for the loop
    addi    $s1, $zero, 1     #s1 = 1
    addi    $s2, $zero, 2     #s2 = 2
    addi    $s3, $zero, 3     #s3 = 3

print_start: #([-> s7 = current task, starts to feed data into print loaded]):
    la      $t0, print #loads print into t0
    lw      $t0, 0($t0)
    beq     $t0, $zero, sum_start #skips printing if print = 0 

    la      $a0, printmsg # Point to the string
    addi    $v0, $zero, 4 # syscall value for print_string
    syscall

    add     $s7, $zero, $zero #sets the current task being worked on to 0
    j       load

sum_start: #( s7 = current task, starts to feed data into sum loaded and sets t3 (the running total) to zero:
    la      $t0, sum #loads the pointer to sum in $t0
    lw      $t0, 0($t0) #loads sum into t0
    beq     $t0, $zero, done #skips printing if sum = 0

    add     $t3, $zero, $zero #set the running total to 0

    la      $a0, summsg   # Point to the string
    addi    $v0, $zero, 4 # syscall value for print_string
    syscall

    add     $s7, $zero, $s1 #sets the current task being worked on to 1
    j       load

choose_task: #(s7 = current_task -> selects which function should opperate on t0 and advances t[1] the load index)
    addi    $t1, $t1, 1 #adds one to the index of the loop
    beq     $s7, $zero, print_loader  #if s7 = 0 goto load_foo
    beq     $s7, $s1, sum_loader  #if t1 = 1 goto load_bar
    beq     $s7, $s2, mul_loader  #if t1 = 2 goto load_baz
    beq     $s7, $s3, min_loader #if t1 = 3 goto load_fred

choose_finish: #(s7 = current_task -> selects approprite finishing function to complete current task)
    beq     $s7, $zero, print_finish  #if t1 = 0 goto load_foo
    beq     $s7, $s1, sum_finish  #if t1 = 1 goto load_bar
    beq     $s7, $s2, mul_finish  #if t1 = 2 goto load_baz
    beq     $s7, $s3, min_finish #if t1 = 3 goto load_fred


load: #loops through all the tasks with an index of t1 directs to choose finsih afterwords
    beq     $t1, $zero, load_foo  #if t1 = 0 goto load_foo
    beq     $t1, $s1, load_bar  #if t1 = 1 goto load_bar
    beq     $t1, $s2, load_baz  #if t1 = 2 goto load_baz
    beq     $t1, $s3, load_fred #if t1 = 3 goto load_fred
    j       choose_finish #Jump to the end of the loop once everything is loader and printed

load_foo:   #loads the pointer to foo into t0
    la      $t0, foo #loads the pointer to foo in t0
    j       choose_task #jumps to the section that prints out what t0 is pointed to

load_bar:   #loads the pointer to bar into t0
    la      $t0, bar #loads the pointer to bar in t0
    j       choose_task #jumps to the section that prints out what t0 is pointed to

load_baz:   #loads the pointer to baz into t0
    la      $t0, baz #loads the pointer to baz in t0
    j       choose_task #jumps to the section that prints out what t0 is pointed to

load_fred:  #loads the pointer to fred into t0
    la      $t0, fred #loads the pointer to fred in t0
    j       choose_task #jumps to the section that prints out what t0 is pointed to

#--Print helper functions--#
print_loader: #prints that value of t[0]
    #printing a word in t0
    lw      $a0, 0($t0) #loads the word from t0
    addi    $v0, $zero, 1 #sets v0 so syscall can print an int
    syscall
    #printing a newline
    la      $a0, newline   #Point to the string
    addi    $v0, $zero, 4  #syscall value for print_string
    syscall

    j       load

print_finish: #prints a blank line and moves onto the sum.
    la      $a0, newline   # Point to the string
    addi    $v0, $zero, 4 # syscall value for print_string
    syscall
    j       sum_start


#--sum helper functions--#
sum_loader: #prints that value of $t0
    #printing a word in $t0
    #$t3 is the running total
    lw      $t0, 0($t0) #loads the word from $t0 to $t4
    add     $t3, $t3, $t0 #adds $t0 to the running total
    add     $a0, $t3, $zero #sets syscall to output $a0
    addi    $v0, $zero, 1 #sets v0 to 1 so syscall can print an int
    syscall
    #printing a newline
    la      $a0, newline   # Point to the string
    addi    $v0, $zero, 4 # syscall value for print_string
    syscall

    j       load

sum_finish: #prints a blank line and moves onto the sum.
    la      $a0, newline   # Point to the string
    addi    $v0, $zero, 4 # syscall value for print_string
    syscall
    j       done

done: # Epilogue for main -- restore stack & frame pointers and return
    lw    $ra, 4($sp)     # get return address from stack
    lw    $fp, 0($sp)     # restore the caller's frame pointer
    addiu $sp, $sp, 24    # restore the caller's stack pointer
    jr    $ra             # return to caller's code