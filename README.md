# dtoggle

Small bash script that uses `xrandr` to configure internal/external displays.  I use it here with BSD and Linux and i3 whenever I connect one or more external displays.

I use the toggle option with the `XF86Display` key (Fn + F7) on my Thinkpad:

```
bindsym XF86Display exec "~/Documents/bin/dtoggle -t"
```

## Usage Scenarios

### Connected to a projector

You connect your laptop to a projector and you do not have (the time to cerate) a profile. Just use the -t option to switch between all displays options on all connected displays.

```
dtoggle -t
```

### Switch between the laptop display and a docking station with connected displays

Add a profile named *foo* and use -p foo once you dock in or out.

```
dtoggle -p foo -e
```

## Config File

dtoggle can read the to be used profile from a config file in `$HOME/.dtoggle.conf`.  If the config file is not present you have to specify the profile using the -p option.  The file looks as follows:

```
# Set your desired profile here
PROFILE=home
```

## Command Line Options

```
dtoggle [-ceix] [-hmntv] [-lr] -p profile

Display Options:
 -c           Clone screen on all displays
 -e           Enable external display(s) and disable internal
 -i           Enable only the internal display
 -x           Extend screen to all displays [default]

General Options:
 -h           Show this help
 -m           Show all available modes
 -n           Dry run. Do not run xrand.  Implies -v
 -t           Toggle different options"
 -v           Be more verbose

Position:
 -l           Display n is left of display (n+1)
 -r           Display n is right of display (n+1) [default]

Profile:
 -p profile   Enable the specified profile
```

## Add a new Profile

1. Clone the repository and copy dtoggle to a location in your `$PATH`
2. Open the file in a text editor, look for the `choose_profile()` function and change the profiles to your needs or add new ones.  I included my profiles for home, work and projector.  In order to get the names of the displays, connect them and run `dtoggle -m`. Look for the strings that say "connected". Add the name of your internal display to `INTERN` and all names of your external displays to `EXTERN[0]` up to `EXTERN[n]`. Note: The order of the entries is important, i.e. entry number n is either left of right (depending on the option) of number (n+1)!

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

3. Check the command line options with `dtoggle -h` and enjoy.

## Bugs

None.  Nevertheless, I you find something annoying, send me an email.

## License

ISC

## Author

Matthias Schmidt (xhr giessen.ccc.de)
