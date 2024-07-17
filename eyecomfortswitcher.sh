#!/bin/sh

# Function to get current eye comfort mode
get_current_eye_comfort_mode() {
    luna-send -f -n 1 luna://com.webos.settingsservice/getSystemSettings '{"category":"picture","keys":["eyeComfortMode"]}' | awk -F'"' '/eyeComfortMode/{print $(NF-1)}'
}

# Function to toggle eye comfort mode
toggle_eye_comfort_mode() {
    current_mode=$(get_current_eye_comfort_mode)

    if [ "$current_mode" = "on" ]; then
        next_mode="off"
    else
        next_mode="on"
    fi

    echo "Current eye comfort mode: $current_mode"
    echo "Setting eye comfort mode to: $next_mode"

    # Set the new eye comfort mode using luna-send
    luna-send -n 1 luna://com.webos.settingsservice/setSystemSettings "{\"category\":\"picture\",\"settings\":{\"eyeComfortMode\":\"$next_mode\"}}"

    # Notify the user with a toast notification
    send_notification "Eye comfort: $(get_current_eye_comfort_mode)"    
}

# Function to send notification
send_notification() {
    local message="$1"
    luna-send -a datablob -f -n 1 luna://com.webos.notification/createToast "{\"sourceId\":\"datablob\",\"message\":\"$message\"}"
}

# Main script execution
toggle_eye_comfort_mode

exit 0
