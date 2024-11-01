DiskReadErrorString: db "Error reading disk", ENDL, 0
BOOT_DISK: db 0
LOADER_SPACE: equ 0x7e00

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
