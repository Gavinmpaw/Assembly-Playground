section .bss
	buffer resb 50

section .text

global _start

_start:
	
	mov rdi, buffer ; target address (arg 1)
	mov rsi, 50		; max size 		 (buffer size, 50 bytes)
	call get_string	

	; print whole buffer
	mov rax, 1
	mov rdi, 1
	mov rsi, buffer
	mov rdx, 50
	syscall

	; exit syscall
	mov rax, 60
	mov rdi, 0
	syscall

; expects the address of a buffer in rdi and the max length of the buffer in rsi
; clobbers r11, rcx, rax, rdi, rsi, rdx
get_string:
	mov r11, rdi	; r11 to track where next char goes
	mov rcx, rsi	; rcx as counter

	jmp get_string_lpCond
	get_string_lpSt:

		push rcx
		push r11

		mov rax, 0
		mov rdi, 0
		mov rsi, r11
		mov rdx, 1
		syscall

		pop r11
		pop rcx

		cmp byte [r11], 10
		je get_string_exit_found_nl
		
		inc r11

	get_string_lpCond:
	dec rcx
	cmp rcx, 1
	jg get_string_lpSt

	get_string_exit_found_nl:
	mov byte [r11], 0

	ret		
