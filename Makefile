NAME=hw_easy

all: hw_easy

clean:
	rm -rf hw_easy hw_easy.o

hw_easy: hw_easy.asm
	nasm -f elf -F dwarf -g hw_easy.asm
	gcc -no-pie -g -m32 -o hw_easy hw_easy.o
