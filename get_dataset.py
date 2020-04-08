import numpy as np
import scipy.io as scio
from sklearn.utils import shuffle


# 读取mat文件中的数据，和mat中的尺寸保持一致
def read_mat(filename):
    """

    :param filename: 文件名
    :return: data数据，shape和mat文件一致

    本项目中如无特别说明，x表示reference，y表示tracking error
    """
    data = scio.loadmat(filename)  # 读取mat文件
    if 'x' in data.keys():
        data = data['x']
        data = data * 1.0
    elif 'y' in data.keys():
        data = data['y']
        data = data * 1.0
    else:
        raise Exception("Invalid mat file!")
    return data


#  将mat中的数据读取后进行打乱
def read_data(file_path):
    # 读取x，y的mat文件
    dataX = read_mat('{}/xe.mat'.format(file_path))
    dataY = read_mat('{}/ye.mat'.format(file_path))
    print('data shape is {}'.format(dataX.shape))

    # 利用shuffle()打乱样本顺序
    dataX, dataY = shuffle(dataX, dataY)

    # scio.savemat('matlab_work/data/train/shuffle_x.mat', {'sx': dataX})
    # scio.savemat('matlab_work/data/train/shuffle_y.mat', {'sy': dataY})

    return dataX, dataY


# 对原始的reference和tracking erorr数据进行一定的预处理
# Used in training
def process_xy_for_train(origin_X, origin_Y, config):
    """

    :param origin_X: 原始reference轨迹,一般形状为一个行向量
    :param origin_Y: 对应的tracking_error，一般形状为一个行向量
    :param config: 配置信息
    :return:处理后的用于训练的数据,形状为（，12）
    """
    # 全部变成列向量，便于后续操作
    if len(origin_X.shape) == 1:
        origin_X = origin_X[:, np.newaxis]  # 增加维数（例如：N → N×1）
    if len(origin_Y.shape) == 1:
        origin_Y = origin_Y[:, np.newaxis]  # 增加维数（例如：N → N×1）

    '''
    进行差分运算，利用位移求得速度，加速度，急动度
    example：
    X:|--|--|--|--|--|--|--|--|--|--| 后一时刻减去前一时刻，可得到中间时刻的速度
    V': |--|--|--|--|--|--|--|--|--|  再用后一时刻减去前一时刻，可以得到中间时刻的加速度
    A:   |--|--|--|--|--|--|--|--|    此时A第一项的时间戳是和x的第二项的时间戳对应的。为了让时间戳对应，利用V(t)=(X(t+1)-X(t-1))/2求速度
    V:   |--|--|--|--|--|--|--|--|    对于J的求法也一样，为了让时间戳可以对应，利用J(t)=(A(t+1)-A(t-1))/2求出
    J:      |--|--|--|--|--|--|
    这样对于一段轨迹，除了前2个点和后2个点，其余所有点的X,V,A,J都是对应的，因此对进行掐头去尾的处理
    '''
    V_tmp = origin_X[1:] - origin_X[:-1]
    A = V_tmp[1:] - V_tmp[:-1]
    V = (origin_X[2:] - origin_X[:-2]) / 2
    J = (A[2:] - A[:-2]) / 2

    # 掐头去尾
    X = origin_X[2:-2]
    V = V[1:-1]
    A = A[1:-1]

    # 处理后的数据
    processed_X = np.concatenate([X, V, A, J], axis=-1)  # 此时processed_X的shape为（N-4,4），N为原始reference的点数
    processed_Y = origin_Y[2:-2]

    # 对数据进行归一化操作，所有数据范围归一化至[-1,1]中
    # 首先对processed_X的每一列进行归一化
    for i in range(processed_X.shape[-1]):
        processed_X[:, i] *= config['scales'][i]
    # 再对processed_Y进行归一化
    processed_Y *= config['scales'][-1]

    '''
    获得最终用于GRU进行训练的数据
    time_step：预测步长，可以调整预测多个时刻后的轨迹（一般为1即可）
    c_step：每组预测数据中，x的前后步长（一般为1即可，即训练输入选取x的t-1/t/t+1，如果为2，则是t-2/t-1/t/t+1/t+2）
    training_data_num：训练数据的个数，一般掐头去尾即可
    训练过程中，t0时刻训练集的输入为：
    Input(t0)= (X(t0-1),V(t0-1),A(t0-1),J(t0-1),X(t0),V(t0),A(t0),J(t0),X(t0+1),V(t0+1),A(t0+1),J(t0+1))
    '''
    output_X, output_Y = [], []
    _t = config['time_step']
    train_data_num = (processed_Y.shape[0] - 2 * config['c_step']) // _t
    for i in range(train_data_num):  # 遍历所有的训练数据
        output_X.append(processed_X[i * _t:(i + 1) * _t + 2 * config['c_step']].ravel())  # 确定input vector
        output_Y.append(processed_Y[i * _t + config['c_step']].ravel())  # 找到对应的output（即tracking error）

    # 将output_X,output_Y转化为ndarray对象
    output_X = np.asarray(output_X, dtype=np.float32)
    output_Y = np.asarray(output_Y, dtype=np.float32)

    return output_X, output_Y


# 对原始的reference数据进行一定的预处理
# Used in implementation
def process_x_for_implementation(origin_X, config):
    """
    类似于process_xy_for_train的实现过程
    :param origin_X: 原始reference轨迹,一般形状为一个行向量
    :param config: 配置信息
    :return: 处理后的用于implementation的数据，形状为(,12)
    """

    # 全部变成列向量，便于后续操作
    origin_X = origin_X.reshape([-1, 1])

    V_tmp = origin_X[1:] - origin_X[:-1]
    A = V_tmp[1:] - V_tmp[:-1]
    V = (origin_X[2:] - origin_X[:-2]) / 2
    J = (A[2:] - A[:-2]) / 2

    # 掐头去尾
    X = origin_X[2:-2]
    V = V[1:-1]
    A = A[1:-1]

    # 处理后的数据
    processed_X = np.concatenate([X, V, A, J], axis=-1)  # 此时processed_X的shape为（N-4,4），N为原始reference的点数
    for i in range(processed_X.shape[-1]):
        processed_X[:, i] *= config['scales'][i]

    output_X = []
    _t = config['time_step']
    implementation_data_num = (processed_X.shape[0] - 2 * config['c_step']) // _t
    for i in range(implementation_data_num):  # 遍历所有的数据
        output_X.append(processed_X[i * _t:(i + 1) * _t + 2 * config['c_step']].ravel())  # 确定input vector

    # 将output_X转化为ndarray对象
    output_X = np.asarray(output_X, dtype=np.float32)

    if len(output_X.shape) == 2:
        output_X = output_X[np.newaxis, :, :]
        # print(output_X.shape)

    return output_X
