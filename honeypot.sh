#!/usr/bin/sh
#!/bin/bash
while true; do
  echo "--- Connection at $(date) ---" >> /home/$(whoami)/intruder_log.txt
  # Use -v to see the attacker's IP and 2>&1 to capture those details
  nc -v -l -p 2222 2>&1 >> /home/$(whoami)/intruder_log.txt
done
