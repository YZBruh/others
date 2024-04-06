/* By YZBruh */

/* in some cases, the compiler is set to c++ std mode. and this must be prevented. after all, this structure is c code */
#ifdef __cplusplus
extern "C" {
#endif

/* check compiler system */
#ifdef _WIN32
    #error "it can only be compiled in linux or android environment. but current system windows"
#elif ! __linux__ || __android__
    #error "unknown compiler system founded"
#endif

/* compiler architecture if arm is not 32-bit or 64-bit, the compilation is stopped */
#if ! defined __aarch64__ || __aarch32__ || __armv8__ || __armv7l__
    #error "only 32-bit or 64-bit arm compilers can be used"
#endif

/* the required libraries are included... their sources are located in the include directory, which is located in the root directory (that is, if you add your own headers to that directory, you can use it as an internal library :) */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <errno.h>

/* the unsigned integer required to handle the error count must be added outside the loops */
uint32_t error_repeated = 0;

/* the actual handler that adjusts the brightness */
void set_bright(uint32_t brightness_level) {
    /* /sys/class/leds/lcd-backlight/brightness opening*/
    FILE *sys_control = fopen("/sys/class/leds/lcd-backlight/brightness", "w");

    /* if it is opened successfully, the process is continued */
    if (sys_control != NULL) {
        fprintf(sys_control, "%d", brightness_level);
        fclose(sys_control);
    /* but if it cannot be opened, the error handlers are started */
    } else {
        /* access to the error file is made */
        FILE *err_header = fopen("/sdcard/brightness_err", "w");

        /* no error = continue */
        if (err_header != NULL) {
            error_repeated++;

            /* if the error number is 25 or higher, the output is made, which is already this service /system/etc/init/hw/init.since you will add it to rc with oneshot, it will not run anymore (at least I am adding it with oneshot, that's my suggestion) */
            if (error_repeated >= 25) {
                exit(EXIT_FAILURE);
            /* write error in error file */
            } else {
                fprintf(err_header, "brightness_control: error: %s\n", strerror(errno));
                fclose(err_header);
            }
        /* error = stop */
        } else {
            fprintf(stderr, "brightness_control: error file cannot be checked: %s\n", strerror(errno));
            exit(EXIT_FAILURE);
        }
    }
}

int main() {
    /* generate loop */
    while (1) {
        /* get current time info */
        time_t current_time;
        struct tm *time_info;
        time(&current_time);
        time_info = localtime(&current_time);
        uint32_t hour = time_info->tm_hour;

        /* brightness is adjusted according to the time. it's already clear what happened */
        if (hour == 6 || hour == 7 || hour == 8 || hour == 9 || hour == 10 || hour == 11 || hour == 12) {
            set_bright(3500);
        } else if (hour == 13 || hour == 14 || hour == 15 || hour == 16 || hour == 17 || hour == 18) {
            set_bright(1500);
        } else if (hour >= 19) {
            set_bright(750);
        } else if (hour <= 5 && hour > 0) {
            set_bright(650);
        } else {
            set_bright(2100);
        }

        sleep(60);
    }

    /* if it happens (impossible), if the cycle ends, the exit is made */
    exit(EXIT_SUCCESS);
}

#ifdef __cplusplus
}
#endif

/* end... */
