
.text

    main:
	addiu $v0, $zero, 5	# read first integer from keyboard
      	syscall
	add $a0, $zero, $v0

	addiu $v0, $zero, 5	# read second integer from keyboard
      	syscall
	add $a1, $zero, $v0

	la $t0, div # call mult
	jalr $t0

	add $a0, $zero, $v0 # print checksum
	addi $v0, $zero, 1
	syscall

	addi $v0, $zero, 10  # exit, returning 0
	syscall





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

    jr $ra

# signed division
div: # left is in $a0, right is in $a1
    la $t0, 0x80000000
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
        sltu $t0, $a1, $t0 # if (r+1) > right
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
        sub $v0, $zero, $v0#q = -q
    sign_is_positive_38696558DC98494C08D951C052900A2A:


    jr $ra