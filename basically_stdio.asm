section .data
	string db "first: %d second: %d error: %q",10,0
	decimPlaceholder db "[DecimalInt]",0
	formatError db "[FORMAT ERROR]",0

	intArg dd 64

section .text

global _start

_start:
	mov rdi, string
	call basically_printf	

	mov rax, 60
	mov rdi, 0
	syscall

basically_printf:
	mov rsi, rdi

	startLp:
	cmp byte [rsi], 0
	je end
		cmp byte [rsi], 0x25
		je formatHandling

		mov rax, 1 ; write
		mov rdi, 1 ; stdout
		mov rdx, 1 ; 1 byte
		syscall ; esi stores the pointer to what to print
		jmp nonHandle

	formatHandling:
		call printFormat

	nonHandle:
	inc rsi
	jmp startLp

	end:
	ret

printFormat:
	inc rsi
	cmp byte [rsi], 'd'
	je decimalIntegerPrint
	
	push rsi
	mov rdi, formatError
	call basically_printf
	pop rsi
	ret

	decimalIntegerPrint:	
		push rsi
		mov rdi, decimPlaceholder
		call basically_printf
		pop rsi
		ret





	
