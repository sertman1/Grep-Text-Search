/*`
 * Assembly language implementations of functions declared in
 * textsearch_fns.h
 */

	.section .text




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

	subq $8, %rsp	
	pushq %r11
	pushq %r14
	pushq %r15

	movq $0, %r11
	movq %rdi, %r14
	movq %rsi, %r15

.LcountOccurences:
	cmpb $0, (%r14)
	jle .LdoneCounting

	call starts_with
	cmpl $1, %eax
	jl .LadvanceToNext
	incq %r11

.LadvanceToNext:
	incq %r14				/* advance to next char */
	movq %r14, %rdi
	movq %r15, %rsi
	jmp .LcountOccurences

.LdoneCounting:
	movq %r11, %rax

	addq $8, %rsp
	popq %r10
	popq %r15
	popq %r14
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
	movl $1, %eax 			/* assume true at first */
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
