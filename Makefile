HelloWorld:
	nasm -f elf64 hello_world.asm
	ld -s -o hello_world hello_world.o
	rm hello_world.o

box:
	nasm -f elf64 box.asm
	ld -s -o box box.o
	rm box.o

dynbox:
	nasm -f elf64 dynamicBox.asm
	ld -s -o dynamicBox dynamicBox.o
	rm dynamicBox.o

numInput:
	nasm -f elf64 numberInput.asm
	ld -s -o numInput numberInput.o
	rm numberInput.o
