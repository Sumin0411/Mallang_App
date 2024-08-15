import requests
import json

file = './tts_test/wavs/a1.wav'
raw = open(file, 'rb')
files = {'wav': raw}
data = {'text': '죽는 날까지 하늘을 우러러 한 점 부끄럼이 없기를,잎새에 이는 바람에도'}
res = requests.post('http://221.163.126.230:8501/tts', files=files, data = data)
with open(f'./tts_test/client_wavs/output.wav', 'wb') as file:
    file.write(res.content)