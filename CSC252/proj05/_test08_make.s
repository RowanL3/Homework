.text
main:
addi $zero $t0 0x10
add  $t1 $t0 $t0 
add  $t2 $t1 $t0 
add  $t3 $t1 $t1

addi $s4, $zero, 8
sw   $t1, -1($s4)
sw   $t1, -4($s4)
sw   $t2, 0($s4)
sw   $t3, 4($s4)
sw   $t0, 1000($s4)

lw   $t1, -1($s4)
lw   $t5, -4($s4)
lw   $t6, 0($s4)
lw   $t7, 4($s4)
lw   $s1, 1000($s4)
