
# FastLLM

## 💼 Deployment
> 确保服务器的2222、3306、5000、5672、6379、8001、9030、9050、9200、10095、15672、22299端口空闲

### Docker及docker compose的安装
参考[这里](https://docs.docker.com/engine/install/)

### 启动服务
1. 镜像及相关文件拉取
```bash

docker pull ictrektech/fastllm:1.5
docker pull ictrektech/ollama_server:arm_latest

curl -o ~/docker-compose-fastllm.yaml https://raw.githubusercontent.com/ictrektech/pubsh/main/docker-compose-fastllm.yaml
curl -o ~/init_mysql_database.sql https://raw.githubusercontent.com/ictrektech/pubsh/main/init_mysql_database.sql
```

2. 启动FastLLM
```bash
docker compose -f ~/docker-compose-fastllm.yaml up -d
curl -L -o ~/run_llm.sh -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/ictrektech/pubsh/main/run_llm.sh && bash ~/run_llm.sh
```
