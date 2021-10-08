/*
 * Assembly language implementation of the main function
 * for the asm_textsearch_fns program
 */
	.section .rodata
errorMsgNumArgs: .string "Error: invalid number of command line arguments\n"
errorMsgFile: .string "Error: unable to open file\n"
readFile: .string "r"
occurrencesFmt: .string "%d occurrence(s)\n"

	.section .text

	.globl main
main:
	pushq %rbp
	subq $8, %rsp
	pushq %r12			/* r12 == argc */
	pushq %r13			/* r13 == num_occurrences for -c command line option */
	pushq %r14			/* r14 == string to be searched for */
	movq %rsp, %rbp
	movq %rdi, %r12
	cmpq $3, %rdi			/* rdi == argc: check if the proper number of args were passed */
	je .LvalidateFile		/* if so, check that the file passed was valid */
	cmpq $4, %rdi
	je .LvalidateFile
	movq stderr(%rip), %rdi		/* if argc is neither 3 nor 4, print error */
	movq $errorMsgNumArgs, %rsi
	call fprintf
	jmp .LreturnError

.LvalidateFile:
	decq %r12
        movq (%rsi, %r12, 8) , %rdi	/* retrieve the last command line arg (the supposed file) */
        decq %r12			
	movq (%rsi, %r12, 8), %r14	/* retireve the second to last arg (the searched for string) */
	movq $readFile, %rsi
        call fopen
        cmpq $0, %rax			/* check that fopen was successful */
        jle .LerrorFile
	movq %r12, %r10			/* r10 == argc - 2, used temporaily to check if -c option was selected*/
	movq %rax, %r12			/* r12 now stores file pointer */	
	subq $512, %rsp			/* make room on stack for 512 char buffer to write lines of text to*/
	cmpq $2, %r10			
	je .LprintOccurrences	
	
.LprintLines:
	movq %r12, %rdi			/* restore FILE* and buffer values */ 
	movq %rsp, %rsi			
	call read_line
	cmpb $0, %al			/* has EOF been reached ? */
	je .LreturnAndCloseFile
	movq %rsp, %rdi			/* buffer is first param for count_occurrences call */
	movq %r14, %rsi			/* desired string is second param */
	call count_occurrences
	cmpb $0, %al			/* where any occurences found? */
	jle .LprintLines
	movq %rsp, %rdi			/* if so, print the line (buffer) */
	call print_line	
	jmp .LprintLines

.LprintOccurrences:
	movq $0, %r13			/* num_occurrences counter variable */
.LcalculateOccurrences:
	movq %r12, %rdi			
	movq %rsp, %rsi
	call read_line
	cmpb $0, %al			
	je .LprintData			/* print total occurrences only once EOF is reached */
	movq %rsp, %rdi
	movq %r14, %rsi			/* buffer is first param, desired string is second: */
	call count_occurrences
	addq %rax, %r13			/* add result of count_occurrences to total */ 
	jmp .LcalculateOccurrences

.LprintData:
	movq $occurrencesFmt, %rdi
	movq %r13, %rsi
	call printf	
	jmp .LreturnAndCloseFile

.LerrorFile:
	movq stderr(%rip), %rdi
	movq $errorMsgFile, %rsi
	call fprintf

.LreturnError:
	movl $1, %eax			/* 1 return value indicates unsuccessful execution */
	popq %r14
	popq %r13
	popq %r12
	addq $8, %rsp
	popq %rbp
	ret

.LreturnAndCloseFile:
	movq %r12, %rdi
	call fclose			
        movl $0, %eax
	addq $512, %rsp			/* realign stack pointer by first getting rid of the buffer */
	popq %r14
        popq %r13
        popq %r12
	addq $8, %rsp
	popq %rbp
	ret
