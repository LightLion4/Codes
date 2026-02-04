% 定义横坐标 - 码字长度，从小到大排列
codeword_length = [40, 80, 120, 160, 200];

% SK scheme (R=0.64)
sk_error_prob_0 = [3.6936429249e-08, 6.8849631355e-10, 1.7317772224e-10, 1.00000000e-10, 1.00000000e-10];

% SK scheme (R=0.645)
sk_error_prob_1 = [3.9637269899e-07, 1.0935284749e-08, 3.1200541703e-09, 1.7384796512e-09, 1.2706437840e-09];

% SK scheme (R=0.65)
sk_error_prob_2 = [3.8202772595e-06, 1.6062562620e-07, 5.2519827313e-08, 3.1290074908e-08, 2.3798757322e-08];

% SK scheme (R=0.656)
sk_error_prob_3 = [4.9241829969e-05, 3.5979650073e-06, 1.4106221815e-06, 9.1900353962e-07, 7.3717737500e-07];

% Reference[23] scheme (R=0.514) 
reference_error_prob = [3.3*10^(-2), 4.1*10^(-3), 7*10^(-4), 1.2*10^(-4), 10^(-5)];

% 绘制图形
figure;

lineWidthValue = 1.5; % 设置线条宽度，可按需调整
markerSizeValue = 6; % 设置标记符号大小，可按需调整

semilogy(codeword_length, reference_error_prob, '-x', 'LineWidth', lineWidthValue, 'MarkerSize', 6);
hold on;
semilogy(codeword_length, sk_error_prob_3, '-*', 'LineWidth', lineWidthValue, 'MarkerSize', 6);
hold on;
semilogy(codeword_length, sk_error_prob_2, '-^', 'LineWidth', lineWidthValue, 'MarkerSize', 6);
hold on;
semilogy(codeword_length, sk_error_prob_1, '-o', 'LineWidth', lineWidthValue, 'MarkerSize', 6);
hold on;
semilogy(codeword_length, sk_error_prob_0, '-s', 'LineWidth', lineWidthValue, 'MarkerSize', 6);

hold off;

% 添加图例
legend('Reference [15] Scheme (R=0.514)','Sk-type coding scheme (R=0.656)','Sk-type coding scheme (R=0.65)','Sk-type coding scheme (R=0.645)','Sk-type coding scheme (R=0.64)');

grid on; % 添加网格便于观察

set(gca,'FontSize',12,'FontWeight','bold','FontName','Times New Roman'); % 设置坐标轴字体属性
xlabel('Codeword length', 'FontSize', 14);
ylabel('Decoding error probability', 'FontSize', 14);
