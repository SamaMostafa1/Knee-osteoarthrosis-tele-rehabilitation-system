import numpy as np
from scipy.signal import find_peaks
class gaitFeatures:
    def functionswingtime(idxTOleft, idxHSleft, sample_frequency, time):
        swing_time_diff = np.array([])  
            
        for i in range(len(idxHSleft)):
            lastTO = np.argwhere(idxTOleft < idxHSleft[i])
            if len(lastTO) > 0:
                lastTO = lastTO[-1][0]
                swing_time = idxHSleft[i] - idxTOleft[lastTO]
                swing_time_diff = np.append(swing_time_diff, time[idxHSleft[i]] - time[idxTOleft[lastTO]])
            
        return  swing_time_diff

    def functionstancetime(idxTOleft, idxHSleft, sample_frequency, time):
        stance_time_diff = np.array([])  
        for i in range(len(idxTOleft)):
            lastHS = np.argwhere(idxHSleft < idxTOleft[i])
            if len(lastHS) > 0:
                lastHS = lastHS[-1][0]
                stance_time_diff = np.append(stance_time_diff, (time[idxTOleft[i]] - time[idxHSleft[lastHS]]))  
        return  stance_time_diff

    def functionstridetime(idxHSleft, sample_frequency, time):
        stride_time_diff = np.array([])
        for i in range(len(idxHSleft) - 1):  
            stride_time_diff = np.append(stride_time_diff, time[idxHSleft[i + 1]] - time[idxHSleft[i]])
        return stride_time_diff 
    def Strike_toe_Angles(data, idxHS,idxTO):
        hs_angles = []
        to_angles =[]
        for hs_idx, to_idx in zip(idxHS, idxTO):
            hs_angles.append(data[hs_idx])
            to_angles.append(data[to_idx])
        return hs_angles,to_angles

    def MaxAngle(data,idxTO,idxHS):
        max_swing_angles=[]
        max_stance_angles=[]
        for i in range(len(idxTO) ):
            start_sw = idxTO[i]
            end_sw = idxHS[i + 1]
            start_st = idxHS[i]
            end_st = idxTO[i]
            segment_swing=data.iloc[start_sw:end_sw]
            segment_stance=data.iloc[ start_st:end_st]
            max_swing=np.max(segment_swing)
            max_swing_angles.append(max_swing)
            max_stance=np.max(segment_stance)
            max_stance_angles.append(max_stance)
        return  max_stance_angles,max_swing_angles
################################################ peak to peak acc Calculation ##################################################
    def accPeaks(fcacc, time,idxHS):
    # Initialize lists for first higher and lower peaks between heel strikes
        first_higher_peaks_times = []
        first_higher_peaks_values = []
        first_lower_peaks_times = []
        first_lower_peaks_values = []

        # Loop through each pair of consecutive heel strikes
        for i in range(len(idxHS) - 1):
            start_idx = idxHS[i]
            end_idx = idxHS[i + 1]

            # Extract the segment of the signal between heel strikes
            segment = fcacc[start_idx:end_idx]
            segment_time = time.iloc[start_idx:end_idx]

    #         Detect all higher peaks (local maxima)
            higher_peaks = find_peaks(segment, prominence=2)[0]
            # Detect all lower peaks (local minima) by inverting the signal
            lower_peaks = find_peaks(-segment, prominence=2)[0]

    #         # Check if higher_peaks and lower_peaks are not empty
            if higher_peaks.size > 0 and lower_peaks.size > 0:
                if segment[higher_peaks[0]] >segment[lower_peaks[0]]:
                    first_idx = higher_peaks[0]
                    next_peak_indices = lower_peaks[lower_peaks > first_idx]
                    if next_peak_indices.size > 0:
                        first_higher_peaks_values.append(segment[first_idx])
                        first_lower_peaks_values.append(segment[next_peak_indices[0]])
                else:
                    first_idx = lower_peaks[0]
                    next_peak_indices = higher_peaks[higher_peaks > first_idx]
                    if next_peak_indices.size > 0:
                        first_higher_peaks_values.append(segment[next_peak_indices[0]])
                        first_lower_peaks_values.append(segment[first_idx])
        return  first_lower_peaks_values, first_higher_peaks_values

    def ThrustAcc(first_higher_peaks_values,first_lower_peaks_values):
        thurstAccelerations=[]
        for i in range(len(first_higher_peaks_values)):
            thrust_Acc=first_higher_peaks_values[i]-first_lower_peaks_values[i]
            thurstAccelerations.append(  thrust_Acc)
        return thurstAccelerations
########################################Frequency#####################################
