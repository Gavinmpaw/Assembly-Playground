segment .bss
    storage resb 1

segment .text

global _start
	
_start:
	mov [storage], byte 'a'

	push storage

	call printChar
	add rsp, 8


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
