dtoggle
=======

Quick-n-dirty hack to use xrandr to configure internal/external displays

Usage
-----

```
dtoogle.sh [-ceix] [-mnv] [-lr] -p profile

Display Options:
 -c           Clone screen on all displays
 -e           Enable external display(s) and disable internal
 -i           Enable only the internal display
 -x           Extend screen to all displays [default]

General Options:
 -m           Show all available modes
 -n           Dry run. Do not run xrand.  Implies -v
 -v           Be more verbose

Position:
 -l           Display n is left of display (n+1)
 -r           Display n is right of display (n+1) [default]

Profile:
 -p profile   Enable the specified profile
```
