[org 0x7c00]
[bits 16]

%define ENDL 0x0A, 0x0D
start:
    ; setup data segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax
    ; setup stack
    mov ss, ax
    mov sp, 0x7c00

     
     ; clear the screen
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    mov [BOOT_DISK], dl
    call read_disk

    mov si, PressKeyContinueString
    call print_string
    call wait_for_key

    jmp LOADER_SPACE
    

wait_for_key:
    mov ah, 0
    int 0x16
    ret

reboot:
    jmp 0xFFFF:0x0000
     
    
%include 'print.asm'
%include 'readdisk.asm'

disk_error:
    mov si, DiskReadErrorString
    call print_string
    mov si, PressKeyString
    call print_string
    call wait_for_key
    call reboot
    jmp $

TestString: db "Initializing startup..", ENDL, ENDL, 0
PressKeyString: db "Press any key to reboot", ENDL, 0
PressKeyContinueString: db "Welcome to megOS!", ENDL,ENDL,"Press any key to start the demo..", ENDL, 0



times 510-($-$$) db 0
dw 0xAA55