#!/bin/bash

/usr/bin/echo $(/usr/bin/cat /sys/class/backlight/acpi_video0/max_brightness ) > /sys/class/backlight/acpi_video0/brightness
