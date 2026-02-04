%R-N-Pe（三维） or R-power2-N-C(二维，但多条)
power1 = 10; %前向信道功率
sigma1=1;   %前向信道的噪声方差
power2 = 1000; %反馈信道功率
sigma2=1;   %反馈信道的噪声方差

SNR1 = power1/sigma1; % 前向信道的信噪比
SNR2 = power2/sigma2; % 反馈信道的信噪比

p = [10^( -3),10^(-4),10^(-5),10^(-6),10^(-7)];
savematrix = zeros(5,12); %本算法最后得到的是一个5行5列的矩阵 每一行代表一个误码率对应的多个码长对应的速率
P=0.4;

for ii=1:2000
    % 生成一个复高斯分布的随机数，均值为0，方差为1  
    h1 = 1/sqrt(2) * (randn + 1i*randn);
    h2 = 1/sqrt(2) * (randn + 1i*randn); %反馈的衰落系数
    
    abs_h1_sq = abs(h1)^2;
    abs_h2_sq = abs(h2)^2;
    
    C = log2(1 + abs_h1_sq * SNR1);
    
    for i = 1:5
        pe = p(i);
        N = 5; %码长横坐标
        for j = 1:12 % 码字长度
            % 计算Gamma值
            G = (qfuncinv(pe / (8 * (N - 1))))^2 / 3;   
            Gamma = 1 + G * (abs_h1_sq * SNR1) / (abs_h2_sq * SNR2); 
            % 计算Loss部分
            Loss = (log2(((1 + abs_h1_sq * SNR1) * (qfuncinv(pe / 8))^2 * Gamma^(N-1))/ (3 * abs_h1_sq * SNR1))) / N;
            % 计算R值
            R_siso_avg_ny = C - Loss;
            % 存储结果
            savematrix(i,j) = savematrix(i,j) + P * R_siso_avg_ny;
            N = N + 10;
        end
    end
end

% 计算平均值
savematrix = savematrix / 2000;  
    
savematrix

NN = (5:10:115);
ppe = [10^(-3),10^(-4),10^(-5),10^(-6),10^(-7)];
surf(NN,ppe,savematrix);

grid on;
set(gca,'FontSize',12,'FontWeight','bold','FontName','Times New Roman','YScale','log');
xlabel('Codeword length','Rotation',15,'FontSize',15);
ylabel('Decoding error probability','Rotation',-25,'FontSize',15);
zlabel('Rate(bits/symbol)','FontSize',15);



