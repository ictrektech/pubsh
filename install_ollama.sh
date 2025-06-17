#!/bin/bash

# 可选代理参数
PROXY=""

# 解析参数
for arg in "$@"; do
  case $arg in
    --proxy=*)
      PROXY="${arg#*=}"
      shift
      ;;
    *)
      echo "未知参数: $arg"
      echo "用法: $0 [--proxy=http://proxy.example.com:7890]"
      exit 1
      ;;
  esac
done

# 如果设置了代理，导出环境变量
if [[ -n "$PROXY" ]]; then
  export http_proxy="$PROXY"
  export https_proxy="$PROXY"
  echo "使用代理: $PROXY"
else
  echo "未设置代理，直接安装"
fi

# 安装 Ollama
curl ${PROXY:+-x "$PROXY"} -fsSL https://ollama.com/install.sh | sh

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