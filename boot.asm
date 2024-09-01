bits 16
org 0x7c00

mov si, name        


;random row
call random


mov ah, 0x02        
mov bh, 0x00   
mov dh, [row]
mov dl, [column]                          
int 0x10

; Imprimir el nombre
print_name:
    mov ah, 0x0e    
    mov al, [si]    
    int 0x10        ; Call BIOS to print
    inc si          ; move next caracter
    cmp byte [si], 0 ; check final string
    jne print_name  

jmp $

;random rows & columns
random:

    mov ah, 0x00        ; Function 00h de INT 1Ah -get sistem Time
    int 0x1A            ; Call BIOS
    mov ax, dx          ; dx use Time as seed

    xor dx, dx          
    mov cx, 25          ; max num rows (0-24)
    div cx              ; Divide AX por 25,
    mov [row], dl  


    mov ax, dx         
    xor dx, dx          
    mov cx, 80          ; max num rows (0-79)
    div cx              
    mov [column], dl   

    ret

row:
    db 0

column:
    db 0

name:
    db "tefa", 0

times 510 - ($ - $$) db 0 
dw 0xAA55              

; nasm boot.asm 
; qemu-system-i386 boot

;or

; nasm -f bin boot.asm -o boot.bin
; qemu-system-i386 -drive format=raw,file=boot.bin