############################### Imports ########################################
import pandas as pd
from scipy.signal import find_peaks
from scipy import signal
import numpy as np
class PreProcessing:
    def read_csv_file(self,file_path):
        try:
            return pd.read_csv(file_path, encoding='utf-8')
        except UnicodeDecodeError:
            return pd.read_csv(file_path, encoding='latin1')

    def handleNan(self,trail_df):
        trail_df = trail_df.dropna()
        trail_df = trail_df.reset_index(drop=True)
        return trail_df
    ################################### find peaks of all data ###################################
    def FirstLastIndxs(self,df_column):
        peaks_min, _ = find_peaks(-df_column, prominence=3)  # Find local minima
        if len(peaks_min) == 0:
            # Return a default value or raise an exception if no peaks are found
            first_peak_min_index = last_peak_min_index = 0
        elif len(peaks_min) >= 2:
            first_peak_min_index = peaks_min[0]
            last_peak_min_index = peaks_min[-1]
        else:
            first_peak_min_index = last_peak_min_index = peaks_min[0]
        # Ensure first_peak_min_index is before last_peak_min_index
        if first_peak_min_index > last_peak_min_index:
            first_peak_min_index, last_peak_min_index = last_peak_min_index, first_peak_min_index
        return first_peak_min_index, last_peak_min_index
   
 ################################### filter data ###################################
    def Filter(self,cutoffFrequency,samplingFrequency,data,filterType,filterOrder):
        NormalizedFrequency = cutoffFrequency / (samplingFrequency / 2)
        b, a = signal.butter(filterOrder,NormalizedFrequency, filterType)       
        filteredData = signal.filtfilt(b,a, data)
        return filteredData
    ################################### Stance and swing time differences ###################################
    def SwingStanceStrideTimeDiffMaxMin(self,swing_time_diff, stance_time_diff, stride_time_diff,idxHS):
        gait_features = []
       
     
        swing_time_max ,swing_time_min = self.calcMax_Min(swing_time_diff)
        gait_features.append(swing_time_max)
        gait_features.append(swing_time_min)
        
        stance_time_max,stance_time_min = self.calcMax_Min(stance_time_diff)
        gait_features.append(stance_time_max)
        gait_features.append(stance_time_min)
        
        stride_time_max,stride_time_min = self.calcMax_Min(stride_time_diff)
        gait_features.append(stride_time_max)
        gait_features.append(stride_time_min)
        return  gait_features
     ################################### calculate maximum and minimum in data of all cycles ###################################
    def calcMax_Min(self,data):
        data_max = np.max(data) if len(data) > 0 else 0
        data_min = np.min(data) if len(data) > 0 else 0
        return data_max,data_min