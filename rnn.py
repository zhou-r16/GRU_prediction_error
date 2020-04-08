#  利用keras实现RNN
from matplotlib import pyplot as plt
import tensorflow as tf
from keras.models import Sequential
from keras.layers import CuDNNGRU as GRU
# from keras.layers import GRU as GRU
# from keras.layers import GRU
from keras.optimizers import Adam
from keras.initializers import Orthogonal
from keras.backend.tensorflow_backend import set_session


# 利用Keras搭建神经网络的模型
class GRU_model:
    def __init__(self, config):
        self.config = config

        #  set gpu:
        gpu_options = tf.GPUOptions(per_process_gpu_memory_fraction=0.3, allow_growth=True)
        gpu_config = tf.ConfigProto(gpu_options=gpu_options, allow_soft_placement=True)

        #  定义模型和GRU网络结构
        #  gru structure
        self.model = Sequential()
        init = Orthogonal()
        self.model.add(GRU(200, input_shape=(None, config['dim']), return_sequences=True,
                           kernel_initializer=init))
        # self.model.add(GRU(64, return_sequences=True, kernel_initializer=init))
        self.model.add(GRU(config['out_dim'], return_sequences=True, kernel_initializer=init))
        # self.model.add(GRU(200, input_shape=(None, config['dim']), return_sequences=True,
        #                    kernel_initializer=init, reset_after=True))
        # # self.model.add(GRU(64, return_sequences=True, kernel_initializer=init))
        # self.model.add(GRU(config['out_dim'], return_sequences=True, kernel_initializer=init, reset_after=True))
        adam = Adam(lr=config['learning_rate'], clipnorm=1.0)
        #  set session
        set_session(tf.Session(config=gpu_config))

        self.model.compile(loss='mse', optimizer=adam, metrics=['mae'])

    def train(self, dataX, dataY):
        #  get history:
        #  fit函数返回一个History的对象，其History.history属性记录了损失函数和其他指标的数值随epoch变化的情况
        #  如果有验证集的话，也包含了验证集的这些指标变化情况
        history = self.model.fit(dataX, dataY, batch_size=self.config['batch_size'],
                                 nb_epoch=self.config['training_epochs'], verbose=2, validation_split=0.2)
        return history

    #  保存模型的权重
    #  Keras一般使用h5文件类型来进行保存
    def save(self):
        self.model.save_weights('train_log/{}.h5'.format(self.config['model_name']))
        print('model saved!')

    #  恢复模型
    def restore(self):
        print('I am going to load {}'.format(self.config['plant']))
        self.model.load_weights('train_log/{}.h5'.format(self.config['model_name']))
        print('model loaded!')

    # 验证预测误差和实际误差并作图。根据X位置预测Y的位置
    def validate(self, val_dataX, val_dataY):
        print('Start validate!')
        print(val_dataX.shape)
        predict_Y = self.model.predict(val_dataX)  # 返回预测的Y值
        for i in range(val_dataX.shape[0]):
            #  ravel()扁平化函数，将多维数组转化为一位数组
            plt.plot(predict_Y[i].ravel(), label='prediction')
            plt.plot(val_dataY[i].ravel(), label='actual')
            plt.legend()
            plt.show()

    # 对im_dataX进行误差预测
    def implement(self, im_dataX):
        predict_Y = self.model.predict(im_dataX)
        predict_Y = predict_Y.reshape([predict_Y.shape[0], -1, 1])
        return predict_Y
