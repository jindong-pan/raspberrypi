Ouch, 99% usage? You’re definitely living on the edge! When a Linux partition hits that level, things can start acting glitchy because the system doesn't have enough "scratch space" to perform basic tasks.

Since your root partition (`/`) is the one that's full, we need to target the usual suspects: cached package files, old kernels, and massive log files.

Here is a step-by-step triage to get some breathing room.

---

### 1. Clean up the Package Manager

Every time you update or install software, Ubuntu (or your Debian-based distro) keeps a copy of the `.deb` files. This is usually the quickest win.

* **Remove outdated packages:**
`sudo apt-get autoremove`
* **Clear the archive cache:**
`sudo apt-get clean`

### 2. Shrink System Logs

System logs (`journald`) can grow indefinitely if not capped. You can safely vacuum these to keep only the most recent data.

* **Check how much space logs are taking:**
`journalctl --disk-usage`
* **Reduce logs to the last 100MB:**
`sudo journalctl --vacuum-size=100M`

### 3. Find the "Space Hogs"

If the steps above didn't save enough space, we need to find out exactly which folder is the culprit. Run this command to see the top 10 largest directories starting from root:

`sudo du -ah / | sort -rh | head -n 10`

> **Note:** You might see a lot of "Permission denied" errors for certain system folders; that’s normal. Look for large numbers in folders like `/var/log`, `/var/lib/snapd`, or your own `/home` directory.

### 4. Manage Snap Packages (If applicable)

If you use Snaps, Linux keeps old versions of every app you've updated. You can remove the disabled ones with this one-liner:

```bash
set -eu
snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        sudo snap remove "$snapname" --revision="$revision"
    done

```

---

### A Quick Reality Check

Your partition is **25GB**. While Linux is efficient, 25GB for a modern desktop installation is quite tight once you add a few apps, browser caches, and personal files.

**Would you like me to show you how to identify and delete large files specifically within your Downloads or Cache folders to free up more space?**
