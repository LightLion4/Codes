% 前向信道功率
power1 = 10; 
% 前向信道的噪声方差
sigma1 = 1;   
% 反馈信道功率
power2 = 1000; 
% 反馈信道的噪声方差
sigma2 = 1;   

pe = 10^(-6);
% 定义参数rho
P = 0.4; 

% 不同的A和B组合
AB_combinations = [3, 3; 5, 5; 7, 7]; 
num_combinations = size(AB_combinations, 1);

% 码长范围
NN = (5:10:115);
% 预分配存储不同A和B组合结果的矩阵
savematrix = zeros(num_combinations, length(NN)); 

for ii = 1:2000
    for comb = 1:num_combinations
        A = AB_combinations(comb, 1);
        B = AB_combinations(comb, 2);
        K = min(A, B);

        % 生成一个示例的前馈信道矩阵h，这里简单随机生成，实际应根据模型生成
        h1 = 1/sqrt(2) * (randn(B, A) + 1i*randn(B, A)); 
        h2 = 1/sqrt(2) * (randn(A, B) + 1i*randn(A, B)); 

        % 进行奇异值分解
        [U1, D1, V1] = svd(h1);
        [U2, D2, V2] = svd(h2);

        % 获取对角矩阵D的对角元素dk
        dk1 = diag(D1);
        dk2 = diag(D2);

        N = 5; %码长横坐标
        for j = 1:length(NN)
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
            savematrix(comb, j) = savematrix(comb, j) + R_mimo_avg_ny;
            N = N + 10;
        end
    end
end

% 计算平均值
savematrix = savematrix / 2000;  

savematrix

% 绘制二维图
figure;
line_styles = {'-o', '-s', '-^'}; % 定义不同的线条样式
line_colors = {'r', 'b', 'g'}; % 定义不同的线条颜色，这里使用红色、蓝色、绿色
lineWidthValue = 1.5; % 设置线条宽度，可按需调整
markerSizeValue = 6; % 设置标记符号大小，可按需调整
handles = []; % 用于存储线条句柄
for comb = 1:num_combinations
    % 使用定义的颜色和线条样式绘图，并保存句柄
    h = plot(NN, savematrix(comb, :), [line_colors{comb} line_styles{comb}], 'DisplayName', ['A = ', num2str(AB_combinations(comb, 1)), ', B = ', num2str(AB_combinations(comb, 2))], 'LineWidth', lineWidthValue, 'MarkerSize', markerSizeValue);
    handles = [handles; h];
    hold on;
end
grid on;
set(gca,'FontSize',12,'FontWeight','bold','FontName','Times New Roman'); % 设置坐标轴字体属性
xlabel('Codeword length', 'FontSize', 15);
ylabel('Rate(bits/symbol)', 'FontSize', 15);
% 添加图例，先传入句柄和标签，再设置属性
h_legend = legend(handles, arrayfun(@(x) ['A = ', num2str(AB_combinations(x, 1)), ', B = ', num2str(AB_combinations(x, 2))], 1:num_combinations, 'UniformOutput', false), 'Location', 'SouthEast', 'FontSize', 13);