IDEAL

MODEL small

STACK 256

DATASEG

CODESEG

Start:
        mov ax,@data
        mov ds,ax

        mov dl, "test"
        mov ah, 02h
        int 21h
Exit:
        mov ax,4C00h
        int 21h
END start