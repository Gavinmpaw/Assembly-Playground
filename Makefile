HelloWorld:
	nasm -f elf64 hello_world.asm
	ld -s -o hello_world hello_world.o
	rm hello_world.o

TutPointKeebEx:
	nasm -f elf64 tutPointExampleReadFromKeyboardAndDisplay.asm
	ld -s -o tutExample tutPointExampleReadFromKeyboardAndDisplay.o
	rm tutPointExampleReadFromKeyboardAndDisplay.o

Test:
	nasm -f elf32 test.asm
	gcc -no-pie -m32 test.o -o test
	rm test.o


