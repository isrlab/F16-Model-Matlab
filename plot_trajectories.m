% ==========================
% Developed by
% Raktim Bhattacharya, 
% Professor
% Aerospace Engineering,
% Texas A&M University.
% ==========================


function plot_trajectories(simOut)
r2d = 180/pi;
set(0, 'DefaultLineLineWidth', 1);

figure(1); clf;
% Plot position in inertial
subplot(4,3,1); plot(simOut.tout,simOut.yout{1}.Values.Data(:,1)); title('$X$ Inertial Position (m)', 'interpreter', 'latex'); xlabel('Time (s)');
subplot(4,3,2); plot(simOut.tout,simOut.yout{1}.Values.Data(:,2)); title('$Y$ Inertial Position (m)', 'interpreter', 'latex'); xlabel('Time (s)');
subplot(4,3,3); plot(simOut.tout,simOut.yout{1}.Values.Data(:,3)); title('$Z$ Inertial Position (m)', 'interpreter', 'latex'); xlabel('Time (s)');
set(gca,'YDir','reverse');

% Plot velocity in inertial
subplot(4,3,4); plot(simOut.tout,simOut.yout{2}.Values.Data(:,1)); title('Inertial Velocity $\dot{X}$ (m)', 'interpreter','latex'); xlabel('Time (s)');
subplot(4,3,5); plot(simOut.tout,simOut.yout{2}.Values.Data(:,2)); title('Ineritial Velocity $\dot{Y}$ (m)', 'interpreter','latex'); xlabel('Time (s)');
subplot(4,3,6); plot(simOut.tout,simOut.yout{2}.Values.Data(:,3)); title('Inertial Velocity $\dot{Z}$ (m)', 'interpreter','latex'); xlabel('Time (s)');

% Plot total velocity, angle of attack, and side slip angle
subplot(4,3,7); plot(simOut.tout,simOut.yout{3}.Values.Data); title('Total Velocity $V_t$ (m/s)', 'interpreter','latex'); xlabel('Time (s)');
subplot(4,3,8); plot(simOut.tout,simOut.yout{4}.Values.Data*r2d); title('Angle of Attack $\alpha$ (deg)', 'interpreter','latex'); xlabel('Time (s)');
subplot(4,3,9); plot(simOut.tout,simOut.yout{5}.Values.Data*r2d); title('Side-slip Angle $\beta$ (deg)', 'interpreter','latex'); xlabel('Time (s)');

% Plot body acceleration
subplot(4,3,10); plot(simOut.tout,simOut.yout{9}.Values.Data(:,1)); title('Body Accleration $\ddot{x}_b$  (m/s$^2$)', 'interpreter','latex'); xlabel('Time (s)');
subplot(4,3,11); plot(simOut.tout,simOut.yout{9}.Values.Data(:,2)); title('Body Accleration $\ddot{y}_b$  (m/s$^2$)', 'interpreter','latex'); xlabel('Time (s)');
subplot(4,3,12); plot(simOut.tout,simOut.yout{9}.Values.Data(:,3)); title('Body Accleration $\ddot{z}_b$  (m/s$^2$)', 'interpreter','latex'); xlabel('Time (s)');


figure(2); clf;
% Plot Euler angels
subplot(4,3,1); plot(simOut.tout,simOut.yout{6}.Values.Data(:,1)*r2d); title('Roll Angle $\phi$ (deg)', 'interpreter', 'latex'); xlabel('Time (s)');
subplot(4,3,2); plot(simOut.tout,simOut.yout{6}.Values.Data(:,2)*r2d); title('Pitch Angle $\theta$ (deg)', 'interpreter', 'latex'); xlabel('Time (s)');
subplot(4,3,3); plot(simOut.tout,simOut.yout{6}.Values.Data(:,3)*r2d); title('Yaw Angle $\psi$ (deg)', 'interpreter', 'latex'); xlabel('Time (s)');

% Plot angular velocity
subplot(4,3,4); plot(simOut.tout,simOut.yout{8}.Values.Data(:,1)*r2d); title('Roll Rate $p$ (deg/s)', 'interpreter','latex'); xlabel('Time (s)');
subplot(4,3,5); plot(simOut.tout,simOut.yout{8}.Values.Data(:,2)*r2d); title('Pitch Rate $q$ (deg/s)', 'interpreter','latex'); xlabel('Time (s)');
subplot(4,3,6); plot(simOut.tout,simOut.yout{8}.Values.Data(:,3)*r2d); title('Yaw Rate $r$ (deg/s)', 'interpreter','latex'); xlabel('Time (s)');

% Plot angular acceleration
subplot(4,3,7); plot(simOut.tout,simOut.yout{10}.Values.Data(:,1)*r2d); title('Roll Acceleration $\dot{p}$ (deg/s)', 'interpreter','latex'); xlabel('Time (s)');
subplot(4,3,8); plot(simOut.tout,simOut.yout{10}.Values.Data(:,2)*r2d); title('Pitch Acceleration $\dot{q}$ (deg/s)', 'interpreter','latex'); xlabel('Time (s)');
subplot(4,3,9); plot(simOut.tout,simOut.yout{10}.Values.Data(:,3)*r2d); title('Yaw Acceleration $\dot{r}$ (deg/s)', 'interpreter','latex'); xlabel('Time (s)');


% Plot Mach and flight path angle
subplot(4,3,10); plot(simOut.tout,simOut.yout{11}.Values.Data); title('Mach Number $M$', 'interpreter','latex'); xlabel('Time (s)');
subplot(4,3,11); plot(simOut.tout,simOut.yout{7}.Values.Data*r2d); title('Flight Path Angle $\gamma$ (deg)', 'interpreter','latex'); xlabel('Time (s)');
%subplot(4,3,9); plot(simOut.tout,simOut.yout{5}.Values.Data*r2d); title('Side-slip Angle $\beta$ (deg)', 'interpreter','latex'); xlabel('Time (s)');

end