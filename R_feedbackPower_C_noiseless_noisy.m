%Derata-power2
power1 = 10; %前向信道功率
sigma1=1;   %前向信道的噪声方差
power2 = [31.62, 100, 316.2, 1000, 3162, 10000]; %反馈信道功率
sigma2=1;   %反馈信道的噪声方差

sigma3=1;        %窃听者
sigma4=1000;        %40db

SNR1 = power1/sigma1; % 前向信道的信噪比
C = (1/2)*log2(1+SNR1);
pe = 10^(-6);
savematrix1 = [0,0,0,0,0,0]; %本算法最后得到的是一个5行5列的矩阵 每一行代表一个误码率对应的多个码长对应的速率
savematrix2 = [0,0,0,0,0,0];
N=60;
P = 0.4;  % 概率

L = (1/3)*(qfuncinv(pe / (4*(N-1))))^2; 
T3 = ((1+SNR1)*(qfuncinv(pe/4))^2)/(3*SNR1);

for i = 1:6
    SNR2 = power2(i)/sigma2; % 反馈信道的信噪比    
    T2 = 1 + L*(SNR1/SNR2);
    T1 = ((1+SNR1)*(qfuncinv(pe/2)^2))/(3*SNR1);
    R1 = P*C - P*(1/2)*log2(((T3/T2)^(1/N))*T2);
    R2 = P*C - (P/(2*N))*log2(T1);
    %Derata = 1 - (log2(1 + (power1/sigma3)) + (N-1)*log2(1 + (power2(i)/sigma4)))/(2*N*R);
    savematrix1(i) = R1;
    savematrix2(i) = R2;
end

P*C
savematrix1
savematrix2
%Derata

hold on;
set(gca,'FontSize',13,'FontWeight','bold','FontName','Times New Roman');
line([15,40],[P*C,P*C],'LineWidth',1.5);

NN = (15:5:40);
plot(NN,savematrix2','r','LineWidth',1.5);
plot(NN,savematrix1,'b','LineWidth',1.5);
grid on;
xlabel('Feedback power','FontSize',13);
ylabel('Rate (bit/symbol)','FontSize',13);


