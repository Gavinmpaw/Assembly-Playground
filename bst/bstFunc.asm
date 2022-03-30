%include "../basically_stdio.asm"

%define NODE_SZ 20
%define VAL_OFF 0
%define LFT_OFF 4
%define RGT_OFF 12

section .text

global _start

_start:

	push 0

	call create_node
	lea rdi, [rax + VAL_OFF]
	mov DWORD [rdi], 5
	mov rdi, rsp	; insert can potentially change the value of the "pointer" to the root node, so needs the address of the "pointer" itself
	mov rsi, rax
	call insert_node
	
	call create_node
	lea rdi, [rax + VAL_OFF]
	mov DWORD [rdi], 10
	mov rdi, rsp
	mov rsi, rax
	call insert_node

	call create_node
	lea rdi, [rax + VAL_OFF]
	mov DWORD [rdi], 7
	mov rdi, rsp
	mov rsi, rax
	call insert_node

	mov rax, 0
	mov rdi, [rsp]	; finding only ever needs the "pointer" itself, so passing it as [rsp] is fine
	mov rsi, 7
	call find_node

	cmp rax, 0
	je skip

	xor rdi,rdi
	mov edi, [rax + VAL_OFF]
	call print_i64

	skip:

	mov rax, 60
	mov rdi, 0
	syscall

; node* create_node()
; creates a new node with all values set to 0 or NULL
; returns the memory address of the new node
create_node:

	; mmap(NULL, size, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 0, 0)
	mov rax, 9 			; call number
	mov rdi, 0  		; target starting address (0 to allow kernel to choose)
	mov rsi, NODE_SZ	; size in bytes 
	mov rdx, 3			; PROT_READ | PROT_WRITE		
	mov r10, 34			; MAP_PRIVATE | MAP_ANONYMOUS
	mov r8, 0			; fd
	mov r9, 0			; off
	syscall

	; syscall will already put pointer in rax, so just initializes values then returns
	mov	DWORD [rax + VAL_OFF], 0 ;	newnode.val   = 0;
	mov DWORD [rax + LFT_OFF], 0 ; 	newnode.left  = NULL;
	mov DWORD [rax + RGT_OFF], 0 ;  newnode.right = NULL;

	ret

; void insert_node(node* root, node* new)
; should take in a node and the root of the target tree and apropriately insert the node
; if the given value is already present, should exit and not insert anything
; returns nothing
insert_node:
	push rbp
	mov rbp, rsp

	; root should be passed as argument, and already in rdi
	; new node should be in rsi

	cmp QWORD [rdi], 0
	jne insert_node_start_insert
	mov [rdi], rsi
	jmp insert_node_end

	insert_node_start_insert:
		mov rdi, [rdi]

	insert_node_insert_loop:
		mov eax, DWORD [rdi + VAL_OFF]
		cmp eax, DWORD [rsi + VAL_OFF]
		je insert_node_end
		jg insert_node_leftMove
		jl insert_node_rightMove

		insert_node_leftMove:
			cmp QWORD [rdi + LFT_OFF], 0
			je insert_node_insert_left
			mov rdi, QWORD [rdi + LFT_OFF]
			jmp insert_node_insert_loop
			
		insert_node_rightMove:	
			cmp QWORD [rdi + LFT_OFF], 0
			je insert_node_insert_right
			mov rdi, QWORD [rdi + RGT_OFF]
			jmp insert_node_insert_loop

	insert_node_insert_left:
		mov QWORD [rdi + LFT_OFF], rsi
		jmp insert_node_end
	insert_node_insert_right:
		mov QWORD [rdi + RGT_OFF], rsi
	insert_node_end:

	mov rsp, rbp
	pop rbp
	ret

; node* find_node(node* root, int val)
; should take the root of the target tree, and the value to find
; if the value is found returns a pointer to that node, otherwise returns 0 (NULL)
find_node:
	push rbp
	mov rbp, rsp

	; root should be passed as argument, and already in rdi
	; value to find should be in rsi

	cmp QWORD [rdi], 0
	je insert_node_end

	find_node_locate_loop:
		cmp rdi, 0
		je find_node_end

		mov eax, DWORD [rdi + VAL_OFF]
		cmp eax, esi
		je find_node_end
		jg find_node_leftMove
		jl find_node_rightMove

		find_node_leftMove:
			mov rdi, QWORD [rdi + LFT_OFF]
			jmp find_node_locate_loop
			
		find_node_rightMove:	
			mov rdi, QWORD [rdi + RGT_OFF]
			jmp find_node_locate_loop

	find_node_end:
		mov rax, rdi

	mov rsp, rbp
	pop rbp
	ret
