# Hopper Controller


## Getting Started
This assumes you are running from the Speedgoat PC which already has the required dependencies installed
1. Attach robot to the boom
2. Connect power and 5 pin CAN to the robot
3. Power on and index the [boom](https://github.com/African-Robotics-Unit/boom-firmware)
4. Ensure the legs are free to move and that upper links are slightly below horizontal
5. Turn on 48V supply to the ODrive and allow the legs to index
6. Open and start `demo.slx` on the Speedgoat
7. The green controller button will start the robot hopping and holding the red button will stop


## Control Structure
Discrete state controller based on the Raibert controller

| State | Description |
| ------------- | ------------- |
| Rest  | Content Cell  |
| Content Cell  | Content Cell  |

<p align="center">
<img src="" width="500">
</p>

## Change Feet
1. Open the `kinematics` folder in matlab
2. Update `la.x` and `la.y` in `compute_kinematics.m` with the new foot dimensions
3. Run `compute_kinematics.m` to update files


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
3. Run the `dump_errors(odrv0)` command and look [here](https://docs.odriverobotics.com/v/0.5.5/troubleshooting.html#error-codes) for the corresponding error


## Dependencies
- Simulink
- Simulink Coder
- Simulink Real-Time
- Simulink Real-Time Target Support Package
- [ARU Simulink Toolbox](https://github.com/African-Robotics-Unit/simulink-toolbox)
- [Speedgoat I/O Blockset](https://www.speedgoat.com/extranet#/Downloads)
