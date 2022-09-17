%define constants
alpha = deg2rad(4.2); %change this, this is the input variable
AR = 5;
Sweep = deg2rad(45);
Vinf = 163; %ft/s
c = 20/12; %20 inches conversion to feet
s = AR*c;
bignum = -10^120;
Vrel = Vinf*sin(alpha);
quarterchord = 5.78;
threequarterchord = 2.685;
chord = c;
chordslope = -0.11;
rho = 0.0765;

%create 8 panel horseshoe vertices. format: [chordwise point 1, 
%chordwise point 2, left trailing point 1, left trailing point 2, 
%right trailing point 1,  right trailing point 2]
j1 = [0 s/8*cos(Sweep) 0 0 s/8*cos(Sweep) s/8*cos(Sweep); -c/4 -c/4-s/8*cos(Sweep) -c/4 bignum -c/4-s/8*cos(Sweep) bignum];
j2 = [0 -s/8*cos(Sweep) 0 0 -s/8*cos(Sweep) -s/8*cos(Sweep); -c/4 -c/4-s/8*cos(Sweep) -c/4 bignum -c/4-s/8*cos(Sweep) bignum];
j3 = [s/8*cos(Sweep) s/4*cos(Sweep) s/8*cos(Sweep) s/8*cos(Sweep) s/4*cos(Sweep) s/4*cos(Sweep); -c/4-s/8*cos(Sweep) -c/4-s/4*cos(Sweep) -c/4-s/8*cos(Sweep) bignum -c/4-s/4*cos(Sweep) bignum];
j4 = [-s/8*cos(Sweep) -s/4*cos(Sweep) -s/8*cos(Sweep) -s/8*cos(Sweep) -s/4*cos(Sweep) -s/4*cos(Sweep); -c/4-s/8*cos(Sweep) -c/4-s/4*cos(Sweep) -c/4-s/8*cos(Sweep) bignum -c/4-s/4*cos(Sweep) bignum];
j5 = [s/4*cos(Sweep) 3*s/8*cos(Sweep) s/4*cos(Sweep) s/4*cos(Sweep) 3*s/8*cos(Sweep) 3*s/8*cos(Sweep); -c/4-s/4*cos(Sweep) -c/4-3*s/8*cos(Sweep) -c/4-s/4*cos(Sweep) bignum -c/4-3*s/8*cos(Sweep) bignum];
j6 = [-s/4*cos(Sweep) -3*s/8*cos(Sweep) -s/4*cos(Sweep) -s/4*cos(Sweep) -3*s/8*cos(Sweep) -3*s/8*cos(Sweep); -c/4-s/4*cos(Sweep) -c/4-3*s/8*cos(Sweep) -c/4-s/4*cos(Sweep) bignum -c/4-3*s/8*cos(Sweep) bignum];
j7 = [3*s/8*cos(Sweep) s/2*cos(Sweep) 3*s/8*cos(Sweep) 3*s/8*cos(Sweep) s/2*cos(Sweep) s/2*cos(Sweep); -c/4-3*s/8*cos(Sweep) -c/4-s/2*cos(Sweep) -c/4-3*s/8*cos(Sweep) bignum -c/4-s/2*cos(Sweep) bignum];
j8 = [-3*s/8*cos(Sweep) -s/2*cos(Sweep) -3*s/8*cos(Sweep) -3*s/8*cos(Sweep) -s/2*cos(Sweep) -s/2*cos(Sweep); -c/4-3*s/8*cos(Sweep) -c/4-s/2*cos(Sweep) -c/4-3*s/8*cos(Sweep) bignum -c/4-s/2*cos(Sweep) bignum];

%compute control point locations
cpoints = [s/16*cos(Sweep) s/16*cos(Sweep)+s/8*cos(Sweep) s/16*cos(Sweep)+s/4*cos(Sweep) s/16*cos(Sweep)+3*s/8*cos(Sweep) -s/16*cos(Sweep) -s/16*cos(Sweep)-s/8*cos(Sweep) -s/16*cos(Sweep)-s/4*cos(Sweep) -s/16*cos(Sweep)-3*s/8*cos(Sweep);-3/4*c-s/16*cos(Sweep) -3/4*c-(s/16*cos(Sweep)+s/8*cos(Sweep)) -3/4*c-(s/16*cos(Sweep)+s/4*cos(Sweep)) -3/4*c-(s/16*cos(Sweep)+3*s/8*cos(Sweep)) -3/4*c-s/16*cos(Sweep) -3/4*c-(s/16*cos(Sweep)+s/8*cos(Sweep)) -3/4*c-(s/16*cos(Sweep)+s/4*cos(Sweep)) -3/4*c-(s/16*cos(Sweep)+3*s/8*cos(Sweep))];

%implement biot-savart law to determine Aij
final = [];
for i=1:8
    cp = cpoints(:, i);
    results = [];
    output = [];
    for j=1:8
        for k=1:2:6
            if j==1
                r1 = cp - j1(:, k);
                r2 = cp - j1(:, k+1);
                if k==1
                    r1 = [r1;(quarterchord-threequarterchord)*chord/100];
                    r2 = [r2;(quarterchord-threequarterchord)*chord/100];
                else 
                    r1 = [r1;(quarterchord-threequarterchord)*chord/100];
                    r2 = [r2;threequarterchord*chord/100];
                end
                numerator = (norm(r1)+norm(r2))*(1-(dot(r1,r2))/(norm(r1)*norm(r2)));
                denom = (norm(r1)*norm(r2))^2 - (dot(r1, r2))^2 + (norm(r1)^2 + norm(r2)^2 - 2*(dot(r1, r2)));
                Aj = cross(r1, r2) .* numerator/denom *1/(4*pi);
                results = [results Aj];
            elseif j==2
                r1 = cp - j2(:, k);
                r2 = cp - j2(:, k+1);
                if k==1
                    r1 = [r1;(quarterchord-threequarterchord)*chord/100];
                    r2 = [r2;(quarterchord-threequarterchord)*chord/100];
                else 
                    r1 = [r1;(quarterchord-threequarterchord)*chord/100];
                    r2 = [r2;threequarterchord*chord/100];
                end
                numerator = (norm(r1)+norm(r2))*(1-(dot(r1,r2))/(norm(r1)*norm(r2)));
                denom = (norm(r1)*norm(r2))^2 - (dot(r1, r2))^2 + (norm(r1)^2 + norm(r2)^2 - 2*(dot(r1, r2)));
                Aj = cross(r1, r2) .* numerator/denom *1/(4*pi);
                results = [results Aj];
            elseif j==3
                r1 = cp - j3(:, k);
                r2 = cp - j3(:, k+1);
                if k==1
                    r1 = [r1;(quarterchord-threequarterchord)*chord/100];
                    r2 = [r2;(quarterchord-threequarterchord)*chord/100];
                else 
                    r1 = [r1;(quarterchord-threequarterchord)*chord/100];
                    r2 = [r2;threequarterchord*chord/100];
                end
                numerator = (norm(r1)+norm(r2))*(1-(dot(r1,r2))/(norm(r1)*norm(r2)));
                denom = (norm(r1)*norm(r2))^2 - (dot(r1, r2))^2 + (norm(r1)^2 + norm(r2)^2 - 2*(dot(r1, r2)));
                Aj = cross(r1, r2) .* numerator/denom *1/(4*pi);
                results = [results Aj];
            elseif j==4
                r1 = cp - j4(:, k);
                r2 = cp - j4(:, k+1);
                if k==1
                    r1 = [r1;(quarterchord-threequarterchord)*chord/100];
                    r2 = [r2;(quarterchord-threequarterchord)*chord/100];
                else 
                    r1 = [r1;(quarterchord-threequarterchord)*chord/100];
                    r2 = [r2;threequarterchord*chord/100];
                end
                numerator = (norm(r1)+norm(r2))*(1-(dot(r1,r2))/(norm(r1)*norm(r2)));
                denom = (norm(r1)*norm(r2))^2 - (dot(r1, r2))^2 + (norm(r1)^2 + norm(r2)^2 - 2*(dot(r1, r2)));
                Aj = cross(r1, r2) .* numerator/denom *1/(4*pi);
                results = [results Aj];
            elseif j==5
                r1 = cp - j5(:, k);
                r2 = cp - j5(:, k+1);
                if k==1
                    r1 = [r1;(quarterchord-threequarterchord)*chord/100];
                    r2 = [r2;(quarterchord-threequarterchord)*chord/100];
                else 
                    r1 = [r1;(quarterchord-threequarterchord)*chord/100];
                    r2 = [r2;threequarterchord*chord/100];
                end
                numerator = (norm(r1)+norm(r2))*(1-(dot(r1,r2))/(norm(r1)*norm(r2)));
                denom = (norm(r1)*norm(r2))^2 - (dot(r1, r2))^2 + (norm(r1)^2 + norm(r2)^2 - 2*(dot(r1, r2)));
                Aj = cross(r1, r2) .* numerator/denom *1/(4*pi);
                results = [results Aj];
            elseif j==6
                r1 = cp - j6(:, k);
                r2 = cp - j6(:, k+1);
                if k==1
                    r1 = [r1;(quarterchord-threequarterchord)*chord/100];
                    r2 = [r2;(quarterchord-threequarterchord)*chord/100];
                else 
                    r1 = [r1;(quarterchord-threequarterchord)*chord/100];
                    r2 = [r2;threequarterchord*chord/100];
                end
                numerator = (norm(r1)+norm(r2))*(1-(dot(r1,r2))/(norm(r1)*norm(r2)));
                denom = (norm(r1)*norm(r2))^2 - (dot(r1, r2))^2 + (norm(r1)^2 + norm(r2)^2 - 2*(dot(r1, r2)));
                Aj = cross(r1, r2) .* numerator/denom *1/(4*pi);
                results = [results Aj];
            elseif j==7
                r1 = cp - j7(:, k);
                r2 = cp - j7(:, k+1);
                if k==1
                    r1 = [r1;(quarterchord-threequarterchord)*chord/100];
                    r2 = [r2;(quarterchord-threequarterchord)*chord/100];
                else 
                    r1 = [r1;(quarterchord-threequarterchord)*chord/100];
                    r2 = [r2;threequarterchord*chord/100];
                end
                numerator = (norm(r1)+norm(r2))*(1-(dot(r1,r2))/(norm(r1)*norm(r2)));
                denom = (norm(r1)*norm(r2))^2 - (dot(r1, r2))^2 + (norm(r1)^2 + norm(r2)^2 - 2*(dot(r1, r2)));
                Aj = cross(r1, r2) .* numerator/denom *1/(4*pi);
                results = [results Aj];
            elseif j==8
                r1 = cp - j8(:, k);
                r2 = cp - j8(:, k+1);
                if k==1
                    r1 = [r1;(quarterchord-threequarterchord)*chord/100];
                    r2 = [r2;(quarterchord-threequarterchord)*chord/100];
                else 
                    r1 = [r1;(quarterchord-threequarterchord)*chord/100];
                    r2 = [r2;threequarterchord*chord/100];
                end
                numerator = (norm(r1)+norm(r2))*(1-(dot(r1,r2))/(norm(r1)*norm(r2)));
                denom = (norm(r1)*norm(r2))^2 - (dot(r1, r2))^2 + (norm(r1)^2 + norm(r2)^2 - 2*(dot(r1, r2)));
                Aj = cross(r1, r2) .* numerator/denom *1/(4*pi);
                results = [results Aj];
            end
        end
    end
     %manipulate results matrix to obtain a row of Aij
    results = squeeze(sum(reshape(results, size(results,1), 3, []),2));
    output = [norm(results(:, 1)) norm(results(:, 2)) norm(results(:, 3)) norm(results(:, 4)) norm(results(:, 5)) norm(results(:, 6)) norm(results(:, 7)) norm(results(:, 8))];
    final = vertcat(final, output);
end 
    %solve matrix equation for vortex strength
    Vterm = dot(Vrel,chordslope);
    rightside = [Vterm; Vterm; Vterm; Vterm; Vterm; Vterm; Vterm; Vterm];
    inversion = inv(final);
    gammas = inversion * -rightside;
    %compute the lift generated by each horseshoe vortex
    Lift = 0;
    for z=1:8
        Lift = Lift + gammas(z, 1)*rho*Vinf*s/8;
    end
    %determine the lift coefficient
    Cl = 2*Lift/(Vinf^2*rho*c*s);
    disp(Cl);
