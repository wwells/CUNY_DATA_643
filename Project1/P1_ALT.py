### this is just practice working in python
### trying to do the same thing as done in the WWells_P1.Rmd file
### please review the R version

import numpy as np
import pandas as pd
import random

#set vars
np.random.seed(643)
n = 15
percentNAs = .3
LETTERS = map(chr, range(65, 91))
users = ['User_' + s for s in LETTERS[0:n]]
items = ['Item_' + s for s in LETTERS[0:n]]

#create initial df
df = pd.DataFrame(np.random.randint(1,6,size=(n, n)), columns=items, index=users)

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
item_bias_train = train.mean() - train_raw_avg

# make predictions based on these calculations
train_prediction = [x + y + train_raw_avg for x in user_bias_train for y in item_bias_train]
train_pred_df = pd.DataFrame(np.array(train_prediction).reshape(len(train), 15))

test_prediction = [x + y + train_raw_avg for x in user_bias_test for y in item_bias_train]
test_pred_df = pd.DataFrame(np.array(test_prediction).reshape(len(test), 15))

trainPredRMSE = ((train_raw_avg - train_pred_df.stack()) ** 2).mean() ** .5
testPredRMSE = ((train_raw_avg - test_pred_df.stack()) ** 2).mean() ** .5

#Summary
dict = [(trainRMSE, trainPredRMSE, (1-trainPredRMSE/trainRMSE)*100),
        (testRMSE, testPredRMSE, (1-testPredRMSE/testRMSE)*100)]
summary = pd.DataFrame(dict, 
    columns = ["Raw Average RMSE", "Simple Predictor RMSE", "Percent Improvement"], 
    index = ['train', 'test'])
summary
