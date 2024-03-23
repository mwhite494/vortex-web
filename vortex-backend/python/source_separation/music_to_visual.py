import requests
import numpy as np
import librosa
import os
import pytube
from moviepy.video.io.VideoFileClip import VideoFileClip

def get_visualization_data(audio_file_path):
    # Load audio file
    audio_data, sr = librosa.load(audio_file_path, sr=44100, mono=True)

    # Submit audio data to Open-Unmix API
    payload = {
        'file': ('audio.wav', audio_data.tobytes(), 'audio/wav'),
        'parameters': ('', '{"separator": "spleeter"}')
    }
    response = requests.post('https://www.aicrowd.com/evaluations/generate_mask', files=payload)

    # Parse response
    mask_data = np.frombuffer(response.content, dtype=np.float32)
    mask_data = np.reshape(mask_data, (5, len(audio_data)))

    # Construct custom data object
    visualization_data = {}
    for i, instrument_name in enumerate(['drums', 'bass', 'vocals', 'other', 'piano']):
        instrument_mask = mask_data[i]
        instrument_audio = audio_data * instrument_mask
        instrument_led_colors = []
        for j in range(len(instrument_audio)):
            if instrument_mask[j] > 0.1:
                # Set LED color based on amplitude of instrument audio
                led_color = [int(val*255) for val in np.abs(instrument_audio[j]) * 60]
                instrument_led_colors.append(led_color)
            else:
                # Set LED color to off
                instrument_led_colors.append([0, 0, 0])
        visualization_data[instrument_name] = instrument_led_colors

    return visualization_data
