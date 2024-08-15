import librosa
from fastapi import FastAPI, UploadFile, File, Form
from fastapi.responses import FileResponse
import asyncio

import soundfile as sf

from mallang_xtts import *
from mallang_whisper import *


def down_sample(y, sr, resample_sr):
    resample = librosa.resample(y, orig_sr=sr, target_sr=resample_sr)
    sf.write('./tts_test/wavs/input.wav', resample, resample_sr, format='WAV', endian='LITTLE', subtype='PCM_16')
    return resample

app = FastAPI()
print("start app")

@app.post('/tts') 
async def api(text: str = Form(...), wav: UploadFile = File(...)):
    wav_content = await wav.read()
    text = text
    with open("./wavs/input.wav", "wb") as file:
        file.write(wav_content)
    loop = asyncio.get_event_loop()
    await loop.run_in_executor(None, tts, text)

    return FileResponse("./wavs/output.wav", filename="output.wav")

@app.post('/stt') 
async def api(wav: UploadFile = File(...)):
    wav_content = await wav.read()
    with open("./stt_wavs/input.wav", "wb") as file:
        file.write(wav_content)
    loop = asyncio.get_event_loop()
    stt_out = await loop.run_in_executor(None, stt, "./stt_wavs/input.wav")
    ###########################gpt###########################
    return None