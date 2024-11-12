import random
import numpy as np
import pandas as pd
from keras.models import Sequential, load_model
from keras.layers import LSTM, Dense
from keras.losses import MeanSquaredError
#import tensorflow as tf

MSE = MeanSquaredError()

#*****************************************************************************************
#*****************************************************************************************
#*****************************************************************************************
#*****************************************************************************************
class tsf():
	def __init__(self):
		#self.optimizer = 'rmsprop'
		self.input_size = 1000
		pass
	#*****************************************************************************************
	#*****************************************************************************************
	def batch_generator(self,list_files,batch_size): #,input_paths, batch_size, istraining):
		while True:
			x1, x2, y = self.data_preprocess(list_files)
			# Division de la serie
			S_train,Y_train = self.get_tensors(x1,x2,y,self.input_size,batch_size)		
			#print(S_train.shape)
			yield S_train, Y_train
	#*****************************************************************************************
	#*****************************************************************************************
	def data_preprocess(self,list_files):
			# Obtencion de la serie en cada iteracion
			random_index = random.randint(0, len(list_files) - 1)
			serie = list_files[random_index]
			x1 = pd.read_csv(serie, header=None, usecols=[0])	# Tau_z
			x2 = pd.read_csv(serie, header=None, usecols=[1])	# rho_ref
			y = pd.read_csv(serie, header=None, usecols=[2])		# delta_w
			# sub_muestreo
			#x1,x2,y = self.sub_sample(x1.to_numpy(),x2.to_numpy(),y.to_numpy())
			# Normalizacion
			x1 = (1.0/16302.0)*x1
			x2 = (1.0/159.9545)*x2
			y = (1.0/7.8365)*y
			return x1.to_numpy(), x2.to_numpy(), y.to_numpy()
	#*****************************************************************************************
	#*****************************************************************************************
	def sub_sample(self,x1,x2,y):
		# h = 0.001 [s]
		# h_sub = 0.002 [s]
		X1 = []
		X2 = []
		Y = []
		l = 1
		for i,j,k in zip(x1,x2,y):
			if l == 0:
				X1.append(i)
				X2.append(j)
				Y.append(k)
			if l == 1: l = 0
			l = l+1
		return np.array(X1), np.array(X2), np.array(Y)
	#*****************************************************************************************
	#*****************************************************************************************
	def get_tensors(self,x1,x2,y,input_size,batch_size):
		N,_ = np.shape(x1)
		#step = int(round(N/batch_size))
		S_train = []
		Y_train = []
		#for k in range(input_size,N,step):
		index = np.random.randint(input_size,N,(batch_size))
		for k in index: 
			s1 = x1[k-input_size:k]
			s2 = x2[k-input_size:k]
			s3 = y[k-input_size:k]
			#print(type(y))
			delta_w = y[k]

			s1 = np.reshape(s1,(-1,1))
			s2 = np.reshape(s2,(-1,1))
			s3 = np.reshape(s3,(-1,1))			
			s = np.concatenate((s1,s2),axis=1)
			s = np.concatenate((s,s3),axis=1)
		
			S_train.append(s) 
			Y_train.append(delta_w)	
		return np.array(S_train), np.array(Y_train)
	#*****************************************************************************************
	#*****************************************************************************************
	def lstm_nn(self,dim_entrada,dim_salida,na):
		modelo = Sequential()
		modelo.add(LSTM(units=na, input_shape=dim_entrada))
		modelo.add(Dense(units=dim_salida))
		modelo.compile(optimizer='adam', loss=MSE)
		modelo.summary()
		return modelo	
	#*****************************************************************************************
	#*****************************************************************************************
	def test_data(self,list_files,input_size):
		x1, x2, y = self.data_preprocess(list_files)	
		N = x1.shape[0]
		S_val = []
		Y_val = []
		for k in range(input_size,N):
			s1 = x1[k-input_size:k,0]
			s2 = x2[k-input_size:k,0]
			s3 = y[k-input_size:k,0]
			tau = y[k]				
			
			s1 = np.reshape(s1,(-1,1))
			s2 = np.reshape(s2,(-1,1))
			s3 = np.reshape(s3,(-1,1))			
			s = np.concatenate((s1,s2),axis=1)
			s = np.concatenate((s,s3),axis=1)
			
			S_val.append(s) 
			Y_val.append(tau)	
		return np.array(S_val), np.array(Y_val)






