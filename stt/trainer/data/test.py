import numpy as np
import json

# JSON 파일 경로 설정
file_path = "C:\\flyai\\stt_test\\stt\\data\\0.json"  # 실제 파일 경로로 바꿔주세요

# JSON 파일 불러오기
with open(file_path, 'r', encoding='utf-8') as file:
    data = json.load(file)

# 2.wav부터 5000.wav까지의 path 생성 및 딕셔너리 업데이트
for i in range(2, 5001):
    new_path = f"{i}.wav"
    new_dict = data.copy()
    new_dict["audio"]["path"] = new_path
    
with open(file_path, 'w', encoding='utf-8') as file:
    json.dump(new_dict, file, ensure_ascii=False, indent=4)