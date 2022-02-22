IDEAL

MODEL small

STACK 512

start_x equ 30
start_y equ 30
start_npc_1_x equ 100
start_npc_1_y equ 30
npc_1_max_y equ 120
npc_1_min_y equ 30
start_npc_2_x equ 30
start_npc_2_y equ 80
npc_2_max_x equ 250
npc_2_min_x equ 30
start_npc_3_x equ 200
start_npc_3_y equ 50
npc_3_max_y equ 180
npc_3_min_y equ 20
npc_height equ 20
npc_wid equ 20
height equ 20
wid equ 20
x_speed equ 10
y_speed equ 10
border_left equ 0
border_right equ 320 - wid - 1
border_up equ 0
border_down equ 200 - height - 1

DATASEG

x dw start_x
y dw start_y
player_color db 47
npc_color db 40
npc_1_x dw start_npc_1_x
npc_1_y dw start_npc_1_y
npc_1_dir db 1
npc_2_x dw start_npc_2_x
npc_2_y dw start_npc_2_y
npc_2_dir db 1
npc_3_x dw start_npc_3_x
npc_3_y dw start_npc_3_y
npc_3_dir db 1
npc_x dw start_npc_1_x
npc_y dw start_npc_1_y
curr_x dw 0

CODESEG

proc check_arrow
	push ax
	push bx
	cmp al, 77h
	je up
	cmp al, 61h
	je left
	cmp al, 73h
	je jump_down
	cmp al, 64h
	je jump_right
	jne check_arrow_con_mid_1

	up:
		mov bx, [y]
		sub bx, y_speed
		cmp bx, border_up
		jl reset_up

		call clean_player
		sub [y], y_speed
		call draw_characters

	check_arrow_con_mid_1:
		jmp check_arrow_con_mid_2

	reset_up:
		call clean_player
		mov [y], border_up
		call draw_characters
		jmp check_arrow_con_mid_1

	left:
		mov bx, [x]
		sub bx, x_speed
		cmp bx, border_left
		jl reset_left

		call clean_player
		sub [x], x_speed
		call draw_characters

	check_arrow_con_mid_2:
		jmp check_arrow_con_mid_3

	jump_down:
		jmp down

	jump_right:
		jmp right

	reset_left:
		call clean_player
		mov [x], border_left
		call draw_characters
		jmp check_arrow_con_mid_2

	down:
		mov bx, [y]
		add bx, y_speed
		cmp bx, border_down
		jg reset_down

		call clean_player
		add	[y], y_speed
		call draw_characters

	check_arrow_con_mid_3:
		jmp check_arrow_con_mid_4

	reset_down:
		call clean_player
		mov [y], border_down
		call draw_characters
		jmp check_arrow_con_mid_3
	
	right:
		mov bx, [x]
		add bx, x_speed
		cmp bx, border_right
		jg reset_right

		call clean_player
		add [x], x_speed
		call draw_characters

	check_arrow_con_mid_4:
		jmp check_arrow_con

	reset_right:
		call clean_player
		mov [x], border_right
		call draw_characters
		jmp check_arrow_con_mid_4

	check_arrow_con:

	pop bx
	pop ax
	ret
endp

proc clean_player
	push ax

	mov al, [player_color]
	push ax
	mov [player_color], 0
	call draw_player
	pop ax
	mov [player_color], al

	pop ax
	ret
endp

proc clean_npc
	mov bl, [npc_color]
	push bx
	mov [npc_color], 0
	call draw_npc
	pop bx
	mov [npc_color], bl
	ret
endp

proc draw_npc_x_line
	push ax
	push bx
	push cx
	push dx

	mov al, [npc_color]
	mov ah, 0ch
	mov bx, [npc_x]
	add bx, npc_wid
	move_right_npc:
		mov cx, [npc_x]
		mov dx, [npc_y]
		int 10h
		inc [npc_x]
		cmp [npc_x], bx
		jne move_right_npc

	pop dx
	pop cx
	pop bx
	pop ax
	ret
endp

proc draw_npc_y_line
	push ax
	push bx
	push cx
	push dx

	mov al, [npc_color]
	mov ah, 0ch
	mov bx, [npc_y]
	add bx, npc_height
	move_down_npc:
		mov cx, [npc_x]
		mov dx, [npc_y]
		int 10h
		inc [npc_y]
		cmp [npc_y], bx
		jne move_down_npc


	pop dx
	pop cx
	pop bx
	pop ax
	ret
endp

proc draw_npc
	push [npc_x]
	push [npc_y]
	call draw_npc_y_line
	add [npc_x], npc_wid
	sub [npc_y], npc_height
	call draw_npc_y_line
	sub [npc_x], npc_wid
	sub [npc_y], npc_height
	call draw_npc_x_line
	sub [npc_x], npc_wid
	add [npc_y], npc_height
	call draw_npc_x_line
	mov al, [npc_color]
	mov ah, 0ch
	mov cx, [npc_x]
	mov dx, [npc_y]
	int 10h
	pop [npc_y]
	pop [npc_x]
	ret
endp

proc switch_npc
	push ax
	push bx
	push cx
	cmp ax, 2
	je npc_2
	jl npc_1
	jg npc_3

	npc_1:
		mov bx, [npc_1_x]
		mov cx, [npc_1_y]
		mov [npc_x], bx
		mov [npc_y], cx

		jmp switch_npc_con

	npc_2:
		mov bx, [npc_2_x]
		mov cx, [npc_2_y]
		mov [npc_x], bx
		mov [npc_y], cx

		jmp switch_npc_con
	
	npc_3:
		mov bx, [npc_3_x]
		mov cx, [npc_3_y]
		mov [npc_x], bx
		mov [npc_y], cx

		jmp switch_npc_con

	switch_npc_con:

	pop cx
	pop bx
	pop ax
	ret
endp

proc move_npc
	push ax
	cmp ax, 2
	jl move_npc_1
	je move_npc_2
	jg move_npc_3

	move_npc_1:
		cmp [npc_1_dir], 1
		je move_npc_1_down
		jmp move_npc_1_up
		move_npc_1_down:
			cmp [npc_1_y], npc_1_max_y
			je reached_max_npc_1_down
			jmp move_npc_1_down_con
			
			reached_max_npc_1_down:
				mov [npc_1_dir], 0
				dec [npc_1_y]
				jmp move_npc_con

			move_npc_1_down_con:
				inc [npc_1_y]
				jmp move_npc_con
		
		move_npc_1_up:
			cmp [npc_1_y], npc_1_min_y
			je reached_max_npc_1_up
			jmp move_npc_1_up_con

			reached_max_npc_1_up:
				mov [npc_1_dir], 1
				inc [npc_1_y]
				jmp move_npc_con

			move_npc_1_up_con:
				dec [npc_1_y]
				jmp move_npc_con

	move_npc_2:

	move_npc_3:
		cmp [npc_3_dir], 1
		je move_npc_3_down
		jmp move_npc_3_up
		move_npc_3_down:
			cmp [npc_3_y], npc_3_max_y
			je reached_max_npc_3_down
			jmp move_npc_3_down_con
			
			reached_max_npc_3_down:
				mov [npc_3_dir], 0
				dec [npc_3_y]
				jmp move_npc_con

			move_npc_3_down_con:
				inc [npc_3_y]
				jmp move_npc_con
		
		move_npc_3_up:
			cmp [npc_3_y], npc_3_min_y
			je reached_max_npc_3_up
			jmp move_npc_3_up_con

			reached_max_npc_3_up:
				mov [npc_3_dir], 1
				inc [npc_3_y]
				jmp move_npc_con

			move_npc_3_up_con:
				dec [npc_3_y]
				jmp move_npc_con


	move_npc_con:

	pop ax 
	ret
endp

proc draw_player_x_line
	push ax
	push bx
	push cx
	push dx

	mov al, [player_color]
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

proc draw_player_y_line
	push ax
	push bx
	push cx
	push dx

	mov al, [player_color]
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

proc draw_player
	push [x]
	push [y]
	call draw_player_y_line
	add [x], wid
	sub [y], height
	call draw_player_y_line
	sub [x], wid
	sub [y], height
	call draw_player_x_line
	sub [x], wid
	add [y], height
	call draw_player_x_line
	mov al, [player_color]
	mov ah, 0ch
	mov cx, [x]
	mov dx, [y]
	int 10h
	pop [y]
	pop [x]
	ret
endp

proc draw_characters
	mov ax, 1
	call switch_npc
	call clean_npc
	call draw_npc
	mov ax, 2
	call switch_npc
	call clean_npc
	call draw_npc
	mov ax, 3
	call switch_npc
	call clean_npc
	call draw_npc
	call draw_player
	ret
endp

start:
	mov ax, @data
	mov ds, ax
	
	mov ax, 13h
	int 10h
	
	call draw_characters

	mainloop:
		mov ax, 1
		call switch_npc
		call move_npc
		call clean_npc
		mov ax, 2
		call switch_npc
		call move_npc
		call clean_npc
		mov ax, 3
		call switch_npc
		call move_npc
		call clean_npc
		call draw_characters
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
