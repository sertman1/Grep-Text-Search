/*
 * Assembly language implementation of the main function
 * for the asm_textsearch_fns program
 */
	.section .rodata
errorMsgNumArgs: .string "Error: invalid number of command line arguments\n"
errorMsgFile: .string "Error: unable to open file\n"
readFile: .string "r"
occurrencesFmt: .string "%d occurrences(s)\n"

	.section .text

	.globl main
main:
	pushq %r12
	pushq %r13
	pushq %r14
	subq $24, %rsp
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
	pushq %rbp
	movq %rsp, %rbp
	cmpq $2, %r10
	je .LprintOccurrences

.LprintLines:
	movq %r12, %rdi
	movq %rsp, %rsi
	call read_line
	cmpb $0, %al
	je .LreturnAlignBuffer
	movq %rsp, %rdi
	movq %r14, %rsi
	call count_occurrences
	cmpb $0, %al	
	jle .LprintLines
	movq %rbp, %rdi
	call print_line	
	jmp .LprintLines
	
.LprintOccurrences:
	movq $0, %r13		/* num_occurrences counter variable */
.LcalculateOccurrences:
	movq %r12, %rdi
	movq %rsp, %rsi
	call read_line
	cmpb $0, %al
	je .LprintData
	movq %rsp, %rdi
	movq %r14, %rsi
	call count_occurrences
	addq %rax, %r13
	jmp .LcalculateOccurrences

.LprintData:
	movq $occurrencesFmt, %rdi
	movq %r13, %rsi
	call printf	
	jmp .LreturnAlignBuffer

.LerrorFile:
	movq stderr(%rip), %rdi
	movq $errorMsgFile, %rsi
	call fprintf

.Lreturn:
	movl $0, %eax
	addq $24, %rsp
	popq %r14
	popq %r13
	popq %r12
	ret

.LreturnAlignBuffer:
        movl $0, %eax
	popq %rbp
	addq $536, %rsp
	popq %r14
        popq %r13
        popq %r12
	ret
