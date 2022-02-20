
segment .data

	myMessage	db	"Hello world",10,0

segment .text

global _start
	
_start:

	; printing the string defined in data
	mov	rax, 1 		; print
	mov	rdi, 1 		; to stdout
	mov	rsi, myMessage  ; this data
	mov	rdx, 12 	; length 12
	syscall 

	mov	rax, 60 	; exit program
	mov	rdi, 0 		; return 0
	syscall  

