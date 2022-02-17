section .data
	number dq 6015
	char db '#'
	numberChars db '0','1','2','3','4','5','6','7','8','9'

section .text

global _start

_start:
	mov rsi, 0
	mov rdi, 10

	lpSt: ; TODO this loop is currently broken, so I just set rdi after
		mov rax, [number]
		cqo
		idiv rdi

		imul rdi, 10

		cmp rax, 0
		jg lpSt	

	mov rdi, 1000	

	lpSt2:
		mov rax, [number]
		cqo
		idiv rdi
		mov r11, rax

		push rdi

		imul rdi, rax
		sub [number], rdi

		mov rbx, 10
		mov rax, rdi
		cqo
		idiv rbx
		mov rdi, rax

		push rdi

		lea rsi, [numberChars + r11]
		mov rax, 1
		mov rdi, 1
		mov rdx, 1
		syscall

		pop rdi

		cmp rdx, 0
		jg lpSt2
		
		

			
			


	mov rax, 60
	mov rsi, 0
	syscall
