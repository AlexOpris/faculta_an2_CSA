bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; A string of bytes A is given. Construct string B containing only odd values from string A.
    ;If A = 17, 4, 2, -2, -1 => B = 17, -1
    sa db 17, 4, 2, -2, -1
    lensa equ $-sa
    sb times lensa db 0
    two db 2


; our code starts here
segment code use32 class=code
    start:
        mov esi, 0
        mov edi, 0
        mov ecx, lensa

        
        repeat:
            mov bl, [sa+esi]
            mov al, bl           
            mov ah, 0
            
            idiv byte[two]   ;ah=remainder, al=quotient
            cmp ah, 1
            JE addtoSB
            JNE end_repeat
                addtoSB:
                    mov [sb+edi], bl    ;moves to string B the value from A             
                    inc edi             ;increses esi and edi
                    jmp end_repeat
            
                                ;if parity is 0 then just increses esi to move to the next elem from string A
            end_repeat:
                inc esi 
        loop repeat
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
