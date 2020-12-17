from multiprocessing import Pool

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

def my_fun(file_name, model):
    train_data = pd.read_csv(file_name)
    features_mean = list(train_data.columns[0:9])
    x_train = train_data.loc[:,features_mean]
    y_train = train_data.loc[:,'W']
    x = x_train.to_numpy()
    y = y_train.to_numpy()

    # fitting model
    model.fit(x.reshape(-1,9), y, epochs=10000, verbose=1)

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
    f.write(A_ij)
    f.write('\n')
    f.close()

    f = open("errs_new.txt", "w")
    f.write(err)
    f.write('\n')
    f.close()

my_fun('./data/data1.csv', model)
