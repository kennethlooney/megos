gdt_nulldesc:
    dd 0
    dd 0
gdt_codedesc:
    dw 0xFFFF           ; Limit
    dw 0                ; Base  
    db 0                ; Base
    db 10011010b        ; Access byte
    db 11001111b        ; Granularity
    db 0                ; Base 
gdt_datadesc:
    dw 0xFFFF           ; Limit
    dw 0                ; Base
    db 0                ; Base
    db 10010010b        ; Access byte
    db 11001111b        ; Granularity
    db 0                ; Base

gdt_end:
gdt_descriptor:
    dw gdt_end - gdt_nulldesc - 1
    dq gdt_nulldesc

codeseg equ gdt_codedesc - gdt_nulldesc
dataseg equ gdt_datadesc - gdt_nulldesc
 
[bits 32]
EditGDT:
    mov [gdt_codedesc + 6], byte 10101111b
    mov [gdt_codedesc + 6], byte 10101111b
    ret
[bits 16]
