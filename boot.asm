; nasm boot.asm 
; qemu-system-i386 boot

bits 16
org 0x7c00

mov si, name        

mov ah, 0x02        
mov bh, 0x00        
mov dh, 10          
mov dl, 20          
int 0x10

; Imprimir el nombre
print_name:
    mov ah, 0x0e    
    mov al, [si]    
    int 0x10        ; Llamada a la BIOS para imprimir
    inc si          ; Avanzar al siguiente carácter
    cmp byte [si], 0 ; Comprobar si es el final del string
    jne print_name  

jmp $


name:
    db "tefa", 0

times 510 - ($ - $$) db 0 
dw 0xAA55               
