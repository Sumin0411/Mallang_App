import re

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

            
    return error_count, error_count/len(r), output


ref = "맑은 날, 숲속에서 토끼와 거북이가 만났습니다. 토끼는 거북이를 보고 먼저 말을 걸었어요."
stt1 = "말도 날 숲속에서 토끼와 거북이가 만났습 토끼는 허위를 보고 먼저 말을 걸었"
stt2 = "맑은 날 숲 속에서 토끼와 거북이가 만났습니다. 토끼는 거기를 보고 먼저 말을 걸었어"

print(wer(ref, stt1))

print(wer(ref, stt2))

