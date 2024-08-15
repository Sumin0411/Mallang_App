python 3.10.7 환경에서 개발되었습니다.

server/server.py == 추론서버 실행 파일
client/client.py == 서버에 음성파일을 보내는 클라이언트 실행파일

https://huggingface.co/kimbori/RVC_E1I4/tree/main

1. 위 허깅페이스 링크에서 RVCsubfiles를 다운로드 한 뒤 내용물을 server 폴더 안에 그대로 넣는다.

2. server.py 환경설정
		- requirements.txt 설치 (pip install -r requirements.txt)
			- 만약 fairseq 모듈 설치 간 오류 발생 시 server폴더 안에 vs_BuildTools.exe 실행시켜 설치 이후 재부팅
			- 설치해도 안된다면 visual studio 2022도 설치 이후 재부팅

3. server.py 실행(python server.py)
		- 만약 그래픽 카드를 못잡는다면 server폴더 안에 cuda_12.3.2_windows_network 설치 파일 실행하여 설치
		- 이후 https://pytorch.org/ 에서 사용환경에 맞는 pytorch 설치
		- 이후 재부팅
		- gpu가 16 혹은 10 이라면 VoiceConversion.py 의 전역변수 is_half를 True에서 False로 변경한다.(반대로 20,30,40 등이라면 True로 설정한다.)

4. client.py 실행
	id 에 변환하려는 음성의 주인 이름(ex. 본인)
	gender 변수에는 본인 성별(남자는 1, 여자는 0)
	age 변수에는 본인 나이
	characterId 에는 목소리를 변환하고 싶은 character model 이름을 넣는다.
	변환하고 싶은 음성이 담긴 wav 경로를 입력하고
	client.py를 실행시킨다.(python client.py)

	client/result/ 경로에 변환 결과물이 생긴다.
