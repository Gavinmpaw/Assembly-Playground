section .data
	prompt db "Enter a number",10
	newLine db 10

section .bss
	integerSpace: resb 4
	characterSpace resb 1

section .text

global _start

_start:
	
	mov rax, 0				; sys_read
	mov rdi, 0				; stdin
	mov rsi, characterSpace	; address of buffer
	mov rdx, 1				; 1 byte (1 ascii char)
	syscall 

	; integer conversion from character to actual number value, works only for single digit numbers 0-9
	movzx esi, byte [characterSpace] ; zero extended move the byte from the buffer into a 32 bit register (esi)
	sub esi, 48						 ; subtract 48 (ascii 0) from the value in the buffer
	mov [integerSpace], esi			 ; store the newly converted int in the 4 byte integerSpace defined in bss

	; for testing reasons print the previously read in character a number of times equal to its value as determined by the above conversion
	mov esi, 0x00
	loopStart:
			push rsi ; just as a precaution, pushing the counter (esi is a subset of rsi, so pushing the whole thing effectively saves both)
			
			mov rax, 1				; sys_write
			mov rdi, 1				; stdout
			mov rsi, characterSpace	; address of buffer
			mov rdx, 1				; 1 byte (1 ascii char)
			syscall	

			pop rsi	

			add esi, 1	

			cmp esi, [integerSpace]
			jl loopStart

	; printing newLine to end program more nicely
	mov rax, 1
	mov rdi, 1
	mov rsi, newLine
	mov rdx, 1
	syscall

	mov rax, 60				; sys_exit
	mov rdi, 0				; exit code 0
	syscall 
	
