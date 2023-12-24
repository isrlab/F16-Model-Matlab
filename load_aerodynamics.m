% ==========================
% Developed by
% Raktim Bhattacharya, 
% Professor
% Aerospace Engineering,
% Texas A&M University.
% ==========================

function F16AeroData = load_aerodynamics()
    Data = load('F16AeroDataInterpolants.mat');
    F16AeroData = Data.F16AeroData;
end