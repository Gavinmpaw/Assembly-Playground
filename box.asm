segment .bss
    storage resb 1

segment .text

global _start
	
_start:
	mov [storage], byte 'a'

	call printChar
	call exit

printChar:
	mov	eax, 4 		; print
	mov	ebx, 1 		; to stdout
	mov ecx, storage
	mov	edx, 1
	int	0x80 		; syscall	


exit:
	mov eax, 1
	mov ebx, 0
	int 0x80
