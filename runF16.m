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

clc; clear;

Param = load_F16_params(); % System Parameters

ft2m = 0.3048;
d2r = pi/180;

% Initial Conditions
% ==================
IC.inertial_position = [0,0,-10000]; % At 10 Km altitude.
IC.body_velocity = [300*ft2m,0,0];    % We may need to get this from Mach, alpha, beta
IC.euler_angles = [0,0,0]*d2r;  % Euler angles
IC.omega = [0,0,0] ;            % Angular velocity in body coordinate system

Tend = 2.0; % Simulation time in seconds.
tic
simOut = sim('F16.slx');
toc

plot_trajectories(simOut);


