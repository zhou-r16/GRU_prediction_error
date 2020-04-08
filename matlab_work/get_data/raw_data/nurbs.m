clear all
close all

N = 3; % 边缘光滑阶次
% T = 80;  % 运行时间(for train）
T = 60;  % 运行时间（for implement）
A = 0.025; % 运行幅值
fs = 2000;

sigx1 = d3_gen(N, T, A);
figure(2)
plot(1000*sigx1(:,2))

% sigx = 1000*sigx1(:,2);
sigx = sigx1(:,2);
figure(1)
subplot(4,1,1)
for o=1:1:(length(sigx)-1)
    vx(o)=(sigx(o+1)-sigx(o))*fs;
end
vx(length(sigx))=0-sigx(length(sigx))*fs;
plot(vx)

subplot(4,1,2)

for o=1:1:(length(sigx)-1)
    ax(o)=(vx(o+1)-vx(o))*fs;
end
ax(length(sigx))=0-vx(length(sigx))*fs;
plot(ax)

subplot(4,1,3)

for o=1:1:(length(sigx)-1)
    jx(o)=(ax(o+1)-ax(o))*fs;
end
jx(length(sigx))=0-ax(length(sigx))*fs;
plot(jx)

subplot(4,1,4)

for o=1:1:(length(sigx)-1)
    jjx(o)=(jx(o+1)-jx(o))*fs;
end
jjx(length(sigx))=0-jx(length(sigx))*fs;
plot(jjx)

a = sigx;
% compen = zeros(1,length(sigx))';
% save input1_5.txt -ascii a
% save compenx.txt -ascii compen

% cx3 = zeros(180000,1);
% compena3 = zeros(180000,1);

%% （for train）Ts=5s,T=80s,T的前后各有一段Ts长的0曲线，因此总时间90s %
% t = 0:1/fs:90;
% t = t';
% data_in = [t a]; % Simulink系统的输入
% compensation = [t zeros(180001,1)];% Simulink系统的补偿

%% （for implement）Ts=5s,T=60s,T的前后各有一段Ts长的0曲线，因此总时间70s 
t = 0:1/fs:70;
t = t';
data_in = [t a]; % Simulink系统的输入
compensation = [t zeros(140001,1)];% Simulink系统的补偿


% x = a';
% save('../../data/implement/im_data.mat','x');

% save(['./input1_5.txt'],'a','-ascii')
% save(['./compenx.txt'],'cx3','-ascii')
% save(['./ffa.txt'],'compena3','-ascii')
