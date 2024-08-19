%load in variables
filename = input('Enter your file name with .extension: ', 's');
load(filename);
% PART I
% create Ax and Ay
[jrow, mcol] = size(C);
Axy = zeros(2*jrow, mcol);
len = zeros(1,mcol);
for c=1:mcol
   for r=1:jrow
       xcoords = X(C(:,c)' == 1);
       ycoords = Y(C(:,c)' == 1);
       indices = find(C(:,c)' == 1);
       Axy(indices(1),c) = ( ((xcoords(2) - xcoords(1)) / (sqrt( (xcoords(2)-xcoords(1))^2 + (ycoords(2)-ycoords(1))^2 ))) )  * C(indices(1),c);
       Axy(indices(2),c) = ( ((xcoords(1) - xcoords(2)) / (sqrt( (xcoords(2)-xcoords(1))^2 + (ycoords(2)-ycoords(1))^2 ))) )  * C(indices(2),c);
   
       Axy(indices(1)+jrow,c) = ( ((ycoords(2) - ycoords(1)) / (sqrt( (xcoords(2)-xcoords(1))^2 + (ycoords(2)-ycoords(1))^2 ))) )  * C(indices(1),c);
       Axy(indices(2)+jrow,c) = ( ((ycoords(1) - ycoords(2)) / (sqrt( (xcoords(2)-xcoords(1))^2 + (ycoords(2)-ycoords(1))^2 ))) )  * C(indices(2),c);
   end
   len(c) = (sqrt( (xcoords(2)-xcoords(1))^2 + (ycoords(2)-ycoords(1))^2 ));
end
% concatenate Axy and S
S = [Sx;Sy];
A = [Axy S];
% find T
T = inv(A)*L;
% PART II
% Rm values
wl = sum(L);
Rm = T'/wl;
% find wfail for each member
pcrit = zeros(1,mcol);
for i = 1:mcol
   pcrit(i) = 3654.533*(len(i)^(-2.119));
end 
wfail = zeros(1,mcol);
for i = 1:mcol
   wfail(i) = -pcrit(i)/Rm(i);
end
wfail = abs(wfail);
critmem = find(wfail == min(wfail));
% print summary
weight = sum(L);
cost = (10*jrow)+(1*sum(len));
fprintf('EK301, Section A3, Group 1: Adithi C., Ella C., Joelie S., 12/8/2023\n');
fprintf('Load: %.3f oz\n', weight);
% trusses and if in tension or compression
fprintf('Member force in oz:\n');
for i = 1:mcol
   fprintf('m%d: ', i);
   fprintf('%.3f ', T(i,1))
   if T(i,1) < 0
       fprintf('(C)\n');
   elseif T(i,1) > 0
       fprintf('(T)\n');
   elseif T(i,1) == 0
       fprintf('\n');
   end
end
% reactions
fprintf('Reaction forces in oz:\n');
fprintf('Sx1: %.3f\n', T(mcol+1,1));
fprintf('Sy1: %.3f\n', T(mcol+2,1));
fprintf('Sy2: %.3f\n', T(mcol+3,1));
% cost
fprintf('Cost of truss: $%.2f\n', cost);
fprintf('Theoretical max load/cost ratio in oz/$: %.2f\n', min(wfail)/cost);
% member(s) and failure weight(s)
fprintf("\nCricital Members and Failure Weight in oz:\n")
for i = 1:numel(critmem)
   fprintf("Member: %1d, Weight: %.3f \n", critmem(i), min(wfail));
end
