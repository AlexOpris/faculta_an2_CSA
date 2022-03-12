bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ;  A string of bytes is given.
    ; Compute the averge (as integer) of each two consecutive elements from string.
    a db 1, 8, 3, 5, 25
    la equ $-a
    b times la-1 db -1  ; 4, 5, 4, 15
    doi db 2

; our code starts here
segment code use32 class=code
    start:
        mov esi, 0 ; a
        mov edi, 0; b
        mov ecx, la-1
        
        repeat1:
            mov al, [a+esi] ; elem de pe adresa 0
            mov bl, [a+esi+1] ; elem de pe adresa 1
            add al, bl ; al = [a+esi] + [a+esi+1]
            cbw   ; al-> ax sau MOVSX ax, al
            idiv byte[doi]  ; ax / 2 = al cat si ah rest
            mov [b+edi], al ; save media in b
            inc esi
            inc edi
        loop repeat1
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
