# from mallang_xtts import *

import torch
import torchaudio
import librosa
import numpy as np

audio_path = './wavs/ldh1.wav'

data, sr = librosa.load(audio_path, sr=24000)

print(data, sr)

def adding_white_noise(data, sr=24000, noise_rate=0.5):
    wn = np.random.randn(len(data))
    data_wn = data + noise_rate*wn
    # save as wav file
    torchaudio.save("./wavs/white_noise.wav", torch.tensor(data_wn).unsqueeze(0), 24000)
    return data

def shifting_sound(data, sr=22050, roll_rate=0.1):
    data_roll = np.roll(data, int(len(data) * roll_rate))
    torchaudio.save("./wavs/shifting.wav", torch.tensor(data_roll).unsqueeze(0), 24000)
    
    return data

def merge_audio(org=audio_path,audio1="./wavs/shifting.wav", audio2="./wavs/white_noise.wav", sr=24000):
    data, sr = librosa.load(org, sr=sr)
    data1, sr = librosa.load(audio1, sr=sr)
    data2, sr = librosa.load(audio2, sr=sr)
    data_merge = np.concatenate((data, data1, data2))
    torchaudio.save("./wavs/merge.wav", torch.tensor(data_merge).unsqueeze(0), sr)
    return data_merge

adding_white_noise(data, sr, noise_rate=0.01)
shifting_sound(data, sr, roll_rate=0.3)
merge_audio()