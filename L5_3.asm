bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
 ; A string of DD is given. 
 ;Save in string R only low bytes equal with a byte X 
 ;from each high word from each doubleword.
 ; X is a variable defined in data segment.
 
 s dd 12345678h, 1a2b3c4dh
 ; words high: 1234h, 1a2bh
 ;              bytes low from words high: 34h, 2bh    !!!!!
 ;              bytes high from words high: 12h, 1ah
 ; words low: 5678h, 3c4dh
 ;              bytes low from words low: 78h, 4dh
 ;              bytes high from words low: 56h, 3ch
 ; s in mem:
 ; 78    56   34    12  4d  3c   2b     1a
 ; 0      1    2     3   4   5    6     7
 ;            blwh               blwh
 ls equ ($-s)/4
 r resb ls
 x db 34h

; our code starts here
segment code use32 class=code
    start:
        mov esi, 2; s blwh
        mov edi, 0 ; r
        mov ecx, ls
        myrep:
            mov al, byte[s+esi]
            cmp al, byte[x]
            JE addinR
            JNE next
                addinR:
                    mov [r+edi], al
                    inc edi
                    add esi, 4
                    jmp end_myrep
                next:
                    add esi, 4
        end_myrep:
        loop myrep
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
