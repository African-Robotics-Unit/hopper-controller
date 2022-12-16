"""
A80-6 Motor ODrive configuration script

NB: Make sure to run without the legs attached!

For some parameters/numbers related to current etc, check out:
https://image.made-in-china.com/202f0j00AtCYEfRsuHru/T-Motor-A80-6-Kv100-High-Torque-Speed-Reducer-Outer-Motor-for-Intelligent-Robot-Machine-Application-OEM-with-Encoder.jpg
"""

import odrive
from odrive.enums import MotorType, EncoderMode, AxisState
from odrive.utils import dump_errors
import time

def config_motor(ax: 'odrive.Axis'):
    # configure motor
    ax.motor.config.current_lim = 24 # [A] Maximum commanded current allowed for this motor
    ax.motor.config.calibration_current = 15 # [A] minimum to avoid phase inductance error
    ax.motor.config.pole_pairs = 21
    ax.motor.config.torque_constant = 0.091 # [Nm/A]
    ax.motor.config.motor_type = MotorType.HIGH_CURRENT
    ax.motor.config.current_control_bandwidth = 500 # [rad/s] default 1000
    # configure controller
    ax.controller.config.vel_limit = 5 # [turn/s]
    ax.controller.config.enable_torque_mode_vel_limit = False
    # configure encoder
    ax.encoder.config.use_index = True
    ax.encoder.config.cpr = 4096 # [CPR] = 4X [PPR]
    ax.encoder.config.mode = EncoderMode.INCREMENTAL
    # configure can
    ax.config.can.node_id = 1 if ax==odrv0.axis0 else 2
    ax.config.can.encoder_rate_ms = 2
    ax.config.can.heartbeat_rate_ms = 10
    # run full calibration sequence
    ax.requested_state = AxisState.FULL_CALIBRATION_SEQUENCE
    while ax.current_state != AxisState.IDLE:
        time.sleep(0.1)
    # set startup sequence
    # see https://docs.odriverobotics.com/api/odrive.axis.axisstate
    ax.config.startup_motor_calibration = False
    ax.config.startup_encoder_index_search = True
    ax.config.startup_encoder_offset_calibration = False
    ax.config.startup_closed_loop_control = False

    ax.requested_state = AxisState.IDLE
    ax.encoder.config.pre_calibrated = True
    ax.motor.config.pre_calibrated = True

    dump_errors(odrv0)


def config_can(odrive):
    odrive.can.config.baud_rate = 1_000_000
    odrive.can.config.protocol = 1


# erase existing configuration
odrv0 = odrive.find_any()
try:
    odrv0.erase_configuration()
except Exception:
    print('Lost connection because of reboot')
time.sleep(1)

print('finding odrive...')
odrv0 = odrive.find_any()

print('configuring motor 0...')
config_motor(odrv0.axis0)
odrv0.axis0.config.calibration_lockin.accel=-20 # reverse index search direction for right motor

print('configuring motor 1...')
config_motor(odrv0.axis1)

print('configuring brake resistor...')
odrv0.config.enable_brake_resistor = True
odrv0.config.brake_resistance = 0.47 # [Ω]
odrv0.config.dc_max_negative_current = -0.01 # default. If you are using a brake resistor and getting DC_BUS_OVER_REGEN_CURRENT errors, raise it slightly.
# The brake resistor ramp feature is needed to dissipate extra power during braking/landing
odrv0.config.enable_dc_bus_overvoltage_ramp = True
odrv0.config.dc_bus_overvoltage_ramp_start = 49.0 #! must be higher than supply voltage
odrv0.config.dc_bus_overvoltage_ramp_end = 55.0

print('configuring CAN communication...')
config_can(odrv0)

# save configuration and reboot
try:
    print('saving config in memory...')
    odrv0.save_configuration()
except Exception:
    print('Lost connection because of reboot')
time.sleep(1)
