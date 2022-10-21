#!/bin/bash

XRESOURCES_PATH="$HOME/.Xresources"

#Exit on any command fail
set -e
#Even in subshells!
shopt -s inherit_errexit

if [ ! -f $1 ]; then
	echo "You must provide a color scheme yaml file as an argument"
	exit 1
fi

function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

function get_color {
	local color_name=$1
	local value=$(echo "$theme" | grep "$color_name")
	[ -z "$value" ] && >&2 echo "Color $color_name was not found in the config file!" && exit 1
	echo "$value" | sed -Ee 's|.*="(.*)"|\1|' -e 's|^0x|#|'
}

function replace_color_in_xresources {
	local col_prefix="$1"
	local col_value="$2"
	local original_line=$(grep -iE "^\\$col_prefix" "$XRESOURCES_PATH" 2>/dev/null)
	echo "$original_line" "=> $col_prefix $col_value"
	sed -iE "s|^\\$col_prefix.*$|$col_prefix $col_value|" "$XRESOURCES_PATH"
}


theme=$(parse_yaml $1)

background=("*background:" "$(get_color "primary_background" >&1)")
foreground=("*foreground:" "$(get_color "primary_foreground" >&1)")

col0=("*color0:" "$(get_color "normal_black" >&1)")
col1=("*color1:" "$(get_color "normal_blue" >&1)")
col2=("*color2:" "$(get_color "normal_green" >&1)")
col3=("*color3:" "$(get_color "normal_cyan" >&1)")
col4=("*color4:" "$(get_color "normal_red" >&1)")
col5=("*color5:" "$(get_color "normal_magenta" >&1)")
col6=("*color6:" "$(get_color "normal_yellow" >&1)")
col7=("*color7:" "$(get_color "normal_white" >&1)")

col8=("*color8:" "$(get_color "bright_black" >&1)")
col9=("*color9:" "$(get_color "bright_blue" >&1)")
col10=("*color10:" "$(get_color "bright_green" >&1)")
col11=("*color11:" "$(get_color "bright_cyan" >&1)")
col12=("*color12:" "$(get_color "bright_red" >&1)")
col13=("*color13:" "$(get_color "bright_magenta" >&1)")
col14=("*color14:" "$(get_color "bright_yellow" >&1)")
col15=("*color15:" "$(get_color "bright_white" >&1)")

replace_color_in_xresources "${background[@]}"
replace_color_in_xresources "${foreground[@]}"
replace_color_in_xresources "${col0[@]}"
replace_color_in_xresources "${col1[@]}"
replace_color_in_xresources "${col2[@]}"
replace_color_in_xresources "${col3[@]}"
replace_color_in_xresources "${col4[@]}"
replace_color_in_xresources "${col5[@]}"
replace_color_in_xresources "${col6[@]}"
replace_color_in_xresources "${col7[@]}"
replace_color_in_xresources "${col8[@]}"
replace_color_in_xresources "${col9[@]}"
replace_color_in_xresources "${col10[@]}"
replace_color_in_xresources "${col11[@]}"
replace_color_in_xresources "${col12[@]}"
replace_color_in_xresources "${col13[@]}"
replace_color_in_xresources "${col14[@]}"
replace_color_in_xresources "${col15[@]}"

xrdb -load "$XRESOURCES_PATH"

echo "...done!"

