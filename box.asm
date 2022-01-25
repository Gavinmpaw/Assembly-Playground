segment .data
	borderChar db '#'
	centerChar db '*'
	newlineChar db 10,0
	MaximumX db 0x05
	MaximumY db 0x05

	TestBox db '#','#','#','#','#',
			db '#','*','*','*','#',
			db '#','*','*','*','#', 
			db '#','*','*','*','#', 
			db '#','#','#','#','#'

segment .bss
    storage resb 25

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

			; printing (saving both counters and recovering them after)
			push rax
			push rbx

			push rdx
			call printChar
			add rsp, 8

			pop rbx
			pop rax

			add rbx, 1
			cmp rbx, 0x05
			jl innerLoop

		push rax
		
		push newlineChar
		call printChar
		add rsp, 8

		pop rax		

		add rax,1
		cmp rax, 0x05
		jl outerLoop
			
	;call printChar
	;add rsp, 8


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
