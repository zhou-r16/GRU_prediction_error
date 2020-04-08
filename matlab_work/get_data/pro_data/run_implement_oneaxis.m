% run: generating training sets:
clc
clear
%% 1. read data:
case_num = 101;
Start = 101;
End = 101;
filenames = cell((End-Start+1), 1);
for i=1:1:(End-Start+1)
filenames(i) = {sprintf('./from_raw_data/for_implement2/%d.mat', i+Start-1)};
end

% neccessary datas:
% get seq len:
filename = char(filenames(1));
[posx, vx, ax, jx, e, fs] = read_data_implement_oneaxis(filename);
seqlen = size(vx,1);
% config
batchlen = 10000;
filenum = size(filenames, 1);

% Ed = zeros(filenum, seqlen, 1);

%% 2. process data
% notice: state has been processed in matlab
% make it fit in different size:


for i = 1:1:filenum
    POSX = [];
    VX = [];
    E = [];
    AX = [];
    JX = [];
    
    filename = char(filenames(i));
    [posx_, vx_, ax_, jx_, e_, fs_] = read_data_implement_oneaxis(filename);
    
%     load('./²¹³¥Á¿_error/16/pre_data_ite0.mat');
%     ex = yp;
%     ex = extend_sample(ex', 10);
%     
%     posx_ = posx_ + ex';
    % resize here| concat:
    secnum = floor(size(vx_, 1)/batchlen);
%     posx__ = reshape(posx_(1:secnum*batchlen), batchlen, secnum); 
%     posy__ = reshape(posy_(1:secnum*batchlen), batchlen, secnum); 
%     vx__ = reshape(vx_(1:secnum*batchlen), batchlen, secnum); 
%     vy__ = reshape(vy_(1:secnum*batchlen), batchlen, secnum); 
%     ax__ = reshape(ax_(1:secnum*batchlen), batchlen, secnum); 
%     ay__ = reshape(ay_(1:secnum*batchlen), batchlen, secnum); 
%     jx__ = reshape(jx_(1:secnum*batchlen), batchlen, secnum); 
%     jy__ = reshape(jy_(1:secnum*batchlen), batchlen, secnum); 
%     v__ = reshape(v_(1:secnum*batchlen), batchlen, secnum); 
%     a_qie__ = reshape(a_qie_(1:secnum*batchlen), batchlen, secnum); 
%     a_fa__ = reshape(a_fa_(1:secnum*batchlen), batchlen, secnum); 
%     e__ = reshape(e_(1:secnum*batchlen), batchlen, secnum); 
    % error process:
%     if(abs(max(max(e)))<2e-5)
        % when it is an good results:
        POSX = [POSX, posx_];
        VX = [VX, vx_];
        AX = [AX, ax_];
        JX = [JX, jx_];
        E = [E, e_];

%     end

%% 3. save: clip and downsample:
% change into x and y
    x1 = POSX';
    x2 = VX;
    x3 = AX;
    x4 = JX;

    y = E';


% yb = Ed;
    x1 = down_sample(x1, 10);
    x2 = down_sample(x2, 10);
    x3 = down_sample(x3, 10);
    x4 = down_sample(x4, 10);

% y = down_sample(y, 10);

    x(:,:,1) = x1'; %px
% x(:,:,2) = x2'; %vx
% x(:,:,3) = x3';  %ax
% x(:,:,4) = x4';  %jx

    for ii=1:1:length(x(1,1,:))
        max__(ii)=1/max(abs(x(:,:,ii)));
    end

    y=y';
% 1/max(abs(y))
%     file_im_data = {sprintf('../../data/implement/for_2nd_train/im_data%d.mat', i+Start-1)};
    file_im_data = {sprintf('../../data/implement/case%d/im_data.mat', i+Start-1)};
    save(file_im_data{1}, 'x');
% save('../x.mat', 'x');
% save('../y.mat', 'y');
% save('../train/yb.mat', 'yb');
end

