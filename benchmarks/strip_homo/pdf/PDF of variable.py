#!/usr/bin/env python
# coding: utf-8

# In[42]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.neural_network import MLPRegressor
import tensorflow
import keras


# In[43]:


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


# In[44]:


num_step = 2
file_name = './data/data'
A_ij = []
errs = []

for i in range(num_step):

    # getting data
    train_data = pd.read_csv(file_name + str(i+1) + '.csv')
    features_mean = list(train_data.columns[0:9])
    x_train = train_data.loc[:,features_mean]
    y_train = train_data.loc[:,'W']
    x = x_train.to_numpy()
    # x = x[1:100,:]
    y = y_train.to_numpy()
    # y = y[1:100]

    # fitting model
    model.fit(x.reshape(-1,9), y, epochs=10000, verbose=1)

    # getting the last layer
    layerCount = len(model.layers)
    lastLayer = layerCount - 1;

    #getting the weights:
    lastWeights = model.layers[lastLayer].get_weights()

    # save A_ij
    A_ij.append(lastWeights[0][0])

    #getting scores
    prediction = model.predict(x)
    err = 0
    for i in range(len(prediction)):
        err = err + abs(prediction[i][0] - y[i])
    errs.append(err)


# In[45]:


f = open("A_ij.txt", "w")
for i in range(len(A_ij)):
    f.write(str(A_ij[i][0]))
    f.write('\n')
f.close()


# In[46]:


f = open("errs.txt", "w")
for i in range(len(errs)):
    f.write(str(errs[i]))
    f.write('\n')
f.close()


# In[ ]:
