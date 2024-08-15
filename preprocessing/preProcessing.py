# 기존사용하던 모듈
from util import SaveJson, setPath, loadJson, SaveSound # get method from util.py
# pydub라이브러리 모듈
from pydub import AudioSegment, effects
from pydub.silence import split_on_silence

# data folder path
wav_path = 'D:/src/sktflyai/project/pre-processing/New_Sample/원천데이터/TS01_뇌신경장애/25.언어+뇌신경장애(1)/'
json_path = 'D:/src/sktflyai/project/pre-processing/New_Sample/라벨링데이터/TL01_뇌신경장애/25.언어+뇌신경장애/'
# pre-processed data path, 
# data saved in 'original_wav_folder/wav/' 'original_json_folder/json/'
output_folder_json = json_path + 'json/'
output_folder_wav = wav_path + 'wav/'


def main():
    i = 0 #json file list number
    id = 0 #pre-processed file number(id)
    # get data list from folder
    wav_file_list = setPath(wav_path, '.wav')
    json_file_list = setPath(json_path, '.json')

    for input_file in wav_file_list:
        sound = AudioSegment.from_file(input_file)
        sound = sound.set_frame_rate(16000).set_channels(1).set_sample_width(2)
        sound = effects.normalize(sound)#정규화
        audio_chunks = split_on_silence(sound,
            min_silence_len=4000, # least silence time(ms)
            silence_thresh=-35, # silence threshold
            keep_silence=500
        )
        # load json file from folder
        desease, Originame, sentence, Patient_info, l = loadJson(json_file_list[i])
        print(l)
        count = 0
        ##save pre-processed data
        for j, chunk in enumerate(audio_chunks):
            SaveSound(chunk, output_folder_wav, str(id))
            SaveJson(id, desease, Originame, sentence[count], Patient_info, output_folder_json)
            count = count + 1
            if l+1 < count:
                print(f"Json data doesn't match with audio data.{Originame}")
                break
            elif l+1 == count:
                print(f"Json data matched with audio data.{Originame}")
            id = id + 1
        i = i + 1

if __name__ == "__main__":
    main()