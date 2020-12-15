#!/usr/bin/env python
# coding: utf-8

# In[85]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.neural_network import MLPRegressor
import tensorflow
import keras


# In[86]:


train_data = pd.read_csv('./stress_xx_sample_fitted3.csv')
F = train_data.loc[:,'F']
A = train_data.loc[:,'A']


# In[87]:


Cauchy = F/A[2]
Lambda = [0.01*(i-1)+1 for i in range(1,len(F)+1)]

for i in range(len(Lambda)):
    Cauchy[i] = Cauchy[i]*Lambda[i]


# In[88]:


fig, ax = plt.subplots()
ax.plot(Lambda, Cauchy.to_numpy(), '--', label='train')
plt.title("stress-stretch")
legend = ax.legend(loc='lower right', shadow=True, fontsize='x-large')

# Put a nicer background color on the legend.
# legend.get_frame().set_facecolor('C2')
plt.xlabel("lambda_1")
plt.ylabel("Cauchy_11")

plt.show()


# In[89]:


x = np.array(Lambda)
y = Cauchy.to_numpy()


# In[90]:


regr = MLPRegressor(random_state=1, max_iter=10000).fit(x.reshape(-1, 1), y)
prediction = regr.predict(x.reshape(-1, 1))


# In[91]:


prediction


# In[92]:


fig, ax = plt.subplots()
ax.plot(Lambda, Cauchy.to_numpy(), '--', label='experiment')
ax.plot(Lambda, prediction, '--', label='prediction')
plt.title("stress-stretch")
legend = ax.legend(loc='lower right', shadow=True, fontsize='x-large')

# Put a nicer background color on the legend.
# legend.get_frame().set_facecolor('C2')
plt.xlabel("lambda_1")
plt.ylabel("Cauchy_11")

plt.show()


# In[93]:


model = keras.Sequential()
model.add(keras.layers.Dense(units = 1, activation = 'linear', input_shape=[1]))
model.add(keras.layers.Dense(units = 64, activation = 'relu'))
model.add(keras.layers.Dense(units = 64, activation = 'relu'))
model.add(keras.layers.Dense(units = 1, activation = 'linear'))
model.compile(loss='mse', optimizer="adam")


# In[94]:


model.fit(x.reshape(-1, 1), y, epochs=10000, verbose=1)
prediction_kera = model.predict(x.reshape(-1, 1))


# In[95]:


fig, ax = plt.subplots()
ax.plot(Lambda, Cauchy.to_numpy(), '--', label='experiment')
ax.plot(Lambda, prediction_kera, '--', label='prediction_kera')
plt.title("stress-stretch")
legend = ax.legend(loc='lower right', shadow=True, fontsize='x-large')

# Put a nicer background color on the legend.
# legend.get_frame().set_facecolor('C2')
plt.xlabel("lambda_1")
plt.ylabel("Cauchy_11")

plt.show()


# ### For strain enrgy density in terms of F

# In[96]:


num_step = 29
file_name = 'stress_xx_sample_def_Data_00'


# In[97]:


data = pd.read_csv('./def4/stress_xx_sample_def_Data_0000.csv')
features_mean = list(data.columns[5:13])
defg = data.loc[:,features_mean]
strain_energy_density = data.loc[:, 'strain_energy_density']

for i in range(num_step):
    if (i+1) < 10:
        data = pd.read_csv('./def4/' + file_name + '0' + str(i+1) + '.csv')
    else:
        data = pd.read_csv('./def4/' + file_name + str(i+1) + '.csv')

    features_mean = list(data.columns[5:13])
    defg = defg.append(data.loc[:,features_mean], ignore_index=True)
    strain_energy_density = strain_energy_density.append(data.loc[:, 'strain_energy_density'], ignore_index=True)

#     defg=data.loc[:,features_mean]
#     strain_energy_density=data.loc[:, 'strain_energy_density']



# In[117]:


model = keras.Sequential()
model.add(keras.layers.Dense(units = 8, activation = 'linear', input_shape=[8]))
model.add(keras.layers.Dense(units = 4, activation = 'relu'))
model.add(keras.layers.Dense(units = 2, activation = 'relu'))
model.add(keras.layers.Dense(units = 1, activation = 'linear'))
model.compile(loss='mse', optimizer="adam")
x = defg.to_numpy()
# x = x[1:100,:]
y = strain_energy_density.to_numpy()
# y = y[1:100]
model.fit(x.reshape(-1,8), y, epochs=200, verbose=1)


# In[118]:


prediction = model.predict(x)


# In[119]:


err = 0
for i in range(len(prediction)):
    err = err + abs(prediction[i][0] - y[i])


# In[120]:

f = open("NN_error4.txt", "w")
f.write(str(err/sum(y)))
f.write('\n')
f.close()

# serialize model to JSON
model_json = model.to_json()
with open("model4.json", "w") as json_file:
    json_file.write(model_json)
# serialize weights to HDF5
model.save_weights("model4.h5")
print("Saved model to disk")
