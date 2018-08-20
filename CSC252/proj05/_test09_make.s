lab1:
    addi $s2, $zero, 0x10
    addi $s3, $zero, 0xA
    sub  $s1, $s2, $s3
    jal  lab2
    j    done
lab2:
    addi $s1, $s1, 1
    beq  $s1, $s2, lab3
    j    lab2
lab3:
    jr   $ra

done:
    slt  $t4, $s1, $s2