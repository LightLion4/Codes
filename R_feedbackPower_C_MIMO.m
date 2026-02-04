% 给定的参数
power1 = 10; % 前向信道的发射功率
sigma1 = 1; % 前向信道的噪声方差
power2 = [31.62, 100, 316.2, 1000, 3162, 10000]; % 反馈信道的发射功率
sigma2 = 1; % 反馈信道的噪声方差

P = 0.4; % URLLC消息的概率
pe = 10^(-6); % 解码错误概率
N = 60; % 块长度

% 假设A和B为已知参数，这里先简单设置示例值，需根据实际调整
A = 5; 
B = 5; 
K = min(A, B);

% 初始化结果矩阵
savematrix1 = zeros(length(power2), 1); % 用于存储不同反馈信道功率下的R值
CC = 0;

power1_k = power1 / A;
SNR1 = power1_k / sigma1; % 前向信道的信噪比

for ii=1:2000
    % 生成一个示例的前馈信道矩阵h，这里简单随机生成，实际应根据模型生成
    h1 = 1/sqrt(2) * (randn(B, A) + 1i*randn(B, A)); 
    h2 = 1/sqrt(2) * (randn(A, B) + 1i*randn(A, B)); 

    % 进行奇异值分解
    [U1, D1, V1] = svd(h1);
    [U2, D2, V2] = svd(h2);

    % 获取对角矩阵D的对角元素dk
    dk1 = diag(D1);
    dk2 = diag(D2);

    abs_h1_sq = 0;
    abs_h2_sq = 0;
    for k = 1:K
        if dk1(k) ~= 0
            abs_h1_sq = dk1(k) * conj(dk1(k));
        end
        if dk2(k) ~= 0
            abs_h2_sq = dk2(k) * conj(dk2(k));
        end
        C = log2(1 + abs_h1_sq * SNR1);
        for i = 1:length(power2)   
            power2_k = power2(i) / B;
            SNR2 = power2_k / sigma2; % 反馈信道的信噪比
            
            % 计算Gamma值时
            temp1 = pe / (8 * K * (N - 1));
            if temp1 <= 0
                G = 0; % 或其他合理默认值
            elseif temp1 >= 1
                G = qfuncinv(0.9999); % 接近1的一个值
            else
                G = (qfuncinv(temp1))^2 / 3;   
            end
            Gamma = 1 + G * (abs_h1_sq * SNR1) / (abs_h2_sq * SNR2); 
            % 计算Loss部分时
            temp2 = pe /(8*K);
            if temp2 <= 0
                temp2 = 0.0001; % 或其他合理默认值
            elseif temp2 >= 1
                temp2 = 0.9999; % 接近1的一个值
            end
            Loss = (log2(((1 + abs_h1_sq * SNR1) * (qfuncinv(temp2))^2 * Gamma^(N - 1))/ (3 * abs_h1_sq * SNR1))) / N;
            % 计算单个天线的速率
            R_siso_avg_ny = C - Loss;
            % 存储结果
            savematrix1(i) = savematrix1(i) + P * R_siso_avg_ny;
        end
    CC = CC + P * C;
    end
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

h = legend('Shannon Limit of MIMO fading channel','R_{avg}^{mimo,ny}');  

% 如果需要，可以自定义图例位置等属性  
% 设置图例字体大小  
set(h,'Location', 'SouthEast', 'FontSize', 13); % 将字体大小设置为12
set(gca,'FontSize',12,'FontWeight','bold','FontName','Times New Roman');

xlabel('Feedback Power(dB)','FontSize',15);
ylabel('Rate(bits/symbol)','FontSize',15);

