segment .data
	newlineChar db 10
	spaceChar db 32
	borderChar db '#'
	fillChar db '*'

	maximumX dq 0x05
	maximumY dq 0x05

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

	mov rax, 12
	xor rbx, rbx
	int 0x80

	; calculating maximumX * maximumY, or the ammount of space needed for the box
	mov rbx, [maximumX]
	imul rbx, [maximumY]

	mov [boxSpace], rax
	add rax, rbx

	mov rbx, rax
	mov rax, 12
	int 0x80

	ret

printChar:
	mov	eax, 4 		; print
	mov	ebx, 1 		; to stdout
	mov rcx, qword [rsp + 8]
	mov	edx, 1
	int	0x80 		; syscall	
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
