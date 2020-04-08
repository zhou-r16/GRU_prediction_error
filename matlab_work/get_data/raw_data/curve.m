% curve.m:用于生成reference，供simulink仿真模型运行
fs = 2000;
T = 80;
t = 0:1/fs:T;
sigx = 0.0103.*sin(0.8.*pi.*t)+0.0096.*sin(pi.*t)-0.0114.*sin(2.*pi.*t);
figure(1)
plot(t,sigx);

a = sigx';
data_in = [t' a];
compensation = [t' zeros(T*fs+1,1)];

figure(2)
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