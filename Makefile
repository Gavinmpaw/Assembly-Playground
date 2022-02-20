HelloWorld:
	nasm -f elf64 hello_world.asm
	ld -s -o hello_world hello_world.o
	rm hello_world.o

box: testing/box.asm
	nasm -f elf64 testing/box.asm
	ld -s -o box testing/box.o
	rm testing/box.o

dynbox: testing/dynamicBox.asm
	nasm -f elf64 testing/dynamicBox.asm
	ld -s -o dynamicBox testing/dynamicBox.o
	rm testing/dynamicBox.o

numInput: testing/numberInput.asm
	nasm -f elf64 testing/numberInput.asm
	ld -s -o numInput testing/numberInput.o
	rm testing/numberInput.o

multiDigitIntFromString: testing/multiDigitIntegerFromString.asm
	nasm -f elf64 testing/multiDigitIntegerFromString.asm
	ld -s -o mdIntFs testing/multiDigitIntegerFromString.o
	rm testing/multiDigitIntegerFromString.o

multiDigitIntToString: testing/multiDigitIntegerToString.asm
	nasm -f elf64 testing/multiDigitIntegerToString.asm
	ld -s -o mdIntTs testing/multiDigitIntegerToString.o
	rm testing/multiDigitIntegerToString.o
	
arbitraryUserInput:	testing/userInput.asm
	nasm -f elf64 testing/userInput.asm
	ld -s -o userInput testing/userInput.o
	rm testing/userInput.o

basically_stdio: basically_stdio.asm
	nasm -f elf64 basically_stdio.asm
	ld -s -o basically_stdio basically_stdio.o
	rm basically_stdio.o
