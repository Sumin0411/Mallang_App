import librosa # apt-get install ffmpeg  : linux에서 필요
from flask import Flask
from flask import request, send_file
import base64
import soundfile as sf
import base64
from mallang_xtts import *
def encode_audio(audio):
    audio_content = audio.read()
    return base64.b64encode(audio_content).decode('utf8')

def down_sample(y, sr, resample_sr):
    resample = librosa.resample(y, orig_sr=sr, target_sr=resample_sr)
    sf.write('./tts_test/wavs/input.wav', resample, resample_sr, format='WAV', endian='LITTLE', subtype='PCM_16')
    return resample


app = Flask(__name__)
print("start app")

@app.route('/tts', methods=['post']) 
def api():

    wav = request.files['wav']
    text = request.form['text']
    y, sr = librosa.load(wav, mono=True, duration=30)

    y = down_sample(y, sr, 22050)
    tts(text)

    return send_file("./wavs/output.wav", as_attachment=True)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=False)