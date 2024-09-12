bits 16
org 0x7c00

_start:
    mov ah, 0x00        ; Function 00h de INT 1Ah -set video mode
    mov al, 0x13        ; grafic mode 13h (320x200 pix, 256 colors)
    int 0x10            ; call a la BIOS
    ;call draw_welcome
    call random
    call wait_key


draw_pix:
    mov bx, 46                ; # rows
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
        mov al, 0x0B            ; Color
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
        inc si                  
        dec bx                  
        jnz next_row  
        ret

draw_pix_vertical:
    mov bx, 46                ; Numero total de filas
    mov cx, [row]             ; Posición Y inicial
    mov dx, [column]          ; Posición X inicial

    next_row_vertical:
        mov di, [si]          
        mov bp, 8            

    next_pixel_vertical:
        test di, 80h          
        jz skip_pixel_vertical

        mov ah, 0x0C          
        mov al, 0x0F          ; Color (blanco)
        mov bh, 0x00          ; Pagina de video
        int 0x10              ; Llamada a la BIOS

    skip_pixel_vertical:
        shl di, 1             ; Mover el byte a la izquierda (siguiente bit)
        inc cx                ; Incrementar la posicion Y (bajar un píxel)
        dec bp                ; Decrementar el contador de columnas
        jnz next_pixel_vertical

        ; Pasar a la siguiente columna
        mov cx, [row]         ; Reiniciar la posicion Y a la fila inicial
        inc dx                ; Incrementar la posicion X (mover a la derecha)
        inc si                ; Cargar el siguiente byte de la letra
        dec bx                ; Decrementar el numero de filas restantes
        jnz next_row_vertical
        ret

;random rows & columns

random:
    mov ah, 0x00        ; Function 00h -get sistem Time
    int 0x1A            ; Call BIOS
    mov ax, dx          ; dx use Time as seed

    xor dx, dx          
    mov cx, 180          ; max num rows (0-199)
    div cx              ; Divide AX por 25,
    mov [row], dx  

    mov ax, dx        
    xor dx, dx          
    mov cx, 300          ; max num columns (0-319)
    div cx              
    mov [column], dx  
    ret

clean_screen:
    mov ax, 0x0013    
    int 0x10          
    ret

wait_key:
    mov ah, 0x00    ; Read key
    int 0x16        ; Call BIOS to read the key
    cmp al, 'e'
    je initial_name_key
    cmp al, 'i'
    je initial_name_key
    cmp al, 'k'
    je name_down_key
    cmp al, 'l'
    je name_left_key
    cmp al, 'j'
    je name_right_key
    cmp al, 'f'
    je final_game
    cmp al, 'r'
    je restart_game
    jmp wait_key
   
    final_game:
        int 0x10                   ; call BIOS
        call clean_screen

    restart_game:
        call _start
        ;debe estar la bienvenida

    initial_name_key:
        int 0x10                   ; call BIOS
        call clean_screen
        mov si, initial_name     ; load matrix
        call draw_pix
        jmp wait_key    

    name_down_key:
        int 0x10        
        call clean_screen
        mov si, name_down    
        call draw_pix
        jmp wait_key
   
    name_left_key:
        int 0x10        
        call clean_screen
        mov si, name_down    
        call draw_pix_vertical
        jmp wait_key
       
    name_right_key:
        int 0x10        
        call clean_screen
        mov si, name_right
        call draw_pix_vertical
        jmp wait_key
     

initial_name:
    db 0b1000000
    db 0b1000000
    db 0b1111111
    db 0b1000000
    db 0b1000000
    db 0b0000000

    db 0b0011111  
    db 0b0010101  
    db 0b0010101  
    db 0b0011101  
    db 0b0000000

    db 0b1111111
    db 0b1001000
    db 0b1001000
    db 0b1000000
    db 0b0000000

    db 0b0000000
    db 0b0101111  
    db 0b0101001  
    db 0b0101001  
    db 0b0111111  
    db 0b0000000
    db 0b0000000
   
    db 0b1100000
    db 0b0011000
    db 0b0000110
    db 0b0000001
    db 0b0000110
    db 0b0011000
    db 0b1100000
    db 0b0000000
   
    db 0b0000000
    db 0b0101111  
    db 0b0101001  
    db 0b0101001  
    db 0b0111111  
    db 0b0000000
   
    db 0b1111111
    db 0b0000001
    db 0b0000001
    db 0b0000000
   
    db 0b0011111  
    db 0b0010101  
    db 0b0010101  
    db 0b0011101  
    db 0b0000000
   


name_down:
    db 0b00000001
    db 0b00000001
    db 0b11111111
    db 0b00000001
    db 0b00000001
    db 0b00000000

    db 0b11110000
    db 0b10101000
    db 0b10101000
    db 0b10111000
    db 0b00000000

    db 0b11111111
    db 0b0001001
    db 0b0001001
    db 0b0000001
    db 0b00000000

    db 0b00000000
    db 0b11101000
    db 0b10101000
    db 0b10101000
    db 0b11111000
    db 0b00000000
    db 0b00000000

    db 0b0000011
    db 0b0001100
    db 0b0110000
    db 0b1000000
    db 0b0110000
    db 0b0001100
    db 0b0000011
    db 0b0000000

    db 0b0000000
    db 0b11101000
    db 0b10101000
    db 0b10101000
    db 0b11111000
    db 0b00000000

    db 0b1111111
    db 0b1000000
    db 0b1000000
    db 0b1000000
    db 0b0000000

    db 0b11110000
    db 0b10101000
    db 0b10101000
    db 0b10111000
    db 0b00000000
   
name_right:
    db 0b0011101  
    db 0b0010101  
    db 0b0010101  
    db 0b0011111  
    db 0b0000000
   
    db 0b0000000
    db 0b0000001
    db 0b0000001
    db 0b0000001
    db 0b1111111
    db 0b0000000
    
    db 0b0000000
    db 0b0011111  
    db 0b0010101  
    db 0b0010101  
    db 0b0010111  
    db 0b0000000
    db 0b0000000
   
    db 0b1100000
    db 0b0011000
    db 0b0000110
    db 0b0000001
    db 0b0000110
    db 0b0011000
    db 0b1100000
    db 0b0000000

    db 0b0011111  
    db 0b0010101  
    db 0b0010101  
    db 0b0010111  
    db 0b0000000

    db 0b1001000
    db 0b1001000
    db 0b1001000
    db 0b1111111
    db 0b0000000

    db 0b0011101  
    db 0b0010101  
    db 0b0010101  
    db 0b0011111  
    db 0b0000000
   
    db 0b1000000
    db 0b1000000
    db 0b1111111
    db 0b1000000
    db 0b1000000
    db 0b0000000



welcome_screen:
    dd 0x3FF8
    dd 0xE00C
    dd 0x10004
    dd 0x20002
    dd 0x40C72

    dd 0x40CF2
    dd 0x201B2
    dd 0x103D2
    dd 0x84D2
    dd 0x10832

    dd 0x84D2
    dd 0x103D2
    dd 0x201B2
    dd 0x40CF2
    dd 0x40C72

    dd 0x20002
    dd 0x10004
    dd 0xE00C
    dd 0x3FF8





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