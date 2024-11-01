[bits 16]


    jmp EnterProtectedMode

 

%include 'gdt.asm'

EnterProtectedMode:
    call EnableA20
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
    mov ax, dataseg
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