clear all
close all

N = 3; % ��Ե�⻬�״�
% T = 80;  % ����ʱ��(for train��
T = 60;  % ����ʱ�䣨for implement��
A = 0.025; % ���з�ֵ
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

%% ��for train��Ts=5s,T=80s,T��ǰ�����һ��Ts����0���ߣ������ʱ��90s %
% t = 0:1/fs:90;
% t = t';
% data_in = [t a]; % Simulinkϵͳ������
% compensation = [t zeros(180001,1)];% Simulinkϵͳ�Ĳ���

%% ��for implement��Ts=5s,T=60s,T��ǰ�����һ��Ts����0���ߣ������ʱ��70s 
t = 0:1/fs:70;
t = t';
data_in = [t a]; % Simulinkϵͳ������
compensation = [t zeros(140001,1)];% Simulinkϵͳ�Ĳ���


% x = a';
% save('../../data/implement/im_data.mat','x');

% save(['./input1_5.txt'],'a','-ascii')
% save(['./compenx.txt'],'cx3','-ascii')
% save(['./ffa.txt'],'compena3','-ascii')
