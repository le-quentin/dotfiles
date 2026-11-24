#!/usr/bin/env bash
# Polybar module: the media of the most recently active MPRIS player (Feishin, YouTube… in Vivaldi or Brave), followed through playerctld.
# Output: [play or pause icon] Artist - Title [small browser logo]; the module's music note is its format-prefix, in forest/user_modules.ini.
# The logo color comes from the module's env (LOGO_COLOR), defaulting to the bar's foreground.
# The logos come from the Simple Icons font (~/.local/share/fonts/SimpleIcons.ttf), declared as font-9 in forest/config-base.ini, hence %{T10}.

export LC_ALL=C.UTF-8

maxlen=50
icon_playing=$'\ue9ba' # feather: play
icon_paused=$'\ue9ae'  # feather: pause
logo_vivaldi=$'\uf6b5' # Simple Icons: vivaldi
logo_brave=$'\ueb96'   # Simple Icons: brave
sep=$'\x1f'            # field separator; not a whitespace, so an empty artist keeps its field

# Short name of the player playerctld follows (vivaldi, brave…).
active_player() {
	local names name
	names=$(busctl --user get-property org.mpris.MediaPlayer2.playerctld /org/mpris/MediaPlayer2 com.github.altdesktop.playerctld PlayerNames 2>/dev/null)
	name=$(awk -F'"' '{print $2}' <<<"$names")
	name=${name#org.mpris.MediaPlayer2.}
	printf '%s' "${name%%.*}"
}

logo() {
	case "$1" in
		vivaldi) printf ' %%{T10}%%{F%s}%s%%{F-}%%{T-}' "${LOGO_COLOR:--}" "$logo_vivaldi" ;;
		brave) printf ' %%{T10}%%{F%s}%s%%{F-}%%{T-}' "${LOGO_COLOR:--}" "$logo_brave" ;;
	esac
}

playerctl -p playerctld --follow metadata --format "{{status}}${sep}{{artist}}${sep}{{title}}" 2>/dev/null |
	while IFS="$sep" read -r status artist title; do
		if [[ -z $title || $status == Stopped ]]; then
			echo
			continue
		fi
		text=${artist:+$artist - }$title
		((${#text} > maxlen)) && text="${text:0:maxlen-1}…"
		text=${text//'%{'/'% {'} # keep a title from opening a polybar tag
		[[ $status == Paused ]] && icon=$icon_paused || icon=$icon_playing
		echo "$icon $text$(logo "$(active_player)")"
	done
