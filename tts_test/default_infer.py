from TTS.api import TTS
tts = TTS("tts_models/multilingual/multi-dataset/xtts_v2", gpu=True)

# generate speech by cloning a voice using default settings
tts.tts_to_file(text="이것은 기존 모델의 테스트 음성입니다.",
                file_path="./wavs/before.wav",
                speaker_wav=["./wavs/a1.wav"],
                language="ko",
                split_sentences=True
                )