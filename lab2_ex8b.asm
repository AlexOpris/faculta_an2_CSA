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
    a dw 1
    b dw 2
    c db 3
    d db 4
    e dd 5

; our code starts here
segment code use32 class=code
    start:
        ; ...  1/a+200*b-c/(d+1)+e
        
        mov ax, 1
        mov dx, 0
        div word[a] ; ax=rest
        
        mov cx, ax  ; cx=1/a
        
        mov al, 200
        mul word[b]  ; ax=200*b
        
        add ax, cx  ; ax=1/a+200*b
        mov cx, ax  ; cx=1/a+200*b
        
        mov al, [d]
        add al, 1   ; al=d+1
        
        mov bl, al
        mov al, [c]
        mov ah, 0
        div bl  ; al=c/(d+1) 
        
        movzx ax, al
        sub cx, ax
        mov ax, cx
        
        movzx eax, ax
        
        add eax, [e]
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
