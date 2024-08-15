# json
import json, re, os, glob, librosa
from json import JSONEncoder
import soundfile as sf
import numpy as np
from json import JSONEncoder
from pydub import AudioSegment, effects
from pydub.silence import split_on_silence


#json encoder class
class NumpyArrayEncoder(JSONEncoder):
    def default(self, obj):
        if isinstance(obj, np.ndarray):
            return obj.tolist()
        return JSONEncoder.default(self, obj)


def createFolder(directory):
    try:
        if not os.path.exists(directory):
            os.makedirs(directory)
    except OSError:
        print('Error: Creating directory. ' + directory)


def setPath(folder_path, extension):
    file_paths = glob.glob(os.path.join(folder_path, '*' + extension))
    for file_path in file_paths:
        print(file_path) 
        # file_paths[file_path] = file_path - folder_path
    return file_paths


def split_sentences(text):
    # 문장 부호 기준으로 문장을 나누는 함수
    # 여기서는 물음표와 마침표를 기준으로 사용
    sentence_delimiters = ['?', '.']
    sentences = []
    current_sentence = ""

    for char in text:
        current_sentence += char
        if char in sentence_delimiters:
            sentences.append(current_sentence.strip())
            current_sentence = ""

    if current_sentence:
        sentences.append(current_sentence.strip())

    return sentences


#load json file with path  
def loadJson(Originame):
    with open(Originame, "r", encoding = "utf-8") as file:
        data = json.load(file)
        
    text = data["Transcript"]
    print(text)
    desease = data["Disease_info"]["Type"]
    origin = data["File_id"]
    Patient_info = data["Patient_info"]
    sentences = split_sentences(text)
    l = len(sentences)
    print("json loaded")
    return desease, origin, sentences, Patient_info, l


#save json with data
def SaveJson(id, desease, Originame, sentence, Patient_info, jsonpath, sampling_rate=16000): 
    createFolder(jsonpath) 
    jsonname = jsonpath + str(id) + '.json'    
    # 저장할 데이터 (리스트)
    data = {
        "sentence": sentence,
        "audio": {
            "Disease_Type": desease,
            "origin" : Originame,
            "path": str(id) + ".wav",
            "sampling_rate": 16000,
            "Patient_info": Patient_info
            }
    }    
    with open(jsonname, "w", encoding = "utf-8") as file:
        json.dump(data, file, cls=NumpyArrayEncoder, ensure_ascii = False)
    print(f"Json saved. path: {jsonpath}, id: {id}")


#save audio data #librosa
def SaveWav(result_wav, id, wavpath, sr=16000):
    wavname = wavpath + str(id) + '.wav'
    sf.write(wavname, result_wav, sr, format='WAV', endian='LITTLE', subtype='PCM_16')
    print(f"wav saved path: {wavpath}")


#save audio data #AudioSegment
def SaveSound(chunk, output_folder, file_name):
    createFolder(output_folder) 
    if len(chunk) > 15000:
        chunk = chunk[:15000]
    output_file = os.path.join(output_folder, file_name)
    chunk.export(output_file, format='wav')
    print(f"wav saved path: {output_folder + file_name}")


# audio normalization, get sound data with AdioSegment and return librosa
def normalization(path):
    rawsound = AudioSegment.from_file(path, "wav") #get data wuth audiosegment
    normalizedsound = effects.normalize(rawsound)
    normalizedsound.export("./output.wav", format="wav")
    normalizedsound, _ = librosa.load("./output.wav")
    return _, normalizedsound #return data to numpy array


#audio downsampling #librosa
def down_sample(input_wav, origin_sr, resample_sr):
    resample = librosa.resample(input_wav, orig_sr=origin_sr, target_sr=resample_sr, fix=True, scale=False)
    y_trimmed, index = librosa.effects.trim(resample, top_db=30)
    # 파일 전후의 무음 데이터 날리기
    print("original wav sr: {}, original wav shape: {}, resample wav sr: {}, resample shape: {}".format(origin_sr, y_trimmed.shape, resample_sr, y_trimmed.shape))
    # 다운샘플링된 음성 데이터의 정보를 출력
    print("down_sample finished", y_trimmed)
    return y_trimmed