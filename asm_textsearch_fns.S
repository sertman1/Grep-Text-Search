/*
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
 * 	 str - pointer to string whose # of occurences in 'line' will be returned
 */

	.globl count_occurrences
count_occurrences:

	subq $8, %rsp 					
	movq $0, %rax					/* occurences = 0 at the start */
	movq $0, %r9					/* %r9 used as an index to trace characters in str */
							
.LcompareChars:
	movb (%rsi,%r9,1), %r10b		/* store str[index] to %r10 for comparison */
	cmpb %r10b, (%rdi)				/* does str[index] == the char pointed to by line? */
	je .LcheckStrNullTerm			/* if so, see if end of str has been reach */
	jmp .LnextCharInLine			/* if not, current char of line is not a match */ 

.LcheckStrNullTerm:
	add $1, %r9						/* index++ */
	cmpb $0, (%rsi,%r9,1)			/* is the next char of string null? */
	je .LoccurenceFound				/* if so, str matched with an index of line excactly */
	jmp .LcompareChars				/* if not, check the following index for a character match */

.LoccurenceFound:
	addq $1, %rax					/* occurences++ */
	jmp .LnextCharInLine			

.LnextCharInLine:
	movq $0, %r9					/* reset index to 0 to check for other occurences of str */	
	incq %rdi						/* advance line (%rdi) to the following char */ 
	cmpb $0, (%rdi)					/* has end of line been reached yet? */
	je .LdoneWithCountOccurences	/* if so, immmediatley return */
	jmp .LcompareChars				/* otherwise, keep on searching for occurences */

.LdoneWithCountOccurences:
	addq $8, %rsp 					
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
	movq $0, %rax 		/* length = 0 at start */

.LcheckNullTerm:
	cmpb $0, (%rdi)		/* NUL terminator reached? */
	je .LdoneWithLoop	/* if so, immediatley return */
	addq $1, %rax 		/* if not, add 1 to (length) return value */
	incq %rdi  			/* advance to next character */
	jmp .LcheckNullTerm /* continue loop */

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
	movq $1, %rax 				/* assume true at first */
								/* check for deniability in loops: */
.LcompareCharacters:
	movb (%rsi), %r10b			/* store 1 char into 'temp' %r10 space for comparison */
	cmpb %r10b, (%rdi)			/* compare the string to the prefix char by char */
	je .LcheckPrefixNullTerm	/* if the chars match, check if next char in pfx is null */
	movq $0, %rax				/* if not equal, return false (0) */
	jmp .LdoneWithComparison

.LcheckPrefixNullTerm:
	incq %rdi					/* advance s and pfx to their next char */
	incq %rsi
	cmpb $0, (%rsi)				/* is pfx null? */
	je .LdoneWithComparison		/* if so, it matched the start of s verbatim. Return $1 (true) */
	jmp .LcompareCharacters		/* otherwise, continue checking for instance where thier chars dont equal */
	
.LdoneWithComparison:
	addq $8, %rsp		
	ret
