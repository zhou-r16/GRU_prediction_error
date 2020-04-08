% get_predict_error:生成最终补偿到原始reference中的误差信号
%% for 1st implement
% case_num = 101;
% file_pre_data = {sprintf('case%d/pre_data.mat', case_num)};
% file_actual_error = {sprintf('case%d/actual_error.mat', case_num)};
% 
% load(file_pre_data{1});
% load(file_actual_error{1});
% 
% actual_num = size(ya,2);
% extend_num = 10*size(yp,2);
% yp = yp';
% yc = extend_sample(yp, 10);
% 
% % 先前的降采样导致extend_num会比实际点的轨迹要少，因此在末尾补上一定数量的0
% padd_num = actual_num - extend_num;
% for i = 1:1:padd_num
%     yc = [yc;0];
% end
% 
% yc = yc';
% t = 0:1/2000:70;
% plot(t,ya);
% hold on;
% plot(t,yc);
% legend('actual','predict');
% 
% file_compensation_error = {sprintf('case%d/compensation_error.mat', case_num)};
% save(file_compensation_error{1}, 'yc');

%% for 2nd train
% 
Start = 1;
End = 25;
for i = Start:1:End
    file_pre_data = string(sprintf('1st_implement_for_2nd_train/pre_data%d.mat', i));

    load(file_pre_data);

    extend_num = 10*size(yp,2);
    yp = yp';
    yc = extend_sample(yp, 10);

    % 先前的降采样导致extend_num会比实际点的轨迹要少，因此在末尾补上一定数量的0
%     padd_num = actual_num - extend_num;
%     for i = 1:1:padd_num
%         yc = [yc;0];
%     end
    yc = [yc;0];

    yc = yc';
%     t = 0:1/2000:70;
%     plot(t,ya);
%     hold on;
%     plot(t,yc);
%     legend('actual','predict');

    file_compensation_error = string(sprintf('1st_implement_for_2nd_train/comp_data%d.mat', i));
    save(file_compensation_error{1}, 'yc');
end

