# Raw_data
* 此部分主要用于生成reference，并保存其在仿真系统中运行的误差
* 在训练网络时，具体使用流程：(1)运行`nurbs.m`,获得一条nurbs曲线作为reference；(2)运行Simulink仿真模型，得到对应的error；(3)运行`save_data.m`，将得到的数据存入`pro_data/from_raw_data/i.mat`中
* 在利用网络进行误差预测时，具体使用流程：(1)运行`nurbs.m`或`curve.m`,获得一条nurbs曲线或其它曲线作为reference；(2)运行Simulink仿真模型，得到对应的error；(3)运行`save_data.m`，将得到的数据存入`pro_data/from_raw_data/for_implement/i.mat`中


## nurbs.m
* 生成NURBS曲线，并将曲线作为Simulink的系统输入，存在Workspace中
## curve.m
* 生成reference曲线,使用GRU对其进行误差预测
## d3_gen.m
* nurbs.m的子函数，用于生成NURBS曲线
## save_data.m
* 将nurb.m生成的轨迹在Simulink运行后，将reference和error等信息保存到pro_data中，进行下一步处理