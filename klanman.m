%%一维度变量的卡尔曼滤波算法
%状态的估计观察

%% 参数设置
N = 200;     % 设置数据长度为N
t = (1:N);   % 生成时间轴，一维矩阵的形式
a = 1;       % 状态转移方程
b = 0;       % 控制输入，对控制方程取0了
c = 1;       % c: 观测方程
x = 0;       % 设置初值 初始的均值和方差
sigma2 = 10;
V = 1;      % 设置生成的信号的噪声标准差
Q = 5;       % 设置状态转移方差Q和观测方差R
R = 300;       

%% 初始化
real_signal = zeros(1,N); % 真实信号
z = zeros(1,N);           % 观测数据
x_filter = zeros(1,N);    % 存储卡尔曼估计的结果，缓存起来用于画图形
K = zeros(1,N);           % 存储卡尔曼预测中的增益k，缓存起来用于画图形

% 初始化真实数据和观测数据
for i=1:N
   %生成真实数据，为1-100线性增加的信号
   real_signal(i) = sin(i); 
   %real_signal(i) = 200;
   %生成观测，真实数据基础上叠加一个高斯噪声 normrnd(均值, 标准差)
   z(i) = real_signal(i) + normrnd(0, V);
   %z(i) = real_signal(i);
end


%% 卡尔曼滤波
for i=1:N
    % 预测步
    %x_ = a*x + b;            %预测当前状态
    x_ = a*x + cos(i);
    sigma2_ = a*sigma2*a'+Q;

    % 更新步
    k = sigma2_*c'/(c*sigma2_*c'+R);
    x = x_ + k*(z(i) - c*x_);
    sigma2 = (1-k*c)*sigma2_;

    % 存储滤波结果
    x_filter(i) = x;
    K(i) = k;
end

%% 展示
% 画出卡尔曼增益k 可以看到系统很快会达到稳态，k会很快收敛成为一个常数，此时卡尔曼滤波也就相当于低通滤波了
plot(t, K);legend('K');
% 画出波形， 真实值 - 观测值 - 卡尔曼估计值
figure(2)


plot(t, real_signal, 'r',t,z,'g' ,t, x_filter, 'b')
legend('实际的状态值','传感器观测的值','卡尔曼滤波后得到的值');
figure(3)


%plot(t,z,'g')
%legend('传感器观测的值')


