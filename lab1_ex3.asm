bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a dw 2
    b db 3
    c dw 2
    d db 1
    aux db 5
    r resw 1

; our code starts here
segment code use32 class=code
    start:
        ; ...a+4+b-(5-d)
        mov ax, [a]
        add ax, 4 ;a+4
        
        mov bl, [b]
        movzx bx, bl
        
        add ax, bx ;ax=a+4+b
        
        mov bl, [aux]
        mov cl, [d]
        sub bl, cl ;cl=5-d
        
        movzx bx, bl
        sub ax, bx  ;ax=a+4+b-(5-d)
        
        mov [r], ax    
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program