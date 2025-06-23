#!/usr/bin/env bash
CUR=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true) | .name')
CURWIND=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused) | "\(.output)"')


if [[ $CURWIND == "eDP-1" ]]; then
  if [[ "$1" == "mnext" ]]; then 
    swaymsg workspace $(swaymsg -t get_workspaces | jq -r '.[] | select(.visible and .output=="HDMI-A-1") | "\(.name)"')
  fi
elif [[ $CURWIND == "HDMI-A-1" ]]; then
  if [[ "$1" == "mprev" ]]; then 
    swaymsg workspace $(swaymsg -t get_workspaces | jq -r '.[] | select(.visible and .output=="eDP-1") | "\(.name)"')
  fi
fi
if [[ "$1" == "next" ]]; then 
  swaymsg workspace $((CUR+1))
elif [[ "$1" == "prev" ]]; then
  swaymsg workspace $((CUR-1))
fi

if [[ "$1" == "w" ]]; then 
  echo $CURWIND 
fi
if [[ "$1" == "c" ]]; then 
  echo $CUR 
fi

