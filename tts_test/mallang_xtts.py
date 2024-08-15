import torch
import torchaudio
from TTS.tts.configs.xtts_config import XttsConfig
from TTS.tts.models.xtts import Xtts
from huggingface_hub import snapshot_download

snapshot_download(repo_id="princesslucy/mallang_xtts_large", local_dir='./model')
config = XttsConfig()
config.load_json("./model/config.json")
model = Xtts.init_from_config(config)
model.load_checkpoint(config, checkpoint_dir="./model")
model.cuda()

def tts(text, temperature=0.3, length_penalty=0.1, repetition_penalty=2.0, speed=1.0, audio="./wavs/input.wav",):
    gpt_cond_latent, speaker_embedding = model.get_conditioning_latents(audio_path=[audio])

    out = model.inference(
    text,
    gpt_cond_latent=gpt_cond_latent,
    speaker_embedding=speaker_embedding,
    temperature=temperature, # Add custom parameters here
    language="ko",
    length_penalty=length_penalty,
    repetition_penalty=repetition_penalty,
    speed=speed,
    enable_text_splitting=False,
    )

    return torchaudio.save("./wavs/output.wav", torch.tensor(out["wav"]).unsqueeze(0), 24000)

#test

#tts("하지만 윤동주는 조선의 독립과 현대 한국인들이 그를 자국인으로 간주하는 것은 당연하다.")