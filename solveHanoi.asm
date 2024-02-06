section .data
    titulo db "TORRE DE HANOI", 0
    nDiscos db "Digite a quantidade de discos (1-20): ", 0
    formatador db "%d", 0
    discos dd 0
    a dd 1
    b dd 2
    c dd 3

section .bss
    input resb 5

section .text
    extern printf
    extern scanf
    global main

main:
    ; Printa titulo
    mov rdi, titulo
    call printf

    ; Pede a quantidade de discos
    mov rdi, nDiscos
    call printf

    ; Lê numero de discos
    mov rdi, input
    mov rsi, formatador
    call scanf

    ; Converte o input str -> int
    xor rax, rax 
    mov rcx, 10 
    mov rdi, input 

convert_loop:
    movzx rdx, byte [rdi] 
    test rdx, rdx 
    jz terminaConversao
    sub rdx, '0' ; ASCII -> int
    imul rax, rcx 
    add rax, rdx 
    inc rdi 
    jmp convert_loop ; Repete o processo para todos os caracteres
    
terminaConversao:
    mov [discos], eax ; Guarda a conversão em discos

    ; Printa numero de discos
    mov rsi, [discos]
    mov rdi, formatador
    call printf

    ; Chama a SolveHanoi
    mov esi, [discos]
    mov edi, 1
    mov edx, 3
    mov ecx, 2
    call SolveHanoi

    ; Quita o programa
    mov eax, 60
    xor edi, edi
    syscall

; Recursive function to solve the Tower of Hanoi
SolveHanoi:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    ; if discos == 1
    mov eax, [discos]
    cmp eax, 1
    jne .FazRecursao

    ; Caso base: move um disco
    mov rsi, [a]
    mov rdx, [c]
    mov rdi, formatador
    call printf
    jmp .TerminaRecursao

.FazRecursao:
    ; pilha -> a, b, c
    dec dword [discos]
    mov esi, [a]
    mov edx, [b]
    mov ecx, [c]
    call SolveHanoi

    ; Move o disco
    mov rsi, [a]
    mov rdx, [c]
    mov rdi, formatador
    call printf

    ; pilha -> b, c, a
    mov esi, [b]
    mov edx, [c]
    mov ecx, [a]
    call SolveHanoi

.TerminaRecursao:
    add rsp, 16
    pop rbp
    ret
