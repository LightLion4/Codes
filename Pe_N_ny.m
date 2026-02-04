% 初始化参数
power1 = 10; % 前向信道功率
sigma1 = 1;   % 前向信道的噪声方差
power2 = 1000; % 反馈信道功率
sigma2 = 1;   % 反馈信道的噪声方差

SNR1 = power1 / sigma1; % 前向信道的信噪比
SNR2 = power2 / sigma2; % 反馈信道的信噪比

R = 0.64; % 固定速率值
P = 0.4;

C = (1/2) * log2(1 + SNR1);

% 定义码长 N 的取值范围
N_values = 40:40:200;
num_N = length(N_values);
Pe_values = zeros(1, num_N);

% 二分法求解 Pe 的误差容限
tolerance = 1e-20;

% 遍历每个 N 值，求解对应的 Pe
for i = 1:num_N
    N = N_values(i);
    
    % 二分法求解 Pe
    Pe_min = 1e-10;
    Pe_max = 1;
    while (Pe_max - Pe_min) > tolerance
        Pe_mid = (Pe_min + Pe_max) / 2;
        
        L = (1/3) * (qfuncinv(Pe_mid / (4 * (N - 1))))^2; 
        T3 = ((1 + SNR1) * (qfuncinv(Pe_mid / 4))^2) / (3 * SNR1);
        T2 = 1 + L * (SNR1 / SNR2);
        T1 = ((1 + SNR1) * (qfuncinv(Pe_mid / 2))^2) / (3 * SNR1);
        R_calculated = P * C - P * (1/2) * log2(((T3/T2)^(1/N)) * T2);
        
        if R_calculated > R
            Pe_max = Pe_mid;
        else
            Pe_min = Pe_mid;
        end
    end
    
    Pe_values(i) = (Pe_min + Pe_max) / 2;
end

% 输出结果
disp('码长 N 对应的译码错误概率 Pe:');
for i = 1:num_N
    fprintf('N = %d, Pe = %.8e\n', N_values(i), Pe_values(i));
end

% 绘制 N 与 Pe 的关系曲线
figure;
plot(N_values, Pe_values, 'b-o');
grid on;
set(gca, 'FontSize', 12, 'FontWeight', 'bold', 'FontName', '新宋体', 'YScale', 'log');
xlabel('码长 N', 'Rotation', 11, 'FontSize', 15);
ylabel('译码错误概率 Pe', 'Rotation', -25, 'FontSize', 15);
title('码长 N 与译码错误概率 Pe 的关系', 'FontSize', 15);