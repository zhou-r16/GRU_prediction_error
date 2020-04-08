%% for train

% train_num = 25;
% 
% rec1.posx = a;
% rec1.vx = vx;
% rec1.ax = ax;
% rec1.jx = jx;
% rec1.ex = error_output.Data; % 保存Simulink中输出的误差
% 
% save(string(sprintf('../pro_data/from_raw_data/for_1st_train/%d.mat',train_num)),'rec1');

%% for implement
% case_num = 2
% 
% rec1.posx = a;
% rec1.vx = vx;
% rec1.ax = ax;
% rec1.jx = jx;
% rec1.ex = error_output.Data; % 保存Simulink中输出的误差
% 
% xr = a';
% ya = error_output.Data';
% 
% file_actual_error = {sprintf('../../data/implement/case%d/1st_implement/actual_error1.mat', case_num)};
% file_origin_reference = {sprintf('../../data/implement/case%d/1st_implement/origin_reference1.mat', case_num)};
% file_rec1 = {sprintf('../pro_data/from_raw_data/for_1st_implement/%d.mat', case_num)};
% 
% save(file_actual_error{1},'ya');
% save(file_origin_reference{1},'xr');
% save(file_rec1{1},'rec1');
%% for 2nd_implement
case_num = 2

rec1.posx = xr';
rec1.vx = zeros(1,160001);
rec1.ax = zeros(1,160001);
rec1.jx = zeros(1,160001);
rec1.ex = ya'; % 保存Simulink中输出的误差

% ya = error_output.Data';

% file_actual_error = {sprintf('../../data/implement/case%d/actual_error.mat', case_num)};
% file_origin_reference = {sprintf('../../data/implement/case%d/origin_reference.mat', case_num)};
file_rec1 = {sprintf('../pro_data/from_raw_data/for_2nd_implement/%d.mat', case_num)};

% save(file_actual_error{1},'ya');
% save(file_origin_reference{1},'xr');
save(file_rec1{1},'rec1');
