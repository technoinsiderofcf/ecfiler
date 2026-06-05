.intel_syntax noprefix
.global _start

_start:
    mov eax, 1      # System call for exit
    mov ebx, 0      # Return 0
    int 0x80        # Interrupt to execute
