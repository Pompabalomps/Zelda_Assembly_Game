IDEAL

MODEL small

STACK 512

start_x equ 30
start_y equ 30
height equ 20
wid equ 20

DATASEG

x dw start_x
y dw start_y
curr_x dw 0

CODESEG

proc _test
	push ax
	push bx
	push cx
	push dx

	mov al, 2
	mov cx, 200
	mov dx, 100
	mov ah, 0ch
	int 10h

	pop dx
	pop cx
	pop bx
	pop ax
	ret
endp

proc check_arrow
	push ax
	cmp al, 57h
	je up
	cmp al, 41h
	je left
	cmp al, 53h
	je down
	cmp al, 44h
	je right
	jne con
	
	up:
		call clean_screen
		sub [y], 10
		call draw_character

		jmp con
	left:
		call clean_screen
		sub [x], 10
		call draw_character

		jmp con
	down:
		call clean_screen
		add	[y], 10
		call draw_character

		jmp con
	right:
		call clean_screen
		add [x], 10
		call draw_character

		jmp con

	con:

	pop ax
	ret
endp

proc clean_screen
	push cx
	push dx
	push bx
	push ax

	mov bx, 0
	mov al, 0
	draw_line:
		mov cx, [curr_x]
		mov dx, bx
		mov ah, 0ch
		int 10h
		inc [curr_x]
		cmp [curr_x], 320
		jne draw_line
		je drop_down

	drop_down:
		inc bx
		cmp bx, 200
		mov [curr_x], 0
		jne draw_line
		je con2

	con2:

	pop ax
	pop bx
	pop dx
	pop cx
	ret
endp

proc draw_character
	push cx
	push dx
	push bx
	push [x]
	push [y]

	draw_left:
		mov al, 47
		mov cx, [x]
		mov dx, [y]
		mov ah, 0ch
		int 10h
		inc [y]
		cmp [y], start_y + height
		jne draw_left
	
	mov [x], start_x + wid
	draw_right:
		mov al, 47
		mov cx, [x]
		mov dx, [y]
		mov ah, 0ch
		int 10h
		dec [y]
		cmp [y], start_y
		jne draw_right
	
	draw_top:
		mov al, 47
		mov cx, [x]
		mov dx, [y]
		mov ah, 0ch
		int 10h
		dec [x]
		cmp [x], start_x
		jne draw_top

	mov [y], start_y + height
	draw_bottom:
		mov al, 47
		mov cx, [x]
		mov dx, [y]
		mov ah, 0ch
		int 10h
		inc [x]
		cmp [x], start_x + wid
		jne draw_bottom

	pop[y]
	pop[x]
	pop bx
	pop dx
	pop cx
	ret
endp

start:
	mov ax, @data
	mov ds, ax
	
	mov ax, 13h
	int 10h
	
	call draw_character

	mainloop:
		mov ah, 01h
		int 16h
		jz mainloop
		jmp inp
	
	inp:
		call check_arrow
		jmp mainloop

exit:
	mov ax, 4c00h
	int 21h

END start
