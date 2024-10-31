[org 0x7e00]
[bits 16]

%define ENDL 0x0A, 0x0D
start:
  ; clear the screen
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    jmp EnterProtectedMode

%include 'print.asm'
%include 'gdt.asm'
EnterProtectedMode:
    call EnableA20      ; Enable A20 line
    cli                 ; Disable interrupts
    lgdt [gdt_descriptor] ; Load GDT
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp $

EnableA20:
    in al, 0x92
    or al, 2
    out 0x92, al
    ret
times 2048-($-$$) db 0
 