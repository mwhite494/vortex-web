import sys
import os
import torch
import soundfile as sf
import openunmix

def separate_audio_sources(input_file_path):
    # Load the Open Unmix pre-trained model for electronic music
    separator = openunmix.umxhq()

    # Load the audio file
    audio, rate = sf.read(input_file_path, always_2d=True)

    # Perform the source separation
    estimates = separator(audio=audio, rate=rate)

    # Save each separated source as a new audio file
    input_file_basename = os.path.splitext(os.path.basename(input_file_path))[0]
    output_dir = os.path.join(os.path.dirname(input_file_path), input_file_basename + "_separated")
    os.makedirs(output_dir, exist_ok=True)

    for source_name, source_audio in estimates.items():
        output_file_path = os.path.join(output_dir, f"{input_file_basename}_{source_name}.wav")
        sf.write(output_file_path, source_audio, rate)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <input_audio_file_path>")
        sys.exit(1)

    input_file_path = sys.argv[1]
    separate_audio_sources(input_file_path)
