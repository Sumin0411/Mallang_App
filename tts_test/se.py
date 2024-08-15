import os
import soundfile as sf
from espnet_model_zoo.downloader import ModelDownloader
import sys
from espnet2.bin.enh_inference import SeparateSpeech

# wav 파일 읽기
mixwav_mc, sr = sf.read("./tts_test/wavs/test.wav")

tag = "espnet/Wangyou_Zhang_chime4_enh_train_enh_conv_tasnet_raw"


d = ModelDownloader()
cfg = d.download_and_unpack(tag)

separate_speech = {}
# For models downloaded from GoogleDrive, you can use the following script:
enh_model_sc = SeparateSpeech(
  train_config=cfg["train_config"],
  model_file=cfg["model_file"],
  # for segment-wise process on long speech
  normalize_segment_scale=False,
  show_progressbar=True,
  ref_channel=4,
  normalize_output_wav=True,
  device="cuda:0",
)

wave = enh_model_sc(mixwav_mc[None, ...], sr)
print(wave[0].shape)

sf.write("./tts_test/wavs/test_output.wav", wave[0][0], sr, format='WAV', endian='LITTLE', subtype='PCM_16')