% 初始化参数
power1 = 10; % 前向信道功率
sigma1 = 1; % 前向信道的噪声方差
power2 = [31.62, 100, 316.2, 1000, 3162]; % 反馈信道功率
sigma2 = 1; % 反馈信道的噪声方差

sigma3 = 1; % 窃听者
sigma4 = 1000; % 40db

SNR1 = power1/sigma1; % 前向信道的信噪比
C = (1/2)*log2(1+SNR1);
pe = 10^(-6);
N = 60; % 设置 N 为 60

mu_values = [0.2, 0.5, 0.8]; % 不同的\mu值
num_mu = length(mu_values);
savematrix = zeros(num_mu, length(power2)); % 用于存储不同\mu值下的结果

% 主循环，遍历不同的\mu值
for k = 1:num_mu
    mu = mu_values(k);
    L = (1/3)*(qfuncinv(pe / (4*(N-1))))^2; 
    T3 = ((1+SNR1)*(qfuncinv(pe/4))^2)/(3*SNR1);
    
    % 遍历不同的反馈信道功率
    for i = 1:length(power2)
        SNR2 = power2(i)/sigma2; % 反馈信道的信噪比    
        T2 = 1 + L*(SNR1/SNR2);
        R = C - (1/2)*log2(((T3/T2)^(1/N))*T2);
        Derata = 1 - (log2(1 + (power1/sigma3)) + (N-1)*log2(1 + (power2(i)/sigma4)))/(2*N*R);
        Rerult = mu*Derata + (1-mu)*(R/C);
        savematrix(k, i) = Rerult;
    end
end

% 绘制图形
NN = (15:5:35);
figure; % 创建新图形窗口
hold on; % 确保所有曲线都绘制在同一张图上

set(gca,'FontSize',12,'FontWeight','bold','FontName','Times New Roman');
lineWidthValue = 1.5; % 设置线条宽度，可按需调整
markerSizeValue = 10; % 设置标记符号大小，可按需调整
markerForMax = '^'; % 用于标记最高点的符号
markerColorForMax = 'r'; % 标记最高点的颜色
markeredgecolor = 'k'; % 标记轮廓颜色
markerEdgeWidthValue = 1.5; % 设置标记点轮廓的宽度，可按需调整

markers = {'*-','o-', 'x-'}; % 定义不同的标记样式
legend_handles = []; % 用于存储需要显示在图例中的句柄
legend_labels = string.empty; % 初始化为空字符串数组

% 遍历不同的\mu值，绘制不同的线条
for j = 1:num_mu
    % 绘制曲线
    h_curve = plot(NN, savematrix(j, :), markers{j}, 'LineWidth', lineWidthValue, 'MarkerSize', markerSizeValue); 
    legend_handles = [legend_handles; h_curve];
    label = strcat('\mu=', num2str(mu_values(j)));
    legend_labels = [legend_labels; label];
    
    % 找到最高点
    [max_value, max_index] = max(savematrix(j, :));
    max_x = NN(max_index);
    max_y = max_value;
    
    % 标记最高点
    h_max = plot(max_x, max_y, markerForMax, 'Color', markerColorForMax, 'MarkerSize', markerSizeValue + 1);
    set(h_max, 'MarkerEdgeColor', markeredgecolor);
    set(h_max, 'LineWidth', 1); % 使用 LineWidth 来模拟 MarkerEdgeWidth
    
    % 只对第一条曲线的最高点添加图例注释
    if j == 3
        legend_handles = [legend_handles; h_max];
        legend_labels = [legend_labels; "The highest point"];
    end
end

xlabel('Feedback Power(dB)','FontSize',15);
ylabel('Trade-off function','FontSize',15);
legend(legend_handles, legend_labels); % 显示图例
grid on; % 添加网格