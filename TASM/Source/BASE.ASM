;------------------------------------------
; PURPOSE : Test number 1 
; SYSTEM  : Turbo Assembler Ideal Mode  
; AUTHOR  :  
;------------------------------------------

		IDEAL
		
		MODEL small

		STACK 256

		DATASEG

		
		CODESEG
Start:
        mov ax, @data
        mov ds, ax

Exit:
        mov ax, 4C00h
        int 21h
		END start
