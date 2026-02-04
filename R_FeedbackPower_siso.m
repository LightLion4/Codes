% 给定的参数
power1 = 10; % 前向信道的发射功率
sigma1 = 1; % 前向信道的噪声方差
power2 = [31.62, 100, 316.2, 1000, 3162, 10000]; % 反馈信道的发射功率
sigma2 = 1; % 反馈信道的噪声方差

P = 0.4; % URLLC消息的概率
pe = 10^(-6); % 解码错误概率
N = 60; % 块长度

% 前向信道的信噪比
SNR1 = power1 / sigma1;

% 初始化结果矩阵
savematrix1 = zeros(length(power2), 1); % 用于存储不同反馈信道功率下的R值
CC = 0;

for ii=1:2000
    % 生成复高斯分布的随机数，均值为0，方差为1
    h1 = 1/sqrt(2) * (randn + 1i*randn);
    h2 = 1/sqrt(2) * (randn + 1i*randn); % 反馈信道的衰落系数
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
        savematrix1(i) = savematrix1(i) + P * R_siso_avg_ny;
    end
    CC = CC + P * C;
end

% 计算平均值
savematrix1 = savematrix1 / 2000;
C = CC/2000;

% 显示结果
savematrix1
C
C - savematrix1(6)

hold on;
line([15,40],[C,C],'LineWidth',2,'LineStyle','--');

NN = (15:5:40);
plot(NN,savematrix1','r','LineWidth',2,'Marker','*','LineStyle','--','MarkerSize',8);
grid on;

h = legend('Shannon Limit of SISO fading channel','R_{avg}^{siso,ny}');  

% 如果需要，可以自定义图例位置等属性  
% 设置图例字体大小  
set(h,'Location', 'SouthEast', 'FontSize', 13); % 将字体大小设置为12
set(gca,'FontSize',12,'FontWeight','bold','FontName','Times New Roman');

xlabel('Feedback Power(dB)','FontSize',15);
ylabel('Rate(bits/symbol)','FontSize',15);

