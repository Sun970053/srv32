.data
    n:		.word	5
    lbracket:	.string	"["
    rbracket: 	.string	"]\n"
    comma: 	.string	","

    iformat: 	.string	"%d"

.text

.global main
main:
    addi	sp, sp, -4
    sw 		ra, 0(sp)

    lw 		t0, n
    slli 	t0, t0, 2
    sub 	sp, sp, t0

    # count bits
    lw 		a0, n
    mv 		a1, sp
    call 	count_bits

    # print result
    mv 		a0, sp
    lw 		a1, n
    slli	a1, a1, 2
    call	print

    # restore sp
    lw 		t0, n
    slli	t0, t0, 2
    add		sp, sp, t0

    # restore ra
    lw 		ra, 0(sp)
    addi 	sp, sp, 4

    # exit
    li 		a0, 0
    ret

popcount:
    li		t2, 0
    mv 		t3, a0

popcount_conti:
    beq 	t3, x0, popcount_end

    # apply a &= (a - 1)
    addi	t4, t3, -1
    and 	t3, t3, t4
    addi	t2, t2, 1
    j		popcount_conti

popcount_end:
    mv 		a0, t2
    ret

count_bits:
    addi 	sp, sp, -4
    sw 		ra, 0(sp)

    # base address of the array
    mv 		s0, a1
    # n
    mv 		s1, a0
    # i
    li 		s3, 0

loop:
    mv 		a0, s3
    call	popcount
    sw 		a0, 0(s0)

    addi	s3, s3, 1
    addi	s0, s0, 4
    bgt 	s1, s3, loop

    lw 		ra, 0(sp)
    addi 	sp, sp, 4
    ret

print:
    addi	sp, sp, -4
    sw 		ra, 0(sp)

    # base address of the array
    mv		s0, a0
    # boundary
    mv 		s1, a1
    add		s1, s1, s0

    # print left bracket
    la		a0, lbracket
    call	printf

    # print first number
    la 		a0, iformat
    lw 		a1, 0(s0)
    call	printf

    addi s0, s0, 4
    ble 	s1, s0, print_end

print_conti:
    # print comma
    la 		a0, comma
    call	printf

    # print number
    la 		a0, iformat
    lw 		a1, 0(s0)
    call 	printf

    addi 	s0, s0, 4
    bgt 	s1, s0, print_conti

print_end:
    # print right bracket and line break
    la 		a0, rbracket
    call 	printf

    lw 		ra, 0(sp)
    addi 	sp, sp, 4
    ret