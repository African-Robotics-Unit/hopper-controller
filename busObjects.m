% Bus object: BodyState
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'x';
elems(1).DataType = 'double';
elems(2) = Simulink.BusElement;
elems(2).Name = 'y';
elems(2).DataType = 'double';
elems(3) = Simulink.BusElement;
elems(3).Name = 'r';
elems(3).DataType = 'double';
elems(4) = Simulink.BusElement;
elems(4).Name = 'dx';
elems(4).DataType = 'double';
elems(5) = Simulink.BusElement;
elems(5).Name = 'dy';
elems(5).DataType = 'double';
elems(6) = Simulink.BusElement;
elems(6).Name = 'dr';
elems(6).DataType = 'double';
elems(7) = Simulink.BusElement;
elems(7).Name = 'ddx';
elems(7).DataType = 'double';
elems(8) = Simulink.BusElement;
elems(8).Name = 'ddy';
elems(8).DataType = 'double';
elems(9) = Simulink.BusElement;
elems(9).Name = 'ddz';
elems(9).DataType = 'double';

BodyState = Simulink.Bus;
BodyState.Elements = elems;
clear elems

% Bus object: Motor State
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'q';
elems(1).DataType = 'double';

elems(2) = Simulink.BusElement;
elems(2).Name = 'w';
elems(2).DataType = 'double';

MotorState = Simulink.Bus;
MotorState.Elements = elems;
clear elems


% Bus object: Command
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'start';
elems(1).DataType = 'boolean';

elems(2) = Simulink.BusElement;
elems(2).Name = 'stop';
elems(2).DataType = 'boolean';

elems(3) = Simulink.BusElement;
elems(3).Name = 'dx';
elems(3).DataType = 'double';

Command = Simulink.Bus;
Command.Elements = elems;
clear elems


% Bus object: CAN
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'Load';
elems(1).DataType = 'double';

elems(2) = Simulink.BusElement;
elems(2).Name = 'Warning';
elems(2).DataType = 'double';

elems(3) = Simulink.BusElement;
elems(3).Name = 'PassiveError';
elems(3).DataType = 'double';

elems(4) = Simulink.BusElement;
elems(4).Name = 'BusOffStatus';
elems(4).DataType = 'double';

CAN = Simulink.Bus;
CAN.Elements = elems;
clear elems


% Bus object: Foot
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'x';
elems(1).DataType = 'double';

elems(2) = Simulink.BusElement;
elems(2).Name = 'y';
elems(2).DataType = 'double';

elems(3) = Simulink.BusElement;
elems(3).Name = 'contact';
elems(3).DataType = 'boolean';

elems(4) = Simulink.BusElement;
elems(4).Name = 'height';
elems(4).DataType = 'double';

Foot = Simulink.Bus;
Foot.Elements = elems;
clear elems


% Bus object: Leg
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'r';
elems(1).DataType = 'double';

elems(2) = Simulink.BusElement;
elems(2).Name = 'phi';
elems(2).DataType = 'double';

elems(3) = Simulink.BusElement;
elems(3).Name = 'dr';
elems(3).DataType = 'double';

elems(4) = Simulink.BusElement;
elems(4).Name = 'dphi';
elems(4).DataType = 'double';

elems(5) = Simulink.BusElement;
elems(5).Name = 'r0';
elems(5).DataType = 'double';

elems(6) = Simulink.BusElement;
elems(6).Name = 'phi0';
elems(6).DataType = 'double';

Leg = Simulink.Bus;
Leg.Elements = elems;
clear elems


% Bus object: Controller
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'Fr';
elems(1).DataType = 'double';

elems(2) = Simulink.BusElement;
elems(2).Name = 'stance_time';
elems(2).DataType = 'double';

elems(3) = Simulink.BusElement;
elems(3).Name = 'state';
elems(3).DataType = 'Enum: States';

Controller = Simulink.Bus;
Controller.Elements = elems;
clear elems


% Bus object: ForceData
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'Fx';
elems(1).DataType = 'double';

elems(2) = Simulink.BusElement;
elems(2).Name = 'Fy';
elems(2).DataType = 'double';

elems(3) = Simulink.BusElement;
elems(3).Name = 'Fz';
elems(3).DataType = 'double';

elems(4) = Simulink.BusElement;
elems(4).Name = 'Tx';
elems(4).DataType = 'double';

elems(5) = Simulink.BusElement;
elems(5).Name = 'Ty';
elems(5).DataType = 'double';

elems(6) = Simulink.BusElement;
elems(6).Name = 'Tz';
elems(6).DataType = 'double';

ForceData = Simulink.Bus;
ForceData.Elements = elems;
clear elems
