;2. Read a string. Extract all small letters and save into second string. Print the second string on screen.
;Ex: s = Ana are Mere => d= na are ere sau d= naareere


bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

extern printf, scanf , gets             
import printf msvcrt.dll  
import scanf msvcrt.dll  
import gets msvcrt.dll  

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    s resb 30
    lens equ $-s
    formatstring db '%s', 0
    startmsg db 'Introduce your string: ', 0
    smallletters db 'abcdefghijklmnopqrstuvwxyz', 0
    news times lens db -1
    endmsg db 'The new string is: %s ', 0
    copy dd 0
    copy2 dd 0
    aux resd 0
    
; our code starts here
segment code use32 class=code
    start:
        ;printing the start msg
        push dword startmsg     
        call [printf]
        add esp, 4*1       
        
        ;getting the string
        push dword s
        call [gets]
        add esp, 4*1
        
        ;finding the small letters
        mov ecx, 30
        mov esi, 0
        
        checkstring:
            mov al, [s+esi]
            mov [copy], ecx
            mov [copy2], esi
            
            mov ecx, 26         ;26 is the number of small letters
            mov edi, 0
            mov esi, [aux]
            checkletter:
                mov bl, [smallletters+edi]
                cmp al, bl
                JE addtostring
                JNE next
                    addtostring:
                        mov [news+esi], al
                        inc esi
                        mov [aux], esi
                        JMP next
                        
                next:
                    inc edi
            loop checkletter
            
            mov ecx, [copy]
            mov esi, [copy2]
            
            inc esi
            
        loop checkstring
        
        push dword news
        push dword endmsg
        call [printf]
        add esp, 4*2
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
