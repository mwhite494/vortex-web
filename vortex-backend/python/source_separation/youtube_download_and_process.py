import os
import sys
from pytube import YouTube
from moviepy.editor import *

def download_and_convert_to_wav(youtube_url, output_filename):
    # Download video from YouTube
    video = YouTube(youtube_url)
    stream = video.streams.get_audio_only()
    audio_file = stream.download()

    # Convert the downloaded file to WAV format
    clip = AudioFileClip(audio_file)
    clip.write_audiofile(f"{output_filename}.wav")

    # Clean up the original download (optional)
    clip.close()
    os.remove(audio_file)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py <YouTube URL> <output filename (without extension)>")
        sys.exit(1)
    
    youtube_url = sys.argv[1]
    output_filename = sys.argv[2]
    
    download_and_convert_to_wav(youtube_url, output_filename)
