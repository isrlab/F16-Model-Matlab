% Find trim states using nonlinear optimization
% Compute trim control only.
% States are frozen to values in x0.
% xdot is obtained from the simulink diagram.


function [xTrim,uTrim,xdTrim, yTrim,fval,exitflag,output] = SteadyLevelTrim(h0, Vt0, maxIter)
% conversion % loads conversion constants
ft2m = 0.3048;
d2r = pi/180;
lbf2N = 4.44822;

hmin = 5000*ft2m;
hmax = 40000*ft2m;

Vtmin = 300*ft2m;
Vtmax = 900*ft2m;

if abs(h0) < hmin || abs(h0) > hmax
    error(['Height must be within: '  num2str([hmin,hmax]) 'm'])
end

if Vt0 < Vtmin || Vt0 > Vtmax
    error(['Velocity must be within: '  num2str([Vtmin,Vtmax]) 'm/s'])
end

% Control surface bounds -- throttle, elevator, aileron, rudder, lef
control.lb = [1000*lbf2N -25*d2r -21.5*d2r -30*d2r 0]*0.9;
control.ub = [19000*lbf2N 25*d2r  21.5*d2r  30*d2r 25*d2r]*0.9;
control.guess = [1000*lbf2N,0,0,0,0]; % Initial guess for trim control


% For steady-level, we want
% -------------------------
% hdot = 0
% Vtotal = given constant, gamma (FPA) = 0,
% th, phi, psi to be zero and constant => thd, phid, psid = 0
% p,q,r = 0 and constant => pd,qd,rd = 0.

% States:        N E h phi th psi U v w p q r
weights = zeros(1,12);
weights(3) = 1; % hd
weights(5) = 1; % thd
weights(7) = 1; % Ud
weights(9) = 1; % wd
weights(11) = 1; % qd

alpha.max = 45*d2r;
alpha.min = -20*d2r;

% Optimization optParamters
% Free state variables are U, w, th,
% Free control variables are T, dele
% Total 5 optimization optParameters.
%
% This is the ordering: [U,w,th,T,dele,lef], with units m/s, m/s, rad, N, rad
lb = horzcat(Vtmin,Vtmax*tan(alpha.min),alpha.min,control.lb([1,2,5]));
ub = horzcat(Vtmax,Vtmax*tan(alpha.max),alpha.max,control.ub([1,2,5]));
p0 = [Vt0,0,0,control.guess(1),0,0];
t0 = 0;

[sys,x01,str,ts] = F16([],[],[],'compile'); % Uses x0 as initial condition. x01 and x0 should be the same.
%
% options = optimoptions(@fmincon, ...
%     'Algorithm','sqp', ...
%     'EnableFeasibilityMode',true, ...
%     'SubproblemAlgorithm','cg', ...
%     'MaxIterations',maxIter);


options = optimoptions(@fmincon, ...
    'Algorithm','sqp', ...
    'Display','iter', ...
    'MaxIterations',maxIter);

[sol,fval,exitflag,output] = fmincon(@trimCost,p0,[],[],[],[],lb,ub,@nonlinConstr,options);

[xTrim,uTrim] = xu(sol);
yTrim = F16(t0, xTrim, uTrim, 'outputs');
xdTrim = F16(t0,xTrim,uTrim,'derivs');

F16([],[],[],'term');


function J = trimCost(optParam)
    [x,u] = xu(optParam);
    
    % States:        N E h phi th psi U v w p q r
    weights = zeros(1,12);
    weights(3) = 1; % hd
    weights(5) = 1; % thd
    weights(7) = 1; % Ud
    weights(9) = 1; % wd
    weights(11) = 1; % qd

    F16(0,x,u, 'outputs'); % Need this to update the dynamics with current state values
    xdot = F16(0,x,u,'derivs');

    J = sum(xdot(:).^2 .* weights(:));
end

function [c,ceq] = nonlinConstr(optParam)
    % Construct states and control from optParam.
    [x,u] = xu(optParam);

    y0 = F16(0,x,u,'outputs');

    e1 = y0(7)-Vt0; % Vt must be Vt0
    e2 = y0(13); % FPA must be zero.

    ineq1 = y0(8) - alpha.max; % Alpha upper bound
    ineq2 = alpha.min - y0(8); % Alpha lower bound

    c = [ineq1;ineq2]; % These are inequality constraints
    ceq = [e1;e2];

end

function [x,u] = xu(optParam) % Specific to steady-level flight
    % Free state variables are U, w, th,
    % Free control variables are T, dele, lef
    % Total 6 optimization optParameters.

    U = optParam(1); % m/s
    w = optParam(2); % m/s
    th = optParam(3); % rad
    T = optParam(4);  % N
    dele = optParam(5); % rad
    lef = optParam(6); % rad

    % States: N E h phi th psi U v w p q r
    % Set the states as per steady-level flight conditions
    x = zeros(1,12);
    x(3) = h0;
    x(5) = th;
    x(7) = U;
    x(9) = w;

    % Controls: T dele dela delr
    % Set controls as per steady-level flight conditions
    u = zeros(1,8); % total input = 5 controls + 3 gusts
    u(1) = T; % Newtons
    u(2) = dele; % radians
    u(5) = lef; % radians
end

end

