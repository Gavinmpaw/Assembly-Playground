section .data
	number dq 6015512

section .text

global _start

_start:
	mov rdi, number
	call getIntegerDigitCount

	mov rdi, 1

	lpSt:
		cmp rax, 1
		jle lpEd

		imul rdi, 10

		dec rax
		jmp lpSt
	lpEd:

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

		mov rdi, r11
		call printSingleDigit

		pop rdi

		cmp rdi, 0
		jg lpSt2
		
	mov rax, 60
	mov rsi, 0
	syscall


; expects a pointer to a i64 stored in rdi, returns the length of that number in rax
; clobbers r11, rdi, rsi, rax
getIntegerDigitCount:
	mov r11, rdi ; r11 should hold the address of the number

	mov rdi, 1 	 ; multiplied by 10 until it gets bigger than the number
	mov rsi, 0	 ; counts the number of times we multiply by 10

	getIntegerDigitCountlpSt:
		mov rax, [r11]
		cqo
		idiv rdi

		cmp rax, 0 ; leave the loop if the division result is 0, or less... but it should never be less
		jle getIntegerDigitCountlpEd

		imul rdi, 10	
		inc rsi
		jmp getIntegerDigitCountlpSt
	getIntegerDigitCountlpEd:

	mov rax, rsi

	ret

; expects an integer between 0 and 9 inclusive in rdi, prints the assosiated character then returns the character's ascii value in rax
; clobbers rax, rdi, rsi, rdx
printSingleDigit:
	add rdi, 48 ; assuming a single digit integer is in rax, convert it to its ascii value
	push rdi	; push that value to the stack

	mov rax, 1		; sys_write
	mov rdi, 1		; to stdout
	mov rsi, rsp	; the value on the stack
	mov rdx, 1		; 1 byte long (1 char)
	syscall

	pop rax	; pop the character back off the stack to avoid corrupting anything, into rax so the function effectively returns the character it printed

	ret
