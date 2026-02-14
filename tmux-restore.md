Standard `tmux` is "persistent" only as long as the computer stays powered on. If the server reboots or power cuts out, the `tmux` server process dies and your sessions vanish.

To survive a power cycle, you need the **Tmux Resurrect** plugin. It allows you to save your environment to your hard drive and reload it later.

---

### 1. Install Tmux Plugin Manager (TPM)

The easiest way to manage "save/restore" features is through TPM.

1. **Clone TPM:**
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

```


2. **Configure `~/.tmux.conf`:**
Open (or create) your config file: `nano ~/.tmux.conf`. Paste these lines at the very bottom:
```bash
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-resurrect'

# Initialize TMUX plugin manager (keep this line at the very bottom)
run '~/.tmux/plugins/tpm/tpm'

```


3. **Load the plugins:** Inside a running `tmux` session, press `Prefix` (Ctrl + b) and then `I` (capital i). This will install the Resurrect plugin.

---

### 2. How to Save and Restore

Once installed, you use two simple keyboard shortcuts:

* **To SAVE:** `Prefix` + `Ctrl + s`
*(You'll see "Saving..." in the status bar. This creates a text file in `~/.tmux/resurrect/` detailing your windows and panes.)*
* **To RESTORE:** `Prefix` + `Ctrl + r`
*(After a reboot, start a fresh `tmux` session and hit this combo. Your windows, names, and paths will snap back into place.)*

---

### 3. What actually gets "saved"?

It is important to understand the limits:

* **Saved:** All sessions, windows, pane layouts, and the **working directory** (the folder you were in).
* **Not Saved (by default):** The "history" (text scrollback) and running programs (like a script that was mid-execution).

**To save program state:**
If you want it to restart programs like `vim` or `top`, add this line to your `~/.tmux.conf`:

```bash
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @continuum-restore 'on'

```

*Note: `tmux-continuum` saves your session automatically every 15 minutes so you don't even have to remember the "Save" shortcut.*


