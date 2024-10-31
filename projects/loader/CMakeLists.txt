# Set the path to the NASM compiler
set(CMAKE_ASM_NASM_COMPILER "nasm")

# Add a custom command to compile the bootloader
add_custom_target(loader ALL
    
    COMMAND ${CMAKE_ASM_NASM_COMPILER} -f bin -o ${CMAKE_BINARY_DIR}/loader.bin ${CMAKE_SOURCE_DIR}/projects/loader/loader.asm
    DEPENDS ${CMAKE_SOURCE_DIR}/projects/loader/loader.asm
    COMMENT "Building loader.bin"
)