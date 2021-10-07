/*
 * Assembly language implementation of the main function
 * for the asm_textsearch_fns program
 */
	.section .rodata
errorMsg: .string "Error: invalid number of command line arguments\n"
readFile: .string "r"

	.section .text

	.globl main
main:
	subq $8, %rsp
	cmpq $3, %rdi
	je .LprintLines
	cmpq $4, %rdi
	je .LprintOccurrences

	movq stderr(%rip), %rdi
	movq $errorMsg, %rsi
	call fprintf
	jmp .Lreturn

.LprintLines:
	movq %rdi, %r12
	movq %rsi, %r13
	movq (%rsi, %r12, 8) , %rdi
	movq $readFile, %rsi
	
.LprintOccurrences:
	movq %rdi, %r12
	movq %rsi, %r13

.Lreturn:
	movl $0, %eax
	addq $8, %rsp
	ret
