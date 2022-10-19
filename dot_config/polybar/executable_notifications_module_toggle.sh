is_paused=$(dunstctl is-paused)
if [ $is_paused = true ]; then
	dunstctl set-paused false
	notify-send "Notifications turned ON"
else
	notify-send "Notifications turned OFF"
	sleep 1.5
	dunstctl close-all && dunstctl set-paused true
fi
