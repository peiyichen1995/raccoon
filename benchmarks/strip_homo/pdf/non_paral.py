import time

def square(x):
    # calculate the square of the value of x
    return x*x

dataset = range(1,100000)

start_time = time.time()

for i in range(len(dataset)):
    result = square(dataset[i])

print(time.time() - start_time)
