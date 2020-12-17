from multiprocessing import Pool

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.neural_network import MLPRegressor
import tensorflow
import keras

# set NN model
model = keras.Sequential()
model.add(keras.layers.Dense(units = 1, activation = 'linear', input_shape=[9]))
model.add(keras.layers.Dense(units = 11, activation = 'relu'))
model.add(keras.layers.Dense(units = 11, activation = 'relu'))
model.add(keras.layers.Dense(units = 11, activation = 'relu'))
model.add(keras.layers.Dense(units = 11, activation = 'relu'))
model.add(keras.layers.Dense(units = 11, activation = 'relu'))
model.add(keras.layers.Dense(units = 11, activation = 'relu'))
model.add(keras.layers.Dense(units = 11, activation = 'relu'))
model.add(keras.layers.Dense(units = 11, activation = 'relu'))
model.add(keras.layers.Dense(units = 11, activation = 'relu'))
model.add(keras.layers.Dense(units = 11, activation = 'relu'))
model.add(keras.layers.Dense(units = 11, activation = 'relu'))
model.add(keras.layers.Dense(units = 11, activation = 'relu'))
model.add(keras.layers.Dense(units = 11, activation = 'relu'))
model.add(keras.layers.Dense(units = 11, activation = 'relu'))
model.add(keras.layers.Dense(units = 1, activation = 'linear'))
model.compile(loss='mse', optimizer="adam")

def my_fun(num):
    train_data = pd.read_csv('./data/data' + str(num) + '.csv')
    features_mean = list(train_data.columns[0:9])
    x_train = train_data.loc[:,features_mean]
    y_train = train_data.loc[:,'W']
    x = x_train.to_numpy()
    y = y_train.to_numpy()

    # fitting model
    model.fit(x.reshape(-1,9), y, epochs=10, verbose=1)

    # getting the last layer
    layerCount = len(model.layers)
    lastLayer = layerCount - 1;

    #getting the weights:
    lastWeights = model.layers[lastLayer].get_weights()

    A_ij = lastWeights[0][0]

    #getting scores
    prediction = model.predict(x)
    err = 0
    for i in range(len(prediction)):
        err = err + abs(prediction[i][0] - y[i])
    err = err/sum(y)

    f = open("A_ij_new.txt", "w")
    f.write(str(A_ij))
    f.write('\n')
    f.close()

    f = open("errs_new.txt", "w")
    f.write(str(err))
    f.write('\n')
    f.close()

# file_names = []
# file_name = './data/data'
#
# num_step = 1
# for i in range(num_step):
#     file_names.append(file_name + str(i+1) + '.csv')
#
# print(file_names)

# my_fun(0)

if __name__ == '__main__':

    # Run this with a pool of 5 agents having a chunksize of 3 until finished
    agents = 2
    chunksize = 1
    with Pool(processes=agents) as pool:
        pool.map(my_fun, range(1,2), chunksize)
