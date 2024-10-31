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

    jmp codeseg:StartProtectedMode

EnableA20:
    in al, 0x92
    or al, 2
    out 0x92, al
    ret

[bits 32]
%include 'cpuid.asm'
%include 'simplepaging.asm'
StartProtectedMode:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    
    call DetectCPUID
    call DetectLongMode
    call SetupIdentityPaging
    call EditGDT
    jmp codeseg:Start64Bit


 [bits 64]
 Start64Bit:
    mov edi, 0xb8000
    mov rax, 0x1f201f201f201f20
    mov ecx, 500
    rep stosq
    jmp $

 
 
times 2048-($-$$) db 0

 