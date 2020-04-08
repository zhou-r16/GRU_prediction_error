% run: generating training sets:
clc
clear
%% 1. read data:
Start = 101;
End = 120;
filenames = cell((End-Start+1), 1);
for i=1:1:(End-Start+1)
filenames(i) = {sprintf('./from_raw_data/%d.mat', i+Start-1)};
end

% neccessary datas:q

% get seq len:
filename = char(filenames(1));
[posx, vx, ax, jx, e, fs] = read_data_oneaxis(filename);
seqlen = size(vx,1);
% config
batchlen = 10000;
filenum = size(filenames, 1);

% Ed = zeros(filenum, seqlen, 1);

%% 2. process data
% notice: state has been processed in matlab
% make it fit in different size:
POSX = [];
VX = [];
E = [];
AX = [];
JX = [];

for i = 1:1:filenum
    filename = char(filenames(i));
    [posx_, vx_, ax_, jx_, e_, fs_] = read_data_oneaxis(filename);
    % resize here| concat:
    secnum = floor(size(vx_, 1)/batchlen);
    posx__ = reshape(posx_(1:secnum*batchlen), batchlen, secnum); 
    vx__ = reshape(vx_(1:secnum*batchlen), batchlen, secnum); 
    ax__ = reshape(ax_(1:secnum*batchlen), batchlen, secnum); 
    jx__ = reshape(jx_(1:secnum*batchlen), batchlen, secnum); 
    e__ = reshape(e_(1:secnum*batchlen), batchlen, secnum); 
    % error process:
%     if(abs(max(max(e)))<2e-5)
        % when it is an good results:
        POSX = [POSX, posx__];
        VX = [VX, vx__];
        AX = [AX, ax__];
        JX = [JX, jx__];
        E = [E, e__];
%     end
end

%% 3. save: clip and downsample:
% change into x and y
x1 = POSX;
x2 = VX;
x3 = AX;
x4 = JX;

y = E;

% yb = Ed;
x1_ = down_sample(x1, 10);
x2_ = down_sample(x2, 10);
x3_ = down_sample(x3, 10);
x4_ = down_sample(x4, 10);

y_ = down_sample(y, 10);


%Í³¼ÆÓÃË³Ðò
x(:,:,1) = x1_'; %px
% x(:,:,2) = x2_'; %vx
% x(:,:,3) = x3_';  %ax
% x(:,:,4) = x4_';  %jx


for i=1:1:length(x(1,1,:))
    max__(i)=1/max(max(abs(x(:,:,i))));
end

y = y_;
y=y';
1/max(max(abs(y)))
% save('../im_data.mat', 'x');1
save('../../data/train/xe.mat', 'x');
save('../../data/train/ye.mat', 'y');
% save('../train/yb.mat', 'yb');