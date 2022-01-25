
segment .data

	myMessage	db	"Hello world",10,0

segment .text

global _start
	
_start:

	; printing the string defined in data
	mov	eax, 4 		; print
	mov	ebx, 1 		; to stdout
	mov	ecx, myMessage  ; this data
	mov	edx, 12 	; length 12
	int	0x80 		; syscall

	; exiting program
	mov	eax, 1 		; exit program
	mov	ebx, 0 		; return 0
	int	0x80   		; syscall	

