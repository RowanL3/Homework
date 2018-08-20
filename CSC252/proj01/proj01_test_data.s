# Print the Hello World phrase.
# Here we load the base address of the string
# into register $a0, and use the print_string
# syscall to print the phrase.
.data
hello:  .asciiz "Hello World\n"