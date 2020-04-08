% For calculating the center, radius, sigma 1 and sigma 3 
% from two stress planes on the Mohr Circle
%
%       Clay Barlow, Geoscience Undergraduate
%       @ Utah State University
%
%
%   Inputs: Sigma normal and Sigma shear of two planes
%   Outputs: Center & radius of Mohr Circle and Sigma 1 and 3
%   Uses system of equations to solve radius of circle equations 
%        and Normal Stress & Shear Stress equations
%

function MCC = MohrCircleCalculations ()
% creates prompt to input values, defaults from hw assignment
prompt = {'Enter sigma1n: ', 'Enter s1s: ', 'Enter sigma2n: ', 'Enter s2s: '};
dlgtitle = 'Inputs';
dims = [1 35];
definput = {'100', '45', '30', '10'};
answer = inputdlg(prompt,dlgtitle,dims,definput);

n1 = str2double(answer(1));
s1 = str2double(answer(2));
n2 = str2double(answer(3));
s2 = str2double(answer(4));

%System of 3 eqs to calc center of mohr circle and radius
syms h k r
eqn1 = (n1 - h)^2 + ( s1 - k)^2 == r^2;
eqn2 = (n2 - h)^2 + ( s2 - k)^2 == r^2;
eqn3 = (n1 - h)^2 + (-s1 - k)^2 == r^2;

center = solve([eqn1, eqn2, eqn3], [h, k, r], 'principalValue', true);
R = center.r;
C = center.h;

fprintf('Center: %.2f , %.2f \n If not on x axis, then some error has occurred\n', C, center.k);
fprintf('Radius: %.2f \n', abs(R));

%Use center and radius to get principal stresses sig1 sig3
syms sig1 sig3
eqn4 = (sig1 - sig3)/2 == R;
eqn5 = (sig1 + sig3)/2 == C;

sigma = solve([eqn4, eqn5], [sig1, sig3], 'principalValue', false);
sigma3 = sigma.sig1; %idk why matlab swaps these? doing by hand gets this result like this
sigma1 = sigma.sig3;

fprintf('Sigma 1: %.2f \nSigma 3: %.2f \n', sigma1, sigma3);

%Use sigma 1,3 to calc angle between them
q1 = acosd((n1 - (sigma1 + sigma3) /2) / ((sigma1 - sigma3) /2))/2;
q2 = acosd((n2 - (sigma1 + sigma3) /2) / ((sigma1 - sigma3) /2))/2;

%angle1 = abs(solve(eqn6, q1, 'principalValue', false));
%angle2 = abs(solve(eqn7, q2, 'principalValue', false));
fprintf('Angles: %.2f, %.2f\n', q1, q2);
fprintf('Angle between planes: %.2fº\n', q1-q2);

