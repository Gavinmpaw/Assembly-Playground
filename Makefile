HelloWorld:
	nasm -f elf64 hello_world.asm
	ld -s -o hello_world hello_world.o
	rm hello_world.o
