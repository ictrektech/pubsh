#!/bin/bash

# 默认值为空
PROXY=""

# 解析具名参数
for arg in "$@"; do
  case $arg in
    --proxy=*)
      PROXY="${arg#*=}"
      shift
      ;;
    *)
      echo "未知参数: $arg"
      echo "用法: $0 --proxy=http://proxy.example.com:7890"
      exit 1
      ;;
  esac
done

# 检查参数是否设置
if [[ -z "$PROXY" ]]; then
  echo "请提供 --proxy 参数"
  echo "示例: $0 --proxy=http://proxy.example.com:7890"
  exit 1
fi

# 设置代理
export http_proxy="$PROXY"
export https_proxy="$PROXY"

# 安装 Ollama
curl -x "$http_proxy" -fsSL https://ollama.com/install.sh | sh

# 替换默认目录
rm -rf /home/ictrek/.ollama
ln -s /home/ictrek/workspace-docker/chatbot/ollama /home/ictrek/.ollama

# 修改 systemd 服务文件
SERVICE_FILE="/etc/systemd/system/ollama.service"
sudo sed -i 's/^User=ollama/User=ictrek/' "$SERVICE_FILE"
sudo sed -i 's/^Group=ollama/Group=ictrek/' "$SERVICE_FILE"
sudo sed -i '/^Environment="PATH=.*"/a Environment="OLLAMA_HOST=0.0.0.0:11434"' "$SERVICE_FILE"

# 重新加载并重启服务
sudo systemctl daemon-reload
sudo systemctl restart ollama
