        .syntax unified

.section .rodata
fmt_addr: .asciz "%08X: "   @ Print memory address
fmt_byte: .asciz "%02X "    @ Print hex byte
fmt_char: .asciz "%c"       @ Print single char

	.section .text
	.global hex_dump
	.align 2

@ hex_dump(r0 = addr, r1 = n)
hex_dump:
	push    {r0-r8, lr}              @ Save registers (8-byte aligned)
	mov     r4, r0                   @ r4 = current address
	mov     r5, r1                   @ r5 = total bytes remaining

_row_loop:
	cbz     r5, _hex_dump_done       @ Exit if no bytes left

	@ 1. Print Address at start of row
	ldr     r0, =fmt_addr
	mov     r1, r4
	bl      printf

	mov     r6, #0                  @ r6 = row byte counter (0-15)
	mov     r7, r4                  @ r7 = temp pointer for hex pass

_hex_pass:
	cmp     r6, #16
	beq     _prep_char_pass
	cmp     r6, r5                  @ Check if we've reached total length
	bge     _print_hex_space

	ldrb    r1, [r7, r6]            @ Load byte at (base + offset)
	ldr     r0, =fmt_byte
	bl      printf
	add     r6, #1
	b       _hex_pass

_print_hex_space:
	@ Padding for partial rows at the end
	ldr     r0, =fmt_byte           @ We'll just reuse fmt_byte with a space
					@ (Logic omitted for brevity, usually prints "   ")
	add     r6, #1
	b       _hex_pass

_prep_char_pass:
	mov     r6, #0                  @ Reset counter for ASCII pass

_char_pass:
	cmp     r6, #16
	beq     _row_end
	cmp     r6, r5
	bge     _row_end

	ldrb    r0, [r4, r6]            @ Load byte
	@ Check if printable (32-126)
	cmp     r0, #32
	blo     _use_dot
	cmp     r0, #126
	bhi     _use_dot
	b       _print_it

_use_dot:
	mov     r0, #'.'

_print_it:
	mov     r8, r0                  @ Save char
	ldr     r0, =fmt_char
	mov     r1, r8
	bl      printf

	add     r6, #1
	b       _char_pass

_row_end:
	mov r0, #10
	bl putchar                      @ putchar('\n');

	@ 3. Update pointers
	add     r4, #16                 @ Advance address by 16
	subs    r5, #16                 @ Decrease remaining count
	bpl     _row_loop               @ Loop if positive or zero

_hex_dump_done:
	pop     {r0-r8, pc}

