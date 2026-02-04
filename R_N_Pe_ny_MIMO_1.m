%R-N-Pe（三维） or R-power2-N-C(二维，但多条)
power1 = 10; %前向信道功率
sigma1 = 1;   %前向信道的噪声方差
power2 = 1000; %反馈信道功率
sigma2 = 1;   %反馈信道的噪声方差

p = [10^(-3), 10^(-4), 10^(-5), 10^(-6), 10^(-7)];
savematrix = zeros(5, 12); %本算法最后得到的是一个5行5列的矩阵 每一行代表一个误码率对应的多个码长对应的速率
P = 0.4;

% 假设A和B为已知参数，这里先简单设置示例值，需根据实际调整
A = 5; 
B = 5; 
K = min(A, B);

for ii = 1:2000
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
    for i = 1:5
        pe = p(i);
        N = 5; %码长横坐标
        for j = 1:12 % 码字长度
            R_mimo_avg_ny = 0; % 初始化
            for k = 1:K
            
                if dk1(k) ~= 0
                    abs_h1_sq = dk1(k) * conj(dk1(k));
                end
                if dk2(k) ~= 0
                    abs_h2_sq = dk2(k) * conj(dk2(k));
                end

                power1_k = power1 / A;
                power2_k = power2 / B;

                SNR1 = power1_k / sigma1; % 前向信道的信噪比
                SNR2 = power2_k / sigma2; % 反馈信道的信噪比

                C = log2(1 + abs_h1_sq * SNR1);
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
                R_k = P * C - P * Loss;
                R_mimo_avg_ny = R_mimo_avg_ny + R_k;
            end    
            % 存储结果
            savematrix(i, j) = savematrix(i, j) + R_mimo_avg_ny;
            N = N + 10;
        end
    end
end

% 计算平均值
savematrix = savematrix / 2000;  

savematrix

NN = (5:10:115);
ppe = [10^(-3), 10^(-4), 10^(-5), 10^(-6), 10^(-7)];
surf(NN, ppe, savematrix);

grid on;
set(gca,'FontSize',12,'FontWeight','bold','FontName','新宋体','YScale','log');
xlabel('Codeword length','Rotation',15,'FontSize',15);
ylabel('Decoding error probability','Rotation',-25,'FontSize',15);
zlabel('Rate(bits/symbol)','FontSize',15);
