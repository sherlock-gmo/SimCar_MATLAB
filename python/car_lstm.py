import os
import numpy as np
import matplotlib.pyplot as plt
from keras.models import load_model, save_model
import tensorflow as tf
import tf2onnx

from lib_lstm import tsf
TSF = tsf()

print('**********************************************************************************')
print('**********************************************************************************')
print('**********************************************************************************')
#---------------------------------------------------------Obtencion de datos
path = '/home/fresbrinda/Mis_Documentos/MATLAB/Car_14DOF_Lat_Long_control/python/train'
files = os.listdir(path)
j = 0
for i in files:
	i = path+'/'+i
	files[j] = i
	j = j+1
print('Numero de series de tiempo',len(files))

# Red LSTM
E = 75						# Numero de epocas
BZ = 1024					# Tamano del lote
SPE = 15000//BZ		# Pasos por epoca
N = 100 					# Numero de neuronas de la red LSTM
M = 1000 #TSF.input_size				# Numero de datos en la serie de entrada
dim_salida = 1
dim_entrada = (M,3)
TSF.input_size = M


path_model_f = '/home/fresbrinda/Mis_Documentos/MATLAB/Car_14DOF_Lat_Long_control/python/'
modelo = TSF.lstm_nn(dim_entrada,dim_salida,N)
modelo.fit(TSF.batch_generator(files,BZ), steps_per_epoch=SPE, epochs=E)
modelo.save('LSTM_network_k3.6.0_trained.h5')
modelo.save_weights('LSTM_network_k3.6.0_trained.weights.h5')

#m = load_model('LSTM_network.h5')		
#fpath = '/home/fresbrinda/Mis_Documentos/MATLAB/Car_14DOF_Lat_Long_control/python/'+Kver
#tf.saved_model.save(modelo,filepath)
modelo.export(path_model_f+'LSTM_network_k3.6.0_F_trained')




S_val, Y_val = TSF.test_data(files,M)
Y_pred = m.predict(S_val)

plt.plot(Y_val,'r')
plt.plot(Y_pred,'b')
plt.legend(['Y_val','Y_pred'])
plt.show()



