#!/bin/bash
WEBHOOK_URL="https://discord.com/api/webhooks/1467242285291802706/BvD7vpp1Sem1EY3eQojMe3edireFckkRHpVUZUOff2AvK34V9tiWbO5HdY5BOM0ZJDxE"

while true; do
  NOW=$(date)
  echo "--- Connection at $NOW ---" >> /home/$(whoami)/intruder_log.txt
  
  # Capture connection info and send alert
  # This waits for a connection, then moves to the next line
  nc -v -l -p 2222 2>&1 | tee -a /home/$(whoami)/intruder_log.txt
  
  curl -X POST -H "Content-Type: application/json" \
  -d "{\"content\": \"⚠️ **Honeypot Alert!** Someone accessed port 22/2222 at $NOW\"}" \
  $WEBHOOK_URL
done
