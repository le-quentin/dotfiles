#!/bin/bash

EXPORT_TO_XRESOURCES_SCRIPT="$HOME/.config/alacritty/export-to-xresources.sh"
ALACRITTY_THEME_DIR="$HOME/.config/alacritty/themes"
ALACRITTY_CONFIG_FILE="$HOME/.config/alacritty/alacritty.yml"

#Exit on any command fail
set -e
#Even in subshells!
shopt -s inherit_errexit

HELP="
Usage: $0 [OPTION]... [THEME_NAME]
Change the theme for Alacritty, by updating the Alacritty config in ~/.config/Alacritty. THEME_NAME is the name of the yml file (without extention) containing the colour scheme, expected in ~/.config/alacritty/themes

Optional arguments:
  -x, --xresources		export the color theme to ~/.Xresources(it is advised to back it up before first run)
  -r, --restart			restart i3
"

# Exit and print help
function exit_with_error {
	error_string=$1
	echo "$0: $1" 
	echo "$HELP"
	exit 1
}

function unrecognized_option {
	exit_with_error "unrecognized option '$1'"
}

############################## Arguments parsing
EXPORT_TO_XRESOURCES=""
RESTART=""
THEME_NAME=""

POSITIONAL_ARGS=()

# Transform long options to short ones
for arg in "$@"; do
  shift
  case "$arg" in
    '--help')   set -- "$@" '-h'   ;;
    '--xresources') set -- "$@" '-x'   ;;
    '--restart')   set -- "$@" '-r'   ;;
    *)          set -- "$@" "$arg" ;;
  esac
done

# Parse - short options with getopts
while getopts ":xrh" opt_name; do
  case "$opt_name" in
    x) EXPORT_TO_XRESOURCES='true' ;;
    r) RESTART='true' ;;
    h) echo "$HELP" ;;
    *) unrecognized_option "$1" ;;
  esac
done
shift $(($OPTIND - 1))

# The remaining arguments are positional arguments
if [ $# = 0 ]; then
	exit_with_error "You must provide an Alacritty theme name"
fi
if [ $# -gt 1 ]; then
	exit_with_error "Too many arguments"
fi
THEME_NAME="$1"

############################## Script begin

function get_existing_theme_line {
	set +e
	line=$(grep "^ *- *$ALACRITTY_THEME_DIR" "$ALACRITTY_CONFIG_FILE")
	[ -z "$line" ] && search=$(echo "$ALACRITTY_THEME_DIR" | sed -E "s|$HOME|~|") && line=$(grep "^ *- *$search" "$ALACRITTY_CONFIG_FILE")
	set -e
	echo "$line" | tail -1 #in case there's many, only last one is relevant
}


# Change Alacritty theme
theme_file="$ALACRITTY_THEME_DIR/$(basename "$1").yml"
config_file="$ALACRITTY_CONFIG_FILE"
[ ! -f "$theme_file" ] && exit_with_error "$theme_file not found"
[ ! -f "$config_file" ] && exit_with_error "$config_file not found"
# Search for existing imported theme, if found we just replace it 
theme_line=$(get_existing_theme_line)
if [ -z "$theme_line" ]; then
	# TODO add the line if it is not found
	echo "Could not find existing imported theme, please import one from the themes folder and run the command again" && exit 1
else
	current_theme="$(basename "$theme_line")"
	new_theme_line="$(echo "$theme_line" | sed "s|$current_theme|$THEME_NAME.yml|")"
	echo "$theme_line=>$new_theme_line"
	sed -i -E "s|^$theme_line$|$new_theme_line|" "$config_file"
fi

# Export to ~/.Xresources
[ ! -z "$EXPORT_TO_XRESOURCES" ] && echo "Exporting to .Xresources..." && "$EXPORT_TO_XRESOURCES_SCRIPT" "$theme_file"

# Restart i3
[ ! -z "$RESTART" ] && echo "Restarting i3..." && i3-msg restart
