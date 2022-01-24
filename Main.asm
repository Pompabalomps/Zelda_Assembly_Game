IDEAL

MODEL small

STACK 512

start_x equ 30
start_y equ 30
height equ 20
wid equ 20
x_speed equ 10
y_speed equ 10

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
	cmp al, 77h
	je up
	cmp al, 61h
	je left
	cmp al, 73h
	je down
	cmp al, 64h
	je right
	jne con

	up:
		call clean_screen
		sub [y], y_speed
		call draw_character

		jmp con
	left:
		call clean_screen
		sub [x], x_speed
		call draw_character

		jmp con
	down:
		call clean_screen
		add	[y], y_speed
		call draw_character

		jmp con
	right:
		call clean_screen
		add [x], x_speed
		call draw_character

		jmp con

	con:

	pop ax
	ret
endp

proc clean_screen
	push ax
	push bx
	push cx
	push dx

	mov bx, 0
	mov al, 0
	mov [curr_x], 0
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

	pop dx
	pop cx
	pop bx
	pop ax
	ret
endp

proc draw_y_line
	push ax
	push bx
	push cx
	push dx

	mov al, 47
	mov ah, 0ch
	mov bx, [y]
	add bx, height
	move_down:
		mov cx, [x]
		mov dx, [y]
		int 10h
		inc [y]
		cmp [y], bx
		jne move_down


	pop dx
	pop cx
	pop bx
	pop ax
	ret
endp

proc draw_x_line
	push ax
	push bx
	push cx
	push dx

	mov al, 47
	mov ah, 0ch
	mov bx, [x]
	add bx, wid
	move_right:
		mov cx, [x]
		mov dx, [y]
		int 10h
		inc [x]
		cmp [x], bx
		jne move_right


	pop dx
	pop cx
	pop bx
	pop ax
	ret
endp

proc draw_character
	push [x]
	push [y]
	call draw_y_line
	add [x], wid
	sub [y], height
	call draw_y_line
	sub [x], wid
	sub [y], height
	call draw_x_line
	sub [x], wid
	add [y], height
	call draw_x_line
	mov al, 47
	mov ah, 0ch
	mov cx, [x]
	mov dx, [y]
	int 10h
	pop [y]
	pop [x]
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
		mov ah, 08h
		int 21h
		jmp mainloop

exit:
	mov ax, 4c00h
	int 21h

END start
