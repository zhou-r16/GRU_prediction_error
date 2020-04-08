# main function is used to make all configurations and making results
# -*- coding:utf-8 -*-
import argparse
import get_dataset as dataset
import trainer
import os

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'


def gen_config(args):
    config = dict()
    config['plant'] = args.plant
    config['mode'] = args.mode
    config['network'] = args.network
    config['continue'] = args.cont
    # implement时使用，为case的编号
    config['case_num'] = args.imple

    # changing part:
    config['time_step'] = 1  # predict in segment
    config['c_step'] = 1  # continuous time step
    config['training_epochs'] = 2000
    config['batch_size'] = 32
    config['learning_rate'] = 5e-5

    # 数据归一化所需要用到的系数，提前求得数据集中X,V,A,J以及tracking error的最大值，代入其中
    # config['scales'] = [20.1, 709.5, 1.69e4, 2.89e5, 2.08e4]  # 前4个分别对应X,V,A,J，最后一个对应error
    config['scales'] = [2.20e4, 4.32e5, 4.24e6, 9.52e6, 3.97e5]  # 前4个分别对应X,V,A,J，最后一个对应error
    # GRU的输入量长度为12
    # Input(t0)= (X(t0-1),V(t0-1),A(t0-1),J(t0-1),X(t0),V(t0),A(t0),J(t0),X(t0+1),V(t0+1),A(t0+1),J(t0+1))
    config['dim'] = 4 * (config['c_step'] * 2 + config['time_step'])
    # 输入量为预测的误差，一般维度就是1
    config['out_dim'] = config['time_step']

    # params for signals:
    config['file_path'] = 'matlab_work/data/train/2nd_train'



    # log structure
    config['save'] = True
    if (config['mode'] == 'train') and (not config['continue']):
        config['restore'] = False
    else:
        config['restore'] = True

    # the name of saved model
    config['model_name'] = '{}_model_err_c{}_{}'.format(config['plant'], config['c_step'], config['network'])
    return config


def run(config):
    mytrainer = trainer.Trainer(config)

    if config['mode'] == 'train':
        X, Y = dataset.read_data(config['file_path'])
        mytrainer.add_data(X, Y)
        mytrainer.train()
    elif config['mode'] == 'test':
        mytrainer.test()
    elif config['mode'] == 'implement':
        # mytrainer.implement()
        for num in range(1, 26):
            config['case_num'] = num
            mytrainer = trainer.Trainer(config)
            mytrainer.implement()
            print('Predicting im_data{}.mat'.format(num))


if __name__ == '__main__':
    # fix config
    parser = argparse.ArgumentParser(description='config for plant & network & mode')
    parser.add_argument('-p', '--plant', default='pid')
    parser.add_argument('-n', '--network', default='rnn')
    parser.add_argument('-m', '--mode', default='train', choices=['train', 'test', 'implement'])
    parser.add_argument('-c', '--cont', default=True, choices=[True, False])
    parser.add_argument('-i', '--imple', default=1)
    args = parser.parse_args()
    config = gen_config(args)
    run(config)
