M1 = 4;
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

%disp(counter + " iterations");
%disp(rad2deg(theta) + " deg");
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

%export_matrix = [M1 rad2deg(theta) M2 T_ratio p_ratio];
%disp(export_matrix);
%up until this point, this is the exact same code as the ideal computation
R = 287.05;
e = exp(1);
T1 = 225;
T2 = T_ratio*T1;
u = gamma*R*T2*Mn2;
V1 = gamma*R*225*M1;
T_r = 3070;
Tr = T_r;
Tr_ratio = T_r/T2;
expTr = e^(Tr_ratio);
cp = R * (7/2 + Tr_ratio^2 + expTr/(expTr-1)^2);
beta = theta;
%necessary constants and intermediate values for real flow approximation

valo1 = (gamma-1)/gamma * e^(Tr_ratio)*Tr_ratio^2/(e^(Tr_ratio)-1) + 1;
valo2 = 1;
valo3 = u/cp;
valo4 = 2*u/R - (T1+(V1*sin(theta))^2/R)/(V1*sin(theta));
mat = [valo1 valo3; valo2 valo4];
%Jacobian matrix

f = T2 + u^2/(2*cp) + (gamval4/gamma)*(Tr/(e^Tr_ratio-1)) - (T1 + (V1*sin(beta)^2)/(2*cp)+(gamval4/gamma)*(Tr/e^Tr_ratio-1));
g = T2 + u^2/R - (T1 + (V1*sin(beta))^2/R)*u/(V1*sin(beta));
%initial f and g values

oof = true;
while oof
    T_n = T2 - (f*valo4 - g*valo3)/(valo1*valo4-valo2*valo3);
    U_n = u - (valo1*g-valo2*f)/(valo1*valo4-valo2*valo3);
    %compute next T2, u2

    valo5 = sqrt(((U_n-u)/u)^2 + ((T_n-T2)/T2)^2);
    if (valo5 < 0.01)
        oof = false;
    else 
        T2 = T_n;
        u = U_n;
        f = T2 + u^2/(2*cp) + (gamval4/gamma)*(Tr/(e^Tr_ratio-1)) - (T1 + (V1*sin(beta)^2)/(2*cp)+(gamval4/gamma)*(Tr/e^Tr_ratio-1));
        g = T2 + u^2/R - (T1 + (V1*sin(beta))^2/R)*u/(V1*sin(beta));
        valo1 = (gamma-1)/gamma * e^(Tr_ratio)*Tr_ratio^2/(e^(Tr_ratio)-1) + 1;
        valo2 = 1;
        valo3 = u/cp;
        valo4 = 2*u/R - (T1+(V1*sin(theta))^2/R)/(V1*sin(theta));
    end 
end
%iterating for new T2, u values

B_theta = (1-0.5*(sin(2*beta-delta_s))*tan(beta))^(-1);
theta_j = atan((V1*sin(beta)-u)/(V1*cos(beta)+u*tan(beta)));
beta = beta - B_theta*(theta_j - theta);
%computing new shock angle

Tr_ratio = T_r/T2;
expTr = e^(Tr_ratio);
c_vn = (5/2 + expTr*Tr_ratio/(expTr - 1)^2)*R;
c_pn = R + c_vn;
gamma_2 = c_pn/c_vn;
%computing new heat capacity ratio

V2 = u/sin(beta-delta_s);
M2 = V2/sqrt(gamma_2*R*T2);
p_ratio = (1+gamma*(M1*sin(beta))^2)/(1+gamma_2*(M2*sin(beta-delta_s))^2);
T_ratio = T2/T1;
%computing new values

T02 = T2 * (1 + (gamma_2-1)/2*M2^2);
T01 = T1 * (1 + (gamma-1)/2*M1^2);
To_ratio = T02/T01;
%computing stagnation ratio

output = [M1 rad2deg(beta) M2 T_ratio To_ratio p_ratio];
disp(output);