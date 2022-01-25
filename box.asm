segment .data
	newlineChar db 10,0
	spaceChar db 32

	maximumX dq 0x05
	maximumY dq 0x05

	TestBox:	
			db '#','#','#','#','#',
			db '#','*','*','*','#',
			db '#','*','*','*','#', 
			db '#','*','*','*','#', 
			db '#','#','#','#','#'

segment .text

global _start
	
_start:
	
	mov rax, 0x00

	outerLoop:
		mov rbx, 0x00
		innerLoop:
			; calculating overall offset
			mov rcx, rax
			imul rcx, 0x05
			add rcx, rbx
			
			; calculating target character address based on offset
			mov rdx, TestBox
			add rdx, rcx

			; push loop counters to the stack so they dont get reset
			push rax
			push rbx

			; print the target character
			push rdx
			call printChar
			add rsp, 8

			; print a space for padding to make the box look nice
			push spaceChar
			call printChar
			add rsp, 8

			; popping loop counters back off the stack
			pop rbx
			pop rax

			add rbx, 1
			cmp rbx, [maximumX]
			jl innerLoop

		push rax
		
		push newlineChar
		call printChar
		add rsp, 8

		pop rax		

		add rax,1
		cmp rax, [maximumY]
		jl outerLoop
			
	call exit

printChar:
	mov	eax, 4 		; print
	mov	ebx, 1 		; to stdout
	mov rcx, qword [rsp + 8]
	mov	edx, 1
	int	0x80 		; syscall	
	ret


exit:
	mov eax, 1
	mov ebx, 0
	int 0x80
