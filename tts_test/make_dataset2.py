from TTS.tts.datasets import load_tts_samples
import os
import json
import glob
from tqdm import tqdm

def formatter(root_path): 
    """Assumes each line as ```<filename>|<transcription>```
    """
    #load one json file
    json_files = glob.glob(os.path.join(root_path, "*.json"))
    items = []
    speaker_name = "my_speaker"
    for json_file in tqdm(json_files):
        with open(json_file, "r", encoding="utf-8") as ttf:
            data = json.load(ttf)
            for files in tqdm(data):
                for file in files["sentences"]:
                    file_name = os.path.basename(file["voice_piece"]["filename"])
                    wav_file = os.path.join(file_name)
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
        for item in items:
            f.write("wavs/" + item["audio_file"] + "|" + item["text"] + "|" + item["speaker_name"] + "\n")
    print(f"Saved to {save_path}")
    
make_metadata("C:\\lee\\158.문학작품 낭송, 낭독 음성 데이터(시, 소설, 희곡, 시나리오)\\01.데이터\\1.Training\\라벨링데이터\\", "C:\\lee\\158.문학작품 낭송, 낭독 음성 데이터(시, 소설, 희곡, 시나리오)\\01.데이터\\1.Training\\metadata_train.txt")
make_test_metadata("C:\\lee\\158.문학작품 낭송, 낭독 음성 데이터(시, 소설, 희곡, 시나리오)\\01.데이터\\2.Validation\\라벨링데이터\\", "C:\\lee\\158.문학작품 낭송, 낭독 음성 데이터(시, 소설, 희곡, 시나리오)\\01.데이터\\2.Validation\\metadata_test.txt")