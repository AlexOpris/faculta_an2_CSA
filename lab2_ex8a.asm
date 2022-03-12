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
    a db 5
    b db 1
    c db 10
    d dw 1
    
    
; our code starts here
segment code use32 class=code
    start:
        ; ...(100*a+d+5-75*b)/(c-5) 
        
        mov al, 100
        mul byte[a] ; ax=a*100
        

        add ax, [d] ; ax=a*100+d
        
        add ax, 5
        
        mov bx, ax
        
        mov al, 75   
        mul byte[b]     ;ax=75*b
        
        sub bx, ax      ; bx =100*a+d+5-75*b
        
        mov cl, byte[c]
        sub cl, 5
        
        mov ax, bx
        
        div cl ; al=cat, ah=rest
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
