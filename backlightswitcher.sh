#!/bin/sh

# Function to get current backlight setting
get_current_backlight() {
    luna-send -f -n 1 luna://com.webos.settingsservice/getSystemSettings '{"category":"picture","keys":["backlight"]}' | awk -F'[:,]' '/backlight/{print $2}'
}

# Function to set next backlight setting
set_next_backlight() {
    current_value=$(get_current_backlight)
    max_value=100
    increment=10

    # Calculate next value
    next_value=$(( current_value + increment ))

    if [ $next_value -gt $max_value ]; then
        next_value=$(( next_value - max_value ))
    fi

    echo "Current backlight setting: $current_value"
    echo "Setting backlight to: $next_value"

    # Set the new backlight setting using luna-send
    luna-send -n 1 luna://com.webos.settingsservice/setSystemSettings "{\"category\":\"picture\",\"settings\":{\"backlight\":$next_value}}"

    # Notify the user with a toast notification
    send_notification "Backlight: $(get_current_backlight)"    
}

# Function to send notification
send_notification() {
    local message="$1"
    luna-send -a datablob -f -n 1 luna://com.webos.notification/createToast "{\"sourceId\":\"datablob\",\"message\":\"$message\"}"
}

# Main script execution
set_next_backlight

exit 0
