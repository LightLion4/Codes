%Derata-N-Pe（三维）
power1 = 10; %前向信道功率
sigma1=1;   %前向信道的噪声方差

sigma3=1;
sigma4=1;        %40db

SNR1 = power1/sigma1; % 前向信道的信噪比
C = (1/2)*log2(1+SNR1);

p = [10^(-3),10^(-4),10^(-5),10^(-6),10^(-7)];
savematrix = zeros(5,12); %本算法最后得到的是一个5行5列的矩阵 每一行代表一个误码率对应的多个码长对应的速率

for i = 1:5
    pe = p(i);
    N = 5; %码长横坐标
    for j = 1:12 % 码字长度
        T1 = ((1+SNR1)*(qfuncinv(pe/2)^2))/(3*SNR1);
        R = C - (1/(2*N))*log2(T1);
        Derata = 1 - (log2(1 + (power1/sigma3)) + log2(1 + (power1/sigma4)))/(2*N*R);
        savematrix(i,j) = Derata;
        N = N + 10;
    end
end

savematrix

NN = (5:10:115);
ppe = [10^(-3),10^(-4),10^(-5),10^(-6),10^(-7)];
surf(NN,ppe,savematrix);
grid on;
set(gca,'FontSize',12,'FontWeight','bold','FontName','新宋体','YScale','log');
xlabel('Codeword length','Rotation',11,'FontSize',15);
ylabel('Decoding error probability','Rotation',-25,'FontSize',15);
zlabel('secrecy level \Delta_{nl}','FontSize',15);
%Y = [savematrix(2,1), savematrix(2,2),savematrix(2,3),savematrix(2,4),savematrix(2,5)];
%plot(NN,Y);
%plot(NN,savematrix(4,:));
%hold on;
%line([5,400],[1,1]);

