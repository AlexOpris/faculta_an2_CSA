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
    a dw 10
    b db 2
    c dw 3
    d db 4
    r dd 0

; our code starts here
segment code use32 class=code
    start:
        ; ... a-b+7-(c+d)
        
        mov ax, [c] ; ax=c
        mov bl, byte[d] ; bl=d
        movzx bx, byte[d] ; bx=d
        
        add ax, bx ; ax=c+d
        
        mov cx, ax ; cx=c+d
        
        mov ax, [a] ; ax =a
        
        movzx bx, byte[b] 
        sub ax, bx  ; ax=a-b
        
        add ax, 7 ; ax=a-b+7
        
        sub ax, cx  ;ax-result
        
        movzx eax, ax

        
        
        
        
                
        
        
    
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
