#!/bin/zsh

smi_output=$(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu,temperature.gpu.tlimit,power.draw,power.max_limit --format=csv,noheader,nounits)
metrics=(${(@s:, :)smi_output})

usage="$metrics[1]"
temp="$metrics[2]"
temp_limit="$metrics[3]"
power="$metrics[4]"
power_limit="$metrics[5]"

# If we could fetch the temp limit, we use it; otherwise, we don't show it, and we use 90°C as a default limit
if [[ "$temp_limit" == <-> ]] 2> /dev/null; then
	temp_limit_str="/$temp_limit"
else
	temp_limit_str=""
	temp_limit=90
fi

# Set the color depending on metrics being under $WARN_LIMIT_PERCENT% of each limit
icon_color=$ICON_COLOR
usage_color=$TEXT_COLOR
temp_color=$TEXT_COLOR
power_color=$TEXT_COLOR

if [[ "$usage" -ge "$WARN_LIMIT_PERCENT" ]]; then
	icon_color=$WARN_COLOR
	usage_color=$WARN_COLOR
fi

max_temp=$(("$WARN_LIMIT_PERCENT" * "$temp_limit" / 100 ))
# max_temp=$(($WARN_LIMIT_PERCENT * 90 / 100 ))
if [[ "$temp" -ge "$max_temp" ]]; then
	icon_color=$WARN_COLOR
	temp_color=$WARN_COLOR
fi

max_power=$(($WARN_LIMIT_PERCENT * $power_limit / 100))
if [[ "$power" -ge "$max_power" ]]; then
	icon_color=$WARN_COLOR
	power_color=$WARN_COLOR
fi

if [[ "$usage" -lt 10 ]]; then
	usage="0$usage"
fi

if [[ "$power" -lt 10 ]]; then
	power="0$power"
fi

echo %{F$icon_color}   %{F-} %{F$usage_color} $usage\% %{F-} - %{F$temp_color} $temp$temp_limit_str°C %{F-} - %{F$power_color}$power/$power_limit\W %{F-}
