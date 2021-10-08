/* Assembly language implementations of functions declared in
 * textsearch_fns.h
 */
	.section .rodata

newLine: .string "\n"  
charFormat: .string "%c"
	
	.section .text

/* read_line - reads a line of text (up to 511 chars) from the specified 
 * file and writes it into the specified buffer
 *
 * Parameters:
 *    in - pointer to the file struct whose lines of text will be read from
 *    buf - the buffer of up to 511 chars which will store one line of text from in 
 */

	.globl read_line
read_line:
	pushq %rbx		/* rbx will mirror the buffer */
	pushq %r13		/* r13 holds the FILE* */
	pushq %r14		/* r14 used as a counter for lines > 511 chars */

	movq %rdi, %r13		/* r13 = in */
	movq %rsi, %rbx		/* rbx = buf */
	movq $0, %r14		/* counter = 0 */
	call fgetc
	cmpb $0, %al		/* were we unable to retrieve a single char? */
	jle .LerrorFile		/* if so, return 0 to indicate failure */
	cmpb $10, %al		/* otherwise, retrieve chars until newline is reached */
	je .LdoneReading

.LreadNextChar:
	cmpq $511, %r14		/* have we reached the maxmium number of chars per line? */
	jae .LdoneReading
	movb %al, (%rbx)	/* add result of fgetc to buffer */
	movq %r13, %rdi
	call fgetc
	incq %rbx		/* shift buffer to its next index */
	cmpb $0, %al		/* check for EOF */
        jle .LdoneReading
        cmpb $10, %al		/* check for NL */
        je .LdoneReading
	incq %r14		/* counter ++ */
	jmp .LreadNextChar
	
.LdoneReading:
	movq $0, (%rbx) 	/* add null terminator to complete 'building' of buffer */
	cmpq $511, %r14		/* did the line have more chars than could be stored? */ 
	jae .LremoveExcess	/* if so, force FILE* to point to next line of text for future read_line calls */
	jmp .LsuccessfulFile

.LremoveExcess:
	cmpb $10, %al
	je .LsuccessfulFile
	movq %r13, %rdi		
	call fgetc		/* call fgetc until EOF or newline has been reached */
	cmpb $0, %al
	jle .LsuccessfulFile
	jmp .LremoveExcess
	
.LerrorFile:
	popq %r14
	popq %r13
	popq %rbx
	movq $0, %rax		/* 0 return value indicates error file */
	ret
.LsuccessfulFile:
	popq %r14
	popq %r13
	popq %rbx
	movq $1, %rax
	ret	

/* print_line - prints the specified line of text (up to 511 chars) 
 * to the console
 *
 * Parameters:
 *    buf - the line of text to be printed to the console
 */

	.globl print_line
print_line:
	pushq %r13		/* r13 will mirror the bufer string of text */
	movq %rdi, %r13		/* r13 = buf */

.LnextChar:
	cmpb $0, (%rdi)		/* have we reached the end of the string ? */
	jle .LdonePrinting
	movq (%rdi), %rsi	/* if not, print current char buf points to to console */
	movq $charFormat, %rdi
	call printf
	incq %r13		/* increment buf to point to next char */
	movq %r13, %rdi
	jmp .LnextChar

.LdonePrinting:
	movq $newLine, %rdi
	call printf
	movq %r13, %rdi
	popq %r13
	ret

/*
 * count_occurrences - determines how often the second specified 
 * string appears in the first specified one.
 *
 * Parameters:
 *   line - pointer to beginning of the string to parse for occurences
 *   str - pointer to string whose number of occurences in line will be returned
 */


	.globl count_occurrences
count_occurrences:
	pushq %r13		/* counter variable to be returned */
	pushq %r14		/* alias for line parameter */
	pushq %r15		/* alias for str */

	movq $0, %r13	 	/* counter = 0 */
	movq %rdi, %r14
	movq %rsi, %r15

.LcountOccurences:
	cmpb $0, (%r14)		/* has the null terminator of the line been reached yet? */
	jle .LdoneCounting
	call starts_with
	cmpl $1, %eax		/* does the current char line point to begin with str? */
	jl .LadvanceToNext	/* if not, check succeeding chars */
	incq %r13		/* if so, occurrence found, counter++ */

.LadvanceToNext:
	incq %r14		/* advance to next char */
	movq %r14, %rdi
	movq %r15, %rsi
	jmp .LcountOccurences

.LdoneCounting:
	movq %r13, %rax
	popq %r15
	popq %r14
	popq %r13
	ret


/*
 * find_string_length - computes the number of non-null characters
 * in the specified string and returns this value.
 *
 * Parameters:
 *   s - pointer to beginning of the string to parse
 */

	.globl find_string_length
find_string_length:
	subq $8, %rsp 		
	movl $0, %eax 		/* length = 0 at start */

.LcheckNullTerm:
	cmpb $0, (%rdi)		/* NUL terminator reached? */
	je .LdoneWithLoop	/* if so, immediatley return */
	addl $1, %eax 		/* if not, add 1 to (length) return value */
	incq %rdi  		/* advance to next character */
	jmp .LcheckNullTerm 	/* continue loop */

.LdoneWithLoop:
	addq $8, %rsp 		
	ret

/*
 * starts_with - determines if the first specified string
 * beings with the exact characters of the other specified string
 *
 * Parameters:
 *   s - pointer to string to be checked
 * 	 pfx - pointer to string which contains the prefix to be searched for in s
 */

	.globl starts_with
starts_with:
	subq $8, %rsp
	movl $1, %eax			/* assume true at first */
					/* check for deniability in loops: */
.LcompareCharacters:
	movb (%rsi), %r10b		/* store 1 char into 'temp' %r10 space for comparison */
	cmpb %r10b, (%rdi)		/* compare the string to the prefix char by char */
	je .LcheckPrefixNullTerm	/* if the chars match, check if next char in pfx is null */
	movl $0, %eax			/* if not equal, return false (0) */
	jmp .LdoneWithComparison

.LcheckPrefixNullTerm:
	incq %rdi			/* advance s and pfx to their next char */
	incq %rsi
	cmpb $0, (%rsi)			/* is pfx null? */
	je .LdoneWithComparison		/* if so, it matched the start of s verbatim. Return $1 (true) */
	jmp .LcompareCharacters		/* otherwise, continue checking for instance where thier chars dont equal */

.LdoneWithComparison:
	addq $8, %rsp
	ret
