bits 64
section .multiboot
align 4

multiboot_header:
    dd 0x1BADB002
    dd 0x04
    dd -(0x1BADB002 + 0x04)
       
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    
    dd 0
    dd 1024
    dd 768
    dd 32

global _start
extern _kstart
_start:
    mov rsp, stack.end
    push rbx
    call _kstart
    pop rbx

    hlt

stack: resb 4096
.end:
