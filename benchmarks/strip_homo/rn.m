clc
clear

n_samples = 50;

c1_mean = 259.59;
c2_mean = 21.343;
g4_mean = 19.285;

x_cv = 0.4;

a = 1/x_cv/x_cv;

c1_b = (c1_mean*x_cv*x_cv);
c2_b = (c2_mean*x_cv*x_cv);
g4_b = (g4_mean*x_cv*x_cv);

c1 = gamrnd(a,c1_b,n_samples,1);
c2 = gamrnd(a,c2_b,n_samples,1);
g4 = gamrnd(a,g4_b,n_samples,1);

% sample_mean = mean(x);
%
% sample_cv = std(x)/sample_mean;
eta = 2;
g1 = 4.1543;
g2 = 2.5084;
beta3 = 3.6537;
rho2 = (1-x_cv*x_cv)/(eta*(eta+1)*x_cv*x_cv);
rho1 = 2*g1/(3^(1.5)*g2);
u = betarnd(rho1,rho2,[1 n_samples]);

fileID = fopen('rn.txt','w');

for i = 1:n_samples
    %     fprintf(fileID,'mpiexec -n 10 ../../raccoon-opt -i strip.i g1=%f g2=%f g3=%f g4=%f sample=%d\n',c2(i)*u(i)/2,3^(-3/2)*c2(i)*(1-u(i)),c1(i)/2/beta3/beta3,g4(i),i);
    fprintf(fileID,'g1=%f g2=%f g3=%f g4=%f sample=%d\n',c2(i)*u(i)/2,3^(-3/2)*c2(i)*(1-u(i)),c1(i)/2/beta3/beta3,g4(i),i);
end

fclose(fileID);
