import sys
from pydub import AudioSegment

def extract_audio_from_mp4(mp4_file_path, output_wav_file_path):
    audio_segment = AudioSegment.from_file(mp4_file_path, format="mp4")
    audio_segment.export(output_wav_file_path, format="wav")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <input_mp4_file_path> <output_wav_file_path>")
        sys.exit(1)

    mp4_file_path = sys.argv[1]
    output_wav_file_path = sys.argv[2]
    extract_audio_from_mp4(mp4_file_path, output_wav_file_path)
