/*
 * Assembly language implementation of the main function
 * for the asm_textsearch_fns program
 */
	.section .rodata
errorMsgNumArgs: .string "Error: invalid number of command line arguments\n"
errorMsgFile: .string "Error: unable to open file\n"
readFile: .string "r"

	.section .text

	.globl main
main:
	subq $8, %rsp
	pushq %rbp
	pushq %r12
	pushq %r13
	pushq %r14
	movq %rdi, %r12
	cmpq $3, %rdi
	je .LvalidateFile
	cmpq $4, %rdi
	je .LvalidateFile
	movq stderr(%rip), %rdi
	movq $errorMsgNumArgs, %rsi
	call fprintf
	jmp .Lreturn

.LvalidateFile:
	decq %r12
        movq (%rsi, %r12, 8) , %rdi
        decq %r12
	movq (%rsi, %r12, 8), %r14	/* %r14 = desired string */
	movq $readFile, %rsi
        call fopen
        cmpq $0, %rax
        jle .LerrorFile
	movq %r12, %r10
	movq %rax, %r12		/* r12 now stores file pointer */	
	subq $512, %rsp		/* make room for 512 chars */
	movq %rsp, %rbp	 
	cmpq $4, %r10
	je .LprintOccurrences

.LprintLines:
	jmp .LreturnAlignBuffer
	
.LprintOccurrences:
	movq $0, %r13		/* num_occurrences counter variable */
	jmp .LreturnAlignBuffer

.LerrorFile:
	movq stderr(%rip), %rdi
	movq $errorMsgFile, %rsi
	call fprintf

.Lreturn:
	movl $0, %eax
	popq %r14
	popq %r13
	popq %r12
	popq %rbp
	addq $8, %rsp
	ret

.LreturnAlignBuffer:
        movl $0, %eax
	addq $512, %rsp
        popq %r14
        popq %r13
        popq %r12
        popq %rbp
	addq $8, %rsp
	ret
