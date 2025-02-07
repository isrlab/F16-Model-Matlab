% =========================================================================
% Model of the F-16 Aircraft model.
%
% References:
%    NASA Technical Report 1538, Simulator Study of Stall/Post-Stall Characteristics of a Fighter Airplane with Relaxed Longitudinal Static Stability, 
%    by Nguyen, Ogburn, Gilbert, Kibler, Brown, and Deal, Dec 1979. 
% 
%    The model is based on Aircraft Control and Simulations, by Brian Stevens and Frank Lewis, Wiley Inter-Science, New York, 1992.
%
% All units in this model are in SI SYSTEM.
% 
% Model developed by
% Raktim Bhattacharya, 
% Professor
% Aerospace Engineering,
% Texas A&M University.
%
% =========================================================================

% ============================= Model Details =============================
% The 12 states of the system are as follows:
% 
% N: North position in ft
% E: East position in ft
% h: Altitude in ft, min: 5000 ft, max: 40000 ft
% phi: Roll angle in rad
% theta: Pitch angle in rad
% psi: Yaw angle in rad
% Vt: Magnitude of total velocity in ft/s, min: 300 ft/s, max: 900 ft/s
% alpha: Angle of attack in rad, min: -20 deg, max: 45 deg
% beta: Side slip angle in rad, min: -30 deg, max: 30 deg
% p: Roll rate in rad/s
% q: Pitch rate in rad/s
% r: Yaw rate in rad/s
% The 5 control variables are:
% 
% T: Thrust in lbf, min: 1000, max: 19000
% dele: Elevator angle in deg, min:-25, max: 25
% dail: Aileron angle in deg, min:-21.5, max: 21.5
% drud: Rudder angle in deg, min: -30, max: 30
% dlef: Leading edge flap in deg, min: 0, max: 25
% Actuator models are defined as:
%
% T: max |rate|: 10,000 lbs/s
% dele: max |rate|: 60 deg/s
% dail: max |rate|: 80 deg/s
% drud: max |rate|: 120 deg/s
% dlef: max |rate|: 25 deg/s
% =========================================================================
clc; clear;

conversion % loads conversion constants. see conversion.m for defintions.

Param = load_F16_params(); % System Parameters

% Simulate with Arbitrary Initial Conditions
% ==========================================
h0 = -10000; % 10 K altitude
Vt0 = 500*ft2m;

% Need to specify IC to initialize simulink.
IC.inertial_position = [0,0,h0]; % At 10 Km altitude.
IC.body_velocity = [Vt0,0,0];    % We may need to get this from Mach, alpha, beta
IC.euler_angles = [0,0,0]*d2r;  % Euler angles
IC.omega = [0,0,0] ;            % Angular velocity in body coordinate system
Tend = 2.0; % Simulation time in seconds.


maxIter = 3000; % Iteration limit for optimization algorithm.
[xTrim,uTrim,xdTrim,yTrim,fval,exitflag,output] = SteadyLevelTrim(h0, Vt0, maxIter);

ix = [3,5,7,9,11];
iy = [7,8,13];
iu = [1,2];

% Check
disp(' ');
disp(['Longitudinal xdTrim: ', num2str(xdTrim(ix)')]); disp(' ');
disp(['Longitudinal xTrim: ', num2str(xTrim(ix))]); disp(' ');
disp(['Longitudinal uTrim: ', num2str(uTrim(iu))]); disp(' ');
disp(['Longitudinal yTrim: ', num2str(yTrim(iy)')]); disp(' ');


%% Linearize
[A,B,C,D] = linmod('F16',xTrim,uTrim);

% Extract the longitudinal dynamics
longi.ix = [5,7,9,11]; % th, U, w, q
longi.iu = [1,2]; % T, dele
longi.id = [5,7]; % dx, dz. Gust (vel) in body (x,z).
longi.iy = [7,8,13,15,17,19]; % Vt, alp, q, xbdd, zbdd

% Dynamics
longi.A = A(longi.ix,longi.ix); % 
longi.Bu = B(longi.ix,longi.iu);
longi.Bd = B(longi.ix,longi.id);

% Output
longi.C = C(longi.iy,longi.ix);
longi.Du = D(longi.iy,longi.iu);
longi.Dd = D(longi.iy,longi.id);

% Create the open-loop MIMO system
AA = longi.A;
BB = [longi.Bd longi.Bu];
CC = longi.C;
DD = [longi.Dd longi.Du];
sys = ss(AA,BB,CC,DD); % Inputs: (dx, dy,T, dele) to (Vt, alp, q, xbdd, zbdd)

outID = 1;
inpID = 3;
sys_T_to_Vt = sys(outID,inpID) ;

damp(sys_T_to_Vt) % Shows poles, damping, nat freq, time constant


