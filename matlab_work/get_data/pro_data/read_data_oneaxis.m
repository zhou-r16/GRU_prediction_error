function [posx, vx, ax, jx, e, fs] = read_data_oneaxis(filename)
%% read data:
load(filename);
% new read data:
% version = max(size(rec.Y));
% if(version == 3) 
%     c = rec.Y(1).Data';
%     x = rec.Y(2).Data';
%     y = rec.Y(3).Data';
%     clip_ratio = 0.05;
% elseif(version == 2)
%     x = rec.Y(2).Data';
%     y = rec.Y(1).Data';   
%     clip_ratio = 0.125;
% end

clip_ratio = 0.05;

% t = rec.X.Data';
% fs = round(1/(1000*(t(end) - t(end-1))))*1000;
fs = 2000;
% In NRUBS
% other:


posx=rec1.posx;
vx=rec1.vx;
ax=rec1.ax;
jx=rec1.jx;

e=rec1.ex;

vx=vx';
ax=ax';
jx=jx';
% e=e';
% posx=posx';

% ad = find(x);
% x = x(min(ad):max(ad),:);
% y = y(min(ad):max(ad), :);
% e = (x - y);
cut = 5;
sys = c2d(tf((2*pi*cut)^2,[1, 2*0.7*2*pi*cut, (2*pi*cut)^2]),0.0005);
ee = e;
e = filtfilt(sys.num{1},sys.den{1},e);
eee = e;
e = filtfilt(sys.num{1},sys.den{1},e);
eeee = e;
e = filtfilt(sys.num{1},sys.den{1},e);
% e = noise_filt(e);
% cut down after filt:

size(vx,1);
clip_step = floor(size(vx, 1)*clip_ratio);

vx = vx(clip_step:end-clip_step, :);
ax =ax(clip_step:end-clip_step, :);
jx = jx(clip_step:end-clip_step, :);
posx = posx(clip_step:end-clip_step, :);

e = e(clip_step:end-clip_step, :);
end