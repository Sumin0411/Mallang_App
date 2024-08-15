from TTS.tts.datasets import load_tts_samples
import os
import json
import glob
from tqdm import tqdm

def formatter(root_path): 
    """Assumes each line as ```<filename>|<transcription>```
    """
    json_files = glob.glob(os.path.join(root_path, "*.json"))
    items = []
    speaker_name = "my_speaker"
    for json_file in tqdm(json_files):
        with open(json_file, "r", encoding="utf-8") as ttf:
            data = json.load(ttf)
            for file in data[0]["sentences"]:
                file_name = file["id"]
                wav_file = os.path.join(file_name + ".wav")
                text = file['voice_piece']['tr']
                items.append({"text":text, "audio_file":wav_file, "speaker_name":speaker_name, "root_path": root_path})
    return items

def make_metadata(root_path, save_path):
    items = formatter(root_path)
    with open(save_path, "w", encoding="utf-8") as f:
        for item in items:
            f.write("wavs/" + item["audio_file"] + "|" + item["text"] + "|" + item["speaker_name"] + "\n")
    print(f"Saved to {save_path}")

def make_test_metadata(root_path, save_path):
    # make test metadata with 0.2 ratio
    items = formatter(root_path)
    with open(save_path, "w", encoding="utf-8") as f:
        for item in items[:630]:
            f.write("wavs/" + item["audio_file"] + "|" + item["text"] + "|" + item["speaker_name"] + "\n")
    print(f"Saved to {save_path}")
    
make_metadata("C:\\lee\\133.감성 및 발화 스타일 동시 고려 음성합성 데이터\\01-1.정식개방데이터\\Validation\\02.라벨링데이터", "C:\\lee\\133.감성 및 발화 스타일 동시 고려 음성합성 데이터\\01-1.정식개방데이터\\Validation\\metadata_train.txt")
make_test_metadata("C:\\lee\\133.감성 및 발화 스타일 동시 고려 음성합성 데이터\\01-1.정식개방데이터\\Validation\\02.라벨링데이터", "C:\\lee\\133.감성 및 발화 스타일 동시 고려 음성합성 데이터\\01-1.정식개방데이터\\Validation\\metadata_test.txt")