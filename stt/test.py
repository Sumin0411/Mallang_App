import requests
import base64
import winsound

#보내고자하는 파일을 'rb'(바이너리 리드)방식 열고
def encode_audio(audio):
    audio_content = audio.read()
    return base64.b64encode(audio_content).decode('utf8')

files = open('C:\\flyai\\mallang\\stt\\test.wav', 'rb')

# 파이썬 딕셔너리 형식으로 file 설정
# request.post방식으로 파일전송.
raw = encode_audio(files)
# res = requests.post('http://127.0.0.1:8000/account/update', json = {"id":"aaaa", "name":"김차차돌", "age":6, "gender":"m"})
# res = requests.get('http://172.23.245.219:8000/account/get/aaaa')
# print(res.json())

res = requests.post('http://172.23.252.237:5000/stt', json = {"file":raw,"text":"4번 선수가 볼을 잡고 있으면 어쨌든 똥 좋은 땅 볼을 지켜내는 능력이 좋습니다."}).json()
print(res)