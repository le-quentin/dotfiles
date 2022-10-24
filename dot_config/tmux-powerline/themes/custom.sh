# Default Theme

if patched_font_in_use; then
	TMUX_POWERLINE_SEPARATOR_LEFT_BOLD=""
	TMUX_POWERLINE_SEPARATOR_LEFT_THIN=""
	TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD=""
	TMUX_POWERLINE_SEPARATOR_RIGHT_THIN=""
else
	TMUX_POWERLINE_SEPARATOR_LEFT_BOLD="◀"
	TMUX_POWERLINE_SEPARATOR_LEFT_THIN="❮"
	TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="▶"
	TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="❯"
fi

XRESOURCES_BACKGROUND=$(xrdb -get background)
XRESOURCES_BACKGROUND_VARIANT=$(xrdb -get background_variant)
XRESOURCES_FOREGROUND=$(xrdb -get foreground)
XRESOURCES_PRIMARY_BACKGROUND=$(xrdb -get primary_background)
XRESOURCES_PRIMARY_FOREGROUND=$(xrdb -get primary_foreground)
XRESOURCES_SECONDARY_BACKGROUND=$(xrdb -get secondary_background)
XRESOURCES_SECONDARY_FOREGROUND=$(xrdb -get secondary_foreground)

TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR="$XRESOURCES_BACKGROUND"
TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR="$XRESOURCES_FOREGROUND"

tmux set-option -g status-bg $TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR
tmux set-option -g status-fg $TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR
tmux set-option -g window-status-bell-style default
tmux set-option -g window-status-activity-style default
tmux set-option -g window-status-current-style bg="$XRESOURCES_SECONDARY_BACKGROUND",fg="$XRESOURCES_SECONDARY_FOREGROUND"
tmux set-option -g window-status-separator '  '

TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}
TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}

# See man tmux.conf for additional formatting options for the status line.
# The `format regular` and `format inverse` functions are provided as conveinences

if [ -z $TMUX_POWERLINE_WINDOW_STATUS_CURRENT ]; then
	TMUX_POWERLINE_WINDOW_STATUS_CURRENT=(
		"#[$(format inverse)]" \
		"$TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR" \
		" #I#F " \
		"$TMUX_POWERLINE_SEPARATOR_RIGHT_THIN" \
		" #W " \
		"#[$(format regular)]" \
		"$TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR"
	)
fi

if [ -z $TMUX_POWERLINE_WINDOW_STATUS_STYLE ]; then
	TMUX_POWERLINE_WINDOW_STATUS_STYLE=(
		"$(format regular)"
	)
fi

if [ -z $TMUX_POWERLINE_WINDOW_STATUS_FORMAT ]; then
	TMUX_POWERLINE_WINDOW_STATUS_FORMAT=(
		"#[$(format regular)]" \
		"  #I#{?window_flags,#F, } " \
		"$TMUX_POWERLINE_SEPARATOR_RIGHT_THIN" \
		" #W "
	)
fi

# Format: segment_name background_color foreground_color [non_default_separator]

PAIR_SEGMENT_COLORS="$XRESOURCES_BACKGROUND_VARIANT $XRESOURCES_FOREGROUND"
IMPAIR_SEGMENT_COLORS="$XRESOURCES_PRIMARY_BACKGROUND $XRESOURCES_PRIMARY_FOREGROUND"

if [ -z $TMUX_POWERLINE_LEFT_STATUS_SEGMENTS ]; then
	TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
		"tmux_session_info $PAIR_SEGMENT_COLORS" \
		"hostname $IMPAIR_SEGMENT_COLORS" \
		#"ifstat 30 255" \
		#"ifstat_sys 30 255" \
		#"lan_ip 24 255 ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN}" \
		#"wan_ip 24 255" \
		"vcs_branch #000000 $XRESOURCES_FOREGROUND" \
		#"vcs_compare 60 255" \
		#"vcs_staged 64 255" \
		#"vcs_modified 9 255" \
		#"vcs_others 245 0" \
	)
fi

if [ -z $TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS ]; then
	TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
		#"earthquake 3 0" \
		"pwd $IMPAIR_SEGMENT_COLORS" \
		#"macos_notification_count 29 255" \
		#"mailcount 9 255" \
		#"now_playing 234 37" \
		#"cpu 240 136" \
		#"load 237 167" \
		#"tmux_mem_cpu_load 234 136" \
		"battery $PAIR_SEGMENT_COLORS" \
		#"weather 37 255" \
		#"rainbarf 0 ${TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR}" \
		#"xkb_layout 125 117" \
		"date_day $IMPAIR_SEGMENT_COLORS" \
		"date $IMPAIR_SEGMENT_COLORS ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}" \
		"time $IMPAIR_SEGMENT_COLORS ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}" \
		#"utc_time 235 136 ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}" \
	)
fi
