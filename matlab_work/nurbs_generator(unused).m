% ——————————————————————
% nurbs_generator：生成NURBS曲线
% 参数列表：N—边界控制点数量；T—生成的曲线时长；A—曲线的幅值；k—控制曲线变化程度的上限，一般1.5-2.5
% 运行示例：nurbs_generator(3, 100, 0.03, 1.5)
% ——————————————————————

function curve = nurbs_generator(N, T, A, k)
% 设置曲线开始时间T_start,采样频率fs
T_start = 2;
fs = 200;

% flag用于判断是否重新生成曲线
flag=1;

% 产生x0:
num=1;
while(flag==1)
    delta_max = random('unif', 0.35, 0.45);
    delta_min = 0.15;

    % 样条曲线的生成是需要边界条件的，x_start和x_end就是需要满足的边界条件
    x_start = -1.0*ones(1, round(N));
    x_end = (T+1)*ones(1, round(N));

    x0 = [];
    x = 0;
    while(x<T)
        x0 = [x0, x];
        deltax = abs(random('unif', delta_min, delta_max));
        x = x + deltax;
    end

    % x_start和x_end都是N个控制点，在所需要的生成曲线的两端，在这些控制点上函数值均为0
    y0 = [zeros(1, round(N)), random('norm', 0, 0.5, 1, max(size(x0))), zeros(1, round(N))]; 
    x0 = [x_start, x0, x_end];

    sp = spapi(5,x0, y0); %生成一个5阶的b样条函数

    % 采样点
    tm = -T_start:1/fs:T+T_start;    % 真正产生的NURBS曲线是从[0,T]时间内的，在这里在曲线前后分别加入了时长为T_start的零曲线
    ys = fnval(sp,tm);  % 获得生成的样条函数在各个采样点的函数值

    % 判断曲线最终是否符合要求
    maxys=max(abs(ys));
    if maxys<k
        flag = 0;
        ys = ys * A / maxys;
    end
    num=num+1;
end
num;

% 将时间从[-T_start,T+T_start]平移到[0,T+2*T_start]
t_used = tm + T_start;
plot(t_used, ys);
curve = [t_used', ys'];
end

