from scipy.signal import find_peaks
from scipy import signal
import numpy as np
class gaitEvent:
    def MidStance(gyroData,distance,height,samplingFrequency):
        #find indeces of Mid stance in gyro data 
        idxOnsMS =(signal.find_peaks (gyroData, distance = distance*samplingFrequency, prominence=1, height=height))[0]
        return idxOnsMS
    def heelStrike(idxOnsMSw,fGyro):
        idxHS = np.asarray([], dtype=int)
        for i in range(0, len(idxOnsMSw)):
            try:
                firstnegative = idxOnsMSw[i] + np.argwhere(fGyro[idxOnsMSw[i]:] < 0)[0]
            except IndexError:
                firstnegative = idxOnsMSw[i] + np.argmin(fGyro[idxOnsMSw[i]:])
            lastpositive = firstnegative-1
            if np.abs(fGyro[lastpositive]) < np.abs(fGyro[firstnegative]):
                lastzerocrossing = lastpositive
            else:
                lastzerocrossing = firstnegative
            idxHS = np.append(idxHS, lastzerocrossing)
        return idxHS
    def toeOff(idxOnsMSw,fACCz,fGYRo,samplingFrequency):
        idxTO=np.asarray([], dtype=int)
        for i in range(1,len(idxOnsMSw)):
            startwindow = np.asarray(idxOnsMSw[i-1] + ((idxOnsMSw[i]-idxOnsMSw[i-1])/3.5), dtype=int)
            window = range(startwindow, idxOnsMSw[i]-int(0.05*samplingFrequency))
            idxT2temp = signal.find_peaks((fACCz)[window])[0] #accelerometerdataLeft[:,2], height=0.3*np.max(fACCzL)
            if len(idxT2temp) > 0:
                mingyr = np.argmin(fGYRo[startwindow + idxT2temp])
                idxT2temp2 = idxT2temp[mingyr]
                idxTO = np.append(idxTO, (startwindow + idxT2temp2))
        return idxTO
