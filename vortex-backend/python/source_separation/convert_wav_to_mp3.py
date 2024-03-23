import argparse
from pydub import AudioSegment
import os

def convert_wav_to_mp3(wav_path, mp3_path):
    # Load the audio file
    audio = AudioSegment.from_wav(wav_path)

    # Create the directory if it doesn't exist
    os.makedirs(os.path.dirname(mp3_path), exist_ok=True)

    # Export the audio file in MP3 format
    audio.export(mp3_path, format="mp3")

if __name__ == "__main__":
    # Set up command line argument parser
    parser = argparse.ArgumentParser(description="Convert a WAV file to an MP3 file.")
    parser.add_argument("wav_file", help="Path to the WAV file.")
    parser.add_argument("mp3_file", help="Path to save the resulting MP3 file.")

    # Parse the command line arguments
    args = parser.parse_args()

    # Convert the WAV file to an MP3 file
    convert_wav_to_mp3(args.wav_file, args.mp3_file)
