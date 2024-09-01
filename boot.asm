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

; Print name
print_name:
    
    mov ah, 0x0e    
    mov al, [si]    
    int 0x10        ; Call BIOS to print
    inc si          ; move next caracter
    cmp byte [si], 0 ; check final string
    jne print_name  

jmp wait_key

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

wait_key:
    mov ah, 0x00    ; Read key
    int 0x16        ; Call BIOS to read the key
    cmp al, 'j'     ; compare
    je rotate_left
    cmp al, 'k'
    je rotate_down
    cmp al, 'l'
    je rotate_right
    cmp al, 'i'
    je rotate_up
    jmp wait_key      ; check again for keys

rotate_right:

    mov ah, 0x0e    ; print caracteres
    mov al, 'l'     ; load key value tecla
    int 0x10        ; Call bios
    jmp wait_key

rotate_up:

    mov ah, 0x0e    
    mov al, 'i'   
    int 0x10
    jmp wait_key

rotate_down:

    mov ah, 0x0e    
    mov al, 'k'   
    int 0x10
    jmp wait_key

rotate_left:

    mov ah, 0x0e    
    mov al, 'j'  
    int 0x10
    jmp wait_key

clean_screen:
    mov ah, 0x06        ; Función 06h de INT 10h - Desplazar pantalla
    mov al, 0x00        ; Atributo de fondo de pantalla (0x00 = blanco)
    mov bh, 0x00        ; Página de video
    mov cx, 0x0000      ; Esquina superior izquierda
    mov dx, 0x184f      ; Esquina inferior derecha (80 columnas x 25 filas)
    int 0x10            ; Llamada a la BIOS

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

; or

; nasm -f bin boot.asm -o boot.bin
; qemu-system-i386 -drive format=raw,file=boot.bin