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
	pushq %r12
	pushq %r13
	movq %rdi, %r12
	movq %rsi, %r13
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
        movq $readFile, %rsi
        call fopen
        cmpq $0, %rax
        jle .LerrorFile
	cmpq $4, %r12
	je .LprintOccurrences

.LprintLines:
	jmp .Lreturn
	
.LprintOccurrences:
	jmp .Lreturn

.LerrorFile:
	movq stderr(%rip), %rdi
	movq $errorMsgFile, %rsi
	call fprintf

.Lreturn:
	movl $0, %eax
	popq %r13
	popq %r12
	addq $8, %rsp
	ret
