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