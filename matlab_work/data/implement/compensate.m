% compensatiom.m:��ȡԭʼreference����Ҫ��������������������ṩ��Simulinkģ�ͽ��з���
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

% ������Simulink��������������������䣬����tracking error
% e = error_output.Data';
% file_tracking_error = {sprintf('case%d/tracking_error.mat', case_num)};
% save(file_tracking_error{1},'e');
