# Matlab_work
* 此部分主要包括一些matlab中的函数及生成的数据集
* data文件夹中保存最终输入到GRU网络进行训练和测试的数据
* get_data文件夹进行原始数据的获取及对数据的一些预处理



## get_scaled_coefficient.m
* 对数据进行归一化，求得`main.py`文件中的`config['scales']`数组