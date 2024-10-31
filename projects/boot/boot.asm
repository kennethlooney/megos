[org 0x7c00]
[bits 16]

mov ah, 0x0e
mov al, 'H'
int 0x10
mov al, 'e'
int 0x10
mov al, 'l'
int 0x10
mov al, 'l'
int 0x10
mov al, 'o'
int 0x10


jmp $

times 510-($-$$) db 0
dw 0xAA55