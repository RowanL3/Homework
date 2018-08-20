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

    # If the opcode is 0 find instruction type via func
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
    j    execInstruction_done

bad_allignment:
    addi $v1, $zero, 2
    j    execInstruction_done

_sw:
    # sign exstend imm
    sll  $s6, $s6, 16
    sra  $s6, $s6, 16


    lw   $s1, 0($s1)         # load rs
    lw   $s2, 0($s2)         # load rt

    add  $t0, $s1, $s6       # add the ofset to rs


    # check if memory is in bonds
    slt  $t1, $t0, $t6       # if !(address < memsize) out of bonds
    beq  $t1, $zero, out_of_bonds 

    slt  $t1, $t6, $zero     # if (address < 0) out of bonds     
    bne  $t1, $zero, out_of_bonds #  $t1 != 0 -> $t1 == 1

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
    sw  $t0, 0($s3)          # save back to rd
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

    add  $t7, $t0, $s7

    j    execInstruction_done

_jal:
    addi $t0, $t7, 4         # add 4 to the program counter
    sw   $t0, 124($a2)       # save result into ra
    j    _j

_jr:
    lw   $t0, 0($s1)        # load rs
    add  $t7, $zero, $t0    # add rs to instruction memory
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


    # 5-arg epilogue
    lw      $ra, 4($sp)
    lw      $fp, 0($sp)
    addiu   $sp, $sp, 28
    jr      $ra



