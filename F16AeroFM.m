% ==========================
% Developed by
% Raktim Bhattacharya, 
% Professor
% Aerospace Engineering,
% Texas A&M University.
% ==========================

function FM = F16AeroFM(inp)

persistent Param F16Aero r2d persistent_flag
if isempty(persistent_flag)
    persistent_flag = 1;
    Param = load_F16_params(); % System Parameters, mass, inertia, etc.
    Data = load('F16AeroDataInterpolants.mat');
    F16Aero = Data.F16AeroData;
    r2d = 180/pi;
end

Vt    = inp(1);
alpha = inp(2)*r2d; % Convert to degrees for aero table look up.
beta  = inp(3)*r2d; % Convert to degrees for aero table look up.
om    = inp(4:6);
qbar  = inp(7);
ele   = inp(8)*r2d; % Convert to degrees for aero table look up.
ail   = inp(9)*r2d; % Convert to degrees for aero table look up.
rud   = inp(10)*r2d; % Convert to degrees for aero table look up.
lef   = inp(11)*r2d; % Convert to degrees for aero table look up.

p = om(1);
q = om(2);
r = om(3);

dail  = ail/21.5;        % Aileron angle normalized against max deflection
drud  = rud/30.0;        % Rudder normalized against max angle
dlef  = (1 - lef/25.0); % Leading edge flap normalized against max angle


% Interpolate aerodynamics data
% =============================
Cx = F16Aero.Cx(alpha,beta,ele);
Cy = F16Aero.Cy(alpha,beta);
Cz = F16Aero.Cz(alpha,beta,ele);
Cm = F16Aero.Cm(alpha,beta,ele);
Cn = F16Aero.Cn(alpha,beta,ele);
Cl = F16Aero.Cl(alpha,beta,ele);

delta_Cx_lef = F16Aero.Cx_lef(alpha,beta) - F16Aero.Cx(alpha,beta,0.0);
delta_Cy_lef = F16Aero.Cy_lef(alpha,beta) - F16Aero.Cy(alpha,beta);
delta_Cz_lef = F16Aero.Cz_lef(alpha,beta) - F16Aero.Cz(alpha,beta,0.0);

delta_Cl_lef = F16Aero.Cl_lef(alpha,beta) - F16Aero.Cl(alpha,beta,0.0);
delta_Cm_lef = F16Aero.Cm_lef(alpha,beta) - F16Aero.Cm(alpha,beta,0.0);
delta_Cn_lef = F16Aero.Cn_lef(alpha,beta) - F16Aero.Cn(alpha,beta,0.0);

Cxq = F16Aero.Cxq(alpha);
Cyr = F16Aero.Cyr(alpha);
Cyp = F16Aero.Cyp(alpha);
Czq = F16Aero.Czq(alpha);
Clr = F16Aero.Clr(alpha);
Clp = F16Aero.Clp(alpha);
Cmq = F16Aero.Cmq(alpha);
Cnr = F16Aero.Cnr(alpha);
Cnp = F16Aero.Cnp(alpha);

delta_Cxq_lef = F16Aero.deltaCxq_lef(alpha);
delta_Cyr_lef = F16Aero.deltaCyr_lef(alpha);
delta_Cyp_lef = F16Aero.deltaCyp_lef(alpha);
delta_Czq_lef = F16Aero.deltaCzq_lef(alpha);
delta_Clr_lef = F16Aero.deltaClr_lef(alpha);
delta_Clp_lef = F16Aero.deltaClp_lef(alpha);
delta_Cmq_lef = F16Aero.deltaCmq_lef(alpha);
delta_Cnr_lef = F16Aero.deltaCnr_lef(alpha);
delta_Cnp_lef = F16Aero.deltaCnp_lef(alpha);

delta_Cy_r30 = F16Aero.Cy_r30(alpha,beta) - F16Aero.Cy(alpha,beta);
delta_Cn_r30 = F16Aero.Cn_r30(alpha,beta) - F16Aero.Cn(alpha,beta,0.0);
delta_Cl_r30 = F16Aero.Cl_r30(alpha,beta) - F16Aero.Cl(alpha,beta,0.0);

delta_Cy_a20 = F16Aero.Cy_a20(alpha,beta) - F16Aero.Cy(alpha,beta);
delta_Cy_a20_lef = F16Aero.Cy_a20_lef(alpha,beta) - F16Aero.Cy_lef(alpha,beta) - delta_Cy_a20;

delta_Cn_a20 = F16Aero.Cn_a20(alpha,beta) - F16Aero.Cn(alpha,beta,0.0);
delta_Cn_a20_lef = F16Aero.Cn_a20_lef(alpha,beta) - F16Aero.Cn_lef(alpha,beta) - delta_Cn_a20;

delta_Cl_a20 = F16Aero.Cl_a20(alpha,beta) - F16Aero.Cl(alpha,beta,0.0);
delta_Cl_a20_lef = F16Aero.Cl_a20_lef(alpha,beta) - F16Aero.Cl_lef(alpha,beta) - delta_Cl_a20;

delta_Cnbeta = F16Aero.deltaCnbeta(alpha);
delta_Clbeta = F16Aero.deltaClbeta(alpha);
delta_Cm = F16Aero.deltaCm(alpha);
eta_el = F16Aero.eta_el(ele);
delta_Cm_ds = 0; % Ignore deep-stall effects.

% Compute total aerodynamic coefficients
% ======================================
% Compute total Cx
dXdq = (Param.cbar/(2*Vt))*(Cxq + delta_Cxq_lef*dlef);
Cx_tot = Cx + delta_Cx_lef*dlef + dXdq*q;

% Compute total Cz
dZdq = (Param.cbar/(2*Vt))*(Czq + delta_Cz_lef*dlef);
Cz_tot = Cz + delta_Cz_lef*dlef + dZdq*q;

% Compute total Cm
dMdq = (Param.cbar/(2*Vt))*(Cmq + delta_Cmq_lef*dlef);
Cm_tot = Cm*eta_el + Cz_tot*(Param.xcgr - Param.xcg) + delta_Cm_lef*dlef + dMdq*q + delta_Cm + delta_Cm_ds;

% Compute total Cy
dYdail = delta_Cy_a20 + delta_Cy_a20_lef*dlef;
dYdr = (Param.b/(2*Vt))*(Cyr + delta_Cyr_lef*dlef);
dYdp = (Param.b/(2*Vt))*(Cyp + delta_Cyp_lef*dlef);
Cy_tot = Cy + delta_Cy_lef*dlef + dYdail*dail + delta_Cy_r30*drud + dYdr*r + dYdp*p;

% Compute total Cn
dNdail = delta_Cn_a20 + delta_Cn_a20_lef*dlef;
dNdr = (Param.b/(2*Vt))*(Cnr + delta_Cnr_lef*dlef);
dNdp = (Param.b/(2*Vt))*(Cnp + delta_Cnp_lef*dlef);
Cn_tot = Cn + delta_Cn_lef*dlef - Cy_tot*(Param.xcgr - Param.xcg)*(Param.cbar/Param.b) + dNdail*dail + delta_Cn_r30*drud + dNdr*r + dNdp*p + delta_Cnbeta*beta;

% Compute total Cl
dLdail = delta_Cl_a20 + delta_Cl_a20_lef*dlef;
dLdr = (Param.b/(2*Vt))*(Clr + delta_Clr_lef*dlef);
dLdp = (Param.b/(2*Vt))*(Clp + delta_Clp_lef*dlef);
Cl_tot = Cl + delta_Cl_lef*dlef + dLdail*dail + delta_Cl_r30*drud + dLdr*r + dLdp*p + delta_Clbeta*beta;

% Compute forces
Fx = qbar*Param.S*Cx_tot;
Fy = qbar*Param.S*Cy_tot;
Fz = qbar*Param.S*Cz_tot;

% Compute moments
L = Cl_tot*qbar*Param.S*Param.b;  
M = Cm_tot*qbar*Param.S*Param.cbar;
N = Cn_tot*qbar*Param.S*Param.b;


% Fb = [Fx,Fy,Fz];
% Mb = [L,M,N];

FM = [Fx,Fy,Fz,L,M,N];

if isnan(norm(FM))
    keyboard
end

end
