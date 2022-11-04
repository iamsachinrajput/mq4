import pandas as pd
import numpy
import matplotlib.pyplot as plt
import pandas
import math
from keras.models import Sequential
from keras.layers import Dense
from keras.layers import LSTM
from keras.layers.core import Dropout
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import mean_squared_error
from sklearn.metrics import mean_absolute_error
numpy.random.seed(7)

data = pd.read_csv("https://raw.githubusercontent.com/iamsachinrajput/roboafl/master/zreports/ML_train_2may19_dhfl.csv")
# print(data.head(), data.columns)
# data = data[:100]
data = data.fillna(0)
# features = ['thisbarOpenPrice', 'thisbarClosePrice', '2minpricechangeinlast2', #, '1minpricechangeinlast1'
#        '5minpricechangeinlast5', '10minpricechangeinlast10',
#        '20minpricechangeinlast20', '30minpricechangeinlast30',
#        '60minpricechangeinlast60', '120minpricechangeinlast120','Volume',
#        '1minvolumechangedinlast1', '2minvolumechangedinlast2',
#        '5minvolumechangedinlast5', '10minvolumechangedinlast10',
#        '20minvolumechangedinlast20', '30minvolumechangedinlast30',
#        '60minvolumechangedinlast60', '120minvolumechangedinlast120']
data['nextmincvol'] = data['Volume'].shift(1)
data['next2mincvol'] = data['Volume'].shift(2)
features = ['thisbarOpenPrice', 'thisbarClosePrice', 'Volume', 'next2mincvol', 'nextmincvol']

data = data[features]
data['prevminclose'] = data['thisbarClosePrice'].shift(1)
data = data.fillna(0)
dataset = data[features]
dataset_test = data['prevminclose']
print(data.head())
# print(dataset.head())
train_size = int(len(dataset) * 0.70)
test_size = len(dataset) - train_size
trainX, testX = dataset.iloc[0:train_size,:], dataset.iloc[train_size:len(dataset),:]
print(dataset.shape, dataset_test.shape)
trainY, testY= dataset_test.iloc[0:train_size], dataset_test.iloc[train_size:len(dataset_test)]
print(len(trainX), len(testX))
# trainX = numpy.reshape(train.values, (train.shape[0], 1, train.shape[1]))
# testX = nu

trainX = numpy.reshape(trainX.values, (trainX.shape[0], 1, trainX.shape[1]))
#

model = Sequential()
model.add(LSTM(128, input_shape=(1, len(features))))
model.add(Dropout(0.2))
model.add(Dense(1))
model.compile(loss='mean_absolute_error', optimizer='adam')
print(trainX.shape, trainY.shape)
model.fit(trainX, trainY, epochs=50, batch_size=64, verbose=2)
# testY,  = trainY.values, testY.values
trainY = numpy.reshape(trainY.values, (trainY.shape[0], 1, 1))
testX = numpy.reshape(testX.values, (testX.shape[0], 1, testX.shape[1]))
testY = numpy.reshape(testY.values, (testY.shape[0], 1,1))
print(testX.shape, testY.shape)
# trainPredict = model.predict(testX)
testPredict = model.predict(testX)
# invert predictions
# print(testY)
# print(testPredict)
# trainPredict = scaler.inverse_transform(trainPredict)
# trainY = scaler.inverse_transform([trainY])
# testPredict = scaler.inverse_transform(testPredict)
# testY = scaler.inverse_transform([testY])
# calculate root mean squared error
# trainScore = math.sqrt(mean_squared_error(trainY[0], trainPredict[:,0]))
# print('Train Score: %.2f RMSE' % (trainScore))

testy = [i[0][0]for i in testY]
preds = [i[0] for i in testPredict]
print(testy)
print(preds)
print(len(testPredict))
testScore = mean_absolute_error(testy, preds)
print('Test Score: %.2f RMSE' % (testScore))
# look_back = 1
# trainPredictPlot = numpy.empty_like(dataset)
# trainPredictPlot[:, :] = numpy.nan
# trainPredictPlot[look_back:len(trainPredict)+look_back, :] = trainPredict
# # shift test predictions for plotting
# testPredictPlot = numpy.empty_like(dataset)
# testPredictPlot[:, :] = numpy.nan
# testPredictPlot[len(trainPredict)+(look_back*2)+1:len(dataset)-1, :] = testPredict
# # plot baseline and predictions
# plt.plot(dataset)
# plt.plot(trainPredictPlot)
# plt.plot(testPredictPlot)
# plt.show()