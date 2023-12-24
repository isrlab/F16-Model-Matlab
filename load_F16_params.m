% ==========================
% Developed by
% Raktim Bhattacharya, 
% Professor
% Aerospace Engineering,
% Texas A&M University.
% ==========================

function Param = load_F16_params()
% Inertia and geometry data for F16.
% All parameters are in SI Units.

slugs2kg = 14.5939;
ft2m     = 0.3048;

Param.S = 300*ft2m^2;      % Reference Area, m^2
Param.b =  30*ft2m;        % Wing Span, m
Param.cbar =  11.32*ft2m;     % Aerodynamic Mean Chord, m
Param.rho = 1.293;         % Air Density, kg/m^3
Param.xcgr = 0.35;         % reference center of gravity as a fraction of cbar
Param.xcg  = 0.30;         % center of gravity as a fraction of cbar.


% Moment of Inertial
Ixx = 9496.0;            % Principle Moment of Intertia around X-axis, slugs*ft^2
Iyy = 55814.0;           % Principle Moment of Intertia around Y-axis, slugs*ft^2
Izz = 63100.0;           % Principle Moment of Intertia around Z-axis, slugs*ft^2 
Ixz = 982.0;           % Principle Moment of Intertia around XZ-axis,slugs*ft^2
Param.moi = [Ixx 0 Ixz;
             0   Iyy 0
             Ixz 0   Izz]*slugs2kg*(ft2m)^2; % Convert to Kg*m^2

Param.mass = 636.94*slugs2kg;     % kg
Param.g = 9.806;  % m/s^2
end