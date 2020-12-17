#!/usr/bin/env python
# coding: utf-8

# In[ ]:


from multiprocessing import Pool
import time

def square(x):
    # calculate the square of the value of x
    return x*x

start_time = time.time()

if __name__ == '__main__':

    # Define the dataset
    dataset = range(1,1000000)

    # Output the dataset
    # print ('Dataset: ' + str(dataset))

    # Run this with a pool of 5 agents having a chunksize of 3 until finished
    agents = 80
    chunksize = 12500
    with Pool(processes=agents) as pool:
        result = pool.map(square, dataset, chunksize)

    # Output the result
    # print ('Result:  ' + str(result))

print(time.time() - start_time)
