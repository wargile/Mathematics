%#eml
function y = Sampling_error(u1, u2)
% Note #eml directive above, that tells MATLAB to compile this function
% for use % in a Simulink model (see Terje1.mdl)

weights = 1./(3:1:8); % Note mrdivide syntax

S1 = (u1.*weights')'*u1;
S2 = (u2.*weights')'*u2;

y = S1 - S2;
