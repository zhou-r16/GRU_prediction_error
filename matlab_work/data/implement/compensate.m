% compensatiom.m:��ȡԭʼreference����Ҫ��������������������ṩ��Simulinkģ�ͽ��з���
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

% ������Simulink��������������������䣬����tracking error
% e = error_output.Data';
% file_tracking_error = {sprintf('case%d/1st_implement/tracking_error1.mat', case_num)};
% save(file_tracking_error{1},'e');
