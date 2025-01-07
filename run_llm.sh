#!/bin/bash

# 下载 YAML 配置文件
CONFIG_FILE=~/dc_llm.yml
URL="https://raw.githubusercontent.com/ictrektech/pubsh/main/dc_ollama_arm.yaml"

# 检查文件是否存在并询问是否覆盖
if [ -f "$CONFIG_FILE" ]; then
    read -p "配置文件已存在，是否覆盖？(y/n): " choice
    if [[ $choice != "y" ]]; then
        echo "取消操作"
        exit 1
    fi
fi

# 下载 YAML 文件
curl -o "$CONFIG_FILE" "$URL"
if [ $? -ne 0 ]; then
    echo "下载配置文件失败！"
    exit 1
fi

# 检查 docker-compose 命令兼容性
DOCKER_COMPOSE_CMD=$(command -v docker-compose || command -v docker compose)
if [ -z "$DOCKER_COMPOSE_CMD" ]; then
    echo "docker-compose 未安装！"
    exit 1
fi

# 启动容器
$DOCKER_COMPOSE_CMD -f "$CONFIG_FILE" up -d
if [ $? -ne 0 ]; then
    echo "容器启动失败！"
    exit 1
fi

# 等待容器准备就绪
echo "等待容器启动完成..."
sleep 10

# 拉取模型文件
CONTAINER_NAME="ollama"

for MODEL in huluxiaohuowa/qwen7b:32k huluxiaohuowa/qwen1.5b:32k huluxiaohuowa/cpmv:32k
do
    docker exec -it "$CONTAINER_NAME" ollama pull "$MODEL"
    if [ $? -ne 0 ]; then
        echo "拉取模型 $MODEL 失败！"
        exit 1
    fi
done

echo "所有操作完成！"
