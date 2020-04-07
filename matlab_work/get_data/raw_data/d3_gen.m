% NURBS generator: d3_gen: the latest generator:
% ys= d3_gen(3, 20, 0.05);| reference parameter
function sig = d3_gen(N, T, A)
%% gen ctrl points: 
Ts = 5;
fs = 2000;
% setting control points:
%% generating x0:
delta_max = random('unif', 0.35, 0.45);
delta_min = 0.25;
% delta_max = random('unif', 0.5, 1.0);
% delta_min = 0.15;
% xs = linspace(-5, 0.2, round(N));
xs = -1.0*ones(1, round(N));
xe = (T+1)*ones(1, round(N));
x0 = [];
x = 0;
while(x<T)
    x0 = [x0, x];
    deltax = abs(random('unif', delta_min, delta_max));
    x = x + deltax;
end
y0 = [zeros(1, round(N)), random('norm', 0, 0.5, 1, max(size(x0))), zeros(1, round(N))]*A;
x0 = [xs, x0, xe];
% scatter(x0+Ts, y0);
%% get knots
hold on;
% sp = spmak(knots,ctrlpoints); %生成B样条函数
% apt = aptknt(x0,5);
sp = spapi(5,x0, y0); %生成B样条函数 生成一个5阶的b样条函数
%% sample points;
tm = -Ts:1/fs:T+Ts;    % time used in middle
ys = fnval(sp,tm);%就是找到sp这个函数在tm处的值

% data has the same min ad:
% when T0 = 5, this = 20001
% assert(min(find(ys)) == 45001, 'Not starting from the same point');
assert(max(abs(ys))<1.10, 'Over the range!');
tu = tm + Ts; % t used:
% plot(tu, ys);
% DrawFFT(ys, 5000);
sig = [tu', ys'];
end