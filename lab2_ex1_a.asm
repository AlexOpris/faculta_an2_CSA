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
    a db 1
    b db 2
    c db 1
    d dw 6

; our code starts here
segment code use32 class=code
    start:
        ; ...((a+b-c)*2 + d-5)*d
        
        mov al, [a]
        mov bl, [b]
        
        add al, bl  ;al=a+b
        mov bl, [c]
        
        sub al, bl  ;al=a+b-c
        
        mov bl, 2
        
        mul bl  ;ax=(a+b-c)*2
        
        mov bx, [d]
        sub bx, 5 ;bx=d-5
        
        add ax, bx  ;((a+b-c)*2 + d-5)
        
        mov bx, [d]
        
        mul bx      ;dx:ax=((a+b-c)*2 + d-5)*d
       
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
