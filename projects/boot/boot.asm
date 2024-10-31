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

     
   

    mov [BOOT_DISK], dl
    call read_disk

    jmp LOADER_SPACE
    

    ; Infinite loop to halt the program
    jmp $



read_disk:
    mov ah, 0x02
    mov al, 4      ; number of sectors to read  
    mov dl, [BOOT_DISK]          
    mov ch, 0
    mov dh, 0
    mov cl, 2
    mov bx, LOADER_SPACE
    int 0x13
    jc disk_error
    ret 

wait_for_key:
    mov ah, 0
    int 0x16
    ret

reboot:
    jmp 0xFFFF:0x0000
     
    
print_string:
    pusha              ; Save registers
    mov ah, 0x0e       ; BIOS teletype function
.next_char:
    lodsb              ; Load next byte from string into AL
    cmp al, 0          ; Check if end of string (null terminator)
    je .done           ; If end of string, jump to done
    int 0x10           ; Print character in AL
    jmp .next_char     ; Repeat for next character
.done:
    popa               ; Restore registers
    ret
    
disk_error:
    mov si, DiskReadErrorString
    call print_string
    mov si, PressKeyString
    call print_string
    call wait_for_key
    call reboot
    jmp $

TestString: db "This is a test string", ENDL, 0
PressKeyString: db "Press any key to reboot", ENDL, 0
DiskReadErrorString: db "Error reading disk", ENDL, 0
BOOT_DISK: db 0
LOADER_SPACE: equ 0x7e00


times 510-($-$$) db 0
dw 0xAA55