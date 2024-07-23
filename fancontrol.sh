#!/bin/bash

CONFIG_FILE="/boot/config/plugins/fancontrol/config.ini"

# Function to install required packages
install_packages() {
    if ! command -v sensors &> /dev/null; then
        echo "Installing lm-sensors..."
        apt-get update && apt-get install -y lm-sensors
    fi
    if ! command -v pwmconfig &> /dev/null; then
        echo "Installing fancontrol..."
        apt-get update && apt-get install -y fancontrol
    fi
}

# Create the config.ini file with default values if it doesn't exist
if [ ! -f $CONFIG_FILE ]; then
    cat <<EOL > $CONFIG_FILE
{
    "temp_sensor": "/sys/class/thermal/thermal_zone0/temp",
    "pwm_control": "/sys/class/hwmon/hwmon0/pwm1",
    "pwm_min": 0,
    "temp_low": 40,
    "temp_high": 80
}
EOL
fi

# Read configuration values from the config.ini file
CONFIG=$(cat $CONFIG_FILE)

TEMP_SENSOR=$(echo $CONFIG | jq -r .temp_sensor)
PWM_CONTROL=$(echo $CONFIG | jq -r .pwm_control)
PWM_MIN=$(echo $CONFIG | jq -r .pwm_min)
TEMP_LOW=$(echo $CONFIG | jq -r .temp_low)
TEMP_HIGH=$(echo $CONFIG | jq -r .temp_high)

TEMP_LOW=$((TEMP_LOW * 1000))
TEMP_HIGH=$((TEMP_HIGH * 1000))

# Function to get the current CPU temperature
get_cpu_temp() {
    cat $TEMP_SENSOR
}

# Function to set the PWM value
set_pwm() {
    echo $1 > $PWM_CONTROL
}

# Main loop
while true; do
    # Get the current CPU temperature
    CPU_TEMP=$(get_cpu_temp)

    # Calculate the PWM value based on the temperature
    if [ $CPU_TEMP -lt $TEMP_LOW ]; then
        PWM_VALUE=$PWM_MIN
    elif [ $CPU_TEMP -gt $TEMP_HIGH ]; then
        PWM_VALUE=255
    else
        PWM_VALUE=$(( ($CPU_TEMP - $TEMP_LOW) * (255 - $PWM_MIN) / ($TEMP_HIGH - $TEMP_LOW) + $PWM_MIN ))
    fi

    # Set the PWM value
    set_pwm $PWM_VALUE

    # Sleep for a while before checking the temperature again
    sleep 5
done
