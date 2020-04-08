% compensatiom.m:读取原始reference和需要补偿的误差量，补偿后提供给Simulink模型进行仿真
clear
clc

case_num = 2;
fs=2000;
T = 80;

file_origin_reference = {sprintf('case%d/1st_implement/origin_reference1.mat', case_num)};
file_compensation_error = {sprintf('case%d/1st_implement/compensation_error1.mat', case_num)};
file_compensation_error2 = {sprintf('case%d/2nd_implement/compensation_error2.mat', case_num)};


load(file_origin_reference{1});
load(file_compensation_error{1});
ycc1 = yc;
load(file_compensation_error2{1});
ycc2 = yc;
ycc = ycc1+ycc2;

t = 0:1/fs:T;
data_in = [t' xr'];
compensation = [t' ycc'];

% 运行完Simulink后在命令行运行下面语句，保存tracking error
% e = error_output.Data';
% file_tracking_error = {sprintf('case%d/1st_implement/tracking_error1.mat', case_num)};
% save(file_tracking_error{1},'e');
