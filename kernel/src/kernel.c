#include <stdint.h>
#include <stddef.h>
#include <stdarg.h>
#include <lunarForge/lunar.h>

void _kstart(multiboot_info_t* mboot_info){
    mb_info = mboot_info;

    while(1);
}

