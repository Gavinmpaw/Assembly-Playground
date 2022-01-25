section .data
	userMsg db "Please enter a number: "
	lenUserMsg equ $-userMsg
	dispMsg db "You have entered: "
	lenDispMsg equ $-dispMsg

section .bss		; Uninitialized Data Segment
	num resb 5

section .text
	global _start

_start:
	mov eax, 4 			; sys_write (putting 4 in eax makes the following syscall be a write)
	mov ebx, 1			; file descriptor for sys_write, in this case stdout
	mov ecx, userMsg
	mov edx, lenUserMsg
	int 80h				; print userMsg from data section

	mov eax, 3			; sys_read (putting 3 in eax makes the following syscall be a read)
	mov ebx, 2			; assuming this is stdin
	mov ecx, num		; previously uninitialized data segment
	mov edx, 5			; read in 5 bytes
	int 80h				; read and store user input

	mov eax, 4
	mov ebx, 1
	mov ecx, dispMsg
	mov edx, lenDispMsg
	int 80h				; output dispMsg from data section

	mov eax, 4
	mov ebx, 1
	mov ecx, num
	mov edx, 5
	int 80h				; outputs previous user input

	mov eax, 1
	mov ebx, 0
	int 80h
