#!/usr/bin/env python
# coding: utf-8

# In[26]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.neural_network import MLPRegressor
import tensorflow
import keras


# In[27]:


train_data = pd.read_csv('./data1.csv')

features_mean = list(train_data.columns[0:9])
x_train = train_data.loc[:,features_mean]
y_train = train_data.loc[:,'W']


# In[28]:


model = keras.Sequential()
model.add(keras.layers.Dense(units = 1, activation = 'linear', input_shape=[9]))
model.add(keras.layers.Dense(units = 64, activation = 'relu'))
model.add(keras.layers.Dense(units = 64, activation = 'relu'))
model.add(keras.layers.Dense(units = 64, activation = 'relu'))
# model.add(keras.layers.Dense(units = 6, activation = 'relu'))
# model.add(keras.layers.Dense(units = 3, activation = 'relu'))
model.add(keras.layers.Dense(units = 1, activation = 'linear'))
model.compile(loss='mse', optimizer="adam")
x = x_train.to_numpy()
# x = x[1:100,:]
y = y_train.to_numpy()
# y = y[1:100]
model.fit(x.reshape(-1,9), y, epochs=10000, verbose=1)


# In[32]:


prediction = model.predict(x)
prediction


# In[33]:


fig, ax = plt.subplots()
ax.plot(x[:,0], y, label='train data')
ax.plot(x[:,0], prediction, label='trained NN')
plt.title("lambda vs. strain energy density")
legend = ax.legend(loc='lower right', shadow=True, fontsize='x-large')

# Put a nicer background color on the legend.
# legend.get_frame().set_facecolor('C2')
plt.xlabel("lambda_11")
plt.ylabel("Strain energy density")
plt.savefig('test.png')
plt.show()
