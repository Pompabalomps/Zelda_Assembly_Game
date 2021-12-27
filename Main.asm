IDEAL

MODEL small

STACK 256

DATASEG
message db "12345678901234567890123", 0dh, 0ah, 0
sup db "Up", 0dh, 0ah, 0
sdown db "down", 0dh, 0ah, 0
sright db "right", 0ah, 0dh, 0
sleft db "left", 0dh, 0ah, 0
array db 20 dup(0)

x dw 0
y dw 160
color db 64

CODESEG

;; print char, input at al
proc print_char
    push dx

    mov ah, 02h
    mov dl, al
    int 21h

    pop dx
    ret
endp

;; get char no echo
;; returns: al - ascii code
;;          ah - bios code
proc get_char_no_echo
    mov ah, 0
    int 16h

    ret
endp

;; get char, with echo, to al
proc get_char_with_echo
    mov ah, 1
    int 21h

    ret
endp

;; write char, input at al
proc write_char
    push dx

    mov ah, 02h
    mov dl, al
    int 21h

    pop dx
    ret
endp

proc print_string
    push bp
    mov bp, sp
    push bx
    push dx
    push ax

    mov  bx, [bp+4]
again:
    mov  dl, [bx]
    mov  ah, 02h
    int  21h
    inc  bx
    cmp  dl, 0
    jne  Again

    pop ax
    pop dx
    pop bx
    pop bp
    ret
endp

proc print_string_length
    push ax
    push bx
    push cx
    push dx

    mov bx, offset message
    xor cx, cx
label1:
    mov dl, [bx]
    inc bx
    inc cx
    cmp dl, 0ah
    jne label1

    cmp cx, 10
    jl lower10
    jmp greater10

greater10:
    xor dx,dx
    mov ax, cx

    mov bx, 10
    div bx

    ;; ax = quotient
    ;; dx = remainder

    add al, '0'
    call print_char

    mov cl, dl ; remainder

lower10:
    add cl, '0'
    mov al, cl
    call print_char

    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

proc print_arrow_type
;; 04bh = left
;; 04dh = right
;; 050h = down
;; 048h = up
    cmp ah, 04bh
    je left

    cmp ah, 04dh
    je right

    cmp ah, 050h
    je down

    cmp ah, 048h
    je up

left:
    push offset sleft
    jmp con
right:
    push offset sright
    jmp con
down:
    push offset sdown
    jmp con
up:
    push offset sup
    jmp con
con:
    call print_string

    ;; clear argument
    add sp, 2

    ret
endp

proc write_to_array
    push si

    mov si, offset array
    mov [si], al

    pop si
    ret
endp

proc enter_graphic_mode
    mov ax, 13h
    int 10h
    ret
endp

proc enter_text_mode
    mov ah , 0
    mov al, 2
    int 10h
    ret
endp

proc print_dot_from_memory
    push bx
    push cx
    push dx

    mov bh, 0h 
    mov cx, [x] 
    mov dx, [y] 
    mov al, [color] 
    mov ah, 0ch 
    int 10h

    pop dx
    pop cx
    pop bx
    ret
endp

proc color_pixel
    call enter_graphic_mode

next:
    call print_dot_from_memory

    ret
endp

Start:
    mov ax, @data
    mov ds, ax

    ;mov al, 41h + 10h
    ;mov al, 'q'
    ;call print_char

    ;push offset sleft
    ;lea bx, [offset sleft]
    ;push bx
    ;call print_string
    ;add sp, 4

    ; push offset sright
    ; call print_string
    ; add sp, 4

    ; push offset sright
    ; call print_string
    ; add sp, 4

    ;call print_string_length
    ; call get_char_no_echo
    ; call print_arrow_type

    ;call get_char_no_echo
    ;call write_to_array

    call color_pixel


Exit:
    mov ax, 4C00h
    int 21h
END start


