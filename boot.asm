bits 16
org 0x7c00


_start:
    
    ;call clean_screen

    mov ah, 0x00        ; Function 00h de INT 1Ah -set video mode
    mov al, 0x13        ; grafic mode 13h (320x200 pix, 256 colors)
    int 0x10            ; call a la BIOS 
    call random
    call draw_pix
    

; Función para dibujar la matriz
draw_pix:
    mov si, letter_matrix    ; load matrix
    mov bx, 5                ; # rows
    mov cx, [row]            ; Pos Y
    mov dx, [column]         ; Pos X

    next_row:
        mov di, [si]             ; load actual byte
        mov bp, 8                ; 8 columns, 1 byte

    next_pixel:
        test di, 80h             
        jz skip_pixel           

        ; Draw pix (dx, cx)
        mov ah, 0x0C            ; call Bios
        mov al, 0x0F            ; Color
        mov bh, 0x00            
        int 0x10                

    skip_pixel:
        shl di, 1               
        inc dx                  
        dec bp                  
        jnz next_pixel          
        ; next row
        mov dx, [column]        
        inc cx                  
        dec bx                  
        jnz next_row            

        ret

;random rows & columns

random:
    mov ah, 0x00        ; Function 00h -get sistem Time
    int 0x1A            ; Call BIOS
    mov ax, dx          ; dx use Time as seed

    xor dx, dx          
    mov cx, 200          ; max num rows (0-199)
    div cx              ; Divide AX por 25,
    mov [row], dx  

    mov ax, dx         
    xor dx, dx          
    mov cx, 320          ; max num columns (0-319)
    div cx              
    mov [column], dx   
    ret

clean_screen:
    mov ah, 0x0C        
    mov al, 0x00        
    mov cx, 0           ; initial left screeen
    mov dx, 0           ; initial rigth screen
    mov bx, 320*200     ; total pix
    ret

wait_key:
    mov ah, 0x00    ; Read key
    int 0x16        ; Call BIOS to read the key
    cmp al, 'l'
    je rotate_right
    jmp wait_key      ; check again for keys

rotate_right:

    mov ah, 0x0e    ; print caracteres
    mov al, 'l'     ; load key value tecla
    int 0x10        ; Call bios
    call clean_screen
    jmp wait_key

letter_matrix:
    db 0b11111100      
    db 0b11111111
    db 0b11111111
    db 0b11111111
    db 0b11111111
row:
    db 0

column:
    db 0

times 510 - ($ - $$) db 0 
dw 0xAA55              

; nasm boot.asm 
; qemu-system-i386 boot

; or

; nasm -f bin boot.asm -o boot.bin
; qemu-system-i386 -drive format=raw,file=boot.bin