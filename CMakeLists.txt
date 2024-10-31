cmake_minimum_required(VERSION 3.28)
project(Megos VERSION 0.1.0 LANGUAGES C CXX ASM_NASM)
enable_language(ASM_NASM)

# Set the NASM executable
find_program(NASM_EXECUTABLE nasm)

if(NOT NASM_EXECUTABLE)
    message(FATAL_ERROR "NASM assembler not found")
endif()

# Add custom command to compile boot.asm
add_custom_command(
    OUTPUT boot.bin
    COMMAND ${NASM_EXECUTABLE} -f bin -I ${CMAKE_CURRENT_SOURCE_DIR}/boot ${CMAKE_CURRENT_SOURCE_DIR}/boot/boot.asm -o ${CMAKE_CURRENT_BINARY_DIR}/boot.bin
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/boot/boot.asm ${CMAKE_CURRENT_SOURCE_DIR}/boot/print.asm ${CMAKE_CURRENT_SOURCE_DIR}/boot/readdisk.asm
    COMMENT "Assembling boot.asm"
)
add_custom_command(
    OUTPUT loader.bin
    COMMAND ${NASM_EXECUTABLE} -f bin -I ${CMAKE_CURRENT_SOURCE_DIR}/boot ${CMAKE_CURRENT_SOURCE_DIR}/boot/loader.asm -o ${CMAKE_CURRENT_BINARY_DIR}/loader.bin
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/boot/loader.asm ${CMAKE_CURRENT_SOURCE_DIR}/boot/print.asm ${CMAKE_CURRENT_SOURCE_DIR}/boot/readdisk.asm ${CMAKE_CURRENT_SOURCE_DIR}/boot/cpuid.asm ${CMAKE_CURRENT_SOURCE_DIR}/boot/simplepaging.asm
    COMMENT "Assembling loader.asm"
)
# Add custom target that depends on the output of the custom command
add_custom_target(bootloader ALL DEPENDS boot.bin loader.bin
    COMMAND cat ${CMAKE_BINARY_DIR}/boot.bin ${CMAKE_BINARY_DIR}/loader.bin > ${CMAKE_BINARY_DIR}/bootloader.bin
) 

add_custom_target(image
    COMMAND cat ${CMAKE_BINARY_DIR}/bootloader.bin > ${CMAKE_BINARY_DIR}/../megos.bin
    COMMAND qemu-system-x86_64 -drive file=${CMAKE_BINARY_DIR}/../megos.bin,format=raw
    DEPENDS bootloader
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)