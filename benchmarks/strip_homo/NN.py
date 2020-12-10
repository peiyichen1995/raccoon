#!/usr/bin/env python
# coding: utf-8

# In[2]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.neural_network import MLPRegressor
import tensorflow
import keras


# In[3]:


train_data = pd.read_csv('./stress_xx_sample_fitted3.csv')
F = train_data.loc[:,'F']
A = train_data.loc[:,'A']


# In[4]:


Cauchy = F/A[2]
Lambda = [0.01*(i-1)+1 for i in range(1,len(F)+1)]

for i in range(len(Lambda)):
    Cauchy[i] = Cauchy[i]*Lambda[i]


# In[5]:


fig, ax = plt.subplots()
ax.plot(Lambda, Cauchy.to_numpy(), '--', label='train')
plt.title("stress-stretch")
legend = ax.legend(loc='lower right', shadow=True, fontsize='x-large')

# Put a nicer background color on the legend.
# legend.get_frame().set_facecolor('C2')
plt.xlabel("lambda_1")
plt.ylabel("Cauchy_11")

plt.show()


# In[6]:


x = np.array(Lambda)
y = Cauchy.to_numpy()


# In[7]:


regr = MLPRegressor(random_state=1, max_iter=10000).fit(x.reshape(-1, 1), y)
prediction = regr.predict(x.reshape(-1, 1))


# In[8]:


prediction


# In[9]:


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


# In[10]:


model = keras.Sequential()
model.add(keras.layers.Dense(units = 1, activation = 'linear', input_shape=[1]))
model.add(keras.layers.Dense(units = 64, activation = 'relu'))
model.add(keras.layers.Dense(units = 64, activation = 'relu'))
model.add(keras.layers.Dense(units = 1, activation = 'linear'))
model.compile(loss='mse', optimizer="adam")


# In[11]:


model.fit(x.reshape(-1, 1), y, epochs=10000, verbose=1)
prediction_kera = model.predict(x.reshape(-1, 1))


# In[12]:


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

# In[76]:


num_step = 1
file_name = 'stress_xx_sample_def_Data_00'


# In[79]:


data = pd.read_csv('./stress_xx_sample_def_Data_0000.csv')
features_mean = list(data.columns[5:13])
defg = data.loc[:,features_mean]
strain_energy_density = data.loc[:, 'strain_energy_density']

for i in range(num_step):
    if (i+1) < 10:
        data = pd.read_csv('./' + file_name + '0' + str(i+1) + '.csv')
    else:
        data = pd.read_csv('./' + file_name + str(i+1) + '.csv')

    features_mean = list(data.columns[5:13])
    defg = defg.append(data.loc[:,features_mean], ignore_index=True)
    strain_energy_density = strain_energy_density.append(data.loc[:, 'strain_energy_density'], ignore_index=True)

#     defg=data.loc[:,features_mean]
#     strain_energy_density=data.loc[:, 'strain_energy_density']


# In[81]:


strain_energy_density


# In[ ]:





# In[37]:


model = keras.Sequential()
model.add(keras.layers.Dense(units = 1, activation = 'linear', input_shape=[8]))
model.add(keras.layers.Dense(units = 64, activation = 'relu'))
model.add(keras.layers.Dense(units = 64, activation = 'relu'))
model.add(keras.layers.Dense(units = 1, activation = 'linear'))
model.compile(loss='mse', optimizer="adam")
model.fit(defg.to_numpy().reshape(-1,8), strain_energy_density.to_numpy(), epochs=10000, verbose=1)


# In[39]:


prediction = model.predict(defg.to_numpy().reshape(-1,8))


# In[52]:


err = 0
simulation = strain_energy_density.to_numpy()
for i in range(len(prediction)):
    err = err + abs(prediction[i][0] - simulation[i])


# In[54]:

print('error:\n')
print(err/sum(simulation))
