# Find the tmux session

```bash
tmux list-sessions
tmux list-panes -a
```

### output:
```plain text
0: 2 windows (created Sat Mar  7 18:56:24 2026)
0:0.1: [72x16] [history 1192/10000, 1535428 bytes] %2 (active)
0:0.2: [72x16] [history 189/10000, 299420 bytes] %5
0:1.1: [72x17] [history 9935/10000, 13738982 bytes] %0 (active)
0:1.2: [72x15] [history 9020/10000, 14544674 bytes] %4
```
```bash
# Capture the larger pane first (likely main picoclaw output)
tmux capture-pane -t 0:1.1 -p -S -10000 > /tmp/picoclaw-1.log
tmux capture-pane -t 0:1.2 -p -S -10000 > /tmp/picoclaw-2.log

# Check which one has picoclaw logs
head -5 /tmp/picoclaw-1.log
echo "---"
head -5 /tmp/picoclaw-2.log
```

### output:
```plain text
sonsPath); err == nil && len(data) > 0 {


ns[:800] + "... (truncated)"

---
☀️  **代托纳海滩 (Daytona Beach)** - 67°F (19°C) 多云
☀️  **坦帕 (Tampa)** - 71°F (22°C) 多云

❄️  全州气温在60-80°F之间，非常适合户外活动。早晚可能有点凉，建议带件薄外
套。]}
```
# find pt/4
```bash
# Check which pane is pts/4
tmux list-panes -a -F "#{session_name}:#{window_index}.#{pane_index} #{pane_tty}"

# Also check window 0 panes
tmux capture-pane -t 0:0.1 -p -S -100 | head -10
echo "---"
tmux capture-pane -t 0:0.2 -p -S -100 | head -10
```
