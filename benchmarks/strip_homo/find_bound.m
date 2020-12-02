clear


% for L = 1:5
%     data = [];
%     for sample = 1:20
%         M = readmatrix(['stress_xx_L_', num2str(L), '_sample_', num2str(sample), '.csv']);
%         data = [data, M(:, 2)];
%     end
%     stretch = (0:30)*0.01+1;
%     lb = min(data, [], 2);
%     ub = max(data, [], 2);
%     writematrix([stret
% ch',lb,ub], ['L_', num2str(L), '_bounds.csv']);
% end

data = [];
for sample = 1:50
    M = readmatrix(['stress_xx_sample_', num2str(sample), '.csv']);
    data = [data, M(:, 2)];
    stretch = (0:30)*0.01+1;
    plot(stretch, M(:, 2),'black');
    hold on;
end
stretch = (0:30)*0.01+1;
lb = min(data, [], 2);
ub = max(data, [], 2);
writematrix([stretch',lb,ub], ['0.2_bounds.csv']);

M = readmatrix(['stress_xx_sample_mean.csv']);
plot(stretch, M(:, 2),'red');