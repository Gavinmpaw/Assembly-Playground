section .data
	string db "int1: %d int2: %d int3: %d int4: %d int5: %d error: %q",10,0
	formatError db "[FORMAT ERROR]",0

	intArg dd 64

section .text

global _start

_start:
	mov rdi, string ; 1st arg
	mov rsi, 14		; 2nd arg
	mov rdx, 15		; 3rd arg
	mov rcx, 16
	mov r8 , 17
	mov r9 , 18
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
	mov r10, 1 		; current format argument, starting at 1 because format string is 0

	startLp:
	cmp byte [rdi], 0
	je end
		cmp byte [rdi], 0x25
		je formatHandling

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
	
		jmp nonHandle

	formatHandling:
		inc rdi					; inc rdi, it should now point to the format character
		xor r11, r11			; set r11 to 0
		mov r11b , byte [rdi]	; move the format character into r11

		push rdx				; push all registers that may be clobbered but are needed later
		push rcx	
		push rdi
		push rsi		

		mov rdi, r11 ; format specifier
		
		cmp r10, 1
		je fstArg
		cmp r10, 2
		je sndArg
		cmp r10, 3
		je thrArg
		cmp r10, 4
		je frtArg
		cmp r10, 5
		je fifArg
		jmp stackArg

		fstArg:
			jmp argEnd
		sndArg:
			mov rsi, rdx
			jmp argEnd
		thrArg:
			mov rsi, rcx
			jmp argEnd
		frtArg:
			mov rsi, r8
			jmp argEnd
		fifArg:
			mov rsi, r9
			jmp argEnd
		stackArg:
			; TODO code here for getting arguments from the stack

		argEnd:
		call printFormat
		
		inc r10
		pop rsi					; pop saved registers
		pop rdi
		pop rcx
		pop rdx

	nonHandle:
	inc rdi
	jmp startLp

	end:
	ret

; REDEFINING, rdi hold format specifier, rsi hold argument
printFormat:
	;inc rdi
	cmp rdi, 'd'
	je decimalIntegerPrint

	; this should only be run in the case of an unrecognised format tag, prints [FORMAT ERROR] to stdout	
	mov rdi, formatError
	call basically_printf
	ret

	decimalIntegerPrint:	
		mov rdi, rsi
		call print_i64
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




	
