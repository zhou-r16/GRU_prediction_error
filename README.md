# GRU_prediction_error

## fast_data
* 以npy格式存储的数据
## matlab_work
* 在matlab中进行的数据集收集、数据预处理、Simulink仿真模型，为GRU网络训练做准备
## train_log
* 存储训练后的网络模型
## python相关文件
* `get_dataset.py`:将数据集进行处理后输入到GRU网络中
* `rnn.py`:搭建rnn网络结构
* `trainer.py`:包括train、validate、implement等操作
* `main.py`:包含配置信息。程序入口
* `hyper_param.py`:寻找最优参数（本项目中未使用）