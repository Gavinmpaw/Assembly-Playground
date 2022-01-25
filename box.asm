segment .bss
    storage resb 1

segment .text

global _start
	
_start:
	mov [storage], byte 'a'

	push storage

	mov	eax, 4 		; print
	mov	ebx, 1 		; to stdout
	pop rcx
	mov	edx, 1
	int	0x80 		; syscall	

	;call printChar

	call exit

printChar:
	mov	eax, 4 		; print
	mov	ebx, 1 		; to stdout
	pop rcx
	mov	edx, 1
	int	0x80 		; syscall	


exit:
	mov eax, 1
	mov ebx, 0
	int 0x80
