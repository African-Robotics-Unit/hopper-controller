# Hopper Controller

## Quick Start
clone repo

## Change Feet
1. Open `kinematics` folder in matlab
2. Update `la.x` and `la.y` in `compute_kinematics.m` with foot dimensions
3. Run `compute_kinematics.m`


## Configure ODrive
This configures the ODrive with correct motor and CAN parameters, and runs motor calibration.
1. Remove the legs
2. Power ODrive with 48V
3. Connect ODrive to PC
4. Run `odrive-config.py`, this might require you to [install odrivetool](https://docs.odriverobotics.com/v/latest/odrivetool.html#install-odrivetool)


## Debug ODrive
Simulink will not show ODrive error messages. To get useful ODrive error messages follow these steps
1. Keep simulink running - terminating will clear errors
2. [Start odrivetool](https://docs.odriverobotics.com/v/0.5.5/getting-started.html#start-odrivetool) and connect
3. Run the `dump_errors(odrv0)` command
