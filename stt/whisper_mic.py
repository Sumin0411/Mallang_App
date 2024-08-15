import whisper
import speech_recognition as sr
import torch
import numpy as np
import time
import re

r = sr.Recognizer()
r.energy_threshold = 200
r.pause_threshold = 0.5
r.dynamic_energy_threshold = False
audio_model = whisper.load_model("base").to("cuda")
colors = [
    "\033[38;5;196m", "\033[38;5;202m", "\033[38;5;208m", "\033[38;5;214m", "\033[38;5;220m",
    "\033[38;5;226m", "\033[38;5;190m", "\033[38;5;154m", "\033[38;5;118m", "\033[38;5;82m",
]

def wer(ref, pred):
    ref = re.sub(r"[^ㄱ-ㅣ가-힣\s]", "", ref)
    pred = re.sub(r"[^ㄱ-ㅣ가-힣\s]", "", pred)
    r = ref.split()
    p = pred.split()
    
    error_count = 0
    shift = 0
    output = []
    for i in range(len(p)):
        if shift+i >= len(p)-1:
            break
        if i >= len(r):
            break
        if r[i] != p[i+shift]:
            error_count += 1
            if ref.find(p[i+shift])==-1:
                output.append(p[i+shift])
            if r[i] == p[i+shift+1]:
                shift += 1

            
    return error_count, round((1 - (error_count/len(r)))*100, 1), output

def get_score(audio):

    # load audio and pad/trim it to fit 30 seconds
    audio = whisper.load_audio(audio)
    audio = whisper.pad_or_trim(audio)

    # make log-Mel spectrogram and move to the same device as the model
    mel = whisper.log_mel_spectrogram(audio).to("cuda")
    # # detect the spoken language
    # _, probs = audio_model.detect_language(mel)
    # if f"{max(probs, key=probs.get)}" != "ko":
    #     return 30

    # decode the audio
    options = whisper.DecodingOptions()
    result = whisper.decode(audio_model, mel, options)
    result.token_probs[-1] = result.token_probs[-2]
    count = 0
    print("token_probs: ", len(result.token_probs))
    print(f"{len(result.text)}/{len(result.token_probs)}")
    for i in range(len(result.text)):
        if count>=len(result.token_probs):
            break
        if result.text[i] == " " or result.text[i] == "." or result.text[i] == "?" or result.text[i] == "!"   or result.text[i] == ",":
            print(f"{colors[int(10*result.token_probs[count])]}\033[40m{result.text[i]}", end="")
        else:
            print(f"{colors[int(10*result.token_probs[count])]}\033[40m{result.text[i]}\033[0m", end="")
            count += 1
    print("\033[0m")
    print('prob: ', result.token_probs)

    words = result.text.split()
    word_scores = []
    start = 0
    
    for word in words:
        end = start + len(word)
        word_scores.append(result.token_probs[start:end])
        start = end
    # 평균 점수가 0.5 이하인 단어만 선택
    low_score_words = [{'word': word, 'worst': [char for i, char in enumerate(word) if word_score[i] <= 0.4]} for word, word_score in zip(words, word_scores) if len(word_score) > 0 and sum(word_score)/len(word_score) <= 0.5 and len(word) > 1]

    print("error_output: ", low_score_words)
    return result.text, low_score_words

# run_once = True
# while run_once:
#     my_speech, inference_time, _score, audio_file = listen(audio_model)
#     if my_speech == "종료":
#         break
#     else:
#         print("inference time : ", inference_time)
#     run_once = False
