#!/bin/bash

# 可选代理参数
PROXY=""
# 是否离线安装
OFFLINE=0

# 解析参数
for arg in "$@"; do
  case $arg in
    --proxy=*)
      PROXY="${arg#*=}"
      shift
      ;;
    --offline)
      OFFLINE=1
      shift
      ;;
    *)
      echo "未知参数: $arg"
      echo "用法: $0 [--proxy=http://proxy.example.com:7890] [--offline]"
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
  echo "未设置代理"
fi

# 安装 Ollama
if [[ "$OFFLINE" == "1" ]]; then
  echo "正在使用本地安装包安装 Ollama..."
  export OLLAMA_OFFLINE=1
  bash ollama.sh
else
  curl ${PROXY:+-x "$PROXY"} -fsSL https://ollama.com/install.sh | bash
fi

# 替换默认目录

# 处理 ~/.ollama 链接或目录
TARGET_LINK="/home/ictrek/.ollama"
REAL_DIR="/home/ictrek/workspace-docker/chatbot/ollama"

if [[ -L "$TARGET_LINK" ]]; then
  echo "$TARGET_LINK 是符号链接，正在删除链接..."
  rm "$TARGET_LINK"
elif [[ -d "$TARGET_LINK" ]]; then
  # 判断是否是链接并指向正确的目标
  if [[ "$(realpath "$TARGET_LINK")" != "$REAL_DIR" ]]; then
    echo "$TARGET_LINK 是目录，但不是指向目标目录，正在删除..."
    rm -rf "$TARGET_LINK"
  else
    echo "$TARGET_LINK 是指向目标的链接，无需修改。"
  fi
fi

# 建立新链接（如果尚未建立）
if [[ ! -L "$TARGET_LINK" ]]; then
  echo "创建符号链接: $TARGET_LINK -> $REAL_DIR"
  ln -s "$REAL_DIR" "$TARGET_LINK"
fi

# 修改 systemd 服务文件
SERVICE_FILE="/etc/systemd/system/ollama.service"
sudo sed -i 's/^User=ollama/User=ictrek/' "$SERVICE_FILE"
sudo sed -i 's/^Group=ollama/Group=ictrek/' "$SERVICE_FILE"
sudo sed -i '/^Environment="PATH=.*"/a Environment="OLLAMA_HOST=0.0.0.0:11434"' "$SERVICE_FILE"

# 重新加载并重启服务
sudo systemctl daemon-reload
sudo systemctl restart ollama
