clc; clear all;

d2r = pi/180;
% Read independent variables
alpha1 = h5read('F16AeroData.h5','/alpha1');
alpha2 = h5read('F16AeroData.h5','/alpha2');
beta1 = h5read('F16AeroData.h5','/beta1');
dh1 = h5read('F16AeroData.h5','/dh1');
dh2 = h5read('F16AeroData.h5','/dh2');

% Force coefficients
F16AeroData.Cx = createAeroFunction(h5read('F16AeroData.h5','/_Cx'),alpha1,beta1,dh1);
F16AeroData.Cy = createAeroFunction(h5read('F16AeroData.h5','/_Cy'),alpha1,beta1);
F16AeroData.Cz = createAeroFunction(h5read('F16AeroData.h5','/_Cz'),alpha1,beta1,dh1);

% Moment coefficients
F16AeroData.Cl = createAeroFunction(h5read('F16AeroData.h5','/_Cl'),alpha1,beta1,dh2);
F16AeroData.Cm = createAeroFunction(h5read('F16AeroData.h5','/_Cm'),alpha1,beta1,dh1);
F16AeroData.Cn = createAeroFunction(h5read('F16AeroData.h5','/_Cn'),alpha1,beta1,dh2);

% Leading edge influences
F16AeroData.Cx_lef = createAeroFunction(h5read('F16AeroData.h5','/_Cx_lef'),alpha2,beta1);
F16AeroData.Cy_lef = createAeroFunction(h5read('F16AeroData.h5','/_Cy_lef'),alpha2,beta1);
F16AeroData.Cz_lef = createAeroFunction(h5read('F16AeroData.h5','/_Cz_lef'),alpha2,beta1);

F16AeroData.Cl_lef = createAeroFunction(h5read('F16AeroData.h5','/_Cl_lef'),alpha2,beta1);
F16AeroData.Cm_lef = createAeroFunction(h5read('F16AeroData.h5','/_Cm_lef'),alpha2,beta1);
F16AeroData.Cn_lef = createAeroFunction(h5read('F16AeroData.h5','/_Cn_lef'),alpha2,beta1);

% Stability Derivatives
F16AeroData.Cxq = createAeroFunction(h5read('F16AeroData.h5','/_Cxq'),alpha1);
F16AeroData.Cyp = createAeroFunction(h5read('F16AeroData.h5','/_Cyp'),alpha1);
F16AeroData.Czq = createAeroFunction(h5read('F16AeroData.h5','/_Czq'),alpha1);
F16AeroData.Cmq = createAeroFunction(h5read('F16AeroData.h5','/_Cmq'),alpha1);

F16AeroData.Cyr = createAeroFunction(h5read('F16AeroData.h5','/_Cyr'),alpha1);
F16AeroData.Cnr = createAeroFunction(h5read('F16AeroData.h5','/_Cnr'),alpha1);

F16AeroData.Cnp = createAeroFunction(h5read('F16AeroData.h5','/_Cnp'),alpha1);
F16AeroData.Clp = createAeroFunction(h5read('F16AeroData.h5','/_Clp'),alpha1);
F16AeroData.Clr = createAeroFunction(h5read('F16AeroData.h5','/_Clr'),alpha1);

F16AeroData.deltaCxq_lef = createAeroFunction(h5read('F16AeroData.h5','/_deltaCxq_lef'),alpha2);
F16AeroData.deltaCyr_lef = createAeroFunction(h5read('F16AeroData.h5','/_deltaCyr_lef'),alpha2);
F16AeroData.deltaCyp_lef = createAeroFunction(h5read('F16AeroData.h5','/_deltaCyp_lef'),alpha2);

F16AeroData.deltaCzq_lef = createAeroFunction(h5read('F16AeroData.h5','/_deltaCzq_lef'),alpha2);
F16AeroData.deltaClr_lef = createAeroFunction(h5read('F16AeroData.h5','/_deltaClr_lef'),alpha2);
F16AeroData.deltaClp_lef = createAeroFunction(h5read('F16AeroData.h5','/_deltaClp_lef'),alpha2);

F16AeroData.deltaCmq_lef = createAeroFunction(h5read('F16AeroData.h5','/_deltaCmq_lef'),alpha2);
F16AeroData.deltaCnr_lef = createAeroFunction(h5read('F16AeroData.h5','/_deltaCnr_lef'),alpha2);
F16AeroData.deltaCnp_lef = createAeroFunction(h5read('F16AeroData.h5','/_deltaCnp_lef'),alpha2);

% Other data
F16AeroData.Cy_r30 = createAeroFunction(h5read('F16AeroData.h5','/_Cy_r30'),alpha1,beta1);
F16AeroData.Cn_r30 = createAeroFunction(h5read('F16AeroData.h5','/_Cn_r30'),alpha1,beta1);
F16AeroData.Cl_r30 = createAeroFunction(h5read('F16AeroData.h5','/_Cl_r30'),alpha1,beta1);

F16AeroData.Cy_a20 = createAeroFunction(h5read('F16AeroData.h5','/_Cy_a20'),alpha1,beta1);
F16AeroData.Cy_a20_lef = createAeroFunction(h5read('F16AeroData.h5','/_Cy_a20_lef'),alpha2,beta1);

F16AeroData.Cn_a20 = createAeroFunction(h5read('F16AeroData.h5','/_Cn_a20'),alpha1,beta1);
F16AeroData.Cn_a20_lef = createAeroFunction(h5read('F16AeroData.h5','/_Cn_a20_lef'),alpha2,beta1);

F16AeroData.Cl_a20 = createAeroFunction(h5read('F16AeroData.h5','/_Cl_a20'),alpha1,beta1);
F16AeroData.Cl_a20_lef = createAeroFunction(h5read('F16AeroData.h5','/_Cl_a20_lef'),alpha2,beta1);

F16AeroData.deltaCnbeta = createAeroFunction(h5read('F16AeroData.h5','/_deltaCnbeta'),alpha1);
F16AeroData.deltaClbeta = createAeroFunction(h5read('F16AeroData.h5','/_deltaClbeta'),alpha1);
F16AeroData.deltaCm = createAeroFunction(h5read('F16AeroData.h5','/_deltaCm'),alpha1);

F16AeroData.eta_el = createAeroFunction(h5read('F16AeroData.h5','/_eta_el'),dh1);

save F16AeroDataInterpolants F16AeroData

function fcn = createAeroFunction(data,varargin)
n = length(varargin);
L = zeros(1,n);
for i = 1:n
    L(i) = length(varargin{i});
end

if n == 1
    fcn = griddedInterpolant(varargin,data,'linear','none');
else
    fcn = griddedInterpolant(varargin,reshape(data,L),'linear','none');
end

end