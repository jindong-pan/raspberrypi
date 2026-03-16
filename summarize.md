To get the most out of `steipete/summarize` on Linux, you need to go beyond the basic installation and set up its "power features": the background **daemon**, **media extraction tools**, and your **LLM provider keys**.

Follow this guide to enable all features:

### 1. Set Up the Background Daemon

The daemon allows the CLI and the Chrome/Firefox extension to talk to each other and enables background tasks. On Linux, this is managed via `systemd`.

* **Install the Daemon:** Replace `<TOKEN>` with the token found in your browser extension's side panel (if you use it) or any secure string:
```bash
summarize daemon install --token <TOKEN>

```


* **Check Status:**
```bash
summarize daemon status

```


*Note: This creates a user-level service at `~/.config/systemd/user/summarize-daemon.service`.*

### 2. Install Media Power Tools

To summarize YouTube videos (with slides/OCR) and podcasts, you need specific local binaries.

* **For Video/Audio Extraction:** Install `yt-dlp` and `ffmpeg`.
```bash
sudo apt update && sudo apt install yt-dlp ffmpeg

```


* **For Slide/OCR Extraction:** Install `tesseract`.
```bash
sudo apt install tesseract-ocr

```



### 3. Configure Your LLM Backends

`summarize` is "model-agnostic." You can use OpenRouter (recommended for access to many models) or specific providers.

* **Set Environment Variables:** Add these to your `~/.bashrc` or `~/.zshrc`:
```bash
export OPENROUTER_API_KEY="your_key_here"
export OPENAI_API_KEY="your_key_here"
export ANTHROPIC_API_KEY="your_key_here"

```


* **Enable "Free" Models:** If you want to use the tool without paying for every request, run:
```bash
summarize refresh-free --set-default

```


This scans OpenRouter for free models and sets them as your default.

### 4. Advanced CLI Usage

Once set up, you can use powerful flags to control the output:

| Feature | Command Flag |
| --- | --- |
| **YouTube Slides** | `summarize --slides "https://youtube.com/..."` |
| **Specific Length** | `summarize --length xxl "https://..."` |
| **Specific Language** | `summarize --lang de "https://..."` (German) |
| **Local Files** | `summarize ./path/to/document.pdf` |
| **Pipe Output** | `cat logs.txt | summarize -` |

### 5. Troubleshooting (Linux Specific)

* **Permissions:** Always install as your normal user, **not as root (sudo)**, so that the configuration files are created in your home directory (`~/.summarize`).
* **Model Selection:** If the tool fails to summarize, run with `--metrics detailed` to see which model it tried to use and why it failed (e.g., "Missing API Key").
