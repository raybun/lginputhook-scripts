#!/bin/sh

# Function to send notification
send_notification() {
    local message="$1"
    luna-send -a datablob -f -n 1 luna://com.webos.notification/createToast "{\"sourceId\":\"datablob\",\"message\":\"$message\"}"
}

# Check if the script is run in simulation mode
simulation=false
if [ "$1" = "--simulate" ]; then
    simulation=true
fi

# List of possible energy saving settings
settings="auto off min med max"

# Run the getter method and capture the output
output=$(luna-send -n 1 luna://com.webos.settingsservice/getSystemSettings '{"category":"picture","keys":["energySaving"]}')

# Extract the current setting using grep and sed
current_setting=$(echo "$output" | awk -F'"' '{for(i=1;i<=NF;i++){if($i=="energySaving"){print $(i+2)}}}')

# Log the current setting to the console
echo "Current energy saving setting: $current_setting"

# Find the index of the current setting in the settings list
index=0
found=false
for setting in $settings; do
    if [ "$setting" = "$current_setting" ]; then
        found=true
        break
    fi
    index=$((index + 1))
done

if [ "$found" = false ]; then
    echo "Current setting not found in the list of possible settings."
    exit 1
fi

# Determine the next setting, looping around if necessary
next_index=$(( (index + 1) % $(echo "$settings" | wc -w) ))
next_setting=$(echo "$settings" | cut -d ' ' -f $((next_index + 1)))

# Log the next setting to the console
echo "Next energy saving setting: $next_setting"

if [ "$simulation" = true ]; then
    echo "Simulation mode: Not setting the new energy saving value."
else
    # Set the new setting using the setter method
    set_output=$(luna-send -n 1 luna://com.webos.settingsservice/setSystemSettings "{\"category\":\"picture\",\"settings\":{\"energySaving\":\"$next_setting\"}}")

    # Notify the user with a toast notification
    send_notification "Energy: $next_setting"    

    # Log the success or error return value to the console
    echo "Set output: $set_output"
fi
