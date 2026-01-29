#!/usr/bin/sh
# 這會顯示嘗試失敗次數最多的前 5 個 IP
sudo lastb | awk '{print $3}' | sort | uniq -c | sort -nr | head -n 5
