% 给定的参数
power1 = 10; % 前向信道的发射功率
sigma1 = 1; % 前向信道的噪声方差
power2 = [10000, 1000, 316.2]; % 反馈信道的发射功率
sigma2 = 1; % 反馈信道的噪声方差

P = 0.4; % URLLC消息的概率
pe = 10^(-6); % 解码错误概率
N_values = 5:10:115; % 块长度的取值范围

% 前向信道的信噪比
SNR1 = power1 / sigma1;

% 初始化结果矩阵
savematrix1 = zeros(length(power2), length(N_values)); % 用于存储不同反馈信道功率和码长下的R值
CC = zeros(1, length(N_values));

for ii = 1:2000
    % 生成复高斯分布的随机数，均值为0，方差为1
    h1 = 1/sqrt(2) * (randn + 1i*randn);
    h2 = 1/sqrt(2) * (randn + 1i*randn); % 反馈信道的衰落系数
    
    for jj = 1:length(N_values)
        N = N_values(jj);
        % 前向信道的香农极限
        C = log2(1 + h1 * conj(h1) * SNR1);
        for i = 1:length(power2)
            % 反馈信道的信噪比
            SNR2 = power2(i) / sigma2;
            % 计算Gamma值
            G = (qfuncinv(pe / (8 * (N - 1))))^2 / 3;
            Gamma = 1 + G * (h1 * conj(h1) * SNR1) / (h2 * conj(h2) * SNR2); 
            % 计算Loss部分
            Loss = (log2(((1 + abs(h1)^2 * SNR1) * (qfuncinv(pe / 8))^2 * Gamma^(N-1))/ (3 * abs(h1)^2 * SNR1))) / N;
            % 计算R值
            R_siso_avg_ny = C - Loss;
            % 存储结果
            savematrix1(i, jj) = savematrix1(i, jj) + P * R_siso_avg_ny;
        end
        CC(jj) = CC(jj) + P * C;
    end
end

% 计算平均值
savematrix1 = savematrix1 / 2000;
CC = CC / 2000;

% 显示结果
disp(savematrix1);
disp(CC);

hold on;
% 先绘制平均信道容量的线条
avg_CC = mean(CC);
line([N_values(1), N_values(end)], [avg_CC, avg_CC], 'LineWidth', 2, 'LineStyle', '--');

line_styles = {'-o', '-s', '-^'}; % 定义不同的线条样式
for i = 1:length(power2)
    plot(N_values, savematrix1(i, :), line_styles{i}, 'LineWidth', 1.5, 'MarkerSize', 7);
end

grid on;

legend_str = cell(1, length(power2) + 1);
for i = 1:length(power2)
    % 将功率转换为dB
    power_dB = 10 * log10(power2(i));
    legend_str{i} = sprintf('可达速率，反馈功率 %.0f dB', power_dB);
end
legend_str{end} = '平均信道容量\rho C_{siso}，C_{siso}是SISO信道的信道容量';
h = legend(legend_str);

% 设置图例字体大小和字体
set(h, 'Location', 'SouthEast', 'FontSize', 10, 'FontName', 'Arial Unicode MS'); 

% 设置坐标轴字体大小和字体
set(gca, 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Arial Unicode MS');

xlabel('码长', 'FontSize', 15, 'FontName', 'Arial Unicode MS');
ylabel('速率(bits/symbol)', 'FontSize', 15, 'FontName', 'Arial Unicode MS');