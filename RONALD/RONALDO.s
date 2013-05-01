.section .data
	nomePrograma: .asciz "***** LISTA ENCADEADA *****\n\n"
	telaCriar: .asciz "***** CRIAR LISTA *****\n\n"
	telaInserir: .asciz "***** INSERÇÃO DE DADOS *****\n\n"
	telaRemover: .asciz "***** REMOÇÃO DE DADOS *****\n\n"
	telaConsultar: .asciz "***** CONSULTA DE DADOS *****\n\n"
	telaMostrar: .asciz "***** MOSTRAR LISTA *****\n\n"

	opcaoCriar: .asciz "1 - Criar Lista.\n"
	opcaoInserir: .asciz "2 - Inserir Dado.\n"
	opcaoRemover: .asciz "3 - Remover Dado.\n"
	opcaoConsultar: .asciz "4 - Consultar Dado.\n"
	opcaoMostrar: .asciz "5 - Mostrar Lista.\n"
	opcaoSair: .asciz "0 - Sair.\n"
	opcao: .asciz "\nOpção: "

	ra: .asciz "Insira RA: "
	nome: .asciz "Insira nome: "
	curso: .asciz "Insira o curso: "

	raSize: .int 10
	nomeSize: .int 50
	cursoSize: .int 36
	
	mostrara: .asciz "RA: %d"
	mostranome: .asciz "Nome: %s"
	mostracurso: .asciz "Curso: %s"

	
	quebrar1Linha: .asciz "\n"
	clear: .asciz "clear"
	
	invalido: .asciz "Opção inexistente, insira novamente.\n"
	registroInvalido: .asciz "Registro inexistente.\n"
	listaVazia: .asciz "Lista vazia.\n"
	criandoLista: .asciz "Nova lista criada.\n"

	intscanf: .asciz "%d"
	stringscanf: .asciz "%s"
	
	alloc: .int 100
	NULL: .int 0

.section .bss
	.lcomm escolha, 4
	.lcomm ptrinicial, 4
	.lcomm ptrfinal, 4
	.lcomm ultimoInserido, 4
	.lcomm endereco, 4
	.lcomm raConsultar, 4
	.lcomm ptranterior, 4

.section .text
.globl _start
_start:
	call clearSystem
	call menu
	call verificarEscolha
	jmp _start

.type criaLista, @function
criaLista:
	call clearSystem
	pushl $telaCriar
	call printf
	addl $4, %esp

	pushl $criandoLista
	call printf
	addl $4, %esp

	movl ptrinicial, %eax
	cmp $0, %eax
	je vazio
	pushl %eax
	call free
	addl $4, %esp

vazio:
	movl NULL, %eax
	movl %eax, ptrinicial
	movl %eax, ptrfinal
	
	call getchar
	call getchar
	ret


.type insereDado, @function
insereDado:
	call clearSystem
	call allocarEspaco
	call allocarPtr
	call pedirDados
	ret

.type pedirDados, @function
pedirDados:
	pushl $telaInserir
	call printf
	addl $4, %esp

	movl endereco, %ecx
	pushl %ecx
	
	pushl $ra
	call printf
	addl $4, %esp
	pushl $intscanf
	call scanf
	addl $4, %esp
	
	popl %ecx

	movl raSize, %eax
	addl %eax, %ecx
	pushl %ecx
	
	pushl $nome
	call printf
	addl $4, %esp
	pushl $stringscanf
	call scanf
	addl $4, %esp
	
	popl %ecx

	movl nomeSize, %eax
	addl %eax, %ecx
	pushl %ecx

	pushl $curso
	call printf
	addl $4, %esp
	pushl $stringscanf
	call scanf
	addl $4, %esp

	popl %ecx
	
	movl cursoSize, %eax
	addl %eax, %ecx
	movl NULL, %edx
	movl %edx, (%ecx)

	ret

.type allocarEspaco, @function
allocarEspaco:
	movl alloc, %eax
	pushl %eax
	call malloc
	addl $4, %esp
	movl %eax, endereco
	ret

.type allocarPtr, @function
allocarPtr:
	movl ptrinicial, %eax
	movl endereco, %ebx
	cmp $0, %eax
	jg alterarPtr
	movl %ebx, ptrinicial
	jmp manterPtr

alterarPtr:
	movl ultimoInserido, %ecx
	call getPtr
	movl %ebx, (%ecx)

manterPtr:
	movl %ebx, ptrfinal
	movl %ebx, ultimoInserido
	ret


.type getPtr, @function
getPtr:
	movl raSize, %edx
	addl %edx, %ecx
	movl nomeSize, %edx
	addl %edx, %ecx
	movl cursoSize, %edx
	addl %edx, %ecx
	ret

.type removeDado, @function
removeDado:
	call clearSystem
	pushl $telaRemover
	call printf
	addl $4, %esp
	call consultaDado
	cmp $0, %eax
	jg continuarRemover
	call listaNULL
	jmp fimRemove

continuarRemover:
	movl ptrinicial, %ecx
	cmp %eax, %ecx
	je moverInicial
	movl ptrfinal, %ecx
	cmp %eax, %ecx
	je moverFinal

moverMeio:
	movl %eax, %ecx
	call getPtr
	movl (%ecx), %edi
	movl ptranterior, %ecx
	call getPtr
	movl %edi, (%ecx)
	jmp liberar

moverInicial:
	call getPtr
	movl (%ecx), %ebx
	movl ptrinicial, %edi
	movl %ebx, ptrinicial
	movl ptrfinal, %edx
	cmp %edi, %edx
	jne liberar
	movl %ebx, ptrfinal
	jmp liberar

moverFinal:
	call getPtr
	movl (%ecx), %ebx
	movl ptranterior, %ecx
	movl %ecx, ptrfinal
	movl %ecx, ultimoInserido
	call getPtr
	movl %ebx, (%ecx)

liberar:
	pushl %eax
	call free
	addl $4, %esp

fimRemove:
	call getchar
	call getchar
	ret
	

.type consultaDado, @function
consultaDado:	

	movl ptrinicial, %ecx
	cmp $0, %ecx
	jg continuar
	call listaNULL
	movl %ecx, %eax
	jmp returnRet

continuar:
	pushl $ra
	call printf
	addl $4, %esp

	pushl $raConsultar
	pushl $intscanf
	call scanf
	addl $8, %esp

	movl raConsultar, %eax
	movl ptrinicial, %ecx

enquantoNotEncontrou:
	movl %ecx, %edi
	movl (%ecx), %ebx
	cmp %ebx, %eax
	je encontrou
	call getPtr
	movl %edi, ptranterior
	movl (%ecx), %edx
	movl %edx, %ecx
	cmp $0, %ecx
	jg enquantoNotEncontrou
	pushl $registroInvalido
	call printf
	addl $4, %esp
	jmp returnRet

encontrou:
	call imprimir
	movl %edi, %eax

returnRet:
	ret

.type imprimir, @function
imprimir:
	pushl %ecx

	pushl (%ecx)
	pushl $mostrara
	call printf
	addl $8, %esp
	
	pushl $quebrar1Linha
	call printf
	addl $4, %esp
	
	popl %ecx
	movl raSize, %eax
	addl %eax, %ecx

	pushl %ecx
	pushl $mostranome
	call printf
	addl $4, %esp

	pushl $quebrar1Linha
	call printf
	addl $4, %esp
	
	popl %ecx
	movl nomeSize, %eax
	addl %eax, %ecx

	pushl %ecx
	pushl $mostracurso
	call printf
	addl $4, %esp
	
	pushl $quebrar1Linha
	call printf
	addl $4, %esp

	popl %ecx
	movl cursoSize, %eax
	addl %eax, %ecx

	ret

.type listaNULL, @function
listaNULL:
	pushl $listaVazia
	call printf
	addl $4, %esp
	ret

.type mostraLista, @function
mostraLista:
	call clearSystem
	pushl $telaMostrar
	call printf
	addl $4, %esp

	movl ptrinicial, %ecx
	cmp $0, %ecx
	jg notAcabou
	call listaNULL
	jmp acabou

notAcabou:
	call imprimir

	movl (%ecx), %ebx
	pushl $quebrar1Linha
	call printf
	addl $4, %esp
	movl %ebx, %ecx
	cmp $0, %ecx
	jg notAcabou

acabou:
	call getchar
	call getchar
	ret

.type verificarEscolha, @function
verificarEscolha:
	movl escolha, %eax
	cmp $0, %eax
	je sair
        cmp $1, %eax
	je criar
	cmp $2, %eax
	je inserir
	cmp $3, %eax
        je remover
	cmp $4, %eax
	je consultar
	cmp $5, %eax
	je mostrar
	jmp numeroInvalido

sair:
	movl $1, %eax
	movl $0, %ebx
	int $0x80

criar:
	call criaLista
	jmp return

inserir:
	call insereDado
	jmp return

remover:
	call removeDado
	jmp return

consultar:
	call clearSystem
	pushl $telaConsultar
	call printf
	addl $4, %esp
	call consultaDado
	call getchar
	call getchar
	jmp return

mostrar:
	call mostraLista
	jmp return

numeroInvalido:
	pushl $invalido
	call printf
	addl $4, %esp

return:
	ret

.type clearSystem, @function
clearSystem:
	pushl $clear
	call system
	addl $4, %esp
	ret

.type menu, @function
menu:
	pushl $nomePrograma
	call printf
	addl $4, %esp
	pushl $opcaoCriar
	call printf
	addl $4, %esp
	pushl $opcaoInserir
	call printf
	addl $4, %esp
	pushl $opcaoRemover
	call printf
	addl $4, %esp
	pushl $opcaoConsultar
	call printf
	addl $4, %esp
	pushl $opcaoMostrar
	call printf
	addl $4, %esp
	pushl $opcaoSair
	call printf
	addl $4, %esp
	pushl $opcao
	call printf
	addl $4, %esp
	
	pushl $escolha
	pushl $intscanf
	call scanf
	addl $8, %esp
	ret
