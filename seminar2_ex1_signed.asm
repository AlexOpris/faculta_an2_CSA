bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...(a*2+b/3+e)/(c-d)+x/a; a-word; b,c,d-byte; e-doubleword; x-qword
    a dw -1234
    b db -2
    c db -3
    d db -8
    e dd -51
    x dq 0ABDWKSh
    r resd 1
    aux resw 1

; our code starts here
segment code use32 class=code
    start:
        ; ...
        ; (a*2+b/3+e)
        mov al, byte[b]
        cbw 
        mov bl, 3
        idiv bl  ;al=b/3 ah=b%3
        
        mov cx, word[a]
        mov ah, 0
        mov [aux], ax
        mov dx, 2
        imul dx
        ; dx:ax=a*2
        ; dx:ax + cx
        ; cx:bx
        
        mov bx, ax
        mov cx, dx
        ; cx:bx = a*2
        mov ax, cx
        cwd
        ;dx:ax=aux+cx:bx
        
        add ax, bx
        add dx, cx
        ;dx:ax=a*2+b/3
        mov cx, word[e+2]
        mov bx, word[e+0]
        ; cx:dx=e
        
        ;dx:ax+    12h
        ;cx:bx+    13h
        ;          2+3
        ;          1+1
        add ax, bx
        adc dx, cx
        
        ;dx:ax=(a*2+b/3+e)
        
        ;c-d
        mov bh, byte[c]
        mov bl, byte[d]
        sub bh, bl
        ; bh=c-d
        movsx bx, bh
        idiv bx
        ;dx:ax / bx
        ;ax=quotient
        ;dx=remainder
        
        ;ax=(a*2+b/3+e)/(c-d)
        
        ;x/a
        movsx ebx, word[a]
        ;x-qword into edx:eax
        mov eax, dword[x+0]
        mov ebx, dword[x+4]
        ;edx:eax=x
        idiv ebx
        ; eax=quotient
        ; ebx=remainder
        
        ;cx+eax
        movsx ecx, cx
        add ecx, eax
        
        mov [r], ecx
        ; r=result
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
