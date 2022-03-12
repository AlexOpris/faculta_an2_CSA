bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; B5. A string of words S is given. Compute string D containing only low bytes multiple of 9 from string S.
    ; If S = 3812h, 5678h, 1a09h => D = 12h, 09
    
    sa dw 3812h, 5678h, 1a09h
    ;low bytes from string A: 12h, 78h, 09h
    
    lensa equ ($-sa)/2
    nine db 9
    sd times lensa db -1
    
; our code starts here
segment code use32 class=code
    start:
        mov esi, 0
        mov edi, 0
        mov ecx, lensa
        
        repeat:
            mov bl, [sa+esi]
            mov al, [sa+esi]
            mov ah, 0
            idiv byte[nine]    ;ah=remainder, al=quotient
            
            cmp ah, 0
            JE addtoD
            JNE not_multiple
                addtoD:
                    mov [sd+edi], bl    ;adds bl to string D and increases edi
                    inc edi
                    
                    
            not_multiple:
                add esi, 2
        loop repeat
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
