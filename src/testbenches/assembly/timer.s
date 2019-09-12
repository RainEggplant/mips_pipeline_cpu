	j	to_kuseg
	j	interrupt
	j	exception

to_kuseg:
	la	$ra,	main
	jr	$ra

main:
	# enable timer
	lui	$t1,	0x4000
	lui	$t2,	0xffff
	ori	$t2,	$t2,	0xffcf
	sw	$t2,	0($t1)
	sw	$t2,	4($t1)
	ori	$t3,	$zero,	3
	sw	$t3,	8($t1)

	addi	$a0,	$zero,	3
	jal	sum

loop:
	beq	$zero,	$zero,	loop

sum:
	addi	$sp,	$sp,	-8
	sw	$ra,	4($sp)
	sw	$a0,	0($sp)
	slti	$t0,	$a0,	1
	beq	$t0,	$zero,	L1
	xor	$v0,	$zero,	$zero
	addi	$sp,	$sp,	8
	jr	$ra

L1:
	addi	$a0,	$a0,	-1
	jal	sum
	lw	$a0,	0($sp)
	lw	$ra,	4($sp)
	addi	$sp,	$sp,	8
	add	$v0,	$a0,	$v0
	jr	$ra

interrupt:
	sw	$t1,	-4($sp)
	sw	$t2,	-8($sp)
	lui	$t1,	0x4000
	ori	$t2,	$zero, 3
	sw	$t2,	8($t1)
	lw	$t1,	-4($sp)
	lw	$t2,	-8($sp)
	jr	$k0

exception:
	beq	$zero,	$zero,	exception
