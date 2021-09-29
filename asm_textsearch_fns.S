/*
 * Assembly language implementations of functions declared in
 * textsearch_fns.h
 */

	.section .text


	.globl read_line
read_line:
	/* TODO: implementation of read_line function */

	ret

/*
 * count_occurrences - 
 *
 * Parameters:
 *   line - pointer to beginning of the string to parse
 * 	 str - pointer to string whose # of occurences in 'line' will be returned
 */

	.globl count_occurrences
count_occurrences:

	subq $8, %rsp 					/* align stack pointer to multiple of 16 */
	movq $0, %rax					/* occurences = 0 at the start */
	movq $0, %r9

.LcompareChars:
	movb (%rsi,%r9,1), %r10b			/* store 1 char into 'temp' %r10 space for comparison */
	cmpb %r10b, (%rdi)				/* compare the string to the prefix char by char */
	je .LcheckStrNullTerm			/* if the chars match, check if next char in pfx is null */
	jmp .LnextCharInLine

.LcheckStrNullTerm:
	add $1, %r9
	cmpb $0, (%rsi,%r9,1)					/* is prefix term null? */
	je .LoccurenceFound				/* if so, it matched the start of string verbatim. Return $1 */
	jmp .LcompareChars

.LoccurenceFound:
	movq $0, %r9
	addq $1, %rax
	jmp .LnextCharInLine

.LnextCharInLine:
	incq %rdi
	cmpb $0, (%rdi)					/* has end of line been reached yet? */
	je .LdoneWithCountOccurences	/* if so, immmediatley end loop and return */
	jmp .LcompareChars				/* otherwise, keep on searching for occurences */

.LdoneWithCountOccurences:
	addq $8, %rsp 					/* realign stack pointer */
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

	subq $8, %rsp 		/* align stack pointer to multiple of 16 */
	movq $0, %rax 		/* length = 0 at start */

.LcheckNullTerm:
	cmpb $0, (%rdi)		/* NUL terminator reached? */
	je .LdoneWithLoop	/* if so, immediatley return */
	addq $1, %rax 		/* if not, add 1 to (length) return value */
	incq %rdi  			/* advance to next character */
	jmp .LcheckNullTerm /* continue loop */

.LdoneWithLoop:
	addq $8, %rsp 		/* realign stack pointer */
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

	subq $8, %rsp 				/* align stack pointer to multiple of 16 */
	movq $1, %rax 				/* assume true at first */
								/* check for deniability in loops: */
.LcompareCharacters:
	movb (%rsi), %r10b			/* store 1 char into 'temp' %r10 space for comparison */
	cmpb %r10b, (%rdi)			/* compare the string to the prefix char by char */
	je .LcheckPrefixNullTerm	/* if the chars match, check if next char in pfx is null */
	movq $0, %rax				/* if not equal, return false (0) */
	jmp .LdoneWithComparison

.LcheckPrefixNullTerm:
	incq %rdi
	incq %rsi
	cmpb $0, (%rsi)				/* is prefix term null? */
	je .LdoneWithComparison		/* if so, it matched the start of string verbatim. Return $1 */
	jmp .LcompareCharacters		/* otherwise continue checking for instance where cmpb != e */

.LdoneWithComparison:
	addq $8, %rsp			/* realign stack pointer */
	ret
