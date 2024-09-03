import numpy as np
from scipy.signal import find_peaks
from scipy.fft import fft, ifft, fftfreq
import statistics as st
import warnings
class frequencyDomain:

    def Sampling_freq (self,time):
        time_interval=np.diff(time)
        time_interval = np.mean(time_interval)
        Fs = 1 / time_interval 
        return Fs


    # Finding fundamental frequency from power spectrum
    def calculate_stride_frequency(self,time, signal,Fs):
        signal = np.asarray(signal)
        freqs = fftfreq(len(time), d=1/Fs)
        spectrum = np.abs(fft(signal))
        peaks, _ = find_peaks(spectrum[:len(spectrum)//2], prominence=0.1)
        fundamental_freq = freqs[peaks[0]] if len(peaks) > 0 else 0
        return fundamental_freq

    def calculate_number_of_cycles(self,time, total_distance):
        time = np.asarray(time)
        total_duration = time[-1] - time[0]
        average_speed = total_distance / total_duration
        estimated_cycle_duration = 1 / average_speed
        num_cycles = total_duration / estimated_cycle_duration
        return num_cycles


    def calculate_average_waveform(self,signal, num_cycles):
        num_cycles = int(num_cycles)
        signal = np.asarray(signal)
        total_samples = len(signal)
        cycle_length = total_samples // num_cycles
        averaged_cycle = np.zeros(cycle_length)

        # Calculate the middle index to ensure we're averaging around the center
        middle_index = total_samples // 2

        # Loop to accumulate the segments
        for i in range(num_cycles):
            start_index = middle_index - cycle_length // 2 + i * cycle_length
            end_index = start_index + cycle_length
            
            # Ensure the indices are within bounds
            if start_index < 0:
                start_index = 0
            if end_index > total_samples:
                end_index = total_samples
                start_index = end_index - cycle_length  # Adjust start to keep segment length consistent
            
            # Accumulate the segments
            averaged_cycle += signal[start_index:end_index].astype(np.float64)

        # Average the accumulated segments
        averaged_cycle /= num_cycles
        return averaged_cycle

    def calculate_fourier_representation(self,signal):
        dft_signal = fft(signal)
        power_spectrum = np.abs(dft_signal) ** 2
        return dft_signal, power_spectrum

    def calculate_power_at_specific_frequencies(self,dft_signal, num_frequencies=6):
        power_at_frequencies = np.abs(dft_signal[:num_frequencies]) ** 2
        return power_at_frequencies


    def FrequencyFeaturesArr(self,df, acc_axis_name,Fs,num_cycles):
        avg_waveforms = {}
        omega_features = []
        power_features = []
        # Calculate fundamental frequencies and append to omega_features
        for axis in acc_axis_name:
            fundamental_freq = self.calculate_stride_frequency(df["time"], df[axis], Fs)
            omega_features.append(fundamental_freq)
        # print("Omega features",omega_features)
        for axis in acc_axis_name:
            avg_waveforms[axis] = self.calculate_average_waveform(df[axis], num_cycles)
        # print("Avg waveform", avg_waveforms)
        for axis in acc_axis_name:
            dft, power = self.calculate_fourier_representation(avg_waveforms[axis])
            power_specific = self.calculate_power_at_specific_frequencies(dft, num_frequencies=6)
            power_features.append(power_specific)
        return omega_features, power_features
