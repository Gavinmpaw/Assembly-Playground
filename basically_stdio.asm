section .data
	FORMAT_ERROR db "[FORMAT ERORR]",0

section .text

printf:
	push rbp
	mov rbp, rsp
		call basically_printf
	mov rsp, rbp
	pop rbp
	ret

; takes a format string and arguments for each of the format specifiers
; in the following order rdi, rsi, rdx, rcx, r8, r9, and any further on the stack
; clobbers rax, r11, rcx, rdx, rcx, rdi, rsi, r10
basically_printf:
	mov r10, 1 		; current format argument, starting at 1 because format string is 0

	basically_printf_startLp:
	cmp byte [rdi], 0
	je basically_printf_end
		cmp byte [rdi], 0x25
		je basically_printf_format_handling

		push rdi ; push all registers which are clobbered by the syscall
		push rsi
		push rdx
		push rcx

		mov rsi, rdi
		mov rax, 1 	; write
		mov rdi, 1 	; stdout
		mov rdx, 1 	; 1 byte
		syscall 	; rsi stores the pointer to what to print

		pop rcx	; pop previously pushed registers to restore them to their pre-syscall state
		pop rdx
		pop rsi
		pop rdi
	
		jmp basically_printf_non_handling

	basically_printf_format_handling:
		inc rdi					; inc rdi, it should now point to the format character
		xor r11, r11			; set r11 to 0
		mov r11b , byte [rdi]	; move the format character into r11

		push rdx				; push all registers that may be clobbered but are needed later
		push rcx	
		push rdi
		push rsi	

		mov rdi, r11 ; format specifier
		
		cmp r10, 1		; stack of compare jumps to decide which register to read an argument from
		je basically_printf_first_format_arg
		cmp r10, 2
		je basically_printf_second_format_arg
		cmp r10, 3
		je basically_printf_third_format_arg
		cmp r10, 4
		je basically_printf_fourth_format_arg
		cmp r10, 5
		je basically_printf_fifth_format_arg
		jmp basically_printf_stack_format_args

		basically_printf_first_format_arg:
			jmp basically_printf_argument_end	; because the argument is already in rdi. could be optomised by just replacing the jump to this tag
		basically_printf_second_format_arg:
			mov rsi, rdx
			jmp basically_printf_argument_end
		basically_printf_third_format_arg:
			mov rsi, rcx
			jmp basically_printf_argument_end
		basically_printf_fourth_format_arg:
			mov rsi, r8
			jmp basically_printf_argument_end
		basically_printf_fifth_format_arg:
			mov rsi, r9
			jmp basically_printf_argument_end
		basically_printf_stack_format_args:
			mov rcx, r10 	; move arg counter into r10
			sub rcx, 5		; subtract 5 from it (it should be 6 for the first stack arg, 7 for the second, and so on)
			imul rcx, 8		; multiply it by 8 to get the offset from rbp where the arg can be found
			mov rsi, rbp
			sub rsi, rcx	; subtract the offset to get the address of the argument
			mov rsi, [rsi]	; move the actual value at that location into rsi instead (the print format call expects the argument itself to be in rsi)
			jmp basically_printf_argument_end	; technically not needed

		basically_printf_argument_end:
		call print_format
		sub r10, rax
		
		inc r10
		pop rsi					; pop saved registers
		pop rdi
		pop rcx
		pop rdx

	basically_printf_non_handling:
	inc rdi
	jmp basically_printf_startLp

	basically_printf_end:
	ret

; given a format character and its assosiated argument, prints the argument
; expects the format char in rdi and its argument in rsi
; clobbers rax, r11, rcx, rdx, rcx, rdi, rsi
print_format:
	;inc rdi
	cmp rdi, 'd'
	je print_format_decimal_integer_print
	cmp rdi, 's'
	je print_format_string_print
	cmp rdi, 'n'
	je print_format_newline_print

	; this should only be run in the case of an unrecognised format tag, prints [FORMAT ERROR] to stdout	
	mov rdi, FORMAT_ERROR
	call basically_printf
	ret

	print_format_newline_print:
		call print_nl
		mov rax, 1
		ret
	print_format_string_print:
		mov rdi, rsi
		call basically_printf
		mov rax, 0
		ret
	print_format_decimal_integer_print:	
		mov rdi, rsi
		call print_i64
		mov rax, 0
		ret

; expects a 64 bit integer in rdi, returns nothing
; clobbers rax, r11, rcx, rdx, rcx, rdi, rsi
print_i64:
        mov rax, rdi
        mov r11, 10

        mov rcx, 0

        print_i64_lpSt:
                cqo
                idiv r11

                push rdx
                inc rcx

                cmp rax, 0
                jne print_i64_lpSt

        print_i64_lpSt2:
                pop rdi

                push rcx

                call print_single_digit

                pop rcx
                dec rcx

                cmp rcx, 0
                jg print_i64_lpSt2

        ret

; expects an integer between 0 and 9 inclusive in rdi, prints the assosiated character then returns the character's ascii value in rax
; clobbers rax, rdi, rsi, rdx, as well as rcx and r11 on account of syscall
print_single_digit:
        add rdi, 48 ; assuming a single digit integer is in rax, convert it to its ascii value
        push rdi        ; push that value to the stack

        mov rax, 1              ; sys_write
        mov rdi, 1              ; to stdout
        mov rsi, rsp    ; the value on the stack
        mov rdx, 1              ; 1 byte long (1 char)
        syscall

        pop rax ; pop the character back off the stack to avoid corrupting anything, into rax so the function effectively returns the character it printed

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
