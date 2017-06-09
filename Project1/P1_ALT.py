### this is just practice working in python
### trying to do the same thing as done in the WWells_P1.Rmd file
### please review the R version

import numpy as np
import pandas as pd
import random
from sklearn.metrics import mean_squared_error

#set vars
np.random.seed(643)
n = 15
percentNAs = .3
LETTERS = map(chr, range(65, 91))
users = ['User_' + s for s in LETTERS[0:n]]
items = ['Item_' + s for s in LETTERS[0:n]]

#create initial df
df = pd.DataFrame(np.random.randint(1,6,size=(n, n)), columns=items)

#insert randoms vars
## https://stackoverflow.com/questions/42091018/randomly-insert-nas-values-in-a-pandas-dataframe-with-no-rows-completely-miss?rq=1
mask = np.random.choice([True, False], size=df.shape)
mask[mask.all(1),-1] = 0
df = df.mask(mask)

#Separate data
train_index = np.random.rand(len(df)) < .75
train = df[train_index]
test = df[~train_index]

#Calculations
train_raw_avg = df.stack().mean()

trainRMSE = ((train.stack() - train_raw_avg) ** 2).mean() ** .5
testRMSE = ((test.stack() - train_raw_avg) ** 2).mean() ** .5

user_bias_train = train.mean(1) - train_raw_avg
user_bias_test = test.mean(1) - train_raw_avg
item_bias_test = test.mean() - train_raw_avg

# make predictions based on these calculations