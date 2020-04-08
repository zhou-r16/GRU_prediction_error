import numpy as np
import get_dataset as dataset
import scipy.io as scio
from rnn import GRU_model


class Trainer:
    def __init__(self, config):
        self.config = config
        self.nn = GRU_model(config)

        if self.config['restore']:
            self.nn.restore()

    def add_data(self, X, Y):
        """

        :param X: 一般为read_data读取出的数据，形状为（seg_num,seg_length)
        :param Y:一般为read_data读取出的数据，形状为（seg_num,seg_length)
        例如：10条10000个点的NURBS曲线用于训练，将其切片成(100,1000)的形状，则seg_num=100,seg_length=1000
        :return:无返回值
        """
        #  生成训练数据
        #  X shape(N, time_step, dimension)
        #  Y shape(N, time_step, dimension)
        data_X, data_Y = [], []
        #  sequence them
        for i in range(X.shape[0]):  # 对X的每一行
            tmp_x, tmp_y = dataset.process_xy_for_train(X[i], Y[i], self.config)
            data_X.append(tmp_x)
            data_Y.append(tmp_y)

        #  data_X的shape此时变为(X.shape[0], seg_length - 6, 12)
        #  data_Y的shape此时变为(Y.shape[0], seg_length - 6, 1)
        data_X = np.asarray(data_X)
        data_Y = np.asarray(data_Y)

        #  根据上述操作，这个语句应该不会被执行
        if len(data_Y.shape) == 2:
            data_Y = data_Y[:, :, np.newaxis]  # 改变矩阵的shape。比如（360,1000）→（360,1000,1）

        #  最后batch_size项作为验证集，前面的项作为训练集
        self.train_dataX = data_X[:-self.config['batch_size']]
        self.train_dataY = data_Y[:-self.config['batch_size']]
        np.save('fast_data/trainX.npy', self.train_dataX)
        np.save('fast_data/trainY.npy', self.train_dataY)

        self.val_data = dict()
        self.val_dataX = data_X[-self.config['batch_size']:]
        self.val_dataY = data_Y[-self.config['batch_size']:]
        self.val_data['X'] = self.val_dataX
        self.val_data['Y'] = self.val_dataY
        np.save('fast_data/valX.npy', self.val_dataX)
        np.save('fast_data/valY.npy', self.val_dataY)

    # 对训练集进行训练
    def train(self):
        self.nn.train(self.train_dataX, self.train_dataY)
        if self.config['save']:
            self.nn.save()
        self.test()

    # 验证集进行测试
    def test(self):
        #  drawing examination
        x_test = np.load('fast_data/valX.npy')
        y_test = np.load('fast_data/valY.npy')
        self.nn.validate(x_test, y_test)

    # 利用网络进行预测
    def implement(self):
        #  imdataX is the data come from target structure:
        #  imdatax should be (N, time_step, 12) 比如(1,1000,12)
        im_dataX = scio.loadmat('matlab_work/data/implement/case{}/im_data.mat'.format(self.config['case_num']))['x']

        d_im_dataX = dataset.process_x_for_implementation(im_dataX, self.config)  # d_im_dataX为处理后的数据，shape为(1,seg_length - 6,12)
        predict_Y = self.nn.implement(d_im_dataX)
        predict_Y = predict_Y / self.config['scales'][-1]
        #  padd zero:
        z_num = predict_Y.shape[0]
        z_c = predict_Y.shape[-1]

        predict_Y = np.concatenate([np.zeros([z_num, 2 + self.config['c_step'], z_c]), predict_Y,
                                    np.zeros([z_num, 2, z_c])], axis=1)

        #  compensate zero
        num_diff = im_dataX.shape[1] - predict_Y.shape[1]
        predict_Y = np.concatenate([predict_Y, np.zeros([z_num, num_diff, z_c])], axis=1)

        #  reshape into standard shape
        scio.savemat('matlab_work/data/implement/case{}/pre_data.mat'.format(self.config['case_num']), {'yp': predict_Y})
        return predict_Y
