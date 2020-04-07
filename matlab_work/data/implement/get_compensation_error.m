% get_predict_error:�������ղ�����ԭʼreference�е�����ź�
case_num = 2;
file_pre_data = {sprintf('case%d/pre_data.mat', case_num)};
file_actual_error = {sprintf('case%d/actual_error.mat', case_num)};

load(file_pre_data{1});
load(file_actual_error{1});

actual_num = size(ya,2);
extend_num = 10*size(yp,2);
yp = yp';
yc = extend_sample(yp, 10);

% ��ǰ�Ľ���������extend_num���ʵ�ʵ�Ĺ켣Ҫ�٣������ĩβ����һ��������0
padd_num = actual_num - extend_num;
for i = 1:1:padd_num
    yc = [yc;0];
end

yc = yc';
t = 0:1/2000:70;
plot(t,ya);
hold on;
plot(t,yc);
legend('actual','predict');

file_compensation_error = {sprintf('case%d/compensation_error.mat', case_num)};
save(file_compensation_error{1}, 'yc');