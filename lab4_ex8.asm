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
    a dw 0
    b dw 0
    
    c resw 0

; our code starts here
segment code use32 class=code
    start:
        mov cx, 0
        and cx, 0000000000000000b
        
        and word[b], 0000000000111111b
        ;b=0000000000b5b4b3b2b1b0
        
        or cx, word[b]
        ;cx=0000000000b5b4b3b2b1b0
        
        mov ax, [a]
        ;ax=a
        
        rol word[a], 3
        ;a=a12a11....a0a15a14a13
        
        and word[a], 1111111111000000b
        ;a=a12a11...a3000000
        
        or cx, word[a]
        ;cx=a12a11...a3b5...b0
        
        rol ax, 13
        ;ax=a2a1a0a15...a3
        
        and ax, 1110000000000000b
        ;ax=a2a1a00000000000000
        
        and cx, 0001111111111111b
        ;cx=000a9...a3b5...b0
        
        or cx, ax
        
        or word[c], cx
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
