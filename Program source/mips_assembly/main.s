.text

# main function, runs in a loop
# we are not using $t6, so I am repurposing it
# for an extra saved variable
main:

    la $t7, read_input
    jalr $t7  # read input1 and op1
    addi $s0, $v0, 0     # save input1
    addi $s1, $t0, 0    # save op1

    equal_return:

    addi $t0, $zero, 0x2a   # clear signal
    bne $s1, $t0, inner_loop
    clear_message_sent: # if op1 == 0x2a: print 0, reset to main
        addi $a0, $zero, 0
	la $t7, print
	jalr $t7
        la $t7, main
	jalr $t7

    inner_loop:

        # read input2 and op2
	# break

	la $t7, read_input
	jalr $t7
        addi $s2, $v0, 0     # save input2
        addi $t6, $t0, 0    # save op2

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

	    la $t7, mult
	    jalr $t7
             # input1 = input1 * input2
            addi $s0, $v0, 0        
        end_mul:
        addi $t0, $zero, 0x44   # div
        bne $t0, $s1, end_div
            addi $a0, $s0, 0
            addi $a1, $s2, 0
             # input1 = input1 / input2
	    la $t7, div
	    jalr $t7
            addi $s0, $v0, 0
        end_div:

        addi $a0, $s0, 0    # print input1
	la $t7, print
	jalr $t7

        addi $t0, $zero, 0x23   # equals
        bne $t0, $t6, end_eq
             # read input2 and op2
	    la $t7, read_input
	    jalr $t7

            addi $s2, $v0, 0    # save input2
            addi $t6, $t0, 0    # save op2

            beq $s2, $zero, end_eq
            addi $s0, $s2, 0        # if the user started typing a new number,
            addi $s1, $t6, 0        # take them back to the start     
            beq $zero, $zero, equal_return

        end_eq:
        addi $t0, $zero, 0x2a   # clear signal
        bne $t0, $t6, end_clr
            beq $zero, $zero, clear_message_sent
        end_clr:

        addi $s1, $t6, 0    # op1 = op2

    beq $zero, $zero, inner_loop

    beq $zero, $zero, main

# reads a multidigit number and an operation
# returns: $v0 = num (number)
#          $t0 = c (operation)

read_input:
    push $ra

    addi $t0, $zero, 0 # num = 0

    reading_loop_start:

         # c = read_keyb_detector()
	la $t7, read_key
	jalr $t7
        addi $t1, $v0, 0

        addi $t2, $zero, 0x3a   
        sgt $t2, $t2, $t1    # t0 = 0x3a > c

        addi $t3, $zero, 0x2f
        sgt $t3, $t1, $t3    # t1 = c > 0x2f

        and $t2, $t2, $t3
        beq $t2, $zero, exit_reading_loop   # if t0 & t1 == 0: break

        push $t1    # save c to memory

        addi $a0, $t0, 0
        addi $a1, $zero, 10
	la $t7, mult
	jalr $t7
         # v = num * 10
        addi $t0, $v0, 0

        pop $t1     # retrieve c
        
        addi $t2, $zero, 0x30
        sub $t2, $t1, $t2   # t2 = c - 0x30

        add $t0, $t0, $t2   # num = num + (c-0x30)

        push $t0    #store num

        addi $a0, $t0, 0
         #print num
	la $t7, print
	jalr $t7

        pop $t0     # retrieve num

    beq $zero, $zero, reading_loop_start

    exit_reading_loop:

    addi $v0, $t0, 0     # return num
    addi $t0, $t1, 0    # return c

    pop $ra
    jalr $zero, $ra


# rising edge detector
read_key:
    push $ra
    poll_for_zero:
    # block until you read a zero
	la $t7, poll_keyboard
	jalr $t7
    bne $v0, $zero, poll_for_zero

    # block until you read a non-zero
    poll_for_char:
	la $t7, poll_keyboard
	jalr $t7
    beq $v0, $zero, poll_for_char

    # return read number
    pop $ra
    jalr $zero, $ra

# standard arithmetic library by Kat Pavu
# internal labels have the md5 hash of the name of the function
# appended to them to reduce the chance of collision with something
# in your code
.text

# signed multiplication
mult: # left is in $a0, right is in $a1

    add $v0, $zero, $zero # acc = 0

    addi $t1, $zero, 1  #t1 = 1
    and $t1, $t1, $a0   #t1 = left & 1
    beq $t1, $zero, left_lsb_is_zero_0F9F2D92C2583EF952556E1F382D0974
        sub $v0, $v0, $a1 # if left & 1 != 0: acc = acc - right
    left_lsb_is_zero_0F9F2D92C2583EF952556E1F382D0974:

    addi $t2, $zero, 32 # index = 32
    loop_start_0F9F2D92C2583EF952556E1F382D0974: # while idex != 0
    beq $t2, $zero, loop_end_0F9F2D92C2583EF952556E1F382D0974 

        sll $a1, $a1, 1 # right = right << 1

        addi $t1, $zero, 3
        and $t1, $t1, $a0   # t1 = left & 3

        addi $t0, $zero, 1 # t2 = 1
        bne $t1, $t0, left_and_3_is_not_1_0F9F2D92C2583EF952556E1F382D0974
            add $v0, $v0, $a1 # if (left & 3) == 1: acc = acc + right
        left_and_3_is_not_1_0F9F2D92C2583EF952556E1F382D0974:

        addi $t0, $zero, 2
        bne $t1, $t0, left_and_3_is_not_2_0F9F2D92C2583EF952556E1F382D0974
            sub $v0, $v0, $a1 # if (left & 3) == 2: acc = acc - right
        left_and_3_is_not_2_0F9F2D92C2583EF952556E1F382D0974:

        addi $t2, $t2, -1 # index = index - 1

        srl $a0, $a0, 1 # left = left >> 1

    beq $zero, $zero, loop_start_0F9F2D92C2583EF952556E1F382D0974
    loop_end_0F9F2D92C2583EF952556E1F382D0974:

    # return acc
    jalr $zero, $ra

# signed division
div: # left is in $a0, right is in $a1
    lui $t0, 0x8000
    and $t1, $t0, $a0 # sign_l = left & 0x80000000
    and $t2, $t0, $a1 # sign_r = right & 0x80000000

    # if left is negative, left = -left
    beq $t1, $zero, left_is_positive_38696558DC98494C08D951C052900A2A
        sub $a0, $zero, $a0
    left_is_positive_38696558DC98494C08D951C052900A2A:

    # if right is negative, right = -right
    beq $t2, $zero, right_is_positive_38696558DC98494C08D951C052900A2A
        sub $a1, $zero, $a1
    right_is_positive_38696558DC98494C08D951C052900A2A:

    # handle division by zero
    # if right == 0: left = [largest numer], right = 1
    bne $a1, $zero, no_division_by_zero_38696558DC98494C08D951C052900A2A
        la $a0, 0x7fffffff
        addi $a1, $zero, 1
    no_division_by_zero_38696558DC98494C08D951C052900A2A:

    xor $a2, $t1, $t2 # save the sign of output to a2

    add $v0, $zero, $zero #  q = 0
    add $t1, $zero, $zero # r = 0

    addi $t2, $zero, 32 #   i = 32
    loop_start_38696558DC98494C08D951C052900A2A: #  while i != 0
    beq $t2, $zero, loop_end_38696558DC98494C08D951C052900A2A
        sll $t1, $t1, 1  # r = r << 1
        sll $v0, $v0, 1    # q = q << 1

        srl $t0, $a0, 31
        or $t1, $t1, $t0    # r |= (left >> 31)

        sll $a0, $a0, 1 # left = let << 1

        addi $t0, $t1, 1
        sgt $t0, $t0, $a1 # if (r+1) > right
        beq $t0, $zero, right_is_bigger_38696558DC98494C08D951C052900A2A
            sub $t1, $t1, $a1   # r = r - right

            addi $t0, $zero, 1
            or $v0, $v0, $t0  # q = q|1
        right_is_bigger_38696558DC98494C08D951C052900A2A:
        
        addi $t2, $t2, -1 # i =  i - 1
    beq $zero, $zero, loop_start_38696558DC98494C08D951C052900A2A
    loop_end_38696558DC98494C08D951C052900A2A:

    # if the sign of the output is negative
    beq $a2, $zero, sign_is_positive_38696558DC98494C08D951C052900A2A
        sub $v0, $zero, $v0 #q = -q
    sign_is_positive_38696558DC98494C08D951C052900A2A:

    # return q
    jalr $zero, $ra


# display a signed number
# dummy function - used for easy testing in mips
print:
    push $ra
    addi $v0, $zero, 1
    syscall

    addi $a0, $zero, 0x0a # print newline
    addi $v0, $zero, 11
    syscall

    pop $ra
    jalr $zero, $ra

# read the keyboard peripheral
# dummy function - used for easy testing in mips
poll_keyboard:
    push $ra
    addiu $v0, $zero, 12	# read char from keyboard
    syscall

    bne $v0, 111, emulate_zero
	addi $v0, $zero, 0
    emulate_zero:

    pop $ra
    jalr $zero, $ra