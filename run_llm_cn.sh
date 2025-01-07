#!/bin/bash

# 下载 YAML 配置文件
CONFIG_FILE=~/dc_llm.yml
# URL="https://raw.githubusercontent.com/ictrektech/pubsh/main/dc_ollama_arm.yaml"
URL="https://gitee.com/jach4/pubsh/raw/main/dc_ollama_arm_cn.yaml"

# 下载 YAML 文件
curl -L -o "$CONFIG_FILE" -H 'Cache-Control: no-cache' "$URL"
if [ $? -ne 0 ]; then
    echo "下载配置文件失败！"
    exit 1
fi

# 检查 docker-compose 命令兼容性
if command -v docker compose &> /dev/null; then
    CMD="docker compose"
elif command -v docker-compose &> /dev/null; then
    CMD="docker-compose"
else
    echo "未检测到 docker compose 或 docker-compose 命令！"
    exit 1
fi

# 启动容器
$CMD -f "$CONFIG_FILE" up -d
if [ $? -ne 0 ]; then
    echo "容器启动失败！"
    exit 1
fi

# 等待容器准备就绪
echo "等待容器启动完成..."
sleep 10

# 动态读取容器名称
CONTAINER_NAME=$(grep 'container_name:' "$CONFIG_FILE" | awk '{print $2}')
if [ -z "$CONTAINER_NAME" ]; then
    echo "无法从 YAML 文件中读取容器名称！"
    exit 1
fi
echo "读取到容器名称：$CONTAINER_NAME"

# 拉取模型文件
for MODEL in huluxiaohuowa/qwen7b:32k huluxiaohuowa/qwen1.5b:32k huluxiaohuowa/cpmv:32k
do
    docker exec -it "$CONTAINER_NAME" ollama pull "$MODEL"
    if [ $? -ne 0 ]; then
        echo "拉取模型 $MODEL 失败！"
        exit 1
    fi
done

echo "所有操作完成！"