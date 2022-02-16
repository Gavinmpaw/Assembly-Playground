section .data
	string db "output %d <first int %d <second int",10,0
	decimPlace db "{DecimalInt}"

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
		inc rsi
		cmp byte [rsi], 'd'
		jne nonHandle

		push rsi

		mov rax, 1
		mov rdi, 1
		mov rsi, decimPlace
		mov rdx, 12
		syscall

		pop rsi

	nonHandle:
	inc rsi
	jmp startLp

	end:
	ret
