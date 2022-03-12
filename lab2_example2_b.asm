bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; (a+a+b*c*100)/(a+10)+a
    
    a db 10
    b db 4
    c db 3
    aux resd 1
    aux2 resd 1
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov al, byte[c]
        mov bl, 100
        mul bl ;ax = c*100
        
        movzx bx, byte[b]
        mul bx; result in dx:ax = b*c*100
        
        mov word [aux + 0], ax
        mov word [aux + 2], dx 
        
        mov eax, [aux]
        
        movzx ebx, byte[a]
        add eax, eax ; a+a
        add eax, ebx ; eax = a+b*c*100
        
        ;a+10
        
        mov bl, byte[a]
        add bl, 10 ; bl=a+10
        
        ; eax/bl=(a+b*c*100)/(a+10)
        movzx bx, bl
        ; converting byte bl to bx
        ; transfer the content from eax into dx:ax
        mov [aux2], eax
        mov ax, word [aux2 + 0]
        mov dx, word [aux2 + 2]
        div bx ; ax=eax/bl
        
        ; (a+a+b*c*100)/(a+10)+a
        movzx bx, byte[a]
        add ax, bx ; ax=(a+a+b*c*100)/(a+10)+a
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
