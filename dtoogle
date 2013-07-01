#!/bin/bash

# Quick-n-dirty script to turn external/internal displays on/off with xrandr
#
# 2013 by Matthias Schmidt <xhr giessen.ccc.de>
#
# License GNU GPL

function choose_profile()
{
  local PROFILE=$1

  case "$PROFILE" in
    # Home profile: Internal on, external extended
    home)
      INTERN="LVDS1"
      EXTERN[0]="HDMI1"
      ;;
    # Work profile: Internal off, both external displays on
    work)
      INTERN="LVDS1"
      EXTERN[0]="HDMI3"
      EXTERN[1]="HDMI2"
      ;;
    # Projector profile: Internal on, external VGA extended
    vga)
      INTERN="LVDS1"
      EXTERN[0]="VGA1"
      ;;
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
    *)
      usage
      pr "Profile $PROFILE not found"
      exit 1
      ;;
  esac

  # Only enable the internal display
  if [ $IFLAG -eq 1 ]; then
    build_xrandr_string "--auto" "--off"
  # Clone screen on all displays
  elif [ $CFLAG -eq 1 ]; then
    RES=`xrandr -q | egrep "^ *[0-9]*x[0-9]*" | awk {'print $1'} | sort | uniq -d | head -1`
    build_xrandr_string "--mode $RES" "--same-as $INTERN"
  # Turn internal display off
  elif [ $EFLAG -eq 1 ]; then
    if [ $RIGHTOF -eq 1 ]; then
      build_xrandr_string "--off" "--auto" "--right-of"
    else
      build_xrandr_string "--off" "--auto" "--left-of"
    fi
  # Internal on and extend screen on all displays by default
  else
    build_xrandr_string "--auto" "--auto" "--right-of"
  fi
}

function build_xrandr_string()
{
  local DOINTERN=$1
  local DOEXTERN=$2
  local POSITION=$3

  CMD="xrandr --output $INTERN $DOINTERN "

  CMDEXT=
  i=0
  for d in ${EXTERN[*]}; do
    if [ $CFLAG -eq 1 ]; then
      CMDEXT="${CMDEXT} --output $d ${DOEXTERN} --mode ${RES}"
    elif [ ! -z $POSITION ]; then
      if [ $i -eq 0 ]; then
        CMDEXT="${CMDEXT} --output $d ${DOEXTERN} ${POSITION} $INTERN"
      else
        CMDEXT="${CMDEXT} --output $d ${DOEXTERN} ${POSITION} ${EXTERN[i-1]}"
      fi
    else
      CMDEXT="${CMDEXT} --output $d ${DOEXTERN} ${POSITION}"
    fi
    i=$(($i + 1))
  done

  CMD="$CMD $CMDEXT"
  [ $VERBOSE -eq 1 ] && {
    echo "I'll run the following command:" 
    pg "$CMD"
  }
}

function run_xrandr()
{
  echo "$CMD $XRANDROPTS" | sh
}

function usage()
{
  echo "`basename $0` [-ceix] [-hmnv] [-lr] -p profile"
  echo
  echo "Display Options:"
  echo " -c           Clone screen on all displays"
  echo " -e           Enable external display(s) and disable internal"
  echo " -i           Enable only the internal display"
  echo -n " -x           Extend screen to all displays "
  pg "[default]"
  echo
  echo "General Options:"
  echo " -h           Show this help"
  echo " -m           Show all available modes"
  echo " -n           Dry run. Do not run xrand.  Implies -v"
  echo " -v           Be more verbose"
  echo
  echo "Position:"
  echo " -l           Display n is left of display (n+1)"
  echo -n " -r           Display n is right of display (n+1) "
  pg "[default]"
  echo
  echo "Profile:"
  echo " -p profile   Enable the specified profile"
  echo
}

RED='\e[0;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
NC="\e[0;37;40m"

function pg()
{
  echo -e "${GREEN}${1}${NC}"
}

function pr()
{
  echo -e "${RED}${1}${NC}"
}

CMD=
PROFILE=
INTERN=
RES=
EXTERN[0]=
EXTERN[1]=
EXTERN[2]=
EXTERN[3]=

# Clone screen on all displays
CFLAG=0
# Enable only external displays
EFLAG=0
# Enable only the internal display
IFLAG=0
# Verbosity
VERBOSE=0
# Display n is right of display (n+1) [default]
RIGHTOF=1
# Additional options for xrandr
XRANDROPTS=""

while getopts "ciehmnrlp:vx" opt; do
  case $opt in
    c)
      CFLAG=1
      ;;
    i)
      IFLAG=1
      ;;
    e)
      EFLAG=1
      ;;
    v)
      VERBOSE=1
      ;;
    n)
      XRANDROPTS="--dryrun"
      VERBOSE=1
      ;;
    r)
      RIGHTOF=1
      ;;
    l)
      RIGHTOF=0
      ;;
    m)
      exec xrandr -q
      ;;
    x)
      # Do nothing here since its the default
      ;;
    p)
      [ ! -z "$OPTARG" ] && PROFILE=$OPTARG
      ;;
    h)
      usage
      exit 1
      ;;
    *)
      usage
      pr "Option not found"
      exit 1
      ;;
  esac
done

if [ $((CFLAG + $IFLAG + $EFLAG)) -gt 1 ]; then
  usage
  pr "Please specify either -c or -e or -i"
  exit 1
fi

choose_profile $PROFILE
run_xrandr

exit $?
