# Assembly-Playground
A repo for random assembly stuff I write

uses linux x86_64 system calls

<hr>

<h3>hello_world.asm</h3>
  <li> mostly self describing... prints "Hello world" </li>
 
<h3>testing/box.asm</h3>
  <li>prints a small box to the screen (done as an early step in learning looping</li>

<h3>testing/dynamicBox.asm</h3>
<ul>
<li>also prints a small box, but with some adjustments<ul>
      <li>now uses mmap syscall to create space in memory</li>
      <li>then constructs the box in this memory space based on x and y values defined in the data section</li>
      <li>prints the box from memory</li>
    </ul>
  </ul></li>
<li>done to learn how memory allocation works in assembly</li>
<li>never actually bothers to de-allocate the memory</li>
</ul>

<h3>testing/numberInput.asm</h3>
<ul>
  <li>reads a single digit from stdin, then prints it out a number of times equal to the digits value</li>
  <li>precursor to the more complex number conversion file tests</li>
  <li>also done to play around with stdin a bit</li>
</ul>

<h3>testing/multiDigitIntegerFromString.asm</h3>
  <li>converts a string defined in the data section into an integer value then prints the character # a number of times equal to the value of the integer</li>
  
<h3>testing/multiDigitIntegerToString.asm</h3>
<ul>
  <li>the reverse of the above, converts a 64 bit integer into a string and prints it</li>
  <li>does not however use the data section... as I was also using it to experiment with using the stack for temporary variable storage</li>
</ul>

<h3>testing/userInput.asm</h3>
<ul>
  <li>contains two subroutines that read user input into a buffer provided by the caller</li>
  <li>read_string - reads characters until either a maximum length, or a newline. whichever comes first</li>
  <li>read_line - reads characters to the end of the line, discards anything beyond the buffer length</li>
  <li> Both will 0 terminate the string in the buffer </li>
</ul>
 
<h3>basically_stdio.asm</h3>
  <li>IO subroutines meant to allow easy IO without using the C standard libraries</li>
  <ul>
  	<li><h5>basically_printf<h5>
		<p> 	Expects arguments in rdi, rsi, rdx, rcx, r8, r9 and any further on the stack
			,currently supports %d for integers, %s for strings, and %n for newline</p>
	</li>
  </ul>
  
<p></p>
