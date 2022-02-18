section .text

global _start

_start:

	mov rdi, 421
	call print_i64_simplified	
	call print_nl

	mov rax, 60
	mov rsi, 0
	syscall

; 
print_i64_simplified:
	mov rax, rdi
	mov r11, 10

	mov rcx, 0

	print_i64_simplified_lpSt:
		cqo
		idiv r11

		push rdx
		inc rcx

		cmp rax, 0
		jne print_i64_simplified_lpSt

	print_i64_simplified_lpSt2:
		pop rdi

		push rcx

		call print_single_digit

		pop rcx
		dec rcx

		cmp rcx, 0
		jg print_i64_simplified_lpSt2

	ret
	

; expects a 64 bit integer stored in rdi, no return value
; clobbers rax, rcx, rdx, rsi, rdi, r11, rcx
print_i64:
	push rdi	
	mov rdi, rsp
	call get_i64_digit_count
	pop rcx

	mov rdi, 1

	print_i64_lpSt:
		cmp rax, 1
		jle print_i64_lpEd

		imul rdi, 10

		dec rax
		jmp print_i64_lpSt
	print_i64_lpEd:

	print_i64_lpSt2:
		mov rax, rcx
		cqo
		idiv rdi
		mov r11, rax

		push rdi

		imul rdi, rax
		sub rcx, rdi

		pop rdi
		
		mov rbx, 10
		mov rax, rdi
		cqo
		idiv rbx
		mov rdi, rax

		push rdi
		push rcx

		mov rdi, r11
		call print_single_digit

		pop rcx
		pop rdi

		cmp rdi, 0
		jg print_i64_lpSt2

	ret
		

; expects a pointer to a i64 stored in rdi, returns the length of that number in rax
; clobbers r11, rdi, rsi, rax
; TODO I think this can be made cleaner by repeatedly dividing the original number by 10 and using rax as the new number on the next loop
get_i64_digit_count:
	mov r11, rdi ; r11 should hold the address of the number

	mov rdi, 1 	 ; multiplied by 10 until it gets bigger than the number
	mov rsi, 0	 ; counts the number of times we multiply by 10

	get_i64_digit_count_lp_st:
		mov rax, [r11]
		cqo
		idiv rdi

		cmp rax, 0 ; leave the loop if the division result is 0, or less... but it should never be less
		jle get_i64_digit_count_lp_ed

		imul rdi, 10	
		inc rsi
		jmp get_i64_digit_count_lp_st
	get_i64_digit_count_lp_ed:

	mov rax, rsi

	ret

; expects an integer between 0 and 9 inclusive in rdi, prints the assosiated character then returns the character's ascii value in rax
; clobbers rax, rdi, rsi, rdx, as well as rcx and r11 on account of syscall
print_single_digit:
	add rdi, 48 ; assuming a single digit integer is in rax, convert it to its ascii value
	push rdi	; push that value to the stack

	mov rax, 1		; sys_write
	mov rdi, 1		; to stdout
	mov rsi, rsp	; the value on the stack
	mov rdx, 1		; 1 byte long (1 char)
	syscall

	pop rax	; pop the character back off the stack to avoid corrupting anything, into rax so the function effectively returns the character it printed

	ret

print_nl:
	mov rdi, 10
	push rdi

	mov rax, 1
	mov rdi, 1
	mov rsi, rsp
	mov rdx, 1
	syscall

	pop rdi

	ret

	
