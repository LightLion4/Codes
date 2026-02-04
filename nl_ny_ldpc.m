% 已知的值
N = 40;
R = 1;
SNR2 = 1000;
% 更新 pe 数组
pe_values = [10^(-1), 10^(-2), 10^(-3), 10^(-4), 10^(-5), 10^(-6), 10^(-7)];

% 初始化数组以存储结果
SNR1_values = zeros(size(pe_values));

% 初始化数组以存储结果（无噪）
SNR1_values2 = zeros(size(pe_values));

% 循环计算每个 pe 对应的 SNR1
for i = 1:length(pe_values)
    pe = pe_values(i);
    
    % 匿名函数定义了我们要求解的方程
    f = @(SNR1) compute_R(SNR1, N, SNR2, pe) - R;
    
    % 利用fzero来寻找SNR1的值
    SNR1_initial_guess = 11; % 更合理的初始猜测值可能需要根据情况调整
    try
        SNR1_solution = fzero(f, SNR1_initial_guess);
        % 存储计算结果
        SNR1_values(i) = SNR1_solution;
    catch exception
        % 如果发生错误，打印错误信息并继续
        disp(exception.message);
        SNR1_values(i) = NaN; % 使用 NaN 来表示未能计算的值
    end
end


% 循环计算每个 pe 对应的 SNR1（无噪）
for i = 1:length(pe_values)
    pe = pe_values(i);
    
    % 匿名函数定义了我们要求解的方程
    f = @(SNR1) compute_R2(SNR1, N, pe) - R;
    
    % 利用fzero来寻找SNR1的值
    SNR1_initial_guess = 11; % 更合理的初始猜测值可能需要根据情况调整
    try
        SNR1_solution = fzero(f, SNR1_initial_guess);
        % 存储计算结果
        SNR1_values2(i) = SNR1_solution;
    catch exception
        % 如果发生错误，打印错误信息并继续
        disp(exception.message);
        SNR1_values2(i) = NaN; % 使用 NaN 来表示未能计算的值
    end
end

% 线性值转换为dB
SNR1_dB_values = 10 * log10(SNR1_values);
SNR1_dB_values

% 线性值转换为dB
SNR1_dB_values2 = 10 * log10(SNR1_values2);
SNR1_dB_values2

% 画图，注意这里将SNR1_dB_values作为x轴，pe_values作为y轴
% LDPC编码的数据点
%ldpc_db_values = [9.9, 10.6, 11.1, 11.5, 12];
%ldpc_db_values = [9.4, 10.5, 11.2, 11.6, 12];
ldpc_db_values = [5.68, 6.59, 7, 7.27, 7.5];
ldpc_pe_values = [10^-1, 10^-2, 10^-3, 10^-4, 10^-5];

ldpc_db_values1 = [9.6, 10.1, 10.5, 10.7, 10.9];
ldpc_pe_values1 = [10^-1, 10^-2, 10^-3, 10^-4, 10^-5];

ldpc_db_values2 = [15.7, 16.7, 16.9, 17.1, 17.2];
ldpc_pe_values2 = [10^-1, 10^-2, 10^-3, 10^-4, 10^-5];

% 设置坐标轴字体
set(gca, 'FontSize', 12, 'FontWeight', 'bold','FontName','Times New Roman', 'YScale', 'log');

% 画SK编码的图（无噪）
semilogy(SNR1_dB_values2, pe_values, '-o', 'DisplayName', 'SK Code(noiseless feedback, N=40)', 'LineWidth', 1.5);
hold on; % 保持当前图形，以便在相同的坐标轴上绘制另一条线

% 画SK编码的图（有噪）
semilogy(SNR1_dB_values, pe_values, '-s', 'DisplayName', 'SK Code(noisy feedback, N=40)', 'LineWidth', 1.5);
hold on; % 保持当前图形，以便在相同的坐标轴上绘制另一条线

% 画LDPC编码的图
semilogy(ldpc_db_values, ldpc_pe_values, '-*', 'DisplayName', 'LDPC Code(N=2400, 4-PAM)', 'LineWidth', 1.5);

% 画LDPC编码的图
%semilogy(ldpc_db_values1, ldpc_pe_values1, '-*', 'DisplayName', 'LDPC Code(N=2400，4-PAM)', 'LineWidth', 1.5);

% 画LDPC编码的图
%semilogy(ldpc_db_values2, ldpc_pe_values2, '-*', 'DisplayName', 'LDPC Code(N=2400，4-PAM)', 'LineWidth', 1.5);

%xlabel('SNR (dB)');
%ylabel('Decoding error probability');
set(gca, 'FontSize', 13, 'FontWeight', 'bold','FontName','Times New Roman');
title('No interference', 'FontWeight', 'bold','FontName','Times New Roman');
xlabel('Feedforward SNR (dB)');
ylabel('Decoding error probability');
legend show; % 显示图例
grid on; % 添加网格便于观察

% 在这里定义compute_R函数，确保这是脚本中的最后一部分(有噪)
function R = compute_R(SNR1, N, SNR2, pe)
    L = (1/3)*(qfuncinv(pe / (4*(N-1))))^2;
    T2 = 1 + L*(SNR1/SNR2);
    T3 = ((1+SNR1)*(qfuncinv(pe/4))^2)/(3*SNR1);
    C = (1/2)*log2(1+SNR1);
    R = C - (1/2)*log2(((T3/T2)^(1/N))*T2);
end

% 在这里定义compute_R2函数，确保这是脚本中的最后一部分(无噪)
function R = compute_R2(SNR1, N, pe)
    T1 = ((1+SNR1)*(qfuncinv(pe/2)^2))/(3*SNR1);
    C = (1/2)*log2(1+SNR1);
    R = C - (1/(2*N))*log2(T1);
end
    