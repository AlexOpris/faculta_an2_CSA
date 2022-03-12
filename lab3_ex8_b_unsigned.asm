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
    a dw 55473
    b dw 29808
    c db 210
    d db 47
    e dd 0EEDDCCBBh

; our code starts here
segment code use32 class=code
    start:
        ; ...  1/a+200*b-c/(d+1)+e
        ;CF=0, ZF=1, SF=0, OF=0
        
        mov ax, 1   
        mov dx, 0
        div word[a] ; ax=rest
        
        mov cx, ax  ; cx=1/a
        
        mov al, 200
        mul word[b]  ; ax=200*b    
        ;CF=1, ZF=0, SF=1, OF=1
        
        add ax, cx  ; ax=1/a+200*b
        ;CF=0, ZF=0, SF=1, OF=0
        mov cx, ax  ; cx=1/a+200*b
        
        mov al, [d]
        add al, 1   ; al=d+1
        ;CF=0, ZF=0, SF=0, OF=0
        
        mov bl, al
        mov al, [c]
        mov ah, 0
        div bl  ; al=c/(d+1) 
        
        movzx ax, al
        sub cx, ax
        ;CF=0, ZF=0, SF=1, OF=0
        mov ax, cx
        
        movzx eax, ax
        
        add eax, [e]
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
