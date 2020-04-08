% get_predict_error:�������ղ�����ԭʼreference�е�����ź�
clear
%% for 1st implement
case_num = 2;
% file_pre_data = {sprintf('case%d/1st_implement/pre_data1.mat', case_num)};
% file_actual_error = {sprintf('case%d/1st_implement/actual_error1.mat', case_num)};
file_pre_data = {sprintf('case%d/2nd_implement/pre_data2.mat', case_num)};
file_actual_error = {sprintf('case%d/2nd_implement/actual_error2.mat', case_num)};


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
t = 0:1/2000:80;
plot(t,ya);
hold on;
plot(t,yc);
legend('actual','predict');

% file_compensation_error = {sprintf('case%d/1st_implement/compensation_error1.mat', case_num)};
file_compensation_error = {sprintf('case%d/2nd_implement/compensation_error2.mat', case_num)};
save(file_compensation_error{1}, 'yc');

%% for 2nd train
% 
% Start = 1;
% End = 25;
% for i = Start:1:End
%     file_pre_data = string(sprintf('1st_implement_for_2nd_train/pre_data%d.mat', i));
% 
%     load(file_pre_data);
% 
%     extend_num = 10*size(yp,2);
%     yp = yp';
%     yc = extend_sample(yp, 10);

    % ��ǰ�Ľ���������extend_num���ʵ�ʵ�Ĺ켣Ҫ�٣������ĩβ����һ��������0
%     padd_num = actual_num - extend_num;
%     for i = 1:1:padd_num
%         yc = [yc;0];
%     end
%     yc = [yc;0];

%     yc = yc';
%     t = 0:1/2000:70;
%     plot(t,ya);
%     hold on;
%     plot(t,yc);
%     legend('actual','predict');

%     file_compensation_error = string(sprintf('1st_implement_for_2nd_train/comp_data%d.mat', i));
%     save(file_compensation_error{1}, 'yc');
% end

