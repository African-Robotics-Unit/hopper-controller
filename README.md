# Hopper Controller


## Getting Started
This assumes you are running from the Speedgoat PC which already has the required dependencies installed
1. Attach robot to the boom
2. Connect power and 5 pin CAN to the robot
3. Power on and index the [boom](https://github.com/African-Robotics-Unit/boom-firmware)
4. Ensure the legs are free to move and that upper links are horizontal
5. Turn on 48V supply to the ODrive and allow the legs to find their index points
6. Add the ```kinematics``` folder to the Matlab path
7. Open and start `demo.slx` on the Speedgoat
8. The green controller button will start the robot hopping and holding the red button will stop


## Control Structure
Discrete state controller based on the Raibert controller [^1]

<p align="center">
<img src="https://github.com/African-Robotics-Unit/hopper-controller/blob/main/hopper-fsm.jpg" width="400">
</p>

The controller cycles through 5 discrete states defined in ```States.m``` which sequences the control actions.
| State | Control Action |
| :--- | --- |
| Rest | Moderately stiff and damped leg to keep the body upright and standing |
| Thrust | Small thrust force in the $r$ direction to overcome losses and maintain a hopping. Zero leg $\phi$ axis stiffness and damping and $r$ axis damping. |
| Unloading | Stop applying a thrust force and let the leg retract back to its neutral point |
| Flight | Adjust $\phi_0$ to position foot for touchdown based on current and desired horizontal speed |
| Compression | Zero leg $\phi$ axis stiffness and damping, and $r$ axis damping |

Transitions between controller states are triggered by changes in the robot state.
| Transition | Trigger |
| :--- | --- |
| Rest ⭢ Thrust | Green start button pressed on controller |
| Thrust ⭢ Unloading | Leg has extended past its neutral length ( $r > r_0$ ) |
| Unloading ⭢ Flight | Foot has left the ground ( $y_{foot} > 0$ ) |
| Flight ⭢ Compression | Leg is being compressed ( $\dot{r} < -1$ ) while body is falling ( $\dot{y}_{body} < 0$ ) |
| Compression ⭢ Thrust | Leg is fully compressed and has begun extending ( $\dot{r} > 0$ ) while below its neutral point ( $r < r_0$ ) |
| Compression ⭢ Rest | Red stop button pressed on controller |


### Leg Impedance Control
The leg is controlled in polar coordinates with a radial length $r$ and an angle $\phi$ from the body to the ankle, kind of like a pogo stick. Force in this polar frame is controlled by computing the required left $\tau_L$ and right $\tau_R$ motor torques from the desired radial force $F_r$ and torque $\tau_{\phi}$ using the leg polar Jacobian $J_p$.

$$
\begin{bmatrix}
\tau_L \\
\tau_R
\end{bmatrix} = J_p^T
\begin{bmatrix}
F_r \\
\tau_\phi
\end{bmatrix}
$$

This ignores the mass and dynamics of the legs, but is still a reasonable approximation as the links are relatively light. A PD controller on each of the polar axes enables tracking of desired position and velocity setpoints $r_0$, $\phi_0$ and $\dot{r}_0$, $\dot{\phi}_0$.

$$ F_r = Kp_r(r_0 - r_{leg}) + Kd_r(\dot{r}_0 - \dot{r}_{leg}) + F_{thrust} $$

$$ \tau_{\phi} = Kp_{\phi}(\phi_0 - \phi_{leg}) + Kd_{\phi}(\dot{\phi}_0 - \dot{\phi}_{leg}) $$

These PD controllers behave like a parallel spring and damper where $Kp$ is the spring stiffness with units $\frac{N}{m}$ or $\frac{Nm}{rad}$ and $Kd$ is the damping constant with units $\frac{Ns}{m}$ or $\frac{Nms}{rad}$. The radial stiffness determines how much the leg compresses during landing. Higher jump heights will need higher radial stiffness to stop the leg bottoming out (think pogo stick). The polar angle stiffness determines how quickly the leg repositions during flight. The damping constants are typically set to keep the axes more or less critically damped and avoid any oscillations.

#### Instability
**NB**: If the $Kp$ or $Kd$ are set too high this increases the gain crossover frequency and will cause the PD controller to go unstable. This will cause the leg to shake violently and should be avoided. Higher gains should first be tested without the legs attached. The point at which the legs go unstable is also dependent on the leg configuration and the apparent mass seen by the motors. In configurations where the Jacobian is less favourable for force production in the polar frame, high polar stiffness maps to significantly higher joint stiffnesses resulting in instability. If much higher stiffness is required in the future this can be mitigated by computing the effective joint stiffness and limiting it to a safe value.

#### Thrust Force
Hopping height is controlled by the radial thrust force. In an ideal world no thrust force should be required and the leg should be able to bounce up and down from an initial height on its perfectly springy leg indefinitely. Due to the motors not producing an ideal radial spring behaviour a small thrust force is required to maintain a desired hopping height. Higher thrust forces will produce greater hopping heights, but the downside to this (apart from the motors getting hotter) is that the radial leg force becomes less and less symmetric. For an ideal Raibert hopper the radial leg force is an even function of time. With a thrust force, the radial force for leg compression and extension is no longer the same producing net horizontal accelerations and impacting horizontal velocity control. For this reason the thrust force should be kept to a minimum and velocity control will most likely need to be adjusted if the thrust force is changed.

### Velocity Control
The neutral point is given by

$$ x_{netral} = \frac{\dot{x}T_s}{2} $$

with $x = 0$ being directly below the hip. Placement of the foot ahead or behind the neutral point produces horizontal accelerations. A proportional controller with gain $K_v$ is used to determine foot placement and control horizontal velocity.

$$ x_{foot} = \frac{\dot{x}T_s}{2} + K_v(\dot{x} - \dot{x}_d) $$

Small changes in foot placement can produce large changes in body velocity. When tuning the gain $K_v$ start small with a value of about 0.01 which corresponds to a 1cm foot adjustment for a 1m/s body velocity error. Higher $K_v$ values will produce more repsonsive velocity control until the leg begins to overshoot. Foot placement is controlled with the $\phi$ axis of the leg by changing the setpoint $\phi_0$.

$$ \phi_0 = -\frac{\pi}{2} + \arcsin(\frac{x_{foot}}{r}) $$


## Motor Encoder Indexing
The encoders in the motors are mounted to the rotor. Because of the planetary reduction, one turn of the motor output results in six turns of the rotor. There are therefore six encoder index points for a full turn of the motor output/hip. It is therefore important that the hips start close (< 60°) to the correct one of these six index points. Powering on the ODrive with the upper links horizontal should accomplish this. When powered on, the ODrive will move the right motor CCW and the left motor CW until the index pulse is detected.


## Changing Feet
1. Open the `kinematics` folder in matlab
2. Update `la.x` and `la.y` in `compute_kinematics.m` with the new foot dimensions
3. Run `compute_kinematics.m` to update function files


## Configuring ODrive
To configure the ODrive with correct motor and CAN parameters, and run motor calibration.
1. Remove the legs
2. Power ODrive with 48V
3. Connect ODrive to PC
4. Run `odrive-config.py`, this requires you to [install odrivetool](https://docs.odriverobotics.com/v/latest/odrivetool.html#install-odrivetool)


## Debugging ODrive
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

[^1]: Raibert, M.H., 1986. Legged robots that balance. MIT press.
