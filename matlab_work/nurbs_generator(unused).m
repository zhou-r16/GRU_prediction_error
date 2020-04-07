% ��������������������������������������������
% nurbs_generator������NURBS����
% �����б�N���߽���Ƶ�������T�����ɵ�����ʱ����A�����ߵķ�ֵ��k���������߱仯�̶ȵ����ޣ�һ��1.5-2.5
% ����ʾ����nurbs_generator(3, 100, 0.03, 1.5)
% ��������������������������������������������

function curve = nurbs_generator(N, T, A, k)
% �������߿�ʼʱ��T_start,����Ƶ��fs
T_start = 2;
fs = 200;

% flag�����ж��Ƿ�������������
flag=1;

% ����x0:
num=1;
while(flag==1)
    delta_max = random('unif', 0.35, 0.45);
    delta_min = 0.15;

    % �������ߵ���������Ҫ�߽������ģ�x_start��x_end������Ҫ����ı߽�����
    x_start = -1.0*ones(1, round(N));
    x_end = (T+1)*ones(1, round(N));

    x0 = [];
    x = 0;
    while(x<T)
        x0 = [x0, x];
        deltax = abs(random('unif', delta_min, delta_max));
        x = x + deltax;
    end

    % x_start��x_end����N�����Ƶ㣬������Ҫ���������ߵ����ˣ�����Щ���Ƶ��Ϻ���ֵ��Ϊ0
    y0 = [zeros(1, round(N)), random('norm', 0, 0.5, 1, max(size(x0))), zeros(1, round(N))]; 
    x0 = [x_start, x0, x_end];

    sp = spapi(5,x0, y0); %����һ��5�׵�b��������

    % ������
    tm = -T_start:1/fs:T+T_start;    % ����������NURBS�����Ǵ�[0,T]ʱ���ڵģ�������������ǰ��ֱ������ʱ��ΪT_start��������
    ys = fnval(sp,tm);  % ������ɵ����������ڸ���������ĺ���ֵ

    % �ж����������Ƿ����Ҫ��
    maxys=max(abs(ys));
    if maxys<k
        flag = 0;
        ys = ys * A / maxys;
    end
    num=num+1;
end
num;

% ��ʱ���[-T_start,T+T_start]ƽ�Ƶ�[0,T+2*T_start]
t_used = tm + T_start;
plot(t_used, ys);
curve = [t_used', ys'];
end

