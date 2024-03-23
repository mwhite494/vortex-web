import sys
import numpy as np
from scipy.io import wavfile
from scipy.signal import butter, lfilter

def butter_bandpass(lowcut, highcut, fs, order=5):
    nyq = 0.5 * fs
    low = lowcut / nyq
    high = highcut / nyq
    b, a = butter(order, [low, high], btype='band')
    return b, a

def butter_bandpass_filter(data, lowcut, highcut, fs, order=5):
    b, a = butter_bandpass(lowcut, highcut, fs, order=order)
    y = lfilter(b, a, data)
    return y

def compute_band_magnitudes(audio_file):
    fs, data = wavfile.read(audio_file)
    data = data.astype(np.float32)

    if len(data.shape) > 1 and data.shape[1] > 1:
        data = np.mean(data, axis=1)  # Convert stereo to mono by averaging channels

    # Define frequency bands
    bands = [
        (20, 60),
        (60, 250),
        (250, 500),
        (500, 2000),
        (2000, 4000),
        (4000, 6000),
        (6000, 20000),
    ]

    band_magnitudes = []

    for lowcut, highcut in bands:
        filtered_data = butter_bandpass_filter(data, lowcut, highcut, fs)
        magnitude = np.sqrt(np.mean(np.square(filtered_data)))
        band_magnitudes.append(magnitude)

    return band_magnitudes

def main():
    if len(sys.argv) < 2:
        print("Usage: python audio_visualizer.py <audio_file>")
        sys.exit(1)

    audio_file = sys.argv[1]
    band_magnitudes = compute_band_magnitudes(audio_file)
    print("Band magnitudes:", band_magnitudes)

if __name__ == "__main__":
    main()
