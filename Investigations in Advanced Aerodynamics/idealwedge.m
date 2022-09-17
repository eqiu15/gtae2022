M1 = 24;
delta_s = deg2rad(15);
gamma = 1.4;
gamval1 = (gamma+1)/2;
gamval2 = (gamma-1)/2;
%input variables and some intermediate terms

upper_bound = deg2rad(90);
lower_bound = delta_s;
delta_r = 1000000;
theta = 0;
counter = 0;
%loop initial conditions

while(abs(rad2deg(delta_r)-rad2deg(delta_s)) >= 0.0001)
theta = (lower_bound + upper_bound)/2;
eqn = cot(theta)*(M1^2*(sin(theta))^2-1)/(gamval1*M1^2-(M1^2*(sin(theta))^2-1));
delta_r = atan(eqn);
if (delta_r > delta_s)
    upper_bound = theta;
else
    lower_bound = theta;
end
counter = counter + 1;
end
%iterate, converging to shock angle and keeping track of # of iterations

disp(counter + " iterations");
disp(rad2deg(theta) + " deg");
%display converged beta value and iteration count

term1 = 1 + gamval2*M1^2;
term2 = gamma*M1^2*(sin(theta))^2-gamval2;
term3 = M1^2*(cos(theta))^2;
term4 = 1+gamval2*M1^2*(sin(theta))^2;
M2 = sqrt(term1/term2 + term3/term4);
%compute the Mach number behind the shock

Mn1 = M1*sin(theta);
gamval3 = gamma+1;
gamval4 = gamma-1;
%more intermediate values

rho_ratio = gamval3*Mn1^2/(gamval4*Mn1^2+2);
p_ratio = 1 + 2*gamma/gamval3*(Mn1^2-1);
T_ratio = p_ratio/rho_ratio;
%computing stagnation ratios

term5 = Mn1^2 + 2/gamval4;
term6 = 2*gamma/gamval4*Mn1^2 - 1;
Mn2 = sqrt(term5/term6);
M2 = Mn2/sin(theta-delta_s);
%computing new Mach number

export_matrix = [M1 rad2deg(theta) M2 T_ratio p_ratio];
disp(export_matrix);