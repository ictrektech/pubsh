#!/bin/bash

# 脚本路径
SCRIPT_PATH="/home/ictrek/check_fastllm.sh"
LOG_FILE="/home/ictrek/fastllm_monitor.log"

# 创建监控脚本
cat << 'EOF' > "$SCRIPT_PATH"
#!/bin/bash

# 发送请求
response=$(curl -s -X GET "http://localhost:25000/session/create?kb_id=default&name=test" -H "accept: */*")

# 检查是否包含错误信息
if echo "$response" | grep -q '"msg": "Exceeded maximum connections."' ; then
    echo "$(date): Exceeded max connections, restarting fastllm-server..." >> /home/ictrek/fastllm_monitor.log
    docker restart fastllm-server
else
    echo "$(date): Server OK." >> /home/ictrek/fastllm_monitor.log
fi
EOF

# 设置权限
chmod +x "$SCRIPT_PATH"

# 确保日志文件存在
touch "$LOG_FILE"

# 添加到 crontab（如果不存在）
CRON_JOB="*/5 * * * * $SCRIPT_PATH"
( crontab -l 2>/dev/null | grep -v -F "$SCRIPT_PATH" ; echo "$CRON_JOB" ) | crontab -

echo "✅ 安装完成！脚本每 5 分钟自动检查 fastllm-server 状态。"
echo "📄 日志文件: $LOG_FILE"
