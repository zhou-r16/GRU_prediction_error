# Pro_data
* 此部分对raw_data中生成的数据进行处理，形成最终用于GRU训练的数据
## How to use：
* 对于训练集，运行`run_oneaxis.m`,可以在指定文件夹中生成`x.mat`,`y.mat`。这两个文件就是输入到GRU网络中的文件
* 对于测试集，运行`run_implement_oneaxis.m`,可以在指定文件夹中生成`im_data.mat`,该文件用于输入到GRU网络中进行预测。预测完成后进入`matlab_work/data/implement`中继续后续操作



## run_oneaxis.m
* 对from_raw_data中的多个数据文件进行预处理（如降采样），整合，最终生成`x.mat`,`y.mat`
## read_data_oneaxis.m
* `run_oneaxis.m`的子函数，用于读取数据
## run_implement_oneaxis.m
* 与`run_oneaxis.m`类似，在实际使用GRU进行预测的时候对reference进行预处理，生成`x.mat`
## read_data_implement_oneaxis.m
* `run_implement_oneaxis.m`的子函数，用于读取数据