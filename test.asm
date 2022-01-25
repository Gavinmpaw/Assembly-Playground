section .data
	fmt db "%d",10,0	

section .bss

section .text
	extern printf
	global main

	main:

		mov ecx, 0x00
		loopStart:	
			push ecx
			call printreg
			pop ecx
			
			add ecx, 0x01
			cmp ecx, 0x0A
			jle loopStart


	   	; exiting program
		mov eax, 1          ; exit program
		mov ebx, 0          ; return 0
		int 0x80            ; syscall

	printreg:
		push ecx
		push fmt
		call printf
		add esp, 8
		ret
	

