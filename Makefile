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

multiDigitNumberConversionFromString:
	nasm -f elf64 mdNumConvert.asm
	ld -s -o mdNumConvert mdNumConvert.o
	rm mdNumConvert.o

multiDigitNumberToString: mdTs.asm
	nasm -f elf64 mdTs.asm
	ld -s -o mdTs mdTs.o
	rm mdTs.o
	
basically_stdio: basically_stdio.asm
	nasm -f elf64 basically_stdio.asm
	ld -s -o basically_stdio basically_stdio.o
	rm basically_stdio.o
