## brightnes_control

What you see is C code. Someone asked me to write about the brightness problem that may occur in GSIs. The current brightness is considered to be 4096. And the brightness control context is specified as `/sys/class/leds/lcd-backlight/brightness`. If it is different for you, you can change it. This is very easy.
Brightness is changed by checking the clock every minute.

#### error handling
If an error occurs, a file named `brightness_err` is created in the `/sdcard` (internal storage) directory. An error is written inside.

#### change guide
For brightness change context, edit:
```
32
33   FILE *sys_control = fopen("/sys/class/leds/lcd-backlight/brightness", "w");
34
```

For example, a modified example:
```
32
33   FILE *sys_control = fopen("/sys/class/backlight/brightness", "w");
34
```

To make changes to the brightness values, edit the following (it's already obvious):
```
74        /* brightness is adjusted according to the time. it's already clear what happened */
75        if (hour == 6 || hour == 7 || hour == 8 || hour == 9 || hour == 10 || hour == 11 || hour == 12) {
76            set_bright(3500);
77        } else if (hour == 13 || hour == 14 || hour == 15 || hour == 16 || hour == 17 || hour == 18) {
78            set_bright(1500);
79        } else if (hour >= 19) {
80            set_bright(750);
81        } else if (hour <= 5 && hour > 0) {
82            set_bright(650);
83        } else {
84            set_bright(2100);
85        }
```

I think it's enough.

#### compiling
To do this you will need an ARM based 32-bit or 64-bit (device dependent) compiler (gcc).
Use Termux or linux to do this (terminal). NOTE: Compilation and architecture checks are available on Windows. Any mismatch during compilation will stop the compilation.

command (don't forget to access the directory where the code is located):
```
gcc -Wall -Wextra -O3 -o brightness_control brightness_control.c
```

If the compilation is finished, a compiled file like this will be created: `brightness_control`

#### apply on gsi image
 - Mount gsi image. Put the compiled file here: `/system/bin`.
 - Continue with the logic above. Open `system/etc/init/hw/init.rc`. And add this code:

`init.rc lines 850-1500`:
```
service brightness_control /system/bin/brightness_control
    class main
    user root
    group root
    oneshot
```

`Add this code to the line after adding the service in init.rc`:
```
on boot
    start brightness_control
```

 - The end can be inserted into an existing `on boot` block.
 - Repack image and flash.
 - Report problems etc. 
