classdef States < Simulink.IntEnumType
   enumeration
       Rest(1),
       Compression(2),
       Thrust(3),
       Unloading(4),
       Flight(5)
   end
end