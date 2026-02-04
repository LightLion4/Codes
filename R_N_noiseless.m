power1 = 10; % 前向信道功率
sigma1 = 1;   % 前向信道的噪声方差

SNR1 = power1/sigma1; % 前向信道的信噪比

C = (1/2)*log2(1+SNR1);

P = 0.4;
pe = 10^(-6); % 固定译码错误概率

N_values = 5:5:400; % 码长范围
num_N = length(N_values);
R_values = zeros(1, num_N); % 用于存储不同码长对应的码率

for i = 1:num_N
    N = N_values(i);
    T1 = ((1+SNR1)*(qfuncinv(pe/2)^2))/(3*SNR1);
    R = P*C - (P/(2*N))*log2(T1);
    R_values(i) = R;
end

% 输出结果
disp('码长 N 对应的码率 R:');
disp([N_values; R_values]);

% 绘制图形
figure;
line([5,400],[P*C,P*C],'LineWidth', 2, 'Color', 'r', 'LineStyle', '--', 'DisplayName', '\rhoC: C is Shannon limit of the dirty paper Gaussian channel'); % 设置第二条线宽度为 2，颜色为红色，线条样式为虚线，并设置图例显示名称
hold on;
plot(N_values, R_values, 'LineWidth', 2, 'Color', 'b', 'DisplayName', 'R_{avg}^{nl}'); % 设置第一条线宽度为 2，颜色为蓝色，并设置图例显示名称
hold off;
grid on;
set(gca, 'FontSize', 12, 'FontWeight', 'bold','FontName','Times New Roman');
xlabel('Codeword length', 'FontSize', 15);
ylabel('Rate (bits/symbol)', 'FontSize', 15);

% 添加图例
legend('show');
    