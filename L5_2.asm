bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; A string of words S is given.
    ; Store in string D only high bytes which are negative and odd.
   
   s dw 02adh, 0FECDh, 0FFABh, 0FDCDh
    ; byte high: 02h, FEh, FFh, FD
    ; byte low:  adh , cdh, abh, cdh
    ; identif byte low si byte high pe val din data segment
    
    ; s in mem, cf little-endian
   ; ad   02   CD  FE   AB  FF CD  FD
   ; 0     1   2   3     4   5  6   7
  
  ;      bytehight: adr: 1, 3, 5, 7 ; esi=1, esi=esi+2 
  ;      bytes low: adr: 0, 2, 4, 6; esi = 0, esi=esi+2  
    
    ls equ ($-s)/2
    d times ls db -1
    ; d db 0FFh, 0FDh
    doi db 2
   ; our code starts here
segment code use32 class=code
    start:
       mov ecx, ls
       mov edi, 0 ; d
       mov esi, 1 ; s, bytes high
       repeat2:
            mov al, byte[s+esi]
            mov bl, al
            cmp al, 0
            JGE positive
            JL negative
                positive:
                    add esi, 2 ; go to next byte high
                    jmp end_myrepeat
                negative:
                    cbw; sau movsx ax, al
                    idiv byte[doi] ; al cat si ah-rest
                    cmp ah, 0
                        JE next
                        JNE addinD
                            next:
                                add esi, 2
                                jmp end_myrepeat
                            
                            addinD:
                                mov [d+edi], bl
                                inc edi
                                add esi, 2
                               
         end_myrepeat:                       
       
       loop repeat2
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
