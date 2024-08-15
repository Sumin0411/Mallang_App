from whisper_mic import *
import librosa
from flask import Flask
from flask import request
import base64
import io
import soundfile as sf
import base64

audio_model = whisper.load_model("base").to("cuda")

def encode_audio(audio):
    audio_content = audio.read()
    return base64.b64encode(audio_content)


def down_sample(y, sr, resample_sr):
    resample = librosa.resample(y, orig_sr=sr, target_sr=resample_sr)
    sf.write('./' + 'temp.wav', resample, resample_sr, format='WAV', endian='LITTLE', subtype='PCM_16')
    return resample

app = Flask(__name__)
print("start app")

@app.route('/stt', methods=['post']) 
def api():
    d = request.get_json()
    file = d['file']
    text = d['text']
    bytes = base64.b64decode(file) 
    bytesIO = io.BytesIO(bytes)
    y, sr = librosa.load(bytesIO, mono=True, duration=30)

    y = down_sample(y, sr, 24000)
    
    my_speech, detail = get_score("temp.wav")
    _, score, error_word = wer(my_speech, text)

    return {"sst":my_speech, "detail":detail, "score":score, "error_word": error_word}

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=False)