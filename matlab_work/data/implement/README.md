# data_implement
每个case代表一条曲线，每个case文件夹下各个文件的意义分别为
* `origin_reference.mat`:原始的曲线
* `actual_error.mat`:没有进行误差补偿时的误差
* `im_data.mat`:原始的曲线降采样后用于输入到GRU的数据
* `pre_data.mat`:GRU预测出的误差数据
* `compensation_error.mat`:对GRU预测出的误差进行线性插值，得到和原始曲线相同点数的误差补偿值
* `tracking_error.mat`:GRU补偿后得到误差
* `0 casei.txt`:记录曲线信息

## get_compensation_error.m
* 将GRU预测得到的误差进行extend_sample，得到最终补偿给原始reference的误差信号
## extend_sample.m
* GRU预测得到的误差是降采样之后的，因此需要进行extend后才能补偿给原始的reference
## compensate.m
* 读取原始reference和需要补偿的误差量，补偿后提供给Simulink模型进行仿真
