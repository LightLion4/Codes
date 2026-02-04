%R-N-Pe（三维） or R-power2-N-C(二维，但多条)
power1 = 10; %前向信道功率
sigma1=1;   %前向信道的噪声方差

SNR1 = power1/sigma1; % 前向信道的信噪比

p = [10^(-3),10^(-4),10^(-5),10^(-6),10^(-7)];
savematrix = zeros(5,12); %本算法最后得到的是一个5行5列的矩阵 每一行代表一个误码率对应的多个码长对应的速率
C = (1/2)*log2(1+SNR1);

P = 0.4

for i = 1:5
    pe = p(i);  
    N = 5; %码长横坐标
    for j = 1:12 % 码字长度
        T1 = ((1+SNR1)*(qfuncinv(pe/2)^2))/(3*SNR1);
        R = P*C - (P/(2*N))*log2(T1);
        savematrix(i,j) = R;
        N = N + 10;
    end
end
    
savematrix

NN = (5:10:115);
ppe = [10^(-3),10^(-4),10^(-5),10^(-6),10^(-7)];
surf(NN,ppe,savematrix);

%line([0,400],[0.4*C,0.4*C]);
%hold on;
%plot(NN, savematrix(4,:));

grid on;
set(gca,'FontSize',12,'FontWeight','bold','FontName','新宋体','YScale','log');
xlabel('码长','Rotation',11,'FontSize',15);
ylabel('译码错误概率','Rotation',-25,'FontSize',15);
zlabel('速率(bits/symbol)','FontSize',15);



