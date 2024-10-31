cmake_minimum_required(VERSION 3.28)
project(Megos VERSION 0.1.0 LANGUAGES C CXX ASM_NASM)
enable_language(ASM_NASM)
set(CMAKE_BUILD_TYPE Debug)
include_directories(./include)


add_subdirectory(projects)

add_custom_target(qemu
    COMMAND cp ${CMAKE_BINARY_DIR}/bootloader.bin ${CMAKE_BINARY_DIR}/../megos.bin
    COMMAND qemu-system-i386 -drive file=${CMAKE_BINARY_DIR}/../megos.bin,format=raw
    DEPENDS bootloader
)