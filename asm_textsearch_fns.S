/*
 * Assembly language implementations of functions declared in
 * textsearch_fns.h
 */

	.section .text

/*
 * The following is just an example of how an assembly language
 * function would be defined
 */
 
	.globl read_line
read_line:
	/* TODO: implementation of read_line function */

	ret

	.globl find_string_length
find_string_length:

	subq $8, %rsp /* align stack pointer address to multiple of 16 */
	movq $0, %rax /* length = 0 at start */

.LcheckNullTerm:
	cmpb $0, (%rdi)		/* NUL terminator reached? */
	je .LdoneWithLoop	/* if so, immediatley return */
	addq $1, (%rax) 	/* if not, add 1 to (length) return value */
	incq %rdi  			/* advance to next character */
	jmp .LcheckNullTerm /* continue loop */

.LdoneWithLoop:
	addq $8, %rsp /* realign the stack pointer */
	ret
