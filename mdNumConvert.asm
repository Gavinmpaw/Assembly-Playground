section .data
	toConvert db "20",0
	character db "#"
	convertLength dq 0
	
section .bss
	convertedNum: resb 4	

section .text

global _start

_start:
		mov rsi, toConvert

		; count number of characters that need converting
		; length (in characters) will be stored in convertLength after section
		lengthCountingLoop:
			add rsi, 1
			add dword [convertLength], 1

			mov al, byte[rsi]
			cmp al, 0
			jne lengthCountingLoop

		mov r11, 0 ; sum storage
		mov r12, 1


		; from the least significant digit to the most moves over the number
		; converting and summing the value, after this point we should have the number
		; stored in convertedNum
		mov r10, [convertLength]
		summingLoop:
			mov rsi, toConvert
			add rsi, r10
			sub rsi, 1
			
			movzx rsi, byte [rsi]
			sub rsi, 48
			imul rsi, r12

			add r11, rsi
			imul r12, 10			

			dec r10
			cmp r10, 0
			jg summingLoop

		; prints a character specified in character a number of times equal to the number
		printingLoop:

			push r11

			mov rax, 1
			mov rdi, 1
			mov rsi, character
			mov rdx, 1
			syscall

			pop r11
			
			dec r11
			cmp r11, 0
			jg printingLoop

		mov rax, 60
		mov rdi, 0
		syscall
			
			
