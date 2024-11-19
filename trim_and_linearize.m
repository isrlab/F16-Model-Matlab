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
% T: Thrust in lbs, min: 1000, max: 19000
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
clc; 

Param = load_F16_params(); % System Parameters

ft2m = 0.3048;
d2r = pi/180;

% Trim the aircraft using Simulink's Control Design Toolbox.
% ==========================================================
% Need to mark inputs and outputs in the simulink digrams.
% Open Steady State Manager to trim the aircraft. Here we are interested in
% steady-level flight. Initialze the model with the trim state and control.

tic
simOut = sim('F16.slx');
toc

plot_trajectories(simOut);

%% Linearization
% Now linearize, assuming the linear model is linsys1

% Extract the transfer function from elev to .
sys = minreal(linsys1(11,3),1E-6); % system from ele to gam










