.text

# main function, runs in a loop
# we are not using $gv, so I am repurposing it
# for an extra saved variable
main:

    ja $ra, read_input  # read input1 and op1
    addi $s0, $v, 0     # save input1
    addi $s1, $t0, 0    # save op1

    equal_return:

    addi $t0, $zero, 0x2a   # clear signal
    bne $s1, $t0, inner_loop
    clear_message_sent: # if op1 == 0x2a: print 0, reset to main
        addi $a0, $zero, 0
        ja $ra, print
        ja $ra, main

    inner_loop:

        ja $ra, read_input  # read input2 and op2
        addi $s2, $v, 0     # save input2
        addi $gv, $t0, 0    # save op2

        addi $t0, $zero, 0x41   # plus
        bne $t0, $s1, end_plus
            add $s0, $s0, $s2   # input1 = input1 + input2
        end_plus:
        addi $t0, $zero, 0x42   # minus
        bne $t0, $s1, end_minus
            sub $s0, $s0, $s2   # input1 = input1 - input2
        end_minus:
        addi $t0, $zero, 0x43   # mul
        bne $t0, $s1, end_mul
            addi $a0, $s0, 0
            addi $a1, $s2, 0
            ja $ra, mult        # input1 = input1 * input2
            addi $s0, $v, 0        
        end_mul:
        addi $t0, $zero, 0x44   # div
        bne $t0, $s1, end_div
            addi $a0, $s0, 0
            addi $a1, $s2, 0
            ja $ra, div         # input1 = input1 / input2
            addi $s0, $v, 0
        end_div:

        addi $a0, $s0, 0    # print input1
        ja $ra, print

        addi $t0, $zero, 0x23   # equals
        bne $t0, $gv, end_eq

            ja $ra, read_input  # read input2 and op2
            addi $s2, $v, 0    # save input2
            addi $gv, $t0, 0    # save op2

            beq $s2, $zero, end_eq
            addi $s0, $s2, 0        # if the user started typing a new number,
            addi $s1, $gv, 0        # take them back to the start        
            beq $zero, $zero, equal_return

        end_eq:
        addi $t0, $zero, 0x2a   # clear signal
        bne $t0, $gv, end_clr
            beq $zero, $zero, clear_message_sent
        end_clr:

        addi $s1, $gv, 0    # op1 = op2

    beq $zero, $zero, inner_loop

    beq $zero, $zero, main

# reads a multidigit number and an operation
# returns: $v = num (number)
#          $t0 = c (operation)

read_input:
    push $ra

    addi $t0, $zero, 0 # num = 0

    reading_loop_start:

        ja $ra, read_key    # c = read_keyb_detector()
        addi $t1, $v, 0

        addi $t2, $zero, 0x3a   
        cmp $t2, $t2, $t1    # t0 = 0x3a > c

        addi $t3, $zero, 0x2f
        cmp $t3, $t1, $t3    # t1 = c > 0x2f

        and $t2, $t2, $t3
        beq $t2, $zero, exit_reading_loop   # if t0 & t1 == 0: break

        push $t1    # save c to memory

        addi $a0, $t0, 0
        addi $a1, $zero, 10
        ja $ra, mult    # v = num * 10
        addi $t0, $v, 0

        pop $t1     # retrieve c
        
        addi $t2, $zero, 0x30
        sub $t2, $t1, $t2   # t2 = c - 0x30

        add $t0, $t0, $t2   # num = num + (c-0x30)

        push $t0    #store num

        addi $a0, $t0, 0
        ja $ra, print   #print num

        pop $t0     # retrieve num

    beq $zero, $zero, reading_loop_start

    exit_reading_loop:

    addi $v, $t0, 0     # return num
    addi $t0, $t1, 0    # return c

    pop $ra
    j $zero, $ra


# rising edge detector
read_key:
    push $ra
    poll_for_zero:
    # block until you read a zero
        ja $ra, poll_keyboard
    bne $v, $zero, poll_for_zero

    # block until you read a non-zero
    poll_for_char:
        ja $ra, poll_keyboard
    beq $v, $zero, poll_for_char

    # return read number
    pop $ra
    j $zero, $ra


.data
    KEYBOARD:   .addr 0xffff0000
    DISPLAY:    .addr 0xffff0004

.text
# display a signed number
# dummy function - used for easy testing in mips
print:
    la $a1, DISPLAY
    sw $a0, $a1
    j $zero, $ra

# read the keyboard peripheral
# dummy function - used for easy testing in mips
poll_keyboard:
    la $a0, KEYBOARD
    lw $v, $a0
    j $zero, $ra