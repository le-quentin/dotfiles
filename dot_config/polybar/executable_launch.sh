#!/usr/bin/env bash

dir="$HOME/.config/polybar"
themes=(`ls --hide="launch.sh" $dir`)

launch_bar_base() {
	# Launch the bar
	if [[ "$style" == "hack" || "$style" == "cuts" ]]; then
		polybar -q top -c "$dir/$style/config.ini" &
		polybar -q bottom -c "$dir/$style/config.ini" &
	elif [[ "$style" == "pwidgets" ]]; then
		bash "$dir"/pwidgets/launch.sh --main
	else
		polybar -q main -c "$config_file" &	
	fi
}

launch_bar() {
	# Terminate already running bar instances
	killall -q polybar

	# Wait until the processes have been shut down
	while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

	# Run the bar on each screen
	echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
	if type "xrandr"; then
	  monitors_count=$(xrandr --listactivemonitors | head -n 1 | cut -d " " -f2)
	  primary=$(xrandr --query | grep " primary" | cut -d" " -f1)
	  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
	    m_width=$(xrandr --listactivemonitors | grep $m | cut -d " " -f4 | cut -d / -f1)
	    [[ $monitors_count = 1 || $m = $primary ]] && tray=right || tray=none
	    [[ $m_width < 1600 ]] && display_mode=compact- || display_mode=""
	    echo "screen $m width $m_width display $display_mode"
	    config_file="~/.config/polybar/$style/$display_mode"config.ini
			# For some reason, doesn't work on new pc, hwmon_temp not found in script
	    # hwmon_file="$(hwmon_temp \"Package id 0\")" 
	    hwmon_file="/sys/devices/platform/coretemp.0/hwmon/hwmon3/temp1_input"
	    MONITOR=$m DIR=$dir STYLE=$style TRAY_POSITION=$tray CONFIG_FILE=$config_file CPU_TEMP_FILE=$hwmon_file launch_bar_base
	  done
	else
	  launch_bar_base
	fi

	echo "Bars launched..."
}

if [[ "$1" == "--material" ]]; then
	style="material"
	launch_bar

elif [[ "$1" == "--shades" ]]; then
	style="shades"
	launch_bar

elif [[ "$1" == "--hack" ]]; then
	style="hack"
	launch_bar

elif [[ "$1" == "--docky" ]]; then
	style="docky"
	launch_bar

elif [[ "$1" == "--cuts" ]]; then
	style="cuts"
	launch_bar

elif [[ "$1" == "--shapes" ]]; then
	style="shapes"
	launch_bar

elif [[ "$1" == "--grayblocks" ]]; then
	style="grayblocks"
	launch_bar

elif [[ "$1" == "--blocks" ]]; then
	style="blocks"
	launch_bar

elif [[ "$1" == "--colorblocks" ]]; then
	style="colorblocks"
	launch_bar

elif [[ "$1" == "--forest" ]]; then
	style="forest"
	launch_bar

elif [[ "$1" == "--pwidgets" ]]; then
	style="pwidgets"
	launch_bar

elif [[ "$1" == "--panels" ]]; then
	style="panels"
	launch_bar

else
	cat <<- EOF
	Usage : launch.sh --theme
		
	Available Themes :
	--blocks    --colorblocks    --cuts      --docky
	--forest    --grayblocks     --hack      --material
	--panels    --pwidgets       --shades    --shapes
	EOF
fi
