[org 0x7e00]
[bits 16]

%define ENDL 0x0A, 0x0D

start:
    ; clear the screen
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    mov si, TestString
    call print_string
    jmp $ 
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

TestString: db "Booting up..", ENDL, 0
times 2048-($-$$) db 0
 