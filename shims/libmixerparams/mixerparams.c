#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>

extern void* mixer_read_event_sec(int32_t* fd_ptr, int32_t mask) {
    if (!fd_ptr) return 0;
    void* buffer = calloc(1, 0x48);
    if (!buffer) return 0;
    ssize_t bytes_read = read(*fd_ptr, buffer, 0x48);
    while (bytes_read > 0) {
        if (*(int32_t*)buffer == 0 && (*((int32_t*)((char*)buffer + 4)) & mask))
            return buffer;
        bytes_read = read(*fd_ptr, buffer, 0x48);
    }

    free(buffer);
    return 0;
}
