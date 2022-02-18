section .data
	number dq 601534

section .text

global _start

_start:
	mov rsi, 0
	mov rdi, 1

	lpSt:
		mov rax, [number]
		cqo
		idiv rdi

		cmp rax, 0
		jle lpEd

		imul rdi, 10	
		jmp lpSt
	lpEd:

	mov rbx, 10
	mov rax, rdi
	cqo
	idiv rbx
	mov rdi, rax

	lpSt2:
		mov rax, [number]
		cqo
		idiv rdi
		mov r11, rax

		push rdi

		imul rdi, rax
		sub [number], rdi

		pop rdi
		
		mov rbx, 10
		mov rax, rdi
		cqo
		idiv rbx
		mov rdi, rax

		push rdi

		;lea rsi, [numberChars + r11]
		add r11, 48
		push r11
				
		lea rsi, [rsp]
		mov rax, 1
		mov rdi, 1
		mov rdx, 1
		syscall

		pop r11
		pop rdi

		cmp rdi, 0
		jg lpSt2
		
	mov rax, 60
	mov rsi, 0
	syscall
