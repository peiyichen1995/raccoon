clc
clear

n_samples = 100;

c1_mean = 259.59;
% c2_mean = 21.343;
c2_mean = 16.1028;
g4_mean = 19.285;
beta3_mean = 3.6537;
beta4_mean = 500.02;

x_cv = 0.2;

a = 1/x_cv/x_cv;

c1_b = (c1_mean*x_cv*x_cv);
c2_b = (c2_mean*x_cv*x_cv);
g4_b = (g4_mean*x_cv*x_cv);
beta3_b = (beta3_mean*x_cv*x_cv);
beta4_b = (beta4_mean*x_cv*x_cv);

c1 = gamrnd(a,c1_b,n_samples,1);
c2 = gamrnd(a,c2_b,n_samples,1);
g4 = gamrnd(a,g4_b,n_samples,1);
beta3 = gamrnd(a,beta3_b,n_samples,1);
beta4 = gamrnd(a,beta4_b,n_samples,1);

% sample_mean = mean(x);
%
% sample_cv = std(x)/sample_mean;
eta = 2;
g1 = 4.1543;
g2 = 1.5;
% beta3 = 3.6537;

syms rho1 rho2;
eqn1 = rho1 - 2*g1/3^(1.5)/g2*rho2 == 0;
eqn2 = x_cv*x_cv - rho2/rho1/(rho1+rho2+1) == 0;
eqns = [eqn1 eqn2];

S = solve(eqns, [rho1 rho2]);

% rho2 = (1-x_cv*x_cv)/(eta*(eta+1)*x_cv*x_cv);
% rho1 = 2*g1/(3^(1.5)*g2)*rho2;
u = betarnd(eval(S.rho1),eval(S.rho2),[1 n_samples]);

fileID = fopen('rn_6.txt','w');
g1_samples = [];
g2_samples = [];
g3_samples = [];
for i = 1:n_samples
    %     fprintf(fileID,'mpiexec -n 10 ../../raccoon-opt -i strip.i g1=%f g2=%f g3=%f g4=%f sample=%d\n',c2(i)*u(i)/2,3^(-3/2)*c2(i)*(1-u(i)),c1(i)/2/beta3/beta3,g4(i),i);
    fprintf(fileID,'g1=%f g2=%f g3=%f g4=%f beta3=%f beta4=%f sample=%d\n',c2(i)*u(i)/2,3^(-3/2)*c2(i)*(1-u(i)),c1(i)/2/beta3(i)/beta3(i),g4(i),beta3(i),beta4(i),i);
    g1_samples = [g1_samples;c2(i)*u(i)/2];
    g2_samples = [g2_samples;3^(-3/2)*c2(i)*(1-u(i))];
    g3_samples = [g3_samples;c1(i)/2/beta3(i)/beta3(i)];
    
end

fclose(fileID);
