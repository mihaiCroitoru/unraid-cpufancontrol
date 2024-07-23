Fan Control Plugin
==================

This plugin controls the CPU fan speed based on the CPU temperature.

Requirements:
- lm-sensors
- fancontrol

Installation:
1. Ensure your system has the required packages:
   - lm-sensors
   - fancontrol

2. Install the plugin via the Unraid web interface:
   - Go to the Plugins tab, click on the Install Plugin button, and paste the URL to your fancontrol.plg file.

3. Configure the plugin settings from the Unraid web interface under the Settings tab.

Configuration:
- CPU Temperature Sensor: Select the CPU temperature sensor from the detected sensors.
- PWM Controller: Select the PWM controller from the detected controllers.
- Minimum PWM Value: Set the minimum fan speed.
- Low Temperature Threshold: Set the temperature below which the fan will run at minimum speed.
- High Temperature Threshold: Set the temperature above which the fan will run at maximum speed.
