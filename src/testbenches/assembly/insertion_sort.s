.text
	j	to_kuseg
	j	interrupt
	j	exception

to_kuseg:
	la	$ra,	main
	jr	$ra

main:
	li	$s5,	0x40000014
	lw	$s6,	0($s5)		# load `systick`
	# use insertion sort on array `v` with `n` numbers
	# $s0: i, $s1: j,  $s2: v, $s3: n
	li	$s2,	0		# v = 0x00000000	
	li	$s3,	100		# n = 100
	
	# for_outer (i = 0; i < n; ++i)
	li	$s0,	0		# i = 0
for_outer:
	# if (!(i < n)) end for
	slt	$t0,	$s0,	$s3
	beq	$t0,	$zero,	endf_outer
	
	# for_inner (j = i - 1; j >= 0 && v[j] > v[j + 1]; --j)
	addi	$s1,	$s0,	-1	# j = i - 1
for_inner:
	# if (j < 0) end for
	slti	$t0,	$s1,	0
	bne	$t0,	$zero,	endf_inner
	# if (!(v[j] > v[j + 1])) end for
	sll	$t0,	$s1,	2
	add	$t1,	$s2,	$t0
	lw	$t2,	0($t1)		# $t2 = v[j]
	lw	$t3,	4($t1)		# $t3 = v[j + 1]
	sltu	$t0,	$t3,	$t2
	beq	$t0,	$zero,	endf_inner	
	
	# swap v[j] and v[j + 1]
	sw	$t2,	4($t1)
	sw	$t3,	0($t1)
	
	# loop back for_inner
	addi	$s1,	$s1,	-1	# --j
	j	for_inner	

endf_inner:
	# loop back for_outer
	addi	$s0,	$s0,	1	# ++i
	j	for_outer

endf_outer:
	lw	$s7,	0($s5)		# load `systick`
	sub	$v0,	$s7,	$s6	# $v0 = execution cycles
	
	# enable timer
	lui	$t0,	0x4000
	li	$t1,	0xffffffff
	sw	$t1,	4($t0)
	lui	$t1,	0xfff0
	sw	$t1,	0($t0)
	li	$t1,	3
	sw	$t1,	8($t0)

exit:
	j	exit


interrupt:
  # no need to save registers as we do not return
	# disable timer
	lui	$s0,	0x4000
	sw	$zero,	8($s0)
	
	# display execution cycles
	li	$s0,	0x190		# the base addr of SSD table
	
	# extract lower 16 bits of `systick`
	li	$t4,	0x000f
	and	$t0,	$v0,	$t4
	srl	$v0,	$v0,	4
	and	$t1,	$v0,	$t4
	srl	$v0,	$v0,	4
	and	$t2,	$v0,	$t4
	srl	$v0,	$v0,	4
	and	$t3,	$v0,	$t4
	
	# get SSD representation of `systick`
	sll	$t4,	$t0,	2
	add	$t4,	$t4,	$s0
	lw	$t0,	0($t4)
	addi	$t0,	$t0,	0x800	# 0b1000_0000_0000
	sll	$t4,	$t1,	2
	add	$t4,	$t4,	$s0
	lw	$t1,	0($t4)
	addi	$t1,	$t1,	0x400
	sll	$t4,	$t2,	2
	add	$t4,	$t4,	$s0
	lw	$t2,	0($t4)
	addi	$t2,	$t2,	0x200
	sll	$t4,	$t3,	2
	add	$t4,	$t4,	$s0
	lw	$t3,	0($t4)
	addi	$t3,	$t3,	0x100
	
	li	$s0,	0x40000010	# addr of SSD
scan:
	sw	$t0,	0($s0)
	li	$a0,	10000
	jal	wait
	sw	$t1,	0($s0)
	li	$a0,	10000
	jal	wait
	sw	$t2,	0($s0)
	li	$a0,	10000
	jal	wait
	sw	$t3,	0($s0)
	li	$a0,	10000
	jal	wait
	j	scan

wait:
	addi	$a0,	$a0,	-1
	bne	$a0,	$zero,	wait	
	jr	$ra

exception:
	j	exception
