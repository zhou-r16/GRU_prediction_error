% compensatiom.m:读取原始reference和需要补偿的误差量，补偿后提供给Simulink模型进行仿真
clear
clc

case_num = 2;
fs=2000;
T = 70;

file_origin_reference = {sprintf('case%d/origin_reference.mat', case_num)};
file_compensation_error = {sprintf('case%d/compensation_error.mat', case_num)};

load(file_origin_reference{1});
load(file_compensation_error{1});

t = 0:1/fs:T;
data_in = [t' xr'];
compensation = [t' yc'];

% 运行完Simulink后在命令行运行下面语句，保存tracking error
% e = error_output.Data';
% file_tracking_error = {sprintf('case%d/tracking_error.mat', case_num)};
% save(file_tracking_error{1},'e');
