#!/bin/bash

# Quick-n-dirty script to turn external/internal displays on/off with xrandr
#
# 2013 by Matthias Schmidt <xhr giessen.ccc.de>
#
# License GNU GPL

# -----------------------------------------------------------------------
# Add your own additional options for xrandr here
# -----------------------------------------------------------------------
XRANDROPTS="--dryrun"
# -----------------------------------------------------------------------


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
    #   ;;
    # -----------------------------------------------------------------------
    *)
      usage
      echo "ERROR: Profile not found"
      exit 1
      ;;
  esac

  # Only enable the internal display
  if [ $IFLAG -eq 1 ]; then
    build_xrandr_string "--auto" "--off"
  # Clone screen on all displays
  elif [ $CFLAG -eq 1 ]; then
    RES=`xrandr -q | egrep "^ *[0-9]*x[0-9]*" | awk {'print $1'} | sort -g -r | uniq -d | head -1`
    build_xrandr_string "--mode $RES" "--same-as $INTERN"
  # Turn internal display off
  elif [ $EFLAG -eq 1 ]; then
    build_xrandr_string "--off" "--auto" "--left-of"
  # Internal on and extend screen on all displays by default
  else
    build_xrandr_string "--auto" "--auto"
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
      CMDEXT="${CMDEXT} --output ${DOEXTERN} --mode ${RES}"
    elif [ ! -z $POSITION ]; then
      # xrandr --output $INTERN --auto --output $EXTERN --auto --right-of $INTERN
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
  echo $CMD
}

function run_xrandr()
{
  exec "$CMD XRANDROPTS"
}

function usage()
{
  echo "$0 [-ceim] [-p profile]"
  echo
  echo " -c           Clone screen on all displays"
  echo " -e           Enable external display(s) and disable internal"
  echo " -i           Enable only the internal display"
  echo " -m           Show all available modes"
  echo
  echo " -p profile   Enable the specified profile"
  echo
  echo "DEFAULT: Extend screen to all displays"
  echo
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

while getopts "ciemp:" opt; do
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
    m)
      exec xrandr -q
      ;;
    p)
      [ ! -z "$OPTARG" ] && PROFILE=$OPTARG
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

if [ $((CFLAG + $IFLAG + $EFLAG)) -gt 1 ]; then
  usage
  echo "Please specify either -c or -e or -i"
  exit 1
fi

choose_profile $PROFILE
run_xrandr

exit $?