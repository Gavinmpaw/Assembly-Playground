# Assembly-Playground
A repo for random assembly stuff I write

uses linux x86_64 system calls

<h3>hello_world.asm</h3>
  - mostly self describing... prints "Hello world"
 
<h3>testing/box.asm</h3>
  - prints a small box to the screen (done as an early step in learning looping)

<h3>testing/dynamicBox.asm</h3>
  - also prints a small box, but with some adjustments
    - now uses mmap syscall to create space in memory
    - then constructs the box in this memory space based on x and y values defined in the data section
    - prints the box from memory  
  - done to learn how memory allocation works in assembly
  - never actually bothers to de-allocate the memory

<h3>testing/numberInput.asm</h3>
  - reads a single digit from stdin, then prints it out a number of times equal to the digits value
  - precursor to the more complex number conversion file tests
  - also done to play around with stdin a bit

<h3>testing/multiDigitIntegerFromString.asm</h3>
  - converts a string defined in the data section into an integer value then prints the character # a number of times equal to the value of the integer
  
<h3>testing/multiDigitIntegerToString.asm</h3>
  - the reverse of the above, converts a 64 bit integer into a string and prints it
  - does not however use the data section... as I was also using it to experiment with using the stack for temporary variable storage

<h3>basically_stdio.asm</h3>
  - IO subroutines meant to allow easy io without using the C standard libraries
  
<p></p>
