section .data
	string db "first: %d second: %d error: %q",10,0
	decimPlaceholder db "[DecimalInt]",0
	formatError db "[FORMAT ERROR]",0

	intArg dd 64

section .text

global _start

_start:
	mov rdi, string ; 1st arg
	mov rsi, 10		; 2nd arg
	mov rdx, 15		; 3rd arg
	call basically_printf	

	mov rax, 60
	mov rdi, 0
	syscall

; takes a format string and arguments for each of the format specifiers
; rdi = first arg = pointer to format string, 
; rsi = second arg, 
; rdx = third arg,
; rcx = fourth arg, 
; r8  = fifth arg, 
; r9  = sixth arg, 
; stack = args > 6
basically_printf:
	mov r10, rdi ; using r10 as counter for current position, to avoid wiping out arguments that would be in other registers

	startLp:
	cmp byte [r10], 0
	je end
		cmp byte [r10], 0x25
		je formatHandling

		mov rax, 1 	; write
		mov rdi, 1 	; stdout
		mov rdx, 1 	; 1 byte
		mov rsi, r10
		syscall 	; rsi stores the pointer to what to print
		jmp nonHandle

	formatHandling:
		call printFormat

	nonHandle:
	inc r10
	jmp startLp

	end:
	ret

printFormat:
	inc r10
	cmp byte [r10], 'd'
	je decimalIntegerPrint
	
	push r10
	mov rdi, formatError
	call basically_printf
	pop r10
	ret

	decimalIntegerPrint:	
		push r10
		mov rdi, decimPlaceholder
		call basically_printf
		pop r10
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




	
