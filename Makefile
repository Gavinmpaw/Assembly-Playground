HelloWorld:
	nasm -f elf64 hello_world.asm
	ld -s -o hello_world hello_world.o
	rm hello_world.o

TutPointKeebEx:
	nasm -f elf64 tutPointExampleReadFromKeyboardAndDisplay.asm
	ld -s -o tutExample tutPointExampleReadFromKeyboardAndDisplay.o
	rm tutPointExampleReadFromKeyboardAndDisplay.o

test:
	nasm -f elf32 test.asm
	gcc -no-pie -m32 test.o -o test
	rm test.o

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
	./numInput
	rm numInput
