;  A negative number a (a: dword) is given. Display the value of that number in base 10 and 
;  in the base 16 in the following format: "a = <base_10> (base 10), a = <base_16> (base 16)"

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

extern printf, scanf               ; tell nasm that exit exists even if we won't be defining it
import printf msvcrt.dll  
import scanf msvcrt.dll 
                          
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    
    a dd -735
    formatprint db "a = %d (base 10), a = %x (base 16)", 0 
    aux resd 0
    aux2 resd 0


; our code starts here
segment code use32 class=code
    start:
        mov ebx, [a]
        mov dword[aux2], ebx    ;computing hexadecimal value
        mov al, byte[aux2+0]
        mov ah, byte[aux2+2]
        mov dl, byte[aux2+4]
        mov dh, byte[aux2+6]
        mov byte[aux+0], al
        mov byte[aux+2], ah 
        mov byte[aux+4], cl
        mov byte[aux+6], ch 
        
        
        push dword[aux]
        push dword[a]           ;pushing the given number on the stack
        push dword formatprint  ;pushing the print format
        
        call[printf]            ;calling the printf function
        
        add esp, 4 * 2          ; cleaning the parameters from the stack

    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
