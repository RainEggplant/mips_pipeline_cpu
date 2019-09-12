j	to_kuseg
j	interrupt
j	exception

to_kuseg:
la	$ra,	main
jr	$ra

main:
lw	$a0,	0($zero)
j	exit

interrupt:
jr	$k0

exception:
exit:
j	exit
nop