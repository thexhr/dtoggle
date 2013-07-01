dtoggle
=======

Small bash script that uses xrandr to configure internal/external displays.  I use it here with Arch Linux and i3 whenever I connect one or more external displays2

Command Line Options
--------------------

```
dtoogle.sh [-ceix] [-hmnv] [-lr] -p profile

Display Options:
 -c           Clone screen on all displays
 -e           Enable external display(s) and disable internal
 -i           Enable only the internal display
 -x           Extend screen to all displays [default]

General Options:
 -h 		  Show this help
 -m           Show all available modes
 -n           Dry run. Do not run xrand.  Implies -v
 -v           Be more verbose

Position:
 -l           Display n is left of display (n+1)
 -r           Display n is right of display (n+1) [default]

Profile:
 -p profile   Enable the specified profile
```

Usage
-----

1. Clone the repository and copy dtoogle to a location in your `$PATH`
2. Open the file in a text editor, look for the `choose_profile()` function and change the profiles to your needs or add new ones.  I included my profiles for home, work and projector.  In order to get the names of the displays, connect them and run `dtoogle -m`. Look for the strings that say "connected". Add the name of your internal display to `INTERN` and all names of your external displays to `EXTERN[0]` up to `EXTERN[n]`. Note: The order of the extries is important, i.e. entry number n is either left of right (depending on the option) of number (n+1)!

```bash
function choose_profile()
{
  [...]
  case "$PROFILE" in
    # Home profile: Internal on, external extended
    home)
      INTERN="LVDS1"
      EXTERN[0]="HDMI1"
      ;;
    [...]
    # -----------------------------------------------------------------------
    # Add your own profiles here.
    # -----------------------------------------------------------------------
    # name)
    #   INTERN="LVDS1"
    #   EXTERN[0]="VGA1"
    #   ...
    #   EXTERN[n]="VGAn"
    #   ;;
    # -----------------------------------------------------------------------
```
3. Check the command line options with `dtoogle -h` and enjoy.

Bugs
----

None.  Nevertheless, I you find something annoying, send me an email.

License
-------

GNU GPL.

Author
------

Matthias Schmidt <xhr giessen.ccc.de>
