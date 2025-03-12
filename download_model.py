from huggingface_hub import snapshot_download
from huggingface_hub import hf_hub_download

# xgb模型
snapshot_download(
    repo_id='InfiniFlow/text_concat_xgb_v1.0',
    local_dir='./res/deepdoc',
    local_dir_use_symlinks=False,
    resume_download=True
)
# ocr模型
snapshot_download(
    repo_id='InfiniFlow/deepdoc',
    revision='3db014208e791216f0cfbce5be662e4d1f0983ac',
    local_dir='./res/deepdoc',
    local_dir_use_symlinks=False,
    resume_download=True
)
# embedding模型
snapshot_download(
    repo_id='BAAI/bge-large-zh-v1.5',
    local_dir='./res/model/bge-large-zh-v1.5',
    local_dir_use_symlinks=False,
    resume_download=True
)
# sst模型
snapshot_download(
    repo_id='ellisd/faster-whisper-large-v3-int8',
    local_dir='/home/ictrek/workspace-docker/resource/model/faster-whisper-large-v3-int8',
    local_dir_use_symlinks=False,
    resume_download=True
)
# 搜图模型
snapshot_download(
    repo_id='Marqo/marqo-fashionSigLIP',
    local_dir='./res/model/marqo-fashionSigLIP',
    local_dir_use_symlinks=False,
    resume_download=True
)
# tts模型
snapshot_download(
    repo_id='csukuangfj/vits-melo-tts-zh_en',
    local_dir='./res/model/tts/vits-melo-tts-zh_en',
    local_dir_use_symlinks=False,
    resume_download=True
)
