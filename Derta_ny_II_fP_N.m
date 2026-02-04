% 初始化参数
power1 = 10; % 前向信道功率
sigma1 = 1; % 前向信道的噪声方差
power2 = [31.62, 100, 316.2, 1000]; % 反馈信道功率
sigma2 = 1; % 反馈信道的噪声方差

SNR1 = power1/sigma1; % 前向信道的信噪比
C = (1/2)*log2(1+SNR1);
pe = 10^(-6);
savematrix = zeros(4,4); % 用于存储结果
N = [60, 120, 200, 800]; % 码长

% 主循环
for j = 1 : 4
    L = (1/3)*(qfuncinv(pe / (4*(N(j)-1))))^2; 
    T3 = ((1+SNR1)*(qfuncinv(pe/4))^2)/(3*SNR1);
    for i = 1:4
        SNR2 = power2(i)/sigma2;    
        T2 = 1 + L*(SNR1/SNR2);
        R = C - (1/2)*log2(((T3/T2)^(1/N(j)))*T2);
        Derata = 1 - (log2(1 + (power1/sigma3)) + (N(j)-1)*log2(1 + (power2(i)/sigma4)))/(2*N(j)*R);
        savematrix(j, i) = max(0, Derata);
    end
end    

savematrix

% 绘制图形
NN = (15:5:30);
figure; % 创建新图形窗口
hold on; % 确保所有曲线都绘制在同一张图上

set(gca,'FontSize',12,'FontWeight','bold','FontName','Times New Roman');
lineWidthValue = 1.5; % 设置线条宽度，可按需调整
markerSizeValue = 8; % 设置标记符号大小，可按需调整
markers = {'*-','o-', 's-', 'x-'}; % 定义不同的标记样式
for j = 1:4
    % 新增设置线条宽度、标记符号大小等属性
    plot(NN, savematrix(j, :), markers{j}, 'DisplayName', ['N = ' num2str(N(j))],...
         'LineWidth', lineWidthValue, 'MarkerSize', markerSizeValue); 
end
xlabel('Feedback Power(dB)','FontSize',15);
ylabel('secrecy level \Delta_{ny,II}','FontSize',15);
% title('Derata 值随反馈信道功率的变化');
legend('show'); % 显示图例
grid on; % 添加网格