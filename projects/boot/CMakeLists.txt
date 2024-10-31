# Set the path to the NASM compiler
set(CMAKE_ASM_NASM_COMPILER "nasm")

# Add a custom command to compile the bootloader
add_custom_target(boot ALL
    
    COMMAND ${CMAKE_ASM_NASM_COMPILER} -f bin -o ${CMAKE_BINARY_DIR}/boot.bin ${CMAKE_SOURCE_DIR}/projects/boot/boot.asm
    DEPENDS ${CMAKE_SOURCE_DIR}/projects/boot/boot.asm
    COMMENT "Building boot.bin"
)