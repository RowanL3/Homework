.data
printmsg:  .asciiz "Printing the four values:\n"
summsg:  .asciiz "Running totals:\n"
mulmsg:  .asciiz "\"Multiplying\" each value by 7:\n"
minmsg:  .asciiz "Minimum: "

newline: .asciiz "\n"
two_spaces: .asciiz "  "

.text
main:    # Function prologue -- even main has one
    addiu $sp, $sp, -24 # allocate stack space -- default of 24 here
    sw    $fp, 0($sp) # save caller's frame pointer
    sw    $ra, 4($sp) # save return address
    addiu $fp, $sp, 20 # setup main's frame pointer

print_start:
    #Skip print if not necessary
    la      $t0, print #loads print into t0
    lw      $t0, 0($t0)
    beq     $t0, $zero, sum_start #skips printing if print = 0 
    #Print out the starting print line.
    la      $a0, printmsg # Point to the string
    addi    $v0, $zero, 4 # syscall value for print_string
    syscall
    #load and print foo
    la      $t0, foo #loads the pointer to foo in t0
    lb      $a0, 0($t0) #loads the word from t0
    addi    $v0, $zero, 1 #sets v0 so syscall can print an int
    syscall
    #load and print a new line
    la      $a0, newline   #Point to the string
    addi    $v0, $zero, 4  #syscall value for print_string
    syscall
    #load and print bar
    la      $t0, bar #loads the pointer to foo in t0
    lw      $a0, 0($t0) #loads the word from t0
    addi    $v0, $zero, 1 #sets v0 so syscall can print an int
    syscall
    #load and print a new line
    la      $a0, newline   #Point to the string
    addi    $v0, $zero, 4  #syscall value for print_string
    syscall
    #load and print baz
    la      $t0, baz #loads the pointer to foo in t0
    lw      $a0, 0($t0) #loads the word from t0
    addi    $v0, $zero, 1 #sets v0 so syscall can print an int
    syscall
    #load and print a new line
    la      $a0, newline   #Point to the string
    addi    $v0, $zero, 4  #syscall value for print_string
    syscall
    #load and print fred
    la      $t0, fred #loads the pointer to foo in t0
    lh      $a0, 0($t0) #loads the word from t0
    addi    $v0, $zero, 1 #sets v0 so syscall can print an int
    syscall
    #load and print 2 new lines
    la      $a0, newline   #Point to the string
    addi    $v0, $zero, 4  #syscall value for print_string
    syscall
    syscall

sum_start:
    #Skip sum if not necessary
    la      $t0, sum #loads print into t0
    lw      $t0, 0($t0)
    beq     $t0, $zero, mul_start #skips summing if sum = 0 
    #Print out the starting sum line.
    la      $a0, summsg #Point to the string
    addi    $v0, $zero, 4 #syscall value for print_string
    syscall
    #initialize a running total var in $s0 to 0
    add     $s0, $zero, $zero
    #Load and add foo to the running total
    la      $t0, foo      #loads the pointer into t0
    lb      $t0, 0($t0)   #*$t0
    add     $s0, $s0, $t0 #running_total($s0) += foo
    #print out the running total
    add     $a0, $s0, $zero #loads the running total into syscall
    addi    $v0, $zero, 1 #sets v0 so syscall will print an int
    syscall #a0 is already being used as the running total
    #load and print a new line
    la      $a0, newline   #Point to the string
    addi    $v0, $zero, 4  #syscall value for print_string
    syscall
    #Load and add bar to the running total
    la      $t0, bar      #loads the pointer into t0
    lw      $t0, 0($t0)   #*$t0
    add     $s0, $s0, $t0 #running_total ($s0) += bar
    #prints out the running total
    add     $a0, $s0, $zero #loads the running total into syscall
    addi    $v0, $zero, 1 #sets v0 so syscall will print an int
    syscall #a0 is already being used as the running total
    #load and print a new line
    la      $a0, newline   #Point to the string
    addi    $v0, $zero, 4  #syscall value for print_string
    syscall
    #Load and add baz to the running total
    la      $t0, baz      #loads the pointer into t0
    lw      $t0, 0($t0)   #*$t0
    add     $s0, $s0, $t0 #running_total ($s0) += baz
    #prints out the running total
    add     $a0, $s0, $zero #loads the running total into syscall
    addi    $v0, $zero, 1 #sets v0 so syscall will print an int
    syscall #a0 is already being used as the running total
    #load and print a new line
    la      $a0, newline   #Point to the string
    addi    $v0, $zero, 4  #syscall value for print_string
    syscall
    #Load and add fred to the running total
    la      $t0, fred      #loads the pointer into t0
    lh      $t0, 0($t0)   #*$t0
    add     $s0, $s0, $t0 #running_total ($s0) += fred
    #prints out the running total
    add     $a0, $s0, $zero #loads the running total into syscall
    addi    $v0, $zero, 1 #sets v0 so syscall will print an int
    syscall #a0 is already being used as the running total
    #load and print 2 new lines
    la      $a0, newline   #Point to the string
    addi    $v0, $zero, 4  #syscall value for print_string
    syscall
    syscall


mul_start:
    #Skip mul if not necessary
    la      $t0, multiply #loads multiply into t0
    lw      $t0, 0($t0)
    beq     $t0, $zero, minstart #skips multiplying if mul = 0
    #set up a constant
    addi    $s7, $zero, 7 #$s7 = 7
    #Print out the multiplication line.
    la      $a0, mulmsg #Point to the string
    addi    $v0, $zero, 4 #syscall value for print_string
    syscall
#--FOO--#
mul_foo:
    #initialize an index $t1 for the multiplication loop
    add     $t1, $zero, $zero #$t1 = 0
    add     $t2, $zero, $zero #t2 = 0 (being used as the running total for multiplcation)
    #Conditional for the loop
    #Load foo into $t0
    la      $t0, foo      #loads the pointer into t0
    lb      $t0, 0($t0)   #*$t0
mull_foo_loop:
    beq     $t1, $s7, print_7foo #exit condtion for the loop
    addu    $t2, $t2, $t0 #$t2 (running total) += foo
    addi    $t1, 1 #increment the loop
    j       mull_foo_loop
print_7foo:
    add     $a0, $t2, $zero #load up the arg for syscall
    addi    $v0, $zero, 1 #set syscall to print an int
    syscall
    #load and print 2 spaces
    la      $a0, two_spaces
    addi    $v0, $zero, 4 #set syscall to print a string
    syscall
#--BAR--#
mul_bar:
    #initialize an index $t1 for the multiplication loop
    add     $t1, $zero, $zero #$t1 = 0
    add     $t2, $zero, $zero #t2 = 0 (being used as the running total for multiplcation)
    #Conditional for the loop
    #Load bar into $t0
    la      $t0, bar      #loads the pointer into t0
    lw      $t0, 0($t0)   #*$t0
mull_bar_loop:
    beq     $t1, $s7, print_7bar #exit condtion for the loop
    addu    $t2, $t2, $t0 #$t2 (running total) += bar
    addi    $t1, 1 #increment the loop
    j       mull_bar_loop
print_7bar:
    add     $a0, $t2, $zero #load up the arg for syscall
    addi    $v0, $zero, 1 #set syscall to print an int
    syscall
    #load and print 2 spaces
    la      $a0, two_spaces
    addi    $v0, $zero, 4 #set syscall to print a string
    syscall
#--BAZ--#
mul_baz:
    #initialize an index $t1 for the multiplication loop
    add     $t1, $zero, $zero #$t1 = 0
    add     $t2, $zero, $zero #t2 = 0 (being used as the running total for multiplcation)
    #Conditional for the loop
    #Load baz into $t0
    la      $t0, baz      #loads the pointer into t0
    lw      $t0, 0($t0)   #*$t0
mull_baz_loop:
    beq     $t1, $s7, print_7baz #exit condtion for the loop
    addu    $t2, $t2, $t0 #$t2 (running total) += baz
    addi    $t1, 1 #increment the loop
    j       mull_baz_loop
print_7baz:
    add     $a0, $t2, $zero #load up the arg for syscall
    addi    $v0, $zero, 1 #set syscall to print an int
    syscall
    #load and print 2 spaces
    la      $a0, two_spaces
    addi    $v0, $zero, 4 #set syscall to print a string
    syscall
#--FRED--#
mul_fred:
    #initialize an index $t1 for the multiplication loop
    add     $t1, $zero, $zero #$t1 = 0
    add     $t2, $zero, $zero #t2 = 0 (being used as the running total for multiplcation)
    #Conditional for the loop
    #Load fred into $t0
    la      $t0, fred     #loads the pointer into t0
    lb      $t0, 0($t0)   #*$t0
mull_fred_loop:
    beq     $t1, $s7, print_7fred #exit condtion for the loop
    addu    $t2, $t2, $t0 #$t2 (running total) += fred
    addi    $t1, 1 #increment the loop
    j       mull_fred_loop
print_7fred:
    add     $a0, $t2, $zero #load up the arg for syscall
    addi    $v0, $zero, 1 #set syscall to print an int
    syscall
    #load and print 2 new lines
    la      $a0, newline   #Point to the string
    addi    $v0, $zero, 4  #syscall value for print_string
    syscall
    syscall

minstart:
    #Skip min if not necessary
    la      $t0, minimum #loads multiply into t0
    lw      $t0, 0($t0)
    beq     $t0, $zero, done #skips min if min = 0
    #Print out the multiplication line.
    la      $a0, minmsg #Point to the string
    addi    $v0, $zero, 4 #syscall value for print_string
    syscall
    #--FOO--#
    la      $t0, foo #loads foo into $t1 (as foo is the current min)
    lb      $t1, 0($t0)
    #--BAR--#
    la      $t0, bar #loads bar into $t0
    lw      $t0, 0($t0)
    slt     $t2, $t0, $t1
    beq     $t2, $zero, bar_not_min
    add     $t1, $t0, $zero #bar = current min (Skiped if bar ($t0) !< $t1)
bar_not_min:
    #--BAZ--#
    la      $t0, baz #loads baz into $t0
    lw      $t0, 0($t0)
    slt     $t2, $t0, $t1
    beq     $t2, $zero, baz_not_min
    add     $t1, $t0, $zero #current min = baz (Skiped if baz ($t0) !< $t1)
baz_not_min:
    #--fred--#
    la      $t0, fred #loads fred into $t0
    lh      $t0, 0($t0)
    slt     $t2, $t0, $t1
    beq     $t2, $zero, fred_not_min
    add     $t1, $t0, $zero #current min = fred (Skiped if fred ($t0) !< $t1)
fred_not_min:
    add     $a0, $t1, $zero
    addi    $v0, $zero, 1
    syscall
    #load and print 2 new lines
    la      $a0, newline   #Point to the string
    addi    $v0, $zero, 4  #syscall value for print_string
    syscall
    syscall

done: # Epilogue for main -- restore stack & frame pointers and return
    lw    $ra, 4($sp)     # get return address from stack
    lw    $fp, 0($sp)     # restore the caller's frame pointer
    addiu $sp, $sp, 24    # restore the caller's stack pointer
    jr    $ra             # return to caller's code