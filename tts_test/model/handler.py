# Create model object
import torch
from TTS.tts.configs.xtts_config import XttsConfig
from TTS.tts.models.xtts import Xtts
from ts.torch_handler.base_handler import BaseHandler

config = XttsConfig()
config.load_json("./model/config.json")
model = Xtts.init_from_config(config)
model.load_checkpoint(config, checkpoint_dir="./model")
model.cuda()

import torch
import torchaudio
from torch import Tensor
from torchaudio.transforms import Spectrogram


class MallangXtts(BaseHandler):
    def __init__(self):
        super(MallangXtts, self).__init__()

    # 모델 초기화
    def initialize(self, context):
        # 모델 초기화
        properties = context.system_properties
        config = XttsConfig()
        config.load_json("./config.json")
        model = Xtts.init_from_config(config)
        model_dir = properties.get("model_dir")
        model.load_checkpoint(config, checkpoint_dir=model_dir)
        model.cuda()

    # 데이터 전처리
    def preprocess(self, data):
        # 데이터에서 텍스트와 wav 파일을 추출
        text, wav_data = data['text'], data['wav']

        return text, wav_data

    # 모델 추론
    def inference(self, model, data):
        text, wav = data
        gpt_cond_latent, speaker_embedding = model.get_conditioning_latents(audio_path=[wav])

        out = model.inference(
            text,
            gpt_cond_latent=gpt_cond_latent,
            speaker_embedding=speaker_embedding,
            temperature=0.3, # Add custom parameters here
            language="ko",
            length_penalty=0.1,
            repetition_penalty=2.0,
            speed=1.0,
            enable_text_splitting=False,
            )
        return torch.tensor(out["wav"]).unsqueeze(0)

    # 데이터 후처리
    def postprocess(self, prediction):
        # 모델의 출력을 wav 파일로 변환
        torchaudio.save('output.wav', prediction, 24000)
        
        with open('output.wav', 'rb') as f:
            output_wav = f.read()

        return output_wav
