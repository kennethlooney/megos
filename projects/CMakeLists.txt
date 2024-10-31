add_subdirectory(boot)
add_subdirectory(loader)

add_custom_target(bootloader ALL
    COMMAND cat ${CMAKE_BINARY_DIR}/boot.bin ${CMAKE_BINARY_DIR}/loader.bin > ${CMAKE_BINARY_DIR}/bootloader.bin
    DEPENDS boot loader
)