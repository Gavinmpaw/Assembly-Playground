segment .data
	newlineChar db 10
	spaceChar db 32
	borderChar db '#'
	fillChar db '*'

	maximumX dq 0xFF
	maximumY dq 0xFF

segment .bss
	;boxSpace: resb 100
	boxSpace: resb 8
	
segment .text

global _start
	
_start:

	call allocateBox
	
	call fillBox
	
	call printBox
				
	call exit

allocateBox:

	; calculating maximumX * maximumY, or the ammount of space needed for the box
	mov rbx, [maximumX]
	imul rbx, [maximumY]

	mov rax, 9 		; call number
	mov rdi, 0  	; target starting address (0 to allow kernel to choose)
	mov rsi, rbx	; size in bytes 
	mov rdx, 3		
	mov r10, 34
	mov r8, 0
	mov r9, 0		; last arg
	syscall

	mov [boxSpace], rax

	ret

printChar:
	mov rax, 1 				; call number
	mov rdi, 1				; stdout
	mov rsi, qword [rsp + 8]; address to print (previously pushed to stack)
	mov rdx, 1				; number of bytes to print
	syscall
	ret

printBox:
	mov r8, [boxSpace]

	mov rax, 0x00

	printBoxLoopOuter:
		mov rbx, 0x00
		printBoxLoopInner:
			; calculating overall offset
			mov rcx, rax
			imul rcx, [maximumX]
			add rcx, rbx
			
			; calculating target character address based on offset
			mov rdx, r8
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
			jl printBoxLoopInner

		push rax
		
		push newlineChar
		call printChar
		add rsp, 8

		pop rax		

		add rax,1
		cmp rax, [maximumY]
		jl printBoxLoopOuter

	ret

fillBox:
	mov r8, [boxSpace]

	mov rax, 0x00

	fillBoxLoopOuter:
		mov rbx, 0x00
		fillBoxLoopInner:
			; calculating overall offset
			mov rcx, rax
			imul rcx, [maximumX]
			add rcx, rbx
			
			; calculating target character address based on offset
			mov rdx, r8
			add rdx, rcx
			
			; top and bottom borders		
			cmp rax, 0x00
			je placeBorder
								
			mov rcx, [maximumY] ; moving maxY into rcx and decrimenting it to imitate rax == (maxY - 1)	
			dec rcx			
			cmp rax, rcx
			je placeBorder

			; side borders
			cmp rbx, 0x00
			je placeBorder

			mov rcx, [maximumX]
			dec rcx
			cmp rbx, rcx
			je placeBorder
			

			placeFill:
				mov cl, [fillChar]
				mov byte [rdx], cl
				jmp endPlaceChar
	
			placeBorder:
				mov cl, [borderChar]
				mov byte [rdx], cl
				jmp endPlaceChar

			endPlaceChar:

			add rbx, 1
			cmp rbx, [maximumX]
			jl fillBoxLoopInner		

		add rax,1
		cmp rax, [maximumY]
		jl fillBoxLoopOuter
	
	ret

exit:
	mov eax, 1
	mov ebx, 0
	int 0x80
